SELECT

/* 

[NAME]

- HANA_Consistency_CheckTableConsistency_Executions_2.00.040+

[DESCRIPTION]

- Overview of consistency check runs (CHECK_TABLE_CONSISTENCY, CHECK_CATALOG)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_CONSISTENCY_CHECK_HISTORY available starting with SAP HANA 2.00.040
- See SAP Notes 1977584 and 2116157 for SAP HANA consistency checks.

[VALID FOR]

- Revisions:              >= 2.00.040

[SQL COMMAND VERSION]

- 2019/02/18:  1.0 (initial version)

[INVOLVED TABLES]

- M_CONSISTENCY_CHECK_HISTORY

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

- DB_USER

  Database user

  'SYSTEM'        --> Database user 'SYSTEM'
  '%'             --> No database user restriction

- CHECK_PROCEDURE_NAME

  Name of consistency check procedure

  'CHECK_TABLE_CONSISTENCY' --> Restrict results to call of CHECK_TABLE_CONSISTENCY
  '%'                       --> No procedure name restriction

- CHECK_ACTION

  Name of check action

  'CHECK_LOBS'              --> Only display details to action CHECK_LOBS
  '%'                       --> No restriction related to check action

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

- ERROR_CODE

  Error code

  5099            --> Only display entries with error code 5099
  -1              --> No restriction related to error code

- ERROR_MESSAGE

  Error message

  'metadata%'     --> Only return error messages starting with 'metadata'
  '%'             --> No restriction related to error message

- MIN_TOTAL_DURATION_H

  Threshold for minimum total duration (h)

  5               --> Only display lines with a minimum total duration of 5 hours
  -1              --> No restriction related to total duration

- MIN_AVG_DURATION_S

  Threshold for minimum average duration (s)

  7200            --> Only display lines with a minimum average duration of 7200 seconds
  -1              --> No restriction related to average duration

- MAX_CHECK_ACTION_LENGTH

  Possibility to limit length of check action in output

  40              --> Truncate CHECK_ACTION output column values to 40 characters
  -1              --> No truncation of CHECK_ACTION output column values
  
- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'ACTION'        --> Aggregation by check action
  'SCHEMA, TABLE' --> Aggregation by schema and table
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'DURATION'      --> Sorting by total duration
  'COUNT'         --> Sorting by number of checks

[OUTPUT PARAMETERS]

- DB_USER:              Database user calling check procedure
- CHECK_PROCEDURE_NAME: Name of check procedure
- CHECK_ACTION:         Check action (see SAP Note 1977584 for possible actions)
- SCHEMA_NAME:          Schema name of checked table (in case of table specific check)
- TABLE_NAME:           Name of check table (in case of table specific check)
- EXECUTIONS:           Number of executions
- LAST_START_TIME:      Last start time of check procedure
- AVG_TIME_S:           Average runtime (s)
- TOT_TIME_H:           Total runtime (h)
- ERROR_DETAILS:        Error details ("0" in case of successful completion)

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|DB_USER        |CHECK_PROCEDURE_NAME   |CHECK_ACTION                            |SCHEMA_NAME|TABLE_NAME|EXECUTIONS|LAST_START_TIME    |AVG_TIME_S|TOT_TIME_H|ERROR_DETAILS|
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|HDB_SCRIPT     |CHECK_TABLE_CONSISTENCY|CHECK_DATA_LENGTH                       |           |          |         1|2019/02/01 12:55:21| 165556.58|     45.98|0            |
|HDB_SCRIPT     |CHECK_TABLE_CONSISTENCY|CHECK_UNIQUE_CONSTRAINTS                |           |          |         1|2019/01/31 19:35:23|  24542.72|      6.81|0            |
|HDB_SCRIPT     |CHECK_TABLE_CONSISTENCY|CHECK_MAIN_DICTIONARY                   |           |          |         2|2019/02/01 09:36:24|  11420.82|      6.34|0            |
|HDB_SCRIPT     |CHECK_TABLE_CONSISTENCY|CHECK_REPLICATION_DATA_FULL             |           |          |         2|2019/02/01 07:22:20|   7082.94|      3.93|0            |
|_SYS_STATISTICS|CHECK_TABLE_CONSISTENCY|CHECK_DELTA_LOG,CHECK_VARIABLE_PART_SANI|           |          |        16|2019/02/18 04:09:41|    776.47|      3.45|0            |
|HDB_SCRIPT     |CHECK_TABLE_CONSISTENCY|CHECK_VALUE_INDEXES                     |           |          |         1|2019/01/30 23:12:40|   7216.34|      2.00|0            |
|HDB_SCRIPT     |CHECK_TABLE_CONSISTENCY|CHECK_MAIN_INVERTED_INDEX               |           |          |         1|2019/01/31 18:11:44|   4030.45|      1.11|0            |
|HDB_SCRIPT     |CHECK_TABLE_CONSISTENCY|CHECK_LOBS                              |           |          |         1|2019/01/30 15:55:12|   2203.25|      0.61|0            |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  DB_USER,
  CHECK_PROCEDURE_NAME,
  CHECK_ACTION,
  SCHEMA_NAME,
  TABLE_NAME,
  LPAD(EXECUTIONS, 10) EXECUTIONS,
  TO_VARCHAR(LAST_START_TIME, 'YYYY/MM/DD HH24:MI:SS') LAST_START_TIME,
  LPAD(TO_DECIMAL(MAP(EXECUTIONS, 0, 0, EXECUTION_TIME_S / EXECUTIONS), 10, 2), 10) AVG_TIME_S,
  LPAD(TO_DECIMAL(EXECUTION_TIME_S / 3600, 10, 2), 10) TOT_TIME_H,
  MAP(ERROR_MESSAGE, '', ERROR_CODE, ERROR_CODE || ':' || CHAR(32) || ERROR_MESSAGE) ERROR_DETAILS
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DB_USER')   != 0 THEN CH.USER_NAME               ELSE MAP(BI.DB_USER,              '%', 'any', BI.DB_USER)                END DB_USER,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PROCEDURE') != 0 THEN CH.CHECK_PROCEDURE_NAME    ELSE MAP(BI.CHECK_PROCEDURE_NAME, '%', 'any', BI.CHECK_PROCEDURE_NAME)   END CHECK_PROCEDURE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ACTION')    != 0 THEN 
      MAP(BI.MAX_CHECK_ACTION_LENGTH, -1, CH.CHECK_ACTION, SUBSTR(CH.CHECK_ACTION, 1, BI.MAX_CHECK_ACTION_LENGTH)) ELSE MAP(BI.CHECK_ACTION,         '%', 'any', BI.CHECK_ACTION)           END CHECK_ACTION,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')    != 0 THEN CH.SCHEMA_NAME             ELSE MAP(BI.SCHEMA_NAME,          '%', 'any', BI.SCHEMA_NAME)            END SCHEMA_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')     != 0 THEN CH.OBJECT_NAME             ELSE MAP(BI.TABLE_NAME,           '%', 'any', BI.TABLE_NAME)             END TABLE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ERROR')     != 0 THEN TO_VARCHAR(CH.ERROR_CODE)  ELSE MAP(BI.ERROR_CODE,            -1, 'any', TO_VARCHAR(BI.ERROR_CODE)) END ERROR_CODE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ERROR')     != 0 THEN CH.ERROR_MESSAGE           ELSE MAP(BI.ERROR_MESSAGE,        '%', 'any', BI.ERROR_MESSAGE)          END ERROR_MESSAGE,
    MAX(LAST_START_TIME) LAST_START_TIME,
    SUM(CHECK_EXECUTION_COUNT) EXECUTIONS,
    SUM(AVG_DURATION / 1000 * CHECK_EXECUTION_COUNT) EXECUTION_TIME_S,
    SUM(AVG_SCHEDULED_TABLE_COUNT * CHECK_EXECUTION_COUNT) SCHEDULED_TABLES,
    SUM(EXECUTED_TABLE_COUNT) EXECUTED_TABLES,
    SUM(ERROR_TABLE_COUNT) ERRORS,
    BI.MIN_TOTAL_DURATION_H,
    BI.MIN_AVG_DURATION_S,
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
      DB_USER,
      CHECK_PROCEDURE_NAME,
      CHECK_ACTION,
      SCHEMA_NAME,
      TABLE_NAME,
      ERROR_CODE,
      ERROR_MESSAGE,
      ONLY_ERRORS,
      MIN_TOTAL_DURATION_H,
      MIN_AVG_DURATION_S,
      MAX_CHECK_ACTION_LENGTH,
      AGGREGATE_BY,
      ORDER_BY
    FROM
    ( SELECT               /* Modification section */
        'C-D30' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        '%' DB_USER,
        '%' CHECK_PROCEDURE_NAME,
        'CHECK' CHECK_ACTION,
        '%' SCHEMA_NAME,
        '%' TABLE_NAME,
        -1  ERROR_CODE,
        '%' ERROR_MESSAGE,
        ' ' ONLY_ERRORS,
        -1  MIN_TOTAL_DURATION_H,
        -1  MIN_AVG_DURATION_S,
        40  MAX_CHECK_ACTION_LENGTH,
        'NONE' AGGREGATE_BY,                /* DB_USER, PROCEDURE, ACTION, SCHEMA, TABLE, ERROR */
        'DURATION' ORDER_BY                 /* DURATION, COUNT, NAME */
      FROM
        DUMMY
    )
  ) BI,
    M_CONSISTENCY_CHECK_HISTORY CH
  WHERE
    ( CH.FIRST_START_TIME BETWEEN BI.BEGIN_TIME AND BI.END_TIME OR
      CH.LAST_START_TIME BETWEEN BI.BEGIN_TIME AND BI.END_TIME OR
      CH.FIRST_START_TIME <= BI.BEGIN_TIME AND CH.LAST_START_TIME >= BI.END_TIME
    ) AND
    CH.USER_NAME LIKE BI.DB_USER AND
    CH.CHECK_PROCEDURE_NAME LIKE BI.CHECK_PROCEDURE_NAME AND
    CH.CHECK_ACTION LIKE BI.CHECK_ACTION AND
    CH.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    CH.OBJECT_NAME LIKE BI.TABLE_NAME AND
    ( BI.ERROR_CODE = -1 OR CH.ERROR_CODE = BI.ERROR_CODE ) AND
    CH.ERROR_MESSAGE LIKE BI.ERROR_MESSAGE AND
    ( BI.ONLY_ERRORS = ' ' OR CH.ERROR_CODE != 0 )
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DB_USER')   != 0 THEN CH.USER_NAME               ELSE MAP(BI.DB_USER,              '%', 'any', BI.DB_USER)                END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PROCEDURE') != 0 THEN CH.CHECK_PROCEDURE_NAME    ELSE MAP(BI.CHECK_PROCEDURE_NAME, '%', 'any', BI.CHECK_PROCEDURE_NAME)   END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ACTION')    != 0 THEN 
      MAP(BI.MAX_CHECK_ACTION_LENGTH, -1, CH.CHECK_ACTION, SUBSTR(CH.CHECK_ACTION, 1, BI.MAX_CHECK_ACTION_LENGTH)) ELSE MAP(BI.CHECK_ACTION,         '%', 'any', BI.CHECK_ACTION)           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')    != 0 THEN CH.SCHEMA_NAME             ELSE MAP(BI.SCHEMA_NAME,          '%', 'any', BI.SCHEMA_NAME)            END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')     != 0 THEN CH.OBJECT_NAME             ELSE MAP(BI.TABLE_NAME,           '%', 'any', BI.TABLE_NAME)             END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ERROR')     != 0 THEN TO_VARCHAR(CH.ERROR_CODE)  ELSE MAP(BI.ERROR_CODE,            -1, 'any', TO_VARCHAR(BI.ERROR_CODE)) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ERROR')     != 0 THEN CH.ERROR_MESSAGE           ELSE MAP(BI.ERROR_MESSAGE,        '%', 'any', BI.ERROR_MESSAGE)          END,
    BI.MIN_TOTAL_DURATION_H,
    BI.MIN_AVG_DURATION_S,
    BI.ORDER_BY
)
WHERE
  ( MIN_TOTAL_DURATION_H = -1 OR EXECUTION_TIME_S / 3600 >= MIN_TOTAL_DURATION_H ) AND
  ( MIN_AVG_DURATION_S = -1 OR EXECUTION_TIME_S / EXECUTIONS >= MIN_AVG_DURATION_S )
ORDER BY
  MAP(ORDER_BY, 'DURATION', EXECUTION_TIME_S, 'COUNT', EXECUTIONS) DESC,
  MAP(ORDER_BY, 'NAME', CHECK_PROCEDURE_NAME || CHECK_ACTION || SCHEMA_NAME || TABLE_NAME)