SELECT
/* 

[NAME]

- HANA_Objects_Overview

[DESCRIPTION]

- Object overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/04/27:  1.0 (initial version)

[INVOLVED TABLES]

- OBJECTS

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

  'TABLE'         --> Specific object type TABLE
  '%'             --> All object types

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'NAME'          --> Sorting by object name
  'ID'            --> Sorting by object ID

[OUTPUT PARAMETERS]

- SCHEMA_NAME:     Schema name
- OBJECT_NAME:     Object name
- OBJECT_TYPE:     Object type
- OBJECT_ID:       Object ID

[EXAMPLE OUTPUT]

-------------------------------------------------------
|SCHEMA_NAME|OBJECT_NAME     |OBJECT_TYPE|OBJECT_ID   |
-------------------------------------------------------
|SAPSR3     |/BIC/ABXCRMO0100|TABLE      |     1060271|
-------------------------------------------------------

*/

  O.SCHEMA_NAME,
  O.OBJECT_NAME,
  O.OBJECT_TYPE,
  LPAD(O.OBJECT_OID, 12) OBJECT_ID
FROM
( SELECT               /* Modification section */
    '%' SCHEMA_NAME,
    '%' OBJECT_NAME,
    '%' OBJECT_TYPE,
    -1 OBJECT_ID,
    'ID' ORDER_BY           /* NAME, ID */
  FROM
    DUMMY
) BI,
  OBJECTS O
WHERE
  O.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  O.OBJECT_NAME LIKE BI.OBJECT_NAME AND
  O.OBJECT_TYPE LIKE BI.OBJECT_TYPE AND
  ( BI.OBJECT_ID = -1 OR O.OBJECT_OID = BI.OBJECT_ID )
ORDER BY
  MAP(BI.ORDER_BY, 'ID', O.OBJECT_OID) DESC,
  O.SCHEMA_NAME,
  O.OBJECT_NAME,
  O.OBJECT_TYPE