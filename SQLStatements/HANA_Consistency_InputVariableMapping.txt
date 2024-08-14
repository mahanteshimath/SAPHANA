SELECT

/* 

[NAME]

- HANA_Consistency_InputVariableMapping

[DESCRIPTION]

- Check input variables of stacked calculation scenarios not adequately mapped

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Related to SAP Note 2525644 ("Input Variables are set to an Empty String When not Mapped in Top-Level Calculation Scenario")

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2017/12/16:  1.0 (initial version)

[INVOLVED TABLES]

- BIMC_ALL_CUBES
- BIMC_VARIABLE_ASSIGNMENT
- BIMC_VARIABLE
- OBJECT_DEPENDENCIES

[INPUT PARAMETERS]


[OUTPUT PARAMETERS]

- CONSUMED_VIEW:   Consumed calculation view
- INPUT_PARAMETER: Input parameter with inadequate mapping
- CONSUMING_VIEW:  Consuming calculation view

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------
|CONSUMED_VIEW                                     |INPUT_PARAMETER|CONSUMING_VIEW                                                  |
-------------------------------------------------------------------------------------------------------------------------------------
|system-local.private.inputParameters::CHECKMAPPING|ipMandUnmapped |system-local.private.D012345.inputParameters::CONSUMECHECKMAPPIN|
-------------------------------------------------------------------------------------------------------------------------------------

*/

  V.QUALIFIED_NAME CONSUMED_VIEW,
  V.VARIABLE_NAME INPUT_PARAMETER,
  C.QUALIFIED_NAME CONSUMING_VIEW
FROM
  _SYS_BI.BIMC_VARIABLE V,
  OBJECT_DEPENDENCIES D,
  _SYS_BI.BIMC_ALL_CUBES C,
  _SYS_BI.BIMC_VARIABLE_ASSIGNMENT A
WHERE
  V.SCHEMA_NAME = D.BASE_SCHEMA_NAME AND
  REPLACE(V.QUALIFIED_NAME, '/', '::') = REPLACE(D.BASE_OBJECT_NAME, '/', '::') AND
  D.DEPENDENT_SCHEMA_NAME = C.SCHEMA_NAME AND
  REPLACE(D.DEPENDENT_OBJECT_NAME, '/', '::') = REPLACE(C.QUALIFIED_NAME, '/', '::') AND
  D.BASE_SCHEMA_NAME = A.SCHEMA_NAME AND
  REPLACE(D.BASE_OBJECT_NAME, '/', '::') = REPLACE(A.QUALIFIED_NAME, '/', '::') AND
  V.VARIABLE_NAME = A.VARIABLE_NAME AND
  A.PLACEHOLDER_NAME IS NOT NULL AND
  V.MANDATORY = '1' AND
  V.DEFAULT_VALUE = '' AND
  D.DEPENDENCY_TYPE = 1 AND
  D.DEPENDENT_OBJECT_TYPE='VIEW' AND 
  NOT EXISTS 
  ( SELECT 
      * 
    FROM
      _SYS_BI.BIMC_VARIABLE_ASSIGNMENT A2
    WHERE
      D.DEPENDENT_SCHEMA_NAME = A2.SCHEMA_NAME AND
      REPLACE(D.DEPENDENT_OBJECT_NAME, '/', '::') = REPLACE(A2.QUALIFIED_NAME, '/', '::') AND
      A2.MODEL_ELEMENT_NAME LIKE '%.' || V.VARIABLE_NAME
  )
