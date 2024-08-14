WITH 

/* 

[NAME]

- HANA_LOBs_LOBSizeHistogram_DataCollector

[DESCRIPTION]

- Value length histogram for LOB columns

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- This command is a command generator, so it generates another SQL statement in the first step that
  has to be executed in a second step in order to retrieve the actual information.
- The generated command can run for a long time and consume significant amounts of memory, so it should only
  be started if proper CPU and memory workload management is in place (SAP Note 2222250).

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2020/01/21:  1.0 (initial version)

[INVOLVED TABLES]

- M_TABLE_LOB_STATISTICS

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

- COLUMN_NAME

  Column name

  'MATNR'         --> Column MATNR
  'Z%'            --> Columns starting with "Z"
  '%'             --> No restriction related to columns

- MIN_LOBS

  Minimum number of LOB records

  1000000         --> Only evaluate LOB columns with at least 1000000 records
  -1              --> No restriction related to LOB records

[OUTPUT PARAMETERS]

- SCHEMA_NAME:  Schema name
- TABLE_NAME:   Table name
- COLUMN_NAME:  LOB column name
- LOB_TYPE:     LOB storage type (PACKED for packed LOBs, FILE for classic disk LOBs, or combination of both)
- TOTAL_ROW:    Total records
- TOTAL_GB:     Total LOB size (GB)
- AVG_BYTE:     Average LOB value size (byte)
- KB_0_1_ROW:   Number of records with LOB size between 0 and 999 byte
- KB_0_1_GB:    Total size of records with LOB size between 0 and 999 byte (GB)
- KB_1_2_ROW:   Number of records with LOB size between 1000 and 1999 byte
- KB_1_2_GB:    Total size of records with LOB size between 1000 and 1999 byte (GB)
- KB_2_4_ROW:   Number of records with LOB size between 2000 and 3999 byte
- KB_2_4_GB:    Total size of records with LOB size between 2000 and 3999 byte (GB)
- KB_4_8_ROW:   Number of records with LOB size between 4000 and 7999 byte
- KB_4_8_GB:    Total size of records with LOB size between 4000 and 7999 byte (GB)
- KB_8_16_ROW:  Number of records with LOB size between 8000 and 15999 byte
- KB_8_16_GB:   Total size of records with LOB size between 8000 and 15999 byte (GB)
- KB_16_ROW:    Number of records with LOB size of 16000 byte and larger
- KB_16_GB:     Total size of records with LOB size of 16000 byte and larger (GB)

[EXAMPLE OUTPUT]

- In the first step a SELECT statement is generated based on the input parameters:

-----------------------------------------------------------------------------------------------------
|COMMAND                                                                                            |
-----------------------------------------------------------------------------------------------------
|SELECT                                                                                             |
|  'SAPABAP1' SCHEMA_NAME,                                                                          |
|  '/SEAL/OUT_CR340' TABLE_NAME,                                                                    |
|  'CLUSTD' COLUMN_NAME,                                                                            |
|  'FILE, PACKED' LOB_TYPE,                                                                         |
|  LPAD(COUNT(*), 12) TOTAL_ROW,                                                                    |
|  LPAD(TO_DECIMAL(SUM(LENGTH("CLUSTD")) / 1073741824, 10, 2), 9) TOTAL_GB,                         |
|  LPAD(TO_DECIMAL(AVG(LENGTH("CLUSTD")), 10, 0), 8) AVG_BYTE,                                      |
|  LPAD(SUM(CASE WHEN LENGTH("CLUSTD") < 1000 THEN 1 ELSE 0 END), 11) KB_0_1_ROW,                   |
|  LPAD(TO_DECIMAL(SUM(CASE WHEN LENGTH("CLUSTD") < 1000 THEN                                       |
|    LENGTH("CLUSTD") ELSE 0 END) / 1073741824, 10, 2), 9) KB_0_1_GB,                               |
|  LPAD(SUM(CASE WHEN LENGTH("CLUSTD") BETWEEN 1000 AND 1999 THEN 1 ELSE 0 END), 11) KB_1_2_ROW,    |
|  LPAD(TO_DECIMAL(SUM(CASE WHEN LENGTH("CLUSTD") BETWEEN 1000 AND 1999 THEN                        |
|    LENGTH("CLUSTD") ELSE 0 END) / 1073741824, 10, 2), 9) KB_1_2_GB,                               |
|  LPAD(SUM(CASE WHEN LENGTH("CLUSTD") BETWEEN 2000 AND 3999 THEN 1 ELSE 0 END), 11) KB_2_4_ROW,    |
|  LPAD(TO_DECIMAL(SUM(CASE WHEN LENGTH("CLUSTD") BETWEEN 2000 AND 3999 THEN                        |
|    LENGTH("CLUSTD") ELSE 0 END) / 1073741824, 10, 2), 9) KB_2_4_GB,                               |
|  LPAD(SUM(CASE WHEN LENGTH("CLUSTD") BETWEEN 4000 AND 7999 THEN 1 ELSE 0 END), 11) KB_4_8_ROW,    |
|  LPAD(TO_DECIMAL(SUM(CASE WHEN LENGTH("CLUSTD") BETWEEN 4000 AND 7999 THEN                        |
|    LENGTH("CLUSTD") ELSE 0 END) / 1073741824, 10, 2), 9) KB_4_8_GB,                               |
|  LPAD(SUM(CASE WHEN LENGTH("CLUSTD") BETWEEN 8000 AND 15999 THEN 1 ELSE 0 END), 11) KB_8_16_ROW,  |
|  LPAD(TO_DECIMAL(SUM(CASE WHEN LENGTH("CLUSTD") BETWEEN 8000 AND 15999 THEN                       |
|    LENGTH("CLUSTD") ELSE 0 END) / 1073741824, 10, 2), 10) KB_8_16_GB,                             |
|  LPAD(SUM(CASE WHEN LENGTH("CLUSTD") >= 16000 THEN 1 ELSE 0 END), 11) KB_16_ROW,                  |
|  LPAD(TO_DECIMAL(SUM(CASE WHEN LENGTH("CLUSTD") >= 16000 THEN                                     |
|    LENGTH("CLUSTD") ELSE 0 END) / 1073741824, 10, 2), 9) KB_16_GB                                 |
|FROM                                                                                               |
|  "SAPABAP1"."/SEAL/OUT_CR340"                                                                     |
|UNION ALL                                                                                          |
...
-----------------------------------------------------------------------------------------------------

- When the statement is executed, a result like as follows is generated:

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|TABLE_NAME     |COLUMN_NAME|LOB_TYPE    |TOTAL_ROW   |TOTAL_GB |AVG_BYTE|KB_0_1_ROW |KB_0_1_GB|KB_1_2_ROW |KB_1_2_GB|KB_2_4_ROW |KB_2_4_GB|KB_4_8_ROW |KB_4_8_GB|KB_8_16_ROW|KB_8_16_GB|KB_16_ROW  |KB_16_GB |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|/SEAL/OUT_CR340|CLUSTD     |FILE, PACKED|    18281283|   126.53|    7432|     297189|     0.12|     207784|     0.28|     440166|     1.23|   17336144|   124.88|          0|      0.00|          0|     0.00|
|SOFFCONT1      |CLUSTD     |FILE, PACKED|    43932046|  1165.81|   28493|    3166575|     0.76|     206508|     0.30|     464718|     1.10|     344477|     1.92|     717510|      7.92|   39032258|  1153.79|
|TST03          |DCONTENT   |FILE        |     4562205|    31.44|    7401|      23835|     0.01|      44284|     0.07|     331742|     0.80|    4155658|    30.51|       6686|      0.05|          0|     0.00|
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

BASIS_INFO AS
( SELECT                          /* Modification section */
    '%' SCHEMA_NAME,
    'SOFFCONT1' TABLE_NAME,
    '%' COLUMN_NAME,
    -1 MIN_LOBS
  FROM
    DUMMY
),
LOB_LIST AS
( SELECT
    MAX(LOB_NO) OVER () MAX_LOB_NO,
    LOB_NO,
    SCHEMA_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    LOB_TYPE,
    'TO_DECIMAL(' || CASE
      WHEN COLUMN_NAME = 'CLUSTD' THEN 'CLUSTR'
      WHEN TABLE_NAME = 'DBTABLOG' THEN 'DATALN'
      WHEN TABLE_NAME = 'TST03' THEN 'DDATALEN'
      ELSE 'LENGTH("' || COLUMN_NAME || '")' 
    END || ')' L
  FROM
  ( SELECT
      ROW_NUMBER() OVER (ORDER BY L.SCHEMA_NAME, L.TABLE_NAME, L.COLUMN_NAME) LOB_NO,
      L.SCHEMA_NAME,
      L.TABLE_NAME,
      L.COLUMN_NAME,
      MIN(L.LOB_STORAGE_TYPE) || MAP(MAX(L.LOB_STORAGE_TYPE), MIN(L.LOB_STORAGE_TYPE), '', ', ' || MAX(L.LOB_STORAGE_TYPE)) LOB_TYPE
    FROM
      BASIS_INFO BI,
      M_TABLE_LOB_STATISTICS L
    WHERE
      L.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
      L.TABLE_NAME LIKE BI.TABLE_NAME AND
      L.COLUMN_NAME LIKE BI.COLUMN_NAME
    GROUP BY
      L.SCHEMA_NAME,
      L.TABLE_NAME,
      L.COLUMN_NAME,
      BI.MIN_LOBS
    HAVING
      ( BI.MIN_LOBS = -1 OR SUM(L.LOB_COUNT) >= BI.MIN_LOBS )
  )
)
SELECT
  COMMAND
