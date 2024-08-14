SELECT
/* 

[NAME]

- HANA_Workload_2.00.060+

[DESCRIPTION]

- Workload information including number of SQL statements and transactions

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- PEAK_EXECUTION_RATE and *_MEMORY_RATE columns not properly filled (bug 263702)
- SITE_ID in history tables available with SAP HANA >= 2.0 SPS 06

[VALID FOR]

- Revisions:              >= 2.00.060

[SQL COMMAND VERSION]

- 2014/04/28:  1.0 (initial version)
- 2014/12/19:  1.1 (AGGREGATE_BY included)
- 2016/12/31:  1.2 (TIME_AGGREGATE_BY = 'TS<seconds>' included)
- 2017/10/23:  1.3 (TIMEZONE included)
- 2018/12/04:  1.4 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2021/02/12:  1.5 (AGGREGATION_TYPE added)
- 2022/05/27:  1.6 (dedicated 2.00.060+ version including SITE_ID for data source HISTORY)

[INVOLVED TABLES]

- M_WORKLOAD
- HOST_WORKLOAD

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

- SITE_ID

  System replication site ID (may only work for DATA_SOURCE = 'HISTORY')

  -1             --> No restriction related to site ID
  1              --> Site id 1

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

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)
  '%'             --> All data sources

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
  
[OUTPUT PARAMETERS]

- SNAPSHOT_TIME:   Sample time frame
- ST:              System replication site ID
- HOST:            Host name
- PORT:            Port
- AGG:             Aggregation type of subsequent output columns (AVG: average values, MAX: maximum values)
                   MAX values may be too high in case of aggregation because maximum values of different services are summed up even if the happened at different times
- EXEC_PER_S:      Number of SQL statement executions per second
- PREP_PER_S:      Number of prepares per second
- TRANS_PER_S:     Number of transactions per second
- UPD_TRANS_PER_S: Number of update transactions per second
- COMMIT_PER_S:    Number of commits per second
- ROLLBACK_PER_S:  Number of rollbacks per second

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------
|SNAPSHOT_TIME   |HOST     |PORT |EXEC_PER_S|PREP_PER_S|TRANS_PER_S|UPD_TRANS_PER_S|COMMIT_PER_S|ROLLBACK_PER_S|
----------------------------------------------------------------------------------------------------------------
|2014/12/19 (FRI)|saphanadb|  any|  15363.65|    103.94|      38.04|          37.73|       38.03|          0.01|
|2014/12/18 (THU)|saphanadb|  any|  11145.88|     89.44|      26.25|          25.65|       26.22|          0.03|
|2014/12/17 (WED)|saphanadb|  any|  14473.61|    122.74|      30.05|          26.85|       29.99|          0.06|
|2014/12/16 (TUE)|saphanadb|  any|  12951.43|     94.15|      28.05|          26.88|       27.97|          0.08|
|2014/12/15 (MON)|saphanadb|  any|  15908.58|    101.16|      25.51|          24.64|       25.46|          0.04|
|2014/12/14 (SUN)|saphanadb|  any|   5007.65|      7.43|      17.08|          16.27|       17.06|          0.02|
|2014/12/13 (SAT)|saphanadb|  any|   7502.89|     12.72|      18.58|          17.52|       18.55|          0.03|
----------------------------------------------------------------------------------------------------------------

*/

  SNAPSHOT_TIME,
  IFNULL(LPAD(SITE_ID, 2), '') ST,
  HOST,
  LPAD(PORT, 5) PORT,
  AGGREGATION_TYPE AGG,
  LPAD(TO_DECIMAL(EXECUTION_RATE / 60, 10, 2), 10) EXEC_PER_S,
  LPAD(TO_DECIMAL(COMPILATION_RATE / 60, 10, 2), 10) PREP_PER_S,
  LPAD(TO_DECIMAL(TRANSACTION_RATE / 60, 10, 2), 11) TRANS_PER_S,
  LPAD(TO_DECIMAL(UPDATE_TRANSACTION_RATE / 60, 10, 2), 15) UPD_TRANS_PER_S,
  LPAD(TO_DECIMAL(COMMIT_RATE / 60, 10, 2), 12) COMMIT_PER_S,
  LPAD(TO_DECIMAL(ROLLBACK_RATE / 60, 10, 2), 14) ROLLBACK_PER_S
