SET TERM ^ ;

CREATE OR ALTER PACKAGE STREAM
AS
begin

  -- Уничтожает поток по его указателю handle
  -- входные параметры:
  --   handle - указатель на объект
  -- выходные параметры:
  --   Истина если объект уничтожен
  function destroy(handle d_id not null)
    returns d_bool not null;
  
  -- Создается новый поток в файле подкачки. Медленее, но объем ограничивается размером файловой системы
  -- выходные параметры:
  --  handle - указатель на объект
  --function  create_shared
  --  returns d_id;
  
  -- Создается новый поток в памяти. Быстро, но объем ограничивается размером виртуальной памяти всего процесса
  -- выходные параметры:
  --  handle - указатель на объект
  function  create_string
    returns d_id;

  -- Копирования данных из потока Source в поток Target
  -- входные параметры:
  --   handle_source - указатель на поток Source
  --   handle_targer - указатель на поток Target
  -- выходные параметры:
  --   Истина если объект уничтожен
  function  assign(handle_source d_id not null, handle_targer d_id not null)
    returns d_bool;

  -- Общий объем данных в потоке
  -- входные параметры:
  --   handle - указатель на поток
  -- выходные параметры:
  --   Объем данных в потоке
  function  size_get(handle d_id not null)
    returns d_id;
  
  --function  size_set(handle d_id not null, size_new d_id not null)
  --  returns d_id;

  -- Позиция в потоке
  -- входные параметры:
  --   handle - указатель на поток
  -- выходные параметры:
  --   Позиция в потоке
  function  position_get(handle d_id not null)
    returns d_id;
  
  -- Устанавливает новую позицию в потоке
  -- входные параметры:
  --   handle - указатель на поток
  --   position_new - новуа позицию в потоке
  -- выходные параметры:
  --   Устанавливленная позицию в потоке, может отличатся от желаемой
  function  position_set(handle d_id not null, position_new d_id not null)
    returns d_id;

  -- Текущий размер данных в битовом представлении в потоке
  -- входные параметры:
  --   handle - указатель на поток
  -- выходные параметры:
  --   Размер данных в потоке между Position и Size
  function  length_get(handle d_id not null)
    returns d_id;

  -- Текущий размер данных в символьном UTF8 представлении в потоке
  -- входные параметры:
  --   handle - указатель на поток
  -- выходные параметры:
  --   Размер данных в потоке между Position и Size
  function  length_char(handle d_id not null)
    returns d_id;

  -- Запись строки в поток
  -- входные параметры:
  --   handle - указатель на поток
  --   data_string - строка
  -- выходные параметры:
  --   Истина если данные записаны в поток
  function  write_s(handle d_id not null, data_string d_str_8100 not null)
    returns d_bool;
  
  -- Чтение строки из потока
  -- входные параметры:
  --   handle - указатель на поток
  --   read_lenght - Размер вычитывания данных
  -- выходные параметры:
  --   Строка которую получили из потока, зависит от Position
  function  read_s(handle d_id not null, read_lenght d_id not null)
    returns d_str_8100;

  -- Запись Blob в поток
  -- входные параметры:
  --   handle - указатель на поток
  --   data_string - Blob
  -- выходные параметры:
  --   Истина если данные записаны в поток
  function  write_b(handle d_id not null, data_blob d_blob_text not null)
    returns d_bool;
  
  -- Чтение Blob из потока
  -- входные параметры:
  --   handle - указатель на поток
  --   read_lenght - Размер вычитывания данных
  -- выходные параметры:
  --   Blob который получили из потока, зависит от Position
  function  read_b(handle d_id not null, read_lenght d_id not null)
    returns d_blob_text;

  -- Сохранить весь поток в строку
  -- входные параметры:
  --   handle - указатель на поток
  -- выходные параметры:
  --   Строка который получили из потока
  function  to_string(handle d_id not null)
    returns d_str_8100;
  
  -- Сохранить весь поток в Blob
  -- входные параметры:
  --   handle - указатель на поток
  -- выходные параметры:
  --   Blob который получили из потока
  function  to_blob(handle d_id not null)
    returns d_blob_text;
 
end
^

SET TERM ; ^