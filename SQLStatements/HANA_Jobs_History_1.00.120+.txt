SELECT
/* 

[NAME]

- HANA_Jobs_History_1.00.120+

[DESCRIPTION]

- Historic overview of executed jobs

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- HOST_JOB_HISTORY available as of SAP HANA 1.00.120 

[VALID FOR]

- Revisions:              >= 1.00.120

[SQL COMMAND VERSION]

- 2016/07/17:  1.0 (initial version)
- 2016/12/31:  1.1 (TIME_AGGREGATE_BY = 'TS<seconds>' included)
- 2017/10/25:  1.2 (TIMEZONE included)
- 2018/12/04:  1.3 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2019/07/13:  1.4 (SAP_NOTE output column added)

[INVOLVED TABLES]

- HOST_JOB_HISTORY

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

- JOB_NAME

  Job name

  'BACKUP'        --> Only consider BACKUP jobs
  '%'             --> No restriction related to job name

- MIN_RUNTIME_S

  Minimum job runtime threshold (s)

  100             --> Only consider jobs with a runtime of at least 100 s
  -1              --> No restriction related to job runtime

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'          --> Aggregation by time
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

  'NUM'           --> Sorting by number of jobs
  'NAME'          --> Sorting by job name

[OUTPUT PARAMETERS]

- START_TIME:            Start time of considered time interval
- HOST:                  Host name
- PORT:                  Port
- JOB_NAME:              Job name
- SAP_NOTE:              SAP Note related to job activity
- NUM:                   Number of executed jobs
- TOTAL_S:               Total job runtime (s)
- AVG_S:                 Average job runtime (s)

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------
|START_TIME|HOST|PORT |JOB_NAME               |NUM     |TOTAL_S   |AVG_S     |
------------------------------------------------------------------------------
|any       |any |  any|CHECK TABLE CONSISTENCY|     352|     42661|    121.19|
|any       |any |  any|BACKUP                 |      25|     82195|   3287.80|
|any       |any |  any|DELTA MERGE            |      19|       685|     36.05|
|any       |any |  any|SAVEPOINT              |       6|       230|     38.33|
|any       |any |  any|OPTIMIZE COMPRESSION   |       1|        32|     32.00|
------------------------------------------------------------------------------

*/

  START_TIME,
  HOST,
  LPAD(PORT, 5) PORT,
  JOB_NAME,
  LPAD(CASE JOB_NAME
    WHEN 'Alter Table'                       THEN '2366291'
    WHEN 'Backup'                            THEN '1642148'
    WHEN 'BW F Fact Table Compression'       THEN '2057046'
    WHEN 'Check Table Consistency'           THEN '2116157'
    WHEN 'Column table reloading on startup' THEN '2127458'
    WHEN 'Create Index'                      THEN '2160391'
    WHEN 'Create Table Like'                 THEN '2366291'
    WHEN 'Data Statistics Autocreate'        THEN '2800028'
    WHEN 'Delta Log Replay'                  THEN '1642148'
    WHEN 'Delta Merge'                       THEN '2057046'
    WHEN 'DSO activation'                    THEN '1849497'
    WHEN 'DSO conversion'                    THEN '1849497'
    WHEN 'DSO rollback'                      THEN '1849497'
    WHEN 'Export'                            THEN '2476884'
    WHEN 'Export All'                        THEN '2476884'
    WHEN 'Export Object'                     THEN '2476884'
    WHEN 'Import'                            THEN '2476884'
    WHEN 'Import All'                        THEN '2476884'
    WHEN 'Import Object'                     THEN '2476884'
    WHEN 'Memory Profiler'                   THEN '1999997'
    WHEN 'Move Table'                        THEN '2081591'
    WHEN 'Online repartitioning'             THEN '2044468'
    WHEN 'Optimize Compression'              THEN '2112604'
    WHEN 'Plan Stability'                    THEN '2799998'
    WHEN 'Reclaim Delta'                     THEN '2057046'
    WHEN 'Re-partitioning'                   THEN '2044468'
    WHEN 'Row Store Reorganization'          THEN '1813245'
    WHEN 'Runtimedump'                       THEN '2400007'
    WHEN 'Save PerfTrace'                    THEN '1787489'
    WHEN 'Savepoint'                         THEN '2100009'
    WHEN 'Savepoint Critical Phase'          THEN '2100009'
    WHEN 'System Replication Data Transfer'  THEN '1999880'
    WHEN 'Table Consistency Check'           THEN '2116157'
    WHEN 'Table conversion (Col to Row)'     THEN '2222277' 
    WHEN 'Table conversion (Row to Col)'     THEN '2222277'
    WHEN 'Table Redistribution Execute'      THEN '2081591'
    WHEN 'Table Redistribution Generate'     THEN '2081591'
  END, 8) SAP_NOTE,
  LPAD(NUM, 8) NUM,
  LPAD(TOTAL_S, 10) TOTAL_S,
  LPAD(TO_DECIMAL(TOTAL_S / NUM, 10, 2), 10) AVG_S
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(J.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE J.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(J.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE J.START_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END START_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST') != 0 THEN J.JOB_HOST             ELSE MAP(BI.HOST, '%', 'any', BI.HOST)         END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT') != 0 THEN TO_VARCHAR(J.JOB_PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT)         END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'NAME') != 0 THEN J.JOB_NAME             ELSE MAP(BI.JOB_NAME, '%', 'any', BI.JOB_NAME) END JOB_NAME,
    SUM(SECONDS_BETWEEN(J.START_TIME, J.END_TIME)) TOTAL_S,
    COUNT(*) NUM,
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
      JOB_NAME,
      MIN_RUNTIME_S,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS:FF7',
        'HOUR',        'YYYY/MM/DD HH24',
        'DAY',         'YYYY/MM/DD (DY)',
        'HOUR_OF_DAY', 'HH24',
        TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
      ORDER_BY
    FROM
    ( SELECT                     /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        'SERVER' TIMEZONE,                              /* SERVER, UTC */
        '%' HOST,
        '%' PORT,
        '%' JOB_NAME,
        -1 MIN_RUNTIME_S,
        'NAME' AGGREGATE_BY,         /* TIME, HOST, PORT, NAME or comma separated combinations, NONE for no aggregation */
        'TS900' TIME_AGGREGATE_BY,   /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'NUM' ORDER_BY               /* NAME, NUM, TIME */
      FROM
        DUMMY
    )
  ) BI,
    _SYS_STATISTICS.HOST_JOB_HISTORY J
  WHERE
    ( CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(J.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE J.START_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME OR
      CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(J.END_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE J.END_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME OR
      CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(J.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE J.START_TIME END < BI.BEGIN_TIME AND CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(J.END_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE J.END_TIME END > BI.END_TIME ) AND
    J.JOB_HOST LIKE BI.HOST AND
    TO_VARCHAR(J.JOB_PORT) LIKE BI.PORT AND
    UPPER(J.JOB_NAME) LIKE UPPER(BI.JOB_NAME) AND
    ( BI.MIN_RUNTIME_S = -1 OR SECONDS_BETWEEN(J.START_TIME, J.END_TIME) >= BI.MIN_RUNTIME_S )
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(J.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE J.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(J.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE J.START_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST') != 0 THEN J.JOB_HOST             ELSE MAP(BI.HOST, '%', 'any', BI.HOST)         END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT') != 0 THEN TO_VARCHAR(J.JOB_PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT)         END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'NAME') != 0 THEN J.JOB_NAME             ELSE MAP(BI.JOB_NAME, '%', 'any', BI.JOB_NAME) END,
    BI.ORDER_BY   
)
ORDER BY
  MAP(ORDER_BY, 'NAME', JOB_NAME),
  MAP(ORDER_BY, 'TIME', START_TIME) DESC,
  NUM DESC