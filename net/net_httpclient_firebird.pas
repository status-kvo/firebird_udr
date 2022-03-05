unit net_httpclient_firebird;

{$I ..\..\include\general.inc}

interface

{$REGION 'uses'}
uses
  SysUtils,
  Classes,
  firebird_api,
  firebird_charset,
  firebird_types,
  firebird_variables,
  firebird_blob,
  firebird_classes,
  firebird_factories,
  firebird_message_metadata,
  firebird_message_data,
  Net.HttpClient,
  System.Net.Mime, //TMultipartFormData
  Net.URLClient;
{$ENDREGION}

type
  TProcedure = class abstract(TFactoryProcedureUniversal)
  protected
    class function ModuleGet: string; override;
  end;

  TFunction = class abstract(TFactoryFunctionUniversal)
  protected
    class function ModuleGet: string; override;
  end;

type
  TFactoryRequestCreate = class sealed(TFunction)
  private
    procedure AcceptedInvalidServerCertificate(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate; var Accepted: Boolean);
  protected
    procedure doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
    class function NameGet: string; override;
  end;

type
  TFactoryRequestHeaderValueGet = class sealed(TFunction)
  protected
    procedure doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
    class function NameGet: string; override;
  end;

type
  TFactoryRequestHeaderValuePut = class sealed(TFunction)
  protected
    procedure doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
    class function NameGet: string; override;
  end;

type
  TFactoryRequestUrlAddParameter = class sealed(TFunction)
  protected
    procedure doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
    class function NameGet: string; override;
  end;

type
  TFactoryMultipartFormDataCreate = class sealed(TFunction)
  protected
    procedure doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
    class function NameGet: string; override;
  end;

type
  TFormDataAddFieldS = class sealed(TFunction)
  protected
    procedure doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
    class function NameGet: string; override;
  end;

type
  TFormDataAddFieldB = class sealed(TFunction)
  protected
    procedure doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
    class function NameGet: string; override;
  end;

type
  TFormDataAddStreamB = class sealed(TFunction)
  protected
    procedure doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
    class function NameGet: string; override;
  end;

type
  TFactoryRequestContentPut = class sealed(TFunction)
  protected
    procedure doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
    class function NameGet: string; override;
  end;

type
  TFactoryExecute = class sealed(TProcedure)
  protected
    function  doOpen(AStatus: IStatus; AInput, AOutput: TMessagesData): IExternalResultSet; override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
    class function NameGet: string; override;
  end;

implementation

type
  THttpClientFB = class
  strict private
    FRequest : IHTTPRequest;
    FClient  : THttpClient;
    FForm    : TMultipartFormData;
    procedure FormSet(const AValue: TMultipartFormData);
  public
    property Request : IHTTPRequest read FRequest write FRequest;
    property Client  : THttpClient read FClient write FClient;
    property Form    : TMultipartFormData read FForm write FormSet;
  public
    constructor Create(const AMethod, AUrl: string);
    destructor  Destroy; override;
  end;

{ THttpClientFB }

constructor THttpClientFB.Create(const AMethod, AUrl: string);
begin
  inherited Create;
  FClient  := THTTPClient.Create;
  FRequest := FClient.GetRequest(AMethod, TURI.Create(AUrl));
  FForm    := nil;
end;

destructor THttpClientFB.Destroy;
begin
  FRequest := nil;
  FClient.Destroy;
  FForm.Free;
  inherited;
end;

procedure THttpClientFB.FormSet(const AValue: TMultipartFormData);
begin
  if FForm <> AValue then
  begin
    FForm.Free;
    FForm := AValue
  end;
end;

{ TFactoryRequestCreate }

procedure TFactoryRequestCreate.AcceptedInvalidServerCertificate(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate;
  var Accepted: Boolean);
begin
  Accepted := True;
end;

procedure TFactoryRequestCreate.doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
var
  Instance: THttpClientFB;
begin
  Instance:= THttpClientFB.Create(AInput[0].AsString.ToUpper, AInput[1].AsString);
  AOutput[0].AsBigint := Int64(Instance);
  if AInput[2].AsInteger <> 0 then
    Instance.Client.OnValidateServerCertificate := AcceptedInvalidServerCertificate;
end;

procedure TFactoryRequestCreate.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  BuilderSetVarChar(AStatus, AInput, 0);
  BuilderSetVarChar(AStatus, AInput, 1);
  BuilderSetBool(AStatus, AInput, 2);
  BuilderSetObject(AStatus, AOutput, 0)
end;

class function TFactoryRequestCreate.NameGet: string;
begin
  Result := 'CreateRequest'
end;

{ TFactoryRequestHeaderValueGet }

procedure TFactoryRequestHeaderValueGet.doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
var
  Instance: THttpClientFB;
begin
  Instance := THttpClientFB(AInput[0].AsBigint);
  AOutput[0].AsString := Instance.Request.HeaderValue[AInput[1].AsString];
end;

procedure TFactoryRequestHeaderValueGet.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  BuilderSetObject(AStatus, AInput, 0);
  BuilderSetVarChar(AStatus, AInput, 1);
  BuilderSetVarChar(AStatus, AOutput, 0)
