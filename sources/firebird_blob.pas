unit firebird_blob;

{$I .\sources\general.inc}

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

  TFbBlobInfo = record
    ANumSegments: Int32;
    AMaxSegmentSize: Int32;
    TotalLength: Int32;
    ABlobType: SmallInt;
  end;

  BlobHelper = class helper for IBlob
  public
    function Read(AStatus: IStatus; var ABuffer; ACount: UInt32): UInt32;
  public
    function Write(AStatus: IStatus; const ABuffer; ACount: UInt32): UInt32;
  public
    procedure GetBlobInfo(AStatus: IStatus; var ANumSegments, AMaxSegmentSize, ATotalSize: Int32; var ABlobType: SmallInt);
  public
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// Загружает в BLOB содержимое потока <br />@param(AStatus Статус вектор) <br />@param(AStream Поток)
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    procedure LoadFromStream(AStatus: IStatus; AStream: TStream);
  public
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// Загружает в поток содержимое BLOB <br />@param(AStatus Статус вектор) <br />@param(AStream Поток)
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    procedure SaveToStream(AStatus: IStatus; AStream: TStream);
  end;

  QUADHelper = record // record helper for ISC_QUAD
  public
    class procedure Action(aIsRead: Boolean; AData: ISC_QUADPtr; AStatus: IStatus; AContext: IExternalContext; AStream: TStream;
      AProc: TProc<IBlob>); static;
  public
    class procedure SaveToStream(AData: ISC_QUADPtr; AStatus: IStatus; AContext: IExternalContext; AStream: TStream); overload; static;
    class function SaveToStream(AData: ISC_QUADPtr; AStatus: IStatus; AContext: IExternalContext): TStream; overload; static;
  public
    class procedure LoadFromStream(aMessage: TMessagesData.RMessage; AStatus: IStatus; AContext: IExternalContext; AStream: TStream); static;
  end;

implementation

uses
  Math;

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

{ BlobHelper }

procedure BlobHelper.GetBlobInfo(AStatus: IStatus; var ANumSegments, AMaxSegmentSize, ATotalSize: Int32; var ABlobType: SmallInt);
var
  tmpItems     : array [0 .. 3] of Byte;
  tmpResults   : array [0 .. 99] of Byte;
  tmpIndex     : Int32;
  tmpItemLength: Int32;
  tmpItem      : Int32;
begin
  tmpItems[0] := Byte(isc_info_blob_num_segments);
  tmpItems[1] := Byte(isc_info_blob_max_segment);
  tmpItems[2] := Byte(isc_info_blob_total_length);
  tmpItems[3] := Byte(isc_info_blob_type);

  Self.getInfo(AStatus, 4, @tmpItems[0], SizeOf(tmpResults), @tmpResults);

  tmpIndex := 0;
  while (tmpIndex < SizeOf(tmpResults)) and (tmpResults[tmpIndex] <> Byte(isc_info_end)) do
  begin
    tmpItem := Int32(tmpResults[tmpIndex]);
    Inc(tmpIndex);
    tmpItemLength := isc_portable_integer(@tmpResults[tmpIndex], 2);
    Inc(tmpIndex, 2);
    case tmpItem of
      isc_info_blob_num_segments:
        ANumSegments := isc_portable_integer(@tmpResults[tmpIndex], tmpItemLength);
      isc_info_blob_max_segment:
        AMaxSegmentSize := isc_portable_integer(@tmpResults[tmpIndex], tmpItemLength);
      isc_info_blob_total_length:
        ATotalSize := isc_portable_integer(@tmpResults[tmpIndex], tmpItemLength);
      isc_info_blob_type:
        ABlobType := isc_portable_integer(@tmpResults[tmpIndex], tmpItemLength);
    end;
    Inc(tmpIndex, tmpItemLength);
  end;

end;

procedure BlobHelper.LoadFromStream(AStatus: IStatus; AStream: TStream);
var
  tmpStreamSize: Int32;
  tmpReadLength: Int32;
  tmpBuffer    : TBytes;
begin
  tmpStreamSize := AStream.Size;
  AStream.Position := 0;
  SetLength(tmpBuffer, MAX_SEGMENT_SIZE);
  while tmpStreamSize <> 0 do
  begin
    tmpReadLength := Min(tmpStreamSize, MAX_SEGMENT_SIZE);
    tmpReadLength := AStream.Read(tmpBuffer, 0, tmpReadLength);
    Self.putSegment(AStatus, tmpReadLength, @tmpBuffer[0]);
    Dec(tmpStreamSize, tmpReadLength);
  end;
end;

