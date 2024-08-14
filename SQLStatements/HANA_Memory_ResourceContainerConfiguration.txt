SELECT
/* 

[NAME]

- HANA_Memory_ResourceContainerConfiguration

[DESCRIPTION]

- Generation of proposals for resource container configuration

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- The resource container contains heap areas that are supposed to be swappable and the row store
- Heap areas without a need for caching (e.g. temporary SQL result set allocators or Pool/RowEngine/MonitorView) 
  are not part of the resource container and so they may allocate memory on top of the resource container size.
- Up to SAP HANA <= 2.00 SPS 00 it is not possible to determine the heap allocators being or being not part of the
  resource container via SQL. Starting with SAP HANA 2.00 SPS 01 M_MEMORY_OBJECT_DISPOSITIONS.CATEGORY contains the mapping.
- Usually a manual configuration of the resource container is not required, but in the context of SAP Note 2301382
  (Rev. 1.00.110 - 1.00.122.05) it is recommended in order to avoid automatic shrinks. Also in other scenarios (e.g. SAP Note 2808956)
  it can sometimes make sense.
- SIZE_BUFFER_PCT and MIN_ALLOC_LIM_PCT are the crucial settings (maximum of both will be used):

  -> If value is too low:  Risk of column unloads due to unnecessary configuration-based resource container shrinks
  -> If value is too high: Risk of global stuck situations due to automatic resource container shrinks

- Configuration depends on SAP HANA Revision level:

  -> SAP HANA <= 1.00.122.01: "resman shrink" via hdbcons
  -> SAP HANA >= 1.00.122.02: unload_upper_bound parameter

- Calculated values can be too high in context of bug 239406 (<= 2.00.047), unload_upper_bound should not be used in this context

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2017/03/06:  1.0 (initial version)
- 2017/03/29:  1.1 (MIN_ALLOC_LIM_PCT included)
- 2019/11/28:  1.2 (L/Code/uncategorized for Debuggee allocator included)

[INVOLVED TABLES]

- M_MEMORY_OBJECTS
- M_HOST_RESOURCE_UTILIZATION

[INPUT PARAMETERS]

- HOST

  Host name

  'saphana01'     --> Specic host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- SIZE_BUFFER_PCT

  Buffer on top of current resource container size (%)

  20              --> Allow a resource container growth of up to 20 % before triggering a shrink
  -1              --> Values <= 2 % are generally mapped to a minimum buffer of 2 %

- MIN_ALLOC_LIM_PCT

  Minimum percentage of allocation limit recommended for resource container size

  50              --> At least recommend a resource container size of 50 % of the allocation limit
  -1              --> No restriction related to allocation limit

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOST'          --> Aggregation by host (host specific parameter commands are generated)
  'NONE'          --> No aggregation (host specific parameter commands are generated)
  'ALL'           --> Complete aggregation (system-wide parameter commands are generated)
  
[OUTPUT PARAMETERS]

- HOST:                       Host name
- ALLOCLIM_GB:                Global allocation limit (GB)
- RC_TOTAL_GB:                Total resource container size (GB)
- RC_SWAP_GB:                 Swappable resource container size (GB)
- RC_PAGE_GB:                 Swappable size of page cache (+ other usual suspects like Debuggee allocator) in resource container (GB)
- UUB_REC_GB:                 Suggested unload_upper_bound value (GB)
- RS_REC_GB:                  Suggested resman shrink size (GB)
- UNLOAD_UPPER_BOUND_COMMAND: Command to set parameter unload_upper_bound (>= 122.02)
- RESMAN_SHRINK_COMMAND:      Command for resman shrink option of hdbcons (SAP Note 2222218)

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST|ALLOCLIM_GB|RC_TOTAL_GB|RC_SWAP_GB|RC_PAGE_GB|UUB_REC_GB|RS_REC_GB|UNLOAD_UPPER_BOUND_COMMAND                                                                                                              |RESMAN_SHRINK_COMMAND          |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|hn01|   15665.53|   10808.09|  10067.49|    614.06|  11344.10| 12232.83|ALTER SYSTEM ALTER CONFIGURATION('global.ini', 'SYSTEM') SET ('memoryobjects', 'unload_upper_bound') = '12180639147090' WITH RECONFIGURE|resman shrink -s 13134903409924|
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(TO_DECIMAL(ALLOCLIM_GB, 10, 2), 11) ALLOCLIM_GB,
  LPAD(TO_DECIMAL(RC_TOTAL_GB, 10, 2), 11) RC_TOTAL_GB,
  LPAD(TO_DECIMAL(RC_SWAP_GB, 10, 2), 10) RC_SWAP_GB,
  LPAD(TO_DECIMAL(RC_PAGE_GB, 10, 2), 10) RC_PAGE_GB,
  LPAD(TO_DECIMAL(UUB_REC_GB, 10 , 2), 10) UUB_REC_GB,
  LPAD(TO_DECIMAL(RS_REC_GB, 10 , 2), 9) RS_REC_GB,
  UNLOAD_UPPER_BOUND_COMMAND,
  RESMAN_SHRINK_COMMAND
FROM
( SELECT
    ROW_NUMBER () OVER (PARTITION BY HOST ORDER BY UUB_REC_GB DESC) ROW_NUM,
    HOST,
    ALLOCLIM_GB,
    RC_TOTAL_GB,
    RC_SWAP_GB,
    RC_PAGE_GB,
    UUB_REC_GB,
    RS_REC_GB,
    'ALTER SYSTEM ALTER CONFIGURATION(' || CHAR(39) || 'global.ini' || CHAR(39) || ',' || CHAR(32) || CHAR(39) || 
      MAP(HOST, 'any', 'SYSTEM', 'HOST' || CHAR(39) || ',' || CHAR(32) || CHAR(39) || HOST) || CHAR(39) || ') SET (' ||
      CHAR(39) || 'memoryobjects' || CHAR(39) || ',' || CHAR(32) || CHAR(39) || 'unload_upper_bound' || CHAR(39) || ') =' || CHAR(32) || CHAR(39) ||
      TO_DECIMAL(ROUND(UUB_REC_GB * 1024 * 1024 * 1024), 15, 0) || CHAR(39) || CHAR(32) || 'WITH RECONFIGURE' UNLOAD_UPPER_BOUND_COMMAND,
    'resman shrink -s' || CHAR(32) || TO_DECIMAL(ROUND(RS_REC_GB * 1024 * 1024 * 1024), 15, 0) RESMAN_SHRINK_COMMAND
  FROM
  ( SELECT
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST') != 0 THEN T.HOST ELSE MAP(BI.HOST, '%', 'any', BI.HOST) END HOST,
      H.ALLOCATION_LIMIT / 1024 / 1024 / 1024 ALLOCLIM_GB,
      T.OBJECT_SIZE / 1024 / 1024 / 1024 RC_TOTAL_GB,
      T.SWAPPABLE_SIZE / 1024 / 1024 / 1024 RC_SWAP_GB,
      P.SWAPPABLE_SIZE / 1024 / 1024 / 1024 RC_PAGE_GB,
      GREATEST(
        MAP(BI.MIN_ALLOC_LIM_PCT, -1, 0, ALLOCATION_LIMIT / 100 * BI.MIN_ALLOC_LIM_PCT - R.OBJECT_SIZE),
        (T.SWAPPABLE_SIZE - P.SWAPPABLE_SIZE) * ( 100 + GREATEST(SIZE_BUFFER_PCT, 2)) / 100)
        / 1024 / 1024 / 1024 UUB_REC_GB,
      GREATEST(
        MAP(BI.MIN_ALLOC_LIM_PCT, -1, 0, ALLOCATION_LIMIT / 100 * BI.MIN_ALLOC_LIM_PCT),
        (T.OBJECT_SIZE - P.SWAPPABLE_SIZE) * ( 100 + GREATEST(SIZE_BUFFER_PCT, 2)) / 100)
        / 1024 / 1024 / 1024 RS_REC_GB,
      BI.SIZE_BUFFER_PCT
    FROM
    ( SELECT                       /* Modification section */
        '%' HOST,
        20 SIZE_BUFFER_PCT,
        50 MIN_ALLOC_LIM_PCT,
        'ALL' AGGREGATE_BY          /* HOST, NONE for no aggregation, ALL for full aggregation */
      FROM
        DUMMY
    ) BI,
      M_MEMORY_OBJECTS T,
    ( SELECT
        HOST,
        PORT,
        SUM(SWAPPABLE_SIZE) SWAPPABLE_SIZE
      FROM
        M_MEMORY_OBJECTS
      WHERE
        TYPE LIKE 'Persistency/%/Default' OR
        TYPE = 'L/Code/uncategorized'
      GROUP BY
        HOST,
        PORT
    ) P,
      M_MEMORY_OBJECTS R,
    ( SELECT
        HOST,
        MAX(EFFECTIVE_ALLOCATION_LIMIT) ALLOCATION_LIMIT
      FROM
        M_SERVICE_MEMORY
      GROUP BY
        HOST
    ) H
    WHERE
      T.HOST LIKE BI.HOST AND
      T.HOST = P.HOST AND
      T.PORT = P.PORT AND
      T.HOST = R.HOST AND
      T.PORT = R.PORT AND
      H.HOST = P.HOST AND
      T.TYPE = '/' AND
      R.TYPE LIKE 'Persistency/%/RowStore'
  )
)
WHERE
  ROW_NUM = 1
ORDER BY
  HOST