end;

class function TFactoryRequestHeaderValueGet.NameGet: string;
begin
  Result := 'RequestHeaderValueGet'
end;

{ TFactoryRequestHeaderValuePut }

procedure TFactoryRequestHeaderValuePut.doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
var
  Instance: THttpClientFB;
begin
  Instance := THttpClientFB(AInput[0].AsBigint);
  Instance.Request.HeaderValue[AInput[1].AsString] := AInput[2].AsString;
  AOutput[0].AsInteger := 1;
end;

procedure TFactoryRequestHeaderValuePut.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  BuilderSetObject(AStatus, AInput, 0);
  BuilderSetVarChar(AStatus, AInput, 1);
  BuilderSetVarChar(AStatus, AInput, 2);
  BuilderSetBool(AStatus, AOutput, 0);
end;

class function TFactoryRequestHeaderValuePut.NameGet: string;
begin
  Result := 'RequestHeaderValuePut'
end;

{ TFactoryRequestUrlAddParameter }

procedure TFactoryRequestUrlAddParameter.doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
var
  Instance: THttpClientFB;
begin
  Instance := THttpClientFB(AInput[0].AsBigint);
  Instance.Request.URL.AddParameter(AInput[1].AsString, AInput[2].AsString);
  AOutput[0].AsInteger := 1;
end;

procedure TFactoryRequestUrlAddParameter.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  BuilderSetObject(AStatus, AInput, 0);
  BuilderSetVarChar(AStatus, AInput, 1);
  BuilderSetVarChar(AStatus, AInput, 2);
  BuilderSetBool(AStatus, AOutput, 0);
end;

class function TFactoryRequestUrlAddParameter.NameGet: string;
begin
  Result := 'UrlAddParameter'
end;

{ TFactoryMultipartFormDataCreate }

procedure TFactoryMultipartFormDataCreate.doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
var
  Instance: THttpClientFB;
begin
  Instance := THttpClientFB(AInput[0].AsBigint);
  Instance.Form := TMultipartFormData.Create;
  AOutput[0].AsBigint := Int64(Instance.Form)
end;

procedure TFactoryMultipartFormDataCreate.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  BuilderSetObject(AStatus, AInput, 0);
  BuilderSetObject(AStatus, AOutput, 0)
end;

class function TFactoryMultipartFormDataCreate.NameGet: string;
begin
  Result := 'CreateMultipartFormData'
end;

{ TFactoryRequestContentPut }

procedure TFactoryRequestContentPut.doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
var
  Instance: THttpClientFB;
  Stream: TStream;
begin
  Instance := THttpClientFB(AInput[0].AsBigint);
  Stream := QUADHelper.SaveToStream(ISC_QUADPtr(AInput.GetDataByIndex(1)), AStatus, AInput.Context);
  Instance.Request.SourceStream := Stream;
end;

procedure TFactoryRequestContentPut.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  BuilderSetObject(AStatus, AInput, 0);
  BuilderSetBlob(AStatus, AInput, 1);
  BuilderSetBool(AStatus, AOutput, 0)
end;

class function TFactoryRequestContentPut.NameGet: string;
begin
  Result := 'RequestContentPut'
end;

{ TFactoryExecute }

function TFactoryExecute.doOpen(AStatus: IStatus; AInput, AOutput: TMessagesData): IExternalResultSet;
var
  Instance  : THttpClientFB;
  Form      : TMultipartFormData;
  Source    : TStream;
  Responce  : IHTTPResponse;
begin
  Result := nil;

  Instance := THttpClientFB(AInput[0].AsBigint);
  if AInput[1].isNull then
    Form := nil
  else
    Form := TMultipartFormData(AInput[1].AsBigint);
  Source := Instance.Request.SourceStream;

  if assigned(Form) then
  begin
    if assigned(Source) then
    begin
      Source.Position := Source.Size;
      Source.CopyFrom(Form.Stream);
    end
    else
    begin
      Instance.Request.SourceStream := Form.Stream;
      Source := Instance.Request.SourceStream;
    end;
  end;

  if assigned(Source) then
    Source.Position := 0;
  try
    Responce := Instance.Client.Execute(Instance.Request);
    AOutput[0].AsInteger := Responce.StatusCode;
    AOutput[1].AsString := Responce.StatusText;

    if AOutput[1].AsString = ''  then
      exit;

    if Assigned(Responce.ContentStream) then
    begin
      Responce.ContentStream.Position := 0;
      AOutput[2].Null := false;
      QUADHelper.LoadFromStream(ISC_QUADPtr(AOutput.GetDataByIndex(2)), AStatus, AOutput.Context, Responce.ContentStream);
    end
    else
      AOutput[2].Null := True;
  except
    on E : Exception do
    begin
      AOutput[0].AsInteger := 520;
      AOutput[1].AsString := E.Message;
      AOutput[2].Null := True;
    end;
  end;

  Instance.Destroy;
end;

