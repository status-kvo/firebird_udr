unit task_firebird;

{$I ..\..\include\general.inc}

interface

implementation

{$REGION 'uses'}
uses
  SysUtils,
  Classes,
  Generics.Collections,
  firebird_api,
  firebird_charset,
  firebird_types,
  firebird_variables,
  firebird_blob,
  firebird_classes,
  firebird_factories,
  firebird_message_metadata,
  firebird_message_data;
{$ENDREGION}

{$REGION 'TTaskList - список потоков'}
type
  TTaskList = class
  strict private
    class var FDefault: TTaskList;
  public type
    TTask = class(TThread)
    private
      FId : Int64;
      FSql: string;
      FContext: IExternalContext;
    protected
      procedure Execute; override;
    public
      constructor Create(AContext: IExternalContext; const AId: Int64; const ASql: string; const AAutoStart: Boolean);
      destructor Destroy; override;
    end;
  public type
    TTaskDictionary = TDictionary<TTask, Int64>;
  strict private
    FList: TTaskDictionary;
  public
    class property default: TTaskList read FDefault;
  public
    procedure Clear;
  public
    function LockList: TTaskDictionary;
    procedure UnLockList;
  public
    procedure TaskCreate(const ATask: TTask);
    procedure TaskDestroy(const ATask: TTask);
  public
    function TaskStart(const ATask: TTask): Boolean; overload;
    function TaskStart(const AId: Int64): Boolean; overload;
  public
    function TaskStop(const ATask: TTask; const AWait: Boolean): Boolean; overload;
    function TaskStop(const AId: Int64; const AWait: Boolean): Boolean; overload;
  public
    function TaskIsTerminated(const ATask: TTask): Boolean; overload;
    function TaskIsTerminated(const AId: Int64): Boolean; overload;
  public
    function TaskContains(const ATask: TTask): Boolean;
    function TaskSearchById(const AId: Int64): TTask;
  public
    constructor Create;
    destructor Destroy; override;
  public
    class constructor Create;
    class destructor Destroy;
  end;
{$ENDREGION}

{$REGION 'TTaskFunction - Базовый класс для функций TaskXXX'}
type
  TTaskFunction = class abstract(TFactoryFunctionUniversal)
  protected
    class function ModuleGet: string; override;
  end;
{$ENDREGION}

{$REGION 'TTaskCreate - Функция создания потока'}
type
  TTaskCreate = class sealed(TTaskFunction)
  protected
    procedure doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
    class function NameGet: string; override;
  end;
{$ENDREGION}

{$REGION 'TTaskStartXXX - Функции запуска отложенный потоков'}
type
  TTaskStart = class abstract(TTaskFunction)
  protected
    class function NameGet: string; override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
  end;

type
  TTaskStartByHandle = class sealed(TTaskStart)
  protected
    procedure doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
    class function NameGet: string; override;
  end;

type
  TTaskStartById = class sealed(TTaskStart)
  protected
    procedure doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
    class function NameGet: string; override;
  end;
{$ENDREGION}

{$REGION 'TTaskStopXXX - Функции остановки потоков'}
type
  TTaskStop = class abstract(TTaskFunction)
  protected
    class function NameGet: string; override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
  end;

type
  TTaskStopByHandle = class sealed(TTaskStop)
  protected
    procedure doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
    class function NameGet: string; override;
  end;

type
  TTaskStopById = class sealed(TTaskStop)
  protected
    procedure doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
    class function NameGet: string; override;
  end;
{$ENDREGION}

{$REGION 'TTaskIsTerminatedXXX - Функции проветки потоков остановки/существования'}
type
  TTaskIsTerminated = class abstract(TTaskFunction)
  protected
    class function NameGet: string; override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
  end;

type
  TTaskIsTerminatedByHandle = class sealed(TTaskIsTerminated)
  protected
    procedure doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
    class function NameGet: string; override;
  end;

type
  TTaskIsTerminatedById = class sealed(TTaskIsTerminated)
  protected
    procedure doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData); override;
  protected
    procedure doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder); override;
    class function NameGet: string; override;
  end;
{$ENDREGION}

  { TTaskList }

procedure TTaskList.Clear;
var
  Index: NativeInt;
  Tasks: TArray<TPair<TTask, Int64>>;
  Task : TTask;
