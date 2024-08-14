SELECT
/* 

[NAME]

HANA_Threads_ThreadSamples_StatisticalRecords_2.00.060+

[DESCRIPTION]

- KPIs for individual database requests based on thread samples

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- HOST_SERVICE_THREAD_SAMPLES not available with standalone statistics server
- DURATION available as of Rev. 1.00.80
- M_SERVICE_THREAD_SAMPLES.STATEMENT_EXECUTION_ID available as of Rev. 1.00.120
- HOST_SERVICE_THREAD_SAMPLES.STATEMENT_EXECUTION_ID available starting with Rev. 1.00.122.05
- ROOT_STATEMENT_HASH available with SAP HANA >= 2.00.040
- SITE_ID in history tables available with SAP HANA >= 2.0 SPS 06

[VALID FOR]

- Revisions:              >= 1.00.2.00.040

[SQL COMMAND VERSION]

- 2016/03/19:  1.0 (initial version)
- 2016/07/07:  1.1 (CPU_S and MIN_CPU_S included)
- 2016/08/15:  1.2 (dedicated Rev120+ version)
- 2017/03/20:  1.3 (MIN_PX_MAX included)
- 2017/06/01:  1.4 (BW_PCT, JE_PCT, JE_PCT and ROW_PCT included)
- 2017/10/27:  1.5 (TIMEZONE included)
- 2018/01/28:  1.6 (CPU_MAX and CPU_AVG included)
- 2018/01/29:  1.7 (dedicated 1.00.122.05+ version)
- 2018/05/07:  1.8 (CPU_S -> CPU_R_S, CPU_M_S)
- 2018/12/05:  1.9 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2019/07/13:  2.0 (dedicated 2.00.040+ version including ROOT_STATEMENT_HASH
- 2020/07/16:  2.1 (JQ_TIMES added)
- 2021/09/12:  2.2 (PASSPORT_COMPONENT and PASSPORT_ACTION added)
- 2022/05/27:  2.3 (dedicated 2.00.060+ version including SITE_ID for data source HISTORY)
- 2022/08/19:  2.4 (MIN_CPU_MAX added)
- 2022/10/23:  2.5 (STATEMENT_THREAD_LIMIT, STATEMENT_MEMORY_LIMIT and WORKLOAD_CLASS added)

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

- SITE_ID

  System replication site ID (may only work for DATA_SOURCE = 'HISTORY')

  -1             --> No restriction related to site ID
  1              --> Site id 1

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

- STATEMENT_HASH      
 
  Hash of SQL statement to be analyzed

  '2e960d7535bf4134e2bd26b9d80bd4fa' --> SQL statement with hash '2e960d7535bf4134e2bd26b9d80bd4fa'
  '%'                                --> No statement hash restriction

- ROOT_STATEMENT_HASH
 
  Root statement hash (e.g. hash of procedure responsible for statement execution)

  '2e960d7535bf4134e2bd26b9d80bd4fa' --> Root statement with hash '2e960d7535bf4134e2bd26b9d80bd4fa'
  '%'                                --> No root statement hash restriction

- STATEMENT_THREAD_LIMIT

  Statement thread limit

  24                --> List threads with a limitation to 24 threads
  -1                --> No restriction related to statement thread limit

- STATEMENT_MEMORY_LIMIT

  Statement memory limit

  100               --> List threads with a limitation to 100 GB of memory
  -1                --> No restriction related to statement memory limit

- WORKLOAD_CLASS

  Workload class name

  'WLC_100'       --> Display threads running in the context of workload class WLC_100
  '%'             --> No restriction related to workload class

- STATEMENT_EXECUTION_ID

  SQL statement execution identifier (varies for different executions of same statement hash)

  '859110927564988' --> Only display samples with statement ID 859110927564988
  '%'               --> No restriction related to statement ID

- DB_USER

  Database user

  'SYSTEM'        --> Database user 'SYSTEM'
  '%'             --> No database user restriction

- APP_NAME

  Name of application

  'ABAP:C11'      --> Application name 'ABAP:C11'
  '%'             --> No application name restriction

- APP_USER

  'SAPSYS'        --> Application user 'SAPSYS'
  '%'             --> No application user restriction
  
- APP_SOURCE

  Application source

  'SAPL2:437'     --> Application source 'SAPL2:437'
  'SAPMSSY2%'     --> Application sources starting with SAPMSSY2
  '%'             --> No application source restriction

- PASSPORT_COMPONENT

  Passport component

  'P24/sapabap01_P24_27' --> Passport component P24/sapabap01_P24_27
  '%'                    --> No restriction related to passport component

- PASSPORT_ACTION

  Passport action

  'SAPMSSY1'      --> Passport action SAPMSSY1
  '%'             --> No restriction related to passport action 

- CLIENT_IP

  IP address of client

  '172.23.4.12'  --> IP address 172.23.4.12 
  '%'            --> No restriction related to IP address

- CLIENT_PID

  Client process ID

  10264           --> Client process ID 10264
  -1              --> No client process ID restriction


- CONN_ID

  Connection ID

  330655          --> Connection ID 330655
  -1              --> No connection ID restriction

- MIN_SAMPLES

  Minimum number of available samples for displayed database requests

  100             --> Only display database requests with at least 100 thread samples
  -1              --> No restriction related to number of samples

- MIN_CPU_S

  Minimum CPU consumption (s)

  100             --> Only display database requests consuming at least 100 CPU seconds
  -1              --> No restriction related to CPU consumption

- MIN_PX_MAX

  Minimum threshold for maximum parallelism (i.e. display only statistics records with a higher parallelism)

  48              --> Only show statistics records with a maximum parallelism of at least 48 threads (all types, including SQLExecutor / Request)
  -1              --> No restriction related to maximum parallelism

- MIN_CPU_MAX

  Minimum threshold for maximum parallel CPU utilization (i.e. display only statistics records with a higher parallelism)

  48              --> Only show statistics records with a maximum utilization of at least 48 CPUs
  -1              --> No restriction related to maximum CPU utilization

- STATEMENT_ACTIVITY

  Current statement activity state

  'ACTIVE'        --> Only display database requests that are marked as active statement
  'INACTIVE'      --> Only display database requests that are no longer active
  '%'             --> No restriction related to database request activity

- USE_ROOT_STATEMENT_HASH

  Possibility to use the root statement hash instead of the statement hash as an aggregation base

  'X'             --> Aggregate based on root statement hash
  ' '             --> Aggregate based on statement hash

- EXCLUDE_SERVICE_THREAD_SAMPLER

  Possibility to ignore samples related to service thread sampling

  'X'             --> Samples related to service thread sampling are not shown
  ' '             --> All samples are displayed

- EXCLUDE_NEGATIVE_THREAD_IDS

  Possibility to ignore samples related to negative thread IDs

  'X'             --> Samples related to negative thread IDs are ignored
  ' '             --> All samples are displayed

- EXCLUDE_NEGATIVE_CONN_IDS

  Possibility to ignore samples related to negative connection IDs (i.e. internal connections)

  'X'             --> Samples related to negative connection IDs are ignored
  ' '             --> All samples are displayed

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'ENDTIME'       --> Sorting by database request end time
  'SAMPLES'       --> Sorting by number of available samples

[OUTPUT PARAMETERS]

- ST:                 System replication site ID
- HOST:               Host name
- PORT:               Port
- WORKLOAD_CLASS:     Workload class name
- STL:                Statement thread limit
- SML:                Statement memory limit
- CONN_ID:            Connection ID
- STMT_EXEC_ID:       Statement execution ID
- STATEMENT_HASH:     Statement hash or root statement hash (depending on USE_ROOT_STATEMENT_HASH configuration)
- A:                  Activity state ('Y' -> statement currently active, 'N' -> statement no longer active)
- BEGIN_TIME:         Begin time
- END_TIME:           End time
- RUNTIME_S:          Absolute runtime (s)
- CPU_R_S:            CPU time (s), based on "Running" threads
- CPU_M_S:            CPU time (s), based on CPU_TIME_CUMULATIVE column
- SAMPLES:            Number of thread samples
- PX_MAX:             Maximum recorded parallelism (i.e. maximum number of threads concurrently working on the database request)
- PX_AVG:             Average parallelism
- CPU_MAX:            Maximum number of threads consuming CPU (i.e. being in 'Running' status)
- CPU_AVG:            Average number of threads consuming CPU
- SMP_TIMES:          Sample times (i.e. distinct timestamps where active threads were found)
- JQ_TIMES:           Sample times where at least one thread was waiting for JobWorker assignment, i.e. job queueing ('Job Exec Waiting' + emtpy CALLING)
- RUN_PCT:            Thread samples in 'Running' state (%)
- TLK_PCT:            Thread samples waiting for transactional locks (%)
- ILK_PCT:            Thread samples waiting for internal locks (%)
- IO_PCT:             Thread samples waiting for I/O (%)
- IDL_PCT:            Thread samples in idle states (%)
- NET_PCT:            Thread samples waiting for network (%)
- OTH_PCT:            Thread samples in other states (%)
- JE_PCT:             Thread samples with join engine related details (%)
- BW_PCT:             Thread samples with OLAP engine related details (%)
- ROW_PCT:            Thread samples with row engine related details (%)
- CE_PCT:             Thread samples with calculation engine related details (%)
- CLIENT_IP:          Client IP address
- CLIENT_PID:         Client process ID
- DB_USER:            Database user
- APP_USER:           Application user
- APP_NAME:           Application name
- APP_SOURCE:         Application source
- PASSPORT_COMPONENT: Passport component
- PASSPORT_ACTION:    Passport action
- ACCESSED_OBJECTS:   Objects accessed by the query

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST  |PORT |CONN_ID   |STATEMENT_ID   |STATEMENT_HASH                  |A|BEGIN_TIME         |END_TIME           |RUNTIME_S |NUM_SAMPLES|PX_MAX|PX_AVG|SAMPLE_TIMES|RUN_PCT|TLK_PCT|ILK_PCT|IO_PCT|IDL_PCT|NET_PCT|OTH_PCT|CLIENT_IP      |CLIENT_PID|DB_USER        |APP_USER       |APP_NAME                  |APP_SOURCE                                                     |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|hana01|33303|    365296|156893505789808|f8b15dbc08271dbee67d82a67e4d38d7|N|2016/03/19 13:25:36|2016/03/19 14:25:34|      3599|         68|  1.00|  1.00|          68|    100|      0|      0|     0|      0|      0|      0|    10.67.36.18|     42132|SAPSR3         |DDIC           |ABAP:SR3                  |SAPLBR00:419                                                   |
|hana01|33303|    351724|151064683853136|a8bf6233b8e2c38def2ba7f82ddf1c56|N|2016/03/19 13:30:22|2016/03/19 14:25:34|      3313|         21|  1.00|  1.00|          21|    100|      0|      0|     0|      0|      0|      0|    10.67.36.13|     34360|SAPSR3         |SD_BATCH       |ABAP:SR3                  |RADBTDDF:70                                                    |
|hana01|33303|    365073|156797747838737|a3025cc0f6b1accdb3ba2f75cd732341|N|2016/03/19 13:37:19|2016/03/19 14:25:32|      2894|         31|  1.00|  1.00|          31|    100|      0|      0|     0|      0|      0|      0|    10.67.36.16|     33868|SAPSR3         |DDIC           |ABAP:SR3                  |SAPLBR00:288                                                   |
|hana01|33303|    365073|156797795834662|5bc91f11c7880283920620042e5c98e6|N|2016/03/19 13:26:09|2016/03/19 14:25:27|      3559|         83|  1.00|  1.00|          83|    100|      0|      0|     0|      0|      0|      0|    10.67.36.16|     33868|SAPSR3         |DDIC           |ABAP:SR3                  |SAPLBR00:402                                                   |
|hana01|33303|    365296|156893500961243|5bc91f11c7880283920620042e5c98e6|N|2016/03/19 13:25:47|2016/03/19 14:25:22|      3576|         82|  1.00|  1.00|          82|    100|      0|      0|     0|      0|      0|      0|    10.67.36.18|     42132|SAPSR3         |DDIC           |ABAP:SR3                  |SAPLBR00:402                                                   |
|hana01|33303|    365296|156893462732440|be5e8809a9ceb674b3117f1d15f08dac|N|2016/03/19 13:25:38|2016/03/19 14:25:17|      3580|        127|  1.00|  1.00|         127|     72|     27|      1|     0|      0|      0|      0|    10.67.36.18|     42132|SAPSR3         |DDIC           |ABAP:SR3                  |SAPLREPB:157                                                   |
|hana01|33303|    352518|151405381588696|aede82e57a6e56eef4a26a1a58d87a8c|N|2016/03/19 13:27:23|2016/03/19 14:25:17|      3474|         10|  1.00|  1.00|          10|    100|      0|      0|     0|      0|      0|      0|    10.67.36.18|     43616|SAPSR3         |DDIC           |ABAP:SR3                  |RBREPL17:197                                                   |
|hana01|33303|    333641|143297722234093|aede82e57a6e56eef4a26a1a58d87a8c|N|2016/03/19 13:25:36|2016/03/19 14:25:16|      3581|        135|  1.00|  1.00|         135|    100|      0|      0|     0|      0|      0|      0|    10.67.36.18|      6312|SAPSR3         |DDIC           |ABAP:SR3                  |RBREPL16:197                                                   |
|hana01|33303|    365073|156797813534331|be5e8809a9ceb674b3117f1d15f08dac|N|2016/03/19 13:25:36|2016/03/19 14:25:15|      3580|        176|  1.00|  1.00|         176|     65|     34|      1|     0|      0|      0|      0|    10.67.36.16|     33868|SAPSR3         |DDIC           |ABAP:SR3                  |SAPLREPB:157                                                   |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  IFNULL(LPAD(SITE_ID, 2), '') ST,
  HOST,
  LPAD(PORT, 5) PORT,
  WORKLOAD_CLASS,
  LPAD(STATEMENT_THREAD_LIMIT, 3) STL,
  LPAD(STATEMENT_MEMORY_LIMIT, 4) SML,
  LPAD(CONN_ID, 7) CONN_ID,
  LPAD(STATEMENT_EXECUTION_ID, 16) STMT_EXEC_ID,
  STATEMENT_HASH,
  ACTIVE A,
  TO_VARCHAR(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS') BEGIN_TIME,
  TO_VARCHAR(END_TIME, 'YYYY/MM/DD HH24:MI:SS') END_TIME,
  LPAD(RUNTIME_S, 9) RUNTIME_S,
  LPAD(TO_DECIMAL(ROUND(CPU_R_S), 10, 0), 8) CPU_R_S,
  LPAD(TO_DECIMAL(ROUND(CPU_M_S), 10, 0), 8) CPU_M_S,
  /* LPAD(TO_DECIMAL(ROUND(DURATION_MS / 1000), 10, 0), 10) DURATION_S, */
  LPAD(NUM_SAMPLES, 8) SAMPLES,
  LPAD(TO_DECIMAL(PX_MAX, 10, 2), 6) PX_MAX,
  LPAD(TO_DECIMAL(PX_AVG, 10, 2), 6) PX_AVG,
  LPAD(TO_DECIMAL(CPU_MAX, 10, 2), 7) CPU_MAX,
  LPAD(TO_DECIMAL(CPU_AVG, 10, 2), 7) CPU_AVG,
  LPAD(SAMPLE_TIMES, 9) SMP_TIMES,
  LPAD(JQ_TIMES, 8) JQ_TIMES,
  LPAD(TO_DECIMAL(ROUND(RUN / NUM_SAMPLES * 100), 10, 0), 7) RUN_PCT,
  LPAD(TO_DECIMAL(ROUND(TLK / NUM_SAMPLES * 100), 10, 0), 7) TLK_PCT,
  LPAD(TO_DECIMAL(ROUND(ILK / NUM_SAMPLES * 100), 10, 0), 7) ILK_PCT,
  LPAD(TO_DECIMAL(ROUND(IO / NUM_SAMPLES * 100), 10, 0), 6) IO_PCT,
  LPAD(TO_DECIMAL(ROUND(IDL / NUM_SAMPLES * 100), 10, 0), 7) IDL_PCT,
  LPAD(TO_DECIMAL(ROUND(NET / NUM_SAMPLES * 100), 10, 0), 7) NET_PCT,
  LPAD(TO_DECIMAL(ROUND((NUM_SAMPLES - RUN - TLK - ILK - IO - IDL - NET) / NUM_SAMPLES * 100), 10, 0), 7) OTH_PCT,
  LPAD(TO_DECIMAL(ROUND(JE / NUM_SAMPLES * 100), 10, 0), 7) JE_PCT,
  LPAD(TO_DECIMAL(ROUND(BW / NUM_SAMPLES * 100), 10, 0), 7) BW_PCT,
  LPAD(TO_DECIMAL(ROUND(ROWENG / NUM_SAMPLES * 100), 10, 0), 7) ROW_PCT,
  LPAD(TO_DECIMAL(ROUND(CE / NUM_SAMPLES * 100), 10, 0), 7) CE_PCT,
  LPAD(CLIENT_IP, 15) CLIENT_IP,
  LPAD(CLIENT_PID, 10) CLIENT_PID,
  DB_USER,
  APP_USER,
  APP_NAME,
  IFNULL(APP_SOURCE_CACHE, APP_SOURCE) APP_SOURCE,
  PASSPORT_COMPONENT,
  PASSPORT_ACTION,
  ( SELECT MAX(TO_VARCHAR(SUBSTR(ACCESSED_OBJECT_NAMES, 1, 5000))) FROM M_SQL_PLAN_CACHE S WHERE S.STATEMENT_HASH = D.STATEMENT_HASH ) ACCESSED_OBJECTS
