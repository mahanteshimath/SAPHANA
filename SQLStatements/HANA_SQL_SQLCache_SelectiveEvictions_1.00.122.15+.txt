SELECT

/* 

[NAME]

- HANA_SQL_SQLCache_SelectiveEvictions_1.00.122.15+

[DESCRIPTION]

- Possibility to generate SQL cache eviction commands for defined database requests

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Result of command execution is a SQL statement that has to be executed in order to count the values
- APPLICATION_SOURCE in M_SQL_PLAN_CACHE available starting with Rev. 1.00.122.15 (and 2.00.012.04 / 2.00.024.00)
- See SAP Note 2124112 -> "How can entries in the SQL cache be invalidated or reparsed manually?" for SQL cache evictions details

[VALID FOR]

- Revisions:              >= 1.00.122.15

[SQL COMMAND VERSION]

- 2020/05/15:  1.2 (initial version)

[INVOLVED TABLES]

- M_SQL_PLAN_CACHE

[INPUT PARAMETERS]

- STATEMENT_HASH      
 
  Hash of SQL statement to be analyzed

  '2e960d7535bf4134e2bd26b9d80bd4fa' --> SQL statement with hash '2e960d7535bf4134e2bd26b9d80bd4fa'
  '%'                                --> No statement hash restriction (only possible if hash is not mandatory)

- PLAN_ID

  SQL plan identifier

  12345678        --> SQL plan identifier 12345678
  -1              --> No restriction based on SQL plan identifier

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  '%'             --> All schemata

- TABLE_NAME           

  Table name

  'T000'          --> Specific table T000
  '%'             --> No table name restriction

- APP_SOURCE

  Application source

  'SAPL2:437'     --> Application source 'SAPL2:437'
  'SAPMSSY2%'     --> Application sources starting with SAPMSSY2
  '%'             --> No application source restriction

- MIN_AVG_EXEC_MS

  Minimum threshold for average execution time (ms)

  5               --> Only consider database requests with an average execution time of at least 5 ms
  -1              --> No restriction related to average execution time 

- EVICTION_METHOD

  Eviction method

  'RECOMPILE'     --> ALTER SYSTEM RECOMPILE SQL PLAN CACHE ENTRY
  'REMOVE'        --> ALTER SYSTEM REMOVE SQL PLAN CACHE ENTRY

[OUTPUT PARAMETERS]

- STATEMENT_HASH:       Statement hash
- PLAN_ID:              Execution plan ID
- AVG_EXEC_MS:          Average execution time (ms)
- ACCESSED_TABLE_NAMES: Names of tables accessed by SQL statement
- APP_SOURCE:           Application source
- EVICTION_COMMAND:     Command to be executed to evict the plan ID from the SQL cache

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------------------------------------
|STATEMENT_HASH                  |PLAN_ID      |AVG_EXEC_MS|ACCESSED_TABLE_NAMES|APP_SOURCE    |EVICTION_COMMAND                                         |
----------------------------------------------------------------------------------------------------------------------------------------------------------
|d7c7f25c006e7fa3807079f3acd108ac|   6897430003|       0.23|    SAPSR3.TBTCS(24)|SAPMSSY2:4106 |ALTER SYSTEM RECOMPILE SQL PLAN CACHE ENTRY '6897430003' |
|cb93ebbcdeabcad44b6195ed8b7fb67f|     40850003|       0.22|    SAPSR3.TBTCS(24)|SAPMSSY2:6018 |ALTER SYSTEM RECOMPILE SQL PLAN CACHE ENTRY '40850003'   |
|f0a05f0f389437ffce03eb17a4bbb03c|   6836170003|       0.21|    SAPSR3.TBTCS(24)|SAPMSSY2:850  |ALTER SYSTEM RECOMPILE SQL PLAN CACHE ENTRY '6836170003' |
|b6f643f928037341f4db302783b7b6a3|     42930003|       0.14|    SAPSR3.TBTCS(24)|SAPLBTCH:63859|ALTER SYSTEM RECOMPILE SQL PLAN CACHE ENTRY '42930003'   |
|c1cdf6f4fc659bdd7cc982d1627fa61d|   4792560003|       0.08|    SAPSR3.TBTCS(24)|SAPMSSY2:7197 |ALTER SYSTEM RECOMPILE SQL PLAN CACHE ENTRY '4792560003' |
|26b743fca38c80f0006ab444059eaaae|     40840003|       0.04|    SAPSR3.TBTCS(24)|SAPMSSY2:5721 |ALTER SYSTEM RECOMPILE SQL PLAN CACHE ENTRY '40840003'   |
|26b743fca38c80f0006ab444059eaaae|   4185570004|       0.00|    SAPSR3.TBTCS(24)|SAPLSXBP:18983|ALTER SYSTEM RECOMPILE SQL PLAN CACHE ENTRY '4185570004' |
|c1cdf6f4fc659bdd7cc982d1627fa61d|   4185580004|       0.00|    SAPSR3.TBTCS(24)|SAPLSXBP:19167|ALTER SYSTEM RECOMPILE SQL PLAN CACHE ENTRY '4185580004' |
|d7c7f25c006e7fa3807079f3acd108ac|   4185590004|       0.00|    SAPSR3.TBTCS(24)|SAPLBTCH:32549|ALTER SYSTEM RECOMPILE SQL PLAN CACHE ENTRY '4185590004' |
----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

  S.STATEMENT_HASH,
  LPAD(S.PLAN_ID, 13) PLAN_ID,
  LPAD(TO_DECIMAL(S.AVG_EXECUTION_TIME / 1000, 10, 2), 11) AVG_EXEC_MS,
  S.ACCESSED_TABLE_NAMES,
  S.APPLICATION_SOURCE APP_SOURCE,
  'ALTER SYSTEM' || CHAR(32) || BI.EVICTION_METHOD || CHAR(32) || 'SQL PLAN CACHE ENTRY' || CHAR(32) || CHAR(39) || S.PLAN_ID || CHAR(39) || CHAR(59) EVICTION_COMMAND
FROM
( SELECT                   /* Modification section */
   '%' STATEMENT_HASH,
    -1 PLAN_ID,
    '%' SCHEMA_NAME,
    'TBTCS' TABLE_NAME,
    '%' APP_SOURCE,
    -1 MIN_AVG_EXEC_MS,
    'RECOMPILE' EVICTION_METHOD                 /* RECOMPILE, REMOVE */
  FROM
    DUMMY
) BI,
  M_SQL_PLAN_CACHE S
WHERE
  S.STATEMENT_HASH LIKE BI.STATEMENT_HASH AND
  ( BI.PLAN_ID = -1 OR S.PLAN_ID = BI.PLAN_ID ) AND
  S.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  ( BI.TABLE_NAME = '%' OR S.ACCESSED_TABLE_NAMES LIKE '%.' || BI.TABLE_NAME || '(%' ) AND
  IFNULL(S.APPLICATION_SOURCE, '') LIKE BI.APP_SOURCE AND
  ( BI.MIN_AVG_EXEC_MS = -1 OR S.AVG_EXECUTION_TIME / 1000 >= BI.MIN_AVG_EXEC_MS )
ORDER BY
  S.AVG_EXECUTION_TIME DESC,
  S.STATEMENT_HASH,
  S.PLAN_ID
