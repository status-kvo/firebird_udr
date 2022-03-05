unit firebird_factories;

{$I .\sources\general.inc}

interface

{$REGION 'uses'{$ENDIF}

uses
  SysUtils,
  TypInfo,
  firebird_api,
  firebird_types,
  firebird_charset,
  firebird_message_metadata,
  firebird_message_data;
{$ENDREGION}

type
  RExecuteParams = record
  public
    FStatus: IStatus;
    FInput : TMessagesData;
    FOutput: TMessagesData;
    FParent: TObject;
  public
    constructor Create(AStatus: IStatus; AInput, AOutput: TMessagesData; AParent: TObject);
    class operator Finalize(var aDest: RExecuteParams);
  end;

type
  RSetupParams = record
  public
    FStatus  : IStatus;
    FMetadata: TRoutineMetadata;
    FInput   : IMetadataBuilder;
    FOutput  : IMetadataBuilder;
    FParent  : TObject;
  public
    constructor Create(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder; AParent: TObject);
    class operator Finalize(var aDest: RSetupParams);
  end;

type
  TExternalFunctionBase = class abstract(IExternalFunctionImpl)
  public
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// Вызывается при уничтожении экземпляра функции
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    procedure dispose; override;
  public
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// Этот метод вызывается непосредственно перед execute и сообщает <br />ядру наш запрошенный набор символов для обмена данными внутри <br />
    /// этого метода. Во время этого вызова контекст использует набор символов, <br />полученный из ExternalEngine::getCharSet. <br />
    /// @param(AStatus Статус вектор) <br />@param(AContext Контекст выполнения внешней функции) <br />@param(AName Имя набора символов) <br />
    /// @param(AName Длина имени набора символов)
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    procedure getCharSet(AStatus: IStatus; AContext: IExternalContext; AName: PAnsiChar; ANameSize: Cardinal); override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

type
  TExternalProcedureBase = class abstract(IExternalProcedureImpl)
  public
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// Вызывается при уничтожении экземпляра функции
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    procedure dispose; override;
  public
{$IFDEF NODEF}{$REGION 'Описание'}{$ENDIF}
    /// <summary>
    /// Этот метод вызывается непосредственно перед execute и сообщает <br />ядру наш запрошенный набор символов для обмена данными внутри <br />
    /// этого метода. Во время этого вызова контекст использует набор символов, <br />полученный из ExternalEngine::getCharSet. <br />
    /// @param(AStatus Статус вектор) <br />@param(AContext Контекст выполнения внешней функции) <br />@param(AName Имя набора символов) <br />
    /// @param(AName Длина имени набора символов)
    /// </summary>
{$IFDEF NODEF}{$ENDREGION}{$ENDIF}
    procedure getCharSet(AStatus: IStatus; AContext: IExternalContext; AName: PAnsiChar; ANameSize: Cardinal); override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

type
  TFactoryFunctionUniversal = class(IUdrFunctionFactoryImpl)
  protected type
    TFunctionAnonymous = class(TExternalFunctionBase)
    private
      FRoutineMetadata: TRoutineMetadata;
      FParent         : TFactoryFunctionUniversal;
    public
      constructor Create(AParent: TFactoryFunctionUniversal; AStatus: IStatus; AMetadata: IRoutineMetadata); overload;
      constructor Create(AParent: TFactoryFunctionUniversal; AStatus: IStatus; AMetadata: TRoutineMetadata); overload;
    public
      procedure execute(AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer); override;
    public
      destructor Destroy; override;
    end;
  public
    procedure dispose; override;
  public
    procedure setup(AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
  public
    function newItem(AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata): IExternalFunction; override;
  protected
    procedure doNewItem(AStatus: IStatus; AContext: IExternalContext; AMetadata: TRoutineMetadata); virtual;
  protected
    procedure doSetup(const ASetup: RSetupParams); virtual;
  protected
    procedure BeforeExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); virtual;
    function doExecute(const AParams: RExecuteParams): Boolean; virtual;
    procedure AfterExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); virtual;
  public
    function TypeToSqlType(AType: Pointer): ESqlType;
    procedure ParamSet(AStatus: IStatus; AMeta: IMetadataBuilder; AIndex: NativeInt; AType: ESqlType);
  public
    destructor Destroy; override;
  end;

  TFactoryProcedureUniversal = class(IUdrProcedureFactoryImpl)
  protected type
    TProcedureAnonymous = class(TExternalProcedureBase)
    private
      FRoutineMetadata: TRoutineMetadata;
      FParent         : TFactoryProcedureUniversal;
    public
      constructor Create(AParent: TFactoryProcedureUniversal; AStatus: IStatus; AMetadata: IRoutineMetadata); overload;
      constructor Create(AParent: TFactoryProcedureUniversal; AStatus: IStatus; AMetadata: TRoutineMetadata); overload;
    public
      function open(AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer): IExternalResultSet; override;
    public
      destructor Destroy; override;
    end;
  public
    procedure dispose; override;
  public
    procedure setup(AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
  public
    function newItem(AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata): IExternalProcedure; override;
  protected
    procedure doNewItem(AStatus: IStatus; AContext: IExternalContext; AMetadata: TRoutineMetadata); virtual;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); virtual;
  protected
    procedure BeforeOpen(AStatus: IStatus; AInput, AOutput: TMessagesData); virtual;
    function doOpen(AStatus: IStatus; AInput, AOutput: TMessagesData): IExternalResultSet; virtual;
    procedure AfterOpen(AStatus: IStatus; AInput, AOutput: TMessagesData); virtual;
  public
    destructor Destroy; override;
  end;

