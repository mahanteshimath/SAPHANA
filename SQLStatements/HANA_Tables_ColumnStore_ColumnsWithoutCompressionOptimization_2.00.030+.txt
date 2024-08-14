SELECT
/* 

[NAME]

- HANA_Tables_ColumnStore_ColumnsWithoutCompressionOptimization_2.00.030+

[DESCRIPTION]

- List column store table columns without advanced compression

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Be aware that there is a chance of false positives, i.e. columns that are reported although a new 
  compression will not be able to compress them efficiently. In this case you can ignore the related 
  tables in the future and do not start more manual compression runs.

[VALID FOR]

- Revisions:              >= 2.00.030

[SQL COMMAND VERSION]

- 2015/10/13:  1.0 (initial version)
- 2016/02/29:  1.1 (AGGREGATE_BY included)
- 2016/07/20:  1.2 (GENERATION_TYPE IS NULL restriction included)
- 2021/07/12:  1.3 (dedicated 2.00.030+ version including PERSISTENT_MEMORY_SIZE_IN_TOTAL)

[INVOLVED TABLES]

- M_CS_COLUMNS

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

- COLUMN_NAME

  Column name

  'MATNR'         --> Column MATNR
  'Z%'            --> Columns starting with 'Z'
  '%'             --> No restriction related to columns

- MIN_RECORD_COUNT

  Minimum number of records

  100000          --> Only display columns with at least 100,000 records
  -1              --> No restriction related to record count

- MIN_MEM_SIZE_MB

  Minimum threshold for the current column memory size (MB)

  500             --> Only consider columns with a current memory size of 500 MB or higher
  -1              --> No restriction related to current column memory size

- MAX_DISTINCT_PCT

  Maximum percentage of distinct values compared to overall number of records (columns with
  a high amount of distinct values often cannot be compressed efficiently)

  25              --> Only report columns with a maximum of 25 % distinct values
  -1              --> No restriction related to distinct values

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'SCHEMA'        --> Aggregation by schema
  'SCHEMA, TABLE' --> Aggregation by schema and table
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'SIZE'          --> Sorting by size 
  'TABLE'         --> Sorting by table name

[OUTPUT PARAMETERS]

- SCHEMA:      Schema name
- TABLE_NAME:  Table name
- COLUMN_NAME: Column name
- NUM:         Number of columns
- RECORDS:     Number of records
- DIST_PCT:    Percentage of distinct values compared to overall number of records
- MEM_GB:      Current column memory allocation (GB)
- COMMAND:     Table compression command

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME    |TABLE_NAME                       |COLUMN_NAME|NUM |RECORDS   |DIST_PCT|MEM_GB |COMMAND                                                                                                         |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SAPSR3         |/BIC/ACINCIBPD40                 |any        |   1|  12722389|    0.00|   0.01|UPDATE "SAPSR3"."/BIC/ACINCIBPD40" WITH PARAMETERS ('OPTIMIZE_COMPRESSION' = 'FORCE')                           |
|SAPSR3         |/BIC/B0000106000                 |any        |   1|   2377583|    4.77|   0.00|UPDATE "SAPSR3"."/BIC/B0000106000" WITH PARAMETERS ('OPTIMIZE_COMPRESSION' = 'FORCE')                           |
|SAPSR3         |/BIC/B0000108000                 |any        |   1| 218787732|    0.00|   0.28|UPDATE "SAPSR3"."/BIC/B0000108000" WITH PARAMETERS ('OPTIMIZE_COMPRESSION' = 'FORCE')                           |
|SAPSR3         |/BIC/B0000122000                 |any        |   2|   4474829|    1.88|   0.01|UPDATE "SAPSR3"."/BIC/B0000122000" WITH PARAMETERS ('OPTIMIZE_COMPRESSION' = 'FORCE')                           |
|SAPSR3         |/BIC/B0000123000                 |any        |   1|   6476812|    2.12|   0.01|UPDATE "SAPSR3"."/BIC/B0000123000" WITH PARAMETERS ('OPTIMIZE_COMPRESSION' = 'FORCE')                           |
|SAPSR3         |/BIC/B0000125000                 |any        |   1|  13041733|    0.00|   0.01|UPDATE "SAPSR3"."/BIC/B0000125000" WITH PARAMETERS ('OPTIMIZE_COMPRESSION' = 'FORCE')                           |
|SAPSR3         |/BIC/B0000130000                 |any        |   2|   4453703|    1.18|   0.01|UPDATE "SAPSR3"."/BIC/B0000130000" WITH PARAMETERS ('OPTIMIZE_COMPRESSION' = 'FORCE')                           |
|SAPSR3         |/BIC/B0000131000                 |any        |   4|   3400334|    1.06|   0.02|UPDATE "SAPSR3"."/BIC/B0000131000" WITH PARAMETERS ('OPTIMIZE_COMPRESSION' = 'FORCE')                           |
|SAPSR3         |/SDF/SMON_WPINFO                 |any        |   1|  17952621|    1.64|   0.04|UPDATE "SAPSR3"."/SDF/SMON_WPINFO" WITH PARAMETERS ('OPTIMIZE_COMPRESSION' = 'FORCE')                           |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  SCHEMA_NAME,
  TABLE_NAME,
  COLUMN_NAME,
  LPAD(NUM, 4) NUM,
  LPAD(RECORDS, 10) RECORDS,
  LPAD(TO_DECIMAL(DIST_PCT, 10, 2), 8) DIST_PCT,
  LPAD(TO_DECIMAL(MEM_GB, 10, 2), 7) MEM_GB,
  CASE WHEN INSTR(TABLE_NAME, '%') = 0 AND TABLE_NAME != 'any' THEN
    'UPDATE "' || SCHEMA_NAME || '"."' || TABLE_NAME || '" WITH PARAMETERS (' || CHAR(39) || 'OPTIMIZE_COMPRESSION' || CHAR(39) || 
      ' = ' || CHAR(39) || 'FORCE' || CHAR(39) || ')' || MAP(GENERATE_SEMICOLON, 'X', ';', '')
    ELSE 'n/a' END COMMAND
FROM
( SELECT
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SCHEMA')   != 0 THEN SCHEMA_NAME ELSE MAP(BI_SCHEMA_NAME, '%', 'any', BI_SCHEMA_NAME) END SCHEMA_NAME,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TABLE')    != 0 THEN TABLE_NAME  ELSE MAP(BI_TABLE_NAME, '%', 'any', BI_TABLE_NAME)   END TABLE_NAME,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'COLUMN')   != 0 THEN COLUMN_NAME ELSE MAP(BI_COLUMN_NAME, '%', 'any', BI_COLUMN_NAME) END COLUMN_NAME,
    COUNT(*) NUM,
    TO_DECIMAL(ROUND(AVG(COUNT)), 10, 0) RECORDS,
    MAP(AVG(COUNT), 0, 0, AVG(DISTINCT_COUNT) / AVG(COUNT) * 100) DIST_PCT,
    SUM(MEMORY_SIZE_IN_TOTAL) / 1024 / 1024 / 1024 MEM_GB,
    GENERATE_SEMICOLON,
    ORDER_BY
  FROM
  ( SELECT
      C.SCHEMA_NAME,
      C.TABLE_NAME,
      C.COLUMN_NAME,
      C.COUNT,
      C.DISTINCT_COUNT,
      C.MEMORY_SIZE_IN_TOTAL,
      BI.SCHEMA_NAME BI_SCHEMA_NAME,
      BI.TABLE_NAME BI_TABLE_NAME,
      BI.COLUMN_NAME BI_COLUMN_NAME,
      BI.GENERATE_SEMICOLON,
      BI.AGGREGATE_BY,
      BI.ORDER_BY
    FROM
    ( SELECT              /* Modification section */
        '%' SCHEMA_NAME,
        '%' TABLE_NAME,
        '%' COLUMN_NAME,
        1000000 MIN_RECORD_COUNT,
        500 MIN_MEM_SIZE_MB,
        2 MAX_DISTINCT_PCT,
        'X' GENERATE_SEMICOLON,
        'SCHEMA,TABLE' AGGREGATE_BY,                  /* SCHEMA, TABLE, COLUMN or comma separated combinations, NONE for no aggregation */
        'TABLE' ORDER_BY                        /* SIZE, TABLE */
      FROM
        DUMMY
    ) BI,
    ( SELECT
        C.SCHEMA_NAME,
        C.TABLE_NAME,
        C.COLUMN_NAME,
        SUM(C.COUNT) COUNT,
        SUM(C.DISTINCT_COUNT) DISTINCT_COUNT,
        SUM(C.MEMORY_SIZE_IN_TOTAL + C.PERSISTENT_MEMORY_SIZE_IN_TOTAL) MEMORY_SIZE_IN_TOTAL
      FROM
        M_CS_COLUMNS C,
        TABLE_COLUMNS TC
      WHERE 
        C.SCHEMA_NAME = TC.SCHEMA_NAME AND
        C.TABLE_NAME = TC.TABLE_NAME AND
        C.COLUMN_NAME = TC.COLUMN_NAME AND
        C.COMPRESSION_TYPE = 'DEFAULT' AND
        TC.GENERATION_TYPE IS NULL
      GROUP BY
        C.SCHEMA_NAME,
        C.TABLE_NAME,
        C.COLUMN_NAME
    ) C
    WHERE
      C.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
      C.TABLE_NAME LIKE BI.TABLE_NAME AND
      C.COLUMN_NAME LIKE BI.COLUMN_NAME AND
      ( BI.MIN_RECORD_COUNT = -1 OR C.COUNT >= BI.MIN_RECORD_COUNT ) AND
      ( BI.MIN_MEM_SIZE_MB = -1 OR C.MEMORY_SIZE_IN_TOTAL / 1024 / 1024 >= BI.MIN_MEM_SIZE_MB ) AND
      ( BI.MAX_DISTINCT_PCT = -1 OR C.DISTINCT_COUNT * 100 <= C.COUNT * BI.MAX_DISTINCT_PCT )
  )
  GROUP BY
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SCHEMA')   != 0 THEN SCHEMA_NAME ELSE MAP(BI_SCHEMA_NAME, '%', 'any', BI_SCHEMA_NAME) END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TABLE')    != 0 THEN TABLE_NAME  ELSE MAP(BI_TABLE_NAME, '%', 'any', BI_TABLE_NAME)   END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'COLUMN')   != 0 THEN COLUMN_NAME ELSE MAP(BI_COLUMN_NAME, '%', 'any', BI_COLUMN_NAME) END,
    GENERATE_SEMICOLON,
    ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'SIZE', MEM_GB, 1) DESC,
  SCHEMA_NAME,
  TABLE_NAME,
  COLUMN_NAME