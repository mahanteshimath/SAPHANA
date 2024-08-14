SELECT

/* 

[NAME]

- HANA_Tables_IOStatistics_2.00.060+

[DESCRIPTION]

- I/O information on table level (read, write, append, size)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- GLOBAL_TABLE_PERSISTENCE_STATISTICS only covers tables with a disk size of 10 MB or more
- Size values only relevant for non-LOB virtual file columns
- Starting with SAP HANA 2.0 a migration to unified table happens and so the size columns are no longer reliable,
  containing very small or 0 values
- Bug 245809 - Byte columns of M_TABLE_PERSISTENCE_STATISTICS no longer properly filled
- M_TABLE_PERSISTENCE_LOCATION_STATISTICS may not consider LOB sizes and show too low values for SAP HANA <= 2.00.037.05 and <= 2.00.046 (bug 242275)
- GLOBAL_TABLE_PERSISTENCE_STATICS is based on M_TABLE_PERSISTENCE_LOCATION_STATISTICS and so it may show too low values for SAP HANA <= 2.00.037.05 and <= 2.00.046 (bug 242275)
- SITE_ID in history tables available with SAP HANA >= 2.0 SPS 06

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/11/25:  1.0 (initial version)
- 2016/12/31:  1.1 (TIME_AGGREGATE_BY = 'TS<seconds>' included)
- 2017/10/27:  1.2 (TIMEZONE included)
- 2018/12/04:  1.3 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2022/05/26:  1.4 (dedicated 2.00.060+ version including SITE_ID for data source HISTORY)

[INVOLVED TABLES]

- M_TABLE_PERSISTENCE_STATISTICS
- GLOBAL_TABLE_PERSISTENCE_STATISTICS

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

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)
  '%'             --> All data sources

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'          --> Aggregation by timestamp
  'TABLE, SCHEMA' --> Aggregation by table and schema name
  'NONE'          --> No aggregation

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'DISK'          --> Sorting by disk size
  'WRITE'         --> Sorting by amount of written data

- RESULT_ROWS

  Number of records to be returned by the query

  100             --> Return a maximum number of 100 records
  -1              --> Return all records

[OUTPUT PARAMETERS]

- SNAPSHOT_TIME:     Begin of time interval
- ST:                System replication site ID
- SCHEMA_NAME:       Schema name
- TABLE_NAME:        Table name
- DISK_SIZE_GB:      Size on disk (GB)
- READ_GB:           Amount of data read (GB)
- WRITE_GB:          Amount of data written (GB)
- APPEND_GB:         Amount of data appended (GB)

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------
|SNAPSHOT_TIME      |SCHEMA_NAME|TABLE_NAME|DISK_SIZE_GB|READ_GB  |WRITE_GB |APPEND_GB|
---------------------------------------------------------------------------------------
|2015/04/14 01:00:15|any        |any       |      281.88|     1.07|   188.25|    45.68|
|2015/04/13 01:00:15|any        |any       |      284.74|     0.59|    76.03|    37.88|
|2015/04/12 01:00:15|any        |any       |      284.03|     9.32|    10.18|     0.04|
|2015/04/11 01:00:14|any        |any       |      282.45|     0.69|   192.61|    40.06|
|2015/04/10 01:00:14|any        |any       |      272.11|     0.75|   188.09|    37.51|
|2015/04/09 01:00:14|any        |any       |      270.98|     4.85|   199.41|    36.47|
|2015/04/08 01:00:14|any        |any       |      269.40|     0.29|     0.00|     0.00|
|2015/04/07 01:00:12|any        |any       |      262.25|    26.91|   188.58|    30.43|
|2015/04/06 01:00:12|any        |any       |      262.82|     1.06|    22.20|    22.78|
|2015/04/05 01:00:12|any        |any       |      263.22|     2.54|    51.90|    20.29|
|2015/04/04 01:00:12|any        |any       |      263.18|     5.30|   114.10|    20.19|
|2015/04/03 01:00:12|any        |any       |      274.91|     6.15|   192.42|    24.16|
|2015/04/02 01:00:12|any        |any       |      265.25|     3.67|     0.00|     0.00|
|2015/04/01 01:00:16|any        |any       |      267.46|   289.54|   235.00|    26.98|
|2015/03/31 01:00:16|any        |any       |      262.08|   145.73|   218.47|    23.01|
|2015/03/30 01:00:16|any        |any       |      257.83|     2.42|    82.82|    12.73|
|2015/03/29 00:00:16|any        |any       |      261.67|     4.14|   106.86|    14.05|
|2015/03/28 00:00:16|any        |any       |      264.79|   109.84|   197.09|    18.70|
|2015/03/27 00:00:16|any        |any       |      258.58|   269.46|   181.98|    16.79|
|2015/03/26 00:00:16|any        |any       |      257.84|    88.16|   185.52|    22.72|
|2015/03/25 00:00:16|any        |any       |      247.73|     1.49|   184.27|    20.88|
|2015/03/24 00:00:16|any        |any       |      238.30|   212.31|   177.10|    17.06|
|2015/03/23 00:00:16|any        |any       |      236.99|     2.85|    64.14|     9.55|
|2015/03/22 00:00:16|any        |any       |      235.40|     1.82|   103.94|     8.37|
|2015/03/21 00:00:16|any        |any       |      239.89|   411.43|   159.82|    12.26|
|2015/03/20 00:00:16|any        |any       |      237.65|   738.92|   163.36|    13.60|
|2015/03/19 00:00:16|any        |any       |      226.04|   191.25|   133.44|    13.28|
|2015/03/18 00:00:16|any        |any       |      220.81|   150.69|   170.57|    14.81|
|2015/03/17 00:00:16|any        |any       |      215.81|   323.55|   137.23|    12.48|
---------------------------------------------------------------------------------------

*/

  SNAPSHOT_TIME,
  IFNULL(LPAD(SITE_ID, 2), '') ST,
  SCHEMA_NAME,
  TABLE_NAME,
  LPAD(TO_DECIMAL(DISK_SIZE_GB, 10, 2), 12) DISK_SIZE_GB,
  LPAD(TO_DECIMAL(READ_GB,      10, 2),  9)  READ_GB,
  LPAD(TO_DECIMAL(WRITE_GB,     10, 2),  9)  WRITE_GB,
  LPAD(TO_DECIMAL(APPEND_GB,    10, 2),  9)  APPEND_GB