begin
  with LockList do
    try
      Tasks := ToArray;
      for index := high(Tasks) to low(Tasks) do
      begin
        Task := Tasks[index].Key;
        try
          Task.Terminate;
          continue;
        except
        end;
        Remove(Task);
      end;
    finally
      UnLockList
    end;

  // ждем пока все протоки остановятся
  while True do
  begin
    with LockList do
      try
        if Count = 0 then
          Break;
      finally
        UnLockList;
      end;
    TThread.Yield;
  end;
end;

class constructor TTaskList.Create;
begin
  FDefault := TTaskList.Create
end;

constructor TTaskList.Create;
begin
  inherited Create;
  FList := TTaskDictionary.Create
end;

destructor TTaskList.Destroy;
begin
  LockList;
  try
    FList.Destroy;
    inherited Destroy;
  finally
    UnLockList;
  end;
end;

class destructor TTaskList.Destroy;
begin
  FDefault.Clear;
  FDefault.Destroy
end;

function TTaskList.LockList: TTaskDictionary;
begin
  TMonitor.Enter(Self);
  Result := FList
end;

function TTaskList.TaskContains(const ATask: TTask): Boolean;
begin
  with default.LockList do
    try
      Result := ContainsKey(ATask);
      if Result then
        ATask.Terminate;
    finally
      UnLockList
    end;
end;

procedure TTaskList.TaskDestroy(const ATask: TTask);
begin
  with default.LockList do
    try
      if ContainsKey(ATask) then
        Remove(ATask)
    finally
      UnLockList
    end;
end;

function TTaskList.TaskIsTerminated(const AId: Int64): Boolean;
begin
  Result := TaskIsTerminated(TaskSearchById(AId))
end;

function TTaskList.TaskIsTerminated(const ATask: TTask): Boolean;
begin
  Result := True;
  if assigned(ATask) then
    with default.LockList do
      try
        if ContainsKey(ATask) then
          Result := ATask.Terminated
        else
          Result := False
      finally
        default.UnLockList
      end
end;

procedure TTaskList.TaskCreate(const ATask: TTask);
begin
  with default.LockList do
    try
      Add(ATask, ATask.FId)
    finally
      UnLockList
    end;
end;

function TTaskList.TaskSearchById(const AId: Int64): TTask;
var
  Tasks: TArray<TPair<TTask, Int64>>;
  Pair : TPair<TTask, Int64>;
begin
  Result := nil;
  with default.LockList do
    try
      Tasks := ToArray;
      for Pair in Tasks do
        if Pair.Value = AId then
        begin
          Result := Pair.Key;
          Break
        end;
    finally
      UnLockList
    end;
end;

function TTaskList.TaskStart(const AId: Int64): Boolean;
begin
  Result := TaskStart(TaskSearchById(AId))
end;

function TTaskList.TaskStart(const ATask: TTask): Boolean;
begin
  Result := False;
  if assigned(ATask) then
    with default.LockList do
      try
        if ContainsKey(ATask) then
        begin
          ATask.Start;
          Result := True;
        end
        else
          Result := False
      finally
        default.UnLockList
      end;
end;

function TTaskList.TaskStop(const AId: Int64; const AWait: Boolean): Boolean;
begin
  Result := TaskStop(TaskSearchById(AId), AWait)
end;

function TTaskList.TaskStop(const ATask: TTask; const AWait: Boolean): Boolean;
begin
  Result := True;
  if assigned(ATask) then
  begin
    with Default.LockList do
      try
        if ContainsKey(ATask) then
        begin
          ATask.Terminate;
          Result := False;
        end
      finally
        Default.UnLockList
      end;

    if not Result then
    begin
      if AWait then
        while True do
          if TaskContains(ATask) then
            TThread.Yield
          else
            Break;
      Result := True;
    end;
  end
end;

procedure TTaskList.UnLockList;
begin
  TMonitor.Exit(Self)
end;

{ TTaskList.TTask }

constructor TTaskList.TTask.Create(AContext: IExternalContext; const AId: Int64; const ASql: string; const AAutoStart: Boolean);
begin
  FId := AId;
  FSql := ASql;
  FContext := AContext;
  inherited Create(False);
  FreeOnTerminate := True;
  TTaskList.Default.TaskCreate(Self);
  if AAutoStart then
    Start;
end;

destructor TTaskList.TTask.Destroy;
begin
  TTaskList.Default.TaskDestroy(Self);
  FContext := nil;
  inherited;
end;

procedure TTaskList.TTask.Execute;
begin
  try

  except
  end;
end;

{ TTaskFunction }

class function TTaskFunction.ModuleGet: string;
begin
  Result := rsTask
end;

{ TTaskCreate }

