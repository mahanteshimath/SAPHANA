SELECT

/* 

[NAME]

- HANA_Synonyms_IdenticalTableNames

[DESCRIPTION]

- Lists synonyms with names that are identical to table names

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Only PUBLIC synonyms and synonyms in the same schema like the table are reported
- This scenario can cause trouble in specific constellations (e.g. SAP Note 2401716 for AMDP / SAP ABAP)
- Synonyms in schemas different from the table are ignored

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2016/12/10:  1.0 (initial version)

[INVOLVED TABLES]

- SYNONYMS
- TABLES

[INPUT PARAMETERS]

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- OBJECT_NAME

  Object name

  'EDIDC'         --> Specific object name EDIDC
  'A%'            --> All objects starting with 'A'
  '%'             --> All objects

[OUTPUT PARAMETERS]

- TABLE_SCHEMA:          Table schema
- TABLE_NAME:            Table name
- SYNONYM_SCHEMA:        Synonym schema
- SYNONYM_NAME:          Synonym name
- SYNONYM_OBJECT_SCHEMA: Schema of object referenced by synonym
- SYNONYM_OBJECT_NAME:   Name of object referenced by synonym

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
|TABLE_SCHEMA|TABLE_NAME                           |SYNONYM_SCHEMA|SYNONYM_NAME                         |SYNONYM_OBJECT_SCHEMA|SYNONYM_OBJECT_NAME                  |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SAPSR3      |BBB                                  |PUBLIC        |BBB                                  |SAPSR3               |AAA                                  |
|SAPSR3      |I099999_native_dev.data::test.details|PUBLIC        |I099999_native_dev.data::test.details|SAPSR3               |I099999_native_dev.data::test.details|
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

  T.SCHEMA_NAME TABLE_SCHEMA,
  T.TABLE_NAME,
  S.SCHEMA_NAME SYNONYM_SCHEMA,
  S.SYNONYM_NAME,
  S.OBJECT_SCHEMA SYNONYM_OBJECT_SCHEMA,
  S.OBJECT_NAME SYNONYM_OBJECT_NAME  
FROM
( SELECT              /* Modification section */
    'SAP___' SCHEMA_NAME,
    '%' OBJECT_NAME
  FROM
    DUMMY
) BI,
  SYNONYMS S,
  TABLES T
WHERE
  T.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  T.TABLE_NAME LIKE BI.OBJECT_NAME AND
  ( S.SCHEMA_NAME = 'PUBLIC' OR S.SCHEMA_NAME = T.SCHEMA_NAME ) AND
  S.SYNONYM_NAME = T.TABLE_NAME 