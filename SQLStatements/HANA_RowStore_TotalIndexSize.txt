SELECT
/* 

[NAME]

- HANA_RowStore_TotalIndexSize

[DESCRIPTION]

- Row store index size comparison (actual indexes vs. heap allocator Pool/RowEngine/CpbTree)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/01/13:  1.0 (initial version)
- 2016/12/12:  1.1 (Pool/RowStoreTables/CpbTree included)

[INVOLVED TABLES]

- M_RS_INDEXES
- M_HEAP_MEMORY

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

- SERVICE_NAME

  Service name

  'indexserver'   --> Specific service indexserver
  '%server'       --> All services ending with 'server'
  '%'             --> All services  

- MIN_HEAP_SIZE_GB

  Minimum size of Pool/RowEngine/CpbTree allocator (GB)

  10              --> Restrict output to row stores with Pool/RowEngine/CpbTree allocator of at least 10 GB
  -1              --> No restriction related to Pool/RowEngine/CpbTree allocator size
  
[OUTPUT PARAMETERS]

- HOST:                   Host name
- PORT:                   Port
- SERVICE:                Service name
- INDEX_SIZE_GB:          Size of all row store indexes
- INDEX_SIZE_DESCRIPTION: Description of index size calculation
- HEAP_SIZE_GB:           Size of heap allocator Pool/RowEngine/CpbTree (GB)
- HEAP_SIZE_DESCRIPTION:  Description of heap size calculation

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------
|HOST         |PORT |INDEX_SIZE_GB|INDEX_SIZE_DESCRIPTION       |HEAP_SIZE_GB|HEAP_SIZE_DESCRIPTION         |
-------------------------------------------------------------------------------------------------------------
|dtcgembwdbp01|30003|        50.81|Size of all row store indexes|      301.15|Size of Pool/RowEngine/CpbTree|
-------------------------------------------------------------------------------------------------------------

*/

  I.HOST,
  LPAD(I.PORT, 5) PORT,
  S.SERVICE_NAME SERVICE,
  LPAD(TO_DECIMAL(I.INDEX_SIZE_GB, 10, 2), 13) INDEX_SIZE_GB,
  'Size of all row store indexes' INDEX_SIZE_DESCRIPTION,
  LPAD(TO_DECIMAL(H.HEAP_SIZE_GB, 10, 2), 12) HEAP_SIZE_GB,
  'Size of Pool/RowEngine/CpbTree' HEAP_SIZE_DESCRIPTION
FROM
( SELECT                   /* Modification section */
    '%' HOST,
    '%' PORT,
    '%' SERVICE_NAME,
    10 MIN_HEAP_SIZE_GB
  FROM
    DUMMY
) BI,
  M_SERVICES S,
( SELECT
    HOST,
    PORT,
    SUM(INDEX_SIZE) / 1024 / 1024 / 1024 INDEX_SIZE_GB
  FROM
    M_RS_INDEXES
  GROUP BY
    HOST,
    PORT
) I,
( SELECT
    HOST,
    PORT,
    SUM(EXCLUSIVE_SIZE_IN_USE) / 1024 / 1024 / 1024 HEAP_SIZE_GB
  FROM
    M_HEAP_MEMORY
  WHERE
    CATEGORY IN ( 'Pool/RowEngine/CpbTree', 'Pool/RowStoreTables/CpbTree' )
  GROUP BY
    HOST,
    PORT
) H
WHERE
  S.HOST LIKE BI.HOST AND
  TO_VARCHAR(S.PORT) LIKE BI.PORT AND
  S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
  I.HOST = S.HOST AND
  I.PORT = S.PORT AND
  H.HOST = I.HOST AND
  H.PORT = I.PORT AND
  ( BI.MIN_HEAP_SIZE_GB = -1 OR I.INDEX_SIZE_GB >= BI.MIN_HEAP_SIZE_GB )
ORDER BY
  I.HOST,
  I.PORT
