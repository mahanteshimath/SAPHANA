SELECT
/* 

[NAME]

- HANA_Columns

[DESCRIPTION]

- Column information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/12/15:  1.0 (initial version)
- 2014/12/28:  1.1 (STORE added)
- 2017/07/15:  1.2 (LOAD_UNIT added)
- 2019/01/29:  1.3 (AGGREGATE_BY added)

[INVOLVED TABLES]

- TABLE_COLUMNS
- VIEW_COLUMNS
- M_MONITOR_COLUMNS

[INPUT PARAMETERS]

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- OBJECT_TYPE

  Object type

  'TABLE'         --> Tables
  'VIEW'          --> Views
  'MONITOR'       --> Monitoring views (M_*)
  '%'             --> No restriction related to object type

- OBJECT_NAME           

  OBJECT name or pattern

  'T000'          --> Specific object T000
  'T%'            --> All objects starting with 'T'
  '%'             --> All objects

- COLUMN_NAME

  Column name

  'MATNR'         --> Column MATNR
  'Z%'            --> Columns starting with "Z"
  '%'             --> No restriction related to columns

- DATA_TYPE

  Column data type

  'NCLOB'         --> Type 'NCLOB'
  '%LOB%'         --> All types containing 'LOB'
  '%'             --> All types

- LOAD_UNIT

  Column load unit

  'TABLE'         --> Load on table level
  'COLUMN'        --> Load on column level
  'PAGE'          --> Load on page level ("paged attribute")

- STORE

  Restriction to store 

  'ROW'           --> Only row store information
  'COLUMN'        --> Only column store information
  '%'             --> No store restriction

- MIN_COLUMN_COUNT

  Minimum threshold for number of columns

  100             --> Only show result lines with at least 100 columns
  -1              --> No restriction related to number of columns

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TYPE'           --> Aggregation by object type
  'SCHEMA, OBJECT' --> Aggregation by schema and object
  'NONE'           --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'COUNT'         --> Sorting by number of columns
  'NAME'          --> Sorting by object name

[OUTPUT PARAMETERS]

- SCHEMA_NAME:   Schema name
- OBJECT_TYPE:   Object type (TABLE, VIEW, MONITOR)
- OBJECT_NAME:   Object name
- COLUMNS:       Number of columns
- STORE:         ROW for table in row store, COLUMN for table in column store, otherwise empty
- COLUMN_NAME:   Column name
- POS:           Column position in object
- DATA_TYPE:     Data type
- LENGTH:        Maximum number of digits and characters
- SCALE:         Maximum number of digits after the decimal point
- NULLABLE:      TRUE if column can contain NULL values, otherwise FALSE
- DEFAULT_VALUE: Default value
- LOAD_UNIT:     Load unit (TABLE, COLUMN, PAGE)
- COMMENT:       Column comment

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME|OBJECT_NAME                  |COLUMN_NAME                          |POS |DATA_TYPE|LENGTH|SCALE|NULLABLE|DEFAULT_VALUE|DESCRIPTION                                             |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SYS        |M_BACKUP_CATALOG             |ENTRY_ID                             |   1|BIGINT   |    19|    0|TRUE    |n/a          |Unique ID of a backup catalog entry (counter)           |
|SYS        |M_BACKUP_CATALOG             |BACKUP_ID                            |   3|BIGINT   |    19|    0|TRUE    |n/a          |Unique ID of a data backup or a log backup respectively.|
|SYS        |M_BACKUP_CATALOG             |SYS_START_TIME                       |   4|TIMESTAMP|    27|    7|TRUE    |n/a          |Start time given in server local time                   |
|SYS        |M_BACKUP_CATALOG             |UTC_START_TIME                       |   5|TIMESTAMP|    27|    7|TRUE    |n/a          |Start time given in UTC                                 |
|SYS        |M_BACKUP_CATALOG             |SYS_END_TIME                         |   6|TIMESTAMP|    27|    7|TRUE    |n/a          |Stop time given in server local time                    |
|SYS        |M_BACKUP_CATALOG             |UTC_END_TIME                         |   7|TIMESTAMP|    27|    7|TRUE    |n/a          |Stop time given in UTC                                  |
|SYS        |M_BACKUP_CATALOG             |COMMENT                              |   9|VARCHAR  |   256|     |TRUE    |n/a          |Additional information                                  |
|SYS        |M_BACKUP_CATALOG             |MESSAGE                              |  10|VARCHAR  |   512|     |TRUE    |n/a          |Additional information                                  |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  SCHEMA_NAME,
  OBJECT_TYPE,
  OBJECT_NAME,
  LPAD(NUM_COLUMNS, 7) COLUMNS,
  STORE,
  COLUMN_NAME,
  LPAD(POSITION, 4) POS,
  DATA_TYPE DATA_TYPE,
  LPAD(LENGTH, 6) LENGTH,
  IFNULL(LPAD(SCALE, 5), ' ') SCALE,
  IS_NULLABLE NULLABLE,
  IFNULL(DEFAULT_VALUE, 'n/a') DEFAULT_VALUE,
  LOAD_UNIT,
  DESCRIPTION COMMENT
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')      != 0 THEN C.SCHEMA_NAME          ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME) END SCHEMA_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'OBJECT_NAME') != 0 THEN C.OBJECT_NAME          ELSE MAP(BI.OBJECT_NAME, '%', 'any', BI.OBJECT_NAME) END OBJECT_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'OBJECT_TYPE') != 0 THEN C.OBJECT_TYPE          ELSE MAP(BI.OBJECT_TYPE, '%', 'any', BI.OBJECT_TYPE) END OBJECT_TYPE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STORE')       != 0 THEN C.STORE                ELSE MAP(BI.STORE,       '%', 'any', BI.STORE)       END STORE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COLUMN')      != 0 THEN C.COLUMN_NAME          ELSE MAP(BI.COLUMN_NAME, '%', 'any', BI.COLUMN_NAME) END COLUMN_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE'                                               THEN TO_VARCHAR(C.POSITION) ELSE 'any'                                           END POSITION,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DATA_TYPE')   != 0 THEN C.DATA_TYPE            ELSE MAP(BI.DATA_TYPE,   '%', 'any', BI.DATA_TYPE)   END DATA_TYPE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE'                                               THEN TO_VARCHAR(C.LENGTH)   ELSE 'any'                                           END LENGTH,
    CASE WHEN BI.AGGREGATE_BY = 'NONE'                                               THEN TO_VARCHAR(C.SCALE)    ELSE 'any'                                           END SCALE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'NULLABLE')    != 0 THEN C.IS_NULLABLE          ELSE 'any'                                           END IS_NULLABLE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DEFAULT')     != 0 THEN C.DEFAULT_VALUE        ELSE 'any'                                           END DEFAULT_VALUE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'LOAD_UNIT')   != 0 THEN C.LOAD_UNIT            ELSE MAP(BI.LOAD_UNIT,   '%', 'any', BI.LOAD_UNIT)   END LOAD_UNIT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DESCRIPTION') != 0 THEN C.DESCRIPTION          ELSE 'any'                                           END DESCRIPTION,
    COUNT(*) NUM_COLUMNS,
    BI.MIN_COLUMN_COUNT,
    BI.ORDER_BY
  FROM
  ( SELECT                   /* Modification section */
      '%' SCHEMA_NAME,
      '%' OBJECT_TYPE,       /* TABLE, VIEW, MONITOR */
      '%' OBJECT_NAME,
      '%' COLUMN_NAME,
      '%' DATA_TYPE,
      '%' LOAD_UNIT,
      '%' STORE,              /* ROW, COLUMN, % */
      -1 MIN_COLUMN_COUNT,
      'SCHEMA, OBJECT_NAME, OBJECT_TYPE, STORE' AGGREGATE_BY,             /* SCHEMA, OBJECT_NAME, STORE, OBJECT_TYPE, COLUMN, DATA_TYPE, LOAD_UNIT, NULLABLE, DEFAULT, DESCRIPTION */
      'COUNT' ORDER_BY                           /* NAME, COUNT */
    FROM
      DUMMY
  ) BI,
  ( SELECT
      'TABLE' OBJECT_TYPE,
      T.TABLE_TYPE STORE,
      TC.SCHEMA_NAME,
      TC.TABLE_NAME OBJECT_NAME,
      TC.COLUMN_NAME,
      TC.POSITION,
      TC.DATA_TYPE_NAME DATA_TYPE,
      TC.LENGTH,
      TC.SCALE,
      TC.IS_NULLABLE,
      TC.DEFAULT_VALUE,
      TC.LOAD_UNIT,
      TC.COMMENTS DESCRIPTION
    FROM
      TABLES T,
      TABLE_COLUMNS TC
    WHERE
      T.SCHEMA_NAME = TC.SCHEMA_NAME AND
      T.TABLE_NAME = TC.TABLE_NAME
    UNION ALL
    ( SELECT
        'VIEW' OBJECT_TYPE,
        '' STORE,
        SCHEMA_NAME,
        VIEW_NAME OBJECT_NAME,
        COLUMN_NAME,
        POSITION,
        DATA_TYPE_NAME DATA_TYPE,
        LENGTH,
        SCALE,
        IS_NULLABLE,
        DEFAULT_VALUE,
        '' LOAD_UNIT,
        COMMENTS DESCRIPTION
      FROM
        VIEW_COLUMNS
    )
    UNION ALL
    ( SELECT
        'MONITOR' OBJECT_TYPE,
        '' STORE,
        'SYS' SCHEMA_NAME,
        VIEW_NAME OBJECT_NAME,
        VIEW_COLUMN_NAME COLUMN_NAME,
        POSITION,
        DATA_TYPE_NAME DATA_TYPE,
        LENGTH,
        SCALE,
        IS_NULLABLE,
        DEFAULT_VALUE,
        '' LOAD_UNIT,
        DESCRIPTION || MAP(UNIT, NULL, '', CHAR(32) || '(' || LOWER(UNIT) || ')')
      FROM
        M_MONITOR_COLUMNS
    )
  ) C
  WHERE
    C.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    C.OBJECT_TYPE LIKE BI.OBJECT_TYPE AND
    C.OBJECT_NAME LIKE BI.OBJECT_NAME AND
    C.COLUMN_NAME LIKE BI.COLUMN_NAME AND
    C.DATA_TYPE LIKE BI.DATA_TYPE AND
    C.LOAD_UNIT LIKE BI.LOAD_UNIT AND
    C.STORE LIKE BI.STORE
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')      != 0 THEN C.SCHEMA_NAME          ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'OBJECT_NAME') != 0 THEN C.OBJECT_NAME          ELSE MAP(BI.OBJECT_NAME, '%', 'any', BI.OBJECT_NAME) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'OBJECT_TYPE') != 0 THEN C.OBJECT_TYPE          ELSE MAP(BI.OBJECT_TYPE, '%', 'any', BI.OBJECT_TYPE) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STORE')       != 0 THEN C.STORE                ELSE MAP(BI.STORE,       '%', 'any', BI.STORE)       END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COLUMN')      != 0 THEN C.COLUMN_NAME          ELSE MAP(BI.COLUMN_NAME, '%', 'any', BI.COLUMN_NAME) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE'                                               THEN TO_VARCHAR(C.POSITION) ELSE 'any'                                           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DATA_TYPE')   != 0 THEN C.DATA_TYPE            ELSE MAP(BI.DATA_TYPE,   '%', 'any', BI.DATA_TYPE)   END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE'                                               THEN TO_VARCHAR(C.LENGTH)   ELSE 'any'                                           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE'                                               THEN TO_VARCHAR(C.SCALE)    ELSE 'any'                                           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'NULLABLE')    != 0 THEN C.IS_NULLABLE          ELSE 'any'                                           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DEFAULT')     != 0 THEN C.DEFAULT_VALUE        ELSE 'any'                                           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'LOAD_UNIT')   != 0 THEN C.LOAD_UNIT            ELSE MAP(BI.LOAD_UNIT,   '%', 'any', BI.LOAD_UNIT)   END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DESCRIPTION') != 0 THEN C.DESCRIPTION          ELSE 'any'                                           END,
    BI.MIN_COLUMN_COUNT,
    BI.ORDER_BY
)
WHERE
  ( MIN_COLUMN_COUNT = -1 OR NUM_COLUMNS >= MIN_COLUMN_COUNT )
ORDER BY
  MAP(ORDER_BY, 'NAME', SCHEMA_NAME || OBJECT_NAME || OBJECT_TYPE),
  MAP(ORDER_BY, 'COUNT', NUM_COLUMNS) DESC
