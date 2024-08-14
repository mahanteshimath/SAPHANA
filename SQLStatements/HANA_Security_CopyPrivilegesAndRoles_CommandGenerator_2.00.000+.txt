WITH 
/* 

[NAME]

- HANA_Security_CopyPrivilegesAndRoles_CommandGenerator_2.00.000+

[DESCRIPTION]

- Generates SQL commands that can be used to grant roles and privileges assigned to one user to another user or role

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- WITH clause requires at least Rev. 1.00.70
- WITH clause does not work with older DBACOCKPIT transactions before SAP BASIS 7.02 SP16 / 7.30 SP12 / 7.31 SP12 / SAP_BASIS 7.40 SP07 (empty result returned) 
- Generated commands will only work when executed with a user having CATALOG READ and GRANT option for all privileges
- ROLE_SCHEMA_NAME available starting with SAP HANA 2.00.000
- Output should be checked before it is executed (e.g. filtering of relevant privileges)
- GRANT_ACTIVATED_ROLE fails with error "389: invalid role name" in case of schema-specific roles (ROLE_SCHEMA_NAME filled), this is a known restriction
- See SAP Note 2621987 ("Copy user with system privileges and objects privileges") for more information about copying a SAP HANA user.

[VALID FOR]

- Revisions:              >= 2.00.000

[SQL COMMAND VERSION]

- 2015/09/13:  1.0 (initial version)
- 2016/06/05:  1.1 (GRANT_ACTIVATED_ROLE included)
- 2018/06/11:  1.2 (dedicated 2.00.000+ version

[INVOLVED TABLES]

- GRANTED_PRIVILEGES
- GRANTED_ROLES

[INPUT PARAMETERS]

- SOURCE_GRANTEE

  User or role whose privileges and roles should be copied

  'SAPSR3'        --> Copy privileges and roles of user SAPSR3
  'DBA_COCKPIT'   --> Copy privileges and roles of role DBA_COCKPIT

- TARGET_GRANTEE

  User or role to which the roles and privileges should be granted

  'SAPSR3'        --> Grant privileges and roles to user SAPSR3
  'MY_NEW_ROLE'   --> Grant privileges and roles to role MY_NEW_ROLE

- GRANT_ROLES

  Generate commands for granting roles

  'X'             --> Commands for granting roles are generated
  ' '             --> No commands for granting roles are generated

- GRANT_PRIVILEGES

  Generate commands for granting privileges

  'X'             --> Commands for granting privileges are generated
  ' '             --> No commands for granting privileges are generated

[OUTPUT PARAMETERS]

- COMMAND: GRANT commands

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------
|COMMAND                                                                          |
-----------------------------------------------------------------------------------
|GRANT EXECUTE ON "_SYS_REPO"."GRANT_ACTIVATED_ROLE" TO "ZMF_ROLE"                |
|GRANT EXECUTE ON "SYS"."ASYNC_TABLE_REPL_COMMAND_DEV" TO "ZMF_ROLE"              |
|GRANT EXECUTE ON "SYS"."GET_FULL_SYSTEM_INFO_DUMP_WITH_PARAMETERS" TO "ZMF_ROLE" |
|GRANT EXECUTE ON "SYS"."UPDATE_LANDSCAPE_CONFIGURATION" TO "ZMF_ROLE"            |
|GRANT EXECUTE ON "SYS"."EXECUTE_CE_RUNTIME_MODEL" TO "ZMF_ROLE"                  |
|GRANT SELECT ON "_SYS_EPM"."VERSIONS" TO "ZMF_ROLE"                              |
|GRANT SELECT ON "_SYS_EPM"."SAVED_CONTAINERS" TO "ZMF_ROLE"                      |
|GRANT SELECT ON "_SYS_EPM"."TEMPORARY_CONTAINERS" TO "ZMF_ROLE"                  |
|GRANT EXECUTE ON "SYS"."CHECK_CALCENGINE" TO "ZMF_ROLE"                          |
|GRANT EXECUTE ON "SYS"."TREXVIADBSLWITHPARAMETER" TO "ZMF_ROLE"                  |
|GRANT EXECUTE ON "SYS"."DEBUG" TO "ZMF_ROLE"                                     |
|GRANT EXECUTE ON "SYS"."CHECK_CALCULATION_MODEL" TO "ZMF_ROLE"                   |
|GRANT EXECUTE ON "SYS"."EXECUTE_SEARCH_RULE_SET" TO "ZMF_ROLE"                   |
|GRANT EXECUTE ON "SYS"."BASKETANALYSIS" TO "ZMF_ROLE"                            |
|GRANT EXECUTE ON "SYS"."PIN_TABLE" TO "ZMF_ROLE"                                 |
-----------------------------------------------------------------------------------

*/

