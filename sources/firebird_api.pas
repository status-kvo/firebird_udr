﻿unit firebird_api;

{$I general.inc}
// {$OBJECTCHECKS OFF}

interface

uses Classes,
  SysUtils;

type
{$IFNDEF FPC}
  QWord = UInt64;
{$ENDIF}
  IVersioned = class;
  IReferenceCounted = class;
  IDisposable = class;
  IStatus = class;
  IMaster = class;
  IPluginBase = class;
  IPluginSet = class;
  IConfigEntry = class;
  IConfig = class;
  IFirebirdConf = class;
  IPluginConfig = class;
  IPluginFactory = class;
  IPluginModule = class;
  IPluginManager = class;
  ICryptKey = class;
  IConfigManager = class;
  IEventCallback = class;
  IBlob = class;
  ITransaction = class;
  IMessageMetadata = class;
  IMetadataBuilder = class;
  IResultSet = class;
  IStatement = class;
  IRequest = class;
  IEvents = class;
  IAttachment = class;
  IService = class;
  IProvider = class;
  IDtcStart = class;
  IDtc = class;
  IAuth = class;
  IWriter = class;
  IServerBlock = class;
  IClientBlock = class;
  IServer = class;
  IClient = class;
  IUserField = class;
  ICharUserField = class;
  IIntUserField = class;
  IUser = class;
  IListUsers = class;
  ILogonInfo = class;
  IManagement = class;
  IAuthBlock = class;
  IWireCryptPlugin = class;
  ICryptKeyCallback = class;
  IKeyHolderPlugin = class;
  IDbCryptInfo = class;
  IDbCryptPlugin = class;
  IExternalContext = class;
  IExternalResultSet = class;
  IExternalFunction = class;
  IExternalProcedure = class;
  IExternalTrigger = class;
  IRoutineMetadata = class;
  IExternalEngine = class;
  ITimer = class;
  ITimerControl = class;
  IVersionCallback = class;
  IUtil = class;
  IOffsetsCallback = class;
  IXpbBuilder = class;
  ITraceConnection = class;
  ITraceDatabaseConnection = class;
  ITraceTransaction = class;
  ITraceParams = class;
  ITraceStatement = class;
  ITraceSQLStatement = class;
  ITraceBLRStatement = class;
  ITraceDYNRequest = class;
  ITraceContextVariable = class;
  ITraceProcedure = class;
  ITraceFunction = class;
  ITraceTrigger = class;
  ITraceServiceConnection = class;
  ITraceStatusVector = class;
  ITraceSweepInfo = class;
  ITraceLogWriter = class;
  ITraceInitInfo = class;
  ITracePlugin = class;
  ITraceFactory = class;
  IUdrFunctionFactory = class;
  IUdrProcedureFactory = class;
  IUdrTriggerFactory = class;
  IUdrPlugin = class;

  FbException = class(Exception)
  public
    constructor create(status: IStatus); virtual;
    destructor Destroy(); override;

    function getStatus: IStatus;

    class procedure checkException(status: IStatus);
    class procedure catchException(status: IStatus; e: Exception);

  private
    status: IStatus;
  end;

  ISC_DATE = Integer;
  ISC_TIME = Integer;
  // ISC_QUAD = array [1 .. 2] of Integer;
  ISC_QUAD = UInt64;

  ntrace_relation_t = Integer;

  TraceCounts = record
    trc_relation_id: ntrace_relation_t;
    trc_relation_name: PAnsiChar;
    trc_counters: ^Int64;
  end;

  TraceCountsPtr = ^TraceCounts;

  PerformanceInfo = record
    pin_time: Int64;
    pin_counters: ^Int64;
    pin_count: NativeUInt;
    pin_tables: TraceCountsPtr;
    pin_records_fetched: Int64;
  end;

  Dsc = record
    dsc_dtype, dsc_scale: Byte;
    dsc_length, dsc_sub_type, dsc_flags: Int16;
    dsc_address: ^Byte;
  end;

  BooleanPtr = ^Boolean;
  BytePtr = ^Byte;
  CardinalPtr = ^Cardinal;
  IKeyHolderPluginPtr = ^IKeyHolderPlugin;
  ISC_QUADPtr = ^ISC_QUAD;
  Int64Ptr = ^Int64;
  NativeIntPtr = ^NativeInt;
  PerformanceInfoPtr = ^PerformanceInfo;
  dscPtr = ^Dsc;

  IReferenceCounted_addRefPtr = procedure(this: IReferenceCounted); cdecl;
  IReferenceCounted_releasePtr = function(this: IReferenceCounted): Integer; cdecl;
  IDisposable_disposePtr = procedure(this: IDisposable); cdecl;
  IStatus_initPtr = procedure(this: IStatus); cdecl;
  IStatus_getStatePtr = function(this: IStatus): Cardinal; cdecl;
  IStatus_setErrors2Ptr = procedure(this: IStatus; length: Cardinal; value: NativeIntPtr); cdecl;
  IStatus_setWarnings2Ptr = procedure(this: IStatus; length: Cardinal; value: NativeIntPtr); cdecl;
  IStatus_setErrorsPtr = procedure(this: IStatus; value: NativeIntPtr); cdecl;
  IStatus_setWarningsPtr = procedure(this: IStatus; value: NativeIntPtr); cdecl;
  IStatus_getErrorsPtr = function(this: IStatus)       : NativeIntPtr; cdecl;
  IStatus_getWarningsPtr = function(this: IStatus)     : NativeIntPtr; cdecl;
  IStatus_clonePtr = function(this: IStatus)           : IStatus; cdecl;
  IMaster_getStatusPtr = function(this: IMaster)       : IStatus; cdecl;
  IMaster_getDispatcherPtr = function(this: IMaster)   : IProvider; cdecl;
  IMaster_getPluginManagerPtr = function(this: IMaster): IPluginManager; cdecl;
  IMaster_getTimerControlPtr = function(this: IMaster) : ITimerControl; cdecl;
  IMaster_getDtcPtr = function(this: IMaster)          : IDtc; cdecl;
  IMaster_registerAttachmentPtr = function(this: IMaster; provider: IProvider; attachment: IAttachment): IAttachment; cdecl;
  IMaster_registerTransactionPtr = function(this: IMaster; attachment: IAttachment; transaction: ITransaction): ITransaction; cdecl;
  IMaster_getMetadataBuilderPtr = function(this: IMaster; status: IStatus; fieldCount: Cardinal): IMetadataBuilder; cdecl;
  IMaster_serverModePtr = function(this: IMaster; mode: Integer): Integer; cdecl;
  IMaster_getUtilInterfacePtr = function(this: IMaster): IUtil; cdecl;
  IMaster_getConfigManagerPtr = function(this: IMaster) : IConfigManager; cdecl;
  IMaster_getProcessExitingPtr = function(this: IMaster): Boolean; cdecl;
  IPluginBase_setOwnerPtr = procedure(this: IPluginBase; r: IReferenceCounted); cdecl;
  IPluginBase_getOwnerPtr = function(this: IPluginBase)   : IReferenceCounted; cdecl;
  IPluginSet_getNamePtr = function(this: IPluginSet)      : PAnsiChar; cdecl;
  IPluginSet_getModuleNamePtr = function(this: IPluginSet): PAnsiChar; cdecl;
  IPluginSet_getPluginPtr = function(this: IPluginSet; status: IStatus): IPluginBase; cdecl;
  IPluginSet_nextPtr = procedure(this: IPluginSet; status: IStatus); cdecl;
  IPluginSet_set_Ptr = procedure(this: IPluginSet; status: IStatus; s: PAnsiChar); cdecl;
  IConfigEntry_getNamePtr = function(this: IConfigEntry) : PAnsiChar; cdecl;
  IConfigEntry_getValuePtr = function(this: IConfigEntry): PAnsiChar; cdecl;
  IConfigEntry_getIntValuePtr = function(this: IConfigEntry): Int64; cdecl;
  IConfigEntry_getBoolValuePtr = function(this: IConfigEntry): Boolean; cdecl;
  IConfigEntry_getSubConfigPtr = function(this: IConfigEntry; status: IStatus): IConfig; cdecl;
  IConfig_findPtr = function(this: IConfig; status: IStatus; name: PAnsiChar): IConfigEntry; cdecl;
  IConfig_findValuePtr = function(this: IConfig; status: IStatus; name: PAnsiChar; value: PAnsiChar): IConfigEntry; cdecl;
  IConfig_findPosPtr = function(this: IConfig; status: IStatus; name: PAnsiChar; pos: Cardinal): IConfigEntry; cdecl;
  IFirebirdConf_getKeyPtr = function(this: IFirebirdConf; name: PAnsiChar): Cardinal; cdecl;
  IFirebirdConf_asIntegerPtr = function(this: IFirebirdConf; key: Cardinal): Int64; cdecl;
  IFirebirdConf_asStringPtr = function(this: IFirebirdConf; key: Cardinal): PAnsiChar; cdecl;
  IFirebirdConf_asBooleanPtr = function(this: IFirebirdConf; key: Cardinal): Boolean; cdecl;
  IPluginConfig_getConfigFileNamePtr = function(this: IPluginConfig): PAnsiChar; cdecl;
  IPluginConfig_getDefaultConfigPtr = function(this: IPluginConfig; status: IStatus): IConfig; cdecl;
  IPluginConfig_getFirebirdConfPtr = function(this: IPluginConfig; status: IStatus): IFirebirdConf; cdecl;
  IPluginConfig_setReleaseDelayPtr = procedure(this: IPluginConfig; status: IStatus; microSeconds: QWord); cdecl;
  IPluginFactory_createPluginPtr = function(this: IPluginFactory; status: IStatus; factoryParameter: IPluginConfig): IPluginBase; cdecl;
  IPluginModule_doCleanPtr = procedure(this: IPluginModule); cdecl;
  IPluginModule_threadDetachPtr = procedure(this: IPluginModule); cdecl;
  IPluginManager_registerPluginFactoryPtr = procedure(this: IPluginManager; pluginType: Cardinal; defaultName: PAnsiChar;
    factory: IPluginFactory); cdecl;
  IPluginManager_registerModulePtr = procedure(this: IPluginManager; cleanup: IPluginModule); cdecl;
  IPluginManager_unregisterModulePtr = procedure(this: IPluginManager; cleanup: IPluginModule); cdecl;
  IPluginManager_getPluginsPtr = function(this: IPluginManager; status: IStatus; pluginType: Cardinal; namesList: PAnsiChar;
    firebirdConf: IFirebirdConf): IPluginSet; cdecl;
  IPluginManager_getConfigPtr = function(this: IPluginManager; status: IStatus; filename: PAnsiChar): IConfig; cdecl;
  IPluginManager_releasePluginPtr = procedure(this: IPluginManager; plugin: IPluginBase); cdecl;
  ICryptKey_setSymmetricPtr = procedure(this: ICryptKey; status: IStatus; type_: PAnsiChar; keyLength: Cardinal; key: Pointer); cdecl;
  ICryptKey_setAsymmetricPtr = procedure(this: ICryptKey; status: IStatus; type_: PAnsiChar; encryptKeyLength: Cardinal; encryptKey: Pointer;
    decryptKeyLength: Cardinal; decryptKey: Pointer); cdecl;
  ICryptKey_getEncryptKeyPtr = function(this: ICryptKey; length: CardinalPtr): Pointer; cdecl;
  ICryptKey_getDecryptKeyPtr = function(this: ICryptKey; length: CardinalPtr): Pointer; cdecl;
  IConfigManager_getDirectoryPtr = function(this: IConfigManager; code: Cardinal): PAnsiChar; cdecl;
  IConfigManager_getFirebirdConfPtr = function(this: IConfigManager): IFirebirdConf; cdecl;
  IConfigManager_getDatabaseConfPtr = function(this: IConfigManager; dbName: PAnsiChar): IFirebirdConf; cdecl;
  IConfigManager_getPluginConfigPtr = function(this: IConfigManager; configuredPlugin: PAnsiChar): IConfig; cdecl;
  IConfigManager_getInstallDirectoryPtr = function(this: IConfigManager): PAnsiChar; cdecl;
  IConfigManager_getRootDirectoryPtr = function(this: IConfigManager): PAnsiChar; cdecl;
  IConfigManager_getDefaultSecurityDbPtr = function(this: IConfigManager): PAnsiChar; cdecl;
  IEventCallback_eventCallbackFunctionPtr = procedure(this: IEventCallback; length: Cardinal; events: BytePtr); cdecl;
  IBlob_getInfoPtr = procedure(this: IBlob; status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr); cdecl;
  IBlob_getSegmentPtr = function(this: IBlob; status: IStatus; bufferLength: Cardinal; buffer: Pointer; var segmentLength: Cardinal): Integer; cdecl;
  IBlob_putSegmentPtr = procedure(this: IBlob; status: IStatus; length: Cardinal; buffer: Pointer); cdecl;
  IBlob_cancelPtr = procedure(this: IBlob; status: IStatus); cdecl;
  IBlob_closePtr = procedure(this: IBlob; status: IStatus); cdecl;
  IBlob_seekPtr = function(this: IBlob; status: IStatus; mode: Integer; offset: Integer): Integer; cdecl;
  ITransaction_getInfoPtr = procedure(this: ITransaction; status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
    buffer: BytePtr); cdecl;
  ITransaction_preparePtr = procedure(this: ITransaction; status: IStatus; msgLength: Cardinal; message: BytePtr); cdecl;
  ITransaction_commitPtr = procedure(this: ITransaction; status: IStatus); cdecl;
  ITransaction_commitRetainingPtr = procedure(this: ITransaction; status: IStatus); cdecl;
  ITransaction_rollbackPtr = procedure(this: ITransaction; status: IStatus); cdecl;
  ITransaction_rollbackRetainingPtr = procedure(this: ITransaction; status: IStatus); cdecl;
  ITransaction_disconnectPtr = procedure(this: ITransaction; status: IStatus); cdecl;
  ITransaction_joinPtr = function(this: ITransaction; status: IStatus; transaction: ITransaction): ITransaction; cdecl;
  ITransaction_validatePtr = function(this: ITransaction; status: IStatus; attachment: IAttachment): ITransaction; cdecl;
  ITransaction_enterDtcPtr = function(this: ITransaction; status: IStatus): ITransaction; cdecl;
  IMessageMetadata_getCountPtr = function(this: IMessageMetadata; status: IStatus): Cardinal; cdecl;
  IMessageMetadata_getFieldPtr = function(this: IMessageMetadata; status: IStatus; index: Cardinal): PAnsiChar; cdecl;
  IMessageMetadata_getRelationPtr = function(this: IMessageMetadata; status: IStatus; index: Cardinal): PAnsiChar; cdecl;
  IMessageMetadata_getOwnerPtr = function(this: IMessageMetadata; status: IStatus; index: Cardinal): PAnsiChar; cdecl;
  IMessageMetadata_getAliasPtr = function(this: IMessageMetadata; status: IStatus; index: Cardinal): PAnsiChar; cdecl;
  IMessageMetadata_getTypePtr = function(this: IMessageMetadata; status: IStatus; index: Cardinal): Cardinal; cdecl;
  IMessageMetadata_isNullablePtr = function(this: IMessageMetadata; status: IStatus; index: Cardinal): Boolean; cdecl;
  IMessageMetadata_getSubTypePtr = function(this: IMessageMetadata; status: IStatus; index: Cardinal): Integer; cdecl;
  IMessageMetadata_getLengthPtr = function(this: IMessageMetadata; status: IStatus; index: Cardinal): Cardinal; cdecl;
  IMessageMetadata_getScalePtr = function(this: IMessageMetadata; status: IStatus; index: Cardinal): Integer; cdecl;
  IMessageMetadata_getCharSetPtr = function(this: IMessageMetadata; status: IStatus; index: Cardinal): Cardinal; cdecl;
  IMessageMetadata_getOffsetPtr = function(this: IMessageMetadata; status: IStatus; index: Cardinal): Cardinal; cdecl;
  IMessageMetadata_getNullOffsetPtr = function(this: IMessageMetadata; status: IStatus; index: Cardinal): Cardinal; cdecl;
  IMessageMetadata_getBuilderPtr = function(this: IMessageMetadata; status: IStatus): IMetadataBuilder; cdecl;
  IMessageMetadata_getMessageLengthPtr = function(this: IMessageMetadata; status: IStatus): Cardinal; cdecl;
  IMetadataBuilder_setTypePtr = procedure(this: IMetadataBuilder; status: IStatus; index: Cardinal; type_: Cardinal); cdecl;
  IMetadataBuilder_setSubTypePtr = procedure(this: IMetadataBuilder; status: IStatus; index: Cardinal; subType: Integer); cdecl;
  IMetadataBuilder_setLengthPtr = procedure(this: IMetadataBuilder; status: IStatus; index: Cardinal; length: Cardinal); cdecl;
  IMetadataBuilder_setCharSetPtr = procedure(this: IMetadataBuilder; status: IStatus; index: Cardinal; charSet: Cardinal); cdecl;
  IMetadataBuilder_setScalePtr = procedure(this: IMetadataBuilder; status: IStatus; index: Cardinal; scale: Integer); cdecl;
  IMetadataBuilder_truncatePtr = procedure(this: IMetadataBuilder; status: IStatus; count: Cardinal); cdecl;
  IMetadataBuilder_moveNameToIndexPtr = procedure(this: IMetadataBuilder; status: IStatus; name: PAnsiChar; index: Cardinal); cdecl;
  IMetadataBuilder_removePtr = procedure(this: IMetadataBuilder; status: IStatus; index: Cardinal); cdecl;
  IMetadataBuilder_addFieldPtr = function(this: IMetadataBuilder; status: IStatus): Cardinal; cdecl;
  IMetadataBuilder_getMetadataPtr = function(this: IMetadataBuilder; status: IStatus): IMessageMetadata; cdecl;
  IResultSet_fetchNextPtr = function(this: IResultSet; status: IStatus; message: Pointer): Integer; cdecl;
  IResultSet_fetchPriorPtr = function(this: IResultSet; status: IStatus; message: Pointer): Integer; cdecl;
  IResultSet_fetchFirstPtr = function(this: IResultSet; status: IStatus; message: Pointer): Integer; cdecl;
  IResultSet_fetchLastPtr = function(this: IResultSet; status: IStatus; message: Pointer): Integer; cdecl;
  IResultSet_fetchAbsolutePtr = function(this: IResultSet; status: IStatus; position: Integer; message: Pointer): Integer; cdecl;
  IResultSet_fetchRelativePtr = function(this: IResultSet; status: IStatus; offset: Integer; message: Pointer): Integer; cdecl;
  IResultSet_isEofPtr = function(this: IResultSet; status: IStatus): Boolean; cdecl;
  IResultSet_isBofPtr = function(this: IResultSet; status: IStatus): Boolean; cdecl;
  IResultSet_getMetadataPtr = function(this: IResultSet; status: IStatus): IMessageMetadata; cdecl;
  IResultSet_closePtr = procedure(this: IResultSet; status: IStatus); cdecl;
  IResultSet_setDelayedOutputFormatPtr = procedure(this: IResultSet; status: IStatus; format: IMessageMetadata); cdecl;
  IStatement_getInfoPtr = procedure(this: IStatement; status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
    buffer: BytePtr); cdecl;
  IStatement_getTypePtr = function(this: IStatement; status: IStatus): Cardinal; cdecl;
  IStatement_getPlanPtr = function(this: IStatement; status: IStatus; detailed: Boolean): PAnsiChar; cdecl;
  IStatement_getAffectedRecordsPtr = function(this: IStatement; status: IStatus): QWord; cdecl;
  IStatement_getInputMetadataPtr = function(this: IStatement; status: IStatus): IMessageMetadata; cdecl;
  IStatement_getOutputMetadataPtr = function(this: IStatement; status: IStatus): IMessageMetadata; cdecl;
  IStatement_executePtr = function(this: IStatement; status: IStatus; transaction: ITransaction; inMetadata: IMessageMetadata; inBuffer: Pointer;
    outMetadata: IMessageMetadata; outBuffer: Pointer): ITransaction; cdecl;
  IStatement_openCursorPtr = function(this: IStatement; status: IStatus; transaction: ITransaction; inMetadata: IMessageMetadata; inBuffer: Pointer;
    outMetadata: IMessageMetadata; flags: Cardinal): IResultSet; cdecl;
  IStatement_setCursorNamePtr = procedure(this: IStatement; status: IStatus; name: PAnsiChar); cdecl;
  IStatement_freePtr = procedure(this: IStatement; status: IStatus); cdecl;
  IStatement_getFlagsPtr = function(this: IStatement; status: IStatus): Cardinal; cdecl;
  IRequest_receivePtr = procedure(this: IRequest; status: IStatus; level: Integer; msgType: Cardinal; length: Cardinal; message: BytePtr); cdecl;
  IRequest_sendPtr = procedure(this: IRequest; status: IStatus; level: Integer; msgType: Cardinal; length: Cardinal; message: BytePtr); cdecl;
  IRequest_getInfoPtr = procedure(this: IRequest; status: IStatus; level: Integer; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
    buffer: BytePtr); cdecl;
  IRequest_startPtr = procedure(this: IRequest; status: IStatus; tra: ITransaction; level: Integer); cdecl;
  IRequest_startAndSendPtr = procedure(this: IRequest; status: IStatus; tra: ITransaction; level: Integer; msgType: Cardinal; length: Cardinal;
    message: BytePtr); cdecl;
  IRequest_unwindPtr = procedure(this: IRequest; status: IStatus; level: Integer); cdecl;
  IRequest_freePtr = procedure(this: IRequest; status: IStatus); cdecl;
  IEvents_cancelPtr = procedure(this: IEvents; status: IStatus); cdecl;
  IAttachment_getInfoPtr = procedure(this: IAttachment; status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
    buffer: BytePtr); cdecl;
  IAttachment_startTransactionPtr = function(this: IAttachment; status: IStatus; tpbLength: Cardinal; tpb: BytePtr): ITransaction; cdecl;
  IAttachment_reconnectTransactionPtr = function(this: IAttachment; status: IStatus; length: Cardinal; id: BytePtr): ITransaction; cdecl;
  IAttachment_compileRequestPtr = function(this: IAttachment; status: IStatus; blrLength: Cardinal; blr: BytePtr): IRequest; cdecl;
  IAttachment_transactRequestPtr = procedure(this: IAttachment; status: IStatus; transaction: ITransaction; blrLength: Cardinal; blr: BytePtr;
    inMsgLength: Cardinal; inMsg: BytePtr; outMsgLength: Cardinal; outMsg: BytePtr); cdecl;
  IAttachment_createBlobPtr = function(this: IAttachment; status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; bpbLength: Cardinal;
    bpb: BytePtr): IBlob; cdecl;
  IAttachment_openBlobPtr = function(this: IAttachment; status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; bpbLength: Cardinal;
    bpb: BytePtr): IBlob; cdecl;
  IAttachment_getSlicePtr = function(this: IAttachment; status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; sdlLength: Cardinal;
    sdl: BytePtr; paramLength: Cardinal; param: BytePtr; sliceLength: Integer; slice: BytePtr): Integer; cdecl;
  IAttachment_putSlicePtr = procedure(this: IAttachment; status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; sdlLength: Cardinal;
    sdl: BytePtr; paramLength: Cardinal; param: BytePtr; sliceLength: Integer; slice: BytePtr); cdecl;
  IAttachment_executeDynPtr = procedure(this: IAttachment; status: IStatus; transaction: ITransaction; length: Cardinal; dyn: BytePtr); cdecl;
  IAttachment_preparePtr = function(this: IAttachment; status: IStatus; tra: ITransaction; stmtLength: Cardinal; sqlStmt: PAnsiChar;
    dialect: Cardinal; flags: Cardinal): IStatement; cdecl;
  IAttachment_executePtr = function(this: IAttachment; status: IStatus; transaction: ITransaction; stmtLength: Cardinal; sqlStmt: PAnsiChar;
    dialect: Cardinal; inMetadata: IMessageMetadata; inBuffer: Pointer; outMetadata: IMessageMetadata; outBuffer: Pointer): ITransaction; cdecl;
  IAttachment_openCursorPtr = function(this: IAttachment; status: IStatus; transaction: ITransaction; stmtLength: Cardinal; sqlStmt: PAnsiChar;
    dialect: Cardinal; inMetadata: IMessageMetadata; inBuffer: Pointer; outMetadata: IMessageMetadata; cursorName: PAnsiChar; cursorFlags: Cardinal)
    : IResultSet; cdecl;
  IAttachment_queEventsPtr = function(this: IAttachment; status: IStatus; callback: IEventCallback; length: Cardinal; events: BytePtr)
    : IEvents; cdecl;
  IAttachment_cancelOperationPtr = procedure(this: IAttachment; status: IStatus; option: Integer); cdecl;
  IAttachment_pingPtr = procedure(this: IAttachment; status: IStatus); cdecl;
  IAttachment_detachPtr = procedure(this: IAttachment; status: IStatus); cdecl;
  IAttachment_dropDatabasePtr = procedure(this: IAttachment; status: IStatus); cdecl;
  IService_detachPtr = procedure(this: IService; status: IStatus); cdecl;
  IService_queryPtr = procedure(this: IService; status: IStatus; sendLength: Cardinal; sendItems: BytePtr; receiveLength: Cardinal;
    receiveItems: BytePtr; bufferLength: Cardinal; buffer: BytePtr); cdecl;
  IService_startPtr = procedure(this: IService; status: IStatus; spbLength: Cardinal; spb: BytePtr); cdecl;
  IProvider_attachDatabasePtr = function(this: IProvider; status: IStatus; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr)
    : IAttachment; cdecl;
  IProvider_createDatabasePtr = function(this: IProvider; status: IStatus; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr)
    : IAttachment; cdecl;
  IProvider_attachServiceManagerPtr = function(this: IProvider; status: IStatus; service: PAnsiChar; spbLength: Cardinal; spb: BytePtr)
    : IService; cdecl;
  IProvider_shutdownPtr = procedure(this: IProvider; status: IStatus; timeout: Cardinal; reason: Integer); cdecl;
  IProvider_setDbCryptCallbackPtr = procedure(this: IProvider; status: IStatus; cryptCallback: ICryptKeyCallback); cdecl;
  IDtcStart_addAttachmentPtr = procedure(this: IDtcStart; status: IStatus; att: IAttachment); cdecl;
  IDtcStart_addWithTpbPtr = procedure(this: IDtcStart; status: IStatus; att: IAttachment; length: Cardinal; tpb: BytePtr); cdecl;
  IDtcStart_startPtr = function(this: IDtcStart; status: IStatus): ITransaction; cdecl;
  IDtc_joinPtr = function(this: IDtc; status: IStatus; one: ITransaction; two: ITransaction): ITransaction; cdecl;
  IDtc_startBuilderPtr = function(this: IDtc; status: IStatus): IDtcStart; cdecl;
  IWriter_resetPtr = procedure(this: IWriter); cdecl;
  IWriter_addPtr = procedure(this: IWriter; status: IStatus; name: PAnsiChar); cdecl;
  IWriter_setTypePtr = procedure(this: IWriter; status: IStatus; value: PAnsiChar); cdecl;
  IWriter_setDbPtr = procedure(this: IWriter; status: IStatus; value: PAnsiChar); cdecl;
  IServerBlock_getLoginPtr = function(this: IServerBlock): PAnsiChar; cdecl;
  IServerBlock_getDataPtr = function(this: IServerBlock; length: CardinalPtr): BytePtr; cdecl;
  IServerBlock_putDataPtr = procedure(this: IServerBlock; status: IStatus; length: Cardinal; data: Pointer); cdecl;
  IServerBlock_newKeyPtr = function(this: IServerBlock; status: IStatus): ICryptKey; cdecl;
  IClientBlock_getLoginPtr = function(this: IClientBlock): PAnsiChar; cdecl;
  IClientBlock_getPasswordPtr = function(this: IClientBlock): PAnsiChar; cdecl;
  IClientBlock_getDataPtr = function(this: IClientBlock; length: CardinalPtr): BytePtr; cdecl;
  IClientBlock_putDataPtr = procedure(this: IClientBlock; status: IStatus; length: Cardinal; data: Pointer); cdecl;
  IClientBlock_newKeyPtr = function(this: IClientBlock; status: IStatus): ICryptKey; cdecl;
  IClientBlock_getAuthBlockPtr = function(this: IClientBlock; status: IStatus): IAuthBlock; cdecl;
  IServer_authenticatePtr = function(this: IServer; status: IStatus; sBlock: IServerBlock; writerInterface: IWriter): Integer; cdecl;
  IServer_setDbCryptCallbackPtr = procedure(this: IServer; status: IStatus; cryptCallback: ICryptKeyCallback); cdecl;
  IClient_authenticatePtr = function(this: IClient; status: IStatus; cBlock: IClientBlock): Integer; cdecl;
  IUserField_enteredPtr = function(this: IUserField): Integer; cdecl;
  IUserField_specifiedPtr = function(this: IUserField): Integer; cdecl;
  IUserField_setEnteredPtr = procedure(this: IUserField; status: IStatus; newValue: Integer); cdecl;
  ICharUserField_getPtr = function(this: ICharUserField): PAnsiChar; cdecl;
  ICharUserField_set_Ptr = procedure(this: ICharUserField; status: IStatus; newValue: PAnsiChar); cdecl;
  IIntUserField_getPtr = function(this: IIntUserField): Integer; cdecl;
  IIntUserField_set_Ptr = procedure(this: IIntUserField; status: IStatus; newValue: Integer); cdecl;
  IUser_operationPtr = function(this: IUser) : Cardinal; cdecl;
  IUser_userNamePtr = function(this: IUser)  : ICharUserField; cdecl;
  IUser_passwordPtr = function(this: IUser)  : ICharUserField; cdecl;
  IUser_firstNamePtr = function(this: IUser) : ICharUserField; cdecl;
  IUser_lastNamePtr = function(this: IUser)  : ICharUserField; cdecl;
  IUser_middleNamePtr = function(this: IUser): ICharUserField; cdecl;
  IUser_commentPtr = function(this: IUser)   : ICharUserField; cdecl;
  IUser_attributesPtr = function(this: IUser): ICharUserField; cdecl;
  IUser_activePtr = function(this: IUser)    : IIntUserField; cdecl;
  IUser_adminPtr = function(this: IUser)     : IIntUserField; cdecl;
  IUser_clearPtr = procedure(this: IUser; status: IStatus); cdecl;
  IListUsers_listPtr = procedure(this: IListUsers; status: IStatus; user: IUser); cdecl;
  ILogonInfo_namePtr = function(this: ILogonInfo): PAnsiChar; cdecl;
  ILogonInfo_rolePtr = function(this: ILogonInfo): PAnsiChar; cdecl;
  ILogonInfo_networkProtocolPtr = function(this: ILogonInfo): PAnsiChar; cdecl;
  ILogonInfo_remoteAddressPtr = function(this: ILogonInfo): PAnsiChar; cdecl;
  ILogonInfo_authBlockPtr = function(this: ILogonInfo; length: CardinalPtr): BytePtr; cdecl;
  IManagement_startPtr = procedure(this: IManagement; status: IStatus; logonInfo: ILogonInfo); cdecl;
  IManagement_executePtr = function(this: IManagement; status: IStatus; user: IUser; callback: IListUsers): Integer; cdecl;
  IManagement_commitPtr = procedure(this: IManagement; status: IStatus); cdecl;
  IManagement_rollbackPtr = procedure(this: IManagement; status: IStatus); cdecl;
  IAuthBlock_getTypePtr = function(this: IAuthBlock)      : PAnsiChar; cdecl;
  IAuthBlock_getNamePtr = function(this: IAuthBlock)      : PAnsiChar; cdecl;
  IAuthBlock_getPluginPtr = function(this: IAuthBlock)    : PAnsiChar; cdecl;
  IAuthBlock_getSecurityDbPtr = function(this: IAuthBlock): PAnsiChar; cdecl;
  IAuthBlock_getOriginalPluginPtr = function(this: IAuthBlock): PAnsiChar; cdecl;
  IAuthBlock_nextPtr = function(this: IAuthBlock; status: IStatus): Boolean; cdecl;
  IAuthBlock_firstPtr = function(this: IAuthBlock; status: IStatus): Boolean; cdecl;
  IWireCryptPlugin_getKnownTypesPtr = function(this: IWireCryptPlugin; status: IStatus): PAnsiChar; cdecl;
  IWireCryptPlugin_setKeyPtr = procedure(this: IWireCryptPlugin; status: IStatus; key: ICryptKey); cdecl;
  IWireCryptPlugin_encryptPtr = procedure(this: IWireCryptPlugin; status: IStatus; length: Cardinal; from: Pointer; to_: Pointer); cdecl;
  IWireCryptPlugin_decryptPtr = procedure(this: IWireCryptPlugin; status: IStatus; length: Cardinal; from: Pointer; to_: Pointer); cdecl;
  ICryptKeyCallback_callbackPtr = function(this: ICryptKeyCallback; dataLength: Cardinal; data: Pointer; bufferLength: Cardinal; buffer: Pointer)
    : Cardinal; cdecl;
  IKeyHolderPlugin_keyCallbackPtr = function(this: IKeyHolderPlugin; status: IStatus; callback: ICryptKeyCallback): Integer; cdecl;
  IKeyHolderPlugin_keyHandlePtr = function(this: IKeyHolderPlugin; status: IStatus; keyName: PAnsiChar): ICryptKeyCallback; cdecl;
  IKeyHolderPlugin_useOnlyOwnKeysPtr = function(this: IKeyHolderPlugin; status: IStatus): Boolean; cdecl;
  IKeyHolderPlugin_chainHandlePtr = function(this: IKeyHolderPlugin; status: IStatus): ICryptKeyCallback; cdecl;
  IDbCryptInfo_getDatabaseFullPathPtr = function(this: IDbCryptInfo; status: IStatus): PAnsiChar; cdecl;
  IDbCryptPlugin_setKeyPtr = procedure(this: IDbCryptPlugin; status: IStatus; length: Cardinal; sources: IKeyHolderPluginPtr;
    keyName: PAnsiChar); cdecl;
  IDbCryptPlugin_encryptPtr = procedure(this: IDbCryptPlugin; status: IStatus; length: Cardinal; from: Pointer; to_: Pointer); cdecl;
  IDbCryptPlugin_decryptPtr = procedure(this: IDbCryptPlugin; status: IStatus; length: Cardinal; from: Pointer; to_: Pointer); cdecl;
  IDbCryptPlugin_setInfoPtr = procedure(this: IDbCryptPlugin; status: IStatus; info: IDbCryptInfo); cdecl;
  IExternalContext_getMasterPtr = function(this: IExternalContext): IMaster; cdecl;
  IExternalContext_getEnginePtr = function(this: IExternalContext; status: IStatus): IExternalEngine; cdecl;
  IExternalContext_getAttachmentPtr = function(this: IExternalContext; status: IStatus): IAttachment; cdecl;
  IExternalContext_getTransactionPtr = function(this: IExternalContext; status: IStatus): ITransaction; cdecl;
  IExternalContext_getUserNamePtr = function(this: IExternalContext): PAnsiChar; cdecl;
  IExternalContext_getDatabaseNamePtr = function(this: IExternalContext): PAnsiChar; cdecl;
  IExternalContext_getClientCharSetPtr = function(this: IExternalContext): PAnsiChar; cdecl;
  IExternalContext_obtainInfoCodePtr = function(this: IExternalContext): Integer; cdecl;
  IExternalContext_getInfoPtr = function(this: IExternalContext; code: Integer): Pointer; cdecl;
  IExternalContext_setInfoPtr = function(this: IExternalContext; code: Integer; value: Pointer): Pointer; cdecl;
  IExternalResultSet_fetchPtr = function(this: IExternalResultSet; status: IStatus): Boolean; cdecl;
  IExternalFunction_getCharSetPtr = procedure(this: IExternalFunction; status: IStatus; context: IExternalContext; name: PAnsiChar;
    nameSize: Cardinal); cdecl;
  IExternalFunction_executePtr = procedure(this: IExternalFunction; status: IStatus; context: IExternalContext; inMsg: Pointer;
    outMsg: Pointer); cdecl;
  IExternalProcedure_getCharSetPtr = procedure(this: IExternalProcedure; status: IStatus; context: IExternalContext; name: PAnsiChar;
    nameSize: Cardinal); cdecl;
  IExternalProcedure_openPtr = function(this: IExternalProcedure; status: IStatus; context: IExternalContext; inMsg: Pointer; outMsg: Pointer)
    : IExternalResultSet; cdecl;
  IExternalTrigger_getCharSetPtr = procedure(this: IExternalTrigger; status: IStatus; context: IExternalContext; name: PAnsiChar;
    nameSize: Cardinal); cdecl;
  IExternalTrigger_executePtr = procedure(this: IExternalTrigger; status: IStatus; context: IExternalContext; action: Cardinal; oldMsg: Pointer;
    newMsg: Pointer); cdecl;
  IRoutineMetadata_getPackagePtr = function(this: IRoutineMetadata; status: IStatus): PAnsiChar; cdecl;
  IRoutineMetadata_getNamePtr = function(this: IRoutineMetadata; status: IStatus): PAnsiChar; cdecl;
  IRoutineMetadata_getEntryPointPtr = function(this: IRoutineMetadata; status: IStatus): PAnsiChar; cdecl;
  IRoutineMetadata_getBodyPtr = function(this: IRoutineMetadata; status: IStatus): PAnsiChar; cdecl;
  IRoutineMetadata_getInputMetadataPtr = function(this: IRoutineMetadata; status: IStatus): IMessageMetadata; cdecl;
  IRoutineMetadata_getOutputMetadataPtr = function(this: IRoutineMetadata; status: IStatus): IMessageMetadata; cdecl;
  IRoutineMetadata_getTriggerMetadataPtr = function(this: IRoutineMetadata; status: IStatus): IMessageMetadata; cdecl;
  IRoutineMetadata_getTriggerTablePtr = function(this: IRoutineMetadata; status: IStatus): PAnsiChar; cdecl;
  IRoutineMetadata_getTriggerTypePtr = function(this: IRoutineMetadata; status: IStatus): Cardinal; cdecl;
  IExternalEngine_openPtr = procedure(this: IExternalEngine; status: IStatus; context: IExternalContext; charSet: PAnsiChar;
    charSetSize: Cardinal); cdecl;
  IExternalEngine_openAttachmentPtr = procedure(this: IExternalEngine; status: IStatus; context: IExternalContext); cdecl;
  IExternalEngine_closeAttachmentPtr = procedure(this: IExternalEngine; status: IStatus; context: IExternalContext); cdecl;
  IExternalEngine_makeFunctionPtr = function(this: IExternalEngine; status: IStatus; context: IExternalContext; metadata: IRoutineMetadata;
    inBuilder: IMetadataBuilder; outBuilder: IMetadataBuilder): IExternalFunction; cdecl;
  IExternalEngine_makeProcedurePtr = function(this: IExternalEngine; status: IStatus; context: IExternalContext; metadata: IRoutineMetadata;
    inBuilder: IMetadataBuilder; outBuilder: IMetadataBuilder): IExternalProcedure; cdecl;
  IExternalEngine_makeTriggerPtr = function(this: IExternalEngine; status: IStatus; context: IExternalContext; metadata: IRoutineMetadata;
    fieldsBuilder: IMetadataBuilder): IExternalTrigger; cdecl;
  ITimer_handlerPtr = procedure(this: ITimer); cdecl;
  ITimerControl_startPtr = procedure(this: ITimerControl; status: IStatus; timer: ITimer; microSeconds: QWord); cdecl;
  ITimerControl_stopPtr = procedure(this: ITimerControl; status: IStatus; timer: ITimer); cdecl;
  IVersionCallback_callbackPtr = procedure(this: IVersionCallback; status: IStatus; text: PAnsiChar); cdecl;
  IUtil_getFbVersionPtr = procedure(this: IUtil; status: IStatus; att: IAttachment; callback: IVersionCallback); cdecl;
  IUtil_loadBlobPtr = procedure(this: IUtil; status: IStatus; blobId: ISC_QUADPtr; att: IAttachment; tra: ITransaction; file_: PAnsiChar;
    txt: Boolean); cdecl;
  IUtil_dumpBlobPtr = procedure(this: IUtil; status: IStatus; blobId: ISC_QUADPtr; att: IAttachment; tra: ITransaction; file_: PAnsiChar;
    txt: Boolean); cdecl;
  IUtil_getPerfCountersPtr = procedure(this: IUtil; status: IStatus; att: IAttachment; countersSet: PAnsiChar; counters: Int64Ptr); cdecl;
  IUtil_executeCreateDatabasePtr = function(this: IUtil; status: IStatus; stmtLength: Cardinal; creatDBstatement: PAnsiChar; dialect: Cardinal;
    stmtIsCreateDb: BooleanPtr): IAttachment; cdecl;
  IUtil_decodeDatePtr = procedure(this: IUtil; date: ISC_DATE; year: CardinalPtr; month: CardinalPtr; day: CardinalPtr); cdecl;
  IUtil_decodeTimePtr = procedure(this: IUtil; time: ISC_TIME; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr;
    fractions: CardinalPtr); cdecl;
  IUtil_encodeDatePtr = function(this: IUtil; year: Cardinal; month: Cardinal; day: Cardinal): ISC_DATE; cdecl;
  IUtil_encodeTimePtr = function(this: IUtil; hours: Cardinal; minutes: Cardinal; seconds: Cardinal; fractions: Cardinal): ISC_TIME; cdecl;
  IUtil_formatStatusPtr = function(this: IUtil; buffer: PAnsiChar; bufferSize: Cardinal; status: IStatus): Cardinal; cdecl;
  IUtil_getClientVersionPtr = function(this: IUtil): Cardinal; cdecl;
  IUtil_getXpbBuilderPtr = function(this: IUtil; status: IStatus; kind: Cardinal; buf: BytePtr; len: Cardinal): IXpbBuilder; cdecl;
  IUtil_setOffsetsPtr = function(this: IUtil; status: IStatus; metadata: IMessageMetadata; callback: IOffsetsCallback): Cardinal; cdecl;
  IOffsetsCallback_setOffsetPtr = procedure(this: IOffsetsCallback; status: IStatus; index: Cardinal; offset: Cardinal; nullOffset: Cardinal); cdecl;
  IXpbBuilder_clearPtr = procedure(this: IXpbBuilder; status: IStatus); cdecl;
  IXpbBuilder_removeCurrentPtr = procedure(this: IXpbBuilder; status: IStatus); cdecl;
  IXpbBuilder_insertIntPtr = procedure(this: IXpbBuilder; status: IStatus; tag: Byte; value: Integer); cdecl;
  IXpbBuilder_insertBigIntPtr = procedure(this: IXpbBuilder; status: IStatus; tag: Byte; value: Int64); cdecl;
  IXpbBuilder_insertBytesPtr = procedure(this: IXpbBuilder; status: IStatus; tag: Byte; bytes: Pointer; length: Cardinal); cdecl;
  IXpbBuilder_insertStringPtr = procedure(this: IXpbBuilder; status: IStatus; tag: Byte; str: PAnsiChar); cdecl;
  IXpbBuilder_insertTagPtr = procedure(this: IXpbBuilder; status: IStatus; tag: Byte); cdecl;
  IXpbBuilder_isEofPtr = function(this: IXpbBuilder; status: IStatus): Boolean; cdecl;
  IXpbBuilder_moveNextPtr = procedure(this: IXpbBuilder; status: IStatus); cdecl;
  IXpbBuilder_rewindPtr = procedure(this: IXpbBuilder; status: IStatus); cdecl;
  IXpbBuilder_findFirstPtr = function(this: IXpbBuilder; status: IStatus; tag: Byte): Boolean; cdecl;
  IXpbBuilder_findNextPtr = function(this: IXpbBuilder; status: IStatus): Boolean; cdecl;
  IXpbBuilder_getTagPtr = function(this: IXpbBuilder; status: IStatus): Byte; cdecl;
  IXpbBuilder_getLengthPtr = function(this: IXpbBuilder; status: IStatus): Cardinal; cdecl;
  IXpbBuilder_getIntPtr = function(this: IXpbBuilder; status: IStatus): Integer; cdecl;
  IXpbBuilder_getBigIntPtr = function(this: IXpbBuilder; status: IStatus): Int64; cdecl;
  IXpbBuilder_getStringPtr = function(this: IXpbBuilder; status: IStatus): PAnsiChar; cdecl;
  IXpbBuilder_getBytesPtr = function(this: IXpbBuilder; status: IStatus): BytePtr; cdecl;
  IXpbBuilder_getBufferLengthPtr = function(this: IXpbBuilder; status: IStatus): Cardinal; cdecl;
  IXpbBuilder_getBufferPtr = function(this: IXpbBuilder; status: IStatus): BytePtr; cdecl;
  ITraceConnection_getKindPtr = function(this: ITraceConnection): Cardinal; cdecl;
  ITraceConnection_getProcessIDPtr = function(this: ITraceConnection): Integer; cdecl;
  ITraceConnection_getUserNamePtr = function(this: ITraceConnection): PAnsiChar; cdecl;
  ITraceConnection_getRoleNamePtr = function(this: ITraceConnection): PAnsiChar; cdecl;
  ITraceConnection_getCharSetPtr = function(this: ITraceConnection): PAnsiChar; cdecl;
  ITraceConnection_getRemoteProtocolPtr = function(this: ITraceConnection): PAnsiChar; cdecl;
  ITraceConnection_getRemoteAddressPtr = function(this: ITraceConnection): PAnsiChar; cdecl;
  ITraceConnection_getRemoteProcessIDPtr = function(this: ITraceConnection): Integer; cdecl;
  ITraceConnection_getRemoteProcessNamePtr = function(this: ITraceConnection): PAnsiChar; cdecl;
  ITraceDatabaseConnection_getConnectionIDPtr = function(this: ITraceDatabaseConnection): Int64; cdecl;
  ITraceDatabaseConnection_getDatabaseNamePtr = function(this: ITraceDatabaseConnection): PAnsiChar; cdecl;
  ITraceTransaction_getTransactionIDPtr = function(this: ITraceTransaction): Int64; cdecl;
  ITraceTransaction_getReadOnlyPtr = function(this: ITraceTransaction): Boolean; cdecl;
  ITraceTransaction_getWaitPtr = function(this: ITraceTransaction): Integer; cdecl;
  ITraceTransaction_getIsolationPtr = function(this: ITraceTransaction): Cardinal; cdecl;
  ITraceTransaction_getPerfPtr = function(this: ITraceTransaction): PerformanceInfoPtr; cdecl;
  ITraceTransaction_getInitialIDPtr = function(this: ITraceTransaction): Int64; cdecl;
  ITraceTransaction_getPreviousIDPtr = function(this: ITraceTransaction): Int64; cdecl;
  ITraceParams_getCountPtr = function(this: ITraceParams): Cardinal; cdecl;
  ITraceParams_getParamPtr = function(this: ITraceParams; idx: Cardinal): dscPtr; cdecl;
  ITraceParams_getTextUTF8Ptr = function(this: ITraceParams; status: IStatus; idx: Cardinal): PAnsiChar; cdecl;
  ITraceStatement_getStmtIDPtr = function(this: ITraceStatement): Int64; cdecl;
  ITraceStatement_getPerfPtr = function(this: ITraceStatement): PerformanceInfoPtr; cdecl;
  ITraceSQLStatement_getTextPtr = function(this: ITraceSQLStatement): PAnsiChar; cdecl;
  ITraceSQLStatement_getPlanPtr = function(this: ITraceSQLStatement): PAnsiChar; cdecl;
  ITraceSQLStatement_getInputsPtr = function(this: ITraceSQLStatement): ITraceParams; cdecl;
  ITraceSQLStatement_getTextUTF8Ptr = function(this: ITraceSQLStatement): PAnsiChar; cdecl;
  ITraceSQLStatement_getExplainedPlanPtr = function(this: ITraceSQLStatement): PAnsiChar; cdecl;
  ITraceBLRStatement_getDataPtr = function(this: ITraceBLRStatement): BytePtr; cdecl;
  ITraceBLRStatement_getDataLengthPtr = function(this: ITraceBLRStatement): Cardinal; cdecl;
  ITraceBLRStatement_getTextPtr = function(this: ITraceBLRStatement): PAnsiChar; cdecl;
  ITraceDYNRequest_getDataPtr = function(this: ITraceDYNRequest): BytePtr; cdecl;
  ITraceDYNRequest_getDataLengthPtr = function(this: ITraceDYNRequest): Cardinal; cdecl;
  ITraceDYNRequest_getTextPtr = function(this: ITraceDYNRequest): PAnsiChar; cdecl;
  ITraceContextVariable_getNameSpacePtr = function(this: ITraceContextVariable): PAnsiChar; cdecl;
  ITraceContextVariable_getVarNamePtr = function(this: ITraceContextVariable): PAnsiChar; cdecl;
  ITraceContextVariable_getVarValuePtr = function(this: ITraceContextVariable): PAnsiChar; cdecl;
  ITraceProcedure_getProcNamePtr = function(this: ITraceProcedure): PAnsiChar; cdecl;
  ITraceProcedure_getInputsPtr = function(this: ITraceProcedure): ITraceParams; cdecl;
  ITraceProcedure_getPerfPtr = function(this: ITraceProcedure): PerformanceInfoPtr; cdecl;
  ITraceFunction_getFuncNamePtr = function(this: ITraceFunction): PAnsiChar; cdecl;
  ITraceFunction_getInputsPtr = function(this: ITraceFunction): ITraceParams; cdecl;
  ITraceFunction_getResultPtr = function(this: ITraceFunction): ITraceParams; cdecl;
  ITraceFunction_getPerfPtr = function(this: ITraceFunction): PerformanceInfoPtr; cdecl;
  ITraceTrigger_getTriggerNamePtr = function(this: ITraceTrigger): PAnsiChar; cdecl;
  ITraceTrigger_getRelationNamePtr = function(this: ITraceTrigger): PAnsiChar; cdecl;
  ITraceTrigger_getActionPtr = function(this: ITraceTrigger): Integer; cdecl;
  ITraceTrigger_getWhichPtr = function(this: ITraceTrigger): Integer; cdecl;
  ITraceTrigger_getPerfPtr = function(this: ITraceTrigger): PerformanceInfoPtr; cdecl;
  ITraceServiceConnection_getServiceIDPtr = function(this: ITraceServiceConnection): Pointer; cdecl;
  ITraceServiceConnection_getServiceMgrPtr = function(this: ITraceServiceConnection): PAnsiChar; cdecl;
  ITraceServiceConnection_getServiceNamePtr = function(this: ITraceServiceConnection): PAnsiChar; cdecl;
  ITraceStatusVector_hasErrorPtr = function(this: ITraceStatusVector): Boolean; cdecl;
  ITraceStatusVector_hasWarningPtr = function(this: ITraceStatusVector): Boolean; cdecl;
  ITraceStatusVector_getStatusPtr = function(this: ITraceStatusVector): IStatus; cdecl;
  ITraceStatusVector_getTextPtr = function(this: ITraceStatusVector): PAnsiChar; cdecl;
  ITraceSweepInfo_getOITPtr = function(this: ITraceSweepInfo): Int64; cdecl;
  ITraceSweepInfo_getOSTPtr = function(this: ITraceSweepInfo): Int64; cdecl;
  ITraceSweepInfo_getOATPtr = function(this: ITraceSweepInfo): Int64; cdecl;
  ITraceSweepInfo_getNextPtr = function(this: ITraceSweepInfo): Int64; cdecl;
  ITraceSweepInfo_getPerfPtr = function(this: ITraceSweepInfo): PerformanceInfoPtr; cdecl;
  ITraceLogWriter_writePtr = function(this: ITraceLogWriter; buf: Pointer; size: Cardinal): Cardinal; cdecl;
  ITraceLogWriter_write_sPtr = function(this: ITraceLogWriter; status: IStatus; buf: Pointer; size: Cardinal): Cardinal; cdecl;
  ITraceInitInfo_getConfigTextPtr = function(this: ITraceInitInfo): PAnsiChar; cdecl;
  ITraceInitInfo_getTraceSessionIDPtr = function(this: ITraceInitInfo): Integer; cdecl;
  ITraceInitInfo_getTraceSessionNamePtr = function(this: ITraceInitInfo): PAnsiChar; cdecl;
  ITraceInitInfo_getFirebirdRootDirectoryPtr = function(this: ITraceInitInfo): PAnsiChar; cdecl;
  ITraceInitInfo_getDatabaseNamePtr = function(this: ITraceInitInfo): PAnsiChar; cdecl;
  ITraceInitInfo_getConnectionPtr = function(this: ITraceInitInfo): ITraceDatabaseConnection; cdecl;
  ITraceInitInfo_getLogWriterPtr = function(this: ITraceInitInfo): ITraceLogWriter; cdecl;
  ITracePlugin_trace_get_errorPtr = function(this: ITracePlugin): PAnsiChar; cdecl;
  ITracePlugin_trace_attachPtr = function(this: ITracePlugin; connection: ITraceDatabaseConnection; create_db: Boolean; att_result: Cardinal)
    : Boolean; cdecl;
  ITracePlugin_trace_detachPtr = function(this: ITracePlugin; connection: ITraceDatabaseConnection; drop_db: Boolean): Boolean; cdecl;
  ITracePlugin_trace_transaction_startPtr = function(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
    tpb_length: Cardinal; tpb: BytePtr; tra_result: Cardinal): Boolean; cdecl;
  ITracePlugin_trace_transaction_endPtr = function(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
    commit: Boolean; retain_context: Boolean; tra_result: Cardinal): Boolean; cdecl;
  ITracePlugin_trace_proc_executePtr = function(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
    procedure_: ITraceProcedure; started: Boolean; proc_result: Cardinal): Boolean; cdecl;
  ITracePlugin_trace_trigger_executePtr = function(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
    trigger: ITraceTrigger; started: Boolean; trig_result: Cardinal): Boolean; cdecl;
  ITracePlugin_trace_set_contextPtr = function(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
    variable: ITraceContextVariable): Boolean; cdecl;
  ITracePlugin_trace_dsql_preparePtr = function(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
    statement: ITraceSQLStatement; time_millis: Int64; req_result: Cardinal): Boolean; cdecl;
  ITracePlugin_trace_dsql_freePtr = function(this: ITracePlugin; connection: ITraceDatabaseConnection; statement: ITraceSQLStatement;
    option: Cardinal): Boolean; cdecl;
  ITracePlugin_trace_dsql_executePtr = function(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
    statement: ITraceSQLStatement; started: Boolean; req_result: Cardinal): Boolean; cdecl;
  ITracePlugin_trace_blr_compilePtr = function(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
    statement: ITraceBLRStatement; time_millis: Int64; req_result: Cardinal): Boolean; cdecl;
  ITracePlugin_trace_blr_executePtr = function(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
    statement: ITraceBLRStatement; req_result: Cardinal): Boolean; cdecl;
  ITracePlugin_trace_dyn_executePtr = function(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
    request: ITraceDYNRequest; time_millis: Int64; req_result: Cardinal): Boolean; cdecl;
  ITracePlugin_trace_service_attachPtr = function(this: ITracePlugin; service: ITraceServiceConnection; att_result: Cardinal): Boolean; cdecl;
  ITracePlugin_trace_service_startPtr = function(this: ITracePlugin; service: ITraceServiceConnection; switches_length: Cardinal; switches: PAnsiChar;
    start_result: Cardinal): Boolean; cdecl;
  ITracePlugin_trace_service_queryPtr = function(this: ITracePlugin; service: ITraceServiceConnection; send_item_length: Cardinal;
    send_items: BytePtr; recv_item_length: Cardinal; recv_items: BytePtr; query_result: Cardinal): Boolean; cdecl;
  ITracePlugin_trace_service_detachPtr = function(this: ITracePlugin; service: ITraceServiceConnection; detach_result: Cardinal): Boolean; cdecl;
  ITracePlugin_trace_event_errorPtr = function(this: ITracePlugin; connection: ITraceConnection; status: ITraceStatusVector; function_: PAnsiChar)
    : Boolean; cdecl;
  ITracePlugin_trace_event_sweepPtr = function(this: ITracePlugin; connection: ITraceDatabaseConnection; sweep: ITraceSweepInfo;
    sweep_state: Cardinal): Boolean; cdecl;
  ITracePlugin_trace_func_executePtr = function(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
    function_: ITraceFunction; started: Boolean; func_result: Cardinal): Boolean; cdecl;
  ITraceFactory_trace_needsPtr = function(this: ITraceFactory): QWord; cdecl;
  ITraceFactory_trace_createPtr = function(this: ITraceFactory; status: IStatus; init_info: ITraceInitInfo): ITracePlugin; cdecl;
  IUdrFunctionFactory_setupPtr = procedure(this: IUdrFunctionFactory; status: IStatus; context: IExternalContext; metadata: IRoutineMetadata;
    inBuilder: IMetadataBuilder; outBuilder: IMetadataBuilder); cdecl;
  IUdrFunctionFactory_newItemPtr = function(this: IUdrFunctionFactory; status: IStatus; context: IExternalContext; metadata: IRoutineMetadata)
    : IExternalFunction; cdecl;
  IUdrProcedureFactory_setupPtr = procedure(this: IUdrProcedureFactory; status: IStatus; context: IExternalContext; metadata: IRoutineMetadata;
    inBuilder: IMetadataBuilder; outBuilder: IMetadataBuilder); cdecl;
  IUdrProcedureFactory_newItemPtr = function(this: IUdrProcedureFactory; status: IStatus; context: IExternalContext; metadata: IRoutineMetadata)
    : IExternalProcedure; cdecl;
  IUdrTriggerFactory_setupPtr = procedure(this: IUdrTriggerFactory; status: IStatus; context: IExternalContext; metadata: IRoutineMetadata;
    fieldsBuilder: IMetadataBuilder); cdecl;
  IUdrTriggerFactory_newItemPtr = function(this: IUdrTriggerFactory; status: IStatus; context: IExternalContext; metadata: IRoutineMetadata)
                                                      : IExternalTrigger; cdecl;
  IUdrPlugin_getMasterPtr = function(this: IUdrPlugin): IMaster; cdecl;
  IUdrPlugin_registerFunctionPtr = procedure(this: IUdrPlugin; status: IStatus; name: PAnsiChar; factory: IUdrFunctionFactory); cdecl;
  IUdrPlugin_registerProcedurePtr = procedure(this: IUdrPlugin; status: IStatus; name: PAnsiChar; factory: IUdrProcedureFactory); cdecl;
  IUdrPlugin_registerTriggerPtr = procedure(this: IUdrPlugin; status: IStatus; name: PAnsiChar; factory: IUdrTriggerFactory); cdecl;

  VersionedVTable = class
    version: NativeInt;
  end;

  IVersioned = class
    vTable: VersionedVTable;

  const
    version = 1;

  end;

  IVersionedImpl = class(IVersioned)
    constructor create;

  end;

  ReferenceCountedVTable = class(VersionedVTable)
    addRef: IReferenceCounted_addRefPtr;
    release: IReferenceCounted_releasePtr;
  end;

  IReferenceCounted = class(IVersioned)
  const
    version = 2;

    procedure addRef();
    function release(): Integer;
  end;

  IReferenceCountedImpl = class(IReferenceCounted)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
  end;

  DisposableVTable = class(VersionedVTable)
    dispose: IDisposable_disposePtr;
  end;

  IDisposable = class(IVersioned)
  const
    version = 2;

    procedure dispose();
  end;

  IDisposableImpl = class(IDisposable)
    constructor create;

    procedure dispose(); virtual; abstract;
  end;

  StatusVTable = class(DisposableVTable)
    init: IStatus_initPtr;
    getState: IStatus_getStatePtr;
    setErrors2: IStatus_setErrors2Ptr;
    setWarnings2: IStatus_setWarnings2Ptr;
    setErrors: IStatus_setErrorsPtr;
    setWarnings: IStatus_setWarningsPtr;
    getErrors: IStatus_getErrorsPtr;
    getWarnings: IStatus_getWarningsPtr;
    clone: IStatus_clonePtr;
  end;

  IStatus = class(IDisposable)
  const
    version = 3;

  const
    STATE_WARNINGS = Cardinal($1);

  const
    STATE_ERRORS = Cardinal($2);

  const
    RESULT_ERROR = Integer(-1);

  const
    RESULT_OK = Integer(0);

  const
    RESULT_NO_DATA = Integer(1);

  const
    RESULT_SEGMENT = Integer(2);

    procedure init();
    function getState(): Cardinal;
    procedure setErrors2(length: Cardinal; value: NativeIntPtr);
    procedure setWarnings2(length: Cardinal; value: NativeIntPtr);
    procedure setErrors(value: NativeIntPtr);
    procedure setWarnings(value: NativeIntPtr);
    function getErrors(): NativeIntPtr;
    function getWarnings(): NativeIntPtr;
    function clone(): IStatus;
  end;

  IStatusImpl = class(IStatus)
    constructor create;

    procedure dispose(); virtual; abstract;
    procedure init(); virtual; abstract;
    function getState(): Cardinal; virtual; abstract;
    procedure setErrors2(length: Cardinal; value: NativeIntPtr); virtual; abstract;
    procedure setWarnings2(length: Cardinal; value: NativeIntPtr); virtual; abstract;
    procedure setErrors(value: NativeIntPtr); virtual; abstract;
    procedure setWarnings(value: NativeIntPtr); virtual; abstract;
    function getErrors(): NativeIntPtr; virtual; abstract;
    function getWarnings(): NativeIntPtr; virtual; abstract;
    function clone(): IStatus; virtual; abstract;
  end;

  MasterVTable = class(VersionedVTable)
    getStatus: IMaster_getStatusPtr;
    getDispatcher: IMaster_getDispatcherPtr;
    getPluginManager: IMaster_getPluginManagerPtr;
    getTimerControl: IMaster_getTimerControlPtr;
    getDtc: IMaster_getDtcPtr;
    registerAttachment: IMaster_registerAttachmentPtr;
    registerTransaction: IMaster_registerTransactionPtr;
    getMetadataBuilder: IMaster_getMetadataBuilderPtr;
    serverMode: IMaster_serverModePtr;
    getUtilInterface: IMaster_getUtilInterfacePtr;
    getConfigManager: IMaster_getConfigManagerPtr;
    getProcessExiting: IMaster_getProcessExitingPtr;
  end;

  IMaster = class(IVersioned)
  const
    version = 2;

    function getStatus(): IStatus;
    function getDispatcher(): IProvider;
    function getPluginManager(): IPluginManager;
    function getTimerControl(): ITimerControl;
    function getDtc(): IDtc;
    function registerAttachment(provider: IProvider; attachment: IAttachment): IAttachment;
    function registerTransaction(attachment: IAttachment; transaction: ITransaction): ITransaction;
    function getMetadataBuilder(status: IStatus; fieldCount: Cardinal): IMetadataBuilder;
    function serverMode(mode: Integer): Integer;
    function getUtilInterface(): IUtil;
    function getConfigManager(): IConfigManager;
    function getProcessExiting(): Boolean;
  end;

  IMasterImpl = class(IMaster)
    constructor create;

    function getStatus(): IStatus; virtual; abstract;
    function getDispatcher(): IProvider; virtual; abstract;
    function getPluginManager(): IPluginManager; virtual; abstract;
    function getTimerControl(): ITimerControl; virtual; abstract;
    function getDtc(): IDtc; virtual; abstract;
    function registerAttachment(provider: IProvider; attachment: IAttachment): IAttachment; virtual; abstract;
    function registerTransaction(attachment: IAttachment; transaction: ITransaction): ITransaction; virtual; abstract;
    function getMetadataBuilder(status: IStatus; fieldCount: Cardinal): IMetadataBuilder; virtual; abstract;
    function serverMode(mode: Integer): Integer; virtual; abstract;
    function getUtilInterface(): IUtil; virtual; abstract;
    function getConfigManager(): IConfigManager; virtual; abstract;
    function getProcessExiting(): Boolean; virtual; abstract;
  end;

  PluginBaseVTable = class(ReferenceCountedVTable)
    setOwner: IPluginBase_setOwnerPtr;
    getOwner: IPluginBase_getOwnerPtr;
  end;

  IPluginBase = class(IReferenceCounted)
  const
    version = 3;

    procedure setOwner(r: IReferenceCounted);
    function getOwner(): IReferenceCounted;
  end;

  IPluginBaseImpl = class(IPluginBase)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: IReferenceCounted); virtual; abstract;
    function getOwner(): IReferenceCounted; virtual; abstract;
  end;

  PluginSetVTable = class(ReferenceCountedVTable)
    getName: IPluginSet_getNamePtr;
    getModuleName: IPluginSet_getModuleNamePtr;
    getPlugin: IPluginSet_getPluginPtr;
    next: IPluginSet_nextPtr;
    set_: IPluginSet_set_Ptr;
  end;

  IPluginSet = class(IReferenceCounted)
  const
    version = 3;

    function getName(): PAnsiChar;
    function getModuleName(): PAnsiChar;
    function getPlugin(status: IStatus): IPluginBase;
    procedure next(status: IStatus);
    procedure set_(status: IStatus; s: PAnsiChar);
  end;

  IPluginSetImpl = class(IPluginSet)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function getName(): PAnsiChar; virtual; abstract;
    function getModuleName(): PAnsiChar; virtual; abstract;
    function getPlugin(status: IStatus): IPluginBase; virtual; abstract;
    procedure next(status: IStatus); virtual; abstract;
    procedure set_(status: IStatus; s: PAnsiChar); virtual; abstract;
  end;

  ConfigEntryVTable = class(ReferenceCountedVTable)
    getName: IConfigEntry_getNamePtr;
    getValue: IConfigEntry_getValuePtr;
    getIntValue: IConfigEntry_getIntValuePtr;
    getBoolValue: IConfigEntry_getBoolValuePtr;
    getSubConfig: IConfigEntry_getSubConfigPtr;
  end;

  IConfigEntry = class(IReferenceCounted)
  const
    version = 3;

    function getName(): PAnsiChar;
    function getValue(): PAnsiChar;
    function getIntValue(): Int64;
    function getBoolValue(): Boolean;
    function getSubConfig(status: IStatus): IConfig;
  end;

  IConfigEntryImpl = class(IConfigEntry)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function getName(): PAnsiChar; virtual; abstract;
    function getValue(): PAnsiChar; virtual; abstract;
    function getIntValue(): Int64; virtual; abstract;
    function getBoolValue(): Boolean; virtual; abstract;
    function getSubConfig(status: IStatus): IConfig; virtual; abstract;
  end;

  ConfigVTable = class(ReferenceCountedVTable)
    find: IConfig_findPtr;
    findValue: IConfig_findValuePtr;
    findPos: IConfig_findPosPtr;
  end;

  IConfig = class(IReferenceCounted)
  const
    version = 3;

    function find(status: IStatus; name: PAnsiChar): IConfigEntry;
    function findValue(status: IStatus; name: PAnsiChar; value: PAnsiChar): IConfigEntry;
    function findPos(status: IStatus; name: PAnsiChar; pos: Cardinal): IConfigEntry;
  end;

  IConfigImpl = class(IConfig)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function find(status: IStatus; name: PAnsiChar): IConfigEntry; virtual; abstract;
    function findValue(status: IStatus; name: PAnsiChar; value: PAnsiChar): IConfigEntry; virtual; abstract;
    function findPos(status: IStatus; name: PAnsiChar; pos: Cardinal): IConfigEntry; virtual; abstract;
  end;

  FirebirdConfVTable = class(ReferenceCountedVTable)
    getKey: IFirebirdConf_getKeyPtr;
    asInteger: IFirebirdConf_asIntegerPtr;
    asString: IFirebirdConf_asStringPtr;
    asBoolean: IFirebirdConf_asBooleanPtr;
  end;

  IFirebirdConf = class(IReferenceCounted)
  const
    version = 3;

    function getKey(name: PAnsiChar): Cardinal;
    function asInteger(key: Cardinal): Int64;
    function asString(key: Cardinal): PAnsiChar;
    function asBoolean(key: Cardinal): Boolean;
  end;

  IFirebirdConfImpl = class(IFirebirdConf)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function getKey(name: PAnsiChar): Cardinal; virtual; abstract;
    function asInteger(key: Cardinal): Int64; virtual; abstract;
    function asString(key: Cardinal): PAnsiChar; virtual; abstract;
    function asBoolean(key: Cardinal): Boolean; virtual; abstract;
  end;

  PluginConfigVTable = class(ReferenceCountedVTable)
    getConfigFileName: IPluginConfig_getConfigFileNamePtr;
    getDefaultConfig: IPluginConfig_getDefaultConfigPtr;
    getFirebirdConf: IPluginConfig_getFirebirdConfPtr;
    setReleaseDelay: IPluginConfig_setReleaseDelayPtr;
  end;

  IPluginConfig = class(IReferenceCounted)
  const
    version = 3;

    function getConfigFileName(): PAnsiChar;
    function getDefaultConfig(status: IStatus): IConfig;
    function getFirebirdConf(status: IStatus): IFirebirdConf;
    procedure setReleaseDelay(status: IStatus; microSeconds: QWord);
  end;

  IPluginConfigImpl = class(IPluginConfig)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function getConfigFileName(): PAnsiChar; virtual; abstract;
    function getDefaultConfig(status: IStatus): IConfig; virtual; abstract;
    function getFirebirdConf(status: IStatus): IFirebirdConf; virtual; abstract;
    procedure setReleaseDelay(status: IStatus; microSeconds: QWord); virtual; abstract;
  end;

  PluginFactoryVTable = class(VersionedVTable)
    createPlugin: IPluginFactory_createPluginPtr;
  end;

  IPluginFactory = class(IVersioned)
  const
    version = 2;

    function createPlugin(status: IStatus; factoryParameter: IPluginConfig): IPluginBase;
  end;

  IPluginFactoryImpl = class(IPluginFactory)
    constructor create;

    function createPlugin(status: IStatus; factoryParameter: IPluginConfig): IPluginBase; virtual; abstract;
  end;

  PluginModuleVTable = class(VersionedVTable)
    doClean: IPluginModule_doCleanPtr;
    threadDetach: IPluginModule_threadDetachPtr;
  end;

  IPluginModule = class(IVersioned)
  const
    version = 3;

    procedure doClean();
    procedure threadDetach();
  end;

  IPluginModuleImpl = class(IPluginModule)
    constructor create;

    procedure doClean(); virtual; abstract;
    procedure threadDetach(); virtual; abstract;
  end;

  PluginManagerVTable = class(VersionedVTable)
    registerPluginFactory: IPluginManager_registerPluginFactoryPtr;
    registerModule: IPluginManager_registerModulePtr;
    unregisterModule: IPluginManager_unregisterModulePtr;
    getPlugins: IPluginManager_getPluginsPtr;
    getConfig: IPluginManager_getConfigPtr;
    releasePlugin: IPluginManager_releasePluginPtr;
  end;

  IPluginManager = class(IVersioned)
  const
    version = 2;

  const
    TYPE_PROVIDER = Cardinal(1);

  const
    TYPE_FIRST_NON_LIB = Cardinal(2);

  const
    TYPE_AUTH_SERVER = Cardinal(3);

  const
    TYPE_AUTH_CLIENT = Cardinal(4);

  const
    TYPE_AUTH_USER_MANAGEMENT = Cardinal(5);

  const
    TYPE_EXTERNAL_ENGINE = Cardinal(6);

  const
    TYPE_TRACE = Cardinal(7);

  const
    TYPE_WIRE_CRYPT = Cardinal(8);

  const
    TYPE_DB_CRYPT = Cardinal(9);

  const
    TYPE_KEY_HOLDER = Cardinal(10);

  const
    TYPE_COUNT = Cardinal(11);

    procedure registerPluginFactory(pluginType: Cardinal; defaultName: PAnsiChar; factory: IPluginFactory);
    procedure registerModule(cleanup: IPluginModule);
    procedure unregisterModule(cleanup: IPluginModule);
    function getPlugins(status: IStatus; pluginType: Cardinal; namesList: PAnsiChar; firebirdConf: IFirebirdConf): IPluginSet;
    function getConfig(status: IStatus; filename: PAnsiChar): IConfig;
    procedure releasePlugin(plugin: IPluginBase);
  end;

  IPluginManagerImpl = class(IPluginManager)
    constructor create;

    procedure registerPluginFactory(pluginType: Cardinal; defaultName: PAnsiChar; factory: IPluginFactory); virtual; abstract;
    procedure registerModule(cleanup: IPluginModule); virtual; abstract;
    procedure unregisterModule(cleanup: IPluginModule); virtual; abstract;
    function getPlugins(status: IStatus; pluginType: Cardinal; namesList: PAnsiChar; firebirdConf: IFirebirdConf): IPluginSet; virtual; abstract;
    function getConfig(status: IStatus; filename: PAnsiChar): IConfig; virtual; abstract;
    procedure releasePlugin(plugin: IPluginBase); virtual; abstract;
  end;

  CryptKeyVTable = class(VersionedVTable)
    setSymmetric: ICryptKey_setSymmetricPtr;
    setAsymmetric: ICryptKey_setAsymmetricPtr;
    getEncryptKey: ICryptKey_getEncryptKeyPtr;
    getDecryptKey: ICryptKey_getDecryptKeyPtr;
  end;

  ICryptKey = class(IVersioned)
  const
    version = 2;

    procedure setSymmetric(status: IStatus; type_: PAnsiChar; keyLength: Cardinal; key: Pointer);
    procedure setAsymmetric(status: IStatus; type_: PAnsiChar; encryptKeyLength: Cardinal; encryptKey: Pointer; decryptKeyLength: Cardinal;
      decryptKey: Pointer);
    function getEncryptKey(length: CardinalPtr): Pointer;
    function getDecryptKey(length: CardinalPtr): Pointer;
  end;

  ICryptKeyImpl = class(ICryptKey)
    constructor create;

    procedure setSymmetric(status: IStatus; type_: PAnsiChar; keyLength: Cardinal; key: Pointer); virtual; abstract;
    procedure setAsymmetric(status: IStatus; type_: PAnsiChar; encryptKeyLength: Cardinal; encryptKey: Pointer; decryptKeyLength: Cardinal;
      decryptKey: Pointer); virtual; abstract;
    function getEncryptKey(length: CardinalPtr): Pointer; virtual; abstract;
    function getDecryptKey(length: CardinalPtr): Pointer; virtual; abstract;
  end;

  ConfigManagerVTable = class(VersionedVTable)
    getDirectory: IConfigManager_getDirectoryPtr;
    getFirebirdConf: IConfigManager_getFirebirdConfPtr;
    getDatabaseConf: IConfigManager_getDatabaseConfPtr;
    getPluginConfig: IConfigManager_getPluginConfigPtr;
    getInstallDirectory: IConfigManager_getInstallDirectoryPtr;
    getRootDirectory: IConfigManager_getRootDirectoryPtr;
    getDefaultSecurityDb: IConfigManager_getDefaultSecurityDbPtr;
  end;

  IConfigManager = class(IVersioned)
  const
    version = 3;

  const
    DIR_BIN = Cardinal(0);

  const
    DIR_SBIN = Cardinal(1);

  const
    DIR_CONF = Cardinal(2);

  const
    DIR_LIB = Cardinal(3);

  const
    DIR_INC = Cardinal(4);

  const
    DIR_DOC = Cardinal(5);

  const
    DIR_UDF = Cardinal(6);

  const
    DIR_SAMPLE = Cardinal(7);

  const
    DIR_SAMPLEDB = Cardinal(8);

  const
    DIR_HELP = Cardinal(9);

  const
    DIR_INTL = Cardinal(10);

  const
    DIR_MISC = Cardinal(11);

  const
    DIR_SECDB = Cardinal(12);

  const
    DIR_MSG = Cardinal(13);

  const
    DIR_LOG = Cardinal(14);

  const
    DIR_GUARD = Cardinal(15);

  const
    DIR_PLUGINS = Cardinal(16);

  const
    DIR_COUNT = Cardinal(17);

    function getDirectory(code: Cardinal): PAnsiChar;
    function getFirebirdConf(): IFirebirdConf;
    function getDatabaseConf(dbName: PAnsiChar): IFirebirdConf;
    function getPluginConfig(configuredPlugin: PAnsiChar): IConfig;
    function getInstallDirectory(): PAnsiChar;
    function getRootDirectory(): PAnsiChar;
    function getDefaultSecurityDb(): PAnsiChar;
  end;

  IConfigManagerImpl = class(IConfigManager)
    constructor create;

    function getDirectory(code: Cardinal): PAnsiChar; virtual; abstract;
    function getFirebirdConf(): IFirebirdConf; virtual; abstract;
    function getDatabaseConf(dbName: PAnsiChar): IFirebirdConf; virtual; abstract;
    function getPluginConfig(configuredPlugin: PAnsiChar): IConfig; virtual; abstract;
    function getInstallDirectory(): PAnsiChar; virtual; abstract;
    function getRootDirectory(): PAnsiChar; virtual; abstract;
    function getDefaultSecurityDb(): PAnsiChar; virtual; abstract;
  end;

  EventCallbackVTable = class(ReferenceCountedVTable)
    eventCallbackFunction: IEventCallback_eventCallbackFunctionPtr;
  end;

  IEventCallback = class(IReferenceCounted)
  const
    version = 3;

    procedure eventCallbackFunction(length: Cardinal; events: BytePtr);
  end;

  IEventCallbackImpl = class(IEventCallback)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure eventCallbackFunction(length: Cardinal; events: BytePtr); virtual; abstract;
  end;

  BlobVTable = class(ReferenceCountedVTable)
    getInfo: IBlob_getInfoPtr;
    getSegment: IBlob_getSegmentPtr;
    putSegment: IBlob_putSegmentPtr;
    cancel: IBlob_cancelPtr;
    close: IBlob_closePtr;
    seek: IBlob_seekPtr;
  end;

  IBlob = class(IReferenceCounted)
  const
    version = 3;

    procedure getInfo(status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
    function getSegment(status: IStatus; bufferLength: Cardinal; buffer: Pointer; var segmentLength: Cardinal): Integer;
    procedure putSegment(status: IStatus; length: Cardinal; buffer: Pointer);
    procedure cancel(status: IStatus);
    procedure close(status: IStatus);
    function seek(status: IStatus; mode: Integer; offset: Integer): Integer;
  end;

  IBlobImpl = class(IBlob)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure getInfo(status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr); virtual; abstract;
    function getSegment(status: IStatus; bufferLength: Cardinal; buffer: Pointer; segmentLength: CardinalPtr): Integer; virtual; abstract;
    procedure putSegment(status: IStatus; length: Cardinal; buffer: Pointer); virtual; abstract;
    procedure cancel(status: IStatus); virtual; abstract;
    procedure close(status: IStatus); virtual; abstract;
    function seek(status: IStatus; mode: Integer; offset: Integer): Integer; virtual; abstract;
  end;

  TransactionVTable = class(ReferenceCountedVTable)
    getInfo: ITransaction_getInfoPtr;
    prepare: ITransaction_preparePtr;
    commit: ITransaction_commitPtr;
    commitRetaining: ITransaction_commitRetainingPtr;
    rollback: ITransaction_rollbackPtr;
    rollbackRetaining: ITransaction_rollbackRetainingPtr;
    disconnect: ITransaction_disconnectPtr;
    join: ITransaction_joinPtr;
    validate: ITransaction_validatePtr;
    enterDtc: ITransaction_enterDtcPtr;
  end;

  ITransaction = class(IReferenceCounted)
  const
    version = 3;

    procedure getInfo(status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
    procedure prepare(status: IStatus; msgLength: Cardinal; message: BytePtr);
    procedure commit(status: IStatus);
    procedure commitRetaining(status: IStatus);
    procedure rollback(status: IStatus);
    procedure rollbackRetaining(status: IStatus);
    procedure disconnect(status: IStatus);
    function join(status: IStatus; transaction: ITransaction): ITransaction;
    function validate(status: IStatus; attachment: IAttachment): ITransaction;
    function enterDtc(status: IStatus): ITransaction;
  end;

  ITransactionImpl = class(ITransaction)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure getInfo(status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr); virtual; abstract;
    procedure prepare(status: IStatus; msgLength: Cardinal; message: BytePtr); virtual; abstract;
    procedure commit(status: IStatus); virtual; abstract;
    procedure commitRetaining(status: IStatus); virtual; abstract;
    procedure rollback(status: IStatus); virtual; abstract;
    procedure rollbackRetaining(status: IStatus); virtual; abstract;
    procedure disconnect(status: IStatus); virtual; abstract;
    function join(status: IStatus; transaction: ITransaction): ITransaction; virtual; abstract;
    function validate(status: IStatus; attachment: IAttachment): ITransaction; virtual; abstract;
    function enterDtc(status: IStatus): ITransaction; virtual; abstract;
  end;

  MessageMetadataVTable = class(ReferenceCountedVTable)
    getCount: IMessageMetadata_getCountPtr;
    getField: IMessageMetadata_getFieldPtr;
    getRelation: IMessageMetadata_getRelationPtr;
    getOwner: IMessageMetadata_getOwnerPtr;
    getAlias: IMessageMetadata_getAliasPtr;
    getType: IMessageMetadata_getTypePtr;
    isNullable: IMessageMetadata_isNullablePtr;
    getSubType: IMessageMetadata_getSubTypePtr;
    getLength: IMessageMetadata_getLengthPtr;
    getScale: IMessageMetadata_getScalePtr;
    getCharSet: IMessageMetadata_getCharSetPtr;
    getOffset: IMessageMetadata_getOffsetPtr;
    getNullOffset: IMessageMetadata_getNullOffsetPtr;
    getBuilder: IMessageMetadata_getBuilderPtr;
    getMessageLength: IMessageMetadata_getMessageLengthPtr;
  end;

  IMessageMetadata = class(IReferenceCounted)
  const
    version = 3;

    function getCount(status: IStatus): Cardinal;
    function getField(status: IStatus; index: Cardinal): PAnsiChar;
    function getRelation(status: IStatus; index: Cardinal): PAnsiChar;
    function getOwner(status: IStatus; index: Cardinal): PAnsiChar;
    function getAlias(status: IStatus; index: Cardinal): PAnsiChar;
    function getType(status: IStatus; index: Cardinal): Cardinal;
    function isNullable(status: IStatus; index: Cardinal): Boolean;
    function getSubType(status: IStatus; index: Cardinal): Integer;
    function getLength(status: IStatus; index: Cardinal): Cardinal;
    function getScale(status: IStatus; index: Cardinal): Integer;
    function getCharSet(status: IStatus; index: Cardinal): Cardinal;
    function getOffset(status: IStatus; index: Cardinal): Cardinal;
    function getNullOffset(status: IStatus; index: Cardinal): Cardinal;
    function getBuilder(status: IStatus): IMetadataBuilder;
    function getMessageLength(status: IStatus): Cardinal;
  end;

  IMessageMetadataImpl = class(IMessageMetadata)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function getCount(status: IStatus): Cardinal; virtual; abstract;
    function getField(status: IStatus; index: Cardinal): PAnsiChar; virtual; abstract;
    function getRelation(status: IStatus; index: Cardinal): PAnsiChar; virtual; abstract;
    function getOwner(status: IStatus; index: Cardinal): PAnsiChar; virtual; abstract;
    function getAlias(status: IStatus; index: Cardinal): PAnsiChar; virtual; abstract;
    function getType(status: IStatus; index: Cardinal): Cardinal; virtual; abstract;
    function isNullable(status: IStatus; index: Cardinal): Boolean; virtual; abstract;
    function getSubType(status: IStatus; index: Cardinal): Integer; virtual; abstract;
    function getLength(status: IStatus; index: Cardinal): Cardinal; virtual; abstract;
    function getScale(status: IStatus; index: Cardinal): Integer; virtual; abstract;
    function getCharSet(status: IStatus; index: Cardinal): Cardinal; virtual; abstract;
    function getOffset(status: IStatus; index: Cardinal): Cardinal; virtual; abstract;
    function getNullOffset(status: IStatus; index: Cardinal): Cardinal; virtual; abstract;
    function getBuilder(status: IStatus): IMetadataBuilder; virtual; abstract;
    function getMessageLength(status: IStatus): Cardinal; virtual; abstract;
  end;

  MetadataBuilderVTable = class(ReferenceCountedVTable)
    setType: IMetadataBuilder_setTypePtr;
    setSubType: IMetadataBuilder_setSubTypePtr;
    setLength: IMetadataBuilder_setLengthPtr;
    setCharSet: IMetadataBuilder_setCharSetPtr;
    setScale: IMetadataBuilder_setScalePtr;
    truncate: IMetadataBuilder_truncatePtr;
    moveNameToIndex: IMetadataBuilder_moveNameToIndexPtr;
    remove: IMetadataBuilder_removePtr;
    addField: IMetadataBuilder_addFieldPtr;
    getMetadata: IMetadataBuilder_getMetadataPtr;
  end;

  IMetadataBuilder = class(IReferenceCounted)
  const
    version = 3;

    procedure setType(status: IStatus; index: Cardinal; type_: Cardinal);
    procedure setSubType(status: IStatus; index: Cardinal; subType: Integer);
    procedure setLength(status: IStatus; index: Cardinal; length: Cardinal);
    procedure setCharSet(status: IStatus; index: Cardinal; charSet: Cardinal);
    procedure setScale(status: IStatus; index: Cardinal; scale: Integer);
    procedure truncate(status: IStatus; count: Cardinal);
    procedure moveNameToIndex(status: IStatus; name: PAnsiChar; index: Cardinal);
    procedure remove(status: IStatus; index: Cardinal);
    function addField(status: IStatus): Cardinal;
    function getMetadata(status: IStatus): IMessageMetadata;
  end;

  IMetadataBuilderImpl = class(IMetadataBuilder)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setType(status: IStatus; index: Cardinal; type_: Cardinal); virtual; abstract;
    procedure setSubType(status: IStatus; index: Cardinal; subType: Integer); virtual; abstract;
    procedure setLength(status: IStatus; index: Cardinal; length: Cardinal); virtual; abstract;
    procedure setCharSet(status: IStatus; index: Cardinal; charSet: Cardinal); virtual; abstract;
    procedure setScale(status: IStatus; index: Cardinal; scale: Integer); virtual; abstract;
    procedure truncate(status: IStatus; count: Cardinal); virtual; abstract;
    procedure moveNameToIndex(status: IStatus; name: PAnsiChar; index: Cardinal); virtual; abstract;
    procedure remove(status: IStatus; index: Cardinal); virtual; abstract;
    function addField(status: IStatus): Cardinal; virtual; abstract;
    function getMetadata(status: IStatus): IMessageMetadata; virtual; abstract;
  end;

  ResultSetVTable = class(ReferenceCountedVTable)
    fetchNext: IResultSet_fetchNextPtr;
    fetchPrior: IResultSet_fetchPriorPtr;
    fetchFirst: IResultSet_fetchFirstPtr;
    fetchLast: IResultSet_fetchLastPtr;
    fetchAbsolute: IResultSet_fetchAbsolutePtr;
    fetchRelative: IResultSet_fetchRelativePtr;
    isEof: IResultSet_isEofPtr;
    isBof: IResultSet_isBofPtr;
    getMetadata: IResultSet_getMetadataPtr;
    close: IResultSet_closePtr;
    setDelayedOutputFormat: IResultSet_setDelayedOutputFormatPtr;
  end;

  IResultSet = class(IReferenceCounted)
  const
    version = 3;

    function fetchNext(status: IStatus; message: Pointer): Integer;
    function fetchPrior(status: IStatus; message: Pointer): Integer;
    function fetchFirst(status: IStatus; message: Pointer): Integer;
    function fetchLast(status: IStatus; message: Pointer): Integer;
    function fetchAbsolute(status: IStatus; position: Integer; message: Pointer): Integer;
    function fetchRelative(status: IStatus; offset: Integer; message: Pointer): Integer;
    function isEof(status: IStatus): Boolean;
    function isBof(status: IStatus): Boolean;
    function getMetadata(status: IStatus): IMessageMetadata;
    procedure close(status: IStatus);
    procedure setDelayedOutputFormat(status: IStatus; format: IMessageMetadata);
  end;

  IResultSetImpl = class(IResultSet)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function fetchNext(status: IStatus; message: Pointer): Integer; virtual; abstract;
    function fetchPrior(status: IStatus; message: Pointer): Integer; virtual; abstract;
    function fetchFirst(status: IStatus; message: Pointer): Integer; virtual; abstract;
    function fetchLast(status: IStatus; message: Pointer): Integer; virtual; abstract;
    function fetchAbsolute(status: IStatus; position: Integer; message: Pointer): Integer; virtual; abstract;
    function fetchRelative(status: IStatus; offset: Integer; message: Pointer): Integer; virtual; abstract;
    function isEof(status: IStatus): Boolean; virtual; abstract;
    function isBof(status: IStatus): Boolean; virtual; abstract;
    function getMetadata(status: IStatus): IMessageMetadata; virtual; abstract;
    procedure close(status: IStatus); virtual; abstract;
    procedure setDelayedOutputFormat(status: IStatus; format: IMessageMetadata); virtual; abstract;
  end;

  StatementVTable = class(ReferenceCountedVTable)
    getInfo: IStatement_getInfoPtr;
    getType: IStatement_getTypePtr;
    getPlan: IStatement_getPlanPtr;
    getAffectedRecords: IStatement_getAffectedRecordsPtr;
    getInputMetadata: IStatement_getInputMetadataPtr;
    getOutputMetadata: IStatement_getOutputMetadataPtr;
    execute: IStatement_executePtr;
    openCursor: IStatement_openCursorPtr;
    setCursorName: IStatement_setCursorNamePtr;
    free: IStatement_freePtr;
    getFlags: IStatement_getFlagsPtr;
  end;

  IStatement = class(IReferenceCounted)
  const
    version = 3;

  const
    PREPARE_PREFETCH_NONE = Cardinal($0);

  const
    PREPARE_PREFETCH_TYPE = Cardinal($1);

  const
    PREPARE_PREFETCH_INPUT_PARAMETERS = Cardinal($2);

  const
    PREPARE_PREFETCH_OUTPUT_PARAMETERS = Cardinal($4);

  const
    PREPARE_PREFETCH_LEGACY_PLAN = Cardinal($8);

  const
    PREPARE_PREFETCH_DETAILED_PLAN = Cardinal($10);

  const
    PREPARE_PREFETCH_AFFECTED_RECORDS = Cardinal($20);

  const
    PREPARE_PREFETCH_FLAGS = Cardinal($40);

  const
    PREPARE_PREFETCH_METADATA = Cardinal(IStatement.PREPARE_PREFETCH_TYPE or IStatement.PREPARE_PREFETCH_FLAGS or
      IStatement.PREPARE_PREFETCH_INPUT_PARAMETERS or IStatement.PREPARE_PREFETCH_OUTPUT_PARAMETERS);

  const
    PREPARE_PREFETCH_ALL = Cardinal(IStatement.PREPARE_PREFETCH_METADATA or IStatement.PREPARE_PREFETCH_LEGACY_PLAN or
      IStatement.PREPARE_PREFETCH_DETAILED_PLAN or IStatement.PREPARE_PREFETCH_AFFECTED_RECORDS);

  const
    FLAG_HAS_CURSOR = Cardinal($1);

  const
    FLAG_REPEAT_EXECUTE = Cardinal($2);

  const
    CURSOR_TYPE_SCROLLABLE = Cardinal($1);

    procedure getInfo(status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
    function getType(status: IStatus): Cardinal;
    function getPlan(status: IStatus; detailed: Boolean): PAnsiChar;
    function getAffectedRecords(status: IStatus): QWord;
    function getInputMetadata(status: IStatus): IMessageMetadata;
    function getOutputMetadata(status: IStatus): IMessageMetadata;
    function execute(status: IStatus; transaction: ITransaction; inMetadata: IMessageMetadata; inBuffer: Pointer; outMetadata: IMessageMetadata;
      outBuffer: Pointer): ITransaction;
    function openCursor(status: IStatus; transaction: ITransaction; inMetadata: IMessageMetadata; inBuffer: Pointer; outMetadata: IMessageMetadata;
      flags: Cardinal): IResultSet;
    procedure setCursorName(status: IStatus; name: PAnsiChar);
    procedure free(status: IStatus);
    function getFlags(status: IStatus): Cardinal;
  end;

  IStatementImpl = class(IStatement)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure getInfo(status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr); virtual; abstract;
    function getType(status: IStatus): Cardinal; virtual; abstract;
    function getPlan(status: IStatus; detailed: Boolean): PAnsiChar; virtual; abstract;
    function getAffectedRecords(status: IStatus): QWord; virtual; abstract;
    function getInputMetadata(status: IStatus): IMessageMetadata; virtual; abstract;
    function getOutputMetadata(status: IStatus): IMessageMetadata; virtual; abstract;
    function execute(status: IStatus; transaction: ITransaction; inMetadata: IMessageMetadata; inBuffer: Pointer; outMetadata: IMessageMetadata;
      outBuffer: Pointer): ITransaction; virtual; abstract;
    function openCursor(status: IStatus; transaction: ITransaction; inMetadata: IMessageMetadata; inBuffer: Pointer; outMetadata: IMessageMetadata;
      flags: Cardinal): IResultSet; virtual; abstract;
    procedure setCursorName(status: IStatus; name: PAnsiChar); virtual; abstract;
    procedure free(status: IStatus); virtual; abstract;
    function getFlags(status: IStatus): Cardinal; virtual; abstract;
  end;

  RequestVTable = class(ReferenceCountedVTable)
    receive: IRequest_receivePtr;
    send: IRequest_sendPtr;
    getInfo: IRequest_getInfoPtr;
    start: IRequest_startPtr;
    startAndSend: IRequest_startAndSendPtr;
    unwind: IRequest_unwindPtr;
    free: IRequest_freePtr;
  end;

  IRequest = class(IReferenceCounted)
  const
    version = 3;

    procedure receive(status: IStatus; level: Integer; msgType: Cardinal; length: Cardinal; message: BytePtr);
    procedure send(status: IStatus; level: Integer; msgType: Cardinal; length: Cardinal; message: BytePtr);
    procedure getInfo(status: IStatus; level: Integer; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
    procedure start(status: IStatus; tra: ITransaction; level: Integer);
    procedure startAndSend(status: IStatus; tra: ITransaction; level: Integer; msgType: Cardinal; length: Cardinal; message: BytePtr);
    procedure unwind(status: IStatus; level: Integer);
    procedure free(status: IStatus);
  end;

  IRequestImpl = class(IRequest)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure receive(status: IStatus; level: Integer; msgType: Cardinal; length: Cardinal; message: BytePtr); virtual; abstract;
    procedure send(status: IStatus; level: Integer; msgType: Cardinal; length: Cardinal; message: BytePtr); virtual; abstract;
    procedure getInfo(status: IStatus; level: Integer; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
      virtual; abstract;
    procedure start(status: IStatus; tra: ITransaction; level: Integer); virtual; abstract;
    procedure startAndSend(status: IStatus; tra: ITransaction; level: Integer; msgType: Cardinal; length: Cardinal; message: BytePtr);
      virtual; abstract;
    procedure unwind(status: IStatus; level: Integer); virtual; abstract;
    procedure free(status: IStatus); virtual; abstract;
  end;

  EventsVTable = class(ReferenceCountedVTable)
    cancel: IEvents_cancelPtr;
  end;

  IEvents = class(IReferenceCounted)
  const
    version = 3;

    procedure cancel(status: IStatus);
  end;

  IEventsImpl = class(IEvents)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure cancel(status: IStatus); virtual; abstract;
  end;

  AttachmentVTable = class(ReferenceCountedVTable)
    getInfo: IAttachment_getInfoPtr;
    startTransaction: IAttachment_startTransactionPtr;
    reconnectTransaction: IAttachment_reconnectTransactionPtr;
    compileRequest: IAttachment_compileRequestPtr;
    transactRequest: IAttachment_transactRequestPtr;
    createBlob: IAttachment_createBlobPtr;
    openBlob: IAttachment_openBlobPtr;
    getSlice: IAttachment_getSlicePtr;
    putSlice: IAttachment_putSlicePtr;
    executeDyn: IAttachment_executeDynPtr;
    prepare: IAttachment_preparePtr;
    execute: IAttachment_executePtr;
    openCursor: IAttachment_openCursorPtr;
    queEvents: IAttachment_queEventsPtr;
    cancelOperation: IAttachment_cancelOperationPtr;
    ping: IAttachment_pingPtr;
    detach: IAttachment_detachPtr;
    dropDatabase: IAttachment_dropDatabasePtr;
  end;

  IAttachment = class(IReferenceCounted)
  const
    version = 3;

    procedure getInfo(status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
    function startTransaction(status: IStatus; tpbLength: Cardinal; tpb: BytePtr): ITransaction;
    function reconnectTransaction(status: IStatus; length: Cardinal; id: BytePtr): ITransaction;
    function compileRequest(status: IStatus; blrLength: Cardinal; blr: BytePtr): IRequest;
    procedure transactRequest(status: IStatus; transaction: ITransaction; blrLength: Cardinal; blr: BytePtr; inMsgLength: Cardinal; inMsg: BytePtr;
      outMsgLength: Cardinal; outMsg: BytePtr);
    function createBlob(status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; bpbLength: Cardinal; bpb: BytePtr): IBlob;
    function openBlob(status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; bpbLength: Cardinal; bpb: BytePtr): IBlob;
    function getSlice(status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; sdlLength: Cardinal; sdl: BytePtr; paramLength: Cardinal;
      param: BytePtr; sliceLength: Integer; slice: BytePtr): Integer;
    procedure putSlice(status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; sdlLength: Cardinal; sdl: BytePtr; paramLength: Cardinal;
      param: BytePtr; sliceLength: Integer; slice: BytePtr);
    procedure executeDyn(status: IStatus; transaction: ITransaction; length: Cardinal; dyn: BytePtr);
    function prepare(status: IStatus; tra: ITransaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal; flags: Cardinal): IStatement;
    function execute(status: IStatus; transaction: ITransaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal;
      inMetadata: IMessageMetadata; inBuffer: Pointer; outMetadata: IMessageMetadata; outBuffer: Pointer): ITransaction;
    function openCursor(status: IStatus; transaction: ITransaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal;
      inMetadata: IMessageMetadata; inBuffer: Pointer; outMetadata: IMessageMetadata; cursorName: PAnsiChar; cursorFlags: Cardinal): IResultSet;
    function queEvents(status: IStatus; callback: IEventCallback; length: Cardinal; events: BytePtr): IEvents;
    procedure cancelOperation(status: IStatus; option: Integer);
    procedure ping(status: IStatus);
    procedure detach(status: IStatus);
    procedure dropDatabase(status: IStatus);
  end;

  IAttachmentImpl = class(IAttachment)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure getInfo(status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr); virtual; abstract;
    function startTransaction(status: IStatus; tpbLength: Cardinal; tpb: BytePtr): ITransaction; virtual; abstract;
    function reconnectTransaction(status: IStatus; length: Cardinal; id: BytePtr): ITransaction; virtual; abstract;
    function compileRequest(status: IStatus; blrLength: Cardinal; blr: BytePtr): IRequest; virtual; abstract;
    procedure transactRequest(status: IStatus; transaction: ITransaction; blrLength: Cardinal; blr: BytePtr; inMsgLength: Cardinal; inMsg: BytePtr;
      outMsgLength: Cardinal; outMsg: BytePtr); virtual; abstract;
    function createBlob(status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; bpbLength: Cardinal; bpb: BytePtr): IBlob; virtual; abstract;
    function openBlob(status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; bpbLength: Cardinal; bpb: BytePtr): IBlob; virtual; abstract;
    function getSlice(status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; sdlLength: Cardinal; sdl: BytePtr; paramLength: Cardinal;
      param: BytePtr; sliceLength: Integer; slice: BytePtr): Integer; virtual; abstract;
    procedure putSlice(status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; sdlLength: Cardinal; sdl: BytePtr; paramLength: Cardinal;
      param: BytePtr; sliceLength: Integer; slice: BytePtr); virtual; abstract;
    procedure executeDyn(status: IStatus; transaction: ITransaction; length: Cardinal; dyn: BytePtr); virtual; abstract;
    function prepare(status: IStatus; tra: ITransaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal; flags: Cardinal): IStatement;
      virtual; abstract;
    function execute(status: IStatus; transaction: ITransaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal;
      inMetadata: IMessageMetadata; inBuffer: Pointer; outMetadata: IMessageMetadata; outBuffer: Pointer): ITransaction; virtual; abstract;
    function openCursor(status: IStatus; transaction: ITransaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal;
      inMetadata: IMessageMetadata; inBuffer: Pointer; outMetadata: IMessageMetadata; cursorName: PAnsiChar; cursorFlags: Cardinal): IResultSet;
      virtual; abstract;
    function queEvents(status: IStatus; callback: IEventCallback; length: Cardinal; events: BytePtr): IEvents; virtual; abstract;
    procedure cancelOperation(status: IStatus; option: Integer); virtual; abstract;
    procedure ping(status: IStatus); virtual; abstract;
    procedure detach(status: IStatus); virtual; abstract;
    procedure dropDatabase(status: IStatus); virtual; abstract;
  end;

  ServiceVTable = class(ReferenceCountedVTable)
    detach: IService_detachPtr;
    query: IService_queryPtr;
    start: IService_startPtr;
  end;

  IService = class(IReferenceCounted)
  const
    version = 3;

    procedure detach(status: IStatus);
    procedure query(status: IStatus; sendLength: Cardinal; sendItems: BytePtr; receiveLength: Cardinal; receiveItems: BytePtr; bufferLength: Cardinal;
      buffer: BytePtr);
    procedure start(status: IStatus; spbLength: Cardinal; spb: BytePtr);
  end;

  IServiceImpl = class(IService)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure detach(status: IStatus); virtual; abstract;
    procedure query(status: IStatus; sendLength: Cardinal; sendItems: BytePtr; receiveLength: Cardinal; receiveItems: BytePtr; bufferLength: Cardinal;
      buffer: BytePtr); virtual; abstract;
    procedure start(status: IStatus; spbLength: Cardinal; spb: BytePtr); virtual; abstract;
  end;

  ProviderVTable = class(PluginBaseVTable)
    attachDatabase: IProvider_attachDatabasePtr;
    createDatabase: IProvider_createDatabasePtr;
    attachServiceManager: IProvider_attachServiceManagerPtr;
    shutdown: IProvider_shutdownPtr;
    setDbCryptCallback: IProvider_setDbCryptCallbackPtr;
  end;

  IProvider = class(IPluginBase)
  const
    version = 4;

    function attachDatabase(status: IStatus; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr): IAttachment;
    function createDatabase(status: IStatus; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr): IAttachment;
    function attachServiceManager(status: IStatus; service: PAnsiChar; spbLength: Cardinal; spb: BytePtr): IService;
    procedure shutdown(status: IStatus; timeout: Cardinal; reason: Integer);
    procedure setDbCryptCallback(status: IStatus; cryptCallback: ICryptKeyCallback);
  end;

  IProviderImpl = class(IProvider)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: IReferenceCounted); virtual; abstract;
    function getOwner(): IReferenceCounted; virtual; abstract;
    function attachDatabase(status: IStatus; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr): IAttachment; virtual; abstract;
    function createDatabase(status: IStatus; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr): IAttachment; virtual; abstract;
    function attachServiceManager(status: IStatus; service: PAnsiChar; spbLength: Cardinal; spb: BytePtr): IService; virtual; abstract;
    procedure shutdown(status: IStatus; timeout: Cardinal; reason: Integer); virtual; abstract;
    procedure setDbCryptCallback(status: IStatus; cryptCallback: ICryptKeyCallback); virtual; abstract;
  end;

  DtcStartVTable = class(DisposableVTable)
    addAttachment: IDtcStart_addAttachmentPtr;
    addWithTpb: IDtcStart_addWithTpbPtr;
    start: IDtcStart_startPtr;
  end;

  IDtcStart = class(IDisposable)
  const
    version = 3;

    procedure addAttachment(status: IStatus; att: IAttachment);
    procedure addWithTpb(status: IStatus; att: IAttachment; length: Cardinal; tpb: BytePtr);
    function start(status: IStatus): ITransaction;
  end;

  IDtcStartImpl = class(IDtcStart)
    constructor create;

    procedure dispose(); virtual; abstract;
    procedure addAttachment(status: IStatus; att: IAttachment); virtual; abstract;
    procedure addWithTpb(status: IStatus; att: IAttachment; length: Cardinal; tpb: BytePtr); virtual; abstract;
    function start(status: IStatus): ITransaction; virtual; abstract;
  end;

  DtcVTable = class(VersionedVTable)
    join: IDtc_joinPtr;
    startBuilder: IDtc_startBuilderPtr;
  end;

  IDtc = class(IVersioned)
  const
    version = 2;

    function join(status: IStatus; one: ITransaction; two: ITransaction): ITransaction;
    function startBuilder(status: IStatus): IDtcStart;
  end;

  IDtcImpl = class(IDtc)
    constructor create;

    function join(status: IStatus; one: ITransaction; two: ITransaction): ITransaction; virtual; abstract;
    function startBuilder(status: IStatus): IDtcStart; virtual; abstract;
  end;

  AuthVTable = class(PluginBaseVTable)
  end;

  IAuth = class(IPluginBase)
  const
    version = 4;

  const
    AUTH_FAILED = Integer(-1);

  const
    AUTH_SUCCESS = Integer(0);

  const
    AUTH_MORE_DATA = Integer(1);

  const
    AUTH_CONTINUE = Integer(2);

  end;

  IAuthImpl = class(IAuth)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: IReferenceCounted); virtual; abstract;
    function getOwner(): IReferenceCounted; virtual; abstract;
  end;

  WriterVTable = class(VersionedVTable)
    reset: IWriter_resetPtr;
    add: IWriter_addPtr;
    setType: IWriter_setTypePtr;
    setDb: IWriter_setDbPtr;
  end;

  IWriter = class(IVersioned)
  const
    version = 2;

    procedure reset();
    procedure add(status: IStatus; name: PAnsiChar);
    procedure setType(status: IStatus; value: PAnsiChar);
    procedure setDb(status: IStatus; value: PAnsiChar);
  end;

  IWriterImpl = class(IWriter)
    constructor create;

    procedure reset(); virtual; abstract;
    procedure add(status: IStatus; name: PAnsiChar); virtual; abstract;
    procedure setType(status: IStatus; value: PAnsiChar); virtual; abstract;
    procedure setDb(status: IStatus; value: PAnsiChar); virtual; abstract;
  end;

  ServerBlockVTable = class(VersionedVTable)
    getLogin: IServerBlock_getLoginPtr;
    getData: IServerBlock_getDataPtr;
    putData: IServerBlock_putDataPtr;
    newKey: IServerBlock_newKeyPtr;
  end;

  IServerBlock = class(IVersioned)
  const
    version = 2;

    function getLogin(): PAnsiChar;
    function getData(length: CardinalPtr): BytePtr;
    procedure putData(status: IStatus; length: Cardinal; data: Pointer);
    function newKey(status: IStatus): ICryptKey;
  end;

  IServerBlockImpl = class(IServerBlock)
    constructor create;

    function getLogin(): PAnsiChar; virtual; abstract;
    function getData(length: CardinalPtr): BytePtr; virtual; abstract;
    procedure putData(status: IStatus; length: Cardinal; data: Pointer); virtual; abstract;
    function newKey(status: IStatus): ICryptKey; virtual; abstract;
  end;

  ClientBlockVTable = class(ReferenceCountedVTable)
    getLogin: IClientBlock_getLoginPtr;
    getPassword: IClientBlock_getPasswordPtr;
    getData: IClientBlock_getDataPtr;
    putData: IClientBlock_putDataPtr;
    newKey: IClientBlock_newKeyPtr;
    getAuthBlock: IClientBlock_getAuthBlockPtr;
  end;

  IClientBlock = class(IReferenceCounted)
  const
    version = 4;

    function getLogin(): PAnsiChar;
    function getPassword(): PAnsiChar;
    function getData(length: CardinalPtr): BytePtr;
    procedure putData(status: IStatus; length: Cardinal; data: Pointer);
    function newKey(status: IStatus): ICryptKey;
    function getAuthBlock(status: IStatus): IAuthBlock;
  end;

  IClientBlockImpl = class(IClientBlock)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function getLogin(): PAnsiChar; virtual; abstract;
    function getPassword(): PAnsiChar; virtual; abstract;
    function getData(length: CardinalPtr): BytePtr; virtual; abstract;
    procedure putData(status: IStatus; length: Cardinal; data: Pointer); virtual; abstract;
    function newKey(status: IStatus): ICryptKey; virtual; abstract;
    function getAuthBlock(status: IStatus): IAuthBlock; virtual; abstract;
  end;

  ServerVTable = class(AuthVTable)
    authenticate: IServer_authenticatePtr;
    setDbCryptCallback: IServer_setDbCryptCallbackPtr;
  end;

  IServer = class(IAuth)
  const
    version = 6;

    function authenticate(status: IStatus; sBlock: IServerBlock; writerInterface: IWriter): Integer;
    procedure setDbCryptCallback(status: IStatus; cryptCallback: ICryptKeyCallback);
  end;

  IServerImpl = class(IServer)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: IReferenceCounted); virtual; abstract;
    function getOwner(): IReferenceCounted; virtual; abstract;
    function authenticate(status: IStatus; sBlock: IServerBlock; writerInterface: IWriter): Integer; virtual; abstract;
    procedure setDbCryptCallback(status: IStatus; cryptCallback: ICryptKeyCallback); virtual; abstract;
  end;

  ClientVTable = class(AuthVTable)
    authenticate: IClient_authenticatePtr;
  end;

  IClient = class(IAuth)
  const
    version = 5;

    function authenticate(status: IStatus; cBlock: IClientBlock): Integer;
  end;

  IClientImpl = class(IClient)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: IReferenceCounted); virtual; abstract;
    function getOwner(): IReferenceCounted; virtual; abstract;
    function authenticate(status: IStatus; cBlock: IClientBlock): Integer; virtual; abstract;
  end;

  UserFieldVTable = class(VersionedVTable)
    entered: IUserField_enteredPtr;
    specified: IUserField_specifiedPtr;
    setEntered: IUserField_setEnteredPtr;
  end;

  IUserField = class(IVersioned)
  const
    version = 2;

    function entered(): Integer;
    function specified(): Integer;
    procedure setEntered(status: IStatus; newValue: Integer);
  end;

  IUserFieldImpl = class(IUserField)
    constructor create;

    function entered(): Integer; virtual; abstract;
    function specified(): Integer; virtual; abstract;
    procedure setEntered(status: IStatus; newValue: Integer); virtual; abstract;
  end;

  CharUserFieldVTable = class(UserFieldVTable)
    get: ICharUserField_getPtr;
    set_: ICharUserField_set_Ptr;
  end;

  ICharUserField = class(IUserField)
  const
    version = 3;

    function get(): PAnsiChar;
    procedure set_(status: IStatus; newValue: PAnsiChar);
  end;

  ICharUserFieldImpl = class(ICharUserField)
    constructor create;

    function entered(): Integer; virtual; abstract;
    function specified(): Integer; virtual; abstract;
    procedure setEntered(status: IStatus; newValue: Integer); virtual; abstract;
    function get(): PAnsiChar; virtual; abstract;
    procedure set_(status: IStatus; newValue: PAnsiChar); virtual; abstract;
  end;

  IntUserFieldVTable = class(UserFieldVTable)
    get: IIntUserField_getPtr;
    set_: IIntUserField_set_Ptr;
  end;

  IIntUserField = class(IUserField)
  const
    version = 3;

    function get(): Integer;
    procedure set_(status: IStatus; newValue: Integer);
  end;

  IIntUserFieldImpl = class(IIntUserField)
    constructor create;

    function entered(): Integer; virtual; abstract;
    function specified(): Integer; virtual; abstract;
    procedure setEntered(status: IStatus; newValue: Integer); virtual; abstract;
    function get(): Integer; virtual; abstract;
    procedure set_(status: IStatus; newValue: Integer); virtual; abstract;
  end;

  UserVTable = class(VersionedVTable)
    operation: IUser_operationPtr;
    userName: IUser_userNamePtr;
    password: IUser_passwordPtr;
    firstName: IUser_firstNamePtr;
    lastName: IUser_lastNamePtr;
    middleName: IUser_middleNamePtr;
    comment: IUser_commentPtr;
    attributes: IUser_attributesPtr;
    active: IUser_activePtr;
    admin: IUser_adminPtr;
    clear: IUser_clearPtr;
  end;

  IUser = class(IVersioned)
  const
    version = 2;

  const
    OP_USER_ADD = Cardinal(1);

  const
    OP_USER_MODIFY = Cardinal(2);

  const
    OP_USER_DELETE = Cardinal(3);

  const
    OP_USER_DISPLAY = Cardinal(4);

  const
    OP_USER_SET_MAP = Cardinal(5);

  const
    OP_USER_DROP_MAP = Cardinal(6);

    function operation(): Cardinal;
    function userName(): ICharUserField;
    function password(): ICharUserField;
    function firstName(): ICharUserField;
    function lastName(): ICharUserField;
    function middleName(): ICharUserField;
    function comment(): ICharUserField;
    function attributes(): ICharUserField;
    function active(): IIntUserField;
    function admin(): IIntUserField;
    procedure clear(status: IStatus);
  end;

  IUserImpl = class(IUser)
    constructor create;

    function operation(): Cardinal; virtual; abstract;
    function userName(): ICharUserField; virtual; abstract;
    function password(): ICharUserField; virtual; abstract;
    function firstName(): ICharUserField; virtual; abstract;
    function lastName(): ICharUserField; virtual; abstract;
    function middleName(): ICharUserField; virtual; abstract;
    function comment(): ICharUserField; virtual; abstract;
    function attributes(): ICharUserField; virtual; abstract;
    function active(): IIntUserField; virtual; abstract;
    function admin(): IIntUserField; virtual; abstract;
    procedure clear(status: IStatus); virtual; abstract;
  end;

  ListUsersVTable = class(VersionedVTable)
    list: IListUsers_listPtr;
  end;

  IListUsers = class(IVersioned)
  const
    version = 2;

    procedure list(status: IStatus; user: IUser);
  end;

  IListUsersImpl = class(IListUsers)
    constructor create;

    procedure list(status: IStatus; user: IUser); virtual; abstract;
  end;

  LogonInfoVTable = class(VersionedVTable)
    name: ILogonInfo_namePtr;
    role: ILogonInfo_rolePtr;
    networkProtocol: ILogonInfo_networkProtocolPtr;
    remoteAddress: ILogonInfo_remoteAddressPtr;
    authBlock: ILogonInfo_authBlockPtr;
  end;

  ILogonInfo = class(IVersioned)
  const
    version = 2;

    function name(): PAnsiChar;
    function role(): PAnsiChar;
    function networkProtocol(): PAnsiChar;
    function remoteAddress(): PAnsiChar;
    function authBlock(length: CardinalPtr): BytePtr;
  end;

  ILogonInfoImpl = class(ILogonInfo)
    constructor create;

    function name(): PAnsiChar; virtual; abstract;
    function role(): PAnsiChar; virtual; abstract;
    function networkProtocol(): PAnsiChar; virtual; abstract;
    function remoteAddress(): PAnsiChar; virtual; abstract;
    function authBlock(length: CardinalPtr): BytePtr; virtual; abstract;
  end;

  ManagementVTable = class(PluginBaseVTable)
    start: IManagement_startPtr;
    execute: IManagement_executePtr;
    commit: IManagement_commitPtr;
    rollback: IManagement_rollbackPtr;
  end;

  IManagement = class(IPluginBase)
  const
    version = 4;

    procedure start(status: IStatus; logonInfo: ILogonInfo);
    function execute(status: IStatus; user: IUser; callback: IListUsers): Integer;
    procedure commit(status: IStatus);
    procedure rollback(status: IStatus);
  end;

  IManagementImpl = class(IManagement)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: IReferenceCounted); virtual; abstract;
    function getOwner(): IReferenceCounted; virtual; abstract;
    procedure start(status: IStatus; logonInfo: ILogonInfo); virtual; abstract;
    function execute(status: IStatus; user: IUser; callback: IListUsers): Integer; virtual; abstract;
    procedure commit(status: IStatus); virtual; abstract;
    procedure rollback(status: IStatus); virtual; abstract;
  end;

  AuthBlockVTable = class(VersionedVTable)
    getType: IAuthBlock_getTypePtr;
    getName: IAuthBlock_getNamePtr;
    getPlugin: IAuthBlock_getPluginPtr;
    getSecurityDb: IAuthBlock_getSecurityDbPtr;
    getOriginalPlugin: IAuthBlock_getOriginalPluginPtr;
    next: IAuthBlock_nextPtr;
    first: IAuthBlock_firstPtr;
  end;

  IAuthBlock = class(IVersioned)
  const
    version = 2;

    function getType(): PAnsiChar;
    function getName(): PAnsiChar;
    function getPlugin(): PAnsiChar;
    function getSecurityDb(): PAnsiChar;
    function getOriginalPlugin(): PAnsiChar;
    function next(status: IStatus): Boolean;
    function first(status: IStatus): Boolean;
  end;

  IAuthBlockImpl = class(IAuthBlock)
    constructor create;

    function getType(): PAnsiChar; virtual; abstract;
    function getName(): PAnsiChar; virtual; abstract;
    function getPlugin(): PAnsiChar; virtual; abstract;
    function getSecurityDb(): PAnsiChar; virtual; abstract;
    function getOriginalPlugin(): PAnsiChar; virtual; abstract;
    function next(status: IStatus): Boolean; virtual; abstract;
    function first(status: IStatus): Boolean; virtual; abstract;
  end;

  WireCryptPluginVTable = class(PluginBaseVTable)
    getKnownTypes: IWireCryptPlugin_getKnownTypesPtr;
    setKey: IWireCryptPlugin_setKeyPtr;
    encrypt: IWireCryptPlugin_encryptPtr;
    decrypt: IWireCryptPlugin_decryptPtr;
  end;

  IWireCryptPlugin = class(IPluginBase)
  const
    version = 4;

    function getKnownTypes(status: IStatus): PAnsiChar;
    procedure setKey(status: IStatus; key: ICryptKey);
    procedure encrypt(status: IStatus; length: Cardinal; from: Pointer; to_: Pointer);
    procedure decrypt(status: IStatus; length: Cardinal; from: Pointer; to_: Pointer);
  end;

  IWireCryptPluginImpl = class(IWireCryptPlugin)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: IReferenceCounted); virtual; abstract;
    function getOwner(): IReferenceCounted; virtual; abstract;
    function getKnownTypes(status: IStatus): PAnsiChar; virtual; abstract;
    procedure setKey(status: IStatus; key: ICryptKey); virtual; abstract;
    procedure encrypt(status: IStatus; length: Cardinal; from: Pointer; to_: Pointer); virtual; abstract;
    procedure decrypt(status: IStatus; length: Cardinal; from: Pointer; to_: Pointer); virtual; abstract;
  end;

  CryptKeyCallbackVTable = class(VersionedVTable)
    callback: ICryptKeyCallback_callbackPtr;
  end;

  ICryptKeyCallback = class(IVersioned)
  const
    version = 2;

    function callback(dataLength: Cardinal; data: Pointer; bufferLength: Cardinal; buffer: Pointer): Cardinal;
  end;

  ICryptKeyCallbackImpl = class(ICryptKeyCallback)
    constructor create;

    function callback(dataLength: Cardinal; data: Pointer; bufferLength: Cardinal; buffer: Pointer): Cardinal; virtual; abstract;
  end;

  KeyHolderPluginVTable = class(PluginBaseVTable)
    keyCallback: IKeyHolderPlugin_keyCallbackPtr;
    keyHandle: IKeyHolderPlugin_keyHandlePtr;
    useOnlyOwnKeys: IKeyHolderPlugin_useOnlyOwnKeysPtr;
    chainHandle: IKeyHolderPlugin_chainHandlePtr;
  end;

  IKeyHolderPlugin = class(IPluginBase)
  const
    version = 5;

    function keyCallback(status: IStatus; callback: ICryptKeyCallback): Integer;
    function keyHandle(status: IStatus; keyName: PAnsiChar): ICryptKeyCallback;
    function useOnlyOwnKeys(status: IStatus): Boolean;
    function chainHandle(status: IStatus): ICryptKeyCallback;
  end;

  IKeyHolderPluginImpl = class(IKeyHolderPlugin)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: IReferenceCounted); virtual; abstract;
    function getOwner(): IReferenceCounted; virtual; abstract;
    function keyCallback(status: IStatus; callback: ICryptKeyCallback): Integer; virtual; abstract;
    function keyHandle(status: IStatus; keyName: PAnsiChar): ICryptKeyCallback; virtual; abstract;
    function useOnlyOwnKeys(status: IStatus): Boolean; virtual; abstract;
    function chainHandle(status: IStatus): ICryptKeyCallback; virtual; abstract;
  end;

  DbCryptInfoVTable = class(ReferenceCountedVTable)
    getDatabaseFullPath: IDbCryptInfo_getDatabaseFullPathPtr;
  end;

  IDbCryptInfo = class(IReferenceCounted)
  const
    version = 3;

    function getDatabaseFullPath(status: IStatus): PAnsiChar;
  end;

  IDbCryptInfoImpl = class(IDbCryptInfo)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function getDatabaseFullPath(status: IStatus): PAnsiChar; virtual; abstract;
  end;

  DbCryptPluginVTable = class(PluginBaseVTable)
    setKey: IDbCryptPlugin_setKeyPtr;
    encrypt: IDbCryptPlugin_encryptPtr;
    decrypt: IDbCryptPlugin_decryptPtr;
    setInfo: IDbCryptPlugin_setInfoPtr;
  end;

  IDbCryptPlugin = class(IPluginBase)
  const
    version = 5;

    procedure setKey(status: IStatus; length: Cardinal; sources: IKeyHolderPluginPtr; keyName: PAnsiChar);
    procedure encrypt(status: IStatus; length: Cardinal; from: Pointer; to_: Pointer);
    procedure decrypt(status: IStatus; length: Cardinal; from: Pointer; to_: Pointer);
    procedure setInfo(status: IStatus; info: IDbCryptInfo);
  end;

  IDbCryptPluginImpl = class(IDbCryptPlugin)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: IReferenceCounted); virtual; abstract;
    function getOwner(): IReferenceCounted; virtual; abstract;
    procedure setKey(status: IStatus; length: Cardinal; sources: IKeyHolderPluginPtr; keyName: PAnsiChar); virtual; abstract;
    procedure encrypt(status: IStatus; length: Cardinal; from: Pointer; to_: Pointer); virtual; abstract;
    procedure decrypt(status: IStatus; length: Cardinal; from: Pointer; to_: Pointer); virtual; abstract;
    procedure setInfo(status: IStatus; info: IDbCryptInfo); virtual; abstract;
  end;

  ExternalContextVTable = class(VersionedVTable)
    getMaster: IExternalContext_getMasterPtr;
    getEngine: IExternalContext_getEnginePtr;
    getAttachment: IExternalContext_getAttachmentPtr;
    getTransaction: IExternalContext_getTransactionPtr;
    getUserName: IExternalContext_getUserNamePtr;
    getDatabaseName: IExternalContext_getDatabaseNamePtr;
    getClientCharSet: IExternalContext_getClientCharSetPtr;
    obtainInfoCode: IExternalContext_obtainInfoCodePtr;
    getInfo: IExternalContext_getInfoPtr;
    setInfo: IExternalContext_setInfoPtr;
  end;

  IExternalContext = class(IVersioned)
  const
    version = 2;

    function getMaster(): IMaster;
    function getEngine(status: IStatus): IExternalEngine;
    function getAttachment(status: IStatus): IAttachment;
    function getTransaction(status: IStatus): ITransaction;
    function getUserName(): PAnsiChar;
    function getDatabaseName(): PAnsiChar;
    function getClientCharSet(): PAnsiChar;
    function obtainInfoCode(): Integer;
    function getInfo(code: Integer): Pointer;
    function setInfo(code: Integer; value: Pointer): Pointer;
  end;

  IExternalContextImpl = class(IExternalContext)
    constructor create;

    function getMaster(): IMaster; virtual; abstract;
    function getEngine(status: IStatus): IExternalEngine; virtual; abstract;
    function getAttachment(status: IStatus): IAttachment; virtual; abstract;
    function getTransaction(status: IStatus): ITransaction; virtual; abstract;
    function getUserName(): PAnsiChar; virtual; abstract;
    function getDatabaseName(): PAnsiChar; virtual; abstract;
    function getClientCharSet(): PAnsiChar; virtual; abstract;
    function obtainInfoCode(): Integer; virtual; abstract;
    function getInfo(code: Integer): Pointer; virtual; abstract;
    function setInfo(code: Integer; value: Pointer): Pointer; virtual; abstract;
  end;

  ExternalResultSetVTable = class(DisposableVTable)
    fetch: IExternalResultSet_fetchPtr;
  end;

  IExternalResultSet = class(IDisposable)
  const
    version = 3;

    function fetch(status: IStatus): Boolean;
  end;

  IExternalResultSetImpl = class(IExternalResultSet)
    constructor create;

    procedure dispose(); virtual; abstract;
    function fetch(status: IStatus): Boolean; virtual; abstract;
  end;

  ExternalFunctionVTable = class(DisposableVTable)
    getCharSet: IExternalFunction_getCharSetPtr;
    execute: IExternalFunction_executePtr;
  end;

  IExternalFunction = class(IDisposable)
  const
    version = 3;

    procedure getCharSet(status: IStatus; context: IExternalContext; name: PAnsiChar; nameSize: Cardinal);
    procedure execute(status: IStatus; context: IExternalContext; inMsg: Pointer; outMsg: Pointer);
  end;

  IExternalFunctionImpl = class(IExternalFunction)
    constructor create;

    procedure dispose(); virtual; abstract;
    procedure getCharSet(status: IStatus; context: IExternalContext; name: PAnsiChar; nameSize: Cardinal); virtual; abstract;
    procedure execute(status: IStatus; context: IExternalContext; inMsg: Pointer; outMsg: Pointer); virtual; abstract;
  end;

  ExternalProcedureVTable = class(DisposableVTable)
    getCharSet: IExternalProcedure_getCharSetPtr;
    open: IExternalProcedure_openPtr;
  end;

  IExternalProcedure = class(IDisposable)
  const
    version = 3;

    procedure getCharSet(status: IStatus; context: IExternalContext; name: PAnsiChar; nameSize: Cardinal);
    function open(status: IStatus; context: IExternalContext; inMsg: Pointer; outMsg: Pointer): IExternalResultSet;
  end;

  IExternalProcedureImpl = class(IExternalProcedure)
    constructor create;

    procedure dispose(); virtual; abstract;
    procedure getCharSet(status: IStatus; context: IExternalContext; name: PAnsiChar; nameSize: Cardinal); virtual; abstract;
    function open(status: IStatus; context: IExternalContext; inMsg: Pointer; outMsg: Pointer): IExternalResultSet; virtual; abstract;
  end;

  ExternalTriggerVTable = class(DisposableVTable)
    getCharSet: IExternalTrigger_getCharSetPtr;
    execute: IExternalTrigger_executePtr;
  end;

  IExternalTrigger = class(IDisposable)
  const
    version = 3;

  const
    TYPE_BEFORE = Cardinal(1);

  const
    TYPE_AFTER = Cardinal(2);

  const
    TYPE_DATABASE = Cardinal(3);

  const
    ACTION_INSERT = Cardinal(1);

  const
    ACTION_UPDATE = Cardinal(2);

  const
    ACTION_DELETE = Cardinal(3);

  const
    ACTION_CONNECT = Cardinal(4);

  const
    ACTION_DISCONNECT = Cardinal(5);

  const
    ACTION_TRANS_START = Cardinal(6);

  const
    ACTION_TRANS_COMMIT = Cardinal(7);

  const
    ACTION_TRANS_ROLLBACK = Cardinal(8);

  const
    ACTION_DDL = Cardinal(9);

    procedure getCharSet(status: IStatus; context: IExternalContext; name: PAnsiChar; nameSize: Cardinal);
    procedure execute(status: IStatus; context: IExternalContext; action: Cardinal; oldMsg: Pointer; newMsg: Pointer);
  end;

  IExternalTriggerImpl = class(IExternalTrigger)
    constructor create;

    procedure dispose(); virtual; abstract;
    procedure getCharSet(status: IStatus; context: IExternalContext; name: PAnsiChar; nameSize: Cardinal); virtual; abstract;
    procedure execute(status: IStatus; context: IExternalContext; action: Cardinal; oldMsg: Pointer; newMsg: Pointer); virtual; abstract;
  end;

  RoutineMetadataVTable = class(VersionedVTable)
    getPackage: IRoutineMetadata_getPackagePtr;
    getName: IRoutineMetadata_getNamePtr;
    getEntryPoint: IRoutineMetadata_getEntryPointPtr;
    getBody: IRoutineMetadata_getBodyPtr;
    getInputMetadata: IRoutineMetadata_getInputMetadataPtr;
    getOutputMetadata: IRoutineMetadata_getOutputMetadataPtr;
    getTriggerMetadata: IRoutineMetadata_getTriggerMetadataPtr;
    getTriggerTable: IRoutineMetadata_getTriggerTablePtr;
    getTriggerType: IRoutineMetadata_getTriggerTypePtr;
  end;

  IRoutineMetadata = class(IVersioned)
  const
    version = 2;

    function getPackage(status: IStatus): PAnsiChar;
    function getName(status: IStatus): PAnsiChar;
    function getEntryPoint(status: IStatus): PAnsiChar;
    function getBody(status: IStatus): PAnsiChar;
    function getInputMetadata(status: IStatus): IMessageMetadata;
    function getOutputMetadata(status: IStatus): IMessageMetadata;
    function getTriggerMetadata(status: IStatus): IMessageMetadata;
    function getTriggerTable(status: IStatus): PAnsiChar;
    function getTriggerType(status: IStatus): Cardinal;
  end;

  IRoutineMetadataImpl = class(IRoutineMetadata)
    constructor create;

    function getPackage(status: IStatus): PAnsiChar; virtual; abstract;
    function getName(status: IStatus): PAnsiChar; virtual; abstract;
    function getEntryPoint(status: IStatus): PAnsiChar; virtual; abstract;
    function getBody(status: IStatus): PAnsiChar; virtual; abstract;
    function getInputMetadata(status: IStatus): IMessageMetadata; virtual; abstract;
    function getOutputMetadata(status: IStatus): IMessageMetadata; virtual; abstract;
    function getTriggerMetadata(status: IStatus): IMessageMetadata; virtual; abstract;
    function getTriggerTable(status: IStatus): PAnsiChar; virtual; abstract;
    function getTriggerType(status: IStatus): Cardinal; virtual; abstract;
  end;

  ExternalEngineVTable = class(PluginBaseVTable)
    open: IExternalEngine_openPtr;
    openAttachment: IExternalEngine_openAttachmentPtr;
    closeAttachment: IExternalEngine_closeAttachmentPtr;
    makeFunction: IExternalEngine_makeFunctionPtr;
    makeProcedure: IExternalEngine_makeProcedurePtr;
    makeTrigger: IExternalEngine_makeTriggerPtr;
  end;

  IExternalEngine = class(IPluginBase)
  const
    version = 4;

    procedure open(status: IStatus; context: IExternalContext; charSet: PAnsiChar; charSetSize: Cardinal);
    procedure openAttachment(status: IStatus; context: IExternalContext);
    procedure closeAttachment(status: IStatus; context: IExternalContext);
    function makeFunction(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata; inBuilder: IMetadataBuilder;
      outBuilder: IMetadataBuilder): IExternalFunction;
    function makeProcedure(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata; inBuilder: IMetadataBuilder;
      outBuilder: IMetadataBuilder): IExternalProcedure;
    function makeTrigger(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata; fieldsBuilder: IMetadataBuilder): IExternalTrigger;
  end;

  IExternalEngineImpl = class(IExternalEngine)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: IReferenceCounted); virtual; abstract;
    function getOwner(): IReferenceCounted; virtual; abstract;
    procedure open(status: IStatus; context: IExternalContext; charSet: PAnsiChar; charSetSize: Cardinal); virtual; abstract;
    procedure openAttachment(status: IStatus; context: IExternalContext); virtual; abstract;
    procedure closeAttachment(status: IStatus; context: IExternalContext); virtual; abstract;
    function makeFunction(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata; inBuilder: IMetadataBuilder;
      outBuilder: IMetadataBuilder): IExternalFunction; virtual; abstract;
    function makeProcedure(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata; inBuilder: IMetadataBuilder;
      outBuilder: IMetadataBuilder): IExternalProcedure; virtual; abstract;
    function makeTrigger(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata; fieldsBuilder: IMetadataBuilder): IExternalTrigger;
      virtual; abstract;
  end;

  TimerVTable = class(ReferenceCountedVTable)
    handler: ITimer_handlerPtr;
  end;

  ITimer = class(IReferenceCounted)
  const
    version = 3;

    procedure handler();
  end;

  ITimerImpl = class(ITimer)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure handler(); virtual; abstract;
  end;

  TimerControlVTable = class(VersionedVTable)
    start: ITimerControl_startPtr;
    stop: ITimerControl_stopPtr;
  end;

  ITimerControl = class(IVersioned)
  const
    version = 2;

    procedure start(status: IStatus; timer: ITimer; microSeconds: QWord);
    procedure stop(status: IStatus; timer: ITimer);
  end;

  ITimerControlImpl = class(ITimerControl)
    constructor create;

    procedure start(status: IStatus; timer: ITimer; microSeconds: QWord); virtual; abstract;
    procedure stop(status: IStatus; timer: ITimer); virtual; abstract;
  end;

  VersionCallbackVTable = class(VersionedVTable)
    callback: IVersionCallback_callbackPtr;
  end;

  IVersionCallback = class(IVersioned)
  const
    version = 2;

    procedure callback(status: IStatus; text: PAnsiChar);
  end;

  IVersionCallbackImpl = class(IVersionCallback)
    constructor create;

    procedure callback(status: IStatus; text: PAnsiChar); virtual; abstract;
  end;

  UtilVTable = class(VersionedVTable)
    getFbVersion: IUtil_getFbVersionPtr;
    loadBlob: IUtil_loadBlobPtr;
    dumpBlob: IUtil_dumpBlobPtr;
    getPerfCounters: IUtil_getPerfCountersPtr;
    executeCreateDatabase: IUtil_executeCreateDatabasePtr;
    decodeDate: IUtil_decodeDatePtr;
    decodeTime: IUtil_decodeTimePtr;
    encodeDate: IUtil_encodeDatePtr;
    encodeTime: IUtil_encodeTimePtr;
    formatStatus: IUtil_formatStatusPtr;
    getClientVersion: IUtil_getClientVersionPtr;
    getXpbBuilder: IUtil_getXpbBuilderPtr;
    setOffsets: IUtil_setOffsetsPtr;
  end;

  IUtil = class(IVersioned)
  const
    version = 2;

    procedure getFbVersion(status: IStatus; att: IAttachment; callback: IVersionCallback);
    procedure loadBlob(status: IStatus; blobId: ISC_QUADPtr; att: IAttachment; tra: ITransaction; file_: PAnsiChar; txt: Boolean);
    procedure dumpBlob(status: IStatus; blobId: ISC_QUADPtr; att: IAttachment; tra: ITransaction; file_: PAnsiChar; txt: Boolean);
    procedure getPerfCounters(status: IStatus; att: IAttachment; countersSet: PAnsiChar; counters: Int64Ptr);
    function executeCreateDatabase(status: IStatus; stmtLength: Cardinal; creatDBstatement: PAnsiChar; dialect: Cardinal; stmtIsCreateDb: BooleanPtr)
      : IAttachment;
    procedure decodeDate(date: ISC_DATE; year: CardinalPtr; month: CardinalPtr; day: CardinalPtr);
    procedure decodeTime(time: ISC_TIME; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr; fractions: CardinalPtr);
    function encodeDate(year: Cardinal; month: Cardinal; day: Cardinal): ISC_DATE;
    function encodeTime(hours: Cardinal; minutes: Cardinal; seconds: Cardinal; fractions: Cardinal): ISC_TIME;
    function formatStatus(buffer: PAnsiChar; bufferSize: Cardinal; status: IStatus): Cardinal;
    function getClientVersion(): Cardinal;
    function getXpbBuilder(status: IStatus; kind: Cardinal; buf: BytePtr; len: Cardinal): IXpbBuilder;
    function setOffsets(status: IStatus; metadata: IMessageMetadata; callback: IOffsetsCallback): Cardinal;
  end;

  IUtilImpl = class(IUtil)
    constructor create;

    procedure getFbVersion(status: IStatus; att: IAttachment; callback: IVersionCallback); virtual; abstract;
    procedure loadBlob(status: IStatus; blobId: ISC_QUADPtr; att: IAttachment; tra: ITransaction; file_: PAnsiChar; txt: Boolean); virtual; abstract;
    procedure dumpBlob(status: IStatus; blobId: ISC_QUADPtr; att: IAttachment; tra: ITransaction; file_: PAnsiChar; txt: Boolean); virtual; abstract;
    procedure getPerfCounters(status: IStatus; att: IAttachment; countersSet: PAnsiChar; counters: Int64Ptr); virtual; abstract;
    function executeCreateDatabase(status: IStatus; stmtLength: Cardinal; creatDBstatement: PAnsiChar; dialect: Cardinal; stmtIsCreateDb: BooleanPtr)
      : IAttachment; virtual; abstract;
    procedure decodeDate(date: ISC_DATE; year: CardinalPtr; month: CardinalPtr; day: CardinalPtr); virtual; abstract;
    procedure decodeTime(time: ISC_TIME; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr; fractions: CardinalPtr); virtual; abstract;
    function encodeDate(year: Cardinal; month: Cardinal; day: Cardinal): ISC_DATE; virtual; abstract;
    function encodeTime(hours: Cardinal; minutes: Cardinal; seconds: Cardinal; fractions: Cardinal): ISC_TIME; virtual; abstract;
    function formatStatus(buffer: PAnsiChar; bufferSize: Cardinal; status: IStatus): Cardinal; virtual; abstract;
    function getClientVersion(): Cardinal; virtual; abstract;
    function getXpbBuilder(status: IStatus; kind: Cardinal; buf: BytePtr; len: Cardinal): IXpbBuilder; virtual; abstract;
    function setOffsets(status: IStatus; metadata: IMessageMetadata; callback: IOffsetsCallback): Cardinal; virtual; abstract;
  end;

  OffsetsCallbackVTable = class(VersionedVTable)
    setOffset: IOffsetsCallback_setOffsetPtr;
  end;

  IOffsetsCallback = class(IVersioned)
  const
    version = 2;

    procedure setOffset(status: IStatus; index: Cardinal; offset: Cardinal; nullOffset: Cardinal);
  end;

  IOffsetsCallbackImpl = class(IOffsetsCallback)
    constructor create;

    procedure setOffset(status: IStatus; index: Cardinal; offset: Cardinal; nullOffset: Cardinal); virtual; abstract;
  end;

  XpbBuilderVTable = class(DisposableVTable)
    clear: IXpbBuilder_clearPtr;
    removeCurrent: IXpbBuilder_removeCurrentPtr;
    insertInt: IXpbBuilder_insertIntPtr;
    insertBigInt: IXpbBuilder_insertBigIntPtr;
    insertBytes: IXpbBuilder_insertBytesPtr;
    insertString: IXpbBuilder_insertStringPtr;
    insertTag: IXpbBuilder_insertTagPtr;
    isEof: IXpbBuilder_isEofPtr;
    moveNext: IXpbBuilder_moveNextPtr;
    rewind: IXpbBuilder_rewindPtr;
    findFirst: IXpbBuilder_findFirstPtr;
    findNext: IXpbBuilder_findNextPtr;
    getTag: IXpbBuilder_getTagPtr;
    getLength: IXpbBuilder_getLengthPtr;
    getInt: IXpbBuilder_getIntPtr;
    getBigInt: IXpbBuilder_getBigIntPtr;
    getString: IXpbBuilder_getStringPtr;
    getBytes: IXpbBuilder_getBytesPtr;
    getBufferLength: IXpbBuilder_getBufferLengthPtr;
    getBuffer: IXpbBuilder_getBufferPtr;
  end;

  IXpbBuilder = class(IDisposable)
  const
    version = 3;

  const
    dpb = Cardinal(1);

  const
    SPB_ATTACH = Cardinal(2);

  const
    SPB_START = Cardinal(3);

  const
    tpb = Cardinal(4);

    procedure clear(status: IStatus);
    procedure removeCurrent(status: IStatus);
    procedure insertInt(status: IStatus; tag: Byte; value: Integer);
    procedure insertBigInt(status: IStatus; tag: Byte; value: Int64);
    procedure insertBytes(status: IStatus; tag: Byte; bytes: Pointer; length: Cardinal);
    procedure insertString(status: IStatus; tag: Byte; str: PAnsiChar);
    procedure insertTag(status: IStatus; tag: Byte);
    function isEof(status: IStatus): Boolean;
    procedure moveNext(status: IStatus);
    procedure rewind(status: IStatus);
    function findFirst(status: IStatus; tag: Byte): Boolean;
    function findNext(status: IStatus): Boolean;
    function getTag(status: IStatus): Byte;
    function getLength(status: IStatus): Cardinal;
    function getInt(status: IStatus): Integer;
    function getBigInt(status: IStatus): Int64;
    function getString(status: IStatus): PAnsiChar;
    function getBytes(status: IStatus): BytePtr;
    function getBufferLength(status: IStatus): Cardinal;
    function getBuffer(status: IStatus): BytePtr;
  end;

  IXpbBuilderImpl = class(IXpbBuilder)
    constructor create;

    procedure dispose(); virtual; abstract;
    procedure clear(status: IStatus); virtual; abstract;
    procedure removeCurrent(status: IStatus); virtual; abstract;
    procedure insertInt(status: IStatus; tag: Byte; value: Integer); virtual; abstract;
    procedure insertBigInt(status: IStatus; tag: Byte; value: Int64); virtual; abstract;
    procedure insertBytes(status: IStatus; tag: Byte; bytes: Pointer; length: Cardinal); virtual; abstract;
    procedure insertString(status: IStatus; tag: Byte; str: PAnsiChar); virtual; abstract;
    procedure insertTag(status: IStatus; tag: Byte); virtual; abstract;
    function isEof(status: IStatus): Boolean; virtual; abstract;
    procedure moveNext(status: IStatus); virtual; abstract;
    procedure rewind(status: IStatus); virtual; abstract;
    function findFirst(status: IStatus; tag: Byte): Boolean; virtual; abstract;
    function findNext(status: IStatus): Boolean; virtual; abstract;
    function getTag(status: IStatus): Byte; virtual; abstract;
    function getLength(status: IStatus): Cardinal; virtual; abstract;
    function getInt(status: IStatus): Integer; virtual; abstract;
    function getBigInt(status: IStatus): Int64; virtual; abstract;
    function getString(status: IStatus): PAnsiChar; virtual; abstract;
    function getBytes(status: IStatus): BytePtr; virtual; abstract;
    function getBufferLength(status: IStatus): Cardinal; virtual; abstract;
    function getBuffer(status: IStatus): BytePtr; virtual; abstract;
  end;

  TraceConnectionVTable = class(VersionedVTable)
    getKind: ITraceConnection_getKindPtr;
    getProcessID: ITraceConnection_getProcessIDPtr;
    getUserName: ITraceConnection_getUserNamePtr;
    getRoleName: ITraceConnection_getRoleNamePtr;
    getCharSet: ITraceConnection_getCharSetPtr;
    getRemoteProtocol: ITraceConnection_getRemoteProtocolPtr;
    getRemoteAddress: ITraceConnection_getRemoteAddressPtr;
    getRemoteProcessID: ITraceConnection_getRemoteProcessIDPtr;
    getRemoteProcessName: ITraceConnection_getRemoteProcessNamePtr;
  end;

  ITraceConnection = class(IVersioned)
  const
    version = 2;

  const
    KIND_DATABASE = Cardinal(1);

  const
    KIND_SERVICE = Cardinal(2);

    function getKind(): Cardinal;
    function getProcessID(): Integer;
    function getUserName(): PAnsiChar;
    function getRoleName(): PAnsiChar;
    function getCharSet(): PAnsiChar;
    function getRemoteProtocol(): PAnsiChar;
    function getRemoteAddress(): PAnsiChar;
    function getRemoteProcessID(): Integer;
    function getRemoteProcessName(): PAnsiChar;
  end;

  ITraceConnectionImpl = class(ITraceConnection)
    constructor create;

    function getKind(): Cardinal; virtual; abstract;
    function getProcessID(): Integer; virtual; abstract;
    function getUserName(): PAnsiChar; virtual; abstract;
    function getRoleName(): PAnsiChar; virtual; abstract;
    function getCharSet(): PAnsiChar; virtual; abstract;
    function getRemoteProtocol(): PAnsiChar; virtual; abstract;
    function getRemoteAddress(): PAnsiChar; virtual; abstract;
    function getRemoteProcessID(): Integer; virtual; abstract;
    function getRemoteProcessName(): PAnsiChar; virtual; abstract;
  end;

  TraceDatabaseConnectionVTable = class(TraceConnectionVTable)
    getConnectionID: ITraceDatabaseConnection_getConnectionIDPtr;
    getDatabaseName: ITraceDatabaseConnection_getDatabaseNamePtr;
  end;

  ITraceDatabaseConnection = class(ITraceConnection)
  const
    version = 3;

    function getConnectionID(): Int64;
    function getDatabaseName(): PAnsiChar;
  end;

  ITraceDatabaseConnectionImpl = class(ITraceDatabaseConnection)
    constructor create;

    function getKind(): Cardinal; virtual; abstract;
    function getProcessID(): Integer; virtual; abstract;
    function getUserName(): PAnsiChar; virtual; abstract;
    function getRoleName(): PAnsiChar; virtual; abstract;
    function getCharSet(): PAnsiChar; virtual; abstract;
    function getRemoteProtocol(): PAnsiChar; virtual; abstract;
    function getRemoteAddress(): PAnsiChar; virtual; abstract;
    function getRemoteProcessID(): Integer; virtual; abstract;
    function getRemoteProcessName(): PAnsiChar; virtual; abstract;
    function getConnectionID(): Int64; virtual; abstract;
    function getDatabaseName(): PAnsiChar; virtual; abstract;
  end;

  TraceTransactionVTable = class(VersionedVTable)
    getTransactionID: ITraceTransaction_getTransactionIDPtr;
    getReadOnly: ITraceTransaction_getReadOnlyPtr;
    getWait: ITraceTransaction_getWaitPtr;
    getIsolation: ITraceTransaction_getIsolationPtr;
    getPerf: ITraceTransaction_getPerfPtr;
    getInitialID: ITraceTransaction_getInitialIDPtr;
    getPreviousID: ITraceTransaction_getPreviousIDPtr;
  end;

  ITraceTransaction = class(IVersioned)
  const
    version = 3;

  const
    ISOLATION_CONSISTENCY = Cardinal(1);

  const
    ISOLATION_CONCURRENCY = Cardinal(2);

  const
    ISOLATION_READ_COMMITTED_RECVER = Cardinal(3);

  const
    ISOLATION_READ_COMMITTED_NORECVER = Cardinal(4);

    function getTransactionID(): Int64;
    function getReadOnly(): Boolean;
    function getWait(): Integer;
    function getIsolation(): Cardinal;
    function getPerf(): PerformanceInfoPtr;
    function getInitialID(): Int64;
    function getPreviousID(): Int64;
  end;

  ITraceTransactionImpl = class(ITraceTransaction)
    constructor create;

    function getTransactionID(): Int64; virtual; abstract;
    function getReadOnly(): Boolean; virtual; abstract;
    function getWait(): Integer; virtual; abstract;
    function getIsolation(): Cardinal; virtual; abstract;
    function getPerf(): PerformanceInfoPtr; virtual; abstract;
    function getInitialID(): Int64; virtual; abstract;
    function getPreviousID(): Int64; virtual; abstract;
  end;

  TraceParamsVTable = class(VersionedVTable)
    getCount: ITraceParams_getCountPtr;
    getParam: ITraceParams_getParamPtr;
    getTextUTF8: ITraceParams_getTextUTF8Ptr;
  end;

  ITraceParams = class(IVersioned)
  const
    version = 3;

    function getCount(): Cardinal;
    function getParam(idx: Cardinal): dscPtr;
    function getTextUTF8(status: IStatus; idx: Cardinal): PAnsiChar;
  end;

  ITraceParamsImpl = class(ITraceParams)
    constructor create;

    function getCount(): Cardinal; virtual; abstract;
    function getParam(idx: Cardinal): dscPtr; virtual; abstract;
    function getTextUTF8(status: IStatus; idx: Cardinal): PAnsiChar; virtual; abstract;
  end;

  TraceStatementVTable = class(VersionedVTable)
    getStmtID: ITraceStatement_getStmtIDPtr;
    getPerf: ITraceStatement_getPerfPtr;
  end;

  ITraceStatement = class(IVersioned)
  const
    version = 2;

    function getStmtID(): Int64;
    function getPerf(): PerformanceInfoPtr;
  end;

  ITraceStatementImpl = class(ITraceStatement)
    constructor create;

    function getStmtID(): Int64; virtual; abstract;
    function getPerf(): PerformanceInfoPtr; virtual; abstract;
  end;

  TraceSQLStatementVTable = class(TraceStatementVTable)
    getText: ITraceSQLStatement_getTextPtr;
    getPlan: ITraceSQLStatement_getPlanPtr;
    getInputs: ITraceSQLStatement_getInputsPtr;
    getTextUTF8: ITraceSQLStatement_getTextUTF8Ptr;
    getExplainedPlan: ITraceSQLStatement_getExplainedPlanPtr;
  end;

  ITraceSQLStatement = class(ITraceStatement)
  const
    version = 3;

    function getText(): PAnsiChar;
    function getPlan(): PAnsiChar;
    function getInputs(): ITraceParams;
    function getTextUTF8(): PAnsiChar;
    function getExplainedPlan(): PAnsiChar;
  end;

  ITraceSQLStatementImpl = class(ITraceSQLStatement)
    constructor create;

    function getStmtID(): Int64; virtual; abstract;
    function getPerf(): PerformanceInfoPtr; virtual; abstract;
    function getText(): PAnsiChar; virtual; abstract;
    function getPlan(): PAnsiChar; virtual; abstract;
    function getInputs(): ITraceParams; virtual; abstract;
    function getTextUTF8(): PAnsiChar; virtual; abstract;
    function getExplainedPlan(): PAnsiChar; virtual; abstract;
  end;

  TraceBLRStatementVTable = class(TraceStatementVTable)
    getData: ITraceBLRStatement_getDataPtr;
    getDataLength: ITraceBLRStatement_getDataLengthPtr;
    getText: ITraceBLRStatement_getTextPtr;
  end;

  ITraceBLRStatement = class(ITraceStatement)
  const
    version = 3;

    function getData(): BytePtr;
    function getDataLength(): Cardinal;
    function getText(): PAnsiChar;
  end;

  ITraceBLRStatementImpl = class(ITraceBLRStatement)
    constructor create;

    function getStmtID(): Int64; virtual; abstract;
    function getPerf(): PerformanceInfoPtr; virtual; abstract;
    function getData(): BytePtr; virtual; abstract;
    function getDataLength(): Cardinal; virtual; abstract;
    function getText(): PAnsiChar; virtual; abstract;
  end;

  TraceDYNRequestVTable = class(VersionedVTable)
    getData: ITraceDYNRequest_getDataPtr;
    getDataLength: ITraceDYNRequest_getDataLengthPtr;
    getText: ITraceDYNRequest_getTextPtr;
  end;

  ITraceDYNRequest = class(IVersioned)
  const
    version = 2;

    function getData(): BytePtr;
    function getDataLength(): Cardinal;
    function getText(): PAnsiChar;
  end;

  ITraceDYNRequestImpl = class(ITraceDYNRequest)
    constructor create;

    function getData(): BytePtr; virtual; abstract;
    function getDataLength(): Cardinal; virtual; abstract;
    function getText(): PAnsiChar; virtual; abstract;
  end;

  TraceContextVariableVTable = class(VersionedVTable)
    getNameSpace: ITraceContextVariable_getNameSpacePtr;
    getVarName: ITraceContextVariable_getVarNamePtr;
    getVarValue: ITraceContextVariable_getVarValuePtr;
  end;

  ITraceContextVariable = class(IVersioned)
  const
    version = 2;

    function getNameSpace(): PAnsiChar;
    function getVarName(): PAnsiChar;
    function getVarValue(): PAnsiChar;
  end;

  ITraceContextVariableImpl = class(ITraceContextVariable)
    constructor create;

    function getNameSpace(): PAnsiChar; virtual; abstract;
    function getVarName(): PAnsiChar; virtual; abstract;
    function getVarValue(): PAnsiChar; virtual; abstract;
  end;

  TraceProcedureVTable = class(VersionedVTable)
    getProcName: ITraceProcedure_getProcNamePtr;
    getInputs: ITraceProcedure_getInputsPtr;
    getPerf: ITraceProcedure_getPerfPtr;
  end;

  ITraceProcedure = class(IVersioned)
  const
    version = 2;

    function getProcName(): PAnsiChar;
    function getInputs(): ITraceParams;
    function getPerf(): PerformanceInfoPtr;
  end;

  ITraceProcedureImpl = class(ITraceProcedure)
    constructor create;

    function getProcName(): PAnsiChar; virtual; abstract;
    function getInputs(): ITraceParams; virtual; abstract;
    function getPerf(): PerformanceInfoPtr; virtual; abstract;
  end;

  TraceFunctionVTable = class(VersionedVTable)
    getFuncName: ITraceFunction_getFuncNamePtr;
    getInputs: ITraceFunction_getInputsPtr;
    getResult: ITraceFunction_getResultPtr;
    getPerf: ITraceFunction_getPerfPtr;
  end;

  ITraceFunction = class(IVersioned)
  const
    version = 2;

    function getFuncName(): PAnsiChar;
    function getInputs(): ITraceParams;
    function getResult(): ITraceParams;
    function getPerf(): PerformanceInfoPtr;
  end;

  ITraceFunctionImpl = class(ITraceFunction)
    constructor create;

    function getFuncName(): PAnsiChar; virtual; abstract;
    function getInputs(): ITraceParams; virtual; abstract;
    function getResult(): ITraceParams; virtual; abstract;
    function getPerf(): PerformanceInfoPtr; virtual; abstract;
  end;

  TraceTriggerVTable = class(VersionedVTable)
    getTriggerName: ITraceTrigger_getTriggerNamePtr;
    getRelationName: ITraceTrigger_getRelationNamePtr;
    getAction: ITraceTrigger_getActionPtr;
    getWhich: ITraceTrigger_getWhichPtr;
    getPerf: ITraceTrigger_getPerfPtr;
  end;

  ITraceTrigger = class(IVersioned)
  const
    version = 2;

  const
    TYPE_ALL = Cardinal(0);

  const
    TYPE_BEFORE = Cardinal(1);

  const
    TYPE_AFTER = Cardinal(2);

    function getTriggerName(): PAnsiChar;
    function getRelationName(): PAnsiChar;
    function getAction(): Integer;
    function getWhich(): Integer;
    function getPerf(): PerformanceInfoPtr;
  end;

  ITraceTriggerImpl = class(ITraceTrigger)
    constructor create;

    function getTriggerName(): PAnsiChar; virtual; abstract;
    function getRelationName(): PAnsiChar; virtual; abstract;
    function getAction(): Integer; virtual; abstract;
    function getWhich(): Integer; virtual; abstract;
    function getPerf(): PerformanceInfoPtr; virtual; abstract;
  end;

  TraceServiceConnectionVTable = class(TraceConnectionVTable)
    getServiceID: ITraceServiceConnection_getServiceIDPtr;
    getServiceMgr: ITraceServiceConnection_getServiceMgrPtr;
    getServiceName: ITraceServiceConnection_getServiceNamePtr;
  end;

  ITraceServiceConnection = class(ITraceConnection)
  const
    version = 3;

    function getServiceID(): Pointer;
    function getServiceMgr(): PAnsiChar;
    function getServiceName(): PAnsiChar;
  end;

  ITraceServiceConnectionImpl = class(ITraceServiceConnection)
    constructor create;

    function getKind(): Cardinal; virtual; abstract;
    function getProcessID(): Integer; virtual; abstract;
    function getUserName(): PAnsiChar; virtual; abstract;
    function getRoleName(): PAnsiChar; virtual; abstract;
    function getCharSet(): PAnsiChar; virtual; abstract;
    function getRemoteProtocol(): PAnsiChar; virtual; abstract;
    function getRemoteAddress(): PAnsiChar; virtual; abstract;
    function getRemoteProcessID(): Integer; virtual; abstract;
    function getRemoteProcessName(): PAnsiChar; virtual; abstract;
    function getServiceID(): Pointer; virtual; abstract;
    function getServiceMgr(): PAnsiChar; virtual; abstract;
    function getServiceName(): PAnsiChar; virtual; abstract;
  end;

  TraceStatusVectorVTable = class(VersionedVTable)
    hasError: ITraceStatusVector_hasErrorPtr;
    hasWarning: ITraceStatusVector_hasWarningPtr;
    getStatus: ITraceStatusVector_getStatusPtr;
    getText: ITraceStatusVector_getTextPtr;
  end;

  ITraceStatusVector = class(IVersioned)
  const
    version = 2;

    function hasError(): Boolean;
    function hasWarning(): Boolean;
    function getStatus(): IStatus;
    function getText(): PAnsiChar;
  end;

  ITraceStatusVectorImpl = class(ITraceStatusVector)
    constructor create;

    function hasError(): Boolean; virtual; abstract;
    function hasWarning(): Boolean; virtual; abstract;
    function getStatus(): IStatus; virtual; abstract;
    function getText(): PAnsiChar; virtual; abstract;
  end;

  TraceSweepInfoVTable = class(VersionedVTable)
    getOIT: ITraceSweepInfo_getOITPtr;
    getOST: ITraceSweepInfo_getOSTPtr;
    getOAT: ITraceSweepInfo_getOATPtr;
    getNext: ITraceSweepInfo_getNextPtr;
    getPerf: ITraceSweepInfo_getPerfPtr;
  end;

  ITraceSweepInfo = class(IVersioned)
  const
    version = 2;

    function getOIT(): Int64;
    function getOST(): Int64;
    function getOAT(): Int64;
    function getNext(): Int64;
    function getPerf(): PerformanceInfoPtr;
  end;

  ITraceSweepInfoImpl = class(ITraceSweepInfo)
    constructor create;

    function getOIT(): Int64; virtual; abstract;
    function getOST(): Int64; virtual; abstract;
    function getOAT(): Int64; virtual; abstract;
    function getNext(): Int64; virtual; abstract;
    function getPerf(): PerformanceInfoPtr; virtual; abstract;
  end;

  TraceLogWriterVTable = class(ReferenceCountedVTable)
    write: ITraceLogWriter_writePtr;
    write_s: ITraceLogWriter_write_sPtr;
  end;

  ITraceLogWriter = class(IReferenceCounted)
  const
    version = 4;

    function write(buf: Pointer; size: Cardinal): Cardinal;
    function write_s(status: IStatus; buf: Pointer; size: Cardinal): Cardinal;
  end;

  ITraceLogWriterImpl = class(ITraceLogWriter)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function write(buf: Pointer; size: Cardinal): Cardinal; virtual; abstract;
    function write_s(status: IStatus; buf: Pointer; size: Cardinal): Cardinal; virtual; abstract;
  end;

  TraceInitInfoVTable = class(VersionedVTable)
    getConfigText: ITraceInitInfo_getConfigTextPtr;
    getTraceSessionID: ITraceInitInfo_getTraceSessionIDPtr;
    getTraceSessionName: ITraceInitInfo_getTraceSessionNamePtr;
    getFirebirdRootDirectory: ITraceInitInfo_getFirebirdRootDirectoryPtr;
    getDatabaseName: ITraceInitInfo_getDatabaseNamePtr;
    getConnection: ITraceInitInfo_getConnectionPtr;
    getLogWriter: ITraceInitInfo_getLogWriterPtr;
  end;

  ITraceInitInfo = class(IVersioned)
  const
    version = 2;

    function getConfigText(): PAnsiChar;
    function getTraceSessionID(): Integer;
    function getTraceSessionName(): PAnsiChar;
    function getFirebirdRootDirectory(): PAnsiChar;
    function getDatabaseName(): PAnsiChar;
    function getConnection(): ITraceDatabaseConnection;
    function getLogWriter(): ITraceLogWriter;
  end;

  ITraceInitInfoImpl = class(ITraceInitInfo)
    constructor create;

    function getConfigText(): PAnsiChar; virtual; abstract;
    function getTraceSessionID(): Integer; virtual; abstract;
    function getTraceSessionName(): PAnsiChar; virtual; abstract;
    function getFirebirdRootDirectory(): PAnsiChar; virtual; abstract;
    function getDatabaseName(): PAnsiChar; virtual; abstract;
    function getConnection(): ITraceDatabaseConnection; virtual; abstract;
    function getLogWriter(): ITraceLogWriter; virtual; abstract;
  end;

  TracePluginVTable = class(ReferenceCountedVTable)
    trace_get_error: ITracePlugin_trace_get_errorPtr;
    trace_attach: ITracePlugin_trace_attachPtr;
    trace_detach: ITracePlugin_trace_detachPtr;
    trace_transaction_start: ITracePlugin_trace_transaction_startPtr;
    trace_transaction_end: ITracePlugin_trace_transaction_endPtr;
    trace_proc_execute: ITracePlugin_trace_proc_executePtr;
    trace_trigger_execute: ITracePlugin_trace_trigger_executePtr;
    trace_set_context: ITracePlugin_trace_set_contextPtr;
    trace_dsql_prepare: ITracePlugin_trace_dsql_preparePtr;
    trace_dsql_free: ITracePlugin_trace_dsql_freePtr;
    trace_dsql_execute: ITracePlugin_trace_dsql_executePtr;
    trace_blr_compile: ITracePlugin_trace_blr_compilePtr;
    trace_blr_execute: ITracePlugin_trace_blr_executePtr;
    trace_dyn_execute: ITracePlugin_trace_dyn_executePtr;
    trace_service_attach: ITracePlugin_trace_service_attachPtr;
    trace_service_start: ITracePlugin_trace_service_startPtr;
    trace_service_query: ITracePlugin_trace_service_queryPtr;
    trace_service_detach: ITracePlugin_trace_service_detachPtr;
    trace_event_error: ITracePlugin_trace_event_errorPtr;
    trace_event_sweep: ITracePlugin_trace_event_sweepPtr;
    trace_func_execute: ITracePlugin_trace_func_executePtr;
  end;

  ITracePlugin = class(IReferenceCounted)
  const
    version = 3;

  const
    RESULT_SUCCESS = Cardinal(0);

  const
    RESULT_FAILED = Cardinal(1);

  const
    RESULT_UNAUTHORIZED = Cardinal(2);

  const
    SWEEP_STATE_STARTED = Cardinal(1);

  const
    SWEEP_STATE_FINISHED = Cardinal(2);

  const
    SWEEP_STATE_FAILED = Cardinal(3);

  const
    SWEEP_STATE_PROGRESS = Cardinal(4);

    function trace_get_error(): PAnsiChar;
    function trace_attach(connection: ITraceDatabaseConnection; create_db: Boolean; att_result: Cardinal): Boolean;
    function trace_detach(connection: ITraceDatabaseConnection; drop_db: Boolean): Boolean;
    function trace_transaction_start(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; tpb_length: Cardinal; tpb: BytePtr;
      tra_result: Cardinal): Boolean;
    function trace_transaction_end(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; commit: Boolean; retain_context: Boolean;
      tra_result: Cardinal): Boolean;
    function trace_proc_execute(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; procedure_: ITraceProcedure; started: Boolean;
      proc_result: Cardinal): Boolean;
    function trace_trigger_execute(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; trigger: ITraceTrigger; started: Boolean;
      trig_result: Cardinal): Boolean;
    function trace_set_context(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; variable: ITraceContextVariable): Boolean;
    function trace_dsql_prepare(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; statement: ITraceSQLStatement;
      time_millis: Int64; req_result: Cardinal): Boolean;
    function trace_dsql_free(connection: ITraceDatabaseConnection; statement: ITraceSQLStatement; option: Cardinal): Boolean;
    function trace_dsql_execute(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; statement: ITraceSQLStatement; started: Boolean;
      req_result: Cardinal): Boolean;
    function trace_blr_compile(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; statement: ITraceBLRStatement;
      time_millis: Int64; req_result: Cardinal): Boolean;
    function trace_blr_execute(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; statement: ITraceBLRStatement;
      req_result: Cardinal): Boolean;
    function trace_dyn_execute(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; request: ITraceDYNRequest; time_millis: Int64;
      req_result: Cardinal): Boolean;
    function trace_service_attach(service: ITraceServiceConnection; att_result: Cardinal): Boolean;
    function trace_service_start(service: ITraceServiceConnection; switches_length: Cardinal; switches: PAnsiChar; start_result: Cardinal): Boolean;
    function trace_service_query(service: ITraceServiceConnection; send_item_length: Cardinal; send_items: BytePtr; recv_item_length: Cardinal;
      recv_items: BytePtr; query_result: Cardinal): Boolean;
    function trace_service_detach(service: ITraceServiceConnection; detach_result: Cardinal): Boolean;
    function trace_event_error(connection: ITraceConnection; status: ITraceStatusVector; function_: PAnsiChar): Boolean;
    function trace_event_sweep(connection: ITraceDatabaseConnection; sweep: ITraceSweepInfo; sweep_state: Cardinal): Boolean;
    function trace_func_execute(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; function_: ITraceFunction; started: Boolean;
      func_result: Cardinal): Boolean;
  end;

  ITracePluginImpl = class(ITracePlugin)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    function trace_get_error(): PAnsiChar; virtual; abstract;
    function trace_attach(connection: ITraceDatabaseConnection; create_db: Boolean; att_result: Cardinal): Boolean; virtual; abstract;
    function trace_detach(connection: ITraceDatabaseConnection; drop_db: Boolean): Boolean; virtual; abstract;
    function trace_transaction_start(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; tpb_length: Cardinal; tpb: BytePtr;
      tra_result: Cardinal): Boolean; virtual; abstract;
    function trace_transaction_end(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; commit: Boolean; retain_context: Boolean;
      tra_result: Cardinal): Boolean; virtual; abstract;
    function trace_proc_execute(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; procedure_: ITraceProcedure; started: Boolean;
      proc_result: Cardinal): Boolean; virtual; abstract;
    function trace_trigger_execute(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; trigger: ITraceTrigger; started: Boolean;
      trig_result: Cardinal): Boolean; virtual; abstract;
    function trace_set_context(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; variable: ITraceContextVariable): Boolean;
      virtual; abstract;
    function trace_dsql_prepare(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; statement: ITraceSQLStatement;
      time_millis: Int64; req_result: Cardinal): Boolean; virtual; abstract;
    function trace_dsql_free(connection: ITraceDatabaseConnection; statement: ITraceSQLStatement; option: Cardinal): Boolean; virtual; abstract;
    function trace_dsql_execute(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; statement: ITraceSQLStatement; started: Boolean;
      req_result: Cardinal): Boolean; virtual; abstract;
    function trace_blr_compile(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; statement: ITraceBLRStatement;
      time_millis: Int64; req_result: Cardinal): Boolean; virtual; abstract;
    function trace_blr_execute(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; statement: ITraceBLRStatement;
      req_result: Cardinal): Boolean; virtual; abstract;
    function trace_dyn_execute(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; request: ITraceDYNRequest; time_millis: Int64;
      req_result: Cardinal): Boolean; virtual; abstract;
    function trace_service_attach(service: ITraceServiceConnection; att_result: Cardinal): Boolean; virtual; abstract;
    function trace_service_start(service: ITraceServiceConnection; switches_length: Cardinal; switches: PAnsiChar; start_result: Cardinal): Boolean;
      virtual; abstract;
    function trace_service_query(service: ITraceServiceConnection; send_item_length: Cardinal; send_items: BytePtr; recv_item_length: Cardinal;
      recv_items: BytePtr; query_result: Cardinal): Boolean; virtual; abstract;
    function trace_service_detach(service: ITraceServiceConnection; detach_result: Cardinal): Boolean; virtual; abstract;
    function trace_event_error(connection: ITraceConnection; status: ITraceStatusVector; function_: PAnsiChar): Boolean; virtual; abstract;
    function trace_event_sweep(connection: ITraceDatabaseConnection; sweep: ITraceSweepInfo; sweep_state: Cardinal): Boolean; virtual; abstract;
    function trace_func_execute(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; function_: ITraceFunction; started: Boolean;
      func_result: Cardinal): Boolean; virtual; abstract;
  end;

  TraceFactoryVTable = class(PluginBaseVTable)
    trace_needs: ITraceFactory_trace_needsPtr;
    trace_create: ITraceFactory_trace_createPtr;
  end;

  ITraceFactory = class(IPluginBase)
  const
    version = 4;

  const
    TRACE_EVENT_ATTACH = Cardinal(0);

  const
    TRACE_EVENT_DETACH = Cardinal(1);

  const
    TRACE_EVENT_TRANSACTION_START = Cardinal(2);

  const
    TRACE_EVENT_TRANSACTION_END = Cardinal(3);

  const
    TRACE_EVENT_SET_CONTEXT = Cardinal(4);

  const
    TRACE_EVENT_PROC_EXECUTE = Cardinal(5);

  const
    TRACE_EVENT_TRIGGER_EXECUTE = Cardinal(6);

  const
    TRACE_EVENT_DSQL_PREPARE = Cardinal(7);

  const
    TRACE_EVENT_DSQL_FREE = Cardinal(8);

  const
    TRACE_EVENT_DSQL_EXECUTE = Cardinal(9);

  const
    TRACE_EVENT_BLR_COMPILE = Cardinal(10);

  const
    TRACE_EVENT_BLR_EXECUTE = Cardinal(11);

  const
    TRACE_EVENT_DYN_EXECUTE = Cardinal(12);

  const
    TRACE_EVENT_SERVICE_ATTACH = Cardinal(13);

  const
    TRACE_EVENT_SERVICE_START = Cardinal(14);

  const
    TRACE_EVENT_SERVICE_QUERY = Cardinal(15);

  const
    TRACE_EVENT_SERVICE_DETACH = Cardinal(16);

  const
    trace_event_error = Cardinal(17);

  const
    trace_event_sweep = Cardinal(18);

  const
    TRACE_EVENT_FUNC_EXECUTE = Cardinal(19);

  const
    TRACE_EVENT_MAX = Cardinal(20);

    function trace_needs(): QWord;
    function trace_create(status: IStatus; init_info: ITraceInitInfo): ITracePlugin;
  end;

  ITraceFactoryImpl = class(ITraceFactory)
    constructor create;

    procedure addRef(); virtual; abstract;
    function release(): Integer; virtual; abstract;
    procedure setOwner(r: IReferenceCounted); virtual; abstract;
    function getOwner(): IReferenceCounted; virtual; abstract;
    function trace_needs(): QWord; virtual; abstract;
    function trace_create(status: IStatus; init_info: ITraceInitInfo): ITracePlugin; virtual; abstract;
  end;

  UdrFunctionFactoryVTable = class(DisposableVTable)
    setup: IUdrFunctionFactory_setupPtr;
    newItem: IUdrFunctionFactory_newItemPtr;
  end;

  IUdrFunctionFactory = class(IDisposable)
  const
    version = 3;

    procedure setup(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata; inBuilder: IMetadataBuilder;
      outBuilder: IMetadataBuilder);
    function newItem(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata): IExternalFunction;
  end;

  IUdrFunctionFactoryImpl = class(IUdrFunctionFactory)
    constructor create;

    procedure dispose(); virtual; abstract;
    procedure setup(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata; inBuilder: IMetadataBuilder;
      outBuilder: IMetadataBuilder); virtual; abstract;
    function newItem(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata): IExternalFunction; virtual; abstract;
  end;

  UdrProcedureFactoryVTable = class(DisposableVTable)
    setup: IUdrProcedureFactory_setupPtr;
    newItem: IUdrProcedureFactory_newItemPtr;
  end;

  IUdrProcedureFactory = class(IDisposable)
  const
    version = 3;

    procedure setup(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata; inBuilder: IMetadataBuilder;
      outBuilder: IMetadataBuilder);
    function newItem(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata): IExternalProcedure;
  end;

  IUdrProcedureFactoryImpl = class(IUdrProcedureFactory)
    constructor create;

    procedure dispose(); virtual; abstract;
    procedure setup(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata; inBuilder: IMetadataBuilder;
      outBuilder: IMetadataBuilder); virtual; abstract;
    function newItem(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata): IExternalProcedure; virtual; abstract;
  end;

  UdrTriggerFactoryVTable = class(DisposableVTable)
    setup: IUdrTriggerFactory_setupPtr;
    newItem: IUdrTriggerFactory_newItemPtr;
  end;

  IUdrTriggerFactory = class(IDisposable)
  const
    version = 3;

    procedure setup(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata; fieldsBuilder: IMetadataBuilder);
    function newItem(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata): IExternalTrigger;
  end;

  IUdrTriggerFactoryImpl = class(IUdrTriggerFactory)
    constructor create;

    procedure dispose(); virtual; abstract;
    procedure setup(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata; fieldsBuilder: IMetadataBuilder); virtual; abstract;
    function newItem(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata): IExternalTrigger; virtual; abstract;
  end;

  UdrPluginVTable = class(VersionedVTable)
    getMaster: IUdrPlugin_getMasterPtr;
    registerFunction: IUdrPlugin_registerFunctionPtr;
    registerProcedure: IUdrPlugin_registerProcedurePtr;
    registerTrigger: IUdrPlugin_registerTriggerPtr;
  end;

  IUdrPlugin = class(IVersioned)
  const
    version = 2;

    function getMaster(): IMaster;
    procedure registerFunction(status: IStatus; name: PAnsiChar; factory: IUdrFunctionFactory);
    procedure registerProcedure(status: IStatus; name: PAnsiChar; factory: IUdrProcedureFactory);
    procedure registerTrigger(status: IStatus; name: PAnsiChar; factory: IUdrTriggerFactory);
  end;

  IUdrPluginImpl = class(IUdrPlugin)
    constructor create;

    function getMaster(): IMaster; virtual; abstract;
    procedure registerFunction(status: IStatus; name: PAnsiChar; factory: IUdrFunctionFactory); virtual; abstract;
    procedure registerProcedure(status: IStatus; name: PAnsiChar; factory: IUdrProcedureFactory); virtual; abstract;
    procedure registerTrigger(status: IStatus; name: PAnsiChar; factory: IUdrTriggerFactory); virtual; abstract;
  end;

function fb_get_master_interface: IMaster; cdecl; external 'fbclient';

const
  isc_dpb_version1                     = Byte(1);
  isc_dpb_version2                     = Byte(2);
  isc_dpb_cdd_pathname                 = Byte(1);
  isc_dpb_allocation                   = Byte(2);
  isc_dpb_journal                      = Byte(3);
  isc_dpb_page_size                    = Byte(4);
  isc_dpb_num_buffers                  = Byte(5);
  isc_dpb_buffer_length                = Byte(6);
  isc_dpb_debug                        = Byte(7);
  isc_dpb_garbage_collect              = Byte(8);
  isc_dpb_verify                       = Byte(9);
  isc_dpb_sweep                        = Byte(10);
  isc_dpb_enable_journal               = Byte(11);
  isc_dpb_disable_journal              = Byte(12);
  isc_dpb_dbkey_scope                  = Byte(13);
  isc_dpb_number_of_users              = Byte(14);
  isc_dpb_trace                        = Byte(15);
  isc_dpb_no_garbage_collect           = Byte(16);
  isc_dpb_damaged                      = Byte(17);
  isc_dpb_license                      = Byte(18);
  isc_dpb_sys_user_name                = Byte(19);
  isc_dpb_encrypt_key                  = Byte(20);
  isc_dpb_activate_shadow              = Byte(21);
  isc_dpb_sweep_interval               = Byte(22);
  isc_dpb_delete_shadow                = Byte(23);
  isc_dpb_force_write                  = Byte(24);
  isc_dpb_begin_log                    = Byte(25);
  isc_dpb_quit_log                     = Byte(26);
  isc_dpb_no_reserve                   = Byte(27);
  isc_dpb_user_name                    = Byte(28);
  isc_dpb_password                     = Byte(29);
  isc_dpb_password_enc                 = Byte(30);
  isc_dpb_sys_user_name_enc            = Byte(31);
  isc_dpb_interp                       = Byte(32);
  isc_dpb_online_dump                  = Byte(33);
  isc_dpb_old_file_size                = Byte(34);
  isc_dpb_old_num_files                = Byte(35);
  isc_dpb_old_file                     = Byte(36);
  isc_dpb_old_start_page               = Byte(37);
  isc_dpb_old_start_seqno              = Byte(38);
  isc_dpb_old_start_file               = Byte(39);
  isc_dpb_drop_walfile                 = Byte(40);
  isc_dpb_old_dump_id                  = Byte(41);
  isc_dpb_wal_backup_dir               = Byte(42);
  isc_dpb_wal_chkptlen                 = Byte(43);
  isc_dpb_wal_numbufs                  = Byte(44);
  isc_dpb_wal_bufsize                  = Byte(45);
  isc_dpb_wal_grp_cmt_wait             = Byte(46);
  isc_dpb_lc_messages                  = Byte(47);
  isc_dpb_lc_ctype                     = Byte(48);
  isc_dpb_cache_manager                = Byte(49);
  isc_dpb_shutdown                     = Byte(50);
  isc_dpb_online                       = Byte(51);
  isc_dpb_shutdown_delay               = Byte(52);
  isc_dpb_reserved                     = Byte(53);
  isc_dpb_overwrite                    = Byte(54);
  isc_dpb_sec_attach                   = Byte(55);
  isc_dpb_disable_wal                  = Byte(56);
  isc_dpb_connect_timeout              = Byte(57);
  isc_dpb_dummy_packet_interval        = Byte(58);
  isc_dpb_gbak_attach                  = Byte(59);
  isc_dpb_sql_role_name                = Byte(60);
  isc_dpb_set_page_buffers             = Byte(61);
  isc_dpb_working_directory            = Byte(62);
  isc_dpb_sql_dialect                  = Byte(63);
  isc_dpb_set_db_readonly              = Byte(64);
  isc_dpb_set_db_sql_dialect           = Byte(65);
  isc_dpb_gfix_attach                  = Byte(66);
  isc_dpb_gstat_attach                 = Byte(67);
  isc_dpb_set_db_charset               = Byte(68);
  isc_dpb_gsec_attach                  = Byte(69);
  isc_dpb_address_path                 = Byte(70);
  isc_dpb_process_id                   = Byte(71);
  isc_dpb_no_db_triggers               = Byte(72);
  isc_dpb_trusted_auth                 = Byte(73);
  isc_dpb_process_name                 = Byte(74);
  isc_dpb_trusted_role                 = Byte(75);
  isc_dpb_org_filename                 = Byte(76);
  isc_dpb_utf8_filename                = Byte(77);
  isc_dpb_ext_call_depth               = Byte(78);
  isc_dpb_auth_block                   = Byte(79);
  isc_dpb_client_version               = Byte(80);
  isc_dpb_remote_protocol              = Byte(81);
  isc_dpb_host_name                    = Byte(82);
  isc_dpb_os_user                      = Byte(83);
  isc_dpb_specific_auth_data           = Byte(84);
  isc_dpb_auth_plugin_list             = Byte(85);
  isc_dpb_auth_plugin_name             = Byte(86);
  isc_dpb_config                       = Byte(87);
  isc_dpb_nolinger                     = Byte(88);
  isc_dpb_reset_icu                    = Byte(89);
  isc_dpb_map_attach                   = Byte(90);
  isc_dpb_address                      = Byte(1);
  isc_dpb_addr_protocol                = Byte(1);
  isc_dpb_addr_endpoint                = Byte(2);
  isc_dpb_addr_flags                   = Byte(3);
  isc_dpb_addr_flag_conn_compressed    = $01;
  isc_dpb_addr_flag_conn_encrypted     = $02;
  isc_dpb_pages                        = Byte(1);
  isc_dpb_records                      = Byte(2);
  isc_dpb_indices                      = Byte(4);
  isc_dpb_transactions                 = Byte(8);
  isc_dpb_no_update                    = Byte(16);
  isc_dpb_repair                       = Byte(32);
  isc_dpb_ignore                       = Byte(64);
  isc_dpb_shut_cache                   = $1;
  isc_dpb_shut_attachment              = $2;
  isc_dpb_shut_transaction             = $4;
  isc_dpb_shut_force                   = $8;
  isc_dpb_shut_mode_mask               = $70;
  isc_dpb_shut_default                 = $0;
  isc_dpb_shut_normal                  = $10;
  isc_dpb_shut_multi                   = $20;
  isc_dpb_shut_single                  = $30;
  isc_dpb_shut_full                    = $40;
  RDB_system                           = Byte(1);
  RDB_id_assigned                      = Byte(2);
  isc_tpb_version1                     = Byte(1);
  isc_tpb_version3                     = Byte(3);
  isc_tpb_consistency                  = Byte(1);
  isc_tpb_concurrency                  = Byte(2);
  isc_tpb_shared                       = Byte(3);
  isc_tpb_protected                    = Byte(4);
  isc_tpb_exclusive                    = Byte(5);
  isc_tpb_wait                         = Byte(6);
  isc_tpb_nowait                       = Byte(7);
  isc_tpb_read                         = Byte(8);
  isc_tpb_write                        = Byte(9);
  isc_tpb_lock_read                    = Byte(10);
  isc_tpb_lock_write                   = Byte(11);
  isc_tpb_verb_time                    = Byte(12);
  isc_tpb_commit_time                  = Byte(13);
  isc_tpb_ignore_limbo                 = Byte(14);
  isc_tpb_read_committed               = Byte(15);
  isc_tpb_autocommit                   = Byte(16);
  isc_tpb_rec_version                  = Byte(17);
  isc_tpb_no_rec_version               = Byte(18);
  isc_tpb_restart_requests             = Byte(19);
  isc_tpb_no_auto_undo                 = Byte(20);
  isc_tpb_lock_timeout                 = Byte(21);
  isc_bpb_version1                     = Byte(1);
  isc_bpb_source_type                  = Byte(1);
  isc_bpb_target_type                  = Byte(2);
  isc_bpb_type                         = Byte(3);
  isc_bpb_source_interp                = Byte(4);
  isc_bpb_target_interp                = Byte(5);
  isc_bpb_filter_parameter             = Byte(6);
  isc_bpb_storage                      = Byte(7);
  isc_bpb_type_segmented               = $0;
  isc_bpb_type_stream                  = $1;
  isc_bpb_storage_main                 = $0;
  isc_bpb_storage_temp                 = $2;
  isc_spb_version1                     = Byte(1);
  isc_spb_current_version              = Byte(2);
  isc_spb_version3                     = Byte(3);
  isc_spb_command_line                 = Byte(105);
  isc_spb_dbname                       = Byte(106);
  isc_spb_verbose                      = Byte(107);
  isc_spb_options                      = Byte(108);
  isc_spb_address_path                 = Byte(109);
  isc_spb_process_id                   = Byte(110);
  isc_spb_trusted_auth                 = Byte(111);
  isc_spb_process_name                 = Byte(112);
  isc_spb_trusted_role                 = Byte(113);
  isc_spb_verbint                      = Byte(114);
  isc_spb_auth_block                   = Byte(115);
  isc_spb_auth_plugin_name             = Byte(116);
  isc_spb_auth_plugin_list             = Byte(117);
  isc_spb_utf8_filename                = Byte(118);
  isc_spb_client_version               = Byte(119);
  isc_spb_remote_protocol              = Byte(120);
  isc_spb_host_name                    = Byte(121);
  isc_spb_os_user                      = Byte(122);
  isc_spb_config                       = Byte(123);
  isc_spb_expected_db                  = Byte(124);
  isc_action_svc_backup                = Byte(1);
  isc_action_svc_restore               = Byte(2);
  isc_action_svc_repair                = Byte(3);
  isc_action_svc_add_user              = Byte(4);
  isc_action_svc_delete_user           = Byte(5);
  isc_action_svc_modify_user           = Byte(6);
  isc_action_svc_display_user          = Byte(7);
  isc_action_svc_properties            = Byte(8);
  isc_action_svc_add_license           = Byte(9);
  isc_action_svc_remove_license        = Byte(10);
  isc_action_svc_db_stats              = Byte(11);
  isc_action_svc_get_ib_log            = Byte(12);
  isc_action_svc_get_fb_log            = Byte(12);
  isc_action_svc_nbak                  = Byte(20);
  isc_action_svc_nrest                 = Byte(21);
  isc_action_svc_trace_start           = Byte(22);
  isc_action_svc_trace_stop            = Byte(23);
  isc_action_svc_trace_suspend         = Byte(24);
  isc_action_svc_trace_resume          = Byte(25);
  isc_action_svc_trace_list            = Byte(26);
  isc_action_svc_set_mapping           = Byte(27);
  isc_action_svc_drop_mapping          = Byte(28);
  isc_action_svc_display_user_adm      = Byte(29);
  isc_action_svc_validate              = Byte(30);
  isc_action_svc_last                  = Byte(31);
  isc_info_svc_svr_db_info             = Byte(50);
  isc_info_svc_get_license             = Byte(51);
  isc_info_svc_get_license_mask        = Byte(52);
  isc_info_svc_get_config              = Byte(53);
  isc_info_svc_version                 = Byte(54);
  isc_info_svc_server_version          = Byte(55);
  isc_info_svc_implementation          = Byte(56);
  isc_info_svc_capabilities            = Byte(57);
  isc_info_svc_user_dbpath             = Byte(58);
  isc_info_svc_get_env                 = Byte(59);
  isc_info_svc_get_env_lock            = Byte(60);
  isc_info_svc_get_env_msg             = Byte(61);
  isc_info_svc_line                    = Byte(62);
  isc_info_svc_to_eof                  = Byte(63);
  isc_info_svc_timeout                 = Byte(64);
  isc_info_svc_get_licensed_users      = Byte(65);
  isc_info_svc_limbo_trans             = Byte(66);
  isc_info_svc_running                 = Byte(67);
  isc_info_svc_get_users               = Byte(68);
  isc_info_svc_auth_block              = Byte(69);
  isc_info_svc_stdin                   = Byte(78);
  isc_spb_sec_userid                   = Byte(5);
  isc_spb_sec_groupid                  = Byte(6);
  isc_spb_sec_username                 = Byte(7);
  isc_spb_sec_password                 = Byte(8);
  isc_spb_sec_groupname                = Byte(9);
  isc_spb_sec_firstname                = Byte(10);
  isc_spb_sec_middlename               = Byte(11);
  isc_spb_sec_lastname                 = Byte(12);
  isc_spb_sec_admin                    = Byte(13);
  isc_spb_lic_key                      = Byte(5);
  isc_spb_lic_id                       = Byte(6);
  isc_spb_lic_desc                     = Byte(7);
  isc_spb_bkp_file                     = Byte(5);
  isc_spb_bkp_factor                   = Byte(6);
  isc_spb_bkp_length                   = Byte(7);
  isc_spb_bkp_skip_data                = Byte(8);
  isc_spb_bkp_stat                     = Byte(15);
  isc_spb_bkp_ignore_checksums         = $01;
  isc_spb_bkp_ignore_limbo             = $02;
  isc_spb_bkp_metadata_only            = $04;
  isc_spb_bkp_no_garbage_collect       = $08;
  isc_spb_bkp_old_descriptions         = $10;
  isc_spb_bkp_non_transportable        = $20;
  isc_spb_bkp_convert                  = $40;
  isc_spb_bkp_expand                   = $80;
  isc_spb_bkp_no_triggers              = $8000;
  isc_spb_prp_page_buffers             = Byte(5);
  isc_spb_prp_sweep_interval           = Byte(6);
  isc_spb_prp_shutdown_db              = Byte(7);
  isc_spb_prp_deny_new_attachments     = Byte(9);
  isc_spb_prp_deny_new_transactions    = Byte(10);
  isc_spb_prp_reserve_space            = Byte(11);
  isc_spb_prp_write_mode               = Byte(12);
  isc_spb_prp_access_mode              = Byte(13);
  isc_spb_prp_set_sql_dialect          = Byte(14);
  isc_spb_prp_activate                 = $0100;
  isc_spb_prp_db_online                = $0200;
  isc_spb_prp_nolinger                 = $0400;
  isc_spb_prp_force_shutdown           = Byte(41);
  isc_spb_prp_attachments_shutdown     = Byte(42);
  isc_spb_prp_transactions_shutdown    = Byte(43);
  isc_spb_prp_shutdown_mode            = Byte(44);
  isc_spb_prp_online_mode              = Byte(45);
  isc_spb_prp_sm_normal                = Byte(0);
  isc_spb_prp_sm_multi                 = Byte(1);
  isc_spb_prp_sm_single                = Byte(2);
  isc_spb_prp_sm_full                  = Byte(3);
  isc_spb_prp_res_use_full             = Byte(35);
  isc_spb_prp_res                      = Byte(36);
  isc_spb_prp_wm_async                 = Byte(37);
  isc_spb_prp_wm_sync                  = Byte(38);
  isc_spb_prp_am_readonly              = Byte(39);
  isc_spb_prp_am_readwrite             = Byte(40);
  isc_spb_rpr_commit_trans             = Byte(15);
  isc_spb_rpr_rollback_trans           = Byte(34);
  isc_spb_rpr_recover_two_phase        = Byte(17);
  isc_spb_tra_id                       = Byte(18);
  isc_spb_single_tra_id                = Byte(19);
  isc_spb_multi_tra_id                 = Byte(20);
  isc_spb_tra_state                    = Byte(21);
  isc_spb_tra_state_limbo              = Byte(22);
  isc_spb_tra_state_commit             = Byte(23);
  isc_spb_tra_state_rollback           = Byte(24);
  isc_spb_tra_state_unknown            = Byte(25);
  isc_spb_tra_host_site                = Byte(26);
  isc_spb_tra_remote_site              = Byte(27);
  isc_spb_tra_db_path                  = Byte(28);
  isc_spb_tra_advise                   = Byte(29);
  isc_spb_tra_advise_commit            = Byte(30);
  isc_spb_tra_advise_rollback          = Byte(31);
  isc_spb_tra_advise_unknown           = Byte(33);
  isc_spb_tra_id_64                    = Byte(46);
  isc_spb_single_tra_id_64             = Byte(47);
  isc_spb_multi_tra_id_64              = Byte(48);
  isc_spb_rpr_commit_trans_64          = Byte(49);
  isc_spb_rpr_rollback_trans_64        = Byte(50);
  isc_spb_rpr_recover_two_phase_64     = Byte(51);
  isc_spb_rpr_validate_db              = $01;
  isc_spb_rpr_sweep_db                 = $02;
  isc_spb_rpr_mend_db                  = $04;
  isc_spb_rpr_list_limbo_trans         = $08;
  isc_spb_rpr_check_db                 = $10;
  isc_spb_rpr_ignore_checksum          = $20;
  isc_spb_rpr_kill_shadows             = $40;
  isc_spb_rpr_full                     = $80;
  isc_spb_rpr_icu                      = $0800;
  isc_spb_res_buffers                  = Byte(9);
  isc_spb_res_page_size                = Byte(10);
  isc_spb_res_length                   = Byte(11);
  isc_spb_res_access_mode              = Byte(12);
  isc_spb_res_fix_fss_data             = Byte(13);
  isc_spb_res_fix_fss_metadata         = Byte(14);
  isc_spb_res_deactivate_idx           = $0100;
  isc_spb_res_no_shadow                = $0200;
  isc_spb_res_no_validity              = $0400;
  isc_spb_res_one_at_a_time            = $0800;
  isc_spb_res_replace                  = $1000;
  isc_spb_res_create                   = $2000;
  isc_spb_res_use_all_space            = $4000;
  isc_spb_val_tab_incl                 = Byte(1);
  isc_spb_val_tab_excl                 = Byte(2);
  isc_spb_val_idx_incl                 = Byte(3);
  isc_spb_val_idx_excl                 = Byte(4);
  isc_spb_val_lock_timeout             = Byte(5);
  isc_spb_num_att                      = Byte(5);
  isc_spb_num_db                       = Byte(6);
  isc_spb_sts_table                    = Byte(64);
  isc_spb_sts_data_pages               = $01;
  isc_spb_sts_db_log                   = $02;
  isc_spb_sts_hdr_pages                = $04;
  isc_spb_sts_idx_pages                = $08;
  isc_spb_sts_sys_relations            = $10;
  isc_spb_sts_record_versions          = $20;
  isc_spb_sts_nocreation               = $80;
  isc_spb_sts_encryption               = $100;
  isc_spb_nbk_level                    = Byte(5);
  isc_spb_nbk_file                     = Byte(6);
  isc_spb_nbk_direct                   = Byte(7);
  isc_spb_nbk_no_triggers              = $01;
  isc_spb_trc_id                       = Byte(1);
  isc_spb_trc_name                     = Byte(2);
  isc_spb_trc_cfg                      = Byte(3);
  isc_sdl_version1                     = Byte(1);
  isc_sdl_eoc                          = Byte(255);
  isc_sdl_relation                     = Byte(2);
  isc_sdl_rid                          = Byte(3);
  isc_sdl_field                        = Byte(4);
  isc_sdl_fid                          = Byte(5);
  isc_sdl_struct                       = Byte(6);
  isc_sdl_variable                     = Byte(7);
  isc_sdl_scalar                       = Byte(8);
  isc_sdl_tiny_integer                 = Byte(9);
  isc_sdl_short_integer                = Byte(10);
  isc_sdl_long_integer                 = Byte(11);
  isc_sdl_add                          = Byte(13);
  isc_sdl_subtract                     = Byte(14);
  isc_sdl_multiply                     = Byte(15);
  isc_sdl_divide                       = Byte(16);
  isc_sdl_negate                       = Byte(17);
  isc_sdl_begin                        = Byte(31);
  isc_sdl_end                          = Byte(32);
  isc_sdl_do3                          = Byte(33);
  isc_sdl_do2                          = Byte(34);
  isc_sdl_do1                          = Byte(35);
  isc_sdl_element                      = Byte(36);
  isc_blob_untyped                     = Byte(0);
  isc_blob_text                        = Byte(1);
  isc_blob_blr                         = Byte(2);
  isc_blob_acl                         = Byte(3);
  isc_blob_ranges                      = Byte(4);
  isc_blob_summary                     = Byte(5);
  isc_blob_format                      = Byte(6);
  isc_blob_tra                         = Byte(7);
  isc_blob_extfile                     = Byte(8);
  isc_blob_debug_info                  = Byte(9);
  isc_blob_max_predefined_subtype      = Byte(10);
  fb_shut_confirmation                 = Byte(1);
  fb_shut_preproviders                 = Byte(2);
  fb_shut_postproviders                = Byte(4);
  fb_shut_finish                       = Byte(8);
  fb_shut_exit                         = Byte(16);
  fb_cancel_disable                    = Byte(1);
  fb_cancel_enable                     = Byte(2);
  fb_cancel_raise                      = Byte(3);
  fb_cancel_abort                      = Byte(4);
  fb_dbg_version                       = Byte(1);
  fb_dbg_end                           = Byte(255);
  fb_dbg_map_src2blr                   = Byte(2);
  fb_dbg_map_varname                   = Byte(3);
  fb_dbg_map_argument                  = Byte(4);
  fb_dbg_subproc                       = Byte(5);
  fb_dbg_subfunc                       = Byte(6);
  fb_dbg_map_curname                   = Byte(7);
  fb_dbg_arg_input                     = Byte(0);
  fb_dbg_arg_output                    = Byte(1);
  isc_facility                         = 20;
  isc_err_base                         = 335544320;
  isc_err_factor                       = 1;
  isc_arg_end                          = 0; (* end of argument list *)
  isc_arg_gds                          = 1; (* generic DSRI status value *)
  isc_arg_string                       = 2; (* string argument *)
  isc_arg_cstring                      = 3; (* count & string argument *)
  isc_arg_number                       = 4; (* numeric argument (long) *)
  isc_arg_interpreted                  = 5; (* interpreted status code (string) *)
  isc_arg_vms                          = 6; (* VAX/VMS status code (long) *)
  isc_arg_unix                         = 7; (* UNIX error code *)
  isc_arg_domain                       = 8; (* Apollo/Domain error code *)
  isc_arg_dos                          = 9; (* MSDOS/OS2 error code *)
  isc_arith_except                     = 335544321;
  isc_bad_dbkey                        = 335544322;
  isc_bad_db_format                    = 335544323;
  isc_bad_db_handle                    = 335544324;
  isc_bad_dpb_content                  = 335544325;
  isc_bad_dpb_form                     = 335544326;
  isc_bad_req_handle                   = 335544327;
  isc_bad_segstr_handle                = 335544328;
  isc_bad_segstr_id                    = 335544329;
  isc_bad_tpb_content                  = 335544330;
  isc_bad_tpb_form                     = 335544331;
  isc_bad_trans_handle                 = 335544332;
  isc_bug_check                        = 335544333;
  isc_convert_error                    = 335544334;
  isc_db_corrupt                       = 335544335;
  isc_deadlock                         = 335544336;
  isc_excess_trans                     = 335544337;
  isc_from_no_match                    = 335544338;
  isc_infinap                          = 335544339;
  isc_infona                           = 335544340;
  isc_infunk                           = 335544341;
  isc_integ_fail                       = 335544342;
  isc_invalid_blr                      = 335544343;
  isc_io_error                         = 335544344;
  isc_lock_conflict                    = 335544345;
  isc_metadata_corrupt                 = 335544346;
  isc_not_valid                        = 335544347;
  isc_no_cur_rec                       = 335544348;
  isc_no_dup                           = 335544349;
  isc_no_finish                        = 335544350;
  isc_no_meta_update                   = 335544351;
  isc_no_priv                          = 335544352;
  isc_no_recon                         = 335544353;
  isc_no_record                        = 335544354;
  isc_no_segstr_close                  = 335544355;
  isc_obsolete_metadata                = 335544356;
  isc_open_trans                       = 335544357;
  isc_port_len                         = 335544358;
  isc_read_only_field                  = 335544359;
  isc_read_only_rel                    = 335544360;
  isc_read_only_trans                  = 335544361;
  isc_read_only_view                   = 335544362;
  isc_req_no_trans                     = 335544363;
  isc_req_sync                         = 335544364;
  isc_req_wrong_db                     = 335544365;
  isc_segment                          = 335544366;
  isc_segstr_eof                       = 335544367;
  isc_segstr_no_op                     = 335544368;
  isc_segstr_no_read                   = 335544369;
  isc_segstr_no_trans                  = 335544370;
  isc_segstr_no_write                  = 335544371;
  isc_segstr_wrong_db                  = 335544372;
  isc_sys_request                      = 335544373;
  isc_stream_eof                       = 335544374;
  isc_unavailable                      = 335544375;
  isc_unres_rel                        = 335544376;
  isc_uns_ext                          = 335544377;
  isc_wish_list                        = 335544378;
  isc_wrong_ods                        = 335544379;
  isc_wronumarg                        = 335544380;
  isc_imp_exc                          = 335544381;
  isc_random                           = 335544382;
  isc_fatal_conflict                   = 335544383;
  isc_badblk                           = 335544384;
  isc_invpoolcl                        = 335544385;
  isc_nopoolids                        = 335544386;
  isc_relbadblk                        = 335544387;
  isc_blktoobig                        = 335544388;
  isc_bufexh                           = 335544389;
  isc_syntaxerr                        = 335544390;
  isc_bufinuse                         = 335544391;
  isc_bdbincon                         = 335544392;
  isc_reqinuse                         = 335544393;
  isc_badodsver                        = 335544394;
  isc_relnotdef                        = 335544395;
  isc_fldnotdef                        = 335544396;
  isc_dirtypage                        = 335544397;
  isc_waifortra                        = 335544398;
  isc_doubleloc                        = 335544399;
  isc_nodnotfnd                        = 335544400;
  isc_dupnodfnd                        = 335544401;
  isc_locnotmar                        = 335544402;
  isc_badpagtyp                        = 335544403;
  isc_corrupt                          = 335544404;
  isc_badpage                          = 335544405;
  isc_badindex                         = 335544406;
  isc_dbbnotzer                        = 335544407;
  isc_tranotzer                        = 335544408;
  isc_trareqmis                        = 335544409;
  isc_badhndcnt                        = 335544410;
  isc_wrotpbver                        = 335544411;
  isc_wroblrver                        = 335544412;
  isc_wrodpbver                        = 335544413;
  isc_blobnotsup                       = 335544414;
  isc_badrelation                      = 335544415;
  isc_nodetach                         = 335544416;
  isc_notremote                        = 335544417;
  isc_trainlim                         = 335544418;
  isc_notinlim                         = 335544419;
  isc_traoutsta                        = 335544420;
  isc_connect_reject                   = 335544421;
  isc_dbfile                           = 335544422;
  isc_orphan                           = 335544423;
  isc_no_lock_mgr                      = 335544424;
  isc_ctxinuse                         = 335544425;
  isc_ctxnotdef                        = 335544426;
  isc_datnotsup                        = 335544427;
  isc_badmsgnum                        = 335544428;
  isc_badparnum                        = 335544429;
  isc_virmemexh                        = 335544430;
  isc_blocking_signal                  = 335544431;
  isc_lockmanerr                       = 335544432;
  isc_journerr                         = 335544433;
  isc_keytoobig                        = 335544434;
  isc_nullsegkey                       = 335544435;
  isc_sqlerr                           = 335544436;
  isc_wrodynver                        = 335544437;
  isc_funnotdef                        = 335544438;
  isc_funmismat                        = 335544439;
  isc_bad_msg_vec                      = 335544440;
  isc_bad_detach                       = 335544441;
  isc_noargacc_read                    = 335544442;
  isc_noargacc_write                   = 335544443;
  isc_read_only                        = 335544444;
  isc_ext_err                          = 335544445;
  isc_non_updatable                    = 335544446;
  isc_no_rollback                      = 335544447;
  isc_bad_sec_info                     = 335544448;
  isc_invalid_sec_info                 = 335544449;
  isc_misc_interpreted                 = 335544450;
  isc_update_conflict                  = 335544451;
  isc_unlicensed                       = 335544452;
  isc_obj_in_use                       = 335544453;
  isc_nofilter                         = 335544454;
  isc_shadow_accessed                  = 335544455;
  isc_invalid_sdl                      = 335544456;
  isc_out_of_bounds                    = 335544457;
  isc_invalid_dimension                = 335544458;
  isc_rec_in_limbo                     = 335544459;
  isc_shadow_missing                   = 335544460;
  isc_cant_validate                    = 335544461;
  isc_cant_start_journal               = 335544462;
  isc_gennotdef                        = 335544463;
  isc_cant_start_logging               = 335544464;
  isc_bad_segstr_type                  = 335544465;
  isc_foreign_key                      = 335544466;
  isc_high_minor                       = 335544467;
  isc_tra_state                        = 335544468;
  isc_trans_invalid                    = 335544469;
  isc_buf_invalid                      = 335544470;
  isc_indexnotdefined                  = 335544471;
  isc_login                            = 335544472;
  isc_invalid_bookmark                 = 335544473;
  isc_bad_lock_level                   = 335544474;
  isc_relation_lock                    = 335544475;
  isc_record_lock                      = 335544476;
  isc_max_idx                          = 335544477;
  isc_jrn_enable                       = 335544478;
  isc_old_failure                      = 335544479;
  isc_old_in_progress                  = 335544480;
  isc_old_no_space                     = 335544481;
  isc_no_wal_no_jrn                    = 335544482;
  isc_num_old_files                    = 335544483;
  isc_wal_file_open                    = 335544484;
  isc_bad_stmt_handle                  = 335544485;
  isc_wal_failure                      = 335544486;
  isc_walw_err                         = 335544487;
  isc_logh_small                       = 335544488;
  isc_logh_inv_version                 = 335544489;
  isc_logh_open_flag                   = 335544490;
  isc_logh_open_flag2                  = 335544491;
  isc_logh_diff_dbname                 = 335544492;
  isc_logf_unexpected_eof              = 335544493;
  isc_logr_incomplete                  = 335544494;
  isc_logr_header_small                = 335544495;
  isc_logb_small                       = 335544496;
  isc_wal_illegal_attach               = 335544497;
  isc_wal_invalid_wpb                  = 335544498;
  isc_wal_err_rollover                 = 335544499;
  isc_no_wal                           = 335544500;
  isc_drop_wal                         = 335544501;
  isc_stream_not_defined               = 335544502;
  isc_wal_subsys_error                 = 335544503;
  isc_wal_subsys_corrupt               = 335544504;
  isc_no_archive                       = 335544505;
  isc_shutinprog                       = 335544506;
  isc_range_in_use                     = 335544507;
  isc_range_not_found                  = 335544508;
  isc_charset_not_found                = 335544509;
  isc_lock_timeout                     = 335544510;
  isc_prcnotdef                        = 335544511;
  isc_prcmismat                        = 335544512;
  isc_wal_bugcheck                     = 335544513;
  isc_wal_cant_expand                  = 335544514;
  isc_codnotdef                        = 335544515;
  isc_xcpnotdef                        = 335544516;
  isc_except                           = 335544517;
  isc_cache_restart                    = 335544518;
  isc_bad_lock_handle                  = 335544519;
  isc_jrn_present                      = 335544520;
  isc_wal_err_rollover2                = 335544521;
  isc_wal_err_logwrite                 = 335544522;
  isc_wal_err_jrn_comm                 = 335544523;
  isc_wal_err_expansion                = 335544524;
  isc_wal_err_setup                    = 335544525;
  isc_wal_err_ww_sync                  = 335544526;
  isc_wal_err_ww_start                 = 335544527;
  isc_shutdown                         = 335544528;
  isc_existing_priv_mod                = 335544529;
  isc_primary_key_ref                  = 335544530;
  isc_primary_key_notnull              = 335544531;
  isc_ref_cnstrnt_notfound             = 335544532;
  isc_foreign_key_notfound             = 335544533;
  isc_ref_cnstrnt_update               = 335544534;
  isc_check_cnstrnt_update             = 335544535;
  isc_check_cnstrnt_del                = 335544536;
  isc_integ_index_seg_del              = 335544537;
  isc_integ_index_seg_mod              = 335544538;
  isc_integ_index_del                  = 335544539;
  isc_integ_index_mod                  = 335544540;
  isc_check_trig_del                   = 335544541;
  isc_check_trig_update                = 335544542;
  isc_cnstrnt_fld_del                  = 335544543;
  isc_cnstrnt_fld_rename               = 335544544;
  isc_rel_cnstrnt_update               = 335544545;
  isc_constaint_on_view                = 335544546;
  isc_invld_cnstrnt_type               = 335544547;
  isc_primary_key_exists               = 335544548;
  isc_systrig_update                   = 335544549;
  isc_not_rel_owner                    = 335544550;
  isc_grant_obj_notfound               = 335544551;
  isc_grant_fld_notfound               = 335544552;
  isc_grant_nopriv                     = 335544553;
  isc_nonsql_security_rel              = 335544554;
  isc_nonsql_security_fld              = 335544555;
  isc_wal_cache_err                    = 335544556;
  isc_shutfail                         = 335544557;
  isc_check_constraint                 = 335544558;
  isc_bad_svc_handle                   = 335544559;
  isc_shutwarn                         = 335544560;
  isc_wrospbver                        = 335544561;
  isc_bad_spb_form                     = 335544562;
  isc_svcnotdef                        = 335544563;
  isc_no_jrn                           = 335544564;
  isc_transliteration_failed           = 335544565;
  isc_start_cm_for_wal                 = 335544566;
  isc_wal_ovflow_log_required          = 335544567;
  isc_text_subtype                     = 335544568;
  isc_dsql_error                       = 335544569;
  isc_dsql_command_err                 = 335544570;
  isc_dsql_constant_err                = 335544571;
  isc_dsql_cursor_err                  = 335544572;
  isc_dsql_datatype_err                = 335544573;
  isc_dsql_decl_err                    = 335544574;
  isc_dsql_cursor_update_err           = 335544575;
  isc_dsql_cursor_open_err             = 335544576;
  isc_dsql_cursor_close_err            = 335544577;
  isc_dsql_field_err                   = 335544578;
  isc_dsql_internal_err                = 335544579;
  isc_dsql_relation_err                = 335544580;
  isc_dsql_procedure_err               = 335544581;
  isc_dsql_request_err                 = 335544582;
  isc_dsql_sqlda_err                   = 335544583;
  isc_dsql_var_count_err               = 335544584;
  isc_dsql_stmt_handle                 = 335544585;
  isc_dsql_function_err                = 335544586;
  isc_dsql_blob_err                    = 335544587;
  isc_collation_not_found              = 335544588;
  isc_collation_not_for_charset        = 335544589;
  isc_dsql_dup_option                  = 335544590;
  isc_dsql_tran_err                    = 335544591;
  isc_dsql_invalid_array               = 335544592;
  isc_dsql_max_arr_dim_exceeded        = 335544593;
  isc_dsql_arr_range_error             = 335544594;
  isc_dsql_trigger_err                 = 335544595;
  isc_dsql_subselect_err               = 335544596;
  isc_dsql_crdb_prepare_err            = 335544597;
  isc_specify_field_err                = 335544598;
  isc_num_field_err                    = 335544599;
  isc_col_name_err                     = 335544600;
  isc_where_err                        = 335544601;
  isc_table_view_err                   = 335544602;
  isc_distinct_err                     = 335544603;
  isc_key_field_count_err              = 335544604;
  isc_subquery_err                     = 335544605;
  isc_expression_eval_err              = 335544606;
  isc_node_err                         = 335544607;
  isc_command_end_err                  = 335544608;
  isc_index_name                       = 335544609;
  isc_exception_name                   = 335544610;
  isc_field_name                       = 335544611;
  isc_token_err                        = 335544612;
  isc_union_err                        = 335544613;
  isc_dsql_construct_err               = 335544614;
  isc_field_aggregate_err              = 335544615;
  isc_field_ref_err                    = 335544616;
  isc_order_by_err                     = 335544617;
  isc_return_mode_err                  = 335544618;
  isc_extern_func_err                  = 335544619;
  isc_alias_conflict_err               = 335544620;
  isc_procedure_conflict_error         = 335544621;
  isc_relation_conflict_err            = 335544622;
  isc_dsql_domain_err                  = 335544623;
  isc_idx_seg_err                      = 335544624;
  isc_node_name_err                    = 335544625;
  isc_table_name                       = 335544626;
  isc_proc_name                        = 335544627;
  isc_idx_create_err                   = 335544628;
  isc_wal_shadow_err                   = 335544629;
  isc_dependency                       = 335544630;
  isc_idx_key_err                      = 335544631;
  isc_dsql_file_length_err             = 335544632;
  isc_dsql_shadow_number_err           = 335544633;
  isc_dsql_token_unk_err               = 335544634;
  isc_dsql_no_relation_alias           = 335544635;
  isc_indexname                        = 335544636;
  isc_no_stream_plan                   = 335544637;
  isc_stream_twice                     = 335544638;
  isc_stream_not_found                 = 335544639;
  isc_collation_requires_text          = 335544640;
  isc_dsql_domain_not_found            = 335544641;
  isc_index_unused                     = 335544642;
  isc_dsql_self_join                   = 335544643;
  isc_stream_bof                       = 335544644;
  isc_stream_crack                     = 335544645;
  isc_db_or_file_exists                = 335544646;
  isc_invalid_operator                 = 335544647;
  isc_conn_lost                        = 335544648;
  isc_bad_checksum                     = 335544649;
  isc_page_type_err                    = 335544650;
  isc_ext_readonly_err                 = 335544651;
  isc_sing_select_err                  = 335544652;
  isc_psw_attach                       = 335544653;
  isc_psw_start_trans                  = 335544654;
  isc_invalid_direction                = 335544655;
  isc_dsql_var_conflict                = 335544656;
  isc_dsql_no_blob_array               = 335544657;
  isc_dsql_base_table                  = 335544658;
  isc_duplicate_base_table             = 335544659;
  isc_view_alias                       = 335544660;
  isc_index_root_page_full             = 335544661;
  isc_dsql_blob_type_unknown           = 335544662;
  isc_req_max_clones_exceeded          = 335544663;
  isc_dsql_duplicate_spec              = 335544664;
  isc_unique_key_violation             = 335544665;
  isc_srvr_version_too_old             = 335544666;
  isc_drdb_completed_with_errs         = 335544667;
  isc_dsql_procedure_use_err           = 335544668;
  isc_dsql_count_mismatch              = 335544669;
  isc_blob_idx_err                     = 335544670;
  isc_array_idx_err                    = 335544671;
  isc_key_field_err                    = 335544672;
  isc_no_delete                        = 335544673;
  isc_del_last_field                   = 335544674;
  isc_sort_err                         = 335544675;
  isc_sort_mem_err                     = 335544676;
  isc_version_err                      = 335544677;
  isc_inval_key_posn                   = 335544678;
  isc_no_segments_err                  = 335544679;
  isc_crrp_data_err                    = 335544680;
  isc_rec_size_err                     = 335544681;
  isc_dsql_field_ref                   = 335544682;
  isc_req_depth_exceeded               = 335544683;
  isc_no_field_access                  = 335544684;
  isc_no_dbkey                         = 335544685;
  isc_jrn_format_err                   = 335544686;
  isc_jrn_file_full                    = 335544687;
  isc_dsql_open_cursor_request         = 335544688;
  isc_ib_error                         = 335544689;
  isc_cache_redef                      = 335544690;
  isc_cache_too_small                  = 335544691;
  isc_log_redef                        = 335544692;
  isc_log_too_small                    = 335544693;
  isc_partition_too_small              = 335544694;
  isc_partition_not_supp               = 335544695;
  isc_log_length_spec                  = 335544696;
  isc_precision_err                    = 335544697;
  isc_scale_nogt                       = 335544698;
  isc_expec_short                      = 335544699;
  isc_expec_long                       = 335544700;
  isc_expec_ushort                     = 335544701;
  isc_escape_invalid                   = 335544702;
  isc_svcnoexe                         = 335544703;
  isc_net_lookup_err                   = 335544704;
  isc_service_unknown                  = 335544705;
  isc_host_unknown                     = 335544706;
  isc_grant_nopriv_on_base             = 335544707;
  isc_dyn_fld_ambiguous                = 335544708;
  isc_dsql_agg_ref_err                 = 335544709;
  isc_complex_view                     = 335544710;
  isc_unprepared_stmt                  = 335544711;
  isc_expec_positive                   = 335544712;
  isc_dsql_sqlda_value_err             = 335544713;
  isc_invalid_array_id                 = 335544714;
  isc_extfile_uns_op                   = 335544715;
  isc_svc_in_use                       = 335544716;
  isc_err_stack_limit                  = 335544717;
  isc_invalid_key                      = 335544718;
  isc_net_init_error                   = 335544719;
  isc_loadlib_failure                  = 335544720;
  isc_network_error                    = 335544721;
  isc_net_connect_err                  = 335544722;
  isc_net_connect_listen_err           = 335544723;
  isc_net_event_connect_err            = 335544724;
  isc_net_event_listen_err             = 335544725;
  isc_net_read_err                     = 335544726;
  isc_net_write_err                    = 335544727;
  isc_integ_index_deactivate           = 335544728;
  isc_integ_deactivate_primary         = 335544729;
  isc_cse_not_supported                = 335544730;
  isc_tra_must_sweep                   = 335544731;
  isc_unsupported_network_drive        = 335544732;
  isc_io_create_err                    = 335544733;
  isc_io_open_err                      = 335544734;
  isc_io_close_err                     = 335544735;
  isc_io_read_err                      = 335544736;
  isc_io_write_err                     = 335544737;
  isc_io_delete_err                    = 335544738;
  isc_io_access_err                    = 335544739;
  isc_udf_exception                    = 335544740;
  isc_lost_db_connection               = 335544741;
  isc_no_write_user_priv               = 335544742;
  isc_token_too_long                   = 335544743;
  isc_max_att_exceeded                 = 335544744;
  isc_login_same_as_role_name          = 335544745;
  isc_reftable_requires_pk             = 335544746;
  isc_usrname_too_long                 = 335544747;
  isc_password_too_long                = 335544748;
  isc_usrname_required                 = 335544749;
  isc_password_required                = 335544750;
  isc_bad_protocol                     = 335544751;
  isc_dup_usrname_found                = 335544752;
  isc_usrname_not_found                = 335544753;
  isc_error_adding_sec_record          = 335544754;
  isc_error_modifying_sec_record       = 335544755;
  isc_error_deleting_sec_record        = 335544756;
  isc_error_updating_sec_db            = 335544757;
  isc_sort_rec_size_err                = 335544758;
  isc_bad_default_value                = 335544759;
  isc_invalid_clause                   = 335544760;
  isc_too_many_handles                 = 335544761;
  isc_optimizer_blk_exc                = 335544762;
  isc_invalid_string_constant          = 335544763;
  isc_transitional_date                = 335544764;
  isc_read_only_database               = 335544765;
  isc_must_be_dialect_2_and_up         = 335544766;
  isc_blob_filter_exception            = 335544767;
  isc_exception_access_violation       = 335544768;
  isc_exception_datatype_missalignment = 335544769;
  isc_exception_array_bounds_exceeded  = 335544770;
  isc_exception_float_denormal_operand = 335544771;
  isc_exception_float_divide_by_zero   = 335544772;
  isc_exception_float_inexact_result   = 335544773;
  isc_exception_float_invalid_operand  = 335544774;
  isc_exception_float_overflow         = 335544775;
  isc_exception_float_stack_check      = 335544776;
  isc_exception_float_underflow        = 335544777;
  isc_exception_integer_divide_by_zero = 335544778;
  isc_exception_integer_overflow       = 335544779;
  isc_exception_unknown                = 335544780;
  isc_exception_stack_overflow         = 335544781;
  isc_exception_sigsegv                = 335544782;
  isc_exception_sigill                 = 335544783;
  isc_exception_sigbus                 = 335544784;
  isc_exception_sigfpe                 = 335544785;
  isc_ext_file_delete                  = 335544786;
  isc_ext_file_modify                  = 335544787;
  isc_adm_task_denied                  = 335544788;
  isc_extract_input_mismatch           = 335544789;
  isc_insufficient_svc_privileges      = 335544790;
  isc_file_in_use                      = 335544791;
  isc_service_att_err                  = 335544792;
  isc_ddl_not_allowed_by_db_sql_dial   = 335544793;
  isc_cancelled                        = 335544794;
  isc_unexp_spb_form                   = 335544795;
  isc_sql_dialect_datatype_unsupport   = 335544796;
  isc_svcnouser                        = 335544797;
  isc_depend_on_uncommitted_rel        = 335544798;
  isc_svc_name_missing                 = 335544799;
  isc_too_many_contexts                = 335544800;
  isc_datype_notsup                    = 335544801;
  isc_dialect_reset_warning            = 335544802;
  isc_dialect_not_changed              = 335544803;
  isc_database_create_failed           = 335544804;
  isc_inv_dialect_specified            = 335544805;
  isc_valid_db_dialects                = 335544806;
  isc_sqlwarn                          = 335544807;
  isc_dtype_renamed                    = 335544808;
  isc_extern_func_dir_error            = 335544809;
  isc_date_range_exceeded              = 335544810;
  isc_inv_client_dialect_specified     = 335544811;
  isc_valid_client_dialects            = 335544812;
  isc_optimizer_between_err            = 335544813;
  isc_service_not_supported            = 335544814;
  isc_generator_name                   = 335544815;
  isc_udf_name                         = 335544816;
  isc_bad_limit_param                  = 335544817;
  isc_bad_skip_param                   = 335544818;
  isc_io_32bit_exceeded_err            = 335544819;
  isc_invalid_savepoint                = 335544820;
  isc_dsql_column_pos_err              = 335544821;
  isc_dsql_agg_where_err               = 335544822;
  isc_dsql_agg_group_err               = 335544823;
  isc_dsql_agg_column_err              = 335544824;
  isc_dsql_agg_having_err              = 335544825;
  isc_dsql_agg_nested_err              = 335544826;
  isc_exec_sql_invalid_arg             = 335544827;
  isc_exec_sql_invalid_req             = 335544828;
  isc_exec_sql_invalid_var             = 335544829;
  isc_exec_sql_max_call_exceeded       = 335544830;
  isc_conf_access_denied               = 335544831;
  isc_wrong_backup_state               = 335544832;
  isc_wal_backup_err                   = 335544833;
  isc_cursor_not_open                  = 335544834;
  isc_bad_shutdown_mode                = 335544835;
  isc_concat_overflow                  = 335544836;
  isc_bad_substring_offset             = 335544837;
  isc_foreign_key_target_doesnt_exist  = 335544838;
  isc_foreign_key_references_present   = 335544839;
  isc_no_update                        = 335544840;
  isc_cursor_already_open              = 335544841;
  isc_stack_trace                      = 335544842;
  isc_ctx_var_not_found                = 335544843;
  isc_ctx_namespace_invalid            = 335544844;
  isc_ctx_too_big                      = 335544845;
  isc_ctx_bad_argument                 = 335544846;
  isc_identifier_too_long              = 335544847;
  isc_except2                          = 335544848;
  isc_malformed_string                 = 335544849;
  isc_prc_out_param_mismatch           = 335544850;
  isc_command_end_err2                 = 335544851;
  isc_partner_idx_incompat_type        = 335544852;
  isc_bad_substring_length             = 335544853;
  isc_charset_not_installed            = 335544854;
  isc_collation_not_installed          = 335544855;
  isc_att_shutdown                     = 335544856;
  isc_blobtoobig                       = 335544857;
  isc_must_have_phys_field             = 335544858;
  isc_invalid_time_precision           = 335544859;
  isc_blob_convert_error               = 335544860;
  isc_array_convert_error              = 335544861;
  isc_record_lock_not_supp             = 335544862;
  isc_partner_idx_not_found            = 335544863;
  isc_tra_num_exc                      = 335544864;
  isc_field_disappeared                = 335544865;
  isc_met_wrong_gtt_scope              = 335544866;
  isc_subtype_for_internal_use         = 335544867;
  isc_illegal_prc_type                 = 335544868;
  isc_invalid_sort_datatype            = 335544869;
  isc_collation_name                   = 335544870;
  isc_domain_name                      = 335544871;
  isc_domnotdef                        = 335544872;
  isc_array_max_dimensions             = 335544873;
  isc_max_db_per_trans_allowed         = 335544874;
  isc_bad_debug_format                 = 335544875;
  isc_bad_proc_BLR                     = 335544876;
  isc_key_too_big                      = 335544877;
  isc_concurrent_transaction           = 335544878;
  isc_not_valid_for_var                = 335544879;
  isc_not_valid_for                    = 335544880;
  isc_need_difference                  = 335544881;
  isc_long_login                       = 335544882;
  isc_fldnotdef2                       = 335544883;
  isc_invalid_similar_pattern          = 335544884;
  isc_bad_teb_form                     = 335544885;
  isc_tpb_multiple_txn_isolation       = 335544886;
  isc_tpb_reserv_before_table          = 335544887;
  isc_tpb_multiple_spec                = 335544888;
  isc_tpb_option_without_rc            = 335544889;
  isc_tpb_conflicting_options          = 335544890;
  isc_tpb_reserv_missing_tlen          = 335544891;
  isc_tpb_reserv_long_tlen             = 335544892;
  isc_tpb_reserv_missing_tname         = 335544893;
  isc_tpb_reserv_corrup_tlen           = 335544894;
  isc_tpb_reserv_null_tlen             = 335544895;
  isc_tpb_reserv_relnotfound           = 335544896;
  isc_tpb_reserv_baserelnotfound       = 335544897;
  isc_tpb_missing_len                  = 335544898;
  isc_tpb_missing_value                = 335544899;
  isc_tpb_corrupt_len                  = 335544900;
  isc_tpb_null_len                     = 335544901;
  isc_tpb_overflow_len                 = 335544902;
  isc_tpb_invalid_value                = 335544903;
  isc_tpb_reserv_stronger_wng          = 335544904;
  isc_tpb_reserv_stronger              = 335544905;
  isc_tpb_reserv_max_recursion         = 335544906;
  isc_tpb_reserv_virtualtbl            = 335544907;
  isc_tpb_reserv_systbl                = 335544908;
  isc_tpb_reserv_temptbl               = 335544909;
  isc_tpb_readtxn_after_writelock      = 335544910;
  isc_tpb_writelock_after_readtxn      = 335544911;
  isc_time_range_exceeded              = 335544912;
  isc_datetime_range_exceeded          = 335544913;
  isc_string_truncation                = 335544914;
  isc_blob_truncation                  = 335544915;
  isc_numeric_out_of_range             = 335544916;
  isc_shutdown_timeout                 = 335544917;
  isc_att_handle_busy                  = 335544918;
  isc_bad_udf_freeit                   = 335544919;
  isc_eds_provider_not_found           = 335544920;
  isc_eds_connection                   = 335544921;
  isc_eds_preprocess                   = 335544922;
  isc_eds_stmt_expected                = 335544923;
  isc_eds_prm_name_expected            = 335544924;
  isc_eds_unclosed_comment             = 335544925;
  isc_eds_statement                    = 335544926;
  isc_eds_input_prm_mismatch           = 335544927;
  isc_eds_output_prm_mismatch          = 335544928;
  isc_eds_input_prm_not_set            = 335544929;
  isc_too_big_blr                      = 335544930;
  isc_montabexh                        = 335544931;
  isc_modnotfound                      = 335544932;
  isc_nothing_to_cancel                = 335544933;
  isc_ibutil_not_loaded                = 335544934;
  isc_circular_computed                = 335544935;
  isc_psw_db_error                     = 335544936;
  isc_invalid_type_datetime_op         = 335544937;
  isc_onlycan_add_timetodate           = 335544938;
  isc_onlycan_add_datetotime           = 335544939;
  isc_onlycansub_tstampfromtstamp      = 335544940;
  isc_onlyoneop_mustbe_tstamp          = 335544941;
  isc_invalid_extractpart_time         = 335544942;
  isc_invalid_extractpart_date         = 335544943;
  isc_invalidarg_extract               = 335544944;
  isc_sysf_argmustbe_exact             = 335544945;
  isc_sysf_argmustbe_exact_or_fp       = 335544946;
  isc_sysf_argviolates_uuidtype        = 335544947;
  isc_sysf_argviolates_uuidlen         = 335544948;
  isc_sysf_argviolates_uuidfmt         = 335544949;
  isc_sysf_argviolates_guidigits       = 335544950;
  isc_sysf_invalid_addpart_time        = 335544951;
  isc_sysf_invalid_add_datetime        = 335544952;
  isc_sysf_invalid_addpart_dtime       = 335544953;
  isc_sysf_invalid_add_dtime_rc        = 335544954;
  isc_sysf_invalid_diff_dtime          = 335544955;
  isc_sysf_invalid_timediff            = 335544956;
  isc_sysf_invalid_tstamptimediff      = 335544957;
  isc_sysf_invalid_datetimediff        = 335544958;
  isc_sysf_invalid_diffpart            = 335544959;
  isc_sysf_argmustbe_positive          = 335544960;
  isc_sysf_basemustbe_positive         = 335544961;
  isc_sysf_argnmustbe_nonneg           = 335544962;
  isc_sysf_argnmustbe_positive         = 335544963;
  isc_sysf_invalid_zeropowneg          = 335544964;
  isc_sysf_invalid_negpowfp            = 335544965;
  isc_sysf_invalid_scale               = 335544966;
  isc_sysf_argmustbe_nonneg            = 335544967;
  isc_sysf_binuuid_mustbe_str          = 335544968;
  isc_sysf_binuuid_wrongsize           = 335544969;
  isc_missing_required_spb             = 335544970;
  isc_net_server_shutdown              = 335544971;
  isc_bad_conn_str                     = 335544972;
  isc_bad_epb_form                     = 335544973;
  isc_no_threads                       = 335544974;
  isc_net_event_connect_timeout        = 335544975;
  isc_sysf_argmustbe_nonzero           = 335544976;
  isc_sysf_argmustbe_range_inc1_1      = 335544977;
  isc_sysf_argmustbe_gteq_one          = 335544978;
  isc_sysf_argmustbe_range_exc1_1      = 335544979;
  isc_internal_rejected_params         = 335544980;
  isc_sysf_fp_overflow                 = 335544981;
  isc_udf_fp_overflow                  = 335544982;
  isc_udf_fp_nan                       = 335544983;
  isc_instance_conflict                = 335544984;
  isc_out_of_temp_space                = 335544985;
  isc_eds_expl_tran_ctrl               = 335544986;
  isc_no_trusted_spb                   = 335544987;
  isc_package_name                     = 335544988;
  isc_cannot_make_not_null             = 335544989;
  isc_feature_removed                  = 335544990;
  isc_view_name                        = 335544991;
  isc_lock_dir_access                  = 335544992;
  isc_invalid_fetch_option             = 335544993;
  isc_bad_fun_BLR                      = 335544994;
  isc_func_pack_not_implemented        = 335544995;
  isc_proc_pack_not_implemented        = 335544996;
  isc_eem_func_not_returned            = 335544997;
  isc_eem_proc_not_returned            = 335544998;
  isc_eem_trig_not_returned            = 335544999;
  isc_eem_bad_plugin_ver               = 335545000;
  isc_eem_engine_notfound              = 335545001;
  isc_attachment_in_use                = 335545002;
  isc_transaction_in_use               = 335545003;
  isc_pman_cannot_load_plugin          = 335545004;
  isc_pman_module_notfound             = 335545005;
  isc_pman_entrypoint_notfound         = 335545006;
  isc_pman_module_bad                  = 335545007;
  isc_pman_plugin_notfound             = 335545008;
  isc_sysf_invalid_trig_namespace      = 335545009;
  isc_unexpected_null                  = 335545010;
  isc_type_notcompat_blob              = 335545011;
  isc_invalid_date_val                 = 335545012;
  isc_invalid_time_val                 = 335545013;
  isc_invalid_timestamp_val            = 335545014;
  isc_invalid_index_val                = 335545015;
  isc_formatted_exception              = 335545016;
  isc_async_active                     = 335545017;
  isc_private_function                 = 335545018;
  isc_private_procedure                = 335545019;
  isc_request_outdated                 = 335545020;
  isc_bad_events_handle                = 335545021;
  isc_cannot_copy_stmt                 = 335545022;
  isc_invalid_boolean_usage            = 335545023;
  isc_sysf_argscant_both_be_zero       = 335545024;
  isc_spb_no_id                        = 335545025;
  isc_ee_blr_mismatch_null             = 335545026;
  isc_ee_blr_mismatch_length           = 335545027;
  isc_ss_out_of_bounds                 = 335545028;
  isc_missing_data_structures          = 335545029;
  isc_protect_sys_tab                  = 335545030;
  isc_libtommath_generic               = 335545031;
  isc_wroblrver2                       = 335545032;
  isc_trunc_limits                     = 335545033;
  isc_info_access                      = 335545034;
  isc_svc_no_stdin                     = 335545035;
  isc_svc_start_failed                 = 335545036;
  isc_svc_no_switches                  = 335545037;
  isc_svc_bad_size                     = 335545038;
  isc_no_crypt_plugin                  = 335545039;
  isc_cp_name_too_long                 = 335545040;
  isc_cp_process_active                = 335545041;
  isc_cp_already_crypted               = 335545042;
  isc_decrypt_error                    = 335545043;
  isc_no_providers                     = 335545044;
  isc_null_spb                         = 335545045;
  isc_max_args_exceeded                = 335545046;
  isc_ee_blr_mismatch_names_count      = 335545047;
  isc_ee_blr_mismatch_name_not_found   = 335545048;
  isc_bad_result_set                   = 335545049;
  isc_wrong_message_length             = 335545050;
  isc_no_output_format                 = 335545051;
  isc_item_finish                      = 335545052;
  isc_miss_config                      = 335545053;
  isc_conf_line                        = 335545054;
  isc_conf_include                     = 335545055;
  isc_include_depth                    = 335545056;
  isc_include_miss                     = 335545057;
  isc_protect_ownership                = 335545058;
  isc_badvarnum                        = 335545059;
  isc_sec_context                      = 335545060;
  isc_multi_segment                    = 335545061;
  isc_login_changed                    = 335545062;
  isc_auth_handshake_limit             = 335545063;
  isc_wirecrypt_incompatible           = 335545064;
  isc_miss_wirecrypt                   = 335545065;
  isc_wirecrypt_key                    = 335545066;
  isc_wirecrypt_plugin                 = 335545067;
  isc_secdb_name                       = 335545068;
  isc_auth_data                        = 335545069;
  isc_auth_datalength                  = 335545070;
  isc_info_unprepared_stmt             = 335545071;
  isc_idx_key_value                    = 335545072;
  isc_forupdate_virtualtbl             = 335545073;
  isc_forupdate_systbl                 = 335545074;
  isc_forupdate_temptbl                = 335545075;
  isc_cant_modify_sysobj               = 335545076;
  isc_server_misconfigured             = 335545077;
  isc_alter_role                       = 335545078;
  isc_map_already_exists               = 335545079;
  isc_map_not_exists                   = 335545080;
  isc_map_load                         = 335545081;
  isc_map_aster                        = 335545082;
  isc_map_multi                        = 335545083;
  isc_map_undefined                    = 335545084;
  isc_baddpb_damaged_mode              = 335545085;
  isc_baddpb_buffers_range             = 335545086;
  isc_baddpb_temp_buffers              = 335545087;
  isc_map_nodb                         = 335545088;
  isc_map_notable                      = 335545089;
  isc_miss_trusted_role                = 335545090;
  isc_set_invalid_role                 = 335545091;
  isc_cursor_not_positioned            = 335545092;
  isc_dup_attribute                    = 335545093;
  isc_dyn_no_priv                      = 335545094;
  isc_dsql_cant_grant_option           = 335545095;
  isc_read_conflict                    = 335545096;
  isc_crdb_load                        = 335545097;
  isc_crdb_nodb                        = 335545098;
  isc_crdb_notable                     = 335545099;
  isc_interface_version_too_old        = 335545100;
  isc_fun_param_mismatch               = 335545101;
  isc_savepoint_backout_err            = 335545102;
  isc_domain_primary_key_notnull       = 335545103;
  isc_invalid_attachment_charset       = 335545104;
  isc_map_down                         = 335545105;
  isc_login_error                      = 335545106;
  isc_already_opened                   = 335545107;
  isc_bad_crypt_key                    = 335545108;
  isc_encrypt_error                    = 335545109;
  isc_gfix_db_name                     = 335740929;
  isc_gfix_invalid_sw                  = 335740930;
  isc_gfix_incmp_sw                    = 335740932;
  isc_gfix_replay_req                  = 335740933;
  isc_gfix_pgbuf_req                   = 335740934;
  isc_gfix_val_req                     = 335740935;
  isc_gfix_pval_req                    = 335740936;
  isc_gfix_trn_req                     = 335740937;
  isc_gfix_full_req                    = 335740940;
  isc_gfix_usrname_req                 = 335740941;
  isc_gfix_pass_req                    = 335740942;
  isc_gfix_subs_name                   = 335740943;
  isc_gfix_wal_req                     = 335740944;
  isc_gfix_sec_req                     = 335740945;
  isc_gfix_nval_req                    = 335740946;
  isc_gfix_type_shut                   = 335740947;
  isc_gfix_retry                       = 335740948;
  isc_gfix_retry_db                    = 335740951;
  isc_gfix_exceed_max                  = 335740991;
  isc_gfix_corrupt_pool                = 335740992;
  isc_gfix_mem_exhausted               = 335740993;
  isc_gfix_bad_pool                    = 335740994;
  isc_gfix_trn_not_valid               = 335740995;
  isc_gfix_unexp_eoi                   = 335741012;
  isc_gfix_recon_fail                  = 335741018;
  isc_gfix_trn_unknown                 = 335741036;
  isc_gfix_mode_req                    = 335741038;
  isc_gfix_pzval_req                   = 335741042;
  isc_dsql_dbkey_from_non_table        = 336003074;
  isc_dsql_transitional_numeric        = 336003075;
  isc_dsql_dialect_warning_expr        = 336003076;
  isc_sql_db_dialect_dtype_unsupport   = 336003077;
  isc_sql_dialect_conflict_num         = 336003079;
  isc_dsql_warning_number_ambiguous    = 336003080;
  isc_dsql_warning_number_ambiguous1   = 336003081;
  isc_dsql_warn_precision_ambiguous    = 336003082;
  isc_dsql_warn_precision_ambiguous1   = 336003083;
  isc_dsql_warn_precision_ambiguous2   = 336003084;
  isc_dsql_ambiguous_field_name        = 336003085;
  isc_dsql_udf_return_pos_err          = 336003086;
  isc_dsql_invalid_label               = 336003087;
  isc_dsql_datatypes_not_comparable    = 336003088;
  isc_dsql_cursor_invalid              = 336003089;
  isc_dsql_cursor_redefined            = 336003090;
  isc_dsql_cursor_not_found            = 336003091;
  isc_dsql_cursor_exists               = 336003092;
  isc_dsql_cursor_rel_ambiguous        = 336003093;
  isc_dsql_cursor_rel_not_found        = 336003094;
  isc_dsql_cursor_not_open             = 336003095;
  isc_dsql_type_not_supp_ext_tab       = 336003096;
  isc_dsql_feature_not_supported_ods   = 336003097;
  isc_primary_key_required             = 336003098;
  isc_upd_ins_doesnt_match_pk          = 336003099;
  isc_upd_ins_doesnt_match_matching    = 336003100;
  isc_upd_ins_with_complex_view        = 336003101;
  isc_dsql_incompatible_trigger_type   = 336003102;
  isc_dsql_db_trigger_type_cant_change = 336003103;
  isc_dsql_record_version_table        = 336003104;
  isc_dsql_invalid_sqlda_version       = 336003105;
  isc_dsql_sqlvar_index                = 336003106;
  isc_dsql_no_sqlind                   = 336003107;
  isc_dsql_no_sqldata                  = 336003108;
  isc_dsql_no_input_sqlda              = 336003109;
  isc_dsql_no_output_sqlda             = 336003110;
  isc_dsql_wrong_param_num             = 336003111;
  isc_dyn_filter_not_found             = 336068645;
  isc_dyn_func_not_found               = 336068649;
  isc_dyn_index_not_found              = 336068656;
  isc_dyn_view_not_found               = 336068662;
  isc_dyn_domain_not_found             = 336068697;
  isc_dyn_cant_modify_auto_trig        = 336068717;
  isc_dyn_dup_table                    = 336068740;
  isc_dyn_proc_not_found               = 336068748;
  isc_dyn_exception_not_found          = 336068752;
  isc_dyn_proc_param_not_found         = 336068754;
  isc_dyn_trig_not_found               = 336068755;
  isc_dyn_charset_not_found            = 336068759;
  isc_dyn_collation_not_found          = 336068760;
  isc_dyn_role_not_found               = 336068763;
  isc_dyn_name_longer                  = 336068767;
  isc_dyn_column_does_not_exist        = 336068784;
  isc_dyn_role_does_not_exist          = 336068796;
  isc_dyn_no_grant_admin_opt           = 336068797;
  isc_dyn_user_not_role_member         = 336068798;
  isc_dyn_delete_role_failed           = 336068799;
  isc_dyn_grant_role_to_user           = 336068800;
  isc_dyn_inv_sql_role_name            = 336068801;
  isc_dyn_dup_sql_role                 = 336068802;
  isc_dyn_kywd_spec_for_role           = 336068803;
  isc_dyn_roles_not_supported          = 336068804;
  isc_dyn_domain_name_exists           = 336068812;
  isc_dyn_field_name_exists            = 336068813;
  isc_dyn_dependency_exists            = 336068814;
  isc_dyn_dtype_invalid                = 336068815;
  isc_dyn_char_fld_too_small           = 336068816;
  isc_dyn_invalid_dtype_conversion     = 336068817;
  isc_dyn_dtype_conv_invalid           = 336068818;
  isc_dyn_zero_len_id                  = 336068820;
  isc_dyn_gen_not_found                = 336068822;
  isc_max_coll_per_charset             = 336068829;
  isc_invalid_coll_attr                = 336068830;
  isc_dyn_wrong_gtt_scope              = 336068840;
  isc_dyn_coll_used_table              = 336068843;
  isc_dyn_coll_used_domain             = 336068844;
  isc_dyn_cannot_del_syscoll           = 336068845;
  isc_dyn_cannot_del_def_coll          = 336068846;
  isc_dyn_table_not_found              = 336068849;
  isc_dyn_coll_used_procedure          = 336068851;
  isc_dyn_scale_too_big                = 336068852;
  isc_dyn_precision_too_small          = 336068853;
  isc_dyn_miss_priv_warning            = 336068855;
  isc_dyn_ods_not_supp_feature         = 336068856;
  isc_dyn_cannot_addrem_computed       = 336068857;
  isc_dyn_no_empty_pw                  = 336068858;
  isc_dyn_dup_index                    = 336068859;
  isc_dyn_package_not_found            = 336068864;
  isc_dyn_schema_not_found             = 336068865;
  isc_dyn_cannot_mod_sysproc           = 336068866;
  isc_dyn_cannot_mod_systrig           = 336068867;
  isc_dyn_cannot_mod_sysfunc           = 336068868;
  isc_dyn_invalid_ddl_proc             = 336068869;
  isc_dyn_invalid_ddl_trig             = 336068870;
  isc_dyn_funcnotdef_package           = 336068871;
  isc_dyn_procnotdef_package           = 336068872;
  isc_dyn_funcsignat_package           = 336068873;
  isc_dyn_procsignat_package           = 336068874;
  isc_dyn_defvaldecl_package_proc      = 336068875;
  isc_dyn_package_body_exists          = 336068877;
  isc_dyn_invalid_ddl_func             = 336068878;
  isc_dyn_newfc_oldsyntax              = 336068879;
  isc_dyn_func_param_not_found         = 336068886;
  isc_dyn_routine_param_not_found      = 336068887;
  isc_dyn_routine_param_ambiguous      = 336068888;
  isc_dyn_coll_used_function           = 336068889;
  isc_dyn_domain_used_function         = 336068890;
  isc_dyn_alter_user_no_clause         = 336068891;
  isc_dyn_duplicate_package_item       = 336068894;
  isc_dyn_cant_modify_sysobj           = 336068895;
  isc_dyn_cant_use_zero_increment      = 336068896;
  isc_dyn_cant_use_in_foreignkey       = 336068897;
  isc_dyn_defvaldecl_package_func      = 336068898;
  isc_gbak_unknown_switch              = 336330753;
  isc_gbak_page_size_missing           = 336330754;
  isc_gbak_page_size_toobig            = 336330755;
  isc_gbak_redir_ouput_missing         = 336330756;
  isc_gbak_switches_conflict           = 336330757;
  isc_gbak_unknown_device              = 336330758;
  isc_gbak_no_protection               = 336330759;
  isc_gbak_page_size_not_allowed       = 336330760;
  isc_gbak_multi_source_dest           = 336330761;
  isc_gbak_filename_missing            = 336330762;
  isc_gbak_dup_inout_names             = 336330763;
  isc_gbak_inv_page_size               = 336330764;
  isc_gbak_db_specified                = 336330765;
  isc_gbak_db_exists                   = 336330766;
  isc_gbak_unk_device                  = 336330767;
  isc_gbak_blob_info_failed            = 336330772;
  isc_gbak_unk_blob_item               = 336330773;
  isc_gbak_get_seg_failed              = 336330774;
  isc_gbak_close_blob_failed           = 336330775;
  isc_gbak_open_blob_failed            = 336330776;
  isc_gbak_put_blr_gen_id_failed       = 336330777;
  isc_gbak_unk_type                    = 336330778;
  isc_gbak_comp_req_failed             = 336330779;
  isc_gbak_start_req_failed            = 336330780;
  isc_gbak_rec_failed                  = 336330781;
  isc_gbak_rel_req_failed              = 336330782;
  isc_gbak_db_info_failed              = 336330783;
  isc_gbak_no_db_desc                  = 336330784;
  isc_gbak_db_create_failed            = 336330785;
  isc_gbak_decomp_len_error            = 336330786;
  isc_gbak_tbl_missing                 = 336330787;
  isc_gbak_blob_col_missing            = 336330788;
  isc_gbak_create_blob_failed          = 336330789;
  isc_gbak_put_seg_failed              = 336330790;
  isc_gbak_rec_len_exp                 = 336330791;
  isc_gbak_inv_rec_len                 = 336330792;
  isc_gbak_exp_data_type               = 336330793;
  isc_gbak_gen_id_failed               = 336330794;
  isc_gbak_unk_rec_type                = 336330795;
  isc_gbak_inv_bkup_ver                = 336330796;
  isc_gbak_missing_bkup_desc           = 336330797;
  isc_gbak_string_trunc                = 336330798;
  isc_gbak_cant_rest_record            = 336330799;
  isc_gbak_send_failed                 = 336330800;
  isc_gbak_no_tbl_name                 = 336330801;
  isc_gbak_unexp_eof                   = 336330802;
  isc_gbak_db_format_too_old           = 336330803;
  isc_gbak_inv_array_dim               = 336330804;
  isc_gbak_xdr_len_expected            = 336330807;
  isc_gbak_open_bkup_error             = 336330817;
  isc_gbak_open_error                  = 336330818;
  isc_gbak_missing_block_fac           = 336330934;
  isc_gbak_inv_block_fac               = 336330935;
  isc_gbak_block_fac_specified         = 336330936;
  isc_gbak_missing_username            = 336330940;
  isc_gbak_missing_password            = 336330941;
  isc_gbak_missing_skipped_bytes       = 336330952;
  isc_gbak_inv_skipped_bytes           = 336330953;
  isc_gbak_err_restore_charset         = 336330965;
  isc_gbak_err_restore_collation       = 336330967;
  isc_gbak_read_error                  = 336330972;
  isc_gbak_write_error                 = 336330973;
  isc_gbak_db_in_use                   = 336330985;
  isc_gbak_sysmemex                    = 336330990;
  isc_gbak_restore_role_failed         = 336331002;
  isc_gbak_role_op_missing             = 336331005;
  isc_gbak_page_buffers_missing        = 336331010;
  isc_gbak_page_buffers_wrong_param    = 336331011;
  isc_gbak_page_buffers_restore        = 336331012;
  isc_gbak_inv_size                    = 336331014;
  isc_gbak_file_outof_sequence         = 336331015;
  isc_gbak_join_file_missing           = 336331016;
  isc_gbak_stdin_not_supptd            = 336331017;
  isc_gbak_stdout_not_supptd           = 336331018;
  isc_gbak_bkup_corrupt                = 336331019;
  isc_gbak_unk_db_file_spec            = 336331020;
  isc_gbak_hdr_write_failed            = 336331021;
  isc_gbak_disk_space_ex               = 336331022;
  isc_gbak_size_lt_min                 = 336331023;
  isc_gbak_svc_name_missing            = 336331025;
  isc_gbak_not_ownr                    = 336331026;
  isc_gbak_mode_req                    = 336331031;
  isc_gbak_just_data                   = 336331033;
  isc_gbak_data_only                   = 336331034;
  isc_gbak_missing_interval            = 336331078;
  isc_gbak_wrong_interval              = 336331079;
  isc_gbak_verify_verbint              = 336331081;
  isc_gbak_option_only_restore         = 336331082;
  isc_gbak_option_only_backup          = 336331083;
  isc_gbak_option_conflict             = 336331084;
  isc_gbak_param_conflict              = 336331085;
  isc_gbak_option_repeated             = 336331086;
  isc_gbak_max_dbkey_recursion         = 336331091;
  isc_gbak_max_dbkey_length            = 336331092;
  isc_gbak_invalid_metadata            = 336331093;
  isc_gbak_invalid_data                = 336331094;
  isc_gbak_inv_bkup_ver2               = 336331096;
  isc_gbak_db_format_too_old2          = 336331100;
  isc_dsql_too_old_ods                 = 336397205;
  isc_dsql_table_not_found             = 336397206;
  isc_dsql_view_not_found              = 336397207;
  isc_dsql_line_col_error              = 336397208;
  isc_dsql_unknown_pos                 = 336397209;
  isc_dsql_no_dup_name                 = 336397210;
  isc_dsql_too_many_values             = 336397211;
  isc_dsql_no_array_computed           = 336397212;
  isc_dsql_implicit_domain_name        = 336397213;
  isc_dsql_only_can_subscript_array    = 336397214;
  isc_dsql_max_sort_items              = 336397215;
  isc_dsql_max_group_items             = 336397216;
  isc_dsql_conflicting_sort_field      = 336397217;
  isc_dsql_derived_table_more_columns  = 336397218;
  isc_dsql_derived_table_less_columns  = 336397219;
  isc_dsql_derived_field_unnamed       = 336397220;
  isc_dsql_derived_field_dup_name      = 336397221;
  isc_dsql_derived_alias_select        = 336397222;
  isc_dsql_derived_alias_field         = 336397223;
  isc_dsql_auto_field_bad_pos          = 336397224;
  isc_dsql_cte_wrong_reference         = 336397225;
  isc_dsql_cte_cycle                   = 336397226;
  isc_dsql_cte_outer_join              = 336397227;
  isc_dsql_cte_mult_references         = 336397228;
  isc_dsql_cte_not_a_union             = 336397229;
  isc_dsql_cte_nonrecurs_after_recurs  = 336397230;
  isc_dsql_cte_wrong_clause            = 336397231;
  isc_dsql_cte_union_all               = 336397232;
  isc_dsql_cte_miss_nonrecursive       = 336397233;
  isc_dsql_cte_nested_with             = 336397234;
  isc_dsql_col_more_than_once_using    = 336397235;
  isc_dsql_unsupp_feature_dialect      = 336397236;
  isc_dsql_cte_not_used                = 336397237;
  isc_dsql_col_more_than_once_view     = 336397238;
  isc_dsql_unsupported_in_auto_trans   = 336397239;
  isc_dsql_eval_unknode                = 336397240;
  isc_dsql_agg_wrongarg                = 336397241;
  isc_dsql_agg2_wrongarg               = 336397242;
  isc_dsql_nodateortime_pm_string      = 336397243;
  isc_dsql_invalid_datetime_subtract   = 336397244;
  isc_dsql_invalid_dateortime_add      = 336397245;
  isc_dsql_invalid_type_minus_date     = 336397246;
  isc_dsql_nostring_addsub_dial3       = 336397247;
  isc_dsql_invalid_type_addsub_dial3   = 336397248;
  isc_dsql_invalid_type_multip_dial1   = 336397249;
  isc_dsql_nostring_multip_dial3       = 336397250;
  isc_dsql_invalid_type_multip_dial3   = 336397251;
  isc_dsql_mustuse_numeric_div_dial1   = 336397252;
  isc_dsql_nostring_div_dial3          = 336397253;
  isc_dsql_invalid_type_div_dial3      = 336397254;
  isc_dsql_nostring_neg_dial3          = 336397255;
  isc_dsql_invalid_type_neg            = 336397256;
  isc_dsql_max_distinct_items          = 336397257;
  isc_dsql_alter_charset_failed        = 336397258;
  isc_dsql_comment_on_failed           = 336397259;
  isc_dsql_create_func_failed          = 336397260;
  isc_dsql_alter_func_failed           = 336397261;
  isc_dsql_create_alter_func_failed    = 336397262;
  isc_dsql_drop_func_failed            = 336397263;
  isc_dsql_recreate_func_failed        = 336397264;
  isc_dsql_create_proc_failed          = 336397265;
  isc_dsql_alter_proc_failed           = 336397266;
  isc_dsql_create_alter_proc_failed    = 336397267;
  isc_dsql_drop_proc_failed            = 336397268;
  isc_dsql_recreate_proc_failed        = 336397269;
  isc_dsql_create_trigger_failed       = 336397270;
  isc_dsql_alter_trigger_failed        = 336397271;
  isc_dsql_create_alter_trigger_failed = 336397272;
  isc_dsql_drop_trigger_failed         = 336397273;
  isc_dsql_recreate_trigger_failed     = 336397274;
  isc_dsql_create_collation_failed     = 336397275;
  isc_dsql_drop_collation_failed       = 336397276;
  isc_dsql_create_domain_failed        = 336397277;
  isc_dsql_alter_domain_failed         = 336397278;
  isc_dsql_drop_domain_failed          = 336397279;
  isc_dsql_create_except_failed        = 336397280;
  isc_dsql_alter_except_failed         = 336397281;
  isc_dsql_create_alter_except_failed  = 336397282;
  isc_dsql_recreate_except_failed      = 336397283;
  isc_dsql_drop_except_failed          = 336397284;
  isc_dsql_create_sequence_failed      = 336397285;
  isc_dsql_create_table_failed         = 336397286;
  isc_dsql_alter_table_failed          = 336397287;
  isc_dsql_drop_table_failed           = 336397288;
  isc_dsql_recreate_table_failed       = 336397289;
  isc_dsql_create_pack_failed          = 336397290;
  isc_dsql_alter_pack_failed           = 336397291;
  isc_dsql_create_alter_pack_failed    = 336397292;
  isc_dsql_drop_pack_failed            = 336397293;
  isc_dsql_recreate_pack_failed        = 336397294;
  isc_dsql_create_pack_body_failed     = 336397295;
  isc_dsql_drop_pack_body_failed       = 336397296;
  isc_dsql_recreate_pack_body_failed   = 336397297;
  isc_dsql_create_view_failed          = 336397298;
  isc_dsql_alter_view_failed           = 336397299;
  isc_dsql_create_alter_view_failed    = 336397300;
  isc_dsql_recreate_view_failed        = 336397301;
  isc_dsql_drop_view_failed            = 336397302;
  isc_dsql_drop_sequence_failed        = 336397303;
  isc_dsql_recreate_sequence_failed    = 336397304;
  isc_dsql_drop_index_failed           = 336397305;
  isc_dsql_drop_filter_failed          = 336397306;
  isc_dsql_drop_shadow_failed          = 336397307;
  isc_dsql_drop_role_failed            = 336397308;
  isc_dsql_drop_user_failed            = 336397309;
  isc_dsql_create_role_failed          = 336397310;
  isc_dsql_alter_role_failed           = 336397311;
  isc_dsql_alter_index_failed          = 336397312;
  isc_dsql_alter_database_failed       = 336397313;
  isc_dsql_create_shadow_failed        = 336397314;
  isc_dsql_create_filter_failed        = 336397315;
  isc_dsql_create_index_failed         = 336397316;
  isc_dsql_create_user_failed          = 336397317;
  isc_dsql_alter_user_failed           = 336397318;
  isc_dsql_grant_failed                = 336397319;
  isc_dsql_revoke_failed               = 336397320;
  isc_dsql_cte_recursive_aggregate     = 336397321;
  isc_dsql_mapping_failed              = 336397322;
  isc_dsql_alter_sequence_failed       = 336397323;
  isc_dsql_create_generator_failed     = 336397324;
  isc_dsql_set_generator_failed        = 336397325;
  isc_dsql_wlock_simple                = 336397326;
  isc_dsql_firstskip_rows              = 336397327;
  isc_dsql_wlock_aggregates            = 336397328;
  isc_dsql_wlock_conflict              = 336397329;
  isc_dsql_max_exception_arguments     = 336397330;
  isc_dsql_string_byte_length          = 336397331;
  isc_dsql_string_char_length          = 336397332;
  isc_dsql_max_nesting                 = 336397333;
  isc_gsec_cant_open_db                = 336723983;
  isc_gsec_switches_error              = 336723984;
  isc_gsec_no_op_spec                  = 336723985;
  isc_gsec_no_usr_name                 = 336723986;
  isc_gsec_err_add                     = 336723987;
  isc_gsec_err_modify                  = 336723988;
  isc_gsec_err_find_mod                = 336723989;
  isc_gsec_err_rec_not_found           = 336723990;
  isc_gsec_err_delete                  = 336723991;
  isc_gsec_err_find_del                = 336723992;
  isc_gsec_err_find_disp               = 336723996;
  isc_gsec_inv_param                   = 336723997;
  isc_gsec_op_specified                = 336723998;
  isc_gsec_pw_specified                = 336723999;
  isc_gsec_uid_specified               = 336724000;
  isc_gsec_gid_specified               = 336724001;
  isc_gsec_proj_specified              = 336724002;
  isc_gsec_org_specified               = 336724003;
  isc_gsec_fname_specified             = 336724004;
  isc_gsec_mname_specified             = 336724005;
  isc_gsec_lname_specified             = 336724006;
  isc_gsec_inv_switch                  = 336724008;
  isc_gsec_amb_switch                  = 336724009;
  isc_gsec_no_op_specified             = 336724010;
  isc_gsec_params_not_allowed          = 336724011;
  isc_gsec_incompat_switch             = 336724012;
  isc_gsec_inv_username                = 336724044;
  isc_gsec_inv_pw_length               = 336724045;
  isc_gsec_db_specified                = 336724046;
  isc_gsec_db_admin_specified          = 336724047;
  isc_gsec_db_admin_pw_specified       = 336724048;
  isc_gsec_sql_role_specified          = 336724049;
  isc_gstat_unknown_switch             = 336920577;
  isc_gstat_retry                      = 336920578;
  isc_gstat_wrong_ods                  = 336920579;
  isc_gstat_unexpected_eof             = 336920580;
  isc_gstat_open_err                   = 336920605;
  isc_gstat_read_err                   = 336920606;
  isc_gstat_sysmemex                   = 336920607;
  isc_fbsvcmgr_bad_am                  = 336986113;
  isc_fbsvcmgr_bad_wm                  = 336986114;
  isc_fbsvcmgr_bad_rs                  = 336986115;
  isc_fbsvcmgr_info_err                = 336986116;
  isc_fbsvcmgr_query_err               = 336986117;
  isc_fbsvcmgr_switch_unknown          = 336986118;
  isc_fbsvcmgr_bad_sm                  = 336986159;
  isc_fbsvcmgr_fp_open                 = 336986160;
  isc_fbsvcmgr_fp_read                 = 336986161;
  isc_fbsvcmgr_fp_empty                = 336986162;
  isc_fbsvcmgr_bad_arg                 = 336986164;
  isc_fbsvcmgr_info_limbo              = 336986170;
  isc_fbsvcmgr_limbo_state             = 336986171;
  isc_fbsvcmgr_limbo_advise            = 336986172;
  isc_utl_trusted_switch               = 337051649;
  isc_nbackup_missing_param            = 337117213;
  isc_nbackup_allowed_switches         = 337117214;
  isc_nbackup_unknown_param            = 337117215;
  isc_nbackup_unknown_switch           = 337117216;
  isc_nbackup_nofetchpw_svc            = 337117217;
  isc_nbackup_pwfile_error             = 337117218;
  isc_nbackup_size_with_lock           = 337117219;
  isc_nbackup_no_switch                = 337117220;
  isc_nbackup_err_read                 = 337117223;
  isc_nbackup_err_write                = 337117224;
  isc_nbackup_err_seek                 = 337117225;
  isc_nbackup_err_opendb               = 337117226;
  isc_nbackup_err_fadvice              = 337117227;
  isc_nbackup_err_createdb             = 337117228;
  isc_nbackup_err_openbk               = 337117229;
  isc_nbackup_err_createbk             = 337117230;
  isc_nbackup_err_eofdb                = 337117231;
  isc_nbackup_fixup_wrongstate         = 337117232;
  isc_nbackup_err_db                   = 337117233;
  isc_nbackup_userpw_toolong           = 337117234;
  isc_nbackup_lostrec_db               = 337117235;
  isc_nbackup_lostguid_db              = 337117236;
  isc_nbackup_err_eofhdrdb             = 337117237;
  isc_nbackup_db_notlock               = 337117238;
  isc_nbackup_lostguid_bk              = 337117239;
  isc_nbackup_page_changed             = 337117240;
  isc_nbackup_dbsize_inconsistent      = 337117241;
  isc_nbackup_failed_lzbk              = 337117242;
  isc_nbackup_err_eofhdrbk             = 337117243;
  isc_nbackup_invalid_incbk            = 337117244;
  isc_nbackup_unsupvers_incbk          = 337117245;
  isc_nbackup_invlevel_incbk           = 337117246;
  isc_nbackup_wrong_orderbk            = 337117247;
  isc_nbackup_err_eofbk                = 337117248;
  isc_nbackup_err_copy                 = 337117249;
  isc_nbackup_err_eofhdr_restdb        = 337117250;
  isc_nbackup_lostguid_l0bk            = 337117251;
  isc_nbackup_switchd_parameter        = 337117255;
  isc_nbackup_user_stop                = 337117257;
  isc_nbackup_deco_parse               = 337117259;
  isc_trace_conflict_acts              = 337182750;
  isc_trace_act_notfound               = 337182751;
  isc_trace_switch_once                = 337182752;
  isc_trace_param_val_miss             = 337182753;
  isc_trace_param_invalid              = 337182754;
  isc_trace_switch_unknown             = 337182755;
  isc_trace_switch_svc_only            = 337182756;
  isc_trace_switch_user_only           = 337182757;
  isc_trace_switch_param_miss          = 337182758;
  isc_trace_param_act_notcompat        = 337182759;
  isc_trace_mandatory_switch_miss      = 337182760;

implementation

procedure IReferenceCounted.addRef();
begin
  ReferenceCountedVTable(vTable).addRef(Self);
end;

function IReferenceCounted.release(): Integer;
begin
  Result := ReferenceCountedVTable(vTable).release(Self);
end;

procedure IDisposable.dispose();
begin
  DisposableVTable(vTable).dispose(Self);
end;

procedure IStatus.init();
begin
  StatusVTable(vTable).init(Self);
end;

function IStatus.getState(): Cardinal;
begin
  Result := StatusVTable(vTable).getState(Self);
end;

procedure IStatus.setErrors2(length: Cardinal; value: NativeIntPtr);
begin
  StatusVTable(vTable).setErrors2(Self, length, value);
end;

procedure IStatus.setWarnings2(length: Cardinal; value: NativeIntPtr);
begin
  StatusVTable(vTable).setWarnings2(Self, length, value);
end;

procedure IStatus.setErrors(value: NativeIntPtr);
begin
  StatusVTable(vTable).setErrors(Self, value);
end;

procedure IStatus.setWarnings(value: NativeIntPtr);
begin
  StatusVTable(vTable).setWarnings(Self, value);
end;

function IStatus.getErrors(): NativeIntPtr;
begin
  Result := StatusVTable(vTable).getErrors(Self);
end;

function IStatus.getWarnings(): NativeIntPtr;
begin
  Result := StatusVTable(vTable).getWarnings(Self);
end;

function IStatus.clone(): IStatus;
begin
  Result := StatusVTable(vTable).clone(Self);
end;

function IMaster.getStatus(): IStatus;
begin
  Result := MasterVTable(vTable).getStatus(Self);
end;

function IMaster.getDispatcher(): IProvider;
begin
  Result := MasterVTable(vTable).getDispatcher(Self);
end;

function IMaster.getPluginManager(): IPluginManager;
begin
  Result := MasterVTable(vTable).getPluginManager(Self);
end;

function IMaster.getTimerControl(): ITimerControl;
begin
  Result := MasterVTable(vTable).getTimerControl(Self);
end;

function IMaster.getDtc(): IDtc;
begin
  Result := MasterVTable(vTable).getDtc(Self);
end;

function IMaster.registerAttachment(provider: IProvider; attachment: IAttachment): IAttachment;
begin
  Result := MasterVTable(vTable).registerAttachment(Self, provider, attachment);
end;

function IMaster.registerTransaction(attachment: IAttachment; transaction: ITransaction): ITransaction;
begin
  Result := MasterVTable(vTable).registerTransaction(Self, attachment, transaction);
end;

function IMaster.getMetadataBuilder(status: IStatus; fieldCount: Cardinal): IMetadataBuilder;
begin
  Result := MasterVTable(vTable).getMetadataBuilder(Self, status, fieldCount);
  FbException.checkException(status);
end;

function IMaster.serverMode(mode: Integer): Integer;
begin
  Result := MasterVTable(vTable).serverMode(Self, mode);
end;

function IMaster.getUtilInterface(): IUtil;
begin
  Result := MasterVTable(vTable).getUtilInterface(Self);
end;

function IMaster.getConfigManager(): IConfigManager;
begin
  Result := MasterVTable(vTable).getConfigManager(Self);
end;

function IMaster.getProcessExiting(): Boolean;
begin
  Result := MasterVTable(vTable).getProcessExiting(Self);
end;

procedure IPluginBase.setOwner(r: IReferenceCounted);
begin
  PluginBaseVTable(vTable).setOwner(Self, r);
end;

function IPluginBase.getOwner(): IReferenceCounted;
begin
  Result := PluginBaseVTable(vTable).getOwner(Self);
end;

function IPluginSet.getName(): PAnsiChar;
begin
  Result := PluginSetVTable(vTable).getName(Self);
end;

function IPluginSet.getModuleName(): PAnsiChar;
begin
  Result := PluginSetVTable(vTable).getModuleName(Self);
end;

function IPluginSet.getPlugin(status: IStatus): IPluginBase;
begin
  Result := PluginSetVTable(vTable).getPlugin(Self, status);
  FbException.checkException(status);
end;

procedure IPluginSet.next(status: IStatus);
begin
  PluginSetVTable(vTable).next(Self, status);
  FbException.checkException(status);
end;

procedure IPluginSet.set_(status: IStatus; s: PAnsiChar);
begin
  PluginSetVTable(vTable).set_(Self, status, s);
  FbException.checkException(status);
end;

function IConfigEntry.getName(): PAnsiChar;
begin
  Result := ConfigEntryVTable(vTable).getName(Self);
end;

function IConfigEntry.getValue(): PAnsiChar;
begin
  Result := ConfigEntryVTable(vTable).getValue(Self);
end;

function IConfigEntry.getIntValue(): Int64;
begin
  Result := ConfigEntryVTable(vTable).getIntValue(Self);
end;

function IConfigEntry.getBoolValue(): Boolean;
begin
  Result := ConfigEntryVTable(vTable).getBoolValue(Self);
end;

function IConfigEntry.getSubConfig(status: IStatus): IConfig;
begin
  Result := ConfigEntryVTable(vTable).getSubConfig(Self, status);
  FbException.checkException(status);
end;

function IConfig.find(status: IStatus; name: PAnsiChar): IConfigEntry;
begin
  Result := ConfigVTable(vTable).find(Self, status, name);
  FbException.checkException(status);
end;

function IConfig.findValue(status: IStatus; name: PAnsiChar; value: PAnsiChar): IConfigEntry;
begin
  Result := ConfigVTable(vTable).findValue(Self, status, name, value);
  FbException.checkException(status);
end;

function IConfig.findPos(status: IStatus; name: PAnsiChar; pos: Cardinal): IConfigEntry;
begin
  Result := ConfigVTable(vTable).findPos(Self, status, name, pos);
  FbException.checkException(status);
end;

function IFirebirdConf.getKey(name: PAnsiChar): Cardinal;
begin
  Result := FirebirdConfVTable(vTable).getKey(Self, name);
end;

function IFirebirdConf.asInteger(key: Cardinal): Int64;
begin
  Result := FirebirdConfVTable(vTable).asInteger(Self, key);
end;

function IFirebirdConf.asString(key: Cardinal): PAnsiChar;
begin
  Result := FirebirdConfVTable(vTable).asString(Self, key);
end;

function IFirebirdConf.asBoolean(key: Cardinal): Boolean;
begin
  Result := FirebirdConfVTable(vTable).asBoolean(Self, key);
end;

function IPluginConfig.getConfigFileName(): PAnsiChar;
begin
  Result := PluginConfigVTable(vTable).getConfigFileName(Self);
end;

function IPluginConfig.getDefaultConfig(status: IStatus): IConfig;
begin
  Result := PluginConfigVTable(vTable).getDefaultConfig(Self, status);
  FbException.checkException(status);
end;

function IPluginConfig.getFirebirdConf(status: IStatus): IFirebirdConf;
begin
  Result := PluginConfigVTable(vTable).getFirebirdConf(Self, status);
  FbException.checkException(status);
end;

procedure IPluginConfig.setReleaseDelay(status: IStatus; microSeconds: QWord);
begin
  PluginConfigVTable(vTable).setReleaseDelay(Self, status, microSeconds);
  FbException.checkException(status);
end;

function IPluginFactory.createPlugin(status: IStatus; factoryParameter: IPluginConfig): IPluginBase;
begin
  Result := PluginFactoryVTable(vTable).createPlugin(Self, status, factoryParameter);
  FbException.checkException(status);
end;

procedure IPluginModule.doClean();
begin
  PluginModuleVTable(vTable).doClean(Self);
end;

procedure IPluginModule.threadDetach();
begin
  PluginModuleVTable(vTable).threadDetach(Self);
end;

procedure IPluginManager.registerPluginFactory(pluginType: Cardinal; defaultName: PAnsiChar; factory: IPluginFactory);
begin
  PluginManagerVTable(vTable).registerPluginFactory(Self, pluginType, defaultName, factory);
end;

procedure IPluginManager.registerModule(cleanup: IPluginModule);
begin
  PluginManagerVTable(vTable).registerModule(Self, cleanup);
end;

procedure IPluginManager.unregisterModule(cleanup: IPluginModule);
begin
  PluginManagerVTable(vTable).unregisterModule(Self, cleanup);
end;

function IPluginManager.getPlugins(status: IStatus; pluginType: Cardinal; namesList: PAnsiChar; firebirdConf: IFirebirdConf): IPluginSet;
begin
  Result := PluginManagerVTable(vTable).getPlugins(Self, status, pluginType, namesList, firebirdConf);
  FbException.checkException(status);
end;

function IPluginManager.getConfig(status: IStatus; filename: PAnsiChar): IConfig;
begin
  Result := PluginManagerVTable(vTable).getConfig(Self, status, filename);
  FbException.checkException(status);
end;

procedure IPluginManager.releasePlugin(plugin: IPluginBase);
begin
  PluginManagerVTable(vTable).releasePlugin(Self, plugin);
end;

procedure ICryptKey.setSymmetric(status: IStatus; type_: PAnsiChar; keyLength: Cardinal; key: Pointer);
begin
  CryptKeyVTable(vTable).setSymmetric(Self, status, type_, keyLength, key);
  FbException.checkException(status);
end;

procedure ICryptKey.setAsymmetric(status: IStatus; type_: PAnsiChar; encryptKeyLength: Cardinal; encryptKey: Pointer; decryptKeyLength: Cardinal;
  decryptKey: Pointer);
begin
  CryptKeyVTable(vTable).setAsymmetric(Self, status, type_, encryptKeyLength, encryptKey, decryptKeyLength, decryptKey);
  FbException.checkException(status);
end;

function ICryptKey.getEncryptKey(length: CardinalPtr): Pointer;
begin
  Result := CryptKeyVTable(vTable).getEncryptKey(Self, length);
end;

function ICryptKey.getDecryptKey(length: CardinalPtr): Pointer;
begin
  Result := CryptKeyVTable(vTable).getDecryptKey(Self, length);
end;

function IConfigManager.getDirectory(code: Cardinal): PAnsiChar;
begin
  Result := ConfigManagerVTable(vTable).getDirectory(Self, code);
end;

function IConfigManager.getFirebirdConf(): IFirebirdConf;
begin
  Result := ConfigManagerVTable(vTable).getFirebirdConf(Self);
end;

function IConfigManager.getDatabaseConf(dbName: PAnsiChar): IFirebirdConf;
begin
  Result := ConfigManagerVTable(vTable).getDatabaseConf(Self, dbName);
end;

function IConfigManager.getPluginConfig(configuredPlugin: PAnsiChar): IConfig;
begin
  Result := ConfigManagerVTable(vTable).getPluginConfig(Self, configuredPlugin);
end;

function IConfigManager.getInstallDirectory(): PAnsiChar;
begin
  Result := ConfigManagerVTable(vTable).getInstallDirectory(Self);
end;

function IConfigManager.getRootDirectory(): PAnsiChar;
begin
  Result := ConfigManagerVTable(vTable).getRootDirectory(Self);
end;

function IConfigManager.getDefaultSecurityDb(): PAnsiChar;
begin
  Result := ConfigManagerVTable(vTable).getDefaultSecurityDb(Self);
end;

procedure IEventCallback.eventCallbackFunction(length: Cardinal; events: BytePtr);
begin
  EventCallbackVTable(vTable).eventCallbackFunction(Self, length, events);
end;

procedure IBlob.getInfo(status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
begin
  BlobVTable(vTable).getInfo(Self, status, itemsLength, items, bufferLength, buffer);
  FbException.checkException(status);
end;

function IBlob.getSegment(status: IStatus; bufferLength: Cardinal; buffer: Pointer; var segmentLength: Cardinal): Integer;
begin
  Result := BlobVTable(vTable).getSegment(Self, status, bufferLength, buffer, segmentLength);
//  {$Message 'KVO. лишняя провека, так как STATE_ERRORS = RESULT_SEGMENT'}
//  FbException.checkException(status);
end;

procedure IBlob.putSegment(status: IStatus; length: Cardinal; buffer: Pointer);
begin
  BlobVTable(vTable).putSegment(Self, status, length, buffer);
  FbException.checkException(status);
end;

procedure IBlob.cancel(status: IStatus);
begin
  BlobVTable(vTable).cancel(Self, status);
  FbException.checkException(status);
end;

procedure IBlob.close(status: IStatus);
begin
  BlobVTable(vTable).close(Self, status);
  FbException.checkException(status);
end;

function IBlob.seek(status: IStatus; mode: Integer; offset: Integer): Integer;
begin
  Result := BlobVTable(vTable).seek(Self, status, mode, offset);
  FbException.checkException(status);
end;

procedure ITransaction.getInfo(status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
begin
  TransactionVTable(vTable).getInfo(Self, status, itemsLength, items, bufferLength, buffer);
  FbException.checkException(status);
end;

procedure ITransaction.prepare(status: IStatus; msgLength: Cardinal; message: BytePtr);
begin
  TransactionVTable(vTable).prepare(Self, status, msgLength, message);
  FbException.checkException(status);
end;

procedure ITransaction.commit(status: IStatus);
begin
  TransactionVTable(vTable).commit(Self, status);
  FbException.checkException(status);
end;

procedure ITransaction.commitRetaining(status: IStatus);
begin
  TransactionVTable(vTable).commitRetaining(Self, status);
  FbException.checkException(status);
end;

procedure ITransaction.rollback(status: IStatus);
begin
  TransactionVTable(vTable).rollback(Self, status);
  FbException.checkException(status);
end;

procedure ITransaction.rollbackRetaining(status: IStatus);
begin
  TransactionVTable(vTable).rollbackRetaining(Self, status);
  FbException.checkException(status);
end;

procedure ITransaction.disconnect(status: IStatus);
begin
  TransactionVTable(vTable).disconnect(Self, status);
  FbException.checkException(status);
end;

function ITransaction.join(status: IStatus; transaction: ITransaction): ITransaction;
begin
  Result := TransactionVTable(vTable).join(Self, status, transaction);
  FbException.checkException(status);
end;

function ITransaction.validate(status: IStatus; attachment: IAttachment): ITransaction;
begin
  Result := TransactionVTable(vTable).validate(Self, status, attachment);
  FbException.checkException(status);
end;

function ITransaction.enterDtc(status: IStatus): ITransaction;
begin
  Result := TransactionVTable(vTable).enterDtc(Self, status);
  FbException.checkException(status);
end;

function IMessageMetadata.getCount(status: IStatus): Cardinal;
begin
  Result := MessageMetadataVTable(vTable).getCount(Self, status);
  FbException.checkException(status);
end;

function IMessageMetadata.getField(status: IStatus; index: Cardinal): PAnsiChar;
begin
  Result := MessageMetadataVTable(vTable).getField(Self, status, index);
  FbException.checkException(status);
end;

function IMessageMetadata.getRelation(status: IStatus; index: Cardinal): PAnsiChar;
begin
  Result := MessageMetadataVTable(vTable).getRelation(Self, status, index);
  FbException.checkException(status);
end;

function IMessageMetadata.getOwner(status: IStatus; index: Cardinal): PAnsiChar;
begin
  Result := MessageMetadataVTable(vTable).getOwner(Self, status, index);
  FbException.checkException(status);
end;

function IMessageMetadata.getAlias(status: IStatus; index: Cardinal): PAnsiChar;
begin
  Result := MessageMetadataVTable(vTable).getAlias(Self, status, index);
  FbException.checkException(status);
end;

function IMessageMetadata.getType(status: IStatus; index: Cardinal): Cardinal;
begin
  Result := MessageMetadataVTable(vTable).getType(Self, status, index);
  FbException.checkException(status);
end;

function IMessageMetadata.isNullable(status: IStatus; index: Cardinal): Boolean;
begin
  Result := MessageMetadataVTable(vTable).isNullable(Self, status, index);
  FbException.checkException(status);
end;

function IMessageMetadata.getSubType(status: IStatus; index: Cardinal): Integer;
begin
  Result := MessageMetadataVTable(vTable).getSubType(Self, status, index);
  FbException.checkException(status);
end;

function IMessageMetadata.getLength(status: IStatus; index: Cardinal): Cardinal;
begin
  Result := MessageMetadataVTable(vTable).getLength(Self, status, index);
  FbException.checkException(status);
end;

function IMessageMetadata.getScale(status: IStatus; index: Cardinal): Integer;
begin
  Result := MessageMetadataVTable(vTable).getScale(Self, status, index);
  FbException.checkException(status);
end;

function IMessageMetadata.getCharSet(status: IStatus; index: Cardinal): Cardinal;
begin
  Result := MessageMetadataVTable(vTable).getCharSet(Self, status, index);
  FbException.checkException(status);
end;

function IMessageMetadata.getOffset(status: IStatus; index: Cardinal): Cardinal;
begin
  Result := MessageMetadataVTable(vTable).getOffset(Self, status, index);
  FbException.checkException(status);
end;

function IMessageMetadata.getNullOffset(status: IStatus; index: Cardinal): Cardinal;
begin
  Result := MessageMetadataVTable(vTable).getNullOffset(Self, status, index);
  FbException.checkException(status);
end;

function IMessageMetadata.getBuilder(status: IStatus): IMetadataBuilder;
begin
  Result := MessageMetadataVTable(vTable).getBuilder(Self, status);
  FbException.checkException(status);
end;

function IMessageMetadata.getMessageLength(status: IStatus): Cardinal;
begin
  Result := MessageMetadataVTable(vTable).getMessageLength(Self, status);
  FbException.checkException(status);
end;

procedure IMetadataBuilder.setType(status: IStatus; index: Cardinal; type_: Cardinal);
begin
  MetadataBuilderVTable(vTable).setType(Self, status, index, type_);
  FbException.checkException(status);
end;

procedure IMetadataBuilder.setSubType(status: IStatus; index: Cardinal; subType: Integer);
begin
  MetadataBuilderVTable(vTable).setSubType(Self, status, index, subType);
  FbException.checkException(status);
end;

procedure IMetadataBuilder.setLength(status: IStatus; index: Cardinal; length: Cardinal);
begin
  MetadataBuilderVTable(vTable).setLength(Self, status, index, length);
  FbException.checkException(status);
end;

procedure IMetadataBuilder.setCharSet(status: IStatus; index: Cardinal; charSet: Cardinal);
begin
  MetadataBuilderVTable(vTable).setCharSet(Self, status, index, charSet);
  FbException.checkException(status);
end;

procedure IMetadataBuilder.setScale(status: IStatus; index: Cardinal; scale: Integer);
begin
  MetadataBuilderVTable(vTable).setScale(Self, status, index, scale);
  FbException.checkException(status);
end;

procedure IMetadataBuilder.truncate(status: IStatus; count: Cardinal);
begin
  MetadataBuilderVTable(vTable).truncate(Self, status, count);
  FbException.checkException(status);
end;

procedure IMetadataBuilder.moveNameToIndex(status: IStatus; name: PAnsiChar; index: Cardinal);
begin
  MetadataBuilderVTable(vTable).moveNameToIndex(Self, status, name, index);
  FbException.checkException(status);
end;

procedure IMetadataBuilder.remove(status: IStatus; index: Cardinal);
begin
  MetadataBuilderVTable(vTable).remove(Self, status, index);
  FbException.checkException(status);
end;

function IMetadataBuilder.addField(status: IStatus): Cardinal;
begin
  Result := MetadataBuilderVTable(vTable).addField(Self, status);
  FbException.checkException(status);
end;

function IMetadataBuilder.getMetadata(status: IStatus): IMessageMetadata;
begin
  Result := MetadataBuilderVTable(vTable).getMetadata(Self, status);
  FbException.checkException(status);
end;

function IResultSet.fetchNext(status: IStatus; message: Pointer): Integer;
begin
  Result := ResultSetVTable(vTable).fetchNext(Self, status, message);
  FbException.checkException(status);
end;

function IResultSet.fetchPrior(status: IStatus; message: Pointer): Integer;
begin
  Result := ResultSetVTable(vTable).fetchPrior(Self, status, message);
  FbException.checkException(status);
end;

function IResultSet.fetchFirst(status: IStatus; message: Pointer): Integer;
begin
  Result := ResultSetVTable(vTable).fetchFirst(Self, status, message);
  FbException.checkException(status);
end;

function IResultSet.fetchLast(status: IStatus; message: Pointer): Integer;
begin
  Result := ResultSetVTable(vTable).fetchLast(Self, status, message);
  FbException.checkException(status);
end;

function IResultSet.fetchAbsolute(status: IStatus; position: Integer; message: Pointer): Integer;
begin
  Result := ResultSetVTable(vTable).fetchAbsolute(Self, status, position, message);
  FbException.checkException(status);
end;

function IResultSet.fetchRelative(status: IStatus; offset: Integer; message: Pointer): Integer;
begin
  Result := ResultSetVTable(vTable).fetchRelative(Self, status, offset, message);
  FbException.checkException(status);
end;

function IResultSet.isEof(status: IStatus): Boolean;
begin
  Result := ResultSetVTable(vTable).isEof(Self, status);
  FbException.checkException(status);
end;

function IResultSet.isBof(status: IStatus): Boolean;
begin
  Result := ResultSetVTable(vTable).isBof(Self, status);
  FbException.checkException(status);
end;

function IResultSet.getMetadata(status: IStatus): IMessageMetadata;
begin
  Result := ResultSetVTable(vTable).getMetadata(Self, status);
  FbException.checkException(status);
end;

procedure IResultSet.close(status: IStatus);
begin
  ResultSetVTable(vTable).close(Self, status);
  FbException.checkException(status);
end;

procedure IResultSet.setDelayedOutputFormat(status: IStatus; format: IMessageMetadata);
begin
  ResultSetVTable(vTable).setDelayedOutputFormat(Self, status, format);
  FbException.checkException(status);
end;

procedure IStatement.getInfo(status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
begin
  StatementVTable(vTable).getInfo(Self, status, itemsLength, items, bufferLength, buffer);
  FbException.checkException(status);
end;

function IStatement.getType(status: IStatus): Cardinal;
begin
  Result := StatementVTable(vTable).getType(Self, status);
  FbException.checkException(status);
end;

function IStatement.getPlan(status: IStatus; detailed: Boolean): PAnsiChar;
begin
  Result := StatementVTable(vTable).getPlan(Self, status, detailed);
  FbException.checkException(status);
end;

function IStatement.getAffectedRecords(status: IStatus): QWord;
begin
  Result := StatementVTable(vTable).getAffectedRecords(Self, status);
  FbException.checkException(status);
end;

function IStatement.getInputMetadata(status: IStatus): IMessageMetadata;
begin
  Result := StatementVTable(vTable).getInputMetadata(Self, status);
  FbException.checkException(status);
end;

function IStatement.getOutputMetadata(status: IStatus): IMessageMetadata;
begin
  Result := StatementVTable(vTable).getOutputMetadata(Self, status);
  FbException.checkException(status);
end;

function IStatement.execute(status: IStatus; transaction: ITransaction; inMetadata: IMessageMetadata; inBuffer: Pointer;
  outMetadata: IMessageMetadata; outBuffer: Pointer): ITransaction;
begin
  Result := StatementVTable(vTable).execute(Self, status, transaction, inMetadata, inBuffer, outMetadata, outBuffer);
  FbException.checkException(status);
end;

function IStatement.openCursor(status: IStatus; transaction: ITransaction; inMetadata: IMessageMetadata; inBuffer: Pointer;
  outMetadata: IMessageMetadata; flags: Cardinal): IResultSet;
begin
  Result := StatementVTable(vTable).openCursor(Self, status, transaction, inMetadata, inBuffer, outMetadata, flags);
  FbException.checkException(status);
end;

procedure IStatement.setCursorName(status: IStatus; name: PAnsiChar);
begin
  StatementVTable(vTable).setCursorName(Self, status, name);
  FbException.checkException(status);
end;

procedure IStatement.free(status: IStatus);
begin
  StatementVTable(vTable).free(Self, status);
  FbException.checkException(status);
end;

function IStatement.getFlags(status: IStatus): Cardinal;
begin
  Result := StatementVTable(vTable).getFlags(Self, status);
  FbException.checkException(status);
end;

procedure IRequest.receive(status: IStatus; level: Integer; msgType: Cardinal; length: Cardinal; message: BytePtr);
begin
  RequestVTable(vTable).receive(Self, status, level, msgType, length, message);
  FbException.checkException(status);
end;

procedure IRequest.send(status: IStatus; level: Integer; msgType: Cardinal; length: Cardinal; message: BytePtr);
begin
  RequestVTable(vTable).send(Self, status, level, msgType, length, message);
  FbException.checkException(status);
end;

procedure IRequest.getInfo(status: IStatus; level: Integer; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
begin
  RequestVTable(vTable).getInfo(Self, status, level, itemsLength, items, bufferLength, buffer);
  FbException.checkException(status);
end;

procedure IRequest.start(status: IStatus; tra: ITransaction; level: Integer);
begin
  RequestVTable(vTable).start(Self, status, tra, level);
  FbException.checkException(status);
end;

procedure IRequest.startAndSend(status: IStatus; tra: ITransaction; level: Integer; msgType: Cardinal; length: Cardinal; message: BytePtr);
begin
  RequestVTable(vTable).startAndSend(Self, status, tra, level, msgType, length, message);
  FbException.checkException(status);
end;

procedure IRequest.unwind(status: IStatus; level: Integer);
begin
  RequestVTable(vTable).unwind(Self, status, level);
  FbException.checkException(status);
end;

procedure IRequest.free(status: IStatus);
begin
  RequestVTable(vTable).free(Self, status);
  FbException.checkException(status);
end;

procedure IEvents.cancel(status: IStatus);
begin
  EventsVTable(vTable).cancel(Self, status);
  FbException.checkException(status);
end;

procedure IAttachment.getInfo(status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal; buffer: BytePtr);
begin
  AttachmentVTable(vTable).getInfo(Self, status, itemsLength, items, bufferLength, buffer);
  FbException.checkException(status);
end;

function IAttachment.startTransaction(status: IStatus; tpbLength: Cardinal; tpb: BytePtr): ITransaction;
begin
  Result := AttachmentVTable(vTable).startTransaction(Self, status, tpbLength, tpb);
  FbException.checkException(status);
end;

function IAttachment.reconnectTransaction(status: IStatus; length: Cardinal; id: BytePtr): ITransaction;
begin
  Result := AttachmentVTable(vTable).reconnectTransaction(Self, status, length, id);
  FbException.checkException(status);
end;

function IAttachment.compileRequest(status: IStatus; blrLength: Cardinal; blr: BytePtr): IRequest;
begin
  Result := AttachmentVTable(vTable).compileRequest(Self, status, blrLength, blr);
  FbException.checkException(status);
end;

procedure IAttachment.transactRequest(status: IStatus; transaction: ITransaction; blrLength: Cardinal; blr: BytePtr; inMsgLength: Cardinal;
  inMsg: BytePtr; outMsgLength: Cardinal; outMsg: BytePtr);
begin
  AttachmentVTable(vTable).transactRequest(Self, status, transaction, blrLength, blr, inMsgLength, inMsg, outMsgLength, outMsg);
  FbException.checkException(status);
end;

function IAttachment.createBlob(status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; bpbLength: Cardinal; bpb: BytePtr): IBlob;
begin
  Result := AttachmentVTable(vTable).createBlob(Self, status, transaction, id, bpbLength, bpb);
  FbException.checkException(status);
end;

function IAttachment.openBlob(status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; bpbLength: Cardinal; bpb: BytePtr): IBlob;
begin
  Result := AttachmentVTable(vTable).openBlob(Self, status, transaction, id, bpbLength, bpb);
  FbException.checkException(status);
end;

function IAttachment.getSlice(status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; sdlLength: Cardinal; sdl: BytePtr; paramLength: Cardinal;
  param: BytePtr; sliceLength: Integer; slice: BytePtr): Integer;
begin
  Result := AttachmentVTable(vTable).getSlice(Self, status, transaction, id, sdlLength, sdl, paramLength, param, sliceLength, slice);
  FbException.checkException(status);
end;

procedure IAttachment.putSlice(status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; sdlLength: Cardinal; sdl: BytePtr; paramLength: Cardinal;
  param: BytePtr; sliceLength: Integer; slice: BytePtr);
begin
  AttachmentVTable(vTable).putSlice(Self, status, transaction, id, sdlLength, sdl, paramLength, param, sliceLength, slice);
  FbException.checkException(status);
end;

procedure IAttachment.executeDyn(status: IStatus; transaction: ITransaction; length: Cardinal; dyn: BytePtr);
begin
  AttachmentVTable(vTable).executeDyn(Self, status, transaction, length, dyn);
  FbException.checkException(status);
end;

function IAttachment.prepare(status: IStatus; tra: ITransaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal; flags: Cardinal)
  : IStatement;
begin
  Result := AttachmentVTable(vTable).prepare(Self, status, tra, stmtLength, sqlStmt, dialect, flags);
  FbException.checkException(status);
end;

function IAttachment.execute(status: IStatus; transaction: ITransaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal;
  inMetadata: IMessageMetadata; inBuffer: Pointer; outMetadata: IMessageMetadata; outBuffer: Pointer): ITransaction;
begin
  Result := AttachmentVTable(vTable).execute(Self, status, transaction, stmtLength, sqlStmt, dialect, inMetadata, inBuffer, outMetadata, outBuffer);
  FbException.checkException(status);
end;

function IAttachment.openCursor(status: IStatus; transaction: ITransaction; stmtLength: Cardinal; sqlStmt: PAnsiChar; dialect: Cardinal;
  inMetadata: IMessageMetadata; inBuffer: Pointer; outMetadata: IMessageMetadata; cursorName: PAnsiChar; cursorFlags: Cardinal): IResultSet;
begin
  Result := AttachmentVTable(vTable).openCursor(Self, status, transaction, stmtLength, sqlStmt, dialect, inMetadata, inBuffer, outMetadata,
    cursorName, cursorFlags);
  FbException.checkException(status);
end;

function IAttachment.queEvents(status: IStatus; callback: IEventCallback; length: Cardinal; events: BytePtr): IEvents;
begin
  Result := AttachmentVTable(vTable).queEvents(Self, status, callback, length, events);
  FbException.checkException(status);
end;

procedure IAttachment.cancelOperation(status: IStatus; option: Integer);
begin
  AttachmentVTable(vTable).cancelOperation(Self, status, option);
  FbException.checkException(status);
end;

procedure IAttachment.ping(status: IStatus);
begin
  AttachmentVTable(vTable).ping(Self, status);
  FbException.checkException(status);
end;

procedure IAttachment.detach(status: IStatus);
begin
  AttachmentVTable(vTable).detach(Self, status);
  FbException.checkException(status);
end;

procedure IAttachment.dropDatabase(status: IStatus);
begin
  AttachmentVTable(vTable).dropDatabase(Self, status);
  FbException.checkException(status);
end;

procedure IService.detach(status: IStatus);
begin
  ServiceVTable(vTable).detach(Self, status);
  FbException.checkException(status);
end;

procedure IService.query(status: IStatus; sendLength: Cardinal; sendItems: BytePtr; receiveLength: Cardinal; receiveItems: BytePtr;
  bufferLength: Cardinal; buffer: BytePtr);
begin
  ServiceVTable(vTable).query(Self, status, sendLength, sendItems, receiveLength, receiveItems, bufferLength, buffer);
  FbException.checkException(status);
end;

procedure IService.start(status: IStatus; spbLength: Cardinal; spb: BytePtr);
begin
  ServiceVTable(vTable).start(Self, status, spbLength, spb);
  FbException.checkException(status);
end;

function IProvider.attachDatabase(status: IStatus; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr): IAttachment;
begin
  Result := ProviderVTable(vTable).attachDatabase(Self, status, filename, dpbLength, dpb);
  FbException.checkException(status);
end;

function IProvider.createDatabase(status: IStatus; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr): IAttachment;
begin
  Result := ProviderVTable(vTable).createDatabase(Self, status, filename, dpbLength, dpb);
  FbException.checkException(status);
end;

function IProvider.attachServiceManager(status: IStatus; service: PAnsiChar; spbLength: Cardinal; spb: BytePtr): IService;
begin
  Result := ProviderVTable(vTable).attachServiceManager(Self, status, service, spbLength, spb);
  FbException.checkException(status);
end;

procedure IProvider.shutdown(status: IStatus; timeout: Cardinal; reason: Integer);
begin
  ProviderVTable(vTable).shutdown(Self, status, timeout, reason);
  FbException.checkException(status);
end;

procedure IProvider.setDbCryptCallback(status: IStatus; cryptCallback: ICryptKeyCallback);
begin
  ProviderVTable(vTable).setDbCryptCallback(Self, status, cryptCallback);
  FbException.checkException(status);
end;

procedure IDtcStart.addAttachment(status: IStatus; att: IAttachment);
begin
  DtcStartVTable(vTable).addAttachment(Self, status, att);
  FbException.checkException(status);
end;

procedure IDtcStart.addWithTpb(status: IStatus; att: IAttachment; length: Cardinal; tpb: BytePtr);
begin
  DtcStartVTable(vTable).addWithTpb(Self, status, att, length, tpb);
  FbException.checkException(status);
end;

function IDtcStart.start(status: IStatus): ITransaction;
begin
  Result := DtcStartVTable(vTable).start(Self, status);
  FbException.checkException(status);
end;

function IDtc.join(status: IStatus; one: ITransaction; two: ITransaction): ITransaction;
begin
  Result := DtcVTable(vTable).join(Self, status, one, two);
  FbException.checkException(status);
end;

function IDtc.startBuilder(status: IStatus): IDtcStart;
begin
  Result := DtcVTable(vTable).startBuilder(Self, status);
  FbException.checkException(status);
end;

procedure IWriter.reset();
begin
  WriterVTable(vTable).reset(Self);
end;

procedure IWriter.add(status: IStatus; name: PAnsiChar);
begin
  WriterVTable(vTable).add(Self, status, name);
  FbException.checkException(status);
end;

procedure IWriter.setType(status: IStatus; value: PAnsiChar);
begin
  WriterVTable(vTable).setType(Self, status, value);
  FbException.checkException(status);
end;

procedure IWriter.setDb(status: IStatus; value: PAnsiChar);
begin
  WriterVTable(vTable).setDb(Self, status, value);
  FbException.checkException(status);
end;

function IServerBlock.getLogin(): PAnsiChar;
begin
  Result := ServerBlockVTable(vTable).getLogin(Self);
end;

function IServerBlock.getData(length: CardinalPtr): BytePtr;
begin
  Result := ServerBlockVTable(vTable).getData(Self, length);
end;

procedure IServerBlock.putData(status: IStatus; length: Cardinal; data: Pointer);
begin
  ServerBlockVTable(vTable).putData(Self, status, length, data);
  FbException.checkException(status);
end;

function IServerBlock.newKey(status: IStatus): ICryptKey;
begin
  Result := ServerBlockVTable(vTable).newKey(Self, status);
  FbException.checkException(status);
end;

function IClientBlock.getLogin(): PAnsiChar;
begin
  Result := ClientBlockVTable(vTable).getLogin(Self);
end;

function IClientBlock.getPassword(): PAnsiChar;
begin
  Result := ClientBlockVTable(vTable).getPassword(Self);
end;

function IClientBlock.getData(length: CardinalPtr): BytePtr;
begin
  Result := ClientBlockVTable(vTable).getData(Self, length);
end;

procedure IClientBlock.putData(status: IStatus; length: Cardinal; data: Pointer);
begin
  ClientBlockVTable(vTable).putData(Self, status, length, data);
  FbException.checkException(status);
end;

function IClientBlock.newKey(status: IStatus): ICryptKey;
begin
  Result := ClientBlockVTable(vTable).newKey(Self, status);
  FbException.checkException(status);
end;

function IClientBlock.getAuthBlock(status: IStatus): IAuthBlock;
begin
  Result := ClientBlockVTable(vTable).getAuthBlock(Self, status);
  FbException.checkException(status);
end;

function IServer.authenticate(status: IStatus; sBlock: IServerBlock; writerInterface: IWriter): Integer;
begin
  Result := ServerVTable(vTable).authenticate(Self, status, sBlock, writerInterface);
  FbException.checkException(status);
end;

procedure IServer.setDbCryptCallback(status: IStatus; cryptCallback: ICryptKeyCallback);
begin
  ServerVTable(vTable).setDbCryptCallback(Self, status, cryptCallback);
  FbException.checkException(status);
end;

function IClient.authenticate(status: IStatus; cBlock: IClientBlock): Integer;
begin
  Result := ClientVTable(vTable).authenticate(Self, status, cBlock);
  FbException.checkException(status);
end;

function IUserField.entered(): Integer;
begin
  Result := UserFieldVTable(vTable).entered(Self);
end;

function IUserField.specified(): Integer;
begin
  Result := UserFieldVTable(vTable).specified(Self);
end;

procedure IUserField.setEntered(status: IStatus; newValue: Integer);
begin
  UserFieldVTable(vTable).setEntered(Self, status, newValue);
  FbException.checkException(status);
end;

function ICharUserField.get(): PAnsiChar;
begin
  Result := CharUserFieldVTable(vTable).get(Self);
end;

procedure ICharUserField.set_(status: IStatus; newValue: PAnsiChar);
begin
  CharUserFieldVTable(vTable).set_(Self, status, newValue);
  FbException.checkException(status);
end;

function IIntUserField.get(): Integer;
begin
  Result := IntUserFieldVTable(vTable).get(Self);
end;

procedure IIntUserField.set_(status: IStatus; newValue: Integer);
begin
  IntUserFieldVTable(vTable).set_(Self, status, newValue);
  FbException.checkException(status);
end;

function IUser.operation(): Cardinal;
begin
  Result := UserVTable(vTable).operation(Self);
end;

function IUser.userName(): ICharUserField;
begin
  Result := UserVTable(vTable).userName(Self);
end;

function IUser.password(): ICharUserField;
begin
  Result := UserVTable(vTable).password(Self);
end;

function IUser.firstName(): ICharUserField;
begin
  Result := UserVTable(vTable).firstName(Self);
end;

function IUser.lastName(): ICharUserField;
begin
  Result := UserVTable(vTable).lastName(Self);
end;

function IUser.middleName(): ICharUserField;
begin
  Result := UserVTable(vTable).middleName(Self);
end;

function IUser.comment(): ICharUserField;
begin
  Result := UserVTable(vTable).comment(Self);
end;

function IUser.attributes(): ICharUserField;
begin
  Result := UserVTable(vTable).attributes(Self);
end;

function IUser.active(): IIntUserField;
begin
  Result := UserVTable(vTable).active(Self);
end;

function IUser.admin(): IIntUserField;
begin
  Result := UserVTable(vTable).admin(Self);
end;

procedure IUser.clear(status: IStatus);
begin
  UserVTable(vTable).clear(Self, status);
  FbException.checkException(status);
end;

procedure IListUsers.list(status: IStatus; user: IUser);
begin
  ListUsersVTable(vTable).list(Self, status, user);
  FbException.checkException(status);
end;

function ILogonInfo.name(): PAnsiChar;
begin
  Result := LogonInfoVTable(vTable).name(Self);
end;

function ILogonInfo.role(): PAnsiChar;
begin
  Result := LogonInfoVTable(vTable).role(Self);
end;

function ILogonInfo.networkProtocol(): PAnsiChar;
begin
  Result := LogonInfoVTable(vTable).networkProtocol(Self);
end;

function ILogonInfo.remoteAddress(): PAnsiChar;
begin
  Result := LogonInfoVTable(vTable).remoteAddress(Self);
end;

function ILogonInfo.authBlock(length: CardinalPtr): BytePtr;
begin
  Result := LogonInfoVTable(vTable).authBlock(Self, length);
end;

procedure IManagement.start(status: IStatus; logonInfo: ILogonInfo);
begin
  ManagementVTable(vTable).start(Self, status, logonInfo);
  FbException.checkException(status);
end;

function IManagement.execute(status: IStatus; user: IUser; callback: IListUsers): Integer;
begin
  Result := ManagementVTable(vTable).execute(Self, status, user, callback);
  FbException.checkException(status);
end;

procedure IManagement.commit(status: IStatus);
begin
  ManagementVTable(vTable).commit(Self, status);
  FbException.checkException(status);
end;

procedure IManagement.rollback(status: IStatus);
begin
  ManagementVTable(vTable).rollback(Self, status);
  FbException.checkException(status);
end;

function IAuthBlock.getType(): PAnsiChar;
begin
  Result := AuthBlockVTable(vTable).getType(Self);
end;

function IAuthBlock.getName(): PAnsiChar;
begin
  Result := AuthBlockVTable(vTable).getName(Self);
end;

function IAuthBlock.getPlugin(): PAnsiChar;
begin
  Result := AuthBlockVTable(vTable).getPlugin(Self);
end;

function IAuthBlock.getSecurityDb(): PAnsiChar;
begin
  Result := AuthBlockVTable(vTable).getSecurityDb(Self);
end;

function IAuthBlock.getOriginalPlugin(): PAnsiChar;
begin
  Result := AuthBlockVTable(vTable).getOriginalPlugin(Self);
end;

function IAuthBlock.next(status: IStatus): Boolean;
begin
  Result := AuthBlockVTable(vTable).next(Self, status);
  FbException.checkException(status);
end;

function IAuthBlock.first(status: IStatus): Boolean;
begin
  Result := AuthBlockVTable(vTable).first(Self, status);
  FbException.checkException(status);
end;

function IWireCryptPlugin.getKnownTypes(status: IStatus): PAnsiChar;
begin
  Result := WireCryptPluginVTable(vTable).getKnownTypes(Self, status);
  FbException.checkException(status);
end;

procedure IWireCryptPlugin.setKey(status: IStatus; key: ICryptKey);
begin
  WireCryptPluginVTable(vTable).setKey(Self, status, key);
  FbException.checkException(status);
end;

procedure IWireCryptPlugin.encrypt(status: IStatus; length: Cardinal; from: Pointer; to_: Pointer);
begin
  WireCryptPluginVTable(vTable).encrypt(Self, status, length, from, to_);
  FbException.checkException(status);
end;

procedure IWireCryptPlugin.decrypt(status: IStatus; length: Cardinal; from: Pointer; to_: Pointer);
begin
  WireCryptPluginVTable(vTable).decrypt(Self, status, length, from, to_);
  FbException.checkException(status);
end;

function ICryptKeyCallback.callback(dataLength: Cardinal; data: Pointer; bufferLength: Cardinal; buffer: Pointer): Cardinal;
begin
  Result := CryptKeyCallbackVTable(vTable).callback(Self, dataLength, data, bufferLength, buffer);
end;

function IKeyHolderPlugin.keyCallback(status: IStatus; callback: ICryptKeyCallback): Integer;
begin
  Result := KeyHolderPluginVTable(vTable).keyCallback(Self, status, callback);
  FbException.checkException(status);
end;

function IKeyHolderPlugin.keyHandle(status: IStatus; keyName: PAnsiChar): ICryptKeyCallback;
begin
  Result := KeyHolderPluginVTable(vTable).keyHandle(Self, status, keyName);
  FbException.checkException(status);
end;

function IKeyHolderPlugin.useOnlyOwnKeys(status: IStatus): Boolean;
begin
  Result := KeyHolderPluginVTable(vTable).useOnlyOwnKeys(Self, status);
  FbException.checkException(status);
end;

function IKeyHolderPlugin.chainHandle(status: IStatus): ICryptKeyCallback;
begin
  Result := KeyHolderPluginVTable(vTable).chainHandle(Self, status);
  FbException.checkException(status);
end;

function IDbCryptInfo.getDatabaseFullPath(status: IStatus): PAnsiChar;
begin
  Result := DbCryptInfoVTable(vTable).getDatabaseFullPath(Self, status);
  FbException.checkException(status);
end;

procedure IDbCryptPlugin.setKey(status: IStatus; length: Cardinal; sources: IKeyHolderPluginPtr; keyName: PAnsiChar);
begin
  DbCryptPluginVTable(vTable).setKey(Self, status, length, sources, keyName);
  FbException.checkException(status);
end;

procedure IDbCryptPlugin.encrypt(status: IStatus; length: Cardinal; from: Pointer; to_: Pointer);
begin
  DbCryptPluginVTable(vTable).encrypt(Self, status, length, from, to_);
  FbException.checkException(status);
end;

procedure IDbCryptPlugin.decrypt(status: IStatus; length: Cardinal; from: Pointer; to_: Pointer);
begin
  DbCryptPluginVTable(vTable).decrypt(Self, status, length, from, to_);
  FbException.checkException(status);
end;

procedure IDbCryptPlugin.setInfo(status: IStatus; info: IDbCryptInfo);
begin
  DbCryptPluginVTable(vTable).setInfo(Self, status, info);
  FbException.checkException(status);
end;

function IExternalContext.getMaster(): IMaster;
begin
  Result := ExternalContextVTable(vTable).getMaster(Self);
end;

function IExternalContext.getEngine(status: IStatus): IExternalEngine;
begin
  Result := ExternalContextVTable(vTable).getEngine(Self, status);
  FbException.checkException(status);
end;

function IExternalContext.getAttachment(status: IStatus): IAttachment;
begin
  Result := ExternalContextVTable(vTable).getAttachment(Self, status);
  FbException.checkException(status);
end;

function IExternalContext.getTransaction(status: IStatus): ITransaction;
begin
  Result := ExternalContextVTable(vTable).getTransaction(Self, status);
  FbException.checkException(status);
end;

function IExternalContext.getUserName(): PAnsiChar;
begin
  Result := ExternalContextVTable(vTable).getUserName(Self);
end;

function IExternalContext.getDatabaseName(): PAnsiChar;
begin
  Result := ExternalContextVTable(vTable).getDatabaseName(Self);
end;

function IExternalContext.getClientCharSet(): PAnsiChar;
begin
  Result := ExternalContextVTable(vTable).getClientCharSet(Self);
end;

function IExternalContext.obtainInfoCode(): Integer;
begin
  Result := ExternalContextVTable(vTable).obtainInfoCode(Self);
end;

function IExternalContext.getInfo(code: Integer): Pointer;
begin
  Result := ExternalContextVTable(vTable).getInfo(Self, code);
end;

function IExternalContext.setInfo(code: Integer; value: Pointer): Pointer;
begin
  Result := ExternalContextVTable(vTable).setInfo(Self, code, value);
end;

function IExternalResultSet.fetch(status: IStatus): Boolean;
begin
  Result := ExternalResultSetVTable(vTable).fetch(Self, status);
  FbException.checkException(status);
end;

procedure IExternalFunction.getCharSet(status: IStatus; context: IExternalContext; name: PAnsiChar; nameSize: Cardinal);
begin
  ExternalFunctionVTable(vTable).getCharSet(Self, status, context, name, nameSize);
  FbException.checkException(status);
end;

procedure IExternalFunction.execute(status: IStatus; context: IExternalContext; inMsg: Pointer; outMsg: Pointer);
begin
  ExternalFunctionVTable(vTable).execute(Self, status, context, inMsg, outMsg);
  FbException.checkException(status);
end;

procedure IExternalProcedure.getCharSet(status: IStatus; context: IExternalContext; name: PAnsiChar; nameSize: Cardinal);
begin
  ExternalProcedureVTable(vTable).getCharSet(Self, status, context, name, nameSize);
  FbException.checkException(status);
end;

function IExternalProcedure.open(status: IStatus; context: IExternalContext; inMsg: Pointer; outMsg: Pointer): IExternalResultSet;
begin
  Result := ExternalProcedureVTable(vTable).open(Self, status, context, inMsg, outMsg);
  FbException.checkException(status);
end;

procedure IExternalTrigger.getCharSet(status: IStatus; context: IExternalContext; name: PAnsiChar; nameSize: Cardinal);
begin
  ExternalTriggerVTable(vTable).getCharSet(Self, status, context, name, nameSize);
  FbException.checkException(status);
end;

procedure IExternalTrigger.execute(status: IStatus; context: IExternalContext; action: Cardinal; oldMsg: Pointer; newMsg: Pointer);
begin
  ExternalTriggerVTable(vTable).execute(Self, status, context, action, oldMsg, newMsg);
  FbException.checkException(status);
end;

function IRoutineMetadata.getPackage(status: IStatus): PAnsiChar;
begin
  Result := RoutineMetadataVTable(vTable).getPackage(Self, status);
  FbException.checkException(status);
end;

function IRoutineMetadata.getName(status: IStatus): PAnsiChar;
begin
  Result := RoutineMetadataVTable(vTable).getName(Self, status);
  FbException.checkException(status);
end;

function IRoutineMetadata.getEntryPoint(status: IStatus): PAnsiChar;
begin
  Result := RoutineMetadataVTable(vTable).getEntryPoint(Self, status);
  FbException.checkException(status);
end;

function IRoutineMetadata.getBody(status: IStatus): PAnsiChar;
begin
  Result := RoutineMetadataVTable(vTable).getBody(Self, status);
  FbException.checkException(status);
end;

function IRoutineMetadata.getInputMetadata(status: IStatus): IMessageMetadata;
begin
  Result := RoutineMetadataVTable(vTable).getInputMetadata(Self, status);
  FbException.checkException(status);
end;

function IRoutineMetadata.getOutputMetadata(status: IStatus): IMessageMetadata;
begin
  Result := RoutineMetadataVTable(vTable).getOutputMetadata(Self, status);
  FbException.checkException(status);
end;

function IRoutineMetadata.getTriggerMetadata(status: IStatus): IMessageMetadata;
begin
  Result := RoutineMetadataVTable(vTable).getTriggerMetadata(Self, status);
  FbException.checkException(status);
end;

function IRoutineMetadata.getTriggerTable(status: IStatus): PAnsiChar;
begin
  Result := RoutineMetadataVTable(vTable).getTriggerTable(Self, status);
  FbException.checkException(status);
end;

function IRoutineMetadata.getTriggerType(status: IStatus): Cardinal;
begin
  Result := RoutineMetadataVTable(vTable).getTriggerType(Self, status);
  FbException.checkException(status);
end;

procedure IExternalEngine.open(status: IStatus; context: IExternalContext; charSet: PAnsiChar; charSetSize: Cardinal);
begin
  ExternalEngineVTable(vTable).open(Self, status, context, charSet, charSetSize);
  FbException.checkException(status);
end;

procedure IExternalEngine.openAttachment(status: IStatus; context: IExternalContext);
begin
  ExternalEngineVTable(vTable).openAttachment(Self, status, context);
  FbException.checkException(status);
end;

procedure IExternalEngine.closeAttachment(status: IStatus; context: IExternalContext);
begin
  ExternalEngineVTable(vTable).closeAttachment(Self, status, context);
  FbException.checkException(status);
end;

function IExternalEngine.makeFunction(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata; inBuilder: IMetadataBuilder;
  outBuilder: IMetadataBuilder): IExternalFunction;
begin
  Result := ExternalEngineVTable(vTable).makeFunction(Self, status, context, metadata, inBuilder, outBuilder);
  FbException.checkException(status);
end;

function IExternalEngine.makeProcedure(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata; inBuilder: IMetadataBuilder;
  outBuilder: IMetadataBuilder): IExternalProcedure;
begin
  Result := ExternalEngineVTable(vTable).makeProcedure(Self, status, context, metadata, inBuilder, outBuilder);
  FbException.checkException(status);
end;

function IExternalEngine.makeTrigger(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata; fieldsBuilder: IMetadataBuilder)
  : IExternalTrigger;
begin
  Result := ExternalEngineVTable(vTable).makeTrigger(Self, status, context, metadata, fieldsBuilder);
  FbException.checkException(status);
end;

procedure ITimer.handler();
begin
  TimerVTable(vTable).handler(Self);
end;

procedure ITimerControl.start(status: IStatus; timer: ITimer; microSeconds: QWord);
begin
  TimerControlVTable(vTable).start(Self, status, timer, microSeconds);
  FbException.checkException(status);
end;

procedure ITimerControl.stop(status: IStatus; timer: ITimer);
begin
  TimerControlVTable(vTable).stop(Self, status, timer);
  FbException.checkException(status);
end;

procedure IVersionCallback.callback(status: IStatus; text: PAnsiChar);
begin
  VersionCallbackVTable(vTable).callback(Self, status, text);
  FbException.checkException(status);
end;

procedure IUtil.getFbVersion(status: IStatus; att: IAttachment; callback: IVersionCallback);
begin
  UtilVTable(vTable).getFbVersion(Self, status, att, callback);
  FbException.checkException(status);
end;

procedure IUtil.loadBlob(status: IStatus; blobId: ISC_QUADPtr; att: IAttachment; tra: ITransaction; file_: PAnsiChar; txt: Boolean);
begin
  UtilVTable(vTable).loadBlob(Self, status, blobId, att, tra, file_, txt);
  FbException.checkException(status);
end;

procedure IUtil.dumpBlob(status: IStatus; blobId: ISC_QUADPtr; att: IAttachment; tra: ITransaction; file_: PAnsiChar; txt: Boolean);
begin
  UtilVTable(vTable).dumpBlob(Self, status, blobId, att, tra, file_, txt);
  FbException.checkException(status);
end;

procedure IUtil.getPerfCounters(status: IStatus; att: IAttachment; countersSet: PAnsiChar; counters: Int64Ptr);
begin
  UtilVTable(vTable).getPerfCounters(Self, status, att, countersSet, counters);
  FbException.checkException(status);
end;

function IUtil.executeCreateDatabase(status: IStatus; stmtLength: Cardinal; creatDBstatement: PAnsiChar; dialect: Cardinal;
  stmtIsCreateDb: BooleanPtr): IAttachment;
begin
  Result := UtilVTable(vTable).executeCreateDatabase(Self, status, stmtLength, creatDBstatement, dialect, stmtIsCreateDb);
  FbException.checkException(status);
end;

procedure IUtil.decodeDate(date: ISC_DATE; year: CardinalPtr; month: CardinalPtr; day: CardinalPtr);
begin
  UtilVTable(vTable).decodeDate(Self, date, year, month, day);
end;

procedure IUtil.decodeTime(time: ISC_TIME; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr; fractions: CardinalPtr);
begin
  UtilVTable(vTable).decodeTime(Self, time, hours, minutes, seconds, fractions);
end;

function IUtil.encodeDate(year: Cardinal; month: Cardinal; day: Cardinal): ISC_DATE;
begin
  Result := UtilVTable(vTable).encodeDate(Self, year, month, day);
end;

function IUtil.encodeTime(hours: Cardinal; minutes: Cardinal; seconds: Cardinal; fractions: Cardinal): ISC_TIME;
begin
  Result := UtilVTable(vTable).encodeTime(Self, hours, minutes, seconds, fractions);
end;

function IUtil.formatStatus(buffer: PAnsiChar; bufferSize: Cardinal; status: IStatus): Cardinal;
begin
  Result := UtilVTable(vTable).formatStatus(Self, buffer, bufferSize, status);
end;

function IUtil.getClientVersion(): Cardinal;
begin
  Result := UtilVTable(vTable).getClientVersion(Self);
end;

function IUtil.getXpbBuilder(status: IStatus; kind: Cardinal; buf: BytePtr; len: Cardinal): IXpbBuilder;
begin
  Result := UtilVTable(vTable).getXpbBuilder(Self, status, kind, buf, len);
  FbException.checkException(status);
end;

function IUtil.setOffsets(status: IStatus; metadata: IMessageMetadata; callback: IOffsetsCallback): Cardinal;
begin
  Result := UtilVTable(vTable).setOffsets(Self, status, metadata, callback);
  FbException.checkException(status);
end;

procedure IOffsetsCallback.setOffset(status: IStatus; index: Cardinal; offset: Cardinal; nullOffset: Cardinal);
begin
  OffsetsCallbackVTable(vTable).setOffset(Self, status, index, offset, nullOffset);
  FbException.checkException(status);
end;

procedure IXpbBuilder.clear(status: IStatus);
begin
  XpbBuilderVTable(vTable).clear(Self, status);
  FbException.checkException(status);
end;

procedure IXpbBuilder.removeCurrent(status: IStatus);
begin
  XpbBuilderVTable(vTable).removeCurrent(Self, status);
  FbException.checkException(status);
end;

procedure IXpbBuilder.insertInt(status: IStatus; tag: Byte; value: Integer);
begin
  XpbBuilderVTable(vTable).insertInt(Self, status, tag, value);
  FbException.checkException(status);
end;

procedure IXpbBuilder.insertBigInt(status: IStatus; tag: Byte; value: Int64);
begin
  XpbBuilderVTable(vTable).insertBigInt(Self, status, tag, value);
  FbException.checkException(status);
end;

procedure IXpbBuilder.insertBytes(status: IStatus; tag: Byte; bytes: Pointer; length: Cardinal);
begin
  XpbBuilderVTable(vTable).insertBytes(Self, status, tag, bytes, length);
  FbException.checkException(status);
end;

procedure IXpbBuilder.insertString(status: IStatus; tag: Byte; str: PAnsiChar);
begin
  XpbBuilderVTable(vTable).insertString(Self, status, tag, str);
  FbException.checkException(status);
end;

procedure IXpbBuilder.insertTag(status: IStatus; tag: Byte);
begin
  XpbBuilderVTable(vTable).insertTag(Self, status, tag);
  FbException.checkException(status);
end;

function IXpbBuilder.isEof(status: IStatus): Boolean;
begin
  Result := XpbBuilderVTable(vTable).isEof(Self, status);
  FbException.checkException(status);
end;

procedure IXpbBuilder.moveNext(status: IStatus);
begin
  XpbBuilderVTable(vTable).moveNext(Self, status);
  FbException.checkException(status);
end;

procedure IXpbBuilder.rewind(status: IStatus);
begin
  XpbBuilderVTable(vTable).rewind(Self, status);
  FbException.checkException(status);
end;

function IXpbBuilder.findFirst(status: IStatus; tag: Byte): Boolean;
begin
  Result := XpbBuilderVTable(vTable).findFirst(Self, status, tag);
  FbException.checkException(status);
end;

function IXpbBuilder.findNext(status: IStatus): Boolean;
begin
  Result := XpbBuilderVTable(vTable).findNext(Self, status);
  FbException.checkException(status);
end;

function IXpbBuilder.getTag(status: IStatus): Byte;
begin
  Result := XpbBuilderVTable(vTable).getTag(Self, status);
  FbException.checkException(status);
end;

function IXpbBuilder.getLength(status: IStatus): Cardinal;
begin
  Result := XpbBuilderVTable(vTable).getLength(Self, status);
  FbException.checkException(status);
end;

function IXpbBuilder.getInt(status: IStatus): Integer;
begin
  Result := XpbBuilderVTable(vTable).getInt(Self, status);
  FbException.checkException(status);
end;

function IXpbBuilder.getBigInt(status: IStatus): Int64;
begin
  Result := XpbBuilderVTable(vTable).getBigInt(Self, status);
  FbException.checkException(status);
end;

function IXpbBuilder.getString(status: IStatus): PAnsiChar;
begin
  Result := XpbBuilderVTable(vTable).getString(Self, status);
  FbException.checkException(status);
end;

function IXpbBuilder.getBytes(status: IStatus): BytePtr;
begin
  Result := XpbBuilderVTable(vTable).getBytes(Self, status);
  FbException.checkException(status);
end;

function IXpbBuilder.getBufferLength(status: IStatus): Cardinal;
begin
  Result := XpbBuilderVTable(vTable).getBufferLength(Self, status);
  FbException.checkException(status);
end;

function IXpbBuilder.getBuffer(status: IStatus): BytePtr;
begin
  Result := XpbBuilderVTable(vTable).getBuffer(Self, status);
  FbException.checkException(status);
end;

function ITraceConnection.getKind(): Cardinal;
begin
  Result := TraceConnectionVTable(vTable).getKind(Self);
end;

function ITraceConnection.getProcessID(): Integer;
begin
  Result := TraceConnectionVTable(vTable).getProcessID(Self);
end;

function ITraceConnection.getUserName(): PAnsiChar;
begin
  Result := TraceConnectionVTable(vTable).getUserName(Self);
end;

function ITraceConnection.getRoleName(): PAnsiChar;
begin
  Result := TraceConnectionVTable(vTable).getRoleName(Self);
end;

function ITraceConnection.getCharSet(): PAnsiChar;
begin
  Result := TraceConnectionVTable(vTable).getCharSet(Self);
end;

function ITraceConnection.getRemoteProtocol(): PAnsiChar;
begin
  Result := TraceConnectionVTable(vTable).getRemoteProtocol(Self);
end;

function ITraceConnection.getRemoteAddress(): PAnsiChar;
begin
  Result := TraceConnectionVTable(vTable).getRemoteAddress(Self);
end;

function ITraceConnection.getRemoteProcessID(): Integer;
begin
  Result := TraceConnectionVTable(vTable).getRemoteProcessID(Self);
end;

function ITraceConnection.getRemoteProcessName(): PAnsiChar;
begin
  Result := TraceConnectionVTable(vTable).getRemoteProcessName(Self);
end;

function ITraceDatabaseConnection.getConnectionID(): Int64;
begin
  Result := TraceDatabaseConnectionVTable(vTable).getConnectionID(Self);
end;

function ITraceDatabaseConnection.getDatabaseName(): PAnsiChar;
begin
  Result := TraceDatabaseConnectionVTable(vTable).getDatabaseName(Self);
end;

function ITraceTransaction.getTransactionID(): Int64;
begin
  Result := TraceTransactionVTable(vTable).getTransactionID(Self);
end;

function ITraceTransaction.getReadOnly(): Boolean;
begin
  Result := TraceTransactionVTable(vTable).getReadOnly(Self);
end;

function ITraceTransaction.getWait(): Integer;
begin
  Result := TraceTransactionVTable(vTable).getWait(Self);
end;

function ITraceTransaction.getIsolation(): Cardinal;
begin
  Result := TraceTransactionVTable(vTable).getIsolation(Self);
end;

function ITraceTransaction.getPerf(): PerformanceInfoPtr;
begin
  Result := TraceTransactionVTable(vTable).getPerf(Self);
end;

function ITraceTransaction.getInitialID(): Int64;
begin
  Result := TraceTransactionVTable(vTable).getInitialID(Self);
end;

function ITraceTransaction.getPreviousID(): Int64;
begin
  Result := TraceTransactionVTable(vTable).getPreviousID(Self);
end;

function ITraceParams.getCount(): Cardinal;
begin
  Result := TraceParamsVTable(vTable).getCount(Self);
end;

function ITraceParams.getParam(idx: Cardinal): dscPtr;
begin
  Result := TraceParamsVTable(vTable).getParam(Self, idx);
end;

function ITraceParams.getTextUTF8(status: IStatus; idx: Cardinal): PAnsiChar;
begin
  Result := TraceParamsVTable(vTable).getTextUTF8(Self, status, idx);
  FbException.checkException(status);
end;

function ITraceStatement.getStmtID(): Int64;
begin
  Result := TraceStatementVTable(vTable).getStmtID(Self);
end;

function ITraceStatement.getPerf(): PerformanceInfoPtr;
begin
  Result := TraceStatementVTable(vTable).getPerf(Self);
end;

function ITraceSQLStatement.getText(): PAnsiChar;
begin
  Result := TraceSQLStatementVTable(vTable).getText(Self);
end;

function ITraceSQLStatement.getPlan(): PAnsiChar;
begin
  Result := TraceSQLStatementVTable(vTable).getPlan(Self);
end;

function ITraceSQLStatement.getInputs(): ITraceParams;
begin
  Result := TraceSQLStatementVTable(vTable).getInputs(Self);
end;

function ITraceSQLStatement.getTextUTF8(): PAnsiChar;
begin
  Result := TraceSQLStatementVTable(vTable).getTextUTF8(Self);
end;

function ITraceSQLStatement.getExplainedPlan(): PAnsiChar;
begin
  Result := TraceSQLStatementVTable(vTable).getExplainedPlan(Self);
end;

function ITraceBLRStatement.getData(): BytePtr;
begin
  Result := TraceBLRStatementVTable(vTable).getData(Self);
end;

function ITraceBLRStatement.getDataLength(): Cardinal;
begin
  Result := TraceBLRStatementVTable(vTable).getDataLength(Self);
end;

function ITraceBLRStatement.getText(): PAnsiChar;
begin
  Result := TraceBLRStatementVTable(vTable).getText(Self);
end;

function ITraceDYNRequest.getData(): BytePtr;
begin
  Result := TraceDYNRequestVTable(vTable).getData(Self);
end;

function ITraceDYNRequest.getDataLength(): Cardinal;
begin
  Result := TraceDYNRequestVTable(vTable).getDataLength(Self);
end;

function ITraceDYNRequest.getText(): PAnsiChar;
begin
  Result := TraceDYNRequestVTable(vTable).getText(Self);
end;

function ITraceContextVariable.getNameSpace(): PAnsiChar;
begin
  Result := TraceContextVariableVTable(vTable).getNameSpace(Self);
end;

function ITraceContextVariable.getVarName(): PAnsiChar;
begin
  Result := TraceContextVariableVTable(vTable).getVarName(Self);
end;

function ITraceContextVariable.getVarValue(): PAnsiChar;
begin
  Result := TraceContextVariableVTable(vTable).getVarValue(Self);
end;

function ITraceProcedure.getProcName(): PAnsiChar;
begin
  Result := TraceProcedureVTable(vTable).getProcName(Self);
end;

function ITraceProcedure.getInputs(): ITraceParams;
begin
  Result := TraceProcedureVTable(vTable).getInputs(Self);
end;

function ITraceProcedure.getPerf(): PerformanceInfoPtr;
begin
  Result := TraceProcedureVTable(vTable).getPerf(Self);
end;

function ITraceFunction.getFuncName(): PAnsiChar;
begin
  Result := TraceFunctionVTable(vTable).getFuncName(Self);
end;

function ITraceFunction.getInputs(): ITraceParams;
begin
  Result := TraceFunctionVTable(vTable).getInputs(Self);
end;

function ITraceFunction.getResult(): ITraceParams;
begin
  Result := TraceFunctionVTable(vTable).getResult(Self);
end;

function ITraceFunction.getPerf(): PerformanceInfoPtr;
begin
  Result := TraceFunctionVTable(vTable).getPerf(Self);
end;

function ITraceTrigger.getTriggerName(): PAnsiChar;
begin
  Result := TraceTriggerVTable(vTable).getTriggerName(Self);
end;

function ITraceTrigger.getRelationName(): PAnsiChar;
begin
  Result := TraceTriggerVTable(vTable).getRelationName(Self);
end;

function ITraceTrigger.getAction(): Integer;
begin
  Result := TraceTriggerVTable(vTable).getAction(Self);
end;

function ITraceTrigger.getWhich(): Integer;
begin
  Result := TraceTriggerVTable(vTable).getWhich(Self);
end;

function ITraceTrigger.getPerf(): PerformanceInfoPtr;
begin
  Result := TraceTriggerVTable(vTable).getPerf(Self);
end;

function ITraceServiceConnection.getServiceID(): Pointer;
begin
  Result := TraceServiceConnectionVTable(vTable).getServiceID(Self);
end;

function ITraceServiceConnection.getServiceMgr(): PAnsiChar;
begin
  Result := TraceServiceConnectionVTable(vTable).getServiceMgr(Self);
end;

function ITraceServiceConnection.getServiceName(): PAnsiChar;
begin
  Result := TraceServiceConnectionVTable(vTable).getServiceName(Self);
end;

function ITraceStatusVector.hasError(): Boolean;
begin
  Result := TraceStatusVectorVTable(vTable).hasError(Self);
end;

function ITraceStatusVector.hasWarning(): Boolean;
begin
  Result := TraceStatusVectorVTable(vTable).hasWarning(Self);
end;

function ITraceStatusVector.getStatus(): IStatus;
begin
  Result := TraceStatusVectorVTable(vTable).getStatus(Self);
end;

function ITraceStatusVector.getText(): PAnsiChar;
begin
  Result := TraceStatusVectorVTable(vTable).getText(Self);
end;

function ITraceSweepInfo.getOIT(): Int64;
begin
  Result := TraceSweepInfoVTable(vTable).getOIT(Self);
end;

function ITraceSweepInfo.getOST(): Int64;
begin
  Result := TraceSweepInfoVTable(vTable).getOST(Self);
end;

function ITraceSweepInfo.getOAT(): Int64;
begin
  Result := TraceSweepInfoVTable(vTable).getOAT(Self);
end;

function ITraceSweepInfo.getNext(): Int64;
begin
  Result := TraceSweepInfoVTable(vTable).getNext(Self);
end;

function ITraceSweepInfo.getPerf(): PerformanceInfoPtr;
begin
  Result := TraceSweepInfoVTable(vTable).getPerf(Self);
end;

function ITraceLogWriter.write(buf: Pointer; size: Cardinal): Cardinal;
begin
  Result := TraceLogWriterVTable(vTable).write(Self, buf, size);
end;

function ITraceLogWriter.write_s(status: IStatus; buf: Pointer; size: Cardinal): Cardinal;
begin
  Result := TraceLogWriterVTable(vTable).write_s(Self, status, buf, size);
  FbException.checkException(status);
end;

function ITraceInitInfo.getConfigText(): PAnsiChar;
begin
  Result := TraceInitInfoVTable(vTable).getConfigText(Self);
end;

function ITraceInitInfo.getTraceSessionID(): Integer;
begin
  Result := TraceInitInfoVTable(vTable).getTraceSessionID(Self);
end;

function ITraceInitInfo.getTraceSessionName(): PAnsiChar;
begin
  Result := TraceInitInfoVTable(vTable).getTraceSessionName(Self);
end;

function ITraceInitInfo.getFirebirdRootDirectory(): PAnsiChar;
begin
  Result := TraceInitInfoVTable(vTable).getFirebirdRootDirectory(Self);
end;

function ITraceInitInfo.getDatabaseName(): PAnsiChar;
begin
  Result := TraceInitInfoVTable(vTable).getDatabaseName(Self);
end;

function ITraceInitInfo.getConnection(): ITraceDatabaseConnection;
begin
  Result := TraceInitInfoVTable(vTable).getConnection(Self);
end;

function ITraceInitInfo.getLogWriter(): ITraceLogWriter;
begin
  Result := TraceInitInfoVTable(vTable).getLogWriter(Self);
end;

function ITracePlugin.trace_get_error(): PAnsiChar;
begin
  Result := TracePluginVTable(vTable).trace_get_error(Self);
end;

function ITracePlugin.trace_attach(connection: ITraceDatabaseConnection; create_db: Boolean; att_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_attach(Self, connection, create_db, att_result);
end;

function ITracePlugin.trace_detach(connection: ITraceDatabaseConnection; drop_db: Boolean): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_detach(Self, connection, drop_db);
end;

function ITracePlugin.trace_transaction_start(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; tpb_length: Cardinal;
  tpb: BytePtr; tra_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_transaction_start(Self, connection, transaction, tpb_length, tpb, tra_result);
end;

function ITracePlugin.trace_transaction_end(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; commit: Boolean;
  retain_context: Boolean; tra_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_transaction_end(Self, connection, transaction, commit, retain_context, tra_result);
end;

function ITracePlugin.trace_proc_execute(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; procedure_: ITraceProcedure;
  started: Boolean; proc_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_proc_execute(Self, connection, transaction, procedure_, started, proc_result);
end;

function ITracePlugin.trace_trigger_execute(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; trigger: ITraceTrigger;
  started: Boolean; trig_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_trigger_execute(Self, connection, transaction, trigger, started, trig_result);
end;

function ITracePlugin.trace_set_context(connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
  variable: ITraceContextVariable): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_set_context(Self, connection, transaction, variable);
end;

function ITracePlugin.trace_dsql_prepare(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; statement: ITraceSQLStatement;
  time_millis: Int64; req_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_dsql_prepare(Self, connection, transaction, statement, time_millis, req_result);
end;

function ITracePlugin.trace_dsql_free(connection: ITraceDatabaseConnection; statement: ITraceSQLStatement; option: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_dsql_free(Self, connection, statement, option);
end;

function ITracePlugin.trace_dsql_execute(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; statement: ITraceSQLStatement;
  started: Boolean; req_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_dsql_execute(Self, connection, transaction, statement, started, req_result);
end;

function ITracePlugin.trace_blr_compile(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; statement: ITraceBLRStatement;
  time_millis: Int64; req_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_blr_compile(Self, connection, transaction, statement, time_millis, req_result);
end;

function ITracePlugin.trace_blr_execute(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; statement: ITraceBLRStatement;
  req_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_blr_execute(Self, connection, transaction, statement, req_result);
end;

function ITracePlugin.trace_dyn_execute(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; request: ITraceDYNRequest;
  time_millis: Int64; req_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_dyn_execute(Self, connection, transaction, request, time_millis, req_result);
end;

function ITracePlugin.trace_service_attach(service: ITraceServiceConnection; att_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_service_attach(Self, service, att_result);
end;

function ITracePlugin.trace_service_start(service: ITraceServiceConnection; switches_length: Cardinal; switches: PAnsiChar;
  start_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_service_start(Self, service, switches_length, switches, start_result);
end;

function ITracePlugin.trace_service_query(service: ITraceServiceConnection; send_item_length: Cardinal; send_items: BytePtr;
  recv_item_length: Cardinal; recv_items: BytePtr; query_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_service_query(Self, service, send_item_length, send_items, recv_item_length, recv_items, query_result);
end;

function ITracePlugin.trace_service_detach(service: ITraceServiceConnection; detach_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_service_detach(Self, service, detach_result);
end;

function ITracePlugin.trace_event_error(connection: ITraceConnection; status: ITraceStatusVector; function_: PAnsiChar): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_event_error(Self, connection, status, function_);
end;

function ITracePlugin.trace_event_sweep(connection: ITraceDatabaseConnection; sweep: ITraceSweepInfo; sweep_state: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_event_sweep(Self, connection, sweep, sweep_state);
end;

function ITracePlugin.trace_func_execute(connection: ITraceDatabaseConnection; transaction: ITraceTransaction; function_: ITraceFunction;
  started: Boolean; func_result: Cardinal): Boolean;
begin
  Result := TracePluginVTable(vTable).trace_func_execute(Self, connection, transaction, function_, started, func_result);
end;

function ITraceFactory.trace_needs(): QWord;
begin
  Result := TraceFactoryVTable(vTable).trace_needs(Self);
end;

function ITraceFactory.trace_create(status: IStatus; init_info: ITraceInitInfo): ITracePlugin;
begin
  Result := TraceFactoryVTable(vTable).trace_create(Self, status, init_info);
  FbException.checkException(status);
end;

procedure IUdrFunctionFactory.setup(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata; inBuilder: IMetadataBuilder;
  outBuilder: IMetadataBuilder);
begin
  UdrFunctionFactoryVTable(vTable).setup(Self, status, context, metadata, inBuilder, outBuilder);
  FbException.checkException(status);
end;

function IUdrFunctionFactory.newItem(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata): IExternalFunction;
begin
  Result := UdrFunctionFactoryVTable(vTable).newItem(Self, status, context, metadata);
  FbException.checkException(status);
end;

procedure IUdrProcedureFactory.setup(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata; inBuilder: IMetadataBuilder;
  outBuilder: IMetadataBuilder);
begin
  UdrProcedureFactoryVTable(vTable).setup(Self, status, context, metadata, inBuilder, outBuilder);
  FbException.checkException(status);
end;

function IUdrProcedureFactory.newItem(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata): IExternalProcedure;
begin
  Result := UdrProcedureFactoryVTable(vTable).newItem(Self, status, context, metadata);
  FbException.checkException(status);
end;

procedure IUdrTriggerFactory.setup(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata; fieldsBuilder: IMetadataBuilder);
begin
  UdrTriggerFactoryVTable(vTable).setup(Self, status, context, metadata, fieldsBuilder);
  FbException.checkException(status);
end;

function IUdrTriggerFactory.newItem(status: IStatus; context: IExternalContext; metadata: IRoutineMetadata): IExternalTrigger;
begin
  Result := UdrTriggerFactoryVTable(vTable).newItem(Self, status, context, metadata);
  FbException.checkException(status);
end;

function IUdrPlugin.getMaster(): IMaster;
begin
  Result := UdrPluginVTable(vTable).getMaster(Self);
end;

procedure IUdrPlugin.registerFunction(status: IStatus; name: PAnsiChar; factory: IUdrFunctionFactory);
begin
  UdrPluginVTable(vTable).registerFunction(Self, status, name, factory);
  FbException.checkException(status);
end;

procedure IUdrPlugin.registerProcedure(status: IStatus; name: PAnsiChar; factory: IUdrProcedureFactory);
begin
  UdrPluginVTable(vTable).registerProcedure(Self, status, name, factory);
  FbException.checkException(status);
end;

procedure IUdrPlugin.registerTrigger(status: IStatus; name: PAnsiChar; factory: IUdrTriggerFactory);
begin
  UdrPluginVTable(vTable).registerTrigger(Self, status, name, factory);
  FbException.checkException(status);
end;

var
  IVersionedImpl_vTable: VersionedVTable;

constructor IVersionedImpl.create;
begin
  vTable := IVersionedImpl_vTable;
end;

procedure IReferenceCountedImpl_addRefDispatcher(this: IReferenceCounted); cdecl;
begin
  try
    IReferenceCountedImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IReferenceCountedImpl_releaseDispatcher(this: IReferenceCounted): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IReferenceCountedImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  IReferenceCountedImpl_vTable: ReferenceCountedVTable;

constructor IReferenceCountedImpl.create;
begin
  vTable := IReferenceCountedImpl_vTable;
end;

procedure IDisposableImpl_disposeDispatcher(this: IDisposable); cdecl;
begin
  try
    IDisposableImpl(this).dispose();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  IDisposableImpl_vTable: DisposableVTable;

constructor IDisposableImpl.create;
begin
  vTable := IDisposableImpl_vTable;
end;

procedure IStatusImpl_disposeDispatcher(this: IStatus); cdecl;
begin
  try
    IStatusImpl(this).dispose();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IStatusImpl_initDispatcher(this: IStatus); cdecl;
begin
  try
    IStatusImpl(this).init();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IStatusImpl_getStateDispatcher(this: IStatus): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := IStatusImpl(this).getState();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IStatusImpl_setErrors2Dispatcher(this: IStatus; length: Cardinal; value: NativeIntPtr); cdecl;
begin
  try
    IStatusImpl(this).setErrors2(length, value);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IStatusImpl_setWarnings2Dispatcher(this: IStatus; length: Cardinal; value: NativeIntPtr); cdecl;
begin
  try
    IStatusImpl(this).setWarnings2(length, value);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IStatusImpl_setErrorsDispatcher(this: IStatus; value: NativeIntPtr); cdecl;
begin
  try
    IStatusImpl(this).setErrors(value);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IStatusImpl_setWarningsDispatcher(this: IStatus; value: NativeIntPtr); cdecl;
begin
  try
    IStatusImpl(this).setWarnings(value);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IStatusImpl_getErrorsDispatcher(this: IStatus): NativeIntPtr; cdecl;
begin
  Result := nil;
  try
    Result := IStatusImpl(this).getErrors();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IStatusImpl_getWarningsDispatcher(this: IStatus): NativeIntPtr; cdecl;
begin
  Result := nil;
  try
    Result := IStatusImpl(this).getWarnings();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IStatusImpl_cloneDispatcher(this: IStatus): IStatus; cdecl;
begin
  Result := nil;
  try
    Result := IStatusImpl(this).clone();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  IStatusImpl_vTable: StatusVTable;

constructor IStatusImpl.create;
begin
  vTable := IStatusImpl_vTable;
end;

function IMasterImpl_getStatusDispatcher(this: IMaster): IStatus; cdecl;
begin
  Result := nil;
  try
    Result := IMasterImpl(this).getStatus();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IMasterImpl_getDispatcherDispatcher(this: IMaster): IProvider; cdecl;
begin
  Result := nil;
  try
    Result := IMasterImpl(this).getDispatcher();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IMasterImpl_getPluginManagerDispatcher(this: IMaster): IPluginManager; cdecl;
begin
  Result := nil;
  try
    Result := IMasterImpl(this).getPluginManager();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IMasterImpl_getTimerControlDispatcher(this: IMaster): ITimerControl; cdecl;
begin
  Result := nil;
  try
    Result := IMasterImpl(this).getTimerControl();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IMasterImpl_getDtcDispatcher(this: IMaster): IDtc; cdecl;
begin
  Result := nil;
  try
    Result := IMasterImpl(this).getDtc();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IMasterImpl_registerAttachmentDispatcher(this: IMaster; provider: IProvider; attachment: IAttachment): IAttachment; cdecl;
begin
  Result := nil;
  try
    Result := IMasterImpl(this).registerAttachment(provider, attachment);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IMasterImpl_registerTransactionDispatcher(this: IMaster; attachment: IAttachment; transaction: ITransaction): ITransaction; cdecl;
begin
  Result := nil;
  try
    Result := IMasterImpl(this).registerTransaction(attachment, transaction);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IMasterImpl_getMetadataBuilderDispatcher(this: IMaster; status: IStatus; fieldCount: Cardinal): IMetadataBuilder; cdecl;
begin
  Result := nil;
  try
    Result := IMasterImpl(this).getMetadataBuilder(status, fieldCount);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IMasterImpl_serverModeDispatcher(this: IMaster; mode: Integer): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IMasterImpl(this).serverMode(mode);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IMasterImpl_getUtilInterfaceDispatcher(this: IMaster): IUtil; cdecl;
begin
  Result := nil;
  try
    Result := IMasterImpl(this).getUtilInterface();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IMasterImpl_getConfigManagerDispatcher(this: IMaster): IConfigManager; cdecl;
begin
  Result := nil;
  try
    Result := IMasterImpl(this).getConfigManager();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IMasterImpl_getProcessExitingDispatcher(this: IMaster): Boolean; cdecl;
begin
  Result := False;
  try
    Result := IMasterImpl(this).getProcessExiting();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  IMasterImpl_vTable: MasterVTable;

constructor IMasterImpl.create;
begin
  vTable := IMasterImpl_vTable;
end;

procedure IPluginBaseImpl_addRefDispatcher(this: IPluginBase); cdecl;
begin
  try
    IPluginBaseImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IPluginBaseImpl_releaseDispatcher(this: IPluginBase): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IPluginBaseImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IPluginBaseImpl_setOwnerDispatcher(this: IPluginBase; r: IReferenceCounted); cdecl;
begin
  try
    IPluginBaseImpl(this).setOwner(r);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IPluginBaseImpl_getOwnerDispatcher(this: IPluginBase): IReferenceCounted; cdecl;
begin
  Result := nil;
  try
    Result := IPluginBaseImpl(this).getOwner();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  IPluginBaseImpl_vTable: PluginBaseVTable;

constructor IPluginBaseImpl.create;
begin
  vTable := IPluginBaseImpl_vTable;
end;

procedure IPluginSetImpl_addRefDispatcher(this: IPluginSet); cdecl;
begin
  try
    IPluginSetImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IPluginSetImpl_releaseDispatcher(this: IPluginSet): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IPluginSetImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IPluginSetImpl_getNameDispatcher(this: IPluginSet): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IPluginSetImpl(this).getName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IPluginSetImpl_getModuleNameDispatcher(this: IPluginSet): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IPluginSetImpl(this).getModuleName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IPluginSetImpl_getPluginDispatcher(this: IPluginSet; status: IStatus): IPluginBase; cdecl;
begin
  Result := nil;
  try
    Result := IPluginSetImpl(this).getPlugin(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IPluginSetImpl_nextDispatcher(this: IPluginSet; status: IStatus); cdecl;
begin
  try
    IPluginSetImpl(this).next(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IPluginSetImpl_set_Dispatcher(this: IPluginSet; status: IStatus; s: PAnsiChar); cdecl;
begin
  try
    IPluginSetImpl(this).set_(status, s);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IPluginSetImpl_vTable: PluginSetVTable;

constructor IPluginSetImpl.create;
begin
  vTable := IPluginSetImpl_vTable;
end;

procedure IConfigEntryImpl_addRefDispatcher(this: IConfigEntry); cdecl;
begin
  try
    IConfigEntryImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IConfigEntryImpl_releaseDispatcher(this: IConfigEntry): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IConfigEntryImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IConfigEntryImpl_getNameDispatcher(this: IConfigEntry): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IConfigEntryImpl(this).getName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IConfigEntryImpl_getValueDispatcher(this: IConfigEntry): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IConfigEntryImpl(this).getValue();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IConfigEntryImpl_getIntValueDispatcher(this: IConfigEntry): Int64; cdecl;
begin
  Result := 0;
  try
    Result := IConfigEntryImpl(this).getIntValue();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IConfigEntryImpl_getBoolValueDispatcher(this: IConfigEntry): Boolean; cdecl;
begin
  Result := False;
  try
    Result := IConfigEntryImpl(this).getBoolValue();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IConfigEntryImpl_getSubConfigDispatcher(this: IConfigEntry; status: IStatus): IConfig; cdecl;
begin
  Result := nil;
  try
    Result := IConfigEntryImpl(this).getSubConfig(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IConfigEntryImpl_vTable: ConfigEntryVTable;

constructor IConfigEntryImpl.create;
begin
  vTable := IConfigEntryImpl_vTable;
end;

procedure IConfigImpl_addRefDispatcher(this: IConfig); cdecl;
begin
  try
    IConfigImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IConfigImpl_releaseDispatcher(this: IConfig): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IConfigImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IConfigImpl_findDispatcher(this: IConfig; status: IStatus; name: PAnsiChar): IConfigEntry; cdecl;
begin
  Result := nil;
  try
    Result := IConfigImpl(this).find(status, name);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IConfigImpl_findValueDispatcher(this: IConfig; status: IStatus; name: PAnsiChar; value: PAnsiChar): IConfigEntry; cdecl;
begin
  Result := nil;
  try
    Result := IConfigImpl(this).findValue(status, name, value);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IConfigImpl_findPosDispatcher(this: IConfig; status: IStatus; name: PAnsiChar; pos: Cardinal): IConfigEntry; cdecl;
begin
  Result := nil;
  try
    Result := IConfigImpl(this).findPos(status, name, pos);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IConfigImpl_vTable: ConfigVTable;

constructor IConfigImpl.create;
begin
  vTable := IConfigImpl_vTable;
end;

procedure IFirebirdConfImpl_addRefDispatcher(this: IFirebirdConf); cdecl;
begin
  try
    IFirebirdConfImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IFirebirdConfImpl_releaseDispatcher(this: IFirebirdConf): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IFirebirdConfImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IFirebirdConfImpl_getKeyDispatcher(this: IFirebirdConf; name: PAnsiChar): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := IFirebirdConfImpl(this).getKey(name);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IFirebirdConfImpl_asIntegerDispatcher(this: IFirebirdConf; key: Cardinal): Int64; cdecl;
begin
  Result := 0;
  try
    Result := IFirebirdConfImpl(this).asInteger(key);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IFirebirdConfImpl_asStringDispatcher(this: IFirebirdConf; key: Cardinal): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IFirebirdConfImpl(this).asString(key);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IFirebirdConfImpl_asBooleanDispatcher(this: IFirebirdConf; key: Cardinal): Boolean; cdecl;
begin
  Result := False;
  try
    Result := IFirebirdConfImpl(this).asBoolean(key);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  IFirebirdConfImpl_vTable: FirebirdConfVTable;

constructor IFirebirdConfImpl.create;
begin
  vTable := IFirebirdConfImpl_vTable;
end;

procedure IPluginConfigImpl_addRefDispatcher(this: IPluginConfig); cdecl;
begin
  try
    IPluginConfigImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IPluginConfigImpl_releaseDispatcher(this: IPluginConfig): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IPluginConfigImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IPluginConfigImpl_getConfigFileNameDispatcher(this: IPluginConfig): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IPluginConfigImpl(this).getConfigFileName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IPluginConfigImpl_getDefaultConfigDispatcher(this: IPluginConfig; status: IStatus): IConfig; cdecl;
begin
  Result := nil;
  try
    Result := IPluginConfigImpl(this).getDefaultConfig(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IPluginConfigImpl_getFirebirdConfDispatcher(this: IPluginConfig; status: IStatus): IFirebirdConf; cdecl;
begin
  Result := nil;
  try
    Result := IPluginConfigImpl(this).getFirebirdConf(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IPluginConfigImpl_setReleaseDelayDispatcher(this: IPluginConfig; status: IStatus; microSeconds: QWord); cdecl;
begin
  try
    IPluginConfigImpl(this).setReleaseDelay(status, microSeconds);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IPluginConfigImpl_vTable: PluginConfigVTable;

constructor IPluginConfigImpl.create;
begin
  vTable := IPluginConfigImpl_vTable;
end;

function IPluginFactoryImpl_createPluginDispatcher(this: IPluginFactory; status: IStatus; factoryParameter: IPluginConfig): IPluginBase; cdecl;
begin
  Result := nil;
  try
    Result := IPluginFactoryImpl(this).createPlugin(status, factoryParameter);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IPluginFactoryImpl_vTable: PluginFactoryVTable;

constructor IPluginFactoryImpl.create;
begin
  vTable := IPluginFactoryImpl_vTable;
end;

procedure IPluginModuleImpl_doCleanDispatcher(this: IPluginModule); cdecl;
begin
  try
    IPluginModuleImpl(this).doClean();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IPluginModuleImpl_threadDetachDispatcher(this: IPluginModule); cdecl;
begin
  try
    IPluginModuleImpl(this).threadDetach();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  IPluginModuleImpl_vTable: PluginModuleVTable;

constructor IPluginModuleImpl.create;
begin
  vTable := IPluginModuleImpl_vTable;
end;

procedure IPluginManagerImpl_registerPluginFactoryDispatcher(this: IPluginManager; pluginType: Cardinal; defaultName: PAnsiChar;
  factory: IPluginFactory); cdecl;
begin
  try
    IPluginManagerImpl(this).registerPluginFactory(pluginType, defaultName, factory);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IPluginManagerImpl_registerModuleDispatcher(this: IPluginManager; cleanup: IPluginModule); cdecl;
begin
  try
    IPluginManagerImpl(this).registerModule(cleanup);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IPluginManagerImpl_unregisterModuleDispatcher(this: IPluginManager; cleanup: IPluginModule); cdecl;
begin
  try
    IPluginManagerImpl(this).unregisterModule(cleanup);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IPluginManagerImpl_getPluginsDispatcher(this: IPluginManager; status: IStatus; pluginType: Cardinal; namesList: PAnsiChar;
  firebirdConf: IFirebirdConf): IPluginSet; cdecl;
begin
  Result := nil;
  try
    Result := IPluginManagerImpl(this).getPlugins(status, pluginType, namesList, firebirdConf);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IPluginManagerImpl_getConfigDispatcher(this: IPluginManager; status: IStatus; filename: PAnsiChar): IConfig; cdecl;
begin
  Result := nil;
  try
    Result := IPluginManagerImpl(this).getConfig(status, filename);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IPluginManagerImpl_releasePluginDispatcher(this: IPluginManager; plugin: IPluginBase); cdecl;
begin
  try
    IPluginManagerImpl(this).releasePlugin(plugin);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  IPluginManagerImpl_vTable: PluginManagerVTable;

constructor IPluginManagerImpl.create;
begin
  vTable := IPluginManagerImpl_vTable;
end;

procedure ICryptKeyImpl_setSymmetricDispatcher(this: ICryptKey; status: IStatus; type_: PAnsiChar; keyLength: Cardinal; key: Pointer); cdecl;
begin
  try
    ICryptKeyImpl(this).setSymmetric(status, type_, keyLength, key);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure ICryptKeyImpl_setAsymmetricDispatcher(this: ICryptKey; status: IStatus; type_: PAnsiChar; encryptKeyLength: Cardinal; encryptKey: Pointer;
  decryptKeyLength: Cardinal; decryptKey: Pointer); cdecl;
begin
  try
    ICryptKeyImpl(this).setAsymmetric(status, type_, encryptKeyLength, encryptKey, decryptKeyLength, decryptKey);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function ICryptKeyImpl_getEncryptKeyDispatcher(this: ICryptKey; length: CardinalPtr): Pointer; cdecl;
begin
  Result := nil;
  try
    Result := ICryptKeyImpl(this).getEncryptKey(length);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ICryptKeyImpl_getDecryptKeyDispatcher(this: ICryptKey; length: CardinalPtr): Pointer; cdecl;
begin
  Result := nil;
  try
    Result := ICryptKeyImpl(this).getDecryptKey(length);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ICryptKeyImpl_vTable: CryptKeyVTable;

constructor ICryptKeyImpl.create;
begin
  vTable := ICryptKeyImpl_vTable;
end;

function IConfigManagerImpl_getDirectoryDispatcher(this: IConfigManager; code: Cardinal): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IConfigManagerImpl(this).getDirectory(code);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IConfigManagerImpl_getFirebirdConfDispatcher(this: IConfigManager): IFirebirdConf; cdecl;
begin
  Result := nil;
  try
    Result := IConfigManagerImpl(this).getFirebirdConf();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IConfigManagerImpl_getDatabaseConfDispatcher(this: IConfigManager; dbName: PAnsiChar): IFirebirdConf; cdecl;
begin
  Result := nil;
  try
    Result := IConfigManagerImpl(this).getDatabaseConf(dbName);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IConfigManagerImpl_getPluginConfigDispatcher(this: IConfigManager; configuredPlugin: PAnsiChar): IConfig; cdecl;
begin
  Result := nil;
  try
    Result := IConfigManagerImpl(this).getPluginConfig(configuredPlugin);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IConfigManagerImpl_getInstallDirectoryDispatcher(this: IConfigManager): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IConfigManagerImpl(this).getInstallDirectory();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IConfigManagerImpl_getRootDirectoryDispatcher(this: IConfigManager): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IConfigManagerImpl(this).getRootDirectory();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IConfigManagerImpl_getDefaultSecurityDbDispatcher(this: IConfigManager): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IConfigManagerImpl(this).getDefaultSecurityDb();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  IConfigManagerImpl_vTable: ConfigManagerVTable;

constructor IConfigManagerImpl.create;
begin
  vTable := IConfigManagerImpl_vTable;
end;

procedure IEventCallbackImpl_addRefDispatcher(this: IEventCallback); cdecl;
begin
  try
    IEventCallbackImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IEventCallbackImpl_releaseDispatcher(this: IEventCallback): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IEventCallbackImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IEventCallbackImpl_eventCallbackFunctionDispatcher(this: IEventCallback; length: Cardinal; events: BytePtr); cdecl;
begin
  try
    IEventCallbackImpl(this).eventCallbackFunction(length, events);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  IEventCallbackImpl_vTable: EventCallbackVTable;

constructor IEventCallbackImpl.create;
begin
  vTable := IEventCallbackImpl_vTable;
end;

procedure IBlobImpl_addRefDispatcher(this: IBlob); cdecl;
begin
  try
    IBlobImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IBlobImpl_releaseDispatcher(this: IBlob): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IBlobImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IBlobImpl_getInfoDispatcher(this: IBlob; status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
  buffer: BytePtr); cdecl;
begin
  try
    IBlobImpl(this).getInfo(status, itemsLength, items, bufferLength, buffer);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IBlobImpl_getSegmentDispatcher(this: IBlob; status: IStatus; bufferLength: Cardinal; buffer: Pointer; segmentLength: CardinalPtr)
  : Integer; cdecl;
begin
  Result := 0;
  try
    Result := IBlobImpl(this).getSegment(status, bufferLength, buffer, segmentLength);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IBlobImpl_putSegmentDispatcher(this: IBlob; status: IStatus; length: Cardinal; buffer: Pointer); cdecl;
begin
  try
    IBlobImpl(this).putSegment(status, length, buffer);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IBlobImpl_cancelDispatcher(this: IBlob; status: IStatus); cdecl;
begin
  try
    IBlobImpl(this).cancel(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IBlobImpl_closeDispatcher(this: IBlob; status: IStatus); cdecl;
begin
  try
    IBlobImpl(this).close(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IBlobImpl_seekDispatcher(this: IBlob; status: IStatus; mode: Integer; offset: Integer): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IBlobImpl(this).seek(status, mode, offset);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IBlobImpl_vTable: BlobVTable;

constructor IBlobImpl.create;
begin
  vTable := IBlobImpl_vTable;
end;

procedure ITransactionImpl_addRefDispatcher(this: ITransaction); cdecl;
begin
  try
    ITransactionImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITransactionImpl_releaseDispatcher(this: ITransaction): Integer; cdecl;
begin
  Result := 0;
  try
    Result := ITransactionImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure ITransactionImpl_getInfoDispatcher(this: ITransaction; status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
  buffer: BytePtr); cdecl;
begin
  try
    ITransactionImpl(this).getInfo(status, itemsLength, items, bufferLength, buffer);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure ITransactionImpl_prepareDispatcher(this: ITransaction; status: IStatus; msgLength: Cardinal; message: BytePtr); cdecl;
begin
  try
    ITransactionImpl(this).prepare(status, msgLength, message);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure ITransactionImpl_commitDispatcher(this: ITransaction; status: IStatus); cdecl;
begin
  try
    ITransactionImpl(this).commit(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure ITransactionImpl_commitRetainingDispatcher(this: ITransaction; status: IStatus); cdecl;
begin
  try
    ITransactionImpl(this).commitRetaining(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure ITransactionImpl_rollbackDispatcher(this: ITransaction; status: IStatus); cdecl;
begin
  try
    ITransactionImpl(this).rollback(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure ITransactionImpl_rollbackRetainingDispatcher(this: ITransaction; status: IStatus); cdecl;
begin
  try
    ITransactionImpl(this).rollbackRetaining(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure ITransactionImpl_disconnectDispatcher(this: ITransaction; status: IStatus); cdecl;
begin
  try
    ITransactionImpl(this).disconnect(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function ITransactionImpl_joinDispatcher(this: ITransaction; status: IStatus; transaction: ITransaction): ITransaction; cdecl;
begin
  Result := nil;
  try
    Result := ITransactionImpl(this).join(status, transaction);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function ITransactionImpl_validateDispatcher(this: ITransaction; status: IStatus; attachment: IAttachment): ITransaction; cdecl;
begin
  Result := nil;
  try
    Result := ITransactionImpl(this).validate(status, attachment);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function ITransactionImpl_enterDtcDispatcher(this: ITransaction; status: IStatus): ITransaction; cdecl;
begin
  Result := nil;
  try
    Result := ITransactionImpl(this).enterDtc(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  ITransactionImpl_vTable: TransactionVTable;

constructor ITransactionImpl.create;
begin
  vTable := ITransactionImpl_vTable;
end;

procedure IMessageMetadataImpl_addRefDispatcher(this: IMessageMetadata); cdecl;
begin
  try
    IMessageMetadataImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IMessageMetadataImpl_releaseDispatcher(this: IMessageMetadata): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IMessageMetadataImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IMessageMetadataImpl_getCountDispatcher(this: IMessageMetadata; status: IStatus): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := IMessageMetadataImpl(this).getCount(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IMessageMetadataImpl_getFieldDispatcher(this: IMessageMetadata; status: IStatus; index: Cardinal): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IMessageMetadataImpl(this).getField(status, index);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IMessageMetadataImpl_getRelationDispatcher(this: IMessageMetadata; status: IStatus; index: Cardinal): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IMessageMetadataImpl(this).getRelation(status, index);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IMessageMetadataImpl_getOwnerDispatcher(this: IMessageMetadata; status: IStatus; index: Cardinal): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IMessageMetadataImpl(this).getOwner(status, index);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IMessageMetadataImpl_getAliasDispatcher(this: IMessageMetadata; status: IStatus; index: Cardinal): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IMessageMetadataImpl(this).getAlias(status, index);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IMessageMetadataImpl_getTypeDispatcher(this: IMessageMetadata; status: IStatus; index: Cardinal): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := IMessageMetadataImpl(this).getType(status, index);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IMessageMetadataImpl_isNullableDispatcher(this: IMessageMetadata; status: IStatus; index: Cardinal): Boolean; cdecl;
begin
  Result := False;
  try
    Result := IMessageMetadataImpl(this).isNullable(status, index);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IMessageMetadataImpl_getSubTypeDispatcher(this: IMessageMetadata; status: IStatus; index: Cardinal): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IMessageMetadataImpl(this).getSubType(status, index);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IMessageMetadataImpl_getLengthDispatcher(this: IMessageMetadata; status: IStatus; index: Cardinal): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := IMessageMetadataImpl(this).getLength(status, index);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IMessageMetadataImpl_getScaleDispatcher(this: IMessageMetadata; status: IStatus; index: Cardinal): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IMessageMetadataImpl(this).getScale(status, index);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IMessageMetadataImpl_getCharSetDispatcher(this: IMessageMetadata; status: IStatus; index: Cardinal): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := IMessageMetadataImpl(this).getCharSet(status, index);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IMessageMetadataImpl_getOffsetDispatcher(this: IMessageMetadata; status: IStatus; index: Cardinal): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := IMessageMetadataImpl(this).getOffset(status, index);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IMessageMetadataImpl_getNullOffsetDispatcher(this: IMessageMetadata; status: IStatus; index: Cardinal): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := IMessageMetadataImpl(this).getNullOffset(status, index);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IMessageMetadataImpl_getBuilderDispatcher(this: IMessageMetadata; status: IStatus): IMetadataBuilder; cdecl;
begin
  Result := nil;
  try
    Result := IMessageMetadataImpl(this).getBuilder(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IMessageMetadataImpl_getMessageLengthDispatcher(this: IMessageMetadata; status: IStatus): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := IMessageMetadataImpl(this).getMessageLength(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IMessageMetadataImpl_vTable: MessageMetadataVTable;

constructor IMessageMetadataImpl.create;
begin
  vTable := IMessageMetadataImpl_vTable;
end;

procedure IMetadataBuilderImpl_addRefDispatcher(this: IMetadataBuilder); cdecl;
begin
  try
    IMetadataBuilderImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IMetadataBuilderImpl_releaseDispatcher(this: IMetadataBuilder): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IMetadataBuilderImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IMetadataBuilderImpl_setTypeDispatcher(this: IMetadataBuilder; status: IStatus; index: Cardinal; type_: Cardinal); cdecl;
begin
  try
    IMetadataBuilderImpl(this).setType(status, index, type_);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IMetadataBuilderImpl_setSubTypeDispatcher(this: IMetadataBuilder; status: IStatus; index: Cardinal; subType: Integer); cdecl;
begin
  try
    IMetadataBuilderImpl(this).setSubType(status, index, subType);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IMetadataBuilderImpl_setLengthDispatcher(this: IMetadataBuilder; status: IStatus; index: Cardinal; length: Cardinal); cdecl;
begin
  try
    IMetadataBuilderImpl(this).setLength(status, index, length);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IMetadataBuilderImpl_setCharSetDispatcher(this: IMetadataBuilder; status: IStatus; index: Cardinal; charSet: Cardinal); cdecl;
begin
  try
    IMetadataBuilderImpl(this).setCharSet(status, index, charSet);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IMetadataBuilderImpl_setScaleDispatcher(this: IMetadataBuilder; status: IStatus; index: Cardinal; scale: Integer); cdecl;
begin
  try
    IMetadataBuilderImpl(this).setScale(status, index, scale);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IMetadataBuilderImpl_truncateDispatcher(this: IMetadataBuilder; status: IStatus; count: Cardinal); cdecl;
begin
  try
    IMetadataBuilderImpl(this).truncate(status, count);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IMetadataBuilderImpl_moveNameToIndexDispatcher(this: IMetadataBuilder; status: IStatus; name: PAnsiChar; index: Cardinal); cdecl;
begin
  try
    IMetadataBuilderImpl(this).moveNameToIndex(status, name, index);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IMetadataBuilderImpl_removeDispatcher(this: IMetadataBuilder; status: IStatus; index: Cardinal); cdecl;
begin
  try
    IMetadataBuilderImpl(this).remove(status, index);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IMetadataBuilderImpl_addFieldDispatcher(this: IMetadataBuilder; status: IStatus): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := IMetadataBuilderImpl(this).addField(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IMetadataBuilderImpl_getMetadataDispatcher(this: IMetadataBuilder; status: IStatus): IMessageMetadata; cdecl;
begin
  Result := nil;
  try
    Result := IMetadataBuilderImpl(this).getMetadata(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IMetadataBuilderImpl_vTable: MetadataBuilderVTable;

constructor IMetadataBuilderImpl.create;
begin
  vTable := IMetadataBuilderImpl_vTable;
end;

procedure IResultSetImpl_addRefDispatcher(this: IResultSet); cdecl;
begin
  try
    IResultSetImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IResultSetImpl_releaseDispatcher(this: IResultSet): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IResultSetImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IResultSetImpl_fetchNextDispatcher(this: IResultSet; status: IStatus; message: Pointer): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IResultSetImpl(this).fetchNext(status, message);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IResultSetImpl_fetchPriorDispatcher(this: IResultSet; status: IStatus; message: Pointer): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IResultSetImpl(this).fetchPrior(status, message);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IResultSetImpl_fetchFirstDispatcher(this: IResultSet; status: IStatus; message: Pointer): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IResultSetImpl(this).fetchFirst(status, message);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IResultSetImpl_fetchLastDispatcher(this: IResultSet; status: IStatus; message: Pointer): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IResultSetImpl(this).fetchLast(status, message);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IResultSetImpl_fetchAbsoluteDispatcher(this: IResultSet; status: IStatus; position: Integer; message: Pointer): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IResultSetImpl(this).fetchAbsolute(status, position, message);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IResultSetImpl_fetchRelativeDispatcher(this: IResultSet; status: IStatus; offset: Integer; message: Pointer): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IResultSetImpl(this).fetchRelative(status, offset, message);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IResultSetImpl_isEofDispatcher(this: IResultSet; status: IStatus): Boolean; cdecl;
begin
  Result := False;
  try
    Result := IResultSetImpl(this).isEof(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IResultSetImpl_isBofDispatcher(this: IResultSet; status: IStatus): Boolean; cdecl;
begin
  Result := False;
  try
    Result := IResultSetImpl(this).isBof(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IResultSetImpl_getMetadataDispatcher(this: IResultSet; status: IStatus): IMessageMetadata; cdecl;
begin
  Result := nil;
  try
    Result := IResultSetImpl(this).getMetadata(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IResultSetImpl_closeDispatcher(this: IResultSet; status: IStatus); cdecl;
begin
  try
    IResultSetImpl(this).close(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IResultSetImpl_setDelayedOutputFormatDispatcher(this: IResultSet; status: IStatus; format: IMessageMetadata); cdecl;
begin
  try
    IResultSetImpl(this).setDelayedOutputFormat(status, format);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IResultSetImpl_vTable: ResultSetVTable;

constructor IResultSetImpl.create;
begin
  vTable := IResultSetImpl_vTable;
end;

procedure IStatementImpl_addRefDispatcher(this: IStatement); cdecl;
begin
  try
    IStatementImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IStatementImpl_releaseDispatcher(this: IStatement): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IStatementImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IStatementImpl_getInfoDispatcher(this: IStatement; status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
  buffer: BytePtr); cdecl;
begin
  try
    IStatementImpl(this).getInfo(status, itemsLength, items, bufferLength, buffer);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IStatementImpl_getTypeDispatcher(this: IStatement; status: IStatus): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := IStatementImpl(this).getType(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IStatementImpl_getPlanDispatcher(this: IStatement; status: IStatus; detailed: Boolean): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IStatementImpl(this).getPlan(status, detailed);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IStatementImpl_getAffectedRecordsDispatcher(this: IStatement; status: IStatus): QWord; cdecl;
begin
  Result := 0;
  try
    Result := IStatementImpl(this).getAffectedRecords(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IStatementImpl_getInputMetadataDispatcher(this: IStatement; status: IStatus): IMessageMetadata; cdecl;
begin
  Result := nil;
  try
    Result := IStatementImpl(this).getInputMetadata(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IStatementImpl_getOutputMetadataDispatcher(this: IStatement; status: IStatus): IMessageMetadata; cdecl;
begin
  Result := nil;
  try
    Result := IStatementImpl(this).getOutputMetadata(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IStatementImpl_executeDispatcher(this: IStatement; status: IStatus; transaction: ITransaction; inMetadata: IMessageMetadata;
  inBuffer: Pointer; outMetadata: IMessageMetadata; outBuffer: Pointer): ITransaction; cdecl;
begin
  Result := nil;
  try
    Result := IStatementImpl(this).execute(status, transaction, inMetadata, inBuffer, outMetadata, outBuffer);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IStatementImpl_openCursorDispatcher(this: IStatement; status: IStatus; transaction: ITransaction; inMetadata: IMessageMetadata;
  inBuffer: Pointer; outMetadata: IMessageMetadata; flags: Cardinal): IResultSet; cdecl;
begin
  Result := nil;
  try
    Result := IStatementImpl(this).openCursor(status, transaction, inMetadata, inBuffer, outMetadata, flags);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IStatementImpl_setCursorNameDispatcher(this: IStatement; status: IStatus; name: PAnsiChar); cdecl;
begin
  try
    IStatementImpl(this).setCursorName(status, name);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IStatementImpl_freeDispatcher(this: IStatement; status: IStatus); cdecl;
begin
  try
    IStatementImpl(this).free(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IStatementImpl_getFlagsDispatcher(this: IStatement; status: IStatus): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := IStatementImpl(this).getFlags(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IStatementImpl_vTable: StatementVTable;

constructor IStatementImpl.create;
begin
  vTable := IStatementImpl_vTable;
end;

procedure IRequestImpl_addRefDispatcher(this: IRequest); cdecl;
begin
  try
    IRequestImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IRequestImpl_releaseDispatcher(this: IRequest): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IRequestImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IRequestImpl_receiveDispatcher(this: IRequest; status: IStatus; level: Integer; msgType: Cardinal; length: Cardinal;
  message: BytePtr); cdecl;
begin
  try
    IRequestImpl(this).receive(status, level, msgType, length, message);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IRequestImpl_sendDispatcher(this: IRequest; status: IStatus; level: Integer; msgType: Cardinal; length: Cardinal; message: BytePtr); cdecl;
begin
  try
    IRequestImpl(this).send(status, level, msgType, length, message);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IRequestImpl_getInfoDispatcher(this: IRequest; status: IStatus; level: Integer; itemsLength: Cardinal; items: BytePtr;
  bufferLength: Cardinal; buffer: BytePtr); cdecl;
begin
  try
    IRequestImpl(this).getInfo(status, level, itemsLength, items, bufferLength, buffer);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IRequestImpl_startDispatcher(this: IRequest; status: IStatus; tra: ITransaction; level: Integer); cdecl;
begin
  try
    IRequestImpl(this).start(status, tra, level);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IRequestImpl_startAndSendDispatcher(this: IRequest; status: IStatus; tra: ITransaction; level: Integer; msgType: Cardinal; length: Cardinal;
  message: BytePtr); cdecl;
begin
  try
    IRequestImpl(this).startAndSend(status, tra, level, msgType, length, message);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IRequestImpl_unwindDispatcher(this: IRequest; status: IStatus; level: Integer); cdecl;
begin
  try
    IRequestImpl(this).unwind(status, level);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IRequestImpl_freeDispatcher(this: IRequest; status: IStatus); cdecl;
begin
  try
    IRequestImpl(this).free(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IRequestImpl_vTable: RequestVTable;

constructor IRequestImpl.create;
begin
  vTable := IRequestImpl_vTable;
end;

procedure IEventsImpl_addRefDispatcher(this: IEvents); cdecl;
begin
  try
    IEventsImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IEventsImpl_releaseDispatcher(this: IEvents): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IEventsImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IEventsImpl_cancelDispatcher(this: IEvents; status: IStatus); cdecl;
begin
  try
    IEventsImpl(this).cancel(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IEventsImpl_vTable: EventsVTable;

constructor IEventsImpl.create;
begin
  vTable := IEventsImpl_vTable;
end;

procedure IAttachmentImpl_addRefDispatcher(this: IAttachment); cdecl;
begin
  try
    IAttachmentImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IAttachmentImpl_releaseDispatcher(this: IAttachment): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IAttachmentImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IAttachmentImpl_getInfoDispatcher(this: IAttachment; status: IStatus; itemsLength: Cardinal; items: BytePtr; bufferLength: Cardinal;
  buffer: BytePtr); cdecl;
begin
  try
    IAttachmentImpl(this).getInfo(status, itemsLength, items, bufferLength, buffer);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IAttachmentImpl_startTransactionDispatcher(this: IAttachment; status: IStatus; tpbLength: Cardinal; tpb: BytePtr): ITransaction; cdecl;
begin
  Result := nil;
  try
    Result := IAttachmentImpl(this).startTransaction(status, tpbLength, tpb);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IAttachmentImpl_reconnectTransactionDispatcher(this: IAttachment; status: IStatus; length: Cardinal; id: BytePtr): ITransaction; cdecl;
begin
  Result := nil;
  try
    Result := IAttachmentImpl(this).reconnectTransaction(status, length, id);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IAttachmentImpl_compileRequestDispatcher(this: IAttachment; status: IStatus; blrLength: Cardinal; blr: BytePtr): IRequest; cdecl;
begin
  Result := nil;
  try
    Result := IAttachmentImpl(this).compileRequest(status, blrLength, blr);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IAttachmentImpl_transactRequestDispatcher(this: IAttachment; status: IStatus; transaction: ITransaction; blrLength: Cardinal; blr: BytePtr;
  inMsgLength: Cardinal; inMsg: BytePtr; outMsgLength: Cardinal; outMsg: BytePtr); cdecl;
begin
  try
    IAttachmentImpl(this).transactRequest(status, transaction, blrLength, blr, inMsgLength, inMsg, outMsgLength, outMsg);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IAttachmentImpl_createBlobDispatcher(this: IAttachment; status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; bpbLength: Cardinal;
  bpb: BytePtr): IBlob; cdecl;
begin
  Result := nil;
  try
    Result := IAttachmentImpl(this).createBlob(status, transaction, id, bpbLength, bpb);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IAttachmentImpl_openBlobDispatcher(this: IAttachment; status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; bpbLength: Cardinal;
  bpb: BytePtr): IBlob; cdecl;
begin
  Result := nil;
  try
    Result := IAttachmentImpl(this).openBlob(status, transaction, id, bpbLength, bpb);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IAttachmentImpl_getSliceDispatcher(this: IAttachment; status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; sdlLength: Cardinal;
  sdl: BytePtr; paramLength: Cardinal; param: BytePtr; sliceLength: Integer; slice: BytePtr): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IAttachmentImpl(this).getSlice(status, transaction, id, sdlLength, sdl, paramLength, param, sliceLength, slice);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IAttachmentImpl_putSliceDispatcher(this: IAttachment; status: IStatus; transaction: ITransaction; id: ISC_QUADPtr; sdlLength: Cardinal;
  sdl: BytePtr; paramLength: Cardinal; param: BytePtr; sliceLength: Integer; slice: BytePtr); cdecl;
begin
  try
    IAttachmentImpl(this).putSlice(status, transaction, id, sdlLength, sdl, paramLength, param, sliceLength, slice);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IAttachmentImpl_executeDynDispatcher(this: IAttachment; status: IStatus; transaction: ITransaction; length: Cardinal; dyn: BytePtr); cdecl;
begin
  try
    IAttachmentImpl(this).executeDyn(status, transaction, length, dyn);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IAttachmentImpl_prepareDispatcher(this: IAttachment; status: IStatus; tra: ITransaction; stmtLength: Cardinal; sqlStmt: PAnsiChar;
  dialect: Cardinal; flags: Cardinal): IStatement; cdecl;
begin
  Result := nil;
  try
    Result := IAttachmentImpl(this).prepare(status, tra, stmtLength, sqlStmt, dialect, flags);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IAttachmentImpl_executeDispatcher(this: IAttachment; status: IStatus; transaction: ITransaction; stmtLength: Cardinal; sqlStmt: PAnsiChar;
  dialect: Cardinal; inMetadata: IMessageMetadata; inBuffer: Pointer; outMetadata: IMessageMetadata; outBuffer: Pointer): ITransaction; cdecl;
begin
  Result := nil;
  try
    Result := IAttachmentImpl(this).execute(status, transaction, stmtLength, sqlStmt, dialect, inMetadata, inBuffer, outMetadata, outBuffer);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IAttachmentImpl_openCursorDispatcher(this: IAttachment; status: IStatus; transaction: ITransaction; stmtLength: Cardinal; sqlStmt: PAnsiChar;
  dialect: Cardinal; inMetadata: IMessageMetadata; inBuffer: Pointer; outMetadata: IMessageMetadata; cursorName: PAnsiChar; cursorFlags: Cardinal)
  : IResultSet; cdecl;
begin
  Result := nil;
  try
    Result := IAttachmentImpl(this).openCursor(status, transaction, stmtLength, sqlStmt, dialect, inMetadata, inBuffer, outMetadata, cursorName,
      cursorFlags);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IAttachmentImpl_queEventsDispatcher(this: IAttachment; status: IStatus; callback: IEventCallback; length: Cardinal; events: BytePtr)
  : IEvents; cdecl;
begin
  Result := nil;
  try
    Result := IAttachmentImpl(this).queEvents(status, callback, length, events);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IAttachmentImpl_cancelOperationDispatcher(this: IAttachment; status: IStatus; option: Integer); cdecl;
begin
  try
    IAttachmentImpl(this).cancelOperation(status, option);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IAttachmentImpl_pingDispatcher(this: IAttachment; status: IStatus); cdecl;
begin
  try
    IAttachmentImpl(this).ping(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IAttachmentImpl_detachDispatcher(this: IAttachment; status: IStatus); cdecl;
begin
  try
    IAttachmentImpl(this).detach(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IAttachmentImpl_dropDatabaseDispatcher(this: IAttachment; status: IStatus); cdecl;
begin
  try
    IAttachmentImpl(this).dropDatabase(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IAttachmentImpl_vTable: AttachmentVTable;

constructor IAttachmentImpl.create;
begin
  vTable := IAttachmentImpl_vTable;
end;

procedure IServiceImpl_addRefDispatcher(this: IService); cdecl;
begin
  try
    IServiceImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IServiceImpl_releaseDispatcher(this: IService): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IServiceImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IServiceImpl_detachDispatcher(this: IService; status: IStatus); cdecl;
begin
  try
    IServiceImpl(this).detach(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IServiceImpl_queryDispatcher(this: IService; status: IStatus; sendLength: Cardinal; sendItems: BytePtr; receiveLength: Cardinal;
  receiveItems: BytePtr; bufferLength: Cardinal; buffer: BytePtr); cdecl;
begin
  try
    IServiceImpl(this).query(status, sendLength, sendItems, receiveLength, receiveItems, bufferLength, buffer);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IServiceImpl_startDispatcher(this: IService; status: IStatus; spbLength: Cardinal; spb: BytePtr); cdecl;
begin
  try
    IServiceImpl(this).start(status, spbLength, spb);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IServiceImpl_vTable: ServiceVTable;

constructor IServiceImpl.create;
begin
  vTable := IServiceImpl_vTable;
end;

procedure IProviderImpl_addRefDispatcher(this: IProvider); cdecl;
begin
  try
    IProviderImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IProviderImpl_releaseDispatcher(this: IProvider): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IProviderImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IProviderImpl_setOwnerDispatcher(this: IProvider; r: IReferenceCounted); cdecl;
begin
  try
    IProviderImpl(this).setOwner(r);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IProviderImpl_getOwnerDispatcher(this: IProvider): IReferenceCounted; cdecl;
begin
  Result := nil;
  try
    Result := IProviderImpl(this).getOwner();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IProviderImpl_attachDatabaseDispatcher(this: IProvider; status: IStatus; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr)
  : IAttachment; cdecl;
begin
  Result := nil;
  try
    Result := IProviderImpl(this).attachDatabase(status, filename, dpbLength, dpb);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IProviderImpl_createDatabaseDispatcher(this: IProvider; status: IStatus; filename: PAnsiChar; dpbLength: Cardinal; dpb: BytePtr)
  : IAttachment; cdecl;
begin
  Result := nil;
  try
    Result := IProviderImpl(this).createDatabase(status, filename, dpbLength, dpb);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IProviderImpl_attachServiceManagerDispatcher(this: IProvider; status: IStatus; service: PAnsiChar; spbLength: Cardinal; spb: BytePtr)
  : IService; cdecl;
begin
  Result := nil;
  try
    Result := IProviderImpl(this).attachServiceManager(status, service, spbLength, spb);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IProviderImpl_shutdownDispatcher(this: IProvider; status: IStatus; timeout: Cardinal; reason: Integer); cdecl;
begin
  try
    IProviderImpl(this).shutdown(status, timeout, reason);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IProviderImpl_setDbCryptCallbackDispatcher(this: IProvider; status: IStatus; cryptCallback: ICryptKeyCallback); cdecl;
begin
  try
    IProviderImpl(this).setDbCryptCallback(status, cryptCallback);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IProviderImpl_vTable: ProviderVTable;

constructor IProviderImpl.create;
begin
  vTable := IProviderImpl_vTable;
end;

procedure IDtcStartImpl_disposeDispatcher(this: IDtcStart); cdecl;
begin
  try
    IDtcStartImpl(this).dispose();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IDtcStartImpl_addAttachmentDispatcher(this: IDtcStart; status: IStatus; att: IAttachment); cdecl;
begin
  try
    IDtcStartImpl(this).addAttachment(status, att);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IDtcStartImpl_addWithTpbDispatcher(this: IDtcStart; status: IStatus; att: IAttachment; length: Cardinal; tpb: BytePtr); cdecl;
begin
  try
    IDtcStartImpl(this).addWithTpb(status, att, length, tpb);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IDtcStartImpl_startDispatcher(this: IDtcStart; status: IStatus): ITransaction; cdecl;
begin
  Result := nil;
  try
    Result := IDtcStartImpl(this).start(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IDtcStartImpl_vTable: DtcStartVTable;

constructor IDtcStartImpl.create;
begin
  vTable := IDtcStartImpl_vTable;
end;

function IDtcImpl_joinDispatcher(this: IDtc; status: IStatus; one: ITransaction; two: ITransaction): ITransaction; cdecl;
begin
  Result := nil;
  try
    Result := IDtcImpl(this).join(status, one, two);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IDtcImpl_startBuilderDispatcher(this: IDtc; status: IStatus): IDtcStart; cdecl;
begin
  Result := nil;
  try
    Result := IDtcImpl(this).startBuilder(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IDtcImpl_vTable: DtcVTable;

constructor IDtcImpl.create;
begin
  vTable := IDtcImpl_vTable;
end;

procedure IAuthImpl_addRefDispatcher(this: IAuth); cdecl;
begin
  try
    IAuthImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IAuthImpl_releaseDispatcher(this: IAuth): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IAuthImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IAuthImpl_setOwnerDispatcher(this: IAuth; r: IReferenceCounted); cdecl;
begin
  try
    IAuthImpl(this).setOwner(r);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IAuthImpl_getOwnerDispatcher(this: IAuth): IReferenceCounted; cdecl;
begin
  Result := nil;
  try
    Result := IAuthImpl(this).getOwner();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  IAuthImpl_vTable: AuthVTable;

constructor IAuthImpl.create;
begin
  vTable := IAuthImpl_vTable;
end;

procedure IWriterImpl_resetDispatcher(this: IWriter); cdecl;
begin
  try
    IWriterImpl(this).reset();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IWriterImpl_addDispatcher(this: IWriter; status: IStatus; name: PAnsiChar); cdecl;
begin
  try
    IWriterImpl(this).add(status, name);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IWriterImpl_setTypeDispatcher(this: IWriter; status: IStatus; value: PAnsiChar); cdecl;
begin
  try
    IWriterImpl(this).setType(status, value);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IWriterImpl_setDbDispatcher(this: IWriter; status: IStatus; value: PAnsiChar); cdecl;
begin
  try
    IWriterImpl(this).setDb(status, value);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IWriterImpl_vTable: WriterVTable;

constructor IWriterImpl.create;
begin
  vTable := IWriterImpl_vTable;
end;

function IServerBlockImpl_getLoginDispatcher(this: IServerBlock): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IServerBlockImpl(this).getLogin();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IServerBlockImpl_getDataDispatcher(this: IServerBlock; length: CardinalPtr): BytePtr; cdecl;
begin
  Result := nil;
  try
    Result := IServerBlockImpl(this).getData(length);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IServerBlockImpl_putDataDispatcher(this: IServerBlock; status: IStatus; length: Cardinal; data: Pointer); cdecl;
begin
  try
    IServerBlockImpl(this).putData(status, length, data);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IServerBlockImpl_newKeyDispatcher(this: IServerBlock; status: IStatus): ICryptKey; cdecl;
begin
  Result := nil;
  try
    Result := IServerBlockImpl(this).newKey(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IServerBlockImpl_vTable: ServerBlockVTable;

constructor IServerBlockImpl.create;
begin
  vTable := IServerBlockImpl_vTable;
end;

procedure IClientBlockImpl_addRefDispatcher(this: IClientBlock); cdecl;
begin
  try
    IClientBlockImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IClientBlockImpl_releaseDispatcher(this: IClientBlock): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IClientBlockImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IClientBlockImpl_getLoginDispatcher(this: IClientBlock): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IClientBlockImpl(this).getLogin();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IClientBlockImpl_getPasswordDispatcher(this: IClientBlock): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IClientBlockImpl(this).getPassword();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IClientBlockImpl_getDataDispatcher(this: IClientBlock; length: CardinalPtr): BytePtr; cdecl;
begin
  Result := nil;
  try
    Result := IClientBlockImpl(this).getData(length);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IClientBlockImpl_putDataDispatcher(this: IClientBlock; status: IStatus; length: Cardinal; data: Pointer); cdecl;
begin
  try
    IClientBlockImpl(this).putData(status, length, data);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IClientBlockImpl_newKeyDispatcher(this: IClientBlock; status: IStatus): ICryptKey; cdecl;
begin
  Result := nil;
  try
    Result := IClientBlockImpl(this).newKey(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IClientBlockImpl_getAuthBlockDispatcher(this: IClientBlock; status: IStatus): IAuthBlock; cdecl;
begin
  Result := nil;
  try
    Result := IClientBlockImpl(this).getAuthBlock(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IClientBlockImpl_vTable: ClientBlockVTable;

constructor IClientBlockImpl.create;
begin
  vTable := IClientBlockImpl_vTable;
end;

procedure IServerImpl_addRefDispatcher(this: IServer); cdecl;
begin
  try
    IServerImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IServerImpl_releaseDispatcher(this: IServer): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IServerImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IServerImpl_setOwnerDispatcher(this: IServer; r: IReferenceCounted); cdecl;
begin
  try
    IServerImpl(this).setOwner(r);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IServerImpl_getOwnerDispatcher(this: IServer): IReferenceCounted; cdecl;
begin
  Result := nil;
  try
    Result := IServerImpl(this).getOwner();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IServerImpl_authenticateDispatcher(this: IServer; status: IStatus; sBlock: IServerBlock; writerInterface: IWriter): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IServerImpl(this).authenticate(status, sBlock, writerInterface);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IServerImpl_setDbCryptCallbackDispatcher(this: IServer; status: IStatus; cryptCallback: ICryptKeyCallback); cdecl;
begin
  try
    IServerImpl(this).setDbCryptCallback(status, cryptCallback);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IServerImpl_vTable: ServerVTable;

constructor IServerImpl.create;
begin
  vTable := IServerImpl_vTable;
end;

procedure IClientImpl_addRefDispatcher(this: IClient); cdecl;
begin
  try
    IClientImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IClientImpl_releaseDispatcher(this: IClient): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IClientImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IClientImpl_setOwnerDispatcher(this: IClient; r: IReferenceCounted); cdecl;
begin
  try
    IClientImpl(this).setOwner(r);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IClientImpl_getOwnerDispatcher(this: IClient): IReferenceCounted; cdecl;
begin
  Result := nil;
  try
    Result := IClientImpl(this).getOwner();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IClientImpl_authenticateDispatcher(this: IClient; status: IStatus; cBlock: IClientBlock): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IClientImpl(this).authenticate(status, cBlock);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IClientImpl_vTable: ClientVTable;

constructor IClientImpl.create;
begin
  vTable := IClientImpl_vTable;
end;

function IUserFieldImpl_enteredDispatcher(this: IUserField): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IUserFieldImpl(this).entered();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IUserFieldImpl_specifiedDispatcher(this: IUserField): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IUserFieldImpl(this).specified();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IUserFieldImpl_setEnteredDispatcher(this: IUserField; status: IStatus; newValue: Integer); cdecl;
begin
  try
    IUserFieldImpl(this).setEntered(status, newValue);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IUserFieldImpl_vTable: UserFieldVTable;

constructor IUserFieldImpl.create;
begin
  vTable := IUserFieldImpl_vTable;
end;

function ICharUserFieldImpl_enteredDispatcher(this: ICharUserField): Integer; cdecl;
begin
  Result := 0;
  try
    Result := ICharUserFieldImpl(this).entered();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ICharUserFieldImpl_specifiedDispatcher(this: ICharUserField): Integer; cdecl;
begin
  Result := 0;
  try
    Result := ICharUserFieldImpl(this).specified();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure ICharUserFieldImpl_setEnteredDispatcher(this: ICharUserField; status: IStatus; newValue: Integer); cdecl;
begin
  try
    ICharUserFieldImpl(this).setEntered(status, newValue);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function ICharUserFieldImpl_getDispatcher(this: ICharUserField): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ICharUserFieldImpl(this).get();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure ICharUserFieldImpl_set_Dispatcher(this: ICharUserField; status: IStatus; newValue: PAnsiChar); cdecl;
begin
  try
    ICharUserFieldImpl(this).set_(status, newValue);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  ICharUserFieldImpl_vTable: CharUserFieldVTable;

constructor ICharUserFieldImpl.create;
begin
  vTable := ICharUserFieldImpl_vTable;
end;

function IIntUserFieldImpl_enteredDispatcher(this: IIntUserField): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IIntUserFieldImpl(this).entered();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IIntUserFieldImpl_specifiedDispatcher(this: IIntUserField): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IIntUserFieldImpl(this).specified();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IIntUserFieldImpl_setEnteredDispatcher(this: IIntUserField; status: IStatus; newValue: Integer); cdecl;
begin
  try
    IIntUserFieldImpl(this).setEntered(status, newValue);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IIntUserFieldImpl_getDispatcher(this: IIntUserField): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IIntUserFieldImpl(this).get();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IIntUserFieldImpl_set_Dispatcher(this: IIntUserField; status: IStatus; newValue: Integer); cdecl;
begin
  try
    IIntUserFieldImpl(this).set_(status, newValue);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IIntUserFieldImpl_vTable: IntUserFieldVTable;

constructor IIntUserFieldImpl.create;
begin
  vTable := IIntUserFieldImpl_vTable;
end;

function IUserImpl_operationDispatcher(this: IUser): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := IUserImpl(this).operation();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IUserImpl_userNameDispatcher(this: IUser): ICharUserField; cdecl;
begin
  Result := nil;
  try
    Result := IUserImpl(this).userName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IUserImpl_passwordDispatcher(this: IUser): ICharUserField; cdecl;
begin
  Result := nil;
  try
    Result := IUserImpl(this).password();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IUserImpl_firstNameDispatcher(this: IUser): ICharUserField; cdecl;
begin
  Result := nil;
  try
    Result := IUserImpl(this).firstName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IUserImpl_lastNameDispatcher(this: IUser): ICharUserField; cdecl;
begin
  Result := nil;
  try
    Result := IUserImpl(this).lastName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IUserImpl_middleNameDispatcher(this: IUser): ICharUserField; cdecl;
begin
  Result := nil;
  try
    Result := IUserImpl(this).middleName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IUserImpl_commentDispatcher(this: IUser): ICharUserField; cdecl;
begin
  Result := nil;
  try
    Result := IUserImpl(this).comment();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IUserImpl_attributesDispatcher(this: IUser): ICharUserField; cdecl;
begin
  Result := nil;
  try
    Result := IUserImpl(this).attributes();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IUserImpl_activeDispatcher(this: IUser): IIntUserField; cdecl;
begin
  Result := nil;
  try
    Result := IUserImpl(this).active();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IUserImpl_adminDispatcher(this: IUser): IIntUserField; cdecl;
begin
  Result := nil;
  try
    Result := IUserImpl(this).admin();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IUserImpl_clearDispatcher(this: IUser; status: IStatus); cdecl;
begin
  try
    IUserImpl(this).clear(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IUserImpl_vTable: UserVTable;

constructor IUserImpl.create;
begin
  vTable := IUserImpl_vTable;
end;

procedure IListUsersImpl_listDispatcher(this: IListUsers; status: IStatus; user: IUser); cdecl;
begin
  try
    IListUsersImpl(this).list(status, user);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IListUsersImpl_vTable: ListUsersVTable;

constructor IListUsersImpl.create;
begin
  vTable := IListUsersImpl_vTable;
end;

function ILogonInfoImpl_nameDispatcher(this: ILogonInfo): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ILogonInfoImpl(this).name();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ILogonInfoImpl_roleDispatcher(this: ILogonInfo): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ILogonInfoImpl(this).role();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ILogonInfoImpl_networkProtocolDispatcher(this: ILogonInfo): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ILogonInfoImpl(this).networkProtocol();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ILogonInfoImpl_remoteAddressDispatcher(this: ILogonInfo): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ILogonInfoImpl(this).remoteAddress();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ILogonInfoImpl_authBlockDispatcher(this: ILogonInfo; length: CardinalPtr): BytePtr; cdecl;
begin
  Result := nil;
  try
    Result := ILogonInfoImpl(this).authBlock(length);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ILogonInfoImpl_vTable: LogonInfoVTable;

constructor ILogonInfoImpl.create;
begin
  vTable := ILogonInfoImpl_vTable;
end;

procedure IManagementImpl_addRefDispatcher(this: IManagement); cdecl;
begin
  try
    IManagementImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IManagementImpl_releaseDispatcher(this: IManagement): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IManagementImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IManagementImpl_setOwnerDispatcher(this: IManagement; r: IReferenceCounted); cdecl;
begin
  try
    IManagementImpl(this).setOwner(r);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IManagementImpl_getOwnerDispatcher(this: IManagement): IReferenceCounted; cdecl;
begin
  Result := nil;
  try
    Result := IManagementImpl(this).getOwner();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IManagementImpl_startDispatcher(this: IManagement; status: IStatus; logonInfo: ILogonInfo); cdecl;
begin
  try
    IManagementImpl(this).start(status, logonInfo);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IManagementImpl_executeDispatcher(this: IManagement; status: IStatus; user: IUser; callback: IListUsers): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IManagementImpl(this).execute(status, user, callback);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IManagementImpl_commitDispatcher(this: IManagement; status: IStatus); cdecl;
begin
  try
    IManagementImpl(this).commit(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IManagementImpl_rollbackDispatcher(this: IManagement; status: IStatus); cdecl;
begin
  try
    IManagementImpl(this).rollback(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IManagementImpl_vTable: ManagementVTable;

constructor IManagementImpl.create;
begin
  vTable := IManagementImpl_vTable;
end;

function IAuthBlockImpl_getTypeDispatcher(this: IAuthBlock): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IAuthBlockImpl(this).getType();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IAuthBlockImpl_getNameDispatcher(this: IAuthBlock): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IAuthBlockImpl(this).getName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IAuthBlockImpl_getPluginDispatcher(this: IAuthBlock): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IAuthBlockImpl(this).getPlugin();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IAuthBlockImpl_getSecurityDbDispatcher(this: IAuthBlock): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IAuthBlockImpl(this).getSecurityDb();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IAuthBlockImpl_getOriginalPluginDispatcher(this: IAuthBlock): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IAuthBlockImpl(this).getOriginalPlugin();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IAuthBlockImpl_nextDispatcher(this: IAuthBlock; status: IStatus): Boolean; cdecl;
begin
  Result := False;
  try
    Result := IAuthBlockImpl(this).next(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IAuthBlockImpl_firstDispatcher(this: IAuthBlock; status: IStatus): Boolean; cdecl;
begin
  Result := False;
  try
    Result := IAuthBlockImpl(this).first(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IAuthBlockImpl_vTable: AuthBlockVTable;

constructor IAuthBlockImpl.create;
begin
  vTable := IAuthBlockImpl_vTable;
end;

procedure IWireCryptPluginImpl_addRefDispatcher(this: IWireCryptPlugin); cdecl;
begin
  try
    IWireCryptPluginImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IWireCryptPluginImpl_releaseDispatcher(this: IWireCryptPlugin): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IWireCryptPluginImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IWireCryptPluginImpl_setOwnerDispatcher(this: IWireCryptPlugin; r: IReferenceCounted); cdecl;
begin
  try
    IWireCryptPluginImpl(this).setOwner(r);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IWireCryptPluginImpl_getOwnerDispatcher(this: IWireCryptPlugin): IReferenceCounted; cdecl;
begin
  Result := nil;
  try
    Result := IWireCryptPluginImpl(this).getOwner();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IWireCryptPluginImpl_getKnownTypesDispatcher(this: IWireCryptPlugin; status: IStatus): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IWireCryptPluginImpl(this).getKnownTypes(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IWireCryptPluginImpl_setKeyDispatcher(this: IWireCryptPlugin; status: IStatus; key: ICryptKey); cdecl;
begin
  try
    IWireCryptPluginImpl(this).setKey(status, key);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IWireCryptPluginImpl_encryptDispatcher(this: IWireCryptPlugin; status: IStatus; length: Cardinal; from: Pointer; to_: Pointer); cdecl;
begin
  try
    IWireCryptPluginImpl(this).encrypt(status, length, from, to_);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IWireCryptPluginImpl_decryptDispatcher(this: IWireCryptPlugin; status: IStatus; length: Cardinal; from: Pointer; to_: Pointer); cdecl;
begin
  try
    IWireCryptPluginImpl(this).decrypt(status, length, from, to_);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IWireCryptPluginImpl_vTable: WireCryptPluginVTable;

constructor IWireCryptPluginImpl.create;
begin
  vTable := IWireCryptPluginImpl_vTable;
end;

function ICryptKeyCallbackImpl_callbackDispatcher(this: ICryptKeyCallback; dataLength: Cardinal; data: Pointer; bufferLength: Cardinal;
  buffer: Pointer): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := ICryptKeyCallbackImpl(this).callback(dataLength, data, bufferLength, buffer);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ICryptKeyCallbackImpl_vTable: CryptKeyCallbackVTable;

constructor ICryptKeyCallbackImpl.create;
begin
  vTable := ICryptKeyCallbackImpl_vTable;
end;

procedure IKeyHolderPluginImpl_addRefDispatcher(this: IKeyHolderPlugin); cdecl;
begin
  try
    IKeyHolderPluginImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IKeyHolderPluginImpl_releaseDispatcher(this: IKeyHolderPlugin): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IKeyHolderPluginImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IKeyHolderPluginImpl_setOwnerDispatcher(this: IKeyHolderPlugin; r: IReferenceCounted); cdecl;
begin
  try
    IKeyHolderPluginImpl(this).setOwner(r);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IKeyHolderPluginImpl_getOwnerDispatcher(this: IKeyHolderPlugin): IReferenceCounted; cdecl;
begin
  Result := nil;
  try
    Result := IKeyHolderPluginImpl(this).getOwner();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IKeyHolderPluginImpl_keyCallbackDispatcher(this: IKeyHolderPlugin; status: IStatus; callback: ICryptKeyCallback): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IKeyHolderPluginImpl(this).keyCallback(status, callback);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IKeyHolderPluginImpl_keyHandleDispatcher(this: IKeyHolderPlugin; status: IStatus; keyName: PAnsiChar): ICryptKeyCallback; cdecl;
begin
  Result := nil;
  try
    Result := IKeyHolderPluginImpl(this).keyHandle(status, keyName);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IKeyHolderPluginImpl_useOnlyOwnKeysDispatcher(this: IKeyHolderPlugin; status: IStatus): Boolean; cdecl;
begin
  Result := False;
  try
    Result := IKeyHolderPluginImpl(this).useOnlyOwnKeys(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IKeyHolderPluginImpl_chainHandleDispatcher(this: IKeyHolderPlugin; status: IStatus): ICryptKeyCallback; cdecl;
begin
  Result := nil;
  try
    Result := IKeyHolderPluginImpl(this).chainHandle(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IKeyHolderPluginImpl_vTable: KeyHolderPluginVTable;

constructor IKeyHolderPluginImpl.create;
begin
  vTable := IKeyHolderPluginImpl_vTable;
end;

procedure IDbCryptInfoImpl_addRefDispatcher(this: IDbCryptInfo); cdecl;
begin
  try
    IDbCryptInfoImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IDbCryptInfoImpl_releaseDispatcher(this: IDbCryptInfo): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IDbCryptInfoImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IDbCryptInfoImpl_getDatabaseFullPathDispatcher(this: IDbCryptInfo; status: IStatus): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IDbCryptInfoImpl(this).getDatabaseFullPath(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IDbCryptInfoImpl_vTable: DbCryptInfoVTable;

constructor IDbCryptInfoImpl.create;
begin
  vTable := IDbCryptInfoImpl_vTable;
end;

procedure IDbCryptPluginImpl_addRefDispatcher(this: IDbCryptPlugin); cdecl;
begin
  try
    IDbCryptPluginImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IDbCryptPluginImpl_releaseDispatcher(this: IDbCryptPlugin): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IDbCryptPluginImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IDbCryptPluginImpl_setOwnerDispatcher(this: IDbCryptPlugin; r: IReferenceCounted); cdecl;
begin
  try
    IDbCryptPluginImpl(this).setOwner(r);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IDbCryptPluginImpl_getOwnerDispatcher(this: IDbCryptPlugin): IReferenceCounted; cdecl;
begin
  Result := nil;
  try
    Result := IDbCryptPluginImpl(this).getOwner();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IDbCryptPluginImpl_setKeyDispatcher(this: IDbCryptPlugin; status: IStatus; length: Cardinal; sources: IKeyHolderPluginPtr;
  keyName: PAnsiChar); cdecl;
begin
  try
    IDbCryptPluginImpl(this).setKey(status, length, sources, keyName);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IDbCryptPluginImpl_encryptDispatcher(this: IDbCryptPlugin; status: IStatus; length: Cardinal; from: Pointer; to_: Pointer); cdecl;
begin
  try
    IDbCryptPluginImpl(this).encrypt(status, length, from, to_);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IDbCryptPluginImpl_decryptDispatcher(this: IDbCryptPlugin; status: IStatus; length: Cardinal; from: Pointer; to_: Pointer); cdecl;
begin
  try
    IDbCryptPluginImpl(this).decrypt(status, length, from, to_);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IDbCryptPluginImpl_setInfoDispatcher(this: IDbCryptPlugin; status: IStatus; info: IDbCryptInfo); cdecl;
begin
  try
    IDbCryptPluginImpl(this).setInfo(status, info);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IDbCryptPluginImpl_vTable: DbCryptPluginVTable;

constructor IDbCryptPluginImpl.create;
begin
  vTable := IDbCryptPluginImpl_vTable;
end;

function IExternalContextImpl_getMasterDispatcher(this: IExternalContext): IMaster; cdecl;
begin
  Result := nil;
  try
    Result := IExternalContextImpl(this).getMaster();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IExternalContextImpl_getEngineDispatcher(this: IExternalContext; status: IStatus): IExternalEngine; cdecl;
begin
  Result := nil;
  try
    Result := IExternalContextImpl(this).getEngine(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IExternalContextImpl_getAttachmentDispatcher(this: IExternalContext; status: IStatus): IAttachment; cdecl;
begin
  Result := nil;
  try
    Result := IExternalContextImpl(this).getAttachment(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IExternalContextImpl_getTransactionDispatcher(this: IExternalContext; status: IStatus): ITransaction; cdecl;
begin
  Result := nil;
  try
    Result := IExternalContextImpl(this).getTransaction(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IExternalContextImpl_getUserNameDispatcher(this: IExternalContext): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IExternalContextImpl(this).getUserName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IExternalContextImpl_getDatabaseNameDispatcher(this: IExternalContext): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IExternalContextImpl(this).getDatabaseName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IExternalContextImpl_getClientCharSetDispatcher(this: IExternalContext): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IExternalContextImpl(this).getClientCharSet();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IExternalContextImpl_obtainInfoCodeDispatcher(this: IExternalContext): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IExternalContextImpl(this).obtainInfoCode();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IExternalContextImpl_getInfoDispatcher(this: IExternalContext; code: Integer): Pointer; cdecl;
begin
  Result := nil;
  try
    Result := IExternalContextImpl(this).getInfo(code);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IExternalContextImpl_setInfoDispatcher(this: IExternalContext; code: Integer; value: Pointer): Pointer; cdecl;
begin
  Result := nil;
  try
    Result := IExternalContextImpl(this).setInfo(code, value);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  IExternalContextImpl_vTable: ExternalContextVTable;

constructor IExternalContextImpl.create;
begin
  vTable := IExternalContextImpl_vTable;
end;

procedure IExternalResultSetImpl_disposeDispatcher(this: IExternalResultSet); cdecl;
begin
  try
    IExternalResultSetImpl(this).dispose();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IExternalResultSetImpl_fetchDispatcher(this: IExternalResultSet; status: IStatus): Boolean; cdecl;
begin
  Result := False;
  try
    Result := IExternalResultSetImpl(this).fetch(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IExternalResultSetImpl_vTable: ExternalResultSetVTable;

constructor IExternalResultSetImpl.create;
begin
  vTable := IExternalResultSetImpl_vTable;
end;

procedure IExternalFunctionImpl_disposeDispatcher(this: IExternalFunction); cdecl;
begin
  try
    IExternalFunctionImpl(this).dispose();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IExternalFunctionImpl_getCharSetDispatcher(this: IExternalFunction; status: IStatus; context: IExternalContext; name: PAnsiChar;
  nameSize: Cardinal); cdecl;
begin
  try
    IExternalFunctionImpl(this).getCharSet(status, context, name, nameSize);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IExternalFunctionImpl_executeDispatcher(this: IExternalFunction; status: IStatus; context: IExternalContext; inMsg: Pointer;
  outMsg: Pointer); cdecl;
begin
  try
    IExternalFunctionImpl(this).execute(status, context, inMsg, outMsg);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IExternalFunctionImpl_vTable: ExternalFunctionVTable;

constructor IExternalFunctionImpl.create;
begin
  vTable := IExternalFunctionImpl_vTable;
end;

procedure IExternalProcedureImpl_disposeDispatcher(this: IExternalProcedure); cdecl;
begin
  try
    IExternalProcedureImpl(this).dispose();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IExternalProcedureImpl_getCharSetDispatcher(this: IExternalProcedure; status: IStatus; context: IExternalContext; name: PAnsiChar;
  nameSize: Cardinal); cdecl;
begin
  try
    IExternalProcedureImpl(this).getCharSet(status, context, name, nameSize);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IExternalProcedureImpl_openDispatcher(this: IExternalProcedure; status: IStatus; context: IExternalContext; inMsg: Pointer; outMsg: Pointer)
  : IExternalResultSet; cdecl;
begin
  Result := nil;
  try
    Result := IExternalProcedureImpl(this).open(status, context, inMsg, outMsg);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IExternalProcedureImpl_vTable: ExternalProcedureVTable;

constructor IExternalProcedureImpl.create;
begin
  vTable := IExternalProcedureImpl_vTable;
end;

procedure IExternalTriggerImpl_disposeDispatcher(this: IExternalTrigger); cdecl;
begin
  try
    IExternalTriggerImpl(this).dispose();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IExternalTriggerImpl_getCharSetDispatcher(this: IExternalTrigger; status: IStatus; context: IExternalContext; name: PAnsiChar;
  nameSize: Cardinal); cdecl;
begin
  try
    IExternalTriggerImpl(this).getCharSet(status, context, name, nameSize);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IExternalTriggerImpl_executeDispatcher(this: IExternalTrigger; status: IStatus; context: IExternalContext; action: Cardinal;
  oldMsg: Pointer; newMsg: Pointer); cdecl;
begin
  try
    IExternalTriggerImpl(this).execute(status, context, action, oldMsg, newMsg);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IExternalTriggerImpl_vTable: ExternalTriggerVTable;

constructor IExternalTriggerImpl.create;
begin
  vTable := IExternalTriggerImpl_vTable;
end;

function IRoutineMetadataImpl_getPackageDispatcher(this: IRoutineMetadata; status: IStatus): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IRoutineMetadataImpl(this).getPackage(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IRoutineMetadataImpl_getNameDispatcher(this: IRoutineMetadata; status: IStatus): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IRoutineMetadataImpl(this).getName(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IRoutineMetadataImpl_getEntryPointDispatcher(this: IRoutineMetadata; status: IStatus): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IRoutineMetadataImpl(this).getEntryPoint(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IRoutineMetadataImpl_getBodyDispatcher(this: IRoutineMetadata; status: IStatus): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IRoutineMetadataImpl(this).getBody(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IRoutineMetadataImpl_getInputMetadataDispatcher(this: IRoutineMetadata; status: IStatus): IMessageMetadata; cdecl;
begin
  Result := nil;
  try
    Result := IRoutineMetadataImpl(this).getInputMetadata(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IRoutineMetadataImpl_getOutputMetadataDispatcher(this: IRoutineMetadata; status: IStatus): IMessageMetadata; cdecl;
begin
  Result := nil;
  try
    Result := IRoutineMetadataImpl(this).getOutputMetadata(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IRoutineMetadataImpl_getTriggerMetadataDispatcher(this: IRoutineMetadata; status: IStatus): IMessageMetadata; cdecl;
begin
  Result := nil;
  try
    Result := IRoutineMetadataImpl(this).getTriggerMetadata(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IRoutineMetadataImpl_getTriggerTableDispatcher(this: IRoutineMetadata; status: IStatus): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IRoutineMetadataImpl(this).getTriggerTable(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IRoutineMetadataImpl_getTriggerTypeDispatcher(this: IRoutineMetadata; status: IStatus): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := IRoutineMetadataImpl(this).getTriggerType(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IRoutineMetadataImpl_vTable: RoutineMetadataVTable;

constructor IRoutineMetadataImpl.create;
begin
  vTable := IRoutineMetadataImpl_vTable;
end;

procedure IExternalEngineImpl_addRefDispatcher(this: IExternalEngine); cdecl;
begin
  try
    IExternalEngineImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IExternalEngineImpl_releaseDispatcher(this: IExternalEngine): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IExternalEngineImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IExternalEngineImpl_setOwnerDispatcher(this: IExternalEngine; r: IReferenceCounted); cdecl;
begin
  try
    IExternalEngineImpl(this).setOwner(r);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IExternalEngineImpl_getOwnerDispatcher(this: IExternalEngine): IReferenceCounted; cdecl;
begin
  Result := nil;
  try
    Result := IExternalEngineImpl(this).getOwner();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IExternalEngineImpl_openDispatcher(this: IExternalEngine; status: IStatus; context: IExternalContext; charSet: PAnsiChar;
  charSetSize: Cardinal); cdecl;
begin
  try
    IExternalEngineImpl(this).open(status, context, charSet, charSetSize);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IExternalEngineImpl_openAttachmentDispatcher(this: IExternalEngine; status: IStatus; context: IExternalContext); cdecl;
begin
  try
    IExternalEngineImpl(this).openAttachment(status, context);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IExternalEngineImpl_closeAttachmentDispatcher(this: IExternalEngine; status: IStatus; context: IExternalContext); cdecl;
begin
  try
    IExternalEngineImpl(this).closeAttachment(status, context);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IExternalEngineImpl_makeFunctionDispatcher(this: IExternalEngine; status: IStatus; context: IExternalContext; metadata: IRoutineMetadata;
  inBuilder: IMetadataBuilder; outBuilder: IMetadataBuilder): IExternalFunction; cdecl;
begin
  Result := nil;
  try
    Result := IExternalEngineImpl(this).makeFunction(status, context, metadata, inBuilder, outBuilder);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IExternalEngineImpl_makeProcedureDispatcher(this: IExternalEngine; status: IStatus; context: IExternalContext; metadata: IRoutineMetadata;
  inBuilder: IMetadataBuilder; outBuilder: IMetadataBuilder): IExternalProcedure; cdecl;
begin
  Result := nil;
  try
    Result := IExternalEngineImpl(this).makeProcedure(status, context, metadata, inBuilder, outBuilder);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IExternalEngineImpl_makeTriggerDispatcher(this: IExternalEngine; status: IStatus; context: IExternalContext; metadata: IRoutineMetadata;
  fieldsBuilder: IMetadataBuilder): IExternalTrigger; cdecl;
begin
  Result := nil;
  try
    Result := IExternalEngineImpl(this).makeTrigger(status, context, metadata, fieldsBuilder);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IExternalEngineImpl_vTable: ExternalEngineVTable;

constructor IExternalEngineImpl.create;
begin
  vTable := IExternalEngineImpl_vTable;
end;

procedure ITimerImpl_addRefDispatcher(this: ITimer); cdecl;
begin
  try
    ITimerImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITimerImpl_releaseDispatcher(this: ITimer): Integer; cdecl;
begin
  Result := 0;
  try
    Result := ITimerImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure ITimerImpl_handlerDispatcher(this: ITimer); cdecl;
begin
  try
    ITimerImpl(this).handler();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ITimerImpl_vTable: TimerVTable;

constructor ITimerImpl.create;
begin
  vTable := ITimerImpl_vTable;
end;

procedure ITimerControlImpl_startDispatcher(this: ITimerControl; status: IStatus; timer: ITimer; microSeconds: QWord); cdecl;
begin
  try
    ITimerControlImpl(this).start(status, timer, microSeconds);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure ITimerControlImpl_stopDispatcher(this: ITimerControl; status: IStatus; timer: ITimer); cdecl;
begin
  try
    ITimerControlImpl(this).stop(status, timer);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  ITimerControlImpl_vTable: TimerControlVTable;

constructor ITimerControlImpl.create;
begin
  vTable := ITimerControlImpl_vTable;
end;

procedure IVersionCallbackImpl_callbackDispatcher(this: IVersionCallback; status: IStatus; text: PAnsiChar); cdecl;
begin
  try
    IVersionCallbackImpl(this).callback(status, text);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IVersionCallbackImpl_vTable: VersionCallbackVTable;

constructor IVersionCallbackImpl.create;
begin
  vTable := IVersionCallbackImpl_vTable;
end;

procedure IUtilImpl_getFbVersionDispatcher(this: IUtil; status: IStatus; att: IAttachment; callback: IVersionCallback); cdecl;
begin
  try
    IUtilImpl(this).getFbVersion(status, att, callback);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IUtilImpl_loadBlobDispatcher(this: IUtil; status: IStatus; blobId: ISC_QUADPtr; att: IAttachment; tra: ITransaction; file_: PAnsiChar;
  txt: Boolean); cdecl;
begin
  try
    IUtilImpl(this).loadBlob(status, blobId, att, tra, file_, txt);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IUtilImpl_dumpBlobDispatcher(this: IUtil; status: IStatus; blobId: ISC_QUADPtr; att: IAttachment; tra: ITransaction; file_: PAnsiChar;
  txt: Boolean); cdecl;
begin
  try
    IUtilImpl(this).dumpBlob(status, blobId, att, tra, file_, txt);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IUtilImpl_getPerfCountersDispatcher(this: IUtil; status: IStatus; att: IAttachment; countersSet: PAnsiChar; counters: Int64Ptr); cdecl;
begin
  try
    IUtilImpl(this).getPerfCounters(status, att, countersSet, counters);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IUtilImpl_executeCreateDatabaseDispatcher(this: IUtil; status: IStatus; stmtLength: Cardinal; creatDBstatement: PAnsiChar; dialect: Cardinal;
  stmtIsCreateDb: BooleanPtr): IAttachment; cdecl;
begin
  Result := nil;
  try
    Result := IUtilImpl(this).executeCreateDatabase(status, stmtLength, creatDBstatement, dialect, stmtIsCreateDb);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IUtilImpl_decodeDateDispatcher(this: IUtil; date: ISC_DATE; year: CardinalPtr; month: CardinalPtr; day: CardinalPtr); cdecl;
begin
  try
    IUtilImpl(this).decodeDate(date, year, month, day);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IUtilImpl_decodeTimeDispatcher(this: IUtil; time: ISC_TIME; hours: CardinalPtr; minutes: CardinalPtr; seconds: CardinalPtr;
  fractions: CardinalPtr); cdecl;
begin
  try
    IUtilImpl(this).decodeTime(time, hours, minutes, seconds, fractions);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IUtilImpl_encodeDateDispatcher(this: IUtil; year: Cardinal; month: Cardinal; day: Cardinal): ISC_DATE; cdecl;
begin
  Result := 0;
  try
    Result := IUtilImpl(this).encodeDate(year, month, day);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IUtilImpl_encodeTimeDispatcher(this: IUtil; hours: Cardinal; minutes: Cardinal; seconds: Cardinal; fractions: Cardinal): ISC_TIME; cdecl;
begin
  Result := 0;
  try
    Result := IUtilImpl(this).encodeTime(hours, minutes, seconds, fractions);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IUtilImpl_formatStatusDispatcher(this: IUtil; buffer: PAnsiChar; bufferSize: Cardinal; status: IStatus): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := IUtilImpl(this).formatStatus(buffer, bufferSize, status);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IUtilImpl_getClientVersionDispatcher(this: IUtil): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := IUtilImpl(this).getClientVersion();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function IUtilImpl_getXpbBuilderDispatcher(this: IUtil; status: IStatus; kind: Cardinal; buf: BytePtr; len: Cardinal): IXpbBuilder; cdecl;
begin
  Result := nil;
  try
    Result := IUtilImpl(this).getXpbBuilder(status, kind, buf, len);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IUtilImpl_setOffsetsDispatcher(this: IUtil; status: IStatus; metadata: IMessageMetadata; callback: IOffsetsCallback): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := IUtilImpl(this).setOffsets(status, metadata, callback);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IUtilImpl_vTable: UtilVTable;

constructor IUtilImpl.create;
begin
  vTable := IUtilImpl_vTable;
end;

procedure IOffsetsCallbackImpl_setOffsetDispatcher(this: IOffsetsCallback; status: IStatus; index: Cardinal; offset: Cardinal;
  nullOffset: Cardinal); cdecl;
begin
  try
    IOffsetsCallbackImpl(this).setOffset(status, index, offset, nullOffset);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IOffsetsCallbackImpl_vTable: OffsetsCallbackVTable;

constructor IOffsetsCallbackImpl.create;
begin
  vTable := IOffsetsCallbackImpl_vTable;
end;

procedure IXpbBuilderImpl_disposeDispatcher(this: IXpbBuilder); cdecl;
begin
  try
    IXpbBuilderImpl(this).dispose();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IXpbBuilderImpl_clearDispatcher(this: IXpbBuilder; status: IStatus); cdecl;
begin
  try
    IXpbBuilderImpl(this).clear(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IXpbBuilderImpl_removeCurrentDispatcher(this: IXpbBuilder; status: IStatus); cdecl;
begin
  try
    IXpbBuilderImpl(this).removeCurrent(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IXpbBuilderImpl_insertIntDispatcher(this: IXpbBuilder; status: IStatus; tag: Byte; value: Integer); cdecl;
begin
  try
    IXpbBuilderImpl(this).insertInt(status, tag, value);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IXpbBuilderImpl_insertBigIntDispatcher(this: IXpbBuilder; status: IStatus; tag: Byte; value: Int64); cdecl;
begin
  try
    IXpbBuilderImpl(this).insertBigInt(status, tag, value);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IXpbBuilderImpl_insertBytesDispatcher(this: IXpbBuilder; status: IStatus; tag: Byte; bytes: Pointer; length: Cardinal); cdecl;
begin
  try
    IXpbBuilderImpl(this).insertBytes(status, tag, bytes, length);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IXpbBuilderImpl_insertStringDispatcher(this: IXpbBuilder; status: IStatus; tag: Byte; str: PAnsiChar); cdecl;
begin
  try
    IXpbBuilderImpl(this).insertString(status, tag, str);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IXpbBuilderImpl_insertTagDispatcher(this: IXpbBuilder; status: IStatus; tag: Byte); cdecl;
begin
  try
    IXpbBuilderImpl(this).insertTag(status, tag);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IXpbBuilderImpl_isEofDispatcher(this: IXpbBuilder; status: IStatus): Boolean; cdecl;
begin
  Result := False;
  try
    Result := IXpbBuilderImpl(this).isEof(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IXpbBuilderImpl_moveNextDispatcher(this: IXpbBuilder; status: IStatus); cdecl;
begin
  try
    IXpbBuilderImpl(this).moveNext(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IXpbBuilderImpl_rewindDispatcher(this: IXpbBuilder; status: IStatus); cdecl;
begin
  try
    IXpbBuilderImpl(this).rewind(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IXpbBuilderImpl_findFirstDispatcher(this: IXpbBuilder; status: IStatus; tag: Byte): Boolean; cdecl;
begin
  Result := False;
  try
    Result := IXpbBuilderImpl(this).findFirst(status, tag);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IXpbBuilderImpl_findNextDispatcher(this: IXpbBuilder; status: IStatus): Boolean; cdecl;
begin
  Result := False;
  try
    Result := IXpbBuilderImpl(this).findNext(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IXpbBuilderImpl_getTagDispatcher(this: IXpbBuilder; status: IStatus): Byte; cdecl;
begin
  Result := 0;
  try
    Result := IXpbBuilderImpl(this).getTag(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IXpbBuilderImpl_getLengthDispatcher(this: IXpbBuilder; status: IStatus): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := IXpbBuilderImpl(this).getLength(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IXpbBuilderImpl_getIntDispatcher(this: IXpbBuilder; status: IStatus): Integer; cdecl;
begin
  Result := 0;
  try
    Result := IXpbBuilderImpl(this).getInt(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IXpbBuilderImpl_getBigIntDispatcher(this: IXpbBuilder; status: IStatus): Int64; cdecl;
begin
  Result := 0;
  try
    Result := IXpbBuilderImpl(this).getBigInt(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IXpbBuilderImpl_getStringDispatcher(this: IXpbBuilder; status: IStatus): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := IXpbBuilderImpl(this).getString(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IXpbBuilderImpl_getBytesDispatcher(this: IXpbBuilder; status: IStatus): BytePtr; cdecl;
begin
  Result := nil;
  try
    Result := IXpbBuilderImpl(this).getBytes(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IXpbBuilderImpl_getBufferLengthDispatcher(this: IXpbBuilder; status: IStatus): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := IXpbBuilderImpl(this).getBufferLength(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IXpbBuilderImpl_getBufferDispatcher(this: IXpbBuilder; status: IStatus): BytePtr; cdecl;
begin
  Result := nil;
  try
    Result := IXpbBuilderImpl(this).getBuffer(status);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IXpbBuilderImpl_vTable: XpbBuilderVTable;

constructor IXpbBuilderImpl.create;
begin
  vTable := IXpbBuilderImpl_vTable;
end;

function ITraceConnectionImpl_getKindDispatcher(this: ITraceConnection): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := ITraceConnectionImpl(this).getKind();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceConnectionImpl_getProcessIDDispatcher(this: ITraceConnection): Integer; cdecl;
begin
  Result := 0;
  try
    Result := ITraceConnectionImpl(this).getProcessID();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceConnectionImpl_getUserNameDispatcher(this: ITraceConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceConnectionImpl(this).getUserName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceConnectionImpl_getRoleNameDispatcher(this: ITraceConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceConnectionImpl(this).getRoleName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceConnectionImpl_getCharSetDispatcher(this: ITraceConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceConnectionImpl(this).getCharSet();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceConnectionImpl_getRemoteProtocolDispatcher(this: ITraceConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceConnectionImpl(this).getRemoteProtocol();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceConnectionImpl_getRemoteAddressDispatcher(this: ITraceConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceConnectionImpl(this).getRemoteAddress();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceConnectionImpl_getRemoteProcessIDDispatcher(this: ITraceConnection): Integer; cdecl;
begin
  Result := 0;
  try
    Result := ITraceConnectionImpl(this).getRemoteProcessID();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceConnectionImpl_getRemoteProcessNameDispatcher(this: ITraceConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceConnectionImpl(this).getRemoteProcessName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ITraceConnectionImpl_vTable: TraceConnectionVTable;

constructor ITraceConnectionImpl.create;
begin
  vTable := ITraceConnectionImpl_vTable;
end;

function ITraceDatabaseConnectionImpl_getKindDispatcher(this: ITraceDatabaseConnection): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := ITraceDatabaseConnectionImpl(this).getKind();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceDatabaseConnectionImpl_getProcessIDDispatcher(this: ITraceDatabaseConnection): Integer; cdecl;
begin
  Result := 0;
  try
    Result := ITraceDatabaseConnectionImpl(this).getProcessID();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceDatabaseConnectionImpl_getUserNameDispatcher(this: ITraceDatabaseConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceDatabaseConnectionImpl(this).getUserName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceDatabaseConnectionImpl_getRoleNameDispatcher(this: ITraceDatabaseConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceDatabaseConnectionImpl(this).getRoleName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceDatabaseConnectionImpl_getCharSetDispatcher(this: ITraceDatabaseConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceDatabaseConnectionImpl(this).getCharSet();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceDatabaseConnectionImpl_getRemoteProtocolDispatcher(this: ITraceDatabaseConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceDatabaseConnectionImpl(this).getRemoteProtocol();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceDatabaseConnectionImpl_getRemoteAddressDispatcher(this: ITraceDatabaseConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceDatabaseConnectionImpl(this).getRemoteAddress();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceDatabaseConnectionImpl_getRemoteProcessIDDispatcher(this: ITraceDatabaseConnection): Integer; cdecl;
begin
  Result := 0;
  try
    Result := ITraceDatabaseConnectionImpl(this).getRemoteProcessID();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceDatabaseConnectionImpl_getRemoteProcessNameDispatcher(this: ITraceDatabaseConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceDatabaseConnectionImpl(this).getRemoteProcessName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceDatabaseConnectionImpl_getConnectionIDDispatcher(this: ITraceDatabaseConnection): Int64; cdecl;
begin
  Result := 0;
  try
    Result := ITraceDatabaseConnectionImpl(this).getConnectionID();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceDatabaseConnectionImpl_getDatabaseNameDispatcher(this: ITraceDatabaseConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceDatabaseConnectionImpl(this).getDatabaseName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ITraceDatabaseConnectionImpl_vTable: TraceDatabaseConnectionVTable;

constructor ITraceDatabaseConnectionImpl.create;
begin
  vTable := ITraceDatabaseConnectionImpl_vTable;
end;

function ITraceTransactionImpl_getTransactionIDDispatcher(this: ITraceTransaction): Int64; cdecl;
begin
  Result := 0;
  try
    Result := ITraceTransactionImpl(this).getTransactionID();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceTransactionImpl_getReadOnlyDispatcher(this: ITraceTransaction): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITraceTransactionImpl(this).getReadOnly();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceTransactionImpl_getWaitDispatcher(this: ITraceTransaction): Integer; cdecl;
begin
  Result := 0;
  try
    Result := ITraceTransactionImpl(this).getWait();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceTransactionImpl_getIsolationDispatcher(this: ITraceTransaction): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := ITraceTransactionImpl(this).getIsolation();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceTransactionImpl_getPerfDispatcher(this: ITraceTransaction): PerformanceInfoPtr; cdecl;
begin
  Result := nil;
  try
    Result := ITraceTransactionImpl(this).getPerf();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceTransactionImpl_getInitialIDDispatcher(this: ITraceTransaction): Int64; cdecl;
begin
  Result := 0;
  try
    Result := ITraceTransactionImpl(this).getInitialID();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceTransactionImpl_getPreviousIDDispatcher(this: ITraceTransaction): Int64; cdecl;
begin
  Result := 0;
  try
    Result := ITraceTransactionImpl(this).getPreviousID();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ITraceTransactionImpl_vTable: TraceTransactionVTable;

constructor ITraceTransactionImpl.create;
begin
  vTable := ITraceTransactionImpl_vTable;
end;

function ITraceParamsImpl_getCountDispatcher(this: ITraceParams): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := ITraceParamsImpl(this).getCount();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceParamsImpl_getParamDispatcher(this: ITraceParams; idx: Cardinal): dscPtr; cdecl;
begin
  Result := nil;
  try
    Result := ITraceParamsImpl(this).getParam(idx);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceParamsImpl_getTextUTF8Dispatcher(this: ITraceParams; status: IStatus; idx: Cardinal): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceParamsImpl(this).getTextUTF8(status, idx);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  ITraceParamsImpl_vTable: TraceParamsVTable;

constructor ITraceParamsImpl.create;
begin
  vTable := ITraceParamsImpl_vTable;
end;

function ITraceStatementImpl_getStmtIDDispatcher(this: ITraceStatement): Int64; cdecl;
begin
  Result := 0;
  try
    Result := ITraceStatementImpl(this).getStmtID();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceStatementImpl_getPerfDispatcher(this: ITraceStatement): PerformanceInfoPtr; cdecl;
begin
  Result := nil;
  try
    Result := ITraceStatementImpl(this).getPerf();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ITraceStatementImpl_vTable: TraceStatementVTable;

constructor ITraceStatementImpl.create;
begin
  vTable := ITraceStatementImpl_vTable;
end;

function ITraceSQLStatementImpl_getStmtIDDispatcher(this: ITraceSQLStatement): Int64; cdecl;
begin
  Result := 0;
  try
    Result := ITraceSQLStatementImpl(this).getStmtID();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceSQLStatementImpl_getPerfDispatcher(this: ITraceSQLStatement): PerformanceInfoPtr; cdecl;
begin
  Result := nil;
  try
    Result := ITraceSQLStatementImpl(this).getPerf();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceSQLStatementImpl_getTextDispatcher(this: ITraceSQLStatement): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceSQLStatementImpl(this).getText();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceSQLStatementImpl_getPlanDispatcher(this: ITraceSQLStatement): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceSQLStatementImpl(this).getPlan();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceSQLStatementImpl_getInputsDispatcher(this: ITraceSQLStatement): ITraceParams; cdecl;
begin
  Result := nil;
  try
    Result := ITraceSQLStatementImpl(this).getInputs();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceSQLStatementImpl_getTextUTF8Dispatcher(this: ITraceSQLStatement): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceSQLStatementImpl(this).getTextUTF8();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceSQLStatementImpl_getExplainedPlanDispatcher(this: ITraceSQLStatement): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceSQLStatementImpl(this).getExplainedPlan();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ITraceSQLStatementImpl_vTable: TraceSQLStatementVTable;

constructor ITraceSQLStatementImpl.create;
begin
  vTable := ITraceSQLStatementImpl_vTable;
end;

function ITraceBLRStatementImpl_getStmtIDDispatcher(this: ITraceBLRStatement): Int64; cdecl;
begin
  Result := 0;
  try
    Result := ITraceBLRStatementImpl(this).getStmtID();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceBLRStatementImpl_getPerfDispatcher(this: ITraceBLRStatement): PerformanceInfoPtr; cdecl;
begin
  Result := nil;
  try
    Result := ITraceBLRStatementImpl(this).getPerf();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceBLRStatementImpl_getDataDispatcher(this: ITraceBLRStatement): BytePtr; cdecl;
begin
  Result := nil;
  try
    Result := ITraceBLRStatementImpl(this).getData();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceBLRStatementImpl_getDataLengthDispatcher(this: ITraceBLRStatement): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := ITraceBLRStatementImpl(this).getDataLength();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceBLRStatementImpl_getTextDispatcher(this: ITraceBLRStatement): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceBLRStatementImpl(this).getText();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ITraceBLRStatementImpl_vTable: TraceBLRStatementVTable;

constructor ITraceBLRStatementImpl.create;
begin
  vTable := ITraceBLRStatementImpl_vTable;
end;

function ITraceDYNRequestImpl_getDataDispatcher(this: ITraceDYNRequest): BytePtr; cdecl;
begin
  Result := nil;
  try
    Result := ITraceDYNRequestImpl(this).getData();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceDYNRequestImpl_getDataLengthDispatcher(this: ITraceDYNRequest): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := ITraceDYNRequestImpl(this).getDataLength();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceDYNRequestImpl_getTextDispatcher(this: ITraceDYNRequest): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceDYNRequestImpl(this).getText();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ITraceDYNRequestImpl_vTable: TraceDYNRequestVTable;

constructor ITraceDYNRequestImpl.create;
begin
  vTable := ITraceDYNRequestImpl_vTable;
end;

function ITraceContextVariableImpl_getNameSpaceDispatcher(this: ITraceContextVariable): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceContextVariableImpl(this).getNameSpace();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceContextVariableImpl_getVarNameDispatcher(this: ITraceContextVariable): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceContextVariableImpl(this).getVarName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceContextVariableImpl_getVarValueDispatcher(this: ITraceContextVariable): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceContextVariableImpl(this).getVarValue();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ITraceContextVariableImpl_vTable: TraceContextVariableVTable;

constructor ITraceContextVariableImpl.create;
begin
  vTable := ITraceContextVariableImpl_vTable;
end;

function ITraceProcedureImpl_getProcNameDispatcher(this: ITraceProcedure): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceProcedureImpl(this).getProcName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceProcedureImpl_getInputsDispatcher(this: ITraceProcedure): ITraceParams; cdecl;
begin
  Result := nil;
  try
    Result := ITraceProcedureImpl(this).getInputs();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceProcedureImpl_getPerfDispatcher(this: ITraceProcedure): PerformanceInfoPtr; cdecl;
begin
  Result := nil;
  try
    Result := ITraceProcedureImpl(this).getPerf();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ITraceProcedureImpl_vTable: TraceProcedureVTable;

constructor ITraceProcedureImpl.create;
begin
  vTable := ITraceProcedureImpl_vTable;
end;

function ITraceFunctionImpl_getFuncNameDispatcher(this: ITraceFunction): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceFunctionImpl(this).getFuncName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceFunctionImpl_getInputsDispatcher(this: ITraceFunction): ITraceParams; cdecl;
begin
  Result := nil;
  try
    Result := ITraceFunctionImpl(this).getInputs();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceFunctionImpl_getResultDispatcher(this: ITraceFunction): ITraceParams; cdecl;
begin
  Result := nil;
  try
    Result := ITraceFunctionImpl(this).getResult();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceFunctionImpl_getPerfDispatcher(this: ITraceFunction): PerformanceInfoPtr; cdecl;
begin
  Result := nil;
  try
    Result := ITraceFunctionImpl(this).getPerf();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ITraceFunctionImpl_vTable: TraceFunctionVTable;

constructor ITraceFunctionImpl.create;
begin
  vTable := ITraceFunctionImpl_vTable;
end;

function ITraceTriggerImpl_getTriggerNameDispatcher(this: ITraceTrigger): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceTriggerImpl(this).getTriggerName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceTriggerImpl_getRelationNameDispatcher(this: ITraceTrigger): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceTriggerImpl(this).getRelationName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceTriggerImpl_getActionDispatcher(this: ITraceTrigger): Integer; cdecl;
begin
  Result := 0;
  try
    Result := ITraceTriggerImpl(this).getAction();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceTriggerImpl_getWhichDispatcher(this: ITraceTrigger): Integer; cdecl;
begin
  Result := 0;
  try
    Result := ITraceTriggerImpl(this).getWhich();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceTriggerImpl_getPerfDispatcher(this: ITraceTrigger): PerformanceInfoPtr; cdecl;
begin
  Result := nil;
  try
    Result := ITraceTriggerImpl(this).getPerf();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ITraceTriggerImpl_vTable: TraceTriggerVTable;

constructor ITraceTriggerImpl.create;
begin
  vTable := ITraceTriggerImpl_vTable;
end;

function ITraceServiceConnectionImpl_getKindDispatcher(this: ITraceServiceConnection): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := ITraceServiceConnectionImpl(this).getKind();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceServiceConnectionImpl_getProcessIDDispatcher(this: ITraceServiceConnection): Integer; cdecl;
begin
  Result := 0;
  try
    Result := ITraceServiceConnectionImpl(this).getProcessID();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceServiceConnectionImpl_getUserNameDispatcher(this: ITraceServiceConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceServiceConnectionImpl(this).getUserName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceServiceConnectionImpl_getRoleNameDispatcher(this: ITraceServiceConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceServiceConnectionImpl(this).getRoleName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceServiceConnectionImpl_getCharSetDispatcher(this: ITraceServiceConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceServiceConnectionImpl(this).getCharSet();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceServiceConnectionImpl_getRemoteProtocolDispatcher(this: ITraceServiceConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceServiceConnectionImpl(this).getRemoteProtocol();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceServiceConnectionImpl_getRemoteAddressDispatcher(this: ITraceServiceConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceServiceConnectionImpl(this).getRemoteAddress();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceServiceConnectionImpl_getRemoteProcessIDDispatcher(this: ITraceServiceConnection): Integer; cdecl;
begin
  Result := 0;
  try
    Result := ITraceServiceConnectionImpl(this).getRemoteProcessID();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceServiceConnectionImpl_getRemoteProcessNameDispatcher(this: ITraceServiceConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceServiceConnectionImpl(this).getRemoteProcessName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceServiceConnectionImpl_getServiceIDDispatcher(this: ITraceServiceConnection): Pointer; cdecl;
begin
  Result := nil;
  try
    Result := ITraceServiceConnectionImpl(this).getServiceID();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceServiceConnectionImpl_getServiceMgrDispatcher(this: ITraceServiceConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceServiceConnectionImpl(this).getServiceMgr();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceServiceConnectionImpl_getServiceNameDispatcher(this: ITraceServiceConnection): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceServiceConnectionImpl(this).getServiceName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ITraceServiceConnectionImpl_vTable: TraceServiceConnectionVTable;

constructor ITraceServiceConnectionImpl.create;
begin
  vTable := ITraceServiceConnectionImpl_vTable;
end;

function ITraceStatusVectorImpl_hasErrorDispatcher(this: ITraceStatusVector): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITraceStatusVectorImpl(this).hasError();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceStatusVectorImpl_hasWarningDispatcher(this: ITraceStatusVector): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITraceStatusVectorImpl(this).hasWarning();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceStatusVectorImpl_getStatusDispatcher(this: ITraceStatusVector): IStatus; cdecl;
begin
  Result := nil;
  try
    Result := ITraceStatusVectorImpl(this).getStatus();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceStatusVectorImpl_getTextDispatcher(this: ITraceStatusVector): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceStatusVectorImpl(this).getText();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ITraceStatusVectorImpl_vTable: TraceStatusVectorVTable;

constructor ITraceStatusVectorImpl.create;
begin
  vTable := ITraceStatusVectorImpl_vTable;
end;

function ITraceSweepInfoImpl_getOITDispatcher(this: ITraceSweepInfo): Int64; cdecl;
begin
  Result := 0;
  try
    Result := ITraceSweepInfoImpl(this).getOIT();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceSweepInfoImpl_getOSTDispatcher(this: ITraceSweepInfo): Int64; cdecl;
begin
  Result := 0;
  try
    Result := ITraceSweepInfoImpl(this).getOST();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceSweepInfoImpl_getOATDispatcher(this: ITraceSweepInfo): Int64; cdecl;
begin
  Result := 0;
  try
    Result := ITraceSweepInfoImpl(this).getOAT();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceSweepInfoImpl_getNextDispatcher(this: ITraceSweepInfo): Int64; cdecl;
begin
  Result := 0;
  try
    Result := ITraceSweepInfoImpl(this).getNext();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceSweepInfoImpl_getPerfDispatcher(this: ITraceSweepInfo): PerformanceInfoPtr; cdecl;
begin
  Result := nil;
  try
    Result := ITraceSweepInfoImpl(this).getPerf();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ITraceSweepInfoImpl_vTable: TraceSweepInfoVTable;

constructor ITraceSweepInfoImpl.create;
begin
  vTable := ITraceSweepInfoImpl_vTable;
end;

procedure ITraceLogWriterImpl_addRefDispatcher(this: ITraceLogWriter); cdecl;
begin
  try
    ITraceLogWriterImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceLogWriterImpl_releaseDispatcher(this: ITraceLogWriter): Integer; cdecl;
begin
  Result := 0;
  try
    Result := ITraceLogWriterImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceLogWriterImpl_writeDispatcher(this: ITraceLogWriter; buf: Pointer; size: Cardinal): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := ITraceLogWriterImpl(this).write(buf, size);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceLogWriterImpl_write_sDispatcher(this: ITraceLogWriter; status: IStatus; buf: Pointer; size: Cardinal): Cardinal; cdecl;
begin
  Result := 0;
  try
    Result := ITraceLogWriterImpl(this).write_s(status, buf, size);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  ITraceLogWriterImpl_vTable: TraceLogWriterVTable;

constructor ITraceLogWriterImpl.create;
begin
  vTable := ITraceLogWriterImpl_vTable;
end;

function ITraceInitInfoImpl_getConfigTextDispatcher(this: ITraceInitInfo): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceInitInfoImpl(this).getConfigText();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceInitInfoImpl_getTraceSessionIDDispatcher(this: ITraceInitInfo): Integer; cdecl;
begin
  Result := 0;
  try
    Result := ITraceInitInfoImpl(this).getTraceSessionID();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceInitInfoImpl_getTraceSessionNameDispatcher(this: ITraceInitInfo): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceInitInfoImpl(this).getTraceSessionName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceInitInfoImpl_getFirebirdRootDirectoryDispatcher(this: ITraceInitInfo): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceInitInfoImpl(this).getFirebirdRootDirectory();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceInitInfoImpl_getDatabaseNameDispatcher(this: ITraceInitInfo): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITraceInitInfoImpl(this).getDatabaseName();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceInitInfoImpl_getConnectionDispatcher(this: ITraceInitInfo): ITraceDatabaseConnection; cdecl;
begin
  Result := nil;
  try
    Result := ITraceInitInfoImpl(this).getConnection();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceInitInfoImpl_getLogWriterDispatcher(this: ITraceInitInfo): ITraceLogWriter; cdecl;
begin
  Result := nil;
  try
    Result := ITraceInitInfoImpl(this).getLogWriter();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ITraceInitInfoImpl_vTable: TraceInitInfoVTable;

constructor ITraceInitInfoImpl.create;
begin
  vTable := ITraceInitInfoImpl_vTable;
end;

procedure ITracePluginImpl_addRefDispatcher(this: ITracePlugin); cdecl;
begin
  try
    ITracePluginImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_releaseDispatcher(this: ITracePlugin): Integer; cdecl;
begin
  Result := 0;
  try
    Result := ITracePluginImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_get_errorDispatcher(this: ITracePlugin): PAnsiChar; cdecl;
begin
  Result := nil;
  try
    Result := ITracePluginImpl(this).trace_get_error();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_attachDispatcher(this: ITracePlugin; connection: ITraceDatabaseConnection; create_db: Boolean; att_result: Cardinal)
  : Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_attach(connection, create_db, att_result);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_detachDispatcher(this: ITracePlugin; connection: ITraceDatabaseConnection; drop_db: Boolean): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_detach(connection, drop_db);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_transaction_startDispatcher(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
  tpb_length: Cardinal; tpb: BytePtr; tra_result: Cardinal): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_transaction_start(connection, transaction, tpb_length, tpb, tra_result);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_transaction_endDispatcher(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
  commit: Boolean; retain_context: Boolean; tra_result: Cardinal): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_transaction_end(connection, transaction, commit, retain_context, tra_result);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_proc_executeDispatcher(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
  procedure_: ITraceProcedure; started: Boolean; proc_result: Cardinal): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_proc_execute(connection, transaction, procedure_, started, proc_result);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_trigger_executeDispatcher(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
  trigger: ITraceTrigger; started: Boolean; trig_result: Cardinal): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_trigger_execute(connection, transaction, trigger, started, trig_result);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_set_contextDispatcher(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
  variable: ITraceContextVariable): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_set_context(connection, transaction, variable);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_dsql_prepareDispatcher(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
  statement: ITraceSQLStatement; time_millis: Int64; req_result: Cardinal): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_dsql_prepare(connection, transaction, statement, time_millis, req_result);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_dsql_freeDispatcher(this: ITracePlugin; connection: ITraceDatabaseConnection; statement: ITraceSQLStatement;
  option: Cardinal): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_dsql_free(connection, statement, option);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_dsql_executeDispatcher(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
  statement: ITraceSQLStatement; started: Boolean; req_result: Cardinal): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_dsql_execute(connection, transaction, statement, started, req_result);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_blr_compileDispatcher(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
  statement: ITraceBLRStatement; time_millis: Int64; req_result: Cardinal): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_blr_compile(connection, transaction, statement, time_millis, req_result);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_blr_executeDispatcher(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
  statement: ITraceBLRStatement; req_result: Cardinal): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_blr_execute(connection, transaction, statement, req_result);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_dyn_executeDispatcher(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
  request: ITraceDYNRequest; time_millis: Int64; req_result: Cardinal): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_dyn_execute(connection, transaction, request, time_millis, req_result);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_service_attachDispatcher(this: ITracePlugin; service: ITraceServiceConnection; att_result: Cardinal): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_service_attach(service, att_result);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_service_startDispatcher(this: ITracePlugin; service: ITraceServiceConnection; switches_length: Cardinal;
  switches: PAnsiChar; start_result: Cardinal): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_service_start(service, switches_length, switches, start_result);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_service_queryDispatcher(this: ITracePlugin; service: ITraceServiceConnection; send_item_length: Cardinal;
  send_items: BytePtr; recv_item_length: Cardinal; recv_items: BytePtr; query_result: Cardinal): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_service_query(service, send_item_length, send_items, recv_item_length, recv_items, query_result);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_service_detachDispatcher(this: ITracePlugin; service: ITraceServiceConnection; detach_result: Cardinal)
  : Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_service_detach(service, detach_result);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_event_errorDispatcher(this: ITracePlugin; connection: ITraceConnection; status: ITraceStatusVector;
  function_: PAnsiChar): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_event_error(connection, status, function_);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_event_sweepDispatcher(this: ITracePlugin; connection: ITraceDatabaseConnection; sweep: ITraceSweepInfo;
  sweep_state: Cardinal): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_event_sweep(connection, sweep, sweep_state);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITracePluginImpl_trace_func_executeDispatcher(this: ITracePlugin; connection: ITraceDatabaseConnection; transaction: ITraceTransaction;
  function_: ITraceFunction; started: Boolean; func_result: Cardinal): Boolean; cdecl;
begin
  Result := False;
  try
    Result := ITracePluginImpl(this).trace_func_execute(connection, transaction, function_, started, func_result);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

var
  ITracePluginImpl_vTable: TracePluginVTable;

constructor ITracePluginImpl.create;
begin
  vTable := ITracePluginImpl_vTable;
end;

procedure ITraceFactoryImpl_addRefDispatcher(this: ITraceFactory); cdecl;
begin
  try
    ITraceFactoryImpl(this).addRef();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceFactoryImpl_releaseDispatcher(this: ITraceFactory): Integer; cdecl;
begin
  Result := 0;
  try
    Result := ITraceFactoryImpl(this).release();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure ITraceFactoryImpl_setOwnerDispatcher(this: ITraceFactory; r: IReferenceCounted); cdecl;
begin
  try
    ITraceFactoryImpl(this).setOwner(r);
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceFactoryImpl_getOwnerDispatcher(this: ITraceFactory): IReferenceCounted; cdecl;
begin
  Result := nil;
  try
    Result := ITraceFactoryImpl(this).getOwner();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceFactoryImpl_trace_needsDispatcher(this: ITraceFactory): QWord; cdecl;
begin
  Result := 0;
  try
    Result := ITraceFactoryImpl(this).trace_needs();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

function ITraceFactoryImpl_trace_createDispatcher(this: ITraceFactory; status: IStatus; init_info: ITraceInitInfo): ITracePlugin; cdecl;
begin
  Result := nil;
  try
    Result := ITraceFactoryImpl(this).trace_create(status, init_info);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  ITraceFactoryImpl_vTable: TraceFactoryVTable;

constructor ITraceFactoryImpl.create;
begin
  vTable := ITraceFactoryImpl_vTable;
end;

procedure IUdrFunctionFactoryImpl_disposeDispatcher(this: IUdrFunctionFactory); cdecl;
begin
  try
    IUdrFunctionFactoryImpl(this).dispose();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IUdrFunctionFactoryImpl_setupDispatcher(this: IUdrFunctionFactory; status: IStatus; context: IExternalContext; metadata: IRoutineMetadata;
  inBuilder: IMetadataBuilder; outBuilder: IMetadataBuilder); cdecl;
begin
  try
    IUdrFunctionFactoryImpl(this).setup(status, context, metadata, inBuilder, outBuilder);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IUdrFunctionFactoryImpl_newItemDispatcher(this: IUdrFunctionFactory; status: IStatus; context: IExternalContext; metadata: IRoutineMetadata)
  : IExternalFunction; cdecl;
begin
  Result := nil;
  try
    Result := IUdrFunctionFactoryImpl(this).newItem(status, context, metadata);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IUdrFunctionFactoryImpl_vTable: UdrFunctionFactoryVTable;

constructor IUdrFunctionFactoryImpl.create;
begin
  vTable := IUdrFunctionFactoryImpl_vTable;
end;

procedure IUdrProcedureFactoryImpl_disposeDispatcher(this: IUdrProcedureFactory); cdecl;
begin
  try
    IUdrProcedureFactoryImpl(this).dispose();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IUdrProcedureFactoryImpl_setupDispatcher(this: IUdrProcedureFactory; status: IStatus; context: IExternalContext; metadata: IRoutineMetadata;
  inBuilder: IMetadataBuilder; outBuilder: IMetadataBuilder); cdecl;
begin
  try
    IUdrProcedureFactoryImpl(this).setup(status, context, metadata, inBuilder, outBuilder);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IUdrProcedureFactoryImpl_newItemDispatcher(this: IUdrProcedureFactory; status: IStatus; context: IExternalContext;
  metadata: IRoutineMetadata): IExternalProcedure; cdecl;
begin
  Result := nil;
  try
    Result := IUdrProcedureFactoryImpl(this).newItem(status, context, metadata);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IUdrProcedureFactoryImpl_vTable: UdrProcedureFactoryVTable;

constructor IUdrProcedureFactoryImpl.create;
begin
  vTable := IUdrProcedureFactoryImpl_vTable;
end;

procedure IUdrTriggerFactoryImpl_disposeDispatcher(this: IUdrTriggerFactory); cdecl;
begin
  try
    IUdrTriggerFactoryImpl(this).dispose();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IUdrTriggerFactoryImpl_setupDispatcher(this: IUdrTriggerFactory; status: IStatus; context: IExternalContext; metadata: IRoutineMetadata;
  fieldsBuilder: IMetadataBuilder); cdecl;
begin
  try
    IUdrTriggerFactoryImpl(this).setup(status, context, metadata, fieldsBuilder);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

function IUdrTriggerFactoryImpl_newItemDispatcher(this: IUdrTriggerFactory; status: IStatus; context: IExternalContext; metadata: IRoutineMetadata)
  : IExternalTrigger; cdecl;
begin
  Result := nil;
  try
    Result := IUdrTriggerFactoryImpl(this).newItem(status, context, metadata);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IUdrTriggerFactoryImpl_vTable: UdrTriggerFactoryVTable;

constructor IUdrTriggerFactoryImpl.create;
begin
  vTable := IUdrTriggerFactoryImpl_vTable;
end;

function IUdrPluginImpl_getMasterDispatcher(this: IUdrPlugin): IMaster; cdecl;
begin
  Result := nil;
  try
    Result := IUdrPluginImpl(this).getMaster();
  except
    on e: Exception do
      FbException.catchException(nil, e);
  end
end;

procedure IUdrPluginImpl_registerFunctionDispatcher(this: IUdrPlugin; status: IStatus; name: PAnsiChar; factory: IUdrFunctionFactory); cdecl;
begin
  try
    IUdrPluginImpl(this).registerFunction(status, name, factory);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IUdrPluginImpl_registerProcedureDispatcher(this: IUdrPlugin; status: IStatus; name: PAnsiChar; factory: IUdrProcedureFactory); cdecl;
begin
  try
    IUdrPluginImpl(this).registerProcedure(status, name, factory);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

procedure IUdrPluginImpl_registerTriggerDispatcher(this: IUdrPlugin; status: IStatus; name: PAnsiChar; factory: IUdrTriggerFactory); cdecl;
begin
  try
    IUdrPluginImpl(this).registerTrigger(status, name, factory);
  except
    on e: Exception do
      FbException.catchException(status, e);
  end
end;

var
  IUdrPluginImpl_vTable: UdrPluginVTable;

constructor IUdrPluginImpl.create;
begin
  vTable := IUdrPluginImpl_vTable;
end;

constructor FbException.create(status: IStatus);
begin
  inherited create('FbException');
  Self.status := status.clone;
end;

destructor FbException.Destroy();
begin
  status.dispose;
  inherited Destroy;
end;

function FbException.getStatus: IStatus;
begin
  Result := status;
end;

class procedure FbException.checkException(status: IStatus);
begin
  if ((status.getState and status.STATE_ERRORS) <> 0) then
    if (status.GetErrors^ <> 1) then
      raise FbException.create(status);

//  if ((status.getState and status.STATE_ERRORS) <> 0) then
//    raise FbException.create(status);
end;

class procedure FbException.catchException(status: IStatus; e: Exception);
var
  statusVector: array [0 .. 4] of NativeIntPtr;
  msg         : AnsiString;
begin
  if (e.inheritsFrom(FbException)) then
    status.setErrors(FbException(e).getStatus.getErrors)
  else
  begin
    msg := AnsiString(e.message);

    statusVector[0] := NativeIntPtr(isc_arg_gds);
    statusVector[1] := NativeIntPtr(isc_random);
    statusVector[2] := NativeIntPtr(isc_arg_string);
    statusVector[3] := NativeIntPtr(PAnsiChar(msg));
    statusVector[4] := NativeIntPtr(isc_arg_end);

    status.setErrors(@statusVector);
  end
end;

initialization

IVersionedImpl_vTable := VersionedVTable.create;
IVersionedImpl_vTable.version := 0;

IReferenceCountedImpl_vTable := ReferenceCountedVTable.create;
IReferenceCountedImpl_vTable.version := 2;
IReferenceCountedImpl_vTable.addRef := @IReferenceCountedImpl_addRefDispatcher;
IReferenceCountedImpl_vTable.release := @IReferenceCountedImpl_releaseDispatcher;

IDisposableImpl_vTable := DisposableVTable.create;
IDisposableImpl_vTable.version := 1;
IDisposableImpl_vTable.dispose := @IDisposableImpl_disposeDispatcher;

IStatusImpl_vTable := StatusVTable.create;
IStatusImpl_vTable.version := 10;
IStatusImpl_vTable.dispose := @IStatusImpl_disposeDispatcher;
IStatusImpl_vTable.init := @IStatusImpl_initDispatcher;
IStatusImpl_vTable.getState := @IStatusImpl_getStateDispatcher;
IStatusImpl_vTable.setErrors2 := @IStatusImpl_setErrors2Dispatcher;
IStatusImpl_vTable.setWarnings2 := @IStatusImpl_setWarnings2Dispatcher;
IStatusImpl_vTable.setErrors := @IStatusImpl_setErrorsDispatcher;
IStatusImpl_vTable.setWarnings := @IStatusImpl_setWarningsDispatcher;
IStatusImpl_vTable.getErrors := @IStatusImpl_getErrorsDispatcher;
IStatusImpl_vTable.getWarnings := @IStatusImpl_getWarningsDispatcher;
IStatusImpl_vTable.clone := @IStatusImpl_cloneDispatcher;

IMasterImpl_vTable := MasterVTable.create;
IMasterImpl_vTable.version := 12;
IMasterImpl_vTable.getStatus := @IMasterImpl_getStatusDispatcher;
IMasterImpl_vTable.getDispatcher := @IMasterImpl_getDispatcherDispatcher;
IMasterImpl_vTable.getPluginManager := @IMasterImpl_getPluginManagerDispatcher;
IMasterImpl_vTable.getTimerControl := @IMasterImpl_getTimerControlDispatcher;
IMasterImpl_vTable.getDtc := @IMasterImpl_getDtcDispatcher;
IMasterImpl_vTable.registerAttachment := @IMasterImpl_registerAttachmentDispatcher;
IMasterImpl_vTable.registerTransaction := @IMasterImpl_registerTransactionDispatcher;
IMasterImpl_vTable.getMetadataBuilder := @IMasterImpl_getMetadataBuilderDispatcher;
IMasterImpl_vTable.serverMode := @IMasterImpl_serverModeDispatcher;
IMasterImpl_vTable.getUtilInterface := @IMasterImpl_getUtilInterfaceDispatcher;
IMasterImpl_vTable.getConfigManager := @IMasterImpl_getConfigManagerDispatcher;
IMasterImpl_vTable.getProcessExiting := @IMasterImpl_getProcessExitingDispatcher;

IPluginBaseImpl_vTable := PluginBaseVTable.create;
IPluginBaseImpl_vTable.version := 4;
IPluginBaseImpl_vTable.addRef := @IPluginBaseImpl_addRefDispatcher;
IPluginBaseImpl_vTable.release := @IPluginBaseImpl_releaseDispatcher;
IPluginBaseImpl_vTable.setOwner := @IPluginBaseImpl_setOwnerDispatcher;
IPluginBaseImpl_vTable.getOwner := @IPluginBaseImpl_getOwnerDispatcher;

IPluginSetImpl_vTable := PluginSetVTable.create;
IPluginSetImpl_vTable.version := 7;
IPluginSetImpl_vTable.addRef := @IPluginSetImpl_addRefDispatcher;
IPluginSetImpl_vTable.release := @IPluginSetImpl_releaseDispatcher;
IPluginSetImpl_vTable.getName := @IPluginSetImpl_getNameDispatcher;
IPluginSetImpl_vTable.getModuleName := @IPluginSetImpl_getModuleNameDispatcher;
IPluginSetImpl_vTable.getPlugin := @IPluginSetImpl_getPluginDispatcher;
IPluginSetImpl_vTable.next := @IPluginSetImpl_nextDispatcher;
IPluginSetImpl_vTable.set_ := @IPluginSetImpl_set_Dispatcher;

IConfigEntryImpl_vTable := ConfigEntryVTable.create;
IConfigEntryImpl_vTable.version := 7;
IConfigEntryImpl_vTable.addRef := @IConfigEntryImpl_addRefDispatcher;
IConfigEntryImpl_vTable.release := @IConfigEntryImpl_releaseDispatcher;
IConfigEntryImpl_vTable.getName := @IConfigEntryImpl_getNameDispatcher;
IConfigEntryImpl_vTable.getValue := @IConfigEntryImpl_getValueDispatcher;
IConfigEntryImpl_vTable.getIntValue := @IConfigEntryImpl_getIntValueDispatcher;
IConfigEntryImpl_vTable.getBoolValue := @IConfigEntryImpl_getBoolValueDispatcher;
IConfigEntryImpl_vTable.getSubConfig := @IConfigEntryImpl_getSubConfigDispatcher;

IConfigImpl_vTable := ConfigVTable.create;
IConfigImpl_vTable.version := 5;
IConfigImpl_vTable.addRef := @IConfigImpl_addRefDispatcher;
IConfigImpl_vTable.release := @IConfigImpl_releaseDispatcher;
IConfigImpl_vTable.find := @IConfigImpl_findDispatcher;
IConfigImpl_vTable.findValue := @IConfigImpl_findValueDispatcher;
IConfigImpl_vTable.findPos := @IConfigImpl_findPosDispatcher;

IFirebirdConfImpl_vTable := FirebirdConfVTable.create;
IFirebirdConfImpl_vTable.version := 6;
IFirebirdConfImpl_vTable.addRef := @IFirebirdConfImpl_addRefDispatcher;
IFirebirdConfImpl_vTable.release := @IFirebirdConfImpl_releaseDispatcher;
IFirebirdConfImpl_vTable.getKey := @IFirebirdConfImpl_getKeyDispatcher;
IFirebirdConfImpl_vTable.asInteger := @IFirebirdConfImpl_asIntegerDispatcher;
IFirebirdConfImpl_vTable.asString := @IFirebirdConfImpl_asStringDispatcher;
IFirebirdConfImpl_vTable.asBoolean := @IFirebirdConfImpl_asBooleanDispatcher;

IPluginConfigImpl_vTable := PluginConfigVTable.create;
IPluginConfigImpl_vTable.version := 6;
IPluginConfigImpl_vTable.addRef := @IPluginConfigImpl_addRefDispatcher;
IPluginConfigImpl_vTable.release := @IPluginConfigImpl_releaseDispatcher;
IPluginConfigImpl_vTable.getConfigFileName := @IPluginConfigImpl_getConfigFileNameDispatcher;
IPluginConfigImpl_vTable.getDefaultConfig := @IPluginConfigImpl_getDefaultConfigDispatcher;
IPluginConfigImpl_vTable.getFirebirdConf := @IPluginConfigImpl_getFirebirdConfDispatcher;
IPluginConfigImpl_vTable.setReleaseDelay := @IPluginConfigImpl_setReleaseDelayDispatcher;

IPluginFactoryImpl_vTable := PluginFactoryVTable.create;
IPluginFactoryImpl_vTable.version := 1;
IPluginFactoryImpl_vTable.createPlugin := @IPluginFactoryImpl_createPluginDispatcher;

IPluginModuleImpl_vTable := PluginModuleVTable.create;
IPluginModuleImpl_vTable.version := 2;
IPluginModuleImpl_vTable.doClean := @IPluginModuleImpl_doCleanDispatcher;
IPluginModuleImpl_vTable.threadDetach := @IPluginModuleImpl_threadDetachDispatcher;

IPluginManagerImpl_vTable := PluginManagerVTable.create;
IPluginManagerImpl_vTable.version := 6;
IPluginManagerImpl_vTable.registerPluginFactory := @IPluginManagerImpl_registerPluginFactoryDispatcher;
IPluginManagerImpl_vTable.registerModule := @IPluginManagerImpl_registerModuleDispatcher;
IPluginManagerImpl_vTable.unregisterModule := @IPluginManagerImpl_unregisterModuleDispatcher;
IPluginManagerImpl_vTable.getPlugins := @IPluginManagerImpl_getPluginsDispatcher;
IPluginManagerImpl_vTable.getConfig := @IPluginManagerImpl_getConfigDispatcher;
IPluginManagerImpl_vTable.releasePlugin := @IPluginManagerImpl_releasePluginDispatcher;

ICryptKeyImpl_vTable := CryptKeyVTable.create;
ICryptKeyImpl_vTable.version := 4;
ICryptKeyImpl_vTable.setSymmetric := @ICryptKeyImpl_setSymmetricDispatcher;
ICryptKeyImpl_vTable.setAsymmetric := @ICryptKeyImpl_setAsymmetricDispatcher;
ICryptKeyImpl_vTable.getEncryptKey := @ICryptKeyImpl_getEncryptKeyDispatcher;
ICryptKeyImpl_vTable.getDecryptKey := @ICryptKeyImpl_getDecryptKeyDispatcher;

IConfigManagerImpl_vTable := ConfigManagerVTable.create;
IConfigManagerImpl_vTable.version := 7;
IConfigManagerImpl_vTable.getDirectory := @IConfigManagerImpl_getDirectoryDispatcher;
IConfigManagerImpl_vTable.getFirebirdConf := @IConfigManagerImpl_getFirebirdConfDispatcher;
IConfigManagerImpl_vTable.getDatabaseConf := @IConfigManagerImpl_getDatabaseConfDispatcher;
IConfigManagerImpl_vTable.getPluginConfig := @IConfigManagerImpl_getPluginConfigDispatcher;
IConfigManagerImpl_vTable.getInstallDirectory := @IConfigManagerImpl_getInstallDirectoryDispatcher;
IConfigManagerImpl_vTable.getRootDirectory := @IConfigManagerImpl_getRootDirectoryDispatcher;
IConfigManagerImpl_vTable.getDefaultSecurityDb := @IConfigManagerImpl_getDefaultSecurityDbDispatcher;

IEventCallbackImpl_vTable := EventCallbackVTable.create;
IEventCallbackImpl_vTable.version := 3;
IEventCallbackImpl_vTable.addRef := @IEventCallbackImpl_addRefDispatcher;
IEventCallbackImpl_vTable.release := @IEventCallbackImpl_releaseDispatcher;
IEventCallbackImpl_vTable.eventCallbackFunction := @IEventCallbackImpl_eventCallbackFunctionDispatcher;

IBlobImpl_vTable := BlobVTable.create;
IBlobImpl_vTable.version := 8;
IBlobImpl_vTable.addRef := @IBlobImpl_addRefDispatcher;
IBlobImpl_vTable.release := @IBlobImpl_releaseDispatcher;
IBlobImpl_vTable.getInfo := @IBlobImpl_getInfoDispatcher;
IBlobImpl_vTable.getSegment := @IBlobImpl_getSegmentDispatcher;
IBlobImpl_vTable.putSegment := @IBlobImpl_putSegmentDispatcher;
IBlobImpl_vTable.cancel := @IBlobImpl_cancelDispatcher;
IBlobImpl_vTable.close := @IBlobImpl_closeDispatcher;
IBlobImpl_vTable.seek := @IBlobImpl_seekDispatcher;

ITransactionImpl_vTable := TransactionVTable.create;
ITransactionImpl_vTable.version := 12;
ITransactionImpl_vTable.addRef := @ITransactionImpl_addRefDispatcher;
ITransactionImpl_vTable.release := @ITransactionImpl_releaseDispatcher;
ITransactionImpl_vTable.getInfo := @ITransactionImpl_getInfoDispatcher;
ITransactionImpl_vTable.prepare := @ITransactionImpl_prepareDispatcher;
ITransactionImpl_vTable.commit := @ITransactionImpl_commitDispatcher;
ITransactionImpl_vTable.commitRetaining := @ITransactionImpl_commitRetainingDispatcher;
ITransactionImpl_vTable.rollback := @ITransactionImpl_rollbackDispatcher;
ITransactionImpl_vTable.rollbackRetaining := @ITransactionImpl_rollbackRetainingDispatcher;
ITransactionImpl_vTable.disconnect := @ITransactionImpl_disconnectDispatcher;
ITransactionImpl_vTable.join := @ITransactionImpl_joinDispatcher;
ITransactionImpl_vTable.validate := @ITransactionImpl_validateDispatcher;
ITransactionImpl_vTable.enterDtc := @ITransactionImpl_enterDtcDispatcher;

IMessageMetadataImpl_vTable := MessageMetadataVTable.create;
IMessageMetadataImpl_vTable.version := 17;
IMessageMetadataImpl_vTable.addRef := @IMessageMetadataImpl_addRefDispatcher;
IMessageMetadataImpl_vTable.release := @IMessageMetadataImpl_releaseDispatcher;
IMessageMetadataImpl_vTable.getCount := @IMessageMetadataImpl_getCountDispatcher;
IMessageMetadataImpl_vTable.getField := @IMessageMetadataImpl_getFieldDispatcher;
IMessageMetadataImpl_vTable.getRelation := @IMessageMetadataImpl_getRelationDispatcher;
IMessageMetadataImpl_vTable.getOwner := @IMessageMetadataImpl_getOwnerDispatcher;
IMessageMetadataImpl_vTable.getAlias := @IMessageMetadataImpl_getAliasDispatcher;
IMessageMetadataImpl_vTable.getType := @IMessageMetadataImpl_getTypeDispatcher;
IMessageMetadataImpl_vTable.isNullable := @IMessageMetadataImpl_isNullableDispatcher;
IMessageMetadataImpl_vTable.getSubType := @IMessageMetadataImpl_getSubTypeDispatcher;
IMessageMetadataImpl_vTable.getLength := @IMessageMetadataImpl_getLengthDispatcher;
IMessageMetadataImpl_vTable.getScale := @IMessageMetadataImpl_getScaleDispatcher;
IMessageMetadataImpl_vTable.getCharSet := @IMessageMetadataImpl_getCharSetDispatcher;
IMessageMetadataImpl_vTable.getOffset := @IMessageMetadataImpl_getOffsetDispatcher;
IMessageMetadataImpl_vTable.getNullOffset := @IMessageMetadataImpl_getNullOffsetDispatcher;
IMessageMetadataImpl_vTable.getBuilder := @IMessageMetadataImpl_getBuilderDispatcher;
IMessageMetadataImpl_vTable.getMessageLength := @IMessageMetadataImpl_getMessageLengthDispatcher;

IMetadataBuilderImpl_vTable := MetadataBuilderVTable.create;
IMetadataBuilderImpl_vTable.version := 12;
IMetadataBuilderImpl_vTable.addRef := @IMetadataBuilderImpl_addRefDispatcher;
IMetadataBuilderImpl_vTable.release := @IMetadataBuilderImpl_releaseDispatcher;
IMetadataBuilderImpl_vTable.setType := @IMetadataBuilderImpl_setTypeDispatcher;
IMetadataBuilderImpl_vTable.setSubType := @IMetadataBuilderImpl_setSubTypeDispatcher;
IMetadataBuilderImpl_vTable.setLength := @IMetadataBuilderImpl_setLengthDispatcher;
IMetadataBuilderImpl_vTable.setCharSet := @IMetadataBuilderImpl_setCharSetDispatcher;
IMetadataBuilderImpl_vTable.setScale := @IMetadataBuilderImpl_setScaleDispatcher;
IMetadataBuilderImpl_vTable.truncate := @IMetadataBuilderImpl_truncateDispatcher;
IMetadataBuilderImpl_vTable.moveNameToIndex := @IMetadataBuilderImpl_moveNameToIndexDispatcher;
IMetadataBuilderImpl_vTable.remove := @IMetadataBuilderImpl_removeDispatcher;
IMetadataBuilderImpl_vTable.addField := @IMetadataBuilderImpl_addFieldDispatcher;
IMetadataBuilderImpl_vTable.getMetadata := @IMetadataBuilderImpl_getMetadataDispatcher;

IResultSetImpl_vTable := ResultSetVTable.create;
IResultSetImpl_vTable.version := 13;
IResultSetImpl_vTable.addRef := @IResultSetImpl_addRefDispatcher;
IResultSetImpl_vTable.release := @IResultSetImpl_releaseDispatcher;
IResultSetImpl_vTable.fetchNext := @IResultSetImpl_fetchNextDispatcher;
IResultSetImpl_vTable.fetchPrior := @IResultSetImpl_fetchPriorDispatcher;
IResultSetImpl_vTable.fetchFirst := @IResultSetImpl_fetchFirstDispatcher;
IResultSetImpl_vTable.fetchLast := @IResultSetImpl_fetchLastDispatcher;
IResultSetImpl_vTable.fetchAbsolute := @IResultSetImpl_fetchAbsoluteDispatcher;
IResultSetImpl_vTable.fetchRelative := @IResultSetImpl_fetchRelativeDispatcher;
IResultSetImpl_vTable.isEof := @IResultSetImpl_isEofDispatcher;
IResultSetImpl_vTable.isBof := @IResultSetImpl_isBofDispatcher;
IResultSetImpl_vTable.getMetadata := @IResultSetImpl_getMetadataDispatcher;
IResultSetImpl_vTable.close := @IResultSetImpl_closeDispatcher;
IResultSetImpl_vTable.setDelayedOutputFormat := @IResultSetImpl_setDelayedOutputFormatDispatcher;

IStatementImpl_vTable := StatementVTable.create;
IStatementImpl_vTable.version := 13;
IStatementImpl_vTable.addRef := @IStatementImpl_addRefDispatcher;
IStatementImpl_vTable.release := @IStatementImpl_releaseDispatcher;
IStatementImpl_vTable.getInfo := @IStatementImpl_getInfoDispatcher;
IStatementImpl_vTable.getType := @IStatementImpl_getTypeDispatcher;
IStatementImpl_vTable.getPlan := @IStatementImpl_getPlanDispatcher;
IStatementImpl_vTable.getAffectedRecords := @IStatementImpl_getAffectedRecordsDispatcher;
IStatementImpl_vTable.getInputMetadata := @IStatementImpl_getInputMetadataDispatcher;
IStatementImpl_vTable.getOutputMetadata := @IStatementImpl_getOutputMetadataDispatcher;
IStatementImpl_vTable.execute := @IStatementImpl_executeDispatcher;
IStatementImpl_vTable.openCursor := @IStatementImpl_openCursorDispatcher;
IStatementImpl_vTable.setCursorName := @IStatementImpl_setCursorNameDispatcher;
IStatementImpl_vTable.free := @IStatementImpl_freeDispatcher;
IStatementImpl_vTable.getFlags := @IStatementImpl_getFlagsDispatcher;

IRequestImpl_vTable := RequestVTable.create;
IRequestImpl_vTable.version := 9;
IRequestImpl_vTable.addRef := @IRequestImpl_addRefDispatcher;
IRequestImpl_vTable.release := @IRequestImpl_releaseDispatcher;
IRequestImpl_vTable.receive := @IRequestImpl_receiveDispatcher;
IRequestImpl_vTable.send := @IRequestImpl_sendDispatcher;
IRequestImpl_vTable.getInfo := @IRequestImpl_getInfoDispatcher;
IRequestImpl_vTable.start := @IRequestImpl_startDispatcher;
IRequestImpl_vTable.startAndSend := @IRequestImpl_startAndSendDispatcher;
IRequestImpl_vTable.unwind := @IRequestImpl_unwindDispatcher;
IRequestImpl_vTable.free := @IRequestImpl_freeDispatcher;

IEventsImpl_vTable := EventsVTable.create;
IEventsImpl_vTable.version := 3;
IEventsImpl_vTable.addRef := @IEventsImpl_addRefDispatcher;
IEventsImpl_vTable.release := @IEventsImpl_releaseDispatcher;
IEventsImpl_vTable.cancel := @IEventsImpl_cancelDispatcher;

IAttachmentImpl_vTable := AttachmentVTable.create;
IAttachmentImpl_vTable.version := 20;
IAttachmentImpl_vTable.addRef := @IAttachmentImpl_addRefDispatcher;
IAttachmentImpl_vTable.release := @IAttachmentImpl_releaseDispatcher;
IAttachmentImpl_vTable.getInfo := @IAttachmentImpl_getInfoDispatcher;
IAttachmentImpl_vTable.startTransaction := @IAttachmentImpl_startTransactionDispatcher;
IAttachmentImpl_vTable.reconnectTransaction := @IAttachmentImpl_reconnectTransactionDispatcher;
IAttachmentImpl_vTable.compileRequest := @IAttachmentImpl_compileRequestDispatcher;
IAttachmentImpl_vTable.transactRequest := @IAttachmentImpl_transactRequestDispatcher;
IAttachmentImpl_vTable.createBlob := @IAttachmentImpl_createBlobDispatcher;
IAttachmentImpl_vTable.openBlob := @IAttachmentImpl_openBlobDispatcher;
IAttachmentImpl_vTable.getSlice := @IAttachmentImpl_getSliceDispatcher;
IAttachmentImpl_vTable.putSlice := @IAttachmentImpl_putSliceDispatcher;
IAttachmentImpl_vTable.executeDyn := @IAttachmentImpl_executeDynDispatcher;
IAttachmentImpl_vTable.prepare := @IAttachmentImpl_prepareDispatcher;
IAttachmentImpl_vTable.execute := @IAttachmentImpl_executeDispatcher;
IAttachmentImpl_vTable.openCursor := @IAttachmentImpl_openCursorDispatcher;
IAttachmentImpl_vTable.queEvents := @IAttachmentImpl_queEventsDispatcher;
IAttachmentImpl_vTable.cancelOperation := @IAttachmentImpl_cancelOperationDispatcher;
IAttachmentImpl_vTable.ping := @IAttachmentImpl_pingDispatcher;
IAttachmentImpl_vTable.detach := @IAttachmentImpl_detachDispatcher;
IAttachmentImpl_vTable.dropDatabase := @IAttachmentImpl_dropDatabaseDispatcher;

IServiceImpl_vTable := ServiceVTable.create;
IServiceImpl_vTable.version := 5;
IServiceImpl_vTable.addRef := @IServiceImpl_addRefDispatcher;
IServiceImpl_vTable.release := @IServiceImpl_releaseDispatcher;
IServiceImpl_vTable.detach := @IServiceImpl_detachDispatcher;
IServiceImpl_vTable.query := @IServiceImpl_queryDispatcher;
IServiceImpl_vTable.start := @IServiceImpl_startDispatcher;

IProviderImpl_vTable := ProviderVTable.create;
IProviderImpl_vTable.version := 9;
IProviderImpl_vTable.addRef := @IProviderImpl_addRefDispatcher;
IProviderImpl_vTable.release := @IProviderImpl_releaseDispatcher;
IProviderImpl_vTable.setOwner := @IProviderImpl_setOwnerDispatcher;
IProviderImpl_vTable.getOwner := @IProviderImpl_getOwnerDispatcher;
IProviderImpl_vTable.attachDatabase := @IProviderImpl_attachDatabaseDispatcher;
IProviderImpl_vTable.createDatabase := @IProviderImpl_createDatabaseDispatcher;
IProviderImpl_vTable.attachServiceManager := @IProviderImpl_attachServiceManagerDispatcher;
IProviderImpl_vTable.shutdown := @IProviderImpl_shutdownDispatcher;
IProviderImpl_vTable.setDbCryptCallback := @IProviderImpl_setDbCryptCallbackDispatcher;

IDtcStartImpl_vTable := DtcStartVTable.create;
IDtcStartImpl_vTable.version := 4;
IDtcStartImpl_vTable.dispose := @IDtcStartImpl_disposeDispatcher;
IDtcStartImpl_vTable.addAttachment := @IDtcStartImpl_addAttachmentDispatcher;
IDtcStartImpl_vTable.addWithTpb := @IDtcStartImpl_addWithTpbDispatcher;
IDtcStartImpl_vTable.start := @IDtcStartImpl_startDispatcher;

IDtcImpl_vTable := DtcVTable.create;
IDtcImpl_vTable.version := 2;
IDtcImpl_vTable.join := @IDtcImpl_joinDispatcher;
IDtcImpl_vTable.startBuilder := @IDtcImpl_startBuilderDispatcher;

IAuthImpl_vTable := AuthVTable.create;
IAuthImpl_vTable.version := 4;
IAuthImpl_vTable.addRef := @IAuthImpl_addRefDispatcher;
IAuthImpl_vTable.release := @IAuthImpl_releaseDispatcher;
IAuthImpl_vTable.setOwner := @IAuthImpl_setOwnerDispatcher;
IAuthImpl_vTable.getOwner := @IAuthImpl_getOwnerDispatcher;

IWriterImpl_vTable := WriterVTable.create;
IWriterImpl_vTable.version := 4;
IWriterImpl_vTable.reset := @IWriterImpl_resetDispatcher;
IWriterImpl_vTable.add := @IWriterImpl_addDispatcher;
IWriterImpl_vTable.setType := @IWriterImpl_setTypeDispatcher;
IWriterImpl_vTable.setDb := @IWriterImpl_setDbDispatcher;

IServerBlockImpl_vTable := ServerBlockVTable.create;
IServerBlockImpl_vTable.version := 4;
IServerBlockImpl_vTable.getLogin := @IServerBlockImpl_getLoginDispatcher;
IServerBlockImpl_vTable.getData := @IServerBlockImpl_getDataDispatcher;
IServerBlockImpl_vTable.putData := @IServerBlockImpl_putDataDispatcher;
IServerBlockImpl_vTable.newKey := @IServerBlockImpl_newKeyDispatcher;

IClientBlockImpl_vTable := ClientBlockVTable.create;
IClientBlockImpl_vTable.version := 8;
IClientBlockImpl_vTable.addRef := @IClientBlockImpl_addRefDispatcher;
IClientBlockImpl_vTable.release := @IClientBlockImpl_releaseDispatcher;
IClientBlockImpl_vTable.getLogin := @IClientBlockImpl_getLoginDispatcher;
IClientBlockImpl_vTable.getPassword := @IClientBlockImpl_getPasswordDispatcher;
IClientBlockImpl_vTable.getData := @IClientBlockImpl_getDataDispatcher;
IClientBlockImpl_vTable.putData := @IClientBlockImpl_putDataDispatcher;
IClientBlockImpl_vTable.newKey := @IClientBlockImpl_newKeyDispatcher;
IClientBlockImpl_vTable.getAuthBlock := @IClientBlockImpl_getAuthBlockDispatcher;

IServerImpl_vTable := ServerVTable.create;
IServerImpl_vTable.version := 6;
IServerImpl_vTable.addRef := @IServerImpl_addRefDispatcher;
IServerImpl_vTable.release := @IServerImpl_releaseDispatcher;
IServerImpl_vTable.setOwner := @IServerImpl_setOwnerDispatcher;
IServerImpl_vTable.getOwner := @IServerImpl_getOwnerDispatcher;
IServerImpl_vTable.authenticate := @IServerImpl_authenticateDispatcher;
IServerImpl_vTable.setDbCryptCallback := @IServerImpl_setDbCryptCallbackDispatcher;

IClientImpl_vTable := ClientVTable.create;
IClientImpl_vTable.version := 5;
IClientImpl_vTable.addRef := @IClientImpl_addRefDispatcher;
IClientImpl_vTable.release := @IClientImpl_releaseDispatcher;
IClientImpl_vTable.setOwner := @IClientImpl_setOwnerDispatcher;
IClientImpl_vTable.getOwner := @IClientImpl_getOwnerDispatcher;
IClientImpl_vTable.authenticate := @IClientImpl_authenticateDispatcher;

IUserFieldImpl_vTable := UserFieldVTable.create;
IUserFieldImpl_vTable.version := 3;
IUserFieldImpl_vTable.entered := @IUserFieldImpl_enteredDispatcher;
IUserFieldImpl_vTable.specified := @IUserFieldImpl_specifiedDispatcher;
IUserFieldImpl_vTable.setEntered := @IUserFieldImpl_setEnteredDispatcher;

ICharUserFieldImpl_vTable := CharUserFieldVTable.create;
ICharUserFieldImpl_vTable.version := 5;
ICharUserFieldImpl_vTable.entered := @ICharUserFieldImpl_enteredDispatcher;
ICharUserFieldImpl_vTable.specified := @ICharUserFieldImpl_specifiedDispatcher;
ICharUserFieldImpl_vTable.setEntered := @ICharUserFieldImpl_setEnteredDispatcher;
ICharUserFieldImpl_vTable.get := @ICharUserFieldImpl_getDispatcher;
ICharUserFieldImpl_vTable.set_ := @ICharUserFieldImpl_set_Dispatcher;

IIntUserFieldImpl_vTable := IntUserFieldVTable.create;
IIntUserFieldImpl_vTable.version := 5;
IIntUserFieldImpl_vTable.entered := @IIntUserFieldImpl_enteredDispatcher;
IIntUserFieldImpl_vTable.specified := @IIntUserFieldImpl_specifiedDispatcher;
IIntUserFieldImpl_vTable.setEntered := @IIntUserFieldImpl_setEnteredDispatcher;
IIntUserFieldImpl_vTable.get := @IIntUserFieldImpl_getDispatcher;
IIntUserFieldImpl_vTable.set_ := @IIntUserFieldImpl_set_Dispatcher;

IUserImpl_vTable := UserVTable.create;
IUserImpl_vTable.version := 11;
IUserImpl_vTable.operation := @IUserImpl_operationDispatcher;
IUserImpl_vTable.userName := @IUserImpl_userNameDispatcher;
IUserImpl_vTable.password := @IUserImpl_passwordDispatcher;
IUserImpl_vTable.firstName := @IUserImpl_firstNameDispatcher;
IUserImpl_vTable.lastName := @IUserImpl_lastNameDispatcher;
IUserImpl_vTable.middleName := @IUserImpl_middleNameDispatcher;
IUserImpl_vTable.comment := @IUserImpl_commentDispatcher;
IUserImpl_vTable.attributes := @IUserImpl_attributesDispatcher;
IUserImpl_vTable.active := @IUserImpl_activeDispatcher;
IUserImpl_vTable.admin := @IUserImpl_adminDispatcher;
IUserImpl_vTable.clear := @IUserImpl_clearDispatcher;

IListUsersImpl_vTable := ListUsersVTable.create;
IListUsersImpl_vTable.version := 1;
IListUsersImpl_vTable.list := @IListUsersImpl_listDispatcher;

ILogonInfoImpl_vTable := LogonInfoVTable.create;
ILogonInfoImpl_vTable.version := 5;
ILogonInfoImpl_vTable.name := @ILogonInfoImpl_nameDispatcher;
ILogonInfoImpl_vTable.role := @ILogonInfoImpl_roleDispatcher;
ILogonInfoImpl_vTable.networkProtocol := @ILogonInfoImpl_networkProtocolDispatcher;
ILogonInfoImpl_vTable.remoteAddress := @ILogonInfoImpl_remoteAddressDispatcher;
ILogonInfoImpl_vTable.authBlock := @ILogonInfoImpl_authBlockDispatcher;

IManagementImpl_vTable := ManagementVTable.create;
IManagementImpl_vTable.version := 8;
IManagementImpl_vTable.addRef := @IManagementImpl_addRefDispatcher;
IManagementImpl_vTable.release := @IManagementImpl_releaseDispatcher;
IManagementImpl_vTable.setOwner := @IManagementImpl_setOwnerDispatcher;
IManagementImpl_vTable.getOwner := @IManagementImpl_getOwnerDispatcher;
IManagementImpl_vTable.start := @IManagementImpl_startDispatcher;
IManagementImpl_vTable.execute := @IManagementImpl_executeDispatcher;
IManagementImpl_vTable.commit := @IManagementImpl_commitDispatcher;
IManagementImpl_vTable.rollback := @IManagementImpl_rollbackDispatcher;

IAuthBlockImpl_vTable := AuthBlockVTable.create;
IAuthBlockImpl_vTable.version := 7;
IAuthBlockImpl_vTable.getType := @IAuthBlockImpl_getTypeDispatcher;
IAuthBlockImpl_vTable.getName := @IAuthBlockImpl_getNameDispatcher;
IAuthBlockImpl_vTable.getPlugin := @IAuthBlockImpl_getPluginDispatcher;
IAuthBlockImpl_vTable.getSecurityDb := @IAuthBlockImpl_getSecurityDbDispatcher;
IAuthBlockImpl_vTable.getOriginalPlugin := @IAuthBlockImpl_getOriginalPluginDispatcher;
IAuthBlockImpl_vTable.next := @IAuthBlockImpl_nextDispatcher;
IAuthBlockImpl_vTable.first := @IAuthBlockImpl_firstDispatcher;

IWireCryptPluginImpl_vTable := WireCryptPluginVTable.create;
IWireCryptPluginImpl_vTable.version := 8;
IWireCryptPluginImpl_vTable.addRef := @IWireCryptPluginImpl_addRefDispatcher;
IWireCryptPluginImpl_vTable.release := @IWireCryptPluginImpl_releaseDispatcher;
IWireCryptPluginImpl_vTable.setOwner := @IWireCryptPluginImpl_setOwnerDispatcher;
IWireCryptPluginImpl_vTable.getOwner := @IWireCryptPluginImpl_getOwnerDispatcher;
IWireCryptPluginImpl_vTable.getKnownTypes := @IWireCryptPluginImpl_getKnownTypesDispatcher;
IWireCryptPluginImpl_vTable.setKey := @IWireCryptPluginImpl_setKeyDispatcher;
IWireCryptPluginImpl_vTable.encrypt := @IWireCryptPluginImpl_encryptDispatcher;
IWireCryptPluginImpl_vTable.decrypt := @IWireCryptPluginImpl_decryptDispatcher;

ICryptKeyCallbackImpl_vTable := CryptKeyCallbackVTable.create;
ICryptKeyCallbackImpl_vTable.version := 1;
ICryptKeyCallbackImpl_vTable.callback := @ICryptKeyCallbackImpl_callbackDispatcher;

IKeyHolderPluginImpl_vTable := KeyHolderPluginVTable.create;
IKeyHolderPluginImpl_vTable.version := 8;
IKeyHolderPluginImpl_vTable.addRef := @IKeyHolderPluginImpl_addRefDispatcher;
IKeyHolderPluginImpl_vTable.release := @IKeyHolderPluginImpl_releaseDispatcher;
IKeyHolderPluginImpl_vTable.setOwner := @IKeyHolderPluginImpl_setOwnerDispatcher;
IKeyHolderPluginImpl_vTable.getOwner := @IKeyHolderPluginImpl_getOwnerDispatcher;
IKeyHolderPluginImpl_vTable.keyCallback := @IKeyHolderPluginImpl_keyCallbackDispatcher;
IKeyHolderPluginImpl_vTable.keyHandle := @IKeyHolderPluginImpl_keyHandleDispatcher;
IKeyHolderPluginImpl_vTable.useOnlyOwnKeys := @IKeyHolderPluginImpl_useOnlyOwnKeysDispatcher;
IKeyHolderPluginImpl_vTable.chainHandle := @IKeyHolderPluginImpl_chainHandleDispatcher;

IDbCryptInfoImpl_vTable := DbCryptInfoVTable.create;
IDbCryptInfoImpl_vTable.version := 3;
IDbCryptInfoImpl_vTable.addRef := @IDbCryptInfoImpl_addRefDispatcher;
IDbCryptInfoImpl_vTable.release := @IDbCryptInfoImpl_releaseDispatcher;
IDbCryptInfoImpl_vTable.getDatabaseFullPath := @IDbCryptInfoImpl_getDatabaseFullPathDispatcher;

IDbCryptPluginImpl_vTable := DbCryptPluginVTable.create;
IDbCryptPluginImpl_vTable.version := 8;
IDbCryptPluginImpl_vTable.addRef := @IDbCryptPluginImpl_addRefDispatcher;
IDbCryptPluginImpl_vTable.release := @IDbCryptPluginImpl_releaseDispatcher;
IDbCryptPluginImpl_vTable.setOwner := @IDbCryptPluginImpl_setOwnerDispatcher;
IDbCryptPluginImpl_vTable.getOwner := @IDbCryptPluginImpl_getOwnerDispatcher;
IDbCryptPluginImpl_vTable.setKey := @IDbCryptPluginImpl_setKeyDispatcher;
IDbCryptPluginImpl_vTable.encrypt := @IDbCryptPluginImpl_encryptDispatcher;
IDbCryptPluginImpl_vTable.decrypt := @IDbCryptPluginImpl_decryptDispatcher;
IDbCryptPluginImpl_vTable.setInfo := @IDbCryptPluginImpl_setInfoDispatcher;

IExternalContextImpl_vTable := ExternalContextVTable.create;
IExternalContextImpl_vTable.version := 10;
IExternalContextImpl_vTable.getMaster := @IExternalContextImpl_getMasterDispatcher;
IExternalContextImpl_vTable.getEngine := @IExternalContextImpl_getEngineDispatcher;
IExternalContextImpl_vTable.getAttachment := @IExternalContextImpl_getAttachmentDispatcher;
IExternalContextImpl_vTable.getTransaction := @IExternalContextImpl_getTransactionDispatcher;
IExternalContextImpl_vTable.getUserName := @IExternalContextImpl_getUserNameDispatcher;
IExternalContextImpl_vTable.getDatabaseName := @IExternalContextImpl_getDatabaseNameDispatcher;
IExternalContextImpl_vTable.getClientCharSet := @IExternalContextImpl_getClientCharSetDispatcher;
IExternalContextImpl_vTable.obtainInfoCode := @IExternalContextImpl_obtainInfoCodeDispatcher;
IExternalContextImpl_vTable.getInfo := @IExternalContextImpl_getInfoDispatcher;
IExternalContextImpl_vTable.setInfo := @IExternalContextImpl_setInfoDispatcher;

IExternalResultSetImpl_vTable := ExternalResultSetVTable.create;
IExternalResultSetImpl_vTable.version := 2;
IExternalResultSetImpl_vTable.dispose := @IExternalResultSetImpl_disposeDispatcher;
IExternalResultSetImpl_vTable.fetch := @IExternalResultSetImpl_fetchDispatcher;

IExternalFunctionImpl_vTable := ExternalFunctionVTable.create;
IExternalFunctionImpl_vTable.version := 3;
IExternalFunctionImpl_vTable.dispose := @IExternalFunctionImpl_disposeDispatcher;
IExternalFunctionImpl_vTable.getCharSet := @IExternalFunctionImpl_getCharSetDispatcher;
IExternalFunctionImpl_vTable.execute := @IExternalFunctionImpl_executeDispatcher;

IExternalProcedureImpl_vTable := ExternalProcedureVTable.create;
IExternalProcedureImpl_vTable.version := 3;
IExternalProcedureImpl_vTable.dispose := @IExternalProcedureImpl_disposeDispatcher;
IExternalProcedureImpl_vTable.getCharSet := @IExternalProcedureImpl_getCharSetDispatcher;
IExternalProcedureImpl_vTable.open := @IExternalProcedureImpl_openDispatcher;

IExternalTriggerImpl_vTable := ExternalTriggerVTable.create;
IExternalTriggerImpl_vTable.version := 3;
IExternalTriggerImpl_vTable.dispose := @IExternalTriggerImpl_disposeDispatcher;
IExternalTriggerImpl_vTable.getCharSet := @IExternalTriggerImpl_getCharSetDispatcher;
IExternalTriggerImpl_vTable.execute := @IExternalTriggerImpl_executeDispatcher;

IRoutineMetadataImpl_vTable := RoutineMetadataVTable.create;
IRoutineMetadataImpl_vTable.version := 9;
IRoutineMetadataImpl_vTable.getPackage := @IRoutineMetadataImpl_getPackageDispatcher;
IRoutineMetadataImpl_vTable.getName := @IRoutineMetadataImpl_getNameDispatcher;
IRoutineMetadataImpl_vTable.getEntryPoint := @IRoutineMetadataImpl_getEntryPointDispatcher;
IRoutineMetadataImpl_vTable.getBody := @IRoutineMetadataImpl_getBodyDispatcher;
IRoutineMetadataImpl_vTable.getInputMetadata := @IRoutineMetadataImpl_getInputMetadataDispatcher;
IRoutineMetadataImpl_vTable.getOutputMetadata := @IRoutineMetadataImpl_getOutputMetadataDispatcher;
IRoutineMetadataImpl_vTable.getTriggerMetadata := @IRoutineMetadataImpl_getTriggerMetadataDispatcher;
IRoutineMetadataImpl_vTable.getTriggerTable := @IRoutineMetadataImpl_getTriggerTableDispatcher;
IRoutineMetadataImpl_vTable.getTriggerType := @IRoutineMetadataImpl_getTriggerTypeDispatcher;

IExternalEngineImpl_vTable := ExternalEngineVTable.create;
IExternalEngineImpl_vTable.version := 10;
IExternalEngineImpl_vTable.addRef := @IExternalEngineImpl_addRefDispatcher;
IExternalEngineImpl_vTable.release := @IExternalEngineImpl_releaseDispatcher;
IExternalEngineImpl_vTable.setOwner := @IExternalEngineImpl_setOwnerDispatcher;
IExternalEngineImpl_vTable.getOwner := @IExternalEngineImpl_getOwnerDispatcher;
IExternalEngineImpl_vTable.open := @IExternalEngineImpl_openDispatcher;
IExternalEngineImpl_vTable.openAttachment := @IExternalEngineImpl_openAttachmentDispatcher;
IExternalEngineImpl_vTable.closeAttachment := @IExternalEngineImpl_closeAttachmentDispatcher;
IExternalEngineImpl_vTable.makeFunction := @IExternalEngineImpl_makeFunctionDispatcher;
IExternalEngineImpl_vTable.makeProcedure := @IExternalEngineImpl_makeProcedureDispatcher;
IExternalEngineImpl_vTable.makeTrigger := @IExternalEngineImpl_makeTriggerDispatcher;

ITimerImpl_vTable := TimerVTable.create;
ITimerImpl_vTable.version := 3;
ITimerImpl_vTable.addRef := @ITimerImpl_addRefDispatcher;
ITimerImpl_vTable.release := @ITimerImpl_releaseDispatcher;
ITimerImpl_vTable.handler := @ITimerImpl_handlerDispatcher;

ITimerControlImpl_vTable := TimerControlVTable.create;
ITimerControlImpl_vTable.version := 2;
ITimerControlImpl_vTable.start := @ITimerControlImpl_startDispatcher;
ITimerControlImpl_vTable.stop := @ITimerControlImpl_stopDispatcher;

IVersionCallbackImpl_vTable := VersionCallbackVTable.create;
IVersionCallbackImpl_vTable.version := 1;
IVersionCallbackImpl_vTable.callback := @IVersionCallbackImpl_callbackDispatcher;

IUtilImpl_vTable := UtilVTable.create;
IUtilImpl_vTable.version := 13;
IUtilImpl_vTable.getFbVersion := @IUtilImpl_getFbVersionDispatcher;
IUtilImpl_vTable.loadBlob := @IUtilImpl_loadBlobDispatcher;
IUtilImpl_vTable.dumpBlob := @IUtilImpl_dumpBlobDispatcher;
IUtilImpl_vTable.getPerfCounters := @IUtilImpl_getPerfCountersDispatcher;
IUtilImpl_vTable.executeCreateDatabase := @IUtilImpl_executeCreateDatabaseDispatcher;
IUtilImpl_vTable.decodeDate := @IUtilImpl_decodeDateDispatcher;
IUtilImpl_vTable.decodeTime := @IUtilImpl_decodeTimeDispatcher;
IUtilImpl_vTable.encodeDate := @IUtilImpl_encodeDateDispatcher;
IUtilImpl_vTable.encodeTime := @IUtilImpl_encodeTimeDispatcher;
IUtilImpl_vTable.formatStatus := @IUtilImpl_formatStatusDispatcher;
IUtilImpl_vTable.getClientVersion := @IUtilImpl_getClientVersionDispatcher;
IUtilImpl_vTable.getXpbBuilder := @IUtilImpl_getXpbBuilderDispatcher;
IUtilImpl_vTable.setOffsets := @IUtilImpl_setOffsetsDispatcher;

IOffsetsCallbackImpl_vTable := OffsetsCallbackVTable.create;
IOffsetsCallbackImpl_vTable.version := 1;
IOffsetsCallbackImpl_vTable.setOffset := @IOffsetsCallbackImpl_setOffsetDispatcher;

IXpbBuilderImpl_vTable := XpbBuilderVTable.create;
IXpbBuilderImpl_vTable.version := 21;
IXpbBuilderImpl_vTable.dispose := @IXpbBuilderImpl_disposeDispatcher;
IXpbBuilderImpl_vTable.clear := @IXpbBuilderImpl_clearDispatcher;
IXpbBuilderImpl_vTable.removeCurrent := @IXpbBuilderImpl_removeCurrentDispatcher;
IXpbBuilderImpl_vTable.insertInt := @IXpbBuilderImpl_insertIntDispatcher;
IXpbBuilderImpl_vTable.insertBigInt := @IXpbBuilderImpl_insertBigIntDispatcher;
IXpbBuilderImpl_vTable.insertBytes := @IXpbBuilderImpl_insertBytesDispatcher;
IXpbBuilderImpl_vTable.insertString := @IXpbBuilderImpl_insertStringDispatcher;
IXpbBuilderImpl_vTable.insertTag := @IXpbBuilderImpl_insertTagDispatcher;
IXpbBuilderImpl_vTable.isEof := @IXpbBuilderImpl_isEofDispatcher;
IXpbBuilderImpl_vTable.moveNext := @IXpbBuilderImpl_moveNextDispatcher;
IXpbBuilderImpl_vTable.rewind := @IXpbBuilderImpl_rewindDispatcher;
IXpbBuilderImpl_vTable.findFirst := @IXpbBuilderImpl_findFirstDispatcher;
IXpbBuilderImpl_vTable.findNext := @IXpbBuilderImpl_findNextDispatcher;
IXpbBuilderImpl_vTable.getTag := @IXpbBuilderImpl_getTagDispatcher;
IXpbBuilderImpl_vTable.getLength := @IXpbBuilderImpl_getLengthDispatcher;
IXpbBuilderImpl_vTable.getInt := @IXpbBuilderImpl_getIntDispatcher;
IXpbBuilderImpl_vTable.getBigInt := @IXpbBuilderImpl_getBigIntDispatcher;
IXpbBuilderImpl_vTable.getString := @IXpbBuilderImpl_getStringDispatcher;
IXpbBuilderImpl_vTable.getBytes := @IXpbBuilderImpl_getBytesDispatcher;
IXpbBuilderImpl_vTable.getBufferLength := @IXpbBuilderImpl_getBufferLengthDispatcher;
IXpbBuilderImpl_vTable.getBuffer := @IXpbBuilderImpl_getBufferDispatcher;

ITraceConnectionImpl_vTable := TraceConnectionVTable.create;
ITraceConnectionImpl_vTable.version := 9;
ITraceConnectionImpl_vTable.getKind := @ITraceConnectionImpl_getKindDispatcher;
ITraceConnectionImpl_vTable.getProcessID := @ITraceConnectionImpl_getProcessIDDispatcher;
ITraceConnectionImpl_vTable.getUserName := @ITraceConnectionImpl_getUserNameDispatcher;
ITraceConnectionImpl_vTable.getRoleName := @ITraceConnectionImpl_getRoleNameDispatcher;
ITraceConnectionImpl_vTable.getCharSet := @ITraceConnectionImpl_getCharSetDispatcher;
ITraceConnectionImpl_vTable.getRemoteProtocol := @ITraceConnectionImpl_getRemoteProtocolDispatcher;
ITraceConnectionImpl_vTable.getRemoteAddress := @ITraceConnectionImpl_getRemoteAddressDispatcher;
ITraceConnectionImpl_vTable.getRemoteProcessID := @ITraceConnectionImpl_getRemoteProcessIDDispatcher;
ITraceConnectionImpl_vTable.getRemoteProcessName := @ITraceConnectionImpl_getRemoteProcessNameDispatcher;

ITraceDatabaseConnectionImpl_vTable := TraceDatabaseConnectionVTable.create;
ITraceDatabaseConnectionImpl_vTable.version := 11;
ITraceDatabaseConnectionImpl_vTable.getKind := @ITraceDatabaseConnectionImpl_getKindDispatcher;
ITraceDatabaseConnectionImpl_vTable.getProcessID := @ITraceDatabaseConnectionImpl_getProcessIDDispatcher;
ITraceDatabaseConnectionImpl_vTable.getUserName := @ITraceDatabaseConnectionImpl_getUserNameDispatcher;
ITraceDatabaseConnectionImpl_vTable.getRoleName := @ITraceDatabaseConnectionImpl_getRoleNameDispatcher;
ITraceDatabaseConnectionImpl_vTable.getCharSet := @ITraceDatabaseConnectionImpl_getCharSetDispatcher;
ITraceDatabaseConnectionImpl_vTable.getRemoteProtocol := @ITraceDatabaseConnectionImpl_getRemoteProtocolDispatcher;
ITraceDatabaseConnectionImpl_vTable.getRemoteAddress := @ITraceDatabaseConnectionImpl_getRemoteAddressDispatcher;
ITraceDatabaseConnectionImpl_vTable.getRemoteProcessID := @ITraceDatabaseConnectionImpl_getRemoteProcessIDDispatcher;
ITraceDatabaseConnectionImpl_vTable.getRemoteProcessName := @ITraceDatabaseConnectionImpl_getRemoteProcessNameDispatcher;
ITraceDatabaseConnectionImpl_vTable.getConnectionID := @ITraceDatabaseConnectionImpl_getConnectionIDDispatcher;
ITraceDatabaseConnectionImpl_vTable.getDatabaseName := @ITraceDatabaseConnectionImpl_getDatabaseNameDispatcher;

ITraceTransactionImpl_vTable := TraceTransactionVTable.create;
ITraceTransactionImpl_vTable.version := 7;
ITraceTransactionImpl_vTable.getTransactionID := @ITraceTransactionImpl_getTransactionIDDispatcher;
ITraceTransactionImpl_vTable.getReadOnly := @ITraceTransactionImpl_getReadOnlyDispatcher;
ITraceTransactionImpl_vTable.getWait := @ITraceTransactionImpl_getWaitDispatcher;
ITraceTransactionImpl_vTable.getIsolation := @ITraceTransactionImpl_getIsolationDispatcher;
ITraceTransactionImpl_vTable.getPerf := @ITraceTransactionImpl_getPerfDispatcher;
ITraceTransactionImpl_vTable.getInitialID := @ITraceTransactionImpl_getInitialIDDispatcher;
ITraceTransactionImpl_vTable.getPreviousID := @ITraceTransactionImpl_getPreviousIDDispatcher;

ITraceParamsImpl_vTable := TraceParamsVTable.create;
ITraceParamsImpl_vTable.version := 3;
ITraceParamsImpl_vTable.getCount := @ITraceParamsImpl_getCountDispatcher;
ITraceParamsImpl_vTable.getParam := @ITraceParamsImpl_getParamDispatcher;
ITraceParamsImpl_vTable.getTextUTF8 := @ITraceParamsImpl_getTextUTF8Dispatcher;

ITraceStatementImpl_vTable := TraceStatementVTable.create;
ITraceStatementImpl_vTable.version := 2;
ITraceStatementImpl_vTable.getStmtID := @ITraceStatementImpl_getStmtIDDispatcher;
ITraceStatementImpl_vTable.getPerf := @ITraceStatementImpl_getPerfDispatcher;

ITraceSQLStatementImpl_vTable := TraceSQLStatementVTable.create;
ITraceSQLStatementImpl_vTable.version := 7;
ITraceSQLStatementImpl_vTable.getStmtID := @ITraceSQLStatementImpl_getStmtIDDispatcher;
ITraceSQLStatementImpl_vTable.getPerf := @ITraceSQLStatementImpl_getPerfDispatcher;
ITraceSQLStatementImpl_vTable.getText := @ITraceSQLStatementImpl_getTextDispatcher;
ITraceSQLStatementImpl_vTable.getPlan := @ITraceSQLStatementImpl_getPlanDispatcher;
ITraceSQLStatementImpl_vTable.getInputs := @ITraceSQLStatementImpl_getInputsDispatcher;
ITraceSQLStatementImpl_vTable.getTextUTF8 := @ITraceSQLStatementImpl_getTextUTF8Dispatcher;
ITraceSQLStatementImpl_vTable.getExplainedPlan := @ITraceSQLStatementImpl_getExplainedPlanDispatcher;

ITraceBLRStatementImpl_vTable := TraceBLRStatementVTable.create;
ITraceBLRStatementImpl_vTable.version := 5;
ITraceBLRStatementImpl_vTable.getStmtID := @ITraceBLRStatementImpl_getStmtIDDispatcher;
ITraceBLRStatementImpl_vTable.getPerf := @ITraceBLRStatementImpl_getPerfDispatcher;
ITraceBLRStatementImpl_vTable.getData := @ITraceBLRStatementImpl_getDataDispatcher;
ITraceBLRStatementImpl_vTable.getDataLength := @ITraceBLRStatementImpl_getDataLengthDispatcher;
ITraceBLRStatementImpl_vTable.getText := @ITraceBLRStatementImpl_getTextDispatcher;

ITraceDYNRequestImpl_vTable := TraceDYNRequestVTable.create;
ITraceDYNRequestImpl_vTable.version := 3;
ITraceDYNRequestImpl_vTable.getData := @ITraceDYNRequestImpl_getDataDispatcher;
ITraceDYNRequestImpl_vTable.getDataLength := @ITraceDYNRequestImpl_getDataLengthDispatcher;
ITraceDYNRequestImpl_vTable.getText := @ITraceDYNRequestImpl_getTextDispatcher;

ITraceContextVariableImpl_vTable := TraceContextVariableVTable.create;
ITraceContextVariableImpl_vTable.version := 3;
ITraceContextVariableImpl_vTable.getNameSpace := @ITraceContextVariableImpl_getNameSpaceDispatcher;
ITraceContextVariableImpl_vTable.getVarName := @ITraceContextVariableImpl_getVarNameDispatcher;
ITraceContextVariableImpl_vTable.getVarValue := @ITraceContextVariableImpl_getVarValueDispatcher;

ITraceProcedureImpl_vTable := TraceProcedureVTable.create;
ITraceProcedureImpl_vTable.version := 3;
ITraceProcedureImpl_vTable.getProcName := @ITraceProcedureImpl_getProcNameDispatcher;
ITraceProcedureImpl_vTable.getInputs := @ITraceProcedureImpl_getInputsDispatcher;
ITraceProcedureImpl_vTable.getPerf := @ITraceProcedureImpl_getPerfDispatcher;

ITraceFunctionImpl_vTable := TraceFunctionVTable.create;
ITraceFunctionImpl_vTable.version := 4;
ITraceFunctionImpl_vTable.getFuncName := @ITraceFunctionImpl_getFuncNameDispatcher;
ITraceFunctionImpl_vTable.getInputs := @ITraceFunctionImpl_getInputsDispatcher;
ITraceFunctionImpl_vTable.getResult := @ITraceFunctionImpl_getResultDispatcher;
ITraceFunctionImpl_vTable.getPerf := @ITraceFunctionImpl_getPerfDispatcher;

ITraceTriggerImpl_vTable := TraceTriggerVTable.create;
ITraceTriggerImpl_vTable.version := 5;
ITraceTriggerImpl_vTable.getTriggerName := @ITraceTriggerImpl_getTriggerNameDispatcher;
ITraceTriggerImpl_vTable.getRelationName := @ITraceTriggerImpl_getRelationNameDispatcher;
ITraceTriggerImpl_vTable.getAction := @ITraceTriggerImpl_getActionDispatcher;
ITraceTriggerImpl_vTable.getWhich := @ITraceTriggerImpl_getWhichDispatcher;
ITraceTriggerImpl_vTable.getPerf := @ITraceTriggerImpl_getPerfDispatcher;

ITraceServiceConnectionImpl_vTable := TraceServiceConnectionVTable.create;
ITraceServiceConnectionImpl_vTable.version := 12;
ITraceServiceConnectionImpl_vTable.getKind := @ITraceServiceConnectionImpl_getKindDispatcher;
ITraceServiceConnectionImpl_vTable.getProcessID := @ITraceServiceConnectionImpl_getProcessIDDispatcher;
ITraceServiceConnectionImpl_vTable.getUserName := @ITraceServiceConnectionImpl_getUserNameDispatcher;
ITraceServiceConnectionImpl_vTable.getRoleName := @ITraceServiceConnectionImpl_getRoleNameDispatcher;
ITraceServiceConnectionImpl_vTable.getCharSet := @ITraceServiceConnectionImpl_getCharSetDispatcher;
ITraceServiceConnectionImpl_vTable.getRemoteProtocol := @ITraceServiceConnectionImpl_getRemoteProtocolDispatcher;
ITraceServiceConnectionImpl_vTable.getRemoteAddress := @ITraceServiceConnectionImpl_getRemoteAddressDispatcher;
ITraceServiceConnectionImpl_vTable.getRemoteProcessID := @ITraceServiceConnectionImpl_getRemoteProcessIDDispatcher;
ITraceServiceConnectionImpl_vTable.getRemoteProcessName := @ITraceServiceConnectionImpl_getRemoteProcessNameDispatcher;
ITraceServiceConnectionImpl_vTable.getServiceID := @ITraceServiceConnectionImpl_getServiceIDDispatcher;
ITraceServiceConnectionImpl_vTable.getServiceMgr := @ITraceServiceConnectionImpl_getServiceMgrDispatcher;
ITraceServiceConnectionImpl_vTable.getServiceName := @ITraceServiceConnectionImpl_getServiceNameDispatcher;

ITraceStatusVectorImpl_vTable := TraceStatusVectorVTable.create;
ITraceStatusVectorImpl_vTable.version := 4;
ITraceStatusVectorImpl_vTable.hasError := @ITraceStatusVectorImpl_hasErrorDispatcher;
ITraceStatusVectorImpl_vTable.hasWarning := @ITraceStatusVectorImpl_hasWarningDispatcher;
ITraceStatusVectorImpl_vTable.getStatus := @ITraceStatusVectorImpl_getStatusDispatcher;
ITraceStatusVectorImpl_vTable.getText := @ITraceStatusVectorImpl_getTextDispatcher;

ITraceSweepInfoImpl_vTable := TraceSweepInfoVTable.create;
ITraceSweepInfoImpl_vTable.version := 5;
ITraceSweepInfoImpl_vTable.getOIT := @ITraceSweepInfoImpl_getOITDispatcher;
ITraceSweepInfoImpl_vTable.getOST := @ITraceSweepInfoImpl_getOSTDispatcher;
ITraceSweepInfoImpl_vTable.getOAT := @ITraceSweepInfoImpl_getOATDispatcher;
ITraceSweepInfoImpl_vTable.getNext := @ITraceSweepInfoImpl_getNextDispatcher;
ITraceSweepInfoImpl_vTable.getPerf := @ITraceSweepInfoImpl_getPerfDispatcher;

ITraceLogWriterImpl_vTable := TraceLogWriterVTable.create;
ITraceLogWriterImpl_vTable.version := 4;
ITraceLogWriterImpl_vTable.addRef := @ITraceLogWriterImpl_addRefDispatcher;
ITraceLogWriterImpl_vTable.release := @ITraceLogWriterImpl_releaseDispatcher;
ITraceLogWriterImpl_vTable.write := @ITraceLogWriterImpl_writeDispatcher;
ITraceLogWriterImpl_vTable.write_s := @ITraceLogWriterImpl_write_sDispatcher;

ITraceInitInfoImpl_vTable := TraceInitInfoVTable.create;
ITraceInitInfoImpl_vTable.version := 7;
ITraceInitInfoImpl_vTable.getConfigText := @ITraceInitInfoImpl_getConfigTextDispatcher;
ITraceInitInfoImpl_vTable.getTraceSessionID := @ITraceInitInfoImpl_getTraceSessionIDDispatcher;
ITraceInitInfoImpl_vTable.getTraceSessionName := @ITraceInitInfoImpl_getTraceSessionNameDispatcher;
ITraceInitInfoImpl_vTable.getFirebirdRootDirectory := @ITraceInitInfoImpl_getFirebirdRootDirectoryDispatcher;
ITraceInitInfoImpl_vTable.getDatabaseName := @ITraceInitInfoImpl_getDatabaseNameDispatcher;
ITraceInitInfoImpl_vTable.getConnection := @ITraceInitInfoImpl_getConnectionDispatcher;
ITraceInitInfoImpl_vTable.getLogWriter := @ITraceInitInfoImpl_getLogWriterDispatcher;

ITracePluginImpl_vTable := TracePluginVTable.create;
ITracePluginImpl_vTable.version := 23;
ITracePluginImpl_vTable.addRef := @ITracePluginImpl_addRefDispatcher;
ITracePluginImpl_vTable.release := @ITracePluginImpl_releaseDispatcher;
ITracePluginImpl_vTable.trace_get_error := @ITracePluginImpl_trace_get_errorDispatcher;
ITracePluginImpl_vTable.trace_attach := @ITracePluginImpl_trace_attachDispatcher;
ITracePluginImpl_vTable.trace_detach := @ITracePluginImpl_trace_detachDispatcher;
ITracePluginImpl_vTable.trace_transaction_start := @ITracePluginImpl_trace_transaction_startDispatcher;
ITracePluginImpl_vTable.trace_transaction_end := @ITracePluginImpl_trace_transaction_endDispatcher;
ITracePluginImpl_vTable.trace_proc_execute := @ITracePluginImpl_trace_proc_executeDispatcher;
ITracePluginImpl_vTable.trace_trigger_execute := @ITracePluginImpl_trace_trigger_executeDispatcher;
ITracePluginImpl_vTable.trace_set_context := @ITracePluginImpl_trace_set_contextDispatcher;
ITracePluginImpl_vTable.trace_dsql_prepare := @ITracePluginImpl_trace_dsql_prepareDispatcher;
ITracePluginImpl_vTable.trace_dsql_free := @ITracePluginImpl_trace_dsql_freeDispatcher;
ITracePluginImpl_vTable.trace_dsql_execute := @ITracePluginImpl_trace_dsql_executeDispatcher;
ITracePluginImpl_vTable.trace_blr_compile := @ITracePluginImpl_trace_blr_compileDispatcher;
ITracePluginImpl_vTable.trace_blr_execute := @ITracePluginImpl_trace_blr_executeDispatcher;
ITracePluginImpl_vTable.trace_dyn_execute := @ITracePluginImpl_trace_dyn_executeDispatcher;
ITracePluginImpl_vTable.trace_service_attach := @ITracePluginImpl_trace_service_attachDispatcher;
ITracePluginImpl_vTable.trace_service_start := @ITracePluginImpl_trace_service_startDispatcher;
ITracePluginImpl_vTable.trace_service_query := @ITracePluginImpl_trace_service_queryDispatcher;
ITracePluginImpl_vTable.trace_service_detach := @ITracePluginImpl_trace_service_detachDispatcher;
ITracePluginImpl_vTable.trace_event_error := @ITracePluginImpl_trace_event_errorDispatcher;
ITracePluginImpl_vTable.trace_event_sweep := @ITracePluginImpl_trace_event_sweepDispatcher;
ITracePluginImpl_vTable.trace_func_execute := @ITracePluginImpl_trace_func_executeDispatcher;

ITraceFactoryImpl_vTable := TraceFactoryVTable.create;
ITraceFactoryImpl_vTable.version := 6;
ITraceFactoryImpl_vTable.addRef := @ITraceFactoryImpl_addRefDispatcher;
ITraceFactoryImpl_vTable.release := @ITraceFactoryImpl_releaseDispatcher;
ITraceFactoryImpl_vTable.setOwner := @ITraceFactoryImpl_setOwnerDispatcher;
ITraceFactoryImpl_vTable.getOwner := @ITraceFactoryImpl_getOwnerDispatcher;
ITraceFactoryImpl_vTable.trace_needs := @ITraceFactoryImpl_trace_needsDispatcher;
ITraceFactoryImpl_vTable.trace_create := @ITraceFactoryImpl_trace_createDispatcher;

IUdrFunctionFactoryImpl_vTable := UdrFunctionFactoryVTable.create;
IUdrFunctionFactoryImpl_vTable.version := 3;
IUdrFunctionFactoryImpl_vTable.dispose := @IUdrFunctionFactoryImpl_disposeDispatcher;
IUdrFunctionFactoryImpl_vTable.setup := @IUdrFunctionFactoryImpl_setupDispatcher;
IUdrFunctionFactoryImpl_vTable.newItem := @IUdrFunctionFactoryImpl_newItemDispatcher;

IUdrProcedureFactoryImpl_vTable := UdrProcedureFactoryVTable.create;
IUdrProcedureFactoryImpl_vTable.version := 3;
IUdrProcedureFactoryImpl_vTable.dispose := @IUdrProcedureFactoryImpl_disposeDispatcher;
IUdrProcedureFactoryImpl_vTable.setup := @IUdrProcedureFactoryImpl_setupDispatcher;
IUdrProcedureFactoryImpl_vTable.newItem := @IUdrProcedureFactoryImpl_newItemDispatcher;

IUdrTriggerFactoryImpl_vTable := UdrTriggerFactoryVTable.create;
IUdrTriggerFactoryImpl_vTable.version := 3;
IUdrTriggerFactoryImpl_vTable.dispose := @IUdrTriggerFactoryImpl_disposeDispatcher;
IUdrTriggerFactoryImpl_vTable.setup := @IUdrTriggerFactoryImpl_setupDispatcher;
IUdrTriggerFactoryImpl_vTable.newItem := @IUdrTriggerFactoryImpl_newItemDispatcher;

IUdrPluginImpl_vTable := UdrPluginVTable.create;
IUdrPluginImpl_vTable.version := 4;
IUdrPluginImpl_vTable.getMaster := @IUdrPluginImpl_getMasterDispatcher;
IUdrPluginImpl_vTable.registerFunction := @IUdrPluginImpl_registerFunctionDispatcher;
IUdrPluginImpl_vTable.registerProcedure := @IUdrPluginImpl_registerProcedureDispatcher;
IUdrPluginImpl_vTable.registerTrigger := @IUdrPluginImpl_registerTriggerDispatcher;

finalization

IVersionedImpl_vTable.Destroy;
IReferenceCountedImpl_vTable.Destroy;
IDisposableImpl_vTable.Destroy;
IStatusImpl_vTable.Destroy;
IMasterImpl_vTable.Destroy;
IPluginBaseImpl_vTable.Destroy;
IPluginSetImpl_vTable.Destroy;
IConfigEntryImpl_vTable.Destroy;
IConfigImpl_vTable.Destroy;
IFirebirdConfImpl_vTable.Destroy;
IPluginConfigImpl_vTable.Destroy;
IPluginFactoryImpl_vTable.Destroy;
IPluginModuleImpl_vTable.Destroy;
IPluginManagerImpl_vTable.Destroy;
ICryptKeyImpl_vTable.Destroy;
IConfigManagerImpl_vTable.Destroy;
IEventCallbackImpl_vTable.Destroy;
IBlobImpl_vTable.Destroy;
ITransactionImpl_vTable.Destroy;
IMessageMetadataImpl_vTable.Destroy;
IMetadataBuilderImpl_vTable.Destroy;
IResultSetImpl_vTable.Destroy;
IStatementImpl_vTable.Destroy;
IRequestImpl_vTable.Destroy;
IEventsImpl_vTable.Destroy;
IAttachmentImpl_vTable.Destroy;
IServiceImpl_vTable.Destroy;
IProviderImpl_vTable.Destroy;
IDtcStartImpl_vTable.Destroy;
IDtcImpl_vTable.Destroy;
IAuthImpl_vTable.Destroy;
IWriterImpl_vTable.Destroy;
IServerBlockImpl_vTable.Destroy;
IClientBlockImpl_vTable.Destroy;
IServerImpl_vTable.Destroy;
IClientImpl_vTable.Destroy;
IUserFieldImpl_vTable.Destroy;
ICharUserFieldImpl_vTable.Destroy;
IIntUserFieldImpl_vTable.Destroy;
IUserImpl_vTable.Destroy;
IListUsersImpl_vTable.Destroy;
ILogonInfoImpl_vTable.Destroy;
IManagementImpl_vTable.Destroy;
IAuthBlockImpl_vTable.Destroy;
IWireCryptPluginImpl_vTable.Destroy;
ICryptKeyCallbackImpl_vTable.Destroy;
IKeyHolderPluginImpl_vTable.Destroy;
IDbCryptInfoImpl_vTable.Destroy;
IDbCryptPluginImpl_vTable.Destroy;
IExternalContextImpl_vTable.Destroy;
IExternalResultSetImpl_vTable.Destroy;
IExternalFunctionImpl_vTable.Destroy;
IExternalProcedureImpl_vTable.Destroy;
IExternalTriggerImpl_vTable.Destroy;
IRoutineMetadataImpl_vTable.Destroy;
IExternalEngineImpl_vTable.Destroy;
ITimerImpl_vTable.Destroy;
ITimerControlImpl_vTable.Destroy;
IVersionCallbackImpl_vTable.Destroy;
IUtilImpl_vTable.Destroy;
IOffsetsCallbackImpl_vTable.Destroy;
IXpbBuilderImpl_vTable.Destroy;
ITraceConnectionImpl_vTable.Destroy;
ITraceDatabaseConnectionImpl_vTable.Destroy;
ITraceTransactionImpl_vTable.Destroy;
ITraceParamsImpl_vTable.Destroy;
ITraceStatementImpl_vTable.Destroy;
ITraceSQLStatementImpl_vTable.Destroy;
ITraceBLRStatementImpl_vTable.Destroy;
ITraceDYNRequestImpl_vTable.Destroy;
ITraceContextVariableImpl_vTable.Destroy;
ITraceProcedureImpl_vTable.Destroy;
ITraceFunctionImpl_vTable.Destroy;
ITraceTriggerImpl_vTable.Destroy;
ITraceServiceConnectionImpl_vTable.Destroy;
ITraceStatusVectorImpl_vTable.Destroy;
ITraceSweepInfoImpl_vTable.Destroy;
ITraceLogWriterImpl_vTable.Destroy;
ITraceInitInfoImpl_vTable.Destroy;
ITracePluginImpl_vTable.Destroy;
ITraceFactoryImpl_vTable.Destroy;
IUdrFunctionFactoryImpl_vTable.Destroy;
IUdrProcedureFactoryImpl_vTable.Destroy;
IUdrTriggerFactoryImpl_vTable.Destroy;
IUdrPluginImpl_vTable.Destroy;

end.
