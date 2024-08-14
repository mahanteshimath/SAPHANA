WITH 

/*

[NAME]

HANA_Threads_ThreadSamples_LockHierarchy_1.00.70+

[DESCRIPTION]

- Hierarchy of internal lock waits in thread samples

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- HOST_SERVICE_THREAD_SAMPLES available with SAP HANA 1.00.70 and higher

[VALID FOR]

- Revisions:              >= 1.00.70

[SQL COMMAND VERSION]

- 2017/07/21:  1.0 (initial version)
- 2017/10/27:  1.1 (TIMEZONE included)
- 2018/12/04:  1.2 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2022/10/03:  1.3 (redesign using SQL hierarchies)
- 2022/10/04:  1.4 (DURATION_S output and STATEMENT_HASH filter included)

[INVOLVED TABLES]

- M_SERVICE_THREAD_SAMPLES
- HOST_SERVICE_THREAD_SAMPLES

[INPUT PARAMETERS]

- BEGIN_TIME

  Begin time

  '2018/12/05 14:05:00' --> Set begin time to 5th of December 2018, 14:05
  'C'                   --> Set begin time to current time
  'C-S900'              --> Set begin time to current time minus 900 seconds
  'C-M15'               --> Set begin time to current time minus 15 minutes
  'C-H5'                --> Set begin time to current time minus 5 hours
  'C-D1'                --> Set begin time to current time minus 1 day
  'C-W4'                --> Set begin time to current time minus 4 weeks
  'E-S900'              --> Set begin time to end time minus 900 seconds
  'E-M15'               --> Set begin time to end time minus 15 minutes
  'E-H5'                --> Set begin time to end time minus 5 hours
  'E-D1'                --> Set begin time to end time minus 1 day
  'E-W4'                --> Set begin time to end time minus 4 weeks
  'MIN'                 --> Set begin time to minimum (1000/01/01 00:00:00)

- END_TIME

  End time

  '2018/12/08 14:05:00' --> Set end time to 8th of December 2018, 14:05
  'C'                   --> Set end time to current time
  'C-S900'              --> Set end time to current time minus 900 seconds
  'C-M15'               --> Set end time to current time minus 15 minutes
  'C-H5'                --> Set end time to current time minus 5 hours
  'C-D1'                --> Set end time to current time minus 1 day
  'C-W4'                --> Set end time to current time minus 4 weeks
  'B+S900'              --> Set end time to begin time plus 900 seconds
  'B+M15'               --> Set end time to begin time plus 15 minutes
  'B+H5'                --> Set end time to begin time plus 5 hours
  'B+D1'                --> Set end time to begin time plus 1 day
  'B+W4'                --> Set end time to begin time plus 4 weeks
  'MAX'                 --> Set end time to maximum (9999/12/31 23:59:59)

- TIMEZONE

  Used timezone (both for input and output parameters)

  'SERVER'       --> Display times in SAP HANA server time
  'UTC'          --> Display times in UTC time

- STATEMENT_HASH

  Possibility to restrict result to hierarchies containing the provided statement hash

  'e4f0792e9ea7930f64b5cdb75c8c498a' --> Display hierarchies with at least one occurrence of statement hash e4f0792e9ea7930f64b5cdb75c8c498a
  '%'                                --> No limitation related to statement hash

- LOCK_NAME

  Possibility to restrict result to hierarchies containing the provided lock name

  'MemoryReclaim' --> Only show hierarchies including MemoryReclaim lock waits
  '%'             --> No restriction related to lock name

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)
  '%'             --> All data sources

[OUTPUT PARAMETERS]

- SAMPLE_TIME:        Sample time
- WAIT:               Total number of waiting threads
- DURATION_S:         Thread activity duration (s)
- THREAD_ID:          Thread ID
- CONN_ID:            Connection ID
- STATEMENT_HASH:     Statement hash
- THREAD_TYPE:        Thread type
- THREAD_STATE:       Thread state
- LOCK_NAME:          Lock name
- THREAD_METHOD:      Threda method
- THREAD_DETAIL:      Thread details
- APP_USER:           Application user
- APP_NAME:           Application name
- APP_SOURCE:         Application source
- CLIENT_IP:          Client IP address
- CLIENT_PID:         Client process ID
- HOST:               Host
- PORT:               Port
- BLOCKING_THREAD_ID: Thread ID of blocking thread (typically corresponds to the thread found one line above)

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------------------------------------------------------------------
|SAMPLE_TIME        |THREAD_ID |STATEMENT_HASH                  |THREAD_TYPE         |THREAD_STATE       |LOCK_NAME                       |APP_USER       |
-----------------------------------------------------------------------------------------------------------------------------------------------------------
|2017/07/21 11:53:29|75206     |#                               |JobWorker           |Running            |#                               |#              |
|                   |  120697  |7feaacf23f1a244251dbfd023468d6b0|SqlExecutor         |Mutex Wait         |unnamed Mutex                   |AHVILLAMKA1    |
|                   |    26530 |4abc5788398210dc5b26d4374c2193b1|SqlExecutor         |ExclusiveLock Enter|BTree GuardContainer            |BHALBALI       |
|2017/07/21 05:35:54|229914    |9fff7e6ea086f31625cb9c336d4bcce8|JobWorker           |Running            |#                               |JOBRUN         |
|                   |  84142   |9fff7e6ea086f31625cb9c336d4bcce8|JobWorker           |Mutex Wait         |ZipResultInput_SectionLock      |JOBRUN         |
|                   |    81721 |9fff7e6ea086f31625cb9c336d4bcce8|JobWorker           |Mutex Wait         |ZipResultInput_SectionLock      |JOBRUN         |
|2017/07/21 04:54:48|213940    |#                               |PeriodicSavepoint   |Semaphore Wait     |WaitAndSwitchCounterResource    |#              |
|                   |  214128  |#                               |SegmentPreallocator |SharedLock Enter   |SavepointLock                   |#              |
|2017/07/21 04:50:58|233415    |d4690cdf4d981eaafda9214e1a5d70fa|JobWorker           |Running            |#                               |CHSORIAJE      |
|                   |  231827  |#                               |JobWorker           |Mutex Wait         |jx-pq02-numa                    |#              |
-----------------------------------------------------------------------------------------------------------------------------------------------------------

*/

