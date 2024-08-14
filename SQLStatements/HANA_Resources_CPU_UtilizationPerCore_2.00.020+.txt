SELECT

/* 

[NAME]

- HANA_Resources_CPU_UtilizationPerCore_2.00.020+

[DESCRIPTION]

- CPU activity on a socket / NUMA node basis

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_HOST_AGENT_METRICS available with SAP HANA >= 2.00.020
- M_HOST_AGENT_METRICS data may not be available for slave nodes with SAP HANA <= 2.00.035
- Fails in SAP HANA Cloud (SHC) environments because host agent is no longer supported:

  invalid table name:  Could not find table/view M_HOST_AGENT_METRICS

[VALID FOR]

- Revisions:              >= 2.00.020

[SQL COMMAND VERSION]

- 2019/03/17:  1.0 (initial version)
- 2020/09/24:  1.1 (CPU_THREADS added)

[INVOLVED TABLES]

- M_HOST_AGENT_METRICS
- M_NUMA_NODES

[INPUT PARAMETERS]

- HOST

  Host name

  'saphana01'     --> Specific host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- NUMA_NODE

  NUMA node

  4               --> Display information for NUMA node 4
  -1              --> No restriction related to NUMA node

- CORE

  Physical (or logical in case of hyperthreading) CPU core

  19              --> Restrict results to CPU core 19
  -1              --> No restriction related to CPU core

- MIN_BUSY_PCT

  Minimum threshold for busy percentage

  70              --> Only consider results with at least 70 % busy time
  -1              --> No restriction related to busy percentage

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'CPU'             --> Aggregation by CPU
  'HOST, NUMA_NODE' --> Aggregation by host and NUMA node
  'NONE'            --> No aggregation

  Sort criteria (available values are provided in comment)

  'BUSY'          --> Sorting by busy percentage
  'NUMA_NODE'     --> Sorting by NUMA node

[OUTPUT PARAMETERS]

- TIMESTAMP:  Check timestamp
- HOST:       Host
- CORE:       Physical (or in case of hyperthreading logical) CPU core
- NUMA_NODE:  NUMA node
- USER_PCT:   User CPU (%)
- SYSTEM_PCT: System CPU (%)
- WAITIO_PCT: Wait I/O CPU (%)
- BUSY_PCT:   Busy CPU (%)
- IDLE_PCT:   Idle CPU (%)

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------
|HOST   |CORE|NUMA_NODE|USER_PCT|SYSTEM_PCT|WAITIO_PCT|BUSY_PCT |IDLE_PCT |
---------------------------------------------------------------------------
|saphana| any|       10|    4.27|      0.41|      0.00|     4.69|    95.30|
|saphana| any|        2|    4.20|      0.11|      0.00|     4.31|    95.68|
|saphana| any|        7|    3.00|      0.53|      0.00|     3.53|    96.46|
|saphana| any|        0|    2.94|      0.18|      0.00|     3.12|    96.86|
|saphana| any|       17|    2.42|      0.60|      0.00|     3.02|    96.97|
|saphana| any|       20|    2.32|      0.41|      0.00|     2.74|    97.25|
|saphana| any|       15|    2.33|      0.38|      0.00|     2.71|    97.28|
|saphana| any|       16|    1.79|      0.37|      0.00|     2.16|    97.83|
|saphana| any|       21|    1.86|      0.28|      0.00|     2.15|    97.84|
---------------------------------------------------------------------------

*/

  TO_VARCHAR(TIMESTAMP, 'YYYY/MM/DD HH24:MI:SS') TIMESTAMP,
  HOST,
  LPAD(NUMA_NODE, 9) NUMA_NODE,
  LPAD(CPU_THREADS, 11) CPU_THREADS,
  LPAD(CORE, 4) CORE,
  LPAD(TO_DECIMAL(USER_PCT, 10, 2), 8) USER_PCT,
  LPAD(TO_DECIMAL(SYSTEM_PCT, 10, 2), 10) SYSTEM_PCT,
  LPAD(TO_DECIMAL(WAITIO_PCT, 10, 2), 10) WAITIO_PCT,
  LPAD(TO_DECIMAL(BUSY_PCT, 10, 2), 9) BUSY_PCT,
  LPAD(TO_DECIMAL(IDLE_PCT, 10, 2), 9) IDLE_PCT
