WITH 

/* 

[NAME]

- HANA_Memory_MemoryProfiler_Details_2.00.040+

[DESCRIPTION]

- Evaluation of memory profiler results

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Memory profiler available for SAP HANA >= 2.00.040
- Prerequisites: Trace needs to be run for some time (ALTER SYSTEM START MEMORY PROFILER ...) and results need to be
  loaded (ALTER SYSTEM LOAD MEMORY_PROFILER)
- Generated table names depend on the specified profile. The default prefix of this analysis command is Z_MEMPROF:

  ALTER SYSTEM LOAD MEMORY PROFILER INTO TABLES Z_MEMPROF

- If you use a different prefix, you have to replace Z_MEMPROF in this text file globally with your prefix name.
  If there is a discrepancy, this command will fail with:

  259: invalid table name: Could not find table/view Z_MEMPROF_BLOCKS

[VALID FOR]

- Revisions:              >= 2.00.040

[SQL COMMAND VERSION]

- 2020/01/07:  1.0 (initial version)

[INVOLVED TABLES]

- <prefix>_ALLOCATES
- <prefix>_ALLOCATORS
- <prefix>_BLOCKS
- <prefix>_CALLERS
- <prefix>_FILES
- <prefix>_FRAMES
- <prefix>_METHODS
- <prefix>_MODULES

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

  'SERVER'         --> Display times in SAP HANA server time
  'UTC'            --> Display times in UTC time

- ALLOCATOR_NAME

  Heap allocator name

  'Pool/itab'      --> Restrict result to allocator Pool/itab
  'Pool/parallel%' --> Restrict result to allocators starting with 'Pool/parallel'
  '%'              --> No restriction related to allocator name

- METHOD_NAME

  Call stack method

  '%tempAlloc%    --> Call stack methods containing 'tempAlloc'
  '%'             --> No restriction related to call stack method

- FILE_NAME

  Call stack file name

  'mm%'           --> All files starting with 'mm'
  '%'             --> No restriction related to callstack file name

- MIN_SIZE_GB

  Minimum size (GB)

  1               --> Only display lines with a size of at least 1 GB
  -1              --> No restriction related to size

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'          --> Aggregation by time
  'ALLOCATOR'     --> Aggregation by allocator
  'NONE'          --> No aggregation

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation
  
[OUTPUT PARAMETERS]

- ALLOCATE_TIME:  Allocation time
- ALLOCATOR_NAME: Heap allocator name
- SIZE_GB:        Allocation size (GB)

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------
|ALLOCATE_TIME      |ALLOCATOR_NAME                                                       |SIZE_GB   |
------------------------------------------------------------------------------------------------------
|2020/01/05 15:46:00|Pool/RowEngine/QueryExecution/SearchAlloc                            |      5.15|
|2020/01/05 15:45:40|Pool/RowEngine/QueryExecution/SearchAlloc                            |      2.77|
|2020/01/05 15:45:50|Pool/RowEngine/QueryExecution/SearchAlloc                            |      2.29|
|2020/01/05 15:45:30|AllocateOnlyAllocator-unlimited/FLA-UL<24592,1>/MemoryMapLevel3Nodes |      1.77|
|2020/01/05 15:45:30|Pool/RowEngine/MonitorView/Resident/M_LOAD_HISTORY_INFO              |      1.22|
|2020/01/05 15:45:30|Pool/malloc/libhdbbasement.so                                        |      0.74|
|2020/01/05 15:45:30|VirtualAlloc                                                         |      0.64|
|2020/01/05 15:45:30|AllocateOnlyAllocator-unlimited/FLA-UL<120,256>/BigBlockInfoAllocator|      0.60|
|2020/01/05 15:45:30|Pool/M_EXPENSIVE_STATEMENTS                                          |      0.60|
|2020/01/05 15:45:30|Pool/RowEngine/SQLPlanStatistics                                     |      0.53|
------------------------------------------------------------------------------------------------------

*/