FROM
( SELECT
    SNAPSHOT_TIME,
    SITE_ID,
    SCHEMA_NAME,
    TABLE_NAME,
    DISK_SIZE_GB,
    READ_GB,
    WRITE_GB,
    APPEND_GB,
    ROW_NUMBER () OVER ( ORDER BY MAP(ORDER_BY, 'DISK', DISK_SIZE_GB, 'READ', READ_GB, 'WRITE', WRITE_GB, 'APPEND', APPEND_GB, 'TIME', SNAPSHOT_TIME) DESC ) ROW_NUM,
    RESULT_ROWS
  FROM
  ( SELECT
      CASE 
        WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), SNAPSHOT_TIME) / SUBSTR(TIME_AGGREGATE_BY, 3)) * SUBSTR(TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(SNAPSHOT_TIME, TIME_AGGREGATE_BY)
          END
        ELSE 'any' 
      END SNAPSHOT_TIME,
      SITE_ID,
      SCHEMA_NAME,
      TABLE_NAME,
      MAX(DISK_SIZE_GB) DISK_SIZE_GB,
      SUM(READ_GB) READ_GB,
      SUM(WRITE_GB) WRITE_GB,
      SUM(APPEND_GB) APPEND_GB,
      ORDER_BY,
      RESULT_ROWS
    FROM
    ( SELECT
        SNAPSHOT_TIME,
        CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SITE_ID') != 0 THEN TO_VARCHAR(SITE_ID) ELSE MAP(BI_SITE_ID,      -1, 'any', TO_VARCHAR(BI_SITE_ID)) END SITE_ID,
        CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SCHEMA')  != 0 THEN SCHEMA_NAME         ELSE MAP(BI_SCHEMA_NAME, '%', 'any', BI_SCHEMA_NAME)         END SCHEMA_NAME,
        CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TABLE')   != 0 THEN TABLE_NAME          ELSE MAP(BI_TABLE_NAME,  '%', 'any', BI_TABLE_NAME)          END TABLE_NAME,
        SUM(DISK_SIZE)      / 1024 / 1024 / 1024 DISK_SIZE_GB,
        SUM(BYTES_READ)     / 1024 / 1024 / 1024 READ_GB,
        SUM(BYTES_WRITTEN)  / 1024 / 1024 / 1024 WRITE_GB,
        SUM(BYTES_APPENDED) / 1024 / 1024 / 1024 APPEND_GB,
        AGGREGATE_BY,
        TIME_AGGREGATE_BY,
        ORDER_BY,
        RESULT_ROWS
      FROM
      ( SELECT
          CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(TS.SNAPSHOT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE TS.SNAPSHOT_TIME END SNAPSHOT_TIME,
          TS.SITE_ID,
          TS.TABLE_NAME,
          TS.SCHEMA_NAME,
          TS.DISK_SIZE,
          CASE WHEN TS.DATA_SOURCE = 'CURRENT' THEN TS.BYTES_READ ELSE
            GREATEST(0, TS.BYTES_READ     - LEAD(TS.BYTES_READ, 1)     OVER (PARTITION BY TS.SCHEMA_NAME, TS.TABLE_NAME ORDER BY TS.SNAPSHOT_TIME DESC)) END BYTES_READ,
          CASE WHEN TS.DATA_SOURCE = 'CURRENT' THEN TS.BYTES_WRITTEN ELSE
            GREATEST(0, TS.BYTES_WRITTEN  - LEAD(TS.BYTES_WRITTEN, 1)  OVER (PARTITION BY TS.SCHEMA_NAME, TS.TABLE_NAME ORDER BY TS.SNAPSHOT_TIME DESC)) END BYTES_WRITTEN,
          CASE WHEN TS.DATA_SOURCE = 'CURRENT' THEN TS.BYTES_APPENDED ELSE
            GREATEST(0, TS.BYTES_APPENDED - LEAD(TS.BYTES_APPENDED, 1) OVER (PARTITION BY TS.SCHEMA_NAME, TS.TABLE_NAME ORDER BY TS.SNAPSHOT_TIME DESC)) END BYTES_APPENDED,
          BI.SITE_ID BI_SITE_ID,
          BI.SCHEMA_NAME BI_SCHEMA_NAME,
          BI.TABLE_NAME BI_TABLE_NAME,
          BI.AGGREGATE_BY,
          BI.TIME_AGGREGATE_BY,
          BI.ORDER_BY,
          BI.RESULT_ROWS
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
            SCHEMA_NAME,
            TABLE_NAME,
            DATA_SOURCE,
            AGGREGATE_BY,
            MAP(TIME_AGGREGATE_BY,
              'NONE',        'YYYY/MM/DD HH24:MI:SS',
              'HOUR',        'YYYY/MM/DD HH24',
              'DAY',         'YYYY/MM/DD (DY)',
              'HOUR_OF_DAY', 'HH24',
              TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
            ORDER_BY,
            RESULT_ROWS
          FROM
          ( SELECT                 /* Modification section */
              '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
              '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
              'SERVER' TIMEZONE,                              /* SERVER, UTC */
              -1 SITE_ID,
              '%' SCHEMA_NAME,
              '%' TABLE_NAME,
              'HISTORY' DATA_SOURCE,            /* CURRENT, HISTORY */
              'TIME' AGGREGATE_BY,              /* TIME, SITE_ID, TABLE, SCHEMA or comma-separated combinations, NONE for no aggregation */
              'HOUR' TIME_AGGREGATE_BY,         /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
              'TIME' ORDER_BY,                  /* TIME, DISK, READ, WRITE, APPEND */
              100 RESULT_ROWS
            FROM
              DUMMY
          )
        ) BI,
        ( SELECT
            'CURRENT' DATA_SOURCE,
            CURRENT_TIMESTAMP SNAPSHOT_TIME,
            CURRENT_SITE_ID() SITE_ID,
            TABLE_NAME,
            SCHEMA_NAME,
            DISK_SIZE,
            BYTES_READ,
            BYTES_WRITTEN,
            BYTES_APPENDED
          FROM
            M_TABLE_PERSISTENCE_STATISTICS
          UNION ALL
          ( SELECT
              'HISTORY' DATA_SOURCE,
              SERVER_TIMESTAMP SNAPSHOT_TIME,
              SITE_ID,
              TABLE_NAME,
              SCHEMA_NAME,
              DISK_SIZE,
              BYTES_READ,
              BYTES_WRITTEN,
              BYTES_APPENDED
            FROM
              _SYS_STATISTICS.GLOBAL_TABLE_PERSISTENCE_STATISTICS
          )
        ) TS
        WHERE
          CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(TS.SNAPSHOT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE TS.SNAPSHOT_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
          ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND TS.SITE_ID IN (-1, 0) ) OR TS.SITE_ID = BI.SITE_ID ) AND
          TS.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
          TS.TABLE_NAME LIKE BI.TABLE_NAME AND
          TS.DATA_SOURCE = BI.DATA_SOURCE
      )
      GROUP BY
        SNAPSHOT_TIME,
        CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SITE_ID') != 0 THEN TO_VARCHAR(SITE_ID) ELSE MAP(BI_SITE_ID,      -1, 'any', TO_VARCHAR(BI_SITE_ID)) END,
        CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SCHEMA')  != 0 THEN SCHEMA_NAME         ELSE MAP(BI_SCHEMA_NAME, '%', 'any', BI_SCHEMA_NAME)         END,
        CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TABLE')   != 0 THEN TABLE_NAME          ELSE MAP(BI_TABLE_NAME,  '%', 'any', BI_TABLE_NAME)          END,
        AGGREGATE_BY,
        TIME_AGGREGATE_BY,
        ORDER_BY,
        RESULT_ROWS
    )
    GROUP BY
      CASE 
        WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), SNAPSHOT_TIME) / SUBSTR(TIME_AGGREGATE_BY, 3)) * SUBSTR(TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(SNAPSHOT_TIME, TIME_AGGREGATE_BY)
          END
        ELSE 'any' 
      END,
      SITE_ID,
      SCHEMA_NAME,
      TABLE_NAME,
      ORDER_BY,
      RESULT_ROWS
  )
)
WHERE
  ( RESULT_ROWS = -1 OR ROW_NUM <= RESULT_ROWS )
ORDER BY
  ROW_NUM