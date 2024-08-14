SELECT
/* 

[NAME]

- HANA_SQL_ExplainPlan_1.00.120+

[DESCRIPTION]

- Displays SQL explain plan information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Entries in EXPLAIN_PLAN_TABLE can be session-specific, so the explain plan taken 
  with one session may not be visible in another session
- Explain plans for an existing SQL cache entry can be generated with the following command:

  EXPLAIN PLAN SET STATEMENT_NAME = '<statement_name>' FOR SQL PLAN CACHE ENTRY <plan_id>

- Column OPERATOR_PROPERTIES available starting with SAP HANA 1.0 SPS 12

[VALID FOR]

- Revisions:              >= 1.00.120

[SQL COMMAND VERSION]

- 2014/08/22:  1.0 (initial version)
- 2020/08/03:  1.1 (dedicated 1.00.120+ version including OPERATOR_PROPERTIES)

[INVOLVED TABLES]

- EXPLAIN_PLAN_TABLE

[INPUT PARAMETERS]

- STATEMENT_NAME

  Name specified when explaining statement (EXPLAIN PLAN SET STATEMENT_NAME = '<statement_name>' FOR ...)

  'ZSAP_TEST' -> Display explain plan for statement with statement name 'ZSAP_TEST'
  '%'         -> No restriction for statement name

- OPERATION_LENGTH_LIMIT

  Maximum length of OPERATION column

  80          -> Truncate OPERATION column to a maximum size of 80 characters
  -1          -> No length limitation for OPERATION column

[OUTPUT PARAMETERS]

- STMT_IDENTIFIER: Identifiert for SQL statement (statement name or - if not statement name defined - timestamp of explain)
- LINE_ID:         Line number of the explain plan
- OPERATION:       Explain plan operation
- TABLE_NAME:      Table name
- ESTIMATED_COSTS: Estimated costs for explain plan step (including sub-steps)
- ESTIMATED_ROWS:  Estimated rows
- ENGINE:          Engine used for processing the explain plan operation
- HOST:            Host name on which the explain plan operation is processed

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
|STMT_IDENTIFIER|LINE_ID|OPERATION                                                                   |TABLE_NAME|ESTIMATED_COSTS|ESTIMATED_ROWS|ENGINE|HOST       |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
|ZSAP_TEST      |      1|COLUMN SEARCH AQGQCAT.NUM, AQGQCAT.QNUM, AQGQCAT.CLAS (LATE MATERIALIZATION)|          |        0.05382|      19570.23|COLUMN|           |
|ZSAP_TEST      |      2|  ORDER BY AQGQCAT.QNUM ASC                                                 |          |        0.00265|      19570.23|COLUMN|           |
|ZSAP_TEST      |      3|    COLUMN TABLE FILTER CONDITION: AQGQCAT.NUM = 1                          |AQGQCAT   |        0.00000|      19570.23|COLUMN|saphana01  |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  IFNULL(E.STATEMENT_NAME, TO_VARCHAR(E.TIMESTAMP, 'YYYY/MM/DD HH24:MI:SS')) STMT_IDENTIFIER,
  LPAD(E.OPERATOR_ID, 7) LINE_ID,
  SUBSTR(E.OPERATOR_NAME || 
    CASE WHEN TO_VARCHAR(E.OPERATOR_DETAILS) = '' THEN '' ELSE CHAR(32) || TO_VARCHAR(E.OPERATOR_DETAILS) END, 
    1, MAP(BI.OPERATION_LENGTH_LIMIT, -1, 999, BI.OPERATION_LENGTH_LIMIT)) OPERATION,
  IFNULL(E.TABLE_NAME, '') TABLE_NAME,
  LPAD(TO_DECIMAL(IFNULL(CASE WHEN E.SUBTREE_COST > 999999999 THEN 999999999 ELSE E.SUBTREE_COST END, 0), 10, 5), 15) ESTIMATED_COSTS,
  LPAD(TO_DECIMAL(IFNULL(CASE WHEN E.OUTPUT_SIZE > 99999999999 THEN 99999999999 ELSE E.OUTPUT_SIZE END, 0), 10, 2), 14) ESTIMATED_ROWS,
  E.EXECUTION_ENGINE ENGINE,
  E.OPERATOR_PROPERTIES,
  E.HOST
FROM
( SELECT                  /* Modification section */
    '%' STATEMENT_NAME,
    -1  OPERATION_LENGTH_LIMIT
  FROM
    DUMMY
) BI,
  EXPLAIN_PLAN_TABLE E
WHERE
  IFNULL(E.STATEMENT_NAME, '') LIKE BI.STATEMENT_NAME
ORDER BY
  E.TIMESTAMP DESC,
  E.OPERATOR_ID
