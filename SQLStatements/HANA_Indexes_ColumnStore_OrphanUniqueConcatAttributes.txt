SELECT

/* 

[NAME]

- HANA_Indexes_ColumnStore_OrphanUniqueConcatAttributes

[DESCRIPTION]

- Lists concat attributes with naming convention "$uc_<constraint>$" but without a corresponding unique constraint

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Orphan unique concat attributes do not enforce uniqueness, but at the same time SAP HANA may assume uniqueness
  leading to wrong results (e.g. issue number 258724)
- Before dropping the orphan concat attribute, make sure that really no related index exists
- See SAP Note 2160391 for more information about SAP HANA indexes.

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2020/10/31:  1.0 (initial version)

[INVOLVED TABLES]

- CONSTRAINTS
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

[OUTPUT PARAMETERS]

- SCHEMA_NAME:      Schema name
- TABLE_NAME:       Table name
- CONCAT_NAME:      Name of orphan unique concat attribute
- RECORD_COUNT:     Records
- DISTINCT_COUNT:   Distinct values
- DELETION_COMMAND: Command for deleting the orphan unique concat attribute

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME|TABLE_NAME|CONCAT_NAME                     |RECORD_COUNT|DISTINCT_COUNT|DELETION_COMMAND                                                                                            |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SYSTEM     |AAA       |$uc__SYS_TREE_CS_#1234567_#0_#0$|        5804|           7  |ALTER TABLE "SYSTEM"."AAA" WITH PARAMETERS ('DELETE_CONCAT_ATTRIBUTE' = '$uc__SYS_TREE_CS_#1234567_#0_#0$') |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  AC.SCHEMA_NAME,
  AC.TABLE_NAME,
  AC.COLUMN_NAME CONCAT_NAME,
  LPAD(GREATEST(0, SUM(AC.COUNT)), 12) RECORD_COUNT,
  LPAD(GREATEST(0, MAX(AC.DISTINCT_COUNT)), 14) DISTINCT_COUNT,
  'ALTER TABLE "' || AC.SCHEMA_NAME || '"."' || AC.TABLE_NAME || '" WITH PARAMETERS (' || CHAR(39) || 'DELETE_CONCAT_ATTRIBUTE' || CHAR(39) || CHAR(32) ||
    '=' || CHAR(32) || CHAR(39) || AC.COLUMN_NAME || CHAR(39) || ')' || CHAR(59) DELETION_COMMAND
FROM
( SELECT                                   /* Modification section */
    '%' SCHEMA_NAME,
    '%' TABLE_NAME
  FROM
    DUMMY
) BI,
  M_CS_ALL_COLUMNS AC
WHERE
  AC.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  AC.TABLE_NAME LIKE BI.TABLE_NAME AND
  AC.COLUMN_NAME LIKE '$uc%$' AND
  AC.INTERNAL_ATTRIBUTE_TYPE = 'CONCAT_ATTRIBUTE' AND
  NOT EXISTS
  ( SELECT 1 FROM CONSTRAINTS C WHERE '$uc_' || C.CONSTRAINT_NAME || '$' = AC.COLUMN_NAME )
GROUP BY
  AC.SCHEMA_NAME,
  AC.TABLE_NAME,
  AC.COLUMN_NAME
ORDER BY
  AC.SCHEMA_NAME,
  AC.TABLE_NAME,
  AC.COLUMN_NAME