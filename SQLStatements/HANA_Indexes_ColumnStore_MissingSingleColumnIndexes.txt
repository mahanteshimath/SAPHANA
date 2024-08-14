SELECT
/* 

[NAME]

- HANA_Indexes_ColumnStore_MissingSingleColumnIndexes

[DESCRIPTION]

- Lists columns of single column indexes, primary keys and unique indexes without single column inverted index structure

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Columns belonging to a single column index, to primary keys and unique indexes per default get a single column inverted key structure
- SAP Note 2160391 ("What are BLOCK and FULL indexes") describes problem scenarios where this inverted index is missing

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/03/10:  1.0 (initial version)
- 2015/03/23:  1.1 (COMPRESSION_COMMAND included)
- 2015/12/28:  1.2 (implicit PK / unique indexes included)
- 2016/04/28:  1.3 (exclusion of FULLTEXT indexes)
- 2016/10/28:  1.4 (ignore SPARSE indexes on SAP HANA Rev. >= 1.00.122.03)
- 2017/04/06:  1.5 (more generic check including also columns with other compression types)
- 2017/04/25:  1.6 (consideration of both SPARSE / PREFIXED columns and missing column indexes)
- 2019/10/15:  1.7 (AGGREGATE_BY, OBJECT_LEVEL and COMPRESSION_TYPE filter included)

[INVOLVED TABLES]

- INDEX_COLUMNS
- M_CS_COLUMNS

[INPUT PARAMETERS]

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- TABLE_NAME           

  Table name or pattern

  'T000'          --> Specific table T000
  'T%'            --> All tables starting with 'T'
  '%'             --> All tables

- INDEX_NAME

  Index name or pattern

  'EDIDC~1'       --> Specific index EDIDC~1
  '%~2'           --> All indexes ending with '~2'
  '%'             --> All indexes

- COLUMN_NAME

  Column name

  'MATNR'         --> Column MATNR
  'Z%'            --> Columns starting with "Z"
  '%'             --> No restriction related to columns

- COMPRESSION_TYPE

  Compression type

  'SPARSE'       --> Only return indexes on columns with SPARSE compression
  '%'            --> No restriction related to compression type

- OBJECT_LEVEL

  Controls display of partitions

  'PARTITION'     --> Result is shown on partition level
  'TABLE'         --> Result is shown on table level

- MIN_RECORD_COUNT

  Minimum number of records

  100000          --> Only display columns with at least 100,000 records
  -1              --> No restriction related to record count

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'COLUMN'        --> Aggregation by column name
  'SCHEMA, TABLE' --> Aggregation by schema and table name
  'NONE'          --> No aggregation

[OUTPUT PARAMETERS]

- SCHEMA_NAME:            Schema name
- TABLE_NAME:             Table name
- INDEX_NAME.             Index name
- COLUMN_NAME:            Column name
- COMP_TYPE:              Compression type
- NUM_ROWS:               Number of rows in table
- C:                      Number of indexes
- IMPLEMENTATION_COMMAND: Command to be executed to recompress the column (using an index-compatible compression type)

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME|TABLE_NAME|INDEX_NAME                 |COLUMN_NAME|COMP_TYPE|NUM_ROWS   |IMPLEMENTATION_COMMAND                                                  |
---------------------------------------------------------------------------------------------------------------------------------------------------------------
|SYSTEM     |AAA_NEW   |_SYS_TREE_CS_#6093813_#0_#0|X          |RLE      |   25000000|-- individual actions like recreation of primary / unique index         |
|SYSTEM     |COPY_TEST2|_SYS_TREE_CS_#6096586_#0_#0|X          |RLE      |   25000000|-- individual actions like recreation of primary / unique index         |
|SYSTEM     |AAA_NEW   |_SYS_TREE_CS_#6093813_#0_#0|Y          |DEFAULT  |   25000000|-- individual actions like recreation of primary / unique index         |
|SYSTEM     |COPY_TEST2|_SYS_TREE_CS_#6096586_#0_#0|Y          |DEFAULT  |   25000000|-- individual actions like recreation of primary / unique index         |
|SAPSR3     |BKPF      |BKPF~1                     |KZWRS      |PREFIXED |     510798|UPDATE "SAPSR3"."BKPF" WITH PARAMETERS ('OPTIMIZE_COMPRESSION'='FORCE') |
---------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')    != 0 THEN IC.SCHEMA_NAME     ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)           END SCHEMA_NAME,
  CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')     != 0 THEN IC.TABLE_NAME || MAP(BI.OBJECT_LEVEL, 'TABLE', '', MAP(C.PART_ID, 0, '', CHAR(32) || '(' || C.PART_ID || ')')) 
      ELSE MAP(BI.TABLE_NAME, '%', 'any', BI.TABLE_NAME) END TABLE_NAME,
  CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'INDEX')     != 0 THEN IC.INDEX_NAME      ELSE MAP(BI.INDEX_NAME, '%', 'any', BI.INDEX_NAME)             END INDEX_NAME,
  CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COLUMN')    != 0 THEN IC.COLUMN_NAME     ELSE MAP(BI.COLUMN_NAME, '%', 'any', BI.COLUMN_NAME)           END COLUMN_NAME,
  CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COMP_TYPE') != 0 THEN C.COMPRESSION_TYPE ELSE MAP(BI.COMPRESSION_TYPE, '%', 'any', BI.COMPRESSION_TYPE) END COMPRESSION_TYPE,
  LPAD(TO_DECIMAL(AVG(C.COUNT), 10, 0), 11) NUM_ROWS,
  TO_VARCHAR(COUNT(*)) C,
  CASE
    WHEN BI.AGGREGATE_BY != 'NONE' AND ( INSTR(BI.AGGREGATE_BY, 'SCHEMA') = 0 OR INSTR(BI.AGGREGATE_BY, 'TABLE') = 0 OR INSTR(BI.AGGREGATE_BY, 'COMMAND') = 0 ) THEN 'any'
    WHEN C.INDEX_TYPE = 'NONE' THEN '-- individual actions like recreation of primary / unique index'
    ELSE 'UPDATE' || CHAR(32) || '"' || IC.SCHEMA_NAME || '"."' || IC.TABLE_NAME || '" WITH PARAMETERS (' || CHAR (39) || 'OPTIMIZE_COMPRESSION' || CHAR(39) || '=' || 
      CHAR(39) || 'FORCE' || CHAR(39) || ');' 
  END IMPLEMENTATION_COMMAND
FROM
( SELECT                   /* Modification section */
    '%' SCHEMA_NAME,
    '%' TABLE_NAME,
    '%' INDEX_NAME,
    '%' COLUMN_NAME,
    '%' COMPRESSION_TYPE,
    'TABLE' OBJECT_LEVEL,             /* TABLE, PARTITION */
    100000 MIN_RECORD_COUNT,
    'SCHEMA, TABLE, COMMAND' AGGREGATE_BY                       /* SCHEMA, TABLE, INDEX, COLUMN, COMP_TYPE, COMMAND or comma separated combinations, NONE for no aggregation */       
  FROM
    DUMMY
) BI,
( SELECT
    SCHEMA_NAME,
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    CONSTRAINT
  FROM
  ( SELECT
      SCHEMA_NAME,
      TABLE_NAME,
      INDEX_NAME,
      COLUMN_NAME,
      CONSTRAINT,
      COUNT(*) OVER (PARTITION BY SCHEMA_NAME, TABLE_NAME, INDEX_NAME) NUM_COLUMNS
    FROM
      INDEX_COLUMNS
  )
  WHERE
    NUM_COLUMNS = 1 OR ( CONSTRAINT IN ('PRIMARY KEY', 'UNIQUE', 'NOT NULL UNIQUE' ) )
) IC,
( SELECT
    SCHEMA_NAME,
    TABLE_NAME,
    PART_ID,
    COLUMN_NAME,
    COMPRESSION_TYPE,
    COUNT,
    INDEX_TYPE,
    LOADED
  FROM
    M_CS_COLUMNS
) C,
( SELECT
    SUBSTR(VALUE, 1, LOCATE(VALUE, '.', 1, 2) - 1) VERSION,
    TO_NUMBER(SUBSTR(VALUE, LOCATE(VALUE, '.', 1, 2) + 1, LOCATE(VALUE, '.', 1, 3) - LOCATE(VALUE, '.', 1, 2) - 1) ||
    MAP(LOCATE(VALUE, '.', 1, 4), 0, '', '.' || SUBSTR(VALUE, LOCATE(VALUE, '.', 1, 3) + 1, LOCATE(VALUE, '.', 1, 4) - LOCATE(VALUE, '.', 1, 3) - 1 ))) REVISION 
  FROM 
    M_SYSTEM_OVERVIEW 
  WHERE 
    SECTION = 'System' AND 
    NAME = 'Version' 
) R
WHERE
  IC.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  IC.TABLE_NAME LIKE BI.TABLE_NAME AND
  IC.INDEX_NAME LIKE BI.INDEX_NAME AND
  IC.COLUMN_NAME LIKE BI.COLUMN_NAME AND
  IC.SCHEMA_NAME = C.SCHEMA_NAME AND
  IC.TABLE_NAME = C.TABLE_NAME AND
  IC.COLUMN_NAME = C.COLUMN_NAME AND
  C.COMPRESSION_TYPE LIKE BI.COMPRESSION_TYPE AND
  ( BI.MIN_RECORD_COUNT = -1 OR C.COUNT >= BI.MIN_RECORD_COUNT ) AND
  ( C.LOADED = 'TRUE' AND C.INDEX_TYPE = 'NONE' OR
    C.COMPRESSION_TYPE = 'PREFIXED' OR
    C.COMPRESSION_TYPE = 'SPARSE' AND R.VERSION = '1.00' AND TO_NUMBER(R.REVISION) <= 122.02
  )  AND NOT EXISTS
  ( SELECT
      *
    FROM
      INDEXES IR,
      INDEX_COLUMNS ICR
    WHERE
      IR.SCHEMA_NAME = ICR.SCHEMA_NAME AND
      IR.TABLE_NAME = ICR.TABLE_NAME AND
      IR.INDEX_NAME = ICR.INDEX_NAME AND
      IR.INDEX_TYPE LIKE 'FULLTEXT%' AND
      C.SCHEMA_NAME = ICR.SCHEMA_NAME AND
      C.TABLE_NAME = ICR.TABLE_NAME AND
      C.COLUMN_NAME = ICR.COLUMN_NAME
  )
