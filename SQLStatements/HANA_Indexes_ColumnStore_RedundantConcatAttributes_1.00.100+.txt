SELECT
/* 

[NAME]

- HANA_Indexes_ColumnStore_RedundantConcatAttributes_1.00.100+

[DESCRIPTION]

- Determine concat attributes / index that exist twice on the same columns (with the same order)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- ORDER BY clause for STRING_AGG only available as of Rev. 100
- In specific scenarios it can be that two identical concat attributes exist, e.g.:

  CREATE COLUMN TABLE AAA (X INT, Y INT)
  ALTER TABLE AAA WITH PARAMETERS ('CONCAT_ATTRIBUTE'=('$X$Y$', 'X', 'Y'))
  ALTER TABLE AAA ADD PRIMARY KEY (X, Y)

  -> Identical concat attributes for both $trexexternalkey$ and $X$Y$ exist

[VALID FOR]

- Revisions:              >= 1.00.100

[SQL COMMAND VERSION]

- 2016/10/11:  1.0 (initial version)

[INVOLVED TABLES]

- M_CS_ALL_COLUMNS
- INDEX_COLUMNS

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
 
- MIN_SIZE_MB

  Minimum size in MB

  1024            --> Minimum size of 1024 MB
  -1              --> No minimum size limitation

- GENERATE_SEMICOLON

  Controls the generation of semicolons at the end of the generated SQL statements

  'X'             --> Semicolon is generated
  ' '             --> No semicolon is generated

[OUTPUT PARAMETERS]

- SCHEMA_NAME:    Schema name
- TABLE_NAME:     Table name
- INDEX_NAME:     Index name
- SIZE_GB:        Size of concat attribute
- COLUMN_LIST:    Column list of concat attribute
- ATTRIBUTE_TYPE: Internal concat attribute type
- CONSTRAINT:     Constraint type
- DROP_COMMAND:   Command for dropping the redundant CONCAT attribute

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME|TABLE_NAME      |INDEX_NAME                   |SIZE_GB   |COLUMN_LIST                                                                            |ATTRIBUTE_TYPE  |CONSTRAINT |DROP_COMMAND                                                                                                                                                                |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SAPSR3     |/BI0/SCO_ITEM_NO|_SYS_TREE_CS_#10996756_#0_#P0|     22.91|$CO_DOC_NO$CO_ITEM_NO$                                                                 |CONCAT_ATTRIBUTE|PRIMARY KEY|ALTER TABLE "SAPSR3"."/BI0/SCO_ITEM_NO" WITH PARAMETERS ('DELETE_CONCAT_ATTRIBUTE'='$CO_DOC_NO$CO_ITEM_NO$')                                                                |
|SAPSR3     |/BIC/SYRDF_COTX |_SYS_TREE_CS_#10741173_#0_#P0|     13.17|$CO_AREA$CO_DOC_NO$/BIC/YRDF_COTX$                                                     |CONCAT_ATTRIBUTE|PRIMARY KEY|ALTER TABLE "SAPSR3"."/BIC/SYRDF_COTX" WITH PARAMETERS ('DELETE_CONCAT_ATTRIBUTE'='$CO_AREA$CO_DOC_NO$/BIC/YRDF_COTX$')                                                     |
|SAPSR3     |/BIC/SYRELDATUM |_SYS_TREE_CS_#10975820_#0_#P0|      4.86|$COMP_CODE$S_ORD_ITEM$SCHED_LINE$DELIV_NUMB$DELIV_ITEM$/BIC/YRELDATUM$                 |CONCAT_ATTRIBUTE|PRIMARY KEY|ALTER TABLE "SAPSR3"."/BIC/SYRELDATUM" WITH PARAMETERS ('DELETE_CONCAT_ATTRIBUTE'='$COMP_CODE$S_ORD_ITEM$SCHED_LINE$DELIV_NUMB$DELIV_ITEM$/BIC/YRELDATUM$')                 |
|SAPSR3     |/BIC/SYRFCSHDAT |_SYS_TREE_CS_#10802085_#0_#P0|      4.07|$/BIC/YRFCHDNDA$/BIC/YRDBCCLOC$/BIC/YRFCSHDAT$                                         |CONCAT_ATTRIBUTE|PRIMARY KEY|ALTER TABLE "SAPSR3"."/BIC/SYRFCSHDAT" WITH PARAMETERS ('DELETE_CONCAT_ATTRIBUTE'='$/BIC/YRFCHDNDA$/BIC/YRDBCCLOC$/BIC/YRFCSHDAT$')                                         |
|SAPSR3     |/BIC/SYRDJZUONR |_SYS_TREE_CS_#10957001_#0_#P0|      3.30|$AC_DOC_NO$ITEM_NUM$FISCYEAR$FISCVARNT$/BIC/YRDJZUONR$                                 |CONCAT_ATTRIBUTE|PRIMARY KEY|ALTER TABLE "SAPSR3"."/BIC/SYRDJZUONR" WITH PARAMETERS ('DELETE_CONCAT_ATTRIBUTE'='$AC_DOC_NO$ITEM_NUM$FISCYEAR$FISCVARNT$/BIC/YRDJZUONR$')                                 |
|SAPSR3     |/BIC/SYRDJSGTXT |_SYS_TREE_CS_#11064182_#0_#P0|      3.27|$AC_DOC_NO$ITEM_NUM$FISCYEAR$FISCVARNT$/BIC/YRDJSGTXT$                                 |CONCAT_ATTRIBUTE|PRIMARY KEY|ALTER TABLE "SAPSR3"."/BIC/SYRDJSGTXT" WITH PARAMETERS ('DELETE_CONCAT_ATTRIBUTE'='$AC_DOC_NO$ITEM_NUM$FISCYEAR$FISCVARNT$/BIC/YRDJSGTXT$')                                 |
|SAPSR3     |/BIC/SYRFCDNITM |_SYS_TREE_CS_#11018283_#0_#P0|      2.22|$/BIC/YRDBCCLOC$/BIC/YRFCDNITM$                                                        |CONCAT_ATTRIBUTE|PRIMARY KEY|ALTER TABLE "SAPSR3"."/BIC/SYRFCDNITM" WITH PARAMETERS ('DELETE_CONCAT_ATTRIBUTE'='$/BIC/YRDBCCLOC$/BIC/YRFCDNITM$')                                                        |
|SAPSR3     |/BIC/SYRDBPMWE2 |_SYS_TREE_CS_#11023357_#0_#P0|      2.22|$/BIC/YRDBP_PVZ$SHIP_TO$MATL_TYPE$MATERIAL$/BIC/YRDBMDAT1$/BIC/YRDBPMWE2$              |CONCAT_ATTRIBUTE|PRIMARY KEY|ALTER TABLE "SAPSR3"."/BIC/SYRDBPMWE2" WITH PARAMETERS ('DELETE_CONCAT_ATTRIBUTE'='$/BIC/YRDBP_PVZ$SHIP_TO$MATL_TYPE$MATERIAL$/BIC/YRDBMDAT1$/BIC/YRDBPMWE2$')              |
|SAPSR3     |/BIC/SYRDBP_MA2 |_SYS_TREE_CS_#10996779_#0_#P0|      2.16|$/BIC/YRDBP_PVZ$CUSTOMER$/BIC/YRDBMUG4$MATL_TYPE$MATERIAL$/BIC/YRDBP_SB$/BIC/YRDBP_MA2$|CONCAT_ATTRIBUTE|PRIMARY KEY|ALTER TABLE "SAPSR3"."/BIC/SYRDBP_MA2" WITH PARAMETERS ('DELETE_CONCAT_ATTRIBUTE'='$/BIC/YRDBP_PVZ$CUSTOMER$/BIC/YRDBMUG4$MATL_TYPE$MATERIAL$/BIC/YRDBP_SB$/BIC/YRDBP_MA2$')|
|SAPSR3     |/BIC/SYRDJBKTXT |_SYS_TREE_CS_#11060146_#0_#P0|      2.05|$AC_DOC_NO$ITEM_NUM$FISCYEAR$FISCVARNT$/BIC/YRDJBKTXT$                                 |CONCAT_ATTRIBUTE|PRIMARY KEY|ALTER TABLE "SAPSR3"."/BIC/SYRDJBKTXT" WITH PARAMETERS ('DELETE_CONCAT_ATTRIBUTE'='$AC_DOC_NO$ITEM_NUM$FISCYEAR$FISCVARNT$/BIC/YRDJBKTXT$')                                 |
|SAPSR3     |/BIC/SYRFCDATUM |_SYS_TREE_CS_#10972594_#0_#P0|      1.98|$/BIC/YRDBCCLOC$DOC_NUMBER$S_ORD_ITEM$SCHED_LINE$DELIV_ITEM$/BIC/YRFCDATUM$            |CONCAT_ATTRIBUTE|PRIMARY KEY|ALTER TABLE "SAPSR3"."/BIC/SYRFCDATUM" WITH PARAMETERS ('DELETE_CONCAT_ATTRIBUTE'='$/BIC/YRDBCCLOC$DOC_NUMBER$S_ORD_ITEM$SCHED_LINE$DELIV_ITEM$/BIC/YRFCDATUM$')            |
|SAPSR3     |/BIC/SYRFCHDNDA |_SYS_TREE_CS_#11034544_#0_#P0|      1.75|$/BIC/YRDBCCLOC$/BIC/YRFCHDNDA$                                                        |CONCAT_ATTRIBUTE|PRIMARY KEY|ALTER TABLE "SAPSR3"."/BIC/SYRFCHDNDA" WITH PARAMETERS ('DELETE_CONCAT_ATTRIBUTE'='$/BIC/YRDBCCLOC$/BIC/YRFCHDNDA$')                                                        |
|SAPSR3     |/BIC/SYRDBPMUE2 |_SYS_TREE_CS_#11043347_#0_#P0|      1.73|$/BIC/YRDBP_PVZ$/BIC/YRDBPUE1$MATL_TYPE$MATERIAL$/BIC/YRDBMDAT1$/BIC/YRDBPMUE2$        |CONCAT_ATTRIBUTE|PRIMARY KEY|ALTER TABLE "SAPSR3"."/BIC/SYRDBPMUE2" WITH PARAMETERS ('DELETE_CONCAT_ATTRIBUTE'='$/BIC/YRDBP_PVZ$/BIC/YRDBPUE1$MATL_TYPE$MATERIAL$/BIC/YRDBMDAT1$/BIC/YRDBPMUE2$')        |
|SAPSR3     |/BIC/SYRDBPMAG2 |_SYS_TREE_CS_#10948588_#0_#P0|      1.73|$/BIC/YRDBP_PVZ$SOLD_TO$MATL_TYPE$MATERIAL$/BIC/YRDBMDAT1$/BIC/YRDBPMAG2$              |CONCAT_ATTRIBUTE|PRIMARY KEY|ALTER TABLE "SAPSR3"."/BIC/SYRDBPMAG2" WITH PARAMETERS ('DELETE_CONCAT_ATTRIBUTE'='$/BIC/YRDBP_PVZ$SOLD_TO$MATL_TYPE$MATERIAL$/BIC/YRDBMDAT1$/BIC/YRDBPMAG2$')              |
|SAPSR3     |/BIC/SYRFCORDIT |_SYS_TREE_CS_#10963770_#0_#P0|      1.56|$/BIC/YRDBCCLOC$/BIC/YRFCORDIT$                                                        |CONCAT_ATTRIBUTE|PRIMARY KEY|ALTER TABLE "SAPSR3"."/BIC/SYRFCORDIT" WITH PARAMETERS ('DELETE_CONCAT_ATTRIBUTE'='$/BIC/YRDBCCLOC$/BIC/YRFCORDIT$')                                                        |
|SAPSR3     |/BIC/SYRDOPAON1 |_SYS_TREE_CS_#11129275_#0_#P0|      1.00|$/BIC/YRDBOPCO1$/BIC/YRDOPAON1$                                                        |CONCAT_ATTRIBUTE|PRIMARY KEY|ALTER TABLE "SAPSR3"."/BIC/SYRDOPAON1" WITH PARAMETERS ('DELETE_CONCAT_ATTRIBUTE'='$/BIC/YRDBOPCO1$/BIC/YRDOPAON1$')                                                        |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  C.SCHEMA_NAME,
  C.TABLE_NAME,
  I.INDEX_NAME,
  LPAD(TO_DECIMAL(C.MEMORY_SIZE_IN_TOTAL / 1024 / 1024 / 1024, 10, 2), 10) SIZE_GB,
  I.COLUMN_LIST,
  C.INTERNAL_ATTRIBUTE_TYPE ATTRIBUTE_TYPE,
  I.CONSTRAINT,
  'ALTER TABLE "' || C.SCHEMA_NAME || '"."' || C.TABLE_NAME || '" WITH PARAMETERS (' || CHAR(39) || 'DELETE_CONCAT_ATTRIBUTE' || 
    CHAR(39) || '=' || CHAR(39) || I.COLUMN_LIST || CHAR(39) || ')' ||
    MAP(BI.GENERATE_SEMICOLON, 'X', CHAR(59), '') DROP_COMMAND
FROM
( SELECT                       /* Modification section */
    '%' SCHEMA_NAME,
    '%' TABLE_NAME,
    1024 MIN_SIZE_MB,
    'X' GENERATE_SEMICOLON
  FROM
    DUMMY
) BI,
  M_CS_ALL_COLUMNS C,
( SELECT
    SCHEMA_NAME,
    TABLE_NAME,
    INDEX_NAME,
    CONSTRAINT,
    '$' || STRING_AGG(COLUMN_NAME, '$' ORDER BY POSITION) || '$' COLUMN_LIST
  FROM
    INDEX_COLUMNS
  WHERE
    CONSTRAINT = 'PRIMARY KEY'
  GROUP BY
    SCHEMA_NAME,
    TABLE_NAME,
    INDEX_NAME,
    CONSTRAINT
) I
WHERE
  C.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  C.TABLE_NAME LIKE BI.TABLE_NAME AND
  C.SCHEMA_NAME = I.SCHEMA_NAME AND
  C.TABLE_NAME = I.TABLE_NAME AND
  C.COLUMN_NAME = I.COLUMN_LIST AND
  ( BI.MIN_SIZE_MB = -1 OR C.MEMORY_SIZE_IN_TOTAL / 1024 / 1024 > BI.MIN_SIZE_MB )
ORDER BY
  C.MEMORY_SIZE_IN_TOTAL DESC