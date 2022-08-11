unit firebird_factories_base;

{$I general.inc}

interface

uses
  firebird_types,
  firebird_message_data,
  firebird_factories;

type
  TFunctionOutInstance<TInstanceOut: class> = class abstract(TFunction)
  protected
    FOutput: TMessagesData.RMessage;
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  protected
    class procedure doSetup(const ASetup: RSetupParams); override;
  end;

type
  TFunctionOutInstance<TIn0; TInstanceOut: class> = class abstract(TFunctionOutInstance<TInstanceOut>)
  protected
    FIn0: TMessagesData.RMessage;
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  protected
    class function TypeIn0Get: ESqlType; virtual;
    class procedure doSetup(const ASetup: RSetupParams); override;
  end;

type
  TFunctionIn0Instance<TInstance: class> = class abstract(TFunction)
  protected
    FInstanceIn: TInstance;
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  protected
    class procedure doSetup(const ASetup: RSetupParams); override;
  end;

type
  TFunctionInOutInstance<TIn: class; TOut: class> = class abstract(TFunctionIn0Instance<TIn>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  protected
    class procedure doSetup(const ASetup: RSetupParams); override;
  private
    function OutGet: TOut;
    procedure OutSet(ANew: TOut);
  protected
    FOutput: TMessagesData.RMessage;
  public
    property &Output: TOut read OutGet write OutSet;
  end;

type
  TFunctionIn0Instance<TInstance: class; TOut> = class abstract(TFunctionIn0Instance<TInstance>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  protected
    class function TypeOutGet: ESqlType; virtual;
    class procedure doSetup(const ASetup: RSetupParams); override;
  protected
    FOutput: TMessagesData.RMessage;
  end;

type
  TFunctionIn0Instance<TInstance: class; TIn1; TOut> = class abstract(TFunctionIn0Instance<TInstance, TOut>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  protected
    class function TypeIn1Get: ESqlType; virtual;
    class procedure doSetup(const ASetup: RSetupParams); override;
  protected
    FIn1: TMessagesData.RMessage;
  end;

implementation

{ TFunctionIn0Instance<TInstance> }

class procedure TFunctionIn0Instance<TInstance>.doSetup(const ASetup: RSetupParams);
begin
  inherited;
  if SizeOf(IntPtr) = 8 then
    ASetup.FInput.setType(ASetup.FStatus, 0, Cardinal(SQL_INT64) + 1)
  else
    ASetup.FInput.setType(ASetup.FStatus, 0, Cardinal(SQL_LONG) + 1)
end;

{ TFunctionInOutInstance<TIn, TOut>s }

function TFunctionInOutInstance<TIn, TOut>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  inherited;
  FOutput := AParams.FOutput.MessageData[0];
  Result := False
end;

class procedure TFunctionInOutInstance<TIn, TOut>.doSetup(const ASetup: RSetupParams);
begin
  inherited;
  if SizeOf(IntPtr) = 8 then
    ASetup.FOutput.setType(ASetup.FStatus, 0, Cardinal(SQL_INT64) + 1)
  else
    ASetup.FOutput.setType(ASetup.FStatus, 0, Cardinal(SQL_LONG) + 1);
end;

function TFunctionInOutInstance<TIn, TOut>.OutGet: TOut;
begin
  Result := TOut(FOutput.AsObject)
end;

procedure TFunctionInOutInstance<TIn, TOut>.OutSet(ANew: TOut);
begin
  FOutput.AsObject := ANew
end;

{ TFunctionIn0Instance<TInstance, TOut> }

function TFunctionIn0Instance<TInstance, TOut>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  Result := inherited;
  FOutput := AParams.FOutput.MessageData[0];
end;

class procedure TFunctionIn0Instance<TInstance, TOut>.doSetup(const ASetup: RSetupParams);
begin
  inherited;
  ParamSet(ASetup.FStatus, ASetup.FOutput, 0, TypeOutGet);
end;

class function TFunctionIn0Instance<TInstance, TOut>.TypeOutGet: ESqlType;
begin
  Result := TypeToSqlType(TypeInfo(TOut))
end;

{ TFunctionIn0Instance<TInstance, TIn1, TOut> }

function TFunctionIn0Instance<TInstance, TIn1, TOut>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  Result := inherited;
  FIn1 := AParams.FInput.MessageData[1];
end;

class procedure TFunctionIn0Instance<TInstance, TIn1, TOut>.doSetup(const ASetup: RSetupParams);
begin
  inherited;
  ParamSet(ASetup.FStatus, ASetup.FInput, 1, TypeIn1Get);
end;

class function TFunctionIn0Instance<TInstance, TIn1, TOut>.TypeIn1Get: ESqlType;
begin
  Result := TypeToSqlType(TypeInfo(TIn1))
end;

{ TFunctionOutInstance<TInstanceOut> }

function TFunctionOutInstance<TInstanceOut>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  FOutput := AParams.FOutput.MessageData[0];
  Result := False
end;

class procedure TFunctionOutInstance<TInstanceOut>.doSetup(const ASetup: RSetupParams);
begin
  inherited;
  if SizeOf(IntPtr) = 8 then
    ASetup.FOutput.setType(ASetup.FStatus, 0, Cardinal(SQL_INT64) + 1)
  else
    ASetup.FOutput.setType(ASetup.FStatus, 0, Cardinal(SQL_LONG) + 1)
end;

{ TFunctionOutInstance<TIn0, TInstanceOut> }

function TFunctionOutInstance<TIn0, TInstanceOut>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  Result := inherited;
  FIn0 := AParams.FInput.MessageData[0];
end;

class procedure TFunctionOutInstance<TIn0, TInstanceOut>.doSetup(const ASetup: RSetupParams);
begin
  inherited;
  ParamSet(ASetup.FStatus, ASetup.FInput, 0, TypeIn0Get);
end;

class function TFunctionOutInstance<TIn0, TInstanceOut>.TypeIn0Get: ESqlType;
begin
  Result := TypeToSqlType(TypeInfo(TIn0))
end;

{ TFunctionIn0Instance<TInstance> }

function TFunctionIn0Instance<TInstance>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  FInstanceIn := TInstance(AParams.FInput.MessageData[0].AsObject);
  Result := False
end;

end.
