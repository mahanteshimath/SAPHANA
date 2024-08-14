SELECT
/* 

[NAME]

- HANA_SQL_ExpensiveStatements_ThresholdTraceVolume

[DESCRIPTION]

- Expensive statement trace volume dependent on treshold setting

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Only populated if expensive statements trace is activated (SAP Note 2180165)
- If *_1 columns already have a percentage significantly below 100, it indicates that many entries are generated based on other thresholds

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2019/03/19:  1.0 (initial version)
- 2019/03/27:  1.1 (PCT_BASIS and statement length related percentage calculations included)

[INVOLVED TABLES]

- M_EXPENSIVE_STATEMENTS

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

- PCT_BASIS

  Basis for percentage calculation

  'COUNT'         --> Number of trace entries
  'SIZE'          --> Size of traced SQL statements

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOST'          --> Aggregation by host
  'NONE'          --> No aggregation

[OUTPUT PARAMETERS]

- HOST:   Host
- PORT:   Port
- COUNT:  Number of expensive statements trace entries
- DUR_MS: threshold_duration setting (ms)
- DUR_1:  Percentage of expensive statements trace entries with a duration of at least the configured threshold_duration
- DUR_2:  Percentage of expensive statements trace entries with a duration of at least the configured threshold_duration * 2
- DUR_4:  Percentage of expensive statements trace entries with a duration of at least the configured threshold_duration * 4
- DUR_8:  Percentage of expensive statements trace entries with a duration of at least the configured threshold_duration * 8
- DUR_16: Percentage of expensive statements trace entries with a duration of at least the configured threshold_duration * 16
- CPU_MS: threshold_cpu_time setting (ms)
- CPU_1:  Percentage of expensive statements trace entries with a CPU time of at least the configured threshold_cpu_time
- CPU_2:  Percentage of expensive statements trace entries with a CPU time of at least the configured threshold_cpu_time * 2
- CPU_4:  Percentage of expensive statements trace entries with a CPU time of at least the configured threshold_cpu_time * 4
- CPU_8:  Percentage of expensive statements trace entries with a CPU time of at least the configured threshold_cpu_time * 8
- CPU_16: Percentage of expensive statements trace entries with a CPU time of at least the configured threshold_cpu_time * 16
- MEM_MB: threshold_memory setting (MB)
- MEM_1:  Percentage of expensive statements trace entries with a memory consumption of at least the configured threshold_memory
- MEM_2:  Percentage of expensive statements trace entries with a memory consumption of at least the configured threshold_memory * 2
- MEM_4:  Percentage of expensive statements trace entries with a memory consumption of at least the configured threshold_memory * 4
- MEM_8:  Percentage of expensive statements trace entries with a memory consumption of at least the configured threshold_memory * 8
- MEM_16: Percentage of expensive statements trace entries with a memory consumption of at least the configured threshold_memory * 16

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST      |PORT |COUNT |DUR_MS|DUR_1 |DUR_2 |DUR_4 |DUR_8 |DUR_16|CPU_MS|CPU_1 |CPU_2 |CPU_4 |CPU_8 |CPU_16|MEM_MB|MEM_1 |MEM_2 |MEM_4 |MEM_8 |MEM_16|
-------------------------------------------------------------------------------------------------------------------------------------------------------
|saphana001|30003|  6801| 50000|  0.76|  0.42|  0.17|  0.13|  0.08|  1000| 99.63| 51.15| 14.21| 10.10|  6.14| 10240|  0.44|  0.07|  0.02|  0.02|  0.00|
|saphana001|30007|  4316| 50000|  0.23|  0.09|  0.00|  0.00|  0.00|  1000|100.00| 80.53| 12.99|  5.69|  3.42| 10240|  0.09|  0.00|  0.00|  0.00|  0.00|
-------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------------
|HOST    |PORT |COUNT |DUR_MS|DUR_1 |DUR_2 |DUR_4 |DUR_8 |DUR_16|CPU_MS|CPU_1 |CPU_2 |CPU_4 |CPU_8 |CPU_16|MEM_MB|MEM_1 |MEM_2 |MEM_4 |MEM_8 |MEM_16|
-----------------------------------------------------------------------------------------------------------------------------------------------------
|saphana1|30003| 30000| 20000|100.00| 70.99| 44.21| 25.15| 22.04|     0|100.00|100.00|100.00|100.00|100.00|     0|100.00|100.00|100.00|100.00|100.00|
|saphana1|30007|    39| 20000|  0.00|  0.00|  0.00|  0.00|  0.00|     0|100.00|100.00|100.00|100.00|100.00|     0|100.00|100.00|100.00|100.00|100.00|
|saphana2|30003| 16402| 20000|100.00| 79.54| 60.75|  1.04|  0.74|     0|100.00|100.00|100.00|100.00|100.00|     0|100.00|100.00|100.00|100.00|100.00|
-----------------------------------------------------------------------------------------------------------------------------------------------------

*/

  HOST,
  PORT,
  LPAD(TOTAL, 6) COUNT,
  LPAD(DUR_MS, 6) DUR_MS,
  LPAD(TO_DECIMAL(MAP(TOTAL, 0, 0, DUR_1_CNT / TOTAL * 100), 10, 2), 6) DUR_1,
  LPAD(TO_DECIMAL(MAP(TOTAL, 0, 0, DUR_2_CNT / TOTAL * 100), 10, 2), 6) DUR_2,
  LPAD(TO_DECIMAL(MAP(TOTAL, 0, 0, DUR_4_CNT / TOTAL * 100), 10, 2), 6) DUR_4,
  LPAD(TO_DECIMAL(MAP(TOTAL, 0, 0, DUR_8_CNT / TOTAL * 100), 10, 2), 6) DUR_8,
  LPAD(TO_DECIMAL(MAP(TOTAL, 0, 0, DUR_16_CNT / TOTAL * 100), 10, 2), 6) DUR_16,
  LPAD(CPU_MS, 6) CPU_MS,
  LPAD(TO_DECIMAL(MAP(TOTAL, 0, 0, CPU_1_CNT / TOTAL * 100), 10, 2), 6) CPU_1,
  LPAD(TO_DECIMAL(MAP(TOTAL, 0, 0, CPU_2_CNT / TOTAL * 100), 10, 2), 6) CPU_2,
  LPAD(TO_DECIMAL(MAP(TOTAL, 0, 0, CPU_4_CNT / TOTAL * 100), 10, 2), 6) CPU_4,
  LPAD(TO_DECIMAL(MAP(TOTAL, 0, 0, CPU_8_CNT / TOTAL * 100), 10, 2), 6) CPU_8,
  LPAD(TO_DECIMAL(MAP(TOTAL, 0, 0, CPU_16_CNT / TOTAL * 100), 10, 2), 6) CPU_16,
  LPAD(MEM_MB, 6) MEM_MB,
  LPAD(TO_DECIMAL(MAP(TOTAL, 0, 0, MEM_1_CNT / TOTAL * 100), 10, 2), 6) MEM_1,
  LPAD(TO_DECIMAL(MAP(TOTAL, 0, 0, MEM_2_CNT / TOTAL * 100), 10, 2), 6) MEM_2,
  LPAD(TO_DECIMAL(MAP(TOTAL, 0, 0, MEM_4_CNT / TOTAL * 100), 10, 2), 6) MEM_4,
  LPAD(TO_DECIMAL(MAP(TOTAL, 0, 0, MEM_8_CNT / TOTAL * 100), 10, 2), 6) MEM_8,
  LPAD(TO_DECIMAL(MAP(TOTAL, 0, 0, MEM_16_CNT / TOTAL * 100), 10, 2), 6) MEM_16
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST') != 0 THEN ES.HOST             ELSE MAP(BI.HOST, '%', 'any', BI.HOST) END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT') != 0 THEN TO_VARCHAR(ES.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT) END PORT,
    TO_DECIMAL(P.DUR_US / 1000, 10, 0) DUR_MS,
    TO_DECIMAL(P.CPU_US / 1000, 10, 0) CPU_MS,
    TO_DECIMAL(P.MEM_BYTE / 1024 / 1024, 10, 0) MEM_MB,
    CASE WHEN BI.PCT_BASIS = 'COUNT' THEN COUNT(*) ELSE SUM(LENGTH(ES.STATEMENT_STRING)) END TOTAL,
    SUM(CASE WHEN ES.DURATION_MICROSEC >= DUR_US        THEN MAP(BI.PCT_BASIS, 'COUNT', 1, 'SIZE', LENGTH(STATEMENT_STRING)) ELSE 0 END) DUR_1_CNT,
    SUM(CASE WHEN ES.DURATION_MICROSEC >= DUR_US *  2   THEN MAP(BI.PCT_BASIS, 'COUNT', 1, 'SIZE', LENGTH(STATEMENT_STRING)) ELSE 0 END) DUR_2_CNT,
    SUM(CASE WHEN ES.DURATION_MICROSEC >= DUR_US *  4   THEN MAP(BI.PCT_BASIS, 'COUNT', 1, 'SIZE', LENGTH(STATEMENT_STRING)) ELSE 0 END) DUR_4_CNT,
    SUM(CASE WHEN ES.DURATION_MICROSEC >= DUR_US *  8   THEN MAP(BI.PCT_BASIS, 'COUNT', 1, 'SIZE', LENGTH(STATEMENT_STRING)) ELSE 0 END) DUR_8_CNT,
    SUM(CASE WHEN ES.DURATION_MICROSEC >= DUR_US * 16   THEN MAP(BI.PCT_BASIS, 'COUNT', 1, 'SIZE', LENGTH(STATEMENT_STRING)) ELSE 0 END) DUR_16_CNT,
    SUM(CASE WHEN ES.CPU_TIME          >= CPU_US        THEN MAP(BI.PCT_BASIS, 'COUNT', 1, 'SIZE', LENGTH(STATEMENT_STRING)) ELSE 0 END) CPU_1_CNT,
    SUM(CASE WHEN ES.CPU_TIME          >= CPU_US *  2   THEN MAP(BI.PCT_BASIS, 'COUNT', 1, 'SIZE', LENGTH(STATEMENT_STRING)) ELSE 0 END) CPU_2_CNT,
    SUM(CASE WHEN ES.CPU_TIME          >= CPU_US *  4   THEN MAP(BI.PCT_BASIS, 'COUNT', 1, 'SIZE', LENGTH(STATEMENT_STRING)) ELSE 0 END) CPU_4_CNT,
    SUM(CASE WHEN ES.CPU_TIME          >= CPU_US *  8   THEN MAP(BI.PCT_BASIS, 'COUNT', 1, 'SIZE', LENGTH(STATEMENT_STRING)) ELSE 0 END) CPU_8_CNT,
    SUM(CASE WHEN ES.CPU_TIME          >= CPU_US * 16   THEN MAP(BI.PCT_BASIS, 'COUNT', 1, 'SIZE', LENGTH(STATEMENT_STRING)) ELSE 0 END) CPU_16_CNT,
    SUM(CASE WHEN ES.MEMORY_SIZE       >= MEM_BYTE      THEN MAP(BI.PCT_BASIS, 'COUNT', 1, 'SIZE', LENGTH(STATEMENT_STRING)) ELSE 0 END) MEM_1_CNT,
    SUM(CASE WHEN ES.MEMORY_SIZE       >= MEM_BYTE * 2  THEN MAP(BI.PCT_BASIS, 'COUNT', 1, 'SIZE', LENGTH(STATEMENT_STRING)) ELSE 0 END) MEM_2_CNT,
    SUM(CASE WHEN ES.MEMORY_SIZE       >= MEM_BYTE * 4  THEN MAP(BI.PCT_BASIS, 'COUNT', 1, 'SIZE', LENGTH(STATEMENT_STRING)) ELSE 0 END) MEM_4_CNT,
    SUM(CASE WHEN ES.MEMORY_SIZE       >= MEM_BYTE * 8  THEN MAP(BI.PCT_BASIS, 'COUNT', 1, 'SIZE', LENGTH(STATEMENT_STRING)) ELSE 0 END) MEM_8_CNT,
    SUM(CASE WHEN ES.MEMORY_SIZE       >= MEM_BYTE * 16 THEN MAP(BI.PCT_BASIS, 'COUNT', 1, 'SIZE', LENGTH(STATEMENT_STRING)) ELSE 0 END) MEM_16_CNT
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
      PCT_BASIS,
      AGGREGATE_BY
    FROM
    ( SELECT                                       /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        '%' HOST,
        '%' PORT,
        'SIZE' PCT_BASIS,
        'NONE' AGGREGATE_BY                   /* HOST, PORT or comma separated combinations, NONE for no aggregation */
      FROM
        DUMMY
    )
  ) BI,
    M_EXPENSIVE_STATEMENTS ES,
  ( SELECT
      MAX(MAP(KEY, 'threshold_duration', TO_NUMBER(IFNULL(HOST, IFNULL(DATABASE, IFNULL(SYSTEM, DEFAULT)))), -1)) DUR_US,
      MAX(MAP(KEY, 'threshold_cpu_time', TO_NUMBER(IFNULL(HOST, IFNULL(DATABASE, IFNULL(SYSTEM, DEFAULT)))), -1)) CPU_US,
      MAX(MAP(KEY, 'threshold_memory', TO_NUMBER(IFNULL(HOST, IFNULL(DATABASE, IFNULL(SYSTEM, DEFAULT)))), -1)) MEM_BYTE
    FROM
    ( SELECT
        KEY,
        MAX(MAP(LAYER_NAME, 'SYSTEM', VALUE)) SYSTEM,
        MAX(MAP(LAYER_NAME, 'DATABASE', VALUE)) DATABASE,
        MAX(MAP(LAYER_NAME, 'HOST', VALUE)) HOST,
        MAX(MAP(LAYER_NAME, 'DEFAULT', VALUE)) DEFAULT
      FROM
        M_INIFILE_CONTENTS
      WHERE
        SECTION = 'expensive_statement' AND
        KEY IN ( 'threshold_duration', 'threshold_cpu_time', 'threshold_memory' )
      GROUP BY
        KEY
    )
  ) P
  WHERE
    ES.START_TIME BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    ES.HOST LIKE BI.HOST AND
    TO_VARCHAR(ES.PORT) LIKE BI.PORT
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST') != 0 THEN ES.HOST             ELSE MAP(BI.HOST, '%', 'any', BI.HOST) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT') != 0 THEN TO_VARCHAR(ES.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT) END,
    P.DUR_US,
    P.CPU_US,
    P.MEM_BYTE,
    BI.PCT_BASIS
)
ORDER BY
  HOST,
  PORT
