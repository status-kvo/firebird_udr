unit xml_firebird_classes;

{$I ..\include\general.inc}

interface

{$IFDEF UDR_HAS_XML}
uses
  firebird_api;

type
  TUdrRegisterXML = record
    class procedure &Register(AStatus: IStatus; AUdrPlugin: IUdrPlugin); static;
  end;
{$ENDIF  UDR_HAS_XML}

implementation

{$IFDEF UDR_HAS_XML}

{$REGION 'uses'}

uses
  SysUtils,
  Classes,

  {$IFDEF XML_INSIDE}
  Xml.omnixmldom,
  {$ELSE  XML_INSIDE}
  Xml.Win.msxmldom,
  {$ENDIF XML_INSIDE}
  Xml.xmldom,
  Xml.xmlutil,
  Xml.XMLConst,

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

type
  TAdapterNode = class sealed(TAdapter<IDOMNode>);

type
  TAdapterDocumentCustom = class abstract(TAdapter<IDOMDocument>);

type
  TAdapterDocument = class sealed(TAdapterDocumentCustom);

type
  TAdapterDocumentCreator = class sealed(TAdapterDocumentCustom)
  protected
    procedure DoCreate; override;
  end;

type
  TSerializationText = class sealed(TFunctionOutInstance<string, TAdapterDocument>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TSerializationBlob = class sealed(TFunctionOutInstance<IBlob, TAdapterDocument>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TDeSerializationText = class sealed(TFunctionIn0Instance<TAdapterNode, string>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

type
  TDeSerializationBlob = class sealed(TFunctionIn0Instance<TAdapterNode, IBlob>)
  protected
    function doExecute(const AParams: RExecuteParams): Boolean; override;
  end;

{ TUdrRegisterStream }

class procedure TUdrRegisterXML.Register(AStatus: IStatus; AUdrPlugin: IUdrPlugin);
begin
  AUdrPlugin.registerFunction(AStatus, 'XmlSerializationText', TSerializationText.Factory);
  AUdrPlugin.registerFunction(AStatus, 'XmlSerializationBlob', TSerializationBlob.Factory);

  AUdrPlugin.registerFunction(AStatus, 'XmlDeSerializationText', TDeSerializationText.Factory);
  AUdrPlugin.registerFunction(AStatus, 'XmlDeSerializationBlob', TDeSerializationBlob.Factory);

  AUdrPlugin.registerFunction(AStatus, 'XmlCreateDocument', TObjectCreator<TAdapterDocumentCreator>.Factory);
end;

{ TDeSerializationBlob }

function TDeSerializationBlob.doExecute(const AParams: RExecuteParams): Boolean;
begin
  Result := inherited;
  TStreamBlob.BytesToMessage(TEncoding.ANSI.GetBytes(string(FInstanceIn.Child.nodeValue)), FOutput, AParams.FStatus, AParams.FOutput.Context)
end;

{ TDeSerializationText }

function TDeSerializationText.doExecute(const AParams: RExecuteParams): Boolean;
begin
  Result := inherited;
  FOutput.AsString := string(FInstanceIn.Child.nodeValue)
end;

{ TSerializationBlob }

procedure DocParseError(aDoc: IDOMDocument);
var
  Line, LinePos: Integer;
  ErrMsg, Reason, Url: string;
  ParseError: IDOMParseError;
begin
  ErrMsg := '';
  ParseError := (aDoc as IDomParseError);
  if ParseError.errorCode <> 0 then
  begin
    Line := ParseError.Line;
    Linepos := ParseError.LinePos;
    Reason := ParseError.Reason;
    Url := ParseError.url;
    ErrMsg := Format(sReason, [Reason ]);
    if Line > 0 then
    begin
      ErrMsg := ErrMsg + Format(sLinePosError,[Line, LinePos, URL]);
    end;
    ErrMsg := sXMLParseError  + ErrMsg;
    raise DomException.Create(ErrMsg);
  end;
end;

function LoadDocFromStream(aStream: TStream): IDOMDocument;
begin
  Result := GetDom.createDocument('', '', nil);
  (Result as IDOMParseoptions).validate:= false;
  (Result as IDomPersist).LoadFromStream(aStream);
  if (Result as IDOMParseError).errorCode <> 0 then
  begin
    DocParseError(Result);
    Result:= nil;
  end;
end;

function TSerializationBlob.doExecute(const AParams: RExecuteParams): Boolean;
var
  Blob: TStream;
  Doc: IDOMDocument;
begin
  inherited;

  if FIn0.Null then
    raise Exception.Create(rsErrorNullOrEmpty)
  else
  begin
    Blob := nil;
    try
      Blob := TStreamBlob.CreateRead(ISC_QUADPtr(FIn0.GetData), AParams.FStatus, AParams.FInput.Context);
      if (Blob.Size > 0) then
      begin
        Doc := LoadDocFromStream(Blob);
        FOutput.AsObject := TAdapterNode.Create(Doc.DocumentElement);
        RLibraryHeapManager.Add(FOutput.AsObject, AParams.FParent);
        Result := True
      end
      else
        raise Exception.Create(rsErrorNullOrEmpty);
    finally
      Blob.Free
    end;
  end
end;

{ TSerializationText }

function TSerializationText.doExecute(const AParams: RExecuteParams): Boolean;
var
  Value: string;
  Doc: IDOMDocument;
begin
  inherited;

  Value := FIn0.AsString;
  if Value = '' then
    raise Exception.Create(rsErrorNullOrEmpty)
  else
  begin
    Doc := LoadDocFromString(Value);
    FOutput.AsObject := TAdapterNode.Create(Doc.DocumentElement);
    RLibraryHeapManager.Add(FOutput.AsObject, AParams.FParent);
    Result := True
  end
end;

{ TAdapterDocumentCreator }

procedure TAdapterDocumentCreator.DoCreate;
begin
  inherited;
  FChild := GetDom.createDocument('', '', nil)
end;

{$ENDIF  UDR_HAS_XML}
end.
