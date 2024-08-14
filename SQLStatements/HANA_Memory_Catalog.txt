SELECT

/* 

[NAME]

- HANA_Memory_Catalog

[DESCRIPTION]

- SAP HANA catalog overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- SAP HANA catalog is covered, not to be mixed with backup catalog
- Relates to CATALOG entry in M_RS_MEMORY respectively CATALOG_GB returned by SQL: "HANA_RowStore_Overview"

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2019/12/30:  1.0 (initial version)

[INVOLVED TABLES]

- M_CATALOG_MEMORY

[INPUT PARAMETERS]

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

- CATEGORY

  Catalog category

  'INDEX_INFO_OBJECT' --> Entries belonging to category INDEX_INFO_OBJECT
  '%COLUMN%'          --> Categories containing 'COLUMN'
  '%'                 --> No restriction related to category

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'CATEGORY'      --> Aggregation by category
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'USED'          --> Sorting by used memory
  'COUNT'         --> Sorting by number of allocations

[OUTPUT PARAMETERS]

- HOST:     Host
- PORT:     Port
- CATEGORY: Catalog category
- COUNT:    Allocation count
- ALLOC_MB: Allocated size (MB)
- USED_MB:  Used size (MB)
- FRAG_PCT: Fragmentation (%)

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------
|HOST   |PORT |CATEGORY                 |COUNT     |ALLOC_MB |USED_MB  |FRAG_PCT|
---------------------------------------------------------------------------------
|saphana|30003|CS_COLUMNS_              |   1511731|   414.40|   403.67|    2.58|
|saphana|30003|CS_VIEW_ATTRIBUTES_      |    266133|   101.46|    99.49|    1.94|
|saphana|30003|RS_COLUMN_INFO_OBJECT    |    287154|    78.76|    76.67|    2.64|
|saphana|30003|CS_TABLES_               |    113296|    47.85|    46.67|    2.47|
|saphana|30003|P_OBJECTDEPENDENCY_      |    593565|    34.01|    31.69|    6.80|
|saphana|30003|INDEX_INFO_OBJECT        |    121434|    21.81|    21.30|    2.30|
|saphana|30003|P_INDEXCOLUMNS_          |    414206|    20.88|    19.94|    4.48|
|saphana|30003|OBJECT_INFO_OBJECT       |    157910|    14.68|    14.45|    1.56|
|saphana|30003|TOPOLOGY_INFORMATION_    |    137377|    14.10|    13.62|    3.43|
|saphana|30003|CS_HIERARCHY_DEFINITIONS_|     17096|     7.03|     6.78|    3.53|
---------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  CATEGORY,
  LPAD(COUNT, 10) COUNT,
  LPAD(TO_DECIMAL(ALLOC_MB, 10, 2), 9) ALLOC_MB,
  LPAD(TO_DECIMAL(USED_MB, 10, 2), 9) USED_MB,
  LPAD(TO_DECIMAL(MAP(ALLOC_MB, 0, 0, 100 - USED_MB / ALLOC_MB * 100), 10, 2), 8) FRAG_PCT
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')     != 0 THEN CM.HOST             ELSE MAP(BI.HOST,     '%', 'any', BI.HOST)     END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')     != 0 THEN TO_VARCHAR(CM.PORT) ELSE MAP(BI.PORT,     '%', 'any', BI.PORT)     END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CATEGORY') != 0 THEN CM.CATEGORY         ELSE MAP(BI.CATEGORY, '%', 'any', BI.CATEGORY) END CATEGORY,
    SUM(CM.ALLOCATION_COUNT) COUNT,
    SUM(CM.ALLOCATED_FIXED_PART_SIZE + CM.ALLOCATED_VARIABLE_PART_SIZE) / 1024 / 1024 ALLOC_MB,
    SUM(CM.USED_FIXED_PART_SIZE + CM.USED_VARIABLE_PART_SIZE) / 1024 / 1024 USED_MB,
    BI.ORDER_BY
  FROM
  ( SELECT                /* Modification section */
      '%' HOST,
      '%' PORT,
      '%' CATEGORY,
      'NONE' AGGREGATE_BY,       /* HOST, PORT, CATEGORY or comma separated combinations, NONE for no aggregation */
      'USED' ORDER_BY            /* ALLOC, USED, COUNT, CATEGORY */
    FROM
      DUMMY
  ) BI,
    M_CATALOG_MEMORY CM
  WHERE
    CM.HOST LIKE BI.HOST AND
    TO_VARCHAR(CM.PORT) LIKE BI.PORT AND
    CM.CATEGORY LIKE BI.CATEGORY
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')     != 0 THEN CM.HOST             ELSE MAP(BI.HOST,     '%', 'any', BI.HOST)     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')     != 0 THEN TO_VARCHAR(CM.PORT) ELSE MAP(BI.PORT,     '%', 'any', BI.PORT)     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CATEGORY') != 0 THEN CM.CATEGORY         ELSE MAP(BI.CATEGORY, '%', 'any', BI.CATEGORY) END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'ALLOC', ALLOC_MB, 'USED', USED_MB, 'COUNT', COUNT) DESC,
  HOST,
  PORT,
  CATEGORY 