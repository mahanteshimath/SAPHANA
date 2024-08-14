SELECT
/* 

[NAME]

- HANA_Tables_TemporaryViews

[DESCRIPTION]

- Temporary view overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2020/09/26:  1.0 (initial version)

[INVOLVED TABLES]

- M_TEMPORARY_VIEWS
- M_TEMPORARY_VIEW_COLUMNS

[INPUT PARAMETERS]

- HOST

  Host name

  'saphana01'     --> Specific host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- PORT

  Port number

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- VIEW_NAME           

  VIEW name or pattern

  'T000'          --> Specific view T000
  'T%'            --> All views starting with 'T'
  '%'             --> All views

- VIEW_CLASS

  Temporary view class

  '%CRM%'         --> Display temporary views with classes related to CRM
  '%'             --> No restriction related to temporary view class

- VIEW_TYPE

  Temporary view type (e.g. CALC, OLAP)

  'OLAP'          --> Display temporary OLAP views
  '%'             --> No restriction related to temporary view type

- IS_COLUMN_VIEW

  'TRUE'          --> Restrict result to column store tables
  'FALSE'         --> Restrict result to non-column store tables (e.g. row store)
  '%'             --> No restriction to column store tables

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'COLUMN'        --> Aggregation by column
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'COUNT'         --> Sorting by number of views
  'VIEW'          --> Sorting by table name

[OUTPUT PARAMETERS]

- HOST:         Host name
- PORT:         Port
- SCHEMA_NAME:  Schema name
- VIEW_NAME:    Table name
- VIEW_CLASS:   Table class
- TYPE:         Temporary table type
- C:            'X' if column store table, otherwise ' '
- NUM_VIEWS:    Number of tables
- PERCENT:      Percentage of tables
- COLUMNS:      Column list

[EXAMPLE OUTPUT]


*/

  HOST,
  PORT,
  SCHEMA_NAME,
  VIEW_NAME,
  VIEW_CLASS,
  VIEW_TYPE TYPE,
  MAP(IS_COLUMN_VIEW, 'TRUE', 'X', 'FALSE', ' ', 'any') C,
  LPAD(NUM_VIEWS, 10) NUM_VIEWS,
  LPAD(TO_DECIMAL(NUM_VIEWS / SUM(NUM_VIEWS) OVER () * 100, 10, 2), 7) PERCENT,
  IFNULL(COLUMNS, '') COLUMNS
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')         != 0 THEN IFNULL(T.HOST, '')             ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                     END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')         != 0 THEN IFNULL(TO_VARCHAR(T.PORT), '') ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                     END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')       != 0 THEN T.SCHEMA_NAME                  ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)       END SCHEMA_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'VIEW')         != 0 THEN T.VIEW_NAME                    ELSE MAP(BI.VIEW_NAME, '%', 'any', BI.VIEW_NAME)           END VIEW_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CLASS')        != 0 THEN T.VIEW_CLASS                   ELSE MAP(BI.VIEW_CLASS, '%', 'any', BI.VIEW_CLASS)         END VIEW_CLASS,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COLUMN')       != 0 THEN TC.COLUMNS                     ELSE 'any'                                                 END COLUMNS,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TYPE')         != 0 THEN T.VIEW_TYPE                    ELSE MAP(BI.VIEW_TYPE, '%', 'any', BI.VIEW_TYPE)           END VIEW_TYPE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'IS_COLTAB')    != 0 THEN T.IS_COLUMN_VIEW               ELSE MAP(BI.IS_COLUMN_VIEW, '%', 'any', BI.IS_COLUMN_VIEW) END IS_COLUMN_VIEW,
    COUNT(*) NUM_VIEWS,
    BI.ORDER_BY
  FROM
  ( SELECT                 /* Modification section */
      '%' HOST,
      '%' PORT,
      '%' SCHEMA_NAME,
      '%' VIEW_NAME,
      '%' VIEW_CLASS,
      '%' VIEW_TYPE,
      '%' IS_COLUMN_VIEW,
      'CLASS, TYPE' AGGREGATE_BY,                /* HOST, PORT, SCHEMA, VIEW, CLASS, TYPE, IS_COLTAB, COLUMN or comma separated combinations, NONE for no aggregation */
      'COUNT' ORDER_BY                    /* VIEW, CLASS, COUNT */
    FROM
      DUMMY
  ) BI,
  ( SELECT
      T.*,
      CASE
        WHEN T.VIEW_NAME LIKE '0BW:BIA%'    THEN '0BW:BIA* - BW (hierarchy)'
        WHEN T.VIEW_NAME LIKE '0BW:CRM%'    THEN '0BW:CRM* - BW (CRM segmentation)'
        WHEN T.VIEW_NAME LIKE '0BW:NCUM%'   THEN '0BW:NCUM* - BW (non-cumulative queries)'
        WHEN T.VIEW_NAME LIKE '_SYS_CE_U1%' THEN '_SYS_CE_U1* - BW (HANA composite providers)'
        WHEN T.VIEW_NAME LIKE '_SYS_SS_CE%' THEN '_SYS_SS_CE* - SQLScript'
        ELSE                                                                      'OTHER' || CHAR(32) || '(' || T.VIEW_NAME || ')'
      END VIEW_CLASS
    FROM
      M_TEMPORARY_VIEWS T
  ) T LEFT OUTER JOIN
  ( SELECT
      HOST,
      TO_VARCHAR(PORT) PORT,
      SCHEMA_NAME,
      VIEW_NAME,
      STRING_AGG(COLUMN_NAME, ', ') COLUMNS
    FROM
      M_TEMPORARY_VIEW_COLUMNS
    GROUP BY
      HOST,
      TO_VARCHAR(PORT),
      SCHEMA_NAME,
      VIEW_NAME
  ) TC ON
      TC.HOST = T.HOST AND
      TC.PORT = T.PORT AND
      TC.SCHEMA_NAME = T.SCHEMA_NAME AND
      TC.VIEW_NAME = T.VIEW_NAME
  WHERE
    IFNULL(T.HOST, '') LIKE BI.HOST AND
    TO_VARCHAR(IFNULL(T.PORT, '')) LIKE BI.PORT AND
    T.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    T.VIEW_NAME LIKE BI.VIEW_NAME AND
    T.VIEW_CLASS LIKE BI.VIEW_CLASS AND
    T.VIEW_TYPE LIKE BI.VIEW_TYPE
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')         != 0 THEN IFNULL(T.HOST, '')             ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')         != 0 THEN IFNULL(TO_VARCHAR(T.PORT), '') ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')       != 0 THEN T.SCHEMA_NAME                  ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)       END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'VIEW')         != 0 THEN T.VIEW_NAME                    ELSE MAP(BI.VIEW_NAME, '%', 'any', BI.VIEW_NAME)           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CLASS')        != 0 THEN T.VIEW_CLASS                   ELSE MAP(BI.VIEW_CLASS, '%', 'any', BI.VIEW_CLASS)         END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COLUMN')       != 0 THEN TC.COLUMNS                     ELSE 'any'                                                 END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TYPE')         != 0 THEN T.VIEW_TYPE                    ELSE MAP(BI.VIEW_TYPE, '%', 'any', BI.VIEW_TYPE)           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'IS_COLTAB')    != 0 THEN T.IS_COLUMN_VIEW               ELSE MAP(BI.IS_COLUMN_VIEW, '%', 'any', BI.IS_COLUMN_VIEW) END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'TABLE', SCHEMA_NAME || VIEW_NAME, 'CLASS', VIEW_CLASS),
  MAP(ORDER_BY, 'COUNT', NUM_VIEWS) DESC