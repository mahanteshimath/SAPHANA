SELECT
/* 

[NAME]

HANA_Tables_ColumnStore_AutoCompressionDisabled

[DESCRIPTION]

- Displays tables with disabled auto compression

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/09/15:  1.0 (initial version)
- 2017/11/07:  1.1 (exclusion of tables with IS_TEMPORARY = 'FALSE')
- 2018/10/09:  1.2 (exclusion of TABLE_TYPE = 'COLLECTION')

[INVOLVED TABLES]

- TABLES

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

- EXCLUDE_BW_TABLES

  Possibility to exclude BW tables from analysis (following naming conventions like /B%/%)

  'X'             --> Only display non BW tables
  ' '             --> Display all tables

- GENERATE_SEMICOLON

  Controls the generation of semicolons at the end of the generated SQL statements

  'X'             --> Semicolon is generated
  ' '             --> No semicolon is generated

[OUTPUT PARAMETERS]

- SCHEMA_NAME:      Schema name
- TABLE_NAME:       Table name
- AUTO_COMPRESSION: Auto compression configuration on table level (FALSE: no auto compression)
- COMMAND:          Command to activate auto compression for the table

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME   |TABLE_NAME      |AUTO_COMPRESSION|COMMAND                                                                                    |
----------------------------------------------------------------------------------------------------------------------------------------------
|SAPSR3        |/ASU/CONTENTV   |FALSE           |ALTER TABLE "SAPSR3"."/ASU/CONTENTV" WITH PARAMETERS('AUTO_OPTIMIZE_COMPRESSION' = 'ON')   |
|SAPSR3        |/ASU/STEPST     |FALSE           |ALTER TABLE "SAPSR3"."/ASU/STEPST" WITH PARAMETERS('AUTO_OPTIMIZE_COMPRESSION' = 'ON')     |
|SAPSR3        |/ASU/STEPST_V   |FALSE           |ALTER TABLE "SAPSR3"."/ASU/STEPST_V" WITH PARAMETERS('AUTO_OPTIMIZE_COMPRESSION' = 'ON')   |
|SAPSR3        |/SDF/CLI_TRC    |FALSE           |ALTER TABLE "SAPSR3"."/SDF/CLI_TRC" WITH PARAMETERS('AUTO_OPTIMIZE_COMPRESSION' = 'ON')    |
|SAPSR3        |/SDF/CMO_IACJSCR|FALSE           |ALTER TABLE "SAPSR3"."/SDF/CMO_IACJSCR" WITH PARAMETERS('AUTO_OPTIMIZE_COMPRESSION' = 'ON')|
|SAPSR3        |/SDF/LC_DBCON   |FALSE           |ALTER TABLE "SAPSR3"."/SDF/LC_DBCON" WITH PARAMETERS('AUTO_OPTIMIZE_COMPRESSION' = 'ON')   |
|SAPSR3        |ARFCLOG         |FALSE           |ALTER TABLE "SAPSR3"."ARFCLOG" WITH PARAMETERS('AUTO_OPTIMIZE_COMPRESSION' = 'ON')         |
|SAPSR3        |ARFCRCONTEXT    |FALSE           |ALTER TABLE "SAPSR3"."ARFCRCONTEXT" WITH PARAMETERS('AUTO_OPTIMIZE_COMPRESSION' = 'ON')    |
|SAPSR3        |BALC            |FALSE           |ALTER TABLE "SAPSR3"."BALC" WITH PARAMETERS('AUTO_OPTIMIZE_COMPRESSION' = 'ON')            |
|SAPSR3        |BAL_INDX        |FALSE           |ALTER TABLE "SAPSR3"."BAL_INDX" WITH PARAMETERS('AUTO_OPTIMIZE_COMPRESSION' = 'ON')        |
|SAPSR3        |BGRFC_CUST_I_DST|FALSE           |ALTER TABLE "SAPSR3"."BGRFC_CUST_I_DST" WITH PARAMETERS('AUTO_OPTIMIZE_COMPRESSION' = 'ON')|
|SAPSR3        |BGRFC_CUST_I_SRV|FALSE           |ALTER TABLE "SAPSR3"."BGRFC_CUST_I_SRV" WITH PARAMETERS('AUTO_OPTIMIZE_COMPRESSION' = 'ON')|
|SAPSR3        |BGRFC_CUST_O_DST|FALSE           |ALTER TABLE "SAPSR3"."BGRFC_CUST_O_DST" WITH PARAMETERS('AUTO_OPTIMIZE_COMPRESSION' = 'ON')|
|SAPSR3        |BGRFC_CUST_O_SRV|FALSE           |ALTER TABLE "SAPSR3"."BGRFC_CUST_O_SRV" WITH PARAMETERS('AUTO_OPTIMIZE_COMPRESSION' = 'ON')|
|SAPSR3        |BGRFC_IUNIT_HIST|FALSE           |ALTER TABLE "SAPSR3"."BGRFC_IUNIT_HIST" WITH PARAMETERS('AUTO_OPTIMIZE_COMPRESSION' = 'ON')|
|SAPSR3        |BGRFC_I_DESTLOCK|FALSE           |ALTER TABLE "SAPSR3"."BGRFC_I_DESTLOCK" WITH PARAMETERS('AUTO_OPTIMIZE_COMPRESSION' = 'ON')|
|SAPSR3        |BGRFC_I_DEST_ERR|FALSE           |ALTER TABLE "SAPSR3"."BGRFC_I_DEST_ERR" WITH PARAMETERS('AUTO_OPTIMIZE_COMPRESSION' = 'ON')|
|SAPSR3        |BGRFC_I_RUNNABLE|FALSE           |ALTER TABLE "SAPSR3"."BGRFC_I_RUNNABLE" WITH PARAMETERS('AUTO_OPTIMIZE_COMPRESSION' = 'ON')|
|SAPSR3        |BGRFC_LOCK_TIME |FALSE           |ALTER TABLE "SAPSR3"."BGRFC_LOCK_TIME" WITH PARAMETERS('AUTO_OPTIMIZE_COMPRESSION' = 'ON') |
----------------------------------------------------------------------------------------------------------------------------------------------

*/

  T.SCHEMA_NAME,
  T.TABLE_NAME,
  T.AUTO_OPTIMIZE_COMPRESSION_ON AUTO_COMPRESSION,
  'ALTER TABLE' || CHAR(32) || '"' || T.SCHEMA_NAME || '"."' || T.TABLE_NAME || '" WITH PARAMETERS(' || CHAR(39) ||
    'AUTO_OPTIMIZE_COMPRESSION' || CHAR(39) || CHAR(32) || '=' || CHAR(32) || CHAR(39) || 'ON' || CHAR(39) || ')' ||
    MAP(BI.GENERATE_SEMICOLON, 'X', ';', '') COMMAND
