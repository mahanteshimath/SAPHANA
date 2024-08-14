SELECT

/* 

[NAME]

- HANA_Consistency_ObjectDependency

[DESCRIPTION]

- Check for inconsistent object types in objects metadata vs. dependency

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Related to SAP Note 2498587 (Inconsistency Message Between Metadata and OBJECT_DEPENDENCIES Table)
- Can result in following trace file entries:

  Inconsistency found between Metadata and Object Dependency Table!

- Output list contains base / dependent objects that can not be found in OBJECTS

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2017/07/14:  1.0 (initial version)
- 2017/07/21:  1.1 (improved check algorithm to avoid false alerts in case of identical names of different objects)
- 2020/09/17:  1.2 (proper handling of NULL schema names)

[INVOLVED TABLES]

- OBJECTS
- OBJECT_DEPENDENCIES

[INPUT PARAMETERS]

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- OBJECT_NAME           

  Object name or pattern

  'T000'          --> Specific object T000
  'T%'            --> All objects starting with 'T'
  '%'             --> All objects

[OUTPUT PARAMETERS]

- CONTEXT:               Object context ('BASE_OBJECT' -> dependency base object, 'DEPENDENT_OBJECT' -> dependency dependent object)
- SCHEMA_NAME:           Schema name
- OBJECT_NAME:           Object name
- OBJECT_TYPE:           Object type

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------
|CONTEXT         |SCHEMA_NAME          |OBJECT_NAME                                                           |OBJECT_TYPE|
---------------------------------------------------------------------------------------------------------------------------
|DEPENDENT_OBJECT|HANA_XS_BASE         |sap.hana.xs.selfService.user.db::INI_PARAMS_DETAILS                   |VIEW       |
|DEPENDENT_OBJECT|HANA_XS_BASE         |sap.hana.xs.selfService.user.db::USS_INI_PARAMS                       |PROCEDURE  |
---------------------------------------------------------------------------------------------------------------------------

*/

  O.CONTEXT,
  IFNULL(O.SCHEMA_NAME, '') SCHEMA_NAME,
  O.OBJECT_NAME,
  O.OBJECT_TYPE
FROM
( SELECT                        /* Modification section */
    '%' SCHEMA_NAME,
    '%' OBJECT_NAME
  FROM
    DUMMY
) BI,
( SELECT DISTINCT
    'BASE_OBJECT' CONTEXT,
    D.BASE_SCHEMA_NAME SCHEMA_NAME,
    D.BASE_OBJECT_NAME OBJECT_NAME,
    D.BASE_OBJECT_TYPE OBJECT_TYPE
  FROM
    OBJECT_DEPENDENCIES D
  WHERE
    NOT EXISTS
    ( SELECT
        1
      FROM
        OBJECTS O
      WHERE
        IFNULL(O.SCHEMA_NAME, '') = IFNULL(D.BASE_SCHEMA_NAME, '') AND
        O.OBJECT_NAME = D.BASE_OBJECT_NAME AND
        O.OBJECT_TYPE = D.BASE_OBJECT_TYPE 
    )
  UNION
  SELECT DISTINCT
    'DEPENDENT_OBJECT' CONTEXT,
    D.DEPENDENT_SCHEMA_NAME SCHEMA_NAME,
    D.DEPENDENT_OBJECT_NAME OBJECT_NAME,
    D.DEPENDENT_OBJECT_TYPE OBJECT_TYPE
  FROM
    OBJECT_DEPENDENCIES D
  WHERE
    NOT EXISTS
    ( SELECT
        1
      FROM
        OBJECTS O
      WHERE
        IFNULL(O.SCHEMA_NAME, '') = IFNULL(D.DEPENDENT_SCHEMA_NAME, '') AND
        O.OBJECT_NAME = D.DEPENDENT_OBJECT_NAME AND
        O.OBJECT_TYPE = D.DEPENDENT_OBJECT_TYPE
    )
) O
WHERE
  IFNULL(O.SCHEMA_NAME, '') LIKE BI.SCHEMA_NAME AND
  O.OBJECT_NAME LIKE BI.OBJECT_NAME
ORDER BY
  IFNULL(O.SCHEMA_NAME, ''),
  O.OBJECT_NAME,
  O.OBJECT_TYPE