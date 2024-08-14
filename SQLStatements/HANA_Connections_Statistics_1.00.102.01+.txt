SELECT
/* 

[NAME]

- HANA_Connections_Statistics_1.00.102.01+

[DESCRIPTION]

- Connection information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Commit information only available as of Rev. 1.00.102.01
- Preparation time in M_CONNECTION_STATISTICS has unit nano seconds while other times have unit micro seconds (bug 238799)

[VALID FOR]

- Revisions:              >= 1.00.102.01

[SQL COMMAND VERSION]

- 2014/04/11:  1.0 (initial version)
- 2016/01/19:  1.1 (dedicated 1.00.102.01+ version)
- 2020/10/11:  1.2 (completely redesigned output format)
- 2022/04/14:  1.3 (DB_USER, CLIENT_HOST, AGGREGATION_TYPE, CONN_STATUS and CONN_TYPE included)

[INVOLVED TABLES]

- M_CONNECTIONS
- M_CONNECTION_STATISTICS

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

- CONN_ID

  Connection ID

  330655          --> Connection ID 330655
  -1              --> No connection ID restriction

- CONN_TYPE

  Connection type

  'Remote'        --> Connections with type Remote
  'History%'      --> History connections
  '%'             --> No restriction related to connection type

- CONN_STATUS

  Connection status

  'IDLE'          --> Connections with status IDLE
  '%'             --> No restriction related to connection status

- CLIENT_HOST

  Client host name

  'abaphost'      --> Connections originating from client host abaphost
  '%'             --> No restriction related to client host

- DB_USER

  Database user

  'SYSTEM'        --> Database user 'SYSTEM'
  '%'             --> No database user restriction 

- AGGREGATION_TYPE

  Type of aggregation (e.g. average, sum, maximum)

  'AVG'           --> Average value
  'SUM'           --> Total value
  'MAX'           --> Maximum value

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

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

  'CONN_ID'       --> Sorting by connection ID
  'COMMIT_COUNT'  --> Sorting by number of commits

[OUTPUT PARAMETERS]

- HOST:          Host name
- PORT:          Port
- AGG:           Aggregation type for key figures (AVG -> average values, MAX -> maximum values, SUM -> total values)
- START_TIME:    Connection start time
- CNT:           Connection count
- CONN_TIME_S:   Connection time (s)
- CONN_ID:       Connection ID
- CT:            Connection type (L -> local, R -> remote, HL -> history local, HR -> history remote)
- S:             Connection status
- CLIENT_HOST:   Client host name
- DB_USER:       Database user name
- MEM_MB:        Memory usage (MB)
- SELECT:        Number of select executions
- AVG_SEL_MS:    Average select execution time (ms)
- SELECT_FU:     Number of select for update executions
- AVG_SEL_FU_MS: Average select for update execution time (ms)
- MODIF:         Number of modification executions (insert, update, delete)
- AVG_MOD_MS:    Average modification execution time (ms)
- DDL:           Number of DDL executions (and other special operations)
- AVG_DDL_MS:    Average DDL execution time (ms)
- PREP:          Number of prepares
- AVG_PREP_MS:   Average prepare time (ms)
- COMMIT:        Number of commits
- AVG_COM_MS:    Average commit time (ms)
- ROLLBACK:      Number of rollbacks
- AVG_RB_MS:     Average rollback time (ms)

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST     |PORT |CONN_ID|MAX_MEM_MB|SELECT    |AVG_SEL_MS|SEL_PER_S|SELECT_FU |AVG_SEL_FU_MS|SEL_FU_PER_S|MODIF     |AVG_MOD_MS|MOD_PER_S|DDL       |AVG_DDL_MS|DDL_PER_S|PREP      |AVG_PREP_MS|PREP_PER_S|COMMIT    |AVG_COM_MS|COM_PER_S|ROLLBACK  |AVG_RB_MS |RB_PER_S |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|saphana01|32103| 300441|   3361.54|  23671663|      7.54|     1.85|         0|         0.00|        0.00|  24846914|     47.19|     1.94|     49268|     51.72|     0.00|    178581|  434494.38|      0.01|   4763734|      1.04|     0.37|         0|      0.00|     0.00|
|saphana01|32103| 300438|   3816.42|  20816810|      9.82|     1.63|         0|         0.00|        0.00|  22417250|     53.38|     1.75|     67259|     36.94|     0.00|    170093|  477976.78|      0.01|   4341965|      1.02|     0.34|         0|      0.00|     0.00|
|saphana01|32103| 300439|   3928.04|  19721973|     10.55|     1.54|         0|         0.00|        0.00|  21757693|    141.47|     1.70|     40311|     51.95|     0.00|    167986|  880418.22|      0.01|   4238118|      1.11|     0.33|         0|      0.00|     0.00|
|saphana01|32103| 300442|   3171.43|  20377843|     10.34|     1.59|         0|         0.00|        0.00|  21514624|     52.39|     1.68|     62027|     40.36|     0.00|    167779|  538379.59|      0.01|   4226439|      1.05|     0.33|         0|      0.00|     0.00|
|saphana01|32103| 363641|   1649.15|  11747222|      0.06|     2.92|   3061452|         0.65|        0.76|   8143261|      1.10|     2.03|         0|      0.00|     0.00|       648|    1116.25|      0.00|   3641545|      0.96|     0.90|         0|      0.00|     0.00|
|saphana01|32103| 300440|   4211.97|  16327946|     13.82|     1.28|         0|         0.00|        0.00|  17213298|     59.72|     1.35|     39587|     50.05|     0.00|    152107|  508156.08|      0.01|   3440413|      1.07|     0.26|         0|      0.00|     0.00|
|saphana01|32103| 346026|   1520.76|  10851741|      0.06|     2.53|   2827512|         0.64|        0.66|   7513636|      1.09|     1.75|         0|      0.00|     0.00|       692|    1026.99|      0.00|   3362805|      0.97|     0.78|         1| 624294.96|     0.00|
|saphana01|32103| 364800|   1444.67|  10282336|      0.06|     2.97|   2678764|         0.64|        0.77|   7131071|      1.11|     2.06|         0|      0.00|     0.00|       613|    1730.12|      0.00|   3184666|      0.97|     0.92|         0|      0.00|     0.00|
|saphana01|32103| 354557|   1347.50|   9575464|      0.06|     2.68|   2495295|         0.65|        0.69|   6630241|      1.13|     1.85|         0|      0.00|     0.00|       617|    1116.51|      0.00|   2968429|      0.99|     0.83|         0|      0.00|     0.00|
|saphana01|32103| 345614|   1126.01|   8015438|      0.07|     1.87|   2090348|         0.67|        0.48|   5531093|      1.12|     1.29|         0|      0.00|     0.00|       622|     555.39|      0.00|   2486162|      0.99|     0.58|         0|      0.00|     0.00|
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  AGGREGATION_TYPE AGG,
  START_TIME,
  LPAD(CNT, 5) CNT,
  LPAD(TO_DECIMAL(CONN_TIME_MS / 1000, 10, 2), 12) CONN_TIME_S,
  LPAD(CONN_ID, 7) CONN_ID,
  MAP(CONN_TYPE, 'History (local)', 'HL', 'History (remote)', 'HR', 'Local', 'L', 'Remote', 'R') CT,
  MAP(CONN_STATUS, 'IDLE', 'I', 'RUNNING', 'R', CONN_STATUS) S,
  CLIENT_HOST,
  DB_USER,
  LPAD(TO_DECIMAL(MEM_MB, 10, 2), 8) MEM_MB,
  LPAD(TO_DECIMAL("SELECT"), 10) "SELECT",
  LPAD(TO_DECIMAL(MAP("SELECT", 0, 0, SEL_MS / "SELECT"), 10, 2), 10) AVG_SEL_MS,
  LPAD(TO_DECIMAL(SELECT_FU), 10) SELECT_FU,
  LPAD(TO_DECIMAL(MAP(SELECT_FU, 0, 0, SEL_FU_MS / SELECT_FU), 10, 2), 13) AVG_SEL_FU_MS,
  LPAD(TO_DECIMAL(MODIF), 10) MODIF,
  LPAD(TO_DECIMAL(MAP(MODIF, 0, 0, MOD_MS / MODIF), 10, 2), 10) AVG_MOD_MS,
  LPAD(TO_DECIMAL(DDL), 10) DDL,
  LPAD(TO_DECIMAL(MAP(DDL, 0, 0, DDL_MS / DDL), 10, 2), 10) AVG_DDL_MS,
  LPAD(TO_DECIMAL(PREP), 10) PREP,
  LPAD(TO_DECIMAL(MAP(PREP, 0, 0, PREP_MS / PREP), 10, 2), 11) AVG_PREP_MS,
  LPAD(TO_DECIMAL("COMMIT"), 10) "COMMIT",
  LPAD(TO_DECIMAL(MAP("COMMIT", 0, 0, COM_MS / "COMMIT"), 10, 2), 10) AVG_COM_MS,
  LPAD(TO_DECIMAL(ROLLBACK), 10) ROLLBACK,
  LPAD(TO_DECIMAL(MAP(ROLLBACK, 0, 0, RB_MS / ROLLBACK), 10, 2), 10) AVG_RB_MS
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(C.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE C.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(C.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE C.START_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any'
    END START_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')    != 0 THEN CS.HOST                      ELSE MAP(BI.HOST,   '%', 'any', BI.HOST)                END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(CS.PORT)          ELSE MAP(BI.PORT,   '%', 'any', BI.PORT)                END PORT,  
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONN_ID') != 0 THEN TO_VARCHAR(C.CONNECTION_ID)  ELSE MAP(BI.CONN_ID, -1, 'any', TO_VARCHAR(BI.CONN_ID)) END CONN_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TYPE')    != 0 THEN C.CONNECTION_TYPE            ELSE MAP(BI.CONN_TYPE, '%', 'any', BI.CONN_TYPE)        END CONN_TYPE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATUS')  != 0 THEN C.CONNECTION_STATUS          ELSE MAP(BI.CONN_STATUS, '%', 'any', BI.CONN_STATUS)    END CONN_STATUS,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CLIENT')  != 0 THEN C.CLIENT_HOST                ELSE MAP(BI.CLIENT_HOST, '%', 'any', BI.CLIENT_HOST)    END CLIENT_HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DB_USER') != 0 THEN C.USER_NAME                  ELSE MAP(BI.DB_USER, '%', 'any', BI.DB_USER)            END DB_USER,
    COUNT(*) CNT,
    MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(C.CONN_TIME_MS), 'AVG', AVG(C.CONN_TIME_MS), 'SUM', SUM(C.CONN_TIME_MS)) CONN_TIME_MS,
    MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(CS.SELECT_EXECUTION_COUNT), 'AVG', AVG(CS.SELECT_EXECUTION_COUNT), 'SUM', SUM(CS.SELECT_EXECUTION_COUNT)) "SELECT",
    MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(CS.SELECT_TOTAL_EXECUTION_TIME), 'AVG', AVG(CS.SELECT_TOTAL_EXECUTION_TIME), 'SUM', SUM(CS.SELECT_TOTAL_EXECUTION_TIME)) / 1000 SEL_MS,
    MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(CS.SELECT_FOR_UPDATE_COUNT), 'AVG', AVG(CS.SELECT_FOR_UPDATE_COUNT), 'SUM', SUM(CS.SELECT_FOR_UPDATE_COUNT)) SELECT_FU,
    MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(CS.SELECT_FOR_UPDATE_TOTAL_EXECUTION_TIME), 'AVG', AVG(CS.SELECT_FOR_UPDATE_TOTAL_EXECUTION_TIME), 'SUM', SUM(CS.SELECT_FOR_UPDATE_TOTAL_EXECUTION_TIME)) / 1000 SEL_FU_MS,
    MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(CS.UPDATE_COUNT), 'AVG', AVG(CS.UPDATE_COUNT), 'SUM', SUM(CS.UPDATE_COUNT)) MODIF,
    MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(CS.UPDATE_TOTAL_EXECUTION_TIME), 'AVG', AVG(CS.UPDATE_TOTAL_EXECUTION_TIME), 'SUM', SUM(CS.UPDATE_TOTAL_EXECUTION_TIME)) / 1000 MOD_MS,
    MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(CS.OTHERS_COUNT), 'AVG', AVG(CS.OTHERS_COUNT), 'SUM', SUM(CS.OTHERS_COUNT)) DDL,
    MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(CS.OTHERS_TOTAL_EXECUTION_TIME), 'AVG', AVG(CS.OTHERS_TOTAL_EXECUTION_TIME), 'SUM', SUM(CS.OTHERS_TOTAL_EXECUTION_TIME)) / 1000 DDL_MS,
    MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(CS.COMMIT_COUNT), 'AVG', AVG(CS.COMMIT_COUNT), 'SUM', SUM(CS.COMMIT_COUNT)) "COMMIT",
    MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(CS.COMMIT_TOTAL_EXECUTION_TIME), 'AVG', AVG(CS.COMMIT_TOTAL_EXECUTION_TIME), 'SUM', SUM(CS.COMMIT_TOTAL_EXECUTION_TIME)) / 1000 COM_MS,
    MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(CS.TOTAL_PREPARATION_COUNT), 'AVG', AVG(CS.TOTAL_PREPARATION_COUNT), 'SUM', SUM(CS.TOTAL_PREPARATION_COUNT)) PREP,
    MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(CS.TOTAL_PREPARATION_TIME), 'AVG', AVG(CS.TOTAL_PREPARATION_TIME), 'SUM', SUM(CS.TOTAL_PREPARATION_TIME)) / 1000000 PREP_MS,
    MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(CS.ROLLBACK_COUNT), 'AVG', AVG(CS.ROLLBACK_COUNT), 'SUM', SUM(CS.ROLLBACK_COUNT)) ROLLBACK,
    MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(CS.ROLLBACK_TOTAL_EXECUTION_TIME), 'AVG', AVG(CS.ROLLBACK_TOTAL_EXECUTION_TIME), 'SUM', SUM(CS.ROLLBACK_TOTAL_EXECUTION_TIME)) / 1000 RB_MS,
    MAP(BI.AGGREGATION_TYPE, 'MAX', MAX(CS.MAX_EXECUTION_MEMORY_SIZE), 'AVG', AVG(CS.MAX_EXECUTION_MEMORY_SIZE), 'SUM', SUM(CS.MAX_EXECUTION_MEMORY_SIZE)) / 1024 / 1024 MEM_MB,
    BI.AGGREGATION_TYPE,
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
      CONN_ID,
      CONN_TYPE,
      CONN_STATUS,
      CLIENT_HOST,
      DB_USER,
      AGGREGATION_TYPE,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS:FF2',
        'HOUR',        'YYYY/MM/DD HH24',
        'DAY',         'YYYY/MM/DD (DY)',
        'HOUR_OF_DAY', 'HH24',
        TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
      ORDER_BY
    FROM
    ( SELECT                                /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        'SERVER' TIMEZONE,                              /* SERVER, UTC */
        '%' HOST,
        '%' PORT,
        -1 CONN_ID,
        '%' CONN_TYPE,             /* Remote, Local, History (remote), History (local), % */
        '%' CONN_STATUS,
        '%' CLIENT_HOST,
        '%' DB_USER,
        'AVG' AGGREGATION_TYPE,           /* MAX, AVG, SUM */
        'NONE' AGGREGATE_BY,             /* HOST, PORT, CONN_ID, TYPE, STATUS, CLIENT, DB_USER or comma separated combinations, NONE for no aggregation */
        'NONE' TIME_AGGREGATE_BY,     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'TIME' ORDER_BY          /* TIME, CONN_ID, COMMIT_COUNT, COMMIT_TIME, PREPARATION_COUNT, PREPARATION_TIME, ROLLBACK_COUNT, ROLLBACK_TIME, MODIFICATION_COUNT, MODIFICATION_TIME, 
                                            SELECT_COUNT, SELECT_TIME, SELECT_FOR_UPDATE_COUNT, SELECT_FOR_UPDATE_TIME  */
      FROM
        DUMMY
    )
  ) BI,
    M_CONNECTION_STATISTICS CS,
  ( SELECT
      *,
      NANO100_BETWEEN(START_TIME, IFNULL(END_TIME, CURRENT_TIMESTAMP)) / 10000 CONN_TIME_MS
    FROM
      M_CONNECTIONS
  ) C
  WHERE
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(C.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE C.START_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    CS.HOST LIKE BI.HOST AND
    TO_VARCHAR(CS.PORT) LIKE BI.PORT AND
    ( BI.CONN_ID = -1 OR CS.CONNECTION_ID = BI.CONN_ID ) AND
    C.CONNECTION_TYPE LIKE BI.CONN_TYPE AND
    C.CONNECTION_STATUS LIKE BI.CONN_STATUS AND
    C.CLIENT_HOST LIKE BI.CLIENT_HOST AND
    C.USER_NAME LIKE BI.DB_USER AND
    C.HOST = CS.HOST AND
    C.PORT = CS.PORT AND
    C.CONNECTION_ID = CS.CONNECTION_ID
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(C.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE C.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(C.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE C.START_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any'
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')    != 0 THEN CS.HOST                      ELSE MAP(BI.HOST,   '%', 'any', BI.HOST)                END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(CS.PORT)          ELSE MAP(BI.PORT,   '%', 'any', BI.PORT)                END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONN_ID') != 0 THEN TO_VARCHAR(C.CONNECTION_ID)  ELSE MAP(BI.CONN_ID, -1, 'any', TO_VARCHAR(BI.CONN_ID)) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TYPE')    != 0 THEN C.CONNECTION_TYPE            ELSE MAP(BI.CONN_TYPE, '%', 'any', BI.CONN_TYPE)        END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATUS')  != 0 THEN C.CONNECTION_STATUS          ELSE MAP(BI.CONN_STATUS, '%', 'any', BI.CONN_STATUS)    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CLIENT')  != 0 THEN C.CLIENT_HOST                ELSE MAP(BI.CLIENT_HOST, '%', 'any', BI.CLIENT_HOST)    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DB_USER') != 0 THEN C.USER_NAME                  ELSE MAP(BI.DB_USER, '%', 'any', BI.DB_USER)            END,
    BI.AGGREGATION_TYPE,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'CONN_ID', HOST || PORT || CONN_ID),
  MAP(ORDER_BY, 'COMMIT_COUNT', "COMMIT", 'COMMIT_TIME', COM_MS, 
                'MODIFICATION_COUNT', MODIF, 'MODIFICATION_TIME', MOD_MS,
                'PREPARATION_COUNT', PREP, 'PREPARATION_TIME', PREP_MS,
                'ROLLBACK_COUNT', ROLLBACK, 'ROLLBACK_TIME', RB_MS,
                'SELECT_COUNT', "SELECT", 'SELECT_TIME', SEL_MS,
                'SELECT_FOR_UPDATE_COUNT', SELECT_FU, 'SELECT_FOR_UPDATE_TIME', SEL_FU_MS,
                'TIME', START_TIME
     ) DESC
  