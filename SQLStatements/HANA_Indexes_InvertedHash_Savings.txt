SELECT

/* 

[NAME]

- HANA_Indexes_InvertedHash_Savings

[DESCRIPTION]

- Calculation of space savings when migrating to inverted hash indexes

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Analysis restricted to primary keys

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2017/07/03:  1.0 (initial version)

[INVOLVED TABLES]

- INDEXES
- M_CS_ALL_COLUMNS
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

- INDEX_NAME

  Index name or pattern

  'EDIDC~1'       --> Specific index EDIDC~1
  '%~2'           --> All indexes ending with '~2'
  '%'             --> All indexes

- EXCLUDE_PARTITIONED_TABLES

  Possibility to exclude partitioned tables

  'X'             --> Only list indexes on non-partitioned tables
  ' '             --> No exclusion of partitioned tables

- EXCLUDE_DATAAGING_TABLES

  Possibility to exclude tables with activated data aging

  'X'             --> Only consider tables without activated data aging
  ' '             --> Consider all tables irrespective of data aging

- EXCLUDE_INVERTED_HASH_INDEXES

  Possibility to exclude indexes that already are of type inverted hash

  'X'             --> Only list indexes with a type different from inverted hash
  ' '             --> No restriction related to index type

[OUTPUT PARAMETERS]

- SCHEMA_NAME:     Schema name
- TABLE_NAME:      Table name
- INDEX_NAME:      Index name
- MAIN_CURR_GB:    Current index size in main storage (GB)
- MAIN_INVHASH_GB: Estimated inverted hash index size in main storage (GB)
- SAVING_GB:       Estimated space saving (GB)
- CONSTRAINT:      Constraint name
- INDEX_TYPE:      Index type

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME|TABLE_NAME      |INDEX_NAME                 |MAIN_CURR_GB |MAIN_INVHASH_GB |SAVING_GB |CONSTRAINT |INDEX_TYPE           |
--------------------------------------------------------------------------------------------------------------------------------------
|SAPERP     |CEALE01         |CEALE01~0                  |        64.77|           12.18|     52.59|PRIMARY KEY|INVERTED VALUE UNIQUE|
|SAPERP     |POC_DB_C_OPER   |POC_DB_C_OPER~0            |        54.97|           17.57|     37.40|PRIMARY KEY|INVERTED VALUE UNIQUE|
|SAPERP     |POC_DB_C_VALUE  |POC_DB_C_VALUE~0           |        49.44|           18.38|     31.06|PRIMARY KEY|INVERTED VALUE UNIQUE|
|SAPERP     |POC_DB_C_COMMAND|POC_DB_C_COMMAND~0         |        47.87|           18.97|     28.90|PRIMARY KEY|INVERTED VALUE UNIQUE|
|SAPERP     |COSS_BAK        |_SYS_TREE_CS_#168305_#0_#P0|        25.61|            4.47|     21.14|PRIMARY KEY|INVERTED VALUE UNIQUE|
|SAPERP     |VRPMA           |VRPMA~0                    |        28.11|            7.90|     20.20|PRIMARY KEY|INVERTED VALUE UNIQUE|
|SAPERP     |VAKPA           |VAKPA~0                    |        25.76|            6.58|     19.17|PRIMARY KEY|INVERTED VALUE UNIQUE|
|SAPERP     |VAPMA           |VAPMA~0                    |        24.48|            5.54|     18.93|PRIMARY KEY|INVERTED VALUE UNIQUE|
--------------------------------------------------------------------------------------------------------------------------------------

*/

  SCHEMA_NAME,
  TABLE_NAME,
  INDEX_NAME,
  LPAD(TO_DECIMAL(MAIN_CURR_GB, 10, 2), 13) MAIN_CURR_GB,
  LPAD(TO_DECIMAL(MAIN_INVHASH_GB, 10, 2), 16) MAIN_INVHASH_GB,
  LPAD(TO_DECIMAL(SAVING_GB, 10, 2), 10) SAVING_GB,
  CONSTRAINT,
  INDEX_TYPE
FROM
( SELECT
    T.SCHEMA_NAME,
    I.TABLE_NAME,
    I.INDEX_NAME,
    I.CONSTRAINT,
    I.INDEX_TYPE,
    SUM(AC.MEMORY_SIZE_IN_MAIN) / 1024 / 1024 / 1024 MAIN_CURR_GB,
    SUM(AC.MEMORY_SIZE_IN_MAIN - AC.MAIN_MEMORY_SIZE_IN_DICT  + AC.COUNT * 10) / 1024 / 1024 / 1024 MAIN_INVHASH_GB,
    SUM(AC.MAIN_MEMORY_SIZE_IN_DICT - AC.COUNT * 10) / 1024 / 1024 / 1024 SAVING_GB,
    SUM(AC.COUNT) RECORDS,
    BI.MIN_SAVING_GB
  FROM
  ( SELECT               /* Modification section */
      '%' SCHEMA_NAME,
      '%' TABLE_NAME,
      '%' INDEX_NAME,
      'X' EXCLUDE_PARTITIONED_TABLES,
      'X' EXCLUDE_DATAAGING_TABLES,
      'X' EXCLUDE_INVERTED_HASH_INDEXES,
      1 MIN_SAVING_GB
    FROM
      DUMMY
  ) BI,
    INDEXES I,
    M_CS_ALL_COLUMNS AC,
    TABLES T
  WHERE
    I.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    I.TABLE_NAME LIKE BI.TABLE_NAME AND
    I.INDEX_NAME LIKE BI.INDEX_NAME AND
    AC.SCHEMA_NAME = I.SCHEMA_NAME AND
    AC.TABLE_NAME = I.TABLE_NAME AND
    T.SCHEMA_NAME = AC.SCHEMA_NAME AND
    T.TABLE_NAME = AC.TABLE_NAME AND
    ( BI.EXCLUDE_PARTITIONED_TABLES = ' ' OR T.PARTITION_SPEC IS NULL ) AND
    ( BI.EXCLUDE_DATAAGING_TABLES = ' ' OR IFNULL(T.PARTITION_SPEC, '') NOT LIKE '%DATAAGING%' ) AND
    ( BI.EXCLUDE_INVERTED_HASH_INDEXES = ' ' OR I.INDEX_TYPE NOT LIKE 'INVERTED HASH%' ) AND
    AC.COLUMN_NAME = '$trexexternalkey$' AND
    I.CONSTRAINT = 'PRIMARY KEY'
  GROUP BY
    T.SCHEMA_NAME,
    I.TABLE_NAME,
    I.INDEX_NAME,
    I.CONSTRAINT,
    I.INDEX_TYPE,
    BI.MIN_SAVING_GB
)
WHERE
  ( MIN_SAVING_GB = -1 OR SAVING_GB >= MIN_SAVING_GB )
ORDER BY
  SAVING_GB DESC