function BlobHelper.Read(AStatus: IStatus; var ABuffer; ACount: UInt32): UInt32;
var
  tmpLocalLength: UInt32;
  tmpLocalBuffer: PByte;
  tmpBytesRead  : UInt32;
  tmpRetutnCode : Int32;
begin
  Result := 0;

  tmpLocalBuffer := PByte(@ABuffer);
  repeat
    tmpLocalLength := Min(ACount, MAX_SEGMENT_SIZE);
    tmpRetutnCode := Self.getSegment(AStatus, tmpLocalLength, tmpLocalBuffer, @tmpBytesRead);
    Inc(tmpLocalBuffer, tmpBytesRead);
    Inc(Result, tmpBytesRead);
    Dec(ACount, tmpBytesRead);
  until ((tmpRetutnCode <> IStatus.RESULT_OK) and (tmpRetutnCode <> IStatus.RESULT_SEGMENT)) or (ACount = 0);
end;

procedure BlobHelper.SaveToStream(AStatus: IStatus; AStream: TStream);
var
  tmpBuffer    : array [0 .. MAX_SEGMENT_SIZE] of Byte;
  tmpBytesRead : UInt32;
  tmpBufferSize: UInt32;
begin
  AStream.Position := 0;
  tmpBufferSize := Min(SizeOf(tmpBuffer), MAX_SEGMENT_SIZE);
  while True do
  begin
    case Self.getSegment(AStatus, tmpBufferSize, @tmpBuffer[0], @tmpBytesRead) of
      IStatus.RESULT_OK:
        AStream.WriteBuffer(tmpBuffer, tmpBytesRead);
      IStatus.RESULT_SEGMENT:
        AStream.WriteBuffer(tmpBuffer, tmpBytesRead);
    else
      break;
    end;
  end;
end;

function BlobHelper.Write(AStatus: IStatus; const ABuffer; ACount: UInt32): UInt32;
var
  tmpLocalBuffer: PByte;
  tmpLocalLength: UInt32;
begin
  Result := 0;
  if ACount > 0 then
  begin
    tmpLocalBuffer := PByte(@ABuffer);
    repeat
      tmpLocalLength := Min(ACount, MAX_SEGMENT_SIZE);
      Self.putSegment(AStatus, tmpLocalLength, tmpLocalBuffer);
      Inc(tmpLocalBuffer, tmpLocalLength);
      Inc(Result, tmpLocalLength);
      Dec(ACount, tmpLocalLength);
    until ACount <= 0;
  end;
end;

{ QUADHelper }

class procedure QUADHelper.Action(aIsRead: Boolean; AData: ISC_QUADPtr; AStatus: IStatus; AContext: IExternalContext; AStream: TStream;
  AProc: TProc<IBlob>);
var
  tmpBlob       : IBlob;
  tmpAttachment : IAttachment;
  tmpTransaction: ITransaction;
begin
  tmpAttachment := AContext.getAttachment(AStatus);
  try
    FbException.checkException(AStatus);
    tmpTransaction := AContext.getTransaction(AStatus);
    try
      FbException.checkException(AStatus);
      if aIsRead then
        tmpBlob := tmpAttachment.openBlob(AStatus, tmpTransaction, AData, 0, nil)
      else
        tmpBlob := tmpAttachment.createBlob(AStatus, tmpTransaction, AData, 0, nil);
      try
        FbException.checkException(AStatus);
        AProc(tmpBlob);
        FbException.checkException(AStatus);
      finally
        tmpBlob.close(AStatus);
      end;
    finally
      tmpTransaction.Release
    end;
  finally
    tmpAttachment.Release
  end;
end;

class procedure QUADHelper.LoadFromStream(aMessage: TMessagesData.RMessage; AStatus: IStatus; AContext: IExternalContext; AStream: TStream);
begin

  Action(False, ISC_QUADPtr(aMessage.GetData), AStatus, AContext, AStream,
    procedure(ABlob: IBlob)
    begin
      ABlob.LoadFromStream(AStatus, AStream);
    end);
  aMessage.Null := False;

end;

class function QUADHelper.SaveToStream(AData: ISC_QUADPtr; AStatus: IStatus; AContext: IExternalContext): TStream;
begin
  Result := TMemoryStream.Create;
  SaveToStream(AData, AStatus, AContext, Result)
end;

class procedure QUADHelper.SaveToStream(AData: ISC_QUADPtr; AStatus: IStatus; AContext: IExternalContext; AStream: TStream);
begin
  Action(True, AData, AStatus, AContext, AStream,
    procedure(ABlob: IBlob)
    begin
      ABlob.SaveToStream(AStatus, AStream);
      AStream.Position := 0;
    end)
end;

end.
