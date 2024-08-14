SELECT

/* 

[NAME]

- HANA_BW_DSOOperations_2.00.000+

[DESCRIPTION]

- BW DSO operations

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_DSO_OPERATIONS available starting with SAP HANA 2.00.000
- Several packages may be processed in parallel (AVG_PACKAGES), so absolute runtime (TOTAL_S) may be smaller 
  than the sum of individual processing times.

[VALID FOR]

- Revisions:              >= 2.00.000

[SQL COMMAND VERSION]

- 2020/01/02:  1.0 (initial version)
- 2023/03/02:  1.1 (AVG_PACKAGES included)

[INVOLVED TABLES]

- M_DSO_OPERATIONS

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

- OPERATION

  DSO operation

  'ACTIVATION'    --> DSO activations (DSO_ACTIVATE_PERSISTED)
  'ROLLBACK'      --> DSO rollbacks (DSO_ROLLBACK_PERSISTED)
  '%'             --> No restriction related to DSO operation

- USAGE_MODE

  DSO usage mode

  'ODSO'          --> DSO usage mode ODSO
  '%'             --> No restriction related to DSO usage mode

- ACTIVATION_ID

  DSO activation ID

  31463029        --> DSO activation ID 31463029
  -1              --> No restriction related to DSO activation ID

- ERROR_CODE

  DSO error code

  10              --> Error code 10
  -1              --> No restriction related to DSO error code

- ERROR_MESSAGE

  DSO error message

  '%temporary%'   --> Error messages containing 'temporary'
  '%'             --> No restriction related to DSO error message

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

  Sort order (available values are provided in comment)

  'COUNT'         --> Sorting by number of operations
  'DURATION'      --> Sorting by duration of operations

[OUTPUT PARAMETERS]

- START_TIME:    Start time
- COUNT:         Number of operations
- TOTAL_S:       Total elapsed time (s)
- P_PROC_S:      Package processing time (s)
- P_INB_S:       Package inbound queue read time (s)
- P_AD_R_S:      Package active data read time (s)
- P_CALC_S:      Package calculation time (s)  
- CL_INS_S:      Change log insert time (s)
- AD_INS_S:      Active data insert time (s)
- AD_UPD_S:      Active data update time (s)
- AD_DEL_S:      Active data delete time (s)
- TABLE_NAME:    Target table name
- OPERATION:     DSO operation (ACTIVATE, ROLLBACK)
- USAGE_MODE:    DSO usage mode
- ERROR_DETAILS: Error code and message
- AVG_SRC_ROWS:  Average number of source rows 
- AVG_S:         Average elapsed time (s)
- AVG_PACKAGES:  Average number of packages
- SCHEMA_NAME:   Target schema name
- ACTIVATION_ID: DSO activation ID
- HOST:          Host
- PORT:          Port

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|START_TIME         |TOTAL_S |P_PROC_S|P_INB_S|P_AD_R_S|P_CALC_S|CL_INS_S|AD_INS_S|AD_UPD_S|AD_DEL_S|TABLE_NAME      |OPERATION |USAGE_MODE|ERROR_DETAILS|AVG_SRC_ROWS|AVG_S  |SCHEMA_NAME|ACTIVATION_ID          |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2020/01/02 13:51:16|     343|    3186|    147|     802|      90|     169|    1865|       0|       0|/BIC/AZ4M3SS0300|ACTIVATION|ODSO      |0 (No error) |    19736504|    343|SAPRBW     |31462931               |
|2020/01/02 13:45:37|     147|    1280|     65|     364|      91|     121|       0|       0|     451|/BIC/AZ4M3SS0300|ACTIVATION|ODSO      |0 (No error) |    19735255|    147|SAPRBW     |31462880               |
|2020/01/02 14:01:42|      87|     801|     36|     191|      47|      64|     401|       0|       0|/BIC/AZ4M3SS0100|ACTIVATION|ODSO      |0 (No error) |     9627281|     87|SAPRBW     |31462984               |
|2020/01/02 13:57:25|      82|     711|     36|     172|      59|      71|       0|       0|     240|/BIC/AZ4M3SS0100|ACTIVATION|ODSO      |0 (No error) |     9627281|     82|SAPRBW     |31462972               |
|2020/01/02 14:30:40|      30|     246|     56|      67|      65|       0|       0|       0|       0|/BIC/AZ4S1VOI00 |ACTIVATION|ODSO      |0 (No error) |    11159711|     30|SAPRBW     |31463353               |
|2020/01/02 14:02:12|      22|     197|     17|     108|      36|       0|       0|       0|       0|/BIC/AZ42SCL0300|ACTIVATION|ODSO      |0 (No error) |     5869136|     22|SAPRBW     |31463029               |
|2020/01/02 14:23:48|      13|      12|      0|       3|       1|       1|       2|       0|       0|/BIC/AZFIGLO0200|ACTIVATION|ODSO      |0 (No error) |      294866|     13|SAPRBW     |31463285               |
|2020/01/02 14:37:34|      12|      39|      3|      10|       2|       3|       0|       0|       8|/BIC/AZ5EDRETAG2|ACTIVATION|ADSO      |0 (No error) |      354646|     12|SAPRBW     |20200102143702000138000|
|2020/01/02 14:38:18|      11|      35|      2|       6|       1|       2|      18|       0|       0|/BIC/AZ5EDRETAG2|ACTIVATION|ADSO      |0 (No error) |      355169|     11|SAPRBW     |20200102143705000012000|
|2020/01/02 13:33:30|       9|      43|      4|       9|       4|      16|       0|       4|       0|/BIC/AZ4LEPE0500|ACTIVATION|ODSO      |0 (No error) |      613991|      9|SAPRBW     |31462786               |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  START_TIME,
  LPAD(OPERATIONS, 5) COUNT,
  LPAD(TOTAL_S, 7) TOTAL_S,
  LPAD(TO_DECIMAL(P_PROC_S, 10, 0), 8) P_PROC_S,
  LPAD(TO_DECIMAL(P_INB_S, 10, 0), 7) P_INB_S,
  LPAD(TO_DECIMAL(P_AD_R_S, 10, 0), 8) P_AD_R_S,
  LPAD(TO_DECIMAL(P_CALC_S, 10, 0), 8) P_CALC_S,
  LPAD(TO_DECIMAL(CL_INS_S, 10, 0), 8) CL_INS_S,
  LPAD(TO_DECIMAL(AD_INS_S, 10, 0), 8) AD_INS_S,
  LPAD(TO_DECIMAL(AD_UPD_S, 10, 0), 8) AD_UPD_S,
  LPAD(TO_DECIMAL(AD_DEL_S, 10, 0), 8) AD_DEL_S,
  TABLE_NAME,
  OPERATION,
  USAGE_MODE,
  ERROR_DETAILS,
  LPAD(TO_DECIMAL(AVG_SRC_ROWS, 12, 0), 12) AVG_SRC_ROWS,
  LPAD(TO_DECIMAL(AVG_S, 10, 0), 7) AVG_S,
  LPAD(TO_DECIMAL(AVG_PACKAGES, 10, 0), 12) AVG_PACKAGES,
  SCHEMA_NAME,
  ACTIVATION_ID,
  HOST,
  LPAD(PORT, 5) PORT
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(D.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE D.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(D.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE D.START_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END START_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')           != 0 THEN D.HOST                       ELSE MAP(BI.HOST,          '%', 'any', BI.HOST)                      END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')           != 0 THEN TO_VARCHAR(D.PORT)           ELSE MAP(BI.PORT,          '%', 'any', BI.PORT)                      END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')         != 0 THEN D.TARGET_SCHEMA_NAME         ELSE MAP(BI.SCHEMA_NAME,   '%', 'any', BI.SCHEMA_NAME)               END SCHEMA_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')          != 0 THEN D.TARGET_TABLE_NAME          ELSE MAP(BI.TABLE_NAME,    '%', 'any', BI.TABLE_NAME)                END TABLE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'OPERATION')      != 0 THEN D.OPERATION                  ELSE MAP(BI.OPERATION,     '%', 'any', BI.OPERATION)                 END OPERATION,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'USAGE_MODE')     != 0 THEN D.USAGE_MODE                 ELSE MAP(BI.USAGE_MODE,    '%', 'any', BI.USAGE_MODE)                END USAGE_MODE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ACTIVATION_IDS') != 0 THEN TO_VARCHAR(D.ACTIVATION_IDS) ELSE MAP(BI.ACTIVATION_ID,  -1, 'any', TO_VARCHAR(BI.ACTIVATION_ID)) END ACTIVATION_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ERROR')          != 0 THEN TO_VARCHAR(D.ERROR_CODE) || MAP(D.ERROR_MESSAGE, '', '', NULL, '', CHAR(32) || '(' || D.ERROR_MESSAGE || ')')                                                                                                                          ELSE 'any'                                                           END ERROR_DETAILS,
    COUNT(*) OPERATIONS,
    SUM(SECONDS_BETWEEN(D.START_TIME, D.END_TIME)) TOTAL_S,
    AVG(SECONDS_BETWEEN(D.START_TIME, D.END_TIME)) AVG_S,
    SUM(D.PACKAGE_PROCESSING_TIME / 1000 / 1000) P_PROC_S,
    SUM(D.PACKAGE_INBOUND_QUEUE_READ_TIME / 1000 / 1000) P_INB_S,
    SUM(D.PACKAGE_ACTIVE_DATA_READ_TIME / 1000 / 1000) P_AD_R_S,
    SUM(D.PACKAGE_CALCULATION_TIME / 1000 / 1000) P_CALC_S,
    SUM(D.CHANGE_LOG_INSERT_TIME / 1000 / 1000) CL_INS_S,
    SUM(D.ACTIVE_DATA_INSERT_TIME / 1000 / 1000) AD_INS_S,
    SUM(D.ACTIVE_DATA_UPDATE_TIME / 1000 / 1000) AD_UPD_S,
    SUM(D.ACTIVE_DATA_DELETE_TIME / 1000 / 1000) AD_DEL_S,
    AVG(D.SOURCE_RECORD_COUNT) AVG_SRC_ROWS,
    AVG(D.PACKAGE_COUNT) AVG_PACKAGES,
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
      HOST,
      PORT,
      TIMEZONE,
      SCHEMA_NAME,
      TABLE_NAME,
      OPERATION,
      USAGE_MODE,
      ACTIVATION_ID,
      ERROR_CODE,
      ERROR_MESSAGE,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS',
        'HOUR',        'YYYY/MM/DD HH24',
        'DAY',         'YYYY/MM/DD (DY)',
        'HOUR_OF_DAY', 'HH24',
        TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
      ORDER_BY
    FROM
    ( SELECT          /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        'SERVER' TIMEZONE,                              /* SERVER, UTC */
        '%' HOST,
        '%' PORT,
        '%' SCHEMA_NAME,
        '%' TABLE_NAME,
        '%' OPERATION,
        '%' USAGE_MODE,
         -1 ACTIVATION_ID,
         -1 ERROR_CODE,
        '%' ERROR_MESSAGE,
        'NONE' AGGREGATE_BY,         /* HOST, PORT, TIME, SCHEMA, TABLE, OPERATION, USAGE_MODE, ERROR, ACTIVATION_ID or comma separated combinations, NONE for no aggregation */
        'NONE' TIME_AGGREGATE_BY,     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'DURATION' ORDER_BY            /* TIME, COUNT, DURATION, NAME */
      FROM
        DUMMY
    ) 
  ) BI,
    M_DSO_OPERATIONS D
  WHERE
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(D.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE D.START_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    D.HOST LIKE BI.HOST AND
    TO_VARCHAR(D.PORT) LIKE BI.PORT AND
    D.TARGET_SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    D.TARGET_TABLE_NAME LIKE BI.TABLE_NAME AND
    D.OPERATION LIKE BI.OPERATION AND
    D.USAGE_MODE LIKE BI.USAGE_MODE AND
    ( BI.ACTIVATION_ID = -1 OR D.ACTIVATION_IDS = BI.ACTIVATION_ID ) AND
    ( BI.ERROR_CODE = -1 OR D.ERROR_CODE = BI.ERROR_CODE ) AND
    D.ERROR_MESSAGE LIKE BI.ERROR_MESSAGE
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(D.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE D.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(D.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE D.START_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')           != 0 THEN D.HOST                       ELSE MAP(BI.HOST,          '%', 'any', BI.HOST)                      END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')           != 0 THEN TO_VARCHAR(D.PORT)           ELSE MAP(BI.PORT,          '%', 'any', BI.PORT)                      END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')         != 0 THEN D.TARGET_SCHEMA_NAME         ELSE MAP(BI.SCHEMA_NAME,   '%', 'any', BI.SCHEMA_NAME)               END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')          != 0 THEN D.TARGET_TABLE_NAME          ELSE MAP(BI.TABLE_NAME,    '%', 'any', BI.TABLE_NAME)                END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'OPERATION')      != 0 THEN D.OPERATION                  ELSE MAP(BI.OPERATION,     '%', 'any', BI.OPERATION)                 END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'USAGE_MODE')     != 0 THEN D.USAGE_MODE                 ELSE MAP(BI.USAGE_MODE,    '%', 'any', BI.USAGE_MODE)                END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ACTIVATION_IDS') != 0 THEN TO_VARCHAR(D.ACTIVATION_IDS) ELSE MAP(BI.ACTIVATION_ID,  -1, 'any', TO_VARCHAR(BI.ACTIVATION_ID)) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ERROR')          != 0 THEN TO_VARCHAR(D.ERROR_CODE) || MAP(D.ERROR_MESSAGE, '', '', NULL, '', CHAR(32) || '(' || D.ERROR_MESSAGE || ')')
                                                                                                                          ELSE 'any'                                                           END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'TIME', START_TIME) DESC,
  MAP(ORDER_BY, 'DURATION', TOTAL_S) DESC,
  MAP(ORDER_BY, 'COUNT', OPERATIONS) DESC,
  HOST,
  PORT,
  SCHEMA_NAME,
  TABLE_NAME

