declare
  /*
  Note: for execute this unit test you should use next package:
        https://github.com/mozg1984/dbunit 
  */

  val json_pkg.value;
  obj1 json_pkg.object;
  obj2 json_pkg.object;
  arr1 json_pkg.array;  
begin
  val := 123456789;
  dbunit.assert(json_pkg.is_json(val), 'INCORRECT JSON FORMATE');
  
  val := 'testmessage';
  dbunit.assert(not json_pkg.is_json('testmessage'), 'INCORRECT JSON FORMATE');

  val := json_pkg.encode('testmessage');
  dbunit.assert_equals('"testmessage"', val);
  dbunit.assert(json_pkg.is_json(val), 'INCORRECT JSON FORMATE');
  
  val := json_pkg.encode('te"""st"mes"sa""ge');
  dbunit.assert_equals('"te\"\"\"st\"mes\"sa\"\"ge"', val);
  dbunit.assert(json_pkg.is_json(val), 'INCORRECT JSON FORMATE');

  dbunit.assert(json_pkg.is_json('{}'), 'INCORRECT JSON FORMATE');
  dbunit.assert_equals('{}', json_pkg.encode(obj1));
  
  json_pkg.add(obj1, 'key1', 'value1');
  dbunit.assert_equals(
    '{"key1":"value1"}', 
    json_pkg.encode(obj1)
  );
  
  json_pkg.add(obj1, 'key1', 123);
  dbunit.assert_equals(
    '{"key1":123}', 
    json_pkg.encode(obj1)
  );
  
  json_pkg.add(obj1, 'key2', 'value2');
  dbunit.assert_equals(
    '{"key1":123,"key2":"value2"}', 
    json_pkg.encode(obj1)
  );
  
  json_pkg.add(obj1, 'key3', 'value3');
  dbunit.assert_equals(
    '{"key1":123,"key2":"value2","key3":"value3"}', 
    json_pkg.encode(obj1)
  );
  
  json_pkg.add(obj1, 'key1', 'value1');
  dbunit.assert_equals(
    '{"key1":"value1","key2":"value2","key3":"value3"}', 
    json_pkg.encode(obj1)
  );
  
  dbunit.assert(json_pkg.is_json('[]'), 'INCORRECT JSON FORMATE');
  dbunit.assert_equals('[]', json_pkg.encode(arr1));
  
  json_pkg.add(arr1, '10');
  json_pkg.add(arr1, '20');
  json_pkg.add(arr1, '30');
  
  dbunit.assert(json_pkg.is_json(json_pkg.encode(arr1)), 'INCORRECT JSON FORMATE');
  dbunit.assert_equals('[10,20,30]', json_pkg.encode(arr1));
  
  json_pkg.add(arr1, 'come"test"message');
  
  dbunit.assert(json_pkg.is_json(json_pkg.encode(arr1)), 'INCORRECT JSON FORMATE');
  dbunit.assert_equals(
    '[10,20,30,"come\"test\"message"]', 
    json_pkg.encode(arr1)
  );
  
  json_pkg.add(obj2, 'key21', arr1);
  json_pkg.add(obj2, 'key22', obj1);
  
  dbunit.assert(json_pkg.is_json(json_pkg.encode(obj2)), 'INCORRECT JSON FORMATE');
  dbunit.assert_equals(
    '{"key21":[10,20,30,"come\"test\"message"],"key22":{"key1":"value1","key2":"value2","key3":"value3"}}', 
    json_pkg.encode(obj2)
  );
  
  json_pkg.add(obj2, 'key21', obj1);
  json_pkg.add(obj2, 'key22', arr1);
  
  dbunit.assert(json_pkg.is_json(json_pkg.encode(obj2)), 'INCORRECT JSON FORMATE'); 
  dbunit.assert_equals(
    '{"key21":{"key1":"value1","key2":"value2","key3":"value3"},"key22":[10,20,30,"come\"test\"message"]}', 
    json_pkg.encode(obj2)
  );
end;