BASIS_INFO AS
( SELECT                  /* Modification section */
    'sap.hana.xs.ide.roles::TraceViewer' SOURCE_GRANTEE,
    'ZMF' TARGET_GRANTEE,
    'X' GRANT_ROLES,
    'X' GRANT_PRIVILEGES
  FROM
    DUMMY
)
SELECT
  'GRANT' || CHAR(32) || P.PRIVILEGE || CHAR(32) || 'ON "' || P.SCHEMA_NAME || '"."' || P.OBJECT_NAME || '" TO "' || BI.TARGET_GRANTEE || '";' COMMAND
FROM
  BASIS_INFO BI,
  GRANTED_PRIVILEGES P
WHERE
  P.GRANTEE = BI.SOURCE_GRANTEE AND
  BI.GRANT_ROLES = 'X' AND
  P.IS_GRANTABLE = 'TRUE' AND
  P.SCHEMA_NAME IS NOT NULL AND 
  P.OBJECT_NAME IS NOT NULL AND
  ( P.PRIVILEGE NOT IN ('INSERT', 'UPDATE', 'DELETE') OR P.SCHEMA_NAME NOT IN ( 'SYS', '_SYS_AUDIT' ) )
UNION ALL
( SELECT
    'GRANT' || CHAR(32) || P.PRIVILEGE || CHAR(32) || 'ON "' || P.OBJECT_NAME || '" TO "' || BI.TARGET_GRANTEE || '";' COMMAND
  FROM
    BASIS_INFO BI,
    GRANTED_PRIVILEGES P
  WHERE
    P.GRANTEE = BI.SOURCE_GRANTEE AND
    BI.GRANT_ROLES = 'X' AND
    P.IS_GRANTABLE = 'TRUE' AND
    P.SCHEMA_NAME IS NULL AND 
    P.OBJECT_NAME IS NOT NULL
)
UNION ALL
( SELECT
    'GRANT' || CHAR(32) || P.PRIVILEGE || CHAR(32) || 'ON SCHEMA "' || P.SCHEMA_NAME || '" TO "' || BI.TARGET_GRANTEE || '";' COMMAND
  FROM
    BASIS_INFO BI,
    GRANTED_PRIVILEGES P
  WHERE
    P.GRANTEE = BI.SOURCE_GRANTEE AND
    BI.GRANT_ROLES = 'X' AND
    P.IS_GRANTABLE = 'TRUE' AND
    P.SCHEMA_NAME IS NOT NULL AND 
    P.OBJECT_NAME IS NULL
)
UNION ALL
( SELECT
    CASE GRANTOR
      WHEN '_SYS_REPO' THEN 'CALL _SYS_REPO.GRANT_ACTIVATED_ROLE(' || CHAR(39) || R.ROLE_NAME || CHAR(39) || ',' || CHAR(32) || 
        CHAR(39) || BI.TARGET_GRANTEE || CHAR(39) || ');' 
      ELSE 'GRANT' || CHAR(32) || MAP(R.ROLE_SCHEMA_NAME, NULL, '', '"' || R.ROLE_SCHEMA_NAME || '".') || R.ROLE_NAME || CHAR(32) || 'TO "' || BI.TARGET_GRANTEE || '";'
    END COMMAND
  FROM
    BASIS_INFO BI,
    GRANTED_ROLES R
  WHERE
    R.GRANTEE = BI.SOURCE_GRANTEE AND
    BI.GRANT_PRIVILEGES = 'X' AND
    R.IS_GRANTABLE = 'TRUE'
)
