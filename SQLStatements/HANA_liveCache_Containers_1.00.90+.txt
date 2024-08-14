SELECT

/* 

[NAME]

- HANA_liveCache_Containers_1.00.90+

[DESCRIPTION]

- Display SAP HANA container information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Only populated if SAP HANA integrated liveCache is used
- liveCache containers may be reflected in related heap areas (Pool/LVCAllocator/LVCContainerDir/LVCContainer_<container_id>)
- Can be used for monitoring remote system replication sites, see SAP Note 1999880 
  ("Is it possible to monitor remote system replication sites on the primary system") for details.
- HOST_LIVECACHE_CONTAINER_STATISTICS and HOST_LIVECACHE_SCHEMA_STATISTICS only available starting with SAP HANA 1.00.90
- HOST and PORT not available in history
- Fails in SAP HANA Cloud (SHC) environments because liveCache is no longer available:

  Could not find table/view M_LIVECACHE_CONTAINER_STATISTICS 

[VALID FOR]

- Revisions:              >= 1.00.90

[SQL COMMAND VERSION]

- 2015/02/24:  1.0 (initial version)
- 2016/02/16:  1.1 (SCHEMA_NAME included)
- 2018/01/22:  1.2 (dedicated 1.00.90+ version including history)
- 2018/01/26:  1.3 (DATA_SOURCE = 'RESET' included)
- 2018/12/04:  1.4 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- HOST_LIVECACHE_CONTAINER_STATISTICS
- HOST_LIVECACHE_SCHEMA_STATISTICS
- M_LIVECACHE_CONTAINER_STATISTICS
- M_LIVECACHE_CONTAINER_STATISTICS_RESET
- M_LIVECACHE_SCHEMA_STATISTICS
- M_LIVECACHE_SCHEMA_STATISTICS_RESET

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

- CLASS_NAME

  liveCache OMS class name

  'BucPersBucket' --> Class BucPersBucket
  '%IO%'          --> Classes containing 'IO'
  '%'             --> No restriction related to class name

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- CONTAINER_ID

  liveCache container ID

  1090923070939   --> Container ID 1090923070939
  -1              --> No restriction related to container ID

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'RESET'         --> Data from reset memory information (M_..._RESET tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'CLASS'         --> Aggregation by class name
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

  'TIME'          --> Sorting by timestamp 
  'OBJECT_SIZE'   --> Sorting by object size

[OUTPUT PARAMETERS]

- SNAPSHOT_TIME:  Snapshot time
- HOST:           Host name
- PORT:           Port
- CLASS_NAME:     liveCache OMS class name
- SCHEMA_NAME:    OMS schema name
- CONTAINER_ID:   liveCache container ID
- NUM_OBJECTS:    Number of objects
- PAGE_SIZE_MB:   Page size (MB)
- OBJECT_SIZE_MB: Object size (MB)

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------
|SNAPSHOT_TIME      |HOST|PORT |CLASS_NAME|SCHEMA_NAME              |CONTAINER_ID|NUM_OBJECTS|PAGE_SIZE_MB|OBJECT_SIZE_MB|
--------------------------------------------------------------------------------------------------------------------------
|2018/01/22 11:45:00|any |  any|any       |OMS                      |any         |      26274|      143.50|        137.67|
|2018/01/22 11:45:00|any |  any|any       |001wMWiJUuqtrJX00002Wf4pW|any         |    2950133|      414.25|        543.49|
|2018/01/22 11:45:00|any |  any|any       |001G5VZyxWa1sBX00002WeaD0|any         |   25091160|     5859.00|       6037.53|
|2018/01/22 11:45:00|any |  any|any       |00101UaTrK07jMAyi4jKOGhYW|any         |    2923937|      410.25|        441.83|
|2018/01/22 11:45:00|any |  any|any       |001000                   |any         |  168773553|    37350.75|      34654.72|
|2018/01/22 11:15:00|any |  any|any       |OMS                      |any         |      20665|      114.75|        107.60|
|2018/01/22 11:15:00|any |  any|any       |001wMWiJUuqtrJX00002Wf4pW|any         |    2950133|      414.25|        543.49|
|2018/01/22 11:15:00|any |  any|any       |001G5VZyxWa1sBX00002WeaD0|any         |   25091160|     5859.00|       6037.53|
|2018/01/22 11:15:00|any |  any|any       |00101UaTrK07jMAyi4jKOGhYW|any         |    2923937|      410.25|        441.83|
|2018/01/22 11:15:00|any |  any|any       |001000                   |any         |  168705447|    37350.75|      34645.64|
--------------------------------------------------------------------------------------------------------------------------

*/

  SNAPSHOT_TIME,
  HOST,
  LPAD(PORT, 5) PORT,
  CLASS_NAME,
  SCHEMA_NAME,
  CONTAINER_ID,
  LPAD(TO_DECIMAL(ROUND(TO_VARCHAR(NUM_OBJECTS)), 11, 0), 11) NUM_OBJECTS,
  LPAD(TO_DECIMAL(PAGE_SIZE_MB, 10, 2), 12) PAGE_SIZE_MB,
  LPAD(TO_DECIMAL(OBJECT_SIZE_MB, 10, 2), 14) OBJECT_SIZE_MB
