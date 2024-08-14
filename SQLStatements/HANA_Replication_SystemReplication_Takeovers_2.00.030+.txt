SELECT

/* 

[NAME]

- HANA_Replication_SystemReplication_Takeovers_2.00.030+

[DESCRIPTION]

- Historic system replication takeover activities

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- See SAP Note 1999880 for more information related to SAP HANA system repliation
- M_SYSTEM_REPLICATION_TAKEOVER_HISTORY available with SAP HANA >= 2.00.030

[VALID FOR]

- Revisions:              >= 2.00.030

[SQL COMMAND VERSION]

- 2018/11/21:  1.0 (initial version)
- 2018/12/05:  1.1 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- M_SYSTEM_REPLICATION_TAKEOVER_HISTORY

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

- TAKEOVER_TYPE

  System replication takeover type (ONLINE, OFFLINE, TIMETRAVEL)

  'ONLINE'       --> Only display takeovers with type ONLINE
  '%'            --> No restriction related to takeover type

[OUTPUT PARAMETERS]

- START_TIME:       Start time of takeover
- END_TIME:         End time of takeover
- DURATION_S:       Takeover duration (s)
- SRC_SITE_ID:      Source site ID
- SRC_SITE_NAME:    Source site name
- SRC_HOST:         Source SAP HANA nameserver master node
- SRC_VERSION:      Source SAP HANA version
- TGT_SITE_ID:      Target site ID
- TGT_SITE_NAME:    Target site name
- TGT_HOST:         Target SAP HANA nameserver master node
- TGT_VERSION:      Target SAP HANA version
- TYPE:             Takeover type
- OPERATION_MODE:   Operation mode
- LOG_POS_TIME:     Log position time
- SHP_LOG_POS_TIME: Shipped log position time

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|START_TIME         |END_TIME           |DURATION_S|SRC_SITE_ID|SRC_SITE_NAME|SRC_HOST   |SRC_VERSION           |TGT_SITE_ID|TGT_SITE_NAME|TGT_HOST   |TGT_VERSION           |TYPE  |OPERATION_MODE      |LOG_POS_TIME       |SHP_LOG_POS_TIME   |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2018/10/16 11:11:50|2018/10/16 11:12:31|        40|          2|7060         |saphana0001|2.00.033.00.1535711040|          1|7050         |saphana0002|2.00.033.00.1535711040|ONLINE|logreplay_readaccess|2018/10/16 11:11:47|2018/10/16 11:08:16|
|2018/10/16 11:01:58|2018/10/16 11:02:47|        48|          1|7050         |saphana0002|2.00.033.00.1535711040|          2|7060         |saphana0001|2.00.033.00.1535711040|ONLINE|logreplay_readaccess|2018/10/16 11:01:55|2018/10/16 10:47:35|
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

  TO_VARCHAR(START_TIME, 'YYYY/MM/DD HH24:MI:SS') START_TIME,
  TO_VARCHAR(END_TIME, 'YYYY/MM/DD HH24:MI:SS') END_TIME,
  LPAD(DURATION_S, 10) DURATION_S,
  LPAD(SRC_SITE_ID, 11) SRC_SITE_ID,
  SRC_SITE_NAME,
  SRC_HOST,
  SRC_VERSION,
  LPAD(TGT_SITE_ID, 11) TGT_SITE_ID,
  TGT_SITE_NAME,
  TGT_HOST,
  TGT_VERSION,
  TYPE,
  OPERATION_MODE,
  TO_VARCHAR(LOG_POS_TIME, 'YYYY/MM/DD HH24:MI:SS') LOG_POS_TIME,
  TO_VARCHAR(SHP_LOG_POS_TIME, 'YYYY/MM/DD HH24:MI:SS') SHP_LOG_POS_TIME  
FROM
( SELECT
    RT.TAKEOVER_START_TIME START_TIME,
    RT.TAKEOVER_END_TIME END_TIME,
    SECONDS_BETWEEN(RT.TAKEOVER_START_TIME, RT.TAKEOVER_END_TIME) DURATION_S,
    RT.SOURCE_SITE_ID SRC_SITE_ID,
    RT.SOURCE_SITE_NAME SRC_SITE_NAME,
    RT.SOURCE_MASTER_NAMESERVER_HOST SRC_HOST,
    RT.SOURCE_VERSION SRC_VERSION,
    RT.SITE_ID TGT_SITE_ID,
    RT.SITE_NAME TGT_SITE_NAME,
    RT.MASTER_NAMESERVER_HOST TGT_HOST,
    RT.VERSION TGT_VERSION,
    RT.TAKEOVER_TYPE TYPE,
    RT.OPERATION_MODE,
    RT.REPLICATION_STATUS,
    RT.LOG_POSITION_TIME LOG_POS_TIME,
    RT.SHIPPED_LOG_POSITION_TIME SHP_LOG_POS_TIME
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
      TAKEOVER_TYPE
    FROM
    ( SELECT                  /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        'SERVER' TIMEZONE,                              /* SERVER, UTC */
        '%' TAKEOVER_TYPE
      FROM
        DUMMY
    )
  ) BI,
    M_SYSTEM_REPLICATION_TAKEOVER_HISTORY RT
  WHERE
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(RT.TAKEOVER_START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE RT.TAKEOVER_START_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    RT.TAKEOVER_TYPE LIKE BI.TAKEOVER_TYPE
)
ORDER BY
  START_TIME DESC