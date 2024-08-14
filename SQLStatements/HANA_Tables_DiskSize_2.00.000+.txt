SELECT
/* 

[NAME]

- HANA_Tables_DiskSize_2.00.000+

[DESCRIPTION]

- Table disk space allocation

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_TABLE_LOB_STATISTICS available starting with 1.00.120
- HOST and PORT columns of GLOBAL_TABLE_PERSISTENCE_STATISTICS available starting with SAP HANA 2.00.000
- M_TABLE_PERSISTENCE_LOCATION_STATISTICS may not consider LOB sizes and show too low values for SAP HANA <= 2.00.037.05 and <= 2.00.046 (bug 242275)
- GLOBAL_TABLE_PERSISTENCE_STATICS is based on M_TABLE_PERSISTENCE_LOCATION_STATISTICS and so it may show too low values for SAP HANA <= 2.00.037.05 and <= 2.00.046 (bug 242275)

[VALID FOR]

- Revisions:              >= 2.00.000

[SQL COMMAND VERSION]

- 2015/09/18:  1.0 (initial version)
- 2016/12/06:  1.1 (switch from M_TABLE_LOB_FILES to M_TABLE_LOB_STATISTICS)
- 2017/03/15:  1.2 (SIZE_NOLOB_GB included)
- 2017/12/14:  1.3 (dedicated 2.00.000+ version including DATA_SOURCE = 'HISTORY')
- 2018/12/04:  1.4 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2019/12/16:  1.5 (Transition from M_TABLE_PERSISTENCE_STATISTICS to M_TABLE_PERSISTENCE_LOCATION_STATISTICS)

[INVOLVED TABLES]

- M_TABLE_PERSISTENCE_LOCATION_STATISTICS
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

- HOST

  Host name

  'saphana01'     --> Specic host saphana01
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

- STORE

  Restriction to store 

  'ROW'           --> Only row store information
  'COLUMN'        --> Only column store information
  '%'             --> No store restriction

- VIRTUAL_FILE_NAME

  Virtual file name or pattern

  '$container$'   --> Only consider entries related to virtual files names $container$
  'att%'          --> Only consider entries with virtual file names starting with 'att'
  '%'             --> No restriction related to virtual file names

- OBJECT_LEVEL

  Controls display of partitions

  'PARTITION'     --> Result is shown on partition level
  'TABLE'         --> Result is shown on table level

- MIN_SIZE_GB

  Minimum size in GB

  10              --> Minimum size of 10 GB
  -1              --> No minimum size limitation

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'SCHEMA'        --> Aggregation by schema
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

[OUTPUT PARAMETERS]

- SNAPSHOT_TIME:     Timestamp
- HOST:              Host name
- PORT:              Port
- SERVICE:           Service name
- SCHEMA_NAME:       Schema name
- TABLE_NAME:        Table name
- SIZE_GB:           Disk size (GB)

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------
|SAMPLE_TIME     |HOST  |PORT |SERVICE    |SCHEMA_NAME|TABLE_NAME|S|SIZE_GB |SIZE_NOLOB_GB|
-------------------------------------------------------------------------------------------
|2017/12/14 (THU)|hana01|30003|indexserver|SAPSR3     |CDPOS     |C|   56.13|n/a          |
|2017/12/13 (WED)|hana01|30003|indexserver|SAPSR3     |CDPOS     |C|   56.09|n/a          |
|2017/12/12 (TUE)|hana01|30003|indexserver|SAPSR3     |CDPOS     |C|   55.97|n/a          |
|2017/12/11 (MON)|hana01|30003|indexserver|SAPSR3     |CDPOS     |C|   55.89|n/a          |
|2017/12/10 (SUN)|hana01|30003|indexserver|SAPSR3     |CDPOS     |C|   55.87|n/a          |
|2017/12/09 (SAT)|hana01|30003|indexserver|SAPSR3     |CDPOS     |C|   17.68|n/a          |
-------------------------------------------------------------------------------------------

*/

  SNAPSHOT_TIME,
  HOST,
  LPAD(PORT, 5) PORT,
  SERVICE_NAME SERVICE,
  SCHEMA_NAME,
  TABLE_NAME,
  STORE S,
  LPAD(TO_DECIMAL(SIZE_BYTE / 1024 / 1024 / 1024, 10, 2), 8) SIZE_GB
