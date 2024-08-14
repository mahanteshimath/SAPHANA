SELECT
/* 

[NAME]

- HANA_Redistribution_PartitionOperations_2.00.060+

[DESCRIPTION]

- Overview of executed table (re-)partitioning operations

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_TABLE_PARTITION_OPERATIONS available as of SAP HANA 2.0 SPS 06
- Only populated if table partition operation trace is activated (activated per default, SAP Note 2119087)

[VALID FOR]

- Revisions:              >= 2.00.060

[SQL COMMAND VERSION]

- 2023/02/25:  1.0 (initial version)

[INVOLVED TABLES]

- M_TABLE_PARTITION_OPERATIONS

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

- OPERATION_TYPE

  Partition operation type

  'ADD PARTITION' --> Operation type "ADD PARTITION"
  '%'             --> No restriction related to operation type

- IS_ONLINE

  Online / offline partition operation

  'TRUE'          --> Online partition operations
  'FALSE'         --> Offline partition operations
  '%'             --> No restriction related to online / offline

- STATEMENT_HASH      
 
  Hash of SQL statement to be analyzed

  '2e960d7535bf4134e2bd26b9d80bd4fa' --> SQL statement with hash '2e960d7535bf4134e2bd26b9d80bd4fa'
  '%'                                --> No statement hash restriction 

- APP_USER

  Application user

  'SAPSYS'        --> Application user 'SAPSYS'
  '%'             --> No application user restriction

- DB_USER

  Database user

  'SYSTEM'        --> Database user 'SYSTEM'
  '%'             --> No database user restriction

- SQL_PATTERN

  Pattern for SQL text (case insensitive)

  'INSERT%'       --> SQL statements starting with INSERT
  '%DBTABLOG%'    --> SQL statements containing DBTABLOG
  '%'             --> All SQL statements

- APP_SOURCE

  Application source

  'SAPL2:437'     --> Application source 'SAPL2:437'
  'SAPMSSY2%'     --> Application sources starting with SAPMSSY2
  '%'             --> No application source restriction

- APP_NAME

  Name of application

  'ABAP:C11'      --> Application name 'ABAP:C11'
  '%'             --> No application name restriction

- CLIENT_IP

  IP address of client

  '172.23.4.12'   --> IP address 172.23.4.12 
  '%'             --> No restriction related to IP address

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HASH'          --> Aggregation by statement hash
  'USER'          --> Aggregation by application user
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
  'DURATION'      --> Sorting by execution time

- RESULT_ROWS

  Number of records to be returned by the query

  100             --> Return a maximum number of 100 records
  -1              --> Return all records

[OUTPUT PARAMETERS]

- START_TIME:              Last start time of SQL statement
- SCHEMA_NAME:             Schema name
- TABLE_NAME:              Table name
- STATEMENT_HASH:          Hash value of SQL statement
- OPERATION_TYPE:          Partition operation type
- O:                       'X' in case of online operation, ' ' in case of offline operation
- EXECUTIONS:              Number of executions
- ELAPSED_MS:              Elapsed time (ms)
- ELA_PER_EXEC_MS:         Elapsed time per execution (ms)
- APP_SOURCE:              Application source
- APP_NAME:                Application name
- APP_USER:                Application user name
- DB_USER:                 Database user name
- CLIENT_IP:               IP address of client executing the request
- SQL_TEXT:                SQL statement text
- PARTITIONING_DEFINITION: Partition definition after statement execution

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|START_TIME         |SCHEMA_NAME|TABLE_NAME      |STATEMENT_HASH                  |OPERATION_TYPE       |O|ELAPSED_MS    |ELA_PER_EXEC_MS|APP_SOURCE                          |APP_NAME|APP_USER|DB_USER|SQL_TEXT                                                                               |PARTITION_DEFINITION                                                                                                                                                                                                                                          |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2023/02/25 15:21:10|SAPSR3     |/BIC/ACMDVBD021 |5f5164b6ac802b929fee234c7d069542|ENABLE DYNAMIC RANGE | |          6.74|           6.74|CL_SQL_STATEMENT==============CP:717|ABAP:C11|BIREMOTE|SAPSR3 |ALTER TABLE "SAPSR3"."/BIC/ACMDVBD021"    PARTITION OTHERS DYNAMIC THRESHOLD 0         |HASH ("AGR_NO","SITE","VKORG","VTWEG") PARTITIONS 1, RANGE ("REQTSN" AS INT) (PARTITION OTHERS DYNAMIC THRESHOLD 0)                                                                                                                                           |
|2023/02/25 15:20:48|SAPSR3     |/BIC/ABMMIMD7093|1e52af6353f1f6a74ec953cb1bab75a3|ENABLE DYNAMIC RANGE | |        230.60|         230.60|CL_SQL_STATEMENT==============CP:717|ABAP:C11|BIREMOTE|SAPSR3 |ALTER TABLE "SAPSR3"."/BIC/ABMMIMD7093"    PARTITION OTHERS DYNAMIC THRESHOLD 0        |HASH ("CALMONTH","BWCOUNTER","DOC_YEAR","FISCVARNT","MAT_DOC","MAT_ITEM","PROCESSKEY") PARTITIONS 6, RANGE ("REQTSN" AS INT) (PARTITION OTHERS DYNAMIC THRESHOLD 0)                                                                                           |
|2023/02/25 15:20:46|SAPSR3     |/BIC/ABMMIMD7013|ceb7e3a0658ff8ee4bc1ff028a38e8bd|ENABLE DYNAMIC RANGE | |         15.53|          15.53|CL_SQL_STATEMENT==============CP:717|ABAP:C11|BIREMOTE|SAPSR3 |ALTER TABLE "SAPSR3"."/BIC/ABMMIMD7013"    PARTITION OTHERS DYNAMIC THRESHOLD 0        |HASH ("CALMONTH","BWCOUNTER","DOC_YEAR","FISCVARNT","MAT_DOC","MAT_ITEM","PROCESSKEY") PARTITIONS 1, RANGE ("REQTSN" AS INT) (PARTITION OTHERS DYNAMIC THRESHOLD 0)                                                                                           |
|2023/02/25 15:20:35|SAPSR3     |/BIC/ACMDVBD041 |9c18ec8b3de984189fd0f62030ccaae3|DISABLE DYNAMIC RANGE| |          6.18|           6.18|CL_SQL_STATEMENT==============CP:717|ABAP:C11|BIREMOTE|SAPSR3 |ALTER TABLE "SAPSR3"."/BIC/ACMDVBD041"    PARTITION OTHERS NO DYNAMIC                  |HASH ("AGR_NO","SITE") PARTITIONS 1, RANGE ("REQTSN") (PARTITION OTHERS)                                                                                                                                                                                      |
|2023/02/25 15:20:35|SAPSR3     |/BIC/ACMDVBD021 |b62f768709da771e4e6d4e251732eeea|DISABLE DYNAMIC RANGE| |          7.02|           7.02|CL_SQL_STATEMENT==============CP:717|ABAP:C11|BIREMOTE|SAPSR3 |ALTER TABLE "SAPSR3"."/BIC/ACMDVBD021"    PARTITION OTHERS NO DYNAMIC                  |HASH ("AGR_NO","SITE","VKORG","VTWEG") PARTITIONS 1, RANGE ("REQTSN") (PARTITION OTHERS)                                                                                                                                                                      |
|2023/02/25 15:20:35|SAPSR3     |/BIC/ACMDVBD031 |313c03bd60ac568fcfb58868c7d97bd4|DISABLE DYNAMIC RANGE| |          6.66|           6.66|CL_SQL_STATEMENT==============CP:717|ABAP:C11|BIREMOTE|SAPSR3 |ALTER TABLE "SAPSR3"."/BIC/ACMDVBD031"    PARTITION OTHERS NO DYNAMIC                  |HASH ("AGR_NO","ITEM_NO","OFFER_ID","MATNR","PUR_SETTYP","PUR_GCOMID","SAL_GCOMID","FIX_GCOMDS","PT_SUB_REF_ID","MEBME") PARTITIONS 1, RANGE ("REQTSN") (PARTITION OTHERS)                                                                                    |
|2023/02/25 15:19:39|SAPSR3     |/BIC/BD000000784|b6e130a095715d161d7f1ebe65489509|DROP EMPTY PARTITIONS| |        119.57|         119.57|                                    |        |        |SYS    |ALTER TABLE "SAPSR3"."/BIC/BD000000784" DROP EMPTY PARTITIONS                          |HASH ("DATAPAKID") PARTITIONS 1, RANGE ("REQTSN" AS INT) (PARTITION '00000000000000000000000' <= VALUES < '20210704020021000176001', PARTITION OTHERS DYNAMIC THRESHOLD 0)                                                                                    |
|2023/02/25 15:16:59|SAPSR3     |/BIC/ACHDSO_D011|78cf14c380fe37a49ad218ad88e44db9|ENABLE DYNAMIC RANGE | |          7.37|           7.37|CL_SQL_STATEMENT==============CP:717|ABAP:C11|BIREMOTE|SAPSR3 |ALTER TABLE "SAPSR3"."/BIC/ACHDSO_D011"    PARTITION OTHERS DYNAMIC THRESHOLD 0        |HASH ("DISCSEQNUMBER","DISCOUNTTYPE","DISCOUNTREASON","OFFERID","PROMOTIONID","EAN","ARTICLE","ITEMTYPE","SALESUNIT","SEQ_NUM","VISIBLEID","VKORG","VTWEG","STORE","CUSTOMERID","EXT_ORDERID") PARTITIONS 1, RANGE ("REQTSN" AS INT) (PARTITION OTHERS DYNAMI |
|2023/02/25 15:16:59|SAPSR3     |/BIC/ABMMIMD7133|d60c98e8266c23090b11cb265fb292ca|ENABLE DYNAMIC RANGE | |         12.96|          12.96|CL_SQL_STATEMENT==============CP:717|ABAP:C11|BIREMOTE|SAPSR3 |ALTER TABLE "SAPSR3"."/BIC/ABMMIMD7133"    PARTITION OTHERS DYNAMIC THRESHOLD 100000000|HASH ("CALMONTH","BWCOUNTER","DOC_YEAR","FISCVARNT","MAT_DOC","MAT_ITEM","PROCESSKEY") PARTITIONS 1, RANGE ("REQTSN" AS INT) (PARTITION OTHERS DYNAMIC THRESHOLD 100000000)                                                                                   |
|2023/02/25 15:16:57|SAPSR3     |/BIC/ABMMIMD7133|3da828781fd46bfc432db109a0bdb18b|DISABLE DYNAMIC RANGE| |         12.78|          12.78|CL_SQL_STATEMENT==============CP:717|ABAP:C11|BIREMOTE|SAPSR3 |ALTER TABLE "SAPSR3"."/BIC/ABMMIMD7133"    PARTITION OTHERS NO DYNAMIC                 |HASH ("CALMONTH","BWCOUNTER","DOC_YEAR","FISCVARNT","MAT_DOC","MAT_ITEM","PROCESSKEY") PARTITIONS 1, RANGE ("REQTSN") (PARTITION OTHERS)                                                                                                                      |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  START_TIME,
  SCHEMA_NAME,
  TABLE_NAME,
  STATEMENT_HASH,
  OPERATION_TYPE,
  MAP(IS_ONLINE, 'TRUE', 'X', 'FALSE', ' ', IS_ONLINE) O,
  LPAD(EXECUTIONS, 10) EXECUTIONS,
  LPAD(TO_DECIMAL(ELAPSED_MS, 12, 2), 14) ELAPSED_MS,
  LPAD(TO_DECIMAL(ELA_PER_EXEC_MS, 12, 2), 15) ELA_PER_EXEC_MS,
  APP_SOURCE,
  APP_NAME,
  APP_USER,
  DB_USER,
  CLIENT_IP,
  SQL_TEXT,
  PARTITION_DEFINITION
FROM
( SELECT
    SCHEMA_NAME,
    TABLE_NAME,
    STATEMENT_HASH,
    OPERATION_TYPE,
    IS_ONLINE,
    EXECUTIONS,
    ELAPSED_MS,
    ELA_PER_EXEC_MS,
    START_TIME,
    APP_SOURCE,
    APP_NAME,
    APP_USER,
    DB_USER,
    CLIENT_IP,
    PARTITION_DEFINITION,
    SQL_TEXT,
    RESULT_ROWS,
    ROW_NUMBER () OVER (ORDER BY 
      MAP(ORDER_BY, 'TIME', START_TIME) DESC, 
      MAP(ORDER_BY, 'DURATION', ELAPSED_MS, 'EXECUTIONS', EXECUTIONS) DESC
    ) ROW_NUM
  FROM
  ( SELECT
      CASE 
        WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.START_TIME END, BI.TIME_AGGREGATE_BY)
          END
        ELSE 'any' 
      END START_TIME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')    != 0 THEN P.SCHEMA_NAME           ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)       END SCHEMA_NAME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')     != 0 THEN P.TABLE_NAME            ELSE MAP(BI.TABLE_NAME, '%', 'any', BI.TABLE_NAME)         END TABLE_NAME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'OP_TYPE')   != 0 THEN P.OPERATION_TYPE        ELSE MAP(BI.OPERATION_TYPE, '%', 'any', BI.OPERATION_TYPE) END OPERATION_TYPE,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'IS_ONLINE') != 0 THEN P.IS_ONLINE             ELSE MAP(BI.IS_ONLINE, '%', 'any', BI.IS_ONLINE)           END IS_ONLINE,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HASH')      != 0 THEN P.STATEMENT_HASH        ELSE MAP(BI.STATEMENT_HASH, '%', 'any', BI.STATEMENT_HASH) END STATEMENT_HASH,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'APP_USER')  != 0 THEN P.APPLICATION_USER_NAME ELSE MAP(BI.APP_USER, '%', 'any', BI.APP_USER)             END APP_USER,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DB_USER')   != 0 THEN P.USER_NAME             ELSE MAP(BI.DB_USER, '%', 'any', BI.DB_USER)               END DB_USER,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CLIENT_IP') != 0 THEN P.CLIENT_IP             ELSE MAP(BI.CLIENT_IP, '%', 'any', BI.CLIENT_IP)           END CLIENT_IP,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SOURCE')    != 0 THEN P.APPLICATION_SOURCE    ELSE MAP(BI.APP_SOURCE, '%', 'any', BI.APP_SOURCE)         END APP_SOURCE,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'APP_NAME')  != 0 THEN P.APPLICATION_NAME      ELSE MAP(BI.APP_NAME, '%', 'any', BI.APP_NAME)             END APP_NAME,
      COUNT(*) EXECUTIONS,
      SUM(P.DURATION) / 1000 ELAPSED_MS,
      SUM(P.DURATION) / COUNT(*) / 1000 ELA_PER_EXEC_MS,
      LTRIM(MAP(MIN(TO_VARCHAR(SUBSTR(P.STATEMENT_STRING, 1, 4000))), MAX(TO_VARCHAR(SUBSTR(P.STATEMENT_STRING, 1, 4000))), MIN(TO_VARCHAR(SUBSTR(P.STATEMENT_STRING, 1, 4000))), 'various')) SQL_TEXT,
      LTRIM(MAP(MIN(TO_VARCHAR(SUBSTR(P.PARTITION_DEFINITION, 1, 4000))), MAX(TO_VARCHAR(SUBSTR(P.PARTITION_DEFINITION, 1, 4000))), MIN(TO_VARCHAR(SUBSTR(P.PARTITION_DEFINITION, 1, 4000))), 'various')) PARTITION_DEFINITION,
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
        SCHEMA_NAME,
        TABLE_NAME,
        OPERATION_TYPE,
        IS_ONLINE,
        STATEMENT_HASH,
        APP_USER,
        DB_USER,
        SQL_PATTERN,
        APP_SOURCE,
        APP_NAME,
        CLIENT_IP,
        AGGREGATE_BY,
        ORDER_BY,
        RESULT_ROWS,
        MAP(TIME_AGGREGATE_BY,
          'NONE',        'YYYY/MM/DD HH24:MI:SS',
          'HOUR',        'YYYY/MM/DD HH24',
          'DAY',         'YYYY/MM/DD (DY)',
          'HOUR_OF_DAY', 'HH24',
          TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY
      FROM
      ( SELECT                                       /* Modification section */
          '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
          '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
          'SERVER' TIMEZONE,                              /* SERVER, UTC */
          '%' SCHEMA_NAME,
          '%' TABLE_NAME,
          '%' OPERATION_TYPE,
          '%' IS_ONLINE,
          '%' STATEMENT_HASH,
          '%' APP_USER,
          '%' DB_USER,
          '%' SQL_PATTERN,
          '%' APP_SOURCE,
          '%' APP_NAME,
          '%' CLIENT_IP,
          'NONE' AGGREGATE_BY,                         /* TIME, SCHEMA, TABLE, OP_TYPE, IS_ONLINE, HASH, APP_USER, DB_USER, SOURCE, APP_NAME, CLIENT_IP or comma separated combinations, NONE for no aggregation */
          'NONE' TIME_AGGREGATE_BY,                   /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
          'TIME' ORDER_BY,                             /* TIME, DURATION, EXECUTIONS */
          -1 RESULT_ROWS
        FROM
          DUMMY
      )
    ) BI INNER JOIN
      M_TABLE_PARTITION_OPERATIONS P ON
        CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.START_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
        P.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
        P.TABLE_NAME LIKE BI.TABLE_NAME AND
        P.OPERATION_TYPE LIKE BI.OPERATION_TYPE AND
        P.IS_ONLINE LIKE BI.IS_ONLINE AND
        P.STATEMENT_HASH LIKE BI.STATEMENT_HASH AND
        P.APPLICATION_USER_NAME LIKE BI.APP_USER AND
        P.USER_NAME LIKE BI.DB_USER AND
        IFNULL(P.APPLICATION_SOURCE, '') LIKE BI.APP_SOURCE AND
        IFNULL(P.APPLICATION_NAME, '') LIKE BI.APP_NAME AND
        TO_VARCHAR(P.CLIENT_IP) LIKE BI.CLIENT_IP AND
        UPPER(TO_VARCHAR(P.STATEMENT_STRING)) LIKE UPPER(BI.SQL_PATTERN)
    GROUP BY
      CASE 
        WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.START_TIME END, BI.TIME_AGGREGATE_BY)
          END
        ELSE 'any' 
      END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')    != 0 THEN P.SCHEMA_NAME           ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)       END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')     != 0 THEN P.TABLE_NAME            ELSE MAP(BI.TABLE_NAME, '%', 'any', BI.TABLE_NAME)         END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'OP_TYPE')   != 0 THEN P.OPERATION_TYPE        ELSE MAP(BI.OPERATION_TYPE, '%', 'any', BI.OPERATION_TYPE) END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'IS_ONLINE') != 0 THEN P.IS_ONLINE             ELSE MAP(BI.IS_ONLINE, '%', 'any', BI.IS_ONLINE)           END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HASH')      != 0 THEN P.STATEMENT_HASH        ELSE MAP(BI.STATEMENT_HASH, '%', 'any', BI.STATEMENT_HASH) END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'APP_USER')  != 0 THEN P.APPLICATION_USER_NAME ELSE MAP(BI.APP_USER, '%', 'any', BI.APP_USER)             END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DB_USER')   != 0 THEN P.USER_NAME             ELSE MAP(BI.DB_USER, '%', 'any', BI.DB_USER)               END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CLIENT_IP') != 0 THEN P.CLIENT_IP             ELSE MAP(BI.CLIENT_IP, '%', 'any', BI.CLIENT_IP)           END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SOURCE')    != 0 THEN P.APPLICATION_SOURCE    ELSE MAP(BI.APP_SOURCE, '%', 'any', BI.APP_SOURCE)         END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'APP_NAME')  != 0 THEN P.APPLICATION_NAME      ELSE MAP(BI.APP_NAME, '%', 'any', BI.APP_NAME)             END,
      BI.RESULT_ROWS,
      BI.ORDER_BY
  )
)
WHERE
  ( RESULT_ROWS = -1 OR ROW_NUM <= RESULT_ROWS )
ORDER BY
  ROW_NUM
