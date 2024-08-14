SELECT

/* 

[NAME]

- HANA_Memory_Components_2.00.056+

[DESCRIPTION]

- Current and historic memory overview including heap components

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_SERVICE_MEMORY.FRAGMENTED_MEMORY_SIZE available with SAP HANA >= 2.00.040

[VALID FOR]

- Revisions:              >= 2.00.056

[SQL COMMAND VERSION]

- 2019/07/07:  1.0 (initial version)
- 2020/12/05:  1.1 (PERSMEM_GB and H_NSE_GB included)
- 2020/12/16:  1.2 (AGGREGATION_TYPE included)
- 2021/06/25:  1.3 (dedicated 2.00.056+ version including HOST_PERSISTENT_MEMORY_VOLUME_STATISTICS)

[INVOLVED TABLES]

- HOST_HEAP_ALLOCATORS
- HOST_PERSISTENT_MEMORY_VOLUME_STATISTICS
- HOST_SERVICE_MEMORY
- M_HEAP_MEMORY
- M_PERSISTENT_MEMORY_VOLUME_STATISTICS
- M_SERVICE_MEMORY

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

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)

- AGGREGATION_TYPE

  Type of aggregation

  'MIN'           --> Minimum value
  'AVG'           --> Average value
  'MAX'           --> Maximum value

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'NONE'          --> No aggregation
  'TIME'          --> Aggregation by time
  'HOST, PORT'    --> Aggregation by host and port

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation

[OUTPUT PARAMETERS]

- SNAPSHOT_TIME: Timestamp
- HOST:          Host
- PORT:          Port
- ALLOC_LIM_GB:  Allocation limit (GB)
- EFF_LIM_GB:    Effective allocation limit (GB)
- CODE_GB:       Code size (GB)
- STACK_GB:      Stack size (GB)
- SHARED_GB:     Shared memory size (GB)
- PERSMEM_GB:    Persistent memory size (GB), only available for DATA_SOURCE = 'CURRENT'
- H_ALLOC_GB:    Heap memory allocated size (GB)
- H_FREE_GB:     Heap free memory (GB)
- H_FRAG_GB:     Heap mmory fragmentation (GB)
- H_USED_GB:     Heap memory used size (GB)
- H_COL_GB:      Heap memory consumed by component 'Column Store Tables' (GB)
- H_ROW_GB:      Heap memory consumed by component 'Row Store Tables' (GB)
- H_SYS_GB:      Heap memory consumed by component 'System' (GB), excluding NSE page cache (Pool/CS/BufferPage)
- H_NSE_GB:      Heap memory consumped by NSE page cache (Pool/CS/BufferPage)
- H_STMT_GB:     Heap memory consumed by component 'Statement Execution & Intermediate Results' (GB)
- H_CACHE_GB:    Heap memory consumed by component 'Cache' (GB)
- H_MON_GB:      Heap memory consumed by component 'Monitoring & Statistical Data' (GB)
- H_OTHER_GB:    Heap memory consumed by component 'Other' (GB)
- YEAR:          Snapshot year
- MONTH:         Snapshot month
- DAY:           Snapshot day
- HOUR:          Snapshot hour

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------------------------------------------
|SNAPSHOT_TIME   |CODE_GB|STACK_GB|FRAG_GB|SHARED_GB|HEAP_GB |H_COL_GB |H_ROW_GB|H_SYS_GB|H_STMT_GB|H_CACHE_GB|H_MON_GB|H_OTHER_GB|
-----------------------------------------------------------------------------------------------------------------------------------
|2019/07/07 (SUN)|  18.67|    6.16| 338.01|   314.64|19011.32| 11114.18|   37.34|  961.51|  2155.65|     23.45|   91.65|      0.00|
|2019/07/06 (SAT)|  18.67|    6.33| 322.05|   314.64|19786.45| 11140.06|   38.32| 1947.46|  2138.08|     23.35|  129.96|      5.75|
|2019/07/05 (FRI)|  18.67|    6.98| 339.53|   314.64|29117.89| 13558.39|   63.20| 9084.53|  2144.33|     22.21|  136.13|      9.28|
|2019/07/04 (THU)|  18.67|    6.44| 340.63|   316.78|26316.89| 16846.66|   55.02| 1110.22|  2142.82|     20.14|  140.00|      5.48|
|2019/07/03 (WED)|  18.65|    6.66| 270.74|  1086.15|24752.73| 16159.52|  119.36| 1167.94|  1623.18|     15.94|  151.44|      4.53|
|2019/07/02 (TUE)|  18.62|    7.31| 131.91|  1437.85|21147.36| 16159.32|  222.31| 1099.41|   766.28|     18.17|  182.87|      4.32|
|2019/07/01 (MON)|  18.65|    5.99| 158.46|   800.17|24821.37| 15829.72|  240.81| 1770.07|  1881.30|     33.77|  146.28|      7.22|
|2019/06/30 (SUN)|  18.67|    5.92| 300.78|     0.70|30856.85| 16219.93|  353.49| 3288.76|  3306.47|     56.22|  145.83|      0.00|
|2019/06/29 (SAT)|  18.67|    6.39| 339.81|     0.70|30929.96| 16648.04|  194.62| 2249.42|  2917.71|     56.55|  158.42|      6.98|
-----------------------------------------------------------------------------------------------------------------------------------

*/

  SNAPSHOT_TIME,
  HOST,
  PORT,
  CASE WHEN ALLOC_LIM_GB = 0 THEN 'n/a' ELSE LPAD(TO_DECIMAL(ALLOC_LIM_GB, 10, 2), 12) END ALLOC_LIM_GB,
  CASE WHEN EFF_ALLOC_LIM_GB = 0 THEN 'n/a' ELSE LPAD(TO_DECIMAL(EFF_ALLOC_LIM_GB, 10, 2), 10) END EFF_LIM_GB,
  LPAD(TO_DECIMAL(CODE_GB, 10, 2), 7) CODE_GB,
  LPAD(TO_DECIMAL(STACK_GB, 10, 2), 8) STACK_GB,
  LPAD(TO_DECIMAL(SHARED_GB, 10, 2), 9) SHARED_GB,
  LPAD(TO_DECIMAL(PERSMEM_GB, 10, 2), 10) PERSMEM_GB,
  LPAD(TO_DECIMAL(HEAP_ALLOC_GB, 10, 2), 10) H_ALLOC_GB,
  LPAD(TO_DECIMAL(FREE_GB, 10, 2), 9) H_FREE_GB,
  LPAD(TO_DECIMAL(FRAG_GB, 10, 2), 9) H_FRAG_GB,
  LPAD(TO_DECIMAL(HEAP_USED_GB, 10, 2), 9) H_USED_GB,
  LPAD(TO_DECIMAL(COL_GB, 10, 2), 9) H_COL_GB,
  LPAD(TO_DECIMAL(ROW_GB, 10, 2), 8) H_ROW_GB,
  LPAD(TO_DECIMAL(SYSTEM_GB, 10, 2), 8) H_SYS_GB,
  LPAD(TO_DECIMAL(SYSTEM_PAGED_GB, 10, 2), 8) H_NSE_GB,
  LPAD(TO_DECIMAL(STMT_GB, 10, 2), 9) H_STMT_GB,
  LPAD(TO_DECIMAL(CACHE_GB, 10, 2), 10) H_CACHE_GB,
  LPAD(TO_DECIMAL(MON_GB, 10, 2), 8) H_MON_GB,
  LPAD(TO_DECIMAL(OTHER_GB, 10, 2), 10) H_OTHER_GB,
  CASE WHEN SNAPSHOT_TIME LIKE '____/__/__ __%' THEN SUBSTR(SNAPSHOT_TIME,  1, 4) ELSE 'any' END YEAR,
  CASE WHEN SNAPSHOT_TIME LIKE '____/__/__ __%' THEN SUBSTR(SNAPSHOT_TIME,  6, 2) ELSE 'any' END MONTH,
  CASE WHEN SNAPSHOT_TIME LIKE '____/__/__ __%' THEN SUBSTR(SNAPSHOT_TIME,  9, 2) ELSE 'any' END DAY,
  CASE WHEN SNAPSHOT_TIME LIKE '____/__/__ __%' THEN SUBSTR(SNAPSHOT_TIME, 12, 2) ELSE 'any' END HOUR
