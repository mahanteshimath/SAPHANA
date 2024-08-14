SELECT
/* 

[NAME]

- HANA_Replication_SystemReplication_ParameterDeviations

[DESCRIPTION]

- Displays statistic server information for SAP HANA parameter deviations between primary and replication side	
- Section "ALERT CONFIGURATION" contains configuration option from global.ini -> [inifile_checker], typically
  parameters and sections are maintained that are allowed to be different

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/10/09:  1.0 (initial version)
- 2016/10/17:  1.1 (consideration of alert 79)
- 2017/10/25:  1.2 (TIMEZONE included)

[INVOLVED TABLES]

- STATISTICS_ALERTS

[INPUT PARAMETERS]

- TIMEZONE

  Used timezone (both for input and output parameters)

  'SERVER'       --> Display times in SAP HANA server time
  'UTC'          --> Display times in UTC time

- EXCLUDE_STATISTICS_SERVER

  Controls if statisticsserver parameters are displayed

  'X'             --> Suppresses the output of parameters related to statisticsserver.ini
  ' '             --> No restriction

[OUTPUT PARAMETERS]

- ALERT_TIMESTAMP: Timestamp of alert (ALERTS section) / parameter name (ALERT CONFIGURATION section)
- DETAILS:         Details about parameter deviation (ALERTS section) / parameter value (ALERT CONFIGURATION section)

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------------------------------------------------------------
|ALERT_TIMESTAMP                |DETAILS                                                                                                                   |
------------------------------------------------------------------------------------------------------------------------------------------------------------
|ALERTS:                        |                                                                                                                          |
|                               |                                                                                                                          |
|2015/01/15 12:00:09            |global.ini/system/[expensive_statement]/enable = 'true' exists only on site 1                                             |
|                               |global.ini/system/[memorymanager]/global_allocation_limit, value on site 1 = '943104', value for site 2 = '204800'        |
|                               |global.ini/system/[persistence]/log_backup_timeout_s, value on site 1 = '7200', value for site 2 = '54000'                |
|                               |global.ini/system/[persistence]/log_buffer_count = '16' exists only on site 1                                             |
|                               |global.ini/system/[persistence]/log_buffer_size_kb = '2048' exists only on site 1                                         |
|                               |global.ini/system/[resource_tracking]/load_monitor_granularity = '60000' exists only on site 1                            |
|                               |global.ini/system/[resource_tracking]/service_thread_sampling_monitor_thread_detail_enabled = 'true' exists only on site 1|
|                               |                                                                                                                          |
|ALERT CONFIGURATION:           |(global.ini -> [inifile_checker])                                                                                         |
|                               |                                                                                                                          |
|enable                         |true                                                                                                                      |
|exclusion_*                    |traceprofile_*                                                                                                            |
|exclusion_daemon.ini/host      |*instances                                                                                                               |
|exclusion_global.ini/system    |storage/*, persistence/*path*, *hostname_resolution*, system_replication*                                                 |
|exclusion_nameserver.ini/system|landscape/*                                                                                                               |
|interval                       |3600                                                                                                                      |
------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

  'ALERTS:' ALERT_TIMESTAMP,
  '' DETAILS
FROM
  DUMMY
UNION ALL
( SELECT '', '' FROM DUMMY )
UNION ALL
( SELECT
    MAP(ROW_NUM, 1, ALERT_TIMESTAMP, '') ALERT_TIMESTAMP,
    DETAILS
  FROM
  ( SELECT DISTINCT
      ALERT_TIMESTAMP,
      DETAILS,
      ROW_NUMBER () OVER (ORDER BY ALERT_TIMESTAMP DESC, DETAILS) ROW_NUM
    FROM
    ( SELECT DISTINCT
        ALERT_TIMESTAMP,
        DETAILS
      FROM
      ( SELECT
          TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(A.ALERT_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE A.ALERT_TIMESTAMP END, 'YYYY/MM/DD HH24:MI:SS') ALERT_TIMESTAMP,
          DETAILS,
          MAX(TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(A.ALERT_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE A.ALERT_TIMESTAMP END, 'YYYY/MM/DD HH24:MI:SS')) OVER () MAX_ALERT_TIMESTAMP
        FROM
        ( SELECT                      /* Modification section */
            'SERVER' TIMEZONE,                              /* SERVER, UTC */
            'X' EXCLUDE_STATISTICS_SERVER
          FROM
            DUMMY
        ) BI,
        ( SELECT
            ALERT_TIMESTAMP,
            CASE
              WHEN INSTR(ALERT_DETAILS, 'parameter mismatch (existence):') != 0 THEN SUBSTR(ALERT_DETAILS, INSTR(ALERT_DETAILS, 'parameter mismatch (existence):') + 32)
              WHEN INSTR(ALERT_DETAILS, 'parameter mismatch (different value):') != 0 THEN SUBSTR(ALERT_DETAILS, INSTR(ALERT_DETAILS, 'parameter mismatch (different value):') + 38)
              ELSE ALERT_DETAILS
            END DETAILS
          FROM
            _SYS_STATISTICS.STATISTICS_ALERTS A
          WHERE
            ALERT_ID IN ( 21, 79 ) AND
            ALERT_TIMESTAMP > ADD_SECONDS(CURRENT_TIMESTAMP, -7200) AND
            ALERT_DETAILS LIKE '%parameter mismatch%'
        ) A
        WHERE
          ( BI.EXCLUDE_STATISTICS_SERVER = ' ' OR A.DETAILS NOT LIKE '%statisticsserver.ini%' )
      )
      WHERE
        ALERT_TIMESTAMP = MAX_ALERT_TIMESTAMP
    )
  )
  ORDER BY
    ALERT_TIMESTAMP DESC,
    DETAILS
)
UNION ALL
( SELECT '', '' FROM DUMMY )
UNION ALL
( SELECT 'ALERT CONFIGURATION:', '(global.ini -> [inifile_checker])' FROM DUMMY )
UNION ALL
( SELECT '', '' FROM DUMMY )
UNION ALL
( SELECT
    KEY,
    IFNULL(HOST_VALUE, IFNULL(DATABASE_VALUE, IFNULL(SYSTEM_VALUE, DEFAULT_VALUE)))
  FROM
  ( SELECT
      KEY,
      MAX(MAP(LAYER_NAME, 'DEFAULT', VALUE)) DEFAULT_VALUE,
      MAX(MAP(LAYER_NAME, 'SYSTEM', VALUE)) SYSTEM_VALUE,
      MAX(MAP(LAYER_NAME, 'DATABASE', VALUE)) DATABASE_VALUE,
      MAX(MAP(LAYER_NAME, 'HOST', VALUE)) HOST_VALUE
    FROM
      M_INIFILE_CONTENTS
    WHERE
      FILE_NAME = 'global.ini' AND
      SECTION = 'inifile_checker'
    GROUP BY
      KEY
  )
)
