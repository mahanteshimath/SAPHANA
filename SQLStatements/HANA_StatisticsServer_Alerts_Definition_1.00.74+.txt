SELECT
/* 

[NAME]

- HANA_StatisticsServer_Alerts_Definition_1.00.74+

[DESCRIPTION]

- Definition of SAP HANA Alerts

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              >= 1.00.74

[SQL COMMAND VERSION]

- 2014/04/12:  1.0 (initial version)
- 2014/05/30:  1.1 (possibility to filter ALERT_DESCRIPTION)
- 2014/10/10:  1.2 (alert thresholds included)

[INVOLVED TABLES]

- STATISTICS_LAST_CHECKS
- STATISTICS_ALERT_THRESHOLDS

[INPUT PARAMETERS]

- ALERT_ID

  Alert identifier

  55           --> Alert 55
  -1           --> No restriction related to alert identifier

- ALERT_DESCRIPTION

  Pattern for alert description

  '%secure%'   --> Show all alerts with a description containing 'secure'
  '%'          --> No restriction of alert description

[OUTPUT PARAMETERS]

- ALERT_ID:          Alert identifier
- ALERT_NAME:        Short alert description
- INTERVAL:          Alert check interval
- THR_INFO:          Threshold for information
- THR_LOW:           Threshold for low alerts
- THR_MED:           Threshold for medium alerts
- THR_HIGH:          Threshold for high alerts
- ALERT_DESCRIPTION: Description of alert
- RECOMMENDATION:    Recommendations

[EXAMPLE OUTPUT]

ALERT_ID|ALERT_NAME                                                      |INTERVAL|THR_INFO |THR_LOW   |THR_MED   |THR_HIGH  |ALERT_DESCRIPTION                                                                                       |RECOMMENDATION                                                                                           |ALERT_TIME         |RATING

       0|Internal statistics server problem                              |        |         |          |          |          |Identifies internal statistics server problem.                                                          |Resolve the problem. For more information, see the trace files. You may need to activate tracing fir     |                   |      
        |                                                                |        |         |          |          |          |                                                                                                        |st.                                                                                                      |                   |      
       1|Host physical memory usage                                      |      60|         |95        |98        |100       |Determines what percentage of total physical memory available on the host is used. All processes con    |Investigate memory usage of processes.                                                                   |2014/10/10 15:51:30|      
        |                                                                |        |         |          |          |          |suming memory are considered, including non-SAP HANA processes.                                         |                                                                                                         |                   |      
       2|Disk usage                                                      |     300|         |90        |95        |98        |Determines what percentage of each disk containing data, log, and trace files is used. This includes    |Investigate disk usage of processes. Increase disk space, for example by shrinking volumes, deleting     |2014/10/10 15:50:30|      
        |                                                                |        |         |          |          |          | space used by non-SAP HANA files.                                                                      | diagnosis files, or adding additional storage.                                                          |                   |      
       3|Inactive services                                               |      60|         |          |          |600       |Identifies inactive services.                                                                           |Investigate why the service is inactive, for example, by checking the service's trace files.             |2014/10/10 15:51:30|      
       4|Restarted services                                              |      60|         |          |          |          |Identifies services that have restarted since the last time the check was performed.                    |Investigate why the service had to restart or be restarted, for example, by checking the service's t     |2014/10/10 15:51:30|      
        |                                                                |        |         |          |          |          |                                                                                                        |race files.                                                                                              |                   |      
       5|Host CPU Usage                                                  |      60|         |25        |15        |10        |Determines the percentage CPU idle time on the host and therefore whether or not CPU resources are r    |Investigate CPU usage.                                                                                   |2014/10/10 15:51:30|HIGH  
        |                                                                |        |         |          |          |          |unning low.                                                                                             |                                                                                                         |                   |      
      10|Delta merge (mergedog) configuration                            |     600|         |          |          |          |Determines whether or not the 'active' parameter in the 'mergedog' section of system configuration f    |Change in SYSTEM layer the parameter active in section(s) mergedog to yes                                |2014/10/10 15:45:30|      
        |                                                                |        |         |          |          |          |ile(s) is 'yes'. mergedog is the system process that periodically checks column tables to determine     |                                                                                                         |                   |      
        |                                                                |        |         |          |          |          |whether or not a delta merge operation needs to be executed.                                            |                                                                                                         |                   |      
      12|Memory usage of name server                                     |      60|         |          |70        |80        |Determines what percentage of allocated shared memory is being used by the name server on a host.       |Increase the shared memory size of the name server. In the 'topology' section of the nameserver.ini      |2014/10/10 15:51:30|      
        |                                                                |        |         |          |          |          |                                                                                                        |file, increase the value of the 'size' parameter.                                                        |                   |      
      16|Lock wait timeout configuration                                 |    3600|         |          |          |          |Determines whether the 'lock_waittimeout' parameter in the 'transaction' section of the indexserver.    |In the 'transaction' section of the indexserver.ini file, set the 'lock_wait_timeout' parameter to a     |2014/10/10 15:05:31|      
        |                                                                |        |         |          |          |          |ini file is between 100,000 and 7,200,000.                                                              | value between 100,000 and 7,200,000 for the System layer.                                               |                   |      

*/

  MAP(A.ROW_NUM, 1, LPAD(A.ALERT_ID, 8), '') ALERT_ID,
  MAP(A.ROW_NUM, 1, A.ALERT_NAME, '') ALERT_NAME,
  MAP(A.ROW_NUM, 1, IFNULL(LPAD(A.INTERVAL, 8), ''), '') INTERVAL, 
  MAP(A.ROW_NUM, 1, IFNULL(THR_1, ''), '') THR_INFO,
  MAP(A.ROW_NUM, 1, IFNULL(THR_2, ''), '') THR_LOW,
  MAP(A.ROW_NUM, 1, IFNULL(THR_3, ''), '') THR_MED,
  MAP(A.ROW_NUM, 1, IFNULL(THR_4, ''), '') THR_HIGH,
  A.ALERT_DESCRIPTION,
  A.RECOMMENDATION,
  MAP(A.ROW_NUM, 1, TO_VARCHAR(A.ALERT_LAST_CHECK_TIMESTAMP, 'YYYY/MM/DD HH24:MI:SS'), '') ALERT_TIME,
  MAP(A.ROW_NUM, 1, MAP(A.ALERT_LAST_CHECK_RATING, 1, 'INFO', 2, 'LOW', 3, 'MEDIUM', 4, 'HIGH', 5, 'INFO', ''), '') RATING
