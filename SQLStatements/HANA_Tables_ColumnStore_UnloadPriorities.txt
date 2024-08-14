SELECT
/* 

[NAME]

- HANA_Tables_ColumnStore_UnloadPriority

[DESCRIPTION]

- Overview of unload priorities of column store tables

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- See SAP Note 2127458 for more information related to unloads and unload priorities

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/04/09:  1.0 (initial version)
- 2022/03/15:  1.1 (ADJUSTMENT_COMMAND added)

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

- ONLY_DEVIATIONS_FROM_DEFAULT

  Possibility to display only non-default unload priorities

  'X'             --> Only show tables with non-default unload priorities
  ' '             --> No restriction related to non-default unload priorities

- UNLOAD_PRIORITY

  Restriction to a specfic unload priority

  7               --> Only display tables with unload priority 7
  -1              --> No restriction related to unload priority

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'SCHEMA'          --> Aggregation by schema name
  'TABLE, PRIORITY' --> Aggregation by table and unload priority
  'NONE'            --> No aggregation

[OUTPUT PARAMETERS]

- SCHEMA_NAME:        Schema name
- TABLE_NAME:         Table name
- UNLOAD_PRIORITY:    Unload priority
- NUM_TABLES:         Number of tables
- ADJUSTMENT_COMMAND: Command to adjust unload priority to unload priority 5

[EXAMPLE OUTPUT]

---------------------------------------------------
|SCHEMA_NAME|TABLE_NAME|UNLOAD_PRIORITY|NUM_TABLES|
---------------------------------------------------
|any        |any       |0              |         1|
|any        |any       |5              |     37257|
|any        |any       |7              |      1208|
---------------------------------------------------

*/

  SCHEMA_NAME,
  TABLE_NAME,
  LPAD(UNLOAD_PRIORITY, 15) UNLOAD_PRIORITY,
  LPAD(NUM_TABLES, 10) NUM_TABLES,
  'ALTER TABLE "' || SCHEMA_NAME || '"."' || TABLE_NAME || '" UNLOAD PRIORITY 5' || CHAR(59) ADJUSTMENT_COMMAND
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')   != 0 THEN T.SCHEMA_NAME                                ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME) END SCHEMA_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')    != 0 THEN T.TABLE_NAME                                 ELSE MAP(BI.TABLE_NAME, '%', 'any', BI.TABLE_NAME)   END TABLE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PRIORITY') != 0 THEN IFNULL(TO_VARCHAR(T.UNLOAD_PRIORITY), 'n/a') ELSE 'any'                                           END UNLOAD_PRIORITY,
    COUNT(*) NUM_TABLES
  FROM
  ( SELECT            /* Modification section */
      '%' SCHEMA_NAME,
      '%' TABLE_NAME,
      'X' ONLY_DEVIATIONS_FROM_DEFAULT,
      -1 UNLOAD_PRIORITY,
      'NONE' AGGREGATE_BY            /* SCHEMA, TABLE, PRIORITY or comma separated combinations, NONE for no aggregation */
    FROM
      DUMMY
  ) BI,
    TABLES T
  WHERE
    T.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    T.TABLE_NAME LIKE BI.TABLE_NAME AND
    T.IS_COLUMN_TABLE = 'TRUE' AND
    T.IS_TEMPORARY = 'FALSE' AND
    SUBSTR(T.SCHEMA_NAME, 1, 5) != '_SYS_' AND
    T.SCHEMA_NAME NOT IN ( 'SYS' , 'SYSTEM' ) AND
    ( BI.UNLOAD_PRIORITY = -1 OR T.UNLOAD_PRIORITY = BI.UNLOAD_PRIORITY ) AND
    ( BI.ONLY_DEVIATIONS_FROM_DEFAULT = ' ' OR
      ( T.UNLOAD_PRIORITY != 5 AND
        ( T.TABLE_NAME LIKE '/BA1/%' OR
          ( T.TABLE_NAME NOT LIKE 'RSPM%' AND 
            T.TABLE_NAME NOT LIKE 'ZBICZ%' AND
            T.TABLE_NAME NOT LIKE '0BW:BIA%' AND
            T.TABLE_NAME NOT LIKE '$BPC$HC$%' AND
            T.TABLE_NAME NOT LIKE '$BPC$TMP%' AND
            T.TABLE_NAME NOT LIKE '/B%/%' AND
            T.TABLE_NAME NOT LIKE '/1B0/%' AND
            T.TABLE_NAME NOT LIKE '/1DD/%' AND
            SUBSTR(T.TABLE_NAME, 1, 3) != 'TR_'
          )
        ) OR
        T.UNLOAD_PRIORITY NOT IN (5, 7) AND
        ( T.TABLE_NAME NOT LIKE '/BA1/%' AND
          ( T.TABLE_NAME LIKE 'RSPM%' OR 
            T.TABLE_NAME LIKE 'ZBICZ%' OR
            T.TABLE_NAME LIKE '0BW:BIA%' OR
            T.TABLE_NAME LIKE '$BPC$HC$%' OR
            T.TABLE_NAME LIKE '$BPC$TMP%' OR
            T.TABLE_NAME LIKE '/B%/%' OR
            T.TABLE_NAME LIKE '/1B0/%' OR
            T.TABLE_NAME LIKE '/1DD/%' OR
            SUBSTR(T.TABLE_NAME, 1, 3) = 'TR_'
          )
        )
      )
    )
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')   != 0 THEN T.SCHEMA_NAME                                ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')    != 0 THEN T.TABLE_NAME                                 ELSE MAP(BI.TABLE_NAME, '%', 'any', BI.TABLE_NAME)   END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PRIORITY') != 0 THEN IFNULL(TO_VARCHAR(T.UNLOAD_PRIORITY), 'n/a') ELSE 'any'                                           END
)
ORDER BY
  SCHEMA_NAME,
  TABLE_NAME,
  UNLOAD_PRIORITY