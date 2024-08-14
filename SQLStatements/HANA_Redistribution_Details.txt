SELECT
/* 

[NAME]

- HANA_Redistribution_Details

[DESCRIPTION]

- Steps executed as part of landscape redistributions

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- With SAP HANA >= 1.00.120 the timestamps in REORG* are erroneously stored as UTC rather than local system time

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/10/13:  1.0 (initial version)
- 2016/12/31:  1.1 (TIME_AGGREGATE_BY = 'TS<seconds>' included)
- 2017/10/25:  1.2 (TIMEZONE included)
- 2018/06/12:  1.3 (proper consideration of NULL values in join)
- 2018/06/28:  1.4 (REORG_ID, STEP_ID included)
- 2018/12/04:  1.5 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- REORG_STEPS

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

- REORG_ID

  Reorg ID

  1               --> Display entries related to reorg ID 1
  -1              --> No restriction related to reorg ID

- STEP_ID

  Step ID of reorg

  123             --> Display entries related to step ID 123
  -1              --> No restriction related to step ID

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

- STATUS

  Step status

  'FINISHED'      --> Step finished successfully
  'FAILED'        --> Step failed with error
  '%'             --> No restriction related to step status

- ONLY_ERRORS

  'X'             --> Only show steps failing with errors
  ' '             --> No restriction to failing steps

- DISPLAY_RECORDS_WITHOUT_TIMESTAMP

  'X'             --> Show records without timestamp regardless of configured time interval
  ' '             --> Show only records with timestamp fitting to configured time interval
  
- MIN_DURATION_S

  Minimum duration time in seconds

  100             --> Minimum duration time of 100 s
  -1              --> No restriction of minimum duration time

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

  'SIZE'          --> Sorting by size 
  'TABLE'         --> Sorting by table name

- RESULT_ROWS

  Number of records to be returned by the query

  100             --> Return a maximum number of 100 records
  -1              --> Return all records

[OUTPUT PARAMETERS]

- START_TIME:       Backup start time
- REORG_ID:         Reorg ID
- STEP_ID:          Step ID
- DURATION_S:       Total duration of steps (s)
- SCHEMA_NAME:      Schema name
- TABLE_NAME:       Table name
- STATUS:           Step status
- ERROR:            Error details
- SRC_HOST:         Source host
- SRC_PORT:         Source port
- TRG_HOST:         Target host
- TRG_PORT:         Target port
- NUM_STEPS:        Number of reorg steps

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------
|START_TIME             |DURATION_S|SCHEMA_NAME|TABLE_NAME    |STATUS  |ERROR|SRC_HOST|SRC_PORT|TRG_HOST   |TRG_PORT|NUM_STEPS|
-------------------------------------------------------------------------------------------------------------------------------
|2014/08/19 17:46:35,566|         1|SAPX06     |/BIC/FLNVOSB  |FINISHED|     |        |        |saphana0043|30003   |        1|
|2014/08/19 17:46:34,112|         1|SAPX06     |/BIC/FLNVOSB  |FINISHED|     |        |        |saphana0044|30003   |        1|
|2014/08/19 17:46:32,663|         1|SAPX06     |/BIC/FLNVOSB  |FINISHED|     |        |        |saphana0034|30003   |        1|
|2014/08/19 17:46:30,712|         1|SAPX06     |/BIC/FLNVDPDB |FINISHED|     |        |        |saphana0043|30003   |        1|
|2014/08/19 17:46:30,690|         0|SAPX06     |/BIC/FLNVDPDB |FINISHED|     |        |        |saphana0033|30003   |        1|
|2014/08/19 17:46:29,155|         1|SAPX06     |/BIC/FLNVDPDB |FINISHED|     |        |        |saphana0034|30003   |        1|
|2014/08/19 17:46:27,758|         0|SAPX06     |/BIC/FLNVBODDB|FINISHED|     |        |        |saphana0044|30003   |        1|
|2014/08/19 17:46:27,740|         0|SAPX06     |/BIC/FLNVBODDB|FINISHED|     |        |        |saphana0033|30003   |        1|
|2014/08/19 17:46:26,796|         0|SAPX06     |/BIC/FLNVBODDB|FINISHED|     |        |        |saphana0042|30003   |        1|
|2014/08/19 17:46:26,069|         0|SAPX06     |/BIC/FLNVAHBB |FINISHED|     |        |        |saphana0042|30003   |        1|
|2014/08/19 17:46:26,055|         0|SAPX06     |/BIC/FLNVAHBB |FINISHED|     |        |        |saphana0033|30003   |        1|
|2014/08/19 17:46:25,558|         0|SAPX06     |/BIC/FLNVAHBB |FINISHED|     |        |        |saphana0034|30003   |        1|
|2014/08/19 17:46:25,031|         0|SAPX06     |/BIC/FLNPPPUNB|FINISHED|     |        |        |saphana0044|30003   |        1|
-------------------------------------------------------------------------------------------------------------------------------

*/

  START_TIME,
  IFNULL(LPAD(DURATION_S, 10), '') DURATION_S,
  LPAD(REORG_ID, 8) REORG_ID,
  LPAD(STEP_ID, 8) STEP_ID,
  SCHEMA_NAME,
  TABLE_NAME,
  IFNULL(STATUS, '') STATUS,
  IFNULL(ERROR, '') ERROR,
  IFNULL(SRC_HOST, '') SRC_HOST,
  IFNULL(SRC_PORT, '') SRC_PORT,
  IFNULL(TRG_HOST, '') TRG_HOST,
  IFNULL(TRG_PORT, '') TRG_PORT,
  LPAD(NUM_STEPS, 9) NUM_STEPS
