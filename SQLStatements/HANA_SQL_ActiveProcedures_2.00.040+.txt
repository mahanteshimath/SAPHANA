SELECT

/* 

[NAME]

- HANA_SQL_ActiveProcedure_2.00.040+

[DESCRIPTION]

- Details for active procedure calls

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Per default only populated for currently running procedures
- Increased retention can be configured with the following parameters (SAP Note 2000002):

  indexserver.ini -> [sqlscript] -> number_of_calls_to_retain_after_execution
  indexserver.ini -> [sqlscript] -> retention_period_for_sqlscript_context

- M_ACTIVE_PROCEDURES.STATEMENT_EXECUTION_MEMORY_SIZE available with SAP HANA >= 2.00.040

[VALID FOR]

- Revisions:              >= 2.00.040

[SQL COMMAND VERSION]

- 2017/11/14:  1.0 (initial version)
- 2018/12/04:  1.1 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2019/07/27:  1.2 (dedicated 2.00.040+ version including STATEMENT_EXECUTION_MEMORY_SIZE)

[INVOLVED TABLES]

- M_ACTIVE_PROCEDURES

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

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- PROCEDURE_NAME

  Procedure name

  'STATISTICS_SCHEDULABLEWRAPPER' --> Procedure STATISTICS_SCHEDULABLEWRAPPER
  '%'                             --> No restriction related to procedure

- STATEMENT_STRING

  Statement string

  'INSERT%'       --> Statements starting with "INSERT"
  '%'             --> No restriction related to statement string

- STATEMENT_STATUS

  Statement status

  'EXECUTING'     --> Statement status EXECUTING
  '%'             --> No restriction relaed to statement status

- CONN_ID

  Connection ID

  330655          --> Connection ID 330655
  -1              --> No connection ID restriction

- STATEMENT_ID

  SQL statement identifier (varies for different executions of same statement hash)

  '859110927564988' --> Only display samples with statement ID 859110927564988
  '%'               --> No restriction related to statement ID

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'          --> Aggregation by timestamp
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

  'TIME'          --> Sorting by start time
  'DURATION'      --> Sorting by execution time
  'MEMORY'        --> Sorting by used memory
  'CPU'           --> Sorting by CPU time

[OUTPUT PARAMETERS]

- START_TIME:       Start time
- HOST:             Host name
- PORT:             Port
- SCHEMA_NAME:      Schema name
- PROCEDURE_NAME:   Procedure name
- CONN_ID:          Connection ID
- STATEMENT_ID:     Statement ID
- EXECUTIONS:       Number of executions
- EXECUTE_S:        Total execution time (s)
- EXE_PER_EXEC_MS:  Time per execution (ms)
- COMPILE_MS:       Total compile time (ms)
- MEM_SIZE_MB:      Used memory (MB)
- DEPTH:            Call depth
- STATEMENT_STATUS: Statement status
- STATEMENT_STRING: Statement text
- BIND_VALUES:      Bind values

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|START_TIME                 |HOST    |PORT |SCHEMA_NAME    |PROCEDURE_NAME               |CONN_ID   |STATEMENT_ID    |EXECUTIONS|EXECUTE_MS|EXE_PER_EXEC_MS|COMPILE_MS|DEPTH|STATEMENT_STATUS|STATEMENT_STRING                                                                                    |BIND_VALUES                                                  |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2017/11/14 09:05:45:2889070|saphana5|30003|_SYS_STATISTICS|STATISTICS_SCHEDULABLEWRAPPER|    400053|1718215682249923|         0|     78.25|           0.00|      0.34|    2|EXECUTING       |    WITH _SYS_WITH_0  AS (/*  procedure: _SYS_STATISTICS.ALERT_CHECK_INACTIVE_SERVICES  variable:...|                                                             |
|2017/11/14 09:05:45:0678180|saphana5|30003|_SYS_STATISTICS|STATISTICS_SCHEDULABLEWRAPPER|    400050|1718202286830377|         0|    299.26|           0.00|      0.27|    2|EXECUTING       |    WITH _SYS_WITH_0  AS (/*  procedure: _SYS_STATISTICS.ALERT_BACKUP_LONG_LOG_BACKUP  variable: ...|                                                             |
|2017/11/14 09:05:45:0657870|saphana5|30003|_SYS_STATISTICS|STATISTICS_SCHEDULABLEWRAPPER|    400053|1718214685618559|         1|    219.47|         219.47|      0.27|    2|COMPLETED       |    INSERT INTO "_SYS_STATISTICS"."HELPER_ALERT_CHECK_INACTIVE_SERVICES_AGE" SELECT "SERVICE_ID",...|                                                             |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  START_TIME,
  HOST,
  LPAD(PORT, 5) PORT,
  SCHEMA_NAME,
  PROCEDURE_NAME,
  LPAD(CONN_ID, 10) CONN_ID,
  LPAD(STATEMENT_ID, 16) STATEMENT_ID,
  LPAD(EXECUTIONS, 10) EXECUTIONS,
  LPAD(TO_DECIMAL(EXECUTE_MS / 1000, 10, 2), 10) EXECUTE_S,
  LPAD(TO_DECIMAL(MAP(EXECUTIONS, 0, 0, EXECUTE_MS / EXECUTIONS), 10, 2), 15) EXE_PER_EXEC_MS,
  LPAD(TO_DECIMAL(COMPILE_MS, 10, 2), 10) COMPILE_MS,
  LPAD(TO_DECIMAL(MEM_SIZE_MB, 10, 2), 11) MEM_SIZE_MB,
  LPAD(DEPTH, 5) DEPTH,
  STATEMENT_STATUS,
  STATEMENT_STRING,
  BIND_VALUES
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.STATEMENT_START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.STATEMENT_START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.STATEMENT_START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.STATEMENT_START_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END START_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')         != 0 THEN P.PROCEDURE_HOST                      ELSE MAP(BI.HOST,             '%', 'any', BI.HOST)                     END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')         != 0 THEN TO_VARCHAR(P.PROCEDURE_PORT)          ELSE MAP(BI.PORT,             '%', 'any', BI.PORT)                     END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONN_ID')      != 0 THEN TO_VARCHAR(P.PROCEDURE_CONNECTION_ID) ELSE MAP(BI.CONN_ID,           -1, 'any', TO_VARCHAR(BI.CONN_ID))      END CONN_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATEMENT_ID') != 0 THEN TO_VARCHAR(P.STATEMENT_ID)            ELSE MAP(BI.STATEMENT_ID,      -1, 'any', TO_VARCHAR(BI.STATEMENT_ID)) END STATEMENT_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')       != 0 THEN P.PROCEDURE_SCHEMA_NAME               ELSE MAP(BI.SCHEMA_NAME,      '%', 'any', BI.SCHEMA_NAME)              END SCHEMA_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PROCEDURE')    != 0 THEN P.PROCEDURE_NAME                      ELSE MAP(BI.PROCEDURE_NAME,   '%', 'any', BI.PROCEDURE_NAME)           END PROCEDURE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATUS')       != 0 THEN P.STATEMENT_STATUS                    ELSE MAP(BI.STATEMENT_STATUS, '%', 'any', BI.STATEMENT_STATUS)         END STATEMENT_STATUS,
    MAP(MIN(TO_VARCHAR(P.STATEMENT_STRING)), MAX(TO_VARCHAR(P.STATEMENT_STRING)), MIN(TO_VARCHAR(P.STATEMENT_STRING)), 'any') STATEMENT_STRING,
    MAP(MIN(TO_VARCHAR(P.STATEMENT_PARAMETERS)), MAX(TO_VARCHAR(P.STATEMENT_PARAMETERS)), MIN(TO_VARCHAR(P.STATEMENT_PARAMETERS)), 'any') BIND_VALUES,
    SUM(P.STATEMENT_EXECUTION_COUNT) EXECUTIONS,
    SUM(P.STATEMENT_EXECUTION_MEMORY_SIZE) / 1024 / 1024 MEM_SIZE_MB,
    MAP(MIN(P.STATEMENT_DEPTH), MAX(P.STATEMENT_DEPTH), TO_VARCHAR(MIN(P.STATEMENT_DEPTH)), 'any') DEPTH,
    SUM(P.STATEMENT_EXECUTION_TIME) / 1000 EXECUTE_MS,
    SUM(P.STATEMENT_COMPILE_TIME) / 1000 COMPILE_MS,
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
      PROCEDURE_NAME,
      STATEMENT_STRING,
      STATEMENT_STATUS,
      CONN_ID,
      STATEMENT_ID,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS:FF7',
        'HOUR',        'YYYY/MM/DD HH24',
        'DAY',         'YYYY/MM/DD (DY)',
        'HOUR_OF_DAY', 'HH24',
        TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
      ORDER_BY
    FROM
    ( SELECT                         /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        'SERVER' TIMEZONE,                              /* SERVER, UTC */
        '%' HOST,
        '%' PORT,
        '%' SCHEMA_NAME,
        '%' PROCEDURE_NAME,
        '%' STATEMENT_STRING,
        '%' STATEMENT_STATUS,                    /* EXECUTING, COMPLETED, ... */
        -1 CONN_ID,
        -1 STATEMENT_ID,
        'NONE' AGGREGATE_BY,                         /* TIME, HOST, PORT, CONN_ID, SCHEMA, PROCEDURE, STATUS or comma separated combinations, NONE for no aggregation */
        'NONE' TIME_AGGREGATE_BY,                    /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'EXEC_TIME' ORDER_BY                  /* TIMESTAMP, PROCEDURE, EXECUTIONS, EXEC_TIME, COMP_TIME */
      FROM
        DUMMY
    )
  ) BI,
    M_ACTIVE_PROCEDURES P
  WHERE
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.STATEMENT_START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.STATEMENT_START_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    P.PROCEDURE_HOST LIKE BI.HOST AND
    TO_VARCHAR(P.PROCEDURE_PORT) LIKE BI.PORT AND
    P.PROCEDURE_SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    P.PROCEDURE_NAME LIKE BI.PROCEDURE_NAME AND
    ( BI.CONN_ID = -1 OR P.PROCEDURE_CONNECTION_ID = BI.CONN_ID ) AND
    ( BI.STATEMENT_ID = -1 OR P.STATEMENT_ID = BI.STATEMENT_ID ) AND
    TO_VARCHAR(P.STATEMENT_STRING) LIKE BI.STATEMENT_STRING AND
    P.STATEMENT_STATUS LIKE BI.STATEMENT_STATUS
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.STATEMENT_START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.STATEMENT_START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.STATEMENT_START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.STATEMENT_START_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')         != 0 THEN P.PROCEDURE_HOST                      ELSE MAP(BI.HOST,             '%', 'any', BI.HOST)                     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')         != 0 THEN TO_VARCHAR(P.PROCEDURE_PORT)          ELSE MAP(BI.PORT,             '%', 'any', BI.PORT)                     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONN_ID')      != 0 THEN TO_VARCHAR(P.PROCEDURE_CONNECTION_ID) ELSE MAP(BI.CONN_ID,           -1, 'any', TO_VARCHAR(BI.CONN_ID))      END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATEMENT_ID') != 0 THEN TO_VARCHAR(P.STATEMENT_ID)            ELSE MAP(BI.STATEMENT_ID,      -1, 'any', TO_VARCHAR(BI.STATEMENT_ID)) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')       != 0 THEN P.PROCEDURE_SCHEMA_NAME               ELSE MAP(BI.SCHEMA_NAME,      '%', 'any', BI.SCHEMA_NAME)              END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PROCEDURE')    != 0 THEN P.PROCEDURE_NAME                      ELSE MAP(BI.PROCEDURE_NAME,   '%', 'any', BI.PROCEDURE_NAME)           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATUS')       != 0 THEN P.STATEMENT_STATUS                    ELSE MAP(BI.STATEMENT_STATUS, '%', 'any', BI.STATEMENT_STATUS)         END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'PROCEDURE', SCHEMA_NAME || PROCEDURE_NAME),
  MAP(ORDER_BY, 'EXECUTIONS', EXECUTIONS, 'EXEC_TIME', EXECUTE_MS, 'COMP_TIME', COMPILE_MS) DESC,
  START_TIME DESC