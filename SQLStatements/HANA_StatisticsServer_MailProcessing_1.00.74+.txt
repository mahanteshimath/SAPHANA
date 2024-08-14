SELECT
/* 

[NAME]

- HANA_StatisticsServer_MailProcessing_1.00.74+

[DESCRIPTION]

- Statistics server e-mail processing details

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Only available for embedded statistics server

[VALID FOR]

- Revisions:              >= 1.00.74

[SQL COMMAND VERSION]

- 2014/11/18:  1.0 (initial version)
- 2016/12/31:  1.1 (TIME_AGGREGATE_BY = 'TS<seconds>' included)
- 2017/10/26:  1.2 (TIMEZONE included)

[INVOLVED TABLES]

- STATISTICS_EMAIL_PROCESSING

[INPUT PARAMETERS]

- TIMEZONE

  Used timezone (both for input and output parameters)

  'SERVER'       --> Display times in SAP HANA server time
  'UTC'          --> Display times in UTC time

- MIN_AGE_HOURS

  Threshold for minimum age of mail notification in hours

  72:            --> Only consider mail notifications older than 72 hours (3 days)
  -1:            --> No restriction related to age of mail notifications

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'          --> Aggregation by time
  'TIME, ID'      --> Aggregation by time and alert ID
  'NONE'          --> No aggregation

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation

[OUTPUT PARAMETERS]

- BEGIN_TIME: Time of mail notification
- ALERT_ID:   Alert identifier
- STATE:      Mail notification state
- SEVERITY:   Alert severity
- NUM_MAILS:  Number of existing mail notifications

[EXAMPLE OUTPUT]

----------------------------------------------
|BEGIN_TIME|ALERT_ID|STATE|SEVERITY|NUM_MAILS|
----------------------------------------------
|2015/03/20|       1|New  |       0|      878|
|2015/03/20|       2|New  |       0|      175|
|2015/03/20|       3|New  |       0|      878|
|2015/03/20|       4|New  |       0|        4|
|2015/03/20|       5|New  |       0|      870|
|2015/03/20|       5|New  |       5|        8|
|2015/03/20|      10|New  |       0|       88|
|2015/03/20|      12|New  |       0|      878|
|2015/03/20|      16|New  |       0|       15|
|2015/03/20|      17|New  |       5|       15|
|2015/03/20|      20|New  |       0|       14|
|2015/03/20|      20|New  |       5|        1|
|2015/03/20|      21|New  |       0|      175|
|2015/03/20|      22|New  |       5|        1|
|2015/03/20|      23|New  |       5|        3|
|2015/03/20|      24|New  |       0|       11|
|2015/03/20|      24|New  |       5|        4|
|2015/03/20|      25|New  |       0|      175|
|2015/03/20|      26|New  |       0|       15|
----------------------------------------------

*/

  BEGIN_TIME,
  LPAD(ALERT_ID, 8) ALERT_ID,
  STATE,
  LPAD(SEVERITY, 8) SEVERITY,
  LPAD(NUM_MAILS, 9) NUM_MAILS
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(SE.SNAPSHOT_ID, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE SE.SNAPSHOT_ID END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(SE.SNAPSHOT_ID, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE SE.SNAPSHOT_ID END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END BEGIN_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ID')       != 0 THEN TO_VARCHAR(SE.ALERT_ID)                          ELSE 'any' END ALERT_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATE')    != 0 THEN SE.STATE                                      ELSE 'any' END STATE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SEVERITY') != 0 THEN TO_VARCHAR(SE.SEVERITY)                          ELSE 'any' END SEVERITY,
    COUNT(*) NUM_MAILS
  FROM
  ( SELECT
      TIMEZONE,
      MIN_AGE_HOURS,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS',
        'HOUR',        'YYYY/MM/DD HH24',
        'DAY',         'YYYY/MM/DD (DY)',
        'HOUR_OF_DAY', 'HH24',
        TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY
    FROM
    ( SELECT                       /* Modification section */
       'SERVER' TIMEZONE,                              /* SERVER, UTC */
       72 MIN_AGE_HOURS,
        'TIME' AGGREGATE_BY,                 /* TIME, ID, STATE, SEVERITY or comma separated combinations, NONE for no aggregation */
        'DAY' TIME_AGGREGATE_BY              /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
      FROM
        DUMMY
    ) 
  ) BI,
    _SYS_STATISTICS.STATISTICS_EMAIL_PROCESSING SE
  WHERE
    ( BI.MIN_AGE_HOURS = -1 OR SECONDS_BETWEEN(SE.SNAPSHOT_ID, CURRENT_TIMESTAMP) >= BI.MIN_AGE_HOURS * 3600 )
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(SE.SNAPSHOT_ID, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE SE.SNAPSHOT_ID END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(SE.SNAPSHOT_ID, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE SE.SNAPSHOT_ID END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ID')       != 0 THEN TO_VARCHAR(SE.ALERT_ID)                          ELSE 'any' END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATE')    != 0 THEN SE.STATE                                      ELSE 'any' END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SEVERITY') != 0 THEN TO_VARCHAR(SE.SEVERITY)                          ELSE 'any' END
)
ORDER BY
  BEGIN_TIME DESC,
  ALERT_ID,
  STATE,
  SEVERITY