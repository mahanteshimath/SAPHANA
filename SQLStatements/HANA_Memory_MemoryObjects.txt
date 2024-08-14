SELECT
/* 

[NAME]

- HANA_Memory_MemoryObjects

[DESCRIPTION]

- Resource container memory objects overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- The resource container contains heap areas that are supposed to be swappable and the row store
- Heap areas without a need for caching (e.g. temporary SQL result set allocators or Pool/RowEngine/MonitorView) 
  are not part of the resource container and so they may allocate memory on top of the resource container size.
- Up to SAP HANA <= 2.00 SPS 00 it is not possible to determine the heap allocators being or being not part of the
  resource container via SQL. Starting with SAP HANA 2.00 SPS 01 M_MEMORY_OBJECT_DISPOSITIONS.CATEGORY contains the mapping.
- Can be used for monitoring remote system replication sites, see SAP Note 1999880 
  ("Is it possible to monitor remote system replication sites on the primary system") for details.

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/04/30:  1.0 (initial version)
- 2016/10/04:  1.1 (ORDER_BY and NONSWAPPABLE included)

[INVOLVED TABLES]

- M_MEMORY_OBJECTS

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

- SIZE_INFORMATION

  Controls the display of gross (inclusive) or net (exclusive) sizes

  'INCLUSIVE'     --> Gross sizes including sub areas are displayed
  'EXCLUSIVE'     --> Net sizes without sub areas are displayed

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'TOTAL'         --> Sorting by total size
  'SWAPPABLE'     --> Sorting by swappable size 
  'NONSWAPPABLE'  --> Sorting by non-swappable size

  
[OUTPUT PARAMETERS]

- HOST:          Host name
- PORT:          Port
- OBJECT_TYPE:   Object type
- NUM_OBJECTS:   Number of objects belonging to object type
- SIZE_GB:       Allocated memory size (GB)
- SWAPPABLE_GB:  Swappable memory size (GB)
- SWAPPABLE_PCT: Percentage of swappable memory size compared to allocated memory size

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------------------
|HOST     |PORT |OBJECT_TYPE                                   |NUM_OBJECTS|SIZE_GB   |SWAPPABLE_GB|SWAPPABLE_PCT|
------------------------------------------------------------------------------------------------------------------
|saphana21|30103|AttributeEngine/AttributeValueContainerElement|     150900|    898.45|      896.80|        99.81|
|saphana21|30103|Persistency/Container/VirtualFile             |    2304461|    219.77|      219.77|       100.00|
|saphana21|30103|Persistency/Pages/RowStore                    |    6332416|    100.39|        0.00|         0.00|
|saphana21|30103|Persistency/Pages/Default                     |    6611258|     79.90|       79.90|       100.00|
|saphana21|30105|AttributeEngine/AttributeValueContainerElement|      11947|      9.69|        0.00|         0.00|
|saphana21|30105|Persistency/Pages/Default                     |       4935|      1.78|        1.78|       100.00|
|saphana21|30103|Persistency/Container/CleanupFile             |    2829920|      1.51|        1.51|       100.00|
------------------------------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  TYPE OBJECT_TYPE,
  LPAD(TO_VARCHAR(NUM_OBJECTS), 11) NUM_OBJECTS,
  LPAD(TO_DECIMAL(SIZE_GB, 10, 2), 10) SIZE_GB,
  LPAD(TO_DECIMAL(SWAPPABLE_GB, 10, 2), 12) SWAPPABLE_GB,
  LPAD(TO_DECIMAL(SIZE_GB - SWAPPABLE_GB, 10, 2), 12) NONSWAP_GB,
  LPAD(TO_DECIMAL(MAP(SIZE_GB, 0, 0, SWAPPABLE_GB / SIZE_GB * 100), 10, 2), 13) SWAPPABLE_PCT
FROM
( SELECT
    HOST,
    PORT,
    TYPE,
    CASE WHEN SIZE_INFORMATION = 'EXCLUSIVE' THEN NUM_OBJECTS - IFNULL(REC_NUM_OBJECTS, 0) ELSE NUM_OBJECTS END NUM_OBJECTS,
    CASE WHEN SIZE_INFORMATION = 'EXCLUSIVE' THEN SIZE_GB - IFNULL(REC_SIZE_GB, 0) ELSE SIZE_GB END SIZE_GB,
    CASE WHEN SIZE_INFORMATION = 'EXCLUSIVE' THEN SWAPPABLE_GB - IFNULL(REC_SWAPPABLE_GB, 0) ELSE SWAPPABLE_GB END SWAPPABLE_GB,
    ORDER_BY
  FROM
  ( SELECT
      M.HOST,
      M.PORT,
      M.TYPE,
      M.OBJECT_COUNT NUM_OBJECTS,
      ( SELECT 
          SUM(M2.OBJECT_COUNT)
        FROM 
          M_MEMORY_OBJECTS M2 
        WHERE 
          M2.HOST = M.HOST AND 
          M2.PORT = M.PORT AND 
          ( M.TYPE = '/' AND M2.TYPE NOT LIKE '%/%' OR 
            M.TYPE != '/' AND M2.TYPE LIKE M.TYPE || '/%' AND M2.TYPE NOT LIKE M.TYPE || '/%/%' )
      ) REC_NUM_OBJECTS,
      M.OBJECT_SIZE / 1024 / 1024 / 1024 SIZE_GB,
      ( SELECT 
          SUM(M2.OBJECT_SIZE) / 1024 / 1024 / 1024 
        FROM 
          M_MEMORY_OBJECTS M2 
        WHERE 
          M2.HOST = M.HOST AND 
          M2.PORT = M.PORT AND 
          ( M.TYPE = '/' AND M2.TYPE NOT LIKE '%/%' OR 
            M.TYPE != '/' AND M2.TYPE LIKE M.TYPE || '/%' AND M2.TYPE NOT LIKE M.TYPE || '/%/%' )
      ) REC_SIZE_GB,
      M.SWAPPABLE_SIZE / 1024 / 1024 / 1024 SWAPPABLE_GB,
      ( SELECT 
          SUM(M2.SWAPPABLE_SIZE) / 1024 / 1024 / 1024 
        FROM 
          M_MEMORY_OBJECTS M2 
        WHERE 
          M2.HOST = M.HOST AND 
          M2.PORT = M.PORT AND 
          ( M.TYPE = '/' AND M2.TYPE NOT LIKE '%/%' OR 
            M.TYPE != '/' AND M2.TYPE LIKE M.TYPE || '/%' AND M2.TYPE NOT LIKE M.TYPE || '/%/%' )
      ) REC_SWAPPABLE_GB,
      BI.SIZE_INFORMATION,
      BI.ORDER_BY
    FROM
    ( SELECT                    /* Modification section */
        '%' HOST,
        '%' PORT,
        '%' OBJECT_TYPE,
        'EXCLUSIVE' SIZE_INFORMATION,             /* EXCLUSIVE, INCLUSIVE */
        'COUNT' ORDER_BY                     /* COUNT, TOTAL, SWAPPABLE, NONSWAPPABLE */
      FROM
        DUMMY
    ) BI,
      M_MEMORY_OBJECTS M
    WHERE
      M.HOST LIKE BI.HOST AND
      TO_VARCHAR(M.PORT) LIKE BI.PORT AND
      M.TYPE LIKE BI.OBJECT_TYPE
  )
)
ORDER BY
  MAP(ORDER_BY, 'TOTAL', SIZE_GB, 'SWAPPABLE', SWAPPABLE_GB, 'NONSWAPPABLE', SIZE_GB - SWAPPABLE_GB, 'COUNT', NUM_OBJECTS) DESC
