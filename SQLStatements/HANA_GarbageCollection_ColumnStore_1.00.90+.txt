SELECT
/* 

[NAME]

- HANA_GarbageCollection_ColumnStore_1.00.90+

[DESCRIPTION]

- MVCC information for column store

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_CS_MVCC only available as of Rev. 90

[VALID FOR]

- Revisions:              >= 1.00.90

[SQL COMMAND VERSION]

- 2015/05/16:  1.0 (initial version)

[INVOLVED TABLES]

- M_CS_MVCC

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

[OUTPUT PARAMETERS]

- SCHEMA_NAME:    Schema name
- TABLE_NAME:     Table name
- MVCC_TOTAL_MB:  Total size of memory allocated by MVCC information (MB)
- MVCC_CREATE_MB: Size of memory allocated by creation timestamps (MB)
- MVCC_DELETE_MB: Size of memory allocated by deletion timestamps (MB)

[EXAMPLE OUTPUT]

------------------------------------------------------------------------
|SCHEMA_NAME    |TABLE_NAME|MVCC_TOTAL_MB|MVCC_CREATE_MB|MVCC_DELETE_MB|
------------------------------------------------------------------------
|SAPHWP         |any       |        13.78|         13.63|          0.15|
|_SYS_BI        |any       |         0.00|          0.00|          0.00|
|_SYS_EPM       |any       |         0.00|          0.00|          0.00|
|_SYS_REPO      |any       |         0.00|          0.00|          0.00|
|_SYS_RT        |any       |         0.00|          0.00|          0.00|
|_SYS_STATISTICS|any       |         0.00|          0.00|          0.00|
|_SYS_XS        |any       |         0.00|          0.00|          0.00|
------------------------------------------------------------------------

*/
  SCHEMA_NAME,
  TABLE_NAME,
  LPAD(TO_DECIMAL(MVCC_TOTAL_MB, 10, 2), 13) MVCC_TOTAL_MB,
  LPAD(TO_DECIMAL(MVCC_CREATE_MB, 10, 2), 14) MVCC_CREATE_MB,
  LPAD(TO_DECIMAL(MVCC_DELETE_MB, 10, 2), 14) MVCC_DELETE_MB
FROM
( SELECT
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SCHEMA')   != 0 THEN SCHEMA_NAME ELSE MAP(BI_SCHEMA_NAME, '%', 'any', BI_SCHEMA_NAME) END SCHEMA_NAME,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TABLE')    != 0 THEN TABLE_NAME  ELSE MAP(BI_TABLE_NAME, '%', 'any', BI_TABLE_NAME)   END TABLE_NAME,
    SUM(( CTS_MEMORY_SIZE + DTS_MEMORY_SIZE ) / 1024 / 1024) MVCC_TOTAL_MB,
    SUM(CTS_MEMORY_SIZE / 1024 / 1024) MVCC_CREATE_MB,
    SUM(DTS_MEMORY_SIZE / 1024 / 1024) MVCC_DELETE_MB,
    MIN_MVCC_MEMORY_MB
  FROM
  ( SELECT
      M.SCHEMA_NAME,
      MAP(BI.OBJECT_LEVEL, 'PARTITION', M.TABLE_NAME || MAP(M.PART_ID, 0, '', -1, '', ' (' || M.PART_ID || ')'), M.TABLE_NAME) TABLE_NAME,
      M.CTS_MEMORY_SIZE,
      M.DTS_MEMORY_SIZE,
      BI.TABLE_NAME BI_TABLE_NAME,
      BI.SCHEMA_NAME BI_SCHEMA_NAME,
      BI.MIN_MVCC_MEMORY_MB,
      BI.AGGREGATE_BY
    FROM
    ( SELECT                    /* Modification section */
        '%' SCHEMA_NAME,
        '%' TABLE_NAME,
        5120 MIN_MVCC_MEMORY_MB,
        'TABLE' OBJECT_LEVEL,
        'NONE' AGGREGATE_BY                 /* SCHEMA, TABLE and comma separated combinations, NONE for no aggregation */
      FROM
        DUMMY
    ) BI,
      M_CS_MVCC M
    WHERE
      M.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
      M.TABLE_NAME LIKE BI.TABLE_NAME
  )
  GROUP BY
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SCHEMA')   != 0 THEN SCHEMA_NAME ELSE MAP(BI_SCHEMA_NAME, '%', 'any', BI_SCHEMA_NAME) END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TABLE')    != 0 THEN TABLE_NAME  ELSE MAP(BI_TABLE_NAME, '%', 'any', BI_TABLE_NAME)   END,
    MIN_MVCC_MEMORY_MB
)
WHERE
( MIN_MVCC_MEMORY_MB = -1 OR
  MVCC_TOTAL_MB >= MIN_MVCC_MEMORY_MB
)
ORDER BY
  MVCC_TOTAL_MB DESC,
  SCHEMA_NAME,
  TABLE_NAME