FROM
( SELECT
    R.ROW_NUM,
    A.ALERT_ID,
    A.ALERT_NAME,
    A.INTERVAL,
    A.ALERT_LAST_CHECK_TIMESTAMP,
    A.ALERT_LAST_CHECK_RATING,
    SUBSTR(A.ALERT_DESCRIPTION, (R.ROW_NUM - 1) * 100 + 1, 100) ALERT_DESCRIPTION,
    SUBSTR(A.ALERT_USERACTION, (R.ROW_NUM - 1) * 100 + 1, 100) RECOMMENDATION,
    ( SELECT IFNULL(CURRENT_VALUE, DEFAULT_VALUE) FROM _SYS_STATISTICS.STATISTICS_ALERT_THRESHOLDS T WHERE T.ALERT_ID = A.ALERT_ID AND T.SEVERITY = 1 ) THR_1,
    ( SELECT IFNULL(CURRENT_VALUE, DEFAULT_VALUE) FROM _SYS_STATISTICS.STATISTICS_ALERT_THRESHOLDS T WHERE T.ALERT_ID = A.ALERT_ID AND T.SEVERITY = 2 ) THR_2,
    ( SELECT IFNULL(CURRENT_VALUE, DEFAULT_VALUE) FROM _SYS_STATISTICS.STATISTICS_ALERT_THRESHOLDS T WHERE T.ALERT_ID = A.ALERT_ID AND T.SEVERITY = 3 ) THR_3,
    ( SELECT IFNULL(CURRENT_VALUE, DEFAULT_VALUE) FROM _SYS_STATISTICS.STATISTICS_ALERT_THRESHOLDS T WHERE T.ALERT_ID = A.ALERT_ID AND T.SEVERITY = 4 ) THR_4
  FROM
  ( SELECT                      /* Modification section */
      -1 ALERT_ID,
      '%' ALERT_DESCRIPTION
    FROM
      DUMMY
  ) BI,
  ( SELECT TOP 10 ROW_NUMBER () OVER () ROW_NUM FROM M_HOST_INFORMATION ) R,
    _SYS_STATISTICS.STATISTICS_LAST_CHECKS A
  WHERE
    UPPER(A.ALERT_DESCRIPTION) LIKE UPPER(BI.ALERT_DESCRIPTION) AND
    ( SUBSTR(A.ALERT_DESCRIPTION, (R.ROW_NUM - 1) * 100 + 1, 100) != '' OR
      SUBSTR(A.ALERT_USERACTION, (R.ROW_NUM - 1) * 100 + 1, 100) != '' ) AND
    ( BI.ALERT_ID = -1 OR A.ALERT_ID = BI.ALERT_ID )
) A
ORDER BY
  A.ALERT_ID,
  ROW_NUM
