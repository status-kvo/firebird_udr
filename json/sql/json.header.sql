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

  -- Получить даты из массива по индексу
  -- входные параметры:
  --   handle                     - указатель на массив
  --   idx                        - целочисленный индекс элемента в массиве
  --   value_when_index_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Извлеченная дата из массива по указанному индексу
  function arr_get_d(handle d_id not null, idx d_integer not null, value_when_index_not_found d_date default null)
    returns d_date;

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

  -- Заменить\добавить дату в массиве по индексу
  -- входные параметры:
  --   handle    - указатель на массив
  --   idx       - целочисленный индекс элемента в массиве
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function arr_set_d(handle d_id not null, idx d_integer not null, value_new d_date)  
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

  -- Получить дату из объекта по ключу или пути
  -- входные параметры:
  --   handle                    - указатель на объект
  --   path                      - ключу или пути
  --   value_when_path_not_found - Значение элемент, если не найден элемент
  -- выходные параметры:
  --   Значение элемента
  function obj_get_d(handle d_id not null, path d_str_long not null, value_when_path_not_found d_date default null)
    returns d_date;

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

  -- Заменить\добавить дату в объект по ключу или пути
  -- входные параметры:
  --   handle    - указатель на объект
  --   path      - ключу или пути
  --   value_new - новое значение
  -- выходные параметры:
  --   Истина если успешно
  function obj_set_d(handle d_id not null, path d_str_8100 not null, value_new d_date)   
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
    returns d_id not null;

end
^

SET TERM ; ^