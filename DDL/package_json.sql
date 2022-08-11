SET SQL DIALECT 3;
SET NAMES UTF8;

SET TERM ^ ;

CREATE OR ALTER PACKAGE JSON
AS
begin

  -- Уничтожает объект по его указателю handle
  -- входные параметры:
  --   handle - указатель на объект
  -- выходные параметры:
  --   Истина если объект уничтожен
  function destroy(handle d_id not null)
    returns d_bool not null;

  -- Создания копии объекта
  -- входные параметры:
  --   handle - указатель на объект
  -- выходные параметры:
  --   указатель на склонированный объект
  function clone(handle d_id not null)
    returns d_id not null;

  -- Количество элементов в объекте или массиве
  -- входные параметры:
  --   handle - указатель на объект или массив
  -- выходные параметры:
  --   Количество элементов
  function count_get(handle d_id not null)
    returns d_integer;

  -- Длина структуры представленной в виде строки
  -- входные параметры:
  --   handle     - указатель на объект или массив
  --   is_compact - если значение равно "1", то система будет подготавливать компактный вид строки
  -- выходные параметры:
  --   длина строки
  function length_get(handle d_id not null, is_compact d_bool)
    returns d_id;

  -- Создается новый пустой массив
  -- выходные параметры:
  --   указатель на массив
  function arr_create()
    returns d_id not null;

  -- Удалить элемент из массива по индексу
  -- входные параметры:
  --   handle - указатель на объект
  --   idx    - целочисленный индекс элемента в массиве
  -- выходные параметры:
  --   Результат выполения операции
  function arr_delete(handle d_id not null, idx d_integer not null)
    returns d_bool not null;

  -- Получить логическое вырожение в числовом представлении из массива по индексу
  -- входные параметры:
  --   handle                     - указатель на объект
  --   idx                        - целочисленный индекс элемента в массиве
  --   value_when_index_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Значение элемента
  function arr_get_b(handle d_id not null, idx d_integer not null, value_when_index_not_found d_bool default null)
    returns d_bool;

  -- Получить логическое вырожение из массива по индексу
  -- входные параметры:
  --   handle                     - указатель на объект
  --   idx                        - целочисленный индекс элемента в массиве
  --   value_when_index_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Значение элемента
  function arr_get_bool(handle d_id not null, idx d_integer not null, value_when_index_not_found boolean default null)
    returns boolean;

  -- Получить строку из массива по индексу
  -- входные параметры:
  --   handle                     - указатель на массив
  --   idx                        - целочисленный индекс элемента в массиве
  --   value_when_index_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Извлеченная строка из массива по указанному индексу
  function arr_get_s(handle d_id not null, idx d_integer not null, value_when_index_not_found d_str_8100 default null)
    returns d_str_8100;

  -- Получить массив двоичных данных (blob) из массива по индексу
  -- входные параметры:
  --   handle                     - указатель на массив
  --   idx                        - целочисленный индекс элемента в массиве
  --   value_when_index_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Извлеченная строка из массива по указанному индексу
  function arr_get_blob(handle d_id not null, idx d_integer not null, value_when_index_not_found d_blob_text default null)
    returns d_blob_text;
 
  -- Получить вещественного числа типа d_float из массива по индексу
  -- входные параметры:
  --   handle                     - указатель на массив
  --   idx                        - целочисленный индекс элемента в массиве
  --   value_when_index_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Извлеченное вещественное число из массива по указанному индексу
  function arr_get_flt(handle d_id not null, idx d_integer not null, value_when_index_not_found d_float default null)
    returns d_float;

  -- Получить вещественного числа типа double из массива по индексу
  -- входные параметры:
  --   handle                     - указатель на массив
  --   idx                        - целочисленный индекс элемента в массиве
  --   value_when_index_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Извлеченное вещественное число из массива по указанному индексу
  function arr_get_f(handle d_id not null, idx d_integer not null, value_when_index_not_found d_double default null)
    returns d_double;

  -- Получить целое числа типа integer из массива по индексу
  -- входные параметры:
  --   handle                     - указатель на массив
  --   idx                        - целочисленный индекс элемента в массиве
  --   value_when_index_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Извлеченное целое число из массива по указанному индексу
  function arr_get_i(handle d_id not null, idx d_integer not null, value_when_index_not_found d_integer default null)
    returns d_integer;

  -- Получить целое числа типа bigint из массива по индексу
  -- входные параметры:
  --   handle                     - указатель на массив
  --   idx                        - целочисленный индекс элемента в массиве
  --   value_when_index_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Извлеченное целое число из массива по указанному индексу
  function arr_get_l(handle d_id not null, idx d_integer not null, value_when_index_not_found d_id default null)
    returns d_id;

  -- Получить времени из массива по индексу
  -- входные параметры:
  --   handle                     - указатель на массив
  --   idx                        - целочисленный индекс элемента в массиве
  --   value_when_index_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Извлеченная дата из массива по указанному индексу
  function arr_get_t(handle d_id not null, idx d_integer not null, value_when_index_not_found d_time default null)
    returns d_time;

  -- Получить даты из массива по индексу
  -- входные параметры:
  --   handle                     - указатель на массив
  --   idx                        - целочисленный индекс элемента в массиве
  --   value_when_index_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Извлеченная дата из массива по указанному индексу
  function arr_get_d(handle d_id not null, idx d_integer not null, value_when_index_not_found d_date default null)
    returns d_date;

  -- Получить даты и времени из массива по индексу
  -- входные параметры:
  --   handle                     - указатель на массив
  --   idx                        - целочисленный индекс элемента в массиве
  --   value_when_index_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Извлеченная дата из массива по указанному индексу
  function arr_get_dt(handle d_id not null, idx d_integer not null, value_when_index_not_found d_datetime default null)
    returns d_datetime;

  -- Получить даты и времени из массива по индексу
  -- входные параметры:
  --   handle                     - указатель на массив
  --   idx                        - целочисленный индекс элемента в массиве
  --   value_when_index_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Извлеченная дата из массива по указанному индексу
  function arr_get_ts(handle d_id not null, idx d_integer not null, value_when_index_not_found d_timestamp default null)
    returns d_timestamp;

  -- Получить объекта из массива по индексу
  -- входные параметры:
  --   handle - указатель на массив
  --   idx    - целочисленный индекс элемента в массиве
  -- выходные параметры:
  --   Извлеченный объекта из массива по указанному индексу
  function arr_get_o(handle d_id not null, idx d_integer not null)
    returns d_id;

  -- Получить массив из массива по индексу
  -- входные параметры:
  --   handle - указатель на массив
  --   idx    - целочисленный индекс элемента в массиве
  -- выходные параметры:
  --   Извлеченный массив из массива по указанному индексу
  function arr_get_a(handle d_id not null, idx d_integer not null)          
    returns d_id;

  -- Заменить\добавить логического вырожениф в массиве по индексу
  -- входные параметры:
  --   handle    - указатель на массив
  --   idx       - целочисленный индекс элемента в массиве
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function arr_set_bool(handle d_id not null, idx d_integer not null, value_new boolean)
    returns d_bool;

  -- Заменить\добавить логического вырожениф в массиве по индексу
  -- входные параметры:
  --   handle    - указатель на массив
  --   idx       - целочисленный индекс элемента в массиве
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function arr_set_b(handle d_id not null, idx d_integer not null, value_new d_bool)
    returns d_bool;

  -- Заменить\добавить строку в массиве по индексу
  -- входные параметры:
  --   handle    - указатель на массив
  --   idx       - целочисленный индекс элемента в массиве
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function arr_set_s(handle d_id not null, idx d_integer not null, value_new d_str_8100)
    returns d_bool;

  -- Заменить\добавить массив двоичных данных (blob) в массиве по индексу
  -- входные параметры:
  --   handle    - указатель на массив
  --   idx       - целочисленный индекс элемента в массиве
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function arr_set_blob(handle d_id not null, idx d_integer not null, value_new d_blob_text)
    returns d_bool;

  -- Заменить\добавить вещественное число типа d_float в массиве по индексу
  -- входные параметры:
  --   handle    - указатель на массив
  --   idx       - целочисленный индекс элемента в массиве
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function arr_set_flt(handle d_id not null, idx d_integer not null, value_new d_float)   
    returns d_bool;

  -- Заменить\добавить вещественное число типа double в массиве по индексу
  -- входные параметры:
  --   handle    - указатель на массив
  --   idx       - целочисленный индекс элемента в массиве
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function arr_set_f(handle d_id not null, idx d_integer not null, value_new d_double) 
    returns d_bool;

  -- Заменить\добавить целое число типа integer в массиве по индексу
  -- входные параметры:
  --   handle    - указатель на массив
  --   idx       - целочисленный индекс элемента в массиве
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function arr_set_i(handle d_id not null, idx d_integer not null, value_new d_integer) 
    returns d_bool;

  -- Заменить\добавить целое число типа bigint в массиве по индексу
  -- входные параметры:
  --   handle    - указатель на массив
  --   idx       - целочисленный индекс элемента в массиве
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function arr_set_l(handle d_id not null, idx d_integer not null, value_new d_id)   
    returns d_bool;

  -- Заменить\добавить время в массиве по индексу (Дата будет обнулена)
  -- входные параметры:
  --   handle    - указатель на массив
  --   idx       - целочисленный индекс элемента в массиве
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function arr_set_t(handle d_id not null, idx d_integer not null, value_new d_time)
    returns d_bool;

  -- Заменить\добавить дату в массиве по индексу
  -- входные параметры:
  --   handle    - указатель на массив
  --   idx       - целочисленный индекс элемента в массиве
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function arr_set_d(handle d_id not null, idx d_integer not null, value_new d_date)  
    returns d_bool;

  -- Заменить\добавить дату и время в массиве по индексу
  -- входные параметры:
  --   handle    - указатель на массив
  --   idx       - целочисленный индекс элемента в массиве
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function arr_set_dt(handle d_id not null, idx d_integer not null, value_new d_datetime)
    returns d_bool;

  -- Заменить\добавить TimeStamp в массиве по индексу
  -- входные параметры:
  --   handle    - указатель на массив
  --   idx       - целочисленный индекс элемента в массиве
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function arr_set_ts(handle d_id not null, idx d_integer not null, value_new d_timestamp)
    returns d_bool;

  -- Заменить\добавить объект в массиве по индексу
  -- входные параметры:
  --   handle    - указатель на массив
  --   idx       - целочисленный индекс элемента в массиве
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function arr_set_o(handle d_id not null, idx d_integer not null, value_new d_id)   
    returns d_bool;

  -- Заменить\добавить массив в массиве по индексу
  -- входные параметры:
  --   handle    - указатель на массив
  --   idx       - целочисленный индекс элемента в массиве
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function arr_set_a(handle d_id not null, idx d_integer not null, value_new d_id)
    returns d_bool;
  
  -- Создается новый пустой объект
  -- выходные параметры:
  --   указатель на объект
  function obj_create()
    returns d_id not null;

  -- Поиск элемент по ключу или пути в объекте
  -- входные параметры:
  --   handle    - указатель на объект
  --   path      - ключ или путь
  -- выходные параметры:
  --   Истина если элемент найден в объекте
  function obj_contains(handle d_id not null, path d_str_long not null)
    returns d_bool not null;

  -- Удалить элемент из объекта по ключу или пути
  -- входные параметры:
  --   handle - указатель на объект
  --   path   - ключу или пути
  -- выходные параметры:
  --   Результат выполения операции
  function obj_remove(handle d_id not null, path d_str_long not null)
    returns d_bool not null;

  -- Получить логическое вырожение в числовом представлении из объекта по ключу или пути
  -- входные параметры:
  --   handle                    - указатель на объект
  --   path                      - ключу или пути
  --   value_when_path_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Значение элемента
  function obj_get_b(handle d_id not null, path d_str_long not null, value_when_path_not_found d_bool default null)
    returns d_bool;

  -- Получить логическое вырожение из объекта по ключу или пути
  -- входные параметры:
  --   handle                    - указатель на объект
  --   path                      - ключу или пути
  --   value_when_path_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Значение элемента
  function obj_get_bool(handle d_id not null, path d_str_long not null, value_when_path_not_found boolean default null)
    returns boolean;

  -- Получить строку из объекта по ключу или пути
  -- входные параметры:
  --   handle                    - указатель на объект
  --   path                      - ключу или пути
  --   value_when_path_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Значение элемента
  function obj_get_s(handle d_id not null, path d_str_long not null, value_when_path_not_found d_str_8100 default null)
    returns d_str_8100;

  -- Получить массив двоичных данных (blob) из объекта по ключу или пути
  -- входные параметры:
  --   handle                    - указатель на объект
  --   path                      - ключу или пути
  --   value_when_path_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Значение элемента
  function obj_get_blob(handle d_id not null, path d_str_long not null, value_when_path_not_found d_blob_text default null)
    returns d_blob_text;

  -- Получить вещественного числа типа d_float из объекта по ключу или пути
  -- входные параметры:
  --   handle                    - указатель на объект
  --   path                      - ключу или пути
  --   value_when_path_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Значение элемента
  function obj_get_flt(handle d_id not null, path d_str_long not null, value_when_path_not_found d_float default null)
    returns d_float;

  -- Получить вещественного числа типа double из объекта по ключу или пути
  -- входные параметры:
  --   handle                    - указатель на объект
  --   path                      - ключу или пути
  --   value_when_path_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Значение элемента
  function obj_get_f(handle d_id not null, path d_str_long not null, value_when_path_not_found d_double default null)
    returns d_double;

  -- Получить целое числа типа integer из объекта по ключу или пути
  -- входные параметры:
  --   handle                    - указатель на объект
  --   path                      - ключу или пути
  --   value_when_path_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Значение элемента
  function obj_get_i(handle d_id not null, path d_str_long not null, value_when_path_not_found d_integer default null)
    returns d_integer;

  -- Получить целое числа типа bigint из объекта по ключу или пути
  -- входные параметры:
  --   handle                    - указатель на объект
  --   path                      - ключу или пути
  --   value_when_path_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Значение элемента
  function obj_get_l(handle d_id not null, path d_str_long not null, value_when_path_not_found d_id default null)
    returns d_id;

  -- Получить время из объекта по ключу или пути
  -- входные параметры:
  --   handle                    - указатель на объект
  --   path                      - ключу или пути
  --   value_when_path_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Значение элемента
  function obj_get_t(handle d_id not null, path d_str_long not null, value_when_path_not_found d_time default null)
    returns d_time;

  -- Получить дату из объекта по ключу или пути
  -- входные параметры:
  --   handle                    - указатель на объект
  --   path                      - ключу или пути
  --   value_when_path_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Значение элемента
  function obj_get_d(handle d_id not null, path d_str_long not null, value_when_path_not_found d_date default null)
    returns d_date;

  -- Получить дату и время из объекта по ключу или пути
  -- входные параметры:
  --   handle                    - указатель на объект
  --   path                      - ключу или пути
  --   value_when_path_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Значение элемента
  function obj_get_dt(handle d_id not null, path d_str_long not null, value_when_path_not_found d_datetime default null)
    returns d_datetime;

  -- Получить TimeStamp из объекта по ключу или пути
  -- входные параметры:
  --   handle                    - указатель на объект
  --   path                      - ключу или пути
  --   value_when_path_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Значение элемента
  function obj_get_ts(handle d_id not null, path d_str_long not null, value_when_path_not_found d_timestamp default null)
    returns d_timestamp;

  -- Получить объект из объекта по ключу или пути
  -- входные параметры:
  --   handle - указатель на объект
  --   path   - ключу или пути
  -- выходные параметры:
  --   Значение элемента
  function obj_get_o(handle d_id not null, path d_str_long not null)          
    returns d_id;

  -- Получить массив из объекта по ключу или пути
  -- входные параметры:
  --   handle - указатель на объект
  --   path   - ключу или пути
  -- выходные параметры:
  --   Значение элемента
  function obj_get_a(handle d_id not null, path d_str_long not null)          
    returns d_id;

  -- Заменить\добавить логическое вырожения в объект по ключу или пути
  -- входные параметры:
  --   handle    - указатель на объект
  --   path      - ключу или пути
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function obj_set_b(handle d_id not null, path d_str_8100 not null, value_new d_bool)
    returns d_bool;

  -- Заменить\добавить логическое вырожения в объект по ключу или пути
  -- входные параметры:
  --   handle    - указатель на объект
  --   path      - ключу или пути
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function obj_set_bool(handle d_id not null, path d_str_8100 not null, value_new boolean)
    returns d_bool;
     
  -- Заменить\добавить строку в объект по ключу или пути
  -- входные параметры:
  --   handle    - указатель на объект
  --   path      - ключу или пути
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function obj_set_s(handle d_id not null, path d_str_8100 not null, value_new d_str_8100) 
    returns d_bool;

  -- Заменить\добавить массив двоичных данных (blob) в объект по ключу или пути
  -- входные параметры:
  --   handle    - указатель на объект
  --   path      - ключу или пути
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function obj_set_blob(handle d_id not null, path d_str_8100 not null, value_new d_blob_text)
    returns d_bool;

  -- Заменить\добавить вещественное число типа d_float в объект по ключу или пути
  -- входные параметры:
  --   handle    - указатель на объект
  --   path      - ключу или пути
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function obj_set_flt(handle d_id not null, path d_str_8100 not null, value_new d_float)   
    returns d_bool;

  -- Заменить\добавить вещественное число типа double в объект по ключу или пути
  -- входные параметры:
  --   handle    - указатель на объект
  --   path      - ключу или пути
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function obj_set_f(handle d_id not null, path d_str_8100 not null, value_new d_double)  
    returns d_bool;

  -- Заменить\добавить целое число типа integer в объект по ключу или пути
  -- входные параметры:
  --   handle    - указатель на объект
  --   path      - ключу или пути
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function obj_set_i(handle d_id not null, path d_str_8100 not null, value_new d_integer) 
    returns d_bool;

  -- Заменить\добавить целое число типа bigint в объект по ключу или пути
  -- входные параметры:
  --   handle    - указатель на объект
  --   path      - ключу или пути
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function obj_set_l(handle d_id not null, path d_str_8100 not null, value_new d_id)    
    returns d_bool;

  -- Заменить\добавить время в объект по ключу или пути
  -- входные параметры:
  --   handle    - указатель на объект
  --   path      - ключу или пути
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function obj_set_t(handle d_id not null, path d_str_8100 not null, value_new d_time)
    returns d_bool;

  -- Заменить\добавить дату в объект по ключу или пути
  -- входные параметры:
  --   handle    - указатель на объект
  --   path      - ключу или пути
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function obj_set_d(handle d_id not null, path d_str_8100 not null, value_new d_date)   
    returns d_bool;

  -- Заменить\добавить дату и время в объект по ключу или пути
  -- входные параметры:
  --   handle    - указатель на объект
  --   path      - ключу или пути
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function obj_set_dt(handle d_id not null, path d_str_8100 not null, value_new d_datetime)
    returns d_bool;

  -- Заменить\добавить TimeStamp в объект по ключу или пути
  -- входные параметры:
  --   handle    - указатель на объект
  --   path      - ключу или пути
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function obj_set_ts(handle d_id not null, path d_str_8100 not null, value_new d_timestamp)
    returns d_bool;

  -- Заменить\добавить объект в объект по ключу или пути
  -- входные параметры:
  --   handle    - указатель на объект
  --   path      - ключу или пути
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function obj_set_o(handle d_id not null, path d_str_8100 not null, value_new d_id)    
    returns d_bool;

  -- Заменить\добавить массив в объект по ключу или пути
  -- входные параметры:
  --   handle    - указатель на объект
  --   path      - ключу или пути
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function obj_set_a(handle d_id not null, path d_str_8100 not null, value_new d_id)
    returns d_bool;

  -- Сериализация (преобразование) объекта или массива в строку
  -- входные параметры:
  --   handle     - указатель на объект
  --   is_compact - Истина если нужен компактный вид полученной структуры
  -- выходные параметры:
  --   Истина если успешно
  function to_str(handle d_id not null, is_compact d_bool)
    returns d_str_8100;

  -- Сериализация (преобразование) объекта или массива в массив двоичных данных (blob)
  -- входные параметры:
  --   handle     - указатель на объект
  --   is_compact - Истина если нужен компактный вид полученной структуры
  -- выходные параметры:
  --   Истина если успешно
  function to_blob(handle d_id not null, is_compact d_bool not null)
    returns d_blob_text;

  -- Десериализация (восстановление) объекта или массива из строки
  -- входные параметры:
  --   handle     - указатель на объект
  -- выходные параметры:
  --   Истина если успешно
  function parse_str(data_string d_str_8100 not null)
    returns d_id not null;

  -- Десериализация (восстановление) объекта или массива из массива двоичных данных (blob)
  -- входные параметры:
  --   handle     - указатель на объект
  -- выходные параметры:
  --   Истина если успешно
  function parse_blob(data_blob d_blob_text not null)
    returns d_id;

