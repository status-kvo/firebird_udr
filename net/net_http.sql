SET TERM ^ ;

CREATE OR ALTER PACKAGE NET_HTTP
AS
begin

  -- создаем новый запрос
  -- входные параметры:
  --   method                     - метод запроса. connect, delete, get, post, head, options, put, trace, merge, patch
  --   url                        - адрес сервера. поддерживается как ip:port, так и domainname[:port]
  --   invalid_server_certificate - разрешить использовать недействительные сертификаты ssl
  -- входные параметры:
  --   указатель на новый запрос. обязательно уничтожать
  function create_request(method d_str_100 not null, url d_str_8100 not null, invalid_server_certificate d_bool not null)
    returns d_id;

  -- добавление в url дополнительного параметра ввиде ключ=значение
  -- входные параметры:
  --   request     - указатель на созданный запрос
  --   param_name  - имя(ключ) значения
  --   param_value - значения ключа
  -- входные параметры:
  --   логическое значение результата выполнения
  function url_add_parameter(request d_id not null, param_name d_str_100 not null, param_value d_str_8100 not null)
    returns d_bool;

  -- создает multipart/form-data. это составной тип содержимого, чаще всего использующийся для отправки html-форм с бинарными (не-ascii)
  --   данными методом post протокола http.
  -- входные параметры:
  --   request - указатель на созданный запрос
  -- входные параметры:
  --   указатель на новую форму. уничтожается автоматически
  function  create_multipart_formdata(request d_id not null)
    returns d_id;

  -- добавление в форму дополнительное поле ввиде поля=значение
  -- входные параметры:
  --   request     - указатель на созданный запрос
  --   field_name  - название поля
  --   field_value - значения поля
  -- входные параметры:
  --   логическое значение результата выполнения
  function  formdata_add_field_s(request d_id not null, field_name d_str_255 not null, field_value d_str_8100 not null)
    returns d_bool;

  -- добавление в форму дополнительное поле ввиде поля=значение
  -- входные параметры:
  --   request     - указатель на созданный запрос
  --   field_name  - название поля
  --   field_value - значения поля. blob
  -- входные параметры:
  --   логическое значение результата выполнения
  function  formdata_add_field_b(request d_id not null, field_name d_str_255 not null, field_value d_blob_text not null)
    returns d_bool;

  -- добавление в форму дополнительное поле с атрибутами
  -- входные параметры:
  --   request      - указатель на созданный запрос
  --   field_name   - название поля
  --   stream       - значения поля. blob
  --   filename     - атрибут поля ввиде названия файла
  --   content_type - атрибут поля ввиде типа контекста. https://ru.wikipedia.org/wiki/список_mime-типов
  -- входные параметры:
  --   логическое значение результата выполнения
  function  formdata_add_stream_b(request d_id not null, field_name d_str_255 not null, stream d_blob_text not null, filename d_str_8100 not null,
      content_type d_str_8100 not null)
    returns d_bool;

  -- добавления/изменения параметра в заголовке запроса ввиде ключ=значение
  -- входные параметры:
  --   request      - указатель на созданный запрос
  --   header_name  - имя(ключ) значения
  --   header_value - значения ключа
  -- входные параметры:
  --   логическое значение результата выполнения
  function request_header_value_set(request d_id not null, header_name d_str_100 not null, header_value d_str_8100 not null)
    returns d_bool;

  -- получение параметра в заголовке запроса по имени(ключу)
  -- входные параметры:
  --   request     - указатель на созданный запрос
  --   header_name - имя(ключ) значения
  -- входные параметры:
  --   значение найденного ключа
  function request_header_value_get(request d_id not null, header_name d_str_100 not null)
    returns d_str_8100;

  -- добавления/изменения параметра в заголовке запроса ввиде ключ=значение
  -- входные параметры:
  --   request - указатель на созданный запрос
  --   content - тело запроса. blob
  -- входные параметры:
  --   логическое значение результата выполнения
  function  request_content_set(request d_id not null, content d_blob_text not null)
    returns d_bool;

  -- выполения запроса. внимание!!! запрос будет автоматически уничтожен
  -- входные параметры:
  --   request - указатель на созданный запрос
  --   form - указатель на созданную форму
  -- выходные параметры:
  --   status_code - числовой кодов состояния. https://ru.wikipedia.org/wiki/список_кодов_состояния_http
  --   status_text - текстовое списание кодов состояния.
  --   content     - результат ответа в формате blob
  procedure request_execute(request d_id not null, form d_id default null)
    returns (status_code d_integer, status_text d_str_8100, content d_blob_text);

end^

RECREATE PACKAGE BODY NET_HTTP
AS
begin

  function create_request(method d_str_100 not null, url d_str_8100 not null, invalid_server_certificate d_bool not null)
    returns  d_id
    external name 'mbulak.udr!Net.HTTP.CreateRequest'
    engine   udr;

  function url_add_parameter(request d_id not null, param_name d_str_100 not null, param_value d_str_8100 not null)
    returns  d_bool
    external name 'mbulak.udr!Net.HTTP.UrlAddParameter'
    engine   udr;

  function  create_multipart_formdata(request d_id not null)
    returns  d_id
    external name 'mbulak.udr!Net.HTTP.CreateMultipartFormData'
    engine   udr;

  function  formdata_add_field_s(request d_id not null, field_name d_str_255 not null, field_value d_str_8100 not null)
    returns  d_bool
    external name 'mbulak.udr!Net.HTTP.FormDataAddFieldS'
    engine   udr;

  function  formdata_add_field_b(request d_id not null, field_name d_str_255 not null, field_value d_blob_text not null)
    returns  d_bool
    external name 'mbulak.udr!Net.HTTP.FormDataAddFieldB'
    engine   udr;

  function  formdata_add_stream_b(request d_id not null, field_name d_str_255 not null, stream d_blob_text not null, filename d_str_8100 not null,
      content_type d_str_8100 not null)
    returns  d_bool
    external name 'mbulak.udr!Net.HTTP.FormDataAddStreamB'
    engine   udr;

  function  request_header_value_set(request d_id not null, header_name d_str_100 not null, header_value d_str_8100 not null)
    returns  d_bool
    external name 'mbulak.udr!Net.HTTP.RequestHeaderValuePut'
    engine   udr;

  function  request_header_value_get(request d_id not null, header_name d_str_100 not null)
    returns  d_str_8100
    external name 'mbulak.udr!Net.HTTP.RequestHeaderValueGet'
    engine   udr;

  function  request_content_set(request d_id not null, content d_blob_text not null)
    returns  d_bool
    external name 'mbulak.udr!Net.HTTP.RequestContentPut'
    engine   udr;

  procedure request_execute(request d_id not null, form d_id)
    returns (status_code d_integer, status_text d_str_8100, content d_blob_text)
    external name 'mbulak.udr!Net.HTTP.RequestExecute'
    engine udr;

end
^

SET TERM ; ^

COMMENT ON PACKAGE NET_HTTP IS
'Пакет по работе по протоколу HTTP и HTTPS.
Поддерживает:
  1) Использования недействительных сертификатов ssl;
  2) Параметры через url-строку;
  3) Поддежка multipart/form-data.';

/* Существующие привилегии на этот пакет */

GRANT EXECUTE ON PACKAGE NET_HTTP TO SYSDBA;