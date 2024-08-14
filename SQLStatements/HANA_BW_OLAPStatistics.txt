SELECT

/* 

[NAME]

- HANA_BW_OLAPStatistics

[DESCRIPTION]

- BW query statistics

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- SET SCHEMA may be required if user different from table owner is used, otherwise you may get an error like:

  [259] invalid table name: Could not find table/view RSDDSTAT_OLAP in schema <non_sap_schema>

[VALID FOR]

- Environment:              BW

[SQL COMMAND VERSION]

- 2022/10/29:  1.0 (initial version)

[INVOLVED TABLES]

- RSDDSTAT_OLAP

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

        '%' SESSION_UID,
        'OLAP' HANDLE_TYPE,
        '%' APP_USER,
        '%' INFOPROVIDER,
        '%' OBJECT_NAME,

- SESSION_UID

  Session identifier

  '003N8KFHVSCZ63V5C13KJX0XO' --> Show details related to session ID 003N8KFHVSCZ63V5C13KJX0XO
  '%'                         --> No restriction related to session ID

- HANDLE_TYPE

  Internal type of query runtime object

  'OLAP'          --> Filter of internal handle type OLAP
  '%'             --> No restriction to internal handle type

- APP_USER

  Application user

  'SAPSYS'        --> Application user 'SAPSYS'
  '%'             --> No application user restriction

- INFOPROVIDER

  Infoprovider name

  'XRFCMS02'      --> Info provider XRFCMS02
  'XRF%'                  --> All info providers with names starting with 'XRF'
  '%'                     --> No restriction related to infoprovider name

- OBJECT_NAME

  OLAP statistics object name (query ID, template ID, ...)

  'XRFCMS02_QSTD_GOA_010' --> OLAP statistics objects with anme XRFCMS02_QSTD_GOA_010
  'XRF%'                  --> All OLAP statistics objects with names starting with 'XRF'
  '%'                     --> No restriction related to infoprovider name

- MIN_DURATION_S

  Minimum individual duration threshold 

  20              --> Only consider statistics with a duration of at least 20 seconds
  -1              --> No restriction related to duration

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'          --> Aggregation by time
  'INFOPROVIDER'  --> Aggregation by infoprovider
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
  'INFOPROVIDER'  --> Sorting by infoprovider

[OUTPUT PARAMETERS]

- SESSION_UID:  Session ID
- START_TIME:   Start timestamp
- DURATION_S:   Runtime duration (s)
- CNT:          Number of queries
- HANDLE_TYPE:  Internal handle type
- APP_USER:     Application user
- INFOPROVIDER: Infoprovider name
- OBJECT_NAME:  OLAP statistics object name

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------------------------------------
|SESSION_UID              |START_TIME         |DURATION_S|HANDLE_TYPE|APP_USER    |INFOPROVIDER|OBJECT_NAME                 |
-----------------------------------------------------------------------------------------------------------------------------
|003N8SJHYQU4NRDR603MNUUSM|2022/10/29 12:53:44|     34.17|DFLT       |FDLBATCH_SSC|            |                            |
|003N8SJHYQU4NRDVLRO2NJB4U|2022/10/29 12:53:37|    108.60|DFLT       |FDLBATCH_SSC|            |                            |
|003N8KFHVSCZ63V3CJEEMDD8E|2022/10/29 12:53:32|     38.91|DFLT       |FDLBATCH_SSC|            |                            |
|003N81F53460NTFNB4SCJL3YB|2022/10/29 12:53:30|     21.54|DFLT       |FDLBATCH    |            |                            |
|003N8KFHVSCZ63V652UDKO525|2022/10/29 12:53:30|     23.84|DFLT       |FDLBATCH_SSC|            |                            |
|003N8SJHYQU4NRDUATRYQ1A7I|2022/10/29 12:53:29|     34.78|DFLT       |FDLBATCH_SSC|            |                            |
|003N8SJHYQU4NRDUATRYQ1A7I|2022/10/29 12:53:29|     25.32|OLAP       |FDLBATCH_SSC|XRFCMC03    |XRFCMC03_QSTD_GIA_021_XTRACT|
|003N8KFHVSCZ63V6033THL303|2022/10/29 12:53:28|     76.19|DFLT       |FDLBATCH_SSC|            |                            |
|003N8SJHYQU4NRDS23CVS9TWN|2022/10/29 12:53:25|     33.82|DFLT       |FDLBATCH_SSC|            |                            |
-----------------------------------------------------------------------------------------------------------------------------

*/

  SESSION_UID,
  START_TIME,
  LPAD(TO_DECIMAL(DURATION_S, 10, 2), 10) DURATION_S,
  LPAD(CNT, 5) CNT,
  HANDLE_TYPE,
  APP_USER,
  INFOPROVIDER,
  OBJECT_NAME
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), TO_TIMESTAMP(S.CALDAY || S.UTIME, 'YYYYMMDDHH24MISS')) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(TO_TIMESTAMP(S.CALDAY || S.UTIME, 'YYYYMMDDHH24MISS'), BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END START_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HANDLE_TYPE')  != 0 THEN S.HANDLETP         ELSE MAP(BI.HANDLE_TYPE,  '%', 'any', BI.HANDLE_TYPE)  END HANDLE_TYPE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'APP_USER')     != 0 THEN S.UNAME            ELSE MAP(BI.APP_USER,     '%', 'any', BI.APP_USER)     END APP_USER,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'INFOPROVIDER') != 0 THEN S.INFOPROV         ELSE MAP(BI.INFOPROVIDER, '%', 'any', BI.INFOPROVIDER) END INFOPROVIDER,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'OBJECT_NAME')  != 0 THEN S.OBJNAME          ELSE MAP(BI.OBJECT_NAME,  '%', 'any', BI.OBJECT_NAME)  END OBJECT_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SESSION_UID')  != 0 THEN S.SESSIONUID       ELSE MAP(BI.SESSION_UID,  '%', 'any', BI.SESSION_UID)  END SESSION_UID,
    COUNT(*) CNT,
    SUM(S.EVTIME) DURATION_S,
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
      SESSION_UID,
      HANDLE_TYPE,
      APP_USER,
      INFOPROVIDER,
      OBJECT_NAME,
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
    ( SELECT                   /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        '%' SESSION_UID,
        '%' HANDLE_TYPE,
        '%' APP_USER,
        '%' INFOPROVIDER,
        '%' OBJECT_NAME,
        20 MIN_DURATION_S,
        'NONE' AGGREGATE_BY,          /* TIME, SESSION_UID, HANDLE_TYPE, APP_USER, INFOPROVIDER, OBJECT_NAME or comma separated combinations, NONE for no aggregation */
        'NONE' TIME_AGGREGATE_BY,     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'TIME' ORDER_BY               /* TIME, DURATION, INFOPROVIDER, OBJECT */
      FROM
        DUMMY
    ) 
  ) BI,
    RSDDSTAT_OLAP S
  WHERE
    TO_TIMESTAMP(S.CALDAY || S.UTIME, 'YYYYMMDDHH24MISS') BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    S.SESSIONUID LIKE BI.SESSION_UID AND
    S.HANDLETP LIKE BI.HANDLE_TYPE AND
    S.UNAME LIKE BI.APP_USER AND
    S.INFOPROV LIKE BI.INFOPROVIDER AND
    S.OBJNAME LIKE BI.OBJECT_NAME AND
    ( BI.MIN_DURATION_S = -1 OR S.EVTIME >= BI.MIN_DURATION_S )
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), TO_TIMESTAMP(S.CALDAY || S.UTIME, 'YYYYMMDDHH24MISS')) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(TO_TIMESTAMP(S.CALDAY || S.UTIME, 'YYYYMMDDHH24MISS'), BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HANDLE_TYPE')  != 0 THEN S.HANDLETP         ELSE MAP(BI.HANDLE_TYPE,  '%', 'any', BI.HANDLE_TYPE)  END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'APP_USER')     != 0 THEN S.UNAME            ELSE MAP(BI.APP_USER,     '%', 'any', BI.APP_USER)     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'INFOPROVIDER') != 0 THEN S.INFOPROV         ELSE MAP(BI.INFOPROVIDER, '%', 'any', BI.INFOPROVIDER) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'OBJECT_NAME')  != 0 THEN S.OBJNAME          ELSE MAP(BI.OBJECT_NAME,  '%', 'any', BI.OBJECT_NAME)  END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SESSION_UID')  != 0 THEN S.SESSIONUID       ELSE MAP(BI.SESSION_UID,  '%', 'any', BI.SESSION_UID)  END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'TIME', START_TIME, 'DURATION', DURATION_S) DESC,
  MAP(ORDER_BY, 'OBJECT', OBJECT_NAME, 'INFOPROVIDER', INFOPROVIDER),
  START_TIME DESC,
  SESSION_UID,
  DURATION_S DESC
