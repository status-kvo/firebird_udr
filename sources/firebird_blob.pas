unit firebird_blob;

{$I general.inc}

interface

{$REGION 'uses'}

uses
  Classes,
  SysUtils,
  firebird_api,
  firebird_message_data;
{$ENDREGION}

const
  MAX_SEGMENT_SIZE = $7FFF;

type
  TBlobType = (btSegmented, btStream);

  TFbBlobInfo = packed record
    NumSegments: Int64;
    MaxSegmentSize: Int64;
    TotalLength: Int64;
    BlobType: SmallInt;
  end;

type
  TStreamBlob = class sealed(TStream)
  private
    FStatus     : IStatus;
    FAttachment : IAttachment;
    FTransaction: ITransaction;
    FBlob       : IBlob;
    constructor Create(aIsRead: Boolean; AData: ISC_QUADPtr; AStatus: IStatus; AContext: IExternalContext); overload;
  public
    function Read(var ABuffer; ACount: Longint): Longint; override;
    function Write(const ABuffer; ACount: Longint): Longint; override;
    function Seek(const AOffset: Int64; AOrigin: TSeekOrigin): Int64; override;
    function GetSize: Int64; override;
  public
    procedure Cancel;
    function  BlobInfoGet: TFbBlobInfo;
  public
    class procedure Clone(const ASource, ATarger: TMessagesData.RMessage; AStatus: IStatus; AContext: IExternalContext); overload;
    class procedure Clone(const ASource: TMessagesData.RMessage; ATraget: TStream; AStatus: IStatus; AContext: IExternalContext); overload;
    class procedure BytesToMessage(const ABytes: TBytes; const ATarger: TMessagesData.RMessage; AStatus: IStatus; AContext: IExternalContext);
    class function  MessageToBytes(const ASource: TMessagesData.RMessage; AStatus: IStatus; AContext: IExternalContext): TBytes;
  public
    constructor Create(AStatus: IStatus; ABlob: IBlob); overload;
    constructor CreateRead(AData: ISC_QUADPtr; AStatus: IStatus; AContext: IExternalContext); virtual;
    constructor CreateWrite(AData: ISC_QUADPtr; AStatus: IStatus; AContext: IExternalContext; aNull: Boolean = False); virtual;

    destructor Destroy; override;
  end;

implementation

uses
  Math, firebird_classes;

const
  (* ************************ *)
  (* Blob information items *)
  (* ************************ *)
  isc_info_end               = 1;
  isc_info_truncated         = 2;
  isc_info_error             = 3;
  isc_info_blob_num_segments = 4;
  isc_info_blob_max_segment  = 5;
  isc_info_blob_total_length = 6;
  isc_info_blob_type         = 7;

resourcestring
  rsBlobNotCreate = 'Firebird IBlob is not create';
  rsBlobNotOperationNegative = 'Firebird IBlob is not support negative index';

function isc_portable_integer(const APtr: PByte; ALength: SmallInt): Int64;
var
  tmpValue: Int64;
  tmpShift: SmallInt;
  tmpIndex: SmallInt;
begin
  if assigned(APtr) then
    if ALength > 0 then
      if ALength <= SizeOf(Int64) then
      begin
        tmpValue := 0;
        tmpShift := 0;
        tmpIndex := 0;
        while ALength > 0 do
        begin
          tmpValue := tmpValue + (Int64((APtr + tmpIndex)^) shl tmpShift);
          Dec(ALength);
          Inc(tmpShift, 8);
          Inc(tmpIndex);
        end;

        Result := tmpValue;
      end
      else
        Result := 0
    else
      Result := 0
  else
    Result := 0
end;

{ TStreamBlob }

function TStreamBlob.BlobInfoGet: TFbBlobInfo;
var
  lItems     : array [0 .. 3] of Byte;
  lResults   : array [0 .. 99] of Byte;
  lIndex     : Int32;
  lItemLength: Int32;
  lItem      : Int32;