FROM
( SELECT
    SNAPSHOT_TIME,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST') != 0 THEN HOST             ELSE MAP(BI_HOST, '%', 'any', BI_HOST) END HOST,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT') != 0 THEN TO_VARCHAR(PORT) ELSE MAP(BI_PORT, '%', 'any', BI_PORT) END PORT,
    MAX(CASE WHEN SUBAREA = 'ALLOCLIM'     AND AGGREGATE_BY = 'NONE' THEN MEM_GB ELSE 0 END) ALLOC_LIM_GB,
    MAX(CASE WHEN SUBAREA = 'EFF_ALLOCLIM' AND AGGREGATE_BY = 'NONE' THEN MEM_GB ELSE 0 END) EFF_ALLOC_LIM_GB,
    SUM(MAP(SUBAREA, 'CODE', MEM_GB, 0)) CODE_GB,
    SUM(MAP(SUBAREA, 'STACK', MEM_GB, 0)) STACK_GB,
    SUM(MAP(SUBAREA, 'SHARED', MEM_GB, 0)) SHARED_GB,
    SUM(MAP(SUBAREA, 'HEAP_ALLOC', MEM_GB, 0)) HEAP_ALLOC_GB,
    SUM(MAP(SUBAREA, 'HEAP_USED', MEM_GB, 0)) HEAP_USED_GB,
    SUM(MAP(SUBAREA, 'COL', MEM_GB, 0)) COL_GB,
    SUM(MAP(SUBAREA, 'ROW', MEM_GB, 0)) ROW_GB,
    SUM(MAP(SUBAREA, 'SYSTEM', MEM_GB, 0)) SYSTEM_GB,
    SUM(MAP(SUBAREA, 'SYSTEM_PAGED', MEM_GB, 0)) SYSTEM_PAGED_GB,
    SUM(MAP(SUBAREA, 'STMT', MEM_GB, 0)) STMT_GB,
    SUM(MAP(SUBAREA, 'CACHE', MEM_GB, 0)) CACHE_GB,
    SUM(MAP(SUBAREA, 'MON', MEM_GB, 0)) MON_GB,
    SUM(MAP(SUBAREA, 'FRAG', MEM_GB, 0)) FRAG_GB,
    SUM(MAP(SUBAREA, 'FREE', MEM_GB, 0)) FREE_GB,
    SUM(MAP(SUBAREA, 'OTHER', MEM_GB, 0)) OTHER_GB,
    SUM(MAP(SUBAREA, 'PERSMEM', MEM_GB, 0)) PERSMEM_GB    
  FROM  
  ( SELECT    
      CASE 
        WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
          TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
          'YYYY/MM/DD HH24:MI:SS'), M.SNAPSHOT_TIME) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
        ELSE TO_VARCHAR(M.SNAPSHOT_TIME, BI.TIME_AGGREGATE_BY)
      END SNAPSHOT_TIME,
      M.HOST,
      M.PORT,
      M.SUBAREA,
      MAP(AGGREGATION_TYPE, 'MIN', MIN(MEM_GB), 'AVG', AVG(MEM_GB), MAX(MEM_GB)) MEM_GB,
      BI.HOST BI_HOST,
      BI.PORT BI_PORT,
      BI.AGGREGATE_BY
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
        DATA_SOURCE,
        AGGREGATION_TYPE,
        AGGREGATE_BY,
        MAP(TIME_AGGREGATE_BY,
          'NONE',        'YYYY/MM/DD HH24:MI:SS',
          'HOUR',        'YYYY/MM/DD HH24',
          'DAY',         'YYYY/MM/DD (DY)',
          'HOUR_OF_DAY', 'HH24',
          TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY
      FROM
      ( SELECT                                                      /* Modification section */
          'MIN' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
          '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
          'SERVER' TIMEZONE,                              /* SERVER, UTC */
          '%' HOST,
          '%' PORT,
          'CURRENT' DATA_SOURCE,
          'MAX' AGGREGATION_TYPE,           /* MIN, AVG, MAX */
          'NONE' AGGREGATE_BY,              /* TIME, HOST, PORT or comma separated combinations, NONE for no aggregation */
          'NONE' TIME_AGGREGATE_BY     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        FROM
          DUMMY
      ) 
    ) BI,
    ( SELECT
        *
      FROM
      ( SELECT
          'CURRENT' DATA_SOURCE,
          CURRENT_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'CODE' SUBAREA,
          CODE_SIZE / 1024 / 1024 / 1024 MEM_GB
        FROM
          M_SERVICE_MEMORY
      )
      UNION ALL
      ( SELECT
          'CURRENT' DATA_SOURCE,
          CURRENT_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'STACK' SUBAREA,
          STACK_SIZE / 1024 / 1024 / 1024 MEM_GB
        FROM
          M_SERVICE_MEMORY
      )
      UNION ALL
      ( SELECT
          'CURRENT' DATA_SOURCE,
          CURRENT_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'SHARED' SUBAREA,
          SHARED_MEMORY_ALLOCATED_SIZE / 1024 / 1024 / 1024 MEM_GB
        FROM
          M_SERVICE_MEMORY
      )
      UNION ALL
      ( SELECT
          'CURRENT' DATA_SOURCE,
          CURRENT_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'HEAP_ALLOC' SUBAREA,
          HEAP_MEMORY_ALLOCATED_SIZE / 1024 / 1024 / 1024 MEM_GB
        FROM
          M_SERVICE_MEMORY
      )
      UNION ALL
      ( SELECT
          'CURRENT' DATA_SOURCE,
          CURRENT_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'HEAP_USED' SUBAREA,
          HEAP_MEMORY_USED_SIZE / 1024 / 1024 / 1024 MEM_GB
        FROM
          M_SERVICE_MEMORY
      )
      UNION ALL
      ( SELECT
          'CURRENT' DATA_SOURCE,
          CURRENT_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'FRAG' SUBAREA,
          FRAGMENTED_MEMORY_SIZE / 1024 / 1024 / 1024 MEM_GB
        FROM
          M_SERVICE_MEMORY
      ) 
      UNION ALL
      ( SELECT
          'CURRENT' DATA_SOURCE,
          CURRENT_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'FREE' SUBAREA,
          FREE_MEMORY_SIZE / 1024 / 1024 / 1024 MEM_GB
        FROM
          M_SERVICE_MEMORY
      ) 
      UNION ALL
      ( SELECT
          'CURRENT' DATA_SOURCE,
          CURRENT_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'ALLOCLIM' SUBAREA,
          ALLOCATION_LIMIT / 1024 / 1024 / 1024 MEM_GB
        FROM
          M_SERVICE_MEMORY
      ) 
      UNION ALL
      ( SELECT
          'CURRENT' DATA_SOURCE,
          CURRENT_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'EFF_ALLOCLIM' SUBAREA,
          EFFECTIVE_ALLOCATION_LIMIT / 1024 / 1024 / 1024 MEM_GB
        FROM
          M_SERVICE_MEMORY
      ) 
      UNION ALL
      ( SELECT
          'CURRENT' DATA_SOURCE,
          CURRENT_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          MAP(CATEGORY, 'Pool/CS/BufferPage', 'SYSTEM_PAGED', 'SYSTEM') SUBAREA,
          SUM(EXCLUSIVE_SIZE_IN_USE) / 1024 / 1024 / 1024 MEM_GB
        FROM
          M_HEAP_MEMORY
        WHERE
          COMPONENT = 'Caches'
        GROUP BY
          HOST,
          PORT,
          MAP(CATEGORY, 'Pool/CS/BufferPage', 'SYSTEM_PAGED', 'SYSTEM')
      )
      UNION ALL
      ( SELECT
          'CURRENT' DATA_SOURCE,
          CURRENT_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'COL' SUBAREA,
          SUM(EXCLUSIVE_SIZE_IN_USE) / 1024 / 1024 / 1024 MEM_GB
        FROM
          M_HEAP_MEMORY
        WHERE
          COMPONENT = 'Column Store Tables'
        GROUP BY
          HOST,
          PORT
      )
      UNION ALL
      ( SELECT
          'CURRENT' DATA_SOURCE,
          CURRENT_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'MON' SUBAREA,
          SUM(EXCLUSIVE_SIZE_IN_USE) / 1024 / 1024 / 1024 MEM_GB
        FROM
          M_HEAP_MEMORY
        WHERE
          COMPONENT = 'Monitoring & Statistical Data'
        GROUP BY
          HOST,
          PORT
      )
      UNION ALL
      ( SELECT
          'CURRENT' DATA_SOURCE,
          CURRENT_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'OTHER' SUBAREA,
          SUM(EXCLUSIVE_SIZE_IN_USE) / 1024 / 1024 / 1024 MEM_GB
        FROM
          M_HEAP_MEMORY
        WHERE
          COMPONENT = 'Other'
        GROUP BY
          HOST,
          PORT
      )
      UNION ALL
      ( SELECT
          'CURRENT' DATA_SOURCE,
          CURRENT_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'ROW' SUBAREA,
          SUM(EXCLUSIVE_SIZE_IN_USE) / 1024 / 1024 / 1024 MEM_GB
        FROM
          M_HEAP_MEMORY
        WHERE
          COMPONENT = 'Row Store Tables'
        GROUP BY
          HOST,
          PORT
      )
      UNION ALL
      ( SELECT
          'CURRENT' DATA_SOURCE,
          CURRENT_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'STMT' SUBAREA,
          SUM(EXCLUSIVE_SIZE_IN_USE) / 1024 / 1024 / 1024 MEM_GB
        FROM
          M_HEAP_MEMORY
        WHERE
          COMPONENT = 'Statement Execution & Intermediate Results'
        GROUP BY
          HOST,
          PORT
      )
      UNION ALL
      ( SELECT
          'CURRENT' DATA_SOURCE,
          CURRENT_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          MAP(CATEGORY, 'Pool/CS/BufferPage', 'SYSTEM_PAGED', 'SYSTEM') SUBAREA,
          SUM(EXCLUSIVE_SIZE_IN_USE) / 1024 / 1024 / 1024 MEM_GB
        FROM
          M_HEAP_MEMORY
        WHERE
          COMPONENT = 'System'
        GROUP BY
          HOST,
          PORT,
          MAP(CATEGORY, 'Pool/CS/BufferPage', 'SYSTEM_PAGED', 'SYSTEM')
      )
      UNION ALL
      ( SELECT
          'CURRENT' DATA_SOURCE,
          CURRENT_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'PERSMEM',
          SUM(TOTAL_ACTIVE_SIZE) / 1024 / 1024 / 1024 MEM_MB
        FROM
          M_PERSISTENT_MEMORY_VOLUME_STATISTICS
        GROUP BY
          HOST,
          PORT
      )
      UNION ALL
      ( SELECT
          'HISTORY' DATA_SOURCE,
          SERVER_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'CODE' SUBAREA,
          CODE_SIZE / 1024 / 1024 / 1024 MEM_GB
        FROM
          _SYS_STATISTICS.HOST_SERVICE_MEMORY
      )
      UNION ALL
      ( SELECT
          'HISTORY' DATA_SOURCE,
          SERVER_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'STACK' SUBAREA,
          STACK_SIZE / 1024 / 1024 / 1024 MEM_GB
        FROM
          _SYS_STATISTICS.HOST_SERVICE_MEMORY
      )
      UNION ALL
      ( SELECT
          'HISTORY' DATA_SOURCE,
          SERVER_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'SHARED' SUBAREA,
          SHARED_MEMORY_ALLOCATED_SIZE / 1024 / 1024 / 1024 MEM_GB
        FROM
          _SYS_STATISTICS.HOST_SERVICE_MEMORY
      )
      UNION ALL
      ( SELECT
          'HISTORY' DATA_SOURCE,
          SERVER_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'HEAP_ALLOC' SUBAREA,
          HEAP_MEMORY_ALLOCATED_SIZE / 1024 / 1024 / 1024 MEM_GB
        FROM
          _SYS_STATISTICS.HOST_SERVICE_MEMORY
      )
      UNION ALL
      ( SELECT
          'HISTORY' DATA_SOURCE,
          SERVER_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'HEAP_USED' SUBAREA,
          HEAP_MEMORY_USED_SIZE / 1024 / 1024 / 1024 MEM_GB
        FROM
          _SYS_STATISTICS.HOST_SERVICE_MEMORY
      )
      UNION ALL
      ( SELECT
          'HISTORY' DATA_SOURCE,
          SERVER_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'FRAG' SUBAREA,
          FRAGMENTED_MEMORY_SIZE / 1024 / 1024 / 1024 MEM_GB
        FROM
          _SYS_STATISTICS.HOST_SERVICE_MEMORY
      ) 
      UNION ALL
      ( SELECT
          'HISTORY' DATA_SOURCE,
          SERVER_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'FREE' SUBAREA,
          FREE_MEMORY_SIZE / 1024 / 1024 / 1024 MEM_GB
        FROM
          _SYS_STATISTICS.HOST_SERVICE_MEMORY
      ) 
      UNION ALL
      ( SELECT
          'HISTORY' DATA_SOURCE,
          SERVER_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'ALLOCLIM' SUBAREA,
          ALLOCATION_LIMIT / 1024 / 1024 / 1024 MEM_GB
        FROM
          _SYS_STATISTICS.HOST_SERVICE_MEMORY
      )
      UNION ALL
      ( SELECT
          'HISTORY' DATA_SOURCE,
          SERVER_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'EFF_ALLOCLIM' SUBAREA,
          EFFECTIVE_ALLOCATION_LIMIT / 1024 / 1024 / 1024 MEM_GB
        FROM
          _SYS_STATISTICS.HOST_SERVICE_MEMORY
      )
      UNION ALL
      ( SELECT
          'HISTORY' DATA_SOURCE,
          SERVER_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          MAP(CATEGORY, 'Pool/CS/BufferPage', 'SYSTEM_PAGED', 'SYSTEM') SUBAREA,
          SUM(EXCLUSIVE_SIZE_IN_USE) / 1024 / 1024 / 1024 MEM_GB
        FROM
          _SYS_STATISTICS.HOST_HEAP_ALLOCATORS
        WHERE
          COMPONENT = 'Caches'
        GROUP BY
          SERVER_TIMESTAMP,
          HOST,
          PORT,
          MAP(CATEGORY, 'Pool/CS/BufferPage', 'SYSTEM_PAGED', 'SYSTEM')          
      )
      UNION ALL
      ( SELECT
          'HISTORY' DATA_SOURCE,
          SERVER_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'COL' SUBAREA,
          SUM(EXCLUSIVE_SIZE_IN_USE) / 1024 / 1024 / 1024 MEM_GB
        FROM
          _SYS_STATISTICS.HOST_HEAP_ALLOCATORS
        WHERE
          COMPONENT = 'Column Store Tables'
        GROUP BY
          SERVER_TIMESTAMP,
          HOST,
          PORT
      )
      UNION ALL
      ( SELECT
          'HISTORY' DATA_SOURCE,
          SERVER_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'MON' SUBAREA,
          SUM(EXCLUSIVE_SIZE_IN_USE) / 1024 / 1024 / 1024 MEM_GB
        FROM
          _SYS_STATISTICS.HOST_HEAP_ALLOCATORS
        WHERE
          COMPONENT = 'Monitoring & Statistical Data'
        GROUP BY
          SERVER_TIMESTAMP,
          HOST,
          PORT
      )
      UNION ALL
      ( SELECT
          'HISTORY' DATA_SOURCE,
          SERVER_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'OTHER' SUBAREA,
          SUM(EXCLUSIVE_SIZE_IN_USE) / 1024 / 1024 / 1024 MEM_GB
        FROM
          _SYS_STATISTICS.HOST_HEAP_ALLOCATORS
        WHERE
          COMPONENT = 'Other'
        GROUP BY
          SERVER_TIMESTAMP,
          HOST,
          PORT
      )
      UNION ALL
      ( SELECT
          'HISTORY' DATA_SOURCE,
          SERVER_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'ROW' SUBAREA,
          SUM(EXCLUSIVE_SIZE_IN_USE) / 1024 / 1024 / 1024 MEM_GB
        FROM
          _SYS_STATISTICS.HOST_HEAP_ALLOCATORS
        WHERE
          COMPONENT = 'Row Store Tables'
        GROUP BY
          SERVER_TIMESTAMP,
          HOST,
          PORT
      )
      UNION ALL
      ( SELECT
          'HISTORY' DATA_SOURCE,
          SERVER_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'STMT' SUBAREA,
          SUM(EXCLUSIVE_SIZE_IN_USE) / 1024 / 1024 / 1024 MEM_GB
        FROM
          _SYS_STATISTICS.HOST_HEAP_ALLOCATORS
        WHERE
          COMPONENT = 'Statement Execution & Intermediate Results'
        GROUP BY
          SERVER_TIMESTAMP,
          HOST,
          PORT
      )
      UNION ALL
      ( SELECT
          'HISTORY' DATA_SOURCE,
          SERVER_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          MAP(CATEGORY, 'Pool/CS/BufferPage', 'SYSTEM_PAGED', 'SYSTEM') SUBAREA,
          SUM(EXCLUSIVE_SIZE_IN_USE) / 1024 / 1024 / 1024 MEM_GB
        FROM
          _SYS_STATISTICS.HOST_HEAP_ALLOCATORS
        WHERE
          COMPONENT = 'System'
        GROUP BY
          SERVER_TIMESTAMP,
          HOST,
          PORT,
          MAP(CATEGORY, 'Pool/CS/BufferPage', 'SYSTEM_PAGED', 'SYSTEM')
      )
      UNION ALL
      ( SELECT
          'HISTORY' DATA_SOURCE,
          SERVER_TIMESTAMP SNAPSHOT_TIME,
          HOST,
          PORT,
          'PERSMEM',
          SUM(TOTAL_ACTIVE_SIZE) / 1024 / 1024 / 1024 MEM_MB
        FROM
          _SYS_STATISTICS.HOST_PERSISTENT_MEMORY_VOLUME_STATISTICS
        GROUP BY
          HOST,
          PORT,
          SERVER_TIMESTAMP
      )
    ) M
    WHERE
      ( BI.DATA_SOURCE = 'CURRENT' OR 
        CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(M.SNAPSHOT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE M.SNAPSHOT_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME
      ) AND
      M.DATA_SOURCE = BI.DATA_SOURCE AND
      M.HOST LIKE BI.HOST AND
      TO_VARCHAR(M.PORT) LIKE BI.PORT
    GROUP BY
      CASE 
        WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
          TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
          'YYYY/MM/DD HH24:MI:SS'), M.SNAPSHOT_TIME) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
        ELSE TO_VARCHAR(M.SNAPSHOT_TIME, BI.TIME_AGGREGATE_BY)
      END,
      M.HOST,
      M.PORT,
      M.SUBAREA,
      BI.HOST,
      BI.PORT,
      BI.AGGREGATION_TYPE,
      BI.AGGREGATE_BY
  )
  GROUP BY
    SNAPSHOT_TIME,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST') != 0 THEN HOST             ELSE MAP(BI_HOST, '%', 'any', BI_HOST) END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT') != 0 THEN TO_VARCHAR(PORT) ELSE MAP(BI_PORT, '%', 'any', BI_PORT) END
)
ORDER BY
  SNAPSHOT_TIME DESC,
  HOST,
  PORT	