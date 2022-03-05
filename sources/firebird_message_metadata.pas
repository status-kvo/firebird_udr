unit firebird_message_metadata;

{$I .\sources\general.inc}

interface

{$IFDEF NODEF}{$REGION 'uses'}{$ENDIF}

uses
  AnsiStrings,
  Classes,
  SysUtils,
  SysConst,
  System.Generics.Collections,
  firebird_api,
  firebird_types,
  firebird_charset;
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}

type
{$IFDEF NODEF}{$REGION 'TMessageMetadataItem - Элемент метаданных'}{$ENDIF}
  /// <summary>
  /// Элемент метаданных
  /// </summary>
  TMessageMetadataItem = class
  private
    FIndex       : Cardinal;
    FSQLType     : Cardinal;
    FSQLSubType  : Integer;
    FDataLength  : Cardinal;
    FNullable    : Boolean;
    FScale       : Integer;
    FCharSetID   : Cardinal;
    FRelationName: AnsiString;
    FFieldName   : AnsiString;
    FOwnerName   : AnsiString;
    FAliasName   : AnsiString;
    FOffset      : Cardinal;
    FNullOffset  : Cardinal;
    FEncoding    : TEncoding;
    function GetCharSetName: AnsiString;
    function GetCharSetWidth: Word;
    function GetCodePage: Integer;
    function GetMaxCharLength: Integer;
    function GetEncoding: TEncoding;
    function GetSQLTypeAsString: string;
    function getSqlTypeE: ESqlType;
  public
    constructor Create;
    destructor Destroy; override;
  public
{$IFDEF NODEF}{$REGION 'Получение данных'}{$ENDIF}
    function GetDataPtr(ABuffer: PByte): PByte;
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
  public
{$IFDEF NODEF}{$REGION 'Операции с NULL'}{$ENDIF}
    function GetNullPtr(ABuffer: PByte): PWordBool;
    function IsNull(ABuffer: PByte): Boolean;
    procedure SetNull(ABuffer: PByte; ANullFlag: Boolean);
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
  public
    function IsText(AAccessBlob: Boolean = False): Boolean;
  public
    function IsNumber: Boolean;
    function IsNumberNatural: Boolean;
    function IsNumberReal: Boolean;
  public
    function IsBlob: Boolean;
  public
    function IsDateTime: Boolean;
  public
    property SqlTypeEnum : ESqlType read getSqlTypeE;
    property SQLType     : Cardinal read FSQLType;
    property SQLSubType  : Integer read FSQLSubType;
    property DataLength  : Cardinal read FDataLength;
    property Nullable    : Boolean read FNullable;
    property Scale       : Integer read FScale;
    property CharsetID   : Cardinal read FCharSetID;
    property RelationName: AnsiString read FRelationName;
    property FieldName   : AnsiString read FFieldName;
    property OwnerName   : AnsiString read FOwnerName;
    property AliasName   : AnsiString read FAliasName;
    property Offset      : Cardinal read FOffset;
    property NullOffset  : Cardinal read FNullOffset;
    property index       : Cardinal read FIndex;
  public
    property CharSetName    : AnsiString read GetCharSetName;
    property CharSetWidth   : Word read GetCharSetWidth;
    property CodePage       : Integer read GetCodePage;
    property Encoding       : TEncoding read GetEncoding;
    property MaxCharLength  : Integer read GetMaxCharLength;
    property SQLTypeAsString: string read GetSQLTypeAsString;
  end;
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}

type
{$IFDEF NODEF}{$REGION 'TMessageMetadata - Метаданные'}{$ENDIF}
  /// <summary>
  /// Метаданные
  /// </summary>
  TMessageMetadata = class(TObjectList<TMessageMetadataItem>)
  private
    FMessageLength: Cardinal;
  public
    constructor Create(AStatus: IStatus; AMetadata: IMessageMetadata; AMetadataRelease: Boolean = False);
  public
    destructor Destroy; override;
  public
    procedure Fill(AStatus: IStatus; AMetadata: IMessageMetadata);
    property MessageLength: Cardinal read FMessageLength;
  end;
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}

type
  TRoutineMetadata = class sealed
  private
    FStatus      : IStatus;
    FPackage     : string;
    FName        : string;
    FEntryPoint  : string;
    FBody        : string;
    FInput       : TMessageMetadata;
    FOutput      : TMessageMetadata;
    FTrigger     : TMessageMetadata;
    FTriggerTable: string;
    FTriggerType : NativeUInt;
  public
    property package: string read FPackage;
  public
    property name: string read FName;
  public
    property EntryPoint: string read FEntryPoint;
  public
    property Body: string read FBody;
  public
    property Input: TMessageMetadata read FInput;
  public
    property Output: TMessageMetadata read FOutput;
  public
    property TriggerMetadata: TMessageMetadata read FTrigger;
  public
    property TriggerTable: string read FTriggerTable;
  public
    property TriggerType: NativeUInt read FTriggerType;
  public
    constructor Create; overload;
    constructor Create(AStatus: IStatus; ARoutineMetaData: IRoutineMetadata); overload;
  public
    destructor Destroy; override;
  end;

implementation

{ TMessageMetadataItem }

constructor TMessageMetadataItem.Create;
begin
  FEncoding := nil;
  SetLength(FRelationName, MAX_IDENTIFIER_LENGTH);
  SetLength(FFieldName, MAX_IDENTIFIER_LENGTH);
  SetLength(FOwnerName, MAX_IDENTIFIER_LENGTH);
  SetLength(FAliasName, MAX_IDENTIFIER_LENGTH);
end;

destructor TMessageMetadataItem.Destroy;
begin
  FEncoding.Free;
  inherited;
end;

function TMessageMetadataItem.GetCharSetName: AnsiString;
begin
  Result := AnsiString(ECharSet(FCharSetID).GetCharSetName);
end;

function TMessageMetadataItem.GetCharSetWidth: Word;
begin
  Result := ECharSet(FCharSetID).GetCharWidth;
end;

function TMessageMetadataItem.GetCodePage: Integer;
begin
  Result := ECharSet(FCharSetID).GetCodePage;
end;

function TMessageMetadataItem.GetDataPtr(ABuffer: PByte): PByte;
begin
  Result := ABuffer + FOffset;
end;

function TMessageMetadataItem.GetEncoding: TEncoding;
begin
  if not Assigned(FEncoding) then
    FEncoding := TEncoding.GetEncoding(CodePage);
  Result := FEncoding;
end;

function TMessageMetadataItem.GetMaxCharLength: Integer;
begin
  case ESqlType(FSQLSubType) of
    SQL_VARYING, SQL_TEXT:
      Result := FDataLength div CharSetWidth;
    SQL_BLOB, SQL_QUAD:
      Result := high(Integer);
  else
    Result := 0;
  end;
end;

function TMessageMetadataItem.GetNullPtr(ABuffer: PByte): PWordBool;
begin
  Result := PWordBool(ABuffer + FNullOffset);
end;

function TMessageMetadataItem.GetSQLTypeAsString: string;
begin
  case SqlTypeEnum of
    SQL_BOOLEAN:
      Result := 'BOOLEAN';

    SQL_SHORT:
      Result := 'SMALLINT'; // учесть масштаб

    SQL_LONG:
      Result := 'INTEGER'; // учесть масштаб

    SQL_INT64:
      if Scale = 0 then // в 3-м диалекте учитывается масштаб
        Result := 'BIGINT'
      else
        Result := 'NUMERIC(18, ' + Abs(Scale).ToString() + ')';

    SQL_FLOAT:
      Result := 'FLOAT';

    SQL_DOUBLE, SQL_D_FLOAT:
      if Scale = 0 then // в 1-м диалекте учитывается масштаб
        Result := 'DOUBLE PRECISION'
      else
        Result := 'NUMERIC(15, ' + Abs(Scale).ToString() + ')';

    SQL_DATE:
      Result := 'DATE';

    SQL_TIME:
      Result := 'TIME';

    SQL_TIMESTAMP:
      Result := 'TIMESTAMP';

    SQL_TEXT:
      begin
        Result := 'CHAR(' + MaxCharLength.ToString() + ')';
        if CharsetID <> 0 then
          Result := Result + ' CHARACTER SET ' + string(GetCharSetName());
      end;

    SQL_VARYING:
      begin
        Result := 'VARCHAR(' + MaxCharLength.ToString() + ')';
        if CharsetID <> 0 then
          Result := Result + ' CHARACTER SET ' + string(GetCharSetName());
      end;

    SQL_BLOB, SQL_QUAD:
      begin
        Result := 'BLOB';
        case SQLSubType of
          0:
            Result := Result + ' SUB_TYPE BINARY';
          1:
            begin
              Result := Result + ' SUB_TYPE TEXT';
              if CharsetID <> 0 then
                Result := Result + ' CHARACTER SET ' + string(GetCharSetName());
            end
        else
          Result := Result + ' SUB_TYPE ' + SQLSubType.ToString();
        end;
      end;
  end;
end;

function TMessageMetadataItem.getSqlTypeE: ESqlType;
begin
  Result := ESqlType(FSQLType)
end;

function TMessageMetadataItem.IsBlob: Boolean;
begin
  Result := (SqlTypeEnum = SQL_BLOB) or (SqlTypeEnum = SQL_QUAD)
end;

function TMessageMetadataItem.IsDateTime: Boolean;
begin
  Result := (SqlTypeEnum = SQL_TIME) or (SqlTypeEnum = SQL_DATE) or (SqlTypeEnum = SQL_TIMESTAMP)
end;

function TMessageMetadataItem.IsNull(ABuffer: PByte): Boolean;
begin
  Result := Boolean(GetNullPtr(ABuffer)^);
end;

function TMessageMetadataItem.IsNumber: Boolean;
begin
  Result := IsNumberNatural or IsNumberReal
end;

function TMessageMetadataItem.IsNumberNatural: Boolean;
begin
  Result := (SqlTypeEnum = SQL_LONG) or (SqlTypeEnum = SQL_SHORT) or (SqlTypeEnum = SQL_INT64)
end;

function TMessageMetadataItem.IsNumberReal: Boolean;
begin
  Result := (SqlTypeEnum = SQL_FLOAT) or (SqlTypeEnum = SQL_DOUBLE) or (SqlTypeEnum = SQL_D_FLOAT)
end;

function TMessageMetadataItem.IsText(AAccessBlob: Boolean): Boolean;
begin
  Result := (SqlTypeEnum = SQL_TEXT) or (SqlTypeEnum = SQL_VARYING) or (AAccessBlob and ((SqlTypeEnum = SQL_BLOB) or (SqlTypeEnum = SQL_QUAD)))
end;

procedure TMessageMetadataItem.SetNull(ABuffer: PByte; ANullFlag: Boolean);
begin
  GetNullPtr(ABuffer)^ := WordBool(ANullFlag);
end;

{ TFbMessageMetadata }

constructor TMessageMetadata.Create(AStatus: IStatus; AMetadata: IMessageMetadata; AMetadataRelease: Boolean);
begin
  inherited Create;
  Fill(AStatus, AMetadata);
  if AMetadataRelease then
    AMetadata.release;
end;

destructor TMessageMetadata.Destroy;
begin
  inherited;
end;

procedure TMessageMetadata.Fill(AStatus: IStatus; AMetadata: IMessageMetadata);
var
  tmpCount: NativeUInt;
  tmpIndex: NativeUInt;
  tmpItem : TMessageMetadataItem;
begin
  tmpCount := AMetadata.getCount(AStatus);
  FMessageLength := AMetadata.getMessageLength(AStatus);
  if tmpCount > 0 then
    for tmpIndex := 0 to Pred(tmpCount) do
    begin
      tmpItem := TMessageMetadataItem.Create;
      tmpItem.FIndex := tmpIndex;
      tmpItem.FRelationName := AMetadata.getRelation(AStatus, tmpIndex);
      tmpItem.FFieldName := AMetadata.getField(AStatus, tmpIndex);
      tmpItem.FOwnerName := AMetadata.getOwner(AStatus, tmpIndex);
      tmpItem.FAliasName := AMetadata.getAlias(AStatus, tmpIndex);
      tmpItem.FSQLType := AMetadata.getType(AStatus, tmpIndex);
      tmpItem.FNullable := AMetadata.isNullable(AStatus, tmpIndex);
      tmpItem.FSQLSubType := AMetadata.getSubType(AStatus, tmpIndex);
      tmpItem.FDataLength := AMetadata.getLength(AStatus, tmpIndex);
      tmpItem.FScale := AMetadata.getScale(AStatus, tmpIndex);
      tmpItem.FCharSetID := AMetadata.getCharSet(AStatus, tmpIndex);
      tmpItem.FOffset := AMetadata.getOffset(AStatus, tmpIndex);
      tmpItem.FNullOffset := AMetadata.getNullOffset(AStatus, tmpIndex);
      Add(tmpItem);
    end;
end;

{ TRoutineMetadata }

constructor TRoutineMetadata.Create;
begin
  raise Exception.Create('Нельзя создавать объект без параметров');
end;

constructor TRoutineMetadata.Create(AStatus: IStatus; ARoutineMetaData: IRoutineMetadata);
begin
  inherited Create;
  FStatus := AStatus;

  FPackage := string(AnsiStrings.StrPas(ARoutineMetaData.getPackage(FStatus)));
  FName := string(AnsiStrings.StrPas(ARoutineMetaData.getName(FStatus)));
  FEntryPoint := string(AnsiStrings.StrPas(ARoutineMetaData.getEntryPoint(FStatus)));
  FBody := string(AnsiStrings.StrPas(ARoutineMetaData.getBody(FStatus)));
  FInput := TMessageMetadata.Create(FStatus, ARoutineMetaData.getInputMetadata(FStatus), True);
  FOutput := TMessageMetadata.Create(FStatus, ARoutineMetaData.getOutputMetadata(FStatus), True);
  // FTrigger      := TMessageMetadata.Create(FStatus, ARoutineMetaData.getTriggerMetadata(FStatus), True);
  // FTriggerTable := String(AnsiStrings.StrPas(ARoutineMetaData.getTriggerTable(FStatus)));
  // FTriggerType  := NativeUInt(ARoutineMetaData.getTriggerType(FStatus));
  FBException.checkException(FStatus);
end;

destructor TRoutineMetadata.Destroy;
begin
  // FTrigger.Destroy;
  FOutput.Destroy;
  FInput.Destroy;

  inherited;
end;

end.
