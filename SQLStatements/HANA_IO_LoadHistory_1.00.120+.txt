SELECT
/* 

[NAME]

- HANA_IO_LoadHistory_1.00.120+

[DESCRIPTION]

- I/O read and write information (being part of load history)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Traditionally collected in nameserver_history.trc and display in "Performance" -> "Load" in SAP HANA Studio
- Displayed figures (duration and volume) are generally total values
- M_LOAD_HISTORY_SERVICE available with SAP HANA >= 1.00.90
- HOST_LOAD_HISTORY_SERVICE and I/O related columns available with SAP HANA >= 1.00.120

[VALID FOR]

- Revisions:              >= 1.00.120

[SQL COMMAND VERSION]

- 2019/04/12:  1.0 (initial version)

[INVOLVED TABLES]

- M_LOAD_HISTORY_SERVICE
- HOST_LOAD_HISTORY_SERVICE

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

- EXCLUDE_STANDBY

  Possibility to exclude standby node

  'X'             --> Exclude standby nodes (based on current standby node, no history available)
  ' '             --> No exclusion of standby nodes

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)

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

- SNAPSHOT_TIME: Start time of considered time interval
- HOST:          Host name
- PORT:          Port
- D_RD_MB:       Data read volume (MB)
- D_RD_S:        Data read duration (s)
- D_RD_MBPS:     Data read throughput (MB/s)
- D_WR_MB:       Data write volume (MB)
- D_WR_S:        Data write duration (s)
- D_WR_MBPS:     Data write throughput (MB/s)
- L_RD_MB:       Log read volume (MB)
- L_RD_S:        Log read duration (s)
- L_RD_MBPS:     Log read throughput (MB/s)
- L_WR_MB:       Log write volume (MB)
- L_WR_S:        Log write duration (s)
- L_WR_MBPS:     Log write throughput (MB/s)
- DB_WR_MB:      Data backup write volume (MB)
- DB_WR_S:       Data backup write duration (s)
- DB_WR_MBPS:    Data backup write throughput (MB/s)
- LB_WR_MB:      Log backup write volume (MB)
- LB_WR_S:       Log backup write duration (s)
- LB_WR_MBPS:    Log backup write throughput (MB/s)

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SNAPSHOT_TIME      |HOST   |PORT |D_RD_MB|D_RD_S|D_RD_MBPS|D_WR_MB|D_WR_S|D_WR_MBPS|L_RD_MB|L_RD_S|L_RD_MBPS|L_WR_MB|L_WR_S|L_WR_MBPS|DB_WR_MB|DB_WR_S|DB_WR_MBPS|LB_WR_MB|LB_WR_S|LB_WR_MBPS|
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2019/04/12 07:59:00|saphana|  any|   2267|     7|   331.36|   6419|     2|  3121.98|    768|     0|  3268.90|    171|     2|    84.06|       0|      0|      0.00|       0|      0|      0.00|
|2019/04/12 07:58:00|saphana|  any|      1|     0|     3.04|    468|     0|  1115.88|    256|     0|  2210.63|    380|     5|    74.95|       0|      0|      0.00|       0|      0|      0.00|
|2019/04/12 07:57:00|saphana|  any|      4|     2|     1.93|  13285|     7|  2001.28|      0|     0|     0.00|    483|     7|    73.13|       0|      0|      0.00|       0|      0|      0.00|
|2019/04/12 07:56:00|saphana|  any|     31|     0|    72.55|   1816|     2|  1145.19|   1024|     0|  2780.39|    519|     6|    87.85|       0|      0|      0.00|       0|      0|      0.00|
|2019/04/12 07:55:00|saphana|  any|      3|     0|    31.23|   1059|     2|   624.95|      0|     0|     0.00|    441|     6|    76.30|       0|      0|      0.00|       0|      0|      0.00|
|2019/04/12 07:54:00|saphana|  any|     30|     1|    54.32|   2038|     1|  1582.10|   1024|     0|  3566.68|    478|     6|    76.94|       0|      0|      0.00|       0|      0|      0.00|
|2019/04/12 07:53:00|saphana|  any|    967|     3|   314.60|   7066|     3|  2123.28|      0|     0|     0.00|    478|     4|   107.23|       0|      0|      0.00|       0|      0|      0.00|
|2019/04/12 07:52:00|saphana|  any|   6273|    24|   266.52|  13485|     6|  2163.82|   1024|     0|  3037.37|    347|     5|    72.36|       0|      0|      0.00|       0|      0|      0.00|
|2019/04/12 07:51:00|saphana|  any|      2|     1|     3.13|   1068|     1|   853.04|      0|     0|     0.00|    507|     4|   117.05|       0|      0|      0.00|       0|      0|      0.00|
|2019/04/12 07:50:00|saphana|  any|     35|     3|    10.08|  17608|     9|  1984.86|   1024|     0|  2725.54|    638|     6|   100.95|       0|      0|      0.00|       0|      0|      0.00|
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  SAMPLE_TIME SNAPSHOT_TIME,
  HOST,
  LPAD(PORT, 5) PORT,
  LPAD(TO_DECIMAL(GREATEST(0, ROUND(DATA_READ_MB)),         10, 0), 8)  D_RD_MB,
  LPAD(TO_DECIMAL(GREATEST(0, ROUND(DATA_READ_S)),          10, 0), 6)  D_RD_S,
  LPAD(TO_DECIMAL(GREATEST(0, D_RD_MBPS),                   10, 2), 9)  D_RD_MBPS,
  LPAD(TO_DECIMAL(GREATEST(0, ROUND(DATA_WRITE_MB)),        10, 0), 8)  D_WR_MB,
  LPAD(TO_DECIMAL(GREATEST(0, ROUND(DATA_WRITE_S)),         10, 0), 6)  D_WR_S,
  LPAD(TO_DECIMAL(GREATEST(0, D_WR_MBPS),                   10, 2), 9)  D_WR_MBPS,
  LPAD(TO_DECIMAL(GREATEST(0, ROUND(LOG_READ_MB)),          10, 0), 8)  L_RD_MB,
  LPAD(TO_DECIMAL(GREATEST(0, ROUND(LOG_READ_S)),           10, 0), 6)  L_RD_S,
  LPAD(TO_DECIMAL(GREATEST(0, L_RD_MBPS),                   10, 2), 9)  L_RD_MBPS,
  LPAD(TO_DECIMAL(GREATEST(0, ROUND(LOG_WRITE_MB)),         10, 0), 8)  L_WR_MB,
  LPAD(TO_DECIMAL(GREATEST(0, ROUND(LOG_WRITE_S)),          10, 0), 6)  L_WR_S,
  LPAD(TO_DECIMAL(GREATEST(0, L_WR_MBPS),                   10, 2), 9)  L_WR_MBPS,
  LPAD(TO_DECIMAL(GREATEST(0, ROUND(DATA_BACKUP_WRITE_MB)), 10, 0), 8)  DB_WR_MB,
  LPAD(TO_DECIMAL(GREATEST(0, ROUND(DATA_BACKUP_WRITE_S)),  10, 0), 7)  DB_WR_S,
  LPAD(TO_DECIMAL(GREATEST(0, DB_WR_MBPS),                  10, 2), 10) DB_WR_MBPS,
  LPAD(TO_DECIMAL(GREATEST(0, ROUND(LOG_BACKUP_WRITE_MB)),  10, 0), 8)  LB_WR_MB,
  LPAD(TO_DECIMAL(GREATEST(0, ROUND(LOG_BACKUP_WRITE_S)),   10, 0), 7)  LB_WR_S,
  LPAD(TO_DECIMAL(GREATEST(0, LB_WR_MBPS),                  10, 2), 10) LB_WR_MBPS
FROM
( SELECT
    SAMPLE_TIME,
    HOST,
    PORT,
    DATA_READ_MB,
    DATA_READ_S,
    DATA_WRITE_MB,
    DATA_WRITE_S,
    LOG_READ_MB,
    LOG_READ_S,
    LOG_WRITE_MB,
    LOG_WRITE_S,
    DATA_BACKUP_WRITE_MB,
    DATA_BACKUP_WRITE_S,
    LOG_BACKUP_WRITE_MB,
    LOG_BACKUP_WRITE_S,
    MAP(DATA_READ_S,         0, 0, DATA_READ_MB         / DATA_READ_S)         D_RD_MBPS,
    MAP(DATA_WRITE_S,        0, 0, DATA_WRITE_MB        / DATA_WRITE_S)        D_WR_MBPS,
    MAP(LOG_READ_S,          0, 0, LOG_READ_MB          / LOG_READ_S)          L_RD_MBPS,
    MAP(LOG_WRITE_S,         0, 0, LOG_WRITE_MB         / LOG_WRITE_S)         L_WR_MBPS,
    MAP(DATA_BACKUP_WRITE_S, 0, 0, DATA_BACKUP_WRITE_MB / DATA_BACKUP_WRITE_S) DB_WR_MBPS,
    MAP(LOG_BACKUP_WRITE_S,  0, 0, LOG_BACKUP_WRITE_MB  / LOG_BACKUP_WRITE_S)  LB_WR_MBPS
  FROM
  ( SELECT
      SAMPLE_TIME,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST') != 0 THEN HOST ELSE MAP(BI_HOST, '%', 'any', BI_HOST) END HOST,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT') != 0 THEN TO_VARCHAR(PORT) ELSE MAP(BI_PORT, '%', 'any', BI_PORT) END PORT,
      SUM(DATA_READ_MB) DATA_READ_MB,
      SUM(DATA_READ_S) DATA_READ_S,
      SUM(DATA_WRITE_MB) DATA_WRITE_MB,
      SUM(DATA_WRITE_S) DATA_WRITE_S,
      SUM(LOG_READ_MB) LOG_READ_MB,
      SUM(LOG_READ_S) LOG_READ_S,
      SUM(LOG_WRITE_MB) LOG_WRITE_MB,
      SUM(LOG_WRITE_S) LOG_WRITE_S,
      SUM(DATA_BACKUP_WRITE_MB) DATA_BACKUP_WRITE_MB,
      SUM(DATA_BACKUP_WRITE_S) DATA_BACKUP_WRITE_S,
      SUM(LOG_BACKUP_WRITE_MB) LOG_BACKUP_WRITE_MB,
      SUM(LOG_BACKUP_WRITE_S) LOG_BACKUP_WRITE_S,
      MAX(INTERVAL_S) INTERVAL_S
    FROM
    ( SELECT
        CASE 
          WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
            CASE 
              WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
                TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
                'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
              ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.TIME END, BI.TIME_AGGREGATE_BY)
            END
          ELSE 'any' 
        END SAMPLE_TIME,
        L.HOST,
        TO_VARCHAR(L.PORT) PORT,
        SUM(L.DATA_READ_SIZE / 1024 / 1024) DATA_READ_MB,
        SUM(L.DATA_READ_TIME / 1000 / 1000) DATA_READ_S,
        SUM(L.DATA_WRITE_SIZE / 1024 / 1024) DATA_WRITE_MB,
        SUM(L.DATA_WRITE_TIME / 1000 / 1000) DATA_WRITE_S,
        SUM(L.LOG_READ_SIZE / 1024 / 1024) LOG_READ_MB,
        SUM(L.LOG_READ_TIME / 1000 / 1000) LOG_READ_S,
        SUM(L.LOG_WRITE_SIZE / 1024 / 1024) LOG_WRITE_MB,
        SUM(L.LOG_WRITE_TIME / 1000 / 1000) LOG_WRITE_S,
        SUM(L.DATA_BACKUP_WRITE_SIZE / 1024 / 1024) DATA_BACKUP_WRITE_MB,
        SUM(L.DATA_BACKUP_WRITE_TIME / 1000 / 1000) DATA_BACKUP_WRITE_S,
        SUM(L.LOG_BACKUP_WRITE_SIZE / 1024 / 1024) LOG_BACKUP_WRITE_MB,
        SUM(L.LOG_BACKUP_WRITE_TIME / 1000 / 1000) LOG_BACKUP_WRITE_S,
        SUM(INTERVAL_S) INTERVAL_S,
        BI.HOST BI_HOST,
        BI.PORT BI_PORT,
        BI.AGGREGATE_BY
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
          EXCLUDE_STANDBY,
          AGGREGATE_BY,
          DATA_SOURCE,
          MAP(TIME_AGGREGATE_BY,
            'NONE',        'YYYY/MM/DD HH24:MI:SS',
            'HOUR',        'YYYY/MM/DD HH24',
            'DAY',         'YYYY/MM/DD (DY)',
            'HOUR_OF_DAY', 'HH24',
            TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY
        FROM
        ( SELECT                      /* Modification section */
            '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
            '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
            'SERVER' TIMEZONE,                              /* SERVER, UTC */
            '%' HOST,
            '%' PORT,
            'X' EXCLUDE_STANDBY,
            'CURRENT' DATA_SOURCE,
            'TIME, HOST' AGGREGATE_BY,               /* TIME, HOST, PORT and comma separated combinations, NONE for no aggregation */
            'TS60' TIME_AGGREGATE_BY     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
          FROM
            DUMMY
        )
      ) BI INNER JOIN
      ( SELECT
          'CURRENT' DATA_SOURCE,
          TIME,
          HOST,
          PORT,
          DATA_READ_SIZE,
          DATA_READ_TIME,
          DATA_WRITE_SIZE,
          DATA_WRITE_TIME,
          LOG_READ_SIZE,
          LOG_READ_TIME,
          LOG_WRITE_SIZE,
          LOG_WRITE_TIME,
          DATA_BACKUP_WRITE_SIZE,
          DATA_BACKUP_WRITE_TIME,
          LOG_BACKUP_WRITE_SIZE,
          LOG_BACKUP_WRITE_TIME,
          NANO100_BETWEEN(LEAD(TIME, 1) OVER (PARTITION BY HOST, PORT ORDER BY TIME DESC), TIME) / 10000000 INTERVAL_S
        FROM
          M_LOAD_HISTORY_SERVICE
        UNION ALL
        SELECT
          'HISTORY' DATA_SOURCE,
          TIME,
          HOST,
          PORT,
          DATA_READ_SIZE,
          DATA_READ_TIME,
          DATA_WRITE_SIZE,
          DATA_WRITE_TIME,
          LOG_READ_SIZE,
          LOG_READ_TIME,
          LOG_WRITE_SIZE,
          LOG_WRITE_TIME,
          DATA_BACKUP_WRITE_SIZE,
          DATA_BACKUP_WRITE_TIME,
          LOG_BACKUP_WRITE_SIZE,
          LOG_BACKUP_WRITE_TIME,
          NANO100_BETWEEN(LEAD(TIME, 1) OVER (PARTITION BY HOST, PORT ORDER BY TIME DESC), TIME) / 10000000 INTERVAL_S
        FROM
          _SYS_STATISTICS.HOST_LOAD_HISTORY_SERVICE
      ) L ON
          L.HOST LIKE BI.HOST AND
          TO_VARCHAR(L.PORT) LIKE BI.PORT AND
          CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
          L.DATA_SOURCE = BI.DATA_SOURCE LEFT OUTER JOIN
        M_SERVICES S ON
          S.HOST = L.HOST AND
          S.SERVICE_NAME = 'indexserver'
      WHERE
        ( BI.EXCLUDE_STANDBY = ' ' OR S.COORDINATOR_TYPE IS NULL OR S.COORDINATOR_TYPE != 'STANDBY' )
      GROUP BY
        CASE 
          WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
            CASE 
              WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
               TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
                 'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
              ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.TIME END, BI.TIME_AGGREGATE_BY)
            END
          ELSE 'any' 
        END,
        L.HOST,
        L.PORT,
        BI.HOST,
        BI.PORT,
        BI.AGGREGATE_BY,
        BI.TIME_AGGREGATE_BY
    )
    GROUP BY
      SAMPLE_TIME,
      HOST,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST') != 0 THEN HOST ELSE MAP(BI_HOST, '%', 'any', BI_HOST) END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT') != 0 THEN TO_VARCHAR(PORT) ELSE MAP(BI_PORT, '%', 'any', BI_PORT) END
  )
)
ORDER BY
  SAMPLE_TIME DESC,
  HOST,
  PORT
