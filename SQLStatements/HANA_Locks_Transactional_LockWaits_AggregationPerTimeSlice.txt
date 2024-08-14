SELECT

/* 

[NAME]

- HANA_Locks_Transactional_LockWaits_AggregationPerTimeSlice

[DESCRIPTION]

- Aggregation of transactional lock waits on time slice basis (1 row with top areas per time interval)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              any

[SQL COMMAND VERSION]

- 2020/12/18:  1.0 (initial version)

[INVOLVED TABLES]

- HOST_BLOCKED_TRANSACTIONS

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
  'saphana%'      --> All hosts starting with 'saphana'
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

- LOCK_MODE

  Transactional lock mode

  'EXCLUSIVE'   --> Display locks with mode EXCLUSIVE
  '%'             --> No restriction related to lock mode

- LOCK_TYPE

  Transactional lock type

  'RECORD_LOCK'   --> Display locks with type RECORD_LOCK
  '%'             --> No restriction related to lock type

- BLOCKED_STATEMENT_HASH      
 
  Hash of blocked SQL statement

  '2e960d7535bf4134e2bd26b9d80bd4fa' --> SQL statement with hash '2e960d7535bf4134e2bd26b9d80bd4fa'
  '%'                                --> No statement hash restriction

- MIN_SAMPLES_TOTAL

  Minimum threshold for total samples

  10              --> Only display time slices with at least 10 total samples
  -1              --> No restriction related to total samples

- MIN_LOCK_WAIT_TIME_S

  Minimum lock duration time in seconds

  100             --> Minimum lock duration time of 100 s
  -1              --> No restriction of minimum duration time

- TIME_SLICE_S

  Time intervals for aggregation

  10              --> Aggregation on a 10 seconds basis
  900             --> Aggregation on a 15 minutes basis

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOST'          --> Aggregation by HOST

[OUTPUT PARAMETERS]

- SAMPLE_TIME:   Begin time of considered time interval
- KEY_FIGURE:    Key figure for which the top areas are determined
- SAMPLES_TOTAL: Total number of lock waits
- DETAIL_<n>:    Top <n> area
- SAMPLES_<n>:   Number of lock waits for top <n> area
- PCT_<n>:       Percentage of top <n> area compared to overall value

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------
|SNAPSHOT_TIME      |KEY_FIGURE|SAMPLES_TOTAL|DETAIL_1  |SAMPLES_1|PCT_1|DETAIL_2        |SAMPLES_2|PCT_2|DETAIL_3        |SAMPLES_3|PCT_3|
-------------------------------------------------------------------------------------------------------------------------------------------
|2020/12/18 09:00:00|TABLE     |          615|ARFCRSTATE|      456|   74|NRIV            |      106|   17|FEBIP           |       19|    3|
|2020/12/18 08:00:00|TABLE     |          537|ARFCRSTATE|      385|   72|NRIV            |      127|   24|CKMLPP          |       11|    2|
|2020/12/18 07:00:00|TABLE     |         2705|NRIV      |     2530|   94|ARFCRSTATE      |      133|    5|CKMLPP          |       41|    2|
|2020/12/18 06:00:00|TABLE     |         1640|NRIV      |     1550|   95|CKMLPP          |       88|    5|USR02           |        1|    0|
|2020/12/18 05:00:00|TABLE     |          124|CKMLPP    |      106|   85|REPOSRC         |        9|    7|NRIV            |        7|    6|
|2020/12/18 04:00:00|TABLE     |          971|CKMLPP    |      852|   88|NRIV            |       58|    6|/SDF/SMON_WPINFO|       36|    4|
|2020/12/18 03:00:00|TABLE     |          170|CKMLPP    |      115|   68|/SDF/SMON_WPINFO|       44|   26|NRIV            |       10|    6|
|2020/12/18 02:00:00|TABLE     |          324|CKMLPP    |      213|   66|S009            |      102|   31|ESH_EX_CPOINTER |        8|    2|
|2020/12/18 01:00:00|TABLE     |         1396|S009      |     1364|   98|CKMLPP          |       27|    2|NRIV            |        5|    0|
|2020/12/18 00:00:00|TABLE     |         1053|S009      |     1035|   98|CKMLPP          |       18|    2|                |         |     |
-------------------------------------------------------------------------------------------------------------------------------------------

*/

  SNAPSHOT_TIME,
  KEY_FIGURE,
  SAMPLES_TOTAL,
  DETAIL_1,
  SAMPLES_1,
  PCT_1,
  DETAIL_2,
  SAMPLES_2,
  PCT_2,
  DETAIL_3,
  SAMPLES_3,
  PCT_3,
  DETAIL_4,
  SAMPLES_4,
  PCT_4,
  DETAIL_5,
  SAMPLES_5,
  PCT_5,
  DETAIL_6,
  SAMPLES_6,
  PCT_6,
  DETAIL_7,
  SAMPLES_7,
  PCT_7,
  DETAIL_8,
  SAMPLES_8,
  PCT_8,
  DETAIL_9,
  SAMPLES_9,
  PCT_9,
  DETAIL10,
  SAMPLES10,
  PCT10
