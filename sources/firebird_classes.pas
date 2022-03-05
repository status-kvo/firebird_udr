unit firebird_classes;

{$I .\sources\general.inc}

interface

{$IFDEF NODEF}{$REGION 'uses'}{$ENDIF}

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF MSWINDOWS}
  SysUtils,
  Classes,
  Generics.Collections,
{$IFDEF UDRLOG}udr_log, {$ENDIF UDRLOG}
  firebird_api,
  firebird_types,
  firebird_factories,
  firebird_factories_base,
  firebird_message_metadata,
  firebird_message_data;
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}

type
  TObjectDestroy = class abstract(TIn0Instance<TObject>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TObjectCreator<TInstance: class, constructor> = class abstract(TOutInstance<TInstance>)
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

implementation

{ TObjectDestroy }

function TObjectDestroy.doExecute(const AParams: RExecuteParams): Boolean;
begin
  inherited;
  RLibraryHeapManager.Remove(FInstanceIn);
  FInstanceIn.Destroy;
  Result := True;
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
  FList := TObjectList.Create
end;

class procedure RLibraryHeapManager.Finalize;
begin
  ClearAll;
end;

class procedure RLibraryHeapManager.Add(AObject: TObject; AParent: TObject);
var
  Info: RHeapObjectInfo;
begin
  TMonitor.Enter(FList);
  try
    if FList.TryGetValue(AObject, Info) then
      Info.FParent := AParent
    else
      Info := RHeapObjectInfo.Create(TThread.CurrentThread.ThreadID, AParent);
    FList.AddOrSetValue(AObject, Info);
{$IFDEF UDRLOG}TUdrLog.Default.Action(AObject, False); {$ENDIF UDRLOG}
  finally
    TMonitor.Exit(FList)
  end
end;

class procedure RLibraryHeapManager.Remove(AObject: TObject);
begin
  TMonitor.Enter(FList);
  try
    FList.Remove(AObject);
{$IFDEF UDRLOG}TUdrLog.Default.Action(AObject, True); {$ENDIF UDRLOG}
  finally
    TMonitor.Exit(FList)
  end
end;

class procedure RLibraryHeapManager.ClearAll;
begin
  try
    TMonitor.Enter(FList);
    try
      for var Key in FList.Keys do
        try
          Key.Free;
        except
        end;
      FList.Clear
    finally
      TMonitor.Exit(FList)
    end;
  finally
    FList.Destroy;
  end;
end;

class procedure RLibraryHeapManager.ClearDependentFromParent(AParent: TObject);
var
  Pairs       : TArray<TPair<TObject, RHeapObjectInfo>>;
  ThreadID    : NativeUInt;
  ListIsDestoy: TList<TObject>;
begin
  TMonitor.Enter(FList);
  try
    ListIsDestoy := TList<TObject>.Create;
    try
      ThreadID := TThread.CurrentThread.ThreadID;
      Pairs := FList.ToArray;
      for var Pair in Pairs do
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
    TMonitor.Exit(FList)
  end
end;

{ TUdrRegisterGeneral }

class procedure TUdrRegisterGeneral.Register(AStatus: IStatus; AUdrPlugin: IUdrPlugin);
begin
  AUdrPlugin.registerFunction(AStatus, 'Destroy', TObjectDestroy.Create);
end;

{ TObjectCreator<TInstance> }

function TObjectCreator<TInstance>.doExecute(const AParams: RExecuteParams): Boolean;
var
  Instance: TInstance;
  Obj     : TObject absolute Instance;
begin
  Instance := TInstance.Create;
  RLibraryHeapManager.Add(Obj, Self);
  AParams.FOutput.MessageData[0].AsObject := Obj;
  Result := True
end;

{ RHeapObjectInfo }

constructor RHeapObjectInfo.Create(AThread: NativeUInt; AParent: TObject);
begin
  FThread := AThread;
  FParent := AParent
end;

initialization

RLibraryHeapManager.Initialize;

finalization

RLibraryHeapManager.Finalize

end.
