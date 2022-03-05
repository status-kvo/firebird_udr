unit stream_firebird_classes;

{$I .\sources\general.inc}

interface

uses
  firebird_api;

type
  TUdrRegisterStream = record
    class procedure &Register(AStatus: IStatus; AUdrPlugin: IUdrPlugin); static;
  end;

implementation

{$REGION 'uses'}

uses
  SysUtils,
  Classes,
  firebird_charset,
  firebird_types,
  firebird_variables,
  firebird_blob,
  firebird_classes,
  firebird_factories,
  firebird_message_metadata,
  firebird_message_data,
  firebird_factories_base,
  stream_shared;
{$ENDREGION}

type
  // второй параметр Blob,выходной Int64
  TGetForStream = class abstract(TIn0Instance<TStream, Int64>)
  end;

type
  TSetFromStream = class abstract(TIn0Instance<TStream, Int64, Int64>)
  end;

type
  TAssign = class sealed(TIn0Instance<TStream, TStream, Int16>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TSizeGet = class sealed(TGetForStream)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TSizeSet = class sealed(TSetFromStream)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TPositionGet = class sealed(TGetForStream)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TPositionSet = class sealed(TSetFromStream)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TLengthGet = class sealed(TGetForStream)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TLengthCharGet = class sealed(TGetForStream)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TReadCustom<TOut> = class abstract(TIn0Instance<TStream, Int64, TOut>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TRead<TOut> = class sealed(TReadCustom<TOut>)
  end;

type
  TReadTo<TOut> = class sealed(TReadCustom<TOut>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TWrite<TIn1> = class sealed(TIn0Instance<TStream, TIn1, Int16>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

  { TUdrRegisterStream }

class procedure TUdrRegisterStream.Register(AStatus: IStatus; AUdrPlugin: IUdrPlugin);
begin
  AUdrPlugin.registerFunction(AStatus, 'StreamSharedCreate', TObjectCreator<TSharedStream>.Create);
  AUdrPlugin.registerFunction(AStatus, 'StreamStringCreate', TObjectCreator<TStringStream>.Create);

  AUdrPlugin.registerFunction(AStatus, 'StreamAssign', TAssign.Create);

  AUdrPlugin.registerFunction(AStatus, 'StreamSizeGet', TSizeGet.Create);
  AUdrPlugin.registerFunction(AStatus, 'StreamSizeSet', TSizeSet.Create);

  AUdrPlugin.registerFunction(AStatus, 'StreamPositionGet', TPositionGet.Create);
  AUdrPlugin.registerFunction(AStatus, 'StreamPositionSet', TPositionSet.Create);

  AUdrPlugin.registerFunction(AStatus, 'StreamLengthGet', TLengthGet.Create);
  AUdrPlugin.registerFunction(AStatus, 'StreamLengthChar', TLengthCharGet.Create);

  AUdrPlugin.registerFunction(AStatus, 'StreamReadString', TRead<string>.Create);
  AUdrPlugin.registerFunction(AStatus, 'StreamReadBlob', TRead<IBlob>.Create);

  AUdrPlugin.registerFunction(AStatus, 'StreamWriteString', TWrite<string>.Create);
  AUdrPlugin.registerFunction(AStatus, 'StreamWriteBlob', TWrite<IBlob>.Create);

  AUdrPlugin.registerFunction(AStatus, 'StreamToString', TReadTo<string>.Create);
  AUdrPlugin.registerFunction(AStatus, 'StreamToBlob', TReadTo<IBlob>.Create);
end;

{ TAssign }

function TAssign.doExecute(const AParams: RExecuteParams): Boolean;

var
  Target: TStream;
  Size  : Int64;
begin
  Result := inherited;

  Target := TStream(FIn1.AsObject);
  Target.Size := 0;
  Size := FInstanceIn.Size - FInstanceIn.Position;
  FOutput.AsBoolean := (Target.CopyFrom(FInstanceIn, Size) = Size)
end;

{ TSizeGet }

function TSizeGet.doExecute(const AParams: RExecuteParams): Boolean;
begin
  Result := inherited;
  FOutput.AsBigint := FInstanceIn.Size;
end;

{ TLengthGet }

function TLengthGet.doExecute(const AParams: RExecuteParams): Boolean;
begin
  inherited;
  FOutput.AsBigint := (FInstanceIn.Size - FInstanceIn.Position);
  Result := True;
end;

{ TLengthCharGet }

function TLengthCharGet.doExecute(const AParams: RExecuteParams): Boolean;

var
  ValueSize  : Int64;
  ValueBuffer: TBytes;
begin
  ValueSize := (FInstanceIn.Size - FInstanceIn.Position);
  SetLength(ValueBuffer, ValueSize);
  ValueSize := FInstanceIn.Read(ValueBuffer, ValueSize);
  SetLength(ValueBuffer, ValueSize);
  FOutput.AsBigint := TEncoding.UTF8.GetString(ValueBuffer).Length;
  Result := True
end;

{ TPositionGet }

function TPositionGet.doExecute(const AParams: RExecuteParams): Boolean;
begin
  inherited;
  FOutput.AsBigint := FInstanceIn.Position;
  Result := True;
end;

{ TSizeSet }

function TSizeSet.doExecute(const AParams: RExecuteParams): Boolean;
begin
  inherited;
  FInstanceIn.Size := FIn1.AsBigint;
  FOutput.AsBigint := FInstanceIn.Size;
  Result := True
end;

{ TPositionSet }

function TPositionSet.doExecute(const AParams: RExecuteParams): Boolean;
begin
  inherited;
  FInstanceIn.Position := FIn1.AsBigint;
  FOutput.AsBigint := FInstanceIn.Position;
  Result := True
end;

{ TReadCustom<TOut> }

function TReadCustom<TOut>.doExecute(const AParams: RExecuteParams): Boolean;

var
  ValueSize  : Int64;
  ValueBuffer: TBytes;
  ValueStream: TStream;
begin
  inherited;

  ValueSize := FInstanceIn.Size;

  SetLength(ValueBuffer, ValueSize);
  ValueSize := FInstanceIn.Read(ValueBuffer, ValueSize);
  SetLength(ValueBuffer, ValueSize);

  case FIn1.Metadata.SQLTypeEnum of
    SQL_VARYING, SQL_TEXT:
      FIn1.AsString := TEncoding.UTF8.GetString(ValueBuffer);
    SQL_BLOB, SQL_QUAD:
      begin
        ValueStream := TMemoryStream.Create;
        try
          ValueStream.CopyFrom(FInstanceIn, ValueSize);
          ValueStream.Position := 0;
          QUADHelper.LoadFromStream(FIn1, FIn1.Parent.Status, FIn1.Parent.Context, ValueStream);
        finally
          ValueStream.DisposeOf
        end;
      end;
  else
    raise Exception.Create(format(rsErrorDataTypeNotSupportedFormat, [rsInputNominative, 2, FIn1.Metadata.SQLTypeAsString]))
  end;
  Result := True;
end;

{ TWrite<TIn1> }

function TWrite<TIn1>.doExecute(const AParams: RExecuteParams): Boolean;

var
  ValueBuffer: TBytes;
  ValueStream: TStream;
begin
  inherited;

  if not FIn1.isNull then
    case FIn1.Metadata.SQLTypeEnum of
      SQL_VARYING, SQL_TEXT:
        begin
          ValueBuffer := TEncoding.UTF8.GetBytes(FIn1.AsString);
          FInstanceIn.WriteData(ValueBuffer, Length(ValueBuffer));
        end;
      SQL_BLOB, SQL_QUAD:
        begin
          ValueStream := TMemoryStream.Create;
          try
            QUADHelper.SaveToStream(ISC_QUADPtr(FIn1.GetData), FIn1.Parent.Status, FIn1.Parent.Context, ValueStream);
            ValueStream.Position := 0;
            FInstanceIn.CopyFrom(ValueStream, ValueStream.Size)
          finally
            ValueStream.Destroy
          end;
        end;
    else
      raise Exception.Create(format(rsErrorDataTypeNotSupportedFormat, [rsInputNominative, 2, FIn1.Metadata.SQLTypeAsString]))
    end;
  Result := True;
  FOutput.AsBoolean := True
end;

{ TReadTo<TOut> }

function TReadTo<TOut>.doExecute(const AParams: RExecuteParams): Boolean;

var
  Position: Int64;
begin
  Position := FInstanceIn.Position;
  try
    Result := inherited;
  finally
    FInstanceIn.Position := Position
  end;
end;

end.
