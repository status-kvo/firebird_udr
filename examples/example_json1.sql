execute block returns (
  func d_str_255,
  is_match boolean,
  res d_str_8100,
  want_res d_str_8100
  )
as
  declare variable jso d_id;
  declare variable jsa d_id;
  declare variable jso1 d_id;
  declare variable init_str d_str_long;
begin
  func = 'obj_set';
  jso = json.obj_create();

  json.obj_set_s(jso, 'str1', 'str_val1');
  json.obj_set_b(jso, 'bool1', 0); json.obj_set_b(jso, 'bool2', 1);
  json.obj_set_blob(jso, 'blob1', 'str_val1');
  json.obj_set_d(jso, 'date1', '01.01.2022');
  json.obj_set_f(jso, 'double1', 5); json.obj_set_f(jso, 'double2', 5.7);
  json.obj_set_flt(jso, 'flt1', 5); json.obj_set_flt(jso, 'flt2', 5.7);
  json.obj_set_i(jso, 'int1', 5);
  json.obj_set_l(jso, 'long1', 12365489798564);
  json.obj_set_o(jso, 'obj1', json.parse_str('{"key1":"val1", "key2":4, "key3":{"sk":2}}'));
  json.obj_set_a(jso, 'arr1', json.parse_str('[1,2,3]'));
  res = json.to_str(jso, 1);
  want_res = '{"str1":"str_val1","bool1":false,"bool2":true,"blob1":"str_val1","date1":"01.01.2022","double1":5,"double2":5.7,"flt1":5,"flt2":5.69999980926514,"int1":5,"long1":12365489798564,"obj1":{"key1":"val1","key2":4,"key3":{"sk":2}},"arr1":[1,2,3]}';
  is_match = res is not distinct from want_res;
  suspend;

  jso1 = json.clone(jso);

  json.obj_set_s(jso, 'str1', 'str_val2');
  json.obj_set_b(jso, 'bool1', 1);
  json.obj_set_blob(jso, 'blob1', 'str_val2');
  json.obj_set_d(jso, 'date1', '31.12.2022');
  json.obj_set_f(jso, 'double1', 777);
  json.obj_set_flt(jso, 'flt1', 777);
  json.obj_set_i(jso, 'int1', 777);
  json.obj_set_l(jso, 'long1', 777);
  json.obj_set_o(jso, 'obj1', json.parse_str('{"key1":"val2", "key2":8, "key3":{"sk1":333}}'));
  json.obj_set_a(jso, 'arr1', json.parse_str('["val1","val2","val3"]'));

  func = 'клон';
  res = json.to_str(jso1, 1);
  is_match = res is not distinct from want_res;
  suspend;

  func = 'obj_set замена значений';
  res = json.to_str(jso, 1);
  want_res = '{"str1":"str_val2","bool1":true,"bool2":true,"blob1":"str_val2","date1":"31.12.2022","double1":777,"double2":5.7,"flt1":777,"flt2":5.69999980926514,"int1":777,"long1":777,"obj1":{"key1":"val2","key2":8,"key3":{"sk1":333}},"arr1":["val1","val2","val3"]}';
  is_match = res is not distinct from want_res;
  suspend;

  func = 'парсинг';
  want_res = '{"str1":"str_val1","bool1":false,"bool2":true,"blob1":"str_val1","date1":"01.01.2022","double1":5,"double2":5.7,"flt1":5,"flt2":5.69999980926514,"int1":5,"long1":12365489798564,"obj1":{"key1":"val1","key2":4,"key3":{"sk":2}},"arr1":[1,2,3]}';
  json.destroy(jso);
  jso = json.parse_str(want_res);
  res = json.to_str(jso, 1);
  is_match = res is not distinct from want_res;
  suspend;

  func = 'obj_set null';
  json.destroy(jso1);
  jso1 = json.clone(jso);

  json.obj_set_s(jso1, 'str1', null);
  json.obj_set_b(jso1, 'bool1', null);
  json.obj_set_blob(jso1, 'blob1', null);
  json.obj_set_d(jso1, 'date1', null);
  json.obj_set_f(jso1, 'double1', null);
  json.obj_set_flt(jso1, 'flt1', null);
  json.obj_set_i(jso1, 'int1', null);
  json.obj_set_l(jso1, 'long1', null);
  json.obj_set_o(jso1, 'obj1', null);
  json.obj_set_a(jso1, 'arr1', null);
  json.obj_set_s(jso1, 'str10', null);
  res = json.to_str(jso1, 1);
  want_res = '{"str1":null,"bool1":null,"bool2":true,"blob1":null,"date1":null,"double1":null,"double2":5.7,"flt1":null,"flt2":5.69999980926514,"int1":null,"long1":null,"obj1":null,"arr1":null,"str10":null}';
  is_match = res is not distinct from want_res;
  suspend;

  func = 'blob';
  json.destroy(jso1);
  jso1 = json.parse_blob(want_res);
  res = json.to_blob(jso1,1);
  is_match = res is not distinct from want_res;
  suspend;

  func = '*****'; res = '****************'; want_res = '*****************'; is_match = true; suspend;

  -- string
  func = 'obj_get_s'; res = json.obj_get_s(jso, 'str1'); want_res = 'str_val1'; is_match = res is not distinct from want_res; suspend;

  --logical
  func = 'obj_get_b'; res = json.obj_get_b(jso, 'bool1'); want_res = '0'; is_match = res is not distinct from want_res; suspend;

  --blob
  func = 'obj_get_blob'; res = json.obj_get_blob(jso, 'blob1'); want_res = 'str_val1'; is_match = res is not distinct from want_res; suspend;

  -- date and time
  func = 'obj_get_t'; res = json.obj_get_t(jso, 'date1'); want_res = '00:00:00.0000'; is_match = res is not distinct from want_res; suspend;
  func = 'obj_get_d'; res = json.obj_get_d(jso, 'date1'); want_res = '2022-01-01'; is_match = res is not distinct from want_res; suspend;
  func = 'obj_get_dt'; res = json.obj_get_dt(jso, 'date1'); want_res = '2022-01-01 00:00:00.0000'; is_match = res is not distinct from want_res; suspend;
  func = 'obj_get_ts'; res = json.obj_get_ts(jso, 'date1'); want_res = '2022-01-01 00:00:00.0000'; is_match = res is not distinct from want_res; suspend;

  -- float
  func = 'obj_get_f'; res = json.obj_get_f(jso, 'double2'); want_res = '5.700000000000000'; is_match = res is not distinct from want_res; suspend;
  func = 'obj_get_flt'; res = json.obj_get_flt(jso, 'flt2'); want_res = '5.6999998'; is_match = res is not distinct from want_res; suspend;

  -- integer
  func = 'obj_get_i'; res = json.obj_get_i(jso, 'int1'); want_res = '5'; is_match = res is not distinct from want_res; suspend;
  func = 'obj_get_l'; res = json.obj_get_l(jso, 'long1'); want_res = '12365489798564'; is_match = res is not distinct from want_res; suspend;

  -- complex
  func = 'obj_get_o'; res = json.to_str(json.obj_get_o(jso, 'obj1'),1); want_res = '{"key1":"val1","key2":4,"key3":{"sk":2}}'; is_match = res is not distinct from want_res; suspend;
  func = 'obj_get_a'; res = json.to_str(json.obj_get_a(jso, 'arr1'),1); want_res = '[1,2,3]'; is_match = res is not distinct from want_res; suspend;

  func = '*****'; res = '****************'; want_res = '*****************'; is_match = true; suspend;


  func = 'arr_set';
  jsa = json.arr_create();

  json.arr_set_s(jsa, -1, 'str_val1');
  json.arr_set_b(jsa, -1, 0); json.arr_set_b(jsa, -1, 1);
  json.arr_set_blob(jsa, -1, 'str_val1');
  json.arr_set_d(jsa, -1, '01.01.2022');
  json.arr_set_f(jsa, -1, 5); json.arr_set_f(jsa, -1, 5.7);
  json.arr_set_flt(jsa, -1, 5); json.arr_set_flt(jsa, -1, 5.7);
  json.arr_set_i(jsa, -1, 5);
  json.arr_set_l(jsa, -1, 12365489798564);
  json.arr_set_o(jsa, -1, json.parse_str('{"key1":"val1", "key2":4, "key3":{"sk":2}}'));
  json.arr_set_a(jsa, -1, json.parse_str('[1,2,3]'));
  res = json.to_str(jsa, 1);
  want_res = '["str_val1",false,true,"str_val1","01.01.2022",5,5.7,5,5.69999980926514,5,12365489798564,{"key1":"val1","key2":4,"key3":{"sk":2}},[1,2,3]]';
  is_match = res is not distinct from want_res;
  suspend;

  func = 'arr_set замена значений';
  json.arr_set_s(jsa, 0, 'str_val2');
  json.arr_set_b(jsa, 1, 1);
  json.arr_set_blob(jsa, 3, 'str_val2');
  json.arr_set_d(jsa, 4, '31.12.2022');
  json.arr_set_f(jsa, 5, 777);
  json.arr_set_flt(jsa, 7, 777);
  json.arr_set_i(jsa, 9, 777);
  json.arr_set_l(jsa, 10, 888);
  json.arr_set_o(jsa, 11, json.parse_str('{"key1":"val2", "key2":8, "key3":{"sk1":333}}'));
  json.arr_set_a(jsa, 12, json.parse_str('["val1","val2","val3"]'));
  res = json.to_str(jsa, 1);
  want_res = '["str_val2",true,true,"str_val2","31.12.2022",777,5.7,777,5.69999980926514,777,888,{"key1":"val2","key2":8,"key3":{"sk1":333}},["val1","val2","val3"]]';
  is_match = res is not distinct from want_res;
  suspend;

  -- string
  func = 'arr_get_s'; res = json.arr_get_s(jsa, 0); want_res = 'str_val2'; is_match = res is not distinct from want_res; suspend;

  -- logical
  func = 'arr_get_b'; res = json.arr_get_b(jsa, 1); want_res = '1'; is_match = res is not distinct from want_res; suspend;

  -- blob
  func = 'arr_get_blob'; res = json.arr_get_blob(jsa, 3); want_res = 'str_val2'; is_match = res is not distinct from want_res; suspend;

  -- date anf time
  func = 'arr_get_t'; res = json.arr_get_t(jsa, 4); want_res = '00:00:00.0000'; is_match = res is not distinct from want_res; suspend;
  func = 'arr_get_d'; res = json.arr_get_d(jsa, 4); want_res = '2022-12-31'; is_match = res is not distinct from want_res; suspend;
  func = 'arr_get_dt'; res = json.arr_get_dt(jsa, 4); want_res = '2022-12-31 00:00:00.0000'; is_match = res is not distinct from want_res; suspend;
  func = 'arr_get_ts'; res = json.arr_get_ts(jsa, 4); want_res = '2022-12-31 00:00:00.0000'; is_match = res is not distinct from want_res; suspend;

  -- float
  func = 'arr_get_f'; res = json.arr_get_f(jsa, 5); want_res = '777.0000000000000'; is_match = res is not distinct from want_res; suspend;
  func = 'arr_get_flt'; res = json.arr_get_flt(jsa, 7); want_res = '777.00000'; is_match = res is not distinct from want_res; suspend;

  -- integer
  func = 'arr_get_i'; res = json.arr_get_i(jsa, 9); want_res = '777'; is_match = res is not distinct from want_res; suspend;
  func = 'arr_get_l'; res = json.arr_get_l(jsa, 10); want_res = '888'; is_match = res is not distinct from want_res; suspend;

  -- complex
  func = 'arr_get_o'; res = json.to_str(json.arr_get_o(jsa, 11),1); want_res = '{"key1":"val2","key2":8,"key3":{"sk1":333}}'; is_match = res is not distinct from want_res; suspend;
  func = 'arr_get_a'; res = json.to_str(json.arr_get_a(jsa, 12),1); want_res = '["val1","val2","val3"]'; is_match = res is not distinct from want_res; suspend;

  func = 'arr_set null';
  json.arr_set_s(jsa, 0, null);
  json.arr_set_b(jsa, 1, null);
  json.arr_set_blob(jsa, 3, null);
  json.arr_set_d(jsa, 4, null);
  json.arr_set_f(jsa, 5, null);
  json.arr_set_flt(jsa, 7, null);
  json.arr_set_i(jsa, 9, null);
  json.arr_set_l(jsa, 10, null);
  json.arr_set_o(jsa, 11, null);
  json.arr_set_a(jsa, 12, null);
  json.arr_set_a(jsa, -1, null);
  res = json.to_str(jsa, 1);
  want_res = '[null,null,true,null,null,null,5.7,null,5.69999980926514,null,null,null,null,null]';
  is_match = res is not distinct from want_res;
  suspend;

  func = '*****'; res = '****************'; want_res = '*****************'; is_match = true; suspend;
  json.destroy(jso);
  jso = json.obj_create();
  json.obj_set_s(jso, '"key.subkey"', 'кавычки');
  json.obj_set_s(jso, 'key.subkey', 'без');
  res = json.obj_get_s(jso, '"key.subkey"');  want_res = 'кавычки';  is_match = res is not distinct from want_res; suspend;
  res = json.obj_get_s(jso, 'key.subkey');    want_res = 'без';      is_match = res is not distinct from want_res; suspend;
  json.destroy(jso);


  jso = json.obj_create();
  json.obj_set_s(jso, '"key1.subkey1"', 'кавычки');
  json.obj_set_s(jso, 'key2.subkey2', 'без');
  res = json.obj_get_s(jso, '"key1.subkey1"');  want_res = 'кавычки';  is_match = res is not distinct from want_res; suspend;
  res = json.obj_get_s(jso, 'key2.subkey2');    want_res = 'без';      is_match = res is not distinct from want_res; suspend;
  res = json.obj_get_s(jso, 'key1.subkey1');    want_res = 'кавычки';  is_match = res is not distinct from want_res; suspend;



  json.destroy(jso1);
  json.destroy(jso);
  json.destroy(jsa);
end