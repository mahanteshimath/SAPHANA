SELECT
/* 

[NAME]

- HANA_Tables_ColumnStore_Overview_2.00.030+

[DESCRIPTION]

- General information about column store

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_CS_ALL_COLUMNS.PERSISTENT_MEMORY_SIZE_IN_TOTAL available with SAP HANA >= 2.00.030

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/03/21:  1.0 (initial version)
- 2015/04/14:  1.1 (MAX_TOTAL_GB included)
- 2022/03/28:  1.2 (PERSISTENT_MEMORY_SIZE_IN_TOTAL included)

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

- MIN_SIZE_MB

  Minimum size in MB

  10              --> Minimum size of 10 MB
  -1              --> No minimum size limitation

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOST, SERVICE' --> Aggregation by host and service 
  'SCHEMA'        --> Aggregation by schema
  'NONE'          --> No aggregation
 
[OUTPUT PARAMETERS]

- HOST:           Host name
- PORT:           Port
- SERVICE:        Service name
- SCHEMA_NAME:    Schema name
- NUM_TABLES:     Number of tables
- MAX_TOTAL_GB:   Total space maximally allocated in column store memory (GB)
- TOTAL_GB:       Total space currently allocated in column store memory (GB)
- MAIN_GB:        Total space currently allocated in main memory of column store (GB)
- DELTA_GB:       Total space currently allocated in delta memory of column store (GB)
- HISTORY_GB:     Total space currently allocated by history tables (GB)

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------
|HOST    |SERVICE_NAME    |SCHEMA_NAME    |NUM_TABLES|TOTAL_GB  |MAIN_GB   |DELTA_GB  |DELTA_PCT |HISTORY_GB|
-------------------------------------------------------------------------------------------------------------
|saphana3|indexserver     |SAPSR3         |     32612|    107.52|    105.12|      2.40|      2.23|      0.00|
|saphana3|statisticsserver|_SYS_STATISTICS|        52|      4.13|      3.69|      0.44|     10.76|      0.00|
|saphana4|indexserver     |SAPSR3         |      2517|    172.89|    172.15|      0.74|      0.42|      0.00|
|saphana5|indexserver     |SAPSR3         |      1972|    201.49|    201.15|      0.33|      0.16|      0.00|
|saphana6|indexserver     |SAPSR3         |      1973|    178.09|    177.78|      0.30|      0.17|      0.00|
|saphana7|indexserver     |SAPSR3         |      1981|    161.99|    161.65|      0.33|      0.20|      0.00|
|saphana8|indexserver     |SAPSR3         |      1952|    186.70|    186.31|      0.39|      0.21|      0.00|
|saphana9|indexserver     |SAPSR3         |      1962|    163.16|    162.79|      0.37|      0.23|      0.00|
|saphana0|indexserver     |SAPSR3         |      1961|    187.58|    187.19|      0.39|      0.21|      0.00|
|saphana1|indexserver     |SAPSR3         |      1985|    176.22|    175.89|      0.32|      0.18|      0.00|
-------------------------------------------------------------------------------------------------------------

*/

  CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')    != 0 THEN T.HOST          ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                 END HOST,
  CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(T.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                 END PORT,
  CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE') != 0 THEN S.SERVICE_NAME  ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME) END SERVICE_NAME,
  CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')  != 0 THEN T.SCHEMA_NAME   ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)   END SCHEMA_NAME,
  LPAD(COUNT(DISTINCT(T.TABLE_NAME)), 10) NUM_TABLES,
  LPAD(TO_DECIMAL(SUM(T.ESTIMATED_MAX_MEMORY_SIZE_IN_TOTAL) / 1024 / 1024 / 1024, 10, 2), 14) MAX_TOTAL_GB,
  LPAD(TO_DECIMAL(SUM(T.MEMORY_SIZE_IN_TOTAL + T.PERSISTENT_MEMORY_SIZE_IN_TOTAL) / 1024 / 1024 / 1024, 10, 2), 10) TOTAL_GB,
  LPAD(TO_DECIMAL(SUM(T.MEMORY_SIZE_IN_MAIN)  / 1024 / 1024 / 1024, 10, 2), 10) MAIN_GB,
  LPAD(TO_DECIMAL(SUM(T.MEMORY_SIZE_IN_DELTA) / 1024 / 1024 / 1024, 10, 2), 10) DELTA_GB,
  LPAD(TO_DECIMAL(MAP(SUM(T.MEMORY_SIZE_IN_TOTAL + T.PERSISTENT_MEMORY_SIZE_IN_TOTAL), 0, 0, SUM(T.MEMORY_SIZE_IN_DELTA) / SUM(T.MEMORY_SIZE_IN_TOTAL + T.PERSISTENT_MEMORY_SIZE_IN_TOTAL) * 100), 10, 2), 10) DELTA_PCT,
  LPAD(TO_DECIMAL(SUM(T.MEMORY_SIZE_IN_HISTORY_MAIN + T.MEMORY_SIZE_IN_HISTORY_DELTA) / 1024 / 1024 / 1024, 10, 2), 10) HISTORY_GB
FROM
( SELECT                   /* Modification section */
    '%' HOST,
    '%' PORT,
    '%' SERVICE_NAME,
    '%' SCHEMA_NAME,
    1024 MIN_SIZE_MB,
    'NONE' AGGREGATE_BY       /* HOST, PORT, SERVICE, SCHEMA or comma separated combinations, NONE for no aggregation */
  FROM
    DUMMY
) BI,
  M_SERVICES S,
  M_CS_TABLES T
WHERE
  S.HOST LIKE BI.HOST AND
  TO_VARCHAR(S.PORT) LIKE BI.PORT AND
  S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
  T.HOST = S.HOST AND
  T.PORT = S.PORT
GROUP BY
  CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')    != 0 THEN T.HOST          ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                 END,
  CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(T.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                 END,
  CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE') != 0 THEN S.SERVICE_NAME  ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME) END,
  CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')  != 0 THEN T.SCHEMA_NAME   ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)   END,
  BI.MIN_SIZE_MB
HAVING
  SUM(T.MEMORY_SIZE_IN_TOTAL + T.PERSISTENT_MEMORY_SIZE_IN_TOTAL) / 1024 / 1024 >= BI.MIN_SIZE_MB
ORDER BY
  HOST,
  PORT,
  SCHEMA_NAME

