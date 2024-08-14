SELECT

/* 

[NAME]

- HANA_Resource_CPUAndMemory_CurrentDetails_2.00.020+

[DESCRIPTION]

- Current CPU and memory information (including details like interrupts or context switches)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_HOST_AGENT_METRICS available with SAP HANA >= 2.00.020
- Fails in SAP HANA Cloud (SHC) environments because host agent is no longer supported:

  invalid table name:  Could not find table/view M_HOST_AGENT_METRICS

[VALID FOR]

- Revisions:              >= 2.00.020

[SQL COMMAND VERSION]

- 2019/03/17:  1.0 (initial version)

[INVOLVED TABLES]

- M_HOST_AGENT_METRICS

[INPUT PARAMETERS]

- HOST

  Host name

  'saphana01'     --> Specific host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

[OUTPUT PARAMETERS]

- TIMESTAMP:          Timestamp
- HOST:               Host
- MEM_TOT_GB:         Total memory (GB)
- MEM_FREE_GB:        Free memory (GB)
- LOADAVG_1MIN:       CPU load average, i.e. average number of active CPUs (last minute)
- LOADAVG_5MIN:       CPU load average, i.e. average number of active CPUs (last 5 minutes)
- LOADAVG_15MIN:      CPU load average, i.e. average number of active CPUs (last 15 minutes)
- STEAL_PCT:          CPU steal time (%)
- CTX_SWITCHES_PER_S: Context switches per second
- INTERRUPTS_PER_S:   Interrupts per second

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------
|TIMESTAMP          |HOST    |MEM_TOT_GB|MEM_FREE_GB|LOADAVG_1MIN|LOADAVG_5MIN|LOADAVG_15MIN|STEAL_PCT|CTX_SWITCHES_PER_S|INTERRUPTS_PER_S|
-------------------------------------------------------------------------------------------------------------------------------------------
|2019/03/17 13:35:54|saphana1|   4650.21|    4666.20|       34.02|       30.83|        30.53|     0.00|         114764.32|        99421.56|
|2019/03/17 13:36:19|saphana2|  10205.65|   10251.83|       58.89|       53.72|        53.61|     0.00|         123579.03|       101253.58|
-------------------------------------------------------------------------------------------------------------------------------------------

*/

  TO_VARCHAR(R.TIMESTAMP, 'YYYY/MM/DD HH24:MI:SS') TIMESTAMP,
  R.HOST,
  LPAD(TO_DECIMAL(R.MEM_TOT_GB, 10, 2), 10) MEM_TOT_GB,
  LPAD(TO_DECIMAL(R.MEM_FREE_GB, 10, 2), 11) MEM_FREE_GB,
  LPAD(TO_DECIMAL(R.LOADAVG_1MIN, 10, 2), 12) LOADAVG_1MIN,
  LPAD(TO_DECIMAL(R.LOADAVG_5MIN, 10, 2), 12) LOADAVG_5MIN,
  LPAD(TO_DECIMAL(R.LOADAVG_15MIN, 10, 2), 13) LOADAVG_15MIN,
  LPAD(TO_DECIMAL(R.STEAL_PCT, 10, 2), 9) STEAL_PCT,
  LPAD(TO_DECIMAL(R.CTX_SWITCHES_PER_S, 10, 2), 18) CTX_SWITCHES_PER_S,
  LPAD(TO_DECIMAL(R.INTERRUPTS_PER_S, 10, 2), 16) INTERRUPTS_PER_S
FROM
( SELECT                    /* Modification section */
    '%' HOST
  FROM
    DUMMY
) BI,
( SELECT
    TIMESTAMP,
    HOST,
    MEM_TOT_KB / 1024 / 1024 MEM_TOT_GB,
    MEM_FREE_KB / 1024 / 1024 MEM_FREE_GB,
    LOADAVG_1MIN,
    LOADAVG_5MIN,
    LOADAVG_15MIN,
    STEAL_PCT,
    CTX_SWITCHES_PER_S,
    INTERRUPTS_PER_S
  FROM
  ( SELECT
      MAX(TIMESTAMP) TIMESTAMP,
      HOST,
      GREATEST(MAX(MAP(CAPTION, 'Visible Memory Size', TO_NUMBER(VALUE), 0)), MAX(MAP(CAPTION, 'Available Physical Memory', TO_NUMBER(VALUE), 0))) MEM_TOT_KB,
      MAX(MAP(CAPTION, 'Free Physical Memory', TO_NUMBER(VALUE), 0)) MEM_FREE_KB,
      MAX(MAP(CAPTION, 'Load Average 1 Minute', TO_NUMBER(VALUE), 0)) LOADAVG_1MIN,
      MAX(MAP(CAPTION, 'Load Average 5 Minutes', TO_NUMBER(VALUE), 0)) LOADAVG_5MIN,
      MAX(MAP(CAPTION, 'Load Average 15 Minutes', TO_NUMBER(VALUE), 0)) LOADAVG_15MIN,
      MAX(MAP(CAPTION, 'Steal Time', TO_NUMBER(VALUE), 0)) STEAL_PCT,
      MAX(MAP(CAPTION, 'Context Switch Rate', TO_NUMBER(VALUE), 0)) CTX_SWITCHES_PER_S,
      MAX(MAP(CAPTION, 'Interrupt Rate', TO_NUMBER(VALUE), 0)) INTERRUPTS_PER_S
    FROM
      M_HOST_AGENT_METRICS
    WHERE
      MEASURED_ELEMENT_TYPE = 'OperatingSystem'
    GROUP BY
      HOST
  )
) R
WHERE
  R.HOST LIKE BI.HOST
ORDER BY
  HOST