unit stream_shared;

{$I general.inc}

interface

{$IFDEF UDR_HAS_STREAM_SHARED}

{$REGION 'uses'}

uses
  WinApi.Windows,
  System.SysUtils,
  System.Classes;
{$ENDREGION}

type
  TSharedStream = class sealed(TStream)
  private
    FMemory  : Pointer; // Указатель на данные
    FSize    : Int64;   // Реальный размер записанных данных
    FPageSize: Int64;   // Размер выделенной "страницы" под данные
    FPosition: Int64;   // Текущая позиция "курсора" на "странице"
    function MemoryNew(const ASizeOld: Int64): Pointer; overload;
    function MemoryNew(const ASizeOld: Int64; var ASizeNew: Int64): Pointer; overload;
  public
    constructor Create;
    destructor Destroy; override;
  public
    function Read(var ABuffer; ACount: LongInt): LongInt; override;
    function Write(const ABuffer; ACount: Integer): LongInt; override;
  public
    function Seek(const AOffset: Int64; AOrigin: TSeekOrigin): Int64; override;
    procedure SetSize(const ANew: Int64); override;
  public
    procedure LoadFromStream(AStream: TStream);
    procedure LoadFromFile(const AFileName: string);
  public
    procedure SaveToStream(AStream: TStream);
    procedure SaveToFile(const AFileName: string);
  public
    property Memory: Pointer read FMemory;
  end;

const
  SwapHandle = $FFFFFFFF; // Handle файла подкачки

{$ENDIF  UDR_HAS_STREAM_SHARED}

implementation

{$IFDEF UDR_HAS_STREAM_SHARED}

resourcestring
  CouldNotMapViewOfFile = 'Could not map view of file.';

const
  cSize1k = 1024000;

constructor TSharedStream.Create;
begin
  FPosition := 0;
  FSize := 0;
  FPageSize := cSize1k;
  FMemory := MemoryNew(0);
end;

destructor TSharedStream.Destroy;
begin
  UnmapViewOfFile(FMemory);
  inherited Destroy;
end;

function TSharedStream.Read(var ABuffer; ACount: LongInt): LongInt;
begin
  if ACount > 0 then
  begin
    Result := FSize - FPosition;
    if Result > 0 then
    begin
      if Result > ACount then
        Result := ACount;
      Move((PChar(FMemory) + FPosition)^, ABuffer, Result);
      Inc(FPosition, Result);
    end
  end
  else
    Result := 0
end;

function TSharedStream.Write(const ABuffer; ACount: Integer): LongInt;
var
  tmpI: Integer;
begin
  if ACount > 0 then
  begin
    tmpI := FPosition + ACount;
    if FSize < tmpI then
      Size := tmpI;
    System.Move(ABuffer, (PChar(FMemory) + FPosition)^, ACount);
    FPosition := tmpI;
    Result := ACount;
  end
  else
    Result := 0
end;

function TSharedStream.Seek(const AOffset: Int64; AOrigin: TSeekOrigin): Int64;
begin
  case AOrigin of
    soBeginning:
      FPosition := AOffset;
    soCurrent:
      Inc(FPosition, AOffset);
    soEnd:
      FPosition := FSize - AOffset;
  end;
  if FPosition > FSize then
    FPosition := FSize
  else if FPosition < 0 then
    FPosition := 0;
  Result := FPosition;
end;

procedure TSharedStream.SetSize(const ANew: Int64);
var
  tmpSizeNew  : Int64;
  tmpMemoryNew: Pointer;
begin
  inherited SetSize(ANew);
  if ANew > FPageSize then
  begin
    tmpMemoryNew := MemoryNew(ANew, tmpSizeNew);
    Move(FMemory^, tmpMemoryNew^, FSize);
    UnmapViewOfFile(FMemory);
    FMemory := tmpMemoryNew;
    FPageSize := tmpSizeNew;
  end;
  FSize := ANew;
  if FPosition > FSize then
    FPosition := FSize;
end;

procedure TSharedStream.LoadFromFile(const AFileName: string);
var
  tmpStream: TFileStream;
begin
  tmpStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(tmpStream)
  finally
    tmpStream.Destroy
  end
end;

procedure TSharedStream.LoadFromStream(AStream: TStream);
var
  tmpCount: Int64;
begin
  AStream.Position := 0;
  tmpCount := AStream.Size;
  SetSize(tmpCount);
  if tmpCount > 0 then
    AStream.Read(FMemory^, tmpCount);
end;

function TSharedStream.MemoryNew(const ASizeOld: Int64; var ASizeNew: Int64): Pointer;
var
  tmpHandleNew: THandle;
begin
  ASizeNew := ASizeOld + cSize1k;
  tmpHandleNew := CreateFileMapping(SwapHandle, nil, PAGE_READWRITE, 0, ASizeNew, nil);
  if tmpHandleNew = 0 then
    raise Exception.Create(CouldNotMapViewOfFile)
  else
    try
      Result := MapViewOfFile(tmpHandleNew, FILE_MAP_WRITE, 0, 0, ASizeNew);
      if Result = nil then
        raise Exception.Create(CouldNotMapViewOfFile);
    finally
      CloseHandle(tmpHandleNew);
    end
end;

function TSharedStream.MemoryNew(const ASizeOld: Int64): Pointer;
var
  tmpSizeNew: Int64;
begin
  tmpSizeNew := ASizeOld + cSize1k;
  Result := MemoryNew(ASizeOld, tmpSizeNew);
end;

procedure TSharedStream.SaveToFile(const AFileName: string);
var
  tmpStream: TFileStream;
begin
  tmpStream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveToStream(tmpStream)
  finally
    tmpStream.Destroy
  end
end;

procedure TSharedStream.SaveToStream(AStream: TStream);
begin
  AStream.Write(FMemory^, FSize);
end;

{$ENDIF  UDR_HAS_STREAM_SHARED}
end.
