SELECT
/* 

[NAME]

- HANA_Memory_PlanningEngine_Cleanup_2.00.036+

[DESCRIPTION]

- Generates cleanup commands for no longer required planning engine runtime objects
- Objects with OBJECT_SCOPE = GLOBAL are not bound to a specific session and are typically retained permanently
- Accessing M_PLE_RUNTIME_OBJECTS can result in a crash with SAP HANA <= 2.00.047 when certain FOX functionality is active in parallel (SAP Note 2937241)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              >= 2.00.036

[SQL COMMAND VERSION]

- 2015/05/12:  1.0 (initial version)
- 2018/12/01:  1.1 (OBJECT_SCOPE filter included instead of fix 'SESSION GROUP' filtering)
- 2019/11/27:  1.2 (dedicated public version)

[INVOLVED TABLES]

- M_PLE_RUNTIME_OBJECTS
- M_PLE_SESSIONS

[INPUT PARAMETERS]

- HOST

  Host name

  'saphana01'     --> Specic host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- PORT

  Port number

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- OBJECT_SCOPE

  Object scope

  'SESSION GROUP' --> Only consider sessions with object scope SESSION GROUP
  'GLOBAL'        --> Only consider sessions with object scoope GLOBAL
  '%'             --> No restriction related to object scope

- MIN_MEM_SIZE_MB

  Minimum memory size of planning engine runtime object (MB)

  5               --> Only consider runtime objects with at least 5 MB of memory size
  -1              --> No restriction related to runtime object memory size

[OUTPUT PARAMETERS]

- COMMAND: Cleanup command for no longer required planning engine runtime objects

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------------
|COMMAND                                                                                                                         |
----------------------------------------------------------------------------------------------------------------------------------
|ALTER PLANNING SESSION "ADMIN" WITH PARAMETERS ('action'='drop_runtime_object', 'object'='0017A47728201ED4B6A6588FD4D099CF...   |
|ALTER PLANNING SESSION "ADMIN" WITH PARAMETERS ('action'='drop_runtime_object', 'object'='0017A47728201ED4B7A1706307F4C77E...   |
|ALTER PLANNING SESSION "ADMIN" WITH PARAMETERS ('action'='drop_runtime_object', 'object'='0017A47728201ED4BA946841829E9139...   |
|ALTER PLANNING SESSION "ADMIN" WITH PARAMETERS ('action'='drop_runtime_object', 'object'='0017A47728201ED4B7B4712A0F85860D...   |
|ALTER PLANNING SESSION "ADMIN" WITH PARAMETERS ('action'='drop_runtime_object', 'object'='0017A47728201EE4BCA8E5F56BB875C6...   |
|ALTER PLANNING SESSION "ADMIN" WITH PARAMETERS ('action'='drop_runtime_object', 'object'='0017A47728201ED4B7A351C1C9ACEDBB...   |
|ALTER PLANNING SESSION "ADMIN" WITH PARAMETERS ('action'='drop_runtime_object', 'object'='0017A47728201EE4BCA904385CCFB71E...   |
|ALTER PLANNING SESSION "ADMIN" WITH PARAMETERS ('action'='drop_runtime_object', 'object'='0017A47728201ED4B7F2B1FCA5FEFB05...   |
|ALTER PLANNING SESSION "ADMIN" WITH PARAMETERS ('action'='drop_runtime_object', 'object'='0017A47728201ED4B7F2B1FCA5FEFB05...   |
|ALTER PLANNING SESSION "ADMIN" WITH PARAMETERS ('action'='drop_runtime_object', 'object'='0017A47728201ED4B7F3A7224E427E8E...   |
|ALTER PLANNING SESSION "ADMIN" WITH PARAMETERS ('action'='drop_runtime_object', 'object'='0017A47728201ED4B7813FAA2E39F89D...   |
|ALTER PLANNING SESSION "ADMIN" WITH PARAMETERS ('action'='drop_runtime_object', 'object'='0017A47728201ED4B7F3A7224E427E8E...   |
----------------------------------------------------------------------------------------------------------------------------------

*/

  'ALTER PLANNING SESSION "ADMIN" WITH PARAMETERS (' || CHAR(39) || 'action' || CHAR(39) || '=' || CHAR(39) || 'drop_runtime_object' || CHAR(39) || ',' || CHAR(32) || CHAR(39) || 'object' || CHAR(39) || 
    '=' || CHAR(39) || P.OBJECT_NAME || CHAR(39) || ',' || CHAR(32) || CHAR(39) || 'host' || CHAR(39) || '=' || CHAR(39) || P.HOST || CHAR(39) || ',' || CHAR(32) || CHAR(39) || 'port' || CHAR(39) || 
    '=' || CHAR(39) || P.PORT || CHAR(39) || ')' || CHAR(59) COMMAND
FROM
( SELECT                 /* Modification section */
    '%' HOST,
    '%' PORT,
    'SESSION GROUP' OBJECT_SCOPE,                 /* e.g. SESSION GROUP, GLOBAL */
    1 MIN_MEM_SIZE_MB
  FROM
    DUMMY
) BI,
  SYS.M_PLE_RUNTIME_OBJECTS P
WHERE
  P.HOST LIKE BI.HOST AND
  TO_VARCHAR(P.PORT) LIKE BI.PORT AND
  P.OBJECT_SCOPE LIKE BI.OBJECT_SCOPE AND
  ( BI.MIN_MEM_SIZE_MB = -1 OR P.MEMORY_SIZE / 1024 / 1024 >= BI.MIN_MEM_SIZE_MB ) AND
  SUBSTR(P.OBJECT_NAME, 1, 32) NOT IN
  ( SELECT
      SESSION_GROUP_NAME
    FROM
      SYS.M_PLE_SESSIONS
  )
