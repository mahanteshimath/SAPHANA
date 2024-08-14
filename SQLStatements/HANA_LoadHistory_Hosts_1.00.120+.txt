SELECT
/* 

[NAME]

- HANA_LoadHistory_Hosts_1.00.120+

[DESCRIPTION]

- Nameserver load history for host level information
- Traditionally collected in nameserver_history.trc and display in "Performance" -> "Load" in SAP HANA Studio
- As of SAP HANA 1.00.90 available via SQL
- Displayed values are generally average values (per sample time)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_LOAD_HISTORY_HOST available as of SAP HANA 1.00.90
- HOST_LOAD_HISTORY_HOST available as of SAP HANA 1.00.120

[VALID FOR]

- Revisions:              >= 1.00.120

[SQL COMMAND VERSION]

- 2015/01/27:  1.0 (initial version)
- 2016/02/03:  1.2 (aggregation bug corrected)
- 2016/07/19:  1.3 (dedicated Rev120+ version including HOST_LOAD_HISTORY_HOST
- 2016/12/31:  1.4 (TIME_AGGREGATE_BY = 'TS<seconds>' included)
- 2017/10/25:  1.5 (TIMEZONE included)
- 2018/12/04:  1.6 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2021/02/26:  1.7 (network units changed from MB to MBPS)
- 2022/11/10:  1.8 (redesigned memory columns)

[INVOLVED TABLES]

- HOST_LOAD_HISTORY_HOST
- M_LOAD_HISTORY_HOST

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

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'          --> Aggregation by time
  'TIME, PORT'    --> Aggregation by time and port
  'NONE'          --> No aggregation

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation
  
[OUTPUT PARAMETERS]

- SNAPSHOT_TIME:    Start time of considered time interval
- HOST:             Host name
- CPU_PCT:          Total CPU consumption of all SAP HANA processes (%)
- HOST_TOTAL_GB:    Available host memory (GB)
- HOST_USED_GB:     Used host memory (GB)
- HANA_LIMIT_GB:    SAP HANA global allocation limit (GB)
- HANA_ALLOC_DB:    Allocated SAP HANA instance memory (GB)
- HANA_USED_GB:     Used SAP HAnA instance memory (GB)
- USED_DISK_GB:     Disk space used by SAP HANA (GB)
- DISK_PCT:         Percentage of overall disk space used by SAP HANA
- NETWORK_IN_MBPS:  Network reads of all SAP HANA processes (MB/s)
- NETWORK_OUT_MBPS: Network writes of all SAP HANA processes (MB/s)
- SWAP_IN_MB:       Swap in operations of all SAP HANA processes (MB)
- SWAP_OUT_MB:      Swap out operations of all SAP HANA processes (MB)

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------
|SAMPLE_TIME     |HOST  |CPU_PCT|USED_MEM_GB|MEM_PCT|USED_DISK_GB|DISK_PCT|NETWORK_IN_MB|NETWORK_OUT_MB|SWAP_IN_MB|SWAP_OUT_MB|
-------------------------------------------------------------------------------------------------------------------------------
|2015/01/27 (TUE)|hana01|      3|     151.26|     30|     1723.69|      61|         5.61|        261.06|      0.00|       0.00|
|2015/01/26 (MON)|hana01|      1|     150.46|     30|     1708.60|      61|         0.79|          4.81|      0.00|       0.00|
|2015/01/25 (SUN)|hana01|      1|     149.93|     30|     1707.23|      61|         0.36|          2.53|      0.00|       0.00|
|2015/01/24 (SAT)|hana01|      9|     150.09|     30|     1762.86|      63|         0.31|          2.51|      0.00|       0.00|
|2015/01/23 (FRI)|hana01|      8|     153.22|     30|     1837.55|      65|         2.89|        155.11|      0.00|       0.00|
|2015/01/22 (THU)|hana01|     46|     153.10|     30|     1897.07|      67|         1.10|          1.83|      0.00|       0.00|
|2015/01/21 (WED)|hana01|     56|     152.86|     30|     1895.70|      67|         7.18|          1.79|      0.08|       0.00|
|2015/01/20 (TUE)|hana01|     39|     144.96|     29|     1897.49|      67|         1.94|        158.04|      0.00|       0.00|
|2015/01/19 (MON)|hana01|     35|     135.50|     27|     1887.37|      67|         0.73|          1.79|      0.00|       0.00|
|2015/01/18 (SUN)|hana01|     35|     134.55|     27|     1887.28|      67|         0.30|          1.04|      0.03|       0.00|
|2015/01/17 (SAT)|hana01|     17|     133.23|     26|     1834.76|      65|         0.34|          1.03|      0.00|       0.00|
|2015/01/16 (FRI)|hana01|     61|     130.76|     26|     1822.28|      65|         3.64|        154.78|      0.00|       0.00|
|2015/01/15 (THU)|hana01|     60|     126.55|     25|     1873.62|      66|         4.06|          1.80|      0.00|       0.00|
|2015/01/14 (WED)|hana01|     63|     163.14|     32|     1872.75|      66|         0.59|          1.45|      1.21|       0.00|
|2015/01/13 (TUE)|hana01|     34|     175.70|     35|     1860.11|      66|         5.82|        159.56|      8.39|       0.00|
-------------------------------------------------------------------------------------------------------------------------------

*/

  SAMPLE_TIME SNAPSHOT_TIME,
  HOST,
  LPAD(TO_DECIMAL(GREATEST(ROUND(CPU_PCT), 0), 10, 0), 7) CPU_PCT,
  LPAD(TO_DECIMAL(GREATEST(HOST_TOTAL_GB, 0), 10, 0), 13) HOST_TOTAL_GB,
  LPAD(TO_DECIMAL(GREATEST(HANA_LIMIT_GB, 0), 10, 0), 13) HANA_LIMIT_GB,
  LPAD(TO_DECIMAL(GREATEST(HOST_USED_GB, 0), 10, 0), 12) HOST_USED_GB,
  LPAD(TO_DECIMAL(GREATEST(HANA_ALLOC_GB, 0), 10, 0), 13) HANA_ALLOC_GB,
  LPAD(TO_DECIMAL(GREATEST(HANA_USED_GB, 0), 10, 0), 12) HANA_USED_GB,
  LPAD(TO_DECIMAL(GREATEST(USED_DISK_GB, 0), 10, 2), 12) USED_DISK_GB,
  LPAD(TO_DECIMAL(GREATEST(ROUND(USED_DISK_PCT), 0), 10, 0), 8) DISK_PCT,
  LPAD(TO_DECIMAL(GREATEST(NETWORK_IN_MBPS, 0), 10, 2), 15) NETWORK_IN_MBPS, 
  LPAD(TO_DECIMAL(GREATEST(NETWORK_OUT_MBPS, 0), 10, 2), 16) NETWORK_OUT_MBPS,
  LPAD(TO_DECIMAL(GREATEST(SWAP_IN_MB, 0), 10, 2), 10) SWAP_IN_MB,
  LPAD(TO_DECIMAL(GREATEST(SWAP_OUT_MB, 0), 10, 2), 11) SWAP_OUT_MB