FROM
( SELECT
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SITE_ID') != 0 THEN TO_VARCHAR(SITE_ID) ELSE MAP(BI_SITE_ID, -1, 'any', TO_VARCHAR(BI_SITE_ID)) END SITE_ID,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST')    != 0 THEN HOST                ELSE MAP(BI_HOST,   '%', 'any', BI_HOST)                END HOST,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(PORT)    ELSE MAP(BI_PORT,   '%', 'any', BI_PORT)                END PORT,
    SNAPSHOT_TIME,
    SUM(EXECUTION_RATE) EXECUTION_RATE,
    SUM(COMPILATION_RATE) COMPILATION_RATE,
    SUM(TRANSACTION_RATE) TRANSACTION_RATE,
    SUM(UPDATE_TRANSACTION_RATE) UPDATE_TRANSACTION_RATE,
    SUM(COMMIT_RATE) COMMIT_RATE,
    SUM(ROLLBACK_RATE) ROLLBACK_RATE,
    AGGREGATION_TYPE
  FROM
  ( SELECT
      CASE 
        WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(W.SAMPLE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE W.SAMPLE_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(W.SAMPLE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE W.SAMPLE_TIME END, BI.TIME_AGGREGATE_BY)
          END
        ELSE 'any' 
      END SNAPSHOT_TIME,
      W.SITE_ID,
      W.HOST,
      W.PORT,
      MAP(BI.AGGREGATION_TYPE, 'AVG', AVG(W.CURRENT_EXECUTION_RATE), MAP(BI.DATA_SOURCE, 'HISTORY', MAX(W.CURRENT_EXECUTION_RATE), MAX(W.PEAK_EXECUTION_RATE))) EXECUTION_RATE,
      MAP(BI.AGGREGATION_TYPE, 'AVG', AVG(W.CURRENT_COMPILATION_RATE), MAP(BI.DATA_SOURCE, 'HISTORY', MAX(W.CURRENT_COMPILATION_RATE), MAX(W.PEAK_COMPILATION_RATE))) COMPILATION_RATE,
      MAP(BI.AGGREGATION_TYPE, 'AVG', AVG(W.CURRENT_TRANSACTION_RATE), MAP(BI.DATA_SOURCE, 'HISTORY', MAX(W.CURRENT_TRANSACTION_RATE), MAX(W.PEAK_TRANSACTION_RATE))) TRANSACTION_RATE,
      MAP(BI.AGGREGATION_TYPE, 'AVG', AVG(W.CURRENT_UPDATE_TRANSACTION_RATE), MAP(BI.DATA_SOURCE, 'HISTORY', MAX(W.CURRENT_UPDATE_TRANSACTION_RATE), MAX(W.PEAK_UPDATE_TRANSACTION_RATE))) UPDATE_TRANSACTION_RATE,
      MAP(BI.AGGREGATION_TYPE, 'AVG', AVG(W.CURRENT_COMMIT_RATE), MAP(BI.DATA_SOURCE, 'HISTORY', MAX(W.CURRENT_COMMIT_RATE), MAX(W.PEAK_COMMIT_RATE))) COMMIT_RATE,
      MAP(BI.AGGREGATION_TYPE, 'AVG', AVG(W.CURRENT_ROLLBACK_RATE), MAP(BI.DATA_SOURCE, 'HISTORY', MAX(W.CURRENT_ROLLBACK_RATE), MAX(W.PEAK_ROLLBACK_RATE))) ROLLBACK_RATE,
      BI.SITE_ID BI_SITE_ID,
      BI.HOST BI_HOST,
      BI.PORT BI_PORT,
      BI.AGGREGATION_TYPE,
      BI.AGGREGATE_BY
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
        SITE_ID,
        HOST,
        PORT,
        DATA_SOURCE,
        AGGREGATION_TYPE,
        AGGREGATE_BY,
        MAP(TIME_AGGREGATE_BY,
          'NONE',        'YYYY/MM/DD HH24:MI:SS',
          'HOUR',        'YYYY/MM/DD HH24',
          'DAY',         'YYYY/MM/DD (DY)',
          'HOUR_OF_DAY', 'HH24',
          TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY
      FROM
      ( SELECT                         /* Modification section */
          '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
          'C' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
          'SERVER' TIMEZONE,                              /* SERVER, UTC */
          CURRENT_SITE_ID() SITE_ID,
          '%' HOST,
          '%' PORT,
          'CURRENT' DATA_SOURCE,              /* CURRENT, HISTORY */
          'AVG' AGGREGATION_TYPE,             /* AVG, MAX */
          'NONE' AGGREGATE_BY,          /* SITE_ID, HOST, PORT, TIME or comma separated combination, NONE for no aggregation */
          'NONE' TIME_AGGREGATE_BY      /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        FROM
          DUMMY
      )
    ) BI,
    ( SELECT
        'CURRENT' DATA_SOURCE,
        CURRENT_TIMESTAMP SAMPLE_TIME,
        CURRENT_SITE_ID() SITE_ID,
        HOST,
        PORT,
        CURRENT_EXECUTION_RATE,
        CURRENT_COMPILATION_RATE,
        CURRENT_TRANSACTION_RATE,
        CURRENT_UPDATE_TRANSACTION_RATE,
        CURRENT_COMMIT_RATE,
        CURRENT_ROLLBACK_RATE,
        PEAK_EXECUTION_RATE,
        PEAK_COMPILATION_RATE,
        PEAK_TRANSACTION_RATE,
        PEAK_UPDATE_TRANSACTION_RATE,
        PEAK_COMMIT_RATE,
        PEAK_ROLLBACK_RATE
      FROM
        M_WORKLOAD
      UNION ALL
      SELECT
        'HISTORY' DATA_SOURCE,
        SERVER_TIMESTAMP SAMPLE_TIME,
        SITE_ID,
        HOST,
        PORT,
        CURRENT_EXECUTION_RATE,
        CURRENT_COMPILATION_RATE,
        CURRENT_TRANSACTION_RATE,
        CURRENT_UPDATE_TRANSACTION_RATE,
        CURRENT_COMMIT_RATE,
        CURRENT_ROLLBACK_RATE,
        PEAK_EXECUTION_RATE,
        PEAK_COMPILATION_RATE,
        PEAK_TRANSACTION_RATE,
        PEAK_UPDATE_TRANSACTION_RATE,
        PEAK_COMMIT_RATE,
        PEAK_ROLLBACK_RATE
      FROM
        _SYS_STATISTICS.HOST_WORKLOAD
    ) W
    WHERE
      ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND W.SITE_ID IN (-1, 0) ) OR W.SITE_ID = BI.SITE_ID ) AND
      W.HOST LIKE BI.HOST AND
      TO_VARCHAR(W.PORT) LIKE BI.PORT AND
      ( BI.DATA_SOURCE = 'CURRENT' OR
        CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(W.SAMPLE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE W.SAMPLE_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME 
      ) AND
      W.DATA_SOURCE LIKE BI.DATA_SOURCE
    GROUP BY
      CASE 
        WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
          CASE 
            WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
              TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
              'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(W.SAMPLE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE W.SAMPLE_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
            ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(W.SAMPLE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE W.SAMPLE_TIME END, BI.TIME_AGGREGATE_BY)
          END
        ELSE 'any' 
      END,
      W.SITE_ID,
      W.HOST,
      W.PORT,
      BI.SITE_ID,
      BI.HOST,
      BI.PORT,
      BI.AGGREGATION_TYPE,
      BI.AGGREGATE_BY,
      BI.DATA_SOURCE
  )
  GROUP BY
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SITE_ID') != 0 THEN TO_VARCHAR(SITE_ID) ELSE MAP(BI_SITE_ID, -1, 'any', TO_VARCHAR(BI_SITE_ID)) END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST')    != 0 THEN HOST                ELSE MAP(BI_HOST,   '%', 'any', BI_HOST)                END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(PORT)    ELSE MAP(BI_PORT,   '%', 'any', BI_PORT)                END,
    SNAPSHOT_TIME,
    AGGREGATION_TYPE
)
ORDER BY
  SNAPSHOT_TIME DESC,
  SITE_ID,
  HOST,
  PORT