SELECT
/* 

[NAME]

- HANA_RowStore_Overview

[DESCRIPTION]

- Row store overview including allocated space and fragmentation

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- See SAP Note 1813245 for row store fragmentation

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/06/24:  1.0 (initial version)
- 2014/07/17:  1.1 (wrong fragmentation calculation fixed)
- 2016/01/12:  1.2 (FRAG_PCT calculation adjusted)
- 2017/06/20:  1.3 (significant change in calculations and output columns)
- 2018/01/10:  1.4 (SHARED_GB added to display size relevant for row store size limit as per SAP Note 2154870)

[INVOLVED TABLES]

- M_RS_MEMORY
- M_RS_TABLES

[INPUT PARAMETERS]

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

- MIN_SIZE_GB

  Minimum size in GB

  10              --> Minimum size of 10 GB
  -1              --> No minimum size limitation

- MIN_FRAGMENTATION_PCT

  Minimum fragmentation in percent

  30              --> Minimum fragmentation of 30 %
  -1              --> No restriction based on fragmentation

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOST'          --> Aggregation by host
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

[OUTPUT PARAMETERS]

- HOST:            Host name
- PORT:            Port
- TOTAL_GB:        Total (allocated) size (GB)
- SHARED_GB:       Shared memory used by row store (GB)
- TABLE_GB:        Table size (GB)
- INDEX_GB:        Index size (GB)
- CATALOG_GB:      Catalog size (GB)
- VERSION_GB:      Version size (GB)
- LOCK_GB:         Lock table size (GB)
- PAGELIST_GB:     Page list size (GB)
- EXTFRAG_GARB_GB: Garbage overhead and - after cleanup and before SAP HANA restart - external fragmentation (GB)
- EXTFRAG_GB:      External fragmentation (outside tables, GB)
- INTFRAG_GB:      Internal fragmentation (inside tables, GB)
- FRAG_PCT:        Overall fragmentation (%)

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------------------------------------
|HOST    |PORT |TOTAL_GB|TABLE_GB|INDEX_GB|CATALOG_GB|VERSION_GB|LOCK_GB|PAGELIST_GB|EXTFRAG_GARB_GB|EXTFRAG_GB|INTFRAG_GB|FRAG_PCT|
------------------------------------------------------------------------------------------------------------------------------------
|uslhd097|30003|  773.32|  550.06|   52.04|      0.72|     42.99|   0.78|       0.09|          21.74|     39.31|     65.55|   16.37|
------------------------------------------------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  LPAD(TO_DECIMAL(TOTAL_SIZE_GB, 10, 2), 8) TOTAL_GB,
  LPAD(TO_DECIMAL(SHARED_SIZE_GB, 10, 2), 9) SHARED_GB,
  LPAD(TO_DECIMAL(TABLE_SIZE_GB, 10, 2), 8) TABLE_GB,
  LPAD(TO_DECIMAL(INDEX_SIZE_GB, 10, 2), 8) INDEX_GB,
  LPAD(TO_DECIMAL(CATALOG_SIZE_GB, 10, 2), 10) CATALOG_GB,
  LPAD(TO_DECIMAL(VERSION_SIZE_GB, 10, 2), 10) VERSION_GB,
  LPAD(TO_DECIMAL(LOCK_SIZE_GB, 10, 2), 7) LOCK_GB,
  LPAD(TO_DECIMAL(PAGELIST_SIZE_GB, 10, 2), 11) PAGELIST_GB,
  LPAD(TO_DECIMAL(EXTFRAG_GARB_SIZE_GB, 10, 2), 15) EXTFRAG_GARB_GB,
  LPAD(TO_DECIMAL(EXTFRAG_SIZE_GB, 10, 2), 10) EXTFRAG_GB,
  LPAD(TO_DECIMAL(INTFRAG_SIZE_GB, 10, 2), 10) INTFRAG_GB,
  LPAD(TO_DECIMAL(MAP(TOTAL_SIZE_GB, 0, 0, (EXTFRAG_GARB_SIZE_GB + EXTFRAG_SIZE_GB + INTFRAG_SIZE_GB) / TOTAL_SIZE_GB * 100), 10, 2), 8) FRAG_PCT
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST') != 0 THEN R.HOST             ELSE MAP(BI.HOST, '%', 'any', BI.HOST) END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT') != 0 THEN TO_VARCHAR(R.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT) END PORT,
    SUM(TOTAL_SIZE_GB) TOTAL_SIZE_GB,
    SUM(SHARED_SIZE_GB) SHARED_SIZE_GB,
    GREATEST(0, SUM(TOTAL_SIZE_GB) - SUM(TABLE_SIZE_GB) - SUM(INDEX_SIZE_GB) - SUM(CATALOG_SIZE_GB) - SUM(VERSION_SIZE_GB) -
      SUM(LOCK_SIZE_GB) - SUM(PAGELIST_SIZE_GB) - SUM(EXTFRAG_SIZE_GB) - SUM(INTFRAG_SIZE_GB)) EXTFRAG_GARB_SIZE_GB,
    SUM(EXTFRAG_SIZE_GB) EXTFRAG_SIZE_GB,
    SUM(INTFRAG_SIZE_GB) INTFRAG_SIZE_GB,
    SUM(TABLE_SIZE_GB) TABLE_SIZE_GB,
    SUM(INDEX_SIZE_GB) INDEX_SIZE_GB,
    SUM(CATALOG_SIZE_GB) CATALOG_SIZE_GB,
    SUM(VERSION_SIZE_GB) VERSION_SIZE_GB,
    SUM(LOCK_SIZE_GB) LOCK_SIZE_GB,
    SUM(PAGELIST_SIZE_GB) PAGELIST_SIZE_GB,
    BI.MIN_SIZE_GB,
    BI.MIN_FRAGMENTATION_PCT
  FROM
  ( SELECT                            /* Modification section */
      '%' HOST,
      '%' PORT,
      10 MIN_SIZE_GB,
      -1 MIN_FRAGMENTATION_PCT,
      'NONE' AGGREGATE_BY            /* HOST, PORT or comma separated combinations, NONE for no aggregation */
    FROM
      DUMMY
  ) BI,
  ( SELECT
      HOST,
      PORT,
      SUM(ALLOCATED_SIZE) / 1024 / 1024 / 1024 TOTAL_SIZE_GB,
      SUM(MAP(CATEGORY, 'TABLE', ALLOCATED_SIZE, 'CATALOG', ALLOCATED_SIZE, 0)) / 1024 / 1024 / 1024 SHARED_SIZE_GB,
      SUM(FREE_SIZE) / 1024 / 1024 / 1024 EXTFRAG_SIZE_GB,
      SUM(MAP(CATEGORY, 'BTREE', USED_SIZE, 'CPBTREE', USED_SIZE, 0)) / 1024 / 1024 / 1024 INDEX_SIZE_GB,
      SUM(MAP(CATEGORY, 'CATALOG', USED_SIZE, 0)) / 1024 / 1024 / 1024 CATALOG_SIZE_GB,
      SUM(MAP(CATEGORY, 'VERSION', USED_SIZE, 0)) / 1024 / 1024 / 1024 VERSION_SIZE_GB,
      SUM(MAP(CATEGORY, 'LOCKTABLE', USED_SIZE, 0)) / 1024 / 1024 / 1024 LOCK_SIZE_GB,
      SUM(MAP(CATEGORY, 'PAGELIST', USED_SIZE, 0)) / 1024 / 1024 / 1024 PAGELIST_SIZE_GB
    FROM
      M_RS_MEMORY
    GROUP BY
      HOST,
      PORT
  ) R,
  ( SELECT
      HOST, 
      PORT,
      SUM(ALLOCATED_FIXED_PART_SIZE + ALLOCATED_VARIABLE_PART_SIZE) / 1024 / 1024 / 1024 TOTAL_USED_SIZE_GB,
      SUM(USED_FIXED_PART_SIZE + USED_VARIABLE_PART_SIZE) / 1024 / 1024 / 1024 TABLE_SIZE_GB,
      SUM(ALLOCATED_FIXED_PART_SIZE + ALLOCATED_VARIABLE_PART_SIZE - USED_FIXED_PART_SIZE - USED_VARIABLE_PART_SIZE) / 1024 / 1024 / 1024 INTFRAG_SIZE_GB
    FROM
      M_RS_TABLES
    GROUP BY
      HOST,
      PORT
  ) T
  WHERE
    R.HOST LIKE BI.HOST AND
    TO_VARCHAR(R.PORT) LIKE BI.PORT AND
    T.HOST = R.HOST AND
    T.PORT = R.PORT
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST') != 0 THEN R.HOST             ELSE MAP(BI.HOST, '%', 'any', BI.HOST) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT') != 0 THEN TO_VARCHAR(R.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT) END,
    BI.MIN_SIZE_GB,
    BI.MIN_FRAGMENTATION_PCT
)
WHERE
  ( MIN_SIZE_GB = -1 OR TOTAL_SIZE_GB >= MIN_SIZE_GB ) AND
  ( MIN_FRAGMENTATION_PCT = -1 OR  EXTFRAG_GARB_SIZE_GB + EXTFRAG_SIZE_GB + INTFRAG_SIZE_GB > TOTAL_SIZE_GB * MIN_FRAGMENTATION_PCT / 100 )