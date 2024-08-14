SELECT
/* 

[NAME]

- HANA_Replication_SystemReplication_Bandwidth

[DESCRIPTION]

- Calculation of bandwidth requirements for system replication with delta_datashipping mode
- Based on write I/O to DATA and size of log backups
- Needs to be run in a system with representative load, otherwise it may show inaccurate / empty results
- Independent of the actual technical SR configuration like compression

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/01/23:  1.0 (initial version)
- 2015/04/09:  1.1 (SIMPLE_BANDWIDTH_MBIT included)
- 2016/01/07:  1.2 (PERSISTENCE_GB included)
- 2016/12/31:  1.3 (TIME_AGGREGATE_BY = 'TS<seconds>' included)
- 2017/10/25:  1.4 (TIMEZONE included)
- 2018/12/04:  1.5 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- HOST_VOLUME_IO_TOTAL_STATISTICS
- M_BACKUP_CATALOG
- M_BACKUP_CATALOG_FILES
- M_DATA_VOLUME_PAGE_STATISTICS

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

- SNAPSHOT_TIME:        Time of snapshot
- HOST:                 Host name
- PERSISTENCE_GB:       (Current) persistence data size (GB)
- DATA_SIZE_GB:         Total amount of data written to disk (GB)
- LOG_SIZE_GB:          Total amount of logs generated (GB)
- TOTAL_SIZE_GB:        Total amount of data and logs generated (GB)
- LOG_PCT:              Log compared to total (%)
- AVG_BANDWIDTH_MBIT:   Average required network bandwidth to replication side (Mbit), only available for certain TIME_AGGREGATE_BY values
- SIMPLE_BANDWITH_MBIT: Simple network bandwidth calculation (Mbit) based on the formula that it should be possible to ship the persistence once per day

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------
|SNAPSHOT_TIME   |HOST|DATA_SIZE_GB|LOG_SIZE_GB|TOTAL_SIZE_GB|LOG_PCT|AVG_BANDWIDTH_MBIT|
-----------------------------------------------------------------------------------------
|2015/01/23 (FRI)|any |      711.33|      46.29|       757.63|   6.11|             71.83|
|2015/01/22 (THU)|any |     1391.42|      63.79|      1455.22|   4.38|            137.97|
|2015/01/21 (WED)|any |      906.09|      41.90|       948.00|   4.42|             89.88|
|2015/01/20 (TUE)|any |     1410.67|      86.78|      1497.45|   5.79|            141.98|
|2015/01/19 (MON)|any |     1653.42|      66.40|      1719.83|   3.86|            163.06|
|2015/01/18 (SUN)|any |     1152.56|      53.77|      1206.34|   4.45|            114.37|
|2015/01/17 (SAT)|any |     1176.58|      58.54|      1235.12|   4.73|            117.10|
|2015/01/16 (FRI)|any |     1435.94|      67.56|      1503.51|   4.49|            142.55|
|2015/01/15 (THU)|any |     1229.27|      66.05|      1295.33|   5.09|            122.81|
|2015/01/14 (WED)|any |     1506.95|      83.28|      1590.24|   5.23|            150.77|
|2015/01/13 (TUE)|any |     1377.62|      91.69|      1469.31|   6.24|            139.31|
|2015/01/12 (MON)|any |     1641.76|     110.41|      1752.18|   6.30|            166.13|
|2015/01/11 (SUN)|any |     1100.44|      51.31|      1151.76|   4.45|            109.20|
|2015/01/10 (SAT)|any |      998.91|      50.35|      1049.27|   4.79|             99.48|
|2015/01/09 (FRI)|any |      989.06|      51.76|      1040.83|   4.97|             98.68|
|2015/01/08 (THU)|any |      979.05|      51.24|      1030.29|   4.97|             97.68|
|2015/01/07 (WED)|any |      854.26|      46.81|       901.08|   5.19|             85.43|
|2015/01/06 (TUE)|any |     1120.61|      55.48|      1176.09|   4.71|            111.51|
|2015/01/05 (MON)|any |     1288.64|      54.24|      1342.89|   4.03|            127.32|
|2015/01/04 (SUN)|any |     1170.12|      61.18|      1231.30|   4.96|            116.74|
|2015/01/03 (SAT)|any |     1175.77|      87.05|      1262.83|   6.89|            119.73|
|2015/01/02 (FRI)|any |     1212.21|      78.33|      1290.55|   6.06|            122.36|
|2015/01/01 (THU)|any |      631.55|      36.79|       668.35|   5.50|             63.36|
|2014/12/31 (WED)|any |     1521.51|     198.34|      1719.85|  11.53|            163.06|
|2014/12/30 (TUE)|any |     2429.77|     101.32|      2531.09|   4.00|            239.98|
|2014/12/29 (MON)|any |     1948.82|      74.11|      2022.94|   3.66|            191.80|
|2014/12/28 (SUN)|any |     1272.63|      61.11|      1333.74|   4.58|            126.45|
|2014/12/27 (SAT)|any |     1505.28|      66.31|      1571.59|   4.21|            149.01|
|2014/12/26 (FRI)|any |     1610.56|      69.89|      1680.45|   4.15|            159.33|
|2014/12/25 (THU)|any |     1859.11|      79.22|      1938.34|   4.08|            183.78|
|2014/12/24 (WED)|any |     3135.07|     116.15|      3251.22|   3.57|            308.26|
|2014/12/23 (TUE)|any |      251.32|      99.83|       351.16|  28.43|             33.29|
-----------------------------------------------------------------------------------------

*/
  SNAPSHOT_TIME,
  HOST,
  LPAD(TO_DECIMAL(PERSISTENCE_MB / 1024, 10, 2) , 14) PERSISTENCE_GB,
  LPAD(TO_DECIMAL(DATA_SIZE_MB / 1024, 10, 2), 12) DATA_SIZE_GB,
  LPAD(TO_DECIMAL(LOG_SIZE_MB / 1024, 10, 2), 11) LOG_SIZE_GB,
  LPAD(TO_DECIMAL(TOTAL_SIZE_MB / 1024, 10, 2), 13) TOTAL_SIZE_GB,
  LPAD(TO_DECIMAL(MAP(TOTAL_SIZE_MB, 0, 0, LOG_SIZE_MB / TOTAL_SIZE_MB * 100), 10, 2), 7) LOG_PCT,
  MAP(SECONDS, -1, 'n/a', LPAD(TO_DECIMAL(TOTAL_SIZE_MB / SECONDS * 8, 10, 2), 18)) AVG_BANDWIDTH_MBIT,
  LPAD(TO_DECIMAL(PERSISTENCE_MB / 86400 * 8, 10, 2), 21) SIMPLE_BANDWIDTH_MBIT
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(I.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE I.SERVER_TIMESTAMP END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(I.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE I.SERVER_TIMESTAMP END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END SNAPSHOT_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST') != 0 THEN I.HOST ELSE MAP(BI.HOST, '%', 'any', BI.HOST) END HOST,
    SUM(I.LOG_SIZE_MB) LOG_SIZE_MB,
    SUM(I.DATA_SIZE_MB) DATA_SIZE_MB,
    SUM(I.LOG_SIZE_MB + I.DATA_SIZE_MB) TOTAL_SIZE_MB,
    MAX(P.PERSISTENCE_MB) PERSISTENCE_MB,
    CASE 
      WHEN BI.TIME_AGGREGATE_BY = 'YYYY/MM/DD HH24' THEN 3600
      WHEN BI.TIME_AGGREGATE_BY = 'YYYY/MM/DD (DY)' THEN 86400
      WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN SUBSTR(BI.TIME_AGGREGATE_BY, 3)
      ELSE -1
    END SECONDS
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
        'TIME' AGGREGATE_BY,         /* TIME, HOST and comma separated combinations or NONE for no aggregation */
        'TS900' TIME_AGGREGATE_BY     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
      FROM
        DUMMY
    )
  ) BI,
  ( SELECT 
      C.SYS_START_TIME SERVER_TIMESTAMP,
      CF.HOST,
      CF.BACKUP_SIZE / 1024 / 1024 LOG_SIZE_MB,
      0 DATA_SIZE_MB
    FROM
      M_BACKUP_CATALOG C,
      M_BACKUP_CATALOG_FILES CF
    WHERE
      C.ENTRY_ID = CF.ENTRY_ID AND
      C.ENTRY_TYPE_NAME = 'log backup' AND
      CF.SOURCE_ID > 0 
    UNION ALL
    ( SELECT
        SERVER_TIMESTAMP,
        HOST,
        LOG_SIZE_MB,
        DATA_SIZE_MB
      FROM
      ( SELECT
          SERVER_TIMESTAMP,
          HOST,
          LOG_SIZE_MB,
          DATA_SIZE_MB - LEAD(DATA_SIZE_MB, 1) OVER (PARTITION BY HOST ORDER BY SERVER_TIMESTAMP DESC) DATA_SIZE_MB
        FROM
        ( SELECT
            SERVER_TIMESTAMP SERVER_TIMESTAMP,
            HOST,
            0 LOG_SIZE_MB,
            SUM(TOTAL_WRITE_SIZE) / 1024 / 1024  DATA_SIZE_MB
          FROM
            _SYS_STATISTICS.HOST_VOLUME_IO_TOTAL_STATISTICS
          WHERE
            TYPE = 'DATA'
          GROUP BY
            SERVER_TIMESTAMP,
            HOST
        )
      )
      WHERE
        DATA_SIZE_MB > 0
    )
  ) I,
  ( SELECT
      HOST,
      SUM(USED_BLOCK_COUNT * PAGE_SIZE) / 1024 / 1024 PERSISTENCE_MB
    FROM
      M_DATA_VOLUME_PAGE_STATISTICS
    GROUP BY
      HOST
  ) P
  WHERE
    I.HOST LIKE BI.HOST AND
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(I.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE I.SERVER_TIMESTAMP END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    I.HOST = P.HOST
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(I.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE I.SERVER_TIMESTAMP END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(I.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE I.SERVER_TIMESTAMP END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST') != 0 THEN I.HOST ELSE MAP(BI.HOST, '%', 'any', BI.HOST) END,
    BI.TIME_AGGREGATE_BY
)
WHERE
  DATA_SIZE_MB > 0 AND
  LOG_SIZE_MB > 0
ORDER BY
  SNAPSHOT_TIME DESC,
  HOST
