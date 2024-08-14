SELECT
/* 

[NAME]

- HANA_LOBs_HybridLOBActivation_CommandGenerator

[DESCRIPTION]

- Generates ALTER TABLE commands to activate hybrid LOBs

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Fails in SAP HANA Cloud (SHC) environments because memory LOBs are no longer available:

  invalid column name: TC.CS_DATA_TYPE_NAME

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/03/21:  1.0 (initial version)
- 2017/06/08:  1.1 (EXCLUDE_SYS_TABLES included)

[INVOLVED TABLES]

- TABLE_COLUMNS
- M_TABLES

[INPUT PARAMETERS]

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

- STORE

  Restriction to row and / or column store

  'ROW'           --> Only row store information
  'COLUMN'        --> Only column store information
  '%'             --> No store restriction

- MIN_TABLE_SIZE_MB

  Minimum table size in MB

  10              --> Minimum table size of 10 MB
  -1              --> No minimum table size limitation

- IGNORE_CORRECT_LOBS

  Controls the display of LOB columns that are already hybrid with proper memory threshold

  'X'             --> Correctly configured LOBs are not displayed
  ' '             --> All LOBs are displayed

- EXCLUDE_SYS_TABLES

  Possibility to ignore tables related to SYS schema

  'X'             --> Ignore tables related to SYS schema
  ' '             --> Consider all tables

- MEMORY_THRESHOLD

  Hybrid LOB memory threshold (in byte), values larger than threshold are not loaded to memory

  1000            --> Threshold of 1000 byte
  4000            --> Threshold of 4000 byte

- GENERATE_SEMICOLON

  Controls the generation of semicolons at the end of the generated SQL statements

  'X'             --> Semicolon is generated
  ' '             --> No semicolon is generated

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'SIZE'          --> Sorting by size 
  'TABLE'         --> Sorting by table name

[OUTPUT PARAMETERS]

- SCHEMA_NAME     --> Schema name
- TABLE_NAME      --> Table name
- STORE           --> Row store / column store
- COLUMN_NAME     --> Column name
- LOB_TYPE        --> Type of LOB (memory threshold in brackets in case of hybrid LOBs)
- SIZE_MB         --> Table size (in MB)
- COMMAND         --> Hybrid LOB activation command

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME|TABLE_NAME      |STORE |COLUMN_NAME |LOB_TYPE|SIZE_MB   |COMMAND                                                                                   |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
|SAPSR3     |RSWR_DATA       |ROW   |DATA        |MEMORY  |  37772.94|ALTER TABLE "SAPSR3"."RSWR_DATA" ALTER ("DATA" NCLOB MEMORY THRESHOLD 1000)               |
|SAPSR3     |RSWR_DATA       |ROW   |XDATA       |MEMORY  |  37772.94|ALTER TABLE "SAPSR3"."RSWR_DATA" ALTER ("XDATA" BLOB MEMORY THRESHOLD 1000)               |
|SAPSR3     |REPOSRC         |ROW   |DATA        |MEMORY  |   3509.63|ALTER TABLE "SAPSR3"."REPOSRC" ALTER ("DATA" BLOB MEMORY THRESHOLD 1000)                  |
|SAPSR3     |REPOLOAD        |ROW   |LDATA       |MEMORY  |   3294.92|ALTER TABLE "SAPSR3"."REPOLOAD" ALTER ("LDATA" BLOB MEMORY THRESHOLD 1000)                |
|SAPSR3     |REPOLOAD        |ROW   |QDATA       |MEMORY  |   3294.92|ALTER TABLE "SAPSR3"."REPOLOAD" ALTER ("QDATA" BLOB MEMORY THRESHOLD 1000)                |
|SAPSR3     |DYNPLOAD        |ROW   |DATA        |MEMORY  |   1858.93|ALTER TABLE "SAPSR3"."DYNPLOAD" ALTER ("DATA" BLOB MEMORY THRESHOLD 1000)                 |
|SAPSR3     |DBTABLOG        |COLUMN|LOGDATA     |MEMORY  |   1343.47|ALTER TABLE "SAPSR3"."DBTABLOG" ALTER ("LOGDATA" BLOB MEMORY THRESHOLD 1000)              |
|SAPSR3     |RSOTLOGOHISTORY |ROW   |OBJDATA     |MEMORY  |    741.40|ALTER TABLE "SAPSR3"."RSOTLOGOHISTORY" ALTER ("OBJDATA" BLOB MEMORY THRESHOLD 1000)       |
|SAPSR3     |SOFFCONT1       |COLUMN|CLUSTD      |MEMORY  |    670.90|ALTER TABLE "SAPSR3"."SOFFCONT1" ALTER ("CLUSTD" BLOB MEMORY THRESHOLD 1000)              |
|SAPSR3     |DYNPSOURCE      |ROW   |EXTENSIONS  |MEMORY  |    534.37|ALTER TABLE "SAPSR3"."DYNPSOURCE" ALTER ("EXTENSIONS" BLOB MEMORY THRESHOLD 1000)         |
|SAPSR3     |DYNPSOURCE      |ROW   |FIELDINFO   |MEMORY  |    534.37|ALTER TABLE "SAPSR3"."DYNPSOURCE" ALTER ("FIELDINFO" BLOB MEMORY THRESHOLD 1000)          |
|SAPSR3     |DYNPSOURCE      |ROW   |LOGICINFO   |MEMORY  |    534.37|ALTER TABLE "SAPSR3"."DYNPSOURCE" ALTER ("LOGICINFO" BLOB MEMORY THRESHOLD 1000)          |
|SAPSR3     |REPOTEXT        |ROW   |DATA        |MEMORY  |    515.30|ALTER TABLE "SAPSR3"."REPOTEXT" ALTER ("DATA" BLOB MEMORY THRESHOLD 1000)                 |
|SAPSR3     |DDNTF           |ROW   |FIELDS      |MEMORY  |    503.68|ALTER TABLE "SAPSR3"."DDNTF" ALTER ("FIELDS" BLOB MEMORY THRESHOLD 1000)                  |
|SAPSR3     |DDNTF_CONV_UC   |ROW   |FIELDS      |MEMORY  |    236.82|ALTER TABLE "SAPSR3"."DDNTF_CONV_UC" ALTER ("FIELDS" BLOB MEMORY THRESHOLD 1000)          |
|SAPSR3     |SEOCOMPODF      |ROW   |TYPESRC     |MEMORY  |    181.84|ALTER TABLE "SAPSR3"."SEOCOMPODF" ALTER ("TYPESRC" NCLOB MEMORY THRESHOLD 1000)           |
|SAPSR3     |RSR_CACHE_DATA_B|ROW   |DATA_XSTRING|MEMORY  |    172.14|ALTER TABLE "SAPSR3"."RSR_CACHE_DATA_B" ALTER ("DATA_XSTRING" BLOB MEMORY THRESHOLD 1000) |
|SAPSR3     |TST03           |ROW   |DCONTENT    |MEMORY  |    164.42|ALTER TABLE "SAPSR3"."TST03" ALTER ("DCONTENT" BLOB MEMORY THRESHOLD 1000)                |
|SAPSR3     |RSBKCMDH        |ROW   |TPL_INSTANCE|MEMORY  |    150.83|ALTER TABLE "SAPSR3"."RSBKCMDH" ALTER ("TPL_INSTANCE" BLOB MEMORY THRESHOLD 1000)         |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  T.SCHEMA_NAME,
  T.TABLE_NAME,
  T.TABLE_TYPE STORE,
  TC.COLUMN_NAME,
  CASE TC.CS_DATA_TYPE_NAME
    WHEN 'LOB' THEN 'HYBRID (' || TC.MEMORY_THRESHOLD || ')'
    WHEN 'ST_MEMORY_LOB' THEN 'MEMORY'
    ELSE TC.CS_DATA_TYPE_NAME
  END LOB_TYPE,
  LPAD(TO_DECIMAL(TABLE_SIZE / 1024 / 1024, 10, 2), 10) SIZE_MB,
  'ALTER TABLE "' || T.SCHEMA_NAME || '"."' || T.TABLE_NAME || '" ALTER ("' || TC.COLUMN_NAME || '" ' || DATA_TYPE_NAME || ' MEMORY THRESHOLD ' || 
    BI.MEMORY_THRESHOLD || ')' || MAP(BI.GENERATE_SEMICOLON, 'X', ';', '') COMMAND
FROM
( SELECT                           /* Modification section */
    '%' SCHEMA_NAME,
    '%' TABLE_NAME,
    '%' STORE,               /* ROW, COLUMN, % */
    100 MIN_TABLE_SIZE_MB,
    'X' IGNORE_CORRECT_LOBS,
    'X' EXCLUDE_SYS_TABLES,
    1000 MEMORY_THRESHOLD,
    'X' GENERATE_SEMICOLON,
    'SIZE' ORDER_BY           /* SIZE, TABLE */
  FROM
    DUMMY
) BI,
  TABLE_COLUMNS TC,
  M_TABLES T
WHERE
  TC.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  TC.TABLE_NAME LIKE BI.TABLE_NAME AND
  TC.SCHEMA_NAME = T.SCHEMA_NAME AND
  TC.TABLE_NAME = T.TABLE_NAME AND
  TC.DATA_TYPE_NAME IN ('BLOB', 'CLOB', 'NCLOB', 'TEXT') AND
  ( BI.EXCLUDE_SYS_TABLES = ' ' OR TC.SCHEMA_NAME != 'SYS' ) AND
  ( BI.MIN_TABLE_SIZE_MB = -1 OR T.TABLE_SIZE / 1024 / 1024 >= BI.MIN_TABLE_SIZE_MB ) AND
  T.TABLE_TYPE LIKE BI.STORE AND
  ( BI.IGNORE_CORRECT_LOBS = ' ' OR TC.CS_DATA_TYPE_NAME != 'LOB' OR TC.MEMORY_THRESHOLD != BI.MEMORY_THRESHOLD )
ORDER BY
  MAP(BI.ORDER_BY, 'SIZE', TABLE_SIZE, 1) DESC,
  T.SCHEMA_NAME,
  T.TABLE_NAME,
  TC.COLUMN_NAME
