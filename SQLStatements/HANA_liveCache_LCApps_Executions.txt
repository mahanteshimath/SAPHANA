SELECT

/* 

[NAME]

- HANA_liveCache_LCAppsExecutions

[DESCRIPTION]

- Overview of LCApps (COM routine) calls in integrated liveCache

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Table /SAPAPO/OMLOGHDR only available in systems with integrated liveCache (SAP Note 2593571)
- You have to be connected to the SAP<sid> schema otherwise the following error is issued:

  [259]: invalid table name: Could not find table/view /SAPAPO/OMLOGHDR in schema

- If access to ABAP objects is possible but you cannot log on as ABAP user, you can switch the default schema before executing the command:

  SET SCHEMA SAP<sid>

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2018/11/07:  1.0 (initial version)
- 2018/12/04:  1.1 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- /SAPAPO/OMLOGHDR

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

- FUNCTION_NAME

  liveCache function name

  'OM_ORDER_GET_DATA' --> Display details for calls of function OM_ORDER_GET_DATA
  '%'                 --> No restriction related to function name

- TRANSACTION_NAME

  ABAP transaction executing the liveCache call

  '/SAPAPO/RRP4'  --> Display information for calls from ABAP transaction /SAPAPO/RRP4
  '%'             --> No restriction related to ABAP transaction

- APP_USER

  Application user

  'SAPSYS'        --> Application user 'SAPSYS'
  '%'             --> No application user restriction

- MIN_DURATION_S

  Minimum duration for liveCache calls (s)

  5               --> Only display liveCache calls taking at least 5 seconds
  -1              --> No restriction related to minimum call duration

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'                  --> Aggregation by time
  'FUNCTION, TRANSACTION' --> Aggregation by function and transaction
  'NONE'                  --> No aggregation

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'COUNT'         --> Sorting by number of calls
  'DURATION'      --> Sorting by total call duration
  
[OUTPUT PARAMETERS]

- START_TIME:       Start time
- FUNCTION_NAME:    Called liveCache function
- COUNT:            Number of liveCache calls
- DURATION_S:       Total execution time (s)
- AVG_DUR_S:        Average execution time (s)
- MAIN_ROWS:        Total number of entries in main table
- AVG_MAIN_ROWS:    Average number of entries in main table
- ALL_ROWS:         Total number of entries in all tables
- APP_USER:         Application user name
- TRANSACTION_NAME: Name of calling ABAP transaction

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------
|START_TIME|FUNCTION_NAME    |COUNT  |DURATION_S|AVG_DUR_S |MAIN_ROWS |AVG_MAIN_ROWS|ALL_ROWS  |APP_USER   |TRANSACTION_NAME    |
---------------------------------------------------------------------------------------------------------------------------------
|any       |OM_ORDER_GET_DATA|   8072|  31234.78|      3.86|     16071|         1.99|    251065|RFC_ECP_CIF|                    |
|any       |OM_ORDER_GET_DATA|   8839|    121.58|      0.01|    886954|       100.34|   4365517|17000408   |ZPLN_SALES_PLAN_CALC|
|any       |OM_ORDER_GET_DATA|    406|     22.96|      0.05|       777|         1.91|     13051|49004404   |/SAPAPO/CDPSB0      |
|any       |OM_ORDER_GET_DATA|      4|      4.29|      1.07|     61711|     15427.75|    555073|11003430   |/SAPAPO/RRP3        |
|any       |OM_CHARACT_MODIFY|    217|      2.51|      0.01|       419|         1.93|      4997|RFC_ECP_CIF|                    |
|any       |OM_ORDER_GET_DATA|    168|      0.69|      0.00|      1639|         9.75|     42218|49004404   |/SAPAPO/RRP4        |
|any       |OM_ORDER_GET_DATA|     63|      0.23|      0.00|        59|         0.93|      6559|17000264   |ZPLN_C_FROM_ACTVER  |
|any       |OM_ORDER_GET_DATA|      4|      0.04|      0.01|        15|         3.75|       208|14000352   |                    |
|any       |OM_ORDER_GET_DATA|     10|      0.03|      0.00|        12|         1.20|        28|14002422   |                    |
|any       |OM_ORDER_GET_DATA|      6|      0.02|      0.00|         8|         1.33|        18|WF-BATCH   |                    |
---------------------------------------------------------------------------------------------------------------------------------

*/

  START_TIME,
  FUNCTION_NAME,
  LPAD(COUNT, 7) COUNT,
  LPAD(TO_DECIMAL(DURATION_S, 10, 2), 10) DURATION_S,
  LPAD(TO_DECIMAL(DURATION_S / COUNT, 10, 2), 9) AVG_DUR_S,
  LPAD(MAIN_ROWS, 10) MAIN_ROWS,
  LPAD(TO_DECIMAL(MAIN_ROWS / COUNT, 10, 2), 13) AVG_MAIN_ROWS,
  LPAD(ALL_ROWS, 10) ALL_ROWS,
  APP_USER,
  TRANSACTION_NAME
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.START_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END START_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'FUNCTION')    != 0 THEN L.FUNCNAME ELSE MAP(BI.FUNCTION_NAME,    '%', 'any', BI.FUNCTION_NAME)    END FUNCTION_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'APP_USER')    != 0 THEN L.UNAME    ELSE MAP(BI.APP_USER,         '%', 'any', BI.APP_USER)         END APP_USER,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TRANSACTION') != 0 THEN L.TCODE    ELSE MAP(BI.TRANSACTION_NAME, '%', 'any', BI.TRANSACTION_NAME) END TRANSACTION_NAME,
    COUNT(*) COUNT,
    SUM(DURATION) DURATION_S,
    SUM(MAIN_TABLE_NO) MAIN_ROWS,
    SUM(ALL_TABLES_NO) ALL_ROWS,
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
      FUNCTION_NAME,
      APP_USER,
      TRANSACTION_NAME,
      MIN_DURATION_S,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS',
        'HOUR',        'YYYY/MM/DD HH24',
        'DAY',         'YYYY/MM/DD (DY)',
        'HOUR_OF_DAY', 'HH24',
        TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
      ORDER_BY
    FROM
    ( SELECT           /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        'SERVER' TIMEZONE,                              /* SERVER, UTC */
        '%' FUNCTION_NAME,
        '%' APP_USER,
        '%' TRANSACTION_NAME,
        -1 MIN_DURATION_S,
        'NONE' AGGREGATE_BY,         /* TIME, FUNCTION, APP_USER, TRANSACTION or comma separated combinations, NONE for no aggregation */
        'TS900' TIME_AGGREGATE_BY,   /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'COUNT' ORDER_BY             /* TIME, COUNT, DURATION, MAIN_ROWS, ALL_ROWS */
      FROM
        DUMMY
    ) 
  ) BI,
  ( SELECT
      TO_TIMESTAMP(L.STARTDATE || L.STARTTIME, 'YYYYMMDDHH24MISS') START_TIME,
      L.*
    FROM
      "/SAPAPO/OMLOGHDR" L
  ) L
  WHERE
    L.START_TIME BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    L.FUNCNAME LIKE BI.FUNCTION_NAME AND
    L.UNAME LIKE BI.APP_USER AND
    L.TCODE LIKE BI.TRANSACTION_NAME AND
    ( BI.MIN_DURATION_S = -1 OR L.DURATION >= BI.MIN_DURATION_S )
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.START_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'FUNCTION')    != 0 THEN L.FUNCNAME ELSE MAP(BI.FUNCTION_NAME,    '%', 'any', BI.FUNCTION_NAME)    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'APP_USER')    != 0 THEN L.UNAME    ELSE MAP(BI.APP_USER,         '%', 'any', BI.APP_USER)         END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TRANSACTION') != 0 THEN L.TCODE    ELSE MAP(BI.TRANSACTION_NAME, '%', 'any', BI.TRANSACTION_NAME) END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'TIME', START_TIME) DESC,
  MAP(ORDER_BY, 'COUNT', COUNT, 'DURATION', DURATION_S, 'MAIN_ROWS', MAIN_ROWS, 'ALL_ROWS', ALL_ROWS) DESC