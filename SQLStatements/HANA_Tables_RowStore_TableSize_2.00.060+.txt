SELECT

/* 

[NAME]

- HANA_Tables_RowStore_TableSize_2.00.060+

[DESCRIPTION]

- Row store table sizes

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_RS_TABLES.SCAN_COUNT available starting with SAP HANA 2.00.040
- SITE_ID in history tables available with SAP HANA >= 2.0 SPS 06

[VALID FOR]

- Revisions:              >= 2.00.060

[SQL COMMAND VERSION]

- 2014/03/06:  1.0 (initial version)
- 2016/08/18:  1.1 (AGGREGATE_BY and ORDER_BY included)
- 2016/12/31:  1.2 (TIME_AGGREGATE_BY = 'TS<seconds>' included)
- 2017/10/27:  1.3 (TIMEZONE included)
- 2017/11/01:  1.4 (M_RS_TABLES and DATA_SOURCE included)
- 2018/12/04:  1.5 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2019/07/21:  1.6 (dedicated 2.00.040+ version including M_RS_TABLES.SCAN_COUNT
- 2022/05/27:  1.7 (dedicated 2.00.060+ version including SITE_ID for data source HISTORY)

[INVOLVED TABLES]

- GLOBAL_ROWSTORE_TABLES_SIZE
- M_RS_TABLES

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

  'saphana01'     --> Specic host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

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

- ONLY_TABLES_ON_WORKER_NODES

  Possibility to restrict the output to row store tables located on worker nodes

  'X'             --> Only display row store tables located on worker nodes
  ' '             --> No restriction related to row store table location

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'HISTORY'       --> Data from persisted history information (HOST_ and GLOBAL_ tables)

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'          --> Aggregation by time
  'SCHEMA, TABLE' --> Aggregation by schema and table
  'NONE'          --> No aggregation

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'USED'          --> Sorting by used size
  'FRAG'          --> Sorting by fragmented size

[OUTPUT PARAMETERS]

- SNAPSHOT_TIME: Timestamp
- ST:            System replication site ID
- HOST:          Host name
- SCHEMA_NAME:   Schema name
- TABLE_NAME:    Table name
- NUM_ROWS:      Number of table rows
- ALLOC_GB:      Allocated table size (GB)
- USED_GB:       Used table size (GB)
- FRAG_GB:       Fragmented table size (GB)
- FRAG_PCT:      Percentage of fragmented table size
- SCANS:         Table scans
- SCANNED_ROWS:  Scanned records

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------
|SAMPLE_TIME     |HOST     |SCHEMA_NAME|TABLE_NAME|NUM_ROWS  |ALLOC_GB    |USED_GB     |WASTED_GB   |WASTED_PCT|
----------------------------------------------------------------------------------------------------------------
|2014/04/22 (TUE)|saphana21|SAPECC     |A726      | 226215741|       18.67|       18.32|        0.34|      1.84|
|2014/04/21 (MON)|saphana21|SAPECC     |A726      | 226165609|       18.67|       18.32|        0.34|      1.84|
|2014/04/20 (SUN)|saphana21|SAPECC     |A726      | 225324494|       18.60|       18.25|        0.34|      1.85|
|2014/04/20 (SUN)|saphana20|SAPECC     |A726      | 225181686|       18.59|       18.24|        0.34|      1.86|
|2014/04/19 (SAT)|saphana20|SAPECC     |A726      | 225125189|       18.58|       18.24|        0.34|      1.85|
|2014/04/18 (FRI)|saphana20|SAPECC     |A726      | 224286337|       18.51|       18.17|        0.34|      1.84|
|2014/04/17 (THU)|saphana20|SAPECC     |A726      | 222692055|       18.38|       18.04|        0.33|      1.84|
|2014/04/16 (WED)|saphana20|SAPECC     |A726      | 222512584|       18.36|       18.02|        0.33|      1.84|
|2014/04/15 (TUE)|saphana20|SAPECC     |A726      | 222421225|       18.36|       18.02|        0.33|      1.84|
----------------------------------------------------------------------------------------------------------------

*/

  SAMPLE_TIME SNAPSHOT_TIME,
  IFNULL(LPAD(SITE_ID, 2), '') ST,
  HOST,
  SCHEMA_NAME,
  TABLE_NAME,
  LPAD(TO_DECIMAL(ROUND(NUM_ROWS), 10, 0), 10) NUM_ROWS,
  LPAD(TO_DECIMAL(ALLOC_GB, 10, 2), 12) ALLOC_GB,
  LPAD(TO_DECIMAL(USED_GB, 10, 2), 12) USED_GB,
  LPAD(TO_DECIMAL(FRAG_GB, 10, 2), 12) FRAG_GB,
  LPAD(TO_DECIMAL(FRAG_PCT, 5, 2), 10) FRAG_PCT,
  LPAD(TO_DECIMAL(SCAN_COUNT, 10, 0), 11) SCANS,
  LPAD(TO_DECIMAL(SCAN_COUNT * NUM_ROWS, 15, 0), 15) SCANNED_ROWS
