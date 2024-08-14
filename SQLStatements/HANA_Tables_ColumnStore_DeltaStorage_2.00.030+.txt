SELECT
/* 

[NAME]

- HANA_Tables_ColumnStore_DeltaStorage_2.00.030+

[DESCRIPTION]

- Record and size information for delta storage (comparable with main storage)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_CS_ALL_COLUMNS.PERSISTENT_MEMORY_SIZE_IN_TOTAL available with SAP HANA >= 2.00.030

[VALID FOR]

- Revisions:              >= 2.00.030

[SQL COMMAND VERSION]

- 2014/09/06:  1.0 (initial version)
- 2016/10/17:  1.1 (AUTO_MERGE_ON included)
- 2022/03/26:  1.2 (PERSISTENT_MEMORY_SIZE_IN_TOTAL included)

[INVOLVED TABLES]

- M_CS_TABLES

[INPUT PARAMETERS]

- HOST

  Host name

  'saphana01'     --> Specic host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- PORT

  Port number

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- SERVICE_NAME

  Service name

  'indexserver'   --> Specific service indexserver
  '%server'       --> All services ending with 'server'
  '%'             --> All services  

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

- OBJECT_LEVEL

  Controls display of partitions

  'PARTITION'     --> Result is shown on partition level
  'TABLE'         --> Result is shown on table level

- MIN_TOTAL_RECORDS

  Minimum number of total records

  100000          --> Only display tables with at least 100,000 records
  -1              --> No restriction related to records

- MIN_DELTA_RECORDS

  Minimum number of records in delta store

  100000          --> Only display tables with at least 100,000 records in delta store
  -1              --> No restriction related to records in delta store

- MIN_DELTA_REC_PCT

  Minimum percentage of records in delta storage (compared to overall number of records in main and delta)

  80              --> Only display tables with at least 80 % of records in delta storage
  -1              --> No restriction related to percentage of records in delta storage

- MIN_DELTA_MEM_PCT

  Minimum percentage of memory allocated by delta storage (compared to overall allocated memory in main and delta)

  30              --> Only display tables with at least 30 % of memory allocated for delta storage
  -1              --> No restriction related to percentage of records in delta storage

- MIN_DELTA_SIZE_MB

  Minimum delta size (MB)

  1024            --> Only consider tables with a delta storage of at least 1024 MB (1 GB)
  -1              --> No restriction related to delta storage size

- AUTO_MERGE_ON

  Auto merge configuration of table

  'TRUE'          --> Only consider tables with activated auto merge
  'FALSE'         --> Only consider tables with deactivated auto merge
  '%'             --> No restriction related to auto merge state configuration of table

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'SCHEMA'        --> Aggregation by schema
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'TOTAL_RECORDS' --> Sorting by total number of rows
  'MAIN_MEM'      --> Sorting by memory allocated by main
  'DELTA_RECORDS' --> Sorting by number of rows in delta
  'DELTA_REC_PCT' --> Sorting by percentage of rows in delta

- RESULT_ROWS

  Number of records to be returned by the query

  100             --> Return a maximum number of 100 records
  -1              --> Return all records

[OUTPUT PARAMETERS]

- HOST:            Host
- PORT:            Port
- SERVICE:         Service name
- SCHEMA_NAME:     Schema name
- TABLE_NAME:      Table name
- RECORDS:         Number of rows
- RECORDS_MAIN:    Raw number of rows in main storage
- RECORDS_DELTA:   Raw number of rows in delta storage
- DELTA_REC_PCT:   Percentage of rows in delta (delta / (main + delta))
- MEM_GB:          Main + delta storage memory (GB)
- MEM_MAIN_GB:     Main storage memory (GB)
- MEM_DELTA_GB:    Delta storage memory (GB)
- DELTA_MEM_PCT:   Percentage of total table memory allocated in delta storage
- LAST_MERGE_TIME: Time of last successful merge operation
- AUTO:            TRUE if auto merge is activated for all involved tables, otherwise FALSE

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST|PORT |SCHEMA_NAME|TABLE_NAME          |RECORDS   |RECORDS_MAIN|RECORDS_DELTA|DELTA_REC_PCT|MEM_GB  |MEM_MAIN_GB|MEM_DELTA_GB|DELTA_MEM_PCT|LAST_MERGE_TIME    |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
|any |  any|any        |/BIC/B0003442001    | 114799875|    71153607|     43646268|        38.01|   28.25|      12.40|       15.85|        56.10|2014/09/06 20:38:57|
|any |  any|any        |/BIC/ALNBSIS2O40    |  70713918|    22314510|     48399408|        68.44|   15.14|       1.85|       13.28|        87.74|2014/09/06 19:34:12|
|any |  any|any        |/BIC/ALNCS01O40     |  23646719|       58754|     23587965|        99.75|   10.85|       0.01|       10.84|        99.88|2014/09/06 16:10:45|
|any |  any|any        |/BIC/AGLOAPOFC00    | 202826842|   200100495|      3330297|         1.63|   15.11|      14.13|        0.97|         6.44|2014/09/02 12:25:39|
|any |  any|any        |/BIC/ALNBSIS1O00    |         0|   145080783|      1268995|         0.86|   28.78|      27.89|        0.89|         3.10|2014/09/03 15:26:08|
|any |  any|any        |/BIC/B0003445001    | 190421311|   188253113|      2168198|         1.13|   30.78|      30.04|        0.74|         2.42|2014/09/06 18:31:56|
|any |  any|any        |/BI0/F0TCT_C02      | 420331926|   414054202|      6277724|         1.49|    9.02|       8.65|        0.36|         4.02|2014/09/02 20:24:44|
---------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  SERVICE_NAME SERVICE,
  SCHEMA_NAME,
  TABLE_NAME,
  LPAD(RECORDS, 10) RECORDS,
  LPAD(RECORDS_MAIN, 12) RECORDS_MAIN,
  LPAD(RECORDS_DELTA, 13) RECORDS_DELTA, 
  LPAD(TO_VARCHAR(TO_DECIMAL(DELTA_REC_PCT, 10, 2)), 13) DELTA_REC_PCT,
  LPAD(TO_DECIMAL(MEM_MAIN_GB + MEM_DELTA_GB, 10, 2), 8) MEM_GB,
  LPAD(TO_DECIMAL(MEM_MAIN_GB, 10, 2), 11) MEM_MAIN_GB,
  LPAD(TO_DECIMAL(MEM_DELTA_GB, 10, 2), 12) MEM_DELTA_GB,
  LPAD(TO_VARCHAR(TO_DECIMAL(DELTA_MEM_PCT, 10, 2)), 13) DELTA_MEM_PCT,
  MAP(LAST_MERGE_TIME, NULL, 'n/a', TO_VARCHAR(LAST_MERGE_TIME, 'YYYY/MM/DD HH24:MI:SS')) LAST_MERGE_TIME,
  AUTO_MERGE AUTO
FROM
( SELECT
    HOST,
    PORT,
    SERVICE_NAME,
    SCHEMA_NAME,
    TABLE_NAME,
    RECORDS,
    RECORDS_MAIN,
    RECORDS_DELTA,
    MEM_MAIN_GB,
    MEM_DELTA_GB,
    AUTO_MERGE,
    LAST_MERGE_TIME,
    DELTA_REC_PCT,
    DELTA_MEM_PCT,
    ORDER_BY,
    RESULT_ROWS,
    ROW_NUMBER () OVER (ORDER BY MAP(ORDER_BY, 'TOTAL_RECORDS', RECORDS, 'MAIN_RECORDS', RECORDS_MAIN, 'DELTA_RECORDS', RECORDS_DELTA, 
      'TOTAL_MEM', MEM_MAIN_GB + MEM_DELTA_GB, 'MAIN_MEM', MEM_MAIN_GB, 'DELTA_MEM', MEM_DELTA_GB, 'DELTA_REC_PCT', DELTA_REC_PCT, 'DELTA_MEM_PCT', DELTA_MEM_PCT) DESC) ROW_NUM
  FROM
  ( SELECT
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST')    != 0 THEN HOST          ELSE MAP(BI_HOST, '%', 'any', BI_HOST)                 END HOST,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(PORT) ELSE MAP(BI_PORT, '%', 'any', BI_PORT)                 END PORT,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SERVICE') != 0 THEN SERVICE_NAME  ELSE MAP(BI_SERVICE_NAME, '%', 'any', BI_SERVICE_NAME) END SERVICE_NAME,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SCHEMA')  != 0 THEN SCHEMA_NAME   ELSE MAP(BI_SCHEMA_NAME, '%', 'any', BI_SCHEMA_NAME)   END SCHEMA_NAME,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TABLE')   != 0 THEN TABLE_NAME    ELSE MAP(BI_TABLE_NAME, '%', 'any', BI_TABLE_NAME)     END TABLE_NAME,
      SUM(RECORDS) RECORDS,
      SUM(RECORDS_MAIN) RECORDS_MAIN,
      SUM(RECORDS_DELTA) RECORDS_DELTA,
      CASE
        WHEN SUM(RECORDS_MAIN) + SUM(RECORDS_DELTA) = 0 THEN 0
        ELSE SUM(RECORDS_DELTA) / SUM(RECORDS_DELTA + RECORDS_MAIN) * 100
        END DELTA_REC_PCT,
      CASE
        WHEN SUM(MEMORY_SIZE_IN_MAIN) + SUM(PERSISTENT_MEMORY_SIZE_IN_TOTAL) + SUM(MEMORY_SIZE_IN_DELTA) = 0 THEN 0
        ELSE SUM(MEMORY_SIZE_IN_DELTA) / SUM(MEMORY_SIZE_IN_DELTA + MEMORY_SIZE_IN_MAIN + PERSISTENT_MEMORY_SIZE_IN_TOTAL) * 100
        END DELTA_MEM_PCT,
      SUM(MEMORY_SIZE_IN_MAIN + PERSISTENT_MEMORY_SIZE_IN_TOTAL) / 1024 / 1024 / 1024 MEM_MAIN_GB,
      SUM(MEMORY_SIZE_IN_DELTA / 1024 / 1024 / 1024) MEM_DELTA_GB,
      MAX(LAST_MERGE_TIME) LAST_MERGE_TIME,
      MIN(AUTO_MERGE) AUTO_MERGE,
      MIN_TOTAL_RECORDS,
      MIN_DELTA_RECORDS,
      MIN_DELTA_REC_PCT,
      MIN_DELTA_MEM_PCT,
      MIN_DELTA_SIZE_MB,
      ORDER_BY,
      RESULT_ROWS
    FROM
    ( SELECT
        T.HOST,
        T.PORT,
        S.SERVICE_NAME,
        T.SCHEMA_NAME,
        CASE BI.OBJECT_LEVEL
          WHEN 'PARTITION' THEN T.TABLE_NAME || MAP(T.PART_ID, 0, '', ' (' || T.PART_ID || ')')
          WHEN 'TABLE'     THEN T.TABLE_NAME
        END TABLE_NAME,
        T.RECORD_COUNT RECORDS,
        T.RAW_RECORD_COUNT_IN_MAIN RECORDS_MAIN,
        T.RAW_RECORD_COUNT_IN_DELTA RECORDS_DELTA,
        T.MEMORY_SIZE_IN_MAIN,
        T.PERSISTENT_MEMORY_SIZE_IN_TOTAL,
        T.MEMORY_SIZE_IN_DELTA,
        T.LAST_MERGE_TIME,
        M.AUTO_MERGE_ON AUTO_MERGE,
        BI.HOST BI_HOST,
        BI.PORT BI_PORT,
        BI.SERVICE_NAME BI_SERVICE_NAME,
        BI.SCHEMA_NAME BI_SCHEMA_NAME,
        BI.TABLE_NAME BI_TABLE_NAME,
        BI.MIN_TOTAL_RECORDS,
        BI.MIN_DELTA_RECORDS,
        BI.MIN_DELTA_SIZE_MB,
        BI.MIN_DELTA_REC_PCT,
        BI.MIN_DELTA_MEM_PCT,
        BI.AGGREGATE_BY,
        BI.RESULT_ROWS,
        BI.ORDER_BY
      FROM
      ( SELECT                     /* Modification section */
          '%' HOST,
          '%' PORT,
          '%' SERVICE_NAME,
          '%' SCHEMA_NAME,
          '%' TABLE_NAME,
          'PARTITION' OBJECT_LEVEL,   /* PARTITION, TABLE */
          -1 MIN_TOTAL_RECORDS,
          1000000 MIN_DELTA_RECORDS,
          -1 MIN_DELTA_SIZE_MB,
          -1 MIN_DELTA_REC_PCT,
          -1 MIN_DELTA_MEM_PCT,
          '%' AUTO_MERGE_ON,      /* TRUE, FALSE, % */
          'NONE' AGGREGATE_BY,       /* HOST, PORT, SERVICE, SCHEMA, TABLE or comma-separated combination, NONE for no aggregation */
          'DELTA_MEM' ORDER_BY,          /* TOTAL_RECORDS, MAIN_RECORDS, DELTA_RECORDS, TOTAL_MEM, MAIN_MEM, DELTA_MEM, DELTA_REC_PCT, DELTA_MEM_PCT */
          50 RESULT_ROWS                 
        FROM
          DUMMY
      ) BI INNER JOIN
        M_SERVICES S ON
          S.HOST LIKE BI.HOST AND
          TO_VARCHAR(S.PORT) LIKE BI.PORT AND
          S.SERVICE_NAME LIKE BI.SERVICE_NAME INNER JOIN
      ( SELECT
          HOST,
          PORT,
          SCHEMA_NAME,
          TABLE_NAME,
          PART_ID,
          RECORD_COUNT,
          RAW_RECORD_COUNT_IN_MAIN,
          RAW_RECORD_COUNT_IN_DELTA,
          MEMORY_SIZE_IN_MAIN,
          PERSISTENT_MEMORY_SIZE_IN_TOTAL,
          MEMORY_SIZE_IN_DELTA,
          LAST_MERGE_TIME
        FROM
          M_CS_TABLES
      ) T ON 
          T.HOST = S.HOST AND
          T.PORT = S.PORT AND
          T.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
          T.TABLE_NAME LIKE BI.TABLE_NAME INNER JOIN
        TABLES M ON
          T.SCHEMA_NAME = M.SCHEMA_NAME AND
          T.TABLE_NAME = M.TABLE_NAME AND
          M.AUTO_MERGE_ON LIKE BI.AUTO_MERGE_ON
    )
    GROUP BY
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST')    != 0 THEN HOST          ELSE MAP(BI_HOST, '%', 'any', BI_HOST)                 END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(PORT) ELSE MAP(BI_PORT, '%', 'any', BI_PORT)                 END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SERVICE') != 0 THEN SERVICE_NAME  ELSE MAP(BI_SERVICE_NAME, '%', 'any', BI_SERVICE_NAME) END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SCHEMA')  != 0 THEN SCHEMA_NAME   ELSE MAP(BI_SCHEMA_NAME, '%', 'any', BI_SCHEMA_NAME)   END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TABLE')   != 0 THEN TABLE_NAME    ELSE MAP(BI_TABLE_NAME, '%', 'any', BI_TABLE_NAME)     END,
      MIN_TOTAL_RECORDS,
      MIN_DELTA_RECORDS,
      MIN_DELTA_REC_PCT,
      MIN_DELTA_MEM_PCT,
      MIN_DELTA_SIZE_MB,
      ORDER_BY,
      RESULT_ROWS
  )
  WHERE
    ( MIN_DELTA_RECORDS = -1 OR RECORDS_DELTA >= MIN_DELTA_RECORDS ) AND
    ( MIN_TOTAL_RECORDS = -1 OR RECORDS >= MIN_TOTAL_RECORDS ) AND
    ( MIN_DELTA_REC_PCT = -1 OR DELTA_REC_PCT >= MIN_DELTA_REC_PCT ) AND
    ( MIN_DELTA_MEM_PCT = -1 OR DELTA_MEM_PCT >= MIN_DELTA_MEM_PCT ) AND
    ( MIN_DELTA_SIZE_MB = -1 OR MEM_DELTA_GB * 1024 >= MIN_DELTA_SIZE_MB )
)
WHERE
  ( RESULT_ROWS = -1 OR ROW_NUM <= RESULT_ROWS )
ORDER BY MAP(ORDER_BY, 
  'TOTAL_RECORDS', RECORDS, 
  'MAIN_RECORDS', RECORDS_MAIN, 
  'DELTA_RECORDS', RECORDS_DELTA, 
  'TOTAL_MEM', MEM_MAIN_GB + MEM_DELTA_GB, 
  'MAIN_MEM', MEM_MAIN_GB, 
  'DELTA_MEM', MEM_DELTA_GB, 
  'DELTA_REC_PCT', DELTA_REC_PCT, 
  'DELTA_MEM_PCT', DELTA_MEM_PCT) DESC