begin
  if FBlob = nil then
    raise Exception.Create(rsBlobNotCreate);

  lItems[0] := Byte(isc_info_blob_num_segments);
  lItems[1] := Byte(isc_info_blob_max_segment);
  lItems[2] := Byte(isc_info_blob_total_length);
  lItems[3] := Byte(isc_info_blob_type);

  fBlob.getInfo(FStatus, 4, @lItems[0], SizeOf(lResults), @lResults);

  lIndex := 0;
  while (lIndex < SizeOf(lResults)) and (lResults[lIndex] <> Byte(isc_info_end)) do
  begin
    lItem := Int32(lResults[lIndex]);
    Inc(lIndex);
    lItemLength := isc_portable_integer(@lResults[lIndex], 2);
    Inc(lIndex, 2);
    case lItem of
      isc_info_blob_num_segments:
        Result.NumSegments := isc_portable_integer(@lResults[lIndex], lItemLength);
      isc_info_blob_max_segment:
        Result.MaxSegmentSize := isc_portable_integer(@lResults[lIndex], lItemLength);
      isc_info_blob_total_length:
        Result.TotalLength := isc_portable_integer(@lResults[lIndex], lItemLength);
      isc_info_blob_type:
        Result.BlobType := isc_portable_integer(@lResults[lIndex], lItemLength);
    end;
    Inc(lIndex, lItemLength);
  end;
end;

procedure TStreamBlob.Cancel;
begin
  if FBlob <> nil then
    FBlob.cancel(FStatus)
end;

class procedure TStreamBlob.Clone(const ASource: TMessagesData.RMessage; ATraget: TStream; AStatus: IStatus; AContext: IExternalContext);
 var
  lSource: TStreamBlob;
begin
  lSource := nil;
  try
    lSource := TStreamBlob.CreateRead(ISC_QUADPtr(ASource.GetData), AStatus, AContext);
    ATraget.CopyFrom(lSource, lSource.Size);
  finally
    lSource.Free;
  end;
end;

class procedure TStreamBlob.Clone(const ASource, ATarger: TMessagesData.RMessage; AStatus: IStatus; AContext: IExternalContext);
 var
  lSource: TStreamBlob;
  lTarget: TStreamBlob;
begin
  lSource := nil;
  lTarget := nil;
  try
    lSource := TStreamBlob.CreateRead(ISC_QUADPtr(ASource.GetData), AStatus, AContext);
    lTarget := TStreamBlob.CreateWrite(ISC_QUADPtr(ATarger.GetData), AStatus, AContext);
    lTarget.CopyFrom(lSource, lSource.Size);
    ATarger.setNull(False);
  finally
    lSource.Free;
    lTarget.Free;
  end;
end;

class procedure TStreamBlob.BytesToMessage(const ABytes: TBytes; const ATarger: TMessagesData.RMessage; AStatus: IStatus; AContext: IExternalContext);
 var
  lTarger: TStreamBlob;
begin
  lTarger := nil;
  try
    lTarger := TStreamBlob.CreateWrite(ISC_QUADPtr(ATarger.GetData), AStatus, AContext);
    lTarger.Write(ABytes, Length(ABytes));
    ATarger.setNull(False);
  finally
    lTarger.Free;
  end;
end;

class function TStreamBlob.MessageToBytes(const ASource: TMessagesData.RMessage; AStatus: IStatus; AContext: IExternalContext): TBytes;
 var
  lSource: TStreamBlob;
begin
  lSource := nil;
  try
    lSource := TStreamBlob.CreateRead(ISC_QUADPtr(ASource.GetData), AStatus, AContext);
    SetLength(Result, lSource.Size);
    lSource.Read(Result, Length(Result));
  finally
    lSource.Free;
  end;
end;

constructor TStreamBlob.Create(AStatus: IStatus; ABlob: IBlob);
begin
  inherited Create;

  FStatus := AStatus;
  FBlob := ABlob;
end;

