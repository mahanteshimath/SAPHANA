SELECT
/* 

[NAME]

HANA_Tables_ColumnStore_PreloadActive

[DESCRIPTION]

- Displays tables and / or columns with activated column store preload on object level

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/02/07:  1.0 (initial version)

[INVOLVED TABLES]

- TABLES
- TABLE_COLUMNS

[INPUT PARAMETERS]

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- TABLE_NAME:           

  Table name or pattern

  'T000'          --> Specific table T000
  'T%'            --> All tables starting with 'T'
  '%'             --> All tables

- COLUMN_VALUE

  Column value

  '100'           --> Column value 100
  '%#%'           --> Column values containing "#"
  '%'             --> Any column value

- PRELOAD_LEVEL

  Level of preload information

  'COLUMN'        --> Preload information on column level (TRUE, FALSE)
  'TABLE'         --> Preload information on table level (FULL, PARTIAL)
  '%'             --> No restriction in terms of preload information

[OUTPUT PARAMETERS]

- SCHEMA_NAME:      Schema name
- TABLE_NAME:       Table name
- COLUMN_NAME:      Column name
- PRELOAD:          Preload state

[EXAMPLE OUTPUT]

---------------------------------------------
|SCHEMA_NAME|TABLE_NAME |COLUMN_NAME|PRELOAD|
---------------------------------------------
|SAPSR3     |SMALLTABLE |           |FULL   |
|SAPSR3     |SMALLTABLE |FIELD1     |TRUE   |
|SAPSR3     |SMALLTABLE |FIELD2     |TRUE   |
|SAPSR3     |SMALLTABLE |FIELD3     |TRUE   |
|SAPSR3     |SMALLTABLE |KEYFIELD   |TRUE   |
|SAPSR3     |SMALLTABLE |MEASURE    |TRUE   |
|SAPSR3     |TMPM_MEMORY|           |FULL   |
|SAPSR3     |TMPM_MEMORY|FIELD1     |TRUE   |
|SAPSR3     |TMPM_MEMORY|FIELD2     |TRUE   |
|SAPSR3     |TMPM_MEMORY|FIELD3     |TRUE   |
|SAPSR3     |TMPM_MEMORY|KEYFIELD   |TRUE   |
|SAPSR3     |TMPM_MEMORY|MEASURE    |TRUE   |
---------------------------------------------

*/

  P.SCHEMA_NAME,
  P.TABLE_NAME,
  P.COLUMN_NAME,
  P.PRELOAD
FROM
( SELECT                  /* Modification section */
    '%' SCHEMA_NAME,
    '%' TABLE_NAME,
    '%' COLUMN_NAME,
    'TABLE' PRELOAD_LEVEL          /* TABLE, COLUMN, % */
  FROM
    DUMMY
) BI,
( SELECT
    'TABLE' PRELOAD_LEVEL,
    SCHEMA_NAME,
    TABLE_NAME,
    '' COLUMN_NAME,
    MAP(IS_PARTIAL_PRELOAD, 'TRUE', 'PARTIAL', 'FULL' ) PRELOAD
  FROM
    TABLES
  WHERE
    IS_PRELOAD = 'TRUE' OR
    IS_PARTIAL_PRELOAD = 'TRUE'
  UNION ALL
  ( SELECT
      'COLUMN' PRELOAD_LEVEL,
      SCHEMA_NAME,
      TABLE_NAME,
      COLUMN_NAME,
      PRELOAD
    FROM
      TABLE_COLUMNS
    WHERE
      PRELOAD = 'TRUE'
  )
) P
WHERE
  P.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  P.TABLE_NAME LIKE BI.TABLE_NAME AND
  P.COLUMN_NAME LIKE BI.COLUMN_NAME AND
  P.PRELOAD_LEVEL LIKE BI.PRELOAD_LEVEL
ORDER BY
  P.SCHEMA_NAME,
  P.TABLE_NAME,
  P.COLUMN_NAME
      