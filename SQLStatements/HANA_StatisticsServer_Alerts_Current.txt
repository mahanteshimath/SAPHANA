SELECT
/* 

[NAME]

- HANA_StatisticsServer_Alerts_Current

[DESCRIPTION]

- Reported SAP HANA alerts

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Access to STATISTICS_ALERTS_BASE table because view STATISTICS_ALERTS may contain erroneous UTC timestamp for ALERT_ID = 0 in ALERT_TIMESTAMP column (bug 160061)

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/04/12:  1.0 (initial version)
- 2017/09/12:  1.1 (STATISTICS_ALERTS replaced with STATISTICS_ALERTS_BASE due to UTC timestamp issue)
- 2017/10/26:  1.2 (TIMEZONE included)
- 2018/12/04:  1.3 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2022/05/27:  1.4 (HOST and PORT included, useful to identify system replication site of alert)

[INVOLVED TABLES]

- STATISTICS_ALERTS_BASE
- STATISTICS_CURRENT_ALERTS
- STATISTICS_LAST_CHECKS

[INPUT PARAMETERS]

- BEGIN_TIME

  Begin time

  '2018/12/05 14:05:00' --> Set begin time to 5th of December 2018, 14:05
  'C'                   --> Set begin time to current time
  'C-S900'              --> Set begin time to current time minus 900 seconds
  'C-M15'               --> Set begin time to current time minus 15 minutes
  'C-H5'                --> Set begin time to current time minus 5 hours
  'C-D1'                --> Set begin time to current time minus 1 day
  'C-W4'                --> Set begin time to current time minus 4 weeks
  'E-S900'              --> Set begin time to end time minus 900 seconds
  'E-M15'               --> Set begin time to end time minus 15 minutes
  'E-H5'                --> Set begin time to end time minus 5 hours
  'E-D1'                --> Set begin time to end time minus 1 day
  'E-W4'                --> Set begin time to end time minus 4 weeks
  'MIN'                 --> Set begin time to minimum (1000/01/01 00:00:00)

- END_TIME

  End time

  '2018/12/08 14:05:00' --> Set end time to 8th of December 2018, 14:05
  'C'                   --> Set end time to current time
  'C-S900'              --> Set end time to current time minus 900 seconds
  'C-M15'               --> Set end time to current time minus 15 minutes
  'C-H5'                --> Set end time to current time minus 5 hours
  'C-D1'                --> Set end time to current time minus 1 day
  'C-W4'                --> Set end time to current time minus 4 weeks
  'B+S900'              --> Set end time to begin time plus 900 seconds
  'B+M15'               --> Set end time to begin time plus 15 minutes
  'B+H5'                --> Set end time to begin time plus 5 hours
  'B+D1'                --> Set end time to begin time plus 1 day
  'B+W4'                --> Set end time to begin time plus 4 weeks
  'MAX'                 --> Set end time to maximum (9999/12/31 23:59:59)

- TIMEZONE

  Used timezone (both for input and output parameters)

  'SERVER'       --> Display times in SAP HANA server time
  'UTC'          --> Display times in UTC time

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

- ALERT_ID

  Alert identifier

  55           --> Alert 55
  -1           --> No restriction related to alert identifier

- RECOMMENDATION

  Pattern for recommendation text

  '%part%'        --> All recommendations containing 'part'
  '%'             --> All recommendations

- MIN_SEVERITY_LEVEL

  Minimum severity level

  'MEDIUM'       --> Show only MEDIUM and HIGH alerts
  'INFO'         --> Show all alerts (INFO, LOW, MEDIUM and HIGH)

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'SEVERITY'      --> Sorting by severity
  'TIME'          --> Sorting by alert time
  
[OUTPUT PARAMETERS]

- ALERT_TIME:     Alert timestamp
- HOST:           Alert host
- PORT:           Alert port
- ALERT_ID:       Alert identifier
- RATING:         Alert rating (INFO, LOW, MEDIUM, HIGH)
- ALERT_DETAILS:  Detailed issue description
- RECOMMENDATION: Recommendation (if available)

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|ALERT_TIME         |RATING|ALERT_DETAILS                                                                                       |RECOMMENDATION                                                                                     |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2014/04/12 22:28:57|HIGH  |SAPECC.BSIS contains 491540707 records.                                                             |Consider partitioning the table only if you expect it to grow rapidly.                             |
|2014/04/12 22:28:57|HIGH  |SAPECC.CDPOS contains 356652123 records.                                                            |Consider partitioning the table only if you expect it to grow rapidly.                             |
|2014/04/12 22:28:57|HIGH  |SAPECC.EDID4 contains 418615377 records.                                                            |Consider partitioning the table only if you expect it to grow rapidly.                             |
|2014/04/12 22:28:57|LOW   |1997859 plan cache evictions occured on host hlahana20, port 30103.                                 |Increase the size of the plan cache. In the 'sql' section of the indexserver.ini file, increase the|
|                   |      |                                                                                                    |value of the 'plan_cache_size' parameter.                                                          |
|2014/04/12 22:28:57|LOW   |There are currently 748 diagnosis files. This might indicate a problem with trace file rotation, a h|Investigate the diagnosis files.                                                                   |
|                   |      |igh number of crashes, or another issue.                                                            |                                                                                                   |
|2014/04/12 22:28:57|LOW   |There are diagnosis files of size greater than or equal to 1536 MB. This can indicate a problem with|Check the diagnosis files in the SAP HANA studio for details.                                      |
|                   |      | the database.                                                                                      |                                                                                                   |
|2014/04/12 21:41:50|MEDIUM|ReplicationError with state INFO with event ID  4164 occurred at 2014-04-12 21:28:45.000000000 on sa|                                                                                                   |
|                   |      |phana20:30101. Additional info: inifile mismatch for site 2: global.ini/SYSTEM/[auditing configurati|                                                                                                   |
|                   |      |on]/default_audit_trail_path = /usr/sap/C11/HDB01/saphana20/trace                                   |                                                                                                   |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  MAP(A.ROW_NUM, 1, TO_VARCHAR(MAX(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(A.ALERT_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE A.ALERT_TIMESTAMP END), 'YYYY/MM/DD HH24:MI:SS'), '') ALERT_TIME,
  A.HOST,
  LPAD(A.PORT, 5) PORT,
  MAP(A.ROW_NUM, 1, LPAD(A.ALERT_ID, 8), '') ALERT_ID,
  MAP(A.ROW_NUM, 1, MAP(A.ALERT_RATING, 1, 'INFO', 2, 'LOW', 3, 'MEDIUM', 4, 'HIGH', 5, 'ERROR'), '') RATING,
  A.ALERT_DETAILS,
  IFNULL(A.RECOMMENDATION, '') RECOMMENDATION
FROM
( SELECT
    CASE
      WHEN BEGIN_TIME =    'C'                             THEN CURRENT_TIMESTAMP
      WHEN BEGIN_TIME LIKE 'C-S%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-S'))
      WHEN BEGIN_TIME LIKE 'C-M%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-M') * 60)
      WHEN BEGIN_TIME LIKE 'C-H%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-H') * 3600)
      WHEN BEGIN_TIME LIKE 'C-D%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-D') * 86400)
      WHEN BEGIN_TIME LIKE 'C-W%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-W') * 86400 * 7)
      WHEN BEGIN_TIME LIKE 'E-S%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-S'))
      WHEN BEGIN_TIME LIKE 'E-M%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-M') * 60)
      WHEN BEGIN_TIME LIKE 'E-H%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-H') * 3600)
      WHEN BEGIN_TIME LIKE 'E-D%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-D') * 86400)
      WHEN BEGIN_TIME LIKE 'E-W%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-W') * 86400 * 7)
      WHEN BEGIN_TIME =    'MIN'                           THEN TO_TIMESTAMP('1000/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS')
      WHEN SUBSTR(BEGIN_TIME, 1, 1) NOT IN ('C', 'E', 'M') THEN TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS')
    END BEGIN_TIME,
    CASE
      WHEN END_TIME =    'C'                             THEN CURRENT_TIMESTAMP
      WHEN END_TIME LIKE 'C-S%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-S'))
      WHEN END_TIME LIKE 'C-M%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-M') * 60)
      WHEN END_TIME LIKE 'C-H%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-H') * 3600)
      WHEN END_TIME LIKE 'C-D%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-D') * 86400)
      WHEN END_TIME LIKE 'C-W%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-W') * 86400 * 7)
      WHEN END_TIME LIKE 'B+S%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+S'))
      WHEN END_TIME LIKE 'B+M%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+M') * 60)
      WHEN END_TIME LIKE 'B+H%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+H') * 3600)
      WHEN END_TIME LIKE 'B+D%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+D') * 86400)
      WHEN END_TIME LIKE 'B+W%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+W') * 86400 * 7)
      WHEN END_TIME =    'MAX'                           THEN TO_TIMESTAMP('9999/12/31 00:00:00', 'YYYY/MM/DD HH24:MI:SS')
      WHEN SUBSTR(END_TIME, 1, 1) NOT IN ('C', 'B', 'M') THEN TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS')
    END END_TIME,
    TIMEZONE,
    HOST,
    PORT,
    ALERT_ID,
    RECOMMENDATION,
    MIN_SEVERITY_LEVEL,
    ORDER_BY
  FROM
  ( SELECT                                         /* Modification section */
      '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
      '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
      'SERVER' TIMEZONE,                              /* SERVER, UTC */
      '%' HOST,
      '%' PORT,
      -1 ALERT_ID,
      '%' RECOMMENDATION,
      'LOW' MIN_SEVERITY_LEVEL,        /* INFO, LOW, MEDIUM, HIGH, ERROR */ 
      'TIME' ORDER_BY              /* SEVERITY, TIME */       
    FROM
      DUMMY
  )
) BI,
( SELECT
    R.ROW_NUM,
    A.ALERT_TIMESTAMP,
    A.HOST,
    A.PORT,
    A.ALERT_ID,
    A.ALERT_RATING,
    A.ALERT_DETAILS ALERT_DETAILS_TOTAL,
    SUBSTR(A.ALERT_DETAILS, (R.ROW_NUM - 1) * 100 + 1, 100) ALERT_DETAILS,
    SUBSTR(A.RECOMMENDATION, (R.ROW_NUM - 1) * 100 + 1, 100) RECOMMENDATION
  FROM
  ( SELECT TOP 10 ROW_NUMBER () OVER () ROW_NUM FROM M_HOST_INFORMATION ) R,
    ( SELECT
        A.ALERT_TIMESTAMP,
        A.ALERT_HOST HOST,
        A.ALERT_PORT PORT,
        A.ALERT_ID,
        A.ALERT_RATING,
        A.ALERT_DETAILS,
        IFNULL(CA.ALERT_USERACTION, L.ALERT_USERACTION) RECOMMENDATION
      FROM
        _SYS_STATISTICS.STATISTICS_LAST_CHECKS L INNER JOIN
        _SYS_STATISTICS.STATISTICS_ALERTS_BASE A ON
          L.ALERT_ID = A.ALERT_ID LEFT OUTER JOIN
        _SYS_STATISTICS.STATISTICS_CURRENT_ALERTS CA ON
          A.ALERT_ID = CA.ALERT_ID AND
          A.INDEX = CA.INDEX AND
          A.SNAPSHOT_ID = CA.SNAPSHOT_ID AND
          A.ALERT_HOST = CA.ALERT_HOST AND
          A.ALERT_PORT = CA.ALERT_PORT
    ) A
  WHERE
    SUBSTR(A.ALERT_DETAILS, (R.ROW_NUM - 1) * 100 + 1, 100) != '' OR
     SUBSTR(A.RECOMMENDATION, (R.ROW_NUM - 1) * 100 + 1, 100) != ''
) A
WHERE
  CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(A.ALERT_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE A.ALERT_TIMESTAMP END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
  A.HOST LIKE BI.HOST AND
  TO_VARCHAR(A.PORT) LIKE BI.PORT AND
  ( BI.MIN_SEVERITY_LEVEL = 'INFO' OR
    BI.MIN_SEVERITY_LEVEL = 'LOW' AND A.ALERT_RATING >= 2 OR
    BI.MIN_SEVERITY_LEVEL = 'MEDIUM' AND A.ALERT_RATING >= 3 OR
    BI.MIN_SEVERITY_LEVEL = 'HIGH' AND A.ALERT_RATING >= 4 OR
    BI.MIN_SEVERITY_LEVEL = 'ERROR' AND A.ALERT_RATING = 5 
  ) AND
  UPPER(IFNULL(A.RECOMMENDATION, '')) LIKE UPPER(BI.RECOMMENDATION) AND
  ( BI.ALERT_ID = -1 OR A.ALERT_ID = BI.ALERT_ID )
GROUP BY
  A.ROW_NUM,
  A.HOST,
  A.PORT,
  A.ALERT_ID,
  A.ALERT_RATING,
  A.ALERT_DETAILS,
  A.ALERT_DETAILS_TOTAL,
  A.RECOMMENDATION,
  BI.ORDER_BY
ORDER BY
  MAP(BI.ORDER_BY, 'TIME', MAX(A.ALERT_TIMESTAMP)) DESC,
  A.HOST,
  A.PORT,
  A.ALERT_RATING DESC,
  A.ALERT_ID,
  A.ALERT_DETAILS_TOTAL,
  A.ROW_NUM