FROM
( SELECT
    SITE_ID,
    HOST,
    PORT,
    WORKLOAD_CLASS_NAME WORKLOAD_CLASS,
    STATEMENT_THREAD_LIMIT,
    STATEMENT_MEMORY_LIMIT,
    CONN_ID,
    STATEMENT_EXECUTION_ID,
    STATEMENT_HASH,
    DB_USER,
    APP_USER,
    APP_NAME,
    APP_SOURCE,
    PASSPORT_COMPONENT,
    PASSPORT_ACTION,
    ( SELECT MAX(APPLICATION_SOURCE) FROM M_SQL_PLAN_CACHE S WHERE S.STATEMENT_HASH = D.STATEMENT_HASH ) APP_SOURCE_CACHE,
    CLIENT_IP,
    CLIENT_PID,
    ACTIVE,
    BEGIN_TIME,
    END_TIME,
    RUNTIME_S,
    CPU_R_S,
    CPU_M_S,
    NUM_SAMPLES,
    SAMPLE_TIMES,
    JQ_TIMES,
    DURATION_MS,
    MAP(SAMPLE_TIMES, 0, 0, NUM_SAMPLES / SAMPLE_TIMES) PX_AVG,
    PX_MAX,
    MAP(SAMPLE_TIMES, 0, 0, RUN / SAMPLE_TIMES) CPU_AVG,
    CPU_MAX,
    RUN,
    TLK,
    ILK,
    IO,
    IDL,
    NET,
    JE,
    BW,
    ROWENG,
    CE,
    ORDER_BY
  FROM
  ( SELECT
      SITE_ID,
      HOST,
      PORT,
      CONN_ID,
      WORKLOAD_CLASS_NAME,
      STATEMENT_MEMORY_LIMIT,
      STATEMENT_THREAD_LIMIT,
      STATEMENT_EXECUTION_ID,
      STATEMENT_HASH,
      DB_USER,
      APP_USER,
      APP_NAME,
      APP_SOURCE,
      PASSPORT_COMPONENT,
      PASSPORT_ACTION,
      CLIENT_IP,
      CLIENT_PID,
      ACTIVE,
      MIN(SAMPLE_TIME) BEGIN_TIME,
      MAX(SAMPLE_TIME) END_TIME,
      SECONDS_BETWEEN(MIN(SAMPLE_TIME), MAX(SAMPLE_TIME)) + 1 RUNTIME_S,
      SUM(RUN) * SAMPLE_INTERVAL_S CPU_R_S,
      SUM(CPU_MS) / 1000 CPU_M_S,
      MAX(DURATION_MS) DURATION_MS,
      SUM(NUM_SAMPLES) NUM_SAMPLES,
      SUM(RUN) RUN,
      SUM(TLK) TLK,
      SUM(ILK) ILK,
      SUM(IO) IO,
      SUM(IDL) IDL,
      SUM(NET) NET,
      COUNT(DISTINCT(SAMPLE_TIME)) SAMPLE_TIMES,
      COUNT(DISTINCT(JOB_QUEUEING)) - MAX(MAP(JOB_QUEUEING, '', 1, 0)) JQ_TIMES,
      SUM(JE) JE,
      SUM(BW) BW,
      SUM(ROWENG) ROWENG,
      SUM(CE) CE,
      MAX(NUM_SAMPLES) PX_MAX,
      MAX(RUN) CPU_MAX,
      ORDER_BY,
      MIN_SAMPLES,
      MIN_CPU_S,
      MIN_PX_MAX,
      MIN_CPU_MAX
    FROM
    ( SELECT
        T.SITE_ID,
        T.HOST,
        T.PORT,
        T.WORKLOAD_CLASS_NAME,
        T.STATEMENT_MEMORY_LIMIT,
        T.STATEMENT_THREAD_LIMIT,
        T.CONN_ID,
        T.STATEMENT_EXECUTION_ID,
        MAP(BI.USE_ROOT_STATEMENT_HASH, 'X', T.ROOT_STATEMENT_HASH, T.STATEMENT_HASH) STATEMENT_HASH,
        T.DB_USER,
        T.APP_USER,
        T.APP_NAME,
        T.APP_SOURCE,
        T.PASSPORT_COMPONENT,
        T.PASSPORT_ACTION,
        T.CLIENT_IP,
        T.CLIENT_PID,
        MAP(T.ACTIVE, NULL, 'N', 0, 'N', 'Y') ACTIVE,
        CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.SAMPLE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.SAMPLE_TIME END SAMPLE_TIME,
        SECONDS_BETWEEN(MIN(T.SAMPLE_TIME), MAX(T.SAMPLE_TIME)) + 1 RUNTIME_S,
        MAP(BI.DATA_SOURCE, 'CURRENT', 1, I.SAMPLE_INTERVAL_S) SAMPLE_INTERVAL_S,
        MAX(T.DURATION_MS) DURATION_MS,
        MAX(T.CPU_MS) CPU_MS,
        COUNT(*) NUM_SAMPLES,
        SUM(MAP(T.THREAD_STATE, 'Running', 1, 0)) RUN,
        SUM(MAP(T.LOCK_NAME, 'TransactionLockWaitCondStat', 1, 'TransactionLockWaitSmpStat', 1, 'RecordLockWaitCondStat', 1, 'TableLockWaitCondStat', 1, 0)) TLK,
        SUM(CASE WHEN T.THREAD_STATE IN ( 'Barrier Wait', 'ConditionalVar Wait', 'ConditionalVariable Wait', 'ExclusiveLock Enter', 'Mutex Wait', 'Semaphore Wait', 'SharedLock Enter', 'Sleeping', 'Speculative Lock Retry backoff', 'Speculative Lock Wait for fallback',
          'Speculative RetryBkf', 'Speculative WaitFlbk' ) AND
          T.LOCK_NAME NOT IN ( 'AttributeStore Resource Load', 'LogBufferFreeWait', 'LoggerBufferSwitch', 'POSTCOMMIT_FINISH_SMP', 'PrefetchCallback', 'PrefetchIteratorCallback',
          'ResourceFlushWaitA', 'ResourceFlushWaitB', 'RecordLockWaitCondStat', 'TableLockWaitCondStat', 'TransactionLockWaitCondStat', 'TransactionLockWaitSmpStat', 'WaitAndSwitchCounterResourceSemaphore' ) THEN 1 ELSE 0 END) ILK,
        SUM(CASE WHEN T.THREAD_STATE IN ( 'Resource Load Wait', 'IO Wait' ) OR
          T.LOCK_NAME IN ( 'AttributeStore Resource Load', 'LoadLock', 'LogBufferFreeWait', 'LoggerBufferSwitch', 'POSTCOMMIT_FINISH_SMP', 'PrefetchCallback', 'PrefetchIteratorCallback',
          'ResourceFlushWaitA', 'ResourceFlushWaitB', 'TableContainer Mutex', 'TRexConfig_IndexMgrIndex_ReplayLock', 'WaitAndSwitchCounterResourceSemaphore' ) THEN 1 ELSE 0 END) IO,
        SUM(CASE WHEN T.THREAD_STATE IN ('Network Poll', 'Network Read', 'Network Write') THEN 1 ELSE 0 END) NET,
        SUM(MAP(T.THREAD_STATE, 'Job Exec Waiting', 1, 0)) IDL,
        SUM(CASE WHEN T.THREAD_TYPE = 'JobWorker' AND T.THREAD_DETAIL LIKE '%(JE%' THEN 1 ELSE 0 END) JE,
        SUM(CASE WHEN T.THREAD_TYPE = 'JobWorker' AND T.THREAD_DETAIL LIKE '%(Bw%' THEN 1 ELSE 0 END) BW,
        SUM(CASE WHEN T.THREAD_TYPE = 'JobWorker' AND T.THREAD_DETAIL LIKE '%(Row%' THEN 1 ELSE 0 END) ROWENG,
        SUM(CASE WHEN T.THREAD_TYPE = 'JobWorker' AND T.THREAD_DETAIL LIKE '%(ce%' THEN 1 ELSE 0 END) CE,
        MAX(JOB_QUEUEING) JOB_QUEUEING,
        BI.ORDER_BY,
        BI.MIN_SAMPLES,
        BI.MIN_CPU_S,
        BI.MIN_PX_MAX,
        BI.MIN_CPU_MAX,
        BI.STATEMENT_ACTIVITY
      FROM 
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
          SITE_ID,
          HOST,
          PORT,
          STATEMENT_HASH,
          ROOT_STATEMENT_HASH,
          WORKLOAD_CLASS,
          STATEMENT_THREAD_LIMIT,
          STATEMENT_MEMORY_LIMIT,
          STATEMENT_EXECUTION_ID,
          DB_USER,
          APP_NAME,
          APP_USER,
          APP_SOURCE,
          PASSPORT_COMPONENT,
          PASSPORT_ACTION,
          CLIENT_IP,
          CLIENT_PID,
          CONN_ID,
          MIN_SAMPLES,
          MIN_CPU_S,
          MIN_PX_MAX,
          MIN_CPU_MAX,
          STATEMENT_ACTIVITY,
          USE_ROOT_STATEMENT_HASH,
          EXCLUDE_SERVICE_THREAD_SAMPLER,
          EXCLUDE_NEGATIVE_THREAD_IDS,
          EXCLUDE_NEGATIVE_CONN_IDS,
          DATA_SOURCE,
          ORDER_BY
        FROM
        ( SELECT                  /* Modification section */
            'C-H1' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
            '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
            'SERVER' TIMEZONE,                              /* SERVER, UTC */
            CURRENT_SITE_ID() SITE_ID,
            '%' HOST,
            '%' PORT,
            '%' STATEMENT_HASH,
             -1 STATEMENT_THREAD_LIMIT,
             -1 STATEMENT_MEMORY_LIMIT,
            '%' WORKLOAD_CLASS,
            '%' ROOT_STATEMENT_HASH,
            '%' STATEMENT_EXECUTION_ID,
            '%' DB_USER,
            '%' APP_NAME,
            '%' APP_USER,
            '%' APP_SOURCE,
            '%' PASSPORT_COMPONENT,
            '%' PASSPORT_ACTION,
            '%' CLIENT_IP,
             -1 CLIENT_PID,
             -1 CONN_ID,
             10 MIN_SAMPLES,
             -1 MIN_CPU_S,
             -1 MIN_PX_MAX,
             -1 MIN_CPU_MAX,
            '%' STATEMENT_ACTIVITY,            /* ACTIVE, INACTIVE, % */
            ' ' USE_ROOT_STATEMENT_HASH,
            'X' EXCLUDE_SERVICE_THREAD_SAMPLER,
            'X' EXCLUDE_NEGATIVE_THREAD_IDS,
            'X' EXCLUDE_NEGATIVE_CONN_IDS,
            'HISTORY' DATA_SOURCE,
            'STARTTIME' ORDER_BY               /* STARTTIME, ENDTIME, DURATION, CPUTIME, SAMPLES, CONN_ID, PX_MAX, PX_AVG, CPU_MAX, CPU_AVG */
          FROM
            DUMMY
        )
      ) BI,
      ( SELECT
          DATA_SOURCE,
          SITE_ID,
          HOST,
          PORT,
          SAMPLE_TIME,
          THREAD_ID,
          MAP(THREAD_TYPE, CHAR(63), THREAD_METHOD, THREAD_TYPE) THREAD_TYPE,
          MAP(THREAD_METHOD, CHAR(63), THREAD_TYPE, THREAD_METHOD) THREAD_METHOD,
          MAP(THREAD_DETAIL, CHAR(63), MAP(THREAD_METHOD, CHAR(63), THREAD_TYPE,   THREAD_METHOD), THREAD_DETAIL) THREAD_DETAIL,
          THREAD_STATE,
          DURATION_MS,
          CPU_MS,
          MAP(STATEMENT_HASH, CHAR(63), THREAD_TYPE, STATEMENT_HASH) STATEMENT_HASH,
          MAP(ROOT_STATEMENT_HASH, CHAR(63), THREAD_TYPE, ROOT_STATEMENT_HASH) ROOT_STATEMENT_HASH,
          STATEMENT_EXECUTION_ID,
          CONN_ID,
          DB_USER,
          APP_NAME,
          APP_USER,
          APP_SOURCE,
          PASSPORT_COMPONENT,
          PASSPORT_ACTION,
          CLIENT_IP,
          CLIENT_PID,
          LOCK_COMPONENT,
          LOCK_NAME,
          BLOCKING_THREAD,
          JOB_QUEUEING,
          WORKLOAD_CLASS_NAME,
          STATEMENT_MEMORY_LIMIT,
          STATEMENT_THREAD_LIMIT,
          ( SELECT COUNT(*) FROM M_ACTIVE_STATEMENTS A WHERE A.HOST = T.HOST AND A.PORT = T.PORT AND A.CONNECTION_ID = T.CONN_ID AND A.STATEMENT_ID = T.STATEMENT_ID ) ACTIVE
        FROM
        ( SELECT
            'CURRENT' DATA_SOURCE,
            CURRENT_SITE_ID() SITE_ID,
            HOST,
            PORT,
            TIMESTAMP SAMPLE_TIME,
            THREAD_ID,
            CASE
              WHEN THREAD_TYPE LIKE 'JobWrk%' THEN 'JobWorker'
              ELSE THREAD_TYPE
            END THREAD_TYPE,
            CASE 
              WHEN THREAD_METHOD LIKE 'GCJob%' THEN 'GCJob' 
              ELSE THREAD_METHOD 
            END THREAD_METHOD,
            THREAD_DETAIL,
            THREAD_STATE,
            DURATION / 1000 DURATION_MS,
            STATEMENT_HASH,
            ROOT_STATEMENT_HASH,
            STATEMENT_ID,
            TO_VARCHAR(STATEMENT_EXECUTION_ID) STATEMENT_EXECUTION_ID,
            CONNECTION_ID CONN_ID,
            USER_NAME DB_USER,
            APPLICATION_NAME APP_NAME,
            APPLICATION_USER_NAME APP_USER,
            APPLICATION_SOURCE APP_SOURCE,
            IFNULL(PASSPORT_COMPONENT_NAME, '') PASSPORT_COMPONENT,
            IFNULL(PASSPORT_ACTION, '') PASSPORT_ACTION,
            CLIENT_IP,
            CLIENT_PID,
            LOCK_WAIT_COMPONENT LOCK_COMPONENT,
            LOCK_WAIT_NAME LOCK_NAME,
            LOCK_OWNER_THREAD_ID BLOCKING_THREAD,
            CPU_TIME_CUMULATIVE / 1000 CPU_MS,
            CASE WHEN THREAD_STATE = 'Job Exec Waiting' AND CALLING = '' THEN TO_VARCHAR(TIMESTAMP, 'YYYY/MM/DD HH24:MI:SS.FF7') ELSE '' END JOB_QUEUEING,
            WORKLOAD_CLASS_NAME,
            STATEMENT_THREAD_LIMIT,
            STATEMENT_MEMORY_LIMIT
          FROM
            M_SERVICE_THREAD_SAMPLES
          UNION ALL
          ( SELECT
              'HISTORY' DATA_SOURCE,
              SITE_ID,
              HOST,
              PORT,
              TIMESTAMP SAMPLE_TIME,
              THREAD_ID,
              CASE
                WHEN THREAD_TYPE LIKE 'JobWrk%' THEN 'JobWorker'
                ELSE THREAD_TYPE
              END THREAD_TYPE,
              CASE 
                WHEN THREAD_METHOD LIKE 'GCJob%' THEN 'GCJob' 
                ELSE THREAD_METHOD 
              END THREAD_METHOD,
              THREAD_DETAIL,
              THREAD_STATE,
              DURATION / 1000 DURATION_MS,
              STATEMENT_HASH,
              ROOT_STATEMENT_HASH,
              STATEMENT_ID,
              TO_VARCHAR(STATEMENT_EXECUTION_ID) STATEMENT_EXECUTION_ID,
              CONNECTION_ID CONN_ID,
              USER_NAME DB_USER,
              APPLICATION_NAME APP_NAME,
              APPLICATION_USER_NAME APP_USER,
              APPLICATION_SOURCE APP_SOURCE,
              IFNULL(PASSPORT_COMPONENT_NAME, '') PASSPORT_COMPONENT,
              IFNULL(PASSPORT_ACTION, '') PASSPORT_ACTION,
              CLIENT_IP,
              CLIENT_PID,
              LOCK_WAIT_COMPONENT LOCK_COMPONENT,
              LOCK_WAIT_NAME LOCK_NAME,
              LOCK_OWNER_THREAD_ID BLOCKING_THREAD,
              CPU_TIME_CUMULATIVE / 1000 CPU_MS,
              CASE WHEN THREAD_STATE = 'Job Exec Waiting' AND CALLING = '' THEN TO_VARCHAR(TIMESTAMP, 'YYYY/MM/DD HH24:MI:SS.FF7') ELSE '' END JOB_QUEUEING,
              WORKLOAD_CLASS_NAME,
              STATEMENT_THREAD_LIMIT,
              STATEMENT_MEMORY_LIMIT
            FROM
              _SYS_STATISTICS.HOST_SERVICE_THREAD_SAMPLES
          )
        ) T
      ) T,
      ( SELECT DISTINCT
          MAX(VALUE) SAMPLE_INTERVAL_S
        FROM
          M_CONFIGURATION_PARAMETER_VALUES
        WHERE
          FILE_NAME = 'global.ini' AND
          SECTION = 'resource_tracking' AND
          KEY = 'service_thread_sampling_monitor_sample_interval'
      ) I
      WHERE
        ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND T.SITE_ID IN (-1, 0) ) OR T.SITE_ID = BI.SITE_ID ) AND
        T.HOST LIKE BI.HOST AND
        TO_VARCHAR(T.PORT) LIKE BI.PORT AND
        CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.SAMPLE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.SAMPLE_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
        SUBSTR(T.STATEMENT_HASH, 1, 31) LIKE SUBSTR(BI.STATEMENT_HASH, 1, 31) AND         /* sometimes only 31 out of 32 bytes were stored in thread samples */
        T.ROOT_STATEMENT_HASH LIKE BI.ROOT_STATEMENT_HASH AND
        T.WORKLOAD_CLASS_NAME LIKE BI.WORKLOAD_CLASS AND
        ( BI.STATEMENT_THREAD_LIMIT = -1 OR T.STATEMENT_THREAD_LIMIT = BI.STATEMENT_THREAD_LIMIT ) AND
        ( BI.STATEMENT_MEMORY_LIMIT = -1 OR T.STATEMENT_MEMORY_LIMIT = BI.STATEMENT_MEMORY_LIMIT ) AND
        T.STATEMENT_EXECUTION_ID LIKE BI.STATEMENT_EXECUTION_ID AND
        T.DB_USER LIKE BI.DB_USER AND
        IFNULL(T.APP_USER, '') LIKE BI.APP_USER AND
        IFNULL(T.APP_NAME, '') LIKE BI.APP_NAME AND
        IFNULL(T.APP_SOURCE, '') LIKE BI.APP_SOURCE AND
        ( T.PASSPORT_ACTION LIKE BI.PASSPORT_ACTION ) AND
        ( T.PASSPORT_COMPONENT LIKE BI.PASSPORT_COMPONENT ) AND
        IFNULL(T.CLIENT_IP, '') LIKE BI.CLIENT_IP AND
        ( BI.CLIENT_PID = -1 OR T.CLIENT_PID = BI.CLIENT_PID ) AND
        ( BI.CONN_ID = -1 OR T.CONN_ID = BI.CONN_ID ) AND
        ( BI.EXCLUDE_SERVICE_THREAD_SAMPLER = ' ' OR T.THREAD_TYPE != 'service thread sampler' ) AND
        ( BI.EXCLUDE_NEGATIVE_THREAD_IDS = ' ' OR T.THREAD_ID >= 0 ) AND
        ( BI.EXCLUDE_NEGATIVE_CONN_IDS = ' ' OR T.CONN_ID >= 0 ) AND
        BI.DATA_SOURCE = T.DATA_SOURCE
      GROUP BY
        T.SITE_ID,
        T.HOST,
        T.PORT,
        T.CONN_ID,
        T.STATEMENT_EXECUTION_ID,
        MAP(BI.USE_ROOT_STATEMENT_HASH, 'X', T.ROOT_STATEMENT_HASH, T.STATEMENT_HASH),
        T.WORKLOAD_CLASS_NAME,
        T.STATEMENT_THREAD_LIMIT,
        T.STATEMENT_MEMORY_LIMIT,
        T.DB_USER,
        T.APP_USER,
        T.APP_NAME,
        T.APP_SOURCE,
        T.PASSPORT_COMPONENT,
        T.PASSPORT_ACTION,
        T.CLIENT_IP,
        T.CLIENT_PID,
        T.ACTIVE,
        T.SAMPLE_TIME,
        MAP(BI.DATA_SOURCE, 'CURRENT', 1, I.SAMPLE_INTERVAL_S),
        BI.ORDER_BY,
        BI.MIN_SAMPLES,
        BI.MIN_CPU_S,
        BI.MIN_PX_MAX,
        BI.MIN_CPU_MAX,
        BI.STATEMENT_ACTIVITY,
        BI.TIMEZONE
    )
    WHERE
    ( STATEMENT_ACTIVITY = '%' OR
      STATEMENT_ACTIVITY = 'ACTIVE' AND ACTIVE = 'Y' OR
      STATEMENT_ACTIVITY = 'INACTIVE' AND ACTIVE = 'N'
    )
    GROUP BY
      SITE_ID,
      HOST,
      PORT,
      CONN_ID,
      WORKLOAD_CLASS_NAME,
      STATEMENT_THREAD_LIMIT,
      STATEMENT_MEMORY_LIMIT,
      STATEMENT_EXECUTION_ID,
      STATEMENT_HASH,
      DB_USER,
      APP_USER,
      APP_NAME,
      APP_SOURCE,
      PASSPORT_COMPONENT,
      PASSPORT_ACTION,
      CLIENT_IP,
      CLIENT_PID,
      ACTIVE,
      ORDER_BY,
      MIN_SAMPLES,
      MIN_CPU_S,
      MIN_PX_MAX,
      MIN_CPU_MAX,
      SAMPLE_INTERVAL_S
  ) D
  WHERE
  ( MIN_SAMPLES = -1 OR NUM_SAMPLES >= MIN_SAMPLES ) AND
  ( MIN_CPU_S = -1 OR CPU_M_S >= MIN_CPU_S OR CPU_R_S >= MIN_CPU_S ) AND
  ( MIN_PX_MAX = -1 OR PX_MAX >= MIN_PX_MAX ) AND
  ( MIN_CPU_MAX = -1 OR CPU_MAX >= MIN_CPU_MAX )
) D
ORDER BY
  MAP(ORDER_BY, 'CONN_ID', CONN_ID),
  MAP(ORDER_BY, 'STARTTIME', BEGIN_TIME, 'CONN_ID', BEGIN_TIME, 'ENDTIME', END_TIME) DESC,
  MAP(ORDER_BY, 'DURATION', RUNTIME_S, 'CPUTIME', GREATEST(CPU_M_S, CPU_R_S), 'SAMPLES', NUM_SAMPLES, 'PX_MAX', PX_MAX, 'PX_AVG', PX_AVG, 'CPU_MAX', CPU_MAX, 'CPU_AVG', CPU_AVG) DESC
