SELECT

/*

[NAME]

- HANA_Services_Statistics_2.00.060+

[DESCRIPTION]

- HANA service information (CPU, memory, request processing)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- DELTA columns in HOST_SERVICE_STATISTICS available starting with SAP HANA 1.0 SPS 12
- REQUEST columns are related to a specific kind of internal TrexNet requests that can not be compared with database requests from client side
- SITE_ID in history tables available with SAP HANA >= 2.0 SPS 06
- PENDING_REQUEST_COUNT may be erroneously negative with SAP HANA <= 2.00.064 (bug 290293)

[VALID FOR]

- Revisions:              >= 2.00.060

[SQL COMMAND VERSION]

- 2015/03/11:  1.0 (initial version)
- 2016/06/25:  1.1 (BEGIN_TIME, END_TIME, EXEC_REQ and EXEQ_EXT_REQ added)
- 2016/12/31:  1.2 (TIME_AGGREGATE_BY = 'TS<seconds>' included)
- 2017/10/26:  1.3 (TIMEZONE included)
- 2018/01/07:  1.4 (dedicated 1.00.120+ version)
- 2018/02/28:  1.5 (OPEN_FILE_COUNT included)
- 2018/12/04:  1.6 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2022/05/26:  1.7 (dedicated 2.00.060+ version including SITE_ID for data source HISTORY)

[INVOLVED TABLES]

- M_SERVICE_STATISTICS
- HOST_SERVICE_STATISTICS

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

- SERVICE_NAME

  Service name

  'indexserver'   --> Specific service indexserver
  '%server'       --> All services ending with 'server'
  '%'             --> All services  

- MIN_CPUS_USED

  Minimum number of CPUs used

  10              --> Only show entries where in average at least 10 CPUs are used
  -1              --> No restriction in terms of CPU utilization

- MIN_RESPONSE_TIME_MS

  Minimum response time (ms)

  10              --> Only display entries with average response time of at least 10 ms
  -1              --> No restriction in terms of response time

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)
  '%'             --> All data sources

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

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'SIZE'          --> Sorting by size 
  'TABLE'         --> Sorting by table name

[OUTPUT PARAMETERS]

- ANALYSIS_TIME: Considered time frame
- ST:            System replication site ID
- HOST:          Host name
- PORT:          Port
- SERVICE:       Service name
- CPUS_USED:     Average number of CPUs used
- ALLOC_MEM_GB:  Average allocated memory (GB)
- ACT_REQ:       Average active requests
- PND_REQ:       Average pending requests
- ACT_THR:       Average active threads
- REQ_PER_S:     Average requests per second
- AVG_RESP_MS:   Average response time (ms)
- HANDLES:       Average open file handles

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------
|ANALYSIS_TIME   |HOST      |PORT |SERVICE_NAME|CPUS_USED|ALLOC_MEM_GB|ACT_REQ|PND_REQ|ACT_THR|REQ_PER_S|AVG_RESP_MS|
---------------------------------------------------------------------------------------------------------------------
|2015/03/11 (WED)|saphana156|30003|indexserver |    26.02|     1747.31|   1.62|   0.00|  28.50|     6.79|      41.90|
|2015/03/10 (TUE)|saphana156|30003|indexserver |    35.74|     1724.38|   1.18|   0.00|  31.52|     7.03|      43.66|
|2015/03/09 (MON)|saphana156|30003|indexserver |    66.80|     1674.86|   1.21|   0.00|  63.58|     6.98|      38.69|
|2015/03/08 (SUN)|saphana156|30003|indexserver |     4.09|     1565.66|   1.10|   0.00|   4.94|     9.42|      18.26|
|2015/03/07 (SAT)|saphana156|30003|indexserver |     4.45|     1806.60|   1.10|   0.00|   7.87|     7.79|      23.72|
|2015/03/06 (FRI)|saphana156|30003|indexserver |    49.78|     1916.92|   1.16|   0.00|  59.01|     6.96|      35.67|
|2015/03/05 (THU)|saphana156|30003|indexserver |    53.63|     1833.55|   1.30|   0.00|  60.09|     8.15|      33.42|
|2015/03/04 (WED)|saphana156|30003|indexserver |    56.68|     1625.03|   1.26|   0.00|  61.01|     8.61|      32.46|
|2015/03/03 (TUE)|saphana156|30003|indexserver |    17.15|     1438.55|   1.07|   0.00|  36.65|    17.64|      17.61|
|2015/03/03 (TUE)|saphana157|30003|indexserver |    41.81|     1425.45|   1.15|   0.00|  59.49|     6.43|      34.97|
|2015/03/02 (MON)|saphana156|30003|indexserver |    24.71|     1938.69|   1.45|   0.00|  24.27|    12.75|      19.37|
|2015/03/02 (MON)|saphana157|30003|indexserver |    58.19|     1404.45|   1.36|   0.02| 100.15|     6.58|      51.62|
---------------------------------------------------------------------------------------------------------------------
*/

  ANALYSIS_TIME,
  IFNULL(LPAD(SITE_ID, 2), '') ST,
  HOST,
  LPAD(PORT, 5) PORT,
  SERVICE_NAME SERVICE,
  LPAD(TO_DECIMAL(CPUS_USED, 10, 2), 9) CPUS_USED,
  LPAD(TO_DECIMAL(ALLOC_MEM_GB, 10, 2), 12) ALLOC_MEM_GB,
  LPAD(TO_DECIMAL(ACT_REQ, 10, 2), 7) ACT_REQ,
  LPAD(TO_DECIMAL(PND_REQ, 10, 2), 7) PND_REQ,
  LPAD(TO_DECIMAL(ROUND(EXEC_REQ), 10, 0), 8) EXEC_REQ,
  LPAD(TO_DECIMAL(ROUND(EXEC_EXT_REQ), 12, 0), 12) EXEC_EXT_REQ,
  LPAD(TO_DECIMAL(ACT_THR, 10, 2), 7) ACT_THR,
  LPAD(TO_DECIMAL(REQ_PER_S, 10, 2), 9) REQ_PER_S,
  LPAD(TO_DECIMAL(AVG_RESP_MS, 10, 2), 11) AVG_RESP_MS,
  LPAD(TO_DECIMAL(HANDLES, 10, 0), 7) HANDLES
