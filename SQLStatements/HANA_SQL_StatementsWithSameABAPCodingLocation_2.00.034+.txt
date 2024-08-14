SELECT
/* 

[NAME]

- HANA_SQL_StatementsWithSameABAPCodingLocation_2.00.034+

[DESCRIPTION]

- Display different SQL statements originating from the same specified ABAP coding location

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- It is common that the same ABAP coding location generates different SQL statements based on user input or technical aspects
- Starting with SAP HANA 2.00.034 the APPLICATION_SOURCE column is available on both M_SQL_PLAN_CACHE and HOST_SQL_PLAN_CACHE,
  so an indirect join via M_PREPARED_STATEMENTS is no longe required

[VALID FOR]

- Revisions:              >= 2.00.034

[SQL COMMAND VERSION]

- 2015/04/15:  1.0 (initial version)
- 2020/11/23:  1.1 (dedicated 2.00.034+ version with direct APPLICATION_SOURCE retrieval from SQL cache)
- 2021/04/13:  1.2 (TIME_PER_REC_MS added)

[INVOLVED TABLES]

- M_PREPARED_STATEMENTS
- M_SQL_PLAN_CACHE

[INPUT PARAMETERS]

- APPLICATION_SOURCE

  Application source

  'SAPLBTCH:7556' --> List SQL statements originating from application source SAPLBTCH:7556
  '%'             --> No restriction related to application source (configure STATEMENT_HASH instead)

- STATEMENT_HASH      
 
  Hash of SQL statement to be analyzed

  'e62ae4d267c59864b78f7ca66e5f8357' --> Statement hash e62ae4d267c59864b78f7ca66e5f8357
  '%'                                --> no restriction related to statement hash (configure APPLICATION_SOURCE instead)

  
[OUTPUT PARAMETERS]

- APPLICATION_SOURCE: Application source
- STATEMENT_HASH:     Statement hash
- EXECUTIONS:         Number of executions
- TIME_PER_EXEC_MS:   Average time per execution (ms)
- REC_PER_EXEC:       Average number of records per execution
- TIME_PER_REC_MS:    Average time per record (ms)
- STATEMENT_STRING:   SQL text

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|APPLICATION_SOURCE                 |STATEMENT_HASH                  |EXECUTIONS|TIME_PER_EXEC_MS|REC_PER_EXEC|STATEMENT_STRING                                                                                                                                                                                                                                               |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|ZCL_IM_CR_BM0063==============CP:86|e62ae4d267c59864b78f7ca66e5f8357|      1997|        18995.95|  3156605.32|SELECT "BUT000" . "PARTNER" , "BUT000" . "PARTNER_GUID" FROM "BUT000" INNER JOIN "DFKKBPTAXNUM" ON "BUT000" . "CLIENT" = "DFKKBPTAXNUM" . "CLIENT" AND "BUT000" . "PARTNER" = "DFKKBPTAXNUM" . "PARTNER" WHERE "BUT000" . "CLIENT" = X                         |
|ZCL_IM_CR_BM0063==============CP:86|5f507d6a731db1022700846a0d1f5c75|    382640|            3.05|        0.84|SELECT "BUT000" . "PARTNER" , "BUT000" . "PARTNER_GUID" FROM "BUT000" INNER JOIN "DFKKBPTAXNUM" ON "BUT000" . "CLIENT" = "DFKKBPTAXNUM" . "CLIENT" AND "BUT000" . "PARTNER" = "DFKKBPTAXNUM" . "PARTNER" WHERE "BUT000" . "CLIENT" = X AND "DFKKBPTAXNUM" . "T"|
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  APPLICATION_SOURCE,
  STATEMENT_HASH,
  LPAD(SUM(EXECUTIONS), 10) EXECUTIONS,
  LPAD(TO_DECIMAL(MAP(SUM(EXECUTIONS), 0, 0, SUM(EXEC_MS) / SUM(EXECUTIONS)), 10, 2), 16) TIME_PER_EXEC_MS,
  LPAD(TO_DECIMAL(MAP(SUM(EXECUTIONS), 0, 0, SUM(RECORDS) / SUM(EXECUTIONS)), 10, 2), 12) REC_PER_EXEC,
  LPAD(TO_DECIMAL(MAP(GREATEST(SUM(RECORDS), SUM(EXECUTIONS)), 0, 0, SUM(EXEC_MS) / GREATEST(SUM(RECORDS), SUM(EXECUTIONS))), 10, 2), 15) TIME_PER_REC_MS,
  STATEMENT_STRING
FROM
( SELECT
    C.APPLICATION_SOURCE,
    C.STATEMENT_HASH,
    IFNULL(C.EXECUTION_COUNT, 0) EXECUTIONS,
    IFNULL(C.TOTAL_EXECUTION_TIME / 1000, 0) EXEC_MS,
    IFNULL(C.TOTAL_RESULT_RECORD_COUNT, 0) RECORDS,
    C.STATEMENT_STRING
  FROM
  ( SELECT
      CASE WHEN APPLICATION_SOURCE = '%' THEN APPLICATION_SOURCE_DERIVED ELSE APPLICATION_SOURCE END APPLICATION_SOURCE
    FROM
    ( SELECT
        APPLICATION_SOURCE,
        ( SELECT MAX(APPLICATION_SOURCE) FROM
          ( SELECT MAX(APPLICATION_SOURCE) APPLICATION_SOURCE FROM M_SQL_PLAN_CACHE C WHERE C.STATEMENT_HASH = BI.STATEMENT_HASH UNION ALL
            SELECT MAX(APPLICATION_SOURCE) APPLICATION_SOURCE FROM _SYS_STATISTICS.HOST_SQL_PLAN_CACHE C WHERE C.STATEMENT_HASH = BI.STATEMENT_HASH
          )
        ) APPLICATION_SOURCE_DERIVED 
      FROM
      ( SELECT               /* Modification section */
          'SAPFM06L:21498' APPLICATION_SOURCE,
          '%' STATEMENT_HASH
        FROM
          DUMMY
      ) BI
    )
  ) BI,
  ( SELECT
      APPLICATION_SOURCE,
      STATEMENT_HASH,
      EXECUTION_COUNT,
      TOTAL_EXECUTION_TIME,
      TOTAL_RESULT_RECORD_COUNT,
      TO_VARCHAR(STATEMENT_STRING) STATEMENT_STRING
    FROM
      M_SQL_PLAN_CACHE
    UNION ALL
    SELECT
      APPLICATION_SOURCE,
      STATEMENT_HASH,
      EXECUTION_COUNT,
      TOTAL_EXECUTION_TIME,
      TOTAL_RESULT_RECORD_COUNT,
      TO_VARCHAR(STATEMENT_STRING) STATEMENT_STRING
    FROM
      _SYS_STATISTICS.HOST_SQL_PLAN_CACHE
  ) C
WHERE
  C.APPLICATION_SOURCE = BI.APPLICATION_SOURCE
)
GROUP BY
  APPLICATION_SOURCE,
  STATEMENT_HASH,
  STATEMENT_STRING