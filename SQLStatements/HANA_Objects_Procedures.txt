SELECT
/* 

[NAME]

- HANA_Objects_Procedures

[DESCRIPTION]

- Overview of SAP HANA procedures

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/09/29:  1.0 (initial version)

[INVOLVED TABLES]

- PROCEDURES

[INPUT PARAMETERS]

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- PROCEDURE_NAME           

  Procedure name or pattern

  'MYPROC'        --> Specific procedure MYPROC
  'T%'            --> All procedures starting with 'T'
  '%'             --> All procedures

- PROCEDURE_TYPE

  Type of procedure (e.g. SQLSCRIPT2, L or R)

  'L'             --> L procedures
  'SQLSCRIPT%'    --> Procedure types starting with 'SQLSCRIPT'
  '%'             --> No restriction related to procedure types

- ONLY_INVALID_PROCEDURES

  Possibility to restrict the result to invalid procedures

  'X'             --> Only show invalid procedures
  ' '             --> No restriction related to procedure validity
  
- GENERATE_SEMICOLON

  Controls the generation of semicolons at the end of the generated SQL statements

  'X'             --> Semicolon is generated
  ' '             --> No semicolon is generated

[OUTPUT PARAMETERS]

- SCHEMA_NAME:       Schema name
- PROCEDURE_NAME:    Procedure name
- PROCEDURE_TYPE:    Procedure type
- VALID:             Validity status
- RECOMPILE_COMMAND: Command for validating the procedure (not valid for SHC where a DROP / CREATE can be used instead)

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME|PROCEDURE_NAME                                            |PROCEDURE_TYPE|VALID|RECOMPILE_COMMAND                                                                                 |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|_SYS_BIC   |OOMAnalysisXS.procedures/Select_CPU_Usage                 |SQLSCRIPT2    |FALSE|ALTER PROCEDURE "_SYS_BIC"."OOMAnalysisXS.procedures/Select_CPU_Usage" RECOMPILE                  |
|_SYS_BIC   |OOMAnalysisXS.procedures/OOM_Analysis                     |SQLSCRIPT2    |FALSE|ALTER PROCEDURE "_SYS_BIC"."OOMAnalysisXS.procedures/OOM_Analysis" RECOMPILE                      |
|_SYS_BIC   |sap.hba.ecc/MfgOrderItmRecQtyToBaseUnitConv/proc          |SQLSCRIPT2    |FALSE|ALTER PROCEDURE "_SYS_BIC"."sap.hba.ecc/MfgOrderItmRecQtyToBaseUnitConv/proc" RECOMPILE           |
|_SYS_BIC   |sap.hba.ecc/MfgOrderItmEntryQtyToBaseUnitConv/proc        |SQLSCRIPT2    |FALSE|ALTER PROCEDURE "_SYS_BIC"."sap.hba.ecc/MfgOrderItmEntryQtyToBaseUnitConv/proc" RECOMPILE         |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  P.SCHEMA_NAME,
  P.PROCEDURE_NAME,
  P.PROCEDURE_TYPE,
  P.IS_VALID VALID,
  'ALTER PROCEDURE' || CHAR(32) || '"' || P.SCHEMA_NAME || '"."' || P.PROCEDURE_NAME || 
    '" RECOMPILE' || MAP(BI.GENERATE_SEMICOLON, 'X', ';', '') RECOMPILE_COMMAND
FROM
( SELECT              /* Modification section */
    '%' SCHEMA_NAME,
    '%' PROCEDURE_NAME,
    '%' PROCEDURE_TYPE,
    'X' ONLY_INVALID_PROCEDURES,
    'X' GENERATE_SEMICOLON
  FROM
    DUMMY
) BI,
  PROCEDURES P
WHERE
  P.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  P.PROCEDURE_NAME LIKE BI.PROCEDURE_NAME AND
  P.PROCEDURE_TYPE LIKE BI.PROCEDURE_TYPE AND
  ( BI.ONLY_INVALID_PROCEDURES = ' ' OR P.IS_VALID = 'FALSE' )
ORDER BY
  P.SCHEMA_NAME,
  P.PROCEDURE_NAME