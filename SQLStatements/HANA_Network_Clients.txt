SELECT
/* 

[NAME]

- HANA_Network_Clients

[DESCRIPTION]

- Network traffic and roundtrip times to client hosts

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Data is only collected if the following parameter is set:

  indexserver.ini --> [sql_client_network_io] --> enabled = true

- Performance overhead, so this trace should only be activated temporarily
- Trace data is purged when trace is deactivated, so you have to analyze while the trace is running or proceed according to SAP Note 2771627

- NO_JOIN_REMOVAL hint required as workaround for bug 110097 (Rev. 112.02, "Execution flow must not reach here", "scalar subquery is not allowed")

[VALID FOR]

- Revisions:              >= 1.00.70

[SQL COMMAND VERSION]

- 2014/07/14:  1.0 (initial version)
- 2014/12/05:  1.1 (STATEMENT_HASH from M_EXPENSIVE_STATEMENTS included)
- 2016/12/31:  1.2 (TIME_AGGREGATE_BY = 'TS<seconds>' included)
- 2017/10/25:  1.3 (TIMEZONE included)
- 2018/12/04:  1.4 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- M_SQL_CLIENT_NETWORK_IO
- M_EXPENSIVE_STATEMENTS

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

- SERVICE_NAME

  Service name

  'indexserver'   --> Specific service indexserver
  '%server'       --> All services ending with 'server'
  '%'             --> All services  

- CLIENT_HOST

  Host name of client

  'sapapp'        --> Client host name sapapp
  'sap%'          --> Client hosts starting with 'sap'
  '%'             --> No client host name restriction

- STATEMENT_HASH      
 
  Hash of SQL statement to be analyzed 

  'f87a03ad3013df4c693681ca4d0540a7' --> Statement hash f87a03ad3013df4c693681ca4d0540a7
  '%'                                --> No restriction related to statement hash

- MIN_RTT_US

  Minimum roundtrip time (microseconds)

  400             --> Only consider communications with a roundtrip time of at least 400 us
  -1              --> No restriction

- MAX_RTT_US

  Maximum roundtrip time (microseconds)

  1000            --> Only consider communications with a roundtrip time of not more than 1000 us (1 ms)
  -1              --> No restriction

- MIN_SIZE_KB

  Minimum size sent / received (KB)

  500             --> Only consider communications with a data exchange of at least 500 KB
  -1              --> No restriction

- MAX_SIZE_KB

  Maximum size sent / received (KB)

  1               --> Only consider communications with a data exchange of not more than 1 KB
  -1              --> No restriction

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

  'TIME'          --> Sorting by time
  'HOST'          --> Sorting by host name

[OUTPUT PARAMETERS]

- SERVER_TIME:    Server timestamp
- HOST:           Host name
- PORT:           Port
- SERVICE:        Service name
- CLIENT:         Client host
- STATEMENT_HASH: Statement hash (if expensive statement trace is available for the statement)
- ROUNDTRIPS:     Number of roundtrips
- SUM_RTT_MS:     Total roundtrip time (ms)
- AVG_RTT_MS:     Average roundtrip time (ms)
- SUM_SIZE_KB:    Total data transfer size (KB)
- AVG_SIZE_KB:    Average data transfer size (KB)

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------
|SERVER_TIME     |HOST|PORT|CLIENT  |ROUNDTRIPS|SUM_RTT_MS|AVG_RTT_MS|SUM_SIZE_KB|AVG_SIZE_KB|
----------------------------------------------------------------------------------------------
|2014/07/14 18:11|any |any |saphana3|     36066|  14503.24|      0.40|   16854.22|       0.46|
|2014/07/14 18:10|any |any |saphana3|     38358|  59775.73|      1.55|   13725.24|       0.35|
|2014/07/14 18:09|any |any |saphana3|     10603|  12305.38|      1.16|    3978.38|       0.37|
|2014/07/14 18:08|any |any |saphana3|       121|     29.99|      0.24|      50.85|       0.42|
|2014/07/14 18:07|any |any |saphana3|        42|     13.66|      0.32|      16.61|       0.39|
|2014/07/14 18:06|any |any |saphana3|        11|     12.28|      1.11|       3.88|       0.35|
|2014/07/14 18:05|any |any |saphana3|        33|      9.37|      0.28|      16.06|       0.48|
|2014/07/14 18:04|any |any |saphana3|        62|     20.55|      0.33|      25.54|       0.41|
|2014/07/14 18:03|any |any |saphana3|        28|      4.88|      0.17|       9.14|       0.32|
|2014/07/14 18:02|any |any |saphana3|       107|     32.81|      0.30|      39.00|       0.36|
|2014/07/14 18:01|any |any |saphana3|        19|      5.09|      0.26|       6.94|       0.36|
|2014/07/14 18:00|any |any |saphana3|        20|      5.36|      0.26|       8.27|       0.41|
|2014/07/14 17:59|any |any |saphana3|        37|     18.01|      0.48|      18.56|       0.50|
|2014/07/14 17:58|any |any |saphana3|       306|     70.78|      0.23|     124.67|       0.40|
|2014/07/14 17:57|any |any |saphana3|        59|     13.05|      0.22|      23.52|       0.39|
|2014/07/14 17:56|any |any |saphana3|        26|      9.99|      0.38|       9.82|       0.37|
----------------------------------------------------------------------------------------------

*/

  SERVER_TIME,
  HOST,
  PORT,
  SERVICE_NAME SERVICE,
  CLIENT,
  STATEMENT_HASH,
  LPAD(COUNT(*), 10) ROUNDTRIPS,
  LPAD(TO_DECIMAL(SUM(SERVER_TIME_MS), 10, 2), 14) SERVER_TIME_MS,
  LPAD(TO_DECIMAL(SUM(ROUNDTRIP_TIME_MS), 10, 2), 10) SUM_RTT_MS,
  LPAD(TO_DECIMAL(SUM(ROUNDTRIP_TIME_MS) / COUNT(*), 10, 2), 10) AVG_RTT_MS,
  LPAD(TO_DECIMAL(SUM(MESSAGE_SIZE_KB), 10, 2), 11) SUM_SIZE_KB,
  LPAD(TO_DECIMAL(SUM(MESSAGE_SIZE_KB) / COUNT(*), 10, 2), 11) AVG_SIZE_KB
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(C.SERVER_RECEIVED_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE C.SERVER_RECEIVED_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(C.SERVER_RECEIVED_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE C.SERVER_RECEIVED_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END SERVER_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')    != 0 THEN C.HOST                           ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                     END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(C.PORT)               ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                     END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE') != 0 THEN S.SERVICE_NAME                   ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME)     END SERVICE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CLIENT')  != 0 THEN C.CLIENT_HOST                    ELSE MAP(BI.CLIENT_HOST, '%', 'any', BI.CLIENT_HOST)       END CLIENT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HASH')    != 0 THEN IFNULL(ES.STATEMENT_HASH, 'n/a') ELSE MAP(BI.STATEMENT_HASH, '%', 'any', BI.STATEMENT_HASH) END STATEMENT_HASH,
    C.SERVER_DURATION / 1000 SERVER_TIME_MS,
    ( C.CLIENT_DURATION - C.SERVER_DURATION ) / 1000 ROUNDTRIP_TIME_MS,
    ( C.RECEIVED_MESSAGE_SIZE + C.SEND_MESSAGE_SIZE ) / 1024 MESSAGE_SIZE_KB,
    BI.AGGREGATE_BY,
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
      SERVICE_NAME,
      CLIENT_HOST,
      STATEMENT_HASH,
      MIN_RTT_US,
      MAX_RTT_US,
      MIN_SIZE_KB,
      MAX_SIZE_KB,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS.FF7',
        'HOUR',        'YYYY/MM/DD HH24',
        'DAY',         'YYYY/MM/DD (DY)',
        'HOUR_OF_DAY', 'HH24',
        TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
      ORDER_BY
    FROM
    ( SELECT                       /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        'SERVER' TIMEZONE,                              /* SERVER, UTC */
        '%' HOST,
        '%' PORT,
        '%' SERVICE_NAME,
        '%' CLIENT_HOST,
        '%' STATEMENT_HASH,
        -1  MIN_RTT_US,
        -1  MAX_RTT_US,
        -1  MIN_SIZE_KB,
        1  MAX_SIZE_KB,
        'NONE' AGGREGATE_BY,                          /* TIME, HOST, PORT, SERVICE, CLIENT, HASH or comma-separated combinations, NONE for no aggregation */
        'TS900' TIME_AGGREGATE_BY,                    /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'TIME' ORDER_BY                               /* TIME, HOST, PORT, CLIENT */
      FROM
        DUMMY
    )
  ) BI INNER JOIN
    M_SERVICES S ON
      S.HOST LIKE BI.HOST AND
      TO_VARCHAR(S.PORT) LIKE BI.PORT AND
      S.SERVICE_NAME LIKE BI.SERVICE_NAME INNER JOIN
    M_SQL_CLIENT_NETWORK_IO C ON
      C.HOST = S.HOST AND
      C.PORT = S.PORT AND
      C.CLIENT_HOST LIKE BI.CLIENT_HOST AND
      CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(C.SERVER_RECEIVED_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE C.SERVER_RECEIVED_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
      ( BI.MIN_RTT_US = -1 OR C.CLIENT_DURATION - C.SERVER_DURATION >= BI.MIN_RTT_US ) AND
      ( BI.MAX_RTT_US = -1 OR C.CLIENT_DURATION - C.SERVER_DURATION <= BI.MAX_RTT_US ) AND
      ( BI.MIN_SIZE_KB = -1 OR C.RECEIVED_MESSAGE_SIZE + C.SEND_MESSAGE_SIZE >= BI.MIN_SIZE_KB * 1024 ) AND
      ( BI.MAX_SIZE_KB = -1 OR C.RECEIVED_MESSAGE_SIZE + C.SEND_MESSAGE_SIZE <= BI.MAX_SIZE_KB * 1024 ) AND
      C.CLIENT_DURATION > 0 /* faulty negative values possible */ LEFT OUTER JOIN
    M_EXPENSIVE_STATEMENTS ES ON
      ES.NETWORK_MESSAGE_ID = C.MESSAGE_ID AND
      ES.OPERATION IN ('AGGREGATED_EXECUTION', 'CALL')
  WHERE
    ( BI.STATEMENT_HASH = '%' OR ES.STATEMENT_HASH = BI.STATEMENT_HASH )
)
GROUP BY
  SERVER_TIME,
  HOST,
  PORT,
  SERVICE_NAME,
  CLIENT,
  ORDER_BY,
  STATEMENT_HASH
ORDER BY
  MAP(ORDER_BY, 'TIME', SERVER_TIME) DESC,
  MAP(ORDER_BY, 'HOST', HOST || PORT, 'PORT', PORT || HOST, 'CLIENT', CLIENT)
WITH HINT (NO_JOIN_REMOVAL)