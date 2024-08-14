SELECT
/* 

[NAME]

HANA_Replication_SystemReplication_Overview_1.00.120+

[DESCRIPTION]

- General system replication information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_SYSTEM_REPLICATION only available with SAP HANA 1.0 SPS 12 and higher

[VALID FOR]

- Revisions:              >= 1.00.120

[SQL COMMAND VERSION]

- 2014/03/14:  1.0 (initial version)
- 2014/03/29:  1.1 (included local log and backup information)
- 2016/02/18:  1.2 (SERVICE_NAME included)
- 2016/10/11:  1.3 (SERVICE_NAME removed as it does not work for multi-tier environments)
- 2017/03/01:  1.4 (LAST_SAVEPOINT_START_TIME included)
- 2017/10/25:  1.5 (TIMEZONE included)
- 2017/12/12:  1.6 (OPERATION_MODE added)
- 2018/06/22:  1.7 ([inifile_checker] -> replicate added)
- 2023/02/25:  1.8 ([system_replication_communication] parameters added)

[INVOLVED TABLES]

- M_SERVICE_REPLICATION
- M_SYSTEM_REPLICATION
- M_VOLUME_IO_TOTAL_STATISTICS

[INPUT PARAMETERS]

- TIMEZONE

  Used timezone (both for input and output parameters)

  'SERVER'       --> Display times in SAP HANA server time
  'UTC'          --> Display times in UTC time

- SITE_NAME

  Replication site name

  'ROT'           --> Specific replication site ROT
  '%'             --> All replication sites

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

- SUPPRESS_ZERO_LINES

  Controls the display of lines with zero time values in the output

  'X'             --> No lines with zero time values
  ' '             --> Lines with zero time values are included

[OUTPUT PARAMETERS]

- REPLICATION_PATH: Source and target site of replication
- HOSTS:            Source and target host of replication
- PORT:             Port
- KEY:              Description of provided information
- VALUE:            Value related to description

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------------------------------------
|REPLICATION_PATH          |HOSTS                     |PORT    |KEY                                     |VALUE              |
-----------------------------------------------------------------------------------------------------------------------------
|saphana0152 -> saphana0151|saphana0152 -> saphana0151|30003   |Replication mode                        |SYNC               |
|                          |                          |        |Secondary connect time                  |2016/10/18 13:00:36|
|                          |                          |        |Days since secondary connect time       |        1.26       |
|                          |                          |        |Used persistence size (GB)              |      205.76       |
|                          |                          |        |Log backup size / day (GB)              |       83.58       |
|                          |                          |        |Local log buffer write size (MB)        |   101130.54       |
|                          |                          |        |Shipped log buffer size (MB)            |   100258.52       |
|                          |                          |        |Avg. local log buffer write size (KB)   |        6.14       |
|                          |                          |        |Avg. shipped log buffer size (KB)       |        6.14       |
|                          |                          |        |Avg. local log buffer write time (ms)   |        0.13       |
|                          |                          |        |Avg. log buffer shipping time (ms)      |        0.24       |
|                          |                          |        |Local log buffer write throughput (MB/s)|       44.68       |
|                          |                          |        |Log buffer shipping throughput (MB/s)   |       24.99       |
|                          |                          |        |Initial data shipping size (MB)         |        0.00       |
|                          |                          |        |Initial data shipping time (s)          |        0.00       |
|                          |                          |        |Last delta data shipping size (MB)      |     2736.00       |
|                          |                          |        |Last delta data shipping time (s)       |       13.00       |
|                          |                          |        |Delta data shipping size (MB)           |   758704.00       |
|                          |                          |        |Delta data shipping time (s)            |     3538.20       |
|                          |                          |        |Delta data shipping throughput (MB/s)   |      214.43       |
|                          |                          |        |Delta data shipping size / day (MB)     |         n/a       |
|                          |                          |        |Replication delay (s)                   |        0.00       |
|                          |                          |        |                                        |                   |
|**********************    |                          |        |                                        |                   |
|                          |                          |        |                                        |                   |
|Replication parameters    |                          |MODIFIED|actual_mode                             |primary            |
|                          |                          |DEFAULT |datashipping_logsize_threshold          |5368709120         |
|                          |                          |DEFAULT |datashipping_min_time_interval          |600                |
|                          |                          |DEFAULT |datashipping_snapshot_max_retention_time|120                |
|                          |                          |DEFAULT |enable_data_compression                 |false              |
|                          |                          |MODIFIED|enable_full_sync                        |false              |
|                          |                          |DEFAULT |enable_log_compression                  |false              |
|                          |                          |DEFAULT |enable_log_retention                    |auto               |
|                          |                          |DEFAULT |keep_old_style_alert                    |false              |
|                          |                          |DEFAULT |logshipping_async_buffer_size           |67108864           |
|                          |                          |DEFAULT |logshipping_async_wait_on_buffer_full   |true               |
|                          |                          |DEFAULT |logshipping_max_retention_size          |1048576            |
|                          |                          |DEFAULT |logshipping_timeout                     |30                 |
|                          |                          |MODIFIED|mode                                    |sync               |
|                          |                          |MODIFIED|operation_mode                          |delta_datashipping |
|                          |                          |DEFAULT |preload_column_tables                   |true               |
|                          |                          |DEFAULT |reconnect_time_interval                 |30                 |
|                          |                          |MODIFIED|site_id                                 |2                  |
|                          |                          |MODIFIED|site_name                               |saphana0152        |
-----------------------------------------------------------------------------------------------------------------------------   
*/

  REPLICATION_PATH,
  HOSTS,
  TO_VARCHAR(PORT) PORT,
  KEY,
  VALUE
