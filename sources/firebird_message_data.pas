unit firebird_message_data;

{$I .\sources\general.inc}

interface

{$REGION 'uses'}

uses
  SysUtils,
  Classes,
  DateUtils,
  firebird_api,
  firebird_types,
  firebird_variables,
  firebird_message_metadata;
{$ENDREGION}

type
  /// <summary>
  /// Данные обмена с сервером
  /// </summary>
  TMessagesData = class
  public type
    RMessage = record
    public type
      PMessage = ^RMessage;
    private
      function GetFbUtil: IUtil;
    private
      FMetadata: TMessageMetadataItem;
      FBuffer  : PByte;
      FParent  : TMessagesData;
    public
      procedure assign(const ASource: RMessage);
    public
      class function Create(AMetadata: TMessageMetadataItem; ABuffer: PByte; AParent: TMessagesData): RMessage; static;
      class operator Finalize(var aDest: RMessage);
    public
{$REGION 'Описание'}
      /// <summary>
      /// Возвращает указатель на данные
      /// </summary>
{$ENDREGION}
      function GetData: PByte;
    public
      function isNull: Boolean;
      procedure setNull(const ANullFlag: Boolean);
    public
      function getBoolean: Boolean;
      procedure setBoolean(const AValue: Boolean);
      function getSmallint: Smallint;
      procedure setSmallint(const AValue: Smallint);
      function getInteger: Integer;
      procedure setInteger(const AValue: Integer);
      function getBigint: Int64;
      procedure setBigint(const AValue: Int64);
      function getFloat: Single;
      procedure setFloat(const AValue: Single);
      function getDouble: Double;
      procedure setDouble(const AValue: Double);
      function getIscDate: ISC_DATE;
      procedure setIscDate(const AValue: ISC_DATE);
      function getIscTime: ISC_TIME;
      procedure setIscTime(const AValue: ISC_TIME);
      function getIscTimestamp: ISC_TIMESTAMP;
      procedure setIscTimestamp(const AValue: ISC_TIMESTAMP);
      function getDate: TDate;
      procedure setDate(const AValue: TDate);
      function getTime: TTime;
      procedure setTime(const AValue: TTime);
      function getTimestamp: TTimestamp;
      procedure setTimestamp(const AValue: TTimestamp);
      function getDateTime: TDateTime;
      procedure setDateTime(const AValue: TDateTime);
      function getString: string;
      procedure setString(const AValue: string);
      function getVariant: variant;
      function getObject: TObject;
      procedure setObject(const AValue: TObject);
    public
      property FbUtil: IUtil read GetFbUtil;
    public
      property Null: Boolean read isNull write setNull;
    public
      property AsBoolean     : Boolean read getBoolean write setBoolean;
      property AsSmallint    : Smallint read getSmallint write setSmallint;
      property AsInteger     : Integer read getInteger write setInteger;
      property AsBigint      : Int64 read getBigint write setBigint;
      property AsFloat       : Single read getFloat write setFloat;
      property AsDouble      : Double read getDouble write setDouble;
      property AsIscDate     : ISC_DATE read getIscDate write setIscDate;
      property AsIscTime     : ISC_TIME read getIscTime write setIscTime;
      property AsIscTimestamp: ISC_TIMESTAMP read getIscTimestamp write setIscTimestamp;
      property AsDate        : TDate read getDate write setDate;
      property AsTime        : TTime read getTime write setTime;
      property AsTimestamp   : TTimestamp read getTimestamp write setTimestamp;
      property AsDateTime    : TDateTime read getDateTime write setDateTime;
      property AsString      : string read getString write setString;
      property AsVariant     : variant read getVariant;
      property AsObject      : TObject read getObject write setObject;
    public
      property Metadata: TMessageMetadataItem read FMetadata;
      property Buffer  : PByte read FBuffer;
      property Parent  : TMessagesData read FParent;
    end;
  private
    FContext : IExternalContext;
    FMetadata: TMessageMetadata;
    FBuffer  : PByte;
    FStatus  : IStatus;
    function GetFbUtil: IUtil;
    function IscDateToDate(AValue: ISC_DATE): TDate;
    function IscTimeToTime(AValue: ISC_TIME): TTime;
    function IscTimestampToDateTime(AValue: ISC_TIMESTAMP): TDateTime;
    function IscTimestampToTimestamp(AValue: ISC_TIMESTAMP): TTimestamp;
    function DateToIscDate(AValue: TDate): ISC_DATE;
    function TimeToIscTime(AValue: TTime): ISC_TIME;
    function DateTimeToIscTimestamp(AValue: TDateTime): ISC_TIMESTAMP;
    function TimestampToIscTimestamp(AValue: TTimestamp): ISC_TIMESTAMP;
    function MessageDataGet(const AIndex: NativeUInt): RMessage;
  public
    constructor Create(AContext: IExternalContext; AMetadata: TMessageMetadata; ABuffer: PByte; AStatus: IStatus);
  public
{$REGION 'Описание'}
    /// <summary>
    /// Возвращает указатель на данные
    /// </summary>
{$ENDREGION}
    function GetDataByIndex(AIndex: Cardinal): PByte;
  public
    property MessageData[const AIndex: NativeUInt]: RMessage read MessageDataGet; default;
  public
    property Metadata: TMessageMetadata read FMetadata;
    property FbUtil  : IUtil read GetFbUtil;
  public
    property Context: IExternalContext read FContext;
    property Status : IStatus read FStatus;
    property Buffer : PByte read FBuffer;
  end;

