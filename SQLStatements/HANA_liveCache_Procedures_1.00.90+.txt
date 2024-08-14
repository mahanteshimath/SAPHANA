SELECT

/* 

[NAME]

- HANA_liveCache_Procedures_1.00.90+

[DESCRIPTION]

- Information about liveCache procedure runtimes

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Only populated if SAP HANA integrated liveCache is used
- RESET can be performed via:

  ALTER SYSTEM RESET MONITORING VIEW M_LIVECACHE_PROCEDURE_STATISTICS_RESET

- Can be used for monitoring remote system replication sites, see SAP Note 1999880 
  ("Is it possible to monitor remote system replication sites on the primary system") for details.
- HOST_LIVECACHE_PROCEDURE_STATISTICS only available starting with SAP HANA 1.00.90
- HOST and PORT not available in history
- Fails in SAP HANA Cloud (SHC) environments because liveCache is no longer available

[VALID FOR]

- Revisions:              >= 1.00.090

[SQL COMMAND VERSION]

- 2015/02/27:  1.0 (initial version)
- 2015/05/02:  1.1 (*_RESET views included)
- 2016/02/17:  1.2 (exceptions and derefs included)
- 2016/07/27:  1.3 (MAX_ELAPSED_MS included)
- 2018/01/22:  1.4 (dedicated 1.00.90+ version including history)
- 2018/12/04:  1.5 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- M_LIVECACHE_PROCEDURE_STATISTICS
- M_LIVECACHE_PROCEDURE_STATISTICS_RESET
- HOST_LIVECACHE_PROCEDURE_STATISTICS

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

- OBJECT_NAME

  liveCache object name

  'SAPAPO'        --> Objects with name SAPAPO
  'SAP%'          --> Objects starting with 'SAP'
  '%'             --> No restriction related to object name

- METHOD_NAME

  liveCache method / procedure name

  'APS_ORDER_CHANGE' --> Method APS_ORDER_CHANGE
  'APS%'             --> Method names starting with 'APS'
  '%'                --> No restriction related to method name

- MIN_ELAPSED_TIME_PCT

  Minimum elapsed time fraction in percent

  10              --> Only show procedures with at least 10 % of the total runtime
  -1              --> No restriction related to runtime share

- ONLY_ERRORS

  Possibility to restrict output to containers with reported errors 
  (exceptions, out-of-date, out-of-memory, terminations, timeouts)

  'X'             --> Only show containers with reported errors
  ' '             --> No restriction related to reported errors

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_* tables)
  'RESET'         --> Data from reset memory information (M_*_RESET tables)
  'HISTORY'       --> Data from historic information (HOST_* and GLOBAL* tables)

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

  'NAME'          --> Sorting by procedure name
  'TIME'          --> Sorting by execution time

- RESULT_ROWS

  Number of records to be returned by the query

  100             --> Return a maximum number of 100 records
  -1              --> Return all records

[OUTPUT PARAMETERS]

- SNAPSHOT_TIME: Snapshot time
- HOST:          Host name
- PORT:          Port
- OBJECT_NAME:   Object name
- METHOD_NAME:   Method name
- EXECUTIONS:    Executions
- ELAPSED_S:     Elapsed time (s)
- ELA_PCT:       Elapsed time compared to overall elapsed time (%)
- PER_EXEC_MS:   Elapsed time per execution (ms)
- DEREFS:        Number of OID derefs
- DEREFS_PER_S:  OID derefs per second
- EXC:           Number of reported exceptions
- OOD:           Number of reported out-of-date exceptions
- OOM:           Number of reported out-of-memory exceptions
- TIMEOUTS:      Number of reported timeouts
- TERM:          Number of reported terminations

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------
|SNAPSHOT_TIME   |OBJECT_NAME|METHOD_NAME                 |EXECUTIONS|ELAPSED_TIME_S|ELA_PCT|ELA_PER_EXEC_MS|DEREFS      |DEREFS_PER_S|
---------------------------------------------------------------------------------------------------------------------------------------
|2018/01/22 (MON)|TRANS-END  |Validate-Callback           |   5591886|           123|   0.07|           0.00|      290208|        2363|
|2018/01/22 (MON)|TRANS-END  |Rollback-Invalidate-Callback|     10253|             0|   0.00|           0.00|           0|           0|
|2018/01/22 (MON)|TRANS-END  |Commit-Invalidate-Callback  |   5591887|           499|   0.29|           0.00|           0|           0|
|2018/01/22 (MON)|TRANS-END  |Kernel-Rollback             |      5963|             1|   0.00|           0.00|           0|           0|
|2018/01/22 (MON)|TRANS-END  |Flush-Cache                 |   5591886|           664|   0.39|           0.00|           0|           0|
|2018/01/22 (MON)|TRANS-END  |Kernel-Commit               |   5591887|          4422|   2.64|           0.00|           0|           0|
|2018/01/21 (SUN)|TRANS-END  |Rollback-Invalidate-Callback|      4397|             0|   0.00|           0.00|           0|           0|
|2018/01/21 (SUN)|TRANS-END  |Commit-Invalidate-Callback  |   2587619|           287|   0.17|           0.00|           0|           0|
|2018/01/21 (SUN)|TRANS-END  |Flush-Cache                 |   2587620|           636|   0.38|           0.00|           0|           0|
|2018/01/21 (SUN)|TRANS-END  |Kernel-Rollback             |      2139|             0|   0.00|           0.00|           0|           0|
|2018/01/21 (SUN)|TRANS-END  |Validate-Callback           |   2587620|            69|   0.04|           0.00|      281044|        4067|
|2018/01/21 (SUN)|TRANS-END  |Kernel-Commit               |   2587619|          2583|   1.54|           0.00|           0|           0|
---------------------------------------------------------------------------------------------------------------------------------------

*/

  SNAPSHOT_TIME,
  HOST,
  LPAD(PORT, 5) PORT,
  OBJECT_NAME,
  METHOD_NAME,
  LPAD(EXECUTIONS, 10) EXECUTIONS,
  LPAD(TO_DECIMAL(ROUND(ELAPSED_TIME_S), 14, 0), 9) ELAPSED_S,
  LPAD(TO_DECIMAL(ELAPSED_TIME_S / TOTAL_TIME_S * 100, 10, 2), 7) ELA_PCT, 
  LPAD(TO_DECIMAL(ELA_PER_EXEC_MS, 10, 2), 11) PER_EXEC_MS,
  LPAD(DEREFS, 12) DEREFS,
  LPAD(TO_DECIMAL(ROUND(DEREFS_PER_S), 12, 0), 12) DEREFS_PER_S,
  LPAD(EXCEPTIONS, 6) EXC,
  LPAD(OOD, 5) OOD,
  LPAD(OOM, 5) OOM,
  LPAD(TIMEOUTS, 8) TIMEOUTS,
  LPAD(TERMINATIONS, 6) TERM
