WITH

/* 

[NAME]

- HANA_Data_DuplicateKeys_CommandGenerator_1.00.100+

[DESCRIPTION]

- Checks for duplicate keys (in terms of primary key, specific index or specific column list)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- ORDER BY clause for STRING_AGG only available as of Rev. 1.00.100
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

- 2016/12/28:  1.0 (initial version)
- 2017/03/10:  1.1 (EXECUTION_HINTS included)

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

- EXECUTION_HINTS

  Hints to be generated

  'NO_AGGR_SIMPLIFICATION, NO_GROUPING_SIMPLIFICATION' --> Generate hints NO_AGGR_SIMPLIFICATION, NO_GROUPING_SIMPLIFICATION
  ''                                                   --> No generation of hints

[OUTPUT PARAMETERS]

- COMMAND:        SQL command to be executed in second step

[EXAMPLE OUTPUT]

-------------------------------
|COMMAND                      |
-------------------------------
|SELECT                       |
|  DOTYP, DBOBJ,              |
|  LPAD(COUNT(*), 9) IDENTICAL|
|FROM                         |
|  "DBSTATC"                  |
|GROUP BY                     |
|  DOTYP, DBOBJ               |
|HAVING                       |
|  COUNT(*) > 1               |
|ORDER BY                     |
|  DOTYP, DBOBJ               |
-------------------------------

--> Needs to be executed and returns e.g.:

-----------------------------
|DOTYP|DBOBJ      |IDENTICAL|
-----------------------------
|01   |APQD       |        4|
|01   |APQI       |        4|
|01   |ARFCRSTATE |        3|
|01   |ARFCSDATA  |        2|
|01   |ARFCSSTATE |        3|
|01   |ATAB       |        2|
|01   |COIX       |        2|
-----------------------------

*/

BASIS_INFO AS
( SELECT                      /* Modification section */
      '%' SCHEMA_NAME,
      '/BIC/SCMACCTN21' TABLE_NAME,
      '' KEY_COLUMNS,
      '' INDEX_NAME,
      'NO_AGGR_SIMPLIFICATION, NO_GROUPING_SIMPLIFICATION' EXECUTION_HINT
    FROM
      DUMMY
),
KEY_COLUMNS AS
( SELECT
    MAP(BI.KEY_COLUMNS, '', IC.KEY_COLUMNS, BI.KEY_COLUMNS) KEY_COLUMNS
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
( SELECT    10 LINE_NO, 'SELECT' COMMAND FROM DUMMY
  UNION ALL SELECT  20, LPAD('', 2) || KEY_COLUMNS || ',' FROM KEY_COLUMNS
  UNION ALL SELECT  30, LPAD('', 2) || 'LPAD(COUNT(*), 9) IDENTICAL' FROM DUMMY
  UNION ALL SELECT  40, 'FROM' FROM DUMMY
  UNION ALL SELECT  50, LPAD('', 2) || MAP(SCHEMA_NAME, '', '', '%', '', '"' || SCHEMA_NAME || '".') || '"' || TABLE_NAME || '"' FROM BASIS_INFO
  UNION ALL SELECT  60, 'GROUP BY' FROM DUMMY
  UNION ALL SELECT  70, LPAD('', 2) || KEY_COLUMNS FROM KEY_COLUMNS
  UNION ALL SELECT  80, 'HAVING' FROM DUMMY
  UNION ALL SELECT  90, LPAD('', 2) || 'COUNT(*) > 1' FROM DUMMY
  UNION ALL SELECT 100, 'ORDER BY' FROM DUMMY
  UNION ALL SELECT 110, LPAD('', 2) || KEY_COLUMNS FROM KEY_COLUMNS
  UNION ALL SELECT 120, MAP(EXECUTION_HINT, '', '', 'WITH HINT (' || EXECUTION_HINT || ')') FROM BASIS_INFO
)
ORDER BY
  LINE_NO