implementation

uses
  firebird_classes;

{ TExternalFunctionBase }

constructor TExternalFunctionBase.Create;
begin
  inherited Create;
  // RLibraryHeapManager.Add(Self);
end;

destructor TExternalFunctionBase.Destroy;
begin
  // RLibraryHeapManager.Remove(Self);
  inherited;
end;

procedure TExternalFunctionBase.dispose;
begin
  Destroy
end;

procedure TExternalFunctionBase.getCharSet(AStatus: IStatus; AContext: IExternalContext; AName: PAnsiChar; ANameSize: Cardinal);
begin
  // virtual
end;

{ TExternalProcedureBase }

constructor TExternalProcedureBase.Create;
begin
  inherited Create;
  // RLibraryHeapManager.Add(Self);
end;

destructor TExternalProcedureBase.Destroy;
begin
  // RLibraryHeapManager.Remove(Self);
  inherited;
end;

procedure TExternalProcedureBase.dispose;
begin
  Destroy
end;

procedure TExternalProcedureBase.getCharSet(AStatus: IStatus; AContext: IExternalContext; AName: PAnsiChar; ANameSize: Cardinal);
begin
  // virtual
end;

{ TFactoryFunctionUniversal }

procedure TFactoryFunctionUniversal.AfterExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
begin
  // virtual
end;

procedure TFactoryFunctionUniversal.BeforeExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
begin
  // virtual
end;

destructor TFactoryFunctionUniversal.Destroy;
begin
  RLibraryHeapManager.ClearDependentFromParent(Self);
  inherited;
end;

procedure TFactoryFunctionUniversal.dispose;
begin
  Destroy
end;

function TFactoryFunctionUniversal.doExecute(const AParams: RExecuteParams): Boolean;
begin
  Result := False
end;

procedure TFactoryFunctionUniversal.doNewItem(AStatus: IStatus; AContext: IExternalContext; AMetadata: TRoutineMetadata);
begin
  // virtual
end;

procedure TFactoryFunctionUniversal.doSetup(const ASetup: RSetupParams);
begin
  // virtual
end;

function TFactoryFunctionUniversal.newItem(AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata): IExternalFunction;
var
  tmpMetadata: TRoutineMetadata;
begin
  try
    tmpMetadata := TRoutineMetadata.Create(AStatus, AMetadata);
    try
      doNewItem(AStatus, AContext, tmpMetadata);
      Result := TFunctionAnonymous.Create(Self, AStatus, tmpMetadata);
      tmpMetadata := nil;
    finally
      tmpMetadata.Free
    end;
  except
    on E: Exception do
    begin
      FbException.catchException(AStatus, E);
      Result := nil;
    end;
  end
end;

procedure TFactoryFunctionUniversal.ParamSet(AStatus: IStatus; AMeta: IMetadataBuilder; AIndex: NativeInt; AType: ESqlType);
begin
  AMeta.setType(AStatus, AIndex, Cardinal(AType) + 1);
  if AType = SQL_VARYING then
    AMeta.setCharSet(AStatus, AIndex, Cardinal(CS_UTF8));
end;

procedure TFactoryFunctionUniversal.setup(AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata;
  AInput, AOutput: IMetadataBuilder);
var
  tmpMetadata: TRoutineMetadata;
begin
  try
    tmpMetadata := TRoutineMetadata.Create(AStatus, AMetadata);
    try
      doSetup(RSetupParams.Create(AStatus, tmpMetadata, AInput, AOutput, Self));
    finally
      tmpMetadata.Destroy
    end;
  except
    on E: Exception do
      FbException.catchException(AStatus, E)
  end;