FROM
( SELECT
    SNAPSHOT_TIME,
    HOST,
    PORT,
    OBJECT_NAME,
    METHOD_NAME,
    EXECUTIONS,
    SUM_RUN_TIME / 1000000 ELAPSED_TIME_S,
    MAP(EXECUTIONS, 0, 0, SUM_RUN_TIME / EXECUTIONS / 1000) ELA_PER_EXEC_MS,
    DEREF_COUNT DEREFS,
    MAP(SUM_RUN_TIME, 0, 0, DEREF_COUNT / SUM_RUN_TIME * 1000000) DEREFS_PER_S,
    SUM(TO_DECIMAL(SUM_RUN_TIME)) OVER () / 1000000 TOTAL_TIME_S,
    EXCEPTION_COUNT EXCEPTIONS,
    OUT_OF_DATE_EXCEPTION_COUNT OOD,
    OUT_OF_MEMORY_EXCEPTION_COUNT OOM,
    TIMEOUT_EXCEPTION_COUNT TIMEOUTS,
    OMS_TERMINATE_COUNT TERMINATIONS,
    ROW_NUMBER () OVER (ORDER BY MAP(ORDER_BY, 'NAME', METHOD_NAME), MAP(ORDER_BY, 'TIME', SNAPSHOT_TIME, 'DURATION', SUM_RUN_TIME, 'EXECUTIONS', EXECUTIONS) DESC) ROW_NUM,
    MIN_ELAPSED_TIME_PCT,
    ONLY_ERRORS,
    RESULT_ROWS
  FROM
  ( SELECT
      CASE 
        WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.SERVER_TIMESTAMP END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.SERVER_TIMESTAMP END, BI.TIME_AGGREGATE_BY)
          END
        ELSE 'any' 
      END SNAPSHOT_TIME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')   != 0 THEN P.HOST        ELSE MAP(BI.HOST, '%', 'any', BI.HOST)               END HOST,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')   != 0 THEN P.PORT        ELSE MAP(BI.PORT, '%', 'any', BI.PORT)               END PORT,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'OBJECT') != 0 THEN P.OBJECT_NAME ELSE MAP(BI.OBJECT_NAME, '%', 'any', BI.OBJECT_NAME) END OBJECT_NAME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'METHOD') != 0 THEN P.METHOD_NAME ELSE MAP(BI.METHOD_NAME, '%', 'any', BI.METHOD_NAME) END METHOD_NAME,
      SUM(TO_DECIMAL(P.CALL_COUNT)) EXECUTIONS,
      SUM(TO_DECIMAL(P.SUM_RUN_TIME)) SUM_RUN_TIME,
      SUM(TO_DECIMAL(P.DEREF_COUNT)) DEREF_COUNT,
      SUM(TO_DECIMAL(P.EXCEPTION_COUNT)) EXCEPTION_COUNT,
      SUM(TO_DECIMAL(P.OUT_OF_DATE_EXCEPTION_COUNT)) OUT_OF_DATE_EXCEPTION_COUNT,
      SUM(TO_DECIMAL(P.OUT_OF_MEMORY_EXCEPTION_COUNT)) OUT_OF_MEMORY_EXCEPTION_COUNT,
      SUM(TO_DECIMAL(P.TIMEOUT_EXCEPTION_COUNT)) TIMEOUT_EXCEPTION_COUNT,
      SUM(TO_DECIMAL(P.OMS_TERMINATE_COUNT)) OMS_TERMINATE_COUNT,
      BI.MIN_ELAPSED_TIME_PCT,
      BI.ONLY_ERRORS,
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
        HOST,
        PORT,
        OBJECT_NAME,
        METHOD_NAME,
        MIN_ELAPSED_TIME_PCT,
        ONLY_ERRORS,
        DATA_SOURCE,
        AGGREGATE_BY,
        MAP(TIME_AGGREGATE_BY,
          'NONE',        'YYYY/MM/DD HH24:MI:SS:FF7',
          'HOUR',        'YYYY/MM/DD HH24',
          'DAY',         'YYYY/MM/DD (DY)',
          'HOUR_OF_DAY', 'HH24',
          TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
        ORDER_BY,
        RESULT_ROWS
      FROM
      ( SELECT                /* Modification section */
          '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
          '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
          'SERVER' TIMEZONE,
          '%' HOST,
          '%' PORT,
          '%' OBJECT_NAME,
          '%' METHOD_NAME,
          -1 MIN_ELAPSED_TIME_PCT,
          ' ' ONLY_ERRORS,
          'CURRENT' DATA_SOURCE,  /* CURRENT, HISTORY, RESET */
          'NONE' AGGREGATE_BY,           /* TIME, HOST, PORT, OBJECT, METHOD or comma separated combinations, NONE for no aggregation */
          'NONE' TIME_AGGREGATE_BY,       /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
          'DURATION' ORDER_BY,        /* NAME, TIME, DURATION, EXECUTIONS */
          -1 RESULT_ROWS
        FROM
          DUMMY
      ) 
    ) BI,
    ( SELECT
        'CURRENT' DATA_SOURCE,
        CURRENT_TIMESTAMP SERVER_TIMESTAMP,
        HOST,
        TO_VARCHAR(PORT) PORT,
        OBJECT_NAME,
        METHOD_NAME,
        CALL_COUNT,
        SUM_RUN_TIME,
        DEREF_COUNT,
        EXCEPTION_COUNT,
        OUT_OF_DATE_EXCEPTION_COUNT,
        OUT_OF_MEMORY_EXCEPTION_COUNT,
        TIMEOUT_EXCEPTION_COUNT,
        OMS_TERMINATE_COUNT
      FROM
        M_LIVECACHE_PROCEDURE_STATISTICS
      UNION ALL
      SELECT
        'RESET' DATA_SOURCE,
        CURRENT_TIMESTAMP SERVER_TIMESTAMP,
        HOST,
        TO_VARCHAR(PORT) PORT,
        OBJECT_NAME,
        METHOD_NAME,
        CALL_COUNT,
        SUM_RUN_TIME,
        DEREF_COUNT,
        EXCEPTION_COUNT,
        OUT_OF_DATE_EXCEPTION_COUNT,
        OUT_OF_MEMORY_EXCEPTION_COUNT,
        TIMEOUT_EXCEPTION_COUNT,
        OMS_TERMINATE_COUNT
      FROM
        M_LIVECACHE_PROCEDURE_STATISTICS_RESET
      UNION ALL
      SELECT
        'HISTORY' DATA_SOURCE,
        SERVER_TIMESTAMP,
        'n/a' HOST,
        'n/a' PORT,
        OBJECT_NAME,
        METHOD_NAME,
        CALL_COUNT,
        SUM_RUN_TIME,
        SUM_DEREF_COUNT DEREF_COUNT,
        EXCEPTION_COUNT EXCEPTION_COUNT,
        OUT_OF_DATE_EXCEPTION_COUNT,
        OUT_OF_MEMORY_EXCEPTION_COUNT,
        TIMEOUT_EXCEPTION_COUNT,
        OMS_TERMINATE_COUNT
      FROM
        _SYS_STATISTICS.HOST_LIVECACHE_PROCEDURE_STATISTICS
    ) P
    WHERE
      ( BI.DATA_SOURCE IN ( 'CURRENT', 'RESET') OR
       CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.SERVER_TIMESTAMP END BETWEEN BI.BEGIN_TIME AND BI.END_TIME
      ) AND
      P.HOST LIKE BI.HOST AND
      P.PORT LIKE BI.PORT AND
      P.OBJECT_NAME LIKE BI.OBJECT_NAME AND
      P.METHOD_NAME LIKE BI.METHOD_NAME AND
      P.DATA_SOURCE = BI.DATA_SOURCE
    GROUP BY
      CASE 
        WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.SERVER_TIMESTAMP END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.SERVER_TIMESTAMP END, BI.TIME_AGGREGATE_BY)
          END
        ELSE 'any' 
      END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')   != 0 THEN P.HOST        ELSE MAP(BI.HOST, '%', 'any', BI.HOST)               END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')   != 0 THEN P.PORT        ELSE MAP(BI.PORT, '%', 'any', BI.PORT)               END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'OBJECT') != 0 THEN P.OBJECT_NAME ELSE MAP(BI.OBJECT_NAME, '%', 'any', BI.OBJECT_NAME) END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'METHOD') != 0 THEN P.METHOD_NAME ELSE MAP(BI.METHOD_NAME, '%', 'any', BI.METHOD_NAME) END,
      BI.MIN_ELAPSED_TIME_PCT,
      BI.ONLY_ERRORS,
      BI.ORDER_BY,
      BI.RESULT_ROWS
  )
)
WHERE
  ( RESULT_ROWS = -1 OR ROW_NUM <= RESULT_ROWS ) AND
  ( MIN_ELAPSED_TIME_PCT = -1 OR ELAPSED_TIME_S / TOTAL_TIME_S * 100 >= MIN_ELAPSED_TIME_PCT ) AND
  ( ONLY_ERRORS = ' ' OR EXCEPTIONS + OOD + OOM + TIMEOUTS + TERMINATIONS > 0 )
ORDER BY
  ROW_NUM