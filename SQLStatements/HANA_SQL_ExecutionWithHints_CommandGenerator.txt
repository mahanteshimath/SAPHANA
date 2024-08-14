WITH 

/* 

[NAME]

- HANA_SQL_ExecutionWithHints_CommandGenerator

[DESCRIPTION]

- Generates SELECT statements to be executed with different SQL hints

[SOURCE]

- SAP Note 1969700

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2016/02/18:  1.0 (initial version)

[INVOLVED TABLES]

- HINTS

[INPUT PARAMETERS]

- HINT_NAME

  Name of hint

  'HASH_JOIN'    --> Information related to HASH_JOIN hint
  '%HASH_JOIN'   --> Information related to hints with names ending with 'HASH_JOIN'
  '%'            --> No restriction related to hint name

- SQL_CACHE_TAG

  Arbitrary identifier for uniquely tagging the executed statements (in order to find them again in SQL cache)

  'ZMF'          --> Tag all statements with 'ZMF'

- CLEAR_SQL_CACHE

  Possibility to clear the existing SQL cache to make sure that relics from the past do not infuence the past 

  'X'            --> Invalidate the whole SQL cache before executing the tests (attention: Performance impact!)
  ' '            --> No SQL cache invalidation

- SQL_TEXT

  Text of SQL statement to be executed (no bind variables, multiple lines allowed)

[OUTPUT PARAMETERS]

- COMMAND: SQL commands to be executed

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------
|COMMAND                                                                                                                              |
---------------------------------------------------------------------------------------------------------------------------------------
|SELECT /* ZMF  / 'DOUBLE_PREAGGR_BEFORE_JOIN' HINT_NAME, * FROM ( SELECT * FROM DUMMY  WITH HINT (DOUBLE_PREAGGR_BEFORE_JOIN))       |
|SELECT /* ZMF  / 'NO_DOUBLE_PREAGGR_BEFORE_JOIN' HINT_NAME, * FROM ( SELECT * FROM DUMMY  WITH HINT (NO_DOUBLE_PREAGGR_BEFORE_JOIN)) |
|SELECT /* ZMF  / 'NO_PREAGGR_BEFORE_JOIN' HINT_NAME, * FROM ( SELECT * FROM DUMMY  WITH HINT (NO_PREAGGR_BEFORE_JOIN))               |
|SELECT /* ZMF  / 'NO_PREAGGR_BEFORE_UNION' HINT_NAME, * FROM ( SELECT * FROM DUMMY  WITH HINT (NO_PREAGGR_BEFORE_UNION))             |
|SELECT /* ZMF  / 'NO_REMOTE_PREAGGR' HINT_NAME, * FROM ( SELECT * FROM DUMMY  WITH HINT (NO_REMOTE_PREAGGR))                         |
|SELECT /* ZMF  / 'PREAGGR_BEFORE_JOIN' HINT_NAME, * FROM ( SELECT * FROM DUMMY  WITH HINT (PREAGGR_BEFORE_JOIN))                     |
|SELECT /* ZMF  / 'PREAGGR_BEFORE_UNION' HINT_NAME, * FROM ( SELECT * FROM DUMMY  WITH HINT (PREAGGR_BEFORE_UNION))                   |
|SELECT /* ZMF  / 'REMOTE_PREAGGR' HINT_NAME, * FROM ( SELECT * FROM DUMMY  WITH HINT (REMOTE_PREAGGR))                               |
|SELECT                                                                                                                               |
|  STATEMENT_HASH,                                                                                                                    |
|  SUBSTR(TO_VARCHAR(STATEMENT_STRING), 1, 50) SQL_TEXT,                                                                                 |
|  LPAD(EXECUTION_COUNT, 10) EXECUTIONS,                                                                                              |
|  LPAD(TO_DECIMAL(MAP(EXECUTION_COUNT, 0, 0, TOTAL_RESULT_RECORD_COUNT / EXECUTION_COUNT), 10, 2), 12) REC_PER_EXEC,                 |
|  LPAD(TO_DECIMAL(MAP(EXECUTION_COUNT, 0, 0, TOTAL_EXECUTION_TIME / EXECUTION_COUNT / 1000), 10, 2), 16) TIME_PER_EXEC_MS            |
|FROM                                                                                                                                 |
|  M_SQL_PLAN_CACHE                                                                                                                   |
|WHERE                                                                                                                                |
|  STATEMENT_STRING LIKE 'SELECT /* ZMF%'                                                                                             |
|ORDER BY                                                                                                                             |
|  TO_VARCHAR(STATEMENT_STRING)                                                                                                          |
---------------------------------------------------------------------------------------------------------------------------------------

--> Needs to be executed and returns e.g.:

------------------------------------------------------------------------------------------------------------------------------
|STATEMENT_HASH                  |SQL_TEXT                                          |EXECUTIONS|REC_PER_EXEC|TIME_PER_EXEC_MS|
------------------------------------------------------------------------------------------------------------------------------
|972039b68d8aff2362ed7b0aa42b9d95|SELECT /* ZMF  / 'DOUBLE_PREAGGR_BEFORE_JOIN' HINT|         1|        1.00|            0.05|
|4d36459b875963acaee37a19fcc503cb|SELECT /* ZMF  / 'NO_PREAGGR_BEFORE_UNION' HINT_NA|         1|        1.00|            0.03|
|ac78f3149ac1d43b1d3909e74495eec4|SELECT /* ZMF  / 'NO_REMOTE_PREAGGR' HINT_NAME, * |         1|        1.00|            0.03|
|eb2a4ad0baa3f8df0c1df03ba4bad71c|SELECT /* ZMF  / 'PREAGGR_BEFORE_JOIN' HINT_NAME, |         1|        1.00|            0.04|
|85f9c439aa199f463dccb1d8275c8b67|SELECT /* ZMF  / 'PREAGGR_BEFORE_UNION' HINT_NAME,|         1|        1.00|            0.03|
|e6d1e9b0104376634fc11375b0c6b3fb|SELECT /* ZMF  / 'REMOTE_PREAGGR' HINT_NAME, * FRO|         1|        1.00|            0.03|
------------------------------------------------------------------------------------------------------------------------------

*/

