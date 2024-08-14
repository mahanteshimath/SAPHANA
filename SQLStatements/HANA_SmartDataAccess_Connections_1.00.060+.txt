SELECT

/* 

[NAME]

- HANA_SmartDataAccess_Connections_1.00.060+

[DESCRIPTION]

- Overview of Smart Data Access (SDA) connections

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Smart Data Access was introduced with SAP HANA 1.0 SPS 06

[VALID FOR]

- Revisions:              >= 1.00.60

[SQL COMMAND VERSION]

- 2022/04/10:  1.0 (initial version)

[INVOLVED TABLES]

- M_REMOTE_CONNECTIONS

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

- CONN_ID

  Remote connection ID

  330655          --> Remote connection ID 330655
  -1              --> No remote connection ID restriction

- REMOTE_SOURCE_NAME

  Name of SDA remote source

  'ABC123'        --> SDA remote source ABC123
  '0CRM%'         --> SDA remote sources starting with '0CRM'
  '%'             --> No restriction related to SDA remote source

- ADAPTER_NAME

  Adapter name

  'aseodbc'       --> Adapter aseodbc
  '%odbc%'        --> Adapters with names containing 'odbc'
  '%'             --> No restriction related to adapter names

- USER_NAME

  Remote source user name

  'BC_BW'         --> User name BW
  '%'             --> No restriction related to user name

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'          --> Aggregation by time
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- STATUS

  Remote connection status

  'CONNECTED'     --> Show remote connections with CONNECTED status
  '%'             --> No restriction related to remote connection status

- DETAILS

  Remote connection details

  '%Driver=libodbcHDB.so%' --> Display remote connections with libodbcHDB.so driver
  '%'                      --> No restriction related to remote connection details

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'SOURCE'        --> Sorting by remote source name
  'COUNT'         --> Sorting by connection count

[OUTPUT PARAMETERS]

- START_TIME:         Remote connection start time
- CONN_ID:            Connection ID
- REMOTE_SOURCE_NAME: Remote source name
- ADAPTER_NAME:       Adapter name
- USER_NAME:          User name
- STATUS:             Remote connection status
- CNT:                Number of connections
- STATEMENTS:         Number of executed statements
- DETAILS:            Remote connection details

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|START_TIME         |CONN_ID|REMOTE_SOURCE_NAME |ADAPTER_NAME|USER_NAME|STATUS   |CNT|STATEMENTS|DETAILS                                                                                               |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2022/03/27 14:00:35| 100189|_SYS_SR_SITE_SITEB |hanaodbc    |_SYS_SR  |CONNECTED|  1|     19124|Driver=libodbcHDB.so,ServerNode=192.168.xx.155:30013,reconnect=false,dmlmode=readwrite,aamode=readonly|
|2022/03/27 14:00:35| 100189|_SYS_SR_SITE_SITEB2|hanaodbc    |_SYS_SR  |CONNECTED|  1|     19124|Driver=libodbcHDB.so,ServerNode=192.168.yy.160:30013,reconnect=false,dmlmode=readwrite,aamode=readonly|
|2022/03/27 14:00:35| 100185|_SYS_SR_SITE_SITEB |hanaodbc    |_SYS_SR  |CONNECTED|  1|     16607|Driver=libodbcHDB.so,ServerNode=192.168.xx.155:30013,reconnect=false,dmlmode=readwrite,aamode=readonly|
|2022/03/27 14:00:35| 100185|_SYS_SR_SITE_SITEB2|hanaodbc    |_SYS_SR  |CONNECTED|  1|     16607|Driver=libodbcHDB.so,ServerNode=192.168.yy.160:30013,reconnect=false,dmlmode=readwrite,aamode=readonly|
|2022/03/27 14:01:35| 100188|_SYS_SR_SITE_SITEB |hanaodbc    |_SYS_SR  |CONNECTED|  1|      8287|Driver=libodbcHDB.so,ServerNode=192.168.xx.155:30013,reconnect=false,dmlmode=readwrite,aamode=readonly|
|2022/03/27 14:01:35| 100188|_SYS_SR_SITE_SITEB2|hanaodbc    |_SYS_SR  |CONNECTED|  1|      8287|Driver=libodbcHDB.so,ServerNode=192.168.yy.160:30013,reconnect=false,dmlmode=readwrite,aamode=readonly|
|2022/03/27 14:04:35| 100187|_SYS_SR_SITE_SITEB |hanaodbc    |_SYS_SR  |CONNECTED|  1|      5876|Driver=libodbcHDB.so,ServerNode=192.168.xx.155:30013,reconnect=false,dmlmode=readwrite,aamode=readonly|
|2022/03/27 14:04:35| 100187|_SYS_SR_SITE_SITEB2|hanaodbc    |_SYS_SR  |CONNECTED|  1|      5876|Driver=libodbcHDB.so,ServerNode=192.168.yy.160:30013,reconnect=false,dmlmode=readwrite,aamode=readonly|
|2022/03/27 14:04:35| 100186|_SYS_SR_SITE_SITEB |hanaodbc    |_SYS_SR  |CONNECTED|  1|      4298|Driver=libodbcHDB.so,ServerNode=192.168.xx.155:30013,reconnect=false,dmlmode=readwrite,aamode=readonly|
|2022/03/27 14:04:35| 100186|_SYS_SR_SITE_SITEB2|hanaodbc    |_SYS_SR  |CONNECTED|  1|      4298|Driver=libodbcHDB.so,ServerNode=192.168.yy.160:30013,reconnect=false,dmlmode=readwrite,aamode=readonly|
|2022/03/27 13:54:55| 100124|_SYS_SR_SITE_SITEB2|hanaodbc    |_SYS_SR  |CONNECTED|  1|        95|Driver=libodbcHDB.so,ServerNode=192.168.xx.160:30013,reconnect=false,dmlmode=readwrite,aamode=readonly|
|2022/03/27 13:54:55| 100124|_SYS_SR_SITE_SITEB |hanaodbc    |_SYS_SR  |CONNECTED|  1|        94|Driver=libodbcHDB.so,ServerNode=192.168.yy.155:30013,reconnect=false,dmlmode=readwrite,aamode=readonly|
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  START_TIME,
  LPAD(CONN_ID, 7) CONN_ID,
  REMOTE_SOURCE_NAME,
  ADAPTER_NAME,
  USER_NAME,
  STATUS,
  LPAD(CNT, 3) CNT,
  LPAD(STATEMENTS, 10) STATEMENTS,
  DETAILS
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(RC.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE RC.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(RC.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE RC.START_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END START_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONN_ID') != 0 THEN TO_VARCHAR(RC.CONNECTION_ID) ELSE MAP(BI.CONN_ID,             -1, 'any', TO_VARCHAR(BI.CONN_ID)) END CONN_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SOURCE')  != 0 THEN RC.REMOTE_SOURCE_NAME        ELSE MAP(BI.REMOTE_SOURCE_NAME, '%', 'any', BI.REMOTE_SOURCE_NAME)  END REMOTE_SOURCE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ADAPTER') != 0 THEN RC.ADAPTER_NAME              ELSE MAP(BI.ADAPTER_NAME,       '%', 'any', BI.ADAPTER_NAME)        END ADAPTER_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'USER')    != 0 THEN RC.REMOTE_SOURCE_USER_NAME   ELSE MAP(BI.USER_NAME,          '%', 'any', BI.USER_NAME)           END USER_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATUS')  != 0 THEN RC.CONNECTION_STATUS         ELSE MAP(BI.STATUS,             '%', 'any', BI.STATUS)              END STATUS,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DETAILS') != 0 THEN RC.DETAILS                   ELSE MAP(BI.DETAILS,            '%', 'any', BI.DETAILS)             END DETAILS,
    COUNT(*) CNT,
    SUM(RC.STATEMENT_COUNT) STATEMENTS,
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
      CONN_ID,
      REMOTE_SOURCE_NAME,
      ADAPTER_NAME,
      USER_NAME,
      STATUS,
      DETAILS,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS',
        'HOUR',        'YYYY/MM/DD HH24',
        'DAY',         'YYYY/MM/DD (DY)',
        'HOUR_OF_DAY', 'HH24',
        TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
      ORDER_BY
    FROM
    ( SELECT                  /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        'SERVER' TIMEZONE,                              /* SERVER, UTC */
        -1 CONN_ID,
        '%' REMOTE_SOURCE_NAME,
        '%' ADAPTER_NAME,
        '%' USER_NAME,
        '%' STATUS,
        '%' DETAILS,
        'NONE' AGGREGATE_BY,         /* TIME, CONN_ID, SOURCE, ADAPTER, USER, STATUS, DETAILS or comma separated combinations, NONE for no aggregation */
        'NONE' TIME_AGGREGATE_BY,    /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'STATEMENTS' ORDER_BY           /* CONN_ID, SOURCE, COUNT, STATEMENTS */
      FROM
        DUMMY
    )
  ) BI,
    M_REMOTE_CONNECTIONS RC
  WHERE
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(RC.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE RC.START_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    (BI.CONN_ID = -1 OR RC.CONNECTION_ID = BI.CONN_ID ) AND
    RC.REMOTE_SOURCE_NAME LIKE BI.REMOTE_SOURCE_NAME AND
    RC.ADAPTER_NAME LIKE BI.ADAPTER_NAME AND
    RC.REMOTE_SOURCE_USER_NAME LIKE BI.USER_NAME AND
    RC.CONNECTION_STATUS LIKE BI.STATUS AND
    RC.DETAILS LIKE BI.DETAILS
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(RC.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE RC.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(RC.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE RC.START_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONN_ID') != 0 THEN TO_VARCHAR(RC.CONNECTION_ID) ELSE MAP(BI.CONN_ID,             -1, 'any', TO_VARCHAR(BI.CONN_ID)) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SOURCE')  != 0 THEN RC.REMOTE_SOURCE_NAME        ELSE MAP(BI.REMOTE_SOURCE_NAME, '%', 'any', BI.REMOTE_SOURCE_NAME)  END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ADAPTER') != 0 THEN RC.ADAPTER_NAME              ELSE MAP(BI.ADAPTER_NAME,       '%', 'any', BI.ADAPTER_NAME)        END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'USER')    != 0 THEN RC.REMOTE_SOURCE_USER_NAME   ELSE MAP(BI.USER_NAME,          '%', 'any', BI.USER_NAME)           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATUS')  != 0 THEN RC.CONNECTION_STATUS         ELSE MAP(BI.STATUS,             '%', 'any', BI.STATUS)              END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DETAILS') != 0 THEN RC.DETAILS                   ELSE MAP(BI.DETAILS,            '%', 'any', BI.DETAILS)             END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'CONN_ID', CONN_ID),
  MAP(ORDER_BY, 'SOURCE', REMOTE_SOURCE_NAME),
  MAP(ORDER_BY, 'COUNT', CNT, 'STATEMENTS', STATEMENTS) DESC,
  CONN_ID,
  REMOTE_SOURCE_NAME