end^

SET TERM ; ^

SET TERM ^ ;

RECREATE PACKAGE BODY JSON
AS
begin

  function destroy(handle d_id not null)
    returns  d_bool not null
    external name 'kvo.udr!Destroy'
    engine   udr;

  function clone(handle d_id not null)
    returns  d_id not null
    external name 'kvo.udr!JsonClone'
    engine   udr;

  function count_get(handle d_id not null)
    returns  d_integer
    external name 'kvo.udr!JsonCountGet'
    engine   udr;

  function length_get(handle d_id not null, is_compact d_bool)
    returns  d_id
    external name 'kvo.udr!JsonLengthGet'
    engine   udr;

  function arr_create()
    returns  d_id not null
    external name 'kvo.udr!JsonArrayCreate'
    engine   udr;

  function arr_delete(handle d_id not null, idx d_integer not null)
    returns d_bool not null
    external name 'kvo.udr!JsonArrayDeleteByIndex'
    engine   udr;

  function arr_get_b(handle d_id not null, idx d_integer not null, value_when_index_not_found d_bool)
    returns  d_bool
    external name 'kvo.udr!JsonArrayGetInt16'
    engine   udr;

  function arr_get_bool(handle d_id not null, idx d_integer not null, value_when_index_not_found boolean)
    returns  boolean
    external name 'kvo.udr!JsonArrayGetBool'
    engine   udr;

  function arr_get_s(handle d_id not null, idx d_integer not null, value_when_index_not_found d_str_8100)
    returns  d_str_8100
    external name 'kvo.udr!JsonArrayGetString'
    engine   udr;

  function arr_get_blob(handle d_id not null, idx d_integer not null, value_when_index_not_found d_blob_text)
    returns  d_blob_text
    external name 'kvo.udr!JsonArrayGetBlob'
    engine   udr;

  function arr_get_flt(handle d_id not null, idx d_integer not null, value_when_index_not_found d_float)
    returns  d_float
    external name 'kvo.udr!JsonArrayGetFloat'
    engine   udr;

  function arr_get_f(handle d_id not null, idx d_integer not null, value_when_index_not_found d_double)
    returns  d_double
    external name 'kvo.udr!JsonArrayGetDouble'
    engine   udr;

  function arr_get_i(handle d_id not null, idx d_integer not null, value_when_index_not_found d_integer)
    returns  d_integer
    external name 'kvo.udr!JsonArrayGetInt32'
    engine   udr;

  function arr_get_l(handle d_id not null, idx d_integer not null, value_when_index_not_found d_id)
    returns  d_id
    external name 'kvo.udr!JsonArrayGetInt64'
    engine   udr;

  function arr_get_t(handle d_id not null, idx d_integer not null, value_when_index_not_found d_time)
    returns  d_time
    external name 'kvo.udr!JsonArrayGetTime'
    engine   udr;

  function arr_get_d(handle d_id not null, idx d_integer not null, value_when_index_not_found d_date)
    returns  d_date
    external name 'kvo.udr!JsonArrayGetDate'
    engine   udr;

  function arr_get_dt(handle d_id not null, idx d_integer not null, value_when_index_not_found d_datetime)
    returns  d_datetime
    external name 'kvo.udr!JsonArrayGetDateTime'
    engine   udr;

  function arr_get_ts(handle d_id not null, idx d_integer not null, value_when_index_not_found d_timestamp)
    returns  d_timestamp
    external name 'kvo.udr!JsonArrayGetTimeStamp'
    engine   udr;

  function arr_get_o(handle d_id not null, idx d_integer not null)
    returns  d_id
    external name 'kvo.udr!JsonArrayGetObject'
    engine   udr;

  function arr_get_a(handle d_id not null, idx d_integer not null)
    returns  d_id
    external name 'kvo.udr!JsonArrayGetArray'
    engine   udr;

  function arr_set_b(handle d_id not null, idx d_integer not null, value_new d_bool)
    returns  d_bool
    external name 'kvo.udr!JsonArrayPutInt16'
    engine   udr;

  function arr_set_bool(handle d_id not null, idx d_integer not null, value_new boolean)
    returns  d_bool
    external name 'kvo.udr!JsonArrayPutBool'
    engine   udr;

  function arr_set_s(handle d_id not null, idx d_integer not null, value_new d_str_8100)
    returns  d_bool
    external name 'kvo.udr!JsonArrayPutString'
    engine   udr;

  function arr_set_blob(handle d_id not null, idx d_integer not null, value_new d_blob_text)
    returns  d_bool
    external name 'kvo.udr!JsonArrayPutBlob'
    engine   udr;

  function arr_set_flt(handle d_id not null, idx d_integer not null, value_new d_float)
    returns  d_bool
    external name 'kvo.udr!JsonArrayPutFloat'
    engine   udr;

  function arr_set_f(handle d_id not null, idx d_integer not null, value_new d_double)
    returns  d_bool
    external name 'kvo.udr!JsonArrayPutDouble'
    engine   udr;

  function arr_set_i(handle d_id not null, idx d_integer not null, value_new d_integer)
    returns  d_bool
    external name 'kvo.udr!JsonArrayPutInt32'
    engine   udr;

  function arr_set_l(handle d_id not null, idx d_integer not null, value_new d_id)
    returns  d_bool
    external name 'kvo.udr!JsonArrayPutInt64'
    engine   udr;

  function arr_set_t(handle d_id not null, idx d_integer not null, value_new d_time)
    returns  d_bool
    external name 'kvo.udr!JsonArrayPutTime'
    engine   udr;

  function arr_set_d(handle d_id not null, idx d_integer not null, value_new d_date)
    returns  d_bool
    external name 'kvo.udr!JsonArrayPutDate'
    engine   udr;

  function arr_set_dt(handle d_id not null, idx d_integer not null, value_new d_datetime)
    returns  d_bool
    external name 'kvo.udr!JsonArrayPutDateTime'
    engine   udr;

  function arr_set_ts(handle d_id not null, idx d_integer not null, value_new d_timestamp)
    returns  d_bool
    external name 'kvo.udr!JsonArrayPutTimeStamp'
    engine   udr;

  function arr_set_o(handle d_id not null, idx d_integer not null, value_new d_id)
    returns  d_bool
    external name 'kvo.udr!JsonArrayPutComplex'
    engine   udr;

  function arr_set_a(handle d_id not null, idx d_integer not null, value_new d_id)
    returns  d_bool
    external name 'kvo.udr!JsonArrayPutComplex'
    engine   udr;

  function obj_create()
    returns  d_id not null
    external name 'kvo.udr!JsonObjectCreate'
    engine   udr;

  function obj_contains(handle d_id not null, path d_str_long not null)
    returns  d_bool not null
    external name 'kvo.udr!JsonObjectContains'
    engine   udr;

  function obj_remove(handle d_id not null, path d_str_long not null)
    returns d_bool not null
    external name 'kvo.udr!JsonObjectRemoveItem'
    engine   udr;

  function obj_get_b(handle d_id not null, path d_str_long not null, value_when_path_not_found d_bool)
    returns  d_bool
    external name 'kvo.udr!JsonObjectGetInt16'
    engine   udr;

  function obj_get_bool(handle d_id not null, path d_str_long not null, value_when_path_not_found boolean)
    returns  boolean
    external name 'kvo.udr!JsonObjectGetBool'
    engine   udr;

  function obj_get_s(handle d_id not null, path d_str_long not null, value_when_path_not_found d_str_8100)
    returns  d_str_8100
    external name 'kvo.udr!JsonObjectGetString'
    engine   udr;

  function obj_get_blob(handle d_id not null, path d_str_long not null, value_when_path_not_found d_blob_text)
    returns  d_blob_text
    external name 'kvo.udr!JsonObjectGetBlob'
    engine   udr;

  function obj_get_flt(handle d_id not null, path d_str_long not null, value_when_path_not_found d_float)
    returns  d_float
    external name 'kvo.udr!JsonObjectGetFloat'
    engine   udr;

  function obj_get_f(handle d_id not null, path d_str_long not null, value_when_path_not_found d_double)
    returns  d_double
    external name 'kvo.udr!JsonObjectGetDouble'
    engine   udr;

  function obj_get_i(handle d_id not null, path d_str_long not null, value_when_path_not_found d_integer)
    returns  d_integer
    external name 'kvo.udr!JsonObjectGetInt32'
    engine   udr;

  function obj_get_l(handle d_id not null, path d_str_long not null, value_when_path_not_found d_id)
    returns  d_id
    external name 'kvo.udr!JsonObjectGetInt64'
    engine   udr;

  function obj_get_t(handle d_id not null, path d_str_long not null, value_when_path_not_found d_time)
    returns  d_time
    external name 'kvo.udr!JsonObjectGetTime'
    engine   udr;

  function obj_get_d(handle d_id not null, path d_str_long not null, value_when_path_not_found d_date)
    returns  d_date
    external name 'kvo.udr!JsonObjectGetDate'
    engine   udr;

  function obj_get_dt(handle d_id not null, path d_str_long not null, value_when_path_not_found d_datetime)
    returns  d_datetime
    external name 'kvo.udr!JsonObjectGetDateTime'
    engine   udr;

  function obj_get_ts(handle d_id not null, path d_str_long not null, value_when_path_not_found d_timestamp)
    returns  d_timestamp
    external name 'kvo.udr!JsonObjectGetTimeStamp'
    engine   udr;

  function obj_get_o(handle d_id not null, path d_str_long not null)
    returns  d_id
    external name 'kvo.udr!JsonObjectGetObject'
    engine   udr;

  function obj_get_a(handle d_id not null, path d_str_long not null)
    returns  d_id
    external name 'kvo.udr!JsonObjectGetArray'
    engine   udr;

  function obj_set_b(handle d_id not null, path d_str_8100 not null, value_new d_bool)
    returns  d_bool
    external name 'kvo.udr!JsonObjectPutInt16'
    engine   udr;

  function obj_set_bool(handle d_id not null, path d_str_8100 not null, value_new boolean)
    returns  d_bool
    external name 'kvo.udr!JsonObjectPutBool'
    engine   udr;

  function obj_set_s(handle d_id not null, path d_str_8100 not null, value_new d_str_8100)
    returns  d_bool
    external name 'kvo.udr!JsonObjectPutString'
    engine   udr;

  function obj_set_blob(handle d_id not null, path d_str_8100 not null, value_new d_blob_text)
    returns  d_bool
    external name 'kvo.udr!JsonObjectPutBlob'
    engine   udr;

  function obj_set_flt(handle d_id not null, path d_str_8100 not null, value_new d_float)
    returns  d_bool
    external name 'kvo.udr!JsonObjectPutFloat'
    engine   udr;

  function obj_set_f(handle d_id not null, path d_str_8100 not null, value_new d_double)
    returns  d_bool
    external name 'kvo.udr!JsonObjectPutDouble'
    engine   udr;

  function obj_set_i(handle d_id not null, path d_str_8100 not null, value_new d_integer)
    returns  d_bool
    external name 'kvo.udr!JsonObjectPutInt32'
    engine   udr;

  function obj_set_l(handle d_id not null, path d_str_8100 not null, value_new d_id)
    returns  d_bool
    external name 'kvo.udr!JsonObjectPutInt64'
    engine   udr;

  function obj_set_t(handle d_id not null, path d_str_8100 not null, value_new d_time)
    returns  d_bool
    external name 'kvo.udr!JsonObjectPutTime'
    engine   udr;

  function obj_set_d(handle d_id not null, path d_str_8100 not null, value_new d_date)
    returns  d_bool
    external name 'kvo.udr!JsonObjectPutDate'
    engine   udr;

  function obj_set_dt(handle d_id not null, path d_str_8100 not null, value_new d_datetime)
    returns  d_bool
    external name 'kvo.udr!JsonObjectPutDateTime'
    engine   udr;

  function obj_set_ts(handle d_id not null, path d_str_8100 not null, value_new d_timestamp)
    returns  d_bool
    external name 'kvo.udr!JsonObjectPutTimeStamp'
    engine   udr;

  function obj_set_o(handle d_id not null, path d_str_8100 not null, value_new d_id)
    returns  d_bool
    external name 'kvo.udr!JsonObjectPutComplex'
    engine   udr;

  function obj_set_a(handle d_id not null, path d_str_8100 not null, value_new d_id)
    returns  d_bool
    external name 'kvo.udr!JsonObjectPutComplex'
    engine   udr;

  function to_str(handle d_id not null, is_compact d_bool)
    returns  d_str_8100
    external name 'kvo.udr!JsonDeSerializationText'
    engine udr;

  function to_blob(handle d_id not null, is_compact d_bool not null)
    returns  d_blob_text
    external name 'kvo.udr!JsonDeSerializationBlob'
    engine udr;

  function parse_str(data_string d_str_8100 not null)
    returns  d_id not null
    external name 'kvo.udr!JsonSerializationText'
    engine udr;

  function parse_blob(data_blob d_blob_text not null)
    returns  d_id
    external name 'kvo.udr!JsonSerializationBlob'
    engine udr;

end
^

SET TERM ; ^