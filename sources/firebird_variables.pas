unit firebird_variables;

{$I general.inc}

interface

uses
  firebird_api;

type
  RFirebirdSetting = record
    myUnloadFlag: Boolean;
    theirUnloadFlag: BooleanPtr;
  end;

var
  FirebirdSetting: RFirebirdSetting;

resourcestring
  rsInputNominative = 'Входной';   // Именительный падеж
  rsInputGenitive = 'входных';     // Родительный падеж
  rsOutputNominative = 'Выходной'; // Именительный падеж
  rsOutputGenitive = 'выходных';   // Родительный падеж
  rsEndOfOV = 'ов';
  rsErrorNullOrEmpty = 'Ошибка данные пустые или значение равно NULL';
  rsErrorNotObjectOrArray = 'Ошибка указатель не является объектом или массивом';
  rsErrorDataTypeNotSupported = 'Не поддерживаемый тип данных';
  rsErrorDataTypeNotSupportedFormat = '%s параметр №%d не поддерживает тип данных %s';
  rsErrorClassNotSupportFormat = 'Класс %s не поддерживается';
  rsErrorDataTypeIsNotSupportedForDataEntityFormat = 'Для сущности %s, тип данных %s не поддерживается';
  rsErrorCountParamsFormat = 'Требуется %d %s параметр%s';
  rsErrorParameterTypesNotMatch = 'Типы параметров не соответствует';

implementation

initialization

FirebirdSetting.myUnloadFlag := True;

finalization

if assigned(FirebirdSetting.theirUnloadFlag) then
  if not FirebirdSetting.myUnloadFlag then
    FirebirdSetting.theirUnloadFlag^ := true;

end.
