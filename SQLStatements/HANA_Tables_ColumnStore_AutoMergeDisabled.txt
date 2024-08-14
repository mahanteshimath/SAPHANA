SELECT
/* 

[NAME]

HANA_Tables_ColumnStore_AutoMergeDisabled

[DESCRIPTION]

- Displays tables with disabled auto merge

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/11/04:  1.0 (initial version)
- 2014/11/18:  1.1 (COMMAND added)
- 2015/05/19:  1.2 (GENERATE_SEMICOLON added)
- 2017/11/07:  1.3 (exclusion of tables with IS_TEMPORARY = 'FALSE')
- 2018/10/09:  1.4 (exclusion of TABLE_TYPE = 'COLLECTION')

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

  Possibility to exclude BW tables from analysis (following naming convention /B%/%)

  'X'             --> Only display non BW tables
  ' '             --> Display all tables

- GENERATE_SEMICOLON

  Controls the generation of semicolons at the end of the generated SQL statements

  'X'             --> Semicolon is generated
  ' '             --> No semicolon is generated

[OUTPUT PARAMETERS]

- SCHEMA_NAME:      Schema name
- TABLE_NAME:       Table name
- AUTO_MERGE_ON:    Auto merge configuration on table level (FALSE: no auto merge)
- COMMAND:          Command to activate auto merge for the table

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------------
|SCHEMA_NAME|TABLE_NAME      |AUTO_MERGE_ON|COMMAND                                                 |
-----------------------------------------------------------------------------------------------------
|SAPSR3     |/ASU/CONTENTNVT |FALSE        |ALTER TABLE "SAPSR3"."/ASU/CONTENTNVT" ENABLE AUTOMERGE |
|SAPSR3     |/ASU/CONTENTT   |FALSE        |ALTER TABLE "SAPSR3"."/ASU/CONTENTT" ENABLE AUTOMERGE   |
|SAPSR3     |/ASU/CONTENTV   |FALSE        |ALTER TABLE "SAPSR3"."/ASU/CONTENTV" ENABLE AUTOMERGE   |
|SAPSR3     |/ASU/CONTENTXML |FALSE        |ALTER TABLE "SAPSR3"."/ASU/CONTENTXML" ENABLE AUTOMERGE |
|SAPSR3     |/ASU/STEPST     |FALSE        |ALTER TABLE "SAPSR3"."/ASU/STEPST" ENABLE AUTOMERGE     |
|SAPSR3     |/ASU/STEPST_V   |FALSE        |ALTER TABLE "SAPSR3"."/ASU/STEPST_V" ENABLE AUTOMERGE   |
|SAPSR3     |/BDL/TMPDAT     |FALSE        |ALTER TABLE "SAPSR3"."/BDL/TMPDAT" ENABLE AUTOMERGE     |
|SAPSR3     |/BDL/_CLUSTL    |FALSE        |ALTER TABLE "SAPSR3"."/BDL/_CLUSTL" ENABLE AUTOMERGE    |
|SAPSR3     |/SAPDMC/LSODOC  |FALSE        |ALTER TABLE "SAPSR3"."/SAPDMC/LSODOC" ENABLE AUTOMERGE  |
|SAPSR3     |/SAPDMC/LSOPRT  |FALSE        |ALTER TABLE "SAPSR3"."/SAPDMC/LSOPRT" ENABLE AUTOMERGE  |
|SAPSR3     |/SAPPO/ORDER_DAT|FALSE        |ALTER TABLE "SAPSR3"."/SAPPO/ORDER_DAT" ENABLE AUTOMERGE|
|SAPSR3     |/SDF/CLI_TRC    |FALSE        |ALTER TABLE "SAPSR3"."/SDF/CLI_TRC" ENABLE AUTOMERGE    |
-----------------------------------------------------------------------------------------------------

*/

  T.SCHEMA_NAME,
  T.TABLE_NAME,
  T.AUTO_MERGE_ON,
  'ALTER TABLE' || CHAR(32) || '"' || T.SCHEMA_NAME || '"."' || T.TABLE_NAME || '" ENABLE AUTOMERGE' ||
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
  T.AUTO_MERGE_ON = 'FALSE' AND
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