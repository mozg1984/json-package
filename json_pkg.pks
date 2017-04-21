create or replace package JSON_PKG is

  subtype value is varchar2(32767);

  type array is table of value;

  type object is table of value index by value;

  -- Check if given value has correct json format
  function is_json(p_value value default '') return boolean;

  -- Check if given value is number
  function is_number(p_value value) return boolean;

  -- Check if given value is json array
  function is_array(p_value value) return boolean;

  -- Check if given value is json object
  function is_object(p_value value) return boolean;

  -- Encode a string in utf8 (for sending cyrillic chars)
  function escape(p_value value) return varchar2;

  -- Escape double quotes by given char
  function escape_quotes(p_value value, p_char char default '\') return varchar2;

  -- Escape value by double quotes
  function quotes(p_value value) return varchar2;

  -- Encode value
  function encode(p_value value) return value;

  -- Encode array
  function encode(p_array in out nocopy array) return value;

  -- Encode object
  function encode(p_object in out nocopy object) return value;

  -- Add value to array
  procedure add(p_array in out nocopy array, p_value value);

  -- Add array to array
  procedure add(p_array in out nocopy array, p_value in out nocopy array);

  -- Add object to array
  procedure add(p_array in out nocopy array, p_value in out nocopy object);

  -- Add value to object by key
  procedure add(p_object in out nocopy object, p_key value, p_value value);

  -- Add array to object by key
  procedure add(p_object in out nocopy object, p_key value, p_value in out nocopy array);

  -- Add object to object by key
  procedure add(p_object in out nocopy object, p_key value, p_value in out nocopy object);
end;
