WITH 

/* 

[NAME]

- HANA_Indexes_ColumnStore_MissingConcatAttributes

[DESCRIPTION]

- Lists multi-column indexes (INVERTED VALUE, INVERTED HASH) in column store that do not have a corresponding concat attribute

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Multi-column column store indexes of type INVERTED VALUE or INVERTED HASH are implemented based on a concat attribute 
  column following the naming convention $<column_1>$...$<column_N>$.
- This analysis command detects inconsistencies where the concat attribute is missing.
- See SAP Note 2160391 for more information about SAP HANA indexes.

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2020/01/30:  1.0 (initial version)

[INVOLVED TABLES]

- INDEXES
- INDEX_COLUMNS
- M_CS_ALL_COLUMNS

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

- INDEX_NAME

  Index name or pattern

  'EDIDC~1'       --> Specific index EDIDC~1
  '%~2'           --> All indexes ending with '~2'
  '%'             --> All indexes

- INDEX TYPE

  Index type

  'INVERTED VALUE' --> Indexes with type INVERTED VALUE
  '%'              --> No restriction related to index type

[OUTPUT PARAMETERS]

- SCHEMA_NAME:               Schema name
- TABLE_NAME:                Table name
- INDEX_NAME.                Index name
- COLUMN_NAME:               Column name
- INDEX_TYPE:                Index type
- EXPECTED_CONCAT_ATTRIBUTE: Expected name of missing concat attribute
- RECREATION_COMMAND:        Command for recreating the missing concat attribute

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME|TABLE_NAME      |INDEX_NAME                  |INDEX_TYPE           |EXPECTED_CONCAT_ATTRIBUTE      |RECREATION_COMMAND                                                                                                                                               |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SAPSR3     |/BIC/AFMMIMD0500|/BIC/AFMMIMD050001          |INVERTED VALUE       |$MATERIAL$PLANT$/BIC/PINCNTPLD$|ALTER TABLE "SAPSR3"."/BIC/AFMMIMD0500" WITH PARAMETERS('CONCAT_ATTRIBUTE' = ('$MATERIAL$PLANT$/BIC/PINCNTPLD$', 'MATERIAL', 'PLANT', '/BIC/PINCNTPLD'))         |
|SAPSR3     |/BIC/AFMMIMD0500|/BIC/AFMMIMD050002          |INVERTED VALUE       |$MATERIAL$PLANT$/BIC/PINCNTDAT$|ALTER TABLE "SAPSR3"."/BIC/AFMMIMD0500" WITH PARAMETERS('CONCAT_ATTRIBUTE' = ('$MATERIAL$PLANT$/BIC/PINCNTDAT$', 'MATERIAL', 'PLANT', '/BIC/PINCNTDAT'))         |
|SAPSR3     |/BIC/AFMMIMD0500|_SYS_TREE_CS_#1633530_#0_#P0|INVERTED VALUE UNIQUE|$trexexternalkey$              |ALTER TABLE "SAPSR3"."/BIC/AFMMIMD0500" WITH PARAMETERS('CONCAT_ATTRIBUTE' = ('$trexexternalkey$', 'FISCVARNT', 'FISCYEAR', '/BIC/PINDOCNUM', '/BIC/PINDOCITM')) |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

TEMP_M_CS_ALL_COLUMNS AS
( SELECT
    SCHEMA_NAME,
    TABLE_NAME,
    COLUMN_NAME
  FROM
    M_CS_ALL_COLUMNS
  WHERE
    COLUMN_NAME LIKE '$%$'
)
SELECT
  SCHEMA_NAME,
  TABLE_NAME,
  INDEX_NAME,
  INDEX_TYPE,
  EXPECTED_CONCAT_ATTRIBUTE,
  'ALTER TABLE "' || SCHEMA_NAME || '"."' || TABLE_NAME || '" WITH PARAMETERS(''CONCAT_ATTRIBUTE'' = (''' || EXPECTED_CONCAT_ATTRIBUTE || ''', ' || COLUMN_LIST || '))' || CHAR(59) RECREATION_COMMAND
FROM
( SELECT
    I.SCHEMA_NAME,
    I.TABLE_NAME,
    I.INDEX_NAME,
    I.INDEX_TYPE,
    CASE
      WHEN IC.CONSTRAINT IS NULL AND I.INDEX_TYPE = 'INVERTED VALUE' THEN '$' || STRING_AGG(IC.COLUMN_NAME, '$' ORDER BY IC.POSITION) || '$'
      WHEN IC.CONSTRAINT = 'PRIMARY KEY'                             THEN '$trexexternalkey$'
      WHEN IC.CONSTRAINT LIKE '%UNIQUE%'                             THEN '$uc_' || I.INDEX_NAME || '$'
    END EXPECTED_CONCAT_ATTRIBUTE,
    CHAR(39) || STRING_AGG(IC.COLUMN_NAME, CHAR(39) || ',' || CHAR(32) || CHAR(39) ORDER BY IC.POSITION) || CHAR(39) COLUMN_LIST
  FROM
    ( SELECT                                   /* Modification section */
        '%' SCHEMA_NAME,
        '%' TABLE_NAME,
        '%' INDEX_NAME,
        '%' INDEX_TYPE
      FROM
        DUMMY
    ) BI,
    INDEXES I,
    INDEX_COLUMNS IC
  WHERE
    I.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    I.TABLE_NAME LIKE BI.TABLE_NAME AND
    I.INDEX_NAME LIKE BI.INDEX_NAME AND
    I.INDEX_TYPE LIKE BI.INDEX_TYPE AND
    I.SCHEMA_NAME = IC.SCHEMA_NAME AND 
    I.TABLE_NAME = IC.TABLE_NAME AND
    I.INDEX_NAME = IC.INDEX_NAME AND
    ( I.INDEX_TYPE LIKE 'INVERTED VALUE%' OR I.INDEX_TYPE LIKE 'INVERTED HASH%')
  GROUP BY
    I.SCHEMA_NAME,
    I.TABLE_NAME,
    I.INDEX_NAME,
    I.INDEX_TYPE,
    IC.CONSTRAINT
  HAVING
    COUNT(*) >= 2
)
WHERE
  ( SCHEMA_NAME, TABLE_NAME, EXPECTED_CONCAT_ATTRIBUTE ) NOT IN
  ( SELECT
      C.SCHEMA_NAME,
      C.TABLE_NAME,
      C.COLUMN_NAME
    FROM
      TEMP_M_CS_ALL_COLUMNS C
  )
ORDER BY
  SCHEMA_NAME,
  TABLE_NAME,
  INDEX_NAME