FROM
( SELECT
    CASE 
      WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(SAMPLE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE SAMPLE_TIME END) / SUBSTR(TIME_AGGREGATE_BY, 3)) * SUBSTR(TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(SAMPLE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE SAMPLE_TIME END, TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END SNAPSHOT_TIME,
    HOST,
    PORT,
    SERVICE_NAME,
    SCHEMA_NAME,
    TABLE_NAME,
    STORE,
    AVG(SIZE_BYTE) SIZE_BYTE,
    MIN_SIZE_GB,
    DATA_SOURCE
  FROM
  ( SELECT
      SAMPLE_TIME,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST')    != 0 THEN HOST              ELSE MAP(BI_HOST, '%', 'any', BI_HOST)                           END HOST,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(PORT)  ELSE MAP(BI_PORT, '%', 'any', BI_PORT)                           END PORT,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SERVICE') != 0 THEN SERVICE_NAME      ELSE MAP(BI_SERVICE_NAME, '%', 'any', BI_SERVICE_NAME)           END SERVICE_NAME,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SCHEMA')  != 0 THEN SCHEMA_NAME       ELSE MAP(BI_SCHEMA_NAME, '%', 'any', BI_SCHEMA_NAME)             END SCHEMA_NAME,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TABLE')   != 0 THEN TABLE_NAME        ELSE MAP(BI_TABLE_NAME, '%', 'any', BI_TABLE_NAME)               END TABLE_NAME,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'STORE')   != 0 THEN STORE             ELSE MAP(BI_STORE, '%', 'any', BI_STORE)                         END STORE,
      SUM(SIZE_BYTE) SIZE_BYTE,
      MIN_SIZE_GB,
      TIMEZONE,
      AGGREGATE_BY,
      TIME_AGGREGATE_BY,
      DATA_SOURCE
    FROM
    ( SELECT
        T.SAMPLE_TIME,
        T.HOST,
        T.PORT,
        S.SERVICE_NAME,
        T.SCHEMA_NAME,
        MAP(BI.OBJECT_LEVEL, 'TABLE', T.TABLE_NAME, T.TABLE_NAME || MAP(T.PART_ID, 0, '', ' (' || T.PART_ID || ')')) TABLE_NAME,
        T.SIZE_BYTE,
        MAP(TB.IS_COLUMN_TABLE, 'TRUE', 'C', 'R') STORE,
        BI.AGGREGATE_BY,
        BI.HOST BI_HOST,
        BI.PORT BI_PORT,
        BI.SERVICE_NAME BI_SERVICE_NAME,
        BI.SCHEMA_NAME BI_SCHEMA_NAME,
        BI.TABLE_NAME BI_TABLE_NAME,
        BI.STORE BI_STORE,
        BI.MIN_SIZE_GB,
        BI.TIMEZONE,
        BI.TIME_AGGREGATE_BY,
        BI.DATA_SOURCE
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
          SERVICE_NAME,
          SCHEMA_NAME,
          TABLE_NAME,
          STORE,
          OBJECT_LEVEL,
          MIN_SIZE_GB,
          DATA_SOURCE,
          AGGREGATE_BY,
          MAP(TIME_AGGREGATE_BY,
            'NONE',        'YYYY/MM/DD HH24:MI:SS',
            'HOUR',        'YYYY/MM/DD HH24',
            'DAY',         'YYYY/MM/DD (DY)',
            'HOUR_OF_DAY', 'HH24',
            TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY
        FROM
        ( SELECT                /* Modification section */
            '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
            '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
            'SERVER' TIMEZONE,                              /* SERVER, UTC */
            '%' HOST,
            '%' PORT,
            '%' SERVICE_NAME,
            '%' SCHEMA_NAME,
            '%' TABLE_NAME,
            '%' STORE,
            'TABLE' OBJECT_LEVEL,
            -1 MIN_SIZE_GB,
            'CURRENT' DATA_SOURCE,
            'HOST' AGGREGATE_BY,       /* HOST, PORT, SERVICE, SCHEMA, TABLE, VFILE, STORE and comma separated combinations, NONE for no aggregation */
            'TS86400' TIME_AGGREGATE_BY     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
          FROM
            DUMMY
        )
      ) BI,
        M_SERVICES S,
      ( SELECT
          'CURRENT' DATA_SOURCE,
          CURRENT_TIMESTAMP SAMPLE_TIME,
          HOST,
          PORT,
          SCHEMA_NAME,
          TABLE_NAME,
          PART_ID,
          DISK_SIZE SIZE_BYTE
        FROM
          M_TABLE_PERSISTENCE_LOCATION_STATISTICS
        UNION ALL
        SELECT
          'HISTORY' DATA_SOURCE,
          SERVER_TIMESTAMP,
          HOST,
          PORT,
          SCHEMA_NAME,
          TABLE_NAME,
          PART_ID,
          DISK_SIZE SIZE_BYTE
        FROM
          _SYS_STATISTICS.GLOBAL_TABLE_PERSISTENCE_STATISTICS
      ) T,
        TABLES TB
      WHERE
        ( BI.DATA_SOURCE = 'CURRENT' OR CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.SAMPLE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.SAMPLE_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME ) AND
        S.HOST LIKE BI.HOST AND
        TO_VARCHAR(S.PORT) LIKE BI.PORT AND
        S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
        T.HOST = S.HOST AND
        T.PORT = S.PORT AND
        T.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
        T.TABLE_NAME LIKE BI.TABLE_NAME AND
        TB.SCHEMA_NAME = T.SCHEMA_NAME AND
        TB.TABLE_NAME = T.TABLE_NAME AND
        T.DATA_SOURCE LIKE BI.DATA_SOURCE AND
        ( BI.STORE = '%' OR
          BI.STORE = 'ROW' AND TB.IS_COLUMN_TABLE = 'FALSE' OR
          BI.STORE = 'COLUMN' AND TB.IS_COLUMN_TABLE = 'TRUE'
        )
    )
    GROUP BY
      SAMPLE_TIME,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST')    != 0 THEN HOST              ELSE MAP(BI_HOST, '%', 'any', BI_HOST)                           END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(PORT)  ELSE MAP(BI_PORT, '%', 'any', BI_PORT)                           END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SERVICE') != 0 THEN SERVICE_NAME      ELSE MAP(BI_SERVICE_NAME, '%', 'any', BI_SERVICE_NAME)           END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SCHEMA')  != 0 THEN SCHEMA_NAME       ELSE MAP(BI_SCHEMA_NAME, '%', 'any', BI_SCHEMA_NAME)             END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TABLE')   != 0 THEN TABLE_NAME        ELSE MAP(BI_TABLE_NAME, '%', 'any', BI_TABLE_NAME)               END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'STORE')   != 0 THEN STORE             ELSE MAP(BI_STORE, '%', 'any', BI_STORE)                         END,
      MIN_SIZE_GB,
      TIMEZONE,
      AGGREGATE_BY,
      TIME_AGGREGATE_BY,
      DATA_SOURCE
  )
  GROUP BY
    CASE 
      WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(SAMPLE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE SAMPLE_TIME END) / SUBSTR(TIME_AGGREGATE_BY, 3)) * SUBSTR(TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(SAMPLE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE SAMPLE_TIME END, TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    HOST,
    PORT,
    SERVICE_NAME,
    SCHEMA_NAME,
    TABLE_NAME,
    STORE,
    MIN_SIZE_GB,
    DATA_SOURCE
)
WHERE
( MIN_SIZE_GB = -1 OR SIZE_BYTE / 1024 / 1024 / 1024 >= MIN_SIZE_GB )
ORDER BY
  SNAPSHOT_TIME DESC,
  SIZE_BYTE DESC,
  HOST,
  PORT,
  SCHEMA_NAME,
  TABLE_NAME
