SELECT
/* 

[NAME]

- HANA_Memory_Caches_Overview

[DESCRIPTION]

- Overview of SAP HANA caches

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- With SAP HANA 2.00.060 - 2.00.063 the M_CACHES access can result in indexserver crashes (bug 289445).

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2016/01/27:  1.0 (initial version)

[INVOLVED TABLES]

- M_CACHES

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

- CACHE_NAME

  Name of cache

  'MdxEntityCache' --> Only display information related to MdxEntityCache
  'CS%'            --> Display information for all caches starting with 'CS'
  '%'              --> No restriction related to cache name

- MIN_USED_SIZE_MB

  Minimum used size threshold for cache

  10              --> Only display caches with a size of at least 10 MB
  -1              --> No limitation related to minimum cache size

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'SERVICE'       --> Aggregation by service
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'SIZE'          --> Sorting by size 
  'CACHE'         --> Sorting by cache name
  'HOST'          --> Sorting by host
  
[OUTPUT PARAMETERS]

- HOST:          Host name
- PORT:          Port
- SERVICE:       Service name
- CACHE_NAME:    Cache name
- NUM_CACHES:    Number of caches
- USED_MB:       Used cache size (MB)
- NUM_ENTRIES:   Number of cache entries
- NUM_INSERTS:   Number of inserts
- INVALIDATIONS: Number of invalidations
- NUM_HITS:      Number of hits
- HIT_PCT:       Hit ratio (%)

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------
|HOST|PORT |SERVICE_NAME|CACHE_NAME                         |NUM_CACHES|USED_MB   |NUM_ENTRIES|NUM_INSERTS|INVALIDATIONS|NUM_HITS   |HIT_PCT|
---------------------------------------------------------------------------------------------------------------------------------------------
|any |  any|any         |HierarchyCache                     |         2|    338.82|        223|       1046|          823|          0|   0.00|
|any |  any|any         |MdxHierarchyCache                  |         2|      2.81|        103|        103|            0|        125|  53.19|
|any |  any|any         |MDS                                |         2|      1.51|         14|       1549|         1535|       3578|  66.11|
|any |  any|any         |CS_QueryResultCache[Realtime]      |         5|      0.00|          0|          0|            0|          0|   0.00|
|any |  any|any         |CS_QueryResultCache[TimeControlled]|         5|      0.00|          0|          0|            0|          0|   0.00|
|any |  any|any         |CS_StatisticsCache                 |         5|      0.00|          0|          0|            0|          0|   0.00|
|any |  any|any         |HierarchyCacheNoInvalidate         |         2|      0.00|          0|          0|            0|          0|   0.00|
|any |  any|any         |MdxEntityCache                     |         1|      0.00|          0|          0|            0|          0|   0.00|
---------------------------------------------------------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  SERVICE_NAME,
  CACHE_NAME,
  LPAD(NUM_CACHES, 10) NUM_CACHES,
  LPAD(TO_DECIMAL(USED_MB, 10, 2), 10) USED_MB,
  LPAD(NUM_ENTRIES, 11) NUM_ENTRIES,
  LPAD(NUM_INSERTS, 11) NUM_INSERTS,
  LPAD(INVALIDATIONS, 13) INVALIDATIONS,
  LPAD(NUM_HITS, 11) NUM_HITS,
  LPAD(TO_DECIMAL(HIT_PCT, 10, 2), 7) HIT_PCT
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')     != 0 THEN S.HOST          ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                 END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')     != 0 THEN TO_VARCHAR(S.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                 END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE')  != 0 THEN S.SERVICE_NAME  ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME) END SERVICE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CACHE')    != 0 THEN C.CACHE_ID      ELSE MAP(BI.CACHE_NAME, '%', 'any', BI.CACHE_NAME)     END CACHE_NAME,
    COUNT(*) NUM_CACHES,
    SUM(C.USED_SIZE / 1024 / 1024) USED_MB,
    SUM(C.ENTRY_COUNT) NUM_ENTRIES,
    SUM(C.INSERT_COUNT) NUM_INSERTS,
    SUM(C.INVALIDATE_COUNT) INVALIDATIONS,
    SUM(C.HIT_COUNT) NUM_HITS,
    MAP(SUM(C.HIT_COUNT), 0, 0, SUM(C.HIT_COUNT) / (SUM(C.HIT_COUNT) + SUM(C.MISS_COUNT)) * 100) HIT_PCT,
    BI.ORDER_BY
  FROM
  ( SELECT                     /* Modification section */
      '%' HOST,
      '%' PORT,
      '%' SERVICE_NAME,
      '%' CACHE_NAME,
      -1 MIN_USED_SIZE_MB,
      'SIZE' ORDER_BY,        /* SIZE, HOST, CACHE */
      'CACHE' AGGREGATE_BY     /* HOST, PORT, SERVICE, CACHE or comma separated combination, NONE for no aggregation */
    FROM
      DUMMY
  ) BI,
    M_SERVICES S,
    M_CACHES C
  WHERE
    S.HOST LIKE BI.HOST AND
    TO_VARCHAR(S.PORT) LIKE BI.PORT AND
    C.HOST = S.HOST AND
    C.PORT = S.PORT AND
    UPPER(C.CACHE_ID) LIKE UPPER(BI.CACHE_NAME) AND
    ( BI.MIN_USED_SIZE_MB = -1 OR C.USED_SIZE / 1024 / 1024 >= BI.MIN_USED_SIZE_MB )
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')     != 0 THEN S.HOST          ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                 END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')     != 0 THEN TO_VARCHAR(S.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                 END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE')  != 0 THEN S.SERVICE_NAME  ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CACHE')    != 0 THEN C.CACHE_ID      ELSE MAP(BI.CACHE_NAME, '%', 'any', BI.CACHE_NAME)     END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'HOST', HOST, ''),
  MAP(ORDER_BY, 'HOST', PORT, ''),
  MAP(ORDER_BY, 'HOST', SERVICE_NAME, ''),
  MAP(ORDER_BY, 'SIZE', USED_MB, 1) DESC,
  CACHE_NAME