GROUP BY
  CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')    != 0 THEN IC.SCHEMA_NAME     ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)           END,
  CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')     != 0 THEN IC.TABLE_NAME || MAP(BI.OBJECT_LEVEL, 'TABLE', '', MAP(C.PART_ID, 0, '', CHAR(32) || '(' || C.PART_ID || ')')) 
      ELSE MAP(BI.TABLE_NAME, '%', 'any', BI.TABLE_NAME) END,
  CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'INDEX')     != 0 THEN IC.INDEX_NAME      ELSE MAP(BI.INDEX_NAME, '%', 'any', BI.INDEX_NAME)             END,
  CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COLUMN')    != 0 THEN IC.COLUMN_NAME     ELSE MAP(BI.COLUMN_NAME, '%', 'any', BI.COLUMN_NAME)           END,
  CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COMP_TYPE') != 0 THEN C.COMPRESSION_TYPE ELSE MAP(BI.COMPRESSION_TYPE, '%', 'any', BI.COMPRESSION_TYPE) END,
  CASE
    WHEN BI.AGGREGATE_BY != 'NONE' AND ( INSTR(BI.AGGREGATE_BY, 'SCHEMA') = 0 OR INSTR(BI.AGGREGATE_BY, 'TABLE') = 0 OR INSTR(BI.AGGREGATE_BY, 'COMMAND') = 0 ) THEN 'any'
    WHEN C.INDEX_TYPE = 'NONE' THEN '-- individual actions like recreation of primary / unique index'
    ELSE 'UPDATE' || CHAR(32) || '"' || IC.SCHEMA_NAME || '"."' || IC.TABLE_NAME || '" WITH PARAMETERS (' || CHAR (39) || 'OPTIMIZE_COMPRESSION' || CHAR(39) || '=' || 
      CHAR(39) || 'FORCE' || CHAR(39) || ');' 
  END
ORDER BY
  SUM(C.COUNT) DESC
