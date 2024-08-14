SELECT
/* 

[NAME]

- HANA_GarbageCollection_RowStore_CurrentVersionsPerTable

[DESCRIPTION]

- Current MVCC versions in row store

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/04/24:  1.0 (initial version)

[INVOLVED TABLES]

- M_RS_TABLE_VERSION_STATISTICS
- M_MVCC_TABLES

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

- MIN_VERSION_COUNT

  Threshold for minimum number of active versions

  10000               --> Only list tables with at least 10000 active versions
  -1                  --> No restriction by active versions

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'VERSION'       --> Sorting by active versions
  'TABLE'         --> Sorting by table name
  'COMMIT_ID'     --> Sorting by commit ID range

- RESULT_ROWS

  Number of records to be returned by the query

  100             --> Return a maximum number of 100 records
  -1              --> Return all records

[OUTPUT PARAMETERS]

- HOST:            Host name
- PORT:            Port
- SERVICE:         Service name
- SCHEMA:          Schema name
- TABLE_NAME:      Table name
- TOTAL_VERSIONS:  Total number of row versions of table
- VERS_PCT:        Number of row versions of table compared to total number of versions (%)
- VERS_SIZE_MB:    Size allocated by versions (MB)
- COMMIT_ID_RANGE: Commit ID range (current commit ID - minimum table commit ID)

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------
|HOST     |PORT |SCHEMA|TABLE_NAME|TOTAL_VERSIONS|VERS_PCT|VERS_SIZE_MB|COMMIT_ID_RANGE|
----------------------------------------------------------------------------------------
|saphana21|30103|SAPECC|VBDATA    |         19430|   23.89|        1.33|          69043|
|saphana21|30103|SAPECC|VBMOD     |         18058|   22.20|        1.23|          69043|
|saphana21|30103|SAPECC|EDIDS     |          8132|   10.00|        0.55|          69038|
|saphana21|30103|SAPECC|VBHDR     |          6564|    8.07|        0.53|          69052|
|saphana21|30103|SAPECC|EDIDC     |          5324|    6.54|        0.71|          69038|
|saphana21|30103|SAPECC|ARFCSSTATE|          5007|    6.15|        0.44|          69038|
|saphana21|30103|SAPECC|ARFCSDATA |          4488|    5.51|        0.30|          69038|
|saphana21|30103|SAPECC|SRRELROLES|          4088|    5.02|        0.28|          69038|
|saphana21|30103|SAPECC|ARFCRSTATE|          3916|    4.81|        0.37|          68930|
|saphana21|30103|SAPECC|NRIVSHADOW|          1248|    1.53|        0.14|          68698|
|saphana21|30103|SAPECC|TRFCQOUT  |          1043|    1.28|        0.07|          69038|
|saphana21|30103|SAPECC|NRIV      |           876|    1.07|        0.09|          69034|
|saphana21|30103|SAPECC|TST01     |           815|    1.00|        0.12|          68758|
----------------------------------------------------------------------------------------

*/
  HOST,
  LPAD(TO_VARCHAR(PORT), 5) PORT,
  SERVICE_NAME SERVICE,
  SCHEMA_NAME SCHEMA,
  TABLE_NAME,
  LPAD(VERSION_COUNT, 14) TOTAL_VERSIONS,
  LPAD(TO_DECIMAL(VERSION_PCT, 10, 2), 8) VERS_PCT,
  LPAD(TO_DECIMAL(VERSION_SIZE / 1024 / 1024, 10, 2), 12) VERS_SIZE_MB,
  LPAD(COMMIT_ID_RANGE, 15) COMMIT_ID_RANGE
FROM
( SELECT
    V.HOST,
    V.PORT,
    S.SERVICE_NAME,
    V.SCHEMA_NAME,
    V.TABLE_NAME,
    V.VERSION_COUNT,
    V.VERSION_COUNT / SUM(V.VERSION_COUNT) OVER () * 100 VERSION_PCT,
    V.VERSION_SIZE,
    M.CURRENT_COMMIT_ID - MAP(V.MIN_COMMIT_ID, 0, M.CURRENT_COMMIT_ID, V.MIN_COMMIT_ID) COMMIT_ID_RANGE,
    ROW_NUMBER () OVER (ORDER BY MAP(BI.ORDER_BY, 'VERSION', V.VERSION_COUNT, 'COMMIT_ID', M.CURRENT_COMMIT_ID - MAP(V.MIN_COMMIT_ID, 0, M.CURRENT_COMMIT_ID, V.MIN_COMMIT_ID), 0) DESC, 
      V.HOST, V.PORT, V.SCHEMA_NAME, V.TABLE_NAME) ROW_NUM,
    BI.ORDER_BY,
    BI.RESULT_ROWS
  FROM
  ( SELECT                      /* Modification section */
      '%' HOST,
      '%' PORT,
      '%' SERVICE_NAME,
      '%' SCHEMA_NAME,
      '%' TABLE_NAME,
      -1 MIN_VERSION_COUNT,
      'VERSION' ORDER_BY,          /* VERSION, TABLE, COMMIT_ID */
      20 RESULT_ROWS
    FROM
      DUMMY
  ) BI,
    M_SERVICES S,
    M_RS_TABLE_VERSION_STATISTICS V,
  ( SELECT MAX(VALUE) CURRENT_COMMIT_ID FROM M_MVCC_TABLES WHERE NAME = 'GLOBAL_TS' ) M
  WHERE
    S.HOST LIKE BI.HOST AND
    TO_VARCHAR(S.PORT) LIKE BI.PORT AND
    S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
    V.HOST = S.HOST AND
    V.PORT = S.PORT AND
    V.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    V.TABLE_NAME LIKE BI.TABLE_NAME AND
    ( BI.MIN_VERSION_COUNT = -1 OR V.VERSION_COUNT >= BI.MIN_VERSION_COUNT )
)
WHERE
  ( RESULT_ROWS = -1 OR ROW_NUM <= RESULT_ROWS )
ORDER BY
  MAP(ORDER_BY, 'VERSION', VERSION_COUNT, 'COMMIT_ID', COMMIT_ID_RANGE, 1) DESC, 
  HOST, 
  PORT, 
  SCHEMA_NAME, 
  TABLE_NAME