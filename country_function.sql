/* 
this function verifies if a record exists, 
if it does not exist it creates it 
and returns the registration id
 */
CREATE OR REPLACE FUNCTION checkcountry(text, text, timestamp)
  RETURNS integer AS
$func$
DECLARE
  id integer;
BEGIN
   WITH s AS (
        SELECT id_country FROM  countries
        WHERE name_country = $2
    ), i AS (
        INSERT INTO countries (id_entity_char, name_country, creation_date, modification_date)
        SELECT $1, $2, $3, $3
        WHERE NOT EXISTS (
        SELECT name_country 
        FROM  countries
        WHERE name_country = $2
        )
    RETURNING id_country INTO id
    )
    SELECT id_country 
    FROM i
    UNION ALL
    SELECT id_country 
    FROM s;
    RETURN id;
END
$func$ LANGUAGE plpgsql;
