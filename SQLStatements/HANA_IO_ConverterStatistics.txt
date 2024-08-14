SELECT
/* 

[NAME]

- HANA_IO_ConverterStatistics

[DESCRIPTION]

- Converter information (mapping of logical page numbers to physical data volume pages)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- RESET can be performed via:

  ALTER SYSTEM RESET MONITORING VIEW M_CONVERTER_STATISTICS_RESET

- Can be used for monitoring remote system replication sites, see SAP Note 1999880 
  ("Is it possible to monitor remote system replication sites on the primary system") for details.

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/07/16:  1.0 (initial version)
- 2021/01/01:  1.1 (MAX_PAGE_NUMBER included)

[INVOLVED TABLES]

- M_CONVERTER_STATISTICS
- M_CONVERTER_STATISTICS_RESET

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

- TYPE

  Converter page type

  'RowStoreConverter' --> Pages related to type RowStoreConverter
  '%'                 --> No restriction related to converter type

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'RESET'         --> Data from reset information (*_RESET tables)

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TYPE'          --> Aggregation by converter type
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

[OUTPUT PARAMETERS]

- HOST:            Host name
- PORT:            Port
- TYPE:            Converter type
- MAX_PAGE_NUMBER: Maximum page number
- SUM_SIZE_GB:     Converter size (GB)
- SUM_SIZE_PCT:    Converter size compared to total converter size (%)
- AVG_SIZE_KB:     Average converter page size (KB)

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------
|HOST       |PORT |TYPE              |SUM_SIZE_GB|SUM_SIZE_PCT|AVG_SIZE_KB|
---------------------------------------------------------------------------
|saphana0001|30203|DynamicConverter  |      84.73|       89.14|      23.78|
|saphana0001|30203|RowStoreConverter |      10.25|       10.78|      16.00|
|saphana0001|30207|RowStoreConverter |       0.06|        0.06|      16.00|
|saphana0001|30203|StaticConverter   |       0.00|        0.00|     256.00|
|saphana0001|30203|TemporaryConverter|       0.00|        0.00|       0.00|
|saphana0001|30207|DynamicConverter  |       0.00|        0.00|     130.00|
|saphana0001|30207|StaticConverter   |       0.00|        0.00|       0.00|
|saphana0001|30207|TemporaryConverter|       0.00|        0.00|       0.00|
---------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  TYPE,
  LPAD(MAX_PAGENUMBER, 15) MAX_PAGE_NUMBER,
  LPAD(TO_DECIMAL(SUM_SIZE_GB, 10, 2), 11) SUM_SIZE_GB,
  LPAD(TO_DECIMAL(SUM_SIZE_PCT, 10, 2), 12) SUM_SIZE_PCT,
  LPAD(TO_DECIMAL(AVG_SIZE_KB, 10, 2), 11) AVG_SIZE_KB
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')    != 0 THEN C.HOST             ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                 END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(C.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                 END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TYPE')    != 0 THEN TO_VARCHAR(C.TYPE) ELSE MAP(BI.TYPE, '%', 'any', BI.TYPE)                 END TYPE,
    SUM(MAX_PAGENUMBER) MAX_PAGENUMBER,
    SUM(ALLOCATED_PAGE_SIZE) / 1024 / 1024 / 1024 SUM_SIZE_GB,
    MAP(AVG(TOTAL_ALLOCATED_PAGE_SIZE), 0, 0,  SUM(ALLOCATED_PAGE_SIZE) / AVG(TOTAL_ALLOCATED_PAGE_SIZE) * 100) SUM_SIZE_PCT,
    MAP(SUM(ALLOCATED_PAGE_COUNT), 0, 0, SUM(ALLOCATED_PAGE_SIZE) / SUM(ALLOCATED_PAGE_COUNT) / 1024) AVG_SIZE_KB
  FROM
  ( SELECT               /* Modification section */
      '%' HOST,
      '%' PORT,
      '%' TYPE,
      'CURRENT' DATA_SOURCE,                /* CURRENT, RESET */
      'NONE' AGGREGATE_BY                   /* HOST, PORT, TYPE or comma separated combinations, NONE for no aggregation */
    FROM
      DUMMY
  ) BI,
  ( SELECT
      'CURRENT' DATA_SOURCE,
      HOST,
      PORT,
      TYPE,
      MAX_PAGENUMBER,
      ALLOCATED_PAGE_COUNT,
      ALLOCATED_PAGE_SIZE,
      SUM(ALLOCATED_PAGE_SIZE) OVER () TOTAL_ALLOCATED_PAGE_SIZE
    FROM
      M_CONVERTER_STATISTICS
    UNION ALL
    SELECT
      'RESET',
      HOST,
      PORT,
      TYPE,
      MAX_PAGENUMBER,
      ALLOCATED_PAGE_COUNT,
      ALLOCATED_PAGE_SIZE,
      SUM(ALLOCATED_PAGE_SIZE) OVER ()
    FROM
      M_CONVERTER_STATISTICS_RESET
  ) C
  WHERE
    C.HOST LIKE BI.HOST AND
    TO_VARCHAR(C.PORT) LIKE BI.PORT AND
    C.TYPE LIKE BI.TYPE AND
    C.DATA_SOURCE = BI.DATA_SOURCE
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')    != 0 THEN C.HOST             ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                 END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(C.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                 END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TYPE')    != 0 THEN TO_VARCHAR(C.TYPE) ELSE MAP(BI.TYPE, '%', 'any', BI.TYPE)                 END
)
ORDER BY
  SUM_SIZE_GB DESC