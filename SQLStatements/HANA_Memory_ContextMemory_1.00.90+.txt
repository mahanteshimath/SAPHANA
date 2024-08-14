SELECT
/* 

[NAME]

- HANA_Memory_ContextMemory_1.00.90+

[DESCRIPTION]

- Context memory overview (i.e. mapping of memory allocations to connections / statements)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- INCLUSIVE_LIMIT available with SAP HANA >= 1.0 SPS 09

[VALID FOR]

- Revisions:              >= 1.00.90

[SQL COMMAND VERSION]

- 2017/10/30:  1.0 (initial version)
- 2018/11/01:  1.1 (STATEMENT_HASH, STATEMENT_STRING included)
- 2019/01/10:  1.2 (Consideration of category starting with WorkloadCtx)
- 2020/11/20:  1.3 (CATEGORY_CLASS included)
- 2020/11/23:  1.4 (WORKLOAD_CLASS included)
- 2020/12/20:  1.5 (dedicated 1.00.90+ version including INCLUSIVE_LIMIT)
- 2022/07/28:  1.6 (ALLOC_MB_PER_S included)

[INVOLVED TABLES]

- M_CONTEXT_MEMORY

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

- CATEGORY

  Context category (e.g. Connection/<conn_id>/Statement/<statement_id>/IMPLICIT for memory booked on particular statement)

  'XSApps%'             --> Only show information for XSApps related categories
  'UnifiedTable%'       --> Restrict output to unified table related categories
  '%'                   --> No category restriction

- CATEGORY_CLASS

  Context category class

  '%'             --> No restriction related to category class

- CONN_ID

  Connection ID

  330655          --> Connection ID 330655
  -1              --> No connection ID restriction

- STATEMENT_ID

  SQL statement identifier (varies for different executions of same statement hash)

  859110927564988   --> Only display samples with statement ID 859110927564988
  -1                --> No restriction related to statement ID

- STATEMENT_HASH      
 
  Hash of SQL statement to be analyzed

  '2e960d7535bf4134e2bd26b9d80bd4fa' --> SQL statement with hash '2e960d7535bf4134e2bd26b9d80bd4fa'
  '%'                                --> No statement hash restriction

- WORKLOAD_CLASS

  Workload class name (in case the context is related to an individual SQL statement)

  'HIGHMEM'      --> Display entries related to workload class HIGHMEM
  '%'            --> No restriction related to workload class

- COMPONENT

  Memory component area

  'System'        --> Only show entries related to System component
  '%'             --> No trace entry restriction

- THREAD_ID

  Thread identifier

  4567            --> Thread 4567
  -1              --> No thread identifier restriction

- CLIENT_HOST

  Client host name

  'saphana01'     --> Specic host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- CLIENT_PORT

  Client port number

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- DB_USER

  Database user

  'SYSTEM'        --> Database user 'SYSTEM'
  '%'             --> No database user restriction

- ONLY_ACTIVE_THREADS

  Restriction to context memory related to active threads

  'X'             --> Only show context memory for active threads / statements
  ' '             --> No restriction related to active threads

- MIN_USED_MEMORY_MB

  Minimum used memory (MB)

  100             --> Only consider contexts with at least 100 MB of used memory
  -1              --> No restriction related to used memory

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'CONN_ID'       --> Aggregation by connection
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'USED'         --> Sorting by used memory
  'ALLOC'        --> Sorting by allocated memory (cumulative)
  'CATEGORY'     --> Sorting by category

[OUTPUT PARAMETERS]

- HOST:             Host name
- PORT:             Port
- CATEGORY:         Category
- CATEGORY_CLASS:   Category class
- NUM_ENTRIES:      Number of contexts
- CONN_ID:          Connection ID
- STATEMENT_ID:     Statement ID
- STATEMENT_HASH:   Statement hash
- USED_GB:          Currently used memory (GB)
- ALLOC_GB:         Overall allocated memory (GB)
- ALLOC_MB_PER_S:   Memory allocation rate (MB / s)
- LIMIT_GB:         Memory limit (GB)
- DB_USER:          Database user
- CLIENT_HOST:      Client host
- CLIENT_PID:       Client process ID
- THREAD_ID:        Thread ID
- COMPONENT:        Component
- STATEMENT_STRING: SQL text

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST    |PORT |CATEGORY                                                                  |CONN_ID   |THREAD_ID |STATEMENT_ID    |STATEMENT_HASH                  |USED_GB   |ALLOC_GB  |DB_USER   |CLIENT_HOST                       |CLIENT_PID|COMPONENT|
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|hana0194|30003|Connection/520543/Statement/2235715549166891/IMPLICIT                     |    520543|    131955|2235715549166891|01f895a2fe32c610a830a533a110c725|      6.56|     12.11|SAPERP    |sap01494                          |     26438|System   |
|hana0194|30003|Connection/505437/Statement/2170836327781179/IMPLICIT                     |    505437|    107267|2170836327781179|eba806fa738a069f3c13f99070ec9533|      1.72|   1273.25|SAPERP    |sap01605                          |     12951|System   |
|hana0194|30003|Connection/511934/Statement/2198741040089503/IMPLICIT                     |    511934|    131617|2198741040089503|0213cee0f26510ce470c9bf8f372c11b|      0.15|      4.93|SAPERP    |sap01603                          |     20686|System   |
|hana0194|30003|Connection/544295/Statement/2337730040908466/IMPLICIT                     |    544295|    132598|2337730040908466|01b251855f6a23d400432ab0737e8f2a|      0.08|     63.36|SAPERP    |sap01601                          |      5544|System   |
|hana0194|30003|Connection/516909/Statement/2220108466152442/IMPLICIT                     |    516909|    107436|2220108466152442|490981c05833f3fe9dbe7e0d4d4419d0|      0.03|      8.97|SAPERP    |sap01425                          |     32344|System   |
|hana0185|30003|Connection/454548/Statement/1952272277058041/IMPLICIT                     |    454548|     82184|1952272277058041|5af0a698f87a4fd3e2cc474710f4ae0f|      0.01|      3.04|SAPERP    |sap01484                          |     15486|System   |
|hana0194|30003|Connection/544295/Statement/2337730040908466/Pool/RowEngine/QueryExecution|    544295|    132598|2337730040908466|01b251855f6a23d400432ab0737e8f2a|      0.00|      0.01|SAPERP    |sap01601                          |      5544|System   |
|hana0185|30003|Connection/462073/Statement/1984588701224903/IMPLICIT                     |    462073|     82792|1984588701224903|b4b3ef226920e0f740e461fa6a104f27|      0.00|     18.20|SAPERP    |sap01494                          |      3366|System   |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  CATEGORY,
  CATEGORY_CLASS,
  LPAD(NUM_ENTRIES, 11) NUM_ENTRIES,
  LPAD(CONN_ID, 10) CONN_ID,
  IFNULL(LPAD(THREAD_ID, 10), '') THREAD_ID,
  LPAD(STATEMENT_ID, 16) STATEMENT_ID,
  IFNULL(STATEMENT_HASH, '') STATEMENT_HASH,
  IFNULL(WORKLOAD_CLASS, '') WORKLOAD_CLASS,
  LPAD(TO_DECIMAL(USED_MB / 1024, 10, 2), 10) USED_GB,
  LPAD(TO_DECIMAL(ALLOC_MB / 1024, 10, 2), 10) ALLOC_GB,
  LPAD(TO_DECIMAL(ALLOC_MB_PER_S, 10, 2), 14) ALLOC_MB_PER_S,
  LPAD(LIMIT_GB, 8) LIMIT_GB,
  IFNULL(DB_USER, '') DB_USER,
  IFNULL(CLIENT_HOST, '') CLIENT_HOST,
  IFNULL(LPAD(CLIENT_PID, 10), '') CLIENT_PID,
  COMPONENT,
  IFNULL(STATEMENT_STRING, '') STATEMENT_STRING
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERV_HOST')      != 0 THEN CM.HOST                         ELSE MAP(BI.HOST,           '%', 'any', BI.HOST)                     END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERV_PORT')      != 0 THEN TO_VARCHAR(CM.PORT)             ELSE MAP(BI.PORT,           '%', 'any', BI.PORT)                     END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CATEGORY')       != 0 THEN CM.CATEGORY                     ELSE MAP(BI.CATEGORY,       '%', 'any', BI.CATEGORY)                 END CATEGORY,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CAT_CLASS')      != 0 THEN CM.CATEGORY_CLASS               ELSE MAP(BI.CATEGORY_CLASS, '%', 'any', BI.CATEGORY_CLASS)           END CATEGORY_CLASS,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'WORKLOAD_CLASS') != 0 THEN PS.WORKLOAD_CLASS_NAME          ELSE MAP(BI.WORKLOAD_CLASS, '%', 'any', BI.WORKLOAD_CLASS)           END WORKLOAD_CLASS,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONN_ID')        != 0 THEN CM.CONN_ID                      ELSE MAP(BI.CONN_ID,         -1, 'any', TO_VARCHAR(BI.CONN_ID))      END CONN_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATEMENT_ID')   != 0 THEN CM.STATEMENT_ID                 ELSE MAP(BI.STATEMENT_ID,    -1, 'any', TO_VARCHAR(BI.STATEMENT_ID)) END STATEMENT_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HASH')           != 0 THEN SP.STATEMENT_HASH               ELSE MAP(BI.STATEMENT_HASH, '%', 'any', BI.STATEMENT_HASH)           END STATEMENT_HASH,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COMPONENT')      != 0 THEN CM.COMPONENT                    ELSE MAP(BI.COMPONENT,      '%', 'any', BI.COMPONENT)                END COMPONENT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CLNT_HOST')      != 0 THEN C.CLIENT_HOST                   ELSE MAP(BI.CLIENT_HOST,    '%', 'any', BI.CLIENT_HOST)              END CLIENT_HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CLNT_PID')       != 0 THEN TO_VARCHAR(C.CLIENT_PID)        ELSE MAP(BI.CLIENT_PID,      -1, 'any', TO_VARCHAR(BI.CLIENT_PID))   END CLIENT_PID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DB_USER')        != 0 THEN C.USER_NAME                     ELSE MAP(BI.DB_USER,        '%', 'any', BI.DB_USER)                  END DB_USER,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'THREAD_ID')      != 0 THEN TO_VARCHAR(T.THREAD_ID)         ELSE MAP(BI.THREAD_ID,       -1, 'any', TO_VARCHAR(BI.THREAD_ID))    END THREAD_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HASH')           != 0 THEN TO_VARCHAR(PS.STATEMENT_STRING) ELSE 'any'                                                           END STATEMENT_STRING,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'LIMIT')          != 0 THEN TO_VARCHAR(LIMIT_GB)            ELSE 'any'                                                           END LIMIT_GB,
    COUNT(*) NUM_ENTRIES,
    SUM(CM.USED_MB) USED_MB,
    SUM(CM.ALLOC_MB) ALLOC_MB,
    SUM(CM.ALLOC_MB) / GREATEST(1, MAX(SECONDS_BETWEEN(C.START_TIME, CURRENT_TIMESTAMP))) ALLOC_MB_PER_S,
    BI.ORDER_BY
  FROM
  ( SELECT                    /* Modification section */
      '%' HOST,
      '%' PORT,
      '%' CATEGORY,
      '%' CATEGORY_CLASS,
      -1 CONN_ID,
      -1 THREAD_ID,
      -1 STATEMENT_ID,
      '%' STATEMENT_HASH,
      '%' WORKLOAD_CLASS,
      '%' COMPONENT,
      '%' CLIENT_HOST,
      -1 CLIENT_PID,
      '_SYS_STATISTICS' DB_USER,
      -1 MIN_USED_MEMORY_MB,
      ' ' ONLY_ACTIVE_THREADS,
      'NONE' AGGREGATE_BY,                        /* SERV_HOST, SERV_PORT, CATEGORY, CAT_CLASS, WORKLOAD_CLASS, CONN_ID, STATEMENT_ID, HASH, COMPONENT, CLNT_HOST, CLNT_PID, DB_USER, LIMIT or comma separated combinations, NONE for no aggregation */
      'USED' ORDER_BY                             /* CATEGORY, USED, ALLOC, COUNT */
    FROM
      DUMMY
  ) BI INNER JOIN
  ( SELECT
      HOST,
      PORT,
      CATEGORY,
      CASE
        WHEN CATEGORY LIKE '%/Pool/CalculationEngine%'                   THEN 'CALCULATION_ENGINE'
        WHEN CATEGORY LIKE '%/Pool/JoinEvaluator'                        THEN 'JOIN_EVALUATOR'
        WHEN CATEGORY LIKE '%/Pool/RowEngine/QueryExecution/SearchAlloc' THEN 'ROWENGINE_SEARCHALLOC'
        WHEN CATEGORY LIKE '%/Pool/RowEngine/Session'                    THEN 'ROWENGINE_SESSION'
        WHEN CATEGORY =    'AggregatedStatement'                         THEN 'AGGREGATED_STATEMENT'   /* for total_statement_memory_limit */
        WHEN CATEGORY LIKE 'Connection/%/Statement/%'                    THEN 'CONNECTION_STATEMENT'
        WHEN CATEGORY LIKE 'Connection/______'                           THEN 'CONNECTION'
        WHEN CATEGORY LIKE 'Connection/_______'                          THEN 'CONNECTION'
        WHEN CATEGORY =    'Connection'                                  THEN 'CONNECTION'
        WHEN CATEGORY LIKE 'HexPlan%'                                    THEN 'HEX_PLAN'
        WHEN CATEGORY LIKE 'LVCContainerDir%'                            THEN 'LIVECACHE_CONTAINER'
        WHEN CATEGORY LIKE 'UnifiedTableComposite%'                      THEN 'UNIFIED_TABLE'
        WHEN CATEGORY LIKE 'WorkloadCtx/%/Statement/%/IMPLICIT'          THEN 'WORKLOAD_CLASS_STATEMENT'
        WHEN CATEGORY LIKE 'WorkloadCtx%'                                THEN 'WORKLOAD_CLASS'
        WHEN CATEGORY LIKE 'XSApps%'                                     THEN 'XS_APPS'
        WHEN CATEGORY LIKE 'XSSessions%'                                 THEN 'XS_SESSIONS'
        WHEN CATEGORY =    '<unnamed allocator>'                         THEN 'UNNAMED_ALLOCATOR'
        WHEN CATEGORY =    '/'                                           THEN 'ROOT'
        ELSE 'OTHER'
      END CATEGORY_CLASS,
      CASE 
        WHEN CATEGORY LIKE 'Connection/%'  THEN SUBSTR(CATEGORY, 12, MAP(LOCATE(CATEGORY, '/', 1, 2), 0, 999, LOCATE(CATEGORY, '/', 1, 2) - 12))
        ELSE '' 
      END CONN_ID,
      CASE 
        WHEN CATEGORY LIKE 'WorkloadCtx/%'  THEN SUBSTR(CATEGORY, 13, MAP(LOCATE(CATEGORY, '/', 1, 2), 0, 999, LOCATE(CATEGORY, '/', 1, 2) - 13))
        ELSE ''
      END WORKLOAD_CONTEXT,
      CASE 
        WHEN CATEGORY LIKE 'Connection/%/Statement%'  THEN SUBSTR(CATEGORY, LOCATE(CATEGORY, '/Statement/') + 11, MAP(LOCATE(CATEGORY, '/', 1, 4), 0, 999, LOCATE(CATEGORY, '/', 1, 4) - LOCATE(CATEGORY, '/Statement/') - 11 )) 
        WHEN CATEGORY LIKE 'WorkloadCtx/%/Statement%' THEN SUBSTR(CATEGORY, LOCATE(CATEGORY, '/Statement/') + 11, MAP(LOCATE(CATEGORY, '/', 1, 4), 0, 999, LOCATE(CATEGORY, '/', 1, 4) - LOCATE(CATEGORY, '/Statement/') - 11 )) 
        ELSE ''
      END STATEMENT_ID,
      EXCLUSIVE_SIZE_IN_USE / 1024 / 1024 USED_MB,
      EXCLUSIVE_ALLOCATED_SIZE / 1024 / 1024 ALLOC_MB,
      TO_DECIMAL(INCLUSIVE_LIMIT / 1024 / 1024 / 1024, 10, 2) LIMIT_GB,
      COMPONENT
    FROM
      M_CONTEXT_MEMORY
  ) CM ON
      CM.HOST LIKE BI.HOST AND
      TO_VARCHAR(CM.PORT) LIKE BI.PORT AND
      CM.CATEGORY LIKE BI.CATEGORY AND
      ( BI.CONN_ID = -1 OR CM.CONN_ID = TO_VARCHAR(BI.CONN_ID) ) AND
      ( BI.STATEMENT_ID = -1 OR CM.STATEMENT_ID = TO_VARCHAR(BI.STATEMENT_ID) ) AND
      CM.COMPONENT LIKE BI.COMPONENT AND
      ( BI.MIN_USED_MEMORY_MB = -1 OR CM.USED_MB >= BI.MIN_USED_MEMORY_MB ) LEFT OUTER JOIN
    M_CONNECTIONS C ON
      C.HOST = CM.HOST AND
      C.PORT = CM.PORT AND
      TO_VARCHAR(C.CONNECTION_ID) = CM.CONN_ID AND
      IFNULL(C.CLIENT_HOST, '') LIKE BI.CLIENT_HOST AND
      ( BI.CLIENT_PID = -1 OR C.CLIENT_PID = BI.CLIENT_PID ) AND
      IFNULL(C.USER_NAME, '') LIKE BI.DB_USER LEFT OUTER JOIN
    M_PREPARED_STATEMENTS PS ON
      PS.HOST = CM.HOST AND
      PS.PORT = CM.PORT AND
      PS.WORKLOAD_CLASS_NAME LIKE BI.WORKLOAD_CLASS AND
      TO_VARCHAR(PS.CONNECTION_ID) = CM.CONN_ID AND
      PS.STATEMENT_ID = CM.STATEMENT_ID LEFT OUTER JOIN
    M_SQL_PLAN_CACHE SP ON
      SP.HOST = PS.HOST AND
      SP.PORT = PS.PORT AND
      SP.PLAN_ID = PS.PLAN_ID LEFT OUTER JOIN
    M_SERVICE_THREADS T ON
      TO_VARCHAR(T.CONNECTION_ID) = CM.CONN_ID AND
      T.STATEMENT_ID = CM.STATEMENT_ID AND
      T.THREAD_TYPE = 'SqlExecutor'
  WHERE
    ( BI.ONLY_ACTIVE_THREADS = ' ' OR T.THREAD_ID IS NOT NULL ) AND
    IFNULL(T.STATEMENT_HASH, '') LIKE BI.STATEMENT_HASH AND
    IFNULL(C.USER_NAME, '') LIKE BI.DB_USER AND
    CM.CATEGORY_CLASS LIKE BI.CATEGORY_CLASS
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERV_HOST')      != 0 THEN CM.HOST                         ELSE MAP(BI.HOST,           '%', 'any', BI.HOST)                     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERV_PORT')      != 0 THEN TO_VARCHAR(CM.PORT)             ELSE MAP(BI.PORT,           '%', 'any', BI.PORT)                     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CATEGORY')       != 0 THEN CM.CATEGORY                     ELSE MAP(BI.CATEGORY,       '%', 'any', BI.CATEGORY)                 END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CAT_CLASS')      != 0 THEN CM.CATEGORY_CLASS               ELSE MAP(BI.CATEGORY_CLASS, '%', 'any', BI.CATEGORY_CLASS)           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'WORKLOAD_CLASS') != 0 THEN PS.WORKLOAD_CLASS_NAME          ELSE MAP(BI.WORKLOAD_CLASS, '%', 'any', BI.WORKLOAD_CLASS)           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONN_ID')        != 0 THEN CM.CONN_ID                      ELSE MAP(BI.CONN_ID,         -1, 'any', TO_VARCHAR(BI.CONN_ID))      END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATEMENT_ID')   != 0 THEN CM.STATEMENT_ID                 ELSE MAP(BI.STATEMENT_ID,    -1, 'any', TO_VARCHAR(BI.STATEMENT_ID)) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HASH')           != 0 THEN SP.STATEMENT_HASH               ELSE MAP(BI.STATEMENT_HASH, '%', 'any', BI.STATEMENT_HASH)           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COMPONENT')      != 0 THEN CM.COMPONENT                    ELSE MAP(BI.COMPONENT,      '%', 'any', BI.COMPONENT)                END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CLNT_HOST')      != 0 THEN C.CLIENT_HOST                   ELSE MAP(BI.CLIENT_HOST,    '%', 'any', BI.CLIENT_HOST)              END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CLNT_PID')       != 0 THEN TO_VARCHAR(C.CLIENT_PID)        ELSE MAP(BI.CLIENT_PID,      -1, 'any', TO_VARCHAR(BI.CLIENT_PID))   END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DB_USER')        != 0 THEN C.USER_NAME                     ELSE MAP(BI.DB_USER,        '%', 'any', BI.DB_USER)                  END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'THREAD_ID')      != 0 THEN TO_VARCHAR(T.THREAD_ID)         ELSE MAP(BI.THREAD_ID,       -1, 'any', TO_VARCHAR(BI.THREAD_ID))    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HASH')           != 0 THEN TO_VARCHAR(PS.STATEMENT_STRING) ELSE 'any'                                                           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'LIMIT')          != 0 THEN TO_VARCHAR(LIMIT_GB)            ELSE 'any'                                                           END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'USED', USED_MB, 'ALLOC', ALLOC_MB, 'COUNT', NUM_ENTRIES) DESC,
  HOST,
  PORT,
  CATEGORY