FROM
( SELECT
    CASE 
      WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE SERVER_TIMESTAMP END) / SUBSTR(TIME_AGGREGATE_BY, 3)) * SUBSTR(TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE SERVER_TIMESTAMP END, TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END SNAPSHOT_TIME,
    HOST,
    PORT,
    CLASS_NAME,
    SCHEMA_NAME,
    CONTAINER_ID,
    AVG(NUM_OBJECTS) NUM_OBJECTS,
    AVG(OBJECT_SIZE_MB) OBJECT_SIZE_MB,
    AVG(PAGE_SIZE_MB) PAGE_SIZE_MB,
    ORDER_BY
  FROM
  ( SELECT
      C.SERVER_TIMESTAMP,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')      != 0 THEN C.HOST                     ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                            END HOST,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')      != 0 THEN TO_VARCHAR(C.PORT)         ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                            END PORT,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CLASS')     != 0 THEN C.OMS_CLASS_NAME           ELSE MAP(BI.CLASS_NAME, '%', 'any', BI.CLASS_NAME)                END CLASS_NAME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')    != 0 THEN C.OMS_SCHEMA_NAME          ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)              END SCHEMA_NAME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONTAINER') != 0 THEN TO_VARCHAR(C.CONTAINER_ID) ELSE MAP(BI.CONTAINER_ID, -1, 'any', TO_VARCHAR(BI.CONTAINER_ID)) END CONTAINER_ID,
      SUM(OBJECT_COUNT) NUM_OBJECTS,
      SUM(OBJECT_SIZE_SUM) / 1024 / 1024 OBJECT_SIZE_MB,
      SUM(PAGE_SIZE_SUM) / 1024 / 1024 PAGE_SIZE_MB,
      TIMEZONE,
      AGGREGATE_BY,
      TIME_AGGREGATE_BY,
      ORDER_BY
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
        CLASS_NAME,
        SCHEMA_NAME,
        CONTAINER_ID,
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
      ( SELECT                         /* Modification section */
          '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
          '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
          'SERVER' TIMEZONE,
          '%' HOST,
          '%' PORT,
          '%' CLASS_NAME,
          '%' SCHEMA_NAME,
          -1 CONTAINER_ID,
          'CURRENT' DATA_SOURCE,           /* CURRENT, RESET, HISTORY */
          'SCHEMA' AGGREGATE_BY,           /* TIME, HOST, PORT, CLASS, CONTAINER, SCHEMA or comma separated combinations, NONE for no aggregation */
          'TS900' TIME_AGGREGATE_BY,       /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
          'TIME' ORDER_BY                  /* TIME, CLASS, SCHEMA, OBJECTS, OBJECT_SIZE, PAGE_SIZE */
        FROM
          DUMMY
      )
    ) BI,
    ( SELECT
        'CURRENT' DATA_SOURCE,
        CURRENT_TIMESTAMP SERVER_TIMESTAMP,
        C.HOST,
        C.PORT,
        C.OMS_CLASS_NAME,
        SC.OMS_SCHEMA_NAME,
        C.CONTAINER_ID,
        C.OBJECT_COUNT,
        C.OBJECT_SIZE_SUM,
        C.PAGE_SIZE_SUM
      FROM
        M_LIVECACHE_CONTAINER_STATISTICS C,
        M_LIVECACHE_SCHEMA_STATISTICS SC
      WHERE
        SC.HOST = C.HOST AND
        SC.PORT = C.PORT AND
        SC.OMS_SCHEMA_HANDLE = C.OMS_SCHEMA_HANDLE
      UNION ALL
      SELECT
        'RESET' DATA_SOURCE,
        CURRENT_TIMESTAMP SERVER_TIMESTAMP,
        C.HOST,
        C.PORT,
        C.OMS_CLASS_NAME,
        SC.OMS_SCHEMA_NAME,
        C.CONTAINER_ID,
        C.OBJECT_COUNT,
        C.OBJECT_SIZE_SUM,
        C.PAGE_SIZE_SUM
      FROM
        M_LIVECACHE_CONTAINER_STATISTICS_RESET C,
        M_LIVECACHE_SCHEMA_STATISTICS_RESET SC
      WHERE
        SC.HOST = C.HOST AND
        SC.PORT = C.PORT AND
        SC.OMS_SCHEMA_HANDLE = C.OMS_SCHEMA_HANDLE
      UNION ALL
      SELECT
        'HISTORY' DATA_SOURCE,
        C.SERVER_TIMESTAMP,
        'n/a' HOST,
        'n/a' PORT,
        C.OMS_CLASS_NAME,
        SC.OMS_SCHEMA_NAME,
        C.CONTAINER_ID,
        C.OBJECT_COUNT,
        C.OBJECT_SIZE_SUM,
        C.PAGE_SIZE_SUM
      FROM
        _SYS_STATISTICS.HOST_LIVECACHE_CONTAINER_STATISTICS C,
        _SYS_STATISTICS.HOST_LIVECACHE_SCHEMA_STATISTICS SC
      WHERE
        SC.OMS_SCHEMA_HANDLE = C.OMS_SCHEMA_HANDLE AND
        C.SNAPSHOT_ID = SC.SNAPSHOT_ID
    ) C
    WHERE
      ( BI.DATA_SOURCE = 'CURRENT' OR
       CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(C.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE C.SERVER_TIMESTAMP END BETWEEN BI.BEGIN_TIME AND BI.END_TIME
      ) AND
      C.HOST LIKE BI.HOST AND
      TO_VARCHAR(C.PORT) LIKE BI.PORT AND
      BI.DATA_SOURCE = C.DATA_SOURCE AND
      ( BI.CONTAINER_ID = -1 OR BI.CONTAINER_ID = C.CONTAINER_ID ) AND
      C.OMS_CLASS_NAME LIKE BI.CLASS_NAME AND
      C.OMS_SCHEMA_NAME LIKE BI.SCHEMA_NAME
    GROUP BY
      C.SERVER_TIMESTAMP,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')      != 0 THEN C.HOST                     ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                            END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')      != 0 THEN TO_VARCHAR(C.PORT)         ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                            END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CLASS')     != 0 THEN C.OMS_CLASS_NAME           ELSE MAP(BI.CLASS_NAME, '%', 'any', BI.CLASS_NAME)                END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')    != 0 THEN C.OMS_SCHEMA_NAME          ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)              END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONTAINER') != 0 THEN TO_VARCHAR(C.CONTAINER_ID) ELSE MAP(BI.CONTAINER_ID, -1, 'any', TO_VARCHAR(BI.CONTAINER_ID)) END,
      TIMEZONE,
      AGGREGATE_BY,
      TIME_AGGREGATE_BY,
      ORDER_BY
  )
  GROUP BY
    CASE 
      WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE SERVER_TIMESTAMP END) / SUBSTR(TIME_AGGREGATE_BY, 3)) * SUBSTR(TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE SERVER_TIMESTAMP END, TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    HOST,
    PORT,
    CLASS_NAME,
    SCHEMA_NAME,
    CONTAINER_ID,
    ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'TIME', SNAPSHOT_TIME) DESC,
  MAP(ORDER_BY, 'CLASS', CLASS_NAME, 'SCHEMA', SCHEMA_NAME || CLASS_NAME),
  MAP(ORDER_BY, 'OBJECTS', NUM_OBJECTS, 'OBJECT_SIZE', OBJECT_SIZE_MB, 'PAGE_SIZE', PAGE_SIZE_MB) DESC