FROM
( SELECT
    SAMPLE_TIME,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST') != 0 THEN HOST ELSE MAP(BI_HOST, '%', 'any', BI_HOST) END HOST,
    AVG(CPU_PCT) CPU_PCT,
    SUM(HOST_TOTAL_GB) HOST_TOTAL_GB,
    SUM(HOST_USED_GB) HOST_USED_GB,
    SUM(HANA_LIMIT_GB) HANA_LIMIT_GB,
    SUM(HANA_ALLOC_GB) HANA_ALLOC_GB,
    SUM(HANA_USED_GB) HANA_USED_GB,
    SUM(USED_DISK_GB) USED_DISK_GB,
    MAP(SUM(TOTAL_DISK_GB), 0, 0, SUM(USED_DISK_GB) / SUM(TOTAL_DISK_GB) * 100) USED_DISK_PCT,
    MAP(MAX(INTERVAL_S), 0, 0, SUM(NETWORK_IN_MB) / MAX(INTERVAL_S)) NETWORK_IN_MBPS,
    MAP(MAX(INTERVAL_S), 0, 0, SUM(NETWORK_OUT_MB) / MAX(INTERVAL_S)) NETWORK_OUT_MBPS,
    SUM(SWAP_IN_MB) SWAP_IN_MB,
    SUM(SWAP_OUT_MB) SWAP_OUT_MB
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
      AVG(L.CPU) CPU_PCT,
      AVG(L.MEMORY_SIZE) / 1024 / 1024 / 1024 HOST_TOTAL_GB,
      AVG(L.MEMORY_TOTAL_RESIDENT) / 1024 / 1024 / 1024 HOST_USED_GB,
      AVG(L.MEMORY_ALLOCATION_LIMIT) / 1024 / 1024 / 1024 HANA_LIMIT_GB,
      AVG(L.MEMORY_RESIDENT) / 1024 / 1024 / 1024 HANA_ALLOC_GB,
      AVG(L.MEMORY_USED) / 1024 / 1024 / 1024 HANA_USED_GB,
      AVG(L.DISK_USED) / 1024 / 1024 / 1024 USED_DISK_GB,
      AVG(L.DISK_SIZE) / 1024 / 1024 / 1024 TOTAL_DISK_GB,
      SUM(L.NETWORK_IN) / 1024 / 1024 NETWORK_IN_MB,
      SUM(L.NETWORK_OUT) / 1024 / 1024 NETWORK_OUT_MB,
      SUM(L.INTERVAL_S) INTERVAL_S,
      AVG(L.SWAP_IN) / 1024 / 1024 SWAP_IN_MB,
      AVG(L.SWAP_OUT) / 1024 / 1024 SWAP_OUT_MB,
      BI.HOST BI_HOST,
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
        DATA_SOURCE,
        AGGREGATE_BY,
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
          'CURRENT' DATA_SOURCE,
          'NONE' AGGREGATE_BY,               /* TIME, HOST and comma separated combinations, NONE for no aggregation */
          'TS900' TIME_AGGREGATE_BY     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        FROM
          DUMMY
      )
    ) BI,
    ( SELECT
        'CURRENT' DATA_SOURCE,
        HOST,
        TIME,
        CPU,
        MEMORY_SIZE,
        MEMORY_ALLOCATION_LIMIT,
        MEMORY_TOTAL_RESIDENT,
        MEMORY_RESIDENT,
        MEMORY_USED,
        DISK_USED,
        DISK_SIZE,
        NETWORK_IN,
        NETWORK_OUT,
        SWAP_IN,
        SWAP_OUT,
        NANO100_BETWEEN(LEAD(TIME, 1) OVER (PARTITION BY HOST ORDER BY TIME DESC), TIME) / 10000000 INTERVAL_S
      FROM
        M_LOAD_HISTORY_HOST
      UNION ALL
      SELECT
        'HISTORY' DATA_SOURCE,
        HOST,
        TIME,
        CPU,
        MEMORY_SIZE,
        MEMORY_ALLOCATION_LIMIT,
        MEMORY_TOTAL_RESIDENT,
        MEMORY_RESIDENT,
        MEMORY_USED,
        DISK_USED,
        DISK_SIZE,
        NETWORK_IN,
        NETWORK_OUT,
        SWAP_IN,
        SWAP_OUT,
        NANO100_BETWEEN(LEAD(TIME, 1) OVER (PARTITION BY HOST ORDER BY TIME DESC), TIME) / 10000000 INTERVAL_S
      FROM
        _SYS_STATISTICS.HOST_LOAD_HISTORY_HOST
    ) L
    WHERE
      L.HOST LIKE BI.HOST AND
      CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
      L.DATA_SOURCE = BI.DATA_SOURCE
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
      BI.HOST,
      BI.AGGREGATE_BY
  )
  GROUP BY
    SAMPLE_TIME,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST') != 0 THEN HOST ELSE MAP(BI_HOST, '%', 'any', BI_HOST) END
)
ORDER BY
  SAMPLE_TIME DESC