FROM
( SELECT
    MAX(TIMESTAMP) TIMESTAMP,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')      != 0 THEN C.HOST                  ELSE MAP(BI.HOST,     '%', 'any', BI.HOST)                  END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CPU')       != 0 THEN C.CORE                  ELSE MAP(BI.CORE,      -1, 'any', TO_VARCHAR(BI.CORE))      END CORE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'NUMA_NODE') != 0 THEN TO_VARCHAR(N.NUMA_NODE) ELSE MAP(BI.NUMA_NODE, -1, 'any', TO_VARCHAR(BI.NUMA_NODE)) END NUMA_NODE,
    AVG(USER_PCT) USER_PCT,
    AVG(SYSTEM_PCT) SYSTEM_PCT,
    AVG(WAITIO_PCT) WAITIO_PCT,
    AVG(BUSY_PCT) BUSY_PCT,
    AVG(IDLE_PCT) IDLE_PCT,
    COUNT(*) CPU_THREADS,
    BI.MIN_BUSY_PCT,
    BI.ORDER_BY
  FROM
  ( SELECT                       /* Modification section */
      '%' HOST,
      -1 NUMA_NODE,
      -1 CORE,
      -1 MIN_BUSY_PCT,
      'HOST, NUMA_NODE' AGGREGATE_BY,       /* HOST, CPU, NUMA_NODE or comma separated combinations, NONE for no aggregation */
      'BUSY' ORDER_BY            /* IDLE, BUSY, USER, SYSTEM, WAITIO, HOST, CORE, NUMA_NODE */
    FROM
      DUMMY
  ) BI,
  ( SELECT
      MAX(TIMESTAMP) TIMESTAMP,
      HOST,
      MEASURED_ELEMENT_NAME CORE,
      SUM(MAP(CAPTION, 'User Time', TO_NUMBER(VALUE), 0)) USER_PCT,
      SUM(MAP(CAPTION, 'System Time', TO_NUMBER(VALUE), 0)) SYSTEM_PCT,
      SUM(MAP(CAPTION, 'Wait Time', TO_NUMBER(VALUE), 0)) WAITIO_PCT,
      SUM(MAP(CAPTION, 'Idle Time', 0, TO_NUMBER(VALUE))) BUSY_PCT,
      SUM(MAP(CAPTION, 'Idle Time', TO_NUMBER(VALUE), 0)) IDLE_PCT
    FROM
      M_HOST_AGENT_METRICS
    WHERE
      MEASURED_ELEMENT_TYPE = 'Processor'
    GROUP BY
      HOST,
      MEASURED_ELEMENT_NAME
  ) C LEFT OUTER JOIN
  ( SELECT
      HOST,
      NUMA_NODE,
      CASE WHEN LOCATE(LOGICAL_CORE_IDS, '-') = 0 THEN TO_NUMBER(LOGICAL_CORE_IDS) ELSE TO_NUMBER(SUBSTR(LOGICAL_CORE_IDS, 1, LOCATE(LOGICAL_CORE_IDS, '-') - 1)) END MIN_CORE,
      CASE WHEN LOCATE(LOGICAL_CORE_IDS, '-') = 0 THEN TO_NUMBER(LOGICAL_CORE_IDS) ELSE TO_NUMBER(SUBSTR(LOGICAL_CORE_IDS, LOCATE(LOGICAL_CORE_IDS, '-') + 1)) END MAX_CORE
    FROM
    ( SELECT
        N.HOST,
        N.NUMA_NODE,
        SUBSTR(N.LOGICAL_CORE_IDS, LOCATE(N.LOGICAL_CORE_IDS, ',', 0, L.LNO) + 1, LOCATE(N.LOGICAL_CORE_IDS, ',', 0, L.LNO + 1) - LOCATE(N.LOGICAL_CORE_IDS, ',', 0, L.LNO) - 1) LOGICAL_CORE_IDS
      FROM
      ( SELECT TOP 200 ROW_NUMBER() OVER () LNO FROM OBJECTS ) L,
      ( SELECT DISTINCT
          HOST,
          NUMA_NODE_ID NUMA_NODE,
          ',' || LOGICAL_CORE_IDS || ',' LOGICAL_CORE_IDS
        FROM
          M_NUMA_NODES
      ) N
    )
    WHERE
      LOGICAL_CORE_IDS != ''
  ) N ON
    C.HOST = N.HOST AND
    C.CORE BETWEEN N.MIN_CORE AND N.MAX_CORE
  WHERE
    C.HOST LIKE BI.HOST AND
    ( BI.CORE = -1 OR C.CORE LIKE TO_VARCHAR(BI.CORE)) AND
    ( BI.NUMA_NODE = -1 OR N.NUMA_NODE = BI.NUMA_NODE )
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')      != 0 THEN C.HOST                  ELSE MAP(BI.HOST,     '%', 'any', BI.HOST)                  END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CPU')       != 0 THEN C.CORE                  ELSE MAP(BI.CORE,      -1, 'any', TO_VARCHAR(BI.CORE))      END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'NUMA_NODE') != 0 THEN TO_VARCHAR(N.NUMA_NODE) ELSE MAP(BI.NUMA_NODE, -1, 'any', TO_VARCHAR(BI.NUMA_NODE)) END,
    BI.MIN_BUSY_PCT,
    BI.ORDER_BY
)
WHERE
  ( MIN_BUSY_PCT = -1 OR BUSY_PCT >= MIN_BUSY_PCT ) 
ORDER BY
  MAP(ORDER_BY, 'IDLE', IDLE_PCT),
  MAP(ORDER_BY, 'USER', USER_PCT, 'SYSTEM', SYSTEM_PCT, 'WAITIO', WAITIO_PCT, 'BUSY', BUSY_PCT) DESC,
  MAP(ORDER_BY, 'HOST', HOST, 'NUMA_NODE', NUMA_NODE),
  CORE
