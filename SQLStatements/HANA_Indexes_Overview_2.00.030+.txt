SELECT
/* 

[NAME]

- HANA_Indexes_Overview_2.00.030+

[DESCRIPTION]

- Overview of indexes in the system (row and column store)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Current memory size is considered, not disk size
- If a column is part of a primary key or unique index and at the same time there is a single column index
  on the column, the allocated space for the inverted index is displayed twice, although it is only
  allocated once. These situations should be avoided, because single column indexes do not provide any advantage
  on columns of a primary key or unique index.
- Persistent memory information available starting with SAP HANA 2.00.030

[VALID FOR]

- Revisions:              >= 2.00.030

[SQL COMMAND VERSION]

- 2014/10/23:  1.0 (initial version)
- 2014/11/19:  1.1 (unique indexes included)
- 2014/11/21:  1.2 (STORE filter included)
- 2014/12/04:  1.3 (consideration of implicit inverted indexes in case of unique / PK indexes)
- 2014/12/15:  1.4 (INDEX_TYPE included)
- 2015/01/17:  1.5 (FULLTEXT_INDEXES included)
- 2015/03/09:  1.6 (AGGREGATE_BY included)
- 2017/08/02:  1.7 (possibility to sort by table name rather than size, PARTITIONED added)
- 2017/11/16:  1.8 (EXCLUDE_PK_AND_UNIQUE included)
- 2019/01/07:  1.9 (EXCLUDE_SYSTEM_INDEXES included)
- 2019/03/05:  2.0 (MIN_SIZE_GB included)
- 2019/10/20:  2.1 (dedicated 2.00.030+ version including persistent memory)
- 2021/02/24:  2.2 (consideration of inverted individual indexes without concat attribute)

[INVOLVED TABLES]

- M_CS_ALL_COLUMNS
- M_RS_INDEXES
- INDEXES
- INDEX_COLUMNS
- TABLES

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

- STORE

  Restriction to store 

  'ROW'           --> Only row store information
  'COLUMN'        --> Only column store information
  '%'             --> No store restriction

- INDEX_TYPE

  Index type

  'CPBTREE'       --> Indexes of type CPBTREE
  '%UNIQUE%'      --> Indexes with type containing 'UNIQUE'
  '%'             --> No restriction related to index type

- PARTITIONED

  Partitioning restrictions

  'YES'           --> Display indexes of partitioned tables
  'NO'            --> Display indexes of non-partitioned tables
  '%'             --> No restriction related to table partitioning

- EXCLUDE_PK_AND_UNIQUE

  Possibility to exclude columns related to primary keys and unique indexes

  'X'             --> Exclude columns related to primary keys and unique indexes
  ' '             --> No restriction related to primary keys and unique indexes

- EXCLUDE_SYSTEM_INDEXES

  Possibility to exclude indexes related to SAP HANA system / DDIC tables

  'X'             --> Skip indexes related to SAP HANA system / DDIC tables
  ' '             --> No restriction related to indexes on SAP HANA system / DDIC tables

- MIN_SIZE_GB

  Minimum index size (GB)

  5               --> Only display index with a size of at least 5 GB
  -1              --> No restriction related to index size

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'STORE'         --> Aggregation by store
  'SCHEMA, TABLE' --> Aggregation by schema and table
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'SIZE'          --> Sorting by size 
  'TABLE'         --> Sorting by table name

- RESULT_ROWS

  Number of records to be returned by the query

  100             --> Return a maximum number of 100 records
  -1              --> Return all records

[OUTPUT PARAMETERS]

- SCHEMA_NAME:        Schema name
- TABLE_NAME:         Table name
- S:                  Store ('C' for column store, 'R' for row store)
- P:                  'X' if underlying table is partitioned, otherwise ' '
- INDEX_NAME:         Index name (_SYS_TREE_CS* are names for primary key indexes in column store)
- C:                  Constraint type ('P' for primary key constraint, 'U' for unique constraint)
- INDEX_TYPE:         Index type
- COLS:               Number of index columns
- INDEXES:            Number of indexes
- MEM_SIZE_GB:        Current size of index in memory (GB)
- INV_HASH_SAVING_GB: Estimated memory saving in case of inverted hash index (GB), only calculated for primary keys

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------
|SCHEMA_NAME    |TABLE_NAME                        |S|INDEX_NAME                  |C|COLS|MEM_SIZE_GB|
------------------------------------------------------------------------------------------------------
|SAPSR3         |MARD                              |C|_SYS_TREE_CS_#1650431_#0_#P0|P|   4|       3.81|
|SAPSR3         |MBEW                              |C|_SYS_TREE_CS_#1650520_#0_#P0|P|   4|       3.05|
|SAPSR3         |MARC                              |C|_SYS_TREE_CS_#1650199_#0_#P0|P|   3|       2.47|
|SAPSR3         |S912                              |C|_SYS_TREE_CS_#1650648_#0_#P0|P|  16|       2.33|
|SAPSR3         |MBEW                              |C|MBEW~ML1                    |U|   2|       2.27|
|SAPSR3         |WBCROSSGT                         |C|WBCROSSGT~0                 |P|   3|       0.72|
|SAPSR3         |MAKT                              |C|_SYS_TREE_CS_#1649940_#0_#P0|P|   3|       0.19|
|SAPSR3         |D010TAB                           |R|D010TAB~1                   | |   2|       0.19|
------------------------------------------------------------------------------------------------------

*/

  SCHEMA_NAME,
  TABLE_NAME,
  SUBSTR(STORE, 1, 1) S,
  PARTITIONED P,
  INDEX_NAME,
  CONSTRAINT C,
  INDEX_TYPE,
  LPAD(NUM_COLUMNS, 4) COLS,
  LPAD(NUM_INDEXES, 7) INDEXES,
  LPAD(TO_DECIMAL(MEM_SIZE_GB, 10, 2), 11) MEM_SIZE_GB,
  IFNULL(LPAD(TO_DECIMAL(GREATEST(0, INV_HASH_SAVING_GB), 10, 2), 18), '') INV_HASH_SAVING_GB