end;

function TFactoryFunctionUniversal.TypeToSqlType(AType: Pointer): ESqlType;
begin
  if (AType = TypeInfo(Int16)) or (AType = TypeInfo(UInt16)) or (AType = TypeInfo(SmallInt)) or (AType = TypeInfo(Word)) then
    Result := ESqlType.SQL_SHORT
  else if (AType = TypeInfo(UInt32)) or (AType = TypeInfo(Int32)) or (AType = TypeInfo(Integer)) or (AType = TypeInfo(LongInt)) or
    (AType = TypeInfo(LongWord)) then
    Result := ESqlType.SQL_LONG
  else if (AType = TypeInfo(UInt64)) or (AType = TypeInfo(Int64)) then
    Result := ESqlType.SQL_INT64
  else if AType = TypeInfo(Single) then
    Result := ESqlType.SQL_FLOAT
  else if AType = TypeInfo(Double) then
    Result := ESqlType.SQL_DOUBLE
  else if AType = TypeInfo(string) then
    Result := ESqlType.SQL_VARYING
  else if AType = TypeInfo(Boolean) then
    Result := ESqlType.SQL_BOOLEAN
  else if AType = TypeInfo(TDate) then
    Result := ESqlType.SQL_DATE
  else if AType = TypeInfo(TDateTime) then
    Result := ESqlType.SQL_TIMESTAMP
  else if AType = TypeInfo(TTime) then
    Result := ESqlType.SQL_TIME
  else if AType = TypeInfo(IBlob) then
    Result := ESqlType.SQL_QUAD
  else if PTypeInfo(AType).Kind = tkClass then
    if SizeOf(NativeInt) = 8 then
      Result := ESqlType.SQL_INT64
    else
      Result := ESqlType.SQL_LONG
  else
    raise Exception.Create('Неизвестный тип данных')
end;

{ TFactoryFunctionUniversal.TFunctionAnonymous }

constructor TFactoryFunctionUniversal.TFunctionAnonymous.Create(AParent: TFactoryFunctionUniversal; AStatus: IStatus; AMetadata: IRoutineMetadata);
begin
  Create(AParent, AStatus, TRoutineMetadata.Create(AStatus, AMetadata));
end;

constructor TFactoryFunctionUniversal.TFunctionAnonymous.Create(AParent: TFactoryFunctionUniversal; AStatus: IStatus; AMetadata: TRoutineMetadata);
begin
  inherited Create;
  // RLibraryHeapManager.Add(Self);
  FParent := AParent;
  FRoutineMetadata := AMetadata;
end;

destructor TFactoryFunctionUniversal.TFunctionAnonymous.Destroy;
begin
  FRoutineMetadata.Destroy;
  FParent := nil;
  RLibraryHeapManager.ClearDependentFromParent(Self);
  inherited;
end;

procedure TFactoryFunctionUniversal.TFunctionAnonymous.execute(AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer);
var
  tmpInputMessage : PByte absolute AInMsg;
  tmpOutputMessage: PByte absolute AOutMsg;
  tmpInput        : TMessagesData;
  tmpOutput       : TMessagesData;
begin
  try
    tmpInput := TMessagesData.Create(AContext, FRoutineMetadata.Input, tmpInputMessage, AStatus);
    try
      tmpOutput := TMessagesData.Create(AContext, FRoutineMetadata.Output, tmpOutputMessage, AStatus);
      try
        FParent.BeforeExecute(AStatus, tmpInput, tmpOutput);
        FParent.doExecute(RExecuteParams.Create(AStatus, tmpInput, tmpOutput, Self));
        FParent.AfterExecute(AStatus, tmpInput, tmpOutput);
        FbException.checkException(AStatus);
      finally
        tmpOutput.Destroy
      end;
    finally
      tmpInput.Destroy
    end;
  except
    on E: Exception do
      FbException.catchException(AStatus, E)
  end;
end;

{ TFactoryProcedureUniversal.TProcedureAnonymous }

constructor TFactoryProcedureUniversal.TProcedureAnonymous.Create(AParent: TFactoryProcedureUniversal; AStatus: IStatus; AMetadata: IRoutineMetadata);
begin
  Create(AParent, AStatus, TRoutineMetadata.Create(AStatus, AMetadata));
end;

constructor TFactoryProcedureUniversal.TProcedureAnonymous.Create(AParent: TFactoryProcedureUniversal; AStatus: IStatus; AMetadata: TRoutineMetadata);
begin
  inherited Create;
  // RLibraryHeapManager.Add(Self);
  FParent := AParent;
  FRoutineMetadata := AMetadata;
