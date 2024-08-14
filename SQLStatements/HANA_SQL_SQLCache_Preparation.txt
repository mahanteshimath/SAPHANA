WITH 

/* 

[NAME]

- HANA_SQL_SQLCache_Preparation

[DESCRIPTION]

- Overview information related to preparation time

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/01/28:  1.0 (initial version)
- 2023/05/04:  1.1 (DATA_SOURCE included)

[INVOLVED TABLES]

- M_SQL_PLAN_CACHE
- M_SQL_PLAN_CACHE_RESET
- M_SQL_PLAN_STATISTICS

[INPUT PARAMETERS]

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

  'CURRENT'       --> Data from memory information (M_* tables)
  'RESET'         --> Data from reset memory information (M_*_RESET tables)
  'STATISTICS'    --> Data from current and evicted SQL cache (M_SQL_PLAN_STATISTICS)

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOST'          --> Aggregation by host
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

-[OUTPUT PARAMETERS]

- HOST:                 Host name
- PORT:                 Port
- SQLS:                 Number of statements
- EXEC_PER_SQL:         Average number of executions per statement
- ELAPSED_S:            Total elapsed time (s)
- ELA_PER_EXEC_MS:      Elapsed time per execution (ms)
- PREP_S:               Total preparation time (s)
- PREP_PER_EXEC_MS:     Preparation time per execution (ms)
- PREP_PCT:             Contribution of preparation time to total elapsed time (%)

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------------
|HOST        |PORT |SQLS    |EXEC_PER_SQL|ELAPSED_S|ELA_PER_EXEC_MS|PREP_S|PREP_PER_EXEC_MS|PREP_PCT|
-----------------------------------------------------------------------------------------------------
|saphanahost1|30603|   66043|      513.14|    38074|           1.12|  7021|            0.20|   18.44|
|saphanahost1|30605|     167|        0.00|        0|           0.00|     0|            0.00|    0.00|
|saphanahost1|30607|     157|        2.10|       67|         202.63|    12|           35.23|   17.38|
-----------------------------------------------------------------------------------------------------

*/

BASIS_INFO AS
( SELECT                /* Modification section */
    '%' HOST,
    '%' PORT,
    'STATISTICS' DATA_SOURCE,      /* CURRENT, RESET, STATISTICS */
    'NONE' AGGREGATE_BY            /* HOST, PORT or comma separated list, NONE for no aggregation */
  FROM
    DUMMY
)
SELECT
  HOST,
  PORT,
  LPAD(STATEMENTS, 8) SQLS,
  LPAD(TO_DECIMAL(MAP(STATEMENTS, 0, 0, EXECUTIONS / STATEMENTS), 10, 2), 12) EXEC_PER_SQL,
  LPAD(TO_DECIMAL(ROUND(TOTAL_TIME_S), 10, 0), 9) ELAPSED_S,
  LPAD(TO_DECIMAL(MAP(EXECUTIONS, 0, 0, TOTAL_TIME_S / EXECUTIONS * 1000), 10, 2), 15) ELA_PER_EXEC_MS,
  LPAD(TO_DECIMAL(ROUND(PREP_TIME_S), 10, 0), 6) PREP_S,
  LPAD(TO_DECIMAL(MAP(EXECUTIONS, 0, 0, PREP_TIME_S / EXECUTIONS * 1000), 10, 2), 16) PREP_PER_EXEC_MS,
  LPAD(TO_DECIMAL(MAP(TOTAL_TIME_S, 0, 0, PREP_TIME_S / TOTAL_TIME_S * 100 ), 10, 2), 8) PREP_PCT
FROM
( SELECT
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST') != 0 THEN HOST             ELSE MAP(BI_HOST, '%', 'any', BI_HOST) END HOST,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT') != 0 THEN TO_VARCHAR(PORT) ELSE MAP(BI_PORT, '%', 'any', BI_PORT) END PORT,
    COUNT(*) STATEMENTS,
    SUM(EXECUTION_COUNT) EXECUTIONS,
    ( SUM(TOTAL_EXECUTION_TIME) + SUM(TOTAL_PREPARATION_TIME) ) / 1000000 TOTAL_TIME_S,
    SUM(TOTAL_EXECUTION_TIME) / 1000000 EXEC_TIME_S,
    SUM(TOTAL_PREPARATION_TIME) / 1000000 PREP_TIME_S
  FROM
  ( SELECT
      S.HOST,
      S.PORT,
      S.EXECUTION_COUNT,
      S.TOTAL_EXECUTION_TIME,
      S.TOTAL_PREPARATION_TIME,
      BI.AGGREGATE_BY,
      BI.HOST BI_HOST,
      BI.PORT BI_PORT
    FROM
      BASIS_INFO BI,
      M_SQL_PLAN_CACHE S
    WHERE
      BI.DATA_SOURCE = 'CURRENT' AND
      S.HOST LIKE BI.HOST AND
      TO_VARCHAR(S.PORT) LIKE BI.PORT
    UNION ALL
    SELECT
      S.HOST,
      S.PORT,
      S.EXECUTION_COUNT,
      S.TOTAL_EXECUTION_TIME,
      S.TOTAL_PREPARATION_TIME,
      BI.AGGREGATE_BY,
      BI.HOST BI_HOST,
      BI.PORT BI_PORT
    FROM
      BASIS_INFO BI,
      M_SQL_PLAN_CACHE_RESET S
    WHERE
      BI.DATA_SOURCE = 'RESET' AND
      S.HOST LIKE BI.HOST AND
      TO_VARCHAR(S.PORT) LIKE BI.PORT
    UNION ALL
    SELECT
      S.HOST,
      S.PORT,
      S.EXECUTION_COUNT,
      S.TOTAL_EXECUTION_TIME,
      S.TOTAL_PREPARATION_TIME,
      BI.AGGREGATE_BY,
      BI.HOST BI_HOST,
      BI.PORT BI_PORT
    FROM
      BASIS_INFO BI,
      M_SQL_PLAN_STATISTICS S
    WHERE
      BI.DATA_SOURCE = 'STATISTICS' AND
      S.HOST LIKE BI.HOST AND
      TO_VARCHAR(S.PORT) LIKE BI.PORT
  )
  GROUP BY
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST') != 0 THEN HOST             ELSE MAP(BI_HOST, '%', 'any', BI_HOST) END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT') != 0 THEN TO_VARCHAR(PORT) ELSE MAP(BI_PORT, '%', 'any', BI_PORT) END
)
