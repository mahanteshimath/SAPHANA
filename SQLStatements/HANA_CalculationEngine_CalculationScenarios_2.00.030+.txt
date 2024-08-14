SELECT
/* 

[NAME]

- HANA_CalculationEngine_CalculationScenarios_2.00.30+

[DESCRIPTION]

- Display calculation scenarios

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_CE_CALCSCENARIO_HINTS available starting with SAP HANA 2.00.030
- SAP_HRF:_SYS_SS_CE_* tables belong to HANA Rules Framework

[VALID FOR]

- Revisions:              >= 2.00.030

[SQL COMMAND VERSION]

- 2014/12/11:  1.0 (initial version)
- 2015/09/15:  1.1 (AGGREGATE_BY 
- 2017/10/24:  1.2 (TIMEZONE included)
- 2018/09/28:  1.3 (SCENARIOS output column added)
- 2018/11/10:  1.4 (M_CE_CALSCENARIO_HINTS added)
- 2018/12/04:  1.5 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2019/12/12:  1.6 (sorting by COUNT added)
- 2021/08/29:  1.7 (TIME_AGGREGATE_BY added)

[INVOLVED TABLES]

- M_CE_CALCSCENARIO_HINTS
- M_CE_CALCSCENARIOS_OVERVIEW

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

- COMPONENT

  Name of calculation scenario component

  'BW'            --> Only show calculation scenarios belonging to component BW
  '%'             --> No restriction related to calculation scenario component

- SCHEMA_NAME

  Schema name

  '_SYS_BIC'      --> Scenarios in schema _SYS_BIC
  '%'             --> No restriction related to schema name

- SCENARIO_NAME

  Name of calculation scenario

  '0BW:BIA:Y08NX2004' --> Calculation scenario with name SAPSR3:0BW:BIA:Y08NX2004
  '%cs'               --> Calculation scenarios ending with 'cs'
  '%'                        --> No restriction related to calculation scenario name

- SCENARIO_CLASS

  Calculation scenario class

  '%CRM%'         --> Display calculation scenarios with classes related to CRM
  '%'             --> No restriction related to calculation scenario class

- SCENARIO_HINTS

  Defined hints for scenario (use place holders at beginning and end as values and multiple hints can be part of the SCENARIO_HINTS column)

  '%doReverseReplaceAll%' --> Scenarios with doReverseReplaceAll hint
  '%'                     --> No restriction related to scenario hint

- ONLY_SCENARIOS_WITH_HINTS

  Possibility to restrict results to scenarios with defined hints

  'X'             --> Only display scenarios with defined hints
  ' '             --> No restriction related to existing scenario hints

- ONLY_PERSISTENT_SCENARIOS

  Possibility to restrict result to persistent scenarios

  'X'             --> Display only persistent scenarios
  ' '             --> Display all scenarios

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'COMPONENT'     --> Aggregation by component
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

[OUTPUT PARAMETERS]

- CREATION_TIME:  Creation time of calculation scenario
- HOST:           Host name
- PORT:           Port
- SERVICE:        Service name
- COMPONENT:      Component responsible for calculation scenario
- SCHEMA_NAME:    Schema name
- SCENARIO_CLASS: Scenario class
- SCENARIO_TIME:  Name of calculation scenario
- P:              'X' -> persisted, ' ' -> not persisted
- SCENARIOS:      Number of scenarios
- SIZE_MB:        Memory size (MB)
- SIZE_PCT:       Memory size share (%)
- SCENARIO_HINTS: Scenario hints

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------
|COMPONENT|SCHEMA_NAME|SCENARIO_CLASS                         |P|SCENARIOS|SIZE_MB |SIZE_PCT|
---------------------------------------------------------------------------------------------
|BW       |SAPSR3     |0BW:NCUM* - BW (non-cumulative queries)| |  1544880| 2773.86|   99.48|
|BW       |SAPSR3     |0BW:BIA* - BW (hierarchy)              |X|      254|   12.57|    0.45|
|UNKNOWN  |_SYS_BIC   |OTHER                                  |X|      198|    1.54|    0.05|
|UNKNOWN  |_SYS_BIC   |OTHER                                  | |       24|    0.24|    0.00|
|UNKNOWN  |SAPSR3     |OTHER                                  | |        3|    0.07|    0.00|
|BW       |SAPSR3     |0BW:BIA* - BW (hierarchy)              | |        1|    0.00|    0.00|
|BW       |SAPSR3     |OTHER                                  |X|       97|    0.00|    0.00|
---------------------------------------------------------------------------------------------

*/

  CREATION_TIME,
  HOST,
  PORT,
  SERVICE_NAME SERVICE,
  COMPONENT,
  SCHEMA_NAME,
  SCENARIO_NAME,
  SCENARIO_CLASS,
  MAP(PERSISTENT, 'TRUE', 'X', '') P,
  LPAD(SCENARIOS, 9) SCENARIOS,
  LPAD(TO_DECIMAL(SIZE_MB, 10, 2), 8) SIZE_MB,
  LPAD(TO_DECIMAL(MAP(SIZE_MB, 0, 0, SIZE_MB / SUM(SIZE_MB) OVER () * 100), 10, 2), 8) SIZE_PCT,
  SCENARIO_HINTS
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(CS.CREATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE CS.CREATE_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(CS.CREATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE CS.CREATE_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END CREATION_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST') != 0       THEN CS.HOST             ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                     END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT') != 0       THEN TO_VARCHAR(CS.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                     END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE') != 0    THEN S.SERVICE_NAME      ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME)     END SERVICE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COMPONENT') != 0  THEN CS.COMPONENT        ELSE MAP(BI.COMPONENT, '%', 'any', BI.COMPONENT)           END COMPONENT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA') != 0     THEN CS.SCHEMA_NAME      ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)       END SCHEMA_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCENARIO') != 0   THEN CS.SCENARIO_NAME    ELSE MAP(BI.SCENARIO_NAME, '%', 'any', BI.SCENARIO_NAME)   END SCENARIO_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CLASS') != 0      THEN CS.SCENARIO_CLASS   ELSE MAP(BI.SCENARIO_CLASS, '%', 'any', BI.SCENARIO_CLASS) END SCENARIO_CLASS,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HINTS') != 0      THEN CH.SCENARIO_HINTS   ELSE MAP(BI.SCENARIO_HINTS, '%', 'any', BI.SCENARIO_HINTS) END SCENARIO_HINTS,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PERSISTENT') != 0 THEN CS.IS_PERSISTENT    ELSE MAP(BI.ONLY_PERSISTENT_SCENARIOS, 'X', 'TRUE', 'any') END PERSISTENT,
    COUNT(*) SCENARIOS,
    SUM(CS.MEMORY_SIZE / 1024 / 1024) SIZE_MB,
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
      COMPONENT,
      SCHEMA_NAME,
      SCENARIO_NAME,
      SCENARIO_CLASS,
      SCENARIO_HINTS,
      ONLY_SCENARIOS_WITH_HINTS,
      ONLY_PERSISTENT_SCENARIOS,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS:FF7',
        'HOUR',        'YYYY/MM/DD HH24',
        'DAY',         'YYYY/MM/DD (DY)',
        'HOUR_OF_DAY', 'HH24',
        TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
      ORDER_BY
    FROM
    ( SELECT                /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        'SERVER' TIMEZONE,                              /* SERVER, UTC */
        '%' HOST,
        '%' PORT,
        '%' SERVICE_NAME,
        '%' COMPONENT,
        '%' SCHEMA_NAME,
        '%' SCENARIO_NAME,
        '%' SCENARIO_CLASS,
        '%' SCENARIO_HINTS,
        ' ' ONLY_SCENARIOS_WITH_HINTS,
        ' ' ONLY_PERSISTENT_SCENARIOS,
        'NONE' AGGREGATE_BY,     /* HOST, PORT, SERVICE, COMPONENT, SCHEMA, SCENARIO, PERSISTENT, HINTS, CLASS or comma separated combinations, NONE for no aggregation */
        'NONE' TIME_AGGREGATE_BY,    /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'SIZE' ORDER_BY                /* TIME, NAME, SIZE, COUNT */
      FROM
        DUMMY
    )
  ) BI,
    M_SERVICES S,
  ( SELECT
      *,
      CASE
        WHEN SCENARIO_NAME LIKE '0BW:BIA%'      THEN            '0BW:BIA* - BW (hierarchy)'
        WHEN SCENARIO_NAME LIKE '0BW:CRM%'      THEN            '0BW:CRM* - BW (CRM segmentation)'
        WHEN SCENARIO_NAME LIKE '0BW:NCUM%'     THEN            '0BW:NCUM* - BW (non-cumulative queries)'
        WHEN SCENARIO_NAME LIKE '/1BCAMDP/0BW%' THEN            '/1BCAMDP/0BW* - BW (AMDP)'
        WHEN SCENARIO_NAME LIKE '_SYS_CE_U1%'   THEN            '_SYS_CE_U1* - BW (HANA composite providers)'
        WHEN SCENARIO_NAME LIKE '_SYS_SS_CE%'   THEN            '_SYS_SS_CE* - SQLScript'
        WHEN SCENARIO_NAME LIKE 'system-local.bw.bw2hana%' THEN 'system-local.bw.bw2hana* - BW (external HANA views)'
        WHEN COMPONENT != 'UNKNOWN'             THEN            'OTHER -' || CHAR(32) || COMPONENT
        ELSE                                                    'OTHER'
      END SCENARIO_CLASS
    FROM
    ( SELECT
        HOST,
        PORT,
        SUBSTR(SCENARIO_NAME, 1, LOCATE(SCENARIO_NAME, ':', 1) - 1) SCHEMA_NAME,
        SUBSTR(SCENARIO_NAME, LOCATE(SCENARIO_NAME, ':', 1) + 1) SCENARIO_NAME,
        IS_PERSISTENT,
        CREATE_TIME,
        MEMORY_SIZE,
        COMPONENT
      FROM
        M_CE_CALCSCENARIOS_OVERVIEW
    )
  ) CS LEFT OUTER JOIN
  ( SELECT
      SCHEMA_NAME,
      SCENARIO_NAME,
      STRING_AGG(HINT_TYPE || '=' || HINT_VALUE, ', ' ORDER BY HINT_TYPE, HINT_VALUE) SCENARIO_HINTS
    FROM
      M_CE_CALCSCENARIO_HINTS
    GROUP BY
      SCHEMA_NAME, 
      SCENARIO_NAME
  ) CH ON
    CH.SCHEMA_NAME = CS.SCHEMA_NAME AND
    CH.SCENARIO_NAME = CS.SCENARIO_NAME
  WHERE
    S.HOST LIKE BI.HOST AND
    TO_VARCHAR(S.PORT) LIKE BI.PORT AND
    S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
    CS.HOST = S.HOST AND
    CS.PORT = S.PORT AND
    CS.COMPONENT LIKE BI.COMPONENT AND
    CS.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    CS.SCENARIO_NAME LIKE BI.SCENARIO_NAME AND
    CS.SCENARIO_CLASS LIKE BI.SCENARIO_CLASS AND
    IFNULL(CH.SCENARIO_HINTS, '') LIKE BI.SCENARIO_HINTS AND
    ( BI.ONLY_SCENARIOS_WITH_HINTS = ' ' OR CH.SCENARIO_HINTS IS NOT NULL ) AND
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(CS.CREATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE CS.CREATE_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    ( BI.ONLY_PERSISTENT_SCENARIOS = ' ' OR CS.IS_PERSISTENT = 'TRUE' )
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(CS.CREATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE CS.CREATE_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(CS.CREATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE CS.CREATE_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST') != 0       THEN CS.HOST                  ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT') != 0       THEN TO_VARCHAR(CS.PORT)      ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE') != 0    THEN S.SERVICE_NAME           ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME)     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COMPONENT') != 0  THEN CS.COMPONENT             ELSE MAP(BI.COMPONENT, '%', 'any', BI.COMPONENT)           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA') != 0     THEN CS.SCHEMA_NAME           ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)       END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCENARIO') != 0   THEN CS.SCENARIO_NAME         ELSE MAP(BI.SCENARIO_NAME, '%', 'any', BI.SCENARIO_NAME)   END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CLASS') != 0      THEN CS.SCENARIO_CLASS        ELSE MAP(BI.SCENARIO_CLASS, '%', 'any', BI.SCENARIO_CLASS) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HINTS') != 0      THEN CH.SCENARIO_HINTS        ELSE MAP(BI.SCENARIO_HINTS, '%', 'any', BI.SCENARIO_HINTS) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PERSISTENT') != 0 THEN CS.IS_PERSISTENT         ELSE MAP(BI.ONLY_PERSISTENT_SCENARIOS, 'X', 'TRUE', 'any') END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'TIME', CREATION_TIME) DESC,
  MAP(ORDER_BY, 'SIZE', SIZE_MB, 'COUNT', SCENARIOS) DESC,
  MAP(ORDER_BY, 'NAME', SCENARIO_NAME) 
  