implementation

uses
  firebird_blob;

resourcestring
  rsErrorCanNotConvertTo = 'Невозможно преобразовать %s в %s';
  rsBigInt = 'BIGINT';
  rsBoolean = 'Boolean';
  rsDouble = 'DOUBLE PRECISION';
  rsFloat = 'FLOAT';
  rsInteger = 'INTEGER';
  rsDate = 'DATE';
  rsTime = 'TIME';
  rsTimeStamp = 'TIMESTAMP';
  rsSmallInt = 'SMALLINT';
  rsStringTrancationChar = 'String trancation, expected char length %d, actual %d';
  rsStringTrancationByte = 'String trancation, expected byte length %d, actual %d';
  rsErrorFormatFloat = 'Неправильный формат дробного числа. %s';

  { TMessagesData }

constructor TMessagesData.Create(AContext: IExternalContext; AMetadata: TMessageMetadata; ABuffer: PByte; AStatus: IStatus);
begin
  FContext := AContext;
  FMetadata := AMetadata;
  FBuffer := ABuffer;
  FStatus := AStatus;
end;

function TMessagesData.DateTimeToIscTimestamp(AValue: TDateTime): ISC_TIMESTAMP;
var
  tmpYear  : Word;
  tmpMonth : Word;
  tmpDay   : Word;
  tmpHour  : Word;
  tmpMinute: Word;
  tmpSecond: Word;
  tmpMS    : Word;
begin
  DecodeDateTime(AValue, tmpYear, tmpMonth, tmpDay, tmpHour, tmpMinute, tmpSecond, tmpMS);
  Result.date := FbUtil.EncodeDate(tmpYear, tmpMonth, tmpDay);
  Result.time := FbUtil.EncodeTime(tmpHour, tmpMinute, tmpSecond, tmpMS * 10);
end;

function TMessagesData.DateToIscDate(AValue: TDate): ISC_DATE;
var
  tmpYear : Word;
  tmpMonth: Word;
  tmpDay  : Word;
begin
  DecodeDate(TDateTime(AValue), tmpYear, tmpMonth, tmpDay);
  Result := FbUtil.EncodeDate(tmpYear, tmpMonth, tmpDay);
end;

function TMessagesData.GetDataByIndex(AIndex: Cardinal): PByte;
begin
  Result := FBuffer + FMetadata[AIndex].Offset
end;

function TMessagesData.GetFbUtil: IUtil;
begin
  Result := FContext.getMaster().getUtilInterface();
end;

function TMessagesData.IscDateToDate(AValue: ISC_DATE): TDate;
var
  tmpYear : Cardinal;
  tmpMonth: Cardinal;
  tmpDay  : Cardinal;
begin
  FbUtil.DecodeDate(AValue, @tmpYear, @tmpMonth, @tmpDay);
  Result := EncodeDate(tmpYear, tmpMonth, tmpDay);
end;