BASIS_INFO AS
( SELECT
    CASE
      WHEN BEGIN_TIME =    'C'                             THEN CURRENT_TIMESTAMP
      WHEN BEGIN_TIME LIKE 'C-S%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-S'))
      WHEN BEGIN_TIME LIKE 'C-M%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-M') * 60)
      WHEN BEGIN_TIME LIKE 'C-H%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-H') * 3600)
      WHEN BEGIN_TIME LIKE 'C-D%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-D') * 86400)
      WHEN BEGIN_TIME LIKE 'C-W%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-W') * 86400 * 7)
      WHEN BEGIN_TIME LIKE 'E-S%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-S'))
      WHEN BEGIN_TIME LIKE 'E-M%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-M') * 60)
      WHEN BEGIN_TIME LIKE 'E-H%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-H') * 3600)
      WHEN BEGIN_TIME LIKE 'E-D%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-D') * 86400)
      WHEN BEGIN_TIME LIKE 'E-W%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-W') * 86400 * 7)
      WHEN BEGIN_TIME =    'MIN'                           THEN TO_TIMESTAMP('1000/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS')
      WHEN SUBSTR(BEGIN_TIME, 1, 1) NOT IN ('C', 'E', 'M') THEN TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS')
    END BEGIN_TIME,
    CASE
      WHEN END_TIME =    'C'                             THEN CURRENT_TIMESTAMP
      WHEN END_TIME LIKE 'C-S%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-S'))
      WHEN END_TIME LIKE 'C-M%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-M') * 60)
      WHEN END_TIME LIKE 'C-H%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-H') * 3600)
      WHEN END_TIME LIKE 'C-D%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-D') * 86400)
      WHEN END_TIME LIKE 'C-W%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-W') * 86400 * 7)
      WHEN END_TIME LIKE 'B+S%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+S'))
      WHEN END_TIME LIKE 'B+M%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+M') * 60)
      WHEN END_TIME LIKE 'B+H%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+H') * 3600)
      WHEN END_TIME LIKE 'B+D%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+D') * 86400)
      WHEN END_TIME LIKE 'B+W%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+W') * 86400 * 7)
      WHEN END_TIME =    'MAX'                           THEN TO_TIMESTAMP('9999/12/31 00:00:00', 'YYYY/MM/DD HH24:MI:SS')
      WHEN SUBSTR(END_TIME, 1, 1) NOT IN ('C', 'B', 'M') THEN TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS')
    END END_TIME,
    TIMEZONE,
    STATEMENT_HASH,
    LOCK_NAME,
    DATA_SOURCE
  FROM
  ( SELECT                                                      /* Modification section */
      '2022/09/16 22:43:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
      'B+S50' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
      'SERVER' TIMEZONE,                              /* SERVER, UTC */
      '%' STATEMENT_HASH,
      '%' LOCK_NAME,
      'HISTORY' DATA_SOURCE
    FROM
      DUMMY
  )
),
ALL_THREADS AS
( SELECT
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.TIMESTAMP END SAMPLE_TIME,
    T.HOST,
    T.PORT,
    T.CONNECTION_ID,
    T.THREAD_ID,
    T.THREAD_TYPE,
    T.THREAD_STATE,
    T.THREAD_METHOD,
    T.THREAD_DETAIL,
    T.STATEMENT_HASH,
    T.APPLICATION_USER_NAME APP_USER,
    T.APPLICATION_NAME APP_NAME,
    T.APPLICATION_SOURCE APP_SOURCE,
    T.CLIENT_IP,
    T.CLIENT_PID,
    TO_DECIMAL(T.DURATION / 1000, 10, 2) DURATION_S,
    CASE
      WHEN T.LOCK_WAIT_NAME LIKE '%[%:%]@%:%' THEN 
        SUBSTR(T.LOCK_WAIT_NAME, LOCATE(T.LOCK_WAIT_NAME, '[') + 1, LOCATE(T.LOCK_WAIT_NAME, ':') - LOCATE(T.LOCK_WAIT_NAME, '[')) ||
        SUBSTR(T.LOCK_WAIT_NAME, LOCATE(T.LOCK_WAIT_NAME, ':' || CHAR(32)) + 1)
      ELSE
        T.LOCK_WAIT_NAME
    END LOCK_NAME,
    T.LOCK_OWNER_THREAD_ID,
    ( SELECT MAP(COUNT(*), 0, 'YES', 'NO') FROM M_SERVICE_THREAD_SAMPLES T2 WHERE T2.TIMESTAMP = T.TIMESTAMP AND T2.LOCK_OWNER_THREAD_ID = T.THREAD_ID ) BLOCKER
  FROM
    BASIS_INFO BI,
    M_SERVICE_THREAD_SAMPLES T
  WHERE
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.TIMESTAMP END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    BI.DATA_SOURCE = 'CURRENT'
  UNION ALL
  SELECT
    T.TIMESTAMP,
    T.HOST,
    T.PORT,
    T.CONNECTION_ID,
    T.THREAD_ID,
    T.THREAD_TYPE,
    T.THREAD_STATE,
    T.THREAD_METHOD,
    T.THREAD_DETAIL,
    T.STATEMENT_HASH,
    T.APPLICATION_USER_NAME APP_USER,
    T.APPLICATION_NAME APP_NAME,
    T.APPLICATION_SOURCE APP_SOURCE,
    T.CLIENT_IP,
    T.CLIENT_PID,
    TO_DECIMAL(T.DURATION / 1000, 10, 2) DURATION_S,
    CASE
      WHEN T.LOCK_WAIT_NAME LIKE '%[%:%]@%:%' THEN 
        SUBSTR(T.LOCK_WAIT_NAME, LOCATE(T.LOCK_WAIT_NAME, '[') + 1, LOCATE(T.LOCK_WAIT_NAME, ':') - LOCATE(T.LOCK_WAIT_NAME, '[')) ||
        SUBSTR(T.LOCK_WAIT_NAME, LOCATE(T.LOCK_WAIT_NAME, ':' || CHAR(32)) + 1)
      ELSE
        T.LOCK_WAIT_NAME
    END LOCK_NAME,
    T.LOCK_OWNER_THREAD_ID,
    ( SELECT MAP(COUNT(*), 0, 'NO', 'YES') FROM _SYS_STATISTICS.HOST_SERVICE_THREAD_SAMPLES T2 WHERE T2.TIMESTAMP = T.TIMESTAMP AND T2.LOCK_OWNER_THREAD_ID = T.THREAD_ID AND T2.LOCK_OWNER_THREAD_ID != -1 ) BLOCKER
  FROM
    BASIS_INFO BI,
    _SYS_STATISTICS.HOST_SERVICE_THREAD_SAMPLES T
  WHERE
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.TIMESTAMP END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    BI.DATA_SOURCE = 'HISTORY'
),
THREAD_HIERARCHY AS
( SELECT
    *,
    COUNT(*) OVER (PARTITION BY HIERARCHY_ROOT_RANK) - 1 WAITERS
  FROM 
    HIERARCHY
    ( SOURCE ( SELECT *, SAMPLE_TIME || LOCK_OWNER_THREAD_ID PARENT_ID, SAMPLE_TIME || THREAD_ID NODE_ID FROM ALL_THREADS )
      START WHERE BLOCKER = 'YES'
      SIBLING ORDER BY SAMPLE_TIME
      NO CACHE
    )
)
SELECT
  MAP(T.HIERARCHY_LEVEL, 1, TO_VARCHAR(T.SAMPLE_TIME, 'YYYY/MM/DD HH24:MI:SS'), '') SAMPLE_TIME,
  MAP(T.HIERARCHY_LEVEL, 1, LPAD(T.WAITERS, 4), '') WAIT,
  LPAD(T.DURATION_S, 10) DURATION_S,
  LPAD(' ', (T.HIERARCHY_LEVEL - 1) * 2) || THREAD_ID THREAD_ID,
  LPAD(T.CONNECTION_ID, 7) CONN_ID,
  T.STATEMENT_HASH,
  T.THREAD_TYPE,
  T.THREAD_STATE,
  T.LOCK_NAME,
  T.THREAD_METHOD,
  REPLACE(REPLACE(T.THREAD_DETAIL, CHAR(10), ' '), CHAR(13), ' ') THREAD_DETAIL,
  T.APP_USER,
  T.APP_NAME,
  T.APP_SOURCE,
  T.CLIENT_IP,
  T.CLIENT_PID,
  T.HOST,
  LPAD(T.PORT, 5) PORT,
  LPAD(T.LOCK_OWNER_THREAD_ID, 18) BLOCKING_THREAD_ID
FROM
  BASIS_INFO BI,
  THREAD_HIERARCHY T
WHERE
( BI.LOCK_NAME = '%' OR EXISTS
  ( SELECT LOCK_NAME FROM THREAD_HIERARCHY T2 WHERE T2.HIERARCHY_ROOT_RANK = T.HIERARCHY_ROOT_RANK AND T2.LOCK_NAME LIKE BI.LOCK_NAME )
) AND
( BI.STATEMENT_HASH = '%' OR EXISTS
  ( SELECT STATEMENT_HASH FROM THREAD_HIERARCHY T2 WHERE T2.HIERARCHY_ROOT_RANK = T.HIERARCHY_ROOT_RANK AND T2.STATEMENT_HASH LIKE BI.STATEMENT_HASH )
)
ORDER BY
  T.HIERARCHY_ROOT_RANK DESC,
  T.HIERARCHY_PARENT_RANK,
  T.HIERARCHY_RANK