procedure TTaskCreate.doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
begin
  AOutput[0].AsObject := TTaskList.TTask.Create(AInput.Context, AInput[0].AsBigint, AInput[1].AsString, AInput[2].AsBoolean)
end;

procedure TTaskCreate.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  BuilderSetInt64(AStatus, AInput, 0);
  BuilderSetVarChar(AStatus, AInput, 1);
  BuilderSetBool(AStatus, AInput, 2);
  BuilderSetObject(AStatus, AOutput, 0);
end;

class function TTaskCreate.NameGet: string;
begin
  Result := rsCreate
end;

{ TTaskStart }

procedure TTaskStart.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  BuilderSetBool(AStatus, AOutput, 0);
end;

class function TTaskStart.NameGet: string;
begin
  Result := rsStart
end;

{ TTaskStartByHandle }

procedure TTaskStartByHandle.doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
begin
  AOutput[0].AsBoolean := TTaskList.Default.TaskStart(TTaskList.TTask(AInput[0].AsObject))
end;

procedure TTaskStartByHandle.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  inherited;
  BuilderSetObject(AStatus, AInput, 0);
end;

class function TTaskStartByHandle.NameGet: string;
begin
  Result := inherited + rsByHandle
end;

{ TTaskStartbyId }

procedure TTaskStartById.doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
begin
  AOutput[0].AsBoolean := TTaskList.Default.TaskStart(AInput[0].AsBigint)
end;

procedure TTaskStartById.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  BuilderSetInt64(AStatus, AInput, 0);
end;

class function TTaskStartById.NameGet: string;
begin
  Result := inherited + rsById
end;

{ TTaskStop }

procedure TTaskStop.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  BuilderSetBool(AStatus, AInput, 1);
  BuilderSetBool(AStatus, AOutput, 0);
end;

class function TTaskStop.NameGet: string;
begin
  Result := rsStop
end;

{ TTaskStopByHandle }

procedure TTaskStopByHandle.doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
begin
  AOutput[0].AsBoolean := TTaskList.Default.TaskStop(TTaskList.TTask(AInput[0].AsObject), AInput[1].AsBoolean)
end;

procedure TTaskStopByHandle.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  inherited;
  BuilderSetObject(AStatus, AInput, 0);
end;

class function TTaskStopByHandle.NameGet: string;
begin
  Result := inherited + rsByHandle
end;

{ TTaskStopById }

procedure TTaskStopById.doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
begin
  AOutput[0].AsBoolean := TTaskList.Default.TaskStop(AInput[0].AsBigint, AInput[1].AsBoolean)
end;

procedure TTaskStopById.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  inherited;
  BuilderSetInt64(AStatus, AInput, 0);
end;

class function TTaskStopById.NameGet: string;
begin
  Result := inherited + rsById
end;

{ TTaskIsTerminated }

procedure TTaskIsTerminated.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  BuilderSetBool(AStatus, AOutput, 0);
end;

class function TTaskIsTerminated.NameGet: string;
begin
  Result := rsIsTerminated
end;

{ TTaskIsTerminatedByHandle }

procedure TTaskIsTerminatedByHandle.doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
begin
  AOutput[0].AsBoolean := TTaskList.Default.TaskIsTerminated(TTaskList.TTask(AInput[0].AsObject))
end;

procedure TTaskIsTerminatedByHandle.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  inherited;
  BuilderSetObject(AStatus, AInput, 0);
end;

class function TTaskIsTerminatedByHandle.NameGet: string;
begin
  Result := inherited + rsByHandle
end;

{ TTaskIsTerminatedById }

procedure TTaskIsTerminatedById.doExecute(AStatus: IStatus; AInput, AOutput: TMessagesData);
begin
  AOutput[0].AsBoolean := TTaskList.Default.TaskIsTerminated(AInput[0].AsBigint)
end;

procedure TTaskIsTerminatedById.doSetup(AStatus: IStatus; AMetadata: TRoutineMetadata; AInput, AOutput: IMetadataBuilder);
begin
  inherited;
  BuilderSetInt64(AStatus, AInput, 0);
end;

class function TTaskIsTerminatedById.NameGet: string;
begin
  Result := inherited + rsById
end;

initialization

begin
  TTaskCreate.Register;

  TTaskStartByHandle.Register;
  TTaskStartById.Register;

  TTaskStopByHandle.Register;
  TTaskStopById.Register;

  TTaskIsTerminatedByHandle.Register;
  TTaskIsTerminatedById.Register;
end;

finalization

end.