function TMessagesData.IscTimestampToDateTime(AValue: ISC_TIMESTAMP): TDateTime;
var
  tmpYear     : Cardinal;
  tmpMonth    : Cardinal;
  tmpDay      : Cardinal;
  tmpHour     : Cardinal;
  tmpMinutes  : Cardinal;
  tmpSeconds  : Cardinal;
  tmpFractions: Cardinal;
begin
  FbUtil.DecodeDate(AValue.date, @tmpYear, @tmpMonth, @tmpDay);
  FbUtil.decodeTime(AValue.time, @tmpHour, @tmpMinutes, @tmpSeconds, @tmpFractions);
  Result := EncodeDateTime(tmpYear, tmpMonth, tmpDay, tmpHour, tmpMinutes, tmpSeconds, tmpFractions div 10);
end;

function TMessagesData.IscTimestampToTimestamp(AValue: ISC_TIMESTAMP): TTimestamp;
begin
  Result.date := AValue.date;
  Result.time := AValue.time div 10;
end;

function TMessagesData.IscTimeToTime(AValue: ISC_TIME): TTime;
var
  tmpHour     : Cardinal;
  tmpMinutes  : Cardinal;
  tmpSeconds  : Cardinal;
  tmpFractions: Cardinal;
begin
  FbUtil.decodeTime(AValue, @tmpHour, @tmpMinutes, @tmpSeconds, @tmpFractions);
  Result := EncodeTime(tmpHour, tmpMinutes, tmpSeconds, tmpFractions div 10);
end;

function TMessagesData.MessageDataGet(const AIndex: NativeUInt): RMessage;
begin
  Result := RMessage.Create(FMetadata[AIndex], GetDataByIndex(AIndex), Self);
end;

function TMessagesData.TimestampToIscTimestamp(AValue: TTimestamp): ISC_TIMESTAMP;
begin
  Result.date := AValue.date;
  Result.time := AValue.time * 10;
end;

function TMessagesData.TimeToIscTime(AValue: TTime): ISC_TIME;
var
  tmpHour  : Word;
  tmpMinute: Word;
  tmpSecond: Word;
  tmpMS    : Word;
begin
  decodeTime(TDateTime(AValue), tmpHour, tmpMinute, tmpSecond, tmpMS);
  Result := FbUtil.EncodeTime(tmpHour, tmpMinute, tmpSecond, tmpMS * 10);
end;

{ TMessagesData.RMessage }

procedure TMessagesData.RMessage.assign(const ASource: RMessage);
var
  tmpStream: TStream;
begin
  if ASource.isNull then
    Self.Null := True
  else
    case Metadata.SQLTypeEnum of
      SQL_VARYING, SQL_TEXT:
        AsString := ASource.AsString;

      SQL_FLOAT:
        AsFloat := ASource.AsFloat;

      SQL_DOUBLE, SQL_D_FLOAT:
        AsDouble := ASource.AsDouble;

      SQL_LONG:
        AsInteger := ASource.AsInteger;

      SQL_SHORT:
        AsSmallint := ASource.AsSmallint;

      SQL_INT64:
        AsBigint := ASource.AsBigint;

      SQL_BLOB, SQL_QUAD:
        begin
          tmpStream := TMemoryStream.Create;
          try
            QUADHelper.SaveToStream(ISC_QUADPtr(ASource.GetData), Parent.Status, Parent.Context, tmpStream);
            tmpStream.Position := 0;
            QUADHelper.LoadFromStream(Self, Parent.Status, Parent.Context, tmpStream)
          finally
            tmpStream.Destroy
          end;
        end;

      SQL_TIME:
        AsTime := ASource.AsTime;

      SQL_DATE:
        AsDate := ASource.AsDate;

      SQL_TIMESTAMP:
        AsDateTime := ASource.AsDateTime;

    else
      raise Exception.Create(format(rsErrorDataTypeNotSupportedFormat, [rsInputNominative, 2, Metadata.SQLTypeAsString]))
    end
end;

class function TMessagesData.RMessage.Create(AMetadata: TMessageMetadataItem; ABuffer: PByte; AParent: TMessagesData): RMessage;
begin
  Result.FMetadata := AMetadata;
  Result.FBuffer := ABuffer;
  Result.FParent := AParent;
end;

class operator TMessagesData.RMessage.Finalize(var aDest: RMessage);
begin
  with aDest do
  begin
    FMetadata := nil;
    FBuffer := nil;
    FParent := nil
  end
