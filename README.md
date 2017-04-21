
Small utility package for working with data in JSON format
   
Note: - Output of json value has length limitation at max value of varchar2 data type (32767)
      - This package depends on next package: https://github.com/mozg1984/PL-JSON-VALIDATOR
        You need to pre-install it 

Example of using:

declare
  employees json_pkg.object;
  person json_pkg.object;
  persons json_pkg.array;  
begin
  json_pkg.add(person, 'id', '11223344');
  json_pkg.add(person, 'name', 'Jon Brock');
  json_pkg.add(person, 'age', '31');
  json_pkg.add(person, 'gender', 'male');
  
  json_pkg.add(persons, person);
  
  json_pkg.add(person, 'id', '55667788');
  json_pkg.add(person, 'name', 'Piter Green');
  json_pkg.add(person, 'age', '40');
  json_pkg.add(person, 'gender', 'male');
  
  json_pkg.add(persons, person);
  
  json_pkg.add(person, 'id', '99001122');
  json_pkg.add(person, 'name', 'Linda Sanderson');
  json_pkg.add(person, 'age', '25');
  json_pkg.add(person, 'gender', 'female');
  
  json_pkg.add(persons, person);
  json_pkg.add(employees, 'department', 'testing');
  json_pkg.add(employees, 'persons', persons);
  
  dbms_output.put_line(json_pkg.encode(employees));
  
  /* Output:
  {
    "department": "testing",
    "persons": [{
      "age": 31,
      "gender": "male",
      "id": 11223344,
      "name": "Jon Brock"
    }, {
      "age": 40,
      "gender": "male",
      "id": 55667788,
      "name": "Piter Green"
    }, {
      "age": 25,
      "gender": "female",
      "id": 99001122,
      "name": "Linda Sanderson"
    }]
  }
  */
end;
