SELECT
/* 

[NAME]

- HANA_Logs_LogBuffers

[DESCRIPTION]

- Log buffer overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- RESET can be performed via:

  ALTER SYSTEM RESET MONITORING VIEW M_LOG_BUFFERS_RESET

- Can be used for monitoring remote system replication sites, see SAP Note 1999880 
  ("Is it possible to monitor remote system replication sites on the primary system") for details.

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/06/23:  1.0 (initial version)
- 2015/05/12:  1.1 (M_LOG_BUFFERS_RESET included)

[INVOLVED TABLES]

- M_LOG_BUFFERS
- M_LOG_BUFFERS_RESET

[INPUT PARAMETERS]

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

- MIN_WAIT_PCT

  Minimum threshold for buffer switches being blocked on semaphore (%)

  1               --> Only display log buffers with at least 1 % of switches blocked via semaphore
  -1              --> No restriction related to blocked switches

- MIN_RACE_PCT

  Minimum threshold for buffer switch race conditions (%)

  1               --> Only display log buffers with at least 1 % of switches with race conditions
  -1              --> No restriction related to switches with race conditions

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_* tables)
  'RESET'         --> Data from reset information (*_RESET tables)

[OUTPUT PARAMETERS]

- HOST:            Host name
- PORT:            Port
- LOG_MODE:        Log mode
- LOG_BUFFER_MB:   Size of configured log buffers (MB)
- BUFFERS:         Number of configured log buffers
- LOG_SEG_MB:      Log segment size (MB)
- BUFFER_SWITCHES: Number of buffer switches
- WAIT_PCT:        Log buffer switch wait count (%), i.e. percentage of log switches blocked by semaphores
- RACE_PCT:        Log buffer switch race count (%), i.e. percentage of log switches with race condition

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------
|HOST  |PORT |LOG_MODE|LOG_BUFFER_MB|BUFFERS|LOG_SEG_GB|BUFFER_SWITCHES|WAIT_PCT|RACE_PCT|
------------------------------------------------------------------------------------------
|hana01|30003|normal  |         1.00|      8|      1.00|        6636062|    0.13|    0.00|
|hana02|30003|normal  |         1.00|      8|      1.00|       24799342|    0.00|    0.00|
|hana02|30005|normal  |         1.00|      8|      0.06|          49296|    0.20|    0.00|
|hana02|30007|normal  |         1.00|      8|      0.00|            349|    0.00|    0.00|
|hana03|30003|normal  |         1.00|      8|      1.00|         704232|    4.63|    0.00|
|hana04|30003|normal  |         1.00|      8|      1.00|         343112|    3.25|    0.00|
|hana05|30003|normal  |         1.00|      8|      1.00|        2248149|    0.37|    0.00|
|hana06|30003|normal  |         1.00|      8|      1.00|         449169|    0.82|    0.00|
|hana07|30003|normal  |         1.00|      8|      1.00|        1745528|    0.59|    0.00|
|hana08|30003|normal  |         1.00|      8|      1.00|         735911|    4.45|    0.00|
|hana09|30003|normal  |         1.00|      8|      1.00|         297523|    4.86|    0.00|
|hana10|30003|normal  |         1.00|      8|      1.00|         692245|    2.58|    0.00|
------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  LOG_MODE,
  LPAD(TO_DECIMAL(LOG_BUFFER_MB, 10, 2), 13) LOG_BUFFER_MB,
  LPAD(BUFFERS, 7) BUFFERS,
  LPAD(TO_DECIMAL(ROUND(LOG_SEG_MB), 10, 0), 10) LOG_SEG_MB,
  LPAD(BUFFER_SWITCHES, 15) BUFFER_SWITCHES,
  LPAD(TO_DECIMAL(WAIT_PCT, 10, 2), 8) WAIT_PCT,
  LPAD(TO_DECIMAL(RACE_PCT, 10, 2), 8) RACE_PCT
FROM
( SELECT
    L.HOST,
    L.PORT,
    L.LOG_MODE,
    L.BUFFER_SIZE / 1024 LOG_BUFFER_MB,
    L.BUFFER_COUNT BUFFERS,
    L.SEGMENT_SIZE LOG_SEG_MB,
    L.SWITCH_NOWAIT_COUNT + L.SWITCH_WAIT_COUNT BUFFER_SWITCHES,
    MAP(L.SWITCH_NOWAIT_COUNT + L.SWITCH_WAIT_COUNT, 0, 0, L.SWITCH_WAIT_COUNT / (L.SWITCH_NOWAIT_COUNT + L.SWITCH_WAIT_COUNT) * 100) WAIT_PCT,
    MAP(L.SWITCH_NOWAIT_COUNT + L.SWITCH_WAIT_COUNT, 0, 0, L.SWITCH_OPEN_COUNT / (L.SWITCH_NOWAIT_COUNT + L.SWITCH_WAIT_COUNT) * 100) RACE_PCT,
    BI.MIN_WAIT_PCT,
    BI.MIN_RACE_PCT
  FROM
  ( SELECT                  /* Modification section */
      '%' HOST,
      '%' PORT,
      -1 MIN_WAIT_PCT,
      -1 MIN_RACE_PCT,
      'CURRENT' DATA_SOURCE
    FROM
      DUMMY
  ) BI,
  ( SELECT
      'CURRENT' DATA_SOURCE,
      HOST,
      PORT,
      LOG_MODE,
      BUFFER_SIZE,
      BUFFER_COUNT,
      SEGMENT_SIZE,
      SWITCH_NOWAIT_COUNT,
      SWITCH_WAIT_COUNT,
      SWITCH_OPEN_COUNT
    FROM
      M_LOG_BUFFERS
    UNION ALL
    SELECT
      'RESET' DATA_SOURCE,
      HOST,
      PORT,
      LOG_MODE,
      BUFFER_SIZE,
      BUFFER_COUNT,
      SEGMENT_SIZE,
      SWITCH_NOWAIT_COUNT,
      SWITCH_WAIT_COUNT,
      SWITCH_OPEN_COUNT
    FROM
      M_LOG_BUFFERS_RESET
  ) L
  WHERE
    L.HOST LIKE BI.HOST AND
    TO_VARCHAR(L.PORT) LIKE BI.PORT AND
    L.DATA_SOURCE = BI.DATA_SOURCE
)
WHERE
  ( MIN_WAIT_PCT = -1 AND MIN_RACE_PCT = -1 OR
    MIN_WAIT_PCT != -1 AND WAIT_PCT >= MIN_WAIT_PCT OR
    MIN_RACE_PCT != -1 AND RACE_PCT >= MIN_RACE_PCT 
  )
ORDER BY
  HOST,
  PORT
