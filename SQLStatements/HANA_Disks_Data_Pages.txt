SELECT

/* 

[NAME]

- HANA_Disks_Data_Pages

[DESCRIPTION]

- Data pages overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2017/01/30:  1.0 (initial version)
- 2017/10/24:  1.1 (TIMEZONE included)
- 2018/05/01:  1.2 (MIN_SHADOW_SIZE_GB included)
- 2018/12/04:  1.3 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- M_DATA_VOLUME_PAGE_STATISTICS
- M_DATA_VOLUME_PAGE_STATISTICS_RESET
- HOST_DATA_VOLUME_PAGE_STATISTICS

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

- VOLUME_NAME

  Disk volume name

  '/hana/data/C11/mnt00001/hdb00002/' --> Volume '/hana/data/C11/mnt00001/hdb00002/'
  '%'                                 --> No volume related restriction

- PAGE_CLASS

  Page class

  '16M'           --> Only show information for 16M page class
  '%'             --> No restriction related to page class.  

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)
  '%'             --> All data sources

- MIN_PAGE_SIZE_KB

  Minimum page size (KB)

  16              --> Only display records for pages with at least 16 KB of size
  -1              --> No lower limit for page sizes

- MAX_PAGE_SIZE_KB

  Minimum page size (KB)

  16              --> Only display records for pages with at most 16 KB of size
  -1              --> No upper limit for page sizes

- MIN_SHADOW_SIZE_GB

  Minimum amount of shadow pages (GB)

  100             --> Only display lines with at least 100 GB of shadow pages
  -1              --> No restriction related to shadow pages

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'          --> Aggregation by time
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation
  
[OUTPUT PARAMETERS]

- SAMPLE_TIME:    Sample time
- HOST:           Host name
- PORT:           Port
- VOLUME_NAME:    Volume name
- PAGE_CLASS:     Page size class
- PAGE_SIZE:      Page size
- USED_PAGES:     Number of used pages
- SHADOW_PAGES:   Number of shadow pages
- USED_SIZE_GB:   Size of used pages (GB)
- SHADOW_SIZE_GB: Size of shadow pages (GB)
- SHADOW_PCT:     Percentage of shadow page size vs. used page size

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------------------------------------
|SAMPLE_TIME        |HOST    |PORT |VOLUME_NAME|PAGE_CLASS|PAGE_SIZE|USED_PAGES|SHADOW_PAGES|USED_SIZE_GB|SHADOW_SIZE_GB|SHADOW_PCT|
------------------------------------------------------------------------------------------------------------------------------------
|2017/01/31 09:37:38|saphana1|  %03|any        |any       |      any| 172992062|       24282|     3309.42|          1.69|      0.05|
|2017/01/31 09:33:27|saphana1|  %03|any        |any       |      any| 172969157|       19780|     3271.45|          1.22|      0.03|
|2017/01/31 09:27:38|saphana1|  %03|any        |any       |      any| 172928201|        8843|     3267.29|          0.96|      0.02|
|2017/01/31 09:22:38|saphana1|  %03|any        |any       |      any| 172849450|       37014|     3234.71|        125.45|      3.87|
|2017/01/31 09:17:40|saphana1|  %03|any        |any       |      any| 172799248|       29845|     3200.71|        124.37|      3.88|
|2017/01/31 09:12:39|saphana1|  %03|any        |any       |      any| 172713161|       49286|     3282.92|          1.68|      0.05|
|2017/01/31 09:07:39|saphana1|  %03|any        |any       |      any| 172752150|        5766|     3269.72|          0.63|      0.01|
------------------------------------------------------------------------------------------------------------------------------------

*/

  SAMPLE_TIME,
  HOST,
  LPAD(PORT, 5) PORT,
  VOLUME_NAME,
  PAGE_CLASS,
  LPAD(PAGE_SIZE, 9) PAGE_SIZE,
  LPAD(TO_DECIMAL(ROUND(USED_BLOCK_COUNT), 10, 0), 10) USED_PAGES,
  LPAD(TO_DECIMAL(ROUND(SHADOW_BLOCK_COUNT), 10, 0), 12) SHADOW_PAGES,
  LPAD(TO_DECIMAL(USED_BLOCK_SIZE_BYTE / 1024 / 1024 / 1024, 10, 2), 12) USED_SIZE_GB,
  LPAD(TO_DECIMAL(SHADOW_BLOCK_SIZE_BYTE / 1024 / 1024 / 1024, 10, 2), 14) SHADOW_SIZE_GB,
  LPAD(TO_DECIMAL(SHADOW_PCT, 10, 2), 10) SHADOW_PCT
