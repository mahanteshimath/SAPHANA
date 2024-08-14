SELECT
/* 

[NAME]

- HANA_SQL_ExecutedStatements_2.00.040+

[DESCRIPTION]

- Load information for executed SQL statements

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_EXECUTED_STATEMENTS available as of SAP HANA 1.0 SPS 11
- Only populated if executed statement trace is activated (SAP Note 2366291)
- CLIENT_IP and CLIENT_PID available starting with SAP HANA 2.0 SPS 04

[VALID FOR]

- Revisions:              >= 2.00.040

[SQL COMMAND VERSION]

- 2016/09/29:  1.0 (initial version)
- 2016/12/31:  1.1 (TIME_AGGREGATE_BY = 'TS<seconds>' included)
- 2017/10/26:  1.2 (TIMEZONE included)
- 2018/12/03:  1.3 (PORT added)
- 2018/12/03:  1.4 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2019/07/28:  1.5 (dedicated 2.00.040+ version including CLIENT_IP and CLIENT_PID)

[INVOLVED TABLES]

- M_EXECUTED_STATEMENTS

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

- SQL_PATTERN

  Pattern for SQL text (case insensitive)

  'INSERT%'       --> SQL statements starting with INSERT
  '%DBTABLOG%'    --> SQL statements containing DBTABLOG
  '%'             --> All SQL statements

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

- CONN_ID

  Connection ID

  330655          --> Connection ID 330655
  -1              --> No connection ID restriction

- APP_SOURCE

  Application source

  'SAPL2:437'     --> Application source 'SAPL2:437'
  'SAPMSSY2%'     --> Application sources starting with SAPMSSY2
  '%'             --> No application source restriction

- APP_NAME

  Name of application

  'ABAP:C11'      --> Application name 'ABAP:C11'
  '%'             --> No application name restriction

- STATEMENT_HASH      
 
  Hash of SQL statement to be analyzed

  '2e960d7535bf4134e2bd26b9d80bd4fa' --> SQL statement with hash '2e960d7535bf4134e2bd26b9d80bd4fa'
  '%'                                --> No statement hash restriction 

- APP_USER

  Application user

  'SAPSYS'        --> Application user 'SAPSYS'
  '%'             --> No application user restriction

- DB_USER

  Database user

  'SYSTEM'        --> Database user 'SYSTEM'
  '%'             --> No database user restriction

- CLIENT_IP

  IP address of client

  '172.23.4.12'   --> IP address 172.23.4.12 
  '%'             --> No restriction related to IP address

- CLIENT_PID

  Client process ID

  10264           --> Client process ID 10264
  -1              --> No client process ID restriction

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HASH'          --> Aggregation by statement hash
  'USER'          --> Aggregation by application user
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

- RESULT_ROWS

  Number of records to be returned by the query

  100             --> Return a maximum number of 100 records
  -1              --> Return all records

[OUTPUT PARAMETERS]

- START_TIME:       Last start time of SQL statement
- HOST:             Host name
- PORT:             Port
- CONN_ID:          Connection ID
- STATEMENT_HASH:   Hash value of SQL statement
- EXECUTIONS:       Number of executions
- ELAPSED_MS:       Elapsed time (ms)
- ELA_PER_EXEC_MS:  Elapsed time per execution (ms)
- APP_SOURCE:       Application source
- APP_NAME:         Application name
- APP_USER:         Application user name
- DB_USER:          Database user name
- CLIENT_IP:        IP address of client executing the request
- CLIENT_PID:       ID of client process executing the request
- ERROR:            Error details (0 in case of successful execution)
- SQL_TEXT:         SQL statement text

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|START_TIME         |HOST   |CONN_ID   |STATEMENT_HASH                  |EXECUTIONS|ELAPSED_MS    |ELA_PER_EXEC_MS|APP_SOURCE                           |APP_USER    |DB_USER   |ERROR                                                                                                                                                                     |SQL_TEXT                              |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2016/09/29 12:04:40|ls80010|    207367|0467d830a16403773440b68ad3081d9f|         1|          1.75|           1.75|                                     |            |SYSTEM    |2048 (column store error: fail to alter partition:  [2594] General partitioning error Paged Attributes are not possible for given partition specification.)               |alter table "SYSTEM"."ZHS_SO_1" PARTIT|
|2016/09/29 12:04:36|ls80010|    207367|6afa0d8c843ef037023cf406aa5a2465|         1|         11.44|          11.44|                                     |            |SYSTEM    |0                                                                                                                                                                         |alter table "SYSTEM"."ZHS_SO_1" alter |
|2016/09/29 12:01:53|ls80010|    207367|0467d830a16403773440b68ad3081d9f|         1|          1.58|           1.58|                                     |            |SYSTEM    |2048 (column store error: fail to alter partition:  [2594] General partitioning error Paged Attributes are not possible for given partition specification.)               |alter table "SYSTEM"."ZHS_SO_1" PARTIT|
|2016/09/29 12:01:29|ls80010|    207367|ca97be485f8b234b3a3e86faffa4b1da|         1|         10.99|          10.99|                                     |            |SYSTEM    |0                                                                                                                                                                         |alter table "SYSTEM"."ZHS_SO_1" alter |
|2016/09/29 12:01:22|ls80010|    207367|14634f4c20b2f34bd5c9256ba4d741fb|         1|         11.00|          11.00|                                     |            |SYSTEM    |0                                                                                                                                                                         |alter table "SYSTEM"."ZHS_SO_1" alter |
|2016/09/29 12:01:22|ls80010|    207367|f80574dde8a2daead47c5a5eebb8be50|         1|         10.76|          10.76|                                     |            |SYSTEM    |0                                                                                                                                                                         |alter table "SYSTEM"."ZHS_SO_1" alter |
|2016/09/29 12:01:22|ls80010|    207367|5b3db7c6cc1c2f47390199c1658b8597|         1|          9.96|           9.96|                                     |            |SYSTEM    |0                                                                                                                                                                         |alter table "SYSTEM"."ZHS_SO_1" alter |
|2016/09/29 12:01:22|ls80010|    207367|63e0bb854d8feac1f4fead6662cda80e|         1|          9.88|           9.88|                                     |            |SYSTEM    |0                                                                                                                                                                         |alter table "SYSTEM"."ZHS_SO_1" alter |
|2016/09/29 12:01:22|ls80010|    207367|17c04e6b8a8637e7e4090176cb052de6|         1|         10.10|          10.10|                                     |            |SYSTEM    |0                                                                                                                                                                         |alter table "SYSTEM"."ZHS_SO_1" alter |
|2016/09/29 12:01:22|ls80010|    207367|4a2910c0a8c7aac4dec6eb34a0987579|         1|         10.11|          10.11|                                     |            |SYSTEM    |0                                                                                                                                                                         |alter table "SYSTEM"."ZHS_SO_1" alter |
|2016/09/29 12:01:22|ls80010|    207367|bd52ea3a7bd7e5c6ee009083dbd9417a|         1|         10.15|          10.15|                                     |            |SYSTEM    |0                                                                                                                                                                         |alter table "SYSTEM"."ZHS_SO_1" alter |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  START_TIME,
  HOST,
  LPAD(PORT, 5) PORT,
  LPAD(CONN_ID, 10) CONN_ID,
  STATEMENT_HASH,
  LPAD(EXECUTIONS, 10) EXECUTIONS,
  LPAD(TO_DECIMAL(ELAPSED_MS, 12, 2), 14) ELAPSED_MS,
  LPAD(TO_DECIMAL(ELA_PER_EXEC_MS, 12, 2), 15) ELA_PER_EXEC_MS,
  APP_SOURCE,
  APP_NAME,
  APP_USER,
  DB_USER,
  CLIENT_IP,
  LPAD(CLIENT_PID, 10) CLIENT_PID,
  ERROR,
  SQL_TEXT
FROM
( SELECT
    HOST,
    PORT,
    CONN_ID,
    STATEMENT_HASH,
    EXECUTIONS,
    ELAPSED_MS,
    ELA_PER_EXEC_MS,
    START_TIME,
    APP_SOURCE,
    APP_NAME,
    APP_USER,
    DB_USER,
    CLIENT_IP,
    CLIENT_PID,
    ERROR,
    SQL_TEXT,
    RESULT_ROWS,
    ROW_NUMBER () OVER (ORDER BY 
      MAP(ORDER_BY, 'TIME', START_TIME) DESC, 
      MAP(ORDER_BY, 'DURATION', ELAPSED_MS, 'EXECUTIONS', EXECUTIONS) DESC
    ) ROW_NUM
  FROM
  ( SELECT
      CASE 
        WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(ES.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE ES.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(ES.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE ES.START_TIME END, BI.TIME_AGGREGATE_BY)
          END
        ELSE 'any' 
      END START_TIME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')       != 0 THEN ES.HOST                      ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                        END HOST,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')       != 0 THEN TO_VARCHAR(ES.PORT)          ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                        END PORT,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HASH')       != 0 THEN ES.STATEMENT_HASH            ELSE MAP(BI.STATEMENT_HASH, '%', 'any', BI.STATEMENT_HASH)    END STATEMENT_HASH,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONN_ID')    != 0 THEN TO_VARCHAR(ES.CONNECTION_ID) ELSE MAP(BI.CONN_ID, -1, 'any', TO_VARCHAR(BI.CONN_ID))       END CONN_ID,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'APP_USER')   != 0 THEN ES.APP_USER                  ELSE MAP(BI.APP_USER, '%', 'any', BI.APP_USER)                END APP_USER,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DB_USER')    != 0 THEN ES.DB_USER                   ELSE MAP(BI.DB_USER, '%', 'any', BI.DB_USER)                  END DB_USER,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CLIENT_IP')  != 0 THEN ES.CLIENT_IP                 ELSE MAP(BI.CLIENT_IP, '%', 'any', BI.CLIENT_IP)              END CLIENT_IP,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CLIENT_PID') != 0 THEN TO_VARCHAR(ES.CLIENT_PID)    ELSE MAP(BI.CLIENT_PID, -1, 'any', TO_VARCHAR(BI.CLIENT_PID)) END CLIENT_PID,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SOURCE')     != 0 THEN ES.APPLICATION_SOURCE        ELSE MAP(BI.APP_SOURCE, '%', 'any', BI.APP_SOURCE)            END APP_SOURCE,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'APP_NAME')   != 0 THEN ES.APPLICATION_NAME          ELSE MAP(BI.APP_NAME, '%', 'any', BI.APP_NAME)                END APP_NAME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ERROR')      != 0 THEN ES.ERROR_CODE || MAP(ES.ERROR_TEXT, '', '', ' (' || ES.ERROR_TEXT || ')') ELSE 'any'       END ERROR,
      COUNT(*) EXECUTIONS,
      SUM(ES.DURATION_MICROSEC) / 1000 ELAPSED_MS,
      SUM(ES.DURATION_MICROSEC) / COUNT(*) / 1000 ELA_PER_EXEC_MS,
      LTRIM(MAP(MIN(TO_VARCHAR(SUBSTR(ES.STATEMENT_STRING, 1, 4000))), MAX(TO_VARCHAR(SUBSTR(ES.STATEMENT_STRING, 1, 4000))), MIN(TO_VARCHAR(SUBSTR(ES.STATEMENT_STRING, 1, 4000))), 'various')) SQL_TEXT,
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
        CONN_ID,
        STATEMENT_HASH,
        APP_USER,
        DB_USER,
        SQL_PATTERN,
        APP_SOURCE,
        APP_NAME,
        CLIENT_IP,
        CLIENT_PID,
        ERROR_CODE,
        ERROR_TEXT,
        ONLY_ERRORS,
        AGGREGATE_BY,
        ORDER_BY,
        RESULT_ROWS,
        MAP(TIME_AGGREGATE_BY,
          'NONE',        'YYYY/MM/DD HH24:MI:SS',
          'HOUR',        'YYYY/MM/DD HH24',
          'DAY',         'YYYY/MM/DD (DY)',
          'HOUR_OF_DAY', 'HH24',
          TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY
      FROM
      ( SELECT                                       /* Modification section */
          '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
          '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
          'SERVER' TIMEZONE,                              /* SERVER, UTC */
          '%' HOST,
          '%' PORT,
          -1 CONN_ID,
          '%' STATEMENT_HASH,
          '%' APP_USER,
          '%' DB_USER,
          '%' SQL_PATTERN,
          '%' APP_SOURCE,
          '%' APP_NAME,
          '%' CLIENT_IP,
          -1 CLIENT_PID,
          -1 ERROR_CODE,
          '%' ERROR_TEXT,
          ' ' ONLY_ERRORS,
          'NONE' AGGREGATE_BY,                         /* TIME, HOST, PORT, CONN_ID, HASH, APP_USER, DB_USER, SOURCE, APP_NAME, CLIENT_PID, CLIENT_IP, ERROR or comma separated combinations, NONE for no aggregation */
          'NONE' TIME_AGGREGATE_BY,                   /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
          'TIME' ORDER_BY,                             /* TIME, DURATION, EXECUTIONS */
          -1 RESULT_ROWS
        FROM
          DUMMY
      )
    ) BI INNER JOIN
      M_EXECUTED_STATEMENTS ES ON
        CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(ES.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE ES.START_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
        ES.HOST LIKE BI.HOST AND
        TO_VARCHAR(ES.PORT) LIKE BI.PORT AND
        ES.STATEMENT_HASH LIKE BI.STATEMENT_HASH AND
        ( BI.CONN_ID = -1 OR ES.CONNECTION_ID = BI.CONN_ID ) AND
        ES.APP_USER LIKE BI.APP_USER AND
        ES.DB_USER LIKE BI.DB_USER AND
        IFNULL(ES.APPLICATION_SOURCE, '') LIKE BI.APP_SOURCE AND
        IFNULL(ES.APPLICATION_NAME, '') LIKE BI.APP_NAME AND
        ( BI.CLIENT_PID = -1 OR ES.CLIENT_PID = BI.CLIENT_PID ) AND
        TO_VARCHAR(ES.CLIENT_IP) LIKE BI.CLIENT_IP AND
        IFNULL(ES.ERROR_TEXT, '') LIKE BI.ERROR_TEXT AND
        ( BI.ERROR_CODE = -1 OR ES.ERROR_CODE = BI.ERROR_CODE ) AND
        ( BI.ONLY_ERRORS = ' ' OR ES.ERROR_CODE != 0) AND
        UPPER(TO_VARCHAR(ES.STATEMENT_STRING)) LIKE UPPER(BI.SQL_PATTERN)
    GROUP BY
      CASE 
        WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(ES.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE ES.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(ES.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE ES.START_TIME END, BI.TIME_AGGREGATE_BY)
          END
        ELSE 'any' 
      END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')       != 0 THEN ES.HOST                      ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                        END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')       != 0 THEN TO_VARCHAR(ES.PORT)          ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                        END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HASH')       != 0 THEN ES.STATEMENT_HASH            ELSE MAP(BI.STATEMENT_HASH, '%', 'any', BI.STATEMENT_HASH)    END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONN_ID')    != 0 THEN TO_VARCHAR(ES.CONNECTION_ID) ELSE MAP(BI.CONN_ID, -1, 'any', TO_VARCHAR(BI.CONN_ID))       END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'APP_USER')   != 0 THEN ES.APP_USER                  ELSE MAP(BI.APP_USER, '%', 'any', BI.APP_USER)                END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DB_USER')    != 0 THEN ES.DB_USER                   ELSE MAP(BI.DB_USER, '%', 'any', BI.DB_USER)                  END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CLIENT_IP')  != 0 THEN ES.CLIENT_IP                 ELSE MAP(BI.CLIENT_IP, '%', 'any', BI.CLIENT_IP)              END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CLIENT_PID') != 0 THEN TO_VARCHAR(ES.CLIENT_PID)    ELSE MAP(BI.CLIENT_PID, -1, 'any', TO_VARCHAR(BI.CLIENT_PID)) END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SOURCE')     != 0 THEN ES.APPLICATION_SOURCE        ELSE MAP(BI.APP_SOURCE, '%', 'any', BI.APP_SOURCE)            END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'APP_NAME')   != 0 THEN ES.APPLICATION_NAME          ELSE MAP(BI.APP_NAME, '%', 'any', BI.APP_NAME)                END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ERROR')      != 0 THEN ES.ERROR_CODE || MAP(ES.ERROR_TEXT, '', '', ' (' || ES.ERROR_TEXT || ')') ELSE 'any'       END,
      BI.RESULT_ROWS,
      BI.ORDER_BY
  )
)
WHERE
  ( RESULT_ROWS = -1 OR ROW_NUM <= RESULT_ROWS )
ORDER BY
  ROW_NUM