FROM
( SELECT LOB_NO,   10 LINE_NO, 'SELECT' COMMAND                                                                                             FROM LOB_LIST UNION ALL
  SELECT LOB_NO,   20, CHAR(32) || CHAR(32) || CHAR(39) || SCHEMA_NAME || CHAR(39) || CHAR(32) || 'SCHEMA_NAME,'                            FROM LOB_LIST UNION ALL
  SELECT LOB_NO,   30, CHAR(32) || CHAR(32) || CHAR(39) || TABLE_NAME || CHAR(39) || CHAR(32) || 'TABLE_NAME,'                              FROM LOB_LIST UNION ALL
  SELECT LOB_NO,   40, CHAR(32) || CHAR(32) || CHAR(39) || COLUMN_NAME || CHAR(39) || CHAR(32) || 'COLUMN_NAME,'                            FROM LOB_LIST UNION ALL
  SELECT LOB_NO,   45, CHAR(32) || CHAR(32) || CHAR(39) || LOB_TYPE || CHAR(39) || CHAR(32) || 'LOB_TYPE,'                                  FROM LOB_LIST UNION ALL
  SELECT LOB_NO,   50, CHAR(32) || CHAR(32) || 'LPAD(COUNT(*), 12) TOTAL_ROW,'                                                              FROM LOB_LIST UNION ALL
  SELECT LOB_NO,   60, CHAR(32) || CHAR(32) || 'LPAD(TO_DECIMAL(SUM(' || L || ') / 1073741824, 10, 2), 9) TOTAL_GB,'                        FROM LOB_LIST UNION ALL
  SELECT LOB_NO,   70, CHAR(32) || CHAR(32) || 'LPAD(TO_DECIMAL(AVG(' || L || '), 10, 0), 8) AVG_BYTE,'                                     FROM LOB_LIST UNION ALL
  SELECT LOB_NO,   80, CHAR(32) || CHAR(32) || 'LPAD(SUM(CASE WHEN ' || L || ' < 1000 THEN 1 ELSE 0 END), 10) KB_0_1_ROW,'                  FROM LOB_LIST UNION ALL
  SELECT LOB_NO,   90, CHAR(32) || CHAR(32) || 'LPAD(TO_DECIMAL(SUM(CASE WHEN ' || L || ' < 1000 THEN'                                      FROM LOB_LIST UNION ALL
  SELECT LOB_NO,   92, CHAR(32) || CHAR(32) || CHAR(32) || CHAR(32) || L || ' ELSE 0 END) / 1073741824, 10, 2), 9) KB_0_1_GB,'              FROM LOB_LIST UNION ALL
  SELECT LOB_NO,  100, CHAR(32) || CHAR(32) || 'LPAD(SUM(CASE WHEN ' || L || ' BETWEEN 1000 AND 1999 THEN 1 ELSE 0 END), 10) KB_1_2_ROW,'   FROM LOB_LIST UNION ALL
  SELECT LOB_NO,  110, CHAR(32) || CHAR(32) || 'LPAD(TO_DECIMAL(SUM(CASE WHEN ' || L || ' BETWEEN 1000 AND 1999 THEN'                       FROM LOB_LIST UNION ALL
  SELECT LOB_NO,  112, CHAR(32) || CHAR(32) || CHAR(32) || CHAR(32) || L || ' ELSE 0 END) / 1073741824, 10, 2), 9) KB_1_2_GB,'              FROM LOB_LIST UNION ALL
  SELECT LOB_NO,  120, CHAR(32) || CHAR(32) || 'LPAD(SUM(CASE WHEN ' || L || ' BETWEEN 2000 AND 3999 THEN 1 ELSE 0 END), 10) KB_2_4_ROW,'   FROM LOB_LIST UNION ALL
  SELECT LOB_NO,  130, CHAR(32) || CHAR(32) || 'LPAD(TO_DECIMAL(SUM(CASE WHEN ' || L || ' BETWEEN 2000 AND 3999 THEN'                       FROM LOB_LIST UNION ALL
  SELECT LOB_NO,  132, CHAR(32) || CHAR(32) || CHAR(32) || CHAR(32) || L || ' ELSE 0 END) / 1073741824, 10, 2), 9) KB_2_4_GB,'              FROM LOB_LIST UNION ALL
  SELECT LOB_NO,  140, CHAR(32) || CHAR(32) || 'LPAD(SUM(CASE WHEN ' || L || ' BETWEEN 4000 AND 7999 THEN 1 ELSE 0 END), 10) KB_4_8_ROW,'   FROM LOB_LIST UNION ALL
  SELECT LOB_NO,  150, CHAR(32) || CHAR(32) || 'LPAD(TO_DECIMAL(SUM(CASE WHEN ' || L || ' BETWEEN 4000 AND 7999 THEN'                       FROM LOB_LIST UNION ALL
  SELECT LOB_NO,  152, CHAR(32) || CHAR(32) || CHAR(32) || CHAR(32) || L || ' ELSE 0 END) / 1073741824, 10, 2), 9) KB_4_8_GB,'              FROM LOB_LIST UNION ALL
  SELECT LOB_NO,  160, CHAR(32) || CHAR(32) || 'LPAD(SUM(CASE WHEN ' || L || ' BETWEEN 8000 AND 15999 THEN 1 ELSE 0 END), 11) KB_8_16_ROW,' FROM LOB_LIST UNION ALL
  SELECT LOB_NO,  170, CHAR(32) || CHAR(32) || 'LPAD(TO_DECIMAL(SUM(CASE WHEN ' || L || ' BETWEEN 8000 AND 15999 THEN'                      FROM LOB_LIST UNION ALL
  SELECT LOB_NO,  172, CHAR(32) || CHAR(32) || CHAR(32) || CHAR(32) || L || ' ELSE 0 END) / 1073741824, 10, 2), 10) KB_8_16_GB,'            FROM LOB_LIST UNION ALL
  SELECT LOB_NO,  180, CHAR(32) || CHAR(32) || 'LPAD(SUM(CASE WHEN ' || L || ' >= 16000 THEN 1 ELSE 0 END), 11) KB_16_ROW,'                 FROM LOB_LIST UNION ALL
  SELECT LOB_NO,  190, CHAR(32) || CHAR(32) || 'LPAD(TO_DECIMAL(SUM(CASE WHEN ' || L || ' >= 16000 THEN'                                    FROM LOB_LIST UNION ALL
  SELECT LOB_NO,  192, CHAR(32) || CHAR(32) || CHAR(32) || CHAR(32) || L || ' ELSE 0 END) / 1073741824, 10, 2), 9) KB_16_GB'                FROM LOB_LIST UNION ALL
  SELECT LOB_NO,  200, 'FROM'                                                                                                               FROM LOB_LIST UNION ALL
  SELECT LOB_NO,  210, CHAR(32) || CHAR(32) || '"' || SCHEMA_NAME || '"."' || TABLE_NAME || '"'                                             FROM LOB_LIST UNION ALL
  SELECT LOB_NO,  220, 'UNION ALL'                                                                                                          FROM LOB_LIST WHERE LOB_NO != MAX_LOB_NO
)
ORDER BY
  LOB_NO,
  LINE_NO
