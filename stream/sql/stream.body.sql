SET TERM ^ ;

RECREATE PACKAGE BODY STREAM
AS
begin

  function destroy(handle d_id not null)
    returns  d_bool not null
    external name 'kvo.udr!Destroy'
    engine   udr;

  function create_shared
    returns d_id
    external name 'kvo.udr!StreamSharedCreate'
    engine udr;
  
  function create_string
    returns d_id
    external name 'kvo.udr!StreamStringCreate'
    engine udr;

  function assign(handle_source d_id not null, handle_targer d_id not null)
    returns d_bool
    external name 'kvo.udr!StreamAssign'
    engine udr;

  function size_get(handle d_id not null)
    returns d_id
    external name 'kvo.udr!StreamSizeGet'
    engine udr;
  
  function size_set(handle d_id not null, size_new d_id not null)
    returns d_id
    external name 'kvo.udr!StreamSizeSet'
    engine udr;

  function position_get(handle d_id not null)
    returns d_id
    external name 'kvo.udr!StreamPositionGet'
    engine udr;
  
  function position_set(handle d_id not null, position_new d_id not null)
    returns d_id
    external name 'kvo.udr!StreamPositionSet'
    engine udr;

  function length_get(handle d_id not null)
    returns d_id
    external name 'kvo.udr!StreamLengthGet'
    engine udr;

  function length_char(handle d_id not null)
    returns d_id
    external name 'kvo.udr!StreamLengthChar'
    engine udr;

  function write_s(handle d_id not null, data_string d_str_8100 not null)
    returns d_bool
    external name 'kvo.udr!StreamWriteString'
    engine udr;
  
  function read_s(handle d_id not null, read_lenght d_id not null)
    returns d_str_8100
    external name 'kvo.udr!StreamReadString'
    engine udr;

  function write_b(handle d_id not null, data_blob d_blob_text not null)
    returns d_bool
    external name 'kvo.udr!StreamWriteBool'
    engine udr;
  
  function read_b(handle d_id not null, read_lenght d_id not null)
    returns d_blob_text
    external name 'kvo.udr!StreamReadBlob'
    engine udr;

  function to_string(handle d_id not null)
    returns d_str_8100
    external name 'kvo.udr!StreamToString'
    engine udr;
  
  function to_blob(handle d_id not null)
    returns d_blob_text
    external name 'kvo.udr!StreamToBlob'
    engine udr;

end
^

SET TERM ; ^