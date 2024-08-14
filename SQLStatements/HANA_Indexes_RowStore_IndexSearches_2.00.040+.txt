SELECT

/* 

[NAME]

- HANA_Indexes_RowStore_IndexSearches_2.00.040+

[DESCRIPTION]

- Index search activity on row store indexes

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_RS_INDEXES.SEARCH_COUNT available with SAP HANA 2.00.040 and higher
- Index searches are in general good because it means that an index is actually used
- Vice versa an index without index searches may be not required
- Index searches are always counted since last startup

[VALID FOR]

- Revisions:              >= 2.00.040

[SQL COMMAND VERSION]

- 2019/07/21:  1.0 (initial version)

[INVOLVED TABLES]

- M_RS_INDEXES

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

- TABLE_NAME           

  Table name or pattern

  'T000'          --> Specific table T000
  'T%'            --> All tables starting with 'T'
  '%'             --> All tables

- INDEX_NAME

  Index name or pattern

  'EDIDC~1'       --> Specific index EDIDC~1
  '%~2'           --> All indexes ending with '~2'
  '%'             --> All indexes

- MIN_INDEX_SIZE_MB

  Minimum index size (MB)

  500             --> Only display index with a size of at least 500 MB
  -1              --> No restriction related to index size

- MIN_INDEX_SEARCHES

  Minimum threshold for index searches

  1000000         --> Only display indexes with at least 1000000 searches
  -1              --> No restriction related to index searches

- MAX_INDEX_SEARCHES

  Maximum threshold for index searches

  0               --> Only display indexes without any index search
  -1              --> No restriction related to index searches

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'SIZE'          --> Sorting by size 
  'SEARCHES'      --> Sorting by index searches

[OUTPUT PARAMETERS]

- HOST:           Host
- PORT:           Port
- SCHEMA_NAME:    Schema name
- TABLE_NAME:     Table name
- INDEX_NAME:     Index name
- SIZE_MB:        Index size (MB)
- ROWS:           Number of index rows
- SEARCHES:       Total index searches (since startup)
- SEARCHES_PER_S: Index searches per second

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------
|PORT |SCHEMA_NAME|TABLE_NAME|INDEX_NAME  |SIZE_MB   |ROWS        |SEARCHES    |SEARCHES_PER_S|
-----------------------------------------------------------------------------------------------
|30003|SAPC11     |TBTCO     |TBTCO~0     |    127.05|     3180870|  2443608789|       2379.22|
|30003|SAPC11     |DYNPSOURCE|DYNPSOURCE^0|      7.52|      297356|   364096726|        354.50|
|30003|SAPC11     |TST03     |TST03~0     |   2643.98|    91988329|   318011102|        309.63|
|30003|SAPC11     |DD01L     |DD01L^0     |      3.17|      125806|   222418721|        216.55|
|30003|SAPC11     |DD12L     |DD12L^0     |      0.62|       24683|   187947728|        182.99|
|30003|SAPC11     |DDNTT     |DDNTT^0     |     31.84|     1296446|   168169294|        163.73|
|30003|SAPC11     |VBDATA    |VBDATA^0    |      4.24|      109050|   155863778|        151.75|
|30003|SAPC11     |DYNPLOAD  |DYNPLOAD^0  |      2.54|       99626|   108853744|        105.98|
|30003|SAPC11     |VARI      |VARI~0      |    272.51|     9558990|    96172906|         93.63|
|30003|SAPC11     |TST01     |TST01~0     |     86.62|     1934699|    82745504|         80.56|
-----------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  SCHEMA_NAME,
  TABLE_NAME,
  INDEX_NAME,
  LPAD(TO_DECIMAL(SIZE_MB, 10, 2), 10) SIZE_MB,
  LPAD(RECORD_COUNT, 12) ROWS,
  LPAD(SEARCH_COUNT, 12) SEARCHES,
  LPAD(TO_DECIMAL(MAP(UPTIME_S, 0, 0, SEARCH_COUNT / UPTIME_S), 14, 2), 14) SEARCHES_PER_S
FROM
( SELECT
    I.HOST,
    I.PORT,
    I.SCHEMA_NAME,
    I.TABLE_NAME,
    I.INDEX_NAME,
    I.INDEX_SIZE / 1024 / 1024 SIZE_MB,
    I.SEARCH_COUNT,
    I.ENTRY_COUNT RECORD_COUNT,
    I.SEARCH_COUNT * I.ENTRY_COUNT SEARCHED_ROWS,
    SECONDS_BETWEEN(SS.START_TIME, CURRENT_TIMESTAMP) UPTIME_S,
    BI.ORDER_BY
  FROM
  ( SELECT                       /* Modification section */
      '%' HOST,
      '%' PORT,
      '%' SCHEMA_NAME,
      '%' TABLE_NAME,
      '%' INDEX_NAME,
      -1  MIN_INDEX_SIZE_MB,
      -1  MIN_INDEX_SEARCHES,
      -1  MAX_INDEX_SEARCHES,
      'SEARCHES' ORDER_BY                 /* NAME, SIZE, ROWS, SEARCHES */
    FROM
      DUMMY
  ) BI,
    M_RS_INDEXES I,
    M_SERVICE_STATISTICS SS
  WHERE
    I.HOST LIKE BI.HOST AND
    TO_VARCHAR(I.PORT) LIKE BI.PORT AND
    I.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    I.TABLE_NAME LIKE BI.TABLE_NAME AND
    I.INDEX_NAME LIKE BI.INDEX_NAME AND
    ( BI.MIN_INDEX_SIZE_MB = -1 OR I.INDEX_SIZE / 1024 / 1024 >= BI.MIN_INDEX_SIZE_MB ) AND
    ( BI.MIN_INDEX_SEARCHES = -1 OR I.SEARCH_COUNT >= BI.MIN_INDEX_SEARCHES ) AND
    ( BI.MAX_INDEX_SEARCHES = -1 OR I.SEARCH_COUNT <= BI.MAX_INDEX_SEARCHES ) AND
    I.HOST = SS.HOST AND
    I.PORT = SS.PORT
)
ORDER BY
  MAP(ORDER_BY, 'NAME', HOST || PORT || SCHEMA_NAME || TABLE_NAME || INDEX_NAME),
  MAP(ORDER_BY, 'SIZE', SIZE_MB, 'SEARCHES', SEARCH_COUNT, 'SEARCHES', RECORD_COUNT * SEARCH_COUNT, 'ROWS', RECORD_COUNT) DESC