FROM
( SELECT
    ROW_NUMBER() OVER (ORDER BY Q.SITE_ID, Q.HOSTS, Q.PORT, Q.LINE_NO) LINE_NO,
    MAP(ROW_NO, 1, Q.REPLICATION_PATH, ' ') REPLICATION_PATH,
    MAP(ROW_NO, 1, Q.HOSTS, ' ') HOSTS,
    MAP(ROW_NO, 1, TO_VARCHAR(Q.PORT), ' ') PORT,
    Q.DESCRIPTION KEY,
    Q.VALUE
  FROM
  ( SELECT
      HOSTS,
      PORT,
      REPLICATION_PATH,
      SITE_ID,
      DESCRIPTION,
      CASE LINE_NO
        WHEN  0 THEN REPLICATION_MODE
        WHEN  1 THEN OPERATION_MODE
        WHEN  2 THEN IFNULL(TO_VARCHAR(SECONDARY_CONNECT_TIME, 'YYYY/MM/DD HH24:MI:SS'), ' ')
        WHEN  3 THEN LPAD(TO_DECIMAL(IFNULL(SECONDS_BETWEEN(SECONDARY_CONNECT_TIME, CURRENT_TIMESTAMP) / 86400, 0), 10, 2), 12)
        WHEN  4 THEN LPAD(TO_DECIMAL(IFNULL(USED_SIZE / 1024 / 1024 / 1024, 0), 10, 2), 12)
        WHEN  7 THEN LPAD(TO_DECIMAL(IFNULL(LOG_BACKUP_SIZE_PER_DAY / 1024 / 1024 / 1024, 0), 10, 2), 12)
        WHEN 10 THEN LPAD(TO_DECIMAL(IFNULL(TOTAL_WRITE_SIZE / 1024 / 1024, 0), 10, 2), 12)
        WHEN 11 THEN LPAD(TO_DECIMAL(IFNULL(SHIPPED_LOG_BUFFERS_SIZE / 1024 / 1024, 0), 10, 2), 12)
        WHEN 12 THEN LPAD(TO_DECIMAL(IFNULL(MAP(TOTAL_TRIGGER_ASYNC_WRITES, 0, 0, TOTAL_WRITE_SIZE / 1024 / TOTAL_TRIGGER_ASYNC_WRITES), 0), 10, 2), 12)
        WHEN 13 THEN LPAD(TO_DECIMAL(IFNULL(MAP(SHIPPED_LOG_BUFFERS_COUNT, 0, 0, SHIPPED_LOG_BUFFERS_SIZE / 1024 / SHIPPED_LOG_BUFFERS_COUNT), 0), 10, 2), 12)
        WHEN 14 THEN LPAD(TO_DECIMAL(IFNULL(MAP(TOTAL_TRIGGER_ASYNC_WRITES, 0, 0, TOTAL_WRITE_TIME / TOTAL_TRIGGER_ASYNC_WRITES / 1000), 0), 10, 2), 12)
        WHEN 15 THEN LPAD(TO_DECIMAL(IFNULL(MAP(SHIPPED_LOG_BUFFERS_COUNT, 0, 0, SHIPPED_LOG_BUFFERS_DURATION / 1000 / SHIPPED_LOG_BUFFERS_COUNT), 0), 10, 2), 12)
        WHEN 16 THEN LPAD(TO_DECIMAL(IFNULL(MAP(TOTAL_WRITE_TIME, 0, 0, TOTAL_WRITE_SIZE / TOTAL_WRITE_TIME / 1024 / 1024 * 1000 * 1000), 0), 10, 2), 12)
        WHEN 17 THEN LPAD(TO_DECIMAL(IFNULL(MAP(SHIPPED_LOG_BUFFERS_DURATION, 0, 0, SHIPPED_LOG_BUFFERS_SIZE / SHIPPED_LOG_BUFFERS_DURATION / 1024 / 1024 * 1000 * 1000), 0), 10, 2), 12)
        WHEN 21 THEN LPAD(TO_DECIMAL(IFNULL(SHIPPED_FULL_REPLICA_SIZE / 1024 / 1024, 0), 10, 2), 12)
        WHEN 22 THEN LPAD(TO_DECIMAL(IFNULL(SHIPPED_FULL_REPLICA_DURATION / 1000000, 0), 10, 2), 12)
        WHEN 23 THEN LPAD(TO_DECIMAL(IFNULL(SHIPPED_LAST_DELTA_REPLICA_SIZE / 1024 / 1024, 0), 10, 2), 12)
        WHEN 24 THEN LPAD(TO_DECIMAL(IFNULL(SECONDS_BETWEEN(SHIPPED_LAST_DELTA_REPLICA_START_TIME, SHIPPED_LAST_DELTA_REPLICA_END_TIME), 0), 10, 2), 12)
        WHEN 25 THEN LPAD(TO_DECIMAL(IFNULL(SHIPPED_DELTA_REPLICA_SIZE / 1024 / 1024, 0), 10, 2), 12)
        WHEN 26 THEN LPAD(TO_DECIMAL(IFNULL(SHIPPED_DELTA_REPLICA_DURATION / 1000000, 0), 10, 2), 12)
        WHEN 27 THEN LPAD(TO_DECIMAL(IFNULL(MAP(SHIPPED_DELTA_REPLICA_DURATION, 0, 0, SHIPPED_DELTA_REPLICA_SIZE / 1024 / 1024 / SHIPPED_DELTA_REPLICA_DURATION * 1000000), 0), 10, 2), 12)
        WHEN 28 THEN 
          CASE    /* SECONDARY_CONNECT_TIME is reset after reconnect or failover while SHIPPED_DELTA_REPLICA_SIZE is kept -> no reliable information */
            WHEN SECONDARY_RECONNECT_COUNT = 0 AND SECONDARY_FAILOVER_COUNT = 0 THEN
              LPAD(TO_DECIMAL(IFNULL(MAP(SECONDS_BETWEEN(SECONDARY_CONNECT_TIME, CURRENT_TIMESTAMP), 0, 0, SHIPPED_DELTA_REPLICA_SIZE / 1024 / 1024 / 
                       SECONDS_BETWEEN(SECONDARY_CONNECT_TIME, CURRENT_TIMESTAMP) * 86400), 0), 10, 2), 12)
            ELSE LPAD('n/a', 12)
          END
        WHEN 29 THEN LPAD(TO_DECIMAL(GREATEST(0, IFNULL(NANO100_BETWEEN(SHIPPED_LOG_POSITION_TIME, LAST_LOG_POSITION_TIME) / 10000000, 0)), 10, 2), 12)
        WHEN 30 THEN IFNULL(TO_VARCHAR(SHIPPED_SAVEPOINT_START_TIME, 'YYYY/MM/DD HH24:MI:SS'), '')
        WHEN 99 THEN ' '
      END VALUE,
      LINE_NO,
      SUPPRESS_ZERO_LINES,
      ROW_NUMBER () OVER (PARTITION BY REPLICATION_PATH, HOSTS, PORT ORDER BY LINE_NO) ROW_NO
    FROM
    ( SELECT
        R.HOSTS,
        R.PORT,
        L.DESCRIPTION,
        L.LINE_NO,
        R.REPLICATION_PATH,
        R.SITE_ID,
        R.REPLICATION_MODE,
        R.OPERATION_MODE,
        CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(R.SECONDARY_CONNECT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE R.SECONDARY_CONNECT_TIME END SECONDARY_CONNECT_TIME,
        R.SHIPPED_LOG_BUFFERS_SIZE,
        R.SHIPPED_LOG_BUFFERS_COUNT,
        R.SHIPPED_LOG_BUFFERS_DURATION,
        R.SHIPPED_FULL_REPLICA_SIZE,
        R.SHIPPED_FULL_REPLICA_DURATION,
        R.SHIPPED_LAST_DELTA_REPLICA_SIZE,
        CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(R.SHIPPED_LAST_DELTA_REPLICA_START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE R.SHIPPED_LAST_DELTA_REPLICA_START_TIME END SHIPPED_LAST_DELTA_REPLICA_START_TIME,
        CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(R.SHIPPED_LAST_DELTA_REPLICA_END_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE R.SHIPPED_LAST_DELTA_REPLICA_END_TIME END SHIPPED_LAST_DELTA_REPLICA_END_TIME,
        R.SHIPPED_DELTA_REPLICA_SIZE,
        R.SHIPPED_DELTA_REPLICA_DURATION,
        R.SECONDARY_RECONNECT_COUNT,
        R.SECONDARY_FAILOVER_COUNT,
        R.TOTAL_WRITE_SIZE,
        R.TOTAL_TRIGGER_ASYNC_WRITES,
        R.TOTAL_WRITE_TIME,
        CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(R.LAST_LOG_POSITION_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE R.LAST_LOG_POSITION_TIME END LAST_LOG_POSITION_TIME,
        CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(R.SHIPPED_LOG_POSITION_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE R.SHIPPED_LOG_POSITION_TIME END SHIPPED_LOG_POSITION_TIME,
        CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(R.SHIPPED_SAVEPOINT_START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE R.SHIPPED_SAVEPOINT_START_TIME END SHIPPED_SAVEPOINT_START_TIME,
        ( SELECT SUM(USED_SIZE) FROM M_VOLUME_FILES V WHERE R.VOLUME_ID = V.VOLUME_ID AND R.HOST = V.HOST AND R.PORT = V.PORT AND V.FILE_TYPE = 'DATA' ) USED_SIZE,
        ( SELECT 
            MAP(DAYS_BETWEEN(MIN(BC.SYS_START_TIME), MAX(BC.SYS_START_TIME)), 0, 0, SUM(BCF.BACKUP_SIZE) / DAYS_BETWEEN(MIN(BC.SYS_START_TIME), MAX(BC.SYS_START_TIME)))
          FROM 
            M_BACKUP_CATALOG_FILES BCF,
            M_BACKUP_CATALOG BC
          WHERE 
            BCF.HOST = R.HOST AND 
            BC.BACKUP_ID = BCF.BACKUP_ID AND
            BC.ENTRY_TYPE_NAME = 'log backup' AND
            BC.STATE_NAME = 'successful' AND
            BC.SYS_START_TIME >= ADD_DAYS(CURRENT_TIMESTAMP, -30)
        ) LOG_BACKUP_SIZE_PER_DAY,
        BI.SUPPRESS_ZERO_LINES
      FROM
      ( SELECT                          /* Modification section */
          'SERVER' TIMEZONE,                              /* SERVER, UTC */
          '%' SITE_NAME,
          '%' HOST,
          '%' PORT,
          ' ' SUPPRESS_ZERO_LINES
        FROM
          DUMMY
      ) BI,
      ( SELECT  0 LINE_NO, 'Replication mode' DESCRIPTION     FROM DUMMY UNION
        SELECT  1, 'Operation mode'                           FROM DUMMY UNION
        SELECT  2, 'Secondary connect time'                   FROM DUMMY UNION
        SELECT  3, 'Days since secondary connect time'        FROM DUMMY UNION
        SELECT  4, 'Used persistence size (GB)'               FROM DUMMY UNION
        SELECT  7, 'Log backup size / day (GB)'               FROM DUMMY UNION
        SELECT 10, 'Local log buffer write size (MB)'         FROM DUMMY UNION
        SELECT 11, 'Shipped log buffer size (MB)'             FROM DUMMY UNION
        SELECT 12, 'Avg. local log buffer write size (KB)'    FROM DUMMY UNION
        SELECT 13, 'Avg. shipped log buffer size (KB)'        FROM DUMMY UNION
        SELECT 14, 'Avg. local log buffer write time (ms)'    FROM DUMMY UNION
        SELECT 15, 'Avg. log buffer shipping time (ms)'       FROM DUMMY UNION
        SELECT 16, 'Local log buffer write throughput (MB/s)' FROM DUMMY UNION
        SELECT 17, 'Log buffer shipping throughput (MB/s)'    FROM DUMMY UNION
        SELECT 21, 'Initial data shipping size (MB)'          FROM DUMMY UNION
        SELECT 22, 'Initial data shipping time (s)'           FROM DUMMY UNION
        SELECT 23, 'Last delta data shipping size (MB)'       FROM DUMMY UNION
        SELECT 24, 'Last delta data shipping time (s)'        FROM DUMMY UNION
        SELECT 25, 'Delta data shipping size (MB)'            FROM DUMMY UNION
        SELECT 26, 'Delta data shipping time (s)'             FROM DUMMY UNION
        SELECT 27, 'Delta data shipping throughput (MB/s)'    FROM DUMMY UNION
        SELECT 28, 'Delta data shipping size / day (MB)'      FROM DUMMY UNION
        SELECT 29, 'Log replay backlog (s)'                   FROM DUMMY UNION
        SELECT 30, 'Last shipped savepoint time'              FROM DUMMY UNION 
        SELECT 99, ' '                                        FROM DUMMY
      ) L,
      ( SELECT DISTINCT
          R.HOST,
          R.HOST || ' -> ' || R.SECONDARY_HOST HOSTS,
          R.PORT,
          R.SITE_NAME || ' -> ' || R.SECONDARY_SITE_NAME REPLICATION_PATH,
          R.SITE_ID,
          R.VOLUME_ID,
          R.REPLICATION_MODE,
          S.OPERATION_MODE,
          R.SECONDARY_CONNECT_TIME,
          R.SHIPPED_LOG_BUFFERS_SIZE,
          R.SHIPPED_LOG_BUFFERS_COUNT,
          R.SHIPPED_LOG_BUFFERS_DURATION,
          R.SHIPPED_FULL_REPLICA_SIZE,
          R.SHIPPED_FULL_REPLICA_DURATION,
          R.SHIPPED_LAST_DELTA_REPLICA_SIZE,
          R.SHIPPED_LAST_DELTA_REPLICA_START_TIME,
          R.SHIPPED_LAST_DELTA_REPLICA_END_TIME,
          R.SHIPPED_DELTA_REPLICA_SIZE,
          R.SHIPPED_DELTA_REPLICA_DURATION,
          R.SECONDARY_RECONNECT_COUNT,
          R.SECONDARY_FAILOVER_COUNT,
          R.LAST_LOG_POSITION_TIME,
          R.SHIPPED_LOG_POSITION_TIME,
          R.SHIPPED_SAVEPOINT_START_TIME,
          I.TOTAL_WRITE_SIZE,
          I.TOTAL_TRIGGER_ASYNC_WRITES,
          I.TOTAL_WRITE_TIME
        FROM
          M_SYSTEM_REPLICATION S INNER JOIN
          M_SERVICE_REPLICATION R ON
            S.SITE_ID = R.SITE_ID AND
            S.SECONDARY_SITE_ID = R.SECONDARY_SITE_ID LEFT OUTER JOIN
          M_VOLUME_IO_TOTAL_STATISTICS I ON
            R.HOST = I.HOST AND
            R.PORT = I.PORT AND
            I.TYPE = 'LOG'
      ) R
      WHERE
        R.HOST LIKE BI.HOST AND
        TO_VARCHAR(R.PORT) LIKE BI.PORT AND
        ( L.LINE_NO IN (0, 1, 99) OR R.REPLICATION_MODE != 'STANDBY' )
    )
  ) Q
  WHERE
  ( Q.SUPPRESS_ZERO_LINES = ' ' OR LTRIM(Q.VALUE) != '0.00' )
  UNION ALL
  ( SELECT 1000, '**********************', ' ', ' ', ' ', ' ' FROM DUMMY )
  UNION ALL
  ( SELECT 1001, ' ', ' ', ' ', ' ', ' ' FROM DUMMY )
  UNION ALL
  ( SELECT
      2000 + ROW_NUMBER () OVER (ORDER BY SECTION, KEY) LINE_NO,
      REPLICATION_PATH,
      HOSTS,
      PORT,
      '[' || SECTION || '] -> ' || KEY KEY,
      VALUE 
    FROM
    ( SELECT
        MAP(ROW_NUMBER() OVER (ORDER BY SECTION, KEY), 1, 'Replication parameters', ' ') REPLICATION_PATH,
        ' ' HOSTS,
        IFNULL(MAX(MAP(LAYER_NAME, 'SYSTEM', 'MODIFIED', NULL)), MAX(MAP(LAYER_NAME, 'DEFAULT', 'DEFAULT', NULL))) PORT,
        SECTION,
        KEY,
        IFNULL(MAX(MAP(LAYER_NAME, 'SYSTEM', VALUE, NULL)), MAX(MAP(LAYER_NAME, 'DEFAULT', VALUE, NULL))) VALUE
      FROM
        M_INIFILE_CONTENTS
      WHERE
        FILE_NAME = 'global.ini' AND
        ( SECTION = 'system_replication' OR
          SECTION = 'system_replication_communication' OR
          SECTION = 'inifile_checker' AND KEY = 'replicate'
        )
      GROUP BY
        SECTION,
        KEY
    )
  )
)
ORDER BY
  LINE_NO