FROM
( SELECT
    SAMPLE_TIME,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SITE_ID') != 0 THEN TO_VARCHAR(SITE_ID) ELSE MAP(BI_SITE_ID,      -1, 'any', TO_VARCHAR(BI_SITE_ID)) END SITE_ID,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST')    != 0 THEN HOST                ELSE MAP(BI_HOST,        '%', 'any', BI_HOST)                END HOST,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SCHEMA')  != 0 THEN SCHEMA_NAME         ELSE MAP(BI_SCHEMA_NAME, '%', 'any', BI_SCHEMA_NAME)         END SCHEMA_NAME,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TABLE')   != 0 THEN TABLE_NAME          ELSE MAP(BI_TABLE_NAME,  '%', 'any', BI_TABLE_NAME)          END TABLE_NAME,
    SUM(NUM_ROWS) NUM_ROWS,
    SUM(SCAN_COUNT) SCAN_COUNT,
    SUM(ALLOC_BYTE) / 1024 / 1024 / 1024 ALLOC_GB,
    SUM(USED_BYTE) / 1024 / 1024 / 1024 USED_GB,
    ( SUM(ALLOC_BYTE) - SUM(USED_BYTE) ) / 1024 / 1024 / 1024 FRAG_GB,
    MAP(SUM(ALLOC_BYTE), 0, 0, 100 - SUM(USED_BYTE) / SUM(ALLOC_BYTE) * 100) FRAG_PCT,
    ORDER_BY
  FROM
  ( SELECT
      CASE 
        WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(RT.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE RT.SERVER_TIMESTAMP END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(RT.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE RT.SERVER_TIMESTAMP END, BI.TIME_AGGREGATE_BY)
          END
        ELSE 'any' 
      END SAMPLE_TIME,
      RT.SCHEMA_NAME,
      RT.TABLE_NAME,
      RT.SITE_ID,
      RT.HOST,
      AVG(RT.RECORD_COUNT) NUM_ROWS,
      AVG(RT.SCAN_COUNT) SCAN_COUNT,
      AVG(RT.ALLOCATED_FIXED_PART_SIZE + RT.ALLOCATED_VARIABLE_PART_SIZE) ALLOC_BYTE,
      AVG(RT.USED_FIXED_PART_SIZE + RT.USED_VARIABLE_PART_SIZE) USED_BYTE,
      BI.ORDER_BY,
      BI.SITE_ID BI_SITE_ID,
      BI.HOST BI_HOST,
      BI.SCHEMA_NAME BI_SCHEMA_NAME,
      BI.TABLE_NAME BI_TABLE_NAME,
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
        SITE_ID,
        HOST,
        SCHEMA_NAME,
        TABLE_NAME,
        ONLY_TABLES_ON_WORKER_NODES,
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
      ( SELECT                                                      /* Modification section */
          '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
          '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
          'SERVER' TIMEZONE,                              /* SERVER, UTC */
          -1 SITE_ID,
          '%' HOST,
          '%' SCHEMA_NAME,
          '%' TABLE_NAME,
          ' ' ONLY_TABLES_ON_WORKER_NODES,
          'CURRENT' DATA_SOURCE,
          'TABLE' AGGREGATE_BY,          /* TIME, SITE_ID, HOST, SCHEMA, TABLE or comma separated combinations, NONE for no aggregation */
          'NONE' TIME_AGGREGATE_BY,     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
          'SCANNED_ROWS' ORDER_BY              /* TIME, ALLOC, USED, FRAG, SCANS, SCANNED_ROWS */
        FROM
          DUMMY
      )
    ) BI,
    ( SELECT TOP 1 HOST MASTER FROM M_LANDSCAPE_HOST_CONFIGURATION WHERE INDEXSERVER_ACTUAL_ROLE = 'MASTER' ) L,
    ( SELECT
        'CURRENT' DATA_SOURCE,
        CURRENT_TIMESTAMP SERVER_TIMESTAMP,
        CURRENT_SITE_ID() SITE_ID,
        SCHEMA_NAME,
        TABLE_NAME,
        HOST,
        RECORD_COUNT,
        ALLOCATED_FIXED_PART_SIZE,
        ALLOCATED_VARIABLE_PART_SIZE,
        USED_FIXED_PART_SIZE,
        USED_VARIABLE_PART_SIZE,
        SCAN_COUNT
      FROM
        M_RS_TABLES
      UNION ALL
      SELECT
        'HISTORY' DATA_SOURCE,
        SERVER_TIMESTAMP,
        SITE_ID,
        SCHEMA_NAME,
        TABLE_NAME,
        HOST,
        RECORD_COUNT,
        ALLOCATED_FIXED_PART_SIZE,
        ALLOCATED_VARIABLE_PART_SIZE,
        USED_FIXED_PART_SIZE,
        USED_VARIABLE_PART_SIZE,
        0 SCAN_COUNT
      FROM
        _SYS_STATISTICS.GLOBAL_ROWSTORE_TABLES_SIZE
    ) RT
    WHERE
      ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND RT.SITE_ID IN (-1, 0) ) OR RT.SITE_ID = BI.SITE_ID ) AND
      RT.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
      RT.TABLE_NAME LIKE BI.TABLE_NAME AND
      RT.HOST LIKE BI.HOST AND
      ( BI.ONLY_TABLES_ON_WORKER_NODES = ' ' OR RT.HOST != L.MASTER ) AND
      RT.DATA_SOURCE = BI.DATA_SOURCE AND
      CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(RT.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE RT.SERVER_TIMESTAMP END BETWEEN BI.BEGIN_TIME AND BI.END_TIME
    GROUP BY
      CASE 
        WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(RT.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE RT.SERVER_TIMESTAMP END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(RT.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE RT.SERVER_TIMESTAMP END, BI.TIME_AGGREGATE_BY)
          END
        ELSE 'any' 
      END,
      RT.SCHEMA_NAME,
      RT.TABLE_NAME,
      RT.SITE_ID,
      RT.HOST,
      BI.ORDER_BY,
      BI.SITE_ID,
      BI.HOST,
      BI.SCHEMA_NAME,
      BI.TABLE_NAME,
      BI.AGGREGATE_BY
  )
  GROUP BY
    SAMPLE_TIME,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SITE_ID') != 0 THEN TO_VARCHAR(SITE_ID) ELSE MAP(BI_SITE_ID,      -1, 'any', TO_VARCHAR(BI_SITE_ID)) END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST')    != 0 THEN HOST                ELSE MAP(BI_HOST,        '%', 'any', BI_HOST)                END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SCHEMA')  != 0 THEN SCHEMA_NAME         ELSE MAP(BI_SCHEMA_NAME, '%', 'any', BI_SCHEMA_NAME)         END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TABLE')   != 0 THEN TABLE_NAME          ELSE MAP(BI_TABLE_NAME,  '%', 'any', BI_TABLE_NAME)          END,
    ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'ALLOC', ALLOC_GB, 'USED', USED_GB, 'FRAG', FRAG_GB, 'SCANS', SCAN_COUNT, 'SCANNED_ROWS', SCAN_COUNT * NUM_ROWS) DESC,
  SAMPLE_TIME DESC,
  SITE_ID