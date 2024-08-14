SELECT

/* 

[NAME]

- HANA_liveCache_OMSVersions_2.00.060+

[DESCRIPTION]

- Display SAP HANA OMS version information
- Versions will be cleaned when indexserver.ini -> [livecache] -> max_version_retention_time (default: 480 minutes) is reached
- SITE_ID in history tables available with SAP HANA >= 2.0 SPS 06

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Only populated if SAP HANA integrated liveCache is used
- liveCache containers may be reflected in related heap areas (Pool/LVCAllocator/LVCContainerDir/LVCContainer_<container_id>)
- HOST_LIVECACHE_OMS_VERSIONS only available starting with SAP HANA 1.00.90
- HOST and PORT not available in history
- Fails in SAP HANA Cloud (SHC) environments because liveCache is no longer available

[VALID FOR]

- Revisions:              >= 1.00.90

[SQL COMMAND VERSION]

- 2018/01/25:  1.0 (initial version)
- 2018/12/04:  1.1 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2022/05/26:  1.2 (dedicated 2.00.060+ version including SITE_ID for data source HISTORY)

[INVOLVED TABLES]

- HOST_LIVECACHE_OMS_VERSIONS
- M_LIVECACHE_OMS_VERSIONS

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

- SITE_ID

  System replication site ID

  -1             --> No restriction related to site ID
  1              --> Site id 1

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

- VERSION_ID

  OMS version identifier

  '6DloqBPT7kY0kTC0w1gDpG' --> Version ID 6DloqBPT7kY0kTC0w1gDpG
  '%'                      --> No restriction related to version ID

- VERSION_DESCRIPTION

  OMS version description

  '/SAPAPO/SAPMMSDP%' --> Version description starting with '/SAPAPO/SAPMMSDP'
  '%'                 --> No restriction related to version description

- MIN_AGE_MINUTES

  Minimum version age (in minutes)

  300            --> Only show versions older than 300 minutes
  -1             --> No restriction related to version age

- IS_OPEN

  Indicator if version is currently open

  'TRUE'          --> Only show open versions
  '%'             --> No restriction related to version open state

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'CLASS'         --> Aggregation by class name
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'TIME'          --> Sorting by timestamp 
  'AGE'           --> Sorting by age of OMS version

[OUTPUT PARAMETERS]

- SNAPSHOT_TIME:       Snapshot time
- ST:                  System replication site ID
- HOST:                Host name
- PORT:                Port
- VERSION_ID:          Version identifier
- IS_OPEN:             Indicator if version is currently open (TRUE) or not (FALSE)
- CREATE_DATE:         Creation date of version
- LAST_OPEN_DATE:      Last open date of version
- AGE_MINUTES:         Version age (minutes)
- AVG_HEAP_MB:         Average allocated heap memory (MB)
- VERSION_DESCRIPTION: Version description

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SNAPSHOT_TIME      |HOST    |PORT |VERSION_ID            |IS_OPEN|CREATE_DATE        |LAST_OPEN_DATE     |AGE_MINUTES|AVG_HEAP_MB|VERSION_DESCRIPTION                                                            |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2018/01/25 17:29:28|saphana8|32003|6DlooLVT7kY0jgr2}8Pj5G|FALSE  |2018/01/25 10:52:11|2018/01/25 17:24:13|     397.00|       1.31|/SAPAPO/SAPMMSDP                        /SAPAPO/SDP         BIANCFEDE1  001 000|
|2018/01/25 17:29:28|saphana8|32003|6DlooLVT7kY0jgr2}8PD5G|FALSE  |2018/01/25 10:52:11|2018/01/25 17:24:13|     397.00|       0.54|/SAPAPO/SAPMMSDP                        /SAPAPO/SDP         BIANCFEDE1  001 000|
|2018/01/25 17:29:28|saphana8|32003|6DloqBPT7kY0kOIYvaQgAW|FALSE  |2018/01/25 13:34:55|2018/01/25 16:21:05|     235.00|       1.47|/SAPAPO/SAPMMSDP                        /SAPAPO/SDP         DEMARMAUR2  001 000|
|2018/01/25 17:29:28|saphana8|32003|6DloqBPT7kY0kOIYvaQAAW|FALSE  |2018/01/25 13:34:55|2018/01/25 16:21:05|     235.00|       0.57|/SAPAPO/SAPMMSDP                        /SAPAPO/SDP         DEMARMAUR2  001 000|
|2018/01/25 17:29:28|saphana8|32003|6DloqBPT7kY0kTC0w1gDpG|FALSE  |2018/01/25 13:52:26|2018/01/25 16:04:10|     217.00|       0.45|/SAPAPO/SAPRRP_ENTRY                    /SAPAPO/RRP3        SIMONENRI1  001 000|
|2018/01/25 17:29:28|saphana8|32003|6DlooLVT7jY0kg4zVsOTVW|FALSE  |2018/01/25 14:38:34|2018/01/25 14:43:24|     171.00|       0.26|/SAPAPO/SAPMMSDP                        /SAPAPO/SDP         ZANELMIRK1  001 000|
|2018/01/25 17:29:28|saphana8|32003|6DlooLVT7jY0kg4zVsOzVW|FALSE  |2018/01/25 14:38:34|2018/01/25 14:43:24|     171.00|       0.33|/SAPAPO/SAPMMSDP                        /SAPAPO/SDP         ZANELMIRK1  001 000|
|2018/01/25 17:29:28|saphana8|32003|6DlooLVT7kY0kkHDNGC0em|FALSE  |2018/01/25 14:53:34|2018/01/25 14:53:36|     156.00|       0.34|/SAPAPO/SAPMMSDP                        /SAPAPO/SDP         ZANELMIRK1  001 000|
|2018/01/25 17:29:28|saphana8|32003|6DlooLVT7kY0kkHDNGCWem|FALSE  |2018/01/25 14:53:34|2018/01/25 14:53:36|     156.00|       0.31|/SAPAPO/SAPMMSDP                        /SAPAPO/SDP         ZANELMIRK1  001 000|
|2018/01/25 17:29:28|saphana8|32003|6DloqBPT7kY0kptsXBuV1m|FALSE  |2018/01/25 15:13:37|2018/01/25 17:26:59|     136.00|       0.29|/SAPAPO/SAPMMSDP                        /SAPAPO/SDP         ORLANANGE1  001 000|
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  SNAPSHOT_TIME,
  IFNULL(LPAD(SITE_ID, 2), '') ST,
  HOST,
  LPAD(PORT, 5) PORT,
  VERSION_ID,
  IS_OPEN,
  CREATE_DATE,
  LAST_OPEN_DATE,
  LPAD(TO_DECIMAL(ROUND(AGE_IN_MINUTES), 10, 2), 11) AGE_MINUTES,
  LPAD(TO_DECIMAL(AVG_HEAP_USAGE_MB, 10, 2), 11) AVG_HEAP_MB,
  VERSION_DESCRIPTION
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(O.SNAPSHOT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE O.SNAPSHOT_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(O.SNAPSHOT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE O.SNAPSHOT_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END SNAPSHOT_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SITE_ID')     != 0 THEN TO_VARCHAR(O.SITE_ID) ELSE MAP(BI.SITE_ID,              -1, 'any', TO_VARCHAR(BI.SITE_ID)) END SITE_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')        != 0 THEN O.HOST                ELSE MAP(BI.HOST,                '%', 'any', BI.HOST)                END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')        != 0 THEN TO_VARCHAR(O.PORT)    ELSE MAP(BI.PORT,                '%', 'any', BI.PORT)                END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'VERSION_ID')  != 0 THEN O.VERSION_ID          ELSE MAP(BI.VERSION_ID,          '%', 'any', BI.VERSION_ID)          END VERSION_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DESCRIPTION') != 0 THEN O.VERSION_DESCRIPTION ELSE MAP(BI.VERSION_DESCRIPTION, '%', 'any', BI.VERSION_DESCRIPTION) END VERSION_DESCRIPTION,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'IS_OPEN')     != 0 THEN O.IS_OPEN             ELSE MAP(BI.IS_OPEN,             '%', 'any', BI.IS_OPEN)             END IS_OPEN,
    MAP(MIN(O.CREATE_DATE), MAX(O.CREATE_DATE), TO_VARCHAR(MAX(O.CREATE_DATE), 'YYYY/MM/DD HH24:MI:SS'), 'any') CREATE_DATE,
    MAP(MIN(O.LAST_OPEN_DATE), MAX(O.LAST_OPEN_DATE), TO_VARCHAR(MAX(O.LAST_OPEN_DATE), 'YYYY/MM/DD HH24:MI:SS'), 'any') LAST_OPEN_DATE,
    AVG(O.AGE_IN_MINUTES) AGE_IN_MINUTES,
    AVG(O.HEAP_USAGE) / 1024 / 1024 AVG_HEAP_USAGE_MB,
    BI.ORDER_BY
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
      SITE_ID,
      HOST,
      PORT,
      VERSION_ID,
      VERSION_DESCRIPTION,
      MIN_AGE_MINUTES,
      IS_OPEN,
      DATA_SOURCE,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS',
        'HOUR',        'YYYY/MM/DD HH24',
        'DAY',         'YYYY/MM/DD (DY)',
        'HOUR_OF_DAY', 'HH24',
        TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
      ORDER_BY
    FROM
    ( SELECT              /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        'SERVER' TIMEZONE,
        -1 SITE_ID,
        '%' HOST,
        '%' PORT,
        '%' VERSION_ID,
        '%' VERSION_DESCRIPTION,
        -1 MIN_AGE_MINUTES,
        '%' IS_OPEN,
        'CURRENT' DATA_SOURCE,           /* CURRENT, HISTORY */
        'NONE' AGGREGATE_BY,           /* TIME, SITE_ID, HOST, PORT, VERSION_ID, DESCRIPTION, IS_OPEN or comma separated combinations, NONE for no aggregation */
        'NONE' TIME_AGGREGATE_BY,       /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'AGE' ORDER_BY                  /* TIME, AGE, DESCRIPTION */
      FROM
        DUMMY
    )
  ) BI,
  ( SELECT
      'CURRENT' DATA_SOURCE,
      CURRENT_TIMESTAMP SNAPSHOT_TIME,
      CURRENT_SITE_ID() SITE_ID,
      HOST,
      PORT,
      VERSION_ID,
      VERSION_DESCRIPTION,
      CREATE_DATE,
      LAST_OPEN_DATE,
      SECONDS_BETWEEN(CREATE_DATE, CURRENT_TIMESTAMP) / 60 AGE_IN_MINUTES,
      IS_OPEN,
      HEAP_USAGE
    FROM
      M_LIVECACHE_OMS_VERSIONS
    UNION ALL
    SELECT
      'HISTORY' DATA_SOURCE,
      SERVER_TIMESTAMP SNAPSHOT_TIME,
      SITE_ID,
      HOST,
      PORT,
      VERSION_ID,
      VERSION_DESCRIPTION,
      CREATE_DATE,
      LAST_OPEN_DATE,
      AGE_IN_MINUTES,
      IS_OPEN,
      HEAP_USAGE
    FROM
      _SYS_STATISTICS.HOST_LIVECACHE_OMS_VERSIONS
  ) O
  WHERE
    ( BI.DATA_SOURCE = 'CURRENT' OR
     CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(O.SNAPSHOT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE O.SNAPSHOT_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME
    ) AND
    ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND O.SITE_ID IN (-1, 0) ) OR O.SITE_ID = BI.SITE_ID ) AND
    O.HOST LIKE BI.HOST AND
    TO_VARCHAR(O.PORT) LIKE BI.PORT AND
    BI.DATA_SOURCE = O.DATA_SOURCE AND
    O.VERSION_ID LIKE BI.VERSION_ID AND
    O.VERSION_DESCRIPTION LIKE BI.VERSION_DESCRIPTION AND
    O.IS_OPEN LIKE BI.IS_OPEN AND
    ( BI.MIN_AGE_MINUTES = -1 OR O.AGE_IN_MINUTES >= BI.MIN_AGE_MINUTES )
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(O.SNAPSHOT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE O.SNAPSHOT_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(O.SNAPSHOT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE O.SNAPSHOT_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SITE_ID')     != 0 THEN TO_VARCHAR(O.SITE_ID) ELSE MAP(BI.SITE_ID,              -1, 'any', TO_VARCHAR(BI.SITE_ID)) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')        != 0 THEN O.HOST                ELSE MAP(BI.HOST,                '%', 'any', BI.HOST)                END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')        != 0 THEN TO_VARCHAR(O.PORT)    ELSE MAP(BI.PORT,                '%', 'any', BI.PORT)                END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'VERSION_ID')  != 0 THEN O.VERSION_ID          ELSE MAP(BI.VERSION_ID,          '%', 'any', BI.VERSION_ID)          END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DESCRIPTION') != 0 THEN O.VERSION_DESCRIPTION ELSE MAP(BI.VERSION_DESCRIPTION, '%', 'any', BI.VERSION_DESCRIPTION) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'IS_OPEN')     != 0 THEN O.IS_OPEN             ELSE MAP(BI.IS_OPEN,             '%', 'any', BI.IS_OPEN)             END,
    ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'TIME', SNAPSHOT_TIME) DESC,
  MAP(ORDER_BY, 'AGE', AGE_IN_MINUTES) DESC,
  MAP(ORDER_BY, 'DESCRIPTION', VERSION_DESCRIPTION),
  SNAPSHOT_TIME,
  AGE_IN_MINUTES,
  VERSION_DESCRIPTION
