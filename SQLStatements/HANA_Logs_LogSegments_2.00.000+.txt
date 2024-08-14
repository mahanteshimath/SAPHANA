SELECT
/* 

[NAME]

- HANA_Logs_LogSegments_2.00.000+

[DESCRIPTION]

- Log segment overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              >= 2.00.000

[SQL COMMAND VERSION]

- 2014/10/19:  1.0 (initial version)
- 2018/02/16:  1.1 (dedicat 2.00.000+ version including LAST_COMMIT_TIME)
- 2018/12/04:  1.1 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- M_LOG_SEGMENTS

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

- SERVICE_NAME

  Service name

  'indexserver'   --> Specific service indexserver
  '%server'       --> All services ending with 'server'
  '%'             --> All services  

- LOG_SEGMENT_STATE

  State of log segment

  'Free'          --> Log segments free for re-use (included in both backup and savepoint)
  '%'             --> any log segment state

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'STATE'         --> Aggregation by state
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
  'TABLE'         --> Sorting by table name

- RESULT_ROWS

  Number of records to be displayed

  100             --> Restrict result to a maximum of 100 records
  -1              --> No restriction of result set
  
[OUTPUT PARAMETERS]

- START_TIME:   Start time
- HOST:         Host name
- PORT:         Port
- SERVICE:      Service name
- STATE:        Log segment state
- BACKED_UP:    Backup flag
- MIN_POSITION: Minimum log position of log segment
- NUM_SEGMENTS: Number of log segments
- USED_GB:      Used log segment size (GB)
- TOTAL_GB:     Total allocated log segment size (GB)

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------
|HOST       |PORT |STATE    |BACKED_UP|MIN_POSITION|NUM_SEGMENTS|USED_GB |TOTAL_GB|
-----------------------------------------------------------------------------------
|sap__hana14|30003|Writing  |FALSE    |427017486208|           1|    0.81|    1.00|
|sap__hana14|30003|Truncated|FALSE    |427000714880|           1|    0.99|    1.00|
|sap__hana14|30003|Truncated|FALSE    |426983939072|           1|    0.99|    1.00|
|sap__hana14|30003|Truncated|FALSE    |426967162880|           1|    0.99|    1.00|
|sap__hana14|30003|Truncated|FALSE    |426950395008|           1|    0.99|    1.00|
|sap__hana14|30003|Truncated|FALSE    |426933617792|           1|    1.00|    1.00|
|sap__hana14|30003|Truncated|FALSE    |426916840576|           1|    1.00|    1.00|
|sap__hana14|30003|Truncated|FALSE    |426900075456|           1|    0.99|    1.00|
|sap__hana14|30003|Truncated|FALSE    |426883298240|           1|    1.00|    1.00|
|sap__hana14|30003|Truncated|FALSE    |426866524032|           1|    0.99|    1.00|
|sap__hana14|30003|Truncated|FALSE    |426849749376|           1|    0.99|    1.00|
|sap__hana14|30003|Truncated|FALSE    |426832972160|           1|    1.00|    1.00|
|sap__hana14|30003|Truncated|FALSE    |426816194944|           1|    1.00|    1.00|
|sap__hana14|30003|Truncated|FALSE    |426814177280|           1|    0.12|    1.00|
|sap__hana15|30003|Writing  |FALSE    |253257598080|           1|    0.05|    1.00|
|sap__hana15|30003|Truncated|FALSE    |253240823616|           1|    0.99|    1.00|
|sap__hana15|30003|Truncated|FALSE    |253224058176|           1|    0.99|    1.00|
|sap__hana15|30003|Truncated|FALSE    |253207291392|           1|    0.99|    1.00|
|sap__hana15|30003|Truncated|FALSE    |253190522048|           1|    0.99|    1.00|
|sap__hana15|30003|Truncated|FALSE    |253173759360|           1|    0.99|    1.00|
-----------------------------------------------------------------------------------

*/

  START_TIME,
  HOST,
  LPAD(PORT, 5) PORT,
  SERVICE_NAME,
  STATE,
  BACKED_UP,
  MIN_POSITION,
  LPAD(NUM_SEGMENTS, 12) NUM_SEGMENTS,
  LPAD(TO_DECIMAL(USED_GB, 10, 2), 8) USED_GB,
  LPAD(TO_DECIMAL(TOTAL_GB, 10, 2), 8) TOTAL_GB