FROM
( SELECT                  /* Modification section */
    '%' SCHEMA_NAME,
    '%' TABLE_NAME,
    'X' EXCLUDE_BW_TABLES,
    'X' GENERATE_SEMICOLON
  FROM
    DUMMY
) BI,
  TABLES T
WHERE
  T.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  T.TABLE_NAME LIKE BI.TABLE_NAME AND
  T.AUTO_OPTIMIZE_COMPRESSION_ON = 'FALSE' AND
  T.IS_COLUMN_TABLE = 'TRUE' AND
  T.IS_TEMPORARY = 'FALSE' AND
  T.TABLE_TYPE != 'COLLECTION' AND
  ( BI.EXCLUDE_BW_TABLES = ' ' OR
    T.TABLE_NAME LIKE '/BA1/%' OR
    ( T.TABLE_NAME NOT LIKE 'RSPM%' AND 
      T.TABLE_NAME NOT LIKE 'ZBICZ%' AND
      T.TABLE_NAME NOT LIKE '0BW:BIA%' AND
      T.TABLE_NAME NOT LIKE '$BPC$HC$%' AND
      T.TABLE_NAME NOT LIKE '$BPC$TMP%' AND
      T.TABLE_NAME NOT LIKE '/B%/%' AND
      T.TABLE_NAME NOT LIKE '/1B0/%' AND
      T.TABLE_NAME NOT LIKE '/1DD/%' AND
      SUBSTR(T.TABLE_NAME, 1, 3) != 'TR_' 
    )
  )
ORDER BY
  T.SCHEMA_NAME,
  T.TABLE_NAME