SELECT
/* 

[NAME]

- HANA_Objects_ObjectDependencies

[DESCRIPTION]

- Dependencies of objects (e.g. views accessing a specific table)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- With SAP HANA >= 2.0 SPS 07 dependencies between synonyms and deployed calculation views are no longer shown (SAP Note 3332017).

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/03/06:  1.0 (initial version)
- 2016/05/30:  1.1 (SCHEMA_NAME included)
- 2017/10/19:  1.2 (M_TEMPORARY_OBJECT_DEPENDENCIES added)
- 2022/02/07:  1.3 (AGGREGATE_BY and MIN_OBJECT_COUNT included)

[INVOLVED TABLES]

- OBJECT_DEPENDENCIES
- M_TEMPORARY_OBJECT_DEPENDENCIES

[INPUT PARAMETERS]

- BASE_SCHEMA_NAME

  Name of main schema

  'SAPSR3'       --> Main schema name SAPSR3
  '%'            --> Any main schema name

- BASE_OBJECT_NAME

  Name of main object

  'ILOA'         --> Main object name ILOA
  '%'            --> Any main object name

- BASE_OBJECT_TYPE

  Type of main object

  'TABLE'        --> Main object type TABLE
  '%'            --> No restriction of main object type

- DEPENDENT_SCHEMA_NAME

  Name of dependent schema

  'SAPSR3'       --> Dependent schema name SAPSR3
  '%'            --> Any dependent schema name

- DEPENDENT_OBJECT_NAME

  Name of dependent object

  'ILOA'         --> Dependent object name ILOA
  '%'            --> Any dependent object name

- DEPENDENT_OBJECT_TYPE:

  Type of dependent object

  'TABLE'        --> Dependent object type VIEW
  '%'            --> No restriction of dependent object type

- ONLY_TEMPORARY_DEPENDENCIES:

  Possibility to restrict result to dependencies involving temporary objects

  'X'            --> Only show dependencies related to temporary objects
  ' '            --> No restriction to temporary objects

- MIN_OBJECT_COUNT

  Minimum threshold for number of objects summarized in a line to be displayed

  50000          --> Only display lines with at least 50000 objects
  -1             --> No restriction related to number of objects per line

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'BASE_OBJECT'   --> Aggregation by base object name
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'BASE_NAME'     --> Sorting by base (schema and object) name
  'COUNT'         --> Sorting by number of objects

[OUTPUT PARAMETERS]

- SCHEMA_NAME:     Main object schema
- OBJECT_NAME:     Main object name
- OBJECT_TYPE:     Main object type
- T:               'X' if main object is temporary, otherwise ' '
- DEP_SCHEMA_NAME: Dependent object schema
- DEP_OBJECT_NAME: Dependent object name
- DEP_OBJECT_TYPE: Dependent object type
- DT:              'X' if dependent object is temporary, otherwise ' '
- COUNT:           Number of objects

[EXAMPLE OUTPUT]

----------------------------------------------------------
|OBJECT_NAME|OBJECT_TYPE|DEP_OBJECT_NAME |DEP_OBJECT_TYPE|
----------------------------------------------------------
|ILOA       |TABLE      |VIAUFKS_IFLOS   |VIEW           |
|ILOA       |TABLE      |VIAUFK_AFVC     |VIEW           |
|ILOA       |TABLE      |VIAUFK_AFVCIFLOS|VIEW           |
|ILOA       |TABLE      |VIAUF_AFVC      |VIEW           |
|ILOA       |TABLE      |VIAUF_AFVC_IFLOS|VIEW           |
|ILOA       |TABLE      |VIMHIO          |VIEW           |
|ILOA       |TABLE      |VIMHIO_IFLOS    |VIEW           |
|ILOA       |TABLE      |VIMHIS          |VIEW           |
|ILOA       |TABLE      |VIMPLA          |VIEW           |
|ILOA       |TABLE      |VIMPOS          |VIEW           |
|ILOA       |TABLE      |VIMPOS_IFLOS    |VIEW           |
|ILOA       |TABLE      |VINOTIF         |VIEW           |
|ILOA       |TABLE      |VIQMAML         |VIEW           |
|ILOA       |TABLE      |VIQMAML_IFLOS   |VIEW           |
|ILOA       |TABLE      |VIQMEL          |VIEW           |
|ILOA       |TABLE      |VIQMELST        |VIEW           |
|ILOA       |TABLE      |VIQMELST_IFLOS  |VIEW           |
|ILOA       |TABLE      |VIQMEL_IFLOS    |VIEW           |
|ILOA       |TABLE      |VIQMFEL         |VIEW           |
|ILOA       |TABLE      |VIQMFEL_IFLOS   |VIEW           |
|ILOA       |TABLE      |VIQMSML         |VIEW           |
|ILOA       |TABLE      |VIQMSML_IFLOS   |VIEW           |
----------------------------------------------------------

*/

  BASE_SCHEMA_NAME SCHEMA_NAME,
  BASE_OBJECT_NAME OBJECT_NAME,
  BASE_OBJECT_TYPE OBJECT_TYPE,
  BASE_OBJECT_IS_TEMPORARY T,
  DEPENDENT_SCHEMA_NAME DEP_SCHEMA_NAME,
  DEPENDENT_OBJECT_NAME DEP_OBJECT_NAME,
  DEPENDENT_OBJECT_TYPE DEP_OBJECT_TYPE,
  DEPENDENT_OBJECT_IS_TEMPORARY DT,
  LPAD(CNT, 7) "COUNT"
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'BASE_SCHEMA') != 0 THEN D.BASE_SCHEMA_NAME              ELSE MAP(BI.BASE_SCHEMA_NAME,      '%', 'any', BI.BASE_SCHEMA_NAME)      END BASE_SCHEMA_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'BASE_OBJECT') != 0 THEN D.BASE_OBJECT_NAME              ELSE MAP(BI.BASE_OBJECT_NAME,      '%', 'any', BI.BASE_OBJECT_NAME)      END BASE_OBJECT_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'BASE_TYPE')   != 0 THEN D.BASE_OBJECT_TYPE              ELSE MAP(BI.BASE_OBJECT_TYPE,      '%', 'any', BI.BASE_OBJECT_TYPE)      END BASE_OBJECT_TYPE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'BASE_TEMP')   != 0 THEN D.BASE_OBJECT_IS_TEMPORARY      ELSE 'any'                                                               END BASE_OBJECT_IS_TEMPORARY,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DEP_SCHEMA')  != 0 THEN D.DEPENDENT_SCHEMA_NAME         ELSE MAP(BI.DEPENDENT_SCHEMA_NAME, '%', 'any', BI.DEPENDENT_SCHEMA_NAME) END DEPENDENT_SCHEMA_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DEP_OBJECT')  != 0 THEN D.DEPENDENT_OBJECT_NAME         ELSE MAP(BI.DEPENDENT_OBJECT_NAME, '%', 'any', BI.DEPENDENT_OBJECT_NAME) END DEPENDENT_OBJECT_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DEP_TYPE')    != 0 THEN D.DEPENDENT_OBJECT_TYPE         ELSE MAP(BI.DEPENDENT_OBJECT_TYPE, '%', 'any', BI.DEPENDENT_OBJECT_TYPE) END DEPENDENT_OBJECT_TYPE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DEP_TEMP')    != 0 THEN D.DEPENDENT_OBJECT_IS_TEMPORARY ELSE 'any'                                                               END DEPENDENT_OBJECT_IS_TEMPORARY,
    COUNT(*) CNT,
    BI.ORDER_BY
  FROM
  ( SELECT                                             /* Modification section */
      '%' BASE_SCHEMA_NAME,
      '%' BASE_OBJECT_NAME,
      'TABLE' BASE_OBJECT_TYPE,
      '%' DEPENDENT_SCHEMA_NAME,
      '%' DEPENDENT_OBJECT_NAME,
      '%' DEPENDENT_OBJECT_TYPE,
      ' ' ONLY_TEMPORARY_DEPENDENCIES,
      50000 MIN_OBJECT_COUNT,
      'BASE_SCHEMA, BASE_OBJECT' AGGREGATE_BY,          /* BASE_SCHEMA, BASE_OBJECT, BASE_TYPE, BASE_TEMP, DEP_SCHEMA, DEP_OBJECT, DEP_TYPE, DEP_TEMP or comma separated combination, NONE for no aggregation */
      'COUNT' ORDER_BY                                  /* BASE_NAME, DEP_NAME, COUNT */
    FROM
      DUMMY
  ) BI,
  ( SELECT
      BASE_SCHEMA_NAME,
      BASE_OBJECT_NAME,
      BASE_OBJECT_TYPE,
      ' ' BASE_OBJECT_IS_TEMPORARY,
      DEPENDENT_SCHEMA_NAME,
      DEPENDENT_OBJECT_NAME,
      DEPENDENT_OBJECT_TYPE,
      ' ' DEPENDENT_OBJECT_IS_TEMPORARY
    FROM
      OBJECT_DEPENDENCIES
    UNION ALL
    SELECT
      BASE_SCHEMA_NAME,
      BASE_OBJECT_NAME,
      BASE_OBJECT_TYPE,
      MAP(BASE_OBJECT_IS_TEMPORARY, 'TRUE', 'X', ' ') BASE_OBJECT_NAME_IS_TEMPORARY,
      DEPENDENT_SCHEMA_NAME,
      DEPENDENT_OBJECT_NAME,
      DEPENDENT_OBJECT_TYPE,
      MAP(DEPENDENT_OBJECT_IS_TEMPORARY, 'TRUE', 'X', ' ') DEPENDENT_OBJECT_NAME_IS_TEMPORARY
    FROM
      M_TEMPORARY_OBJECT_DEPENDENCIES
  ) D
  WHERE
    D.BASE_SCHEMA_NAME LIKE BI.BASE_SCHEMA_NAME AND
    D.BASE_OBJECT_NAME LIKE BI.BASE_OBJECT_NAME AND
    D.BASE_OBJECT_TYPE LIKE BI.BASE_OBJECT_TYPE AND
    D.DEPENDENT_SCHEMA_NAME LIKE BI.DEPENDENT_SCHEMA_NAME AND
    D.DEPENDENT_OBJECT_NAME LIKE BI.DEPENDENT_OBJECT_NAME AND
    D.DEPENDENT_OBJECT_TYPE LIKE BI.DEPENDENT_OBJECT_TYPE AND
    ( BI.ONLY_TEMPORARY_DEPENDENCIES = ' ' OR 
      D.BASE_OBJECT_IS_TEMPORARY = 'X' OR
      D.DEPENDENT_OBJECT_IS_TEMPORARY = 'X'
    )
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'BASE_SCHEMA') != 0 THEN D.BASE_SCHEMA_NAME              ELSE MAP(BI.BASE_SCHEMA_NAME,      '%', 'any', BI.BASE_SCHEMA_NAME)      END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'BASE_OBJECT') != 0 THEN D.BASE_OBJECT_NAME              ELSE MAP(BI.BASE_OBJECT_NAME,      '%', 'any', BI.BASE_OBJECT_NAME)      END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'BASE_TYPE')   != 0 THEN D.BASE_OBJECT_TYPE              ELSE MAP(BI.BASE_OBJECT_TYPE,      '%', 'any', BI.BASE_OBJECT_TYPE)      END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'BASE_TEMP')   != 0 THEN D.BASE_OBJECT_IS_TEMPORARY      ELSE 'any'                                                               END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DEP_SCHEMA')  != 0 THEN D.DEPENDENT_SCHEMA_NAME         ELSE MAP(BI.DEPENDENT_SCHEMA_NAME, '%', 'any', BI.DEPENDENT_SCHEMA_NAME) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DEP_OBJECT')  != 0 THEN D.DEPENDENT_OBJECT_NAME         ELSE MAP(BI.DEPENDENT_OBJECT_NAME, '%', 'any', BI.DEPENDENT_OBJECT_NAME) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DEP_TYPE')    != 0 THEN D.DEPENDENT_OBJECT_TYPE         ELSE MAP(BI.DEPENDENT_OBJECT_TYPE, '%', 'any', BI.DEPENDENT_OBJECT_TYPE) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DEP_TEMP')    != 0 THEN D.DEPENDENT_OBJECT_IS_TEMPORARY ELSE 'any'                                                               END,
    BI.ORDER_BY,
    BI.MIN_OBJECT_COUNT
  HAVING
    BI.MIN_OBJECT_COUNT = -1 OR COUNT(*) >= BI.MIN_OBJECT_COUNT
)
ORDER BY
  MAP(ORDER_BY, 'DEP_NAME', DEPENDENT_SCHEMA_NAME || DEPENDENT_OBJECT_NAME || DEPENDENT_OBJECT_TYPE),
  MAP(ORDER_BY, 'COUNT', CNT) DESC,
  BASE_SCHEMA_NAME,
  BASE_OBJECT_NAME,
  BASE_OBJECT_TYPE