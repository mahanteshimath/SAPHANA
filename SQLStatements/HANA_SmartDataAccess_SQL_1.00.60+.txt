SELECT

/* 

[NAME]

- HANA_SmartDataAccess_SQL_1.00.60+

[DESCRIPTION]

- Overview of database requests issued via Smart Data Access (SDA)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Smart Data Access was introduced with SAP HANA 1.00.60
- Number of records available in M_REMOTE_STATEMENTS is controlled with the following parameter (SAP Note 2088971):

  indexserver.ini -> [smart_data_access] -> max_remote_scan_queries

[VALID FOR]

- Revisions:              >= 1.00.60

[SQL COMMAND VERSION]

- 2016/09/14:  1.0 (initial version)
- 2016/12/31:  1.1 (TIME_AGGREGATE_BY = 'TS<seconds>' included)
- 2017/10/26:  1.2 (TIMEZONE included)
- 2018/12/04:  1.3 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- M_REMOTE_STATEMENTS

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

  Connection ID

  330655          --> Connection ID 330655
  -1              --> No connection ID restriction

- TRANSACTION_ID

  Transaction identifier

  123             --> Transaction identifier 123
  -1              --> No restriction to specific transaction identifiers

- DB_USER

  Database user

  'SYSTEM'        --> Database user 'SYSTEM'
  '%'             --> No database user restriction

- SQL_PATTERN

  Pattern for SQL text (case insensitive)

  'INSERT%'       --> SQL statements starting with INSERT
  '%DBTABLOG%'    --> SQL statements containing DBTABLOG
  '%'             --> All SQL statements

- REMOTE_CONN_ID

  Remote connection ID

  330655          --> Connection ID 330655
  -1              --> No connection ID restriction

- REMOTE_SOURCE_NAME

  Name of SDA remote source

  'ABC123'        --> SDA remote source ABC123
  '0CRM%'         --> SDA remote sources starting with '0CRM'
  '%'             --> No restriction related to SDA remote source

- REMOTE_STATEMENT_STATUS
 
  Status of remote SDA statement execution

  'CLOSED'        --> SQL statements already closed
  'EXECUTING'     --> SQL statements still executing
  '%'             --> No restriction related to remote statement status

- ONLY_CURRENT_TRANSACTIONS

  Possibility to restrict result to transactions that are still active
  (orphan 'EXECUTING' statements can be suppressed in that way)

  'X'             --> Only display remote queries of current transactions
  ' '             --> No restriction related to current transactions

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'              --> Aggregation by time
  'CONN_ID, TRANS_ID' --> Aggregation by host and port
  'NONE'              --> No aggregation

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'TIME'          --> Sorting by time
  'DURATION'      --> Sorting by duration of execution
  
[OUTPUT PARAMETERS]

- START_TIME:       Start time of remote statement
- NUM_STMT:         Number of SQL statements
- SUM_ELA_S:        Total elapsed time (ms)
- AVG_ELA_MS:       Average elapsed time (ms)
- SUM_ROWS:         Total number of records returned
- AVG_ROWS:         Average number of records returned
- CONN_ID:          Connection ID
- TRANS_ID:         Transaction ID
- C:                'X' if related transaction is current, otherwise ' '
- RCONN_ID:         Remote connection ID
- REMOTE_SOURCE:    Name of remote source
- STATUS:           Status of remote execution
- STATEMENT_STRING: SQL statement string

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|START_TIME         |NUM_STMT|SUM_ELA_S      |AVG_ELA_MS|CONN_ID  |TRANS_ID|C|RCONN_ID |REMOTE_SOURCE|STATUS   |SUM_ROWS    |AVG_ROWS    |STATEMENT_STRING                                                                                                                                                                                                                                               |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2016/09/15 04:46:03|       1|           0.06|     64.13|   702403|     917|X|   195495|SAPIQDB_NLS  |CLOSED   |           0|        0.00|SELECT "/BIC/OUZAFNNC211"."V1", "/BIC/OUZAFNNC211"."V2", "/BIC/OUZAFNNC211"."V3", "/BIC/OUZAFNNC211"."V4", "/BIC/OUZAFNNC211"."V5", "/BIC/OUZAFNNC211"."V6", SUM("/BIC/OUZAFNNC211"."V7"), SUM("/BIC/OUZAFNNC211"."V8") FROM ( (SELECT "/BIC/OUZAFNNC21"."/BIC"|
|2016/09/15 04:44:22|       1|           0.00|      7.31|  1002037|     267|X|   195488|SAPIQDB_NLS  |CLOSED   |         227|      227.00| INSERT INTO #JRT_2_0X7F8433C95D50 VALUES(X )                                                                                                                                                                                                                  |
|2016/09/15 04:44:22|       1|           0.00|      7.34|  1002037|     267|X|   195488|SAPIQDB_NLS  |CLOSED   |         175|      175.00| INSERT INTO #JRT_1_0X7F8433C95D50 VALUES(X )                                                                                                                                                                                                                  |
|2016/09/15 04:44:22|       1|           0.00|      4.42|  1002037|     267|X|   195488|SAPIQDB_NLS  |CLOSED   |           0|        0.00|CREATE TABLE #JRT_2_0X7F8433C95D50 ( "C1" varchar(150) null )                                                                                                                                                                                                  |
|2016/09/15 04:44:21|       1|           0.00|      8.02|  1002037|     267|X|   195488|SAPIQDB_NLS  |CLOSED   |           0|        0.00|CREATE TABLE #JRT_1_0X7F8433C95D50 ( "C1" varchar(150) null )                                                                                                                                                                                                  |
|2016/09/15 04:44:21|       1|           0.08|     82.91|  1002037|     267|X|   195488|SAPIQDB_NLS  |CLOSED   |           0|        0.00|SELECT "/BIC/PZCCUSTSHP3"."V1", "/BIC/PZCCUSTSHP3"."V2", "/BIC/PZCCUSTSHP3"."V3", "/BIC/PZCCUSTSHP3"."V4", "/BIC/PZCCUSTSHP3"."V5", "/BIC/PZCCUSTSHP3"."V6", "/BIC/PZCCUSTSHP3"."V7", "/BIC/PZCCUSTSHP3"."V8" FROM ( (SELECT "/BIC/PZCCUSTSHP1"."V1" AS V1, "/"|
|2016/09/15 03:46:58|       1|        4063.05|4063050.87|   703186|    1036|X|   195343|SAPIQDB_NLS  |EXECUTING|           0|        0.00|SELECT "/BIC/XZFISCWEEK8"."C1", "/BIC/XZFISCWEEK7"."C1", "/BIC/XZFISCWEEK6"."V1", "/BIC/XZFISCWEEK6"."V2", "/BIC/XZFISCWEEK6"."V3", "/BIC/XZFISCWEEK6"."V4", "/BIC/XZFISCWEEK6"."V5", "/BIC/XZFISCWEEK6"."V6", "/BIC/XZFISCWEEK6"."V7", "/BIC/XZFISCWEEK6"."V8"|
|2016/09/15 03:46:01|       1|           1.87|   1875.40|   703186|    1036|X|   195339|SAPIQDB_NLS  |CLOSED   |      217561|   217561.00| INSERT INTO #JRT_3_0X7F0481EEC080 VALUES(X, X )                                                                                                                                                                                                               |
|2016/09/15 03:46:01|       1|           0.00|      8.43|   703186|    1036|X|   195339|SAPIQDB_NLS  |CLOSED   |          37|       37.00| INSERT INTO #JRT_2_0X7F0481EEC080 VALUES(X, X )                                                                                                                                                                                                               |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  START_TIME,
  LPAD(NUM, 8) NUM_STMT,
  LPAD(TO_DECIMAL(RUNTIME_MS / 1000, 13, 2), 15) SUM_ELA_S,
  LPAD(TO_DECIMAL(RUNTIME_MS / NUM, 10, 2), 12) AVG_ELA_MS,
  LPAD(RECORDS, 12) SUM_ROWS,
  LPAD(TO_DECIMAL(RECORDS / NUM, 10, 2), 12) AVG_ROWS,
  LPAD(CONN_ID, 9) CONN_ID,
  LPAD(TRANS_ID, 8) TRANS_ID,
  CURR_TRANS C,
  LPAD(REMOTE_CONN_ID, 9) RCONN_ID,
  REMOTE_SOURCE,
  STATUS,
  STATEMENT_STRING
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(S.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE S.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(S.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE S.START_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END START_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONN_ID')   != 0 THEN TO_VARCHAR(S.CONNECTION_ID)                ELSE MAP(BI.CONN_ID, -1, 'any', TO_VARCHAR(BI.CONN_ID))                      END CONN_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TRANS_ID')  != 0 THEN TO_VARCHAR(S.TRANSACTION_ID)               ELSE MAP(BI.TRANS_ID, -1, 'any', TO_VARCHAR(BI.TRANS_ID))                    END TRANS_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'RCONN_ID')  != 0 THEN TO_VARCHAR(S.REMOTE_CONNECTION_ID)         ELSE MAP(BI.REMOTE_CONN_ID, -1, 'any', TO_VARCHAR(BI.REMOTE_CONN_ID))        END REMOTE_CONN_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SOURCE')    != 0 THEN S.REMOTE_SOURCE_NAME                       ELSE MAP(BI.REMOTE_SOURCE, '%', 'any', BI.REMOTE_SOURCE)                     END REMOTE_SOURCE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATUS')    != 0 THEN S.REMOTE_STATEMENT_STATUS                  ELSE MAP(BI.REMOTE_STATEMENT_STATUS, '%', 'any', BI.REMOTE_STATEMENT_STATUS) END STATUS,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATEMENT') != 0 THEN SUBSTR(S.REMOTE_STATEMENT_STRING, 1, 4000) ELSE MAP(BI.SQL_PATTERN, '%', 'any', BI.SQL_PATTERN)                         END STATEMENT_STRING,
    COUNT(*) NUM,
    SUM(NANO100_BETWEEN(S.START_TIME, IFNULL(S.END_TIME, CURRENT_TIMESTAMP)) / 10000) RUNTIME_MS,
    SUM(S.FETCHED_RECORD_COUNT) RECORDS,
    MAP(SUM(S.CURR_TRANS), 0, ' ' , 'X') CURR_TRANS,
    BI.ONLY_CURRENT_TRANSACTIONS,
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
      TRANSACTION_ID TRANS_ID,
      DB_USER,
      SQL_PATTERN,
      REMOTE_CONN_ID,
      REMOTE_SOURCE_NAME REMOTE_SOURCE,
      ONLY_CURRENT_TRANSACTIONS,
      REMOTE_STATEMENT_STATUS,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS.FF3',
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
        -1 CONN_ID,
        -1 TRANSACTION_ID,
        '%' DB_USER,
        '%' SQL_PATTERN,
        -1 REMOTE_CONN_ID,
        '%' REMOTE_SOURCE_NAME,
        '%' REMOTE_STATEMENT_STATUS,   /* EXECUTING, CLOSED */
        ' ' ONLY_CURRENT_TRANSACTIONS,
        'STATEMENT' AGGREGATE_BY,               /* TIME, CONN_ID, TRANS_ID, RCONN_ID, DB_USER, SOURCE, STATUS, STATEMENT or comma separated combinations, NONE for no aggregation */
        'NONE' TIME_AGGREGATE_BY,          /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'DURATION' ORDER_BY                    /* TIME, DURATION, ROWS */
      FROM
        DUMMY
    )
  ) BI,
  ( SELECT
      S.*,
      ( SELECT COUNT(*) CURR_TRANS FROM M_TRANSACTIONS T WHERE T.CONNECTION_ID = S.CONNECTION_ID AND T.TRANSACTION_ID = S.TRANSACTION_ID ) CURR_TRANS
    FROM
      M_REMOTE_STATEMENTS S
  ) S
  WHERE
  ( IFNULL(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(S.END_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE S.END_TIME END, 
    TO_TIMESTAMP('9999/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS')) >= BI.BEGIN_TIME AND CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(S.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE S.START_TIME END <= BI.END_TIME ) AND
  ( BI.CONN_ID = -1 OR S.CONNECTION_ID = BI.CONN_ID ) AND
  ( BI.TRANS_ID = -1 OR S.TRANSACTION_ID = BI.TRANS_ID ) AND
    S.USER_NAME LIKE BI.DB_USER AND
    SUBSTR(S.REMOTE_STATEMENT_STRING, 1, 4000) LIKE BI.SQL_PATTERN AND
  ( BI.REMOTE_CONN_ID = -1 OR S.REMOTE_CONNECTION_ID = BI.REMOTE_CONN_ID ) AND
    S.REMOTE_SOURCE_NAME LIKE BI.REMOTE_SOURCE AND
    S.REMOTE_STATEMENT_STATUS LIKE BI.REMOTE_STATEMENT_STATUS
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(S.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE S.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(S.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE S.START_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONN_ID')   != 0 THEN TO_VARCHAR(S.CONNECTION_ID)                ELSE MAP(BI.CONN_ID, -1, 'any', TO_VARCHAR(BI.CONN_ID))                      END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TRANS_ID')  != 0 THEN TO_VARCHAR(S.TRANSACTION_ID)               ELSE MAP(BI.TRANS_ID, -1, 'any', TO_VARCHAR(BI.TRANS_ID))                    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'RCONN_ID')  != 0 THEN TO_VARCHAR(S.REMOTE_CONNECTION_ID)         ELSE MAP(BI.REMOTE_CONN_ID, -1, 'any', TO_VARCHAR(BI.REMOTE_CONN_ID))        END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SOURCE')    != 0 THEN S.REMOTE_SOURCE_NAME                       ELSE MAP(BI.REMOTE_SOURCE, '%', 'any', BI.REMOTE_SOURCE)                     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATUS')    != 0 THEN S.REMOTE_STATEMENT_STATUS                  ELSE MAP(BI.REMOTE_STATEMENT_STATUS, '%', 'any', BI.REMOTE_STATEMENT_STATUS) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATEMENT') != 0 THEN SUBSTR(S.REMOTE_STATEMENT_STRING, 1, 4000) ELSE MAP(BI.SQL_PATTERN, '%', 'any', BI.SQL_PATTERN)                         END,
    BI.ONLY_CURRENT_TRANSACTIONS,
    BI.ORDER_BY
)
WHERE
( ONLY_CURRENT_TRANSACTIONS = ' ' OR CURR_TRANS = 'X' )
ORDER BY
  MAP(ORDER_BY, 'TIME', START_TIME) DESC,
  MAP(ORDER_BY, 'DURATION', RUNTIME_MS, 'ROWS', RECORDS) DESC
 
  