BASIS_INFO AS
( SELECT
    HINT_NAME,
    SQL_CACHE_TAG,
    CLEAR_SQL_CACHE,
    REPLACE(REPLACE(REPLACE(REPLACE(SQL_TEXT, CHAR(10), CHAR(32)), CHAR(13), CHAR(32)), CHAR(32) || CHAR(32), CHAR(32)), CHAR(32) || CHAR(32), CHAR(32)) SQL_TEXT
  FROM
  ( SELECT                /* Modification section */
      '%PREAGGR%' HINT_NAME,
      'ZMF' SQL_CACHE_TAG,
      ' ' CLEAR_SQL_CACHE,
      'SELECT * FROM DUMMY' SQL_TEXT /* use double single quotes rather than single single quotes, do not specify a trailing semi-colon) */
    FROM
      DUMMY
  ) 
)
SELECT 'ALTER SYSTEM CLEAR SQL PLAN CACHE ' COMMAND FROM BASIS_INFO WHERE CLEAR_SQL_CACHE = 'X' UNION ALL
SELECT
  *
FROM
( SELECT
    'SELECT /*' || CHAR(32) || SQL_CACHE_TAG || CHAR(32) || '*/' || CHAR(32) || CHAR(39) || H.HINT_NAME || CHAR(39) || CHAR(32) || 'HINT_NAME, * FROM (' || 
      BI.SQL_TEXT || CHAR(32) || 'WITH HINT (' || H.HINT_NAME || ')) ' COMMAND
  FROM
    BASIS_INFO BI,
    HINTS H
  WHERE
    H.HINT_NAME LIKE BI.HINT_NAME
  ORDER BY
    H.HINT_NAME
)
UNION ALL
SELECT 'SELECT'                                                                                                                    FROM DUMMY      UNION ALL
SELECT '  STATEMENT_HASH,'                                                                                                         FROM DUMMY      UNION ALL
SELECT '  SUBSTR(TO_VARCHAR(STATEMENT_STRING), 1, 50) SQL_TEXT,'                                                                      FROM DUMMY      UNION ALL
SELECT '  LPAD(EXECUTION_COUNT, 10) EXECUTIONS,'                                                                                   FROM DUMMY      UNION ALL
SELECT '  LPAD(TO_DECIMAL(MAP(EXECUTION_COUNT, 0, 0, TOTAL_RESULT_RECORD_COUNT / EXECUTION_COUNT), 10, 2), 12) REC_PER_EXEC,'      FROM DUMMY      UNION ALL
SELECT '  LPAD(TO_DECIMAL(MAP(EXECUTION_COUNT, 0, 0, TOTAL_EXECUTION_TIME / EXECUTION_COUNT / 1000), 10, 2), 16) TIME_PER_EXEC_MS' FROM DUMMY      UNION ALL
SELECT 'FROM'                                                                                                                      FROM DUMMY      UNION ALL
SELECT '  M_SQL_PLAN_CACHE'                                                                                                        FROM DUMMY      UNION ALL
SELECT 'WHERE'                                                                                                                     FROM DUMMY      UNION ALL
SELECT '  STATEMENT_STRING LIKE' || CHAR(32) || CHAR(39) || 'SELECT /*' || CHAR(32) || SQL_CACHE_TAG || '%' || CHAR(39)            FROM BASIS_INFO UNION ALL
SELECT 'ORDER BY'                                                                                                                  FROM DUMMY      UNION ALL
SELECT '  TO_VARCHAR(STATEMENT_STRING) '                                                                                              FROM DUMMY      