end;

function TMessagesData.RMessage.getDate: TDate;
begin
  Result := FParent.IscDateToDate(getIscDate);
end;

function TMessagesData.RMessage.getDateTime: TDateTime;
begin
  Result := FParent.IscTimestampToDateTime(getIscTimestamp);
end;

function TMessagesData.RMessage.getDouble: Double;
begin
  case FMetadata.SQLTypeEnum of
    SQL_SHORT:
      Result := getSmallint;

    SQL_LONG:
      Result := getInteger;

    SQL_INT64:
      Result := getBigint;

    SQL_FLOAT:
      Result := getFloat;

    SQL_DOUBLE:
      Result := PDouble(FBuffer)^;

    SQL_TEXT, SQL_VARYING:
      Result := Single.Parse(getString);

  else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [FMetadata.SQLTypeAsString, rsDouble]);
  end;
end;

function TMessagesData.RMessage.GetFbUtil: IUtil;
begin
  Result := FParent.Context.getMaster().getUtilInterface()
end;

function TMessagesData.RMessage.getFloat: Single;
begin
  case FMetadata.SQLTypeEnum of
    SQL_SHORT:
      Result := getSmallint;

    SQL_LONG:
      Result := getInteger;

    SQL_INT64:
      Result := getBigint;

    SQL_FLOAT:
      Result := PSingle(GetData)^;

    SQL_DOUBLE:
      Result := getDouble;

    SQL_TEXT, SQL_VARYING:
      Result := Single.Parse(getString);

  else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [FMetadata.SQLTypeAsString, rsFloat]);
  end;
end;

function TMessagesData.RMessage.getInteger: Integer;
begin
  case FMetadata.SQLTypeEnum of
    SQL_SHORT:
      Result := getSmallint;

    SQL_LONG:
      Result := PInteger(FBuffer)^;

    SQL_INT64:
      Result := getBigint;

    SQL_TEXT, SQL_VARYING:
      Result := Integer.Parse(getString);

  else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [FMetadata.SQLTypeAsString, rsInteger]);
  end;
end;

function TMessagesData.RMessage.getIscDate: ISC_DATE;
begin
  case FMetadata.SQLTypeEnum of
    SQL_DATE:
      Result := PISC_DATE(FBuffer)^;

    SQL_TIMESTAMP:
      Result := getIscTimestamp.date;

  else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [FMetadata.SQLTypeAsString, rsDate]);
  end;
end;

function TMessagesData.RMessage.getBigint: Int64;
begin
  case FMetadata.SQLTypeEnum of
    SQL_SHORT:
      Result := getSmallint;

    SQL_LONG:
      Result := getInteger;

    SQL_INT64:
      Result := PInt64(FBuffer)^;

    SQL_TEXT, SQL_VARYING:
      Result := Int64.Parse(getString);

  else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [FMetadata.SQLTypeAsString, rsBigInt]);
  end;
end;

function TMessagesData.RMessage.getBoolean: Boolean;
begin
  case FMetadata.SQLTypeEnum of
    SQL_BOOLEAN:
      Result := PBoolean(FBuffer)^;

    SQL_TEXT, SQL_VARYING:
      Result := Boolean.Parse(getString);

    SQL_SHORT:
      Result := Boolean(getSmallint);
  else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [FMetadata.SQLTypeAsString, rsBoolean]);
  end;
end;

function TMessagesData.RMessage.GetData: PByte;
begin
  Result := FBuffer
end;

function TMessagesData.RMessage.getIscTime: ISC_TIME;
begin
  case FMetadata.SQLTypeEnum of
    SQL_TIME:
      Result := PISC_TIME(FBuffer)^;

    SQL_TIMESTAMP:
      Result := getIscTimestamp.time;

  else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [FMetadata.SQLTypeAsString, rsTime]);
  end;
end;

function TMessagesData.RMessage.getIscTimestamp: ISC_TIMESTAMP;
var
  tmpTime: ISC_TIME;
  tmpDate: ISC_DATE;
