SELECT DISTINCT

/* 

[NAME]

- HANA_Tables_RowStore_TablesWithMultipleContainers_1.00.90+

[DESCRIPTION]

- Determination of row store tables with multiple containers

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_RS_TABLES.CONTAINER_COUNT not available before SAP HANA 1.0 SPS 09

[VALID FOR]

- Revisions:              >= 1.00.90

[SQL COMMAND VERSION]

- 2015/12/08:  1.0 (initial version)

[INVOLVED TABLES]

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

- SERVICE_NAME

  Service name

  'indexserver'   --> Specific service indexserver
  '%server'       --> All services ending with 'server'
  '%'             --> All services  

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

- GENERATE_SEMICOLON

  Controls the generation of semicolons at the end of the generated SQL statements

  'X'             --> Semicolon is generated
  ' '             --> No semicolon is generated

[OUTPUT PARAMETERS]

- HOST:          Host name
- PORT:          Port
- SERVICE:       Service name
- SCHEMA_NAME:   Schema name
- TABLE_NAME:    Table name
- RECORD:        Number of records in table
- ALLOC_MB:      Memory allocated by table (MB)
- USED_MB:       Memory used by table (MB)
- CONTAINERS:    Number of table containers
- COMMAND:       Table reorganization command to merge containers into a single container

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------
|HOST   |PORT |SCHEMA_NAME|TABLE_NAME     |RECORDS   |ALLOC_MB|USED_MB|CONTAINERS|COMMAND                                                   |
---------------------------------------------------------------------------------------------------------------------------------------------
|saphana|30003|SAPSR3     |D010INC        |  17933895| 1325.99|1284.01|         2|ALTER TABLE "SAPSR3"."D010INC" RECLAIM DATA SPACE         |
|saphana|30003|SAPSR3     |D010TAB        |  47299151| 2894.74|2705.96|         2|ALTER TABLE "SAPSR3"."D010TAB" RECLAIM DATA SPACE         |
|saphana|30003|SAPSR3     |DD12L          |     25729|    5.80|   3.09|         3|ALTER TABLE "SAPSR3"."DD12L" RECLAIM DATA SPACE           |
|saphana|30003|SAPSR3     |DD25L          |     64762|   22.57|   7.03|         3|ALTER TABLE "SAPSR3"."DD25L" RECLAIM DATA SPACE           |
|saphana|30003|SAPSR3     |DD27S          |    646800|   96.34|  76.78|         2|ALTER TABLE "SAPSR3"."DD27S" RECLAIM DATA SPACE           |
|saphana|30003|SAPSR3     |DD28S          |     95295|   13.36|   9.38|         2|ALTER TABLE "SAPSR3"."DD28S" RECLAIM DATA SPACE           |
|saphana|30003|SAPSR3     |DD30L          |     24508|    4.80|   2.44|         2|ALTER TABLE "SAPSR3"."DD30L" RECLAIM DATA SPACE           |
|saphana|30003|SAPSR3     |ICFALIAS       |        32|    0.03|   0.01|         2|ALTER TABLE "SAPSR3"."ICFALIAS" RECLAIM DATA SPACE        |
|saphana|30003|SAPSR3     |NRIVSHADOW     |        46|    0.03|   0.00|         2|ALTER TABLE "SAPSR3"."NRIVSHADOW" RECLAIM DATA SPACE      |
|saphana|30003|SAPSR3     |RSBBSCUBE      |        62|    0.01|   0.00|         2|ALTER TABLE "SAPSR3"."RSBBSCUBE" RECLAIM DATA SPACE       |
|saphana|30003|SAPSR3     |RSBBSQUERY     |       250|    0.05|   0.03|         2|ALTER TABLE "SAPSR3"."RSBBSQUERY" RECLAIM DATA SPACE      |
|saphana|30003|SAPSR3     |RZLLITAB       |         6|    0.03|   0.00|         2|ALTER TABLE "SAPSR3"."RZLLITAB" RECLAIM DATA SPACE        |
|saphana|30003|SAPSR3     |SEOCOMPODF     |   2280928|  593.96| 519.13|         2|ALTER TABLE "SAPSR3"."SEOCOMPODF" RECLAIM DATA SPACE      |
---------------------------------------------------------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  SERVICE_NAME SERVICE,
  SCHEMA_NAME,
  TABLE_NAME,
  LPAD(RECORDS, 10) RECORDS,
  LPAD(TO_DECIMAL(ALLOC_BYTE / 1024 / 1024, 10, 2), 10) ALLOC_MB,
  LPAD(TO_DECIMAL(USED_BYTE / 1024 / 1024, 10, 2), 10) USED_MB,
  LPAD(CONTAINERS, 10) CONTAINERS,
  'ALTER TABLE "' || SCHEMA_NAME || '"."' || TABLE_NAME || '" RECLAIM DATA SPACE' ||
    MAP(GENERATE_SEMICOLON, 'X', ';', '') COMMAND
FROM
( SELECT
    T.HOST,
    T.PORT,
    S.SERVICE_NAME,
    T.SCHEMA_NAME,
    T.TABLE_NAME,
    T.RECORD_COUNT RECORDS,
    T.ALLOCATED_FIXED_PART_SIZE + T.ALLOCATED_VARIABLE_PART_SIZE ALLOC_BYTE,
    T.USED_FIXED_PART_SIZE + T.USED_VARIABLE_PART_SIZE USED_BYTE,
    T.CONTAINER_COUNT CONTAINERS,
    BI.GENERATE_SEMICOLON
  FROM
  ( SELECT                 /* Modification section */
      '%' HOST,
      '%' PORT,
      '%' SERVICE_NAME,
      '%' SCHEMA_NAME,
      '%' TABLE_NAME,
      'X' GENERATE_SEMICOLON
    FROM
      DUMMY
  ) BI,
    M_SERVICES S,
    M_RS_TABLES T
  WHERE
    S.HOST LIKE BI.HOST AND
    TO_VARCHAR(S.PORT) LIKE BI.PORT AND
    S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
    T.HOST = S.HOST AND
    T.PORT = S.PORT AND
    T.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    T.TABLE_NAME LIKE BI.TABLE_NAME AND
    T.CONTAINER_COUNT > 1
)
ORDER BY
  HOST,
  PORT,
  SCHEMA_NAME,
  TABLE_NAME