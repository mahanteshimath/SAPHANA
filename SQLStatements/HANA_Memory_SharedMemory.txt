SELECT
/* 

[NAME]

- HANA_Memory_SharedMemory

[DESCRIPTION]

- Used and allocated shared memory per host and service

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/12/13:  1.0 (initial version)
- 2020/08/17:  1.1 (transition from M_SERVICE_MEMORY to more granular M_SHARED_MEMORY)

[INVOLVED TABLES]

- M_SERVICE_MEMORY
- M_SHARED_MEMORY

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

  Shared memory category

  'TOPOLOGY'      --> Display information for TOPOLOGY shared memory
  '%'             --> No restriction related to shared memory category
  
[OUTPUT PARAMETERS]

- HOST:         Host name
- PORT:         Port
- CATEGORY:     Shared memory category
- SHM_ALLOC_MB: Allocated shared memory (MB)
- SHM_USED_MB:  Used shared memory (MB)
- SHM_USED_PCT: Percentage of allocated memory used

[EXAMPLE OUTPUT]

---------------------------------------------------------------------
|HOST  |PORT |SERVICE_NAME    |SHM_ALLOC_GB|SHM_USED_GB|SHM_USED_PCT|
---------------------------------------------------------------------
|hana01|31001|nameserver      |        0.13|       0.02|       18.64|
|hana01|31002|preprocessor    |        0.00|       0.00|        0.00|
|hana01|31003|indexserver     |       24.50|      11.21|       45.76|
|hana01|31005|statisticsserver|        0.14|       0.03|       22.98|
|hana01|31006|webdispatcher   |        0.00|       0.00|        0.00|
|hana01|31007|xsengine        |        0.14|       0.03|       22.96|
|hana01|31010|compileserver   |        0.00|       0.00|        0.00|
---------------------------------------------------------------------

*/

  M.HOST,
  LPAD(M.PORT, 5) PORT,
  M.CATEGORY,
  LPAD(TO_DECIMAL(M.ALLOCATED_SIZE / 1024 / 1024, 10, 2), 12) SHM_ALLOC_MB,
  LPAD(TO_DECIMAL(M.USED_SIZE / 1024 / 1024, 10, 2), 11) SHM_USED_MB,
  LPAD(TO_DECIMAL(MAP(M.ALLOCATED_SIZE, 0, 0, M.USED_SIZE / M.ALLOCATED_SIZE * 100), 10, 2), 12) SHM_USED_PCT
FROM
( SELECT                /* Modification section */
    '%' HOST,
    '%' PORT,
    '%' CATEGORY
  FROM
    DUMMY
) BI,
  M_SHARED_MEMORY M
WHERE
  M.HOST LIKE BI.HOST AND
  TO_VARCHAR(M.PORT) LIKE BI.PORT AND
  M.CATEGORY LIKE BI.CATEGORY
ORDER BY
  M.HOST,
  M.PORT,
  M.CATEGORY