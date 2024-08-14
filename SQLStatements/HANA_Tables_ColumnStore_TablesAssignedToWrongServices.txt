SELECT DISTINCT

/* 

[NAME]

HANA_Tables_ColumnStore_TablesAssignedToWrongServices

[DESCRIPTION]

- Displays tables assigned to wrong services

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/05/20:  1.0 (initial version)

[INVOLVED TABLES]

- M_CS_TABLES
- M_SERVICES

[INPUT PARAMETERS]

- HOST

  Host name

  'saphana01'     --> Specific host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- TABLE_NAME:           

  Table name or pattern

  'T000'          --> Specific table T000
  'T%'            --> All tables starting with 'T'
  '%'             --> All tables

- OBJECT_LEVEL

  Controls display of partitions

  'PARTITION'     --> Result is shown on partition level
  'TABLE'         --> Result is shown on table level

[OUTPUT PARAMETERS]

- HOST:         Host name
- PORT:         Port
- SERVICE_NAME: Service name
- SCHEMA_NAME:  Schema name
- TABLE_NAME:   Table name

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------
|HOST        |PORT |SERVICE_NAME|SCHEMA_NAME    |TABLE_NAME                             |
-----------------------------------------------------------------------------------------
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|GLOBAL_COLUMN_TABLES_SIZE              |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|GLOBAL_CPU_STATISTICS                  |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|GLOBAL_DEC_EXTRACTOR_STATUS            |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|GLOBAL_DISKS                           |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|GLOBAL_INTERNAL_DISKFULL_EVENTS        |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|GLOBAL_INTERNAL_EVENTS                 |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|GLOBAL_MEMORY_STATISTICS               |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|GLOBAL_PERSISTENCE_STATISTICS          |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|GLOBAL_ROWSTORE_TABLES_SIZE            |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|GLOBAL_TABLES_SIZE                     |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|GLOBAL_TABLE_PERSISTENCE_STATISTICS    |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|HOST_BLOCKED_TRANSACTIONS              |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|HOST_COLUMN_TABLES_PART_SIZE           |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|HOST_CONNECTIONS                       |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|HOST_CONNECTION_STATISTICS             |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|HOST_CS_UNLOADS                        |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|HOST_DATA_VOLUME_PAGE_STATISTICS       |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|HOST_DATA_VOLUME_SUPERBLOCK_STATISTICS |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|HOST_DELTA_MERGE_STATISTICS            |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|HOST_HEAP_ALLOCATORS                   |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|HOST_LONG_IDLE_CURSOR                  |
|vhbshk0cdb01|30404|scriptserver|_SYS_STATISTICS|HOST_LONG_RUNNING_STATEMENTS           |
-----------------------------------------------------------------------------------------

*/

  T.HOST,
  LPAD(T.PORT, 5) PORT,
  S.SERVICE_NAME,
  T.SCHEMA_NAME,
  T.TABLE_NAME || MAP(BI.OBJECT_LEVEL, 'TABLE', '', MAP(T.PART_ID, -1, '', 0, '', CHAR(32) || '(' || T.PART_ID || ')')) TABLE_NAME
FROM
( SELECT                     /* Modification section */
    '%' HOST,
    '%' SCHEMA_NAME,
    '%' TABLE_NAME,
    'TABLE' OBJECT_LEVEL
  FROM
    DUMMY
) BI,
  M_CS_TABLES T,
  M_SERVICES S
WHERE
  T.HOST LIKE BI.HOST AND
  T.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  T.TABLE_NAME LIKE BI.TABLE_NAME AND
  T.PORT = S.PORT AND
  S.SERVICE_NAME NOT IN ( 'indexserver', 'statisticsserver' )
ORDER BY
  1, 2, 3, 4, 5
  
  