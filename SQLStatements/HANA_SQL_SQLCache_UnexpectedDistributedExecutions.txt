SELECT

/* 

[NAME]

- HANA_SQL_SQLCache_UnexpectedDistributedExecutions

[DESCRIPTION]

- Overview of single table accesses that are executed from a remote host

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Statement routing should normally make sure that tables are accessed locally (SAP Note 2200772)

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2018/12/12:  1.0 (initial version)
- 2019/03/28:  1.1 (AGGREGATE_BY included)

[INVOLVED TABLES]

- M_SQL_PLAN_CACHE

[INPUT PARAMETERS]

- EXECUTION_HOST

  Host name of statement execution

  'saphana01'     --> Specic host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- EXECUTION_PORT

  Port number of statement execution

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- TABLE_HOST

  Name of host where accessed table is located

  'saphana01'     --> Specic host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- TABLE_PORT

  Port number where accessed table is located

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- TABLE_NAME

  Table name pattern (for ACCESSED_TABLE_NAMES value)

  '%BSEG%'        --> Entries with ACCESSED_TABLE_NAMES containing 'BSEG'
  '%'             --> No restriction related to table names

- STATEMENT_HASH      
 
  Hash of SQL statement to be analyzed

  '2e960d7535bf4134e2bd26b9d80bd4fa' --> SQL statement with hash '2e960d7535bf4134e2bd26b9d80bd4fa'
  '%'                                --> No statement hash restriction (only possible if hash is not mandatory)

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'EXEC_HOST'     --> Aggregation by execution host
  'NONE'          --> No aggregation

-[OUTPUT PARAMETERS]

- EXECUTION_HOST: Host where statement is executed
- EXECUTION_PORT: Port where statement is executed
- TABLE_HOST:     Host where table is located
- TABLE_PORT:     Port where table is located
- TABLE_NAME:     Name of accessed table
- STATEMENT_HASH: Statement hash
- COUNT:          Number of statements

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------
|EXECUTION_HOST|EXECUTION_PORT|TABLE_HOST|TABLE_PORT|TABLE_NAME                  |STATEMENT_HASH                  |
-------------------------------------------------------------------------------------------------------------------
|saphana01     |38003         |saphana03 |38003     |SAPPRD.RSPCLOGCHAIN(25)     |5c6e14ce898801f511f60aefe739b6b8|
|saphana01     |38003         |saphana03 |38003     |SAPPRD./GRCPI/GRIAFFOBT(20) |1a7b8fd094759956b2f611b350b3e496|
|saphana01     |38003         |saphana03 |38003     |SAPPRD./GRCPI/GRIAFFUSR(26) |3f93517dcd016eb25a67053b2e784cab|
|saphana01     |38003         |saphana03 |38003     |SAPPRD.AGR_USERS(31)        |907bc4b7c033e8ad8e1bccf2e8ebcd58|
|saphana01     |38003         |saphana03 |38003     |SAPPRD.AGR_USERS(31)        |5f143587a8f12c0f76f77099864939c9|
|saphana01     |38003         |saphana03 |38003     |SAPPRD./GRCPI/GRIARCODE(21) |2da4a0ca577154a30fdad8878c8b3ac3|
|saphana01     |38003         |saphana03 |38003     |SAPPRD.TSPOPTIONS(3)        |09ccd6fe24315b810fd66e81bc1a4236|
|saphana02     |38003         |saphana03 |38003     |SAPPRD.SECURITY_CONTEXT(35) |53267c4a4b9fadfc06f105efc4693cbb|
|saphana02     |38003         |saphana03 |38003     |SAPPRD.SECURITY_CONTEXT(35) |7bf9f988c36efb2c1bddd04332ebcab2|
|saphana01     |38003         |saphana03 |38003     |SAPPRD.TSP02(58)            |5bd64d6f3ab2e01458bafd0693a4d331|
-------------------------------------------------------------------------------------------------------------------

*/

  EXECUTION_HOST,
  LPAD(EXECUTION_PORT, 5) EXECUTION_PORT,
  TABLE_HOST,
  TABLE_PORT,
  TABLE_NAME,
  STATEMENT_HASH,
  LPAD(COUNT, 7) COUNT
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'EXEC_HOST')  != 0 THEN SP.EXECUTION_HOST ELSE MAP(BI.EXECUTION_HOST, '%', 'any', BI.EXECUTION_HOST) END EXECUTION_HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'EXEC_PORT')  != 0 THEN SP.EXECUTION_PORT ELSE MAP(BI.EXECUTION_PORT, '%', 'any', BI.EXECUTION_PORT) END EXECUTION_PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE_HOST') != 0 THEN SP.TABLE_HOST     ELSE MAP(BI.TABLE_HOST,     '%', 'any', BI.TABLE_HOST)     END TABLE_HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE_PORT') != 0 THEN SP.TABLE_PORT     ELSE MAP(BI.TABLE_PORT,     '%', 'any', BI.TABLE_PORT)     END TABLE_PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE_NAME') != 0 THEN SP.TABLE_NAME     ELSE MAP(BI.TABLE_NAME,     '%', 'any', BI.TABLE_NAME)     END TABLE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HASH')       != 0 THEN SP.STATEMENT_HASH ELSE MAP(BI.STATEMENT_HASH, '%', 'any', BI.STATEMENT_HASH) END STATEMENT_HASH,
    COUNT(*) COUNT
  FROM
  ( SELECT               /* Modification section */
      '%' EXECUTION_HOST,
      '%' EXECUTION_PORT,
      '%' TABLE_HOST,
      '%' TABLE_PORT,
      '%' TABLE_NAME,
      '%' STATEMENT_HASH,
      'EXEC_HOST, EXEC_PORT, TABLE_HOST, TABLE_PORT' AGGREGATE_BY                       /* EXEC_HOST, EXEC_PORT, TABLE_HOST, TABLE_PORT, TABLE_NAME, HASH or comma separated combinations, NONE for no aggregation */
    FROM
      DUMMY
  ) BI,
  ( SELECT
      HOST EXECUTION_HOST,
      TO_VARCHAR(PORT) EXECUTION_PORT,
      SUBSTR(TABLE_LOCATIONS, 2, LOCATE(TABLE_LOCATIONS, ':', 1, 1) - 2) TABLE_HOST,
      LPAD(SUBSTR(TABLE_LOCATIONS, LOCATE(TABLE_LOCATIONS, ':', 1, 1) + 1, LOCATE(TABLE_LOCATIONS, ',', 1, 1) - LOCATE(TABLE_LOCATIONS, ':', 1, 1) - 1), 5) TABLE_PORT,
      TO_VARCHAR(ACCESSED_TABLE_NAMES) TABLE_NAME,
      STATEMENT_HASH
    FROM
      M_SQL_PLAN_CACHE
    WHERE
      TABLE_LOCATIONS NOT LIKE '%), (%' AND
      TABLE_LOCATIONS != '' AND
      IS_DISTRIBUTED_EXECUTION = 'TRUE' AND
      IS_INTERNAL = 'FALSE' AND
      EXECUTION_COUNT > 0 AND
      SUBSTR(TABLE_LOCATIONS, 2) NOT LIKE HOST || '%' AND
      ACCESSED_TABLE_NAMES NOT LIKE '%SYS.%' AND
      IS_VALID = 'TRUE'
  ) SP
  WHERE
      SP.EXECUTION_HOST LIKE BI.EXECUTION_HOST AND
      TO_VARCHAR(SP.EXECUTION_PORT) LIKE BI.EXECUTION_PORT AND
      SP.TABLE_NAME LIKE BI.TABLE_NAME AND
      SP.STATEMENT_HASH LIKE BI.STATEMENT_HASH AND
      SP.TABLE_HOST LIKE BI.TABLE_HOST AND
      SP.TABLE_PORT LIKE BI.TABLE_PORT
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'EXEC_HOST')  != 0 THEN SP.EXECUTION_HOST ELSE MAP(BI.EXECUTION_HOST, '%', 'any', BI.EXECUTION_HOST) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'EXEC_PORT')  != 0 THEN SP.EXECUTION_PORT ELSE MAP(BI.EXECUTION_PORT, '%', 'any', BI.EXECUTION_PORT) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE_HOST') != 0 THEN SP.TABLE_HOST     ELSE MAP(BI.TABLE_HOST,     '%', 'any', BI.TABLE_HOST)     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE_PORT') != 0 THEN SP.TABLE_PORT     ELSE MAP(BI.TABLE_PORT,     '%', 'any', BI.TABLE_PORT)     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE_NAME') != 0 THEN SP.TABLE_NAME     ELSE MAP(BI.TABLE_NAME,     '%', 'any', BI.TABLE_NAME)     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HASH')       != 0 THEN SP.STATEMENT_HASH ELSE MAP(BI.STATEMENT_HASH, '%', 'any', BI.STATEMENT_HASH) END
)
ORDER BY
  1, 2, 3