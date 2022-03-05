unit firebird_factories_base;

{$I .\sources\general.inc}

interface

uses
  firebird_types,
  firebird_message_data,
  firebird_factories;

type
  TOutInstance<TInstanceOut: class> = class abstract(TFactoryFunctionUniversal)
  protected
    procedure doSetup(const ASetup: RSetupParams); override;
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  private
    function OutGet: TInstanceOut;
    procedure OutSet(ANew: TInstanceOut);
  protected
    FOutput: TMessagesData.RMessage;
  public
    property Output: TInstanceOut read OutGet write OutSet;
  end;

type
  TOutInstance<TIn0; TInstanceOut: class> = class abstract(TOutInstance<TInstanceOut>)
  protected
    function TypeIn0Get: ESqlType; virtual;
    procedure doSetup(const ASetup: RSetupParams); override;
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  protected
    FIn0: TMessagesData.RMessage;
  end;

type
  TIn0Instance<TInstance: class> = class abstract(TFactoryFunctionUniversal)
  protected
    FInstanceIn: TInstance;
    procedure doSetup(const ASetup: RSetupParams); override;
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TInOutInstance<TIn: class; TOut: class> = class abstract(TIn0Instance<TIn>)
  protected
    procedure doSetup(const ASetup: RSetupParams); override;
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  private
    function OutGet: TOut;
    procedure OutSet(ANew: TOut);
  protected
    FOutput: TMessagesData.RMessage;
  public
    property &Output: TOut read OutGet write OutSet;
  end;

type
  TIn0Instance<TInstance: class; TOut> = class abstract(TIn0Instance<TInstance>)
  protected
    function TypeOutGet: ESqlType; virtual;
    procedure doSetup(const ASetup: RSetupParams); override;
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  protected
    FOutput: TMessagesData.RMessage;
  end;

type
  TIn0Instance<TInstance: class; TIn1; TOut> = class abstract(TIn0Instance<TInstance, TOut>)
  protected
    function TypeIn1Get: ESqlType; virtual;
    procedure doSetup(const ASetup: RSetupParams); override;
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  protected
    FIn1: TMessagesData.RMessage;
  end;

type
  TIn0Instance<TInstance: class; TIn1, TIn2, TOut> = class abstract(TIn0Instance<TInstance, TIn1, TOut>)
  protected
    function TypeIn2Get: ESqlType; virtual;
    procedure doSetup(const ASetup: RSetupParams); override;
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  protected
    FIn2: TMessagesData.RMessage;
  end;

implementation

{ TOutInstance<TInstanceOut> }

function TOutInstance<TInstanceOut>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  FOutput := AParams.FOutput.MessageData[0];
  Result := False
end;

procedure TOutInstance<TInstanceOut>.doSetup(const ASetup: RSetupParams);
begin
  inherited;
  if SizeOf(IntPtr) = 8 then
    ASetup.FOutput.setType(ASetup.FStatus, 0, Cardinal(SQL_INT64) + 1)
  else
    ASetup.FOutput.setType(ASetup.FStatus, 0, Cardinal(SQL_LONG) + 1)
end;

function TOutInstance<TInstanceOut>.OutGet: TInstanceOut;
begin
  Result := TInstanceOut(FOutput.AsObject)
end;

procedure TOutInstance<TInstanceOut>.OutSet(ANew: TInstanceOut);
begin
  FOutput.AsObject := ANew
end;

{ TIn0Instance<TInstance> }

function TIn0Instance<TInstance>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  FInstanceIn := TInstance(AParams.FInput.MessageData[0].AsObject);
  Result := False
end;

procedure TIn0Instance<TInstance>.doSetup(const ASetup: RSetupParams);
begin
  inherited;
  if SizeOf(IntPtr) = 8 then
    ASetup.FInput.setType(ASetup.FStatus, 0, Cardinal(SQL_INT64) + 1)
  else
    ASetup.FInput.setType(ASetup.FStatus, 0, Cardinal(SQL_LONG) + 1)
end;

{ TInOutInstance<TIn, TOut> }

function TInOutInstance<TIn, TOut>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  inherited;
  FOutput := AParams.FOutput.MessageData[0];
  Result := False
end;

procedure TInOutInstance<TIn, TOut>.doSetup(const ASetup: RSetupParams);
begin
  inherited;
  if SizeOf(IntPtr) = 8 then
    ASetup.FOutput.setType(ASetup.FStatus, 0, Cardinal(SQL_INT64) + 1)
  else
    ASetup.FOutput.setType(ASetup.FStatus, 0, Cardinal(SQL_LONG) + 1);
end;

function TInOutInstance<TIn, TOut>.OutGet: TOut;
begin
  Result := TOut(FOutput.AsObject)
end;

procedure TInOutInstance<TIn, TOut>.OutSet(ANew: TOut);
begin
  FOutput.AsObject := ANew
end;

{ TIn0InstanceOutCustom<TInstance> }

function TIn0Instance<TInstance, TOut>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  Result := inherited;
  FOutput := AParams.FOutput.MessageData[0];
end;

procedure TIn0Instance<TInstance, TOut>.doSetup(const ASetup: RSetupParams);
begin
  inherited;
  ParamSet(ASetup.FStatus, ASetup.FOutput, 0, TypeOutGet);
end;

function TIn0Instance<TInstance, TOut>.TypeOutGet: ESqlType;
begin
  Result := TypeToSqlType(TypeInfo(TOut))
end;

{ TIn0InstanceIn1CustomOutCustom<TInstance, TIn1, TValue> }

function TIn0Instance<TInstance, TIn1, TOut>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  Result := inherited;
  FIn1 := AParams.FInput.MessageData[1];
end;

procedure TIn0Instance<TInstance, TIn1, TOut>.doSetup(const ASetup: RSetupParams);
begin
  inherited;
  ParamSet(ASetup.FStatus, ASetup.FInput, 1, TypeIn1Get);
end;

function TIn0Instance<TInstance, TIn1, TOut>.TypeIn1Get: ESqlType;
begin
  Result := TypeToSqlType(TypeInfo(TIn1))
end;

{ TOutInstance<TIn0, TInstanceOut> }

function TOutInstance<TIn0, TInstanceOut>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  Result := inherited;
  FIn0 := AParams.FInput.MessageData[0];
end;

procedure TOutInstance<TIn0, TInstanceOut>.doSetup(const ASetup: RSetupParams);
begin
  inherited;
  ParamSet(ASetup.FStatus, ASetup.FInput, 0, TypeIn0Get);
end;

function TOutInstance<TIn0, TInstanceOut>.TypeIn0Get: ESqlType;
begin
  Result := TypeToSqlType(TypeInfo(TIn0))
end;

{ TIn0InstanceOutCustom<TInstance, TIn1, TIn2, TOut> }

function TIn0Instance<TInstance, TIn1, TIn2, TOut>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  Result := inherited;
  FIn2 := AParams.FInput.MessageData[2]
end;

procedure TIn0Instance<TInstance, TIn1, TIn2, TOut>.doSetup(const ASetup: RSetupParams);
begin
  inherited;
  ParamSet(ASetup.FStatus, ASetup.FInput, 2, TypeIn2Get)
end;

function TIn0Instance<TInstance, TIn1, TIn2, TOut>.TypeIn2Get: ESqlType;
begin
  Result := TypeToSqlType(TypeInfo(TIn2))
end;

end.
