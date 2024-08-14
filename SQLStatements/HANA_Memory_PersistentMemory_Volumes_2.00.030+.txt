SELECT

/* 

[NAME]

- HANA_Memory_PersistentMemory_Volumes_2.00.030+

[DESCRIPTION]

- Persistent memory volumes

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Persistent memory and underlying monitoring views available with SAP HANA >= 2.00.030
- See SAP Note 2700084 for more details regarding persistent memory and fast restart option
- The function HEXSTR2INT doesn't exist in the SAP HANA standard, so you need to create it individually,
  e.g. based on the definition available here:

  https://stackoverflow.com/questions/43340665/hexadecimal-to-decimal-through-system-defined-function

- Otherwise you will receive the following error:

  [328]: invalid name of function or procedure: HEXSTR2INT

[VALID FOR]

- Revisions:              >= 2.00.030

[SQL COMMAND VERSION]

- 2020/04/28:  1.0 (initial version)
- 2020/05/15:  1.1 (SCHEMA_NAME, TABLE_NAME, COLUMN_NAME and OBJECT_LEVEL added)

[INVOLVED TABLES]

- M_CS_COLUMNS_PERSISTENCE
- M_PERSISTENT_MEMORY_VOLUMES
- M_PERSISTENT_MEMORY_VOLUME_DATA_FILES
- M_TABLE_VIRTUAL_FILES

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

- VOLUME_ID

  Disk volume ID

  3               --> Volume 3
  -1              --> No restriction related to volume

- PATH

  Path on disk

  '/hdb/ERP/backup/log/' --> Path /hdb/HAL/backup/log/
  '%mnt00001%'           --> Paths containing 'mnt00001'
  '%'                    --> No restriction of path

- FILESYSTEM_TYPE

  Type of file system

  'tmpfs'         --> tmpfs file system
  '%'             --> All file systems

- FILE_NAME

  File name

  'alert.trc'     --> File with name alert.trc
  '852%'          --> Files starting with '852'
  '%'             --> All files

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- TABLE_NAME           

  Table name or pattern

  'T000'          --> Specific table T000
  'T%'            --> All tables starting with 'T'
  '%'             --> All tables

- COLUMN_NAME

  Column name

  'MATNR'         --> Column MATNR
  'Z%'            --> Columns starting with "Z"
  '%'             --> No restriction related to columns

- OBJECT_LEVEL

  Controls display of partitions

  'PARTITION'     --> Result is shown on partition level
  'TABLE'         --> Result is shown on table level

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOST, PORT'    --> Aggregation by host and port
  'VOLUME'        --> Aggregation by volume
  'NONE'          --> No aggregation
  
- ORDER_BY

  Sort criteria (available values are provided in comment)

  'FILE_SIZE'     --> Sorting by data file size
  'VOLUME'        --> Sorting by volume

[OUTPUT PARAMETERS]

- HOST:         Host
- PORT:         Port
- V:            Volume ID
- PATH:         Filesystem path
- FS_TYPE:      Filesystem type
- FILES:        Number of persistent memory files
- VOL_TOTAL_GB: Total persistent memory volume size (GB)
- VOL_USED_GB:  used persistent memory volume size (GB)
- SCHEMA_NAME   Schema name
- TABLE_NAME:   Table name
- COLUMN_NAME:  Column name
- FILE_MB:      Persistent memory file size (MB)
- FILE_NAME:    File name

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST       |PORT |V|PATH                                    |FS_TYPE|FILES |VOL_TOTAL_GB|VOL_USED_GB|SCHEMA_NAME    |TABLE_NAME                         |COLUMN_NAME            |FILE_MB   |FILE_NAME                                                        |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|saphananode|30003|3|/hana/tmpfs0/C11/mnt00001/hdb00003.00003|tmpfs  |     1|       23.36|       1.33|_SYS_REPO      |ACTIVE_OBJECT                      |$_SYS_SHADOW_CDATA$    |    488.92|14537-000000fe00000009-00000026-000000dd-00000001_9261.fileblock |
|saphananode|30003|3|/hana/tmpfs0/C11/mnt00001/hdb00003.00003|tmpfs  |     1|       23.36|       1.33|PLAYGROUND     |DATA_MASTER                        |$trexexternalkey$      |     95.42|805-000000fe0000bcf3-00000007-000000d0-00000001_5996.fileblock   |
|saphananode|30003|3|/hana/tmpfs0/C11/mnt00001/hdb00003.00003|tmpfs  |     1|       23.36|       1.33|PLAYGROUND     |DATA_MASTER                        |COL3                   |     20.26|852-000000fe0000bcf3-00000007-000000cc-00000001_5996.fileblock   |
|saphananode|30003|3|/hana/tmpfs0/C11/mnt00001/hdb00003.00003|tmpfs  |     1|       23.36|       1.33|PLAYGROUND     |DATA_MASTER                        |KEY                    |     17.64|804-000000fe0000bcf3-00000007-000000c9-00000001_5996.fileblock   |
|saphananode|30003|3|/hana/tmpfs0/C11/mnt00001/hdb00003.00003|tmpfs  |     1|       23.36|       1.33|_SYS_STATISTICS|HOST_LOAD_HISTORY_SERVICE_BASE     |MEMORY_ALLOCATION_LIMIT|      6.82|21312-000000fe000000f0-00000087-000000ec-00000001_11852.fileblock|
|saphananode|30003|3|/hana/tmpfs0/C11/mnt00001/hdb00003.00003|tmpfs  |     1|       23.36|       1.33|PLAYGROUND     |DATA_MASTER                        |$rowid$                |      6.47|741-000000fe0000bcf3-00000007-00000007-00000001_5996.fileblock   |
|saphananode|30003|3|/hana/tmpfs0/C11/mnt00001/hdb00003.00003|tmpfs  |     1|       23.36|       1.33|_SYS_STATISTICS|HOST_LOAD_HISTORY_SERVICE_BASE     |TIME                   |      5.98|21329-000000fe000000f0-00000087-000000f8-00000001_11852.fileblock|
|saphananode|30003|3|/hana/tmpfs0/C11/mnt00001/hdb00003.00003|tmpfs  |     1|       23.36|       1.33|_SYS_STATISTICS|HOST_LOAD_HISTORY_SERVICE_BASE     |MEMORY_USED            |      5.56|21311-000000fe000000f0-00000087-000000ed-00000001_11852.fileblock|
|saphananode|30003|3|/hana/tmpfs0/C11/mnt00001/hdb00003.00003|tmpfs  |     1|       23.36|       1.33|_SYS_STATISTICS|HOST_SERVICE_THREAD_CALLSTACKS_BASE|SNAPSHOT_ID            |      4.87|21867-000000fe000000f7-0000009a-000000c9-00000001_12046.fileblock|
|saphananode|30003|3|/hana/tmpfs0/C11/mnt00001/hdb00003.00003|tmpfs  |     1|       23.36|       1.33|_SYS_STATISTICS|HOST_LOAD_HISTORY_HOST_BASE        |TIME                   |      4.28|21273-000000fe000000ef-00000085-000000d8-00000001_11852.fileblock|
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  VOLUME_ID V,
  PATH,
  FS_TYPE,
  LPAD(FILES, 6) FILES,
  LPAD(TO_DECIMAL(VOL_TOTAL_GB, 10, 2), 12) VOL_TOTAL_GB,
  LPAD(TO_DECIMAL(VOL_USED_GB, 10, 2), 11) VOL_USED_GB,
  SCHEMA_NAME,
  TABLE_NAME,
  COLUMN_NAME,
  LPAD(TO_DECIMAL(FILE_MB, 10, 2), 10) FILE_MB,
  FILE_NAME
FROM
( SELECT
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST')    != 0 THEN HOST                  ELSE MAP(BI_HOST,      '%', 'any', BI_HOST)                  END HOST,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(PORT)      ELSE MAP(BI_PORT,      '%', 'any', BI_PORT)                  END PORT,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'VOLUME')  != 0 THEN TO_VARCHAR(VOLUME_ID) ELSE MAP(BI_VOLUME_ID,  -1, 'any', TO_VARCHAR(BI_VOLUME_ID)) END VOLUME_ID,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PATH')    != 0 THEN PATH                  ELSE MAP(BI_PATH,      '%', 'any', BI_PATH)                  END PATH,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'FS_TYPE') != 0 THEN FILESYSTEM_TYPE       ELSE MAP(BI_FS_TYPE,   '%', 'any', BI_FS_TYPE)               END FS_TYPE,
    FILE_NAME,
    SCHEMA_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    SUM(FILES) FILES,
    SUM(TOTAL_SIZE) / 1024 / 1024 / 1024 VOL_TOTAL_GB,
    SUM(USED_SIZE) / 1024 / 1024 / 1024 VOL_USED_GB,
    SUM(SIZE) / 1024 / 1024 FILE_MB,
    ORDER_BY
  FROM
  ( SELECT
      V.HOST,
      V.PORT,
      V.VOLUME_ID,
      V.PATH,
      V.FILESYSTEM_TYPE,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'FILE')   != 0 THEN F.FILE_NAME   ELSE MAP(BI.FILE_NAME,   '%', 'any', BI.FILE_NAME)   END FILE_NAME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA') != 0 THEN F.SCHEMA_NAME ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME) END SCHEMA_NAME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')  != 0 THEN F.TABLE_NAME || CASE WHEN BI.OBJECT_LEVEL = 'TABLE' OR 
        F.PART_ID IN ('', '-1', '0') THEN '' ELSE CHAR(32) || '(' || F.PART_ID || ')' END            ELSE MAP(BI.TABLE_NAME,  '%', 'any', BI.TABLE_NAME)  END TABLE_NAME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COLUMN') != 0 THEN F.COLUMN_NAME ELSE MAP(BI.COLUMN_NAME, '%', 'any', BI.COLUMN_NAME) END COLUMN_NAME,
      COUNT(*) FILES,
      MAX(V.TOTAL_SIZE) TOTAL_SIZE,
      MAX(V.USED_SIZE) USED_SIZE,
      SUM(F.SIZE) SIZE,
      BI.HOST BI_HOST,
      BI.PORT BI_PORT,
      BI.VOLUME_ID BI_VOLUME_ID,
      BI.PATH BI_PATH,
      BI.FILESYSTEM_TYPE BI_FS_TYPE,
      BI.AGGREGATE_BY,
      BI.ORDER_BY
    FROM
    ( SELECT                         /* Modification section */
        '%' HOST,
        '%' PORT,
        -1 VOLUME_ID,
        '%' PATH,
        '%' FILESYSTEM_TYPE,
        '%' FILE_NAME,
        '%' SCHEMA_NAME,
        '%' TABLE_NAME,
        '%' COLUMN_NAME,
        'PARTITION' OBJECT_LEVEL,
        'NONE' AGGREGATE_BY,               /* HOST, PORT, VOLUME, PATH, FILE, FS_TYPE, SCHEMA, TABLE, COLUMN or comma separated combinations, NONE for no analysis */
        'FILE_SIZE' ORDER_BY            /* VOL_TOTAL_SIZE, VOL_USED_SIZE, FILE_SIZE, FILES, VOLUME, TABLE */
      FROM
        DUMMY
    ) BI,
      M_PERSISTENT_MEMORY_VOLUMES V,
    ( SELECT
        F.*,
        IFNULL(V.SCHEMA_NAME, '') SCHEMA_NAME,
        IFNULL(V.TABLE_NAME, '') TABLE_NAME,
        MAP(V.PART_ID, NULL, '', TO_VARCHAR(V.PART_ID)) PART_ID,
        IFNULL(C.COLUMN_NAME, '') COLUMN_NAME
      FROM
        M_PERSISTENT_MEMORY_VOLUME_DATA_FILES F LEFT OUTER JOIN
        M_TABLE_VIRTUAL_FILES V ON
          HEXSTR2INT(SUBSTR_BEFORE(SUBSTR_AFTER(F.FILE_NAME, '-'), '-')) = V.CONTAINER_ID AND
          V.HOST = F.HOST AND
          V.PORT = F.PORT LEFT OUTER JOIN
        M_CS_COLUMNS_PERSISTENCE C ON
          C.SCHEMA_NAME = V.SCHEMA_NAME AND
          C.TABLE_NAME = V.TABLE_NAME AND
          C.PART_ID = V.PART_ID AND
          C.COLUMN_ID = HEXSTR2INT(SUBSTR_BEFORE(SUBSTR_AFTER(SUBSTR_AFTER(SUBSTR_AFTER(FILE_NAME, '-'), '-'), '-'), '-'))
    ) F
    WHERE
      V.HOST LIKE BI.HOST AND
      TO_VARCHAR(V.PORT) LIKE BI.PORT AND
      ( BI.VOLUME_ID = -1 OR V.VOLUME_ID = BI.VOLUME_ID ) AND
      V.PATH LIKE BI.PATH AND
      V.FILESYSTEM_TYPE LIKE BI.FILESYSTEM_TYPE AND
      F.FILE_NAME LIKE BI.FILE_NAME AND
      F.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
      F.TABLE_NAME LIKE BI.TABLE_NAME AND
      F.COLUMN_NAME LIKE BI.COLUMN_NAME AND
      F.HOST = V.HOST AND
      F.PORT = V.PORT AND
      F.VOLUME_ID = V.VOLUME_ID AND
      F.NUMA_NODE_INDEX = V.NUMA_NODE_INDEX
    GROUP BY
      V.HOST,
      V.PORT,
      V.VOLUME_ID,
      V.PATH,
      V.FILESYSTEM_TYPE,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'FILE')   != 0 THEN F.FILE_NAME   ELSE MAP(BI.FILE_NAME,   '%', 'any', BI.FILE_NAME)   END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA') != 0 THEN F.SCHEMA_NAME ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME) END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')  != 0 THEN F.TABLE_NAME || CASE WHEN BI.OBJECT_LEVEL = 'TABLE' OR 
        F.PART_ID IN ('', '-1', '0') THEN '' ELSE CHAR(32) || '(' || F.PART_ID || ')' END            ELSE MAP(BI.TABLE_NAME,  '%', 'any', BI.TABLE_NAME)  END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COLUMN') != 0 THEN F.COLUMN_NAME ELSE MAP(BI.COLUMN_NAME, '%', 'any', BI.COLUMN_NAME) END,
      BI.HOST,
      BI.PORT,
      BI.VOLUME_ID,
      BI.PATH,
      BI.FILESYSTEM_TYPE,
      BI.AGGREGATE_BY,
      BI.ORDER_BY
  )
  GROUP BY
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST')    != 0 THEN HOST                  ELSE MAP(BI_HOST,      '%', 'any', BI_HOST)                  END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(PORT)      ELSE MAP(BI_PORT,      '%', 'any', BI_PORT)                  END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'VOLUME')  != 0 THEN TO_VARCHAR(VOLUME_ID) ELSE MAP(BI_VOLUME_ID,  -1, 'any', TO_VARCHAR(BI_VOLUME_ID)) END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PATH')    != 0 THEN PATH                  ELSE MAP(BI_PATH,      '%', 'any', BI_PATH)                  END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'FS_TYPE') != 0 THEN FILESYSTEM_TYPE       ELSE MAP(BI_FS_TYPE,   '%', 'any', BI_FS_TYPE)               END,
    FILE_NAME,
    SCHEMA_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'VOL_TOTAL_SIZE', VOL_TOTAL_GB, 'VOL_USED_SIZE', VOL_USED_GB, 'FILE_SIZE', FILE_MB, 'FILES', FILES) DESC,
  MAP(ORDER_BY, 'TABLE', SCHEMA_NAME || TABLE_NAME),
  VOLUME_ID,
  PATH,
  FILE_NAME
  