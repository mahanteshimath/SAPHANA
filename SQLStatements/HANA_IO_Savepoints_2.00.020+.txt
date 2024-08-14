SELECT

/* 

[NAME]

- HANA_IO_Savepoints_2.00.020+

[DESCRIPTION]

- Savepoint overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- CRITICAL_PHASE_START_TIME, CRITICAL_PHASE_WAIT_TIME available as of 1.00.71 in M_SAVEPOINTS
- TOTAL_SIZE (and as a consequence SUM_SIZE_MB and AVG_SIZE_MB) may be empty due to bug 62788 
  (fixed with 1.00.97)
- CRITICAL_PHASE_START_TIME, CRITICAL_PHASE_WAIT_TIME available as of 1.00.80 and with ESS in history
- BLOCKING_PHASE_START_TIME available as of SAP HANA 2.00.010
- Both CRITICAL_PHASE_WAIT_TIME and CRITICAL_PHASE_DURATION are critical in terms of locking DML statements
- INITIATION, PURPOSE and PREPARE_FLUSH_RETRY_COUNT not available in HOST_SAVEPOINTS before 2.00.020 (bug 145339)
- Can be used for monitoring remote system replication sites, see SAP Note 1999880 
  ("Is it possible to monitor remote system replication sites on the primary system") for details.
  Only works for DATA_SOURCE = 'CURRENT'

[VALID FOR]

- Revisions:              >= 2.00.020

[SQL COMMAND VERSION]

- 2014/04/25:  1.0 (initial version)
- 2014/05/26:  1.1 (history included)
- 2014/11/27:  1.2 (write throughput MB_PER_S included)
- 2015/06/24:  1.3 (dedicated Rev. 80+ version)
- 2015/09/21:  1.4 (included blocking phase information)
- 2016/12/31:  1.5 (TIME_AGGREGATE_BY = 'TS<seconds>' included)
- 2017/04/08:  1.6 (explicit display of waitForLock phase duration)
- 2017/04/24:  1.7 (PURPOSE and RETRY_COUNT included)
- 2017/10/25:  1.8 (TIMEZONE included)
- 2018/02/06:  1.9 (INITIATION and new aggregations included)
- 2018/02/06:  2.0 (dedicated 2.00.012 version)
- 2018/08/23:  2.1 (dedicated 2.00.020 version)
- 2018/12/05:  2.2 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2020/04/19:  2.3 (AGGREGATION_TYPE added)
- 2021/06/27:  2.4 (VERSION added)
- 2022/10/05:  2.5 (critical phase details added)

[INVOLVED TABLES]

- M_SAVEPOINTS
- HOST_SAVEPOINTS

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

- VERSION

  Savepoint version

  123456          --> Display savepoint with version 123456 (version is also shown in trace files as "Savepoint current savepoint version: <version>")
  -1              --> No restriction related to savepoint version

- MIN_BLOCKING_PHASE_DURATION_S

  Only show savepoints with a blocking phase that exceeds the configured threshold (in seconds)

  10               --> Display savepoints with a blocking phase of at least 10 seconds
  -1               --> Display all savepoints

- MIN_WAIT_FOR_LOCK_PHASE_DURATION_S

  Only show savepoints with a waitForLock phase that exceeds the configured threshold (in seconds)

  10               --> Display savepoints with a waitForLock phase of at least 10 seconds
  -1               --> Display all savepoints

- MIN_CRITICAL_PHASE_DURATION_S

  Only show savepoints with a critical phase that exceeds the configured threshold (in seconds)

  10               --> Display savepoints with a critical phase of at least 10 seconds
  -1               --> Display all savepoints

- MIN_SAVEPOINT_DURATION_S

  Only show savepoints with a critical phase that exceeds the configured threshold (in seconds)

  300              --> Display savepoints with a total duration of at least 300 seconds
  -1               --> Display all savepoints

- MIN_WRITE_SIZE_GB

  Minimum size of I/O writes (GB)

  10               --> Only display savepoints writing at least 10 GB
  -1               --> No restriction related to savepoint write size

- MIN_RETRY_COUNT

  Minimum number of flush retries

  20               --> Display savepoints with at least 20 flush retries
  -1               --> No restriction related to flush retries

- INITIATION

  Savepoint initiation

  'EX%ECUTED_EXPLICITLY' --> explicit triggering of savepoint (due to a spelling error INITIATION may be "EXCECUTED_EXPLICITLY" rather than "EXECUTED_EXPLICITLY")
  'TRIGGERED_TIMEBASED'  --> Timebased savepoint trigger (global.ini -> [persistence] -> savepoint_interval_s)
  '%'                    --> No restriction related to initiation

- PURPOSE

  Savepoint purpose

  'NORMAL'                   --> Normal savepoint
  'SNAPSHOT_FOR_REPLICATION' --> Savepoint for system replication snapshot
  'DROP_SNAPSHOT'            --> Savepoint when dropping a snapshot
  '%'                        --> No restriction related to purpose

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)
  '%'             --> All data sources

- AGGREGATION_TYPE

  Type of aggregation (e.g. average, sum, maximum)

  'AVG'           --> Average value
  'SUM'           --> Total value
  'MAX'           --> Maximum value

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'          --> Aggregation by time
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation

[OUTPUT PARAMETERS]

- START_TIME:            Start time of considered time interval
- BLK_PHASE_START_TIME:  Start time of blocking phase
- CRIT_PHASE_START_TIME: Start time of critical phase
- END_TIME:              End time of savepoint
- START_TIME:            Start time of considered time interval
- HOST:                  Host
- PORT:                  Port
- VERSION:               Savepoint version
- COUNT:                 Number of savepoints
- P:                     Savepoint purpose (DS -> DROP_SNAPSHOT, N -> NORMAL, SFR -> SNAPSHOT_FOR_REPLICATION, SFB -> SNAPSHOT_FOR_BACKUP,
                         SRR -> SNAPSHOT_FOR_RESUMERE..., SFS -> SNAPSHOT_FOR_SECONDARY)
- I:                     Savepoint initiation (E -> EXECUTED_EXPLICITLY, T -> TRIGGERED_TIMEBASED)
- AGG:                   Aggregation type used for the subsequent output columns (MAX -> maximum, AVG -> average, SUM -> total)
- RETRIES:               Number of flush retries in the non-critical phase
- TOTAL_S:               Savepoint duration (s)
- BLK_S:                 Blocking phase (s), i.e. time when DML operations can be blocked
- LOCK_S:                waitForLock phase duration (s)
- CRIT_S:                Critical phase duration (s)
- SIZE_MB:               Savepoint write size (MB)
- MB_PER_S:              Write throughput (MB / s)
- CRIT_PAGES:            Number of pages flushed in critical phase
- CRIT_SIZE_MB:          Write size in critical phase (MB)
- CRIT_MB_PER_S:         Write throughput during critical phase (MB / s)
- CRIT_PAGE_MS:          Write time per page in critical phase (ms)
- RS_SIZE_PCT:           Flushed data related to rowstore compared to overall flushed data (%)

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|START_TIME      |HOST     |SERVICE_NAME|SAVEPOINTS|SUM_DURATION_S|MAX_DURATION_S|AVG_DURATION_S|MAX_CRITICAL_PHASE_S|AVG_CRITICAL_PHASE_S|SUM_SIZE_MB|AVG_SIZE_MB|RS_SIZE_PCT|
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2014/05/26 (MON)|saphana20|indexserver |        45|       5918.08|        626.11|        131.51|                3.93|                2.01|     861705|      19149|       6.86|
|2014/05/25 (SUN)|saphana20|indexserver |       230|      21724.41|       2595.69|         94.45|                4.69|                2.34|    2835199|      12327|       7.28|
|2014/05/24 (SAT)|saphana20|indexserver |       186|      20134.43|       1643.51|        108.24|                3.85|                2.25|    2838311|      15260|       6.89|
|2014/05/23 (FRI)|saphana20|indexserver |       111|      17556.60|       2613.64|        158.16|                7.32|                2.36|    2406131|      21677|       9.55|
|2014/05/22 (THU)|saphana20|indexserver |       318|      19547.89|       3164.87|         61.47|                7.44|                3.58|    2122936|       6676|       8.37|
|2014/05/21 (WED)|saphana20|indexserver |       290|      31459.90|      10009.32|        108.48|                8.40|                4.31|    3318363|      11443|       8.94|
|2014/05/20 (TUE)|saphana20|indexserver |       313|      26608.99|       3240.07|         85.01|                9.15|                4.25|    2630053|       8403|       8.11|
|2014/05/19 (MON)|saphana20|indexserver |       303|      29189.67|      10650.05|         96.33|                8.26|                4.51|    3445940|      11373|       7.24|
|2014/05/18 (SUN)|saphana20|indexserver |        25|        924.44|        131.38|         36.97|                2.90|                2.32|      94909|       3796|       6.00|
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  START_TIME,
  BLK_PHASE_START_TIME,
  CRIT_PHASE_START_TIME,
  END_TIME,
  HOST,
  LPAD(PORT, 5) PORT,
  LPAD(VERSION, 8) VERSION,
  LPAD(NUM_SAVEPOINTS, 5) COUNT,
  MAP(PURPOSE, 'DROP_SNAPSHOT', 'DS', 'NORMAL', 'N', 'SNAPSHOT_FOR_REPLICATION', 'SFR', 'SNAPSHOT_FOR_BACKUP', 'SFB', 'SNAPSHOT_FOR_RESUMERE...', 'SRR', 'SNAPSHOT_FOR_SECONDARY', 'SFS', PURPOSE) P,
  MAP(INITIATION, 'EXCECUTED_EXPLICITLY', 'E', 'EXECUTED_EXPLICITLY', 'E', 'TRIGGERED_TIMEBASED', 'T', INITIATION) I,
  AGGREGATION_TYPE AGG,
  LPAD(TO_DECIMAL(RETRIES, 10, 2), 11) RETRIES,
  LPAD(TO_DECIMAL(DURATION_S, 12, 2), 11) TOTAL_S,
  LPAD(TO_DECIMAL(BLOCKING_PHASE_S, 12, 2), 10)  BLK_S,
  LPAD(TO_DECIMAL(WAIT_FOR_LOCK_PHASE_S, 12, 2), 10) LOCK_S,
  LPAD(TO_DECIMAL(CRITICAL_PHASE_S, 12, 2), 10) CRIT_S,
  LPAD(TO_DECIMAL(ROUND(SIZE_MB), 11, 0), 10) SIZE_MB,
  LPAD(TO_DECIMAL(MB_PER_S, 10, 2), 8) MB_PER_S,
  LPAD(TO_DECIMAL(ROUND(CRIT_PAGES), 12, 0), 10) CRIT_PAGES,
  LPAD(TO_DECIMAL(ROUND(CRIT_SIZE_MB), 12, 0), 12) CRIT_SIZE_MB,
  LPAD(TO_DECIMAL(CRIT_MB_PER_S, 10, 2), 13) CRIT_MB_PER_S,
  LPAD(TO_DECIMAL(CRIT_PAGE_MS, 10, 2), 12) CRIT_PAGE_MS,
  LPAD(TO_DECIMAL(RS_SIZE_PCT, 12, 2), 11) RS_SIZE_PCT
FROM 
( SELECT
    CASE WHEN NUM_SAVEPOINTS = 1 THEN CRIT_PHASE_START_TIME ELSE 'various' END CRIT_PHASE_START_TIME,
    CASE WHEN NUM_SAVEPOINTS = 1 THEN BLK_PHASE_START_TIME ELSE 'various' END BLK_PHASE_START_TIME,
    CASE WHEN NUM_SAVEPOINTS = 1 THEN END_TIME ELSE 'various' END END_TIME,
    START_TIME,
    HOST,
    PORT,
    VERSION,
    NUM_SAVEPOINTS,
    INITIATION,
    PURPOSE,
    RETRIES,
    DURATION_S,
    BLOCKING_PHASE_S,
    WAIT_FOR_LOCK_PHASE_S,
    CRITICAL_PHASE_S,
    SIZE_MB,
    CRIT_SIZE_MB,
    CRIT_PAGES,
    MAP(DURATION_S, 0, 0, SIZE_MB / DURATION_S) MB_PER_S,
    MAP(CRIT_PAGES, 0, 0, CRITICAL_PHASE_S / CRIT_PAGES * 1000) CRIT_PAGE_MS,
    MAP(CRITICAL_PHASE_S, 0, 0, CRIT_SIZE_MB / CRITICAL_PHASE_S) CRIT_MB_PER_S,
    MAP(SIZE_MB, 0, 0, RS_SIZE_MB / SIZE_MB * 100) RS_SIZE_PCT,
    AGGREGATION_TYPE
  FROM
  ( SELECT
      CASE 
        WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(SP.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE SP.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(SP.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE SP.START_TIME END, BI.TIME_AGGREGATE_BY)
          END
        ELSE 'any' 
      END START_TIME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')       != 0 THEN SP.HOST             ELSE MAP(BI.HOST,       '%', 'any', BI.HOST)       END HOST,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')       != 0 THEN TO_VARCHAR(SP.PORT) ELSE MAP(BI.PORT,       '%', 'any', BI.PORT)       END PORT,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'INITIATION') != 0 THEN SP.INITIATION       ELSE MAP(BI.INITIATION, '%', 'any', BI.INITIATION) END INITIATION,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PURPOSE')    != 0 THEN SP.PURPOSE          ELSE MAP(BI.PURPOSE,    '%', 'any', BI.PURPOSE)    END PURPOSE,
      TO_VARCHAR(MIN(SP.BLOCKING_PHASE_START_TIME), 'YYYY/MM/DD HH24:MI:SS') BLK_PHASE_START_TIME,
      TO_VARCHAR(MIN(SP.CRITICAL_PHASE_START_TIME), 'YYYY/MM/DD HH24:MI:SS') CRIT_PHASE_START_TIME,
      TO_VARCHAR(MIN(SP.END_TIME), 'YYYY/MM/DD HH24:MI:SS') END_TIME,
      BI.AGGREGATION_TYPE,
      COUNT(*) NUM_SAVEPOINTS,
      MAP(MIN(SP.VERSION), MAX(SP.VERSION), TO_VARCHAR(MIN(SP.VERSION)), 'any') VERSION,
      MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(SP.DURATION), 'SUM', SUM(SP.DURATION), 'AVG', AVG(SP.DURATION)) / 1000000 DURATION_S,
      MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(SP.BLOCKING_PHASE_DURATION), 'SUM', SUM(SP.BLOCKING_PHASE_DURATION), 'AVG', AVG(SP.BLOCKING_PHASE_DURATION)) / 1000000 BLOCKING_PHASE_S,
      MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(SP.WAIT_FOR_LOCK_DURATION), 'SUM', SUM(SP.WAIT_FOR_LOCK_DURATION), 'AVG', AVG(SP.WAIT_FOR_LOCK_DURATION)) / 1000000 WAIT_FOR_LOCK_PHASE_S,
      MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(SP.CRITICAL_PHASE_DURATION), 'SUM', SUM(SP.CRITICAL_PHASE_DURATION), 'AVG', AVG(SP.CRITICAL_PHASE_DURATION)) / 1000000 CRITICAL_PHASE_S,
      MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(SP.TOTAL_SIZE), 'SUM', SUM(SP.TOTAL_SIZE), 'AVG', AVG(SP.TOTAL_SIZE)) / 1024 / 1024 SIZE_MB,
      MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(SP.FLUSHED_ROWSTORE_SIZE), 'SUM', SUM(SP.FLUSHED_ROWSTORE_SIZE), 'AVG', AVG(SP.FLUSHED_ROWSTORE_SIZE)) / 1024 / 1024 RS_SIZE_MB,
      MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(SP.FLUSHED_SIZE_IN_CRITICAL_PHASE), 'SUM', SUM(SP.FLUSHED_SIZE_IN_CRITICAL_PHASE), 'AVG', AVG(SP.FLUSHED_SIZE_IN_CRITICAL_PHASE)) / 1024 / 1024 CRIT_SIZE_MB,
      MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(SP.FLUSHED_PAGES_IN_CRITICAL_PHASE), 'SUM', SUM(SP.FLUSHED_PAGES_IN_CRITICAL_PHASE), 'AVG', AVG(SP.FLUSHED_PAGES_IN_CRITICAL_PHASE)) CRIT_PAGES,
      MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(SP.RETRY_COUNT), 'SUM', SUM(SP.RETRY_COUNT), 'AVG', AVG(SP.RETRY_COUNT)) RETRIES
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
        HOST,
        PORT,
        VERSION,
        TIMEZONE,
        MIN_BLOCKING_PHASE_DURATION_S,
        MIN_WAIT_FOR_LOCK_PHASE_DURATION_S,
        MIN_CRITICAL_PHASE_DURATION_S,
        MIN_SAVEPOINT_DURATION_S,
        MIN_WRITE_SIZE_GB,
        MIN_RETRY_COUNT,
        INITIATION,
        PURPOSE,
        DATA_SOURCE,
        AGGREGATION_TYPE,
        AGGREGATE_BY,
        MAP(TIME_AGGREGATE_BY,
          'NONE',        'YYYY/MM/DD HH24:MI:SS:FF7',
          'HOUR',        'YYYY/MM/DD HH24',
          'DAY',         'YYYY/MM/DD (DY)',
          'HOUR_OF_DAY', 'HH24',
          TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY
      FROM
      ( SELECT                                                         /* Modification section */
          '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
          '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
          'SERVER' TIMEZONE,                              /* SERVER, UTC */
          '%' HOST,
          '%' PORT,
          -1 VERSION,
          -1 MIN_BLOCKING_PHASE_DURATION_S,
          -1 MIN_WAIT_FOR_LOCK_PHASE_DURATION_S,
          -1 MIN_CRITICAL_PHASE_DURATION_S,
          -1 MIN_SAVEPOINT_DURATION_S,
          -1 MIN_WRITE_SIZE_GB,
          -1 MIN_RETRY_COUNT,
          '%' INITIATION,
          '%' PURPOSE,
          'HISTORY' DATA_SOURCE,                        /* CURRENT, HISTORY */
          'AVG' AGGREGATION_TYPE,                       /* MAX, AVG, SUM */
          'NONE' AGGREGATE_BY,         /* HOST, PORT, TIME, INITIATION, PURPOSE or comma separated combinations, NONE for no aggregation */
          'NONE' TIME_AGGREGATE_BY     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        FROM
          DUMMY
      )
    ) BI,
    ( SELECT
        'CURRENT' DATA_SOURCE,
        HOST,
        PORT,
        START_TIME,
        BLOCKING_PHASE_START_TIME,
        CRITICAL_PHASE_START_TIME,
        ADD_SECONDS(START_TIME, DURATION / 1000000) END_TIME,
        DURATION,
        CRITICAL_PHASE_WAIT_TIME WAIT_FOR_LOCK_DURATION,
        CRITICAL_PHASE_DURATION,
        CRITICAL_PHASE_WAIT_TIME + CRITICAL_PHASE_DURATION BLOCKING_PHASE_DURATION,
        TOTAL_SIZE,
        FLUSHED_ROWSTORE_SIZE,
        FLUSHED_SIZE_IN_CRITICAL_PHASE,
        FLUSHED_PAGES_IN_CRITICAL_PHASE,
        INITIATION,
        PURPOSE,
        VERSION,
        PREPARE_FLUSH_RETRY_COUNT RETRY_COUNT
      FROM
        M_SAVEPOINTS
      UNION ALL
      SELECT DISTINCT
        'HISTORY' DATA_SOURCE,
        HOST,
        PORT,
        START_TIME,
        BLOCKING_PHASE_START_TIME,
        CRITICAL_PHASE_START_TIME,
        ADD_SECONDS(START_TIME, DURATION / 1000000) END_TIME,
        DURATION,
        CRITICAL_PHASE_WAIT_TIME WAIT_FOR_LOCK_DURATION,
        CRITICAL_PHASE_DURATION,
        CRITICAL_PHASE_WAIT_TIME + CRITICAL_PHASE_DURATION BLOCKING_PHASE_DURATION,
        TOTAL_SIZE,
        FLUSHED_ROWSTORE_SIZE,
        FLUSHED_SIZE_IN_CRITICAL_PHASE,
        FLUSHED_PAGES_IN_CRITICAL_PHASE,
        INITIATION,
        PURPOSE,
        VERSION,
        PREPARE_FLUSH_RETRY_COUNT RETRY_COUNT
      FROM
        _SYS_STATISTICS.HOST_SAVEPOINTS
    ) SP
    WHERE 
      SP.HOST LIKE BI.HOST AND  
      TO_VARCHAR(SP.PORT) LIKE BI.PORT AND
      CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(SP.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE SP.START_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
      SP.INITIATION LIKE BI.INITIATION AND
      SP.PURPOSE LIKE BI.PURPOSE AND
      ( BI.VERSION = -1 OR SP.VERSION = BI.VERSION ) AND
      ( BI.MIN_BLOCKING_PHASE_DURATION_S = -1 OR SP.BLOCKING_PHASE_DURATION / 1000000 >= BI.MIN_BLOCKING_PHASE_DURATION_S) AND
      ( BI.MIN_WAIT_FOR_LOCK_PHASE_DURATION_S = -1 OR SP.WAIT_FOR_LOCK_DURATION / 1000000 >= BI.MIN_WAIT_FOR_LOCK_PHASE_DURATION_S ) AND
      ( BI.MIN_CRITICAL_PHASE_DURATION_S = -1 OR SP.CRITICAL_PHASE_DURATION / 1000000 >= BI.MIN_CRITICAL_PHASE_DURATION_S ) AND
      ( BI.MIN_SAVEPOINT_DURATION_S = -1 OR SP.DURATION / 1000000 >= BI.MIN_SAVEPOINT_DURATION_S ) AND
      ( BI.MIN_WRITE_SIZE_GB = -1 OR SP.TOTAL_SIZE / 1024 / 1024 / 1024 >= BI.MIN_WRITE_SIZE_GB ) AND
      ( BI.MIN_RETRY_COUNT = -1 OR SP.RETRY_COUNT >= BI.MIN_RETRY_COUNT ) AND
      SP.DATA_SOURCE = BI.DATA_SOURCE
    GROUP BY
      CASE 
        WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(SP.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE SP.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(SP.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE SP.START_TIME END, BI.TIME_AGGREGATE_BY)
          END
        ELSE 'any' 
      END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')       != 0 THEN SP.HOST             ELSE MAP(BI.HOST,       '%', 'any', BI.HOST)       END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')       != 0 THEN TO_VARCHAR(SP.PORT) ELSE MAP(BI.PORT,       '%', 'any', BI.PORT)       END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'INITIATION') != 0 THEN SP.INITIATION       ELSE MAP(BI.INITIATION, '%', 'any', BI.INITIATION) END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PURPOSE')    != 0 THEN SP.PURPOSE          ELSE MAP(BI.PURPOSE,    '%', 'any', BI.PURPOSE)    END,
      BI.AGGREGATION_TYPE
  )
)
ORDER BY
  START_TIME DESC,
  HOST,
  PORT
