SELECT

/* 

[NAME]

- HANA_ABAP_UpdateErrors

[DESCRIPTION]

- Overview of current SAP ABAP update requests in error state

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Tables VBHDR / VBERROR only available in SAP ABAP environments
- You have to be connected to the SAP<sid> schema otherwise the following error is issued:

  [259]: invalid table name: Could not find table/view VBHDR / VBERROR in schema

- If access to ABAP objects is possible but you cannot log on as ABAP user, you can switch the default schema before executing the command:

  SET SCHEMA SAP<sid>

[VALID FOR]

- Revisions:              all
- Client application:     ABAP

[SQL COMMAND VERSION]

- 2017/02/16:  1.0 (initial version)
- 2018/12/04:  1.1 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- VBERROR
- VBHDR

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

- APP_SERVER

  SAP application server

  'sapabap01'      --> Restrict output to application server sapabap01
  '%'              --> No restriction related to SAP application server

- MANDT

  SAP ABAP client

  '100'            --> Only show work processes related to client 100
  '%'              --> No restriction related to SAP ABAP client

- WP_TYPE

  SAP ABAP work process type (e.g. DIA, ENQ, BTC, UPD)

  'DIA'             --> Restrict output to dialog work processes
  '%'               --> No restriction related to work process type

- WP_ID

  SAP ABAP work process ID

  23                --> Show information for work process 23
  -1                --> No restriction related to work process ID

- CPID

  Client process ID (i.e. process ID of SAP ABAP work process)

  1234              --> Show information for work process with client process ID 1234
  -1                --> No restriction related to client process ID

- ACTION

  SAP ABAP work process action

  'SELECT'          --> Restrict output to SELECT operations
  '%'               --> No restriction related to work process action

- TABLE_NAME

  Accessed table name

  'MARA'            --> Restrict output to accesses to table MARA
  '%'               --> No restriction related to table name

- STATE

  SAP ABAP work process state

  'SYNC RFC'        --> Restrict output to work processes in state SYNC RFC
  '%'               --> No process state restriction

- WAITING_FOR

  Wait situation

  'CMSEND%'         --> Display only work processes waiting for CMSEND
  '%'               --> No restriction related to wait situation

- APP_USER

  Application user

  'SAPSYS'        --> Application user 'SAPSYS'
  '%'             --> No application user restriction

- APP_SOURCE

  Application source

  'SAPL2'         --> Application source 'SAPL2:437'
  'SAPMSSY2%'     --> Application sources starting with SAPMSSY2
  '%'             --> No application source restriction

- REQUEST_TYPE

  Type of root request

  'RFC%'          --> Restrict results to RFC requests
  '%'             --> No restriction related to request type

- BATCH_JOB

  Batch job name

  'MYBATCH1'      --> Only show information for batch job MYBATCH1
  '%'             --> No restriction related to batch job

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
  
[OUTPUT PARAMETERS]

- START_TIME:   Start time of considered time interval
- SAMPLES:      Number of samples
- APP_SERVER:   Application server name
- MANDT:        SAP ABAP client
- TYP:          Work process type (e.g. DIA, BTC, UPD)
- WP_ID:        Work process ID
- CPID:         Client process ID (i.e. OS PID of work process)
- DB_ROWS:      Database rows retrieved
- DB_TIME_MS:   Database time spent (ms)
- ACTION:       Action (e.g. SELECT, ENQUEUE, ROLL IN, INSERT, UPDATE)
- TABLE_NAME:   Accessed table name (only one table displayed in case of joins)
- STATE:        Work process state
- APP_USER:     Application user
- APP_SOURCE:   Application source (main ABAP module -> current ABAP module)
- REQUEST_TYPE: Root request type
- BATCH_JOB:    Batch job name
- WAITING_FOR:  Wait reason

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|START_TIME         |APP_SERVER     |MANDT|TYP|WP_ID|CPID  |DB_ROWS  |DB_TIME_S |ACTION   |TABLE_NAME      |STATE    |APP_USER    |APP_SOURCE                                                  |BATCH_JOB                       |WAITING_FOR                                        |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2017/02/15 12:01:00|saphana0_E9A_02|  103|DIA|   33| 20032|        0|      0.00|SELECT   |LQUA            |         |RUPUZIDAEK  |SAPML03T -> SAPLL03A                                        |                                |                                                   |
|2017/02/15 12:01:00|saphana0_E9A_02|  103|DIA|   34| 20033|     1227|      0.27|         |                |         |JOBRUN      |SAPMSSY1 -> SAPLVEDA                                        |                                |                                                   |
|2017/02/15 12:01:00|saphana0_E9A_02|  103|DIA|   66| 20066|        0|      0.00|SELECT   |COST            |         |PUZUTTIOBA  |/GLB/RGTPTR_PROCESS_ORDER_VAR -> SAPLKARS                   |                                |                                                   |
|2017/02/15 12:01:00|saphana0_E9A_02|  103|DIA|   77| 28920|      361|      0.51|         |                |SYNC RFC |BGVASILEVA  |RVV50R10C -> SAPLATPC                                       |                                |CMSEND(SAP) / 13410508 / SYNC_CPIC / 141.122.207.43|
|2017/02/15 12:01:00|saphana0_E9A_02|  103|BTC|  113|  1876|      833|      0.88|SELECT   |VBFA            |         |JOBRUN      |/EUR/ODECSR_COD_PROCESS -> SAPLV05C                         |RU_R3E_CS_R_0065295_SDBLRU3AIMSP|                                                   |
|2017/02/15 12:01:00|saphana0_E9A_02|  103|BTC|  117| 22492|      283|      0.18|         |                |         |JOBRUN      |SAPMV45A -> SAPLV69A                                        |IT_R3E_CS_R_0060246_ORDERS_E    |                                                   |
|2017/02/15 12:01:00|saphana0_E9A_02|  103|BTC|  119| 11503|        0|      0.00|         |                |ABAP WAIT|NBNRA       |/GLB/RGTFCR_INVOICE_JOB                                     |5200637291201720170215120040    |CMRCV / 77113581 / SYNC_CPIC                       |
|2017/02/15 12:01:00|saphana1_E9A_02|  103|DIA|    8|  5335|      384|      0.57|SELECT   |LIKP            |         |BGMIHAYLAL1 |SAPMSSY1 -> SAPLV61B                                        |                                |                                                   |
|2017/02/15 12:01:00|saphana1_E9A_02|  103|DIA|   22| 30973|      481|      0.64|SELECT   |/GLB/RGTNOSHPORD|         |BGMIHAYLAL1 |SAPMSSY1 -> SAPLV61B                                        |                                |                                                   |
|2017/02/15 12:01:00|saphana1_E9A_02|  103|DIA|   37| 30642|        0|      0.00|SELECT   |TRFCQOUT        |         |PUMAIZNEBA  |SAPMSSY1 -> SAPLORFC                                        |                                |                                                   |
|2017/02/15 12:01:00|saphana1_E9A_02|  103|DIA|   51|  5380|        0|      0.00|         |                |         |OSS_481396  |SAPMSSY1 -> CL_SERVER_INFO================CP                |                                |                                                   |
|2017/02/15 12:01:00|saphana1_E9A_02|  103|DIA|   60| 30643|     1197|      0.92|SELECT   |EKBE            |         |DESERWEFL   |RM06EL00 -> SAPLME07                                        |                                |                                                   |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  START_TIME,
  LPAD(NUM, 7) COUNT,
  APP_SERVER,
  LPAD(MANDT, 5) MANDT,
  APP_USER,
  REPORT_NAME,
  TRANSACTION_NAME
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), TO_TIMESTAMP(H.VBDATE, 'YYYYMMDDHH24MISS')) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(TO_TIMESTAMP(H.VBDATE, 'YYYYMMDDHH24MISS'), BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END START_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'MANDT')       != 0 THEN H.VBMANDT  ELSE MAP(BI.MANDT,            '%', 'any', BI.MANDT)            END MANDT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'APP_USER')    != 0 THEN H.VBUSR    ELSE MAP(BI.APP_USER,         '%', 'any', BI.APP_USER)         END APP_USER,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVER')      != 0 THEN H.VBNAME   ELSE MAP(BI.APP_SERVER,       '%', 'any', BI.APP_SERVER)       END APP_SERVER,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'REPORT')      != 0 THEN H.VBREPORT ELSE MAP(BI.REPORT_NAME,      '%', 'any', BI.REPORT_NAME)      END REPORT_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TRANSACTION') != 0 THEN H.VBTCODE  ELSE MAP(BI.TRANSACTION_NAME, '%', 'any', BI.TRANSACTION_NAME) END TRANSACTION_NAME,
    COUNT(*) NUM,
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
      MANDT,
      APP_USER,
      REPORT_NAME,
      TRANSACTION_NAME,
      APP_SERVER,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS',
        'HOUR',        'YYYY/MM/DD HH24',
        'DAY',         'YYYY/MM/DD (DY)',
        'HOUR_OF_DAY', 'HH24',
        TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
      ORDER_BY
    FROM
    ( SELECT                          /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        '%' MANDT,
        '%' APP_USER,
        '%' REPORT_NAME,
        '%' TRANSACTION_NAME,
        '%' APP_SERVER,
        'TIME' AGGREGATE_BY,         /* TIME, SERVER, MANDT, APP_USER, REPORT, TRANSACTION or comma separated combinations, NONE for no aggregation */
        'DAY' TIME_AGGREGATE_BY,    /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'TIME' ORDER_BY              /* TIME, COUNT */
      FROM
        DUMMY
    )
  ) BI,
    VBHDR H,
    VBERROR E
  WHERE
    TO_TIMESTAMP(H.VBDATE, 'YYYYMMDDHH24MISS') BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    H.VBMANDT LIKE BI.MANDT AND
    H.VBUSR LIKE BI.APP_USER AND
    H.VBREPORT LIKE BI.REPORT_NAME AND
    H.VBTCODE LIKE BI.TRANSACTION_NAME AND
    H.VBNAME LIKE BI.APP_SERVER AND
    H.VBKEY = E.VBKEY
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), TO_TIMESTAMP(H.VBDATE, 'YYYYMMDDHH24MISS')) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(TO_TIMESTAMP(H.VBDATE, 'YYYYMMDDHH24MISS'), BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'MANDT')       != 0 THEN H.VBMANDT  ELSE MAP(BI.MANDT,            '%', 'any', BI.MANDT)            END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'APP_USER')    != 0 THEN H.VBUSR    ELSE MAP(BI.APP_USER,         '%', 'any', BI.APP_USER)         END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVER')      != 0 THEN H.VBNAME   ELSE MAP(BI.APP_SERVER,       '%', 'any', BI.APP_SERVER)       END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'REPORT')      != 0 THEN H.VBREPORT ELSE MAP(BI.REPORT_NAME,      '%', 'any', BI.REPORT_NAME)      END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TRANSACTION') != 0 THEN H.VBTCODE  ELSE MAP(BI.TRANSACTION_NAME, '%', 'any', BI.TRANSACTION_NAME) END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'TIME', START_TIME) DESC,
  MAP(ORDER_BY, 'COUNT', NUM) DESC