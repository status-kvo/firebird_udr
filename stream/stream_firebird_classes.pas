unit stream_firebird_classes;

{$I general.inc}

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
  TGetForStream = class abstract(TFunctionIn0Instance<TStream, Int64>)
  end;

type
  TSetFromStream = class abstract(TFunctionIn0Instance<TStream, Int64, Int64>)
  end;

type
  TAssign = class sealed(TFunctionIn0Instance<TStream, TStream, Int16>)
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
  TReadCustom<TOut> = class abstract(TFunctionIn0Instance<TStream, Int64, TOut>)
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
  TWrite<TIn1> = class sealed(TFunctionIn0Instance<TStream, TIn1, Int16>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

  { TUdrRegisterStream }

class procedure TUdrRegisterStream.Register(AStatus: IStatus; AUdrPlugin: IUdrPlugin);
begin
  {$IFDEF UDR_HAS_STREAM_SHARED}
    AUdrPlugin.registerFunction(AStatus, 'StreamSharedCreate', TObjectCreator<TSharedStream>.Factory);
  {$ENDIF  UDR_HAS_STREAM_SHARED}

  AUdrPlugin.registerFunction(AStatus, 'StreamStringCreate', TObjectCreator<TStringStream>.Factory);

  AUdrPlugin.registerFunction(AStatus, 'StreamAssign', TAssign.Factory);

  AUdrPlugin.registerFunction(AStatus, 'StreamSizeGet', TSizeGet.Factory);
  AUdrPlugin.registerFunction(AStatus, 'StreamSizeSet', TSizeSet.Factory);

  AUdrPlugin.registerFunction(AStatus, 'StreamPositionGet', TPositionGet.Factory);
  AUdrPlugin.registerFunction(AStatus, 'StreamPositionSet', TPositionSet.Factory);

  AUdrPlugin.registerFunction(AStatus, 'StreamLengthGet', TLengthGet.Factory);
  AUdrPlugin.registerFunction(AStatus, 'StreamLengthChar', TLengthCharGet.Factory);

  AUdrPlugin.registerFunction(AStatus, 'StreamReadString', TRead<string>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'StreamReadBlob', TRead<IBlob>.Factory);

  AUdrPlugin.registerFunction(AStatus, 'StreamWriteString', TWrite<string>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'StreamWriteBlob', TWrite<IBlob>.Factory);

  AUdrPlugin.registerFunction(AStatus, 'StreamToString', TReadTo<string>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'StreamToBlob', TReadTo<IBlob>.Factory);
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
  lValueSize  : Int64;
  lValueData: TBytes;
begin
  inherited;

  lValueSize := FInstanceIn.Size;

  SetLength(lValueData, lValueSize);
  lValueSize := FInstanceIn.Read(lValueData, lValueSize);
  SetLength(lValueData, lValueSize);

  case FIn1.Metadata.SQLTypeEnum of

    SQL_VARYING, SQL_TEXT:
      FIn1.AsString := TEncoding.UTF8.GetString(lValueData);

    SQL_BLOB, SQL_QUAD:
      TStreamBlob.BytesToMessage(lValueData, FIn1, FIn1.Parent.Status, FIn1.Parent.Context);

  else
    raise Exception.CreateFmt(rsErrorDataTypeNotSupportedFormat, [rsInputNominative, 2, FIn1.Metadata.SQLTypeAsString])
  end;

  Result := True;
end;

{ TWrite<TIn1> }

function TWrite<TIn1>.doExecute(const AParams: RExecuteParams): Boolean;
var
  lBuffer: TBytes;
begin
  inherited;

  if not FIn1.isNull then
    case FIn1.Metadata.SQLTypeEnum of

      SQL_VARYING, SQL_TEXT:
        begin
          lBuffer := TEncoding.UTF8.GetBytes(FIn1.AsString);
          FInstanceIn.WriteData(lBuffer, Length(lBuffer));
        end;

      SQL_BLOB, SQL_QUAD:
        TStreamBlob.Clone(FIn1, FInstanceIn, FIn1.Parent.Status, FIn1.Parent.Context);

    else
      raise Exception.CreateFmt(rsErrorDataTypeNotSupportedFormat, [rsInputNominative, 2, FIn1.Metadata.SQLTypeAsString])
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
