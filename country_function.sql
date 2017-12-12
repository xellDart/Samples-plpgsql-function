/* 
this function verifies if a record exists, 
if it does not exist it creates it 
and returns the registration id
 */
CREATE OR REPLACE FUNCTION check_country(name_table character varying, column_id_name character varying, column_mach_name character varying, value_mach_name character varying)                                                                                                                                     
  RETURNS integer AS
$BODY$
DECLARE
    response integer;
BEGIN
    IF (value_mach_name IS NULL)  THEN
        RETURN NULL;
    END IF;
    EXECUTE '
    WITH s AS (
        SELECT ' || quote_ident(column_id_name) || '
        FROM  ' || quote_ident(name_table) || '
        WHERE nombre_pais = ' || quote_literal(value_mach_name) || '
    ), i AS (
        INSERT INTO ' || quote_ident(name_table) || '(' || quote_ident(column_mach_name) || ')
        SELECT ' || quote_literal(value_mach_name) || '
        WHERE NOT EXISTS (
        SELECT ' || quote_ident(column_mach_name) || ' 
        FROM  ' || quote_ident(name_table) || ' 
        WHERE ' || quote_ident(column_mach_name) || ' = ' || quote_literal(value_mach_name) || '
        )
        RETURNING ' || quote_ident(column_id_name) || ' 
    )
    SELECT ' || quote_ident(column_id_name) || ' 
    FROM i
    UNION ALL
    SELECT ' || quote_ident(column_id_name) || ' 
    FROM s;'
    INTO response  ;
    RETURN response;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
--Test function:
 SELECT check_country('table','value_to_return','column_to_compare','value');
