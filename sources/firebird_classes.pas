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
  TUdrRegisterGeneral = record
    class procedure &Register(AStatus: IStatus; AUdrPlugin: IUdrPlugin); static;
  end;

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
  FInstances.Add(TAdapterClass.Create(Self, LObj));
  AParams.FOutput.MessageData[0].AsObject := LObj;
  Result := True
end;

end.
