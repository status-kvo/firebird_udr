unit json_firebird_classes;

{$I .\sources\general.inc}

interface

uses
  firebird_api;

type
  TUdrRegisterJson = record
    class procedure &Register(AStatus: IStatus; AUdrPlugin: IUdrPlugin); static;
  end;

implementation

{$REGION 'uses'}

uses
  SysUtils,
  Classes,
  firebird_variables,
  firebird_types,
  firebird_blob,
  firebird_charset,
  firebird_classes,
  firebird_message_data,
  firebird_message_metadata,
  firebird_factories_base,
  firebird_factories,
  JsonDataObjects;
{$ENDREGION}

resourcestring
  ErrorIndexRangeFormat = 'Запрашиваемый индекс(%d) должен быть в диапозоне от 0 до %d';
  ErrorKeyIsNotEmpty = 'Ключ не может быть пустым';

type
  TClone = class sealed(TInOutInstance<TJsonBaseObject, TJsonBaseObject>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TCount = class sealed(TIn0Instance<TJsonBaseObject, Int32>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TLength = class sealed(TIn0Instance<TJsonBaseObject, Int16, Int64>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TSerializationText = class sealed(TOutInstance<string, TJsonBaseObject>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TSerializationBlob = class sealed(TOutInstance<IBlob, TJsonBaseObject>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  public
    destructor Destroy; override;
  end;

type
  TDeSerializationText = class sealed(TIn0Instance<TJsonBaseObject, Int16, string>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TDeSerializationBlob = class sealed(TIn0Instance<TJsonBaseObject, Int16, IBlob>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TObjectContains = class sealed(TIn0Instance<TJsonObject, string, Int16>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TObjectGetValueCustom<TOut> = class abstract(TIn0Instance<TJsonObject, string, TOut>)
  protected
    function IsComplex: Boolean; virtual; abstract;
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TObjectGetValueComplex<TOut: class> = class sealed(TObjectGetValueCustom<TOut>)
  protected
    function IsComplex: Boolean; override;
  end;

type
  TObjectGetValueSimple<TOut> = class sealed(TObjectGetValueCustom<TOut>)
  protected
    function IsComplex: Boolean; override;
    procedure doSetup(const ASetup: RSetupParams); override;
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TObjectRemoveItem = class sealed(TIn0Instance<TJsonObject, string, Int16>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TArrayGetValueCustom<TOut> = class abstract(TIn0Instance<TJsonArray, Int32, TOut>)
  protected
    function IsComplex: Boolean; virtual; abstract;
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TArrayGetValueSimple<TOut> = class abstract(TArrayGetValueCustom<TOut>)
  protected
    function IsComplex: Boolean; override;
  end;

type
  TArrayGetValueComplex<TOut: class> = class abstract(TArrayGetValueCustom<TOut>)
  protected
    function IsComplex: Boolean; override;
  end;

type
  TBasePutValueComplex<TIn1> = class sealed(TIn0Instance<TJsonBaseObject, TIn1, TJsonBaseObject, Int16>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TObjectPutValueSimple<TIn2> = class sealed(TIn0Instance<TJsonObject, string, TIn2, Int16>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TArrayPutValueSimple<TIn2> = class sealed(TIn0Instance<TJsonArray, Int32, TIn2, Int16>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TArrayDeleteByIndex = class sealed(TIn0Instance<TJsonArray, Int32, Int16>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

  { TUdrRegisterJson }

class procedure TUdrRegisterJson.Register(AStatus: IStatus; AUdrPlugin: IUdrPlugin);
begin
  AUdrPlugin.registerFunction(AStatus, 'Clone', TClone.Create);
  AUdrPlugin.registerFunction(AStatus, 'CountGet', TCount.Create);
  AUdrPlugin.registerFunction(AStatus, 'LengthGet', TLength.Create);

  AUdrPlugin.registerFunction(AStatus, 'SerializationText', TSerializationText.Create);
  AUdrPlugin.registerFunction(AStatus, 'SerializationBlob', TSerializationBlob.Create);

  AUdrPlugin.registerFunction(AStatus, 'DeSerializationText', TDeSerializationText.Create);
  AUdrPlugin.registerFunction(AStatus, 'DeSerializationBlob', TDeSerializationBlob.Create);

  AUdrPlugin.registerFunction(AStatus, 'ObjectCreate', TObjectCreator<TJsonObject>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectContains', TObjectContains.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectRemoveItem', TObjectRemoveItem.Create);

  AUdrPlugin.registerFunction(AStatus, 'ObjectGetObject', TObjectGetValueComplex<TJsonObject>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectGetArray', TObjectGetValueComplex<TJsonArray>.Create);

  AUdrPlugin.registerFunction(AStatus, 'ObjectGetBlob', TObjectGetValueSimple<IBlob>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectGetString', TObjectGetValueSimple<string>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectGetInt16', TObjectGetValueSimple<Int16>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectGetInt32', TObjectGetValueSimple<Int32>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectGetInt64', TObjectGetValueSimple<Int64>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectGetFloat', TObjectGetValueSimple<Single>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectGetDouble', TObjectGetValueSimple<Double>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectGetBool', TObjectGetValueSimple<Boolean>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectGetDate', TObjectGetValueSimple<TDate>.Create);
  // AUdrPlugin.registerFunction(AStatus, 'ObjectGetTime', TObjectGetValueSimple<TTime>.Create);
  // AUdrPlugin.registerFunction(AStatus, 'ObjectGetDateTime', TObjectGetValueSimple<TDateTime>.Create);

  AUdrPlugin.registerFunction(AStatus, 'ObjectPutBlob', TObjectPutValueSimple<IBlob>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectPutString', TObjectPutValueSimple<string>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectPutInt16', TObjectPutValueSimple<Int16>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectPutInt32', TObjectPutValueSimple<Int32>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectPutInt64', TObjectPutValueSimple<Int64>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectPutFloat', TObjectPutValueSimple<Single>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectPutDouble', TObjectPutValueSimple<Double>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectPutBool', TObjectPutValueSimple<Boolean>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectPutDate', TObjectPutValueSimple<TDate>.Create);
  // AUdrPlugin.registerFunction(AStatus, 'ObjectPutTime', TObjectPutValueSimple<TTime>.Create);
  // AUdrPlugin.registerFunction(AStatus, 'ObjectPutDateTime', TObjectPutValueSimple<TDateTime>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ObjectPutComplex', TBasePutValueComplex<string>.Create);

  AUdrPlugin.registerFunction(AStatus, 'ArrayCreate', TObjectCreator<TJsonArray>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayDeleteByIndex', TArrayDeleteByIndex.Create);

  AUdrPlugin.registerFunction(AStatus, 'ArrayGetObject', TArrayGetValueComplex<TJsonObject>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayGetArray', TArrayGetValueComplex<TJsonArray>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayGetBlob', TArrayGetValueSimple<IBlob>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayGetString', TArrayGetValueSimple<string>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayGetInt16', TArrayGetValueSimple<Int16>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayGetInt32', TArrayGetValueSimple<Int32>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayGetInt64', TArrayGetValueSimple<Int64>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayGetFloat', TArrayGetValueSimple<Single>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayGetDouble', TArrayGetValueSimple<Double>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayGetBool', TArrayGetValueSimple<Boolean>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayGetDate', TArrayGetValueSimple<TDate>.Create);
  // AUdrPlugin.registerFunction(AStatus, 'ArrayGetTime', TArrayGetValueSimple<TTime>.Create);
  // AUdrPlugin.registerFunction(AStatus, 'ArrayGetDateTime', TArrayGetValueSimple<TDateTime>.Create);

  AUdrPlugin.registerFunction(AStatus, 'ArrayPutBlob', TArrayPutValueSimple<IBlob>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayPutString', TArrayPutValueSimple<string>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayPutInt16', TArrayPutValueSimple<Int16>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayPutInt32', TArrayPutValueSimple<Int32>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayPutInt64', TArrayPutValueSimple<Int64>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayPutFloat', TArrayPutValueSimple<Single>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayPutDouble', TArrayPutValueSimple<Double>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayPutBool', TArrayPutValueSimple<Boolean>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayPutDate', TArrayPutValueSimple<TDate>.Create);
  // AUdrPlugin.registerFunction(AStatus, 'ArrayPutTime', TArrayPutValueSimple<TTime>.Create);
  // AUdrPlugin.registerFunction(AStatus, 'ArrayPutDateTime', TArrayPutValueSimple<TDateTime>.Create);
  AUdrPlugin.registerFunction(AStatus, 'ArrayPutComplex', TBasePutValueComplex<Int32>.Create);
end;

type
  TJsonDataValueHelperUdr = record helper for TJsonDataValueHelper
  private
    class function MessageIdentToValue(const AJson: TJsonBaseObject; const AIdent: TMessagesData.RMessage): TJsonDataValueHelper; static;
  public
    function SaveToUdr(const AOutput: TMessagesData.RMessage; aIsNotText: Boolean): Boolean;
    class function LoadFromUdr(const AJson: TJsonBaseObject; const AIdent, AInput: TMessagesData.RMessage; aIsNotText: Boolean): Boolean; static;
  end;

  { TClone }

function TClone.doExecute(const AParams: RExecuteParams): Boolean;
var
  NewObject: TJsonObject;
  NewArray : TJsonArray;
begin
  inherited;
  if FInstanceIn is TJsonObject then
  begin
    NewObject := TJsonObject.Create;
    NewObject.assign(TJsonObject(FInstanceIn));
    RLibraryHeapManager.Add(NewObject, AParams.FParent);
    Output := NewObject;
  end
  else if FInstanceIn is TJsonArray then
  begin
    NewArray := TJsonArray.Create;
    NewArray.assign(TJsonArray(FInstanceIn));
    RLibraryHeapManager.Add(NewArray, AParams.FParent);
    Output := NewArray;
  end
  else
    raise Exception.Create(format(rsErrorClassNotSupportFormat, [FInstanceIn.ClassName]));
  Result := True
end;

{ TCount }

function TCount.doExecute(const AParams: RExecuteParams): Boolean;
begin
  inherited;
  if FInstanceIn is TJsonObject then
    FOutput.AsInteger := TJsonObject(FInstanceIn).Count
  else if FInstanceIn is TJsonArray then
    FOutput.AsInteger := TJsonArray(FInstanceIn).Count
  else
    raise Exception.Create(format(rsErrorClassNotSupportFormat, [FInstanceIn.ClassName]));
  Result := True
end;

{ TLength }

function TLength.doExecute(const AParams: RExecuteParams): Boolean;
begin
  inherited;
  FOutput.AsBigint := Length(FInstanceIn.ToJSON(FIn1.AsBoolean));
  Result := True
end;

{ TObjectContains }

function TObjectContains.doExecute(const AParams: RExecuteParams): Boolean;
var
  Key: string;
begin
  inherited;

  try
    Key := FIn1.AsString;
    if FInstanceIn.Contains(Key) then
      FOutput.AsBoolean := True
    else
      FOutput.AsBoolean := (FInstanceIn.Path[Key].Typ <> jdtNone);
    Result := True
  except
    FOutput.AsBoolean := False;
    Result := True
  end;
end;

{ TSerializationText }

function TSerializationText.doExecute(const AParams: RExecuteParams): Boolean;
var
  Value: string;
begin
  inherited;

  Value := FIn0.AsString;
  if Value = '' then
    raise Exception.Create(rsErrorNullOrEmpty)
  else
  begin
    FOutput.AsObject := TJsonBaseObject.ParseUtf8(UTF8String(Value));
    RLibraryHeapManager.Add(FOutput.AsObject, AParams.FParent);
    Result := True
  end
end;

{ TSerializationBlob }

destructor TSerializationBlob.Destroy;
begin
  inherited;
end;

function TSerializationBlob.doExecute(const AParams: RExecuteParams): Boolean;
var
  Blob: TStream;
begin
  inherited;

  if FIn0.Null then
    raise Exception.Create(rsErrorNullOrEmpty)
  else
  begin
    Blob := nil;
    try
      Blob := QUADHelper.SaveToStream(ISC_QUADPtr(AParams.FInput.GetDataByIndex(0)), AParams.FStatus, AParams.FInput.Context);
      if assigned(Blob) and (Blob.Size > 0) then
      begin
        FOutput.AsObject := TJsonBaseObject.ParseFromStream(Blob);
        RLibraryHeapManager.Add(FOutput.AsObject, AParams.FParent);
        Result := True
      end
      else
        raise Exception.Create(rsErrorNullOrEmpty);
    finally
      Blob.Free
    end;
  end;
end;

{ TDeSerializationText }

function TDeSerializationText.doExecute(const AParams: RExecuteParams): Boolean;
begin
  Result := inherited;
  FOutput.AsString := string(FInstanceIn.ToUtf8JSON(FIn1.AsBoolean))
end;

{ TDeSerializationBlob }

function TDeSerializationBlob.doExecute(const AParams: RExecuteParams): Boolean;
var
  StreamBlob: TStream;
begin
  Result := inherited;
  StreamBlob := TMemoryStream.Create;
  try
    FInstanceIn.SaveToStream(StreamBlob, FIn1.AsBoolean, nil, False);
    StreamBlob.Position := 0;
    QUADHelper.LoadFromStream(FOutput, AParams.FStatus, AParams.FOutput.Context, StreamBlob)
  finally
    StreamBlob.Destroy
  end;
end;

{ TObjectGetValueCustom<TOut> }

function TObjectGetValueCustom<TOut>.doExecute(const AParams: RExecuteParams): Boolean;
var
  Key: string;
begin
  inherited;
  Result := False;
  Key := FIn1.AsString;
  if (Key = '') then
    raise Exception.Create(ErrorKeyIsNotEmpty)
  else
  begin
    if FInstanceIn.Contains(Key) then
      Result := FInstanceIn.Values[Key].SaveToUdr(FOutput, IsComplex)
    else if (FInstanceIn.Path[Key].Typ <> jdtNone) then
      Result := FInstanceIn.Path[Key].SaveToUdr(FOutput, IsComplex)
  end;
end;

{ TObjectGetValueSimple<TOut> }

function TObjectGetValueSimple<TOut>.doExecute(const AParams: RExecuteParams): Boolean;
var
  Default: TMessagesData.RMessage;
begin
  Result := inherited;
  if not Result then
  begin
    default := AParams.FInput.MessageData[2];
    FOutput.assign(default)
  end;
end;

procedure TObjectGetValueSimple<TOut>.doSetup(const ASetup: RSetupParams);
begin
  inherited;
  ParamSet(ASetup.FStatus, ASetup.FInput, 2, TypeOutGet);
end;

function TObjectGetValueSimple<TOut>.IsComplex: Boolean;
begin
  Result := False
end;

{ TArrayGetValue<TOut> }

function TArrayGetValueCustom<TOut>.doExecute(const AParams: RExecuteParams): Boolean;
var
  Index: Int32;
  Value: PJsonDataValue;
begin
  Result := inherited;

  index := FIn1.AsInteger;
  if (index < 0) or (index >= FInstanceIn.Count) then
    raise Exception.CreateFmt(ErrorIndexRangeFormat, [index, FInstanceIn.Count])
  else
    Result := FInstanceIn.Values[index].SaveToUdr(FOutput, IsComplex)
end;

{ TJsonDataValueHelperUdr }

class function TJsonDataValueHelperUdr.MessageIdentToValue(const AJson: TJsonBaseObject; const AIdent: TMessagesData.RMessage): TJsonDataValueHelper;

  procedure ObjectGetData;
  var
    Name: string;
  begin
    name := AIdent.getString;
    Result := TJsonObject(AJson).Values[name];
    if Result.Typ = jdtNone then
      Result := TJsonObject(AJson).Path[name];
  end;

  procedure ArrayGetData;
  var
    Index: Int32;
  begin
    index := AIdent.getInteger;
    if index = TJsonArray(AJson).Count then
      TJsonArray(AJson).Add('');
    Result := TJsonArray(AJson).Values[AIdent.getInteger]
  end;

begin
  if AIdent.Metadata.IsText then
    if (AJson is TJsonObject) then
      ObjectGetData
    else
      raise Exception.Create(format(rsErrorDataTypeIsNotSupportedForDataEntityFormat, ['JsonObject', AIdent.Metadata.SQLTypeAsString]))
  else if AIdent.Metadata.IsNumberNatural then
    if (AJson is TJsonArray) then
      ArrayGetData
    else
      raise Exception.Create(format(rsErrorDataTypeIsNotSupportedForDataEntityFormat, ['JsonArray', AIdent.Metadata.SQLTypeAsString]))
  else
    raise Exception.Create(format(rsErrorDataTypeNotSupportedFormat, [rsOutputNominative, 1, AIdent.Metadata.SQLTypeAsString]));
end;

class function TJsonDataValueHelperUdr.LoadFromUdr(const AJson: TJsonBaseObject; const AIdent, AInput: TMessagesData.RMessage;
  aIsNotText: Boolean): Boolean;
var
  JsonValue: TJsonDataValueHelper;
  JsonNew  : TJsonBaseObject;
  Stream   : TStream;

  procedure ObjAddChild(AParent: TJsonObject; AChild: TJsonBaseObject);
  begin
    if AChild is TJsonObject then
      AParent.Path[AIdent.AsString].ObjectValue := TJsonObject(AChild)
    else
      AParent.Path[AIdent.AsString].ArrayValue := TJsonArray(AChild);
    RLibraryHeapManager.Remove(AChild);
  end;

  procedure ArrAddChild(AParent: TJsonArray; AChild: TJsonBaseObject);
  var
    Index: Int32;
  begin
    index := AIdent.AsInteger;
    if index = AParent.Count then
      if AChild is TJsonObject then
        AParent.Add(TJsonObject(AChild))
      else
        AParent.Add(TJsonArray(AChild))
    else if AChild is TJsonObject then
      AParent.O[index] := TJsonObject(AChild)
    else
      AParent.A[index] := TJsonArray(AChild)
  end;

begin
  Result := True;

  if aIsNotText then
  begin
    JsonNew := TJsonBaseObject(AInput.AsObject);
    if AJson is TJsonObject then
      ObjAddChild(TJsonObject(AJson), JsonNew)
    else
      ArrAddChild(TJsonArray(AJson), JsonNew)
  end
  else
  begin
    JsonValue := MessageIdentToValue(AJson, AIdent);

    if AInput.IsNull then
      JsonValue.VariantValue := varNull
    else
      case AInput.Metadata.SQLTypeEnum of
        SQL_VARYING, SQL_TEXT:
          JsonValue.Value := AInput.AsString;
        SQL_FLOAT:
          JsonValue.FloatValue := AInput.AsFloat;
        SQL_DOUBLE, SQL_D_FLOAT:
          JsonValue.FloatValue := AInput.AsDouble;
        SQL_LONG:
          JsonValue.IntValue := AInput.AsInteger;
        SQL_SHORT:
          JsonValue.IntValue := Integer(AInput.AsSmallint);
        SQL_INT64:
          JsonValue.LongValue := AInput.AsBigint;
        SQL_BLOB, SQL_QUAD:
          begin
            Stream := TMemoryStream.Create;
            try
              QUADHelper.SaveToStream(ISC_QUADPtr(AInput.GetData), AInput.Parent.Status, AInput.Parent.Context, Stream);
              Stream.Position := 0;
              JsonNew := TJsonObject.ParseFromStream(Stream, nil, True);
              if JsonNew is TJsonObject then
                JsonValue.ObjectValue := TJsonObject(JsonNew)
              else if JsonNew is TJsonArray then
                JsonValue.ArrayValue := TJsonArray(JsonNew)
              else
                raise Exception.Create('add only Object or Array');
              RLibraryHeapManager.Remove(JsonNew);
            finally
              Stream.Destroy
            end
          end;
        SQL_TIME:
          JsonValue.DateTimeValue := AInput.AsTime;
        SQL_DATE:
          JsonValue.DateTimeValue := AInput.AsDate;
        SQL_TIMESTAMP:
          JsonValue.DateTimeValue := AInput.AsDateTime;
      else
        raise Exception.Create(format(rsErrorDataTypeNotSupportedFormat, [rsInputNominative, 2, AInput.Metadata.SQLTypeAsString]))
      end
  end
end;

function TJsonDataValueHelperUdr.SaveToUdr(const AOutput: TMessagesData.RMessage; aIsNotText: Boolean): Boolean;
var
  Obj: TJsonBaseObject;
begin
  Result := True;
  if IsNull or (Typ = jdtNone) then
    AOutput.Null := True
  else
    case Typ of
      jdtString:
        AOutput.AsString := Self.Value;
      jdtInt:
        AOutput.AsInteger := Self.IntValue;
      jdtLong:
        AOutput.AsBigint := Self.LongValue;
      jdtULong:
        AOutput.AsBigint := Self.ULongValue;
      jdtFloat:
        AOutput.AsDouble := Self.FloatValue;
      jdtDateTime:
        AOutput.AsDateTime := Self.DateTimeValue;
      jdtUtcDateTime:
        AOutput.AsDateTime := Self.UtcDateTimeValue;
      jdtBool:
        AOutput.AsBoolean := Self.BoolValue;
      jdtArray, jdtObject:
        begin
          if Typ = jdtArray then
            Obj := Self.ArrayValue
          else
            Obj := Self.ObjectValue;
          if aIsNotText then
            AOutput.AsObject := Obj
          else
            AOutput.AsString := Obj.ToJSON(True)
        end;
    else
      raise Exception.Create('Неизвестный тип данных');
    end;
end;

{ TObjectGetValue<TOut> }

function TObjectGetValueComplex<TOut>.IsComplex: Boolean;
begin
  Result := True
end;

{ TArrayGetValueSimple<TOut> }

function TArrayGetValueSimple<TOut>.IsComplex: Boolean;
begin
  Result := False
end;

{ TArrayGetValueComplex<TOut> }

function TArrayGetValueComplex<TOut>.IsComplex: Boolean;
begin
  Result := True
end;

{ TBasePutValueComplex<TIn1> }

function TBasePutValueComplex<TIn1>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  inherited;
  if (FIn1.AsString = '') then
    raise Exception.Create(ErrorKeyIsNotEmpty)
  else
    FOutput.AsBoolean := TJsonDataValueHelper.LoadFromUdr(FInstanceIn, FIn1, FIn2, True)
end;

{ TObjectPutValueSimple<TIn2> }

function TObjectPutValueSimple<TIn2>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  inherited;
  if (FIn1.AsString = '') then
    raise Exception.Create(ErrorKeyIsNotEmpty)
  else
    FOutput.AsBoolean := TJsonDataValueHelper.LoadFromUdr(FInstanceIn, FIn1, FIn2, False)
end;

{ TArrayPutValueSimple<TIn2> }

function TArrayPutValueSimple<TIn2>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  inherited;
  if FIn1.Null or (FIn1.AsInteger < 0) or (FIn1.AsInteger > FInstanceIn.Count) then
    raise Exception.CreateFmt(ErrorIndexRangeFormat, [FIn1.AsInteger, FInstanceIn.Count])
  else
    FOutput.AsBoolean := TJsonDataValueHelper.LoadFromUdr(FInstanceIn, FIn1, FIn2, False)
end;

{ TArrayDeleteByIndex }

function TArrayDeleteByIndex.doExecute(const AParams: RExecuteParams): Boolean;
begin
  inherited;
  if FIn1.Null or (FIn1.AsInteger < 0) or (FIn1.AsInteger >= FInstanceIn.Count) then
    raise Exception.CreateFmt(ErrorIndexRangeFormat, [FIn1.AsInteger, FInstanceIn.Count])
  else
  begin
    FInstanceIn.Delete(FIn1.AsInteger);
    FOutput.AsBoolean := True;
    Result := True
  end;
end;

{ TObjectRemoveItem }

function TObjectRemoveItem.doExecute(const AParams: RExecuteParams): Boolean;
begin
  inherited;
  if (FIn1.AsString = '') then
    raise Exception.Create(ErrorKeyIsNotEmpty)
  else
  begin
    FInstanceIn.Remove(FIn1.AsString);
    FOutput.AsBoolean := True;
    Result := True
  end;
end;

end.