FROM
( SELECT
    CASE 
      WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), SAMPLE_TIME) / SUBSTR(TIME_AGGREGATE_BY, 3)) * SUBSTR(TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(SAMPLE_TIME, TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END SAMPLE_TIME,
    HOST,
    PORT,
    VOLUME_NAME,
    PAGE_CLASS,
    PAGE_SIZE,
    AVG(USED_BLOCK_COUNT) USED_BLOCK_COUNT,
    AVG(SHADOW_BLOCK_COUNT) SHADOW_BLOCK_COUNT,
    AVG(USED_BLOCK_SIZE_BYTE) USED_BLOCK_SIZE_BYTE,
    AVG(SHADOW_BLOCK_SIZE_BYTE) SHADOW_BLOCK_SIZE_BYTE,
    MAP(AVG(USED_BLOCK_SIZE_BYTE), 0, 0, AVG(SHADOW_BLOCK_SIZE_BYTE) / AVG(USED_BLOCK_SIZE_BYTE) * 100) SHADOW_PCT,
    MIN_SHADOW_SIZE_GB
  FROM
  ( SELECT
      CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.SAMPLE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.SAMPLE_TIME END SAMPLE_TIME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')       != 0 THEN P.HOST                                                   ELSE MAP(BI.HOST, '%', 'any', BI.HOST)               END HOST,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')       != 0 THEN TO_VARCHAR(P.PORT)                                       ELSE MAP(BI.PORT, '%', 'any', BI.PORT)               END PORT,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'VOLUME')     != 0 THEN P.DATA_VOLUME_NAME                                       ELSE MAP(BI.VOLUME_NAME, '%', 'any', BI.VOLUME_NAME) END VOLUME_NAME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PAGE_CLASS') != 0 THEN TO_VARCHAR(P.PAGE_SIZECLASS)                             ELSE MAP(BI.PAGE_CLASS, '%', 'any', BI.PAGE_CLASS)   END PAGE_CLASS,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PAGE_SIZE')  != 0 THEN TO_VARCHAR(TO_DECIMAL(ROUND(P.PAGE_SIZE / 1024), 10, 0)) ELSE 'any'                                           END PAGE_SIZE,
      SUM(P.USED_BLOCK_COUNT) USED_BLOCK_COUNT,
      SUM(P.SHADOW_BLOCK_COUNT) SHADOW_BLOCK_COUNT,
      SUM(P.USED_BLOCK_COUNT * P.PAGE_SIZE) USED_BLOCK_SIZE_BYTE,
      SUM(P.SHADOW_BLOCK_COUNT * P.PAGE_SIZE) SHADOW_BLOCK_SIZE_BYTE,
      BI.MIN_SHADOW_SIZE_GB,
      BI.AGGREGATE_BY,
      BI.TIME_AGGREGATE_BY
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
        VOLUME_NAME,
        PAGE_CLASS,
        MIN_PAGE_SIZE_KB,
        MAX_PAGE_SIZE_KB,
        MIN_SHADOW_SIZE_GB,
        DATA_SOURCE,
        AGGREGATE_BY,
        MAP(TIME_AGGREGATE_BY,
          'NONE',        'YYYY/MM/DD HH24:MI:SS',
          'HOUR',        'YYYY/MM/DD HH24',
          'DAY',         'YYYY/MM/DD (DY)',
          'HOUR_OF_DAY', 'HH24',
          TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY
      FROM
      ( SELECT                                       /* Modification section */
          '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
          '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
          'SERVER' TIMEZONE,                              /* SERVER, UTC */
          '%' HOST,
          '%03' PORT,
          '%' VOLUME_NAME,
          '%' PAGE_CLASS,
          -1 MIN_PAGE_SIZE_KB,
          -1 MAX_PAGE_SIZE_KB,
          200 MIN_SHADOW_SIZE_GB,
          'HISTORY' DATA_SOURCE,       /* CURRENT, RESET, HISTORY */
          'HOST, TIME' AGGREGATE_BY,         /* TIME, HOST, PORT, VOLUME, PAGE_CLASS, PAGE_SIZE or comma separated combinations, NONE for no aggregation */
          'NONE' TIME_AGGREGATE_BY     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        FROM
          DUMMY
      )
    ) BI,
    ( SELECT
        'CURRENT' DATA_SOURCE,
        CURRENT_TIMESTAMP SAMPLE_TIME,
        HOST,
        PORT,
        DATA_VOLUME_NAME,
        PAGE_SIZECLASS,
        PAGE_SIZE,
        USED_BLOCK_COUNT,
        SHADOW_BLOCK_COUNT
      FROM
        M_DATA_VOLUME_PAGE_STATISTICS
      UNION ALL
      SELECT
        'RESET' DATA_SOURCE,
        CURRENT_TIMESTAMP SAMPLE_TIME,
        HOST,
        PORT,
        DATA_VOLUME_NAME,
        PAGE_SIZECLASS,
        PAGE_SIZE,
        USED_BLOCK_COUNT,
        SHADOW_BLOCK_COUNT
      FROM
        M_DATA_VOLUME_PAGE_STATISTICS_RESET
      UNION ALL
      SELECT
        'HISTORY' DATA_SOURCE,
        SERVER_TIMESTAMP SAMPLE_TIME,
        HOST,
        PORT,
        FILE_NAME DATA_VOLUME_NAME,
        PAGE_SIZE_CLASS PAGE_SIZECLASS,
        PAGE_SIZE,
        USED_BLOCK_COUNT,
        SHADOW_BLOCK_COUNT
      FROM
         _SYS_STATISTICS.HOST_DATA_VOLUME_PAGE_STATISTICS
    ) P
    WHERE
      CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.SAMPLE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.SAMPLE_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
      P.HOST LIKE BI.HOST AND
      TO_VARCHAR(P.PORT) LIKE BI.PORT AND
      P.DATA_VOLUME_NAME LIKE BI.VOLUME_NAME AND
      P.PAGE_SIZECLASS LIKE BI.PAGE_CLASS AND
      P.PAGE_SIZE / 1024 BETWEEN BI.MIN_PAGE_SIZE_KB AND MAP(BI.MAX_PAGE_SIZE_KB, -1, 99999999999, BI.MAX_PAGE_SIZE_KB) AND
      P.DATA_SOURCE = BI.DATA_SOURCE
    GROUP BY
      CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.SAMPLE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.SAMPLE_TIME END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')       != 0 THEN P.HOST                                                   ELSE MAP(BI.HOST, '%', 'any', BI.HOST)               END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')       != 0 THEN TO_VARCHAR(P.PORT)                                       ELSE MAP(BI.PORT, '%', 'any', BI.PORT)               END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'VOLUME')     != 0 THEN P.DATA_VOLUME_NAME                                       ELSE MAP(BI.VOLUME_NAME, '%', 'any', BI.VOLUME_NAME) END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PAGE_CLASS') != 0 THEN TO_VARCHAR(P.PAGE_SIZECLASS)                             ELSE MAP(BI.PAGE_CLASS, '%', 'any', BI.PAGE_CLASS)   END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PAGE_SIZE')  != 0 THEN TO_VARCHAR(TO_DECIMAL(ROUND(P.PAGE_SIZE / 1024), 10, 0)) ELSE 'any'                                           END,
      BI.AGGREGATE_BY,
      BI.TIME_AGGREGATE_BY,
      BI.MIN_SHADOW_SIZE_GB
  )
  GROUP BY
    CASE 
      WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), SAMPLE_TIME) / SUBSTR(TIME_AGGREGATE_BY, 3)) * SUBSTR(TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(SAMPLE_TIME, TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    HOST,
    PORT,
    VOLUME_NAME,
    PAGE_CLASS,
    PAGE_SIZE,
    MIN_SHADOW_SIZE_GB
)
WHERE
  MIN_SHADOW_SIZE_GB = -1 OR SHADOW_BLOCK_SIZE_BYTE / 1024 / 1024 / 1024 >= MIN_SHADOW_SIZE_GB
ORDER BY
  SAMPLE_TIME DESC,
  HOST,
  PORT,
  PAGE_SIZE,
  PAGE_CLASS