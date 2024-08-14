WITH 

/* 

[NAME]

- HANA_Memory_Heap_Allocations_2.00.060+

[DESCRIPTION]

- Cumulated and historic heap memory allocations

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- With SAP HANA <= 2.00.066 allocators are only written to HOST_HEAP_ALLOCATORS when EXCLUSIVE_SIZE_IN_USE is significant. 
  Thus, allocators with high ALLOCATE and low USE values may be missing in the history (bug 296076).
- SITE_ID in history tables available with SAP HANA >= 2.0 SPS 06

[VALID FOR]

- Revisions:              >= 2.00.060

[SQL COMMAND VERSION]

- 2022/10/01:  1.0 (initial version)

[INVOLVED TABLES]

- HOST_HEAP_ALLOCATORS
- M_HEAP_MEMORY
- M_SERVICE_STATISTICS

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

- ALLOCATOR_NAME

  Heap allocator name

  'Pool/itab'     --> Heap allocator Pool/itab
  '%Version%'     --> Heap allocators containing 'Version' in name
  '%'             --> No restriction for heap allocator name

- MIN_ALLOC_MB_PER_S

  Lower limit for memory allocation rate (MB / s)

  1000            --> Only display results if memory allocation rate is at least 1000 MB / s
  -1              --> No restriction related to memory allocation rate

- MIN_ALLOCS_PER_S

  Lower limit for average memory allocations per second

  10000           --> Only display results if number of memory allocations is at least 10000 / s
  -1              --> No restriction related to number of memory allocations

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)
  '%'             --> All data sources

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

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'TIME'          --> Sorting by time
  'SIZE'          --> Sorting by allocated memory size

[OUTPUT PARAMETERS]

- SNAPSHOT_TIME:     Snapshot time
- ST:                System replication site ID
- HOST:              Host name
- PORT:              Port
- ALLOCATOR_NAME:    Heap allocator name
- ALLOC_MB_PER_S:    Memory allocation rate (MB / s)
- ALLOCS_PER_S:      Average number of allocations per second
- ALLOC_PCT:         Percentage of overall allocation size (per timestamp)
- AVG_ALLOC_SIZE_KB: Average memory allocation size (KB)
- ALLOC_GB:          Total memory allocation size (GB)
- ALLOCATIONS:       Total memory allocations

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SNAPSHOT_TIME      |HOST      |PORT |ALLOCATOR_NAME                           |ALLOC_MB_PER_S|ALLOCS_PER_S|ALLOC_PCT|AVG_ALLOC_SIZE_KB|ALLOC_GB    |ALLOCATIONS    |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2022/10/01 06:30:19|saphana001|30003|Pool/RowEngine/Session                   |      17933.30|      135057|    75.10|           135.96|    40824154|   314830107833|
|2022/10/01 06:30:19|saphana001|30003|Pool/itab                                |       1351.48|       57592|     5.65|            24.02|     3076571|   134251502788|
|2022/10/01 06:30:19|saphana001|30003|Pool/malloc/libhdbcs.so                  |        716.92|      112654|     3.00|             6.51|     1632050|   262605322558|
|2022/10/01 06:30:19|saphana001|30003|Pool/RowEngine/QueryExecution/SearchAlloc|        711.60|      130999|     2.98|             5.56|     1619932|   305369704842|
|2022/10/01 06:30:19|saphana001|30003|Pool/PerformanceAnalyzer                 |        641.52|       97623|     2.68|             6.72|     1460398|   227567794502|
|2022/10/01 06:30:19|saphana001|30003|Pool/CS_TableSearch                      |        418.01|       65629|     1.75|             6.52|      951586|   152986642658|
|2022/10/01 06:30:19|saphana001|30003|Pool/SearchAPI                           |        379.36|        2791|     1.58|           139.18|      863597|     6506135568|
|2022/10/01 06:30:19|saphana001|30003|Pool/BitVector                           |        285.60|       21355|     1.19|            13.69|      650152|    49780724892|
|2022/10/01 06:30:19|saphana001|30003|Pool/TableUpdate                         |         70.21|        7010|     0.29|            10.25|      159844|    16342367424|
|2022/10/01 06:30:19|saphana001|30003|Pool/RowEngine/QueryCompilation          |         70.14|        6424|     0.29|            11.17|      159670|    14976707886|
---------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

BASIS_INFO AS
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
    ALLOCATOR_NAME,
    MIN_ALLOC_MB_PER_S,
    MIN_ALLOCS_PER_S,
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
  ( SELECT                                                      /* Modification section */
      'MIN' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
      'MAX' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
      'SERVER' TIMEZONE,                              /* SERVER, UTC */
      -1 SITE_ID,
      '%' HOST,
      '%' PORT,
      'Pool/RowEngine/Session' ALLOCATOR_NAME,                   /* Name of table or heap area */
      -1 MIN_ALLOC_MB_PER_S,
      -1 MIN_ALLOCS_PER_S,
      'HISTORY' DATA_SOURCE,
      'TIME' AGGREGATE_BY,        /* TIME, SITE_ID, HOST, PORT, ALLOCATOR or comma separated combinations, NONE for no aggregation */
      'DAY' TIME_AGGREGATE_BY,       /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
      'SIZE' ORDER_BY                /* TIME, ALLOCATOR, SIZE, COUNT */
    FROM
      DUMMY
  )
),
HEAP_ALLOCATORS_CURRENT AS
( SELECT
    HOST,
    PORT,
    CATEGORY,
    SUM(EXCLUSIVE_ALLOCATED_SIZE) EXCLUSIVE_ALLOCATED_SIZE,
    SUM(EXCLUSIVE_ALLOCATED_COUNT) EXCLUSIVE_ALLOCATED_COUNT
  FROM
    M_HEAP_MEMORY
  GROUP BY
    HOST,
    PORT,
    CATEGORY
),
HEAP_ALLOCATORS_HISTORY AS
( SELECT
    SERVER_TIMESTAMP,
    SITE_ID,
    HOST,
    PORT,
    CATEGORY,
    SUM(EXCLUSIVE_ALLOCATED_SIZE) EXCLUSIVE_ALLOCATED_SIZE,
    SUM(EXCLUSIVE_ALLOCATED_COUNT) EXCLUSIVE_ALLOCATED_COUNT
  FROM
    _SYS_STATISTICS.HOST_HEAP_ALLOCATORS
  GROUP BY
    SERVER_TIMESTAMP,
    SITE_ID,
    HOST,
    PORT,
    CATEGORY
)
SELECT
  SNAPSHOT_TIME,
  IFNULL(LPAD(SITE_ID, 2), '') ST,  HOST,
  LPAD(PORT, 5) PORT,
  ALLOCATOR_NAME,
  LPAD(TO_DECIMAL(MAP(INTERVAL_S, 0, 0, EXCLUSIVE_ALLOCATED_SIZE / INTERVAL_S / 1024 / 1024), 10, 2), 14) ALLOC_MB_PER_S,
  LPAD(TO_DECIMAL(MAP(INTERVAL_S, 0, 0, EXCLUSIVE_ALLOCATED_COUNT / INTERVAL_S), 10, 0), 12) ALLOCS_PER_S,
  LPAD(TO_DECIMAL(EXCLUSIVE_ALLOCATED_SIZE / SUM(EXCLUSIVE_ALLOCATED_SIZE) OVER (PARTITION BY SNAPSHOT_TIME) * 100, 10, 2), 9) ALLOC_PCT,
  LPAD(TO_DECIMAL(MAP(EXCLUSIVE_ALLOCATED_COUNT, 0, 0, EXCLUSIVE_ALLOCATED_SIZE / EXCLUSIVE_ALLOCATED_COUNT / 1024), 10, 2), 17) AVG_ALLOC_SIZE_KB,
  LPAD(TO_DECIMAL(EXCLUSIVE_ALLOCATED_SIZE / 1024 / 1024 / 1024, 12, 0), 12) ALLOC_GB,
  LPAD(TO_DECIMAL(EXCLUSIVE_ALLOCATED_COUNT, 10, 0), 15) ALLOCATIONS
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(H.SNAPSHOT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE H.SNAPSHOT_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(H.SNAPSHOT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE H.SNAPSHOT_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END SNAPSHOT_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SITE_ID')   != 0 THEN TO_VARCHAR(H.SITE_ID) ELSE MAP(BI.SITE_ID,         -1, 'any', TO_VARCHAR(BI.SITE_ID)) END SITE_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')      != 0 THEN H.HOST                ELSE MAP(BI.HOST,           '%', 'any', BI.HOST)                END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')      != 0 THEN TO_VARCHAR(H.PORT)    ELSE MAP(BI.PORT,           '%', 'any', BI.PORT)                END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ALLOCATOR') != 0 THEN H.ALLOCATOR_NAME      ELSE MAP(BI.ALLOCATOR_NAME, '%', 'any', BI.ALLOCATOR_NAME)      END ALLOCATOR_NAME,
    SUM(H.EXCLUSIVE_ALLOCATED_SIZE) EXCLUSIVE_ALLOCATED_SIZE,
    SUM(H.EXCLUSIVE_ALLOCATED_COUNT) EXCLUSIVE_ALLOCATED_COUNT,
    SECONDS_BETWEEN(MIN(H.START_TIME), MAX(H.SNAPSHOT_TIME)) INTERVAL_S,
    BI.ORDER_BY,
    BI.MIN_ALLOC_MB_PER_S,
    BI.MIN_ALLOCS_PER_S
  FROM
    BASIS_INFO BI,
  ( SELECT
      CURRENT_TIMESTAMP SNAPSHOT_TIME,
      S.START_TIME,
      CURRENT_SITE_ID() SITE_ID,
      H.HOST,
      H.PORT,
      H.CATEGORY ALLOCATOR_NAME,
      H.EXCLUSIVE_ALLOCATED_SIZE,
      H.EXCLUSIVE_ALLOCATED_COUNT
    FROM
      BASIS_INFO BI,
      HEAP_ALLOCATORS_CURRENT H,
      M_SERVICE_STATISTICS S
    WHERE
      BI.DATA_SOURCE = 'CURRENT' AND
      ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND CURRENT_SITE_ID() IN (-1, 0) ) OR CURRENT_SITE_ID() = BI.SITE_ID ) AND
      H.HOST LIKE BI.HOST AND
      TO_VARCHAR(H.PORT) LIKE BI.PORT AND
      H.CATEGORY LIKE BI.ALLOCATOR_NAME AND
      S.HOST = H.HOST AND
      S.PORT = H.PORT
    UNION ALL
    SELECT
      H.SERVER_TIMESTAMP SNAPSHOT_TIME,
      ( SELECT MAX(SERVER_TIMESTAMP) FROM HEAP_ALLOCATORS_HISTORY HT WHERE HT.HOST = H.HOST AND HT.PORT = H.PORT AND HT.SERVER_TIMESTAMP < H.SERVER_TIMESTAMP ) START_TIME,
      H.SITE_ID,
      H.HOST,
      H.PORT,
      H.CATEGORY ALLOCATOR_NAME,
      CASE
        WHEN H.EXCLUSIVE_ALLOCATED_SIZE  - LAG(H.EXCLUSIVE_ALLOCATED_SIZE,  1) OVER (PARTITION BY H.SITE_ID, H.HOST, H.PORT, H.CATEGORY ORDER BY H.SERVER_TIMESTAMP ) < 0 THEN H.EXCLUSIVE_ALLOCATED_SIZE
        ELSE H.EXCLUSIVE_ALLOCATED_SIZE  - LAG(H.EXCLUSIVE_ALLOCATED_SIZE,  1) OVER (PARTITION BY H.SITE_ID, H.HOST, H.PORT, H.CATEGORY ORDER BY H.SERVER_TIMESTAMP )
      END EXCLUSIVE_ALLOCATED_SIZE,
      CASE
        WHEN H.EXCLUSIVE_ALLOCATED_COUNT - LAG(H.EXCLUSIVE_ALLOCATED_COUNT, 1) OVER (PARTITION BY H.SITE_ID, H.HOST, H.PORT, H.CATEGORY ORDER BY H.SERVER_TIMESTAMP ) < 0 THEN H.EXCLUSIVE_ALLOCATED_COUNT
        ELSE H.EXCLUSIVE_ALLOCATED_COUNT - LAG(H.EXCLUSIVE_ALLOCATED_COUNT, 1) OVER (PARTITION BY H.SITE_ID, H.HOST, H.PORT, H.CATEGORY ORDER BY H.SERVER_TIMESTAMP )
      END EXCLUSIVE_ALLOCATED_COUNT
    FROM
      BASIS_INFO BI,
      HEAP_ALLOCATORS_HISTORY H
    WHERE
      BI.DATA_SOURCE = 'HISTORY' AND
      CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(H.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE H.SERVER_TIMESTAMP END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
      ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND H.SITE_ID IN (-1, 0) ) OR H.SITE_ID = BI.SITE_ID ) AND
      H.HOST LIKE BI.HOST AND
      TO_VARCHAR(H.PORT) LIKE BI.PORT AND
      H.CATEGORY LIKE BI.ALLOCATOR_NAME
  ) H
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(H.SNAPSHOT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE H.SNAPSHOT_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(H.SNAPSHOT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE H.SNAPSHOT_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SITE_ID')   != 0 THEN TO_VARCHAR(H.SITE_ID) ELSE MAP(BI.SITE_ID,         -1, 'any', TO_VARCHAR(BI.SITE_ID)) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')      != 0 THEN H.HOST                ELSE MAP(BI.HOST,           '%', 'any', BI.HOST)                END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')      != 0 THEN TO_VARCHAR(H.PORT)    ELSE MAP(BI.PORT,           '%', 'any', BI.PORT)                END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ALLOCATOR') != 0 THEN H.ALLOCATOR_NAME      ELSE MAP(BI.ALLOCATOR_NAME, '%', 'any', BI.ALLOCATOR_NAME)      END,
    BI.ORDER_BY,
    BI.MIN_ALLOC_MB_PER_S,
    BI.MIN_ALLOCS_PER_S
)
WHERE
  ( MIN_ALLOC_MB_PER_S = -1 OR MAP(INTERVAL_S, 0, 0, EXCLUSIVE_ALLOCATED_SIZE / INTERVAL_S / 1024 / 1024) >= MIN_ALLOC_MB_PER_S ) AND
  ( MIN_ALLOCS_PER_S   = -1 OR MAP(INTERVAL_S, 0, 0, EXCLUSIVE_ALLOCATED_COUNT / INTERVAL_S) >= MIN_ALLOCS_PER_S )
ORDER BY
  MAP(ORDER_BY, 'SIZE', EXCLUSIVE_ALLOCATED_SIZE, 'COUNT', EXCLUSIVE_ALLOCATED_COUNT) DESC,
  MAP(ORDER_BY, 'ALLOCATOR', ALLOCATOR_NAME),
  SNAPSHOT_TIME DESC