FROM
( SELECT
    DISTINCT
    SNAPSHOT_TIME,
    KEY_FIGURE,
    SAMPLES_TOTAL,
    IFNULL(TO_VARCHAR(MAX(DETAIL_1)), '') DETAIL_1,
    IFNULL(LPAD(MAX(SAMPLES_1), 9), '') SAMPLES_1,
    IFNULL(LPAD(MAX(PCT_1), 5), '') PCT_1,
    IFNULL(TO_VARCHAR(MAX(DETAIL_2)), '') DETAIL_2,
    IFNULL(LPAD(MAX(SAMPLES_2), 9), '') SAMPLES_2,
    IFNULL(LPAD(MAX(PCT_2), 5), '') PCT_2,
    IFNULL(TO_VARCHAR(MAX(DETAIL_3)), '') DETAIL_3,
    IFNULL(LPAD(MAX(SAMPLES_3), 9), '') SAMPLES_3,
    IFNULL(LPAD(MAX(PCT_3), 5), '') PCT_3,
    IFNULL(TO_VARCHAR(MAX(DETAIL_4)), '') DETAIL_4,
    IFNULL(LPAD(MAX(SAMPLES_4), 9), '') SAMPLES_4,
    IFNULL(LPAD(MAX(PCT_4), 5), '') PCT_4,
    IFNULL(TO_VARCHAR(MAX(DETAIL_5)), '') DETAIL_5,
    IFNULL(LPAD(MAX(SAMPLES_5), 9), '') SAMPLES_5,
    IFNULL(LPAD(MAX(PCT_5), 5), '') PCT_5,
    IFNULL(TO_VARCHAR(MAX(DETAIL_6)), '') DETAIL_6,
    IFNULL(LPAD(MAX(SAMPLES_6), 9), '') SAMPLES_6,
    IFNULL(LPAD(MAX(PCT_6), 5), '') PCT_6,
    IFNULL(TO_VARCHAR(MAX(DETAIL_7)), '') DETAIL_7,
    IFNULL(LPAD(MAX(SAMPLES_7), 9), '') SAMPLES_7,
    IFNULL(LPAD(MAX(PCT_7), 5), '') PCT_7,
    IFNULL(TO_VARCHAR(MAX(DETAIL_8)), '') DETAIL_8,
    IFNULL(LPAD(MAX(SAMPLES_8), 9), '') SAMPLES_8,
    IFNULL(LPAD(MAX(PCT_8), 5), '') PCT_8,
    IFNULL(TO_VARCHAR(MAX(DETAIL_9)), '') DETAIL_9,
    IFNULL(LPAD(MAX(SAMPLES_9), 9), '') SAMPLES_9,
    IFNULL(LPAD(MAX(PCT_9), 5), '') PCT_9,
    IFNULL(TO_VARCHAR(MAX(DETAIL_10)), '') DETAIL10,
    IFNULL(LPAD(MAX(SAMPLES_10), 9), '') SAMPLES10,
    IFNULL(LPAD(MAX(PCT_10), 5), '') PCT10,
    ROW_NUMBER () OVER (ORDER BY SNAPSHOT_TIME DESC) ROWNO,
    MIN_SAMPLES_TOTAL
  FROM
  ( SELECT DISTINCT
      TO_VARCHAR(SNAPSHOT_TIME, 'YYYY/MM/DD HH24:MI:SS') SNAPSHOT_TIME,
      AGGREGATE_BY KEY_FIGURE,
      LPAD(SUM(NUM_SAMPLES) OVER (PARTITION BY SNAPSHOT_TIME), 13) SAMPLES_TOTAL,
      NTH_VALUE(VALUE, 1) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) DETAIL_1,
      NTH_VALUE(NUM_SAMPLES, 1) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) SAMPLES_1,
      TO_DECIMAL(ROUND(NTH_VALUE(PERCENT, 1) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC)), 10, 0) PCT_1,
      NTH_VALUE(VALUE, 2) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) DETAIL_2,
      NTH_VALUE(NUM_SAMPLES, 2) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) SAMPLES_2,
      TO_DECIMAL(ROUND(NTH_VALUE(PERCENT, 2) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC)), 10, 0) PCT_2,
      NTH_VALUE(VALUE, 3) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) DETAIL_3,
      NTH_VALUE(NUM_SAMPLES, 3) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) SAMPLES_3,
      TO_DECIMAL(ROUND(NTH_VALUE(PERCENT, 3) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC)), 10, 0) PCT_3,
      NTH_VALUE(VALUE, 4) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) DETAIL_4,
      NTH_VALUE(NUM_SAMPLES, 4) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) SAMPLES_4,
      TO_DECIMAL(ROUND(NTH_VALUE(PERCENT, 4) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC)), 10, 0) PCT_4,
      NTH_VALUE(VALUE, 5) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) DETAIL_5,
      NTH_VALUE(NUM_SAMPLES, 5) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) SAMPLES_5,
      TO_DECIMAL(ROUND(NTH_VALUE(PERCENT, 5) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC)), 10, 0) PCT_5,
      NTH_VALUE(VALUE, 6) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) DETAIL_6,
      NTH_VALUE(NUM_SAMPLES, 6) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) SAMPLES_6,
      TO_DECIMAL(ROUND(NTH_VALUE(PERCENT, 6) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC)), 10, 0) PCT_6,
      NTH_VALUE(VALUE, 7) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) DETAIL_7,
      NTH_VALUE(NUM_SAMPLES, 7) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) SAMPLES_7,
      TO_DECIMAL(ROUND(NTH_VALUE(PERCENT, 7) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC)), 10, 0) PCT_7,
      NTH_VALUE(VALUE, 8) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) DETAIL_8,
      NTH_VALUE(NUM_SAMPLES, 8) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) SAMPLES_8,
      TO_DECIMAL(ROUND(NTH_VALUE(PERCENT, 8) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC)), 10, 0) PCT_8,
      NTH_VALUE(VALUE, 9) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) DETAIL_9,
      NTH_VALUE(NUM_SAMPLES, 9) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) SAMPLES_9,
      TO_DECIMAL(ROUND(NTH_VALUE(PERCENT, 9) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC)), 10, 0) PCT_9,
      NTH_VALUE(VALUE, 10) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) DETAIL_10,
      NTH_VALUE(NUM_SAMPLES, 10) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC) SAMPLES_10,
      TO_DECIMAL(ROUND(NTH_VALUE(PERCENT, 10) OVER (PARTITION BY SNAPSHOT_TIME ORDER BY NUM_SAMPLES DESC)), 10, 0) PCT_10,
      MIN_SAMPLES_TOTAL
    FROM
    ( SELECT
        SNAPSHOT_TIME,
        AGGREGATE_BY,
        VALUE,
        COUNT(*) NUM_SAMPLES,
        COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY SNAPSHOT_TIME) * 100 PERCENT,
        MIN_SAMPLES_TOTAL
      FROM
      ( SELECT
          ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), 
            FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(B.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE B.SERVER_TIMESTAMP END) / BI.TIME_SLICE_S) * BI.TIME_SLICE_S) SNAPSHOT_TIME,
          MAP(BI.AGGREGATE_BY,
            'HOST',                B.HOST,
            'PORT',                TO_VARCHAR(B.PORT),
            'SCHEMA',              B.WAITING_SCHEMA_NAME,
            'TABLE',               B.WAITING_OBJECT_NAME,
            'TYPE',                B.LOCK_TYPE,
            'MODE',                B.LOCK_MODE,
            'BLOCKING_HOST_PID',   B.LOCK_OWNER_HOST || CHAR(32) || '/' || CHAR(32) || B.LOCK_OWNER_PID,
            'BLOCKING_UTID',       B.LOCK_OWNER_UPDATE_TRANSACTION_ID,
            'BLOCKING_CONN_ID',    B.LOCK_OWNER_CONNECTION_ID,
            'BLOCKING_APP_USER',   B.LOCK_OWNER_APPLICATION_USER,
            'BLOCKING_APP_SOURCE', B.LOCK_OWNER_APPLICATION_SOURCE,
            'BLOCKING_APP_NAME',   B.LOCK_OWNER_APPLICATION,
            'BLOCKING_HASH',       B.LOCK_OWNER_STATEMENT_HASH) VALUE,
          BI.AGGREGATE_BY,
          BI.MIN_SAMPLES_TOTAL,
          BI.TIME_SLICE_S
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
            HOST,
            PORT,
            LOCK_MODE,
            LOCK_TYPE,
            SCHEMA_NAME,
            TABLE_NAME,
            BLOCKED_STATEMENT_HASH,
            MIN_SAMPLES_TOTAL,
            MIN_WAIT_TIME_S,
            TIME_SLICE_S,
            AGGREGATE_BY
          FROM
          ( SELECT                                                      /* Modification section */
              '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
              '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
              'SERVER' TIMEZONE,                              /* SERVER, UTC */
              '%' HOST,
              '%' PORT,
              '%' SCHEMA_NAME,
              '%' TABLE_NAME,
              '%' LOCK_MODE,
              '%' LOCK_TYPE,
              '%' BLOCKED_STATEMENT_HASH,
              -1  MIN_SAMPLES_TOTAL,
              -1  MIN_WAIT_TIME_S,
              600 TIME_SLICE_S,
              'TABLE' AGGREGATE_BY     /* TIME, HOST, PORT, SCHEMA, TABLE, TYPE, MODE, BLOCKING_HOST_PID, BLOCKING_UTID, BLOCKING_CONN_ID, BLOCKING_APP_USER, BLOCKING_APP_SOURCE, BLOCKING_APP_NAME,
                                         BLOCKING_HASH */
            FROM
              DUMMY
          )
        ) BI,
          _SYS_STATISTICS.HOST_BLOCKED_TRANSACTIONS B
        WHERE
          B.HOST LIKE BI.HOST AND
          TO_VARCHAR(B.PORT) LIKE BI.PORT AND
          CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(B.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE B.SERVER_TIMESTAMP END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
          B.LOCK_MODE LIKE BI.LOCK_MODE AND
          B.LOCK_TYPE LIKE BI.LOCK_TYPE AND
          B.WAITING_SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
          B.WAITING_OBJECT_NAME LIKE BI.TABLE_NAME AND
          B.BLOCKED_STATEMENT_HASH LIKE BI.BLOCKED_STATEMENT_HASH AND
          ( BI.MIN_WAIT_TIME_S = -1 OR B.WAITING_MINUTES * 60 >= BI.MIN_WAIT_TIME_S )
      )
      GROUP BY
        SNAPSHOT_TIME,
        VALUE,
        AGGREGATE_BY,
        MIN_SAMPLES_TOTAL,
        TIME_SLICE_S
    )
  )
  GROUP BY
    SNAPSHOT_TIME,
    KEY_FIGURE,
    SAMPLES_TOTAL,
    MIN_SAMPLES_TOTAL
)
WHERE
  ( MIN_SAMPLES_TOTAL = -1 OR SAMPLES_TOTAL >= MIN_SAMPLES_TOTAL )
ORDER BY
  SNAPSHOT_TIME DESC
