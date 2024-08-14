SELECT
/* 

[NAME]

- HANA_Instances_Activities_1.00.120+

[DESCRIPTION]

- Displays instance activities like savepoints, merges or unloads

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_CS_LOADS only available as of SAP HANA SPS 08
- HOST_JOB_HISTORY only available as of SAP HANA SPS 12

[VALID FOR]

- Revisions:              >= 1.00.120

[SQL COMMAND VERSION]

- 2015/01/26:  1.0 (initial version)
- 2015/12/09:  1.1 ("blk. phase" for savepoints included)
- 2016/07/18:  1.2 (dedicated Rev120+ version including HOST_JOB_HISTORY)
- 2017/10/24:  1.3 (TIMEZONE included)
- 2018/12/04:  1.4 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- HOST_SAVEPOINTS
- HOST_DELTA_MERGE_STATISTICS
- HOST_JOB_HISTORY
- M_CS_LOADS
- M_CS_UNLOADS

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

  'saphana01'     --> Specic host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- PORT

  Port number

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- DISPLAY_MERGES

  Possiblity to configure the display of merge information

  'X'             --> Merge operations are displayed
  ' '             --> Merge operations are suppressed
 
- DISPLAY_SAVEPOINTS

  Possiblity to configure the display of savepoint information

  'X'             --> Savepoints are displayed
  ' '             --> Savepoints are not displayed
 
- DISPLAY_LOADS

  Possiblity to configure the display of load information

  'X'             --> Load operations are displayed
  ' '             --> Load operations are suppressed
 
- DISPLAY_UNLOADS

  Possiblity to configure the display of unload information

  'X'             --> Unload operations are displayed
  ' '             --> Unload operations are suppressed

- MIN_DURATION_MS

  Minimum duration time in milli seconds

  100             --> Minimum duration time of 100 ms
  -1              --> No restriction of minimum duration time
 
[OUTPUT PARAMETERS]

- BEGIN_TIME:    Begin time
- END_TIME:      End time
- RUNTIME_S:     Runtime of activity (s)
- HOST:          Host name
- PORT:          Port
- ACTIVITY_TYPE: Type of activity (MERGE, SAVEPOINT, LOAD, UNLOAD)
- DETAIL_1:      Activity related detail:
                 MERGE, UNLOAD, LOAD: Schema + table
                 SAVEPOINT:           Write size (MB)
- DETAIL_2:      Activity related detail:
                 MERGE:               Merge type
                 LOAD, UNLOAD:        Column name
                 SAVEPOINT:           Critical phase duration (s)       

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------------------------------------------------
|BEGIN_TIME             |END_TIME               |RUNTIME_S|HOST         |PORT |ACTIVITY_TYPE|DETAIL_1               |DETAIL_2           |
-----------------------------------------------------------------------------------------------------------------------------------------
|2015/01/21 06:18:51:625|2015/01/21 06:19:01:512|     9.88|saphanahost04|30003|MERGE        |SAPSR3./BIC/AZ4APD10200|MERGE (SMART)      |
|2015/01/21 06:18:51:623|2015/01/21 06:19:00:880|     9.25|saphanahost03|30003|MERGE        |SAPSR3./BIC/AZ4APD10200|MERGE (SMART)      |
|2015/01/21 06:18:51:622|2015/01/21 06:19:03:345|    11.72|saphanahost02|30003|MERGE        |SAPSR3./BIC/AZ4APD10200|MERGE (SMART)      |
|2015/01/21 06:18:51:441|2015/01/21 06:18:54:190|     2.74|saphanahost03|30003|SAVEPOINT    |849.93 MB              |Crit. phase: 0.00 s|
|2015/01/21 06:18:45:027|2015/01/21 06:18:48:144|     3.11|saphanahost04|30003|MERGE        |SAPSR3./BIC/B0006587001|MERGE (SMART)      |
|2015/01/21 06:18:41:464|2015/01/21 06:18:43:551|     2.08|saphanahost04|30003|MERGE        |SAPSR3./BIC/B0002177000|MERGE (SMART)      |
|2015/01/21 06:18:38:222|2015/01/21 06:18:46:133|     7.91|saphanahost04|30003|SAVEPOINT    |1774.14 MB             |Crit. phase: 0.03 s|
|2015/01/21 06:18:30:123|2015/01/21 06:18:31:166|     1.04|saphanahost04|30003|MERGE        |SAPSR3./BIC/B0009010000|MERGE (SMART)      |
|2015/01/21 06:16:18:471|2015/01/21 06:16:19:526|     1.05|saphanahost03|30003|MERGE        |SAPSR3./BIC/FZ5APD102  |MERGE (SMART)      |
|2015/01/21 06:16:06:549|2015/01/21 06:16:08:643|     2.09|saphanahost02|30003|MERGE        |SAPSR3./BIC/FZ5APD103  |MERGE (SMART)      |
|2015/01/21 06:16:03:290|2015/01/21 06:16:10:271|     6.98|saphanahost01|30003|SAVEPOINT    |624.29 MB              |Crit. phase: 0.89 s|
|2015/01/21 06:15:55:102|2015/01/21 06:15:58:535|     3.43|saphanahost04|30003|MERGE        |SAPSR3./BIC/FZ5APD104  |MERGE (SMART)      |
|2015/01/21 06:15:48:114|2015/01/21 06:15:49:190|     1.07|saphanahost04|30003|MERGE        |SAPSR3./BIC/B0005401000|MERGE (SMART)      |
|2015/01/21 06:15:48:020|2015/01/21 06:15:51:749|     3.72|saphanahost02|30003|MERGE        |SAPSR3./BIC/AZRICRMM100|MERGE (SMART)      |
|2015/01/21 06:15:38:613|2015/01/21 06:15:50:475|    11.86|saphanahost04|30003|MERGE        |SAPSR3./BIC/AZ2BOST0100|MERGE (SMART)      |
|2015/01/21 06:15:38:610|2015/01/21 06:15:54:760|    16.15|saphanahost02|30003|MERGE        |SAPSR3./BIC/AZ2BOST0100|MERGE (SMART)      |
|2015/01/21 06:15:38:608|2015/01/21 06:15:52:675|    14.06|saphanahost03|30003|MERGE        |SAPSR3./BIC/AZ2BOST0100|MERGE (SMART)      |
|2015/01/21 06:15:36:882|2015/01/21 06:15:48:105|    11.22|saphanahost01|30003|SAVEPOINT    |1434.78 MB             |Crit. phase: 2.03 s|
|2015/01/21 06:15:26:349|2015/01/21 06:15:29:525|     3.17|saphanahost02|30003|MERGE        |SAPSR3./BIC/AZ4APD10100|MERGE (SMART)      |
-----------------------------------------------------------------------------------------------------------------------------------------

*/

  TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(A.BEGIN_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE A.BEGIN_TIME END, 'YYYY/MM/DD HH24:MI:SS:FF3') BEGIN_TIME,
  TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(A.END_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE A.END_TIME END, 'YYYY/MM/DD HH24:MI:SS:FF3') END_TIME,
  LPAD(TO_DECIMAL(A.RUNTIME_S, 10, 2), 9) RUNTIME_S,
  A.HOST,
  LPAD(A.PORT, 5) PORT,
  A.ACTIVITY_TYPE,
  A.DETAIL_1,
  A.DETAIL_2
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
    DISPLAY_MERGES,
    DISPLAY_SAVEPOINTS,
    DISPLAY_LOADS,
    DISPLAY_UNLOADS,
    DISPLAY_JOBS,
    MIN_DURATION_MS
  FROM
  ( SELECT                 /* Modification section */
      '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
      '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
      'SERVER' TIMEZONE,                              /* SERVER, UTC */
      '%' HOST,
      '%' PORT,
      'X' DISPLAY_MERGES,
      'X' DISPLAY_SAVEPOINTS,
      'X' DISPLAY_LOADS,
      'X' DISPLAY_UNLOADS,
      'X' DISPLAY_JOBS,
      -1 MIN_DURATION_MS
    FROM
      DUMMY
  )
) BI,
( SELECT DISTINCT
    'SAVEPOINT' ACTIVITY_TYPE,
    HOST,
    PORT,
    START_TIME BEGIN_TIME,
    ADD_SECONDS(START_TIME, DURATION / 1000000) END_TIME,
    DURATION / 1000000 RUNTIME_S,
    TO_VARCHAR(TO_DECIMAL(TOTAL_SIZE / 1024 / 1024, 10, 2)) || CHAR(32) || 'MB' DETAIL_1,
    'Blk. phase:' || CHAR(32) || TO_VARCHAR(TO_DECIMAL((CRITICAL_PHASE_WAIT_TIME + CRITICAL_PHASE_DURATION) / 1000000, 10, 2)) || CHAR(32) || 's,' || CHAR(32) ||
      'crit. phase:' || CHAR(32) || TO_VARCHAR(TO_DECIMAL(CRITICAL_PHASE_DURATION / 1000000, 10, 2)) || CHAR(32) || 's' DETAIL_2
  FROM
    _SYS_STATISTICS.HOST_SAVEPOINTS
  UNION ALL
  ( SELECT DISTINCT
      'MERGE' ACTIVITY_TYPE,
      HOST,
      PORT,
      START_TIME BEGIN_TIME,
      ADD_SECONDS(START_TIME, EXECUTION_TIME / 1000) END_TIME,
      EXECUTION_TIME / 1000 RUNTIME_S,
      SCHEMA_NAME || '.' || TABLE_NAME DETAIL_1,
      TYPE || CHAR(32) || '(' || MOTIVATION || ')' DETAIL_2
    FROM
      _SYS_STATISTICS.HOST_DELTA_MERGE_STATISTICS
  )
  UNION ALL
  ( SELECT
      'LOAD' ACTIVITY_TYPE,
      HOST,
      PORT,
      LOAD_TIME BEGIN_TIME,
      LOAD_TIME END_TIME,
      0 RUNTIME_S,
      SCHEMA_NAME || '.' || TABLE_NAME DETAIL_1,
      COLUMN_NAME DETAIL_2
    FROM
      M_CS_LOADS
  )
  UNION ALL
  ( SELECT
      'UNLOAD' ACTIVITY_TYPE,
      HOST,
      PORT,
      UNLOAD_TIME BEGIN_TIME,
      UNLOAD_TIME END_TIME,
      0 RUNTIME_S,
      SCHEMA_NAME || '.' || TABLE_NAME DETAIL_1,
      COLUMN_NAME DETAIL_2
    FROM
      M_CS_UNLOADS
  )
  UNION ALL
  ( SELECT
      'JOB:' || CHAR(32) || UPPER(JOB_NAME) ACTIVITY_TYPE,
      JOB_HOST,
      JOB_PORT,
      START_TIME,
      END_TIME,
      SECONDS_BETWEEN(START_TIME, END_TIME),
      '',
      ''
    FROM
      _SYS_STATISTICS.HOST_JOB_HISTORY
  )
) A
WHERE
  A.HOST LIKE BI.HOST AND
  TO_VARCHAR(A.PORT) LIKE BI.PORT AND
  ( CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(A.END_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE A.END_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME OR 
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(A.BEGIN_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE A.BEGIN_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME 
  ) AND
  ( BI.MIN_DURATION_MS = -1 OR A.RUNTIME_S >= BI.MIN_DURATION_MS / 1000 ) AND
  ( BI.DISPLAY_MERGES     = 'X' AND A.ACTIVITY_TYPE = 'MERGE'     OR
    BI.DISPLAY_SAVEPOINTS = 'X' AND A.ACTIVITY_TYPE = 'SAVEPOINT' OR
    BI.DISPLAY_LOADS      = 'X' AND A.ACTIVITY_TYPE = 'LOAD' OR
    BI.DISPLAY_UNLOADS    = 'X' AND A.ACTIVITY_TYPE = 'UNLOAD' OR
    BI.DISPLAY_JOBS       = 'X' AND A.ACTIVITY_TYPE LIKE 'JOB:%'
  )
ORDER BY
  A.BEGIN_TIME DESC

      
