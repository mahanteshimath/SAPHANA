SELECT

/* 

[NAME]

- HANA_Consistency_CheckTableConsistency_Tables_2.00.010+

[DESCRIPTION]

- Consistency check information on table level

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Related to consistency check CHECK_TABLE_CONSISTENCY (SAP Note 2116157)
- M_CS_TABLES.LAST_CONSISTENCY_CHECK_ERROR_COUNT and M_CS_TABLES.LAST_CONSISTENCY_CHECK_TIME available starting with SAP HANA 2.00.010

[VALID FOR]

- Revisions:              >= 2.00.010

[SQL COMMAND VERSION]

- 2017/05/10:  1.0 (initial version)
- 2017/10/24:  1.1 (TIMEZONE included)
- 2018/12/04:  1.2 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- TABLES
- M_CS_TABLES

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

- PART_ID

  Partition number

  2               --> Only show information for partition number 2
  -1              --> No restriction related to partition number

- ONLY_ERRORS

  Possibility to restrict the output to tables with consistency check errors

  'X'             --> Only display tables with consistency check errors
  ' '             --> No limitation related to consistency check errors

- ONLY_TABLES_WITHOUT_CONSISTENCY_CHECK

  Possibility to restrict the output to tables without consistency check

  'X'             --> Only show tables without a consistency check
  ' '             --> No restriction related to tables without a consistency check

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'          --> Aggregation by time
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- AGGREGATION_TYPE

  Type of aggregation (e.g. average, sum, maximum)

  'AVG'           --> Average value
  'SUM'           --> Total value
  'MAX'           --> Maximum value

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'TIME'          --> Sorting by time
  'NAME'          --> Sorting by table name
  
[OUTPUT PARAMETERS]

- START_TIME:      Start time of merge
- END_TIME:        End time of merge
- DURATION_S:      Merge duration (s)
- HOST:            Host name
- PORT:            Port
- NUM:             Number of merges
- TYPE:            Merge type
- MOTIVATION:      Merge motivation
- SCHEMA_NAME:     Schema name
- TABLE_NAME:      Table name
- ROWS_MERGED:     Number of records merged
- LAST_ERROR:      Last error message (0 if no error)

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------------------------
|CHECK_TIME         |HOST  |PORT |SCHEMA_NAME    |TABLE_NAME                               |NUM_TABLES|SIZE_GB |ERRORS |
------------------------------------------------------------------------------------------------------------------------
|2017/05/10 14:43:07|hana01|30346|_SYS_STATISTICS|HOST_VOLUME_IO_DETAILED_STATISTICS_BASE  |         1|    0.02|      0|
|2017/05/10 14:43:06|hana01|30346|_SYS_STATISTICS|HOST_VOLUME_IO_RETRY_STATISTICS_BASE     |         1|    0.02|      0|
|2017/05/10 14:43:05|hana01|30346|_SYS_STATISTICS|HOST_SERVICE_MEMORY_BASE                 |         1|    0.02|      0|
|2017/05/10 14:43:05|hana01|30346|_SYS_STATISTICS|HOST_SERVICE_STATISTICS_BASE             |         1|    0.02|      0|
|2017/05/10 14:43:05|hana01|30346|_SYS_STATISTICS|HOST_LOAD_HISTORY_SERVICE_BASE           |         1|    0.02|      0|
|2017/05/10 14:43:05|hana01|30346|_SYS_STATISTICS|HOST_LOAD_HISTORY_HOST_BASE              |         1|    0.02|      0|
|2017/05/10 14:43:05|hana01|30346|_SYS_STATISTICS|HOST_SQL_PLAN_CACHE_BASE                 |         1|    0.02|      0|
|2017/05/10 14:43:04|hana01|30346|_SYS_STATISTICS|HOST_RESOURCE_UTILIZATION_STATISTICS_BASE|         1|    0.00|      0|
|2017/05/10 14:43:04|hana01|30346|_SYS_STATISTICS|GLOBAL_DISKS_BASE                        |         1|    0.00|      0|
|2017/05/10 14:43:04|hana01|30346|_SYS_STATISTICS|HOST_HEAP_ALLOCATORS_BASE                |         1|    0.00|      0|
------------------------------------------------------------------------------------------------------------------------

*/

  CHECK_TIME,
  HOST,
  PORT,
  SCHEMA_NAME,
  TABLE_NAME,
  LPAD(NUM_TABLES, 10) NUM_TABLES,
  LPAD(TO_DECIMAL(SIZE_GB, 10, 2), 8) SIZE_GB,
  LPAD(ERRORS, 7) ERRORS
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.LAST_CONSISTENCY_CHECK_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.LAST_CONSISTENCY_CHECK_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.LAST_CONSISTENCY_CHECK_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.LAST_CONSISTENCY_CHECK_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END CHECK_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')       != 0 THEN T.HOST                                                                     ELSE MAP(BI.HOST, '%', 'any', BI.HOST)               END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')       != 0 THEN TO_VARCHAR(T.PORT)                                                         ELSE MAP(BI.PORT, '%', 'any', BI.PORT)               END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')     != 0 THEN T.SCHEMA_NAME                                                              ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME) END SCHEMA_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')      != 0 THEN T.TABLE_NAME || MAP(T.PART_ID, 0, '', CHAR(32) || '(' || T.PART_ID || ')') ELSE MAP(BI.TABLE_NAME, '%', 'any', BI.TABLE_NAME)   END TABLE_NAME,
    COUNT(*) NUM_TABLES,
    SUM(T.MEMORY_SIZE_IN_TOTAL / 1024 / 1024 / 1024) SIZE_GB,
    SUM(T.LAST_CONSISTENCY_CHECK_ERROR_COUNT) ERRORS,
    BI.ORDER_BY
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
      SCHEMA_NAME,
      TABLE_NAME,
      PART_ID,
      ONLY_ERRORS,
      ONLY_TABLES_WITHOUT_CONSISTENCY_CHECK,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS',
        'HOUR',        'YYYY/MM/DD HH24',
        'DAY',         'YYYY/MM/DD (DY)',
        'HOUR_OF_DAY', 'HH24',
        TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
      ORDER_BY
    FROM
    ( SELECT               /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        'SERVER' TIMEZONE,                              /* SERVER, UTC */
        '%' HOST,
        '%' PORT,
        '%' SCHEMA_NAME,
        '%' TABLE_NAME,
        -1 PART_ID,
        ' ' ONLY_ERRORS,
        ' ' ONLY_TABLES_WITHOUT_CONSISTENCY_CHECK,
        'NONE' AGGREGATE_BY,           /* TIME, HOST, PORT, SCHEMA, TABLE and comma-separated combinations, NONE for no aggregation */
        'NONE' TIME_AGGREGATE_BY,      /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'TIME' ORDER_BY               /* TIME, NAME, OCCURRENCES, SIZE, ERRORS */
      FROM
        DUMMY
    )
  ) BI,
  ( SELECT
      CT.*
    FROM
      TABLES T,
      M_CS_TABLES CT
    WHERE
    ( T.TEMPORARY_TABLE_TYPE = 'NO LOGGING' OR T.IS_TEMPORARY != 'TRUE' ) AND
      CT.SCHEMA_NAME = T.SCHEMA_NAME AND
      CT.TABLE_NAME = T.TABLE_NAME
  ) T      
  WHERE
    ( BI.ONLY_TABLES_WITHOUT_CONSISTENCY_CHECK = 'X' AND T.LAST_CONSISTENCY_CHECK_TIME IS NULL OR
      BI.ONLY_TABLES_WITHOUT_CONSISTENCY_CHECK = ' ' AND CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.LAST_CONSISTENCY_CHECK_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.LAST_CONSISTENCY_CHECK_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME
    ) AND
    T.HOST LIKE BI.HOST AND
    TO_CHAR(T.PORT) LIKE BI.PORT AND
    T.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    T.TABLE_NAME LIKE BI.TABLE_NAME AND
    ( BI.PART_ID = -1 OR T.PART_ID = BI.PART_ID ) AND
    ( BI.ONLY_ERRORS = ' ' OR T.LAST_CONSISTENCY_CHECK_ERROR_COUNT > 0 )
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.LAST_CONSISTENCY_CHECK_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.LAST_CONSISTENCY_CHECK_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.LAST_CONSISTENCY_CHECK_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.LAST_CONSISTENCY_CHECK_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')       != 0 THEN T.HOST                                                                     ELSE MAP(BI.HOST, '%', 'any', BI.HOST)               END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')       != 0 THEN TO_VARCHAR(T.PORT)                                                         ELSE MAP(BI.PORT, '%', 'any', BI.PORT)               END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')     != 0 THEN T.SCHEMA_NAME                                                              ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')      != 0 THEN T.TABLE_NAME || MAP(T.PART_ID, 0, '', CHAR(32) || '(' || T.PART_ID || ')') ELSE MAP(BI.TABLE_NAME, '%', 'any', BI.TABLE_NAME)   END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'TIME', CHECK_TIME) DESC,
  MAP(ORDER_BY, 'NAME', SCHEMA_NAME || TABLE_NAME),
  MAP(ORDER_BY, 'OCCURRENCES', NUM_TABLES, 'SIZE', SIZE_GB, 'ERRORS', ERRORS) DESC