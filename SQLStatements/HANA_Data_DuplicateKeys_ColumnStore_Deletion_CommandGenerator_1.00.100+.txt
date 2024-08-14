WITH

/* 

[NAME]

- HANA_Data_DuplicateKeys_ColumnStore_Deletion_CommandGenerator_1.00.100+

[DESCRIPTION]

- Checks for duplicate keys (in terms of primary key, specific index or specific column list) in a single column store table
  and generates DELETE command in order to remove duplicates.

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Attention: Using this command in a wrong way and executing the DELETE command can result in data loss, so double-check what
  you are doing before actually executing the DELETE!

- In some cases a manual consolidation of records is required because dependent on the application requirements a specific
  filtering or merging is required.

- ORDER BY clause for STRING_AGG only available as of SAP HANA 1.00.100
- Key columns are determined in the following way:

  - If KEY_COLUMNS is populated (i.e. different from ''): Use the specified columns
  - If INDEX_NAME is populated (i.e. different from ''): Use the columns of the specified index
  - Otherwise use the PRIMARY KEY columns

- Due to SAP HANA internal optimizations it can happen that duplicates are not properly reported in all cases,
  in this case adding hints to disable query simplifications like NO_AGGR_SIMPLIFICATION and NO_GROUPING_SIMPLIFICATION
  can help

[VALID FOR]

- Revisions:              >= 1.00.100

[SQL COMMAND VERSION]

- 2017/11/28:  1.0 (initial version)

[INVOLVED TABLES]

- INDEX_COLUMNS

[INPUT PARAMETERS]

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  '%'             --> No specific schema

- TABLE_NAME          

  Table name (no pattern)

  'T000'          --> Specific table T000

- KEY_COLUMNS

  Key columns

  'DBOBJ'         --> Explicit key column DBOBJ
  'MANDT, BUKRS'  --> Explicit key columns MANDT and BUKRS
  ''              --> Use primary key or explicitly specified index name for determining key columns

- INDEX_NAME

  Index name

  'DBSTATC~0'     --> Columns of index DBSTATC~0 used as key columns
  ''              --> Do not use index for key columns

- PRIORITY_ORDER_BY

  Priority sort criteria (first record in terms of sort order is kept, other duplicates are deleted)

  'Z'             --> Keep record with lowest value for column Z
  'A DESC'        --> Keep record with highest value for column A
  ''              --> No defined priority order

- EXECUTION_HINTS

  Hints to be generated

  'NO_AGGR_SIMPLIFICATION, NO_GROUPING_SIMPLIFICATION' --> Generate hints NO_AGGR_SIMPLIFICATION, NO_GROUPING_SIMPLIFICATION
  ''                                                   --> No generation of hints

[OUTPUT PARAMETERS]

- COMMAND:        SQL command to be executed in second step

[EXAMPLE OUTPUT]

----------------------------------------------------------------
|COMMAND                                                       |
----------------------------------------------------------------
|DELETE FROM                                                   |
|  "AAA"                                                       |
|WHERE                                                         |
|  "$rowid$" IN                                                |
|  ( SELECT                                                    |
|      ROW_ID                                                  |
|    FROM                                                      |
|    ( SELECT                                                  |
|        "$rowid$" ROW_ID,                                     |
|        ROW_NUMBER() OVER (PARTITION BY "X", "Y", "Z") DUP_NO |
|         FROM                                                 |
|        "AAA"                                                 |
|    )                                                         |
|    WHERE                                                     |
|      DUP_NO > 1                                              |
|  )                                                           |
|WITH HINT (NO_AGGR_SIMPLIFICATION, NO_GROUPING_SIMPLIFICATION)|
----------------------------------------------------------------

--> Needs to be executed in order to clean up duplicates in terms of the specified key

*/

BASIS_INFO AS
( SELECT                      /* Modification section */
      '%' SCHEMA_NAME,
      '/BIC/SCMACCTN21' TABLE_NAME,
      '' KEY_COLUMNS,
      '' INDEX_NAME,
      '' PRIORITY_ORDER_BY,
      'NO_AGGR_SIMPLIFICATION, NO_GROUPING_SIMPLIFICATION' EXECUTION_HINT
    FROM
      DUMMY
),
KEY_COLUMNS AS
( SELECT
    MAP(BI.KEY_COLUMNS, '', IC.KEY_COLUMNS, BI.KEY_COLUMNS) KEY_COLUMNS,
    BI.PRIORITY_ORDER_BY
  FROM
    BASIS_INFO BI,
  ( SELECT
      '"' || STRING_AGG(IC.COLUMN_NAME, '", "' ORDER BY IC.POSITION) || '"' KEY_COLUMNS
    FROM
      BASIS_INFO BI LEFT OUTER JOIN
      INDEX_COLUMNS IC ON
        IC.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
        IC.TABLE_NAME = BI.TABLE_NAME AND
        ( BI.INDEX_NAME != '' AND IC.INDEX_NAME = BI.INDEX_NAME OR
          BI.INDEX_NAME = '' AND IC.CONSTRAINT = 'PRIMARY KEY' )
  ) IC
)
SELECT
  COMMAND
FROM
( SELECT  10 LINE_NO, 'DELETE FROM' COMMAND FROM DUMMY UNION ALL
  SELECT  20, LPAD('', 2) || MAP(SCHEMA_NAME, '', '', '%', '', '"' || SCHEMA_NAME || '".') || '"' || TABLE_NAME || '"' FROM BASIS_INFO UNION ALL
  SELECT  30, 'WHERE' FROM DUMMY UNION ALL
  SELECT  40, LPAD('', 2) || '"$rowid$" IN' FROM DUMMY UNION ALL
  SELECT  50, LPAD('', 2) || '( SELECT' FROM DUMMY UNION ALL
  SELECT  60, LPAD('', 6) || 'ROW_ID' FROM DUMMY UNION ALL
  SELECT  70, LPAD('', 4) || 'FROM' FROM DUMMY UNION ALL
  SELECT  80, LPAD('', 4) || '( SELECT' FROM DUMMY UNION ALL
  SELECT  90, LPAD('', 8) || '"$rowid$" ROW_ID,' FROM DUMMY UNION ALL
  SELECT 100, LPAD('', 8) || 'ROW_NUMBER() OVER (PARTITION BY' || CHAR(32) || KEY_COLUMNS || MAP(PRIORITY_ORDER_BY, '', '', '%', '', CHAR(32) || 'ORDER BY' || CHAR(32) || PRIORITY_ORDER_BY) || ') DUP_NO' FROM KEY_COLUMNS UNION ALL
  SELECT 110, LPAD('', 9) || 'FROM' FROM DUMMY UNION ALL
  SELECT 120, LPAD('', 8) || MAP(SCHEMA_NAME, '', '', '%', '', '"' || SCHEMA_NAME || '".') || '"' || TABLE_NAME || '"' FROM BASIS_INFO UNION ALL
  SELECT 130, LPAD('', 4) || ')' FROM DUMMY UNION ALL
  SELECT 140, LPAD('', 4) || 'WHERE' FROM DUMMY UNION ALL
  SELECT 150, LPAD('', 6) || 'DUP_NO > 1' FROM DUMMY UNION ALL
  SELECT 160, LPAD('', 2) || ')' FROM DUMMY UNION ALL
  SELECT 170, MAP(EXECUTION_HINT, '', '', 'WITH HINT (' || EXECUTION_HINT || ')') FROM BASIS_INFO
)
ORDER BY
  LINE_NO