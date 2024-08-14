SELECT
/* 

[NAME]

- HANA_SQL_ExplainCallPlan_2.00.010+

[DESCRIPTION]

- Displays SQL explain call plan information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Explain call plans are generated for procedure calls using the EXPLAIN CALL PLAN commands
- EXPLAIN_CALL_PLANS available with SAP HANA >= 2.0 SPS 01

[VALID FOR]

- Revisions:              >= 2.00.010

[SQL COMMAND VERSION]

- 2020/12/02:  1.0 (initial version)

[INVOLVED TABLES]

- EXPLAIN_CALL_PLANS

[INPUT PARAMETERS]

- STATEMENT_NAME

  Name specified when explaining statement (EXPLAIN CALL PLAN SET STATEMENT_NAME = '<statement_name>' FOR ...)

  'ZSAP_TEST' -> Display explain plan for statement with statement name 'ZSAP_TEST'
  '%'         -> No restriction for statement name

- SCHEMA_NAME

  Procedure schema name

  '_SYS_STATISTICS' --> Specific schema _SYS_STATISTICS
  'SAP%'            --> All schemas starting with 'SAP'
  '%'               --> All schemas

- PROCEDURE_NAME           

  Procedure name

  'MYPROC'        --> Specific procedure name MYPROC
  'T%'            --> All procedures starting with 'T'
  '%'             --> All procedures

- VALUE_LENGTH_LIMIT

  Maximum length of VALUE columns

  80          -> Truncate VALUE columns to a maximum size of 80 characters
  -1          -> No length limitation for VALUE columns

[OUTPUT PARAMETERS]

- TIMESTAMP:        Time stamp of explain call plan generation
- STATEMENT_NAME:   Name specified when explaining statement (EXPLAIN CALL PLAN SET STATEMENT_NAME = '<statement_name>' FOR ...)
- SCHEMA_NAME:      Procedure schema name
- PROCEDURE_NAME:   Procedure name
- EXECUTION_ENGINE: Execution engine
- OPERATOR_NAME:    Operator name
- INPUT_VALUES:     Input values
- OUTPUT_VALUES:    Output values

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|TIMESTAMP          |STATEMENT_NAME|SCHEMA_NAME    |PROCEDURE_NAME               |EXECUTION_ENGINE|OPERATOR_NAME  |INPUT_VALUES                                                                                                                 |OUTPUT_VALUES                                                                                                                |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2020/11/26 14:22:31|SQL_ANALYSIS  |_SYS_STATISTICS|STATISTICS_SCHEDULABLEWRAPPER|SQLScript       |Call           |(CALLER, NVARCHAR(128)), (SNAPSHOT_ID, TIMESTAMP), (SCHEDULABLE_ID, INTEGER), (DELETE_HISTORY, TINYINT), (::ROWCOUNT, BIGINT)|(USED_VALUES, TABLE(TIMESTAMP, VARCHAR(128), VARCHAR(2048), VARCHAR(1024), NVARCHAR(5000), NCLOB))                           |
|2020/11/26 14:22:31|SQL_ANALYSIS  |_SYS_STATISTICS|STATISTICS_SCHEDULABLEWRAPPER|SQLScript       | Sequential Op |                                                                                                                             |                                                                                                                             |
|2020/11/26 14:22:31|SQL_ANALYSIS  |_SYS_STATISTICS|STATISTICS_SCHEDULABLEWRAPPER|SQLScript       |  Initial Op   |                                                                                                                             |(CALLER, NVARCHAR(128)), (SNAPSHOT_ID, TIMESTAMP), (SCHEDULABLE_ID, INTEGER), (DELETE_HISTORY, TINYINT), (::ROWCOUNT, BIGINT)|
|2020/11/26 14:22:31|SQL_ANALYSIS  |_SYS_STATISTICS|STATISTICS_SCHEDULABLEWRAPPER|SQLScript       |  Initialize Op|                                                                                                                             |(V_USED_VALUES_1, TABLE(TIMESTAMP, VARCHAR(128), VARCHAR(2048), VARCHAR(1024), NVARCHAR(5000), NCLOB))                       |
|2020/11/26 14:22:31|SQL_ANALYSIS  |_SYS_STATISTICS|STATISTICS_SCHEDULABLEWRAPPER|SQLScript       |  Initialize Op|                                                                                                                             |(LT_THRESHOLDS_1, TABLE(TINYINT, NVARCHAR(256)))                                                                             |
|2020/11/26 14:22:31|SQL_ANALYSIS  |_SYS_STATISTICS|STATISTICS_SCHEDULABLEWRAPPER|SQLScript       |  Initialize Op|                                                                                                                             |(USED_VALUES, TABLE(TIMESTAMP, VARCHAR(128), VARCHAR(2048), VARCHAR(1024), NVARCHAR(5000), NCLOB))                           |
|2020/11/26 14:22:31|SQL_ANALYSIS  |_SYS_STATISTICS|STATISTICS_SCHEDULABLEWRAPPER|SQLScript       |  Initialize Op|                                                                                                                             |(V_WAS_CANCELLED_1, INTEGER)                                                                                                 |
|2020/11/26 14:22:31|SQL_ANALYSIS  |_SYS_STATISTICS|STATISTICS_SCHEDULABLEWRAPPER|SQLScript       |  Initialize Op|                                                                                                                             |(V_RETURN_RESULTSET_1, INTEGER)                                                                                              |
|2020/11/26 14:22:31|SQL_ANALYSIS  |_SYS_STATISTICS|STATISTICS_SCHEDULABLEWRAPPER|SQLScript       |  Initialize Op|                                                                                                                             |(L_TYPE_1, VARCHAR(5000))                                                                                                    |
|2020/11/26 14:22:31|SQL_ANALYSIS  |_SYS_STATISTICS|STATISTICS_SCHEDULABLEWRAPPER|SQLScript       |  Initialize Op|                                                                                                                             |(L_STORE_USED_VALUES_1, INTEGER)                                                                                             |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  TO_VARCHAR(E.TIMESTAMP, 'YYYY/MM/DD HH24:MI:SS') TIMESTAMP,
  IFNULL(E.STATEMENT_NAME, '') STATEMENT_NAME,
  E.PROCEDURE_SCHEMA_NAME SCHEMA_NAME,
  E.PROCEDURE_NAME,
  E.EXECUTION_ENGINE,
  LPAD('', E.LEVEL - 1) || LTRIM(E.OPERATOR_NAME, CHAR(32)) OPERATOR_NAME,
  MAP(BI.VALUE_LENGTH_LIMIT, -1, E.INPUT_VALUES, RTRIM(E.INPUT_VALUES, BI.VALUE_LENGTH_LIMIT)) INPUT_VALUES,
  MAP(BI.VALUE_LENGTH_LIMIT, -1, E.OUTPUT_VALUES, RTRIM(E.OUTPUT_VALUES, BI.VALUE_LENGTH_LIMIT)) OUTPUT_VALUES
FROM
( SELECT                  /* Modification section */
    '%' STATEMENT_NAME,
    '%' SCHEMA_NAME,
    '%' PROCEDURE_NAME,
    -1 VALUE_LENGTH_LIMIT
  FROM
    DUMMY
) BI,
  EXPLAIN_CALL_PLANS E
WHERE
  IFNULL(E.STATEMENT_NAME, '') LIKE BI.STATEMENT_NAME AND
  IFNULL(E.PROCEDURE_SCHEMA_NAME, '') LIKE BI.SCHEMA_NAME AND
  IFNULL(E.PROCEDURE_NAME, '') LIKE BI.PROCEDURE_NAME
ORDER BY
  E.TIMESTAMP DESC,
  E.STATEMENT_NAME,
  E.SQLSCRIPT_PLAN_ID,
  E.OPERATOR_ID