begin
  case FMetadata.SQLTypeEnum of
    SQL_TIME:
      begin
        tmpTime := PISC_TIME(FBuffer)^;
        Result.date := FParent.DateToIscDate(date());
        Result.time := tmpTime;
      end;

    SQL_DATE:
      begin
        tmpDate := PISC_DATE(FBuffer)^;
        Result.date := tmpDate;
        Result.time := 0;
      end;

    SQL_TIMESTAMP:
      Result := PISC_TIMESTAMP(FBuffer)^;

  else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [FMetadata.SQLTypeAsString, rsDate]);
  end;
end;

function TMessagesData.RMessage.getObject: TObject;
begin
  if SizeOf(IntPtr) = 8 then
    Result := TObject(AsBigint)
  else
    Result := TObject(AsInteger)
end;

function TMessagesData.RMessage.getSmallint: Smallint;
begin
  case FMetadata.SQLTypeEnum of
    SQL_SHORT:
      Result := PSmallint(FBuffer)^;

    SQL_LONG:
      Result := getInteger;

    SQL_INT64:
      Result := getBigint;

    SQL_TEXT, SQL_VARYING:
      Result := Smallint.Parse(getString);

  else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [FMetadata.SQLTypeAsString, rsSmallInt]);
  end;
end;

function TMessagesData.RMessage.getString: string;
begin
  with FMetadata do
    case SQLTypeEnum of
      SQL_BOOLEAN:
        Result := getBoolean.ToString;

      SQL_SHORT:
        Result := getSmallint.ToString;

      SQL_LONG:
        Result := getInteger.ToString;

      SQL_INT64:
        Result := getBigint.ToString;

      SQL_FLOAT:
        Result := getFloat.ToString;

      SQL_DOUBLE:
        Result := getDouble.ToString;

      SQL_DATE:
        Result := DateToStr(getDate);

      SQL_TIME:
        Result := TimeToStr(getTime);

      SQL_TIMESTAMP:
        Result := DateToStr(getDateTime);

      SQL_VARYING:
        Result := Encoding.getString(TBytes(FBuffer + 2), 0, PWord(FBuffer)^);

      SQL_TEXT:
        begin
          Result := Encoding.getString(TBytes(FBuffer), 0, DataLength);
          SetLength(Result, DataLength);
        end;
    end;
end;

function TMessagesData.RMessage.getTime: TTime;
begin
  Result := FParent.IscTimeToTime(getIscTime);
end;

function TMessagesData.RMessage.getTimestamp: TTimestamp;
begin
  Result := FParent.IscTimestampToTimestamp(getIscTimestamp);
end;

function TMessagesData.RMessage.getVariant: variant;
begin
  Result := varNull;
  case FMetadata.SQLTypeEnum of
    SQL_BOOLEAN:
      Result := getBoolean;

    SQL_SHORT:
      Result := getSmallint;

    SQL_LONG:
      Result := getInteger;

    SQL_INT64:
      Result := getBigint;

    SQL_FLOAT:
      Result := getFloat;

    SQL_DOUBLE:
      Result := getDouble;

    SQL_DATE:
      Result := DateToStr(getDate);

    SQL_TIME:
      Result := TimeToStr(getTime);

    SQL_TIMESTAMP:
      Result := DateToStr(getDateTime);

    SQL_VARYING, SQL_TEXT:
      Result := getString;

  else
    raise Exception.Create(rsErrorDataTypeNotSupported);
  end;
end;

function TMessagesData.RMessage.isNull: Boolean;
begin
  Result := PWordBool(FBuffer + FMetadata.NullOffset - FMetadata.Offset)^
end;

procedure TMessagesData.RMessage.setNull(const ANullFlag: Boolean);
begin
  PWordBool(FBuffer + FMetadata.NullOffset - FMetadata.Offset)^ := ANullFlag
end;

procedure TMessagesData.RMessage.setBigint(const AValue: Int64);
begin
  case FMetadata.SQLTypeEnum of
    SQL_SHORT:
      setSmallint(AValue);

    SQL_LONG:
      setInteger(AValue);

    SQL_INT64:
      begin
        setNull(False);
        PInt64(FBuffer)^ := AValue;
      end;

    SQL_FLOAT:
      setFloat(AValue);

    SQL_DOUBLE, SQL_D_FLOAT:
      setDouble(AValue);

    SQL_TEXT, SQL_VARYING:
      setString(AValue.ToString)

  else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [rsBigInt, FMetadata.SQLTypeAsString])
  end;
end;

procedure TMessagesData.RMessage.setBoolean(const AValue: Boolean);
begin
  case FMetadata.SQLTypeEnum of
    SQL_BOOLEAN, SQL_SHORT:
      begin
        setNull(False);
        PBoolean(FBuffer)^ := AValue;
      end;
    SQL_TEXT, SQL_VARYING:
      if AValue then
        setString('True')
      else
        setString('False');

  else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [rsBoolean, FMetadata.SQLTypeAsString])
  end;
end;

procedure TMessagesData.RMessage.setDate(const AValue: TDate);
begin
  setIscDate(FParent.DateToIscDate(AValue));
end;

procedure TMessagesData.RMessage.setDateTime(const AValue: TDateTime);
begin
  setIscTimestamp(FParent.DateTimeToIscTimestamp(AValue));
end;

procedure TMessagesData.RMessage.setDouble(const AValue: Double);
begin
  case FMetadata.SQLTypeEnum of
    SQL_DOUBLE, SQL_D_FLOAT:
      begin
        setNull(False);
        PDouble(FBuffer)^ := AValue;
      end;

    SQL_FLOAT:
      setFloat(Single(AValue));

    SQL_TEXT, SQL_VARYING:
      setString(AValue.ToString());

  else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [rsDouble, FMetadata.SQLTypeAsString])
  end;
end;

procedure TMessagesData.RMessage.setFloat(const AValue: Single);
begin
  case FMetadata.SQLTypeEnum of
    SQL_FLOAT:
      begin
        setNull(False);
        PSingle(FBuffer)^ := AValue;
      end;

    SQL_DOUBLE, SQL_D_FLOAT:
      setDouble(AValue);

    SQL_TEXT, SQL_VARYING:
      setString(AValue.ToString())

  else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [rsFloat, FMetadata.SQLTypeAsString])
  end;
end;

procedure TMessagesData.RMessage.setInteger(const AValue: Integer);
begin
  case FMetadata.SQLTypeEnum of
    SQL_SHORT:
      setSmallint(AValue);

    SQL_LONG:
      begin
        setNull(False);
        PInteger(FBuffer)^ := AValue;
      end;

    SQL_INT64:
      setBigint(AValue);

    SQL_FLOAT:
      setFloat(AValue);

    SQL_DOUBLE, SQL_D_FLOAT:
      setDouble(AValue);

    SQL_TEXT, SQL_VARYING:
      setString(AValue.ToString())

  else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [rsInteger, FMetadata.SQLTypeAsString])
  end;
end;

procedure TMessagesData.RMessage.setIscDate(const AValue: ISC_DATE);
var
  tmpTimestamp: ISC_TIMESTAMP;
begin
  case FMetadata.SQLTypeEnum of
    SQL_DATE:
      begin
        setNull(False);
        PISC_DATE(FBuffer)^ := AValue;
      end;

    SQL_TIMESTAMP:
      begin
        tmpTimestamp.date := AValue;
        tmpTimestamp.time := 0;
        setIscTimestamp(tmpTimestamp);
      end;

  else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [rsDate, FMetadata.SQLTypeAsString])
  end;
end;

procedure TMessagesData.RMessage.setIscTime(const AValue: ISC_TIME);
var
  tmpTimestamp: ISC_TIMESTAMP;
begin
  case FMetadata.SQLTypeEnum of
    SQL_TIME:
      begin
        setNull(False);
        PISC_TIME(FBuffer)^ := AValue;
      end;

    SQL_TIMESTAMP:
      begin
        tmpTimestamp.date := FParent.DateToIscDate(date());
        tmpTimestamp.time := AValue;
        setIscTimestamp(tmpTimestamp);
      end;

  else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [rsTime, FMetadata.SQLTypeAsString])
  end;
end;

procedure TMessagesData.RMessage.setIscTimestamp(const AValue: ISC_TIMESTAMP);
begin
  case FMetadata.SQLTypeEnum of
    SQL_TIMESTAMP:
      begin
        setNull(False);
        PISC_TIMESTAMP(FBuffer)^ := AValue;
      end;

  else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [rsTimeStamp, FMetadata.SQLTypeAsString])
  end;
end;

procedure TMessagesData.RMessage.setObject(const AValue: TObject);
begin
  if SizeOf(IntPtr) = 8 then
    AsBigint := IntPtr(AValue)
  else
    AsInteger := IntPtr(AValue)
