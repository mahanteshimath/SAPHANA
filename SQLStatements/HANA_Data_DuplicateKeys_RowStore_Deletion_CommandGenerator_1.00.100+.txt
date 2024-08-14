WITH

/* 

[NAME]

- HANA_Data_DuplicateKeys_RowStore_Deletion_CommandGenerator_1.00.100+

[DESCRIPTION]

- Checks for duplicate keys (in terms of primary key, specific index or specific column list) in a single row store table
  and generates commands in order to remove duplicates

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Records with distinct keys are copied from <table> to <table>_TEMP, then <table> is renamed to <table>_ORIG and 
  <table>_TEMP is renamed to <table>, so at the end the deduplicated data is available in the original table name while
  the original table content is still available in <table>_ORIG

- Attention: Using this SQL statement in a wrong way and executing the generated commands can result in data loss, so double-check what
  you are doing before actually executing the steps! The final DROP of the original table (<table>_ORIG) should only be performed
  if you are sure that all required information is in the target table.

- Attention: If the duplicate keys are a consequence of a SAP HANA corruption, the DROP can result in further issues like
  crashes (in case dropped pages are actually accessed in a different context).

- Attention: Due to a lack of an explicit identifier for a single record (like row ID) an intermediate table needs to be populated and
  renamed. As a consequence you need to make sure that the generated commands are executed during a downtime when no selections or
  modifications are executed against the underlying table.

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

- 2018/02/13:  1.0 (initial version)

[INVOLVED TABLES]

- INDEX_COLUMNS
- TABLE_COLUMNS

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

- COLUMNS_PER_LINE

  Number of table column names generated in each line in the output statement (too avoid very long output lines)

  8               --> Generate 8 table column names per line

- EXECUTION_HINTS

  Hints to be generated

  'NO_AGGR_SIMPLIFICATION, NO_GROUPING_SIMPLIFICATION' --> Generate hints NO_AGGR_SIMPLIFICATION, NO_GROUPING_SIMPLIFICATION
  ''                                                   --> No generation of hints

[OUTPUT PARAMETERS]

- COMMAND:        SQL command to be executed in second step

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------
|COMMAND                                                                         |
----------------------------------------------------------------------------------
|CREATE TABLE "DBSTATC_TEMP" LIKE "DBSTATC"                                      |
|INSERT INTO "DBSTATC_TEMP"                                                      |
|( SELECT                                                                        |
|    "DBOBJ", "DOTYP", "OBJOW", "DBTYP", "VWTYP", "ACTIV", "OBJEC", "AEDAT",     |
|    "SIGNI", "AMETH", "OPTIO", "TOBDO", "HISTO", "TDDAT", "DURAT", "PLAND"      |
|  FROM                                                                          |
|  ( SELECT                                                                      |
|      ROW_NUMBER() OVER (PARTITION BY "DBOBJ", "DOTYP", "OBJOW", "DBTYP") ROWNO,|
|      "DBOBJ", "DOTYP", "OBJOW", "DBTYP", "VWTYP", "ACTIV", "OBJEC", "AEDAT",   |
|      "SIGNI", "AMETH", "OPTIO", "TOBDO", "HISTO", "TDDAT", "DURAT", "PLAND"    |
|    FROM                                                                        |
|      "DBSTATC"                                                                 |
|  )                                                                             |
|  WHERE                                                                         |
|    ROWNO = 1                                                                   |
|)                                                                               |
|WITH HINT (NO_AGGR_SIMPLIFICATION, NO_GROUPING_SIMPLIFICATION)                  |
|RENAME TABLE "DBSTATC" TO "DBSTATC_ORIG"                                        |
|RENAME TABLE "DBSTATC_TEMP" TO "DBSTATC"                                        |
|-- DROP TABLE "DBSTATC_ORIG"                                                    |
----------------------------------------------------------------------------------

--> Needs to be executed in order to clean up duplicates in terms of the specified key

*/

BASIS_INFO AS
( SELECT                      /* Modification section */
      '%' SCHEMA_NAME,
      'DBSTATC' TABLE_NAME,
      '' KEY_COLUMNS,
      '' INDEX_NAME,
      '' PRIORITY_ORDER_BY,
      8 COLUMNS_PER_LINE,
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
),
COLUMN_LIST AS
( SELECT
    LINE_NO,
    MAP(LINE_NO, MAX_LINE_NO, COLUMNS, COLUMNS || ',') COLUMNS
  FROM
  ( SELECT
      MAX(L.LINE_NO) OVER () MAX_LINE_NO,
      L.LINE_NO,
      '"' || STRING_AGG(COLUMN_NAME, '", "' ORDER BY POSITION) || '"' COLUMNS
    FROM
    ( SELECT TOP 100 ROW_NUMBER() OVER () LINE_NO FROM OBJECTS ) L,
      BASIS_INFO BI,
      TABLE_COLUMNS C
    WHERE
      C.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
      C.TABLE_NAME LIKE BI.TABLE_NAME AND
      CEIL(C.POSITION / BI.COLUMNS_PER_LINE) = L.LINE_NO
    GROUP BY
      L.LINE_NO
  )
)
SELECT
  COMMAND
FROM
( SELECT   10 LINE_NO, 'CREATE TABLE' || CHAR(32) || MAP(SCHEMA_NAME, '', '', '%', '', '"' || SCHEMA_NAME || '".') || '"' || TABLE_NAME || '_TEMP" LIKE' || CHAR(32) || MAP(SCHEMA_NAME, '', '', '%', '', '"' || SCHEMA_NAME || '".') || '"' || TABLE_NAME || '"' || CHAR(59) COMMAND FROM BASIS_INFO UNION ALL
  SELECT   20, 'INSERT INTO' || CHAR(32) || MAP(SCHEMA_NAME, '', '', '%', '', '"' || SCHEMA_NAME || '".') || '"' || TABLE_NAME || '_TEMP"' FROM BASIS_INFO UNION ALL
  SELECT   30, '( SELECT' FROM DUMMY UNION ALL
  SELECT 1000 + LINE_NO, LPAD('', 4) || COLUMNS FROM COLUMN_LIST UNION ALL
  SELECT 2000, LPAD('', 2) || 'FROM' FROM DUMMY UNION ALL
  SELECT 2010, LPAD('', 2) || '( SELECT' FROM DUMMY UNION ALL
  SELECT 2020, LPAD('', 6) || 'ROW_NUMBER() OVER (PARTITION BY' || CHAR(32) || K.KEY_COLUMNS || MAP(BI.PRIORITY_ORDER_BY, '', '', CHAR(32) || 'ORDER BY' || CHAR(32) || BI.PRIORITY_ORDER_BY) || ') ROWNO,' FROM BASIS_INFO BI, KEY_COLUMNS K UNION ALL
  SELECT 3000 + LINE_NO, LPAD('', 6) || COLUMNS FROM COLUMN_LIST UNION ALL
  SELECT 4010, LPAD('', 4) || 'FROM' FROM DUMMY UNION ALL
  SELECT 4020, LPAD('', 6) || MAP(SCHEMA_NAME, '', '', '%', '', '"' || SCHEMA_NAME || '".') || '"' || TABLE_NAME || '"' FROM BASIS_INFO UNION ALL
  SELECT 4030, LPAD('', 2) || ')' FROM DUMMY UNION ALL
  SELECT 4040, LPAD('', 2) || 'WHERE' FROM DUMMY UNION ALL
  SELECT 4050, LPAD('', 4) || 'ROWNO = 1' FROM DUMMY UNION ALL
  SELECT 4060, MAP(EXECUTION_HINT, '', ')' || CHAR(59), ')') FROM BASIS_INFO UNION ALL
  SELECT 4070, 'WITH HINT (' || EXECUTION_HINT || ')' || CHAR(59) FROM BASIS_INFO WHERE EXECUTION_HINT != '' UNION ALL
  SELECT 5000, 'RENAME TABLE' || CHAR(32) || MAP(SCHEMA_NAME, '', '', '%', '', '"' || SCHEMA_NAME || '".') || '"' || TABLE_NAME || '" TO' || CHAR(32) || MAP(SCHEMA_NAME, '', '', '%', '', '"' || SCHEMA_NAME || '".') || '"' || TABLE_NAME || '_ORIG"' || CHAR(59) FROM BASIS_INFO UNION ALL
  SELECT 5010, 'RENAME TABLE' || CHAR(32) || MAP(SCHEMA_NAME, '', '', '%', '', '"' || SCHEMA_NAME || '".') || '"' || TABLE_NAME || '_TEMP" TO' || CHAR(32) || MAP(SCHEMA_NAME, '', '', '%', '', '"' || SCHEMA_NAME || '".') || '"' || TABLE_NAME || '"' || CHAR(59) FROM BASIS_INFO UNION ALL
  SELECT 5020, '-- DROP TABLE' || CHAR(32) || MAP(SCHEMA_NAME, '', '', '%', '', '"' || SCHEMA_NAME || '".') || '"' || TABLE_NAME || '_ORIG"' || CHAR(59) FROM BASIS_INFO
)
ORDER BY
  LINE_NO