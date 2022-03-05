unit firebird_charset;

{$I .\sources\general.inc}

interface

uses
  Classes,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF MSWINDOWS}
  SysUtils;

type
{$IFDEF NODEF}{$REGION 'ECharSet - Наборы символов Firebird'}{$ENDIF}
  /// <summary>
  /// Наборы символов Firebird
  /// </summary>
  ECharSet = (
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// No Character Set
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_NONE = 0,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// BINARY BYTES
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_BINARY = 1,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// ASCII
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_ASCII = 2,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// UNICODE in FSS format
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_UNICODE_FSS = 3,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// UTF-8
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_UTF8 = 4,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// SJIS
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_SJIS = 5,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// EUC-J
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_EUCJ = 6,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// JIS 0208; 1990
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_JIS_0208 = 7,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// UNICODE v 1.10
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_UNICODE_UCS2 = 8,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// DOS CP 737
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_DOS_737 = 9,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// DOS CP 437
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_DOS_437 = 10,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// DOS CP 850
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_DOS_850 = 11,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// DOS CP 865
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_DOS_865 = 12,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// DOS CP 860
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_DOS_860 = 13,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// DOS CP 863
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_DOS_863 = 14,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// DOS CP 775
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_DOS_775 = 15,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// DOS CP 858
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_DOS_858 = 16,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// DOS CP 862
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_DOS_862 = 17,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// DOS CP 864
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_DOS_864 = 18,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// NeXTSTEP OS native charset
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_NEXT = 19,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// ISO-8859.1
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_ISO8859_1 = 21,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// ISO-8859.2
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_ISO8859_2 = 22,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// ISO-8859.3
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_ISO8859_3 = 23,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// ISO-8859.4
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_ISO8859_4 = 34,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// ISO-8859.5
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_ISO8859_5 = 35,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// ISO-8859.6
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_ISO8859_6 = 36,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// ISO-8859.7
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_ISO8859_7 = 37,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// ISO-8859.8
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_ISO8859_8 = 38,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// ISO-8859.9
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_ISO8859_9 = 39,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// ISO-8859.13
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_ISO8859_13 = 40,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// KOREAN STANDARD 5601
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_KSC5601 = 44,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// DOS CP 852
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_DOS_852 = 45,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// DOS CP 857
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_DOS_857 = 46,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// DOS CP 861
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_DOS_861 = 47,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// DOS CP 866
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_DOS_866 = 48,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// DOS CP 869
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_DOS_869 = 49,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// Cyrilic
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_CYRL = 50,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// Windows cp 1250
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_WIN1250 = 51,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// Windows cp 1251
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_WIN1251 = 52,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// Windows cp 1252
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_WIN1252 = 53,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// Windows cp 1253
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_WIN1253 = 54,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// Windows cp 1254
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_WIN1254 = 55,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// Big Five unicode cs
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_BIG5 = 56,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// GB 2312-80 cs
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_GB2312 = 57,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// Windows cp 1255
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_WIN1255 = 58,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// Windows cp 1256
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_WIN1256 = 59,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// Windows cp 1257
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_WIN1257 = 60,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// UTF-16
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_UTF16 = 61,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// UTF-32
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_UTF32 = 62,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// Russian KOI8R
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_KOI8R = 63,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// Ukrainian KOI8U
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_KOI8U = 64,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// Windows cp 1258
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_WIN1258 = 65,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// TIS620
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_TIS620 = 66,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// GBK
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_GBK = 67,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// CP943C
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_CP943C = 68,
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// GB18030
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    CS_GB18030 = 69);
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}

type
{$IFDEF NODEF}{$REGION 'RCharsetMap - Маппиг наборов символов Firebird на кодовые страницы'}{$ENDIF}
  /// <summary>
  /// Маппиг наборов символов Firebird на кодовые страницы
  /// </summary>
  RCharsetMap = record
    CharsetID: Int32;
    CharSetName: AnsiString;
    CharSetWidth: UInt16;
    CodePage: Int32;
  end;
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}

type
  HCharset = record helper for ECharSet
  public
    function GetCharset: RCharsetMap;
    function GetCodePage: Int32;
    function GetCharWidth: UInt16;
    function GetCharSetName: string;
    function GetEncoding: TEncoding;
    function GetString(const ABytes: TBytes; AByteIndex, AByteCount: Int32): UnicodeString;
  end;

implementation

