SELECT
/* 

[NAME]

- HANA_Replication_SystemReplication_KeyFigures_Current_CommandGenerator

[DESCRIPTION]

- Collects load and throughput figures for SAP HANA system replication

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Command generator is required to collect snapshot values once

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/04/20:  1.0 (initial version)
- 2015/04/23:  1.1 (DATA_AVG_ACT_SHIP and DATA_SHIP_MB_PER_S included)

[INVOLVED TABLES]

- M_SERVICE_REPLICATION

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

- SITE_NAME

  Replication site name

  'ROT'           --> Specific replication site ROT
  '%'             --> All replication sites

- REPLICATION_MODE

  Replication mode

  'SYNC'          --> Only show information for replication mode SYNC
  '%'             --> No restriction related to replication mode

[OUTPUT PARAMETERS]

- BEGIN_TIME:           Begin time
- END_TIME:             End time (i.e. current timestamp)
- DATA_AVG_ACT_SHIP:    Average number of active data shippings
- DATA_SHIP_MB_PER_S:   Data shipping rate (MB / s) based on relative shipping time
- LOG_AVG_ACT_SHIP:     Average number of active log buffer shippings
- LOG_GEN_MB_PER_S:     Log buffer generation rate (MB / s) based on absolute time
- LOG_SHIP_MB_PER_S:    Log buffer shipping rate (MB / s) based on relative shipping time
                        Should be significantly higher than generation rate above, otherwise replication speed is at its limit
- LOG_AVG_SHIP_TIME_MS: Average log buffer shipping time (ms)

[EXAMPLE OUTPUT]

- Result is a SQL statement that considers the snapshot values and the current values:

--------------------------------------------------------------------------------------------------------------
|COMMAND                                                                                                     |
--------------------------------------------------------------------------------------------------------------
|SELECT                                                                                                      |
|  TO_VARCHAR(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS') BEGIN_TIME,                                                  |
|  TO_VARCHAR(END_TIME, 'YYYY/MM/DD HH24:MI:SS') END_TIME,                                                      |
|  LPAD(TO_DECIMAL(SHIPPED_LOG_BUFFERS_DURATION / 1000000 / SECONDS, 10, 2), 17) AVG_ACT_SHIPPINGS,          |
|  LPAD(TO_DECIMAL(SHIPPED_LOG_BUFFERS_SIZE / 1024 / 1024 / SECONDS, 10, 2), 17) GEN_RATE_MB_PER_S,          |
|  LPAD(TO_DECIMAL(IFNULL(MAP(SHIPPED_LOG_BUFFERS_DURATION, 0, 0, SHIPPED_LOG_BUFFERS_SIZE /                 |
|    SHIPPED_LOG_BUFFERS_DURATION / 1024 / 1024 * 1000 * 1000), 0), 10, 2), 18) SHIP_RATE_MB_PER_S,          |
|  LPAD(TO_DECIMAL(IFNULL(MAP(SHIPPED_LOG_BUFFERS_COUNT, 0, 0, SHIPPED_LOG_BUFFERS_DURATION / 1000 /         |
|    SHIPPED_LOG_BUFFERS_COUNT), 0), 10, 2), 16) AVG_SHIP_TIME_MS                                            |
|FROM                                                                                                        |
|( SELECT                                                                                                    |
|    CURRENT_TIMESTAMP END_TIME,                                                                             |
|    BI.BEGIN_TIME,                                                                                          |
|    SECONDS_BETWEEN(BI.BEGIN_TIME, CURRENT_TIMESTAMP) SECONDS,                                              |
|    SUM(R.SHIPPED_LOG_BUFFERS_SIZE) - MAX(BI.SHIPPED_LOG_BUFFERS_SIZE) SHIPPED_LOG_BUFFERS_SIZE,            |
|    SUM(R.SHIPPED_LOG_BUFFERS_DURATION) - MAX(BI.SHIPPED_LOG_BUFFERS_DURATION) SHIPPED_LOG_BUFFERS_DURATION,|
|    SUM(R.SHIPPED_LOG_BUFFERS_COUNT) - MAX(BI.SHIPPED_LOG_BUFFERS_COUNT) SHIPPED_LOG_BUFFERS_COUNT          |
|  FROM                                                                                                      |
|  ( SELECT                                                                                                  |
|      TO_TIMESTAMP(TO_VARCHAR('2015-04-20 12:44:31.4180000', 'YYYY/MM/DD HH24:MI:SS'                           |
|        ), 'YYYY/MM/DD HH24:MI:SS') BEGIN_TIME,                                                             |
|      615037968384 SHIPPED_LOG_BUFFERS_SIZE,                                                                |
|      75114251255 SHIPPED_LOG_BUFFERS_DURATION,                                                             |
|      39752356 SHIPPED_LOG_BUFFERS_COUNT                                                                    |
|    FROM                                                                                                    |
|      DUMMY                                                                                                 |
|  ) BI,                                                                                                     |
|    M_SERVICE_REPLICATION R                                                                                 |
|  WHERE                                                                                                     |
|    R.HOST LIKE '%' AND                                                                                     |
|    TO_VARCHAR(R.PORT) LIKE '%' AND                                                                            |
|    R.SITE_NAME LIKE '%' AND                                                                                |
|    R.REPLICATION_MODE LIKE '%'                                                                             |
|  GROUP BY                                                                                                  |
|    BI.BEGIN_TIME                                                                                           |
|)                                                                                                           |
--------------------------------------------------------------------------------------------------------------

- To calculate current key figures you have to execute the generated SQL statement:

-------------------------------------------------------------------------------------------------------------------------------------------------------
|BEGIN_TIME         |END_TIME           |DATA_AVG_ACT_SHIP|DATA_SHIP_MB_PER_S|LOG_AVG_ACT_SHIP|LOG_GEN_MB_PER_S|LOG_SHIP_MB_PER_S|LOG_AVG_SHIP_TIME_MS|
-------------------------------------------------------------------------------------------------------------------------------------------------------
|2015/04/23 18:50:59|2015/04/23 18:51:29|             0.00|              0.00|            0.49|            2.45|             4.95|                1.07|
-------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  COMMAND
FROM
( SELECT
    CASE LINE_NO
      WHEN   5 THEN 'SELECT'
      WHEN  10 THEN '  TO_VARCHAR(BEGIN_TIME, ' || CHAR(39) || 'YYYY/MM/DD HH24:MI:SS' || CHAR(39) || ') BEGIN_TIME,'
      WHEN  15 THEN '  TO_VARCHAR(END_TIME, ' || CHAR(39) || 'YYYY/MM/DD HH24:MI:SS' || CHAR(39) || ') END_TIME,'
      WHEN  16 THEN '  LPAD(TO_DECIMAL(SHIPPED_DELTA_REPLICA_DURATION / 1000000 / SECONDS, 10, 2), 17) DATA_AVG_ACT_SHIP,'
      WHEN  17 THEN '  LPAD(TO_DECIMAL(IFNULL(MAP(SHIPPED_DELTA_REPLICA_DURATION, 0, 0, SHIPPED_DELTA_REPLICA_SIZE /'
      WHEN  18 THEN '    SHIPPED_DELTA_REPLICA_DURATION / 1024 / 1024 * 1000 * 1000), 0), 10, 2), 18) DATA_SHIP_MB_PER_S,'
      WHEN  20 THEN '  LPAD(TO_DECIMAL(SHIPPED_LOG_BUFFERS_DURATION / 1000000 / SECONDS, 10, 2), 16) LOG_AVG_ACT_SHIP,'
      WHEN  25 THEN '  LPAD(TO_DECIMAL(SHIPPED_LOG_BUFFERS_SIZE / 1024 / 1024 / SECONDS, 10, 2), 16) LOG_GEN_MB_PER_S,'
      WHEN  30 THEN '  LPAD(TO_DECIMAL(IFNULL(MAP(SHIPPED_LOG_BUFFERS_DURATION, 0, 0, SHIPPED_LOG_BUFFERS_SIZE /'
      WHEN  31 THEN '    SHIPPED_LOG_BUFFERS_DURATION / 1024 / 1024 * 1000 * 1000), 0), 10, 2), 17) LOG_SHIP_MB_PER_S,'
      WHEN  35 THEN '  LPAD(TO_DECIMAL(IFNULL(MAP(SHIPPED_LOG_BUFFERS_COUNT, 0, 0, SHIPPED_LOG_BUFFERS_DURATION / 1000 /'
      WHEN  36 THEN '    SHIPPED_LOG_BUFFERS_COUNT), 0), 10, 2), 20) LOG_AVG_SHIP_TIME_MS'
      WHEN  40 THEN 'FROM'
      WHEN  45 THEN '( SELECT'
      WHEN  50 THEN '    CURRENT_TIMESTAMP END_TIME,'
      WHEN  55 THEN '    BI.BEGIN_TIME,'
      WHEN  60 THEN '    SECONDS_BETWEEN(BI.BEGIN_TIME, CURRENT_TIMESTAMP) SECONDS,'
      WHEN  62 THEN '    SUM(R.SHIPPED_DELTA_REPLICA_SIZE) - MAX(BI.SHIPPED_DELTA_REPLICA_SIZE) SHIPPED_DELTA_REPLICA_SIZE,'
      WHEN  63 THEN '    SUM(R.SHIPPED_DELTA_REPLICA_DURATION) - MAX(BI.SHIPPED_DELTA_REPLICA_DURATION) SHIPPED_DELTA_REPLICA_DURATION,'
      WHEN  65 THEN '    SUM(R.SHIPPED_LOG_BUFFERS_SIZE) - MAX(BI.SHIPPED_LOG_BUFFERS_SIZE) SHIPPED_LOG_BUFFERS_SIZE,'
      WHEN  70 THEN '    SUM(R.SHIPPED_LOG_BUFFERS_DURATION) - MAX(BI.SHIPPED_LOG_BUFFERS_DURATION) SHIPPED_LOG_BUFFERS_DURATION,'
      WHEN  75 THEN '    SUM(R.SHIPPED_LOG_BUFFERS_COUNT) - MAX(BI.SHIPPED_LOG_BUFFERS_COUNT) SHIPPED_LOG_BUFFERS_COUNT'
      WHEN  80 THEN '  FROM'
      WHEN  85 THEN '  ( SELECT'
      WHEN  90 THEN '      TO_TIMESTAMP(TO_VARCHAR(' || CHAR(39) || CURRENT_TIMESTAMP || CHAR(39) || ',' || CHAR(32) || CHAR(39) || 'YYYY/MM/DD HH24:MI:SS' || CHAR(39)
      WHEN  91 THEN '        ),' || CHAR(32) || CHAR(39) || 'YYYY/MM/DD HH24:MI:SS' || CHAR(39) || ') BEGIN_TIME,'
      WHEN  93 THEN LPAD(CHAR(32), 6) || SHIPPED_DELTA_REPLICA_SIZE || ' SHIPPED_DELTA_REPLICA_SIZE,'
      WHEN  94 THEN LPAD(CHAR(32), 6) || SHIPPED_DELTA_REPLICA_DURATION || ' SHIPPED_DELTA_REPLICA_DURATION,'
      WHEN  95 THEN LPAD(CHAR(32), 6) || SHIPPED_LOG_BUFFERS_SIZE || ' SHIPPED_LOG_BUFFERS_SIZE,'
      WHEN 100 THEN LPAD(CHAR(32), 6) || SHIPPED_LOG_BUFFERS_DURATION || ' SHIPPED_LOG_BUFFERS_DURATION,'
      WHEN 105 THEN LPAD(CHAR(32), 6) || SHIPPED_LOG_BUFFERS_COUNT || ' SHIPPED_LOG_BUFFERS_COUNT'
      WHEN 110 THEN '    FROM'
      WHEN 115 THEN '      DUMMY'
      WHEN 120 THEN '  ) BI,'
      WHEN 125 THEN '    M_SERVICE_REPLICATION R'
      WHEN 130 THEN '  WHERE'
      WHEN 135 THEN '    R.HOST LIKE' || CHAR(32) || CHAR(39) || BI_HOST || CHAR(39) || ' AND'
      WHEN 140 THEN '    TO_VARCHAR(R.PORT) LIKE' || CHAR(32) || CHAR(39) || BI_PORT || CHAR(39) || ' AND'
      WHEN 145 THEN '    R.SITE_NAME LIKE' || CHAR(32) || CHAR(39) || BI_SITE_NAME || CHAR(39) || ' AND'
      WHEN 150 THEN '    R.REPLICATION_MODE LIKE' || CHAR(32) || CHAR(39) || BI_REPLICATION_MODE || CHAR(39)
      WHEN 155 THEN '  GROUP BY'
      WHEN 160 THEN '    BI.BEGIN_TIME'
      WHEN 165 THEN ')'
    END COMMAND,
    LINE_NO
  FROM
  ( SELECT
      SUM(SHIPPED_LOG_BUFFERS_SIZE) SHIPPED_LOG_BUFFERS_SIZE,
      SUM(SHIPPED_LOG_BUFFERS_DURATION) SHIPPED_LOG_BUFFERS_DURATION,
      SUM(SHIPPED_LOG_BUFFERS_COUNT) SHIPPED_LOG_BUFFERS_COUNT,
      SUM(SHIPPED_DELTA_REPLICA_SIZE) SHIPPED_DELTA_REPLICA_SIZE,
      SUM(SHIPPED_DELTA_REPLICA_DURATION) SHIPPED_DELTA_REPLICA_DURATION,
      MAX(BI.HOST) BI_HOST,
      MAX(BI.PORT) BI_PORT,
      MAX(BI.SITE_NAME) BI_SITE_NAME,
      MAX(BI.REPLICATION_MODE) BI_REPLICATION_MODE
    FROM
    ( SELECT                        /* Modification section */
        '%' HOST,
        '%' PORT,
        '%' SITE_NAME,
        '%' REPLICATION_MODE
      FROM
        DUMMY
    ) BI,
      M_SERVICE_REPLICATION R
    WHERE
      R.HOST LIKE BI.HOST AND
      TO_VARCHAR(R.PORT) LIKE BI.PORT AND
      R.SITE_NAME LIKE BI.SITE_NAME AND
      R.REPLICATION_MODE LIKE BI.REPLICATION_MODE
  ),    
    ( SELECT TOP 200 ROW_NUMBER () OVER () LINE_NO FROM OBJECTS ) L
)
WHERE
  COMMAND IS NOT NULL
ORDER BY
  LINE_NO

