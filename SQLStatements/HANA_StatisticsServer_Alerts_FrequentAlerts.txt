SELECT
/* 

[NAME]

- HANA_StatisticsServer_Alerts_FrequentAlerts

[DESCRIPTION]

- Display of frequent alerts and cleanup command

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/08/07  1.0 (initial version)

[INVOLVED TABLES]

- STATISTICS_ALERTS_BASE

[INPUT PARAMETERS]

- RETAINED_RECORDS_PER_ALERT

  Threshold for retained records per alert

  500000       --> Only show alerts with at least 500000 records

[OUTPUT PARAMETERS]

- ALERT_ID:          Alert identifier
- TOTAL_RECORDS:     Total records for alert
- RETAINED_RECORDS:  Retained records
- COMMAND:           Cleanup command so that all records exceeding the retention limit are deleted

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
|ALERT_ID|TOTAL_RECORDS|RETAINED_RECORDS|COMMAND                                                                                                                    |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
|      21|      3251632|          500000|DELETE FROM _SYS_STATISTICS.STATISTICS_ALERTS_BASE WHERE ALERT_ID = 21 AND ALERT_TIMESTAMP <= '2015-07-26 06:00:51.1670000'|
|      79|      3251620|          500000|DELETE FROM _SYS_STATISTICS.STATISTICS_ALERTS_BASE WHERE ALERT_ID = 79 AND ALERT_TIMESTAMP <= '2015-07-26 06:00:51.5780000'|
---------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  LPAD(ALERT_ID, 8) ALERT_ID,
  LPAD(TOTAL_RECORDS, 13) TOTAL_RECORDS,
  LPAD(RETAINED_RECORDS, 16) RETAINED_RECORDS,
  COMMAND
FROM
( SELECT
    ALERT_ID,
    ( SELECT COUNT(*) FROM _SYS_STATISTICS.STATISTICS_ALERTS_BASE B WHERE A.ALERT_ID = B.ALERT_ID ) TOTAL_RECORDS,
    RETAINED_RECORDS_PER_ALERT RETAINED_RECORDS,
    'DELETE FROM _SYS_STATISTICS.STATISTICS_ALERTS_BASE WHERE ALERT_ID =' || CHAR(32) || TO_VARCHAR(ALERT_ID) || ' AND ALERT_TIMESTAMP <=' || CHAR(32) || CHAR(39) || ALERT_TIMESTAMP || CHAR(39) COMMAND
  FROM
  ( SELECT
      A.ALERT_ID,
      A.ALERT_TIMESTAMP,
      BI.RETAINED_RECORDS_PER_ALERT,
      ROW_NUMBER() OVER (PARTITION BY ALERT_ID ORDER BY ALERT_TIMESTAMP DESC) ROW_NUM
    FROM
    ( SELECT               /* Modification section */
        500000 RETAINED_RECORDS_PER_ALERT
      FROM
        DUMMY
    ) BI,
      _SYS_STATISTICS.STATISTICS_ALERTS_BASE A
  ) A
  WHERE
    ROW_NUM = RETAINED_RECORDS_PER_ALERT
)
ORDER BY
  ALERT_ID
