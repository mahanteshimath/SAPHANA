SELECT
/* 

[NAME]

- HANA_IO_KeyFigures_Total_1.00.110+

[DESCRIPTION]

- Total I/O information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- DELTA columns available starting with SAP HANA 1.00.110
- RESET can be performed via:

  ALTER SYSTEM RESET MONITORING VIEW M_VOLUME_IO_TOTAL_STATISTICS_RESET

[VALID FOR]

- Revisions:              >= 1.00.110

[SQL COMMAND VERSION]

- 2014/04/09:  1.0 (initial version)
- 2014/05/08:  1.1 (PATH included)
- 2014/09/24:  1.2 (SYNC / ASYNC separation via IO_MODE)
- 2015/05/19:  1.3 (SYNC / ASYNC separation undone)
- 2016/06/25:  1.4 (DELTA column used)
- 2016/12/31:  1.5 (TIME_AGGREGATE_BY = 'TS<seconds>' included)
- 2017/07/24:  1.6 (AVG_READ_MS and AVG_WRITE_MS included)
- 2017/08/01:  1.7 (MIN_AVG_READ_MS included)
- 2017/10/25:  1.8 (TIMEZONE included)
- 2018/12/04:  1.9 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2019/01/07:  2.0 (AVG_READ_KB and AVG_WRT_KB included)
- 2019/05/22:  2.1 (MIN_AVG_WRITE_MS filter added)
- 2020/05/06:  2.2 (combination of current and historic values in one command)

[INVOLVED TABLES]

- M_VOLUME_IO_TOTAL_STATISTICS
- M_VOLUME_IO_TOTAL_STATISTICS_RESET
- HOST_VOLUME_IO_TOTAL_STATISTICS

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

  'saphana01'    --> Specific host saphana01
  'saphana%'     --> All hosts starting with saphana
  '%'            --> All hosts

- PORT

  Port number

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- IO_TYPE

  I/O type (e.g. DATA, LOG)

  'DATA'          --> Disk areas related to data files
  'LOG'           --> Disk areas related to log files
  '%'             --> All disk areas

- PATH

  Path on disk

  '/hdb/ERP/backup/log/' --> Path /hdb/HAL/backup/log/
  '%backup%'             --> Paths containing 'backup'
  '%'                    --> No restriction of path

- FILESYSTEM_TYPE

  Type of file system

  'gpfs'          --> GPFS file system
  '%'             --> All file systems

- MIN_AVG_READ_MS

  Minimum threshold for average read time per request (ms)

  20              --> Only show times with average read time per request of 20 ms or higher
  -1              --> No restriction related to average read time per request

- MIN_AVG_WRITE_MS

  Minimum threshold for average write time per request (ms)

  20              --> Only show times with average write time per request of 20 ms or higher
  -1              --> No restriction related to average write time per request

- ONLY_IO_FAILURES

  Possibility to restrict output to I/O areas with reported I/O errors

  'X'             --> Only show areas with I/O failures
  ' '             --> No restriction to areas with I/O failures

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'RESET'         --> Data from reset information (*_RESET tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'FILESYSTEM'    --> Aggregation by file system
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation

[OUTPUT PARAMETERS]

- SNAPSHOT_TIME:  Time of snapshot
- HOST:           Host name
- TYPE:           Type of disk area (e.g. DATA, LOG)
- FILESYSTEM:     File system type
- READ_GB:        Total size of read requests (GB)
- AVG_READ_KB:    Average read size (KB)
- READ_TIME_S:    Total read time (s)
- READ_MB_PER_S:  Read throughput (MB/s)
- AVG_READ_MS:    Average read time per request (ms)
- TRIG_READ:      Trigger read ratio
- WRITE_GB:       Total size of write requests (GB)
- AVG_WRT_KB:     Average write size (KB)
- WRT_TIME_S:     Total write time (s)
- WRT_MB_PER_S:   Write throughput (MB/s)
- AVG_WRT_MS:     Avg. write time per request (ms)
- TRIG_WRITE:     Trigger write ratio
- FAILED_READS:   Number of failing I/O read requests
- FAILED_WRITES:  Number of failing I/O write requests

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------------------------------------------
|SNAPSHOT_TIME|HOST     |SERVICE_NAME    |TYPE|FILESYSTEM|READ_SIZE_GB|READ_TIME_S|READ_MB_PER_S|TRIG_READ|WRITE_SIZE_GB|WRITE_TIME_S|WRITE_MB_PER_S|TRIG_WRITE|
----------------------------------------------------------------------------------------------------------------------------------------------------------------
|2014/04/10 10|saphana20|indexserver     |DATA|gpfs      |       89.68|        209|       439.42|     0.17|        92.87|         639|        148.93|      0.00|
|2014/04/10 10|saphana20|statisticsserver|DATA|gpfs      |       10.25|         11|       937.21|     0.07|         0.15|           1|        109.08|      0.05|
|2014/04/10 10|saphana20|xsengine        |DATA|gpfs      |        0.07|          1|       131.93|     0.10|         0.00|           0|          5.53|      0.59|
|2014/04/10 09|saphana20|indexserver     |DATA|gpfs      |       14.73|        106|       142.48|     0.17|       442.27|        2994|        151.27|      0.00|
|2014/04/10 09|saphana20|statisticsserver|DATA|gpfs      |        3.59|          5|       675.17|     0.07|         7.19|          53|        138.33|      0.05|
|2014/04/10 09|saphana20|xsengine        |DATA|gpfs      |        0.01|          0|        41.62|     0.09|         0.00|           0|         14.11|      0.59|
|2014/04/10 08|saphana20|indexserver     |DATA|gpfs      |       21.78|        289|        77.09|     0.17|        54.60|         394|        141.78|      0.00|
|2014/04/10 08|saphana20|statisticsserver|DATA|gpfs      |        0.51|          1|       365.44|     0.07|         1.37|          12|        113.28|      0.05|
|2014/04/10 08|saphana20|xsengine        |DATA|gpfs      |        0.01|          0|        42.46|     0.09|         0.00|           0|         13.29|      0.59|
|2014/04/10 07|saphana20|indexserver     |DATA|gpfs      |       38.14|        308|       126.87|     0.17|       112.17|         726|        158.24|      0.00|
|2014/04/10 07|saphana20|statisticsserver|DATA|gpfs      |        3.78|          5|       794.26|     0.07|         3.94|          22|        183.33|      0.05|
|2014/04/10 07|saphana20|xsengine        |DATA|gpfs      |        0.01|          0|        36.87|     0.09|         0.00|           0|         13.36|      0.59|
----------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  SNAPSHOT_TIME,
  HOST,
  PORT,
  TYPE,
  PATH,
  FILESYSTEM,
  LPAD(TO_DECIMAL(READ_SIZE_GB , 12, 2), 10) READ_GB,
  LPAD(TO_DECIMAL(MAP(TOTAL_READS, 0, 0, READ_SIZE_GB / TOTAL_READS * 1024 * 1024), 10, 2), 11) AVG_READ_KB,
  LPAD(TO_DECIMAL(ROUND(READ_TIME_S), 11, 0), 11) READ_TIME_S,
  LPAD(TO_DECIMAL(READ_MB_PER_S, 12, 2), 13) READ_MB_PER_S,
  LPAD(TO_DECIMAL(MAP(TOTAL_READS, 0, 0, READ_TIME_S / TOTAL_READS * 1000), 10, 2), 11) AVG_READ_MS,
  LPAD(TO_DECIMAL(TRIG_READ, 5, 2), 9) TRIG_READ,
  LPAD(TO_DECIMAL(WRITE_SIZE_GB, 12, 2), 10) WRITE_GB,
  LPAD(TO_DECIMAL(MAP(TOTAL_WRITES, 0, 0, WRITE_SIZE_GB / TOTAL_WRITES * 1024 * 1024), 10, 2), 10) AVG_WRT_KB,
  LPAD(TO_DECIMAL(ROUND(WRITE_TIME_S), 12, 0), 10) WRT_TIME_S,
  LPAD(TO_DECIMAL(WRITE_MB_PER_S, 12, 2), 12) WRT_MB_PER_S,
  LPAD(TO_DECIMAL(MAP(TOTAL_WRITES, 0, 0, WRITE_TIME_S / TOTAL_WRITES * 1000), 10, 2), 10) AVG_WRT_MS,
  LPAD(TO_DECIMAL(TRIG_WRITE, 5, 2), 10) TRIG_WRITE,
  LPAD(FAILED_READS, 12) FAILED_READS,
  LPAD(FAILED_WRITES, 13) FAILED_WRITES
FROM
( SELECT
    SNAPSHOT_TIME,
    HOST,
    PORT,
    TYPE,
    PATH,
    FILESYSTEM,
    SUM(TOTAL_READS) TOTAL_READS,
    SUM(CASE WHEN TOTAL_READ_SIZE > 0 THEN TOTAL_READ_SIZE ELSE 0 END) / 1024 / 1024 / 1024 READ_SIZE_GB,
    SUM(CASE WHEN TOTAL_READ_TIME > 0 THEN TOTAL_READ_TIME ELSE 0 END) / 1000000 READ_TIME_S,
    MAP(SUM(CASE WHEN TOTAL_READ_TIME > 0 THEN TOTAL_READ_TIME ELSE 0 END), 0, 0, SUM(TOTAL_READ_SIZE) / 1024 / 1024 / SUM(CASE WHEN TOTAL_READ_TIME > 0 THEN TOTAL_READ_TIME ELSE 0 END) * 1000000) READ_MB_PER_S,
    MAX(TRIGGER_READ_RATIO) TRIG_READ,
    SUM(TOTAL_WRITES) TOTAL_WRITES,
    SUM(TOTAL_WRITE_SIZE) / 1024 / 1024 / 1024 WRITE_SIZE_GB,
    SUM(TOTAL_WRITE_TIME) / 1000000 WRITE_TIME_S,
    MAP(SUM(CASE WHEN TOTAL_WRITE_TIME > 0 THEN TOTAL_WRITE_TIME ELSE 0 END), 0, 0, SUM(TOTAL_WRITE_SIZE) / 1024 / 1024 / SUM(CASE WHEN TOTAL_WRITE_TIME > 0 THEN TOTAL_WRITE_TIME ELSE 0 END) * 1000000) WRITE_MB_PER_S,
    MAX(TRIGGER_WRITE_RATIO) TRIG_WRITE,
    SUM(FAILED_READS) FAILED_READS,
    SUM(FAILED_WRITES) FAILED_WRITES,
    MIN_AVG_READ_MS,
    MIN_AVG_WRITE_MS,
    ONLY_IO_FAILURES
  FROM
  ( SELECT
      CASE 
        WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), SERVER_TIMESTAMP) / SUBSTR(TIME_AGGREGATE_BY, 3)) * SUBSTR(TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(SERVER_TIMESTAMP, TIME_AGGREGATE_BY)
          END
        ELSE 'any' 
      END SNAPSHOT_TIME,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST')       != 0 THEN HOST             ELSE MAP(BI_HOST,            '%', 'any', BI_HOST)            END HOST,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT')       != 0 THEN TO_VARCHAR(PORT) ELSE MAP(BI_PORT,            '%', 'any', BI_PORT)            END PORT,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TYPE')       != 0 THEN TYPE             ELSE MAP(BI_IO_TYPE,         '%', 'any', BI_IO_TYPE)         END TYPE,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PATH')       != 0 THEN PATH             ELSE MAP(BI_PATH,            '%', 'any', BI_PATH)            END PATH,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'FILESYSTEM') != 0 THEN FILESYSTEM_TYPE  ELSE MAP(BI_FILESYSTEM_TYPE, '%', 'any', BI_FILESYSTEM_TYPE) END FILESYSTEM,
      SUM(TOTAL_READS) TOTAL_READS,
      SUM(TOTAL_READ_SIZE) TOTAL_READ_SIZE,
      SUM(TOTAL_READ_TIME) TOTAL_READ_TIME,
      MAX(TRIGGER_READ_RATIO) TRIGGER_READ_RATIO,
      SUM(TOTAL_WRITES) TOTAL_WRITES,
      SUM(TOTAL_WRITE_SIZE) TOTAL_WRITE_SIZE,
      SUM(TOTAL_WRITE_TIME) TOTAL_WRITE_TIME,
      MAX(TRIGGER_WRITE_RATIO) TRIGGER_WRITE_RATIO,
      SUM(FAILED_READS) FAILED_READS,
      SUM(FAILED_WRITES) FAILED_WRITES,
      MIN_AVG_READ_MS,
      MIN_AVG_WRITE_MS,
      ONLY_IO_FAILURES
    FROM
    ( SELECT
        SERVER_TIMESTAMP,
        HOST,
        PORT,
        TYPE,
        PATH,
        FILESYSTEM_TYPE,
        TOTAL_READS,
        TOTAL_READ_SIZE,
        TOTAL_READ_TIME,
        TRIGGER_READ_RATIO,
        TOTAL_WRITES,
        TOTAL_WRITE_SIZE,
        TOTAL_WRITE_TIME,
        TRIGGER_WRITE_RATIO,
        TOTAL_FAILED_READS - IFNULL(LEAD(TOTAL_FAILED_READS, 1) OVER (PARTITION BY HOST, PORT, TYPE, PATH, FILESYSTEM_TYPE ORDER BY SERVER_TIMESTAMP DESC), TOTAL_FAILED_READS) FAILED_READS,
        TOTAL_FAILED_WRITES - IFNULL(LEAD(TOTAL_FAILED_WRITES, 1) OVER (PARTITION BY HOST, PORT, TYPE, PATH, FILESYSTEM_TYPE ORDER BY SERVER_TIMESTAMP DESC), TOTAL_FAILED_WRITES) FAILED_WRITES,
        AGGREGATE_BY,
        TIME_AGGREGATE_BY,
        BI_HOST,
        BI_PORT,
        BI_IO_TYPE,
        BI_PATH,
        BI_FILESYSTEM_TYPE,
        MIN_AVG_READ_MS,
        MIN_AVG_WRITE_MS,
        ONLY_IO_FAILURES
      FROM
      ( SELECT
          CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(I.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE I.SERVER_TIMESTAMP END SERVER_TIMESTAMP,
          I.HOST,
          I.PORT,
          I.TYPE,
          I.PATH,
          I.FILESYSTEM_TYPE,
          I.TOTAL_READS,
          I.TOTAL_READ_SIZE,
          I.TOTAL_READ_TIME,
          I.TOTAL_WRITES,
          I.TOTAL_WRITE_SIZE,
          I.TOTAL_WRITE_TIME,
          I.TRIGGER_READ_RATIO,
          I.TRIGGER_WRITE_RATIO,
          I.TOTAL_FAILED_READS,
          I.TOTAL_FAILED_WRITES,
          BI.HOST BI_HOST,
          BI.PORT BI_PORT,
          BI.PATH BI_PATH,
          BI.IO_TYPE BI_IO_TYPE,
          BI.FILESYSTEM_TYPE BI_FILESYSTEM_TYPE,
          BI.MIN_AVG_READ_MS,
          BI.MIN_AVG_WRITE_MS,
          BI.ONLY_IO_FAILURES,
          BI.AGGREGATE_BY,
          BI.TIME_AGGREGATE_BY
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
            IO_TYPE,
            PATH,
            FILESYSTEM_TYPE,
            MIN_AVG_READ_MS,
            MIN_AVG_WRITE_MS,
            ONLY_IO_FAILURES,
            DATA_SOURCE,
            AGGREGATE_BY,
            MAP(TIME_AGGREGATE_BY,
              'NONE',        'YYYY/MM/DD HH24:MI:SS',
              'HOUR',        'YYYY/MM/DD HH24',
              'DAY',         'YYYY/MM/DD (DY)',
              'HOUR_OF_DAY', 'HH24',
              TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY
          FROM
          ( SELECT                                 /* Modification section */
              '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
              '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
              'SERVER' TIMEZONE,                              /* SERVER, UTC */
              '%' HOST,
              '%' PORT,
              '%' IO_TYPE,                      /* LOG, DATA, ... */
              '%' PATH,
              '%' FILESYSTEM_TYPE,
              -1 MIN_AVG_READ_MS,
              -1 MIN_AVG_WRITE_MS,
              ' ' ONLY_IO_FAILURES,
              'HISTORY' DATA_SOURCE,              /* CURRENT, RESET, HISTORY */
              'TIME, TYPE' AGGREGATE_BY, /* TIME, HOST, PORT, TYPE, PATH, FILESYSTEM and comma separated combinations or NONE for no aggregation */
              'HOUR' TIME_AGGREGATE_BY     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
            FROM
              DUMMY
          )
        ) BI,
        ( SELECT
            'RESET' DATA_SOURCE,
            CURRENT_TIMESTAMP SERVER_TIMESTAMP,
            HOST,
            PORT,
            TYPE,
            PATH,
            FILESYSTEM_TYPE,
            TOTAL_READS + TOTAL_TRIGGER_ASYNC_READS TOTAL_READS,
            TOTAL_READ_SIZE,
            TOTAL_READ_TIME,
            TOTAL_WRITES + TOTAL_TRIGGER_ASYNC_WRITES TOTAL_WRITES,
            TOTAL_WRITE_SIZE,
            TOTAL_WRITE_TIME,
            TRIGGER_READ_RATIO,
            TRIGGER_WRITE_RATIO,
            TOTAL_FAILED_READS,
            TOTAL_FAILED_WRITES,
            CONFIGURATION
          FROM
            M_VOLUME_IO_TOTAL_STATISTICS_RESET
          UNION ALL
          SELECT
            'CURRENT' DATA_SOURCE,
            CURRENT_TIMESTAMP SERVER_TIMESTAMP,
            HOST,
            PORT,
            TYPE,
            PATH,
            FILESYSTEM_TYPE,
            TOTAL_READS + TOTAL_TRIGGER_ASYNC_READS TOTAL_READS,
            TOTAL_READ_SIZE,
            TOTAL_READ_TIME,
            TOTAL_WRITES + TOTAL_TRIGGER_ASYNC_WRITES TOTAL_WRITES,
            TOTAL_WRITE_SIZE,
            TOTAL_WRITE_TIME,
            TRIGGER_READ_RATIO,
            TRIGGER_WRITE_RATIO,
            TOTAL_FAILED_READS,
            TOTAL_FAILED_WRITES,
            CONFIGURATION
          FROM
            M_VOLUME_IO_TOTAL_STATISTICS
          UNION ALL
          SELECT
            'HISTORY' DATA_SOURCE,
            SERVER_TIMESTAMP,
            HOST,
            PORT,
            TYPE,
            PATH,
            FILESYSTEM_TYPE,
            TOTAL_READS_DELTA + TOTAL_TRIGGER_ASYNC_READS - IFNULL(LEAD(TOTAL_TRIGGER_ASYNC_READS, 1) OVER 
              (PARTITION BY HOST, PORT, TYPE, PATH, FILESYSTEM_TYPE ORDER BY SERVER_TIMESTAMP DESC), 0) TOTAL_READS,
            TOTAL_READ_SIZE_DELTA TOTAL_READ_SIZE,
            TOTAL_READ_TIME_DELTA TOTAL_READ_TIME,
            TOTAL_WRITES_DELTA + TOTAL_TRIGGER_ASYNC_WRITES - IFNULL(LEAD(TOTAL_TRIGGER_ASYNC_WRITES, 1) OVER 
              (PARTITION BY HOST, PORT, TYPE, PATH, FILESYSTEM_TYPE ORDER BY SERVER_TIMESTAMP DESC), 0) TOTAL_WRITES,
            TOTAL_WRITE_SIZE_DELTA TOTAL_WRITE_SIZE,
            TOTAL_WRITE_TIME_DELTA TOTAL_WRITE_TIME,
            TRIGGER_READ_RATIO,
            TRIGGER_WRITE_RATIO,
            TOTAL_FAILED_READS,
            TOTAL_FAILED_WRITES,
            CONFIGURATION
          FROM
            _SYS_STATISTICS.HOST_VOLUME_IO_TOTAL_STATISTICS
        ) I
        WHERE
          I.HOST LIKE BI.HOST AND
          TO_VARCHAR(I.PORT) LIKE BI.PORT AND
          ( BI.DATA_SOURCE IN ( 'CURRENT', 'RESET' ) OR
            CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(I.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE I.SERVER_TIMESTAMP END BETWEEN BI.BEGIN_TIME AND BI.END_TIME
          ) AND
          I.TYPE LIKE BI.IO_TYPE AND
          UPPER(I.PATH) LIKE UPPER(BI.PATH) AND
          UPPER(I.FILESYSTEM_TYPE) LIKE UPPER(BI.FILESYSTEM_TYPE) AND
          I.DATA_SOURCE LIKE BI.DATA_SOURCE
      )
    )
    GROUP BY
      CASE 
        WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), SERVER_TIMESTAMP) / SUBSTR(TIME_AGGREGATE_BY, 3)) * SUBSTR(TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(SERVER_TIMESTAMP, TIME_AGGREGATE_BY)
          END
        ELSE 'any' 
      END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST')       != 0 THEN HOST             ELSE MAP(BI_HOST,            '%', 'any', BI_HOST)            END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT')       != 0 THEN TO_VARCHAR(PORT) ELSE MAP(BI_PORT,            '%', 'any', BI_PORT)            END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TYPE')       != 0 THEN TYPE             ELSE MAP(BI_IO_TYPE,         '%', 'any', BI_IO_TYPE)         END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PATH')       != 0 THEN PATH             ELSE MAP(BI_PATH,            '%', 'any', BI_PATH)            END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'FILESYSTEM') != 0 THEN FILESYSTEM_TYPE  ELSE MAP(BI_FILESYSTEM_TYPE, '%', 'any', BI_FILESYSTEM_TYPE) END,
      MIN_AVG_READ_MS,
      MIN_AVG_WRITE_MS,
      ONLY_IO_FAILURES
  )
  GROUP BY
    SNAPSHOT_TIME,
    HOST,
    PORT,
    TYPE,
    PATH,
    FILESYSTEM,
    MIN_AVG_READ_MS,
    MIN_AVG_WRITE_MS,
    ONLY_IO_FAILURES
) O
WHERE
  ( ONLY_IO_FAILURES = ' ' OR FAILED_READS > 0 OR FAILED_WRITES > 0 ) AND
  ( MIN_AVG_READ_MS = -1 OR MAP(TOTAL_READS, 0, 0, READ_TIME_S / TOTAL_READS * 1000) > MIN_AVG_READ_MS ) AND
  ( MIN_AVG_WRITE_MS = -1 OR MAP(TOTAL_WRITES, 0, 0, WRITE_TIME_S / TOTAL_WRITES * 1000) > MIN_AVG_WRITE_MS )
ORDER BY
  SNAPSHOT_TIME DESC,
  HOST,
  PORT,
  TYPE,
  PATH,
  FILESYSTEM
