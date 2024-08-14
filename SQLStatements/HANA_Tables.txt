SELECT
/* 

[NAME]

- HANA_Tables

[DESCRIPTION]

- General table information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2016/02/01:  1.0 (initial version)

[INVOLVED TABLES]

- TABLES

[INPUT PARAMETERS]

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- TABLE_NAME           

  Table name or pattern

  'T000'          --> Specific table T000
  'T%'            --> All tables starting with 'T'
  '%'             --> All tables

- LOGGING

  Table LOGGING state
  
  'TRUE'          --> Only show tables created with LOGGING
  'FALSE'         --> Only show tables created with NOLOGGING
  '%'             --> No restriction related to table LOGGING

- PRIMARY_KEY

  Existence of primary key for table

  'X'             --> Only show tables with primary key
  ' '             --> Only show tables without primary key
  '%'             --> No restriction related to primary key

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'LOGGING'       --> Aggregation by LOGGING state
  'SCHEMA, TABLE' --> Aggregation by schema and table
  'NONE'          --> No aggregation

[OUTPUT PARAMETERS]

- SCHEMA_NAME: Schema name
- TABLE_NAME:  Table name
- NUM_TABLES:  Number of tables
- TABLE_TYPE:  Table type (e.g. ROW, COLUMN, VIRTUAL)
- LOGGING:     Aggregation by LOGGING state
- PK:          Primary key ('X' if primary key exists, otherwise ' ')

[EXAMPLE OUTPUT]

---------------------------------------------------------
|SCHEMA_NAME|TABLE_NAME|NUM_TABLES|TABLE_TYPE|LOGGING|PK|
---------------------------------------------------------
|any        |any       |      1568|ROW       |TRUE   |X |
|any        |any       |      2566|ROW       |TRUE   |  |
|any        |any       |       103|ROW       |FALSE  |  |
|any        |any       |       241|COLUMN    |TRUE   |  |
|any        |any       |    113277|COLUMN    |TRUE   |X |
|any        |any       |         4|VIRTUAL   |TRUE   |  |
---------------------------------------------------------

*/

  SCHEMA_NAME,
  TABLE_NAME,
  LPAD(NUM_TABLES, 10) NUM_TABLES,
  TABLE_TYPE,
  LOGGING,
  MAP(PK, 'TRUE', 'X', ' ') PK
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')       != 0 THEN T.SCHEMA_NAME     ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)   END SCHEMA_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')        != 0 THEN T.TABLE_NAME      ELSE MAP(BI.TABLE_NAME, '%', 'any', BI.TABLE_NAME)     END TABLE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TYPE')         != 0 THEN T.TABLE_TYPE      ELSE MAP(BI.TABLE_TYPE, '%', 'any', BI.TABLE_TYPE)     END TABLE_TYPE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'LOGGING')      != 0 THEN T.IS_LOGGED       ELSE MAP(BI.LOGGING, '%', 'any', BI.LOGGING)           END LOGGING,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PK')           != 0 THEN T.HAS_PRIMARY_KEY ELSE MAP(BI.PRIMARY_KEY, '%', 'any', BI.PRIMARY_KEY)   END PK,
    COUNT(*) NUM_TABLES
  FROM
  ( SELECT               /* Modification section */
      '%' SCHEMA_NAME,
      '%' TABLE_NAME,
      '%' LOGGING,                       /* TRUE, FALSE, % */
      '%' TABLE_TYPE,                    /* ROW, COLUMN, COLLECTION, HISTORY, ... */
      '%' TEMP_TYPE,
      '%' PRIMARY_KEY,                   /* TRUE, FALSE, % */
      'NONE' AGGREGATE_BY                /* SCHEMA, TABLE, TYPE, LOGGING, PK or comma separated combinations, NONE for no aggregation */
    FROM
      DUMMY
  ) BI,
    TABLES T
  WHERE
    T.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    T.TABLE_NAME LIKE BI.TABLE_NAME AND
    T.IS_LOGGED LIKE BI.LOGGING AND
    T.TABLE_TYPE LIKE BI.TABLE_TYPE AND
    T.HAS_PRIMARY_KEY LIKE BI.PRIMARY_KEY
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')       != 0 THEN T.SCHEMA_NAME     ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)   END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')        != 0 THEN T.TABLE_NAME      ELSE MAP(BI.TABLE_NAME, '%', 'any', BI.TABLE_NAME)     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TYPE')         != 0 THEN T.TABLE_TYPE      ELSE MAP(BI.TABLE_TYPE, '%', 'any', BI.TABLE_TYPE)     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'LOGGING')      != 0 THEN T.IS_LOGGED       ELSE MAP(BI.LOGGING, '%', 'any', BI.LOGGING)           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PK')           != 0 THEN T.HAS_PRIMARY_KEY ELSE MAP(BI.PRIMARY_KEY, '%', 'any', BI.PRIMARY_KEY)   END
)