end;

procedure TMessagesData.RMessage.setSmallint(const AValue: Smallint);
begin
  case FMetadata.SQLTypeEnum of
    SQL_SHORT:
      begin
        setNull(False);
        PSmallint(FBuffer)^ := AValue;
      end;

    SQL_LONG:
      setInteger(AValue);

    SQL_INT64:
      setBigint(AValue);

    SQL_FLOAT:
      setFloat(AValue);

    SQL_DOUBLE, SQL_D_FLOAT:
      setDouble(AValue);

    SQL_TEXT, SQL_VARYING:
      setString(AValue.ToString());

  else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [rsSmallInt, FMetadata.SQLTypeAsString])
  end;
end;

procedure TMessagesData.RMessage.setString(const AValue: string);
var
  ValueBytes        : TBytes;
  ValueBuffer       : PByte;
  ValueStream       : TStream;
  ValueFloat        : Double;
  ValueFloatSettings: TFormatSettings;
begin
  // Null := False;
  Metadata.setNull(FParent.FBuffer, False);

  with FMetadata do
    case SQLTypeEnum of
      SQL_BOOLEAN:
        setBoolean(AValue.ToBoolean());

      SQL_SHORT:
        setSmallint(Smallint.Parse(AValue));

      SQL_LONG:
        setInteger(AValue.ToInteger());

      SQL_INT64:
        setInteger(Int64.Parse(AValue));

      SQL_FLOAT:
        setFloat(AValue.ToSingle());

      SQL_DOUBLE, SQL_D_FLOAT:
        begin
          if not TryStrToFloat(AValue, ValueFloat) then
          begin
            ValueFloatSettings := FormatSettings;
            ValueFloatSettings.DecimalSeparator := '.';
            if not TryStrToFloat(AValue, ValueFloat, ValueFloatSettings) then
              raise Exception.CreateFmt(rsErrorFormatFloat, [AValue]);
          end;
          setDouble(ValueFloat);
        end;

      SQL_TIME:
        setTime(StrToTime(AValue));

      SQL_DATE:
        setDate(StrToDate(AValue));

      SQL_TIMESTAMP:
        setDateTime(StrToDateTime(AValue));

      SQL_VARYING:
        begin
          if (Cardinal(Length(AValue)) > DataLength) then
            raise Exception.CreateFmt(rsStringTrancationChar, [DataLength, Length(AValue)])
          else
          begin
            ValueBytes := Encoding.GetBytes(AValue);
            ValueBuffer := FBuffer;
            PWord(ValueBuffer)^ := Word(Length(ValueBytes));
            if Length(ValueBytes) > DataLength then
              raise Exception.CreateFmt(rsStringTrancationChar, [DataLength, Length(ValueBytes)])
            else
              Move(ValueBytes[0], (ValueBuffer + 2)^, Length(ValueBytes));
          end;
        end;

      SQL_TEXT:
        begin
          if (Cardinal(Length(AValue)) > DataLength) then
            raise Exception.CreateFmt(rsStringTrancationChar, [DataLength, Length(AValue)])
          else
          begin
            ValueBytes := Encoding.GetBytes(AValue);
            if high(ValueBytes) > DataLength then
              raise Exception.CreateFmt(rsStringTrancationByte, [DataLength, high(ValueBytes)])
            else
            begin
              ValueBuffer := FBuffer;
              Move(ValueBytes[0], ValueBuffer^, high(ValueBytes));
            end;
          end;
        end;

      SQL_BLOB, SQL_QUAD:
        begin
          ValueStream := TMemoryStream.Create;
          try
            ValueBytes := Encoding.GetBytes(AValue);
            ValueStream.Write(ValueBytes, Length(ValueBytes));
            ValueStream.Position := 0;
            QUADHelper.LoadFromStream(Self, Parent.Status, Parent.Context, ValueStream);
          finally
            ValueStream.DisposeOf
          end;
        end;
    end;
end;

procedure TMessagesData.RMessage.setTime(const AValue: TTime);
begin
  setIscTime(FParent.TimeToIscTime(AValue));
end;

procedure TMessagesData.RMessage.setTimestamp(const AValue: TTimestamp);
begin
  setIscTimestamp(FParent.TimestampToIscTimestamp(AValue));
end;

end.
