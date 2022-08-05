library kvo;

{$I .\sources\general.inc}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF UNIX}
  library_external in 'sources\library_external.pas',
  firebird_api in 'sources\firebird_api.pas',
  firebird_variables in 'sources\firebird_variables.pas',
  firebird_types in 'sources\firebird_types.pas',
  firebird_charset in 'sources\firebird_charset.pas',
  firebird_message_metadata in 'sources\firebird_message_metadata.pas',
  firebird_blob in 'sources\firebird_blob.pas',
  firebird_message_data in 'sources\firebird_message_data.pas',
  firebird_classes in 'sources\firebird_classes.pas',
  firebird_factories in 'sources\firebird_factories.pas',
  firebird_factories_base in 'sources\firebird_factories_base.pas',
  json_firebird_classes in 'json\json_firebird_classes.pas',
  stream_firebird_classes in 'stream\stream_firebird_classes.pas',
  stream_shared in 'stream\stream_shared.pas',
  udr_log in 'log\udr_log.pas',
  JsonDataObjectsKVO in 'json\JsonDataObjectsKVO.pas';

function firebird_udr_plugin(AStatus: IStatus; AUnloadFlagLocal: BooleanPtr; AUdrPlugin: IUdrPlugin): BooleanPtr; cdecl;
begin
  TUdrRegisterGeneral.Register(AStatus, AUdrPlugin);
  TUdrRegisterJson.Register(AStatus, AUdrPlugin);
  TUdrRegisterStream.Register(AStatus, AUdrPlugin);

  FirebirdSetting.theirUnloadFlag := AUnloadFlagLocal;
  Result := @FirebirdSetting.myUnloadFlag;
end;

exports
  firebird_udr_plugin;

begin
  IsMultiThread := true;

  // в DLL нельзя на прямую проверять так, ставь breakpoint на "getmem.inc".ShowMessage и наче будет висеть процесс
  // ReportMemoryLeaksOnShutdown := {$IFDEF RELEASE}false{$ELSE}true{$ENDIF RELEASE};
end.