FROM
( SELECT
    SCHEMA_NAME,
    TABLE_NAME,
    STORE,
    PARTITIONED,
    INDEX_NAME,
    CONSTRAINT,
    INDEX_TYPE,
    NUM_COLUMNS,
    NUM_INDEXES,
    MEM_SIZE_GB,
    INV_HASH_SAVING_GB,
    ROW_NUMBER () OVER (ORDER BY MAP(ORDER_BY, 'SIZE', MEM_SIZE_GB) DESC, SCHEMA_NAME, TABLE_NAME, INDEX_NAME) ROW_NUM,
    ORDER_BY,
    RESULT_ROWS
  FROM
  ( SELECT
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SCHEMA')     != 0 THEN SCHEMA_NAME             ELSE MAP(BI_SCHEMA_NAME, '%', 'any', BI_SCHEMA_NAME) END SCHEMA_NAME,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TABLE')      != 0 THEN TABLE_NAME              ELSE MAP(BI_TABLE_NAME,  '%', 'any', BI_TABLE_NAME)  END TABLE_NAME,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'STORE')      != 0 THEN STORE                   ELSE MAP(BI_STORE,       '%', ' ', BI_STORE)         END STORE,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'INDEX')      != 0 THEN INDEX_NAME              ELSE MAP(BI_INDEX_NAME,  '%', 'any', BI_INDEX_NAME)  END INDEX_NAME,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'CONSTRAINT') != 0 THEN CONSTRAINT              ELSE 'any'                                           END CONSTRAINT,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TYPE')       != 0 THEN INDEX_TYPE              ELSE MAP(BI_INDEX_TYPE,  '%', 'any', BI_INDEX_TYPE)  END INDEX_TYPE,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'COLUMNS')    != 0 THEN TO_VARCHAR(NUM_COLUMNS) ELSE ' '                                             END NUM_COLUMNS,
      COUNT(*) NUM_INDEXES,
      SUM(MEM_SIZE_GB + MAP(NUM_COLUMNS, 1, 0, MAP(CONSTRAINT, 'P', COL_MEM_SIZE_GB, 'U', COL_MEM_SIZE_GB, 0))) MEM_SIZE_GB,
      SUM(INV_HASH_SAVING_GB) INV_HASH_SAVING_GB,
      MAP(MIN(PARTITIONED), MAX(PARTITIONED), MIN(PARTITIONED), 'any') PARTITIONED,
      MIN_SIZE_GB,
      ORDER_BY,
      RESULT_ROWS
    FROM
    ( SELECT
        I.SCHEMA_NAME,
        I.TABLE_NAME,
        IFNULL(I.STORE, 'COLUMN') STORE,             /* no concat attribute in context of inverted individual indexes */
        MAP(PT.TABLE_NAME, NULL, ' ', 'X') PARTITIONED,
        I.CONSTRAINT,
        I.INDEX_TYPE,
        I.INDEX_NAME,
        ( SELECT COUNT(*) FROM INDEX_COLUMNS IC WHERE IC.SCHEMA_NAME = I.SCHEMA_NAME AND IC.TABLE_NAME = I.TABLE_NAME AND IC.INDEX_NAME = I.INDEX_NAME ) NUM_COLUMNS,
        ( SELECT /* space allocated by implicit inverted indexes in case of unique or primary key indexes */
            IFNULL(SUM(MAIN_MEMORY_SIZE_IN_INDEX + MAIN_PERSISTENT_MEMORY_SIZE_IN_INDEX + DELTA_MEMORY_SIZE_IN_INDEX) / 1024 / 1024 / 1024, 0) 
          FROM 
            INDEX_COLUMNS IC,
            M_CS_ALL_COLUMNS AC
          WHERE 
            IC.SCHEMA_NAME = I.SCHEMA_NAME AND 
            IC.TABLE_NAME = I.TABLE_NAME AND 
            IC.INDEX_NAME = I.INDEX_NAME AND
            IC.SCHEMA_NAME = AC.SCHEMA_NAME AND 
            IC.TABLE_NAME = AC.TABLE_NAME AND 
            IC.COLUMN_NAME = AC.COLUMN_NAME 
        ) COL_MEM_SIZE_GB,
        ( SELECT
            IFNULL(SUM(AC.MAIN_MEMORY_SIZE_IN_DICT + AC.MAIN_PERSISTENT_MEMORY_SIZE_IN_DICT - AC.COUNT * 10) / 1024 / 1024 / 1024, 0)
          FROM
            M_CS_ALL_COLUMNS AC
          WHERE
            AC.SCHEMA_NAME = I.SCHEMA_NAME AND 
            AC.TABLE_NAME = I.TABLE_NAME AND 
            I.CONSTRAINT = 'P' AND
            AC.COLUMN_NAME = '$trexexternalkey$'
        ) INV_HASH_SAVING_GB,
        IFNULL(I.MEM_SIZE_GB, 0) MEM_SIZE_GB,
        BI.RESULT_ROWS,
        BI.SCHEMA_NAME BI_SCHEMA_NAME,
        BI.TABLE_NAME BI_TABLE_NAME,
        BI.INDEX_NAME BI_INDEX_NAME,
        BI.STORE BI_STORE,
        BI.INDEX_TYPE BI_INDEX_TYPE,
        BI.EXCLUDE_PK_AND_UNIQUE,
        BI.EXCLUDE_SYSTEM_INDEXES,
        BI.MIN_SIZE_GB,
        BI.AGGREGATE_BY,
        BI.ORDER_BY
      FROM
      ( SELECT            /* Modification section */
          '%' SCHEMA_NAME,
          'CDHDR' TABLE_NAME,
          '%' INDEX_NAME,
          '%' STORE,           /* ROW, COLUMN, % */
          '%' INDEX_TYPE,
          '%' PARTITIONED,     /* YES, NO, % */
          ' ' EXCLUDE_PK_AND_UNIQUE,
          'X' EXCLUDE_SYSTEM_INDEXES,
          0.5 MIN_SIZE_GB,
          'NONE' AGGREGATE_BY,                    /* SCHEMA, TABLE, STORE, INDEX, TYPE, CONSTRAINT, COLUMNS or comma separated combinations, NONE for no aggregation */
          'SIZE' ORDER_BY,                        /* SIZE, TABLE */
          50 RESULT_ROWS
        FROM
          DUMMY
      ) BI,
      ( SELECT
          C.STORE,
          IC.SCHEMA_NAME,
          IC.TABLE_NAME,
          IC.INDEX_NAME,
          IC.INDEX_TYPE,
          IC.CONSTRAINT,
          C.MEM_SIZE_GB
        FROM
        ( SELECT
            SCHEMA_NAME,
            TABLE_NAME,
            INDEX_NAME,
            INDEX_TYPE,
            CONSTRAINT,
            CASE NUM_COLUMNS
              WHEN 1 THEN COLUMN_NAME_1
              ELSE COL01 || COL02 || COL03 || COL04 || COL05 || COL06 || COL07 || COL08 ||
                COL09 || COL10 || COL11 || COL12 || COL13 || COL14 || COL15 || COL16 ||
                MAP(COL01, '', '', '$')
              END COLUMN_NAME
          FROM
          ( SELECT              /* Indexes that are neither unique nor fulltext */ 
              IC.SCHEMA_NAME,
              IC.TABLE_NAME,
              IC.INDEX_NAME,
              I.INDEX_TYPE,
              ' ' CONSTRAINT,
              COUNT(*) NUM_COLUMNS,
              MAX(MAP(IC.POSITION,  1, IC.COLUMN_NAME, '')) COLUMN_NAME_1,
              MAX(MAP(IC.POSITION,  1, '$' || IC.COLUMN_NAME, '')) COL01,
              MAX(MAP(IC.POSITION,  2, '$' || IC.COLUMN_NAME, '')) COL02,
              MAX(MAP(IC.POSITION,  3, '$' || IC.COLUMN_NAME, '')) COL03,
              MAX(MAP(IC.POSITION,  4, '$' || IC.COLUMN_NAME, '')) COL04,
              MAX(MAP(IC.POSITION,  5, '$' || IC.COLUMN_NAME, '')) COL05,
              MAX(MAP(IC.POSITION,  6, '$' || IC.COLUMN_NAME, '')) COL06,
              MAX(MAP(IC.POSITION,  7, '$' || IC.COLUMN_NAME, '')) COL07,
              MAX(MAP(IC.POSITION,  8, '$' || IC.COLUMN_NAME, '')) COL08,
              MAX(MAP(IC.POSITION,  9, '$' || IC.COLUMN_NAME, '')) COL09,
              MAX(MAP(IC.POSITION, 10, '$' || IC.COLUMN_NAME, '')) COL10,
              MAX(MAP(IC.POSITION, 11, '$' || IC.COLUMN_NAME, '')) COL11,
              MAX(MAP(IC.POSITION, 12, '$' || IC.COLUMN_NAME, '')) COL12,
              MAX(MAP(IC.POSITION, 13, '$' || IC.COLUMN_NAME, '')) COL13,
              MAX(MAP(IC.POSITION, 14, '$' || IC.COLUMN_NAME, '')) COL14,
              MAX(MAP(IC.POSITION, 15, '$' || IC.COLUMN_NAME, '')) COL15,
              MAX(MAP(IC.POSITION, 16, '$' || IC.COLUMN_NAME, '')) COL16
            FROM
              INDEXES I,
              INDEX_COLUMNS IC,
              TABLE_COLUMNS TC
            WHERE
              I.SCHEMA_NAME = IC.SCHEMA_NAME AND
              I.TABLE_NAME = IC.TABLE_NAME AND
              I.INDEX_NAME = IC.INDEX_NAME AND
              IC.SCHEMA_NAME = TC.SCHEMA_NAME AND
              IC.TABLE_NAME = TC.TABLE_NAME AND
              IC.COLUMN_NAME = TC.COLUMN_NAME AND
              ( IC.CONSTRAINT IS NULL OR
                ( IC.CONSTRAINT NOT LIKE '%UNIQUE%' AND IC.CONSTRAINT NOT LIKE '%PRIMARY KEY%' )
              ) AND
              I.INDEX_TYPE NOT LIKE 'FULLTEXT%' AND
              TC.DATA_TYPE_NAME NOT IN ('BINTEXT', 'SHORTTEXT', 'TEXT')
            GROUP BY
              IC.SCHEMA_NAME,
              IC.TABLE_NAME,
              IC.INDEX_NAME,
              I.INDEX_TYPE
          )
          UNION ALL
          ( SELECT DISTINCT     /* Unique indexes and primary keys */
              SCHEMA_NAME,
              TABLE_NAME,
              CONSTRAINT_NAME INDEX_NAME,
              ( SELECT INDEX_TYPE FROM INDEXES I WHERE C.SCHEMA_NAME = I.SCHEMA_NAME AND C.CONSTRAINT_NAME = I.INDEX_NAME ) INDEX_TYPE,
              CASE WHEN IS_PRIMARY_KEY = 'TRUE' THEN 'P' ELSE 'U' END CONSTRAINT,
              CASE 
                WHEN NUM_CONSTRAINT_COLUMNS = 1 THEN COLUMN_NAME
                WHEN IS_PRIMARY_KEY = 'TRUE' THEN '$trexexternalkey$' 
                ELSE '$uc_' || CONSTRAINT_NAME || '$' 
              END COLUMN_NAME
            FROM
            ( SELECT
                SCHEMA_NAME,
                TABLE_NAME,
                CONSTRAINT_NAME,
                COLUMN_NAME,
                IS_PRIMARY_KEY,
                IS_UNIQUE_KEY,
                MAX(POSITION) OVER (PARTITION BY SCHEMA_NAME, TABLE_NAME, CONSTRAINT_NAME) NUM_CONSTRAINT_COLUMNS
              FROM
                CONSTRAINTS
              WHERE
                ( IS_PRIMARY_KEY = 'TRUE' OR IS_UNIQUE_KEY = 'TRUE' )
            ) C
          )
          UNION ALL
          ( SELECT                      /* Fulltext indexes */
              F.SCHEMA_NAME,
              F.TABLE_NAME,
              F.INDEX_NAME,
              'FULLTEXT' INDEX_TYPE,
              '' CONSTRAINT,
              IFNULL(F.INTERNAL_COLUMN_NAME, IC.COLUMN_NAME) COLUMN_NAME              /* explicit vs. implicit fulltext indexes */
            FROM
              FULLTEXT_INDEXES F LEFT OUTER JOIN
              INDEX_COLUMNS IC ON
                IC.SCHEMA_NAME = F.SCHEMA_NAME AND
                IC.TABLE_NAME = F.TABLE_NAME AND
                IC.INDEX_NAME = F.INDEX_NAME
          )
        ) IC LEFT OUTER JOIN
        ( SELECT
            'COLUMN' STORE,
            AC.SCHEMA_NAME,
            AC.TABLE_NAME,
            AC.COLUMN_NAME,
            CASE 
              WHEN TC.DATA_TYPE_NAME IN ('BINTEXT', 'SHORTTEXT', 'TEXT')                                      THEN SUM(AC.MEMORY_SIZE_IN_TOTAL + AC.PERSISTENT_MEMORY_SIZE_IN_TOTAL )
              WHEN AC.INTERNAL_ATTRIBUTE_TYPE IN ('TREX_UDIV', 'ROWID')                                       THEN 0                                                                                                           /* technical necessity, completely treated as "table" */
              WHEN AC.INTERNAL_ATTRIBUTE_TYPE IN ('TEXT', 'TREX_EXTERNAL_KEY', 'UNKNOWN', 'CONCAT_ATTRIBUTE') THEN SUM(AC.MEMORY_SIZE_IN_TOTAL + AC.PERSISTENT_MEMORY_SIZE_IN_TOTAL)                                           /* both concat attribute and index on it treated as "index" */
              ELSE                                                                                                 SUM(AC.MAIN_MEMORY_SIZE_IN_INDEX + AC.MAIN_PERSISTENT_MEMORY_SIZE_IN_INDEX + AC.DELTA_MEMORY_SIZE_IN_INDEX) /* index structures on single columns treated as "index" */
            END  / 1024 / 1024 / 1024 MEM_SIZE_GB
          FROM
            M_CS_ALL_COLUMNS AC LEFT OUTER JOIN 
            TABLE_COLUMNS TC ON
              AC.SCHEMA_NAME = TC.SCHEMA_NAME AND
              AC.TABLE_NAME = TC.TABLE_NAME AND
              AC.COLUMN_NAME = TC.COLUMN_NAME
          GROUP BY
            AC.SCHEMA_NAME,
            AC.TABLE_NAME,
            AC.COLUMN_NAME,
            AC.INTERNAL_ATTRIBUTE_TYPE,
            TC.DATA_TYPE_NAME
        ) C ON
          C.SCHEMA_NAME = IC.SCHEMA_NAME AND
          C.TABLE_NAME = IC.TABLE_NAME AND
          C.COLUMN_NAME = IC.COLUMN_NAME
        UNION ALL
        ( SELECT
            'ROW' STORE,
            R.SCHEMA_NAME,
            R.TABLE_NAME,
            R.INDEX_NAME,
            I.INDEX_TYPE,
            MAP(R.IS_UNIQUE, 'TRUE', 'U', ' ') CONSTRAINT,     
            R.INDEX_SIZE / 1024 / 1024 / 1024 MEM_SIZE_GB
          FROM
            M_RS_INDEXES R,
            INDEXES I
          WHERE
            R.SCHEMA_NAME = I.SCHEMA_NAME AND
            R.TABLE_NAME = I.TABLE_NAME AND
            R.INDEX_NAME = I.INDEX_NAME
        )
      ) I LEFT OUTER JOIN
        PARTITIONED_TABLES PT ON
          PT.SCHEMA_NAME = I.SCHEMA_NAME AND
          PT.TABLE_NAME = I.TABLE_NAME
      WHERE
        I.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
        I.TABLE_NAME LIKE BI.TABLE_NAME AND
        I.INDEX_NAME LIKE BI.INDEX_NAME AND
        ( BI.PARTITIONED = 'YES' AND PT.TABLE_NAME IS NOT NULL OR
          BI.PARTITIONED = 'NO' AND PT.TABLE_NAME IS NULL OR
          BI.PARTITIONED = '%' ) AND
        IFNULL(I.STORE, 'COLUMN') LIKE BI.STORE
    )
    WHERE
      INDEX_TYPE LIKE BI_INDEX_TYPE AND
      ( EXCLUDE_PK_AND_UNIQUE = ' ' OR IFNULL(CONSTRAINT, '') NOT IN ('P', 'U') ) AND
      ( EXCLUDE_SYSTEM_INDEXES = ' ' OR ( SCHEMA_NAME NOT IN ( 'SYS', 'SYSTEM' ) AND SUBSTR(SCHEMA_NAME, 1, 4) != '_SYS' ) )
    GROUP BY
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SCHEMA')     != 0 THEN SCHEMA_NAME             ELSE MAP(BI_SCHEMA_NAME, '%', 'any', BI_SCHEMA_NAME) END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TABLE')      != 0 THEN TABLE_NAME              ELSE MAP(BI_TABLE_NAME,  '%', 'any', BI_TABLE_NAME)  END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'STORE')      != 0 THEN STORE                   ELSE MAP(BI_STORE,       '%', ' ', BI_STORE)         END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'INDEX')      != 0 THEN INDEX_NAME              ELSE MAP(BI_INDEX_NAME,  '%', 'any', BI_INDEX_NAME)  END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'CONSTRAINT') != 0 THEN CONSTRAINT              ELSE 'any'                                           END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TYPE')       != 0 THEN INDEX_TYPE              ELSE MAP(BI_INDEX_TYPE,  '%', 'any', BI_INDEX_TYPE)  END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'COLUMNS')    != 0 THEN TO_VARCHAR(NUM_COLUMNS) ELSE ' '                                             END,
      ORDER_BY,
      RESULT_ROWS,
      MIN_SIZE_GB
  )
  WHERE
    MIN_SIZE_GB = -1 OR MEM_SIZE_GB >= MIN_SIZE_GB
)
WHERE
  ( RESULT_ROWS = -1 OR ROW_NUM <= RESULT_ROWS )
ORDER BY
  ROW_NUM