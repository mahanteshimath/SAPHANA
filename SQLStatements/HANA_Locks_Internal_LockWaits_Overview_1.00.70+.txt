SELECT
/* 

[NAME]

- HANA_Locks_Internal_LockWaits_Overview_1.00.70+

[DESCRIPTION]

- Overview of wait times for internal locks (read / write locks, mutexes, semaphores and conditional variables since startup)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Column COMPONENT available with SAP HANA >= 1.00.70
- RESET can be performed via:

  ALTER SYSTEM RESET MONITORING VIEW M_READWRITELOCKS_RESET
  ALTER SYSTEM RESET MONITORING VIEW M_CONDITIONAL_VARIABLES_RESET
  ALTER SYSTEM RESET MONITORING VIEW M_SEMAPHORES_RESET
  ALTER SYSTEM RESET MONITORING VIEW M_MUTEXES_RESET

- Can be used for monitoring remote system replication sites, see SAP Note 1999880 
  ("Is it possible to monitor remote system replication sites on the primary system") for details.

[VALID FOR]

- Revisions:              >= 1.00.70

[SQL COMMAND VERSION]

- 2014/05/02:  1.0 (initial version)
- 2015/05/02:  1.1 (*_RESET views included)
- 2017/02/25:  1.2 (ORDER_BY and COUNT included)
- 2021/01/12:  1.3 (LOCK_REQUESTS added)
- 2023/05/10:  1.4 (count calculation including REQUEST_COUNT and DESTROY_COUNT)

[INVOLVED TABLES]

- M_READWRITELOCKS
- M_READWRITELOCKS_RESET
- M_CONDITIONAL_VARIABLES
- M_CONDITIONAL_VARIABLES_RESET
- M_SEMAPHORES
- M_SEMAPHORES_RESET
- M_MUTEXES
- M_MUTEXES_RESET

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

- STATISTICS_NAME

  Statistics name

  'ConsistentChangeLock' --> Specific statistics name ConsistentChangeLock
  '%Savepoint%'          --> All statistics names containing 'Savepoint'
  '%'                    --> No statistics name restriction

- MAX_STATISTICS_NAME_LENGTH

  Maximum output length of lock statistic name

  50               --> Names are truncated to 50 characters
  -1               --> No limitation of output length of lock statistic name

- LOCK_TYPE

  Lock type

  'READWRITELOCK'    --> Read write locks
  'SEMAPHORE, MUTEX' --> Semaphores and mutexes
  '%'                --> No lock type restriction

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_* tables)
  'RESET'         --> Data from reset memory information (M_*_RESET tables)

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'STATISTIC'        --> Aggregation by statistics name
  'HOST, PORT'       --> Aggregation by host and port
  'NONE'             --> No aggregation, pure filtering 

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'SIZE'          --> Sorting by size 
  'COUNT'         --> Sorting by number of occurrences

- RESULT_ROWS

  Number of records to be returned by the query

  100             --> Return a maximum number of 100 records
  -1              --> Return all records

[OUTPUT PARAMETERS]

- HOST:             Host name
- PORT:             Port
- COMPONENT:        Lock component
- LOCK_TYPE:        Type of lock
- STATISTICS_NAME:  Name of lock statistic
- COUNT:            Number of locks
- LOCK_REQUESTS:    Number of lock requests
- ACT_SESS:         Average number of waiting sessions
- WAIT_TIME_S:      Total wait time (in s)
- WAIT_PCT:         Fraction of overall total time (in %)   

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST       |PORT |COMPONENT|LOCK_TYPE    |STATISTICS_NAME                                                                         |COUNT     |LOCK_REQUESTS|ACT_SESS|WAIT_TIME_S |WAIT_PCT |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|saphananode|34003|liveCache|READWRITELOCK|LVCContainer_1090925615811                                                              |        16|  51732130374|    0.00|      825.42|     0.00|
|saphananode|34003|Session  |READWRITELOCK|StatementContextContainer_hLock                                                         |         1|  26621655978|    0.00|      468.96|     0.00|
|saphananode|34003|Other    |MUTEX        |Mutex[CommEvent.hpp:301]@0x00007fba644c0dc5: ptime::TcpListenerCallback::registerChannel|         1|  23928210527|    0.00|        0.00|     0.00|
|saphananode|34003|liveCache|MUTEX        |LVCContainer_1090925615811                                                              |        16|  13788719443|    0.02|    60180.20|     0.00|
|saphananode|34003|Other    |MUTEX        |Mutex[Channel.hpp:236]@0x00007fba415ca602: SessionLayer::TcpChannel::TcpChannel         |         1|  12785367061|    0.00|        0.08|     0.00|
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  COMPONENT,
  LOCK_TYPE,
  MAP(MAX_STATISTICS_NAME_LENGTH, -1, STATISTICS_NAME, SUBSTR(STATISTICS_NAME, 1, MAX_STATISTICS_NAME_LENGTH)) STATISTICS_NAME,
  LPAD(LOCKS, 10) COUNT,
  LPAD(LOCK_REQUESTS, 13) LOCK_REQUESTS,
  LPAD(TO_DECIMAL(MAP(UPTIME_S, 0, 0, WAIT_TIME_S / UPTIME_S), 10, 2), 8) ACT_SESS,
  LPAD(TO_DECIMAL(WAIT_TIME_S, 10, 2), 12) WAIT_TIME_S,
  LPAD(TO_DECIMAL(MAP(OVERALL_WAIT_TIME_S, 0, 0, WAIT_TIME_S / OVERALL_WAIT_TIME_S * 100), 10, 2), 9) WAIT_PCT
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'HOST')      != 0 THEN L.HOST             ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                       END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'PORT')      != 0 THEN TO_VARCHAR(L.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                       END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'STATISTIC') != 0 THEN L.STATISTICS_NAME  ELSE MAP(BI.STATISTICS_NAME, '%', 'any', BI.STATISTICS_NAME) END STATISTICS_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'TYPE')      != 0 THEN L.LOCK_TYPE        ELSE MAP(BI.LOCK_TYPE, '%', 'any', BI.LOCK_TYPE)             END LOCK_TYPE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'COMPONENT') != 0 THEN L.COMPONENT        ELSE 'any'                                                   END COMPONENT,
    SUM(L.WAIT_TIME_S) WAIT_TIME_S,
    SUM(SUM(L.WAIT_TIME_S)) OVER () OVERALL_WAIT_TIME_S,
    SUM(L.LOCK_REQUESTS) LOCK_REQUESTS,
    SUM(L.CNT) LOCKS,
    BI.RESULT_ROWS,
    BI.MAX_STATISTICS_NAME_LENGTH,
    T.UPTIME_S,
    ROW_NUMBER() OVER (ORDER BY MAP(BI.ORDER_BY, 'COUNT', SUM(L.CNT), 'TIME', SUM(L.WAIT_TIME_S), 'REQUESTS', SUM(L.LOCK_REQUESTS)) DESC) ROW_NUM
  FROM
  ( SELECT                        /* Modification section */
      '%' HOST,
      '%' PORT,
      '%' STATISTICS_NAME,
      -1 MAX_STATISTICS_NAME_LENGTH,
      'COND_VARIABLE' LOCK_TYPE,              /* READWRITELOCK, COND_VARIABLE, MUTEX, SEMAPHORE, comma separated list or % for all */
      'RESET' DATA_SOURCE,        /* CURRENT, RESET */
      'NONE' AGGREGATE_BY,        /* HOST, PORT, COMPONENT, TYPE, STATISTIC or comma separated combinations, NONE for no aggregation */
      'COUNT' ORDER_BY,           /* COUNT, TIME, REQUESTS */
      100 RESULT_ROWS
    FROM
      DUMMY
  ) BI,
  ( SELECT
      MAX(SECONDS_BETWEEN(TO_TIMESTAMP(VALUE), CURRENT_TIMESTAMP)) UPTIME_S
    FROM
      M_HOST_INFORMATION
    WHERE
      KEY = 'start_time'
  ) T,
  ( SELECT
      'READWRITELOCK' LOCK_TYPE,
      'CURRENT' DATA_SOURCE,
      HOST,
      PORT,
      COMPONENT,
      STATISTICS_NAME,
      EXCLUSIVE_LOCK_COUNT + SHARED_LOCK_COUNT + INTENT_LOCK_COUNT LOCK_REQUESTS,
      ( SUM_EXCLUSIVE_WAIT_TIME + SUM_SHARED_WAIT_TIME ) / 1000000 WAIT_TIME_S,
      GREATEST(1, CREATE_COUNT - DESTROY_COUNT) CNT
    FROM
      M_READWRITELOCKS
    UNION ALL
    SELECT
      'READWRITELOCK' LOCK_TYPE,
      'RESET' DATA_SOURCE,
      HOST,
      PORT,
      COMPONENT,
      STATISTICS_NAME,
      EXCLUSIVE_LOCK_COUNT + SHARED_LOCK_COUNT + INTENT_LOCK_COUNT LOCK_REQUESTS,
      ( SUM_EXCLUSIVE_WAIT_TIME + SUM_SHARED_WAIT_TIME ) / 1000000 WAIT_TIME_S,
      GREATEST(1, CREATE_COUNT - DESTROY_COUNT) CNT
    FROM
      M_READWRITELOCKS_RESET
    UNION ALL
    SELECT
      'SEMAPHORE' LOCK_TYPE,
      'CURRENT' DATA_SOURCE,
      HOST,
      PORT,
      COMPONENT,
      STATISTICS_NAME,
      WAIT_COUNT LOCK_REQUESTS,
      SUM_BLOCKING_TIME / 1000000 WAIT_TIME_S,
      GREATEST(1, CREATE_COUNT - DESTROY_COUNT) CNT
    FROM
      M_SEMAPHORES
    UNION ALL
    SELECT
      'SEMAPHORE' LOCK_TYPE,
      'RESET' DATA_SOURCE,
      HOST,
      PORT,
      COMPONENT,
      STATISTICS_NAME,
      WAIT_COUNT LOCK_REQUESTS,
      SUM_BLOCKING_TIME / 1000000 WAIT_TIME_S,
      GREATEST(1, CREATE_COUNT - DESTROY_COUNT) CNT
    FROM
      M_SEMAPHORES_RESET
    UNION ALL
    SELECT
      'MUTEX' LOCK_TYPE,
      'CURRENT' DATA_SOURCE,
      HOST,
      PORT,
      COMPONENT,
      STATISTICS_NAME,
      LOCK_COUNT LOCK_REQUESTS,
      SUM_WAIT_TIME / 1000000 WAIT_TIME_S,
      GREATEST(1, CREATE_COUNT - DESTROY_COUNT) CNT
    FROM
      M_MUTEXES
    UNION ALL
    SELECT
      'MUTEX' LOCK_TYPE,
      'RESET' DATA_SOURCE,
      HOST,
      PORT,
      COMPONENT,
      STATISTICS_NAME,
      LOCK_COUNT LOCK_REQUESTS,
      SUM_WAIT_TIME / 1000000 WAIT_TIME_S,
      GREATEST(1, CREATE_COUNT - DESTROY_COUNT) CNT
    FROM
      M_MUTEXES_RESET
    UNION ALL
    SELECT
      'COND_VARIABLE' LOCK_TYPE,
      'CURRENT' DATA_SOURCE,
      HOST,
      PORT,
      COMPONENT,
      STATISTICS_NAME,
      WAIT_COUNT LOCK_REQUESTS,
      SUM_BLOCKING_TIME / 1000000 WAIT_TIME_S,
      GREATEST(1, CREATE_COUNT - DESTROY_COUNT) CNT
    FROM
      M_CONDITIONAL_VARIABLES
    UNION ALL
    SELECT
      'COND_VARIABLE' LOCK_TYPE,
      'RESET' DATA_SOURCE,
      HOST,
      PORT,
      COMPONENT,
      STATISTICS_NAME,
      WAIT_COUNT LOCK_REQUESTS,
      SUM_BLOCKING_TIME / 1000000 WAIT_TIME_S,
      GREATEST(1, CREATE_COUNT - DESTROY_COUNT) CNT
    FROM
      M_CONDITIONAL_VARIABLES_RESET
  ) L
  WHERE
    L.HOST LIKE BI.HOST AND
    TO_VARCHAR(L.PORT) LIKE BI.PORT AND
    L.STATISTICS_NAME LIKE BI.STATISTICS_NAME AND
    L.DATA_SOURCE = BI.DATA_SOURCE AND
    ( BI.LOCK_TYPE = '%' OR LOCATE(BI.LOCK_TYPE, L.LOCK_TYPE) != 0 ) 
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'HOST')      != 0 THEN L.HOST             ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                       END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'PORT')      != 0 THEN TO_VARCHAR(L.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                       END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'STATISTIC') != 0 THEN L.STATISTICS_NAME  ELSE MAP(BI.STATISTICS_NAME, '%', 'any', BI.STATISTICS_NAME) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'TYPE')      != 0 THEN L.LOCK_TYPE        ELSE MAP(BI.LOCK_TYPE, '%', 'any', BI.LOCK_TYPE)             END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'COMPONENT') != 0 THEN L.COMPONENT        ELSE 'any'                                                   END,
    BI.RESULT_ROWS,
    BI.MAX_STATISTICS_NAME_LENGTH,
    BI.ORDER_BY,
    T.UPTIME_S
)
WHERE
  ( RESULT_ROWS = -1 OR ROW_NUM <= RESULT_ROWS )
ORDER BY
  ROW_NUM
