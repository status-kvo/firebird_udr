unit firebird_classes;

{$I general.inc}

interface

{$IFDEF NODEF}{$REGION 'uses'}{$ENDIF}

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF MSWINDOWS}
  SysUtils,
  Classes,
  Generics.Collections,
  SyncObjs,
{$IFDEF UDRLOG}udr_log, {$ENDIF UDRLOG}
  firebird_api,
  firebird_types,
  firebird_factories,
  firebird_factories_base,
  firebird_message_metadata,
  firebird_message_data;
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}

type
  TObjectDestroy = class sealed(TFunctionIn0Instance<TObject>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TObjectCreator<TInstance: class, constructor> = class abstract(TFunctionOutInstance<TInstance>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  RLogical<T> = record
    class function IIF(const ACondition: Boolean; const ALeft, ARight: T): T; static; inline;
  end;

  RLogicalString = RLogical<string>;

type
  RHeapObjectInfo = record
    FThread: NativeUInt;
    FParent: TObject;
  public
    constructor Create(AThread: NativeUInt; AParent: TObject);
  end;

type
  RLibraryHeapManager = record
  private type
    TObjectList = TDictionary<TObject, RHeapObjectInfo>;
  private
    class var FList: TObjectList;
    class var FCS: TCriticalSection;
  private
    class procedure Initialize; static;
    class procedure Finalize; static;
  public
    class procedure Add(AObject: TObject; AParent: TObject); static;
    class procedure Remove(AObject: TObject); static;
    class procedure ClearAll; static;
    class procedure ClearDependentFromParent(AParent: TObject); static;
  end;

type
  TUdrRegisterGeneral = record
    class procedure &Register(AStatus: IStatus; AUdrPlugin: IUdrPlugin); static;
  end;

{$IFDEF  UDR_HAS_XML}
type
  TAdapter<TChild: IInterface> = class abstract
  protected
    FChild: TChild;
    procedure DoCreate; virtual;
  public
    property Child: TChild read FChild;
  public
    constructor Create(AChild: TChild); reintroduce;
    destructor Destroy; override;
  end;
{$ENDIF  UDR_HAS_XML}

procedure ReferenceCountedFreeAndNil(var AInstance: IReferenceCounted); inline;
procedure ReferenceCountedFree(AInstance: IReferenceCounted);inline;

implementation

procedure ReferenceCountedFree(AInstance: IReferenceCounted);
begin
  if AInstance <> nil then
    AInstance.release;
end;

procedure ReferenceCountedFreeAndNil(var AInstance: IReferenceCounted);
begin
  ReferenceCountedFree(AInstance);
  AInstance := nil
end;

{ TObjectDestroy }

function TObjectDestroy.doExecute(const AParams: RExecuteParams): Boolean;
begin
  inherited;
  Result := False;
  if (FInstanceIn <> nil) then
  begin
    RLibraryHeapManager.Remove(FInstanceIn);
    FInstanceIn.Free;
    Result := True;
  end;
  AParams.FOutput.MessageData[0].AsBoolean := Result
end;

{ RLogical<T> }

class function RLogical<T>.IIF(const ACondition: Boolean; const ALeft, ARight: T): T;
begin
  if ACondition then
    Result := ALeft
  else
    Result := ARight
end;

{ RLibraryHeapManager }

class procedure RLibraryHeapManager.Initialize;
begin
  FList := TObjectList.Create;
  FCS:= TCriticalSection.Create;
end;

class procedure RLibraryHeapManager.Finalize;
begin
  try
    ClearAll;
  finally
    FList.Free;
    FCS.Free;
  end;
end;

class procedure RLibraryHeapManager.Add(AObject: TObject; AParent: TObject);
var
  Info: RHeapObjectInfo;
begin
  FCS.Enter;
  try
    if FList.TryGetValue(AObject, Info) then
      Info.FParent := AParent
    else
      Info := RHeapObjectInfo.Create(TThread.CurrentThread.ThreadID, AParent);
    FList.AddOrSetValue(AObject, Info);
{$IFDEF UDRLOG}TUdrLog.Default.Action(AObject, False); {$ENDIF UDRLOG}
  finally
    FCS.Leave;
  end
end;

class procedure RLibraryHeapManager.Remove(AObject: TObject);
begin
  FCS.Enter;
  try
    FList.Remove(AObject);
{$IFDEF UDRLOG}TUdrLog.Default.Action(AObject, True); {$ENDIF UDRLOG}
  finally
    FCS.Leave
  end
end;

class procedure RLibraryHeapManager.ClearAll;
var
  Key: TObject;
begin
  FCS.Enter;
  try
    for Key in FList.Keys do
      try
        Key.Free;
      except
      end;
    FList.Clear
  finally
    FCS.Leave
  end;
end;

class procedure RLibraryHeapManager.ClearDependentFromParent(AParent: TObject);
var
  Pairs       : TArray<TPair<TObject, RHeapObjectInfo>>;
  Pair        : TPair<TObject, RHeapObjectInfo>;
  ThreadID    : NativeUInt;
  ListIsDestoy: TList<TObject>;
begin
  FCS.Enter;
  try
    ListIsDestoy := TList<TObject>.Create;
    try
      ThreadID := TThread.CurrentThread.ThreadID;
      Pairs := FList.ToArray;
      for Pair in Pairs do
        if (assigned(AParent) and (Pair.Value.FParent = AParent)) or ((not assigned(AParent)) and (Pair.Value.FThread = ThreadID)) then
        begin
{$IFDEF UDRLOG}TUdrLog.Default.Action(Pair.Key, True); {$ENDIF UDRLOG}
          FList.Remove(Pair.Key);
          try
            if not ListIsDestoy.Contains(Pair.Key) then
            begin
              ListIsDestoy.Add(Pair.Key);
              Pair.Key.Destroy
            end;
          except
          end;
        end;
    finally
      ListIsDestoy.Destroy
    end;
  finally
    FList.Capacity := FList.Count;
    FCS.Leave
  end
end;

{ TUdrRegisterGeneral }

class procedure TUdrRegisterGeneral.Register(AStatus: IStatus; AUdrPlugin: IUdrPlugin);
begin
  AUdrPlugin.registerFunction(AStatus, 'Destroy', TObjectDestroy.Factory);
end;

{ TObjectCreator<TInstance> }

function TObjectCreator<TInstance>.doExecute(const AParams: RExecuteParams): Boolean;
 var
  LNew: TInstance;
  LObj: TObject absolute LNew;
begin
  LNew := TInstance.Create;
  RLibraryHeapManager.Add(LObj, Self);
  AParams.FOutput.MessageData[0].AsObject := LObj;
  Result := True
end;

{ RHeapObjectInfo }

constructor RHeapObjectInfo.Create(AThread: NativeUInt; AParent: TObject);
begin
  FThread := AThread;
  FParent := AParent
end;

{$IFDEF  UDR_HAS_XML}

{ TAdapter<TChild> }

constructor TAdapter<TChild>.Create(AChild: TChild);
begin
  inherited Create;
  FChild := AChild;
  DoCreate
end;

destructor TAdapter<TChild>.Destroy;
begin
  FChild := nil;
  inherited;
end;

procedure TAdapter<TChild>.DoCreate;
begin
  // virtual
end;

{$ENDIF  UDR_HAS_XML}

initialization

RLibraryHeapManager.Initialize;

finalization

RLibraryHeapManager.Finalize

end.