FROM
( SELECT
    ANALYSIS_TIME,
    SITE_ID,
    HOST,
    PORT,
    SERVICE_NAME,
    CPUS_USED,
    ALLOC_MEM_GB,
    REQ_PER_S,
    ACT_REQ,
    PND_REQ,
    EXEC_REQ,
    EXEC_EXT_REQ,
    ACT_THR,
    HANDLES,
    AVG_RESP_MS,
    ROW_NUMBER () OVER (ORDER BY MAP(ORDER_BY, 'TIME', ANALYSIS_TIME) DESC, HOST, PORT) ROW_NUM
  FROM
  ( SELECT
      ANALYSIS_TIME,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SITE_ID') != 0 THEN TO_VARCHAR(SITE_ID) ELSE MAP(BI_SITE_ID,       -1, 'any', TO_VARCHAR(BI_SITE_ID)) END SITE_ID,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST')    != 0 THEN HOST                ELSE MAP(BI_HOST,         '%', 'any', BI_HOST)                END HOST,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(PORT)    ELSE MAP(BI_PORT,         '%', 'any', BI_PORT)                END PORT,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SERVICE') != 0 THEN SERVICE_NAME        ELSE MAP(BI_SERVICE_NAME, '%', 'any', BI_SERVICE_NAME)        END SERVICE_NAME,
      SUM(CPUS_USED) CPUS_USED,
      SUM(ALLOC_MEM_GB) ALLOC_MEM_GB,
      SUM(REQ_PER_S) REQ_PER_S,
      SUM(ACT_REQ) ACT_REQ,
      SUM(PND_REQ) PND_REQ,
      SUM(EXEC_REQ) EXEC_REQ,
      SUM(EXEC_EXT_REQ) EXEC_EXT_REQ,
      SUM(ACT_THR) ACT_THR,
      SUM(HANDLES) HANDLES,
      SUM(AVG_RESP_MS) AVG_RESP_MS,
      ORDER_BY,
      MIN_CPUS_USED,
      MIN_RESPONSE_TIME_MS
    FROM
    ( SELECT
        CASE 
          WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
            CASE 
              WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
                TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
                'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(S.ANALYSIS_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE S.ANALYSIS_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
              ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(S.ANALYSIS_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE S.ANALYSIS_TIME END, BI.TIME_AGGREGATE_BY)
            END
          ELSE 'any' 
        END ANALYSIS_TIME,
        S.SITE_ID,
        S.HOST,
        S.PORT,
        S.SERVICE_NAME,
        AVG(S.CPUS_USED) CPUS_USED,
        AVG(S.ALLOC_MEM_GB) ALLOC_MEM_GB,
        AVG(S.REQUESTS_PER_SEC) REQ_PER_S,
        AVG(S.ACTIVE_REQUEST_COUNT) ACT_REQ,
        AVG(S.PENDING_REQUEST_COUNT) PND_REQ,
        SUM(S.FINISHED_REQUESTS) EXEC_REQ,
        SUM(S.FINISHED_EXT_REQUESTS) EXEC_EXT_REQ,
        AVG(S.ACTIVE_THREAD_COUNT) ACT_THR,
        AVG(S.OPEN_FILE_COUNT) HANDLES,
        AVG(S.RESPONSE_TIME) AVG_RESP_MS,
        BI.AGGREGATE_BY,
        BI.SITE_ID BI_SITE_ID,
        BI.HOST BI_HOST,
        BI.PORT BI_PORT,
        BI.SERVICE_NAME BI_SERVICE_NAME,
        BI.ORDER_BY,
        BI.MIN_CPUS_USED,
        BI.MIN_RESPONSE_TIME_MS
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
          SERVICE_NAME,
          MIN_CPUS_USED,
          MIN_RESPONSE_TIME_MS,
          DATA_SOURCE,
          AGGREGATE_BY,
          MAP(TIME_AGGREGATE_BY,
            'NONE',        'YYYY/MM/DD HH24:MI:SS',
            'HOUR',        'YYYY/MM/DD HH24',
            'DAY',         'YYYY/MM/DD (DY)',
            'HOUR_OF_DAY', 'HH24',
            TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
          ORDER_BY
        FROM
        ( SELECT              /* Modification section */
            '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
            '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
            'SERVER' TIMEZONE,                              /* SERVER, UTC */
            -1 SITE_ID,
            '%' HOST,
            '%03' PORT,
            '%' SERVICE_NAME,
            -1 MIN_CPUS_USED,
            -1 MIN_RESPONSE_TIME_MS,
            'HISTORY' DATA_SOURCE,                      /* CURRENT, HISTORY */
            'NONE' AGGREGATE_BY,          /* SITE_ID, HOST, PORT, SERVICE, TIME or comma separated combinations, NONE for no aggregation */
            'TS900' TIME_AGGREGATE_BY,    /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
            'TIME' ORDER_BY               /* TIME, HOST */
          FROM
            DUMMY
        ) 
      ) BI,
      ( SELECT
          'CURRENT' DATA_SOURCE,
          CURRENT_TIMESTAMP ANALYSIS_TIME,
          CURRENT_SITE_ID() SITE_ID,
          HOST,
          PORT,
          SERVICE_NAME,
          MAP(SECONDS_BETWEEN(START_TIME, CURRENT_TIMESTAMP), 0, 0, PROCESS_CPU_TIME / SECONDS_BETWEEN(START_TIME, CURRENT_TIMESTAMP) / 1000) CPUS_USED,
          PROCESS_MEMORY / 1024 / 1024 / 1024 ALLOC_MEM_GB,
          REQUESTS_PER_SEC,
          ACTIVE_REQUEST_COUNT,
          PENDING_REQUEST_COUNT,
          ALL_FINISHED_REQUEST_COUNT FINISHED_REQUESTS,
          FINISHED_NON_INTERNAL_REQUEST_COUNT FINISHED_EXT_REQUESTS,
          ACTIVE_THREAD_COUNT,
          OPEN_FILE_COUNT,
          RESPONSE_TIME
        FROM
          M_SERVICE_STATISTICS S
        UNION ALL
        ( SELECT
            'HISTORY' DATA_SOURCE,
            SERVER_TIMESTAMP ANALYSIS_TIME,
            SITE_ID,
            HOST,
            PORT,
            SERVICE_NAME,
            MAP(SECONDS, 0, 0, PROCESS_CPU_TIME / SECONDS / 1000) CPUS_USED,
            PROCESS_MEMORY / 1024 / 1024 / 1024 ALLOC_MEM_GB,
            REQUESTS_PER_SEC,
            ACTIVE_REQUEST_COUNT,
            PENDING_REQUEST_COUNT,
            FINISHED_REQUESTS,
            FINISHED_EXT_REQUESTS,
            ACTIVE_THREAD_COUNT,
            OPEN_FILE_COUNT,
            RESPONSE_TIME
          FROM
          ( SELECT
              SERVER_TIMESTAMP,
              SITE_ID,
              HOST,
              PORT,
              SERVICE_NAME,
              PROCESS_CPU_TIME_DELTA PROCESS_CPU_TIME,
              SNAPSHOT_DELTA SECONDS,
              PROCESS_MEMORY,
              REQUESTS_PER_SEC,
              ACTIVE_REQUEST_COUNT,
              PENDING_REQUEST_COUNT,
              ALL_FINISHED_REQUEST_COUNT_DELTA FINISHED_REQUESTS,
              FINISHED_NON_INTERNAL_REQUEST_COUNT_DELTA FINISHED_EXT_REQUESTS,
              ACTIVE_THREAD_COUNT,
              OPEN_FILE_COUNT,
              RESPONSE_TIME
            FROM
              _SYS_STATISTICS.HOST_SERVICE_STATISTICS
          ) S
        ) 
      ) S 
      WHERE
        CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(S.ANALYSIS_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE S.ANALYSIS_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
        ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND S.SITE_ID IN (-1, 0) ) OR S.SITE_ID = BI.SITE_ID ) AND
        S.HOST LIKE BI.HOST AND
        TO_VARCHAR(S.PORT) LIKE BI.PORT AND
        S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
        S.DATA_SOURCE = BI.DATA_SOURCE
      GROUP BY
        CASE 
          WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
            CASE 
              WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
                TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
                'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(S.ANALYSIS_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE S.ANALYSIS_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
              ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(S.ANALYSIS_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE S.ANALYSIS_TIME END, BI.TIME_AGGREGATE_BY)
            END
          ELSE 'any' 
        END,
        S.SITE_ID,
        S.HOST,
        S.PORT,
        S.SERVICE_NAME,
        BI.AGGREGATE_BY,
        BI.SITE_ID,
        BI.HOST,
        BI.PORT,
        BI.SERVICE_NAME,
        BI.ORDER_BY,
        BI.MIN_CPUS_USED,
        BI.MIN_RESPONSE_TIME_MS
    )
    GROUP BY
      ANALYSIS_TIME,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SITE_ID') != 0 THEN TO_VARCHAR(SITE_ID) ELSE MAP(BI_SITE_ID,       -1, 'any', TO_VARCHAR(BI_SITE_ID)) END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST')    != 0 THEN HOST                ELSE MAP(BI_HOST,         '%', 'any', BI_HOST)                END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(PORT)    ELSE MAP(BI_PORT,         '%', 'any', BI_PORT)                END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SERVICE') != 0 THEN SERVICE_NAME        ELSE MAP(BI_SERVICE_NAME, '%', 'any', BI_SERVICE_NAME)        END,
      ORDER_BY,
      MIN_CPUS_USED,
      MIN_RESPONSE_TIME_MS
  )
  WHERE
    ( MIN_RESPONSE_TIME_MS = -1 OR AVG_RESP_MS >= MIN_RESPONSE_TIME_MS ) AND
    ( MIN_CPUS_USED = -1 OR CPUS_USED >= MIN_CPUS_USED )
)
ORDER BY
  ROW_NUM