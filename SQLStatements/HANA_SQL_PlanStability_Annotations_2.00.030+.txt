SELECT
/* 

[NAME]

- HANA_SQL_PlanStability_Annotations_2.00.030+

[DESCRIPTION]

- Display annotations

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Annotations with key HINT for SQL views exist for SAP HANA >= 2.0 SPS 03 and can be used for object-level plan stability purposes.
- Other annotations for different purposes also exist.

[VALID FOR]

- Revisions:              >= 2.00.030

[SQL COMMAND VERSION]

- 2019/06/09:  1.0 (initial version)

[INVOLVED TABLES]

- ANNOTATIONS

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

- OBJECT_TYPE

  Type of object (e.g. 'TABLE', 'SYNONYM', 'VIEW' or 'INDEX')

  'VIEW'          --> Specific object type VIEW
  '%'             --> All object types

- KEY

  Annotation key

  'HINT'          --> Display annotations with key HINT
  '%'             --> No restriction related to annotation key

- VALUE

  Annotation value

  'USE_HEX_PLAN'  --> Display annotations with value USE_HEX_PLAN
  '%'             --> No restriction related to annotation value

[OUTPUT PARAMETERS]

- STATEMENT_STRING:   Statement string
- HINT_STRING:        Hint string (i.e. hints manually added by user)
- SYSTEM_HINT_STRING: System hint string (i.e. hints predelivered during upgrade)
- ENABLED:            Status of statement hint (TRUE -> enabled, FALSE -> disabled)
- ENABLE_TIME:        Last enable time
- USER_NAME:          Name of user who enabled statement hint last time

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------
|SCHEMA_NAME|OBJECT_NAME            |OBJECT_TYPE|KEY |VALUE                         |
-------------------------------------------------------------------------------------
|SAPC11     |V_CF_MCHB              |VIEW       |HINT|USE_ESX_PLAN                  |
|_SYS_BI    |BIMC_ALL_CUBES_HDI     |VIEW       |HINT|OPTIMIZATION_LEVEL(RULE_BASED)|
|_SYS_BI    |BIMC_AUTH_ONLY_CUBES   |VIEW       |HINT|OPTIMIZATION_LEVEL(RULE_BASED)|
|_SYS_BI    |BIMC_DIMENSIONS_HDI    |VIEW       |HINT|OPTIMIZATION_LEVEL(RULE_BASED)|
|_SYS_BI    |BIMC_DIMENSION_VIEW    |VIEW       |HINT|OPTIMIZATION_LEVEL(RULE_BASED)|
|_SYS_BI    |BIMC_DIMENSION_VIEW_HDI|VIEW       |HINT|OPTIMIZATION_LEVEL(RULE_BASED)|
|_SYS_BI    |BIMC_HIERARCHIES_HDI   |VIEW       |HINT|OPTIMIZATION_LEVEL(RULE_BASED)|
|_SYS_BI    |BIMC_PROPERTIES_VIEW   |VIEW       |HINT|OPTIMIZATION_LEVEL(RULE_BASED)|
|_SYS_BI    |BIMC_REPORTABLE_VIEWS  |VIEW       |HINT|OPTIMIZATION_LEVEL(RULE_BASED)|
|_SYS_BI    |BIMC_SOURCES           |VIEW       |HINT|OPTIMIZATION_LEVEL(RULE_BASED)|
-------------------------------------------------------------------------------------

*/

  A.SCHEMA_NAME,
  A.OBJECT_NAME,
  A.OBJECT_TYPE,
  A.KEY,
  A.VALUE  
FROM
( SELECT             /* Modification section */
    '%' SCHEMA_NAME,
    '%' OBJECT_NAME,
    '%' OBJECT_TYPE,
    'HINT' KEY,
    '%' VALUE
  FROM
    DUMMY
) BI,
  ANNOTATIONS A
WHERE
  A.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  A.OBJECT_NAME LIKE BI.OBJECT_NAME AND
  A.OBJECT_TYPE LIKE BI.OBJECT_TYPE AND
  A.KEY LIKE BI.KEY AND
  A.VALUE LIKE BI.VALUE
ORDER BY
  A.SCHEMA_NAME,
  A.OBJECT_NAME,
  A.OBJECT_TYPE,
  A.KEY,
  A.VALUE
