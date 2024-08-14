SELECT
/* 

[NAME]

- HANA_Indexes_InvertedIndividual_Conversion_CommandGenerator_2.00.030+

[DESCRIPTION]

- Generates a SQL command to convert primary keys to inverted individual indexes

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- ORDER BY clause for STRING_AGG only available as of Rev. 1.00.100
- Result of command execution is a SQL statement that has to be executed in order to count the values
- See SAP Note 2600076 for more information related to inverted individual indexes

[VALID FOR]

- Revisions:              >= 2.00.030

[SQL COMMAND VERSION]

- 2018/05/08:  1.0 (initial version)
- 2020/02/17:  1.1 (simplified conversion commands with SAP HANA 2.0 SPS 04 included)

[INVOLVED TABLES]

- M_CS_TABLES
- INDEX_COLUMNS
- INDEXES

[INPUT PARAMETERS]

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  '%'             --> All schemata

- TABLE_NAME           

  Table name 

  'T000'          --> Specific table T000
  'T%'            --> All tables starting with 'T'
  '%'             --> No restriction related to table name

- MIN_TABLE_SIZE_MB

  Minimum table size (MB)

  1024            --> Only consider indexes of tables with a size of at least 1024 MB
  -1              --> No restriction related to table size

[OUTPUT PARAMETERS]

- COMMAND: SQL command to be executed in second step

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------------
|SAVING_GB|COMMAND                                                                                                                                      |
---------------------------------------------------------------------------------------------------------------------------------------------------------
|         |SET TRANSACTION AUTOCOMMIT DDL OFF                                                                                                           |
|     0.33|ALTER TABLE "SAPSR3"."SEOCOMPOTX" DROP PRIMARY KEY                                                                                           |
|         |ALTER TABLE "SAPSR3"."SEOCOMPOTX" ADD CONSTRAINT "SEOCOMPOTX~0" PRIMARY KEY INVERTED INDIVIDUAL ("CLSNAME", "CMPNAME", "LANGU")              |
|         |COMMIT                                                                                                                                       |
|     0.74|ALTER TABLE "SAPSR3"."SEOSUBCOTX" DROP PRIMARY KEY                                                                                           |
|         |ALTER TABLE "SAPSR3"."SEOSUBCOTX" ADD CONSTRAINT "SEOSUBCOTX~0" PRIMARY KEY INVERTED INDIVIDUAL ("CLSNAME", "CMPNAME", "SCONAME", "LANGU")   |
|         |COMMIT                                                                                                                                       |
|         |SET TRANSACTION AUTOCOMMIT DDL ON                                                                                                            |
---------------------------------------------------------------------------------------------------------------------------------------------------------

--> Needs to be executed (in a session with deactivated normal autocommit)

*/

  '' SAVING_GB, 'SET TRANSACTION AUTOCOMMIT DDL OFF' || CHAR(59) COMMAND
FROM
  M_DATABASE WHERE VERSION < '2.00.040'
UNION ALL
( SELECT
    MAP(L.LINE_NO, 1, LPAD(TO_DECIMAL(MEM_SIZE_GB, 10, 2), 9), '') SAVING_GB,
    CASE L.DESCRIPTION
      WHEN 'DROP' THEN
        'ALTER TABLE "' || SCHEMA_NAME || '"."' || TABLE_NAME || '" DROP PRIMARY KEY' || CHAR(59)
      WHEN 'CREATE' THEN
        'ALTER TABLE "' || SCHEMA_NAME || '"."' || TABLE_NAME || '" ADD' || CHAR(32) || MAP(NEW_INDEX_NAME, '', '', 'CONSTRAINT "' || 
          NEW_INDEX_NAME || '"' || CHAR(32)) || 'PRIMARY KEY INVERTED INDIVIDUAL (' || COLUMN_LIST || ')' || CHAR(59)
      WHEN 'SINGLE' THEN
        'ALTER TABLE "' || SCHEMA_NAME || '"."' || TABLE_NAME || '" ALTER PRIMARY KEY INVERTED INDIVIDUAL' || CHAR(59)
      WHEN 'COMMIT' THEN
        'COMMIT' || CHAR(59)
    END COMMAND
  FROM
  ( SELECT
      T.SCHEMA_NAME,
      T.TABLE_NAME,
      IC.INDEX_NAME ORIG_INDEX_NAME,
      C.MEM_SIZE_GB,
      MAP(BI.USE_ABAP_INDEX_NAMING_CONVENTION, 'X', T.TABLE_NAME || '~0', '') NEW_INDEX_NAME,
      IC.COLUMN_LIST
    FROM
    ( SELECT               /* Modification section */
        '%' SCHEMA_NAME,
        '%' TABLE_NAME,
        1024 MIN_TABLE_SIZE_MB,
        'X' USE_ABAP_INDEX_NAMING_CONVENTION
      FROM
        DUMMY
    ) BI,
    ( SELECT
        SCHEMA_NAME,
        TABLE_NAME,
        SUM(ESTIMATED_MAX_MEMORY_SIZE_IN_TOTAL) ESTIMATED_MAX_MEMORY_SIZE_IN_TOTAL
      FROM
        M_CS_TABLES
      GROUP BY
        SCHEMA_NAME,
        TABLE_NAME
    ) T,
    ( SELECT
        SCHEMA_NAME,
        TABLE_NAME,
        INDEX_NAME,
        CONSTRAINT,
         '"' || STRING_AGG(COLUMN_NAME, '", "' ORDER BY POSITION) || '"' COLUMN_LIST
      FROM
        INDEX_COLUMNS
      GROUP BY
        SCHEMA_NAME,
        TABLE_NAME,
        INDEX_NAME,
        CONSTRAINT
    ) IC,
      INDEXES I,
    ( SELECT
        SCHEMA_NAME,
        TABLE_NAME,
        SUM(MEMORY_SIZE_IN_TOTAL) / 1024 / 1024 / 1024 MEM_SIZE_GB
      FROM
        M_CS_ALL_COLUMNS
      WHERE
        COLUMN_NAME = '$trexexternalkey$'
      GROUP BY
        SCHEMA_NAME,
        TABLE_NAME
    ) C
    WHERE
      T.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
      T.TABLE_NAME LIKE BI.TABLE_NAME AND
      ( BI.MIN_TABLE_SIZE_MB = -1 OR T.ESTIMATED_MAX_MEMORY_SIZE_IN_TOTAL >= BI.MIN_TABLE_SIZE_MB * 1024 * 1024 ) AND
      T.SCHEMA_NAME = IC.SCHEMA_NAME AND
      T.TABLE_NAME = IC.TABLE_NAME AND
      IC.SCHEMA_NAME = I.SCHEMA_NAME AND
      IC.TABLE_NAME = I.TABLE_NAME AND
      IC.INDEX_NAME = I.INDEX_NAME AND
      IC.CONSTRAINT IN ( 'PRIMARY KEY', 'UNIQUE', 'NOT NULL UNIQUE' ) AND
      I.INDEX_TYPE != 'INVERTED INDIVIDUAL' AND
      C.SCHEMA_NAME = T.SCHEMA_NAME AND
      C.TABLE_NAME = T.TABLE_NAME
  ) I,
  ( SELECT 1 LINE_NO, 'DROP' DESCRIPTION FROM M_DATABASE WHERE VERSION < '2.00.040' UNION ALL
    SELECT 2, 'CREATE'                   FROM M_DATABASE WHERE VERSION < '2.00.040' UNION ALL
    SELECT 3, 'COMMIT'                   FROM M_DATABASE WHERE VERSION < '2.00.040' UNION ALL
    SELECT 1, 'SINGLE'                   FROM M_DATABASE WHERE VERSION >= '2.00.040'
  ) L
  ORDER BY
    I.SCHEMA_NAME,
    I.TABLE_NAME,
    L.LINE_NO
)
UNION ALL
( SELECT
    '', 'SET TRANSACTION AUTOCOMMIT DDL ON' || CHAR(59) COMMAND
  FROM
    M_DATABASE WHERE VERSION < '2.00.040'
)