procedure TFactoryExecute.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  BuilderSetObject(AStatus, AInput, 0);
  BuilderSetObject(AStatus, AInput, 1);
  BuilderSetInt32(AStatus, AOutput, 0);
  BuilderSetVarChar(AStatus, AOutput, 1);
  BuilderSetBlob(AStatus, AOutput, 2)
end;

class function TFactoryExecute.NameGet: string;
begin
  Result := 'RequestExecute'
end;

{ TFormDataAddFieldS }

procedure TFormDataAddFieldS.doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
var
  Instance : TMultipartFormData;
begin
  Instance := TMultipartFormData(AInput[0].AsBigint);
  Instance.AddField(AInput[1].AsString, AInput[2].AsString);
  AOutput[0].AsInteger := 1;
end;

procedure TFormDataAddFieldS.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  BuilderSetObject(AStatus, AInput, 0);
  BuilderSetVarChar(AStatus, AInput, 1);
  BuilderSetVarChar(AStatus, AInput, 2);
  BuilderSetBool(AStatus, AOutput, 0)
end;

class function TFormDataAddFieldS.NameGet: string;
begin
  Result := 'FormDataAddFieldS'
end;

{ TFormDataAddFieldB }

procedure TFormDataAddFieldB.doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
var
  Instance : TMultipartFormData;
  Stream   : TStream;
  Buffer   : TBytes;
begin
  Instance := TMultipartFormData(AInput[0].AsBigint);
  Stream := QUADHelper.SaveToStream(ISC_QUADPtr(AInput.GetDataByIndex(2)), AStatus, AInput.Context);
  try
    SetLength(Buffer, Stream.Size);
    Stream.Position := 0;
    Stream.Read(Buffer, 0, Stream.Size);
    Instance.AddField(AInput[1].AsString, AInput.Metadata.Items[2].Encoding.GetString(Buffer))
  finally
    Stream.Destroy
  end;
end;

procedure TFormDataAddFieldB.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  BuilderSetObject(AStatus, AInput, 0);
  BuilderSetVarChar(AStatus, AInput, 1);
  BuilderSetBlob(AStatus, AInput, 2);
  BuilderSetBool(AStatus, AOutput, 0)
end;

class function TFormDataAddFieldB.NameGet: string;
begin
  Result := 'FormDataAddFieldB'
end;

{ TFormDataAddStreamB }

procedure TFormDataAddStreamB.doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
var
  Instance : TMultipartFormData;
  Stream   : TStream;
begin
  Instance := TMultipartFormData(AInput[0].AsBigint);
  Stream := QUADHelper.SaveToStream(ISC_QUADPtr(AInput.GetDataByIndex(2)), AStatus, AInput.Context);
  try
    Stream.Position := 0;
    Instance.AddStream(AInput[1].AsString, Stream, AInput[3].AsString, AInput[4].AsString);
    AOutput[0].AsInteger := 1;
  finally
    Stream.Destroy
  end;
end;

procedure TFormDataAddStreamB.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  BuilderSetObject(AStatus, AInput, 0);
  BuilderSetVarChar(AStatus, AInput, 1);
  BuilderSetBlob(AStatus, AInput, 2);
  BuilderSetVarChar(AStatus, AInput, 3);
  BuilderSetVarChar(AStatus, AInput, 4);
  BuilderSetBool(AStatus, AOutput, 0)
end;

class function TFormDataAddStreamB.NameGet: string;
begin
  Result := 'FormDataAddStreamB'
end;

procedure Register;
begin
  TFactoryMultipartFormDataCreate.Register;

  TFormDataAddFieldS.Register;
  TFormDataAddFieldB.Register;
  TFormDataAddStreamB.Register;

  TFactoryRequestCreate.Register;
  TFactoryRequestUrlAddParameter.Register;
  TFactoryRequestHeaderValueGet.Register;
  TFactoryRequestHeaderValuePut.Register;
  TFactoryRequestContentPut.Register;
  TFactoryExecute.Register;

//  AUdrPlugin.registerFunction(AStatus, 'Net.HTTP.RequestExecute',     net_httpclient_firebird.TFactoryRequestExecute.Create);
//  AUdrPlugin.registerFunction(AStatus, 'Net.HTTP.ResponseStatusCode', net_httpclient_firebird.TFactoryResponseStatusCode.Create);
//  AUdrPlugin.registerFunction(AStatus, 'Net.HTTP.ResponseStatusText', net_httpclient_firebird.TFactoryResponseStatusText.Create);
//  AUdrPlugin.registerFunction(AStatus, 'Net.HTTP.ResponseContent', net_httpclient_firebird.TFactoryResponseContent.Create);
//  AUdrPlugin.registerFunction(AStatus, 'Net.HTTP.ResponseContentToJson', net_httpclient_firebird.TFactoryResponseContentToJson.Create);
end;

{ TProcedure }

class function TProcedure.ModuleGet: string;
begin
  Result := 'Net.HTTP'
end;

{ TFunction }

class function TFunction.ModuleGet: string;
begin
  Result := 'Net.HTTP'
end;

initialization
  Register;

end.
