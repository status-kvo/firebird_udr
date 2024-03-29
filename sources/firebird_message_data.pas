﻿unit firebird_message_data;

{$I general.inc}

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
    public
      function getSmallint: Smallint;
      procedure setSmallint(const AValue: Smallint);
    public
      function getInteger: Integer;
      procedure setInteger(const AValue: Integer);
    public
      function getBigint: Int64;
      procedure setBigint(const AValue: Int64);
    public
      function getFloat: Single;
      procedure setFloat(const AValue: Single);
    public
      function getDouble: Double;
      procedure setDouble(const AValue: Double);
    public
      function getDate: TDate;
      procedure setDate(const AValue: TDate);
    public
      function getTime: TTime;
      procedure setTime(const AValue: TTime);
    public
      function getTimestamp: TTimestamp;
      procedure setTimestamp(const AValue: TTimestamp);
    public
      function getDateTime: TDateTime;
      procedure setDateTime(const AValue: TDateTime);
    public
      function getString: string;
      procedure setString(const AValue: string);
    public
      function getVariant: variant;
    public
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
    function DateToIscDate(AValue: TDate): ISC_DATE;
    function TimeToIscTime(AValue: TTime): ISC_TIME;
    function DateTimeToIscTimestamp(AValue: TDateTime): ISC_TIMESTAMP;
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
  FbUtil.DecodeTime(AValue.time, @tmpHour, @tmpMinutes, @tmpSeconds, @tmpFractions);
  Result := EncodeDateTime(tmpYear, tmpMonth, tmpDay, tmpHour, tmpMinutes, tmpSeconds, tmpFractions div 10);
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
        TStreamBlob.Clone(ASource, Self, Parent.Status, Parent.Context);

      SQL_TIME:
        AsTime := ASource.AsTime;

      SQL_DATE:
        AsDate := ASource.AsDate;

      SQL_TIMESTAMP:
        AsDateTime := ASource.AsDateTime;

    else
      raise Exception.CreateFmt(rsErrorDataTypeNotSupportedFormat, [rsInputNominative, 2, Metadata.SQLTypeAsString])
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

function TMessagesData.RMessage.getTime: TTime;
begin
  Result := TTime(AsDateTime)
end;

function TMessagesData.RMessage.getTimestamp: TTimestamp;
begin
  Result := DateTimeToTimeStamp(AsDateTime)
end;

function TMessagesData.RMessage.getDate: TDate;
begin
  Result := TDate(AsDateTime)
end;

function TMessagesData.RMessage.getDateTime: TDateTime;
begin
  case FMetadata.SQLTypeEnum of
    SQL_TIME:
      Result := TDateTime(FParent.IscTimeToTime(PISC_TIME(FBuffer)^));
    SQL_DATE:
      Result := TDateTime(FParent.IscDateToDate(PISC_DATE(FBuffer)^));
    SQL_TIMESTAMP:
      Result := FParent.IscTimestampToDateTime(PISC_TIMESTAMP(FBuffer)^);
   else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [FMetadata.SQLTypeAsString, rsDate]);
  end;
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
      PBoolean(FBuffer)^ := AValue;
    SQL_TEXT, SQL_VARYING:
      if AValue then
        setString('True')
      else
        setString('False');
   else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [rsBoolean, FMetadata.SQLTypeAsString])
  end;
  setNull(False);
end;

procedure TMessagesData.RMessage.setTimestamp(const AValue: TTimestamp);
begin
  AsDateTime := TimestampToDateTime(AValue)
end;

procedure TMessagesData.RMessage.setTime(const AValue: TTime);
begin
  AsDateTime := TDateTime(AValue)
end;

procedure TMessagesData.RMessage.setDate(const AValue: TDate);
begin
  AsDateTime := TDateTime(AValue)
end;

procedure TMessagesData.RMessage.setDateTime(const AValue: TDateTime);
begin
  case FMetadata.SQLTypeEnum of
    SQL_TIME:
      PISC_TIME(FBuffer)^ := FParent.TimeToIscTime(TTime(AValue));
    SQL_DATE:
      PISC_DATE(FBuffer)^ := FParent.DateToIscDate(TDate(AValue));
    SQL_TIMESTAMP:
      PISC_TIMESTAMP(FBuffer)^ := FParent.DateTimeToIscTimestamp(TDateTime(AValue));
   else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [rsTime, FMetadata.SQLTypeAsString])
  end;
  setNull(False);
end;

procedure TMessagesData.RMessage.setDouble(const AValue: Double);
begin
  case FMetadata.SQLTypeEnum of
    SQL_DOUBLE, SQL_D_FLOAT:
      PDouble(FBuffer)^ := AValue;
    SQL_FLOAT:
      setFloat({$IFDEF FPC}AValue{$ELSE}Single(AValue){$ENDIF});
    SQL_TEXT, SQL_VARYING:
      setString(AValue.ToString());
   else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [rsDouble, FMetadata.SQLTypeAsString])
  end;
  setNull(False);
end;

procedure TMessagesData.RMessage.setFloat(const AValue: Single);
begin
  case FMetadata.SQLTypeEnum of
    SQL_FLOAT:
      PSingle(FBuffer)^ := AValue;
    SQL_DOUBLE, SQL_D_FLOAT:
      setDouble(AValue);
    SQL_TEXT, SQL_VARYING:
      setString(AValue.ToString())
   else
    raise Exception.CreateFmt(rsErrorCanNotConvertTo, [rsFloat, FMetadata.SQLTypeAsString])
  end;
  setNull(False);
end;

procedure TMessagesData.RMessage.setInteger(const AValue: Integer);
begin
  case FMetadata.SQLTypeEnum of
    SQL_SHORT:
      setSmallint(AValue);
    SQL_LONG:
      PInteger(FBuffer)^ := AValue;
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
  setNull(False);
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

      SQL_TIME, SQL_DATE, SQL_TIMESTAMP:
        AsDateTime := StrToDateTime(AValue);

      SQL_VARYING:
        begin
          if (Cardinal(Length(AValue)) > DataLength) then
            raise Exception.CreateFmt(rsStringTrancationChar, [DataLength, Length(AValue)])
          else
          begin
            ValueBytes := Encoding.GetBytes(AValue);
            ValueBuffer := FBuffer;
            PWord(ValueBuffer)^ := Word(Length(ValueBytes));
            if Length(ValueBytes) > Integer(DataLength) then
              raise Exception.CreateFmt(rsStringTrancationChar, [DataLength, Length(ValueBytes)])
            else
              Move(ValueBytes[0], (ValueBuffer + 2)^, Length(ValueBytes));
          end;
        end;

      SQL_TEXT:
        begin
          if (Length(AValue) > Integer(DataLength)) then
            raise Exception.CreateFmt(rsStringTrancationChar, [DataLength, Length(AValue)])
          else
          begin
            ValueBytes := Encoding.GetBytes(AValue);
            if high(ValueBytes) > Integer(DataLength) then
              raise Exception.CreateFmt(rsStringTrancationByte, [DataLength, high(ValueBytes)])
            else
            begin
              ValueBuffer := FBuffer;
              Move(ValueBytes[0], ValueBuffer^, high(ValueBytes));
            end;
          end;
        end;

      SQL_BLOB, SQL_QUAD:
        TStreamBlob.BytesToMessage(Encoding.GetBytes(AValue), Self, Parent.Status, Parent.Context);

    end;
end;

end.
