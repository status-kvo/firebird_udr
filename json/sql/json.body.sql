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
    external name 'kvo.udr!Clone'
    engine   udr;

  function count_get(handle d_id not null)
    returns  d_integer
    external name 'kvo.udr!CountGet'
    engine   udr;

  function length_get(handle d_id not null, is_compact d_bool)
    returns  d_id
    external name 'kvo.udr!LengthGet'
    engine   udr;

  function arr_create()
    returns  d_id not null
    external name 'kvo.udr!ArrayCreate'
    engine   udr;

  function arr_delete(handle d_id not null, idx d_integer not null)
    returns d_bool not null
    external name 'kvo.udr!ArrayDeleteByIndex'
    engine   udr;

  function arr_get_b(handle d_id not null, idx d_integer not null, value_when_index_not_found d_bool)
    returns  d_bool
    external name 'kvo.udr!ArrayGetInt16'
    engine   udr;

  function arr_get_bool(handle d_id not null, idx d_integer not null, value_when_index_not_found boolean)
    returns  boolean
    external name 'kvo.udr!ArrayGetBool'
    engine   udr;

  function arr_get_s(handle d_id not null, idx d_integer not null, value_when_index_not_found d_str_8100)
    returns  d_str_8100
    external name 'kvo.udr!ArrayGetString'
    engine   udr;

  function arr_get_blob(handle d_id not null, idx d_integer not null, value_when_index_not_found d_blob_text)
    returns  d_blob_text
    external name 'kvo.udr!ArrayGetBlob'
    engine   udr;

  function arr_get_flt(handle d_id not null, idx d_integer not null, value_when_index_not_found d_float)
    returns  d_float
    external name 'kvo.udr!ArrayGetFloat'
    engine   udr;

  function arr_get_f(handle d_id not null, idx d_integer not null, value_when_index_not_found d_double)
    returns  d_double
    external name 'kvo.udr!ArrayGetDouble'
    engine   udr;

  function arr_get_i(handle d_id not null, idx d_integer not null, value_when_index_not_found d_integer)
    returns  d_integer
    external name 'kvo.udr!ArrayGetInt32'
    engine   udr;

  function arr_get_l(handle d_id not null, idx d_integer not null, value_when_index_not_found d_id)
    returns  d_id
    external name 'kvo.udr!ArrayGetInt64'
    engine   udr;

  function arr_get_d(handle d_id not null, idx d_integer not null, value_when_index_not_found d_date)
    returns  d_date
    external name 'kvo.udr!ArrayGetDate'
    engine   udr;

  function arr_get_o(handle d_id not null, idx d_integer not null)
    returns  d_id
    external name 'kvo.udr!ArrayGetObject'
    engine   udr;

  function arr_get_a(handle d_id not null, idx d_integer not null)
    returns  d_id
    external name 'kvo.udr!ArrayGetArray'
    engine   udr;

  function arr_set_b(handle d_id not null, idx d_integer not null, value_new d_bool)
    returns  d_bool
    external name 'kvo.udr!ArrayPutInt16'
    engine   udr;

  function arr_set_bool(handle d_id not null, idx d_integer not null, value_new boolean)
    returns  d_bool
    external name 'kvo.udr!ArrayPutBool'
    engine   udr;

  function arr_set_s(handle d_id not null, idx d_integer not null, value_new d_str_8100)
    returns  d_bool
    external name 'kvo.udr!ArrayPutString'
    engine   udr;

  function arr_set_blob(handle d_id not null, idx d_integer not null, value_new d_blob_text)
    returns  d_bool
    external name 'kvo.udr!ArrayPutBlob'
    engine   udr;

  function arr_set_flt(handle d_id not null, idx d_integer not null, value_new d_float)
    returns  d_bool
    external name 'kvo.udr!ArrayPutFloat'
    engine   udr;

  function arr_set_f(handle d_id not null, idx d_integer not null, value_new d_double)
    returns  d_bool
    external name 'kvo.udr!ArrayPutDouble'
    engine   udr;

  function arr_set_i(handle d_id not null, idx d_integer not null, value_new d_integer)
    returns  d_bool
    external name 'kvo.udr!ArrayPutInt32'
    engine   udr;

  function arr_set_l(handle d_id not null, idx d_integer not null, value_new d_id)
    returns  d_bool
    external name 'kvo.udr!ArrayPutInt64'
    engine   udr;

  function arr_set_d(handle d_id not null, idx d_integer not null, value_new d_date)
    returns  d_bool
    external name 'kvo.udr!ArrayPutDate'
    engine   udr;

  function arr_set_o(handle d_id not null, idx d_integer not null, value_new d_id)
    returns  d_bool
    external name 'kvo.udr!ArrayPutComplex'
    engine   udr;

  function arr_set_a(handle d_id not null, idx d_integer not null, value_new d_id)
    returns  d_bool
    external name 'kvo.udr!ArrayPutComplex'
    engine   udr;

  function obj_create()
    returns  d_id not null
    external name 'kvo.udr!ObjectCreate'
    engine   udr;

  function obj_contains(handle d_id not null, path d_str_long not null)
    returns  d_bool not null
    external name 'kvo.udr!ObjectContains'
    engine   udr;

  function obj_remove(handle d_id not null, path d_str_long not null)
    returns d_bool not null
    external name 'kvo.udr!ObjectRemoveItem'
    engine   udr;

  function obj_get_b(handle d_id not null, path d_str_long not null, value_when_path_not_found d_bool)
    returns  d_bool
    external name 'kvo.udr!ObjectGetInt16'
    engine   udr;

  function obj_get_bool(handle d_id not null, path d_str_long not null, value_when_path_not_found boolean)
    returns  boolean
    external name 'kvo.udr!ObjectGetBool'
    engine   udr;

  function obj_get_s(handle d_id not null, path d_str_long not null, value_when_path_not_found d_str_8100)
    returns  d_str_8100
    external name 'kvo.udr!ObjectGetString'
    engine   udr;

  function obj_get_blob(handle d_id not null, path d_str_long not null, value_when_path_not_found d_blob_text)
    returns  d_blob_text
    external name 'kvo.udr!ObjectGetBlob'
    engine   udr;

  function obj_get_flt(handle d_id not null, path d_str_long not null, value_when_path_not_found d_float)
    returns  d_float
    external name 'kvo.udr!ObjectGetFloat'
    engine   udr;

  function obj_get_f(handle d_id not null, path d_str_long not null, value_when_path_not_found d_double)
    returns  d_double
    external name 'kvo.udr!ObjectGetDouble'
    engine   udr;

  function obj_get_i(handle d_id not null, path d_str_long not null, value_when_path_not_found d_integer)
    returns  d_integer
    external name 'kvo.udr!ObjectGetInt32'
    engine   udr;

  function obj_get_l(handle d_id not null, path d_str_long not null, value_when_path_not_found d_id)
    returns  d_id
    external name 'kvo.udr!ObjectGetInt64'
    engine   udr;

  function obj_get_d(handle d_id not null, path d_str_long not null, value_when_path_not_found d_date)
    returns  d_date
    external name 'kvo.udr!ObjectGetDate'
    engine   udr;

  function obj_get_o(handle d_id not null, path d_str_long not null)
    returns  d_id
    external name 'kvo.udr!ObjectGetObject'
    engine   udr;

  function obj_get_a(handle d_id not null, path d_str_long not null)
    returns  d_id
    external name 'kvo.udr!ObjectGetArray'
    engine   udr;

  function obj_set_b(handle d_id not null, path d_str_8100 not null, value_new d_bool)
    returns  d_bool
    external name 'kvo.udr!ObjectPutInt16'
    engine   udr;

  function obj_set_bool(handle d_id not null, path d_str_8100 not null, value_new boolean)
    returns  d_bool
    external name 'kvo.udr!ObjectPutBool'
    engine   udr;

  function obj_set_s(handle d_id not null, path d_str_8100 not null, value_new d_str_8100)
    returns  d_bool
    external name 'kvo.udr!ObjectPutString'
    engine   udr;

  function obj_set_blob(handle d_id not null, path d_str_8100 not null, value_new d_blob_text)
    returns  d_bool
    external name 'kvo.udr!ObjectPutBlob'
    engine   udr;

  function obj_set_flt(handle d_id not null, path d_str_8100 not null, value_new d_float)
    returns  d_bool
    external name 'kvo.udr!ObjectPutFloat'
    engine   udr;

  function obj_set_f(handle d_id not null, path d_str_8100 not null, value_new d_double)
    returns  d_bool
    external name 'kvo.udr!ObjectPutDouble'
    engine   udr;

  function obj_set_i(handle d_id not null, path d_str_8100 not null, value_new d_integer)
    returns  d_bool
    external name 'kvo.udr!ObjectPutInt32'
    engine   udr;

  function obj_set_l(handle d_id not null, path d_str_8100 not null, value_new d_id)
    returns  d_bool
    external name 'kvo.udr!ObjectPutInt64'
    engine   udr;

  function obj_set_d(handle d_id not null, path d_str_8100 not null, value_new d_date)
    returns  d_bool
    external name 'kvo.udr!ObjectPutDate'
    engine   udr;

  function obj_set_o(handle d_id not null, path d_str_8100 not null, value_new d_id)
    returns  d_bool
    external name 'kvo.udr!ObjectPutComplex'
    engine   udr;

  function obj_set_a(handle d_id not null, path d_str_8100 not null, value_new d_id)
    returns  d_bool
    external name 'kvo.udr!ObjectPutComplex'
    engine   udr;

  function to_str(handle d_id not null, is_compact d_bool)
    returns  d_str_8100
    external name 'kvo.udr!DeSerializationText'
    engine udr;

  function to_blob(handle d_id not null, is_compact d_bool not null)
    returns  d_blob_text
    external name 'kvo.udr!DeSerializationBlob'
    engine udr;

  function parse_str(data_string d_str_8100 not null)
    returns  d_id not null
    external name 'kvo.udr!SerializationText'
    engine udr;

  function parse_blob(data_blob d_blob_text not null)
    returns  d_id not null
    external name 'kvo.udr!SerializationBlob'
    engine udr;

end
^

SET TERM ; ^
