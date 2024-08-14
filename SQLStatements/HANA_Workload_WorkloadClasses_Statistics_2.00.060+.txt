SELECT

/* 

[NAME]

- HANA_Workload_WorkloadClasses_Statistics_2.00.060+

[DESCRIPTION]

- Overview of workload class statistics

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_WORKLOAD_CLASS_STATISTICS available with SAP HANA >= 2.00.060

[VALID FOR]

- Revisions:              >= 2.00.060

[SQL COMMAND VERSION]

- 2022/10/23:  1.0 (initial version)

[INVOLVED TABLES]

- M_WORKLOAD_CLASS_STATISTICS

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

- WORKLOAD_CLASS

  Workload class name

  'WLC_100'       --> Display threads running in the context of workload class WLC_100
  '%'             --> No restriction related to workload class

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'WORKLOAD_CLASS' --> Aggregation by workload class name
  'HOST, PORT'     --> Aggregation by host and port
  'NONE'           --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'MEMORY'        --> Sorting by total statement memory consumption
  'TIMEOUT_COUNT' --> Sorting by number of timeouts

[OUTPUT PARAMETERS]

- HOST:           Host name
- PORT:           Port
- WORKLOAD_CLASS: Workload class name
- MEM_GB:         Overall statement memory usage (GB)
- CPU_S:          Overall statement CPU consumption (s)
- ADMIT_COUNT:    Admission control admit count
- MEM_PER_REQ_MB: Statement memory usage per request (MB)
- CPU_PER_REQ_MS: CPU consumption per request (ms)
- REJECT_COUNT:   Admission control reject count
- ENQUEUE_COUNT:  Admission control enqueue count
- DEQUEUE_COUNT:  Admission control dequeue count
- TIMEOUT_COUNT:  Statement timeout count
- CNT:            Number of aggregated view records

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST  |PORT |WORKLOAD_CLASS          |MEM_GB  |CPU_S   |ADMIT_COUNT|MEM_PER_REQ_MB|CPU_PER_REQ_MS|REJECT_COUNT|ENQUEUE_COUNT|DEQUEUE_COUNT|TIMEOUT_COUNT|CNT  |
----------------------------------------------------------------------------------------------------------------------------------------------------------------
|hana01|30240|WLC_APPUSER_SD_BATCH    |80975.83|  291585|  172285522|          0.48|          1.69|           0|            0|            0|            0|    1|
|hana01|30240|WLC_APPUSER_SAP_JOBREPO |211430.8|   18466|   16160857|         13.39|          1.14|           0|            0|            0|            0|    1|
|hana01|30240|WLC_APPUSER_D111111     |171953.9|   10735|   17805710|          9.88|          0.60|           0|            0|            0|            0|    1|
|hana01|30240|WLC_FELIPE              | 8714.52|  103475|      40242|        221.75|       2571.32|           0|            0|            0|            0|    1|
|hana01|30240|WLC_APPUSER_D222222     | 7345.21|   72250|   14691621|          0.51|          4.91|           0|            0|            0|            0|    1|
|hana01|30240|WLC_APPUSER_D333333     | 2992.26|   28985|    8656050|          0.35|          3.34|           0|            0|            0|            0|    1|
|hana01|30240|WLC_APPUSER_I444444     | 1647.64|    1467|     404807|          4.16|          3.62|           0|            0|            0|            0|    1|
|hana01|30240|WLC_APPUSER_D555555     | 1618.62|    7798|    1572436|          1.05|          4.95|           0|            0|            0|            0|    1|
|hana01|30240|WLC_APL_SAP_DS_HDI      | 1435.53|   54999|     106528|         13.79|        516.29|           0|            0|            0|            0|    1|
|hana01|30240|WLC_APPUSER_HYBILL_BATCH| 1032.50|    2587|    2667224|          0.39|          0.97|           0|            0|            0|            0|    1|
|hana01|30240|WLC_APPUSER_PI1_ARIBA   | 1026.06|   62878|      15075|         69.69|       4171.07|           0|            0|            0|            0|    1|
|hana01|30240|WLC_APPUSER_D666666     |  919.79|    9566|     786889|          1.19|         12.15|           0|            0|            0|            0|    1|
|hana01|30240|WLC_APPUSER_C777777     |  799.54|    1237|    2102002|          0.38|          0.58|           0|            0|            0|            0|    1|
|hana01|30240|WLC_APPUSER_D888888     |  654.42|   27835|       4305|        155.66|       6465.91|           0|            0|            0|            0|    1|
|hana01|30240|WLC_APPUSER_I999999     |  568.90|    7747|      84898|          6.86|         91.25|           0|            0|            0|            0|    1|
----------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  WORKLOAD_CLASS,
  LPAD(TO_DECIMAL(MEM_GB, 10, 2), 8) MEM_GB,
  LPAD(TO_DECIMAL(CPU_S, 10, 0), 8) CPU_S,
  LPAD(ADMIT_COUNT, 11) ADMIT_COUNT,
  LPAD(TO_DECIMAL(MAP(ADMIT_COUNT, 0, 0, MEM_GB / ADMIT_COUNT) * 1024, 10, 2), 14) MEM_PER_REQ_MB,
  LPAD(TO_DECIMAL(MAP(ADMIT_COUNT, 0, 0, CPU_S / ADMIT_COUNT) * 1000, 10, 2), 14) CPU_PER_REQ_MS,
  LPAD(REJECT_COUNT, 12) REJECT_COUNT,
  LPAD(ENQUEUE_COUNT, 13) ENQUEUE_COUNT,
  LPAD(DEQUEUE_COUNT, 13) DEQUEUE_COUNT,
  LPAD(TIMEOUT_COUNT, 13) TIMEOUT_COUNT,
  LPAD(CNT, 5) CNT
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')           != 0 THEN WCS.HOST                ELSE MAP(BI.HOST,           '%', 'any', BI.HOST)           END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')           != 0 THEN TO_VARCHAR(WCS.PORT)    ELSE MAP(BI.PORT,           '%', 'any', BI.PORT)           END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'WORKLOAD_CLASS') != 0 THEN WCS.WORKLOAD_CLASS_NAME ELSE MAP(BI.WORKLOAD_CLASS, '%', 'any', BI.WORKLOAD_CLASS) END WORKLOAD_CLASS,
    SUM(WCS.TOTAL_STATEMENT_MEMORY_SIZE) / 1024 / 1024 / 1024 MEM_GB,
    SUM(WCS.TOTAL_STATEMENT_CPU_TIME) / 1000000 CPU_S,
    SUM(WCS.TOTAL_STATEMENT_ADMIT_COUNT) ADMIT_COUNT,
    SUM(WCS.TOTAL_STATEMENT_REJECT_COUNT) REJECT_COUNT,
    SUM(WCS.TOTAL_STATEMENT_ENQUEUE_COUNT) ENQUEUE_COUNT,
    SUM(WCS.TOTAL_STATEMENT_DEQUEUE_COUNT) DEQUEUE_COUNT,
    SUM(WCS.TOTAL_STATEMENT_TIMEOUT_COUNT) TIMEOUT_COUNT,
    COUNT(*) CNT,
    BI.ORDER_BY
  FROM
  ( SELECT                /* Modification section */
      '%' HOST,
      '%' PORT,
      '%' WORKLOAD_CLASS,
      'NONE' AGGREGATE_BY,                /* HOST, PORT, WORKLOAD_CLASS or comma-separated combinations, NONE for no aggregation */
      'MEMORY' ORDER_BY                /* MEMORY, CPU, ADMIT_COUNT, REJECT_COUNT, ENQUEUE_COUNT, TIMEOUT_COUNT */
    FROM
      DUMMY	
  ) BI,
    M_WORKLOAD_CLASS_STATISTICS WCS
  WHERE
    WCS.HOST LIKE BI.HOST AND
    TO_VARCHAR(WCS.PORT) LIKE BI.PORT AND
    UPPER(WCS.WORKLOAD_CLASS_NAME) LIKE UPPER(BI.WORKLOAD_CLASS)
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')           != 0 THEN WCS.HOST                ELSE MAP(BI.HOST,           '%', 'any', BI.HOST)           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')           != 0 THEN TO_VARCHAR(WCS.PORT)    ELSE MAP(BI.PORT,           '%', 'any', BI.PORT)           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'WORKLOAD_CLASS') != 0 THEN WCS.WORKLOAD_CLASS_NAME ELSE MAP(BI.WORKLOAD_CLASS, '%', 'any', BI.WORKLOAD_CLASS) END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'MEMORY', MEM_GB, 'CPU', CPU_S, 'ADMIT_COUNT', ADMIT_COUNT, 'REJECT_COUNT', REJECT_COUNT, 'ENQUEUE_COUNT', ENQUEUE_COUNT, 'TIMEOUT_COUNT', TIMEOUT_COUNT) DESC