end;

destructor TFactoryProcedureUniversal.TProcedureAnonymous.Destroy;
begin
  FRoutineMetadata.Destroy;
  FParent := nil;
  RLibraryHeapManager.ClearDependentFromParent(Self);
  inherited;
end;

function TFactoryProcedureUniversal.TProcedureAnonymous.open(AStatus: IStatus; AContext: IExternalContext; AInMsg, AOutMsg: Pointer)
  : IExternalResultSet;
var
  tmpInputMessage : PByte absolute AInMsg;
  tmpOutputMessage: PByte absolute AOutMsg;
  tmpInput        : TMessagesData;
  tmpOutput       : TMessagesData;
begin
  Result := nil;
  try
    tmpInput := TMessagesData.Create(AContext, FRoutineMetadata.Input, tmpInputMessage, AStatus);
    try
      tmpOutput := TMessagesData.Create(AContext, FRoutineMetadata.Output, tmpOutputMessage, AStatus);
      try
        FParent.BeforeOpen(AStatus, tmpInput, tmpOutput);
        Result := FParent.doOpen(AStatus, tmpInput, tmpOutput);
        FParent.AfterOpen(AStatus, tmpInput, tmpOutput);
        FbException.checkException(AStatus);
      finally
        tmpOutput.Destroy
      end;
    finally
      tmpInput.Destroy
    end;
  except
    on E: Exception do
      FbException.catchException(AStatus, E)
  end;
end;

{ TFactoryProcedureUniversal }

procedure TFactoryProcedureUniversal.AfterOpen(AStatus: IStatus; AInput, AOutput: TMessagesData);
begin
  // virtual
end;

procedure TFactoryProcedureUniversal.BeforeOpen(AStatus: IStatus; AInput, AOutput: TMessagesData);
begin
  // virtual
end;

destructor TFactoryProcedureUniversal.Destroy;
begin
  RLibraryHeapManager.ClearDependentFromParent(Self);
  inherited;
end;

procedure TFactoryProcedureUniversal.dispose;
begin
  Destroy
end;

function TFactoryProcedureUniversal.doOpen(AStatus: IStatus; AInput, AOutput: TMessagesData): IExternalResultSet;
begin
  Result := nil
end;

procedure TFactoryProcedureUniversal.doNewItem(AStatus: IStatus; AContext: IExternalContext; AMetadata: TRoutineMetadata);
begin
  // virtual
end;

procedure TFactoryProcedureUniversal.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  // virtual
end;

function TFactoryProcedureUniversal.newItem(AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata): IExternalProcedure;
var
  tmpMetadata: TRoutineMetadata;
begin
  try
    tmpMetadata := TRoutineMetadata.Create(AStatus, AMetadata);
    try
      doNewItem(AStatus, AContext, tmpMetadata);
      Result := TProcedureAnonymous.Create(Self, AStatus, tmpMetadata);
      tmpMetadata := nil;
    finally
      tmpMetadata.Free
    end;
  except
    on E: Exception do
    begin
      FbException.catchException(AStatus, E);
      Result := nil;
    end;
  end
end;

procedure TFactoryProcedureUniversal.setup(AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata;
  AInput, AOutput: IMetadataBuilder);
var
  tmpMetadata: TRoutineMetadata;
begin
  try
    tmpMetadata := TRoutineMetadata.Create(AStatus, AMetadata);
    try
      doSetup(AStatus, tmpMetadata, AInput, AOutput);
    finally
      tmpMetadata.Destroy
    end;
  except
    on E: Exception do
      FbException.catchException(AStatus, E)
  end
end;

{ RExecuteParams }

constructor RExecuteParams.Create(AStatus: IStatus; AInput, AOutput: TMessagesData; AParent: TObject);
begin
  FStatus := AStatus;
  FInput := AInput;
  FOutput := AOutput;
  FParent := AParent
end;

class operator RExecuteParams.Finalize(var aDest: RExecuteParams);
begin
  with aDest do
  begin
    FStatus := nil;
    FInput := nil;
    FOutput := nil;
    FParent := nil
  end
end;

{ RSetupParams }

constructor RSetupParams.Create(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder; AParent: TObject);
begin
  FStatus := AStatus;
  FMetadata := AMetadata;
  FInput := AInput;
  FOutput := AOutput;
  FParent := AParent
end;

class operator RSetupParams.Finalize(var aDest: RSetupParams);
begin
  with aDest do
  begin
    FStatus := nil;
    FMetadata := nil;
    FInput := nil;
    FOutput := nil;
    FParent := nil
  end
end;

end.