FRAMES AS
( SELECT
    FR.FRAME_ID,
    MO.MODULE_NAME,
    ME.METHOD_NAME,
    FI.FILE_NAME
  FROM
    Z_MEMPROF_FRAMES FR,
    Z_MEMPROF_MODULES MO,
    Z_MEMPROF_METHODS ME,
    Z_MEMPROF_FILES FI
  WHERE
    FR.MODULE_ID = MO.MODULE_ID AND
    FR.METHEOD_ID = ME.METHOD_ID AND
    FR.FILE_ID = FI.FILE_ID
)
SELECT
  ALLOCATE_TIME,
  ALLOCATOR_NAME,
  LPAD(TO_DECIMAL(SIZE_GB, 10, 2), 10) SIZE_GB,
  IFNULL(METHOD_NAME, '') METHOD_NAME,
  IFNULL(FILE_NAME, '') FILE_NAME
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.ALLOCATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.ALLOCATE_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.ALLOCATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.ALLOCATE_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END ALLOCATE_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ALLOCATOR') != 0 THEN A.ALLOCATOR_NAME ELSE MAP(BI.ALLOCATOR_NAME, '%', 'any', BI.ALLOCATOR_NAME) END ALLOCATOR_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'METHOD')    != 0 THEN F.METHOD_NAME    ELSE MAP(BI.METHOD_NAME,    '%', 'any', BI.METHOD_NAME)    END METHOD_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'FILE')      != 0 THEN F.FILE_NAME      ELSE MAP(BI.FILE_NAME,      '%', 'any', BI.FILE_NAME)      END FILE_NAME,
    SUM(B.SIZE / 1024 / 1024 / 1024) SIZE_GB,
    BI.MIN_SIZE_GB,
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
      ALLOCATOR_NAME,
      METHOD_NAME,
      FILE_NAME,
      MIN_SIZE_GB,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS:FF7',
        'HOUR',        'YYYY/MM/DD HH24',
        'DAY',         'YYYY/MM/DD (DY)',
        'HOUR_OF_DAY', 'HH24',
        TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
      ORDER_BY
    FROM
    ( SELECT                      /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        'SERVER' TIMEZONE,                              /* SERVER, UTC */
        '%' ALLOCATOR_NAME,
        '%' METHOD_NAME,
        '%' FILE_NAME,
        0 MIN_SIZE_GB,
        'NONE' AGGREGATE_BY,         /* TIME, ALLOCATOR, METHOD, FILE or comma separated combinations, NONE for no aggregation */
        'TS10' TIME_AGGREGATE_BY,   /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'SIZE' ORDER_BY          /* NAME, TIME, SIZE */
      FROM
        DUMMY
    )
  ) BI,
    Z_MEMPROF_ALLOCATORS A,
    Z_MEMPROF_ALLOCATES T,
    Z_MEMPROF_BLOCKS B LEFT OUTER JOIN
    Z_MEMPROF_CALLERS C ON
      C.CALLER_ID = B.CALLER_ID LEFT OUTER JOIN
    FRAMES F ON
      F.FRAME_ID = C.FRAME_ID
  WHERE
    A.ALLOCATOR_NAME LIKE BI.ALLOCATOR_NAME AND
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.ALLOCATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.ALLOCATE_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    A.ALLOCATOR_ID = B.ALLOCATOR_ID AND
    T.BLOCK_ID = B.BLOCK_ID AND
    IFNULL(F.METHOD_NAME, '') LIKE BI.METHOD_NAME AND
    IFNULL(F.FILE_NAME, '') LIKE BI.FILE_NAME
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.ALLOCATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.ALLOCATE_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.ALLOCATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.ALLOCATE_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ALLOCATOR') != 0 THEN A.ALLOCATOR_NAME ELSE MAP(BI.ALLOCATOR_NAME, '%', 'any', BI.ALLOCATOR_NAME) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'METHOD')    != 0 THEN F.METHOD_NAME    ELSE MAP(BI.METHOD_NAME,    '%', 'any', BI.METHOD_NAME)    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'FILE')      != 0 THEN F.FILE_NAME      ELSE MAP(BI.FILE_NAME,      '%', 'any', BI.FILE_NAME)      END,
    BI.MIN_SIZE_GB,
    BI.ORDER_BY
)
WHERE
  ( MIN_SIZE_GB = -1 OR SIZE_GB >= MIN_SIZE_GB )
ORDER BY
  MAP(ORDER_BY, 'TIME', ALLOCATE_TIME) DESC,
  MAP(ORDER_BY, 'SIZE', SIZE_GB) DESC,
  ALLOCATOR_NAME
