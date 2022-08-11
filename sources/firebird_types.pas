unit firebird_types;

{$I general.inc}

interface

{$IFDEF NODEF}{$REGION 'uses'}{$ENDIF}

uses
  SysUtils,
  {$IFDEF FPC}
    base64,
  {$ELSE}
    NetEncoding,
  {$ENDIF}
  firebird_api,
  firebird_charset;
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}

type
  // типы Firebird
  ESqlType = (
{$IFDEF NODEF}{$REGION 'VARCHAR'}{$ENDIF}
    /// <summary>
    /// VARCHAR
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    SQL_VARYING = 448,
{$IFDEF NODEF}{$REGION 'CHAR'}{$ENDIF}
    /// <summary>
    /// CHAR
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    SQL_TEXT = 452,
{$IFDEF NODEF}{$REGION 'DOUBLE PRECISION'}{$ENDIF}
    /// <summary>
    /// DOUBLE PRECISION
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    SQL_DOUBLE = 480,
{$IFDEF NODEF}{$REGION 'FLOAT'}{$ENDIF}
    /// <summary>
    /// FLOAT
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    SQL_FLOAT = 482,
{$IFDEF NODEF}{$REGION 'INTEGER'}{$ENDIF}
    /// <summary>
    /// INTEGER - Целое число
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    SQL_LONG = 496,
{$IFDEF NODEF}{$REGION 'SMALLINT'}{$ENDIF}
    /// <summary>
    /// SMALLINT
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    SQL_SHORT = 500,
{$IFDEF NODEF}{$REGION 'TIMESTAMP'}{$ENDIF}
    /// <summary>
    /// TIMESTAMP
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    SQL_TIMESTAMP = 510,
{$IFDEF NODEF}{$REGION 'BLOB'}{$ENDIF}
    /// <summary>
    /// BLOB
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    SQL_BLOB = 520,
{$IFDEF NODEF}{$REGION 'DOUBLE PRECISION'}{$ENDIF}
    /// <summary>
    /// DOUBLE PRECISION
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    SQL_D_FLOAT = 530,
{$IFDEF NODEF}{$REGION 'ARRAY'}{$ENDIF}
    /// <summary>
    /// ARRAY
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    SQL_ARRAY = 540,
{$IFDEF NODEF}{$REGION 'BLOB_ID (QUAD)'}{$ENDIF}
    /// <summary>
    /// BLOB_ID (QUAD)
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    SQL_QUAD = 550,
{$IFDEF NODEF}{$REGION 'TIME'}{$ENDIF}
    /// <summary>
    /// TIME
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    SQL_TIME = 560,
{$IFDEF NODEF}{$REGION 'DATE'}{$ENDIF}
    /// <summary>
    /// DATE
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    SQL_DATE = 570,
{$IFDEF NODEF}{$REGION 'BIGINT'}{$ENDIF}
    /// <summary>
    /// BIGINT
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    SQL_INT64 = 580,
{$IFDEF NODEF}{$REGION 'BOOLEAN'}{$ENDIF}
    /// <summary>
    /// BOOLEAN
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    SQL_BOOLEAN = 32764,
{$IFDEF NODEF}{$REGION 'NULL'}{$ENDIF}
    /// <summary>
    /// NULL
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    SQL_NULL = 32766);

type
  // TIMESTAMP
  ISC_TIMESTAMP = record
    date: ISC_DATE;
    time: ISC_TIME;
  end;

  // указатели на специальные типы
  PISC_DATE = ^ISC_DATE;
  PISC_TIME = ^ISC_TIME;
  PISC_TIMESTAMP = ^ISC_TIMESTAMP;
  PISC_QUAD = ^ISC_QUAD;

type
  ISC_SMALLINT = -32768 .. 65535; // SMALLINT	2 bytes	Range from -32 768 to 32 767 (unsigned: from 0 to 65 535)

  TVarChar<T> = record
  public
    Length: Word;
    Value : T;
  strict private
    function SizeValueGet: NativeUInt; {$IFDEF RELEASE}inline; {$ENDIF}
    function SizeGet: NativeUInt; {$IFDEF RELEASE}inline; {$ENDIF}
  public
    function ToString(ACharSet: ECharSet): string; {$IFDEF RELEASE}inline; {$ENDIF}
  public
    property SizeValue: NativeUInt read SizeValueGet;
    property Size     : NativeUInt read SizeGet;
  end;

const
  MAX_IDENTIFIER_LENGTH = 31; // для 4.0 = 63 * 4 -1
  //
  // type
  // TFBType = NativeUInt;

type
  TFBBool = WordBool;
  PFBBool = ^TFBBool;

implementation

{ TVarChar<T> }

function TVarChar<T>.SizeGet: NativeUInt;
begin
  Result := SizeOf(Length) + SizeValueGet
end;

function TVarChar<T>.SizeValueGet: NativeUInt;
begin
  Result := Length * SizeOf(Value);
end;

function TVarChar<T>.ToString(ACharSet: ECharSet): string;
begin
  if ACharSet = CS_BINARY then
  begin
{$IFNDEF FPC}
    Result := TNetEncoding.base64.EncodeBytesToString(@Value, Length);
{$ELSE}
    Result := String(ACharSet.GetString(TBytes(@Value), 0, Length));
    Result := EncodeStringBase64(Result);
{$ENDIF}
  end
  else
    Result := String(ACharSet.GetString(TBytes(@Value), 0, Length));
end;

end.
