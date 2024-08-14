SELECT
/* 

[NAME]

- HANA_Disks_DiskUsage_2.00.040+

[DESCRIPTION]

- Disk usage information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_DISK_USAGE only available as SAP HANA 1.00.090
- GLOBAL_DISK_USAGE available starting with SAP HANA 2.00.040
- Wrong values possible with SAP HANA <= 2.00.059.04 and <= 2.00.063 because volume partitioning is not properly considered (issue number 288466)

[VALID FOR]

- Revisions:              >= 2.00.040

[SQL COMMAND VERSION]

- 2018/10/18:  1.0 (initial version)
- 2018/12/04:  1.1 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2019/07/28:  1.2 (dedicated 2.00.040+ version considering GLOBAL_DISK_USAGE instead of TEL_DISK_USAGE)
- 2019/12/17:  1.3 (HOST included)

[INVOLVED TABLES]

- M_DISK_USAGE
- GLOBAL_DISK_USAGE

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
  '%'             --> All data sources

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation

[OUTPUT PARAMETERS]

- SNAPSHOT_TIME: Snapshot time
- HOST:          Host
- DATA_GB:       Size of data volume (GB)
- LOG_GB:        Size of log volume (GB)
- DATA_BKP_GB:   Size of data backup volume (GB)
- LOG_BKP_GB:    Size of log backup volume (GB)
- CAT_BKP_GB:    Size of catalog backup volume (GB)
- TRACE_GB:      Size of trace volume (GB)
- RK_BKP_GB:     Size of rootkey backup volume (GB)

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------
|SAMPLE_TIME     |DATA_GB    |LOG_GB     |DATA_BKP_GB|LOG_BKP_GB |CAT_BKP_GB |TRACE_GB   |RK_BKP_GB  |
------------------------------------------------------------------------------------------------------
|2018/10/18 (THU)|       1.70|       0.12|       0.00|       2.11|       2.11|       0.02|       0.00|
|2018/10/17 (WED)|       1.70|       0.12|       0.00|       1.48|       1.48|       0.01|       0.00|
|2018/10/16 (TUE)|       1.70|       0.12|       0.00|       0.85|       0.85|       0.01|       0.00|
|2018/10/15 (MON)|       0.46|       0.31|       0.00|       0.00|       0.00|       0.00|       0.00|
------------------------------------------------------------------------------------------------------

*/

  SNAPSHOT_TIME,
  HOST,
  LPAD(TO_DECIMAL(DATA_GB, 10, 2), 11) DATA_GB,
  LPAD(TO_DECIMAL(LOG_GB, 10, 2), 11) LOG_GB,
  LPAD(TO_DECIMAL(DATA_BACKUP_GB, 10, 2), 11) DATA_BKP_GB,
  LPAD(TO_DECIMAL(LOG_BACKUP_GB, 10, 2), 11) LOG_BKP_GB,
  LPAD(TO_DECIMAL(CATALOG_BACKUP_GB, 10, 2), 11) CAT_BKP_GB,
  LPAD(TO_DECIMAL(TRACE_GB, 10, 2), 11) TRACE_GB,
  LPAD(TO_DECIMAL(ROOTKEY_BACKUP_GB, 10, 2), 11) RK_BKP_GB
