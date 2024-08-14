SELECT

/* 

[NAME]

- HANA_Memory_ProcessMemory_2.00.040+

[DESCRIPTION]

- Current SAP HANA process memory information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Can only be executed with SAP_INTERNAL_HANA_SUPPORT role or as SYSTEM
- Only available SAP internally, not available for public use
- Contains information about heap memory fragmentation (FRAG* columns)
- M_DEV_PROCESS_MEMORY.MEMORYCACHE_FREE_SIZE available starting SAP HANA 2.0 SPS 01
- M_SERVICE_MEMORY.FRAGMENTED_MEMORY_SIZE available starting SAP HANA 2.0 SPS 04

[VALID FOR]

- Revisions:              >= 2.00.040

[SQL COMMAND VERSION]

- 2017/02/06:  1.0 (initial version)
- 2018/10/05:  1.1 (PROCESS_ALLOCATION_LIMIT -> EFFECTIVE_ALLOCATION_LIMIT)
- 2018/11/27:  1.2 (dedicated 2.00.010+ version with MEMORYCACHE_FREE_SIZE)
- 2019/08/12:  1.3 (dedicated 2.00.040+ version based on public views)

[INVOLVED TABLES]

- M_SERVICE_MEMORY

[INPUT PARAMETERS]

- PORT

  Port number

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- HOST

  Host name

  'saphana01'     --> Specific host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

[OUTPUT PARAMETERS]

- HOST:            Host
- PORT:            Port
- PAL_GB:          Process allocation limit (GB)
- ALLOC_GB:        Allocated memory (GB)
- HEAP_USED_GB:    Heap memory (GB)
- SHARED_USED_GB:  Shared memory (GB)
- FREE_GB:         Free memory within allocated memory (GB), i.e. allocated minus used minus fragmented
- FRAG_GB:         Memory fragmentation (GB)
- ALLOC_PCT:       Percentage of effective allocation limit being allocated at the moment
- HEAP_USED_PCT:   Percentage of effective allocation limit occupied by heap allocators
- SHARED_USED_PCT: Percentage of effective allocation limit occupied by shared memory
- FREE_PCT:        Percentage of effective allocation limit occupied by free blocks (within allocated memory)
- FRAG_PCT:        Percentage of effective allocation limit consumed by fragmentation (can be cleaned with hdbcons "mm gc -f")

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------
|HOST   |PORT |PAL_GB |ALLOC_GB|HEAP_USED_GB|FREE_GB|FRAG_GB|ALLOC_PCT|HEAP_USED_PCT|FREE_PCT|FRAG_PCT|
-------------------------------------------------------------------------------------------------------
|ls80010|30001| 176.55|    2.70|        1.43|   0.00|   1.26|     1.53|         0.81|    0.00|    0.71|
|ls80010|30002| 176.55|    1.60|        0.25|   0.00|   1.34|     0.90|         0.14|    0.00|    0.76|
|ls80010|30003| 176.55|  176.14|      155.34|   0.00|  20.80|    99.77|        87.98|    0.00|   11.78|
|ls80010|30004| 176.55|    2.25|        1.30|   0.00|   0.94|     1.27|         0.74|    0.00|    0.53|
|ls80010|30006| 176.55|    1.54|        0.48|   0.00|   1.06|     0.87|         0.27|    0.00|    0.60|
|ls80010|30007| 176.55|    9.19|        6.95|   0.00|   2.24|     5.20|         3.93|    0.00|    1.27|
|ls80010|30010| 176.55|    3.03|        0.28|   0.00|   2.75|     1.71|         0.16|    0.00|    1.55|
|ls80010|30011| 176.55|    3.07|        1.40|   0.00|   1.67|     1.74|         0.79|    0.00|    0.94|
-------------------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  LPAD(TO_DECIMAL(PAL_GB, 10, 0), 7) PAL_GB,
  LPAD(TO_DECIMAL(ALLOC_GB, 10, 2), 8) ALLOC_GB,
  LPAD(TO_DECIMAL(HEAP_USED_GB, 10, 2), 12) HEAP_USED_GB,
  LPAD(TO_DECIMAL(SHARED_USED_GB, 10, 2), 14) SHARED_USED_GB,
  LPAD(TO_DECIMAL(FREE_GB, 10, 2), 7) FREE_GB,
  LPAD(TO_DECIMAL(FRAG_GB, 10, 2), 7) FRAG_GB,
  LPAD(TO_DECIMAL(ALLOC_PCT, 10, 2), 9) ALLOC_PCT,
  LPAD(TO_DECIMAL(HEAP_USED_PCT, 10, 2), 13) HEAP_USED_PCT,
  LPAD(TO_DECIMAL(SHARED_USED_PCT, 10, 2), 15) SHARED_USED_PCT,
  LPAD(TO_DECIMAL(FREE_PCT, 10, 2), 8) FREE_PCT,
  LPAD(TO_DECIMAL(FRAG_PCT, 10, 2), 8) FRAG_PCT
FROM
( SELECT
    SM.HOST,
    SM.PORT,
    SM.EFFECTIVE_ALLOCATION_LIMIT / 1024 / 1024 / 1024 PAL_GB,
    ( SM.HEAP_MEMORY_ALLOCATED_SIZE + SM.SHARED_MEMORY_ALLOCATED_SIZE ) / 1024 / 1024 / 1024 ALLOC_GB,
    MAP(SM.EFFECTIVE_ALLOCATION_LIMIT, 0, 0, ( SM.HEAP_MEMORY_ALLOCATED_SIZE + SM.SHARED_MEMORY_ALLOCATED_SIZE ) / SM.EFFECTIVE_ALLOCATION_LIMIT * 100) ALLOC_PCT,
    SM.HEAP_MEMORY_USED_SIZE / 1024 / 1024 / 1024 HEAP_USED_GB,
    MAP(SM.EFFECTIVE_ALLOCATION_LIMIT, 0, 0, SM.HEAP_MEMORY_USED_SIZE / SM.EFFECTIVE_ALLOCATION_LIMIT * 100) HEAP_USED_PCT,
    SM.SHARED_MEMORY_USED_SIZE / 1024 / 1024 / 1024 SHARED_USED_GB,
    MAP(SM.EFFECTIVE_ALLOCATION_LIMIT, 0, 0, SM.SHARED_MEMORY_USED_SIZE / SM.EFFECTIVE_ALLOCATION_LIMIT * 100) SHARED_USED_PCT,
    SM.FREE_MEMORY_SIZE / 1024 / 1024 / 1024 FREE_GB,
    MAP(SM.EFFECTIVE_ALLOCATION_LIMIT, 0, 0, SM.FREE_MEMORY_SIZE / SM.EFFECTIVE_ALLOCATION_LIMIT * 100) FREE_PCT,
    SM.FRAGMENTED_MEMORY_SIZE / 1024 / 1024 / 1024 FRAG_GB,
    MAP(SM.EFFECTIVE_ALLOCATION_LIMIT, 0, 0, SM.FRAGMENTED_MEMORY_SIZE / SM.EFFECTIVE_ALLOCATION_LIMIT * 100) FRAG_PCT
  FROM
  ( SELECT               /* Modification section */
      '%' HOST,
      '%' PORT
    FROM
      DUMMY
  ) BI,
    M_SERVICE_MEMORY SM
  WHERE
    SM.HOST LIKE BI.HOST AND
    TO_VARCHAR(SM.PORT) LIKE BI.PORT
)
ORDER BY
  HOST,
  PORT
