create or replace package body JSON_PKG is
  function is_json(p_value value default '') return boolean
  is
  begin
    return json_validator.safety_validate(p_value);
  end;

  function is_number(p_value value) return boolean
  is
  begin
    return regexp_like(p_value, '^-?[0-9]+$|^([0-9]+)?(\.|\,)[0-9]+$');
  end;

  function is_array(p_value value) return boolean
  is
  begin
    return regexp_like(p_value, '^\[.*\]$');
  end;

  function is_object(p_value value) return boolean
  is
  begin
    return regexp_like(p_value, '^{.*}$');
  end;

  function escape(p_value value) return varchar2
  is
  begin
    return utl_url.escape(p_value, true, 'utf-8');
  end;

  function escape_quotes(p_value value, p_char char default '\') return varchar2
  is
  begin
    return replace(p_value, '"', (p_char || '"'));
  end;
  
  function quotes(p_value value) return varchar2
  is
  begin
    return '"' || p_value || '"';
  end;

  function encode(p_value value) return value
  is
  begin
    if p_value is null then
      return 'null';
    end if;

    if is_number(p_value) then
      return p_value;
    end if;
    
    if (is_object(p_value) or is_array(p_value)) and is_json(p_value) then
      return p_value;
    end if;

    return quotes(escape_quotes(p_value));
  end;

  function encode(p_array in out nocopy array) return value
  is
    l_array value := '';
  begin
    if p_array is not null then
      for i in 1..p_array.count loop
        l_array := l_array || (case when i > 1 then ',' else '' end) || encode(p_array(i));
      end loop;
    end if;   

    return '[' || l_array || ']';
  end;

  function encode(p_object in out nocopy object) return value
  is
    l_key value;
    l_object value := '';
  begin
    l_key := p_object.first;
    for i in 1..p_object.count loop
      l_object := l_object || (case when i > 1 then ',' else '' end) ||
        quotes(l_key) || ':' || encode(p_object(l_key));
      l_key := p_object.next(l_key);
    end loop;

    return '{' || l_object || '}';
  end;

  procedure add(p_array in out nocopy array, p_value value)
  is
  begin
    if p_array is null then
      p_array := array();
    end if;

    p_array.extend;
    p_array(p_array.last) := p_value;
  end;

  procedure add(p_array in out nocopy array, p_value in out nocopy array)
  is
  begin
    if p_value is null then
      return;
    end if;

    if p_array is null then
      p_array := array();
    end if;

    p_array.extend;
    p_array(p_array.last) := encode(p_value);
  end;

  procedure add(p_array in out nocopy array, p_value in out nocopy object)
  is
  begin
    if p_value.count = 0 then
      return;
    end if;

    if p_array is null then
      p_array := array();
    end if;

    p_array.extend;
    p_array(p_array.last) := encode(p_value);
  end;

  procedure add(p_object in out nocopy object, p_key value, p_value value)
  is
  begin
    p_object(p_key) := p_value;
  end;

  procedure add(p_object in out nocopy object, p_key value, p_value in out nocopy array)
  is
  begin
    if p_value is null then
      return;
    end if;

    p_object(p_key) := encode(p_value);
  end;

  procedure add(p_object in out nocopy object, p_key value, p_value in out nocopy object)
  is
  begin
    if p_value.count = 0 then
      return;
    end if;

    p_object(p_key) := encode(p_value);
  end;
end;
