SELECT
/* 

[NAME]

- HANA_License_LicenseMeasurements_1.00.90+

[DESCRIPTION]

- License measurements

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_LICENSE_MEASUREMENTS available starting 1.00.90

[VALID FOR]

- Revisions:              >= 1.00.90

[SQL COMMAND VERSION]

- 2018/03/19:  1.0 (initial version)
- 2018/12/04:  1.1 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- M_LICENSE
- M_LICENSE_MEASUREMENTS

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

- GLAS_APPLICATION_ID

  GLAS application ID

  '000673'       --> GLAS application ID 000673 (SAP HANA database without BW)
  '%'            --> No restriction related to GLAS application ID

- APPLICATION_NAME

  Application name

  'Smart Data Integration' --> Smart data integration (SDA)
  '%'                      -- No restriction related to application name
  
- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'          --> Aggregation by time
  'NONE'          --> No aggregation

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'TIME'          --> Sorting by measure time
  'APPLICATION'   --> Sorting by application name

[OUTPUT PARAMETERS]

- MEASURE_TIME:        Time of measurement
- GLAS_APPLICATION_ID: GLAS application ID
- APPLICATION_NAME:    Application name
- VALUE:               Measurement value
- SUCCESSFUL:          TRUE if successful, otherwise FALSE

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------
|MEASURE_TIME|GLAS_APPLICATION_ID|APPLICATION_NAME         |VALUE     |SUCCESSFUL|
----------------------------------------------------------------------------------
|2018/03     |000673             |SAP HANA Database (no BW)|   2315.78|TRUE      |
|2018/02     |000673             |SAP HANA Database (no BW)|   3154.92|TRUE      |
|2018/01     |000673             |SAP HANA Database (no BW)|   1586.72|TRUE      |
|2017/12     |000673             |SAP HANA Database (no BW)|   1510.58|TRUE      |
|2017/11     |000673             |SAP HANA Database (no BW)|   1560.01|TRUE      |
|2017/10     |000673             |SAP HANA Database (no BW)|   1793.60|TRUE      |
|2017/09     |000673             |SAP HANA Database (no BW)|   1729.98|TRUE      |
|2017/08     |000673             |SAP HANA Database (no BW)|   1434.96|TRUE      |
|2017/07     |000673             |SAP HANA Database (no BW)|   1288.98|TRUE      |
|2017/06     |000673             |SAP HANA Database (no BW)|   1120.43|TRUE      |
|2017/05     |000673             |SAP HANA Database (no BW)|   1282.13|TRUE      |
|2017/04     |000673             |SAP HANA Database (no BW)|   1529.40|TRUE      |
|2017/03     |000673             |SAP HANA Database (no BW)|   1688.20|TRUE      |
----------------------------------------------------------------------------------

*/

  MEASURE_TIME,
  GLAS_APPLICATION_ID,
  APPLICATION_NAME,
  LPAD(TO_DECIMAL(VALUE, 10, 2), 10) VALUE,
  SUCCESSFUL
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.MEASURE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.MEASURE_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.MEASURE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.MEASURE_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END MEASURE_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'APPLICATION') != 0 THEN L.GLAS_APPLICATION_ID ELSE MAP(BI.GLAS_APPLICATION_ID, '%', 'any', BI.GLAS_APPLICATION_ID) END GLAS_APPLICATION_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'APPLICATION') != 0 THEN G.APPLICATION_NAME    ELSE MAP(BI.APPLICATION_NAME,    '%', 'any', BI.APPLICATION_NAME)    END APPLICATION_NAME,
    AVG(L.VALUE) VALUE,
    MAP(MIN(L.SUCCESSFUL), MAX(L.SUCCESSFUL), MIN(L.SUCCESSFUL), 'any') SUCCESSFUL,
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
      GLAS_APPLICATION_ID,
      APPLICATION_NAME,
      AGGREGATE_BY,
        MAP(TIME_AGGREGATE_BY,
          'NONE',        'YYYY/MM/DD HH24:MI:SS.FF3',
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
        '00H011' GLAS_APPLICATION_ID,
        'Business Warehouse' APPLICATION_NAME,
        'TIME' AGGREGATE_BY,          /* TIME, APPLICATION or comma separated values, NONE for no aggregation */
        'DAY' TIME_AGGREGATE_BY,     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'TIME' ORDER_BY               /* TIME, APPLICATION */ 
      FROM
        DUMMY
    )
  ) BI,
  ( SELECT '00H001' GLAS_APPLICATION_ID, 'Predictive Option' APPLICATION_NAME FROM DUMMY UNION ALL
    SELECT '00H002', 'Spatial Option'                  FROM DUMMY UNION ALL
    SELECT '00H003', 'Advanced Data Processing Option' FROM DUMMY UNION ALL
    SELECT '00H011', 'Business Warehouse'              FROM DUMMY UNION ALL
    SELECT '00H012', 'Smart Data Integration'          FROM DUMMY UNION ALL
    SELECT '00H013', 'Smart Data Quality'              FROM DUMMY UNION ALL
    SELECT '000673', 'SAP HANA database'               FROM DUMMY
  ) G,    
    M_LICENSE_MEASUREMENTS L
  WHERE
    G.GLAS_APPLICATION_ID LIKE BI.GLAS_APPLICATION_ID AND
    G.APPLICATION_NAME LIKE BI.APPLICATION_NAME AND
    L.GLAS_APPLICATION_ID = G.GLAS_APPLICATION_ID AND
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.MEASURE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.MEASURE_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.MEASURE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.MEASURE_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.MEASURE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.MEASURE_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'APPLICATION') != 0 THEN L.GLAS_APPLICATION_ID ELSE MAP(BI.GLAS_APPLICATION_ID, '%', 'any', BI.GLAS_APPLICATION_ID) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'APPLICATION') != 0 THEN G.APPLICATION_NAME    ELSE MAP(BI.APPLICATION_NAME,    '%', 'any', BI.APPLICATION_NAME)    END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'TIME', MEASURE_TIME) DESC,
  APPLICATION_NAME