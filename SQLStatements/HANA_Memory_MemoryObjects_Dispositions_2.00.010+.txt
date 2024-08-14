SELECT

/* 

[NAME]

- HANA_Memory_MemoryObjects_Dispositions_2.00.010+

[DESCRIPTION]

- Resource container memory object dispositions

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Memory object dispositions control the order of resource container unloads in case of memory pressure
- See SAP Note 1999997 for more information.
- M_MEMORY_OBJECT_DISPOSITIONS.CATEGORY available starting with SAP HANA 2.00.010
- Can be used for monitoring remote system replication sites, see SAP Note 1999880 
  ("Is it possible to monitor remote system replication sites on the primary system") for details.

[VALID FOR]

- Revisions:              >= 2.00.010

[SQL COMMAND VERSION]

- 2017/05/17:  1.0 (initial version)

[INVOLVED TABLES]

- M_MEMORY_OBJECT_DISPOSITIONS

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

- OBJECT_TYPE

  Object type

  'Persistency/Pages/RowStore' --> Object type Persistency/Pages/RowStore
  'Attribute%'                 --> Object types starting with 'Attribute'
  '%'                          --> No restriction of object type

- ALLOCATOR

  Heap allocator name (or Pool/ColumnStore/System for column store)

  'Pool/ColumnStore/System' --> Restrict output to column store related allocators
  '%'                       --> No limitation related to allocators

- DISPOSITION

  Disposition class (TEMPORARY, PAGE_LOADABLE, INTERNAL_SHORT_TERM, SHORT_TERM, MID_TERM, LONG_TERM, NON_SWAPPABLE)

  'SHORT_TERM'   --> Only display information related to disposition SHORT_TERM
  '%'            --> No restriction related to disposition

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'DISPOSITION'   --> Aggregation by disposition
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'TOTAL'         --> Sorting by total size
  'SWAPPABLE'     --> Sorting by swappable size 
  'NONSWAPPABLE'  --> Sorting by non-swappable size
  
[OUTPUT PARAMETERS]

- HOST:               Host name
- PORT:               Port
- OBJECT_TYPE:        Object type
- ALLOCATOR:          Related heap allocator (Pool/ColumnStore/System for column store tables)
- DISPOSITION:        Disposition class
- OBJECT_COUNT:       Number of objects
- OBJECT_SIZE_GB:     Object size (GB)
- SIZE_PER_OBJECT_KB: Size per object (KB)

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------
|OBJECT_TYPE                                    |DISPOSITION        |OBJECT_COUNT|OBJECT_SIZE_GB|SIZE_PER_OBJECT_KB|
--------------------------------------------------------------------------------------------------------------------
|AttributeEngine/AttributeValueContainerElement |LONG_TERM          |     1283759|       3442.49|           2811.83|
|Cache/HierarchyCache                           |SHORT_TERM         |        7209|        499.31|          72627.05|
|Persistency/Pages/Default                      |INTERNAL_SHORT_TERM|      194839|        161.37|            868.47|
|Persistency/Pages/RowStore                     |NON_SWAPPABLE      |     7364608|        116.92|             16.64|
|Persistency/Pages/Default                      |SHORT_TERM         |     1400790|        102.45|             76.69|
|Cache/MdxHierarchyCache                        |SHORT_TERM         |        1225|         40.59|          34744.45|
|AttributeEngine/AttributeValueContainerElement |NON_SWAPPABLE      |     1295833|          8.95|              7.24|
|Persistency/Pages/Default                      |LONG_TERM          |      236301|          5.27|             23.42|
|Persistency/Container/VirtualFile              |SHORT_TERM         |     3505507|          3.13|              0.93|
|Persistency/Pages/Default                      |TEMPORARY          |        3983|          2.65|            699.15|
|Persistency/Pages/Converter/Default            |TEMPORARY          |        5667|          1.39|            258.69|
--------------------------------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  OBJECT_TYPE,
  ALLOCATOR,
  DISPOSITION,
  LPAD(OBJECT_COUNT, 12) OBJECT_COUNT,
  LPAD(TO_DECIMAL(OBJECT_SIZE / 1024 / 1024 / 1024, 10, 2), 14) OBJECT_SIZE_GB,
  LPAD(TO_DECIMAL(MAP(OBJECT_COUNT, 0, 0, OBJECT_SIZE / OBJECT_COUNT / 1024), 10, 2), 18) SIZE_PER_OBJECT_KB
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')        != 0 THEN M.HOST             ELSE MAP(BI.HOST, '%', 'any', BI.HOST)               END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')        != 0 THEN TO_VARCHAR(M.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT)               END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'OBJECT_TYPE') != 0 THEN M.TYPE             ELSE MAP(BI.OBJECT_TYPE, '%', 'any', BI.OBJECT_TYPE) END OBJECT_TYPE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DISPOSITION') != 0 THEN D.DISPOSITION      ELSE MAP(BI.DISPOSITION, '%', 'any', BI.DISPOSITION) END DISPOSITION,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ALLOCATOR')   != 0 THEN M.CATEGORY         ELSE MAP(BI.ALLOCATOR, '%', 'any', BI.ALLOCATOR)     END ALLOCATOR,
    SUM(MAP(D.DISPOSITION,
      'TEMPORARY',           M.TEMPORARY_OBJECT_COUNT,
      'PAGE_LOADABLE',       M.PAGE_LOADABLE_COLUMNS_OBJECT_COUNT,
      'EARLY_UNLOAD',        M.EARLY_UNLOAD_OBJECT_COUNT,
      'INTERNAL_SHORT_TERM', M.INTERNAL_SHORT_TERM_OBJECT_COUNT,
      'SHORT_TERM',          M.SHORT_TERM_OBJECT_COUNT,
      'MID_TERM',            M.MID_TERM_OBJECT_COUNT,
      'LONG_TERM',           M.LONG_TERM_OBJECT_COUNT,
      'NON_SWAPPABLE',       M.NON_SWAPPABLE_OBJECT_COUNT)) OBJECT_COUNT,
    SUM(MAP(D.DISPOSITION,
      'TEMPORARY',           M.TEMPORARY_OBJECT_SIZE,
      'PAGE_LOADABLE',       M.PAGE_LOADABLE_COLUMNS_OBJECT_SIZE,
      'EARLY_UNLOAD',        M.EARLY_UNLOAD_OBJECT_SIZE,
      'INTERNAL_SHORT_TERM', M.INTERNAL_SHORT_TERM_OBJECT_SIZE,
      'SHORT_TERM',          M.SHORT_TERM_OBJECT_SIZE,
      'MID_TERM',            M.MID_TERM_OBJECT_SIZE,
      'LONG_TERM',           M.LONG_TERM_OBJECT_SIZE,
      'NON_SWAPPABLE',       M.NON_SWAPPABLE_OBJECT_SIZE)) OBJECT_SIZE,
    BI.ORDER_BY
  FROM
  ( SELECT               /* Modification section */
      '%' HOST,
      '%' PORT,
      '%' OBJECT_TYPE, 
      '%' ALLOCATOR,
      '%' DISPOSITION,
      'OBJECT_TYPE, DISPOSITION, ALLOCATOR' AGGREGATE_BY, /* HOST, PORT, OBJECT_TYPE, DISPOSITION, ALLOCATOR */
      'SIZE' ORDER_BY                          /* SIZE, COUNT, HOST, OBJECT_TYPE, DISPOSITION, ALLOCATOR */
    FROM
      DUMMY
  ) BI,
  ( SELECT 'TEMPORARY' DISPOSITION FROM DUMMY UNION ALL
    SELECT 'PAGE_LOADABLE'         FROM DUMMY UNION ALL
    SELECT 'EARLY_UNLOAD'          FROM DUMMY UNION ALL
    SELECT 'INTERNAL_SHORT_TERM'   FROM DUMMY UNION ALL
    SELECT 'SHORT_TERM'            FROM DUMMY UNION ALL
    SELECT 'MID_TERM'              FROM DUMMY UNION ALL
    SELECT 'LONG_TERM'             FROM DUMMY UNION ALL
    SELECT 'NON_SWAPPABLE'         FROM DUMMY
  ) D,
    M_MEMORY_OBJECT_DISPOSITIONS M
  WHERE
    M.HOST LIKE BI.HOST AND
    TO_CHAR(M.PORT) LIKE BI.PORT AND
    M.TYPE LIKE BI.OBJECT_TYPE AND
    D.DISPOSITION LIKE BI.DISPOSITION AND
    M.CATEGORY LIKE BI.ALLOCATOR
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')        != 0 THEN M.HOST             ELSE MAP(BI.HOST, '%', 'any', BI.HOST)               END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')        != 0 THEN TO_VARCHAR(M.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT)               END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'OBJECT_TYPE') != 0 THEN M.TYPE             ELSE MAP(BI.OBJECT_TYPE, '%', 'any', BI.OBJECT_TYPE) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DISPOSITION') != 0 THEN D.DISPOSITION      ELSE MAP(BI.DISPOSITION, '%', 'any', BI.DISPOSITION) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ALLOCATOR')   != 0 THEN M.CATEGORY         ELSE MAP(BI.ALLOCATOR, '%', 'any', BI.ALLOCATOR)     END,
    ORDER_BY
)
WHERE
( OBJECT_COUNT > 0 OR OBJECT_SIZE > 0 )
ORDER BY
  MAP(ORDER_BY, 'SIZE', OBJECT_SIZE, 'COUNT', OBJECT_COUNT) DESC,
  MAP(ORDER_BY, 'HOST', HOST || PORT, 'OBJECT_TYPE', OBJECT_TYPE, 'DISPOSITION', DISPOSITION, 'ALLOCATOR', ALLOCATOR)