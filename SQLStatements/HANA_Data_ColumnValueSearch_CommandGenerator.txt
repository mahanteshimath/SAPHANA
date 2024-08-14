SELECT
/* 

[NAME]

- HANA_Data_ColumnValueSearch_CommandGenerator

[DESCRIPTION]

- Generates a SQL command to search for specific column values

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Result of command execution is a SQL statement that has to be executed in order to search for the values
- Column value search is e.g. useful in order to check for suspected corruptions (e.g. "#" values due to codepage problem)
- Only valid for tables in column store

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/07/23:  1.0 (initial version)

[INVOLVED TABLES]


[INPUT PARAMETERS]

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  '%'             --> All schemata

- TABLE_NAMES           

  Table names, separated by comma

  'T000'          --> Specific table T000
  'JEST, JSTO'    --> Tables JEST and JSTO
  'CRMD%, BUT000' --> Tables with names starting with "CRMD" and table BUT000

- DATA_TYPE

  Column data type

  'NCLOB'         --> Type 'NCLOB'
  '%LOB%'         --> All types containing 'LOB'
  '%'             --> All types

- COLUMN_NAME

  Column name

  'MATNR'         --> Column MATNR
  'Z%'            --> Columns starting with "Z"
  '%'             --> No restriction related to columns

- COLUMN_VALUE

  Column value

  '100'           --> Column value 100
  '%#%'           --> Column values containing "#"
  '%'             --> Any column value

[OUTPUT PARAMETERS]

- SCHEMA_NAME: Schema name
- TABLE_NAME:  Table name
- COLUMN_NAME: Column name
- COMMAND:     SQL command to be executed in second step

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME|TABLE_NAME|COLUMN_NAME     |COMMAND                                                                                                  |
---------------------------------------------------------------------------------------------------------------------------------------------------
|SAPECP     |BUT000    |ADDRCOMM        |( SELECT * FROM ( SELECT 'SAPECP' SCHEMA_NAME, 'BUT000' TABLE_NAME,                                      |
|SAPECP     |BUT000    |ADDRCOMM        |'ADDRCOMM' COLUMN_NAME, "ADDRCOMM" COLUMN_VALUE, TO_VARCHAR("$trexexternalkey$") PRIMARY_KEY                |
|SAPECP     |BUT000    |ADDRCOMM        |FROM "SAPECP"."BUT000" WHERE "ADDRCOMM" LIKE '%#%'                                                       |
|SAPECP     |BUT000    |ADDRCOMM        |ORDER BY "$trexexternalkey$" )) UNION ALL                                                                |
|SAPECP     |BUT000    |AUGRP           |( SELECT * FROM ( SELECT 'SAPECP' SCHEMA_NAME, 'BUT000' TABLE_NAME,                                      |
|SAPECP     |BUT000    |AUGRP           |'AUGRP' COLUMN_NAME, "AUGRP" COLUMN_VALUE, TO_VARCHAR("$trexexternalkey$") PRIMARY_KEY                      |
|SAPECP     |BUT000    |AUGRP           |FROM "SAPECP"."BUT000" WHERE "AUGRP" LIKE '%#%'                                                          |
|SAPECP     |BUT000    |AUGRP           |ORDER BY "$trexexternalkey$" )) UNION ALL                                                                |
...
|           |          |                |SELECT NULL, NULL, NULL, NULL, NULL FROM DUMMY WHERE 1 = 0                                               |
---------------------------------------------------------------------------------------------------------------------------------------------------

--> Needs to be executed and returns e.g.:

-----------------------------------------------------------------------------
|SCHEMA_NAME|TABLE_NAME|COLUMN_NAME|COLUMN_VALUE        |PRIMARY_KEY        |
-----------------------------------------------------------------------------
|SAPECP     |BUT000    |BIRTHPL    |#########           |3,900;10,0800033170|
|SAPECP     |BUT000    |BIRTHPL    |######-##-####      |3,900;10,0812445707|
|SAPECP     |BUT000    |BIRTHPL    |######              |3,900;10,0815512868|
|SAPECP     |BUT000    |BIRTHPL    |#### ### ##### #####|3,900;10,0821738343|
|SAPECP     |BUT000    |BU_SORT1   |#######             |3,900;10,0001105058|
|SAPECP     |BUT000    |BU_SORT1   |########            |3,900;10,0800013910|
|SAPECP     |BUT000    |BU_SORT1   |########            |3,900;10,0800013947|
|SAPECP     |BUT000    |BU_SORT1   |#######             |3,900;10,0800014653|
|SAPECP     |BUT000    |BU_SORT1   |#######             |3,900;10,0800014798|
|SAPECP     |BUT000    |BU_SORT1   |#########           |3,900;10,0800014848|
|SAPECP     |BUT000    |BU_SORT1   |#######             |3,900;10,0800014906|
|SAPECP     |BUT000    |BU_SORT1   |######              |3,900;10,0800015195|
|SAPECP     |BUT000    |BU_SORT1   |#######             |3,900;10,0800015429|
|SAPECP     |BUT000    |BU_SORT1   |########            |3,900;10,0800015672|
|SAPECP     |BUT000    |BU_SORT1   |######              |3,900;10,0800016020|
-----------------------------------------------------------------------------

*/

  SCHEMA_NAME,
  TABLE_NAME,
  COLUMN_NAME,
  SQL_TEXT COMMAND FROM (
SELECT DISTINCT
  TC.SCHEMA_NAME,
  TC.TABLE_NAME,
  TC.COLUMN_NAME,
  S.SECTION_NO,
  CASE SECTION_NO
    WHEN  10 THEN '( SELECT * FROM ( SELECT ' || CHAR(39) || TC.SCHEMA_NAME || CHAR(39) || CHAR(32) || 'SCHEMA_NAME, ' || CHAR(39) || TC.TABLE_NAME  || CHAR(39) || CHAR(32) || 'TABLE_NAME,'
    WHEN  25 THEN CHAR(39) || TC.COLUMN_NAME || CHAR(39) || CHAR(32) || 'COLUMN_NAME, ' || '"' || TC.COLUMN_NAME || '"' || CHAR(32) || 'COLUMN_VALUE, TO_VARCHAR("$trexexternalkey$") PRIMARY_KEY'
    WHEN  40 THEN 'FROM "' || TC.SCHEMA_NAME || '"."' || TC.TABLE_NAME || '" WHERE "' || TC.COLUMN_NAME || '" LIKE ' || CHAR(39) || BI.COLUMN_VALUE || CHAR(39)
    WHEN  90 THEN 'ORDER BY "$trexexternalkey$" )) UNION ALL'
   END SQL_TEXT
FROM
( SELECT
    SCHEMA_NAME,
    TABLE_NAME,
    DATA_TYPE,
    COLUMN_NAME,
    COLUMN_VALUE
  FROM
  ( SELECT
      SCHEMA_NAME,
      CASE
        WHEN T.NUM = 1 AND LOCATE(BI.TABLE_NAMES, ',') = 0 THEN 
          BI.TABLE_NAMES
        WHEN T.NUM = 1 AND LOCATE(BI.TABLE_NAMES, ',') != 0 THEN 
          SUBSTR(BI.TABLE_NAMES, 1, LOCATE(BI.TABLE_NAMES, ',') - 1)
        WHEN T.NUM > 1 AND LOCATE(BI.TABLE_NAMES, ',', 1, T.NUM - 1) = 0 THEN
          NULL
        WHEN T.NUM > 1 AND LOCATE(BI.TABLE_NAMES, ',', 1, T.NUM) = 0 THEN
          SUBSTR(BI.TABLE_NAMES, LOCATE(BI.TABLE_NAMES, ',', 1, T.NUM - 1) + 1, LENGTH(BI.TABLE_NAMES) - LOCATE(BI.TABLE_NAMES, ',', 1, T.NUM - 1) - 1)
        WHEN T.NUM > 1 AND LOCATE(BI.TABLE_NAMES, ',', 1, T.NUM) != 0 THEN
          SUBSTR(BI.TABLE_NAMES, LOCATE(BI.TABLE_NAMES, ',', 1, T.NUM - 1) + 1, LOCATE(BI.TABLE_NAMES, ',', 1, T.NUM) - LOCATE(BI.TABLE_NAMES, ',', 1, T.NUM - 1) - 1)
      END TABLE_NAME,
      DATA_TYPE,
      COLUMN_NAME,
      COLUMN_VALUE
    FROM
    ( SELECT
        SCHEMA_NAME,
        REPLACE(TABLE_NAMES, CHAR(32), '') TABLE_NAMES,
        DATA_TYPE,
        COLUMN_NAME,
        COLUMN_VALUE
      FROM
      ( SELECT                              /* Modification section */
          '%' SCHEMA_NAME,
          'CRMD_ORDERADM_H' TABLE_NAMES,   /* table name or comma-separated list of table names */
          'NVARCHAR' DATA_TYPE,
          '%' COLUMN_NAME,
          '%#%' COLUMN_VALUE
        FROM
          DUMMY
      )
    ) BI,
    ( SELECT TOP 50 ROW_NUMBER () OVER () NUM FROM OBJECTS ) T
  )
  WHERE
    TABLE_NAME IS NOT NULL
) BI,
( SELECT  10 SECTION_NO, 'SELECT' SECTION_DESC FROM DUMMY UNION
  SELECT  25,            'SELECT_COLUMN'       FROM DUMMY UNION
  SELECT  40,            'FROM'                FROM DUMMY UNION
  SELECT  90,            'ORDER_BY'            FROM DUMMY
) S,
  TABLE_COLUMNS TC
WHERE
  TC.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  TC.TABLE_NAME LIKE BI.TABLE_NAME AND
  TC.COLUMN_NAME LIKE BI.COLUMN_NAME AND
  TC.DATA_TYPE_NAME LIKE BI.DATA_TYPE
ORDER BY
  TC.SCHEMA_NAME,
  TC.TABLE_NAME,
  TC.COLUMN_NAME,
  S.SECTION_NO
)
UNION ALL
( SELECT NULL, NULL, NULL, 'SELECT NULL, NULL, NULL, NULL, NULL FROM DUMMY WHERE 1 = 0' FROM DUMMY )
