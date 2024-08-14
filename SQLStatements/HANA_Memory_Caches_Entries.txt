SELECT
/* 

[NAME]

- HANA_Memory_Caches_Entries

[DESCRIPTION]

- SAP HANA cache entries

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2017/05/17:  1.0 (initial version)
- 2021/07/19:  1.1 (CREATE_TIME included)
- 2023/05/05:  1.2 (TOTAL_READS included)

[INVOLVED TABLES]

- M_CACHE_ENTRIES

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

- SERVICE_NAME

  Service name

  'indexserver'   --> Specific service indexserver
  '%server'       --> All services ending with 'server'
  '%'             --> All services  

- CACHE_NAME

  Name of cache

  'MdxEntityCache' --> Only display information related to MdxEntityCache
  'CS%'            --> Display information for all caches starting with 'CS'
  '%'              --> No restriction related to cache name

- COMPONENT

  Cache component

  'OLAP'          --> Only shows cache entries with component OLAP
  '%'             --> No limitation related to cache component

- USER_NAME

  Cache user name

  'SAP123'        --> Only show caches entries of user SAP123
  '%'             --> No limitation related to user name

- ENTRY_NAME

  Cache entry name

  '%PURCHASE%'     --> Only display cache entries with a name containing 'PURCHASE'
  '%'              --> No limitation related to cache entry name

- MIN_MEMORY_SIZE_MB

  Minimum memory size threshold (MB)

  10              --> Only display cache entries with a size of at least 10 MB
  -1              --> No limitation related to minimum cache entry size

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'SERVICE'       --> Aggregation by service
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

  'SIZE'          --> Sorting by size 
  'CACHE'         --> Sorting by cache name
  'HOST'          --> Sorting by host
  
[OUTPUT PARAMETERS]

- CREATE_TIME:      Creation time 
- HOST:             Host name
- PORT:             Port
- SERVICE_NAME:     Service name
- CACHE_NAME:       Cache name
- ENTRY_NAME:       Name of cache entry
- ENTRIES:          Number of cache entries
- READS:            Average number of cache reads
- TOTAL_READS:      Total number of cache reads
- COMPONENT:        Cache component
- USER_NAME:        User name
- MEM_MB:           Used cache memory (MB)
- MEM_PER_ENTRY_KB: Used cache memory per entry (KB)

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------
|HOST    |PORT |SERVICE_NAME|CACHE_NAME            |ENTRY_NAME            |ENTRIES   |COMPONENT|USER_NAME|MEM_MB    |
---------------------------------------------------------------------------------------------------------------------
|saphana5|30004|scriptserver|AdapterOperationsCache|Data Cleanse          |        90|OpAdapter|         |      0.07|
|saphana4|30004|scriptserver|AdapterOperationsCache|Data Cleanse          |        90|OpAdapter|         |      0.07|
|saphana5|30004|scriptserver|AdapterOperationsCache|Global Address Cleanse|        30|OpAdapter|         |      0.02|
|saphana4|30004|scriptserver|AdapterOperationsCache|Global Address Cleanse|        30|OpAdapter|         |      0.02|
|saphana5|30004|scriptserver|AdapterOperationsCache|Type Identification   |        20|OpAdapter|         |      0.01|
|saphana4|30004|scriptserver|AdapterOperationsCache|Type Identification   |        20|OpAdapter|         |      0.01|
|saphana5|30004|scriptserver|AdapterOperationsCache|Match                 |        20|OpAdapter|         |      0.00|
|saphana4|30004|scriptserver|AdapterOperationsCache|Match                 |        20|OpAdapter|         |      0.00|
---------------------------------------------------------------------------------------------------------------------

*/

  CREATE_TIME,
  HOST,
  LPAD(PORT, 5) PORT,
  SERVICE_NAME,
  CACHE_NAME,
  ENTRY_NAME,
  LPAD(ENTRIES, 10) ENTRIES,
  LPAD(READS, 6) READS,
  LPAD(TOTAL_READS, 11) TOTAL_READS,
  COMPONENT,
  USER_NAME,
  LPAD(TO_DECIMAL(MEM_MB, 10, 2), 10) MEM_MB,
  LPAD(TO_DECIMAL(MAP(ENTRIES, 0, 0, MEM_MB * 1024 / ENTRIES), 10, 2), 16) MEM_PER_ENTRY_KB
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(C.CREATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE C.CREATE_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(C.CREATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE C.CREATE_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END CREATE_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')      != 0 THEN S.HOST                   ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                 END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')      != 0 THEN TO_VARCHAR(S.PORT)       ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                 END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE')   != 0 THEN S.SERVICE_NAME           ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME) END SERVICE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CACHE')     != 0 THEN C.CACHE_ID               ELSE MAP(BI.CACHE_NAME, '%', 'any', BI.CACHE_NAME)     END CACHE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COMPONENT') != 0 THEN C.COMPONENT              ELSE MAP(BI.COMPONENT, '%', 'any', BI.COMPONENT)       END COMPONENT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'USER')      != 0 THEN C.USER_NAME              ELSE MAP(BI.USER_NAME, '%', 'any', BI.USER_NAME)       END USER_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ENTRY')     != 0 THEN C.ENTRY_DESCRIPTION      ELSE MAP(BI.ENTRY_NAME, '%', 'any', BI.ENTRY_NAME)     END ENTRY_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'READS')     != 0 THEN TO_VARCHAR(C.READ_COUNT) ELSE 'any'                                             END READS,
    COUNT(*) ENTRIES,
    SUM(C.MEMORY_SIZE / 1024 / 1024) MEM_MB,
    SUM(C.READ_COUNT) TOTAL_READS,
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
      HOST,
      PORT,
      SERVICE_NAME,
      CACHE_NAME,
      COMPONENT,
      USER_NAME,
      ENTRY_NAME,
      MIN_MEMORY_SIZE_MB,
      ORDER_BY,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS',
        'HOUR',        'YYYY/MM/DD HH24',
        'DAY',         'YYYY/MM/DD (DY)',
        'HOUR_OF_DAY', 'HH24',
        TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY
    FROM
    ( SELECT                     /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */      
        'SERVER' TIMEZONE,                              /* SERVER, UTC */
        '%' HOST,
        '%' PORT,
        '%' SERVICE_NAME,
        'CE_ScenarioModelCache' CACHE_NAME,
        '%' COMPONENT,
        '%' USER_NAME,
        '%' ENTRY_NAME,
        -1 MIN_MEMORY_SIZE_MB,
        'READS' AGGREGATE_BY,     /* HOST, PORT, SERVICE, CACHE, COMPONENT, USER, ENTRY, READS or comma separated combination, NONE for no aggregation */
        'NONE' TIME_AGGREGATE_BY,    /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'SIZE' ORDER_BY        /* TIME, SIZE, HOST, CACHE, ENTRY, READS */
      FROM
        DUMMY
    )
  ) BI,
    M_SERVICES S,
    M_CACHE_ENTRIES C
  WHERE
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(C.CREATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE C.CREATE_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    S.HOST LIKE BI.HOST AND
    TO_VARCHAR(S.PORT) LIKE BI.PORT AND
    C.HOST = S.HOST AND
    C.PORT = S.PORT AND
    UPPER(C.CACHE_ID) LIKE UPPER(BI.CACHE_NAME) AND
    IFNULL(C.COMPONENT, '') LIKE BI.COMPONENT AND
    IFNULL(C.USER_NAME, '') LIKE BI.USER_NAME AND
    C.ENTRY_DESCRIPTION LIKE BI.ENTRY_NAME AND
    ( BI.MIN_MEMORY_SIZE_MB = -1 OR C.MEMORY_SIZE / 1024 / 1024 >= BI.MIN_MEMORY_SIZE_MB )
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(C.CREATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE C.CREATE_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(C.CREATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE C.CREATE_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')      != 0 THEN S.HOST                   ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                 END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')      != 0 THEN TO_VARCHAR(S.PORT)       ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                 END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE')   != 0 THEN S.SERVICE_NAME           ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CACHE')     != 0 THEN C.CACHE_ID               ELSE MAP(BI.CACHE_NAME, '%', 'any', BI.CACHE_NAME)     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COMPONENT') != 0 THEN C.COMPONENT              ELSE MAP(BI.COMPONENT, '%', 'any', BI.COMPONENT)       END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'USER')      != 0 THEN C.USER_NAME              ELSE MAP(BI.USER_NAME, '%', 'any', BI.USER_NAME)       END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ENTRY')     != 0 THEN C.ENTRY_DESCRIPTION      ELSE MAP(BI.ENTRY_NAME, '%', 'any', BI.ENTRY_NAME)     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'READS')     != 0 THEN TO_VARCHAR(C.READ_COUNT) ELSE 'any'                                             END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'HOST', HOST || PORT || SERVICE_NAME),
  MAP(ORDER_BY, 'SIZE', MEM_MB) DESC,
  MAP(ORDER_BY, 'CACHE', CACHE_NAME),
  MAP(ORDER_BY, 'TIME', CREATE_TIME) DESC,
  MAP(ORDER_BY, 'READS', TOTAL_READS) DESC,
  ENTRY_NAME
