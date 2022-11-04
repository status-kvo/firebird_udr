unit json_firebird_classes;

{$I general.inc}

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
  Variants,
  Classes,
  Generics.Collections,
  JsonDataObjectsKVO,
  firebird_variables,
  firebird_types,
  firebird_blob,
  firebird_charset,
  firebird_classes,
  firebird_message_data,
  firebird_message_metadata,
  firebird_factories_base,
  firebird_factories;
{$ENDREGION}

{$REGION 'resourcestring'}
resourcestring
  ErrorIndexGetRangeFormat = 'Индекс при чтении(%d) должен быть в диапозоне от 0 до %d';
  ErrorIndexSetRangeFormat = 'Индекс при записи(%d) должен быть в диапозоне от -1 (вставка) до %d.';
  ErrorIndexDelRangeFormat = 'Индекс при удалении(%d) должен быть в диапозоне от 0 до %d';
  ErrorKeyIsNotEmpty = 'Ключ не может быть пустым';
  ErrorValueIsNotObject = 'Запрашиваемый элемент не является "Объектом"';
  ErrorValueIsNotArray = 'Запрашиваемый элемент не является "Массивом"';
{$ENDREGION}

procedure RaiseForArray(const aIndex: NativeInt; aCount: NativeInt);
begin
  if aCount > 0 then
    Dec(aCount);
  raise Exception.CreateFmt(ErrorIndexGetRangeFormat, [aIndex, aCount]);
end;

type
  TClone = class sealed(TFunctionInOutInstance<TJsonBaseObject, TJsonBaseObject>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TInJson<TOut> = class abstract(TFunctionIn0Instance<TJsonBaseObject, TOut>)
  end;

type
  TInJson<TIn1, TOut> = class abstract(TFunctionIn0Instance<TJsonBaseObject, TIn1, TOut>)
  end;

type
  TInJsonIn1Int16OutCustom<TOut> = class abstract(TInJson<Int16, TOut>)
  end;

type
  TCount = class sealed(TInJson<Int32>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TLength = class sealed(TInJsonIn1Int16OutCustom<Int64>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TSerializationText = class sealed(TFunctionOutInstance<string, TJsonBaseObject>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TSerializationBlob = class sealed(TFunctionOutInstance<IBlob, TJsonBaseObject>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TDeSerializationText = class sealed(TInJsonIn1Int16OutCustom<string>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TDeSerializationBlob = class sealed(TInJsonIn1Int16OutCustom<IBlob>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TInJsonExtractIn1CustomOutCustom<TPath; TOut> = class abstract(TFunctionIn0Instance<TJsonBaseObject, TPath, TOut>)
  private
    function InternalExecuteArray(const AParams: RExecuteParams): Boolean;
    function InternalExecuteObject(const AParams: RExecuteParams): Boolean;
  protected
    FRemove: Boolean;
    function doExecute(const AParams: RExecuteParams): Boolean; override;
    function IsUpdateResultForOutput: Boolean; virtual;
  protected
    function IsArray: Boolean;
    function ValueToUdr(AValue: PJsonDataValue; const AParams: RExecuteParams): Boolean; virtual; abstract;
  end;

type
  TInJsonExtractIn1CustomOutBool<TPath> = class abstract(TInJsonExtractIn1CustomOutCustom<TPath, Int16>)
  end;

type
  TInJsonContainsItem<TPath> = class sealed(TInJsonExtractIn1CustomOutBool<TPath>)
  protected
    function ValueToUdr(AValue: PJsonDataValue; const AParams: RExecuteParams): Boolean; override;
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TInJsonRemoveItem<TPath> = class sealed(TInJsonExtractIn1CustomOutBool<TPath>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  protected
    function ValueToUdr(AValue: PJsonDataValue; const AParams: RExecuteParams): Boolean; override;
  end;

type
  TInJsonGetCustomItem<TPath; TOut> = class abstract(TInJsonExtractIn1CustomOutCustom<TPath, TOut>)
  end;

type
  TInJsonGetObjectItem<TPath> = class sealed(TInJsonExtractIn1CustomOutCustom<TPath, TJsonObject>)
  protected
    function IsUpdateResultForOutput: Boolean; override;
    function ValueToUdr(AValue: PJsonDataValue; const AParams: RExecuteParams): Boolean; override;
  end;

type
  TInJsonGetArrayItem<TPath> = class sealed(TInJsonExtractIn1CustomOutCustom<TPath, TJsonArray>)
  protected
    function IsUpdateResultForOutput: Boolean; override;
    function ValueToUdr(AValue: PJsonDataValue; const AParams: RExecuteParams): Boolean; override;
  end;

type
  TInJsonGetSimpleItemAndDefault<TPath; TOut> = class abstract(TInJsonExtractIn1CustomOutCustom<TPath, TOut>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
    function IsUpdateResultForOutput: Boolean; override;
  protected
    class procedure doSetup(const ASetup: RSetupParams); override;
  protected
    function ValueToUdr(AValue: PJsonDataValue; const AParams: RExecuteParams): Boolean; override;
  end;

type
  TInJsonObjectGetSimpleItem<TOut> = class sealed(TInJsonGetSimpleItemAndDefault<string, TOut>)
  end;

type
  TInJsonObjectGetDateItem<TOut> = class sealed(TInJsonGetSimpleItemAndDefault<string, TDate>)
  protected
    function ValueToUdr(AValue: PJsonDataValue; const AParams: RExecuteParams): Boolean; override;
  end;

type
  TInJsonGetSimpleItem<TPath, TOut> = class abstract(TInJsonExtractIn1CustomOutCustom<TPath, TOut>)
  protected
    function IsUpdateResultForOutput: Boolean; override;
    function ValueToUdr(AValue: PJsonDataValue; const AParams: RExecuteParams): Boolean; override;
  end;

type
  TInJsonArrayGetSimpleItem<TOut> = class sealed(TInJsonGetSimpleItem<Int32, TOut>)
  end;

type
  TInJsonGetBlobItem<TPath> = class sealed(TInJsonExtractIn1CustomOutCustom<TPath, IBlob>)
  protected
    function IsUpdateResultForOutput: Boolean; override;
    function ValueToUdr(AValue: PJsonDataValue; const AParams: RExecuteParams): Boolean; override;
  end;

type
  TInJsonPutCustomItemOutBool<TPath, TValue> = class abstract(TFunctionIn0Instance<TJsonBaseObject, TPath, Int16>)
  private
    procedure InternalExecuteArray(const AParams: RExecuteParams);
    procedure InternalExecuteObject(const AParams: RExecuteParams);
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  protected
    class procedure doSetup(const ASetup: RSetupParams); override;
  protected
    FValueUdr: TMessagesData.RMessage;
    procedure UdrToValue(const AParams: RExecuteParams; AValueJson: PJsonDataValue); virtual; abstract;
  end;

type
  TInJsonPutComplexItem<TPath> = class sealed(TInJsonPutCustomItemOutBool<TPath, TJsonBaseObject>)
  protected
    procedure UdrToValue(const AParams: RExecuteParams; AValueJson: PJsonDataValue); override;
  end;

type
  TInJsonPutBlobItem<TPath> = class sealed(TInJsonPutCustomItemOutBool<TPath, IBlob>)
  protected
    procedure UdrToValue(const AParams: RExecuteParams; AValueJson: PJsonDataValue); override;
  end;

type
  TInJsonPutInt16Item<TPath> = class sealed(TInJsonPutCustomItemOutBool<TPath, Int16>)
  protected
    procedure UdrToValue(const AParams: RExecuteParams; AValueJson: PJsonDataValue); override;
  end;

type
  TInJsonPutInt32Item<TPath> = class sealed(TInJsonPutCustomItemOutBool<TPath, Int32>)
  protected
    procedure UdrToValue(const AParams: RExecuteParams; AValueJson: PJsonDataValue); override;
  end;

type
  TInJsonPutInt64Item<TPath> = class sealed(TInJsonPutCustomItemOutBool<TPath, Int64>)
  protected
    procedure UdrToValue(const AParams: RExecuteParams; AValueJson: PJsonDataValue); override;
  end;

type
  TInJsonPutSingleItem<TPath> = class sealed(TInJsonPutCustomItemOutBool<TPath, Single>)
  protected
    procedure UdrToValue(const AParams: RExecuteParams; AValueJson: PJsonDataValue); override;
  end;

type
  TInJsonPutDoubleItem<TPath> = class sealed(TInJsonPutCustomItemOutBool<TPath, Double>)
  protected
    procedure UdrToValue(const AParams: RExecuteParams; AValueJson: PJsonDataValue); override;
  end;

type
  TInJsonPutStringItem<TPath> = class sealed(TInJsonPutCustomItemOutBool<TPath, string>)
  protected
    procedure UdrToValue(const AParams: RExecuteParams; AValueJson: PJsonDataValue); override;
  end;

type
  TInJsonPutDateKindItem<TPath, TDateKind> = class sealed(TInJsonPutCustomItemOutBool<TPath, TDateKind>)
  protected
    procedure UdrToValue(const AParams: RExecuteParams; AValueJson: PJsonDataValue); override;
  end;

  { TUdrRegisterJson }

class procedure TUdrRegisterJson.Register(AStatus: IStatus; AUdrPlugin: IUdrPlugin);
begin
  AUdrPlugin.registerFunction(AStatus, 'JsonClone', TClone.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonCountGet', TCount.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonLengthGet', TLength.Factory);

  AUdrPlugin.registerFunction(AStatus, 'JsonSerializationText', TSerializationText.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonSerializationBlob', TSerializationBlob.Factory);

  AUdrPlugin.registerFunction(AStatus, 'JsonDeSerializationText', TDeSerializationText.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonDeSerializationBlob', TDeSerializationBlob.Factory);

  AUdrPlugin.registerFunction(AStatus, 'JsonObjectCreate', TObjectCreator<TJsonObject>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectContains', TInJsonContainsItem<string>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectRemoveItem', TInJsonRemoveItem<string>.Factory);

  AUdrPlugin.registerFunction(AStatus, 'JsonObjectGetObject', TInJsonGetObjectItem<string>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectGetArray', TInJsonGetArrayItem<string>.Factory);

  AUdrPlugin.registerFunction(AStatus, 'JsonObjectGetBlob', TInJsonGetBlobItem<string>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectGetString', TInJsonObjectGetSimpleItem<string>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectGetInt16', TInJsonObjectGetSimpleItem<Int16>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectGetInt32', TInJsonObjectGetSimpleItem<Int32>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectGetInt64', TInJsonObjectGetSimpleItem<Int64>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectGetFloat', TInJsonObjectGetSimpleItem<Single>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectGetDouble', TInJsonObjectGetSimpleItem<Double>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectGetBool', TInJsonObjectGetSimpleItem<Boolean>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectGetTime', TInJsonObjectGetSimpleItem<TTime>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectGetDate', TInJsonObjectGetSimpleItem<TDate>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectGetDateTime', TInJsonObjectGetSimpleItem<TDateTime>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectGetTimeStamp', TInJsonObjectGetSimpleItem<TTimeStamp>.Factory);

  AUdrPlugin.registerFunction(AStatus, 'JsonObjectPutBlob', TInJsonPutBlobItem<string>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectPutString', TInJsonPutStringItem<string>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectPutInt16', TInJsonPutInt16Item<string>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectPutInt32', TInJsonPutInt32Item<string>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectPutInt64', TInJsonPutInt64Item<string>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectPutFloat', TInJsonPutSingleItem<string>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectPutDouble', TInJsonPutDoubleItem<string>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectPutTime', TInJsonPutDateKindItem<string, TTime>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectPutDate', TInJsonPutDateKindItem<string, TDate>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectPutDateTime', TInJsonPutDateKindItem<string, TDateTime>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectPutTimeStamp', TInJsonPutDateKindItem<string, TTimeStamp>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonObjectPutComplex', TInJsonPutComplexItem<string>.Factory);

  AUdrPlugin.registerFunction(AStatus, 'JsonArrayCreate', TObjectCreator<TJsonArray>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayDeleteByIndex', TInJsonRemoveItem<Int32>.Factory);

  AUdrPlugin.registerFunction(AStatus, 'JsonArrayGetObject', TInJsonGetObjectItem<Int32>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayGetArray', TInJsonGetArrayItem<Int32>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayGetBlob', TInJsonGetBlobItem<Int32>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayGetString', TInJsonArrayGetSimpleItem<string>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayGetInt16', TInJsonArrayGetSimpleItem<Int16>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayGetInt32', TInJsonArrayGetSimpleItem<Int32>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayGetInt64', TInJsonArrayGetSimpleItem<Int64>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayGetFloat', TInJsonArrayGetSimpleItem<Single>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayGetDouble', TInJsonArrayGetSimpleItem<Double>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayGetBool', TInJsonArrayGetSimpleItem<Boolean>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayGetTime', TInJsonArrayGetSimpleItem<TTime>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayGetDate', TInJsonArrayGetSimpleItem<TDate>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayGetDateTime', TInJsonArrayGetSimpleItem<TDateTime>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayGetTimeStamp', TInJsonArrayGetSimpleItem<TTimeStamp>.Factory);

  AUdrPlugin.registerFunction(AStatus, 'JsonArrayPutBlob', TInJsonPutBlobItem<Int32>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayPutString', TInJsonPutStringItem<Int32>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayPutInt16', TInJsonPutInt16Item<Int32>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayPutInt32', TInJsonPutInt32Item<Int32>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayPutInt64', TInJsonPutInt64Item<Int32>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayPutFloat', TInJsonPutSingleItem<Int32>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayPutDouble', TInJsonPutDoubleItem<Int32>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayPutTime', TInJsonPutDateKindItem<Int32, TTime>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayPutDate', TInJsonPutDateKindItem<Int32, TDate>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayPutDateTime', TInJsonPutDateKindItem<Int32, TDateTime>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayPutTimeStamp', TInJsonPutDateKindItem<Int32, TTimeStamp>.Factory);
  AUdrPlugin.registerFunction(AStatus, 'JsonArrayPutComplex', TInJsonPutComplexItem<Int32>.Factory);
end;

{ TClone }

function TClone.doExecute(const AParams: RExecuteParams): Boolean;
 var
  LNew: TJsonBaseObject;
begin
  inherited;

  if FInstanceIn is TJsonArray then
    LNew := TJsonArray(FInstanceIn).Clone
  else if FInstanceIn is TJsonObject then
    LNew := TJsonObject(FInstanceIn).Clone
  else
    raise Exception.CreateFmt(rsErrorClassNotSupportFormat, [FInstanceIn.ClassName]);

  TFunction(AParams.FParent).FInstances.Add(TAdapterClass.Create(Self, LNew));
  Output := LNew;
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
    raise Exception.CreateFmt(rsErrorClassNotSupportFormat, [FInstanceIn.ClassName]);

  Result := True
end;

{ TLength }

function TLength.doExecute(const AParams: RExecuteParams): Boolean;
begin
  inherited;

  FOutput.AsBigint := Length(FInstanceIn.ToJSON(true));
  Result := True
end;

{ TSerializationText }

function TSerializationText.doExecute(const AParams: RExecuteParams): Boolean;
 var
  LValue: string;
begin
  inherited;

  LValue := FIn0.AsString;
  if LValue = '' then
    raise Exception.Create(rsErrorNullOrEmpty)
  else
  begin
    FOutput.AsObject := TJsonObject.ParseUtf8(UTF8String(LValue));
    if (FOutput.AsObject <> nil) then
      TFunction(AParams.FParent).FInstances.Add(TAdapterClass.Create(Self, FOutput.AsObject));
    Result := True
  end
end;

{ TSerializationBlob }

function TSerializationBlob.doExecute(const AParams: RExecuteParams): Boolean;
 var
  LStream: TStream;
begin
  inherited;

  if FIn0.isNull then
    raise Exception.Create(rsErrorNullOrEmpty)
  else
  begin
    LStream := nil;
    try
      LStream := TStreamBlob.CreateRead(ISC_QUADPtr(FIn0.GetData), AParams.FStatus, AParams.FInput.Context);
      if LStream.Size = 0 then
        raise Exception.Create(rsErrorNullOrEmpty);

      FOutput.AsObject := TJsonBaseObject.ParseFromStream(LStream);
      if (FOutput.AsObject <> nil) then
        TFunction(AParams.FParent).FInstances.Add(TAdapterClass.Create(Self, FOutput.AsObject));
    finally
      LStream.Free
    end;

    Result := True;
  end;
end;

{ TDeSerializationText }

function TDeSerializationText.doExecute(const AParams: RExecuteParams): Boolean;
begin
  inherited;
  FOutput.AsString := FInstanceIn.ToJSON(FIn1.AsBoolean);
  Result := True;
end;

{ TDeSerializationBlob }

function TDeSerializationBlob.doExecute(const AParams: RExecuteParams): Boolean;
 var
  LStream: TStream;
begin
  inherited;

  LStream := nil;
  try
    LStream := TStreamBlob.CreateWrite(ISC_QUADPtr(FOutput.GetData), AParams.FStatus, AParams.FInput.Context);
    FInstanceIn.SaveToStream(LStream, FIn1.AsBoolean);
    FOutput.SetNull(False)
  finally
    LStream.Free
  end;

  Result := True;
end;

{ TInJsonExtractIn1CustomOutCustom<TPath, TOut> }

function TInJsonExtractIn1CustomOutCustom<TPath, TOut>.InternalExecuteArray(const AParams: RExecuteParams): Boolean;
 var
  LIndex: NativeInt;
  LValue: PJsonDataValue;
begin
  LIndex := FIn1.AsInteger;
  Result := True;

  if (LIndex < 0) or (LIndex >= TJsonArray(FInstanceIn).Count) then
    RaiseForArray(LIndex, TJsonArray(FInstanceIn).Count);

  LValue := TJsonArray(FInstanceIn).Items[LIndex];
  if (LValue <> nil) and (not LValue.IsNull) then
    Result := ValueToUdr(LValue, AParams);

  if FRemove then
    TJsonArray(FInstanceIn).Delete(LIndex);

  if IsUpdateResultForOutput then
    FOutput.AsBoolean := Result
end;

function TInJsonExtractIn1CustomOutCustom<TPath, TOut>.InternalExecuteObject(const AParams: RExecuteParams): Boolean;
 var
  LPath : string;
  LValue: PJsonDataValue;
  LHelper: TJsonDataValueHelper;
begin
  Result := False;
  LPath := FIn1.AsString;

  LHelper := TJsonObject(FInstanceIn).Path[LPath];

  if (LHelper.Typ = jdtNone) or (LHelper.Intern = nil) then
    if not LPath.StartsWith('"') then
      LHelper := TJsonObject(FInstanceIn).Path[LPath.QuotedString('"')];

  if (LHelper.Typ = jdtNone) or (LHelper.Intern = nil) then
  begin
    Result  := false;
    Exit;
  end;

  LValue := LHelper.Intern;

  if (LValue = nil) or (LValue.IsNull) then
    Result := True
  else
    Result := ValueToUdr(LValue, AParams);

  if FRemove and (LHelper.NameResolver <> nil) then
    LHelper.NameResolver.Remove(LHelper.Name);

  if IsUpdateResultForOutput then
    FOutput.AsBoolean := Result
end;

function TInJsonExtractIn1CustomOutCustom<TPath, TOut>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  inherited;

  if IsArray then
    Result := InternalExecuteArray(AParams)
  else
    Result := InternalExecuteObject(AParams)
end;

function TInJsonExtractIn1CustomOutCustom<TPath, TOut>.IsArray: Boolean;
begin
  Result := (FInstanceIn is TJsonArray)
end;

function TInJsonExtractIn1CustomOutCustom<TPath, TOut>.IsUpdateResultForOutput: Boolean;
begin
  Result := True
end;

{ TInJsonContainsItem<TPath> }

function TInJsonContainsItem<TPath>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  Result := inherited doExecute(AParams);
  if FOutput.isNull then
    FOutput.AsBoolean := False
end;

function TInJsonContainsItem<TPath>.ValueToUdr(AValue: PJsonDataValue; const AParams: RExecuteParams): Boolean;
begin
  Result := True
end;

{ TInJsonRemoveItem<TPath> }

function TInJsonRemoveItem<TPath>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  FRemove := True;
  Result := inherited
end;

function TInJsonRemoveItem<TPath>.ValueToUdr(AValue: PJsonDataValue; const AParams: RExecuteParams): Boolean;
begin
  aValue.IntValue := 0;
  Result := True
end;

{ TInJsonGetObjectItem<TPath> }

function TInJsonGetObjectItem<TPath>.IsUpdateResultForOutput: Boolean;
begin
  Result := False
end;

function TInJsonGetObjectItem<TPath>.ValueToUdr(AValue: PJsonDataValue; const AParams: RExecuteParams): Boolean;
begin
  if aValue.Typ <> TJsonDataType.jdtObject then
    raise Exception.Create(ErrorValueIsNotObject);

  FOutput.AsObject := aValue.ObjectValue;
  Result := True;
end;

{ TInJsonGetArrayItem<TPath> }

function TInJsonGetArrayItem<TPath>.IsUpdateResultForOutput: Boolean;
begin
  Result := False
end;

function TInJsonGetArrayItem<TPath>.ValueToUdr(AValue: PJsonDataValue; const AParams: RExecuteParams): Boolean;
begin
  if aValue.Typ <> TJsonDataType.jdtArray then
    raise Exception.Create(ErrorValueIsNotArray);

  FOutput.AsObject := aValue.ArrayValue;
  Result := True;
end;

{ TInJsonGetSimpleItemAndDefault<TPath, TOut> }

function TInJsonGetSimpleItemAndDefault<TPath, TOut>.doExecute(const AParams: RExecuteParams): Boolean;
 var
  LDefault: TMessagesData.RMessage;
begin
  Result := inherited;
  if not Result then
    if not IsArray then
    begin
      LDefault := AParams.FInput.MessageData[2];
      FOutput.Assign(LDefault);
      Result := True;
    end;
end;

class procedure TInJsonGetSimpleItemAndDefault<TPath, TOut>.doSetup(const ASetup: RSetupParams);
begin
  inherited;
  ParamSet(ASetup.FStatus, ASetup.FInput, 2, TypeOutGet);
end;

function TInJsonGetSimpleItemAndDefault<TPath, TOut>.IsUpdateResultForOutput: Boolean;
begin
  Result := False
end;

function TInJsonGetSimpleItemAndDefault<TPath, TOut>.ValueToUdr(AValue: PJsonDataValue; const AParams: RExecuteParams): Boolean;
begin
  case aValue.Typ of
    jdtBool:
      FOutput.AsBoolean := AValue.BoolValue;
    jdtInt, jdtLong:
      FOutput.AsBigint := AValue.LongValue;
    jdtULong:
      FOutput.AsBigint := Int64(AValue.LongValue);
    jdtFloat:
      FOutput.AsDouble := AValue.FloatValue;
    jdtDateTime, jdtUtcDateTime:
      FOutput.AsDateTime := AValue.DateTimeValue;
   else
    FOutput.AsString := aValue.Value;
  end;
  Result := True
end;

{ TInJsonGetSimpleItem<TPath, TOut> }

function TInJsonGetSimpleItem<TPath, TOut>.IsUpdateResultForOutput: Boolean;
begin
  Result := False
end;

function TInJsonGetSimpleItem<TPath, TOut>.ValueToUdr(AValue: PJsonDataValue; const AParams: RExecuteParams): Boolean;
begin
  case aValue.Typ of
    jdtBool:
      FOutput.AsBoolean := AValue.BoolValue;
    jdtInt, jdtLong:
      FOutput.AsBigint := AValue.LongValue;
    jdtULong:
      FOutput.AsBigint := Int64(AValue.LongValue);
    jdtFloat:
      FOutput.AsDouble := AValue.FloatValue;
    jdtDateTime, jdtUtcDateTime:
      FOutput.AsDateTime := AValue.DateTimeValue;
   else
    FOutput.AsString := aValue.Value;
  end;
  Result := True
end;

{ TInJsonGetBlobItem<TPath> }

function TInJsonGetBlobItem<TPath>.IsUpdateResultForOutput: Boolean;
begin
  Result := False
end;

function TInJsonGetBlobItem<TPath>.ValueToUdr(AValue: PJsonDataValue; const AParams: RExecuteParams): Boolean;
 var
  LData  : String;
  LBuffer: TBytes;
begin
  case AValue.Typ of
    TJsonDataType.jdtArray : LData := AValue.ArrayValue.ToJSON(True);
    TJsonDataType.jdtObject: LData := AValue.ObjectValue.ToJSON(True);
   else
    LData := AValue.Value
  end;

  LBuffer := TEncoding.UTF8.GetBytes(LData);
  TStreamBlob.BytesToMessage(LBuffer, FOutput, AParams.FStatus, AParams.FOutput.Context);
  Result := True;
end;

{ TInJsonObjectGetDateItem<TOut> }

function TInJsonObjectGetDateItem<TOut>.ValueToUdr(AValue: PJsonDataValue; const AParams: RExecuteParams): Boolean;
begin
  if AValue.Typ in [TJsonDataType.jdtDateTime, TJsonDataType.jdtUtcDateTime] then
  begin
    FOutput.AsDate := Trunc(AValue.DateTimeValue);
    Result := True
  end
  else
    Result := inherited ValueToUdr(aValue, AParams)
end;

{ TInJsonPutCustomItemOutBool<TPath, TValue> }

procedure TInJsonPutCustomItemOutBool<TPath, TValue>.InternalExecuteArray(const AParams: RExecuteParams);
 var
  LIndex: NativeInt;
  LNew  : TJsonBaseObject;
begin
  LIndex := FIn1.AsInteger;

  if LIndex = -1 then
  begin
    TJsonArray(FInstanceIn).Add(null);
    LIndex := Pred(TJsonArray(FInstanceIn).Count);
  end;

  if FValueUdr.isNull then
    TJsonArray(FInstanceIn).Items[LIndex].ObjectValue := nil
  else
    UdrToValue(AParams, TJsonArray(FInstanceIn).Items[LIndex]);
end;

procedure TInJsonPutCustomItemOutBool<TPath, TValue>.InternalExecuteObject(const AParams: RExecuteParams);
 var
  LPath  : string;
  LNew   : TJsonBaseObject;
  LHelper: TJsonDataValueHelper;
begin
  LPath := FIn1.AsString;

  LHelper := TJsonObject(FInstanceIn).Path[LPath];
  LHelper.ObjectValue := nil;

  if not FValueUdr.isNull then
    UdrToValue(AParams, LHelper.Intern);
end;

function TInJsonPutCustomItemOutBool<TPath, TValue>.doExecute(const AParams: RExecuteParams): Boolean;
begin
  inherited;
  FValueUdr := AParams.FInput.MessageData[2];

  if FInstanceIn is TJsonArray then
    InternalExecuteArray(AParams)
  else
    InternalExecuteObject(AParams);

  Result := True;
end;

class procedure TInJsonPutCustomItemOutBool<TPath, TValue>.doSetup(const ASetup: RSetupParams);
begin
  inherited;
  ParamSet(ASetup.FStatus, ASetup.FInput, 2, TypeToSqlType(TypeInfo(TValue)));
end;

{ TInJsonPutComplexItem<TPath> }

procedure TInJsonPutComplexItem<TPath>.UdrToValue(const AParams: RExecuteParams; AValueJson: PJsonDataValue);
 var
  LAdapter: TAdapterClass;
begin
  if FValueUdr.getObject is TJsonArray then
    AValueJson.ArrayValue := TJsonArray(FValueUdr.getObject)
  else
    AValueJson.ObjectValue := TJsonObject(FValueUdr.getObject);

  LAdapter := nil;
  try
    LAdapter := TAdapterClass(TFunction(AParams.FParent).FInstances.FindAdapterByClass(FValueUdr.getObject));
    if LAdapter = nil then
      Exit;

    LAdapter.IsChildDispose := False;
  finally
    LAdapter.Free;
  end;
end;

{ TInJsonPutBlobItem<TPath> }

procedure TInJsonPutBlobItem<TPath>.UdrToValue(const AParams: RExecuteParams; AValueJson: PJsonDataValue);
 var
  LBuffer: TBytes;
begin
  LBuffer := TStreamBlob.MessageToBytes(FValueUdr, AParams.FStatus, AParams.FInput.Context);
  AValueJson.Value := TEncoding.UTF8.GetString(LBuffer)
end;

{ TInJsonPutInt16Item<TPath> }

procedure TInJsonPutInt16Item<TPath>.UdrToValue(const AParams: RExecuteParams; AValueJson: PJsonDataValue);
begin
  AValueJson.BoolValue := FValueUdr.AsBoolean
end;

{ TInJsonPutInt32Item<TPath> }

procedure TInJsonPutInt32Item<TPath>.UdrToValue(const AParams: RExecuteParams; AValueJson: PJsonDataValue);
begin
  AValueJson.IntValue := FValueUdr.AsInteger
end;

{ TInJsonPutInt64Item<TPath> }

procedure TInJsonPutInt64Item<TPath>.UdrToValue(const AParams: RExecuteParams; AValueJson: PJsonDataValue);
begin
  AValueJson.LongValue := FValueUdr.AsBigint
end;

{ TInJsonPutSingleItem<TPath> }

procedure TInJsonPutSingleItem<TPath>.UdrToValue(const AParams: RExecuteParams; AValueJson: PJsonDataValue);
begin
  AValueJson.FloatValue := FValueUdr.AsFloat
end;

{ TInJsonPutDoubleItem<TPath> }

procedure TInJsonPutDoubleItem<TPath>.UdrToValue(const AParams: RExecuteParams; AValueJson: PJsonDataValue);
begin
  AValueJson.FloatValue := FValueUdr.AsDouble
end;

{ TInJsonPutStringItem<TPath> }

procedure TInJsonPutStringItem<TPath>.UdrToValue(const AParams: RExecuteParams; AValueJson: PJsonDataValue);
begin
  AValueJson.Value := FValueUdr.AsString
end;

{ TInJsonPutDateKindItem<TPath, TDateKind> }

procedure TInJsonPutDateKindItem<TPath, TDateKind>.UdrToValue(const AParams: RExecuteParams; AValueJson: PJsonDataValue);
begin
  AValueJson.DateTimeValue := FValueUdr.AsDateTime
end;

end.