FROM
( SELECT
    START_TIME,
    REORG_ID,
    STEP_ID,
    SRC_HOST,
    SRC_PORT,
    TRG_HOST,
    TRG_PORT,
    SCHEMA_NAME,
    TABLE_NAME,
    STATUS,
    ERROR,
    DURATION_S,
    NUM_STEPS,
    RESULT_ROWS,
    ROW_NUMBER () OVER (ORDER BY MAP(ORDER_BY, 'TIME', START_TIME) DESC, MAP(ORDER_BY, 'DURATION', DURATION_S) DESC, MAP(ORDER_BY, 'TABLE', SCHEMA_NAME || TABLE_NAME, 
      'REORG', LPAD(REORG_ID, 100) || LPAD(STEP_ID, 100))) ROW_NUM
  FROM
  ( SELECT
      CASE
        WHEN R.START_DATE IS NULL THEN '-'
        WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(R.START_DATE, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE R.START_DATE END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(R.START_DATE, BI.TIME_AGGREGATE_BY)
          END
        ELSE 'any' 
      END START_TIME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'REORG_ID') != 0 THEN TO_VARCHAR(R.REORG_ID) ELSE MAP(BI.REORG_ID, -1, 'any', TO_VARCHAR(BI.REORG_ID)) END REORG_ID,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STEP_ID')  != 0 THEN TO_VARCHAR(R.STEP_ID)  ELSE MAP(BI.STEP_ID, -1, 'any', TO_VARCHAR(BI.STEP_ID))   END STEP_ID,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SRC_HOST') != 0 THEN R.OLD_HOST             ELSE 'any'                                                END SRC_HOST,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SRC_PORT') != 0 THEN TO_VARCHAR(R.OLD_PORT) ELSE 'any'                                                END SRC_PORT,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TRG_HOST') != 0 THEN R.NEW_HOST             ELSE 'any'                                                END TRG_HOST,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TRG_PORT') != 0 THEN TO_VARCHAR(R.NEW_PORT) ELSE 'any'                                                END TRG_PORT,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')   != 0 THEN R.SCHEMA_NAME          ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)      END SCHEMA_NAME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')    != 0 THEN R.TABLE_NAME           ELSE MAP(BI.TABLE_NAME,  '%', 'any', BI.TABLE_NAME)       END TABLE_NAME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATUS')   != 0 THEN R.STATUS               ELSE MAP(BI.STATUS,      '%', 'any', BI.STATUS)           END STATUS,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ERROR')    != 0 THEN R.ERROR                ELSE 'any'                                                END ERROR,
      SUM(SECONDS_BETWEEN(R.START_DATE, IFNULL(R.END_DATE, CURRENT_TIMESTAMP))) DURATION_S,
      COUNT(*) NUM_STEPS,
      BI.RESULT_ROWS,
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
        REORG_ID,
        STEP_ID,
        SCHEMA_NAME,
        TABLE_NAME,
        HOST,
        PORT,
        STATUS,
        ONLY_ERRORS,
        DISPLAY_RECORDS_WITHOUT_TIMESTAMP,
        MIN_DURATION_S,
        AGGREGATE_BY,
        MAP(TIME_AGGREGATE_BY,
          'NONE',        'YYYY/MM/DD HH24:MI:SS.FF3',
          'HOUR',        'YYYY/MM/DD HH24',
          'DAY',         'YYYY/MM/DD (DY)',
          'HOUR_OF_DAY', 'HH24',
          TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
        RESULT_ROWS,
        ORDER_BY
      FROM
      ( SELECT                   /* Modification section */
          '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
          '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
          'SERVER' TIMEZONE,                              /* SERVER, UTC */
          -1 REORG_ID,
          -1 STEP_ID,
          '%' SCHEMA_NAME,
          '%' TABLE_NAME,
          '%' HOST,
          '%' PORT,
          '%' STATUS,              /* %, FINISHED, FAILED, STARTED, CANCELED, ... */
          ' ' ONLY_ERRORS,
          'X' DISPLAY_RECORDS_WITHOUT_TIMESTAMP,
          -1 MIN_DURATION_S,
          'NONE' AGGREGATE_BY,        /* TIME, REORG_ID, STEP_ID, SCHEMA, TABLE, SRC_HOST, SRC_PORT, TRG_HOST, TRG_PORT, STATUS, ERROR or comma separated list, NONE for no aggregation */
          'TS900' TIME_AGGREGATE_BY,     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
          'TIME' ORDER_BY,                        /* TIME, DURATION, TABLE, REORG */ 
          50 RESULT_ROWS
        FROM
          DUMMY
      )
    ) BI,
      REORG_STEPS R
    WHERE
    ( DISPLAY_RECORDS_WITHOUT_TIMESTAMP = 'X' AND ( R.START_DATE IS NULL OR R.END_DATE IS NULL ) OR
      CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(IFNULL(R.START_DATE, ADD_DAYS(R.END_DATE, -100)), SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE IFNULL(R.START_DATE, ADD_DAYS(R.END_DATE, -100)) END <= BI.END_TIME AND
      CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(IFNULL(R.END_DATE, ADD_DAYS(R.START_DATE, 100)), SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE IFNULL(R.END_DATE, ADD_DAYS(R.START_DATE, 100)) END >= BI.BEGIN_TIME
    ) AND
    ( BI.REORG_ID = -1 OR R.REORG_ID = BI.REORG_ID ) AND
    ( BI.STEP_ID = -1 OR R.STEP_ID = BI.STEP_ID ) ANd
      R.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
      R.TABLE_NAME LIKE BI.TABLE_NAME AND
      ( IFNULL(R.OLD_HOST, '') LIKE BI.HOST OR IFNULL(R.NEW_HOST, '') LIKE BI.HOST ) AND
      ( IFNULL(TO_VARCHAR(R.OLD_PORT), '') LIKE BI.PORT OR IFNULL(TO_VARCHAR(R.NEW_PORT), '') LIKE BI.PORT ) AND
      IFNULL(R.STATUS, '') LIKE BI.STATUS AND
      ( BI.ONLY_ERRORS = ' ' OR R.ERROR IS NOT NULL ) AND
      ( BI.MIN_DURATION_S = -1 OR SECONDS_BETWEEN(R.START_DATE, IFNULL(R.END_DATE, MAP(BI.TIMEZONE, 'UTC', CURRENT_UTCTIMESTAMP, CURRENT_TIMESTAMP))) >= BI.MIN_DURATION_S )
    GROUP BY
      CASE 
        WHEN R.START_DATE IS NULL THEN '-'
        WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(R.START_DATE, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE R.START_DATE END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(R.START_DATE, BI.TIME_AGGREGATE_BY)
          END
        ELSE 'any' 
      END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'REORG_ID') != 0 THEN TO_VARCHAR(R.REORG_ID) ELSE MAP(BI.REORG_ID, -1, 'any', TO_VARCHAR(BI.REORG_ID)) END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STEP_ID')  != 0 THEN TO_VARCHAR(R.STEP_ID)  ELSE MAP(BI.STEP_ID, -1, 'any', TO_VARCHAR(BI.STEP_ID))   END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SRC_HOST') != 0 THEN R.OLD_HOST             ELSE 'any'                                                END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SRC_PORT') != 0 THEN TO_VARCHAR(R.OLD_PORT) ELSE 'any'                                                END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TRG_HOST') != 0 THEN R.NEW_HOST             ELSE 'any'                                                END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TRG_PORT') != 0 THEN TO_VARCHAR(R.NEW_PORT) ELSE 'any'                                                END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')   != 0 THEN R.SCHEMA_NAME          ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)      END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')    != 0 THEN R.TABLE_NAME           ELSE MAP(BI.TABLE_NAME,  '%', 'any', BI.TABLE_NAME)       END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATUS')   != 0 THEN R.STATUS               ELSE MAP(BI.STATUS,      '%', 'any', BI.STATUS)           END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ERROR')    != 0 THEN R.ERROR                ELSE 'any'                                                END,
      BI.RESULT_ROWS,
      BI.ORDER_BY
  )
)
WHERE
  ( RESULT_ROWS = -1 OR ROW_NUM <= RESULT_ROWS )
ORDER BY
  ROW_NUM
