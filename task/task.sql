SET TERM ^ ;

CREATE OR ALTER package task
AS
begin
 
  -- создаем новый поток она же задача, асинхронное выполение SQL-запроса
  -- входные параметры:
  --   id         - Идентификатор записи из таблицы TASKS для идентификации или null
  --   sql        - SQL-запрос, который будет выполнен
  --   auto_start - Если значение равно ИСТИНЕ(1), то потом будет автоматически запущен, после создания
  -- выходные параметры:
  --   указатель на новый поток (Handle)
  function create_task(id d_id, sql d_str_8100 not null, auto_start d_bool not null)
    returns  d_id not null;

  -- Запуск остановленного поток по его указателю
  -- входные параметры:
  --   handle - Указатель на поток
  -- выходные параметры:
  --   ИСТИНА(1), если поток запущен
  function start_by_handle(handle d_id not null)
    returns  d_bool not null;

  -- Запуск остановленного поток по его идентификатору записи из таблицы TASKS
  -- входные параметры:
  --   id - Идентификатор записи из таблицы TASKS
  -- выходные параметры:
  --   ИСТИНА(1), если поток запущен
  function start_by_id(id d_id not null)
    returns  d_bool not null;

  -- Остановка с последующим уничтожением поток по его указателю
  -- входные параметры:
  --   handle  - Указатель на поток
  --   is_wait - Если ИСТИНА(1), то система будет ожидать остановки потока(Синхронное выполнение)
  -- выходные параметры:
  --   ИСТИНА(1), если потоку отослана команда остановки или он ранее уже завершил работу
  function stop_by_handle(handle d_id not null, is_wait d_bool not null)
    returns  d_bool not null;

  -- Остановка с последующим уничтожением поток по его идентификатору записи из таблицы TASKS
  -- входные параметры:
  --   id      - Идентификатор записи из таблицы TASKS
  --   is_wait - Если ИСТИНА(1), то система будет ожидать остановки потока(Синхронное выполнение)
  -- выходные параметры:
  --   ИСТИНА(1), если потоку отослана команда остановки или он ранее уже завершил работу
  function stop_by_id(id d_id not null, is_wait d_bool not null)
    returns  d_bool not null;

  -- Проверка наличия команды остановки внутри вызова SQL-команды из потока. Поток ищется по его указателю
  -- входные параметры:
  --   id - Указатель на поток
  -- выходные параметры:
  --   ИСТИНА(1), если команда остановку присутсвует
  function is_terminated_by_handle(handle d_id not null)
    returns  d_bool not null;

  -- Проверка наличия команды остановки внутри вызова SQL-команды из потока. ППоток ищется по его идентификатору записи из таблицы TASKS
  -- входные параметры:
  --   id - Идентификатор записи из таблицы TASKS
  -- выходные параметры:
  --   ИСТИНА(1), если команда остановку присутсвует
  function is_terminated_by_id(id d_id not null)
    returns  d_bool not null;

end^

RECREATE PACKAGE BODY TASK
AS
begin
 
  function create_task(id d_id, sql d_str_8100 not null, auto_start d_bool not null)
    returns  d_id not null
    external name 'mbulak.udr!TASK.Create'
    engine   udr;

  function start_by_handle(handle d_id not null)
    returns  d_bool not null
    external name 'mbulak.udr!TASK.StartByHandle'
    engine   udr;

  function start_by_id(id d_id not null)
    returns  d_bool not null
    external name 'mbulak.udr!TASK.StartById'
    engine   udr;

  function stop_by_handle(handle d_id not null, is_wait d_bool not null)
    returns  d_bool not null
    external name 'mbulak.udr!TASK.StopByHandle'
    engine   udr;

  function stop_by_id(id d_id not null, is_wait d_bool not null)
    returns  d_bool not null
    external name 'mbulak.udr!TASK.StopById'
    engine   udr;

  function is_terminated_by_handle(handle d_id not null)
    returns  d_bool not null
    external name 'mbulak.udr!TASK.IsTerminatedByHandle'
    engine   udr;

  function is_terminated_by_id(id d_id not null)
    returns  d_bool not null
    external name 'mbulak.udr!TASK.IsTerminatedById'
    engine   udr;

end
^

SET TERM ; ^

/* Существующие привилегии на этот пакет */

GRANT EXECUTE ON PACKAGE TASK TO SYSDBA;