const
{$IFDEF NODEF}{$REGION 'CharSetMap - Массив приведение типа кодовой страницы'}{$ENDIF}
  /// <summary>
  /// Массив приведение типа кодовой страницы
  /// </summary>
  CharSetMap: array [0 .. 69] of RCharsetMap = ((CharsetID: 0; CharSetName: 'NONE'; CharSetWidth: 1; CodePage: CP_ACP), (CharsetID: 1;
    CharSetName: 'OCTETS'; CharSetWidth: 1; CodePage: CP_NONE), (CharsetID: 2; CharSetName: 'ASCII'; CharSetWidth: 1; CodePage: { CP_ASCII } CP_ACP),
    (CharsetID: 3; CharSetName: 'UNICODE_FSS'; CharSetWidth: 3; CodePage: CP_UTF8), (CharsetID: 4; CharSetName: 'UTF8'; CharSetWidth: 4;
    CodePage: CP_UTF8), (CharsetID: 5; CharSetName: 'SJIS_0208'; CharSetWidth: 2; CodePage: 20932), (CharsetID: 6; CharSetName: 'EUCJ_0208';
    CharSetWidth: 2; CodePage: 20932), (CharsetID: 7; CharSetName: 'Unknown'; CharSetWidth: 0; CodePage: CP_NONE), (CharsetID: 8;
    CharSetName: 'Unknown'; CharSetWidth: 0; CodePage: CP_NONE), (CharsetID: 9; CharSetName: 'DOS737'; CharSetWidth: 1; CodePage: 737),
    (CharsetID: 10; CharSetName: 'DOS437'; CharSetWidth: 1; CodePage: 437), (CharsetID: 11; CharSetName: 'DOS850'; CharSetWidth: 1; CodePage: 850),
    (CharsetID: 12; CharSetName: 'DOS865'; CharSetWidth: 1; CodePage: 865), (CharsetID: 13; CharSetName: 'DOS860'; CharSetWidth: 1; CodePage: 860),
    (CharsetID: 14; CharSetName: 'DOS863'; CharSetWidth: 1; CodePage: 863), (CharsetID: 15; CharSetName: 'DOS775'; CharSetWidth: 1; CodePage: 775),
    (CharsetID: 16; CharSetName: 'DOS858'; CharSetWidth: 1; CodePage: 858), (CharsetID: 17; CharSetName: 'DOS862'; CharSetWidth: 1; CodePage: 862),
    (CharsetID: 18; CharSetName: 'DOS864'; CharSetWidth: 1; CodePage: 864), (CharsetID: 19; CharSetName: 'NEXT'; CharSetWidth: 1; CodePage: CP_NONE),
    (CharsetID: 20; CharSetName: 'Unknown'; CharSetWidth: 0; CodePage: CP_NONE), (CharsetID: 21; CharSetName: 'ISO8859_1'; CharSetWidth: 1;
    CodePage: 28591), (CharsetID: 22; CharSetName: 'ISO8859_2'; CharSetWidth: 1; CodePage: 28592), (CharsetID: 23; CharSetName: 'ISO8859_3';
    CharSetWidth: 1; CodePage: 28593), (CharsetID: 24; CharSetName: 'Unknown'; CharSetWidth: 0; CodePage: CP_NONE), (CharsetID: 25;
    CharSetName: 'Unknown'; CharSetWidth: 0; CodePage: CP_NONE), (CharsetID: 26; CharSetName: 'Unknown'; CharSetWidth: 0; CodePage: CP_NONE),
    (CharsetID: 27; CharSetName: 'Unknown'; CharSetWidth: 0; CodePage: CP_NONE), (CharsetID: 28; CharSetName: 'Unknown'; CharSetWidth: 0;
    CodePage: CP_NONE), (CharsetID: 29; CharSetName: 'Unknown'; CharSetWidth: 0; CodePage: CP_NONE), (CharsetID: 30; CharSetName: 'Unknown';
    CharSetWidth: 0; CodePage: CP_NONE), (CharsetID: 31; CharSetName: 'Unknown'; CharSetWidth: 0; CodePage: CP_NONE), (CharsetID: 32;
    CharSetName: 'Unknown'; CharSetWidth: 0; CodePage: CP_NONE), (CharsetID: 33; CharSetName: 'Unknown'; CharSetWidth: 0; CodePage: CP_NONE),
    (CharsetID: 34; CharSetName: 'ISO8859_4'; CharSetWidth: 1; CodePage: 28594), (CharsetID: 35; CharSetName: 'ISO8859_5'; CharSetWidth: 1;
    CodePage: 28595), (CharsetID: 36; CharSetName: 'ISO8859_6'; CharSetWidth: 1; CodePage: 28596), (CharsetID: 37; CharSetName: 'ISO8859_7';
    CharSetWidth: 1; CodePage: 28597), (CharsetID: 38; CharSetName: 'ISO8859_8'; CharSetWidth: 1; CodePage: 28598), (CharsetID: 39;
    CharSetName: 'ISO8859_9'; CharSetWidth: 1; CodePage: 28599), (CharsetID: 40; CharSetName: 'ISO8859_13'; CharSetWidth: 1; CodePage: 28603),
    (CharsetID: 41; CharSetName: 'Unknown'; CharSetWidth: 0; CodePage: CP_NONE), (CharsetID: 42; CharSetName: 'Unknown'; CharSetWidth: 0;
    CodePage: CP_NONE), (CharsetID: 43; CharSetName: 'Unknown'; CharSetWidth: 0; CodePage: CP_NONE), (CharsetID: 44; CharSetName: 'KSC_5601';
    CharSetWidth: 2; CodePage: 949), (CharsetID: 45; CharSetName: 'DOS852'; CharSetWidth: 1; CodePage: 852), (CharsetID: 46; CharSetName: 'DOS857';
    CharSetWidth: 1; CodePage: 857), (CharsetID: 47; CharSetName: 'DOS861'; CharSetWidth: 1; CodePage: 861), (CharsetID: 48; CharSetName: 'DOS866';
    CharSetWidth: 1; CodePage: 866), (CharsetID: 49; CharSetName: 'DOS869'; CharSetWidth: 1; CodePage: 869), (CharsetID: 50; CharSetName: 'CYRL';
    CharSetWidth: 1; CodePage: 1251), (CharsetID: 51; CharSetName: 'WIN1250'; CharSetWidth: 1; CodePage: 1250), (CharsetID: 52;
    CharSetName: 'WIN1251'; CharSetWidth: 1; CodePage: 1251), (CharsetID: 53; CharSetName: 'WIN1252'; CharSetWidth: 1; CodePage: 1252),
    (CharsetID: 54; CharSetName: 'WIN1253'; CharSetWidth: 1; CodePage: 1253), (CharsetID: 55; CharSetName: 'WIN1254'; CharSetWidth: 1;
    CodePage: 1254), (CharsetID: 56; CharSetName: 'BIG_5'; CharSetWidth: 2; CodePage: 950), (CharsetID: 57; CharSetName: 'GB_2312'; CharSetWidth: 2;
    CodePage: 936), (CharsetID: 58; CharSetName: 'WIN1255'; CharSetWidth: 1; CodePage: 1255), (CharsetID: 59; CharSetName: 'WIN1256'; CharSetWidth: 1;
    CodePage: 1256), (CharsetID: 60; CharSetName: 'WIN1257'; CharSetWidth: 1; CodePage: 1257), (CharsetID: 61; CharSetName: 'Unknown';
    CharSetWidth: 0; CodePage: CP_NONE), (CharsetID: 62; CharSetName: 'Unknown'; CharSetWidth: 0; CodePage: CP_NONE), (CharsetID: 63;
    CharSetName: 'KOI8R'; CharSetWidth: 1; CodePage: 20866), (CharsetID: 64; CharSetName: 'KOI8U'; CharSetWidth: 1; CodePage: 21866), (CharsetID: 65;
    CharSetName: 'WIN1258'; CharSetWidth: 1; CodePage: 1258), (CharsetID: 66; CharSetName: 'TIS620'; CharSetWidth: 1; CodePage: 874), (CharsetID: 67;
    CharSetName: 'GBK'; CharSetWidth: 2; CodePage: 936), (CharsetID: 68; CharSetName: 'CP943C'; CharSetWidth: 2; CodePage: 943), (CharsetID: 69;
    CharSetName: 'GB18030'; CharSetWidth: 4; CodePage: 54936));
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
  { HCharset }

function HCharset.GetCharset: RCharsetMap;
begin
  Result := CharSetMap[Int32(Self)];
end;

function HCharset.GetCodePage: Int32;
begin
  Result := CharSetMap[Int32(Self)].CodePage;
end;

function HCharset.GetCharWidth: UInt16;
begin
  Result := CharSetMap[Int32(Self)].CharSetWidth;
end;

function HCharset.GetCharSetName: string;
begin
  Result := string(CharSetMap[Int32(Self)].CharSetName);
end;

function HCharset.GetEncoding: TEncoding;
begin
  Result := TEncoding.GetEncoding(CharSetMap[Int32(Self)].CodePage);
end;

function HCharset.GetString(const ABytes: TBytes; AByteIndex, AByteCount: Int32): UnicodeString;
var
  tmpEncoding: TEncoding;
begin
  tmpEncoding := GetEncoding;
  try
    Result := tmpEncoding.GetString(ABytes, AByteIndex, AByteCount);
  finally
    tmpEncoding.Destroy;
  end;
end;

end.