FROM
( SELECT
    START_TIME,
    HOST,
    PORT,
    SERVICE_NAME,
    STATE,
    BACKED_UP,
    MIN_POSITION,
    NUM_SEGMENTS, 
    USED_GB,
    TOTAL_GB,
    ROW_NUMBER () OVER (ORDER BY MAP(ORDER_BY, 'TIME', START_TIME) DESC, MAP(ORDER_BY, 'POSITION', LPAD(MIN_POSITION, 30)) DESC, MAP(ORDER_BY, 'HOST', HOST || PORT || LPAD(MIN_POSITION, 20)), MAP(ORDER_BY, 'SIZE', TOTAL_GB) DESC) ROW_NUM,
    RESULT_ROWS
  FROM
  ( SELECT
      CASE 
        WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.LAST_COMMIT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.LAST_COMMIT_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.LAST_COMMIT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.LAST_COMMIT_TIME END, BI.TIME_AGGREGATE_BY)
          END
        ELSE 'any'
      END START_TIME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')      != 0 THEN L.HOST                     ELSE MAP(BI.HOST,              '%', 'any', BI.HOST)              END HOST,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')      != 0 THEN TO_VARCHAR(L.PORT)         ELSE MAP(BI.PORT,              '%', 'any', BI.PORT)              END PORT,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE')   != 0 THEN S.SERVICE_NAME             ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME)           END SERVICE_NAME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATE')     != 0 THEN L.STATE                    ELSE MAP(BI.LOG_SEGMENT_STATE, '%', 'any', BI.LOG_SEGMENT_STATE) END STATE,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'BACKED_UP') != 0 THEN L.IN_BACKUP                ELSE MAP(BI.BACKED_UP,         '%', 'any', BI.BACKED_UP)         END BACKED_UP,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'POSITION')  != 0 THEN TO_VARCHAR(L.MIN_POSITION) ELSE 'any'                                                       END MIN_POSITION,
      COUNT(*) NUM_SEGMENTS,
      SUM(USED_SIZE / 1024 / 1024 / 1024) USED_GB,
      SUM(TOTAL_SIZE / 1024 / 1024 / 1024) TOTAL_GB,
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
        SERVICE_NAME,
        LOG_SEGMENT_STATE,
        BACKED_UP,
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
      ( SELECT                   /* Modification section */
          '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
          '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
          'SERVER' TIMEZONE,                              /* SERVER, UTC */
          '%' HOST,
          '%' PORT,
          '%' SERVICE_NAME,
          '%' LOG_SEGMENT_STATE,         /* e.g. 'Free' -> can be reused, 'Truncated' -> backup needed / not required for restart */
          '%' BACKED_UP,                 /* TRUE, FALSE, % */
          'TIME' AGGREGATE_BY,           /* HOST, PORT, SERVICE, STATE, DB_NAME, BACKED_UP, POSITION or comma separated combinations, NONE for no aggregation */
          'TS900' TIME_AGGREGATE_BY,     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
          'POSITION' ORDER_BY,           /* TIME, POSITION, SIZE, HOST */
          50 RESULT_ROWS
        FROM
          DUMMY
      )
    ) BI,
      M_SERVICES S,
      M_LOG_SEGMENTS L
    WHERE
      CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.LAST_COMMIT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.LAST_COMMIT_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
      S.HOST LIKE BI.HOST AND
      TO_VARCHAR(S.PORT) LIKE BI.PORT AND
      S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
      L.HOST = S.HOST AND
      L.PORT = S.PORT AND
      UPPER(L.STATE) LIKE UPPER(BI.LOG_SEGMENT_STATE) AND
      L.IN_BACKUP LIKE BI.BACKED_UP
    GROUP BY
      CASE 
        WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.LAST_COMMIT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.LAST_COMMIT_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.LAST_COMMIT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.LAST_COMMIT_TIME END, BI.TIME_AGGREGATE_BY)
          END
        ELSE 'any'
      END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')      != 0 THEN L.HOST                     ELSE MAP(BI.HOST,              '%', 'any', BI.HOST)              END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')      != 0 THEN TO_VARCHAR(L.PORT)         ELSE MAP(BI.PORT,              '%', 'any', BI.PORT)              END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE')   != 0 THEN S.SERVICE_NAME             ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME)           END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATE')     != 0 THEN L.STATE                    ELSE MAP(BI.LOG_SEGMENT_STATE, '%', 'any', BI.LOG_SEGMENT_STATE) END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'BACKED_UP') != 0 THEN L.IN_BACKUP                ELSE MAP(BI.BACKED_UP,         '%', 'any', BI.BACKED_UP)         END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'POSITION')  != 0 THEN TO_VARCHAR(L.MIN_POSITION) ELSE 'any'                                                       END,
      BI.ORDER_BY,
      BI.RESULT_ROWS
  )
)
WHERE
  ( RESULT_ROWS = -1 OR ROW_NUM <= RESULT_ROWS )
ORDER BY
  ROW_NUM