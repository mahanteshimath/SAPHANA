SELECT
/* 

[NAME]

- HANA_IO_KeyFigures_Details

[DESCRIPTION]

- I/O information including I/O buffer size distinction

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- RESET can be performed via:

  ALTER SYSTEM RESET MONITORING VIEW M_VOLUME_IO_DETAILED_STATISTICS_RESET

- Sporadic negative values are typically caused by rounding errors, because the total I/O time is calculated based on the average time and the amount of I/O

---------------------------------------------------------------------------------------------------------------------------------
|SERVER_TIMESTAMP       |MAX_IO_BUFFER_SIZE|AVG_TRIGGER_ASYNC_WRITE_TIME|TRIGGER_ASYNC_WRITE_COUNT|TOTAL_WRITE_TIME|WRITE_TIME_S|
---------------------------------------------------------------------------------------------------------------------------------
|20150320055820226000000|           65.536 |                      1.845 |              53.682.154 | 99.043.574.130 |  6.129.090 |
|20150320055305615000000|           65.536 |                      1.845 |              53.678.832 | 99.037.445.040 | 14.047.830 |
|20150320054806575000000|           65.536 |                      1.845 |              53.671.218 | 99.023.397.210 | 31.571.640 |
|20150320054320051000000|           65.536 |                      1.845 |              53.654.106 | 98.991.825.570 | 24.179.024-| <- AVG_TRIGGER_ASYNC_WRITE_TIME changes from 1846 to 1845
|20150320053806244000000|           65.536 |                      1.846 |              53.638.139 | 99.016.004.594 | 33.327.684 |
|20150320053306181000000|           65.536 |                      1.846 |              53.620.085 | 98.982.676.910 | 22.168.614 |
|20150320052848938000000|           65.536 |                      1.846 |              53.608.076 | 98.960.508.296 |  6.625.294 |
---------------------------------------------------------------------------------------------------------------------------------

[VALID FOR]

- Revisions:              all
[SQL COMMAND VERSION]

- 2014/09/23:  1.0 (initial version)
- 2015/03/20:  1.1 (READ_MB_PER_S and WRITE_MB_PER_S added)
- 2016/12/31:  1.2 (TIME_AGGREGATE_BY = 'TS<seconds>' included)
- 2017/10/24:  1.3 (TIMEZONE included)
- 2018/12/04:  1.4 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2020/05/06:  1.5 (combination of current and historic values in one command)

[INVOLVED TABLES]

- M_VOLUME_IO_DETAILED_STATISTICS
- M_VOLUME_IO_DETAILED_STATISTICS_RESET
- HOST_VOLUME_IO_DETAILED_STATISTICS

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

- IO_TYPE

  Type of I/O

  'DATA'          --> Data related I/O
  'LOG'           --> Log related I/O
  '%'             --> All I/O types

- IO_MODE

  I/O mode

  'SYNC'          --> Synchronous I/O
  'ASYNC'         --> Asynchronous I/O
  '%'             --> No restriction to I/O mode

- PATH

  Path on disk

  '/hdb/ERP/backup/log/' --> Path /hdb/HAL/backup/log/
  '%backup%'             --> Paths containing 'backup'
  '%'                    --> No restriction of path

- MIN_IO_BUFFER_SIZE_KB

  Lower threshold for I/O buffer size (KB)

  1024            --> Only consider I/O with buffer sizes >= 1024 KB (1 MB)
  -1              --> No lower limit for I/O buffer size

- MAX_IO_BUFFER_SIZE_KB

  Upper threshold for I/O buffer size (KB)

  4096            --> Only consider I/O with buffer sizes <= 4096 KB (4 MB)
  -1              --> No upper limit for I/O buffer size

- MIN_TOTAL_SIZE_GB

  Lower limit for total I/O size (GB)

  5               --> Only consider I/O with a volume of at least 5 GB
  -1              --> No restriction related to total I/O size

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'RESET'         --> Data from reset information (*_RESET tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'IO_TYPE'       --> Aggregation by I/O type
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

  'HOST'          --> Sorting by host name
  'TOTAL_SIZE'    --> Sorting by total I/O size

[OUTPUT PARAMETERS]

- SNAPSHOT_TIME:     Timestamp
- HOST:              Host name
- PORT:              Port
- IO_TYPE:           I/O type (e.g. 'DATA' for data access, 'LOG' for log access)
- IO_MODE:           IO mode (SYNC for synchronous I/O, ASYNC for asynchronous I/O, ALL for all I/O)
- BUFFER_KB:         Upper limit for I/O buffer size (related to a predefined range)
- TOTAL_SIZE_GB:     Total I/O size (read + write) (s)
- TOTAL_TIME_S:      Total I/O time (read + write) (s)
- READS:             Total number of read requests
- READ_GB:           Total read size (GB)
- READ_TIME_S:       Total read time (s), high values are not an indication for problems because I/O times of all concurrent requests are summarized
- AVG_READ_TIME_MS:  Average read time (ms)
- READ_MB_PER_S:     Read throughput (MB / s), only active read time is considered
- WRITES:            Total number of write requests
- WRITE_GB:          Total write size (GB)
- WRITE_TIME_S:      Total write time (s), high values are not an indication for problems because I/O times of all concurrent requests are summarized
- AVG_WRITE_TIME_MS: Average write time (ms)
- WRITE_MB_PER_S:    Write throughput (MB / s), only active write time is considered

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SNAPSHOT_TIME      |HOST         |PORT |IO_TYPE|BUFFER_KB|TOTAL_SIZE_GB|TOTAL_TIME_S|READS     |READ_SIZE_GB|READ_TIME_S|AVG_READ_TIME_MS|WRITES    |WRITE_SIZE_GB|WRITE_TIME_S|AVG_WRITE_TIME_MS|
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2014/09/21 21:39:18|saphanadbd005|31103|DATA   |    16384|         7.15|         143|       458|        7.15|        143|          313.23|         0|         0.00|           0|             0.00|
|2014/09/21 19:09:18|saphanadbd002|31103|DATA   |    16384|         8.87|          43|       568|        8.87|         43|           75.79|         0|         0.00|           0|             0.00|
|2014/09/21 12:39:18|saphanadbd008|31103|DATA   |     4096|         5.04|          31|      1291|        5.04|         31|           24.06|         0|         0.00|           0|             0.00|
|2014/09/21 12:39:18|saphanadbd008|31103|DATA   |    16384|         9.54|          21|       611|        9.54|         21|           33.87|         0|         0.00|           0|             0.00|
|2014/09/21 09:04:18|saphanadbd004|31103|DATA   |     1024|        14.43|        2239|     14778|       14.43|       2239|          151.48|         0|         0.00|           0|             0.00|
|2014/09/21 09:04:18|saphanadbd004|31103|DATA   |    16384|        59.12|        1121|      3784|       59.12|       1121|          296.12|         0|         0.00|           0|             0.00|
|2014/09/21 09:04:18|saphanadbd004|31103|DATA   |     4096|        30.32|        1850|      7762|       30.32|       1850|          238.32|         0|         0.00|           0|             0.00|
|2014/09/21 09:04:18|saphanadbd005|31103|DATA   |     4096|        17.39|        3419|      4453|       17.39|       3419|          767.76|         0|         0.00|           0|             0.00|
|2014/09/21 09:04:18|saphanadbd005|31103|DATA   |    16384|        47.90|        2228|      3066|       47.90|       2228|          726.53|         0|         0.00|           0|             0.00|
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  SNAPSHOT_TIME,
  HOST,
  LPAD(PORT, 5) PORT,
  IO_TYPE,
  MAP(IO_MODE, '%', 'any', IO_MODE) IO_MODE,
  LPAD(MAP(BUFFER_KB, '0', '> 65536', BUFFER_KB), 9) BUFFER_KB,
  LPAD(TO_DECIMAL(TOTAL_SIZE_GB, 10, 2), 13) TOTAL_SIZE_GB,
  LPAD(TO_DECIMAL(ROUND(TOTAL_TIME_S), 12, 0), 12) TOTAL_TIME_S,
  LPAD(READS, 10) READS,
  LPAD(TO_DECIMAL(READ_SIZE_GB, 10, 2), 10) READ_GB,
  LPAD(TO_DECIMAL(ROUND(READ_TIME_S), 11, 0), 11) READ_TIME_S,
  LPAD(TO_DECIMAL(AVG_READ_TIME_MS, 10, 2), 16) AVG_READ_TIME_MS,
  LPAD(TO_DECIMAL(MAP(READ_TIME_S, 0, 0, READ_SIZE_GB * 1024 / READ_TIME_S), 10, 2), 13) READ_MB_PER_S,
  LPAD(WRITES, 10) WRITES,
  LPAD(TO_DECIMAL(WRITE_SIZE_GB, 10, 2), 10) WRITE_GB,
  LPAD(TO_DECIMAL(ROUND(WRITE_TIME_S), 12, 0), 12) WRITE_TIME_S,
  LPAD(TO_DECIMAL(AVG_WRITE_TIME_MS, 10, 2), 17) AVG_WRITE_TIME_MS,
  LPAD(TO_DECIMAL(MAP(WRITE_TIME_S, 0, 0, WRITE_SIZE_GB * 1024 / WRITE_TIME_S), 10, 2), 14) WRITE_MB_PER_S
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
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST')        != 0 THEN HOST                                                            ELSE MAP(BI_HOST,    '%', 'any', BI_HOST)    END HOST,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT')        != 0 THEN TO_VARCHAR(PORT)                                                ELSE MAP(BI_PORT,    '%', 'any', BI_PORT)    END PORT,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PATH')        != 0 THEN PATH                                                            ELSE MAP(BI_PATH,    '%', 'any', BI_PATH)    END PATH,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'IO_TYPE')     != 0 THEN IO_TYPE                                                         ELSE MAP(BI_IO_TYPE, '%', 'any', BI_IO_TYPE) END IO_TYPE,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'BUFFER_SIZE') != 0 THEN TO_VARCHAR(TO_DECIMAL(ROUND(MAX_IO_BUFFER_SIZE / 1024), 10, 0)) ELSE 'any'                                   END BUFFER_KB,
    SUM(TOTAL_SIZE_GB) TOTAL_SIZE_GB,
    SUM(TOTAL_TIME_S) TOTAL_TIME_S,
    SUM(READS) READS,
    SUM(READ_SIZE_GB) READ_SIZE_GB,
    SUM(READ_TIME_S) READ_TIME_S,
    MAP(SUM(READS), 0, 0, SUM(READ_TIME_S) / SUM(READS) * 1000) AVG_READ_TIME_MS,
    SUM(WRITES) WRITES,
    SUM(WRITE_SIZE_GB) WRITE_SIZE_GB,
    SUM(WRITE_TIME_S) WRITE_TIME_S,
    MAP(SUM(WRITES), 0, 0, SUM(WRITE_TIME_S) / SUM(WRITES) * 1000) AVG_WRITE_TIME_MS,
    MIN_TOTAL_SIZE_GB,
    IO_MODE
  FROM
  ( SELECT
      SERVER_TIMESTAMP,
      HOST,
      PORT,
      IO_TYPE,
      IO_MODE,
      PATH,
      MAX_IO_BUFFER_SIZE,
      CASE WHEN DATA_SOURCE IN ('CURRENT', 'RESET') THEN TOTAL_SIZE_GB ELSE TOTAL_SIZE_GB - LEAD(TOTAL_SIZE_GB, 1) OVER (PARTITION BY HOST, PORT, IO_TYPE, PATH, FILESYSTEM_TYPE, MAX_IO_BUFFER_SIZE ORDER BY SERVER_TIMESTAMP DESC) END TOTAL_SIZE_GB,
      CASE WHEN DATA_SOURCE IN ('CURRENT', 'RESET') THEN TOTAL_TIME_S  ELSE TOTAL_TIME_S  - LEAD(TOTAL_TIME_S,  1) OVER (PARTITION BY HOST, PORT, IO_TYPE, PATH, FILESYSTEM_TYPE, MAX_IO_BUFFER_SIZE ORDER BY SERVER_TIMESTAMP DESC) END TOTAL_TIME_S,
      CASE WHEN DATA_SOURCE IN ('CURRENT', 'RESET') THEN READS         ELSE READS         - LEAD(READS,         1) OVER (PARTITION BY HOST, PORT, IO_TYPE, PATH, FILESYSTEM_TYPE, MAX_IO_BUFFER_SIZE ORDER BY SERVER_TIMESTAMP DESC) END READS,
      CASE WHEN DATA_SOURCE IN ('CURRENT', 'RESET') THEN READ_SIZE_GB  ELSE READ_SIZE_GB  - LEAD(READ_SIZE_GB,  1) OVER (PARTITION BY HOST, PORT, IO_TYPE, PATH, FILESYSTEM_TYPE, MAX_IO_BUFFER_SIZE ORDER BY SERVER_TIMESTAMP DESC) END READ_SIZE_GB,
      CASE WHEN DATA_SOURCE IN ('CURRENT', 'RESET') THEN READ_TIME_S   ELSE READ_TIME_S   - LEAD(READ_TIME_S,   1) OVER (PARTITION BY HOST, PORT, IO_TYPE, PATH, FILESYSTEM_TYPE, MAX_IO_BUFFER_SIZE ORDER BY SERVER_TIMESTAMP DESC) END READ_TIME_S,
      CASE WHEN DATA_SOURCE IN ('CURRENT', 'RESET') THEN WRITES        ELSE WRITES        - LEAD(WRITES,        1) OVER (PARTITION BY HOST, PORT, IO_TYPE, PATH, FILESYSTEM_TYPE, MAX_IO_BUFFER_SIZE ORDER BY SERVER_TIMESTAMP DESC) END WRITES,
      CASE WHEN DATA_SOURCE IN ('CURRENT', 'RESET') THEN WRITE_SIZE_GB ELSE WRITE_SIZE_GB - LEAD(WRITE_SIZE_GB, 1) OVER (PARTITION BY HOST, PORT, IO_TYPE, PATH, FILESYSTEM_TYPE, MAX_IO_BUFFER_SIZE ORDER BY SERVER_TIMESTAMP DESC) END WRITE_SIZE_GB,
      CASE WHEN DATA_SOURCE IN ('CURRENT', 'RESET') THEN WRITE_TIME_S  ELSE WRITE_TIME_S  - LEAD(WRITE_TIME_S,  1) OVER (PARTITION BY HOST, PORT, IO_TYPE, PATH, FILESYSTEM_TYPE, MAX_IO_BUFFER_SIZE ORDER BY SERVER_TIMESTAMP DESC) END WRITE_TIME_S,
      BEGIN_TIME,
      END_TIME,
      BI_HOST,
      BI_PORT,
      BI_PATH,
      BI_IO_TYPE,
      MIN_IO_BUFFER_SIZE_KB,
      MAX_IO_BUFFER_SIZE_KB,
      MIN_TOTAL_SIZE_GB,
      AGGREGATE_BY,
      TIME_AGGREGATE_BY
    FROM
    ( SELECT
        SERVER_TIMESTAMP,
        HOST,
        PORT,
        IO_TYPE,
        IO_MODE,
        PATH,
        FILESYSTEM_TYPE,
        MAX_IO_BUFFER_SIZE,
        ( READ_SIZE + WRITE_SIZE ) / 1024 / 1024 / 1024 TOTAL_SIZE_GB,
        ( READ_TIME + WRITE_TIME ) / 1000000 TOTAL_TIME_S,
        READ_COUNT READS,
        READ_SIZE / 1024 / 1024 / 1024 READ_SIZE_GB,
        READ_TIME / 1000000 READ_TIME_S,
        WRITE_COUNT WRITES,
        WRITE_SIZE / 1024 / 1024 / 1024 WRITE_SIZE_GB,
        WRITE_TIME / 1000000 WRITE_TIME_S,
        BEGIN_TIME,
        END_TIME,
        BI_HOST,
        BI_PORT,
        BI_PATH,
        BI_IO_TYPE,
        MIN_IO_BUFFER_SIZE_KB,
        MAX_IO_BUFFER_SIZE_KB,
        MIN_TOTAL_SIZE_GB,
        DATA_SOURCE,
        AGGREGATE_BY,
        TIME_AGGREGATE_BY
      FROM
      ( SELECT
          CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(I.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE I.SERVER_TIMESTAMP END SERVER_TIMESTAMP,
          I.HOST,
          I.PORT,
          I.TYPE IO_TYPE,
          BI.IO_MODE,
          I.PATH,
          I.FILESYSTEM_TYPE,
          I.MAX_IO_BUFFER_SIZE,
          CASE BI.IO_MODE 
            WHEN 'SYNC'  THEN I.READ_COUNT 
            WHEN 'ASYNC' THEN I.TRIGGER_ASYNC_READ_COUNT 
            WHEN '%'     THEN I.READ_COUNT + I.TRIGGER_ASYNC_READ_COUNT 
          END READ_COUNT,
          CASE BI.IO_MODE 
            WHEN 'SYNC'  THEN I.READ_COUNT * I.AVG_READ_SIZE 
            WHEN 'ASYNC' THEN I.TRIGGER_ASYNC_READ_COUNT * AVG_TRIGGER_ASYNC_READ_SIZE 
            WHEN '%'     THEN I.READ_COUNT * I.AVG_READ_SIZE + I.TRIGGER_ASYNC_READ_COUNT * AVG_TRIGGER_ASYNC_READ_SIZE 
          END READ_SIZE,
          CASE BI.IO_MODE 
            WHEN 'SYNC'  THEN I.READ_COUNT * I.AVG_READ_TIME
            WHEN 'ASYNC' THEN I.TRIGGER_ASYNC_READ_COUNT * AVG_TRIGGER_ASYNC_READ_TIME
            WHEN '%'     THEN I.READ_COUNT * I.AVG_READ_TIME + I.TRIGGER_ASYNC_READ_COUNT * AVG_TRIGGER_ASYNC_READ_TIME
          END READ_TIME,
          CASE BI.IO_MODE 
            WHEN 'SYNC'  THEN I.WRITE_COUNT 
            WHEN 'ASYNC' THEN I.TRIGGER_ASYNC_WRITE_COUNT 
            WHEN '%'     THEN I.WRITE_COUNT + I.TRIGGER_ASYNC_WRITE_COUNT 
          END WRITE_COUNT,
          CASE BI.IO_MODE 
            WHEN 'SYNC'  THEN I.WRITE_COUNT * I.AVG_WRITE_SIZE 
            WHEN 'ASYNC' THEN I.TRIGGER_ASYNC_WRITE_COUNT * AVG_TRIGGER_ASYNC_WRITE_SIZE 
            WHEN '%'     THEN I.WRITE_COUNT * I.AVG_WRITE_SIZE + I.TRIGGER_ASYNC_WRITE_COUNT * AVG_TRIGGER_ASYNC_WRITE_SIZE 
          END WRITE_SIZE,
          CASE BI.IO_MODE 
            WHEN 'SYNC'  THEN I.WRITE_COUNT * I.AVG_WRITE_TIME 
            WHEN 'ASYNC' THEN I.TRIGGER_ASYNC_WRITE_COUNT * AVG_TRIGGER_ASYNC_WRITE_TIME
            WHEN '%'     THEN I.WRITE_COUNT * I.AVG_WRITE_TIME + I.TRIGGER_ASYNC_WRITE_COUNT * AVG_TRIGGER_ASYNC_WRITE_TIME
          END WRITE_TIME,
          BI.BEGIN_TIME,
          BI.END_TIME,
          BI.HOST BI_HOST,
          BI.PORT BI_PORT,
          BI.PATH BI_PATH,
          BI.IO_TYPE BI_IO_TYPE,
          BI.MIN_IO_BUFFER_SIZE_KB,
          BI.MAX_IO_BUFFER_SIZE_KB,
          BI.MIN_TOTAL_SIZE_GB,
          BI.DATA_SOURCE,
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
            PATH,
            IO_TYPE,
            IO_MODE,
            MIN_IO_BUFFER_SIZE_KB,
            MAX_IO_BUFFER_SIZE_KB,
            MIN_TOTAL_SIZE_GB,
            DATA_SOURCE,
            AGGREGATE_BY,
            MAP(TIME_AGGREGATE_BY,
              'NONE',        'YYYY/MM/DD HH24:MI:SS',
              'HOUR',        'YYYY/MM/DD HH24',
              'DAY',         'YYYY/MM/DD (DY)',
              'HOUR_OF_DAY', 'HH24',
              TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY     
          FROM
          ( SELECT              /* Modification section */
              '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
              '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
              'SERVER' TIMEZONE,                              /* SERVER, UTC */
              '%' HOST,
              '%' PORT,
              'DATA' IO_TYPE,            /* %, DATA, LOG, DATA_BACKUP, LOG_BACKUP, ... */
              '%' IO_MODE,         /* SYNC, ASYNC, % */
              '%' PATH,
              -1 MIN_IO_BUFFER_SIZE_KB,
              -1 MAX_IO_BUFFER_SIZE_KB,
              -1 MIN_TOTAL_SIZE_GB,
              'HISTORY' DATA_SOURCE,                 /* CURRENT, RESET, HISTORY */
              'TIME, BUFFER_SIZE' AGGREGATE_BY,                  /* TIME, HOST, PORT, PATH, IO_TYPE, BUFFER_SIZE or comma-separated combinations, NONE for no aggregation */
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
            MAX_IO_BUFFER_SIZE,
            READ_COUNT,
            AVG_READ_SIZE,
            AVG_READ_TIME,
            WRITE_COUNT,
            AVG_WRITE_SIZE,
            AVG_WRITE_TIME,
            TRIGGER_ASYNC_READ_COUNT,
            AVG_TRIGGER_ASYNC_READ_SIZE,
            AVG_TRIGGER_ASYNC_READ_TIME,
            TRIGGER_ASYNC_WRITE_COUNT,
            AVG_TRIGGER_ASYNC_WRITE_SIZE,
            AVG_TRIGGER_ASYNC_WRITE_TIME
          FROM
            M_VOLUME_IO_DETAILED_STATISTICS_RESET
          UNION ALL
          SELECT
            'CURRENT' DATA_SOURCE,
            CURRENT_TIMESTAMP SERVER_TIMESTAMP,
            HOST,
            PORT,
            TYPE,
            PATH,
            FILESYSTEM_TYPE,
            MAX_IO_BUFFER_SIZE,
            READ_COUNT,
            AVG_READ_SIZE,
            AVG_READ_TIME,
            WRITE_COUNT,
            AVG_WRITE_SIZE,
            AVG_WRITE_TIME,
            TRIGGER_ASYNC_READ_COUNT,
            AVG_TRIGGER_ASYNC_READ_SIZE,
            AVG_TRIGGER_ASYNC_READ_TIME,
            TRIGGER_ASYNC_WRITE_COUNT,
            AVG_TRIGGER_ASYNC_WRITE_SIZE,
            AVG_TRIGGER_ASYNC_WRITE_TIME
          FROM
            M_VOLUME_IO_DETAILED_STATISTICS
          UNION ALL
          SELECT
            'HISTORY' DATA_SOURCE,
            SERVER_TIMESTAMP,
            HOST,
            PORT,
            TYPE,
            PATH,
            FILESYSTEM_TYPE,
            MAX_IO_BUFFER_SIZE,
            READ_COUNT,
            AVG_READ_SIZE,
            AVG_READ_TIME,
            WRITE_COUNT,
            AVG_WRITE_SIZE,
            AVG_WRITE_TIME,
            TRIGGER_ASYNC_READ_COUNT,
            AVG_TRIGGER_ASYNC_READ_SIZE,
            AVG_TRIGGER_ASYNC_READ_TIME,
            TRIGGER_ASYNC_WRITE_COUNT,
            AVG_TRIGGER_ASYNC_WRITE_SIZE,
            AVG_TRIGGER_ASYNC_WRITE_TIME
          FROM
          _SYS_STATISTICS.HOST_VOLUME_IO_DETAILED_STATISTICS I
        ) I
        WHERE
          I.HOST LIKE BI.HOST AND
          TO_VARCHAR(I.PORT) LIKE BI.PORT AND
          ( BI.DATA_SOURCE IN ( 'CURRENT', 'RESET' ) OR
            CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(I.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE I.SERVER_TIMESTAMP END BETWEEN BI.BEGIN_TIME AND BI.END_TIME
          ) AND
          I.TYPE LIKE BI.IO_TYPE AND
          I.PATH LIKE BI.PATH AND
          ( BI.MIN_IO_BUFFER_SIZE_KB = -1 OR I.MAX_IO_BUFFER_SIZE / 1024 >= BI.MIN_IO_BUFFER_SIZE_KB ) AND
          ( BI.MAX_IO_BUFFER_SIZE_KB = -1 OR I.MAX_IO_BUFFER_SIZE / 1024 <= BI.MAX_IO_BUFFER_SIZE_KB ) AND
          I.DATA_SOURCE LIKE BI.DATA_SOURCE
      )
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
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST')        != 0 THEN HOST                                                            ELSE MAP(BI_HOST,    '%', 'any', BI_HOST)    END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT')        != 0 THEN TO_VARCHAR(PORT)                                                ELSE MAP(BI_PORT,    '%', 'any', BI_PORT)    END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PATH')        != 0 THEN PATH                                                            ELSE MAP(BI_PATH,    '%', 'any', BI_PATH)    END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'IO_TYPE')     != 0 THEN IO_TYPE                                                         ELSE MAP(BI_IO_TYPE, '%', 'any', BI_IO_TYPE) END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'BUFFER_SIZE') != 0 THEN TO_VARCHAR(TO_DECIMAL(ROUND(MAX_IO_BUFFER_SIZE / 1024), 10, 0)) ELSE 'any'                                   END,
    IO_MODE,
    MIN_TOTAL_SIZE_GB
)
WHERE
  ( MIN_TOTAL_SIZE_GB = -1 OR TOTAL_SIZE_GB >= MIN_TOTAL_SIZE_GB ) AND
  TOTAL_SIZE_GB > 0
ORDER BY
  SNAPSHOT_TIME DESC,
  HOST,
  PORT,
  BUFFER_KB