constructor TStreamBlob.Create(aIsRead: Boolean; AData: ISC_QUADPtr; AStatus: IStatus; AContext: IExternalContext);
 var
  lBlob: IBlob;
begin
  try
    FAttachment := AContext.getAttachment(AStatus);
    FbException.checkException(AStatus);
    FTransaction := AContext.getTransaction(AStatus);
    FbException.checkException(AStatus);
    if aIsRead then
      lBlob := FAttachment.openBlob(AStatus, FTransaction, AData, 0, nil)
    else
      lBlob := FAttachment.createBlob(AStatus, FTransaction, AData, 0, nil);
    FbException.checkException(AStatus);
    Create(AStatus, lBlob)
  except
    ReferenceCountedFree(FTransaction);
    ReferenceCountedFree(FAttachment);
    raise;
  end;
end;

constructor TStreamBlob.CreateRead(AData: ISC_QUADPtr; AStatus: IStatus; AContext: IExternalContext);
begin
  Create(True, AData, AStatus, AContext);
end;

constructor TStreamBlob.CreateWrite(AData: ISC_QUADPtr; AStatus: IStatus; AContext: IExternalContext; aNull: Boolean = False);
begin
  Create(False, AData, AStatus, AContext);
end;

destructor TStreamBlob.Destroy;
begin
  if FBlob <> nil then
  begin
    FBlob.close(FStatus);
    //ReferenceCountedFree(FBlob);
  end;

  ReferenceCountedFree(FTransaction);
  ReferenceCountedFree(FAttachment);

  FStatus := nil;

  inherited;
end;

function TStreamBlob.GetSize: Int64;
begin
  Result := Int64(BlobInfoGet.TotalLength)
end;

function TStreamBlob.Read(var ABuffer; ACount: Longint): Longint;
var
  lRead: Cardinal;
  lSize: Longint;
  lData: PByte;
begin
  if FBlob = nil then
    raise Exception.Create(rsBlobNotCreate);

  if ACount < 0 then
    raise Exception.Create(rsBlobNotOperationNegative);

  Result := 0;
  lData := @ABuffer;
  while ACount > 0 do
  begin
    lSize := Min(ACount, MAX_SEGMENT_SIZE);

    if not (FBlob.getSegment(FStatus, Cardinal(lSize), lData, lRead) in [IStatus.RESULT_OK, IStatus.RESULT_SEGMENT]) then
      break;

    Dec(ACount, Longint(lRead));
    Inc(lData, lRead);
    Inc(Result, Longint(lSize))
  end;
end;

function TStreamBlob.Write(const ABuffer; ACount: Longint): Longint;
var
  lSize: Longint;
  lData: PByte;
begin
  if FBlob = nil then
    raise Exception.Create(rsBlobNotCreate);

  if ACount < 0 then
    raise Exception.Create(rsBlobNotOperationNegative);

  Result := 0;
  lData := @ABuffer;
  while ACount > 0 do
  begin
    lSize := Min(ACount, MAX_SEGMENT_SIZE);
    FBlob.PutSegment(FStatus, Cardinal(lSize), lData);

    Dec(ACount, lSize);
    Inc(lData, lSize);
    Inc(Result, lSize)
  end;
end;

function TStreamBlob.Seek(const AOffset: Int64; AOrigin: TSeekOrigin): Int64;
 const
  CSegmentSize : Int64 = 16384;
 var
  LSegment: Int32;
  LFull: Int64;
begin
  if FBlob = nil then
    raise Exception.Create(rsBlobNotCreate);

  LFull := AOffset;
  Result := AOffset;
  repeat

    if LFull <= 0 then
      Exit;

    if LFull > CSegmentSize then
      LSegment := Int32(CSegmentSize)
    else
      LSegment := Int32(LFull);

    LSegment := FBlob.seek(FStatus, Int32(AOrigin), LSegment);
    Dec(LFull, Int64(LSegment));
    AOrigin := soCurrent;

  until LFull <> 0;
end;

end.
