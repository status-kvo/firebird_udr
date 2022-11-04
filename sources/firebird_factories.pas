unit firebird_factories;

{$I general.inc}

interface

{$REGION 'uses'{$ENDIF}

uses
  SysUtils,
  TypInfo,
  Generics.Collections,
  firebird_api,
  firebird_types,
  firebird_charset,
  firebird_message_metadata,
  firebird_message_data;
{$ENDREGION}

type
  TAdapter = class;

  IOwner = interface
    procedure ChildDispose(AChild: TAdapter);
  end;

  TAdapter = class abstract
   private
    FOwner: IOwner;
   protected
    procedure DoCreate; virtual;
   public
    constructor Create(AOwner: IOwner);
    destructor Destroy; override;
  end;

type
  TListAdapter = class sealed
   private
    FList: TList<TAdapter>;
   public
    procedure Add(AAdapted: TAdapter);
    procedure Remove(AAdapted: TAdapter);
   public
    function FindAdapterByClass(AChild: TObject): TAdapter;
   public
    constructor Create;
    destructor Destroy; override;
  end;

type
  TAdapter<TChild> = class abstract(TAdapter)
   protected
    FChild: TChild;
   public
    property Child: TChild read FChild;
   public
    constructor Create(AOwner: IOwner; AChild: TChild); reintroduce;
  end;

type
  TAdapterInterface<TChild: IInterface> = class sealed(TAdapter<TChild>)
  end;

type
  TAdapterClass = class sealed(TAdapter<TObject>)
   private
    FIsChildDispose: Boolean;
   protected
    procedure DoCreate; override;
   public
    property IsChildDispose: Boolean read FIsChildDispose write FIsChildDispose;
   public
    destructor Destroy; override;
  end;

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
  TExternalFunctionBase = class abstract(IExternalFunctionImpl, IOwner)
   public type
    TClass = class of TExternalFunctionBase;
   private
    FRoutineMetadata: TRoutineMetadata;
   protected
    // Interface IInterface
    function QueryInterface(const AIID: TGUID; out AObj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
   protected
    // Interface IOwner
    procedure ChildDispose(AChild: TAdapter);
   public
    FInstances: TListAdapter;
   protected
    class function TypeToSqlType(AType: Pointer): ESqlType;
    class procedure ParamSet(AStatus: IStatus; AMeta: IMetadataBuilder; AIndex: NativeInt; AType: ESqlType);
    class procedure doSetup(const ASetup: RSetupParams); virtual;
    class procedure doNewItem(AStatus: IStatus; AContext: IExternalContext; AMetadata: TRoutineMetadata); virtual;
   public
    /// <summary>
    /// Вызывается при уничтожении экземпляра функции
    /// </summary>
    procedure dispose; override;
   public
    /// <summary>
    /// Этот метод вызывается непосредственно перед execute и сообщает <br />ядру наш запрошенный набор символов для обмена данными внутри <br />
    /// этого метода. Во время этого вызова контекст использует набор символов, <br />полученный из ExternalEngine::getCharSet. <br />
    /// @param(AStatus Статус вектор) <br />@param(AContext Контекст выполнения внешней функции) <br />@param(AName Имя набора символов) <br />
    /// @param(AName Длина имени набора символов)
    /// </summary>
    procedure getCharSet(AStatus: IStatus; AContext: IExternalContext; AName: PAnsiChar; ANameSize: Cardinal); override;
   public
    constructor Create(AParent: IUdrFunctionFactoryImpl); overload;
    constructor Create(AParent: IUdrFunctionFactoryImpl; AStatus: IStatus; AMetadata: IRoutineMetadata); overload;
    constructor Create(AParent: IUdrFunctionFactoryImpl; AStatus: IStatus; AMetadata: TRoutineMetadata); overload;

    destructor Destroy; override;
  end;

type
  TExternalProcedureBase = class abstract(IExternalProcedureImpl, IOwner)
   public type
    TClass = class of TExternalProcedureBase;
   protected
    // Interface IInterface
    function QueryInterface(const AIID: TGUID; out AObj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
   protected
    // Interface IOwner
    procedure ChildDispose(AChild: TAdapter);
   protected
    FInstances: TListAdapter;
   public
    /// <summary>
    /// Вызывается при уничтожении экземпляра функции
    /// </summary>
    procedure dispose; override;
   public
    /// <summary>
    /// Этот метод вызывается непосредственно перед execute и сообщает <br />ядру наш запрошенный набор символов для обмена данными внутри <br />
    /// этого метода. Во время этого вызова контекст использует набор символов, <br />полученный из ExternalEngine::getCharSet. <br />
    /// @param(AStatus Статус вектор) <br />@param(AContext Контекст выполнения внешней функции) <br />@param(AName Имя набора символов) <br />
    /// @param(AName Длина имени набора символов)
    /// </summary>
    procedure getCharSet(AStatus: IStatus; AContext: IExternalContext; AName: PAnsiChar; ANameSize: Cardinal); override;
   public
    constructor Create;
    destructor Destroy; override;
  end;

type
  TFactoryFunction = class(IUdrFunctionFactoryImpl)
   protected
    FInstanceClass: TExternalFunctionBase.TClass;
   public
    procedure dispose; override;
   public
    procedure setup(AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
   public
    function newItem(AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata): IExternalFunction; override;
   public
    constructor Create(AInstanceClass: TExternalFunctionBase.TClass);
  end;

type
  TFunction = class abstract(TExternalFunctionBase)
   protected
    procedure BeforeExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); virtual;
    function doExecute(const AParams: RExecuteParams): Boolean; virtual;
    procedure AfterExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); virtual;
   public
    procedure execute(AStatus: IStatus; AContext: IExternalContext; AInMsg: Pointer; AOutMsg: Pointer); override; final;
   public
    class function Factory: TFactoryFunction; virtual;
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
  end;

implementation

uses
  firebird_classes;

{ TExternalFunctionBase }

constructor TExternalFunctionBase.Create(AParent: IUdrFunctionFactoryImpl);
begin
  inherited Create;
  FInstances := TListAdapter.Create;
end;

constructor TExternalFunctionBase.Create(AParent: IUdrFunctionFactoryImpl; AStatus: IStatus; AMetadata: TRoutineMetadata);
begin
  Create(AParent);
  FRoutineMetadata := AMetadata;
end;

constructor TExternalFunctionBase.Create(AParent: IUdrFunctionFactoryImpl; AStatus: IStatus; AMetadata: IRoutineMetadata);
begin
  Create(AParent, AStatus, TRoutineMetadata.Create(AStatus, AMetadata));
end;

procedure TExternalFunctionBase.ChildDispose(AChild: TAdapter);
begin
  FInstances.Remove(AChild)
end;

destructor TExternalFunctionBase.Destroy;
begin
  FInstances.Free;
  FRoutineMetadata.Free;
  inherited;
end;

procedure TExternalFunctionBase.dispose;
begin
  Destroy
end;

class procedure TExternalFunctionBase.doNewItem(AStatus: IStatus; AContext: IExternalContext; AMetadata: TRoutineMetadata);
begin
  // virtual
end;

class procedure TExternalFunctionBase.doSetup(const ASetup: RSetupParams);
begin
  // virtual
end;

procedure TExternalFunctionBase.getCharSet(AStatus: IStatus; AContext: IExternalContext; AName: PAnsiChar; ANameSize: Cardinal);
begin
  // virtual
end;

class procedure TExternalFunctionBase.ParamSet(AStatus: IStatus; AMeta: IMetadataBuilder; AIndex: NativeInt; AType: ESqlType);
begin
  AMeta.setType(AStatus, AIndex, Cardinal(AType) + 1);
  if AType = SQL_VARYING then
    AMeta.setCharSet(AStatus, AIndex, Cardinal(CS_UTF8));
end;

function TExternalFunctionBase.QueryInterface(const AIID: TGUID; out AObj): HResult;
begin
  if GetInterface(AIID, AObj) then
    Result := 0
  else
    Result := E_NOINTERFACE
end;

class function TExternalFunctionBase.TypeToSqlType(AType: Pointer): ESqlType;
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
  else if AType = TypeInfo(TTimeStamp) then
    Result := ESqlType.SQL_TIMESTAMP
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

function TExternalFunctionBase._AddRef: Integer;
begin
  Result := -1
end;

function TExternalFunctionBase._Release: Integer;
begin
  Result := -1
end;

{ TExternalProcedureBase }

procedure TExternalProcedureBase.ChildDispose(AChild: TAdapter);
begin
  FInstances.Remove(AChild)
end;

constructor TExternalProcedureBase.Create;
begin
  inherited Create;
  FInstances := TListAdapter.Create;
end;

destructor TExternalProcedureBase.Destroy;
begin
  FInstances.Free;
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

function TExternalProcedureBase.QueryInterface(const AIID: TGUID; out AObj): HResult;
begin
  if GetInterface(AIID, AObj) then
    Result := 0
  else
    Result := E_NOINTERFACE
end;

function TExternalProcedureBase._AddRef: Integer;
begin
  Result := -1
end;

function TExternalProcedureBase._Release: Integer;
begin
  Result := -1
end;

{ TFactoryFunction }

constructor TFactoryFunction.Create(AInstanceClass: TExternalFunctionBase.TClass);
begin
  inherited Create;
  FInstanceClass := AInstanceClass
end;

procedure TFactoryFunction.dispose;
begin
  Destroy
end;

function TFactoryFunction.newItem(AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata): IExternalFunction;
var
  lMetadata: TRoutineMetadata;
begin
  Result := nil;
  try
    lMetadata := nil;
    try
      lMetadata := TRoutineMetadata.Create(AStatus, AMetadata);
      FInstanceClass.doNewItem(AStatus, AContext, lMetadata);
      Result := FInstanceClass.Create(Self, AStatus, lMetadata);
      lMetadata := nil;
    finally
      lMetadata.Free;
    end;
  except
    on E: Exception do
      FbException.catchException(AStatus, E);
  end;
  FbException.checkException(AStatus);
end;

procedure TFactoryFunction.setup(AStatus: IStatus; AContext: IExternalContext; AMetadata: IRoutineMetadata;
  AInput, AOutput: IMetadataBuilder);
var
  lMetadata: TRoutineMetadata;
begin
  try
    lMetadata := nil;
    try
      lMetadata := TRoutineMetadata.Create(AStatus, AMetadata);
      FInstanceClass.doSetup(RSetupParams.Create(AStatus, lMetadata, AInput, AOutput, Self));
    finally
      lMetadata.Free
    end;
  except
    on E: Exception do
      FbException.catchException(AStatus, E)
  end;
  FbException.checkException(AStatus);
end;

{ TFunctionAnonymous }

procedure TFunction.AfterExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
begin
  // virtual
end;

procedure TFunction.BeforeExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
begin
  // virtual
end;

function TFunction.doExecute(const AParams: RExecuteParams): Boolean;
begin
  Result := False
end;

procedure TFunction.execute(AStatus: IStatus; AContext: IExternalContext; AInMsg: Pointer; AOutMsg: Pointer);
var
  lInputMessage : PByte absolute AInMsg;
  lOutputMessage: PByte absolute AOutMsg;
  lInput        : TMessagesData;
  lOutput       : TMessagesData;
begin
  try
    lInput := nil;
    lOutput := nil;
    try
      lInput := TMessagesData.Create(AContext, FRoutineMetadata.Input, lInputMessage, AStatus);
      lOutput := TMessagesData.Create(AContext, FRoutineMetadata.Output, lOutputMessage, AStatus);

      BeforeExecute(AStatus, lInput, lOutput);
      doExecute(RExecuteParams.Create(AStatus, lInput, lOutput, Self));
      AfterExecute(AStatus, lInput, lOutput);
    finally
      lOutput.Free;
      lInput.Free
    end;
  except
    on E: Exception do
      FbException.catchException(AStatus, E)
  end;
end;

class function TFunction.Factory: TFactoryFunction;
begin
  Result := TFactoryFunction.Create(Self)
end;

{ TFactoryProcedureUniversal.TProcedureAnonymous }

constructor TFactoryProcedureUniversal.TProcedureAnonymous.Create(AParent: TFactoryProcedureUniversal; AStatus: IStatus; AMetadata: IRoutineMetadata);
begin
  Create(AParent, AStatus, TRoutineMetadata.Create(AStatus, AMetadata));
end;

constructor TFactoryProcedureUniversal.TProcedureAnonymous.Create(AParent: TFactoryProcedureUniversal; AStatus: IStatus; AMetadata: TRoutineMetadata);
begin
  inherited Create;
  FParent := AParent;
  FRoutineMetadata := AMetadata;
end;

destructor TFactoryProcedureUniversal.TProcedureAnonymous.Destroy;
begin
  FRoutineMetadata.Destroy;
  FParent := nil;
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

{ TAdapter }

constructor TAdapter.Create(AOwner: IOwner);
begin
  inherited Create;
  FOwner := AOwner;
end;

destructor TAdapter.Destroy;
begin
  FOwner.ChildDispose(Self);
  FOwner := nil;

  inherited;
end;

procedure TAdapter.DoCreate;
begin
  Pointer(FOwner) := nil;
end;

{ TAdapter<TChild> }

constructor TAdapter<TChild>.Create(AOwner: IOwner; AChild: TChild);
begin
  inherited Create(AOwner);
  FChild := AChild
end;

{ TAdapterClass }

destructor TAdapterClass.Destroy;
begin
  if FIsChildDispose then
    FChild.Free;
  FChild := nil;

  inherited;
end;

procedure TAdapterClass.DoCreate;
begin
  inherited;

  FIsChildDispose := True
end;

{ TListAdapter }

procedure TListAdapter.Add(AAdapted: TAdapter);
begin
  TMonitor.Enter(Self);
  try
    if (FList.IndexOf(AAdapted) = -1) then
      FList.Add(AAdapted)
  finally
    TMonitor.Exit(Self)
  end;
end;

constructor TListAdapter.Create;
begin
  inherited Create;
  FList := TList<TAdapter>.Create;
end;

destructor TListAdapter.Destroy;
 var
  LAdapter: TAdapter;
begin
  TMonitor.Enter(Self);
  try
    for LAdapter in FList do
      LAdapter.DisposeOf;
  finally
    TMonitor.Exit(Self)
  end;

  FList.Free;

  inherited;
end;

function TListAdapter.FindAdapterByClass(AChild: TObject): TAdapter;
 var
  LAdapter: TAdapter;
begin
  Result := nil;
  TMonitor.Enter(Self);
  try
    for LAdapter in FList do
      if LAdapter is TAdapterClass then
        if TAdapterClass(LAdapter).Child = AChild then
          Exit(LAdapter)
  finally
    TMonitor.Exit(Self)
  end;
end;

procedure TListAdapter.Remove(AAdapted: TAdapter);
begin
  TMonitor.Enter(Self);
  try
    FList.Remove(AAdapted)
  finally
    TMonitor.Exit(Self)
  end;
end;

end.