FROM
( SELECT
    SNAPSHOT_TIME,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST') != 0 THEN HOST ELSE MAP(BI_HOST, '%', 'any', BI_HOST) END HOST,
    SUM(DATA_GB) DATA_GB,
    SUM(LOG_GB) LOG_GB,
    SUM(DATA_BACKUP_GB) DATA_BACKUP_GB,
    SUM(LOG_BACKUP_GB) LOG_BACKUP_GB,
    SUM(CATALOG_BACKUP_GB) CATALOG_BACKUP_GB,
    SUM(TRACE_GB) TRACE_GB,
    SUM(ROOTKEY_BACKUP_GB) ROOTKEY_BACKUP_GB
  FROM
  ( SELECT
      CASE 
        WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(DU.SNAPSHOT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE DU.SNAPSHOT_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(DU.SNAPSHOT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE DU.SNAPSHOT_TIME END, BI.TIME_AGGREGATE_BY)
        END
        ELSE 'any'
      END SNAPSHOT_TIME,
      DU.HOST,
      AVG(DU.DATA) / 1024 / 1024 / 1024 DATA_GB,
      AVG(DU.LOG) / 1024 / 1024 / 1024 LOG_GB,
      AVG(DU.DATA_BACKUP) / 1024 / 1024 / 1024 DATA_BACKUP_GB,
      AVG(DU.LOG_BACKUP) / 1024 / 1024 / 1024 LOG_BACKUP_GB,
      AVG(DU.CATALOG_BACKUP) / 1024 / 1024 / 1024 CATALOG_BACKUP_GB,
      AVG(DU.TRACE) / 1024 / 1024 / 1024 TRACE_GB,
      AVG(DU.ROOTKEY_BACKUP) / 1024 / 1024 / 1024 ROOTKEY_BACKUP_GB,
      BI.AGGREGATE_BY,
      BI.HOST BI_HOST
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
          'NONE',        'YYYY/MM/DD HH24:MI:SS:FF7',
          'HOUR',        'YYYY/MM/DD HH24',
          'DAY',         'YYYY/MM/DD (DY)',
          'HOUR_OF_DAY', 'HH24',
          TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY
      FROM
      ( SELECT                       /* Modification section */
          '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
          '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
          'SERVER' TIMEZONE,                              /* SERVER, UTC */
          '%' HOST,
          'HISTORY' DATA_SOURCE,               /* CURRENT, HISTORY */
          'NONE' AGGREGATE_BY,           /* TIME, HOST or comma separated combinations, NONE for no aggregation */
          'DAY' TIME_AGGREGATE_BY     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        FROM
          DUMMY
      )
    ) BI,
    ( SELECT
        'CURRENT' DATA_SOURCE,
        CURRENT_TIMESTAMP SNAPSHOT_TIME,
        HOST,
        SUM(MAP(USAGE_TYPE, 'DATA', USED_SIZE, 0)) DATA,
        SUM(MAP(USAGE_TYPE, 'LOG', USED_SIZE, 0)) LOG,
        SUM(MAP(USAGE_TYPE, 'DATA_BACKUP', USED_SIZE, 0)) DATA_BACKUP,
        SUM(MAP(USAGE_TYPE, 'LOG_BACKUP', USED_SIZE, 0)) LOG_BACKUP,
        SUM(MAP(USAGE_TYPE, 'TRACE', USED_SIZE, 0)) TRACE,
        SUM(MAP(USAGE_TYPE, 'CATALOG_BACKUP', USED_SIZE, 0)) CATALOG_BACKUP,
        SUM(MAP(USAGE_TYPE, 'ROOTKEY_BACKUP', USED_SIZE, 0)) ROOTKEY_BACKUP
      FROM
        M_DISK_USAGE
      GROUP BY
        HOST
      UNION ALL
      SELECT
        'HISTORY' DATA_SOURCE,
        SERVER_TIMESTAMP SNAPSHOT_TIME,
        HOST,
        SUM(MAP(USAGE_TYPE, 'DATA', USED_SIZE, 0)) DATA,
        SUM(MAP(USAGE_TYPE, 'LOG', USED_SIZE, 0)) LOG,
        SUM(MAP(USAGE_TYPE, 'DATA_BACKUP', USED_SIZE, 0)) DATA_BACKUP,
        SUM(MAP(USAGE_TYPE, 'LOG_BACKUP', USED_SIZE, 0)) LOG_BACKUP,
        SUM(MAP(USAGE_TYPE, 'TRACE', USED_SIZE, 0)) TRACE,
        SUM(MAP(USAGE_TYPE, 'CATALOG_BACKUP', USED_SIZE, 0)) CATALOG_BACKUP,
        SUM(MAP(USAGE_TYPE, 'ROOTKEY_BACKUP', USED_SIZE, 0)) ROOTKEY_BACKUP
      FROM
        _SYS_STATISTICS.GLOBAL_DISK_USAGE
      GROUP BY
        SERVER_TIMESTAMP,
        HOST
    ) DU
    WHERE
      CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(DU.SNAPSHOT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE DU.SNAPSHOT_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
      DU.HOST LIKE BI.HOST AND
      DU.DATA_SOURCE = BI.DATA_SOURCE
    GROUP BY
      CASE 
        WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(DU.SNAPSHOT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE DU.SNAPSHOT_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(DU.SNAPSHOT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE DU.SNAPSHOT_TIME END, BI.TIME_AGGREGATE_BY)
        END
        ELSE 'any'
      END,
      DU.HOST,
      BI.AGGREGATE_BY,
      BI.HOST
  )
  GROUP BY
    SNAPSHOT_TIME,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST') != 0 THEN HOST ELSE MAP(BI_HOST, '%', 'any', BI_HOST) END
)
ORDER BY
  SNAPSHOT_TIME DESC,
  HOST
