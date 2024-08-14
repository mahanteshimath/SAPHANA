SELECT
/* 

[NAME]

- HANA_Tables_ColumnStore_TableHostMapping

[DESCRIPTION]

- Display table sizes on different hosts

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/08/25:  1.0 (initial version)
- 2017/06/24:  1.1 (AGGREGATE_BY, record count, TABLE_GROUP_TYPE and TABLE_GROUP included)

[INVOLVED TABLES]

- M_CS_TABLES
- M_LANDSCAPE_HOST_CONFIGURATION

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

- TABLE_GROUP

  Table group name

  'SD_VBAK'       --> Table group SD_VBAK
  '%'             --> No restriction related to table group

- TABLE_GROUP_TYPE

  Table group type

  'sap.s4hana.tableset' --> Table group type sap.s4hana.tableset
  '%'                   --> No restriction related to table group type

- MIN_SIZE_MB

  Minimum size in MB

  10              --> Minimum size of 10 MB
  -1              --> No minimum size limitation

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'GROUP'         --> Aggregation by table group
  'SCHEMA, TABLE' --> Aggregation by schema and table
  'NONE'          --> No aggregation

- RESULT_ROWS

  Number of records to be returned by the query

  100             --> Return a maximum number of 100 records
  -1              --> Return all records

[OUTPUT PARAMETERS]

- SCHEMA:              Schema name
- TABLE_NAME:          Table name
- TABLE_GROUP:         Table group name
- TABLE_GROUP_TYPE:    Table group type
- PART:                Number of partitions
- TOTAL_GB:            Total table size (GB)
- TOTAL_ROWS:          Total records
- HOST_<id>_SIZE_ROWS: Table size and records on host <id> (host name found in line 1 of output, role found in line 2 of output)
                       format: <size_gb>GB / <million_rows>M

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------
|SCHEMA|TABLE_NAME|TABLE_GROUP     |TABLE_GROUP_TYPE   |PART|TOTAL_GB|TOTAL_ROWS|HOST_1_SIZE_ROWS |HOST_2_SIZE_ROWS |
---------------------------------------------------------------------------------------------------------------------
|HOST  |          |                |                   |    |        |          |saphana1         |saphana2         |
|ROLE  |          |                |                   |    |        |          |MASTER           |SLAVE            |
|      |          |                |                   |    |        |          |                 |                 |
|TOTAL |          |                |                   |    |13055.14|   309571M| 6582GB / 122508M| 6473GB / 187063M|
|      |          |                |                   |    |        |          |                 |                 |
|SAP%  |any       |                |                   |1151| 5395.89|   100377M| 5365GB /  99767M|   31GB /    610M|
|SAP%  |any       |SD_VBAK         |sap.s4hana.tableset| 254| 4213.38|   141227M|    0GB /      0M| 4213GB / 141227M|
|SAP%  |any       |FI_DOCUMENT     |sap.s4hana.tableset| 154| 1819.55|    37239M|    0GB /      0M| 1820GB /  37239M|
|SAP%  |any       |BC_CHDO         |sap.s4hana.tableset|  30|  706.49|    14359M|  706GB /  14359M|    0GB /      0M|
|SAP%  |any       |LE_LIKP         |sap.s4hana.tableset|  24|  232.47|     2622M|    0GB /      0M|  232GB /   2622M|
|SAP%  |any       |SD_VBAK         |abcdef.erp.tableset|  41|  166.39|     5097M|    0GB /      0M|  166GB /   5097M|
|SAP%  |any       |BC_WORKITEM     |sap.s4hana.tableset|  16|  150.84|      950M|  151GB /    950M|    0GB /      0M|
|SAP%  |any       |STATUS          |sap.s4hana.tableset|   7|   92.04|     2585M|   92GB /   2585M|    0GB /      0M|
|SAP%  |any       |MM_EKKO         |sap.s4hana.tableset|  34|   40.99|      821M|   41GB /    821M|    0GB /      0M|
|SAP%  |any       |BC_SBAL         |sap.s4hana.tableset|   6|   40.97|      136M|   41GB /    136M|    0GB /      0M|
|SAP%  |any       |GROUP_OSTR      |sap.s4hana.ostr    |  70|   30.59|      610M|   31GB /    610M|    0GB /      0M|
|SAP%  |any       |E071K           |                   |   4|   22.80|      724M|   23GB /    724M|    0GB /      0M|
---------------------------------------------------------------------------------------------------------------------

*/

  *
FROM
( SELECT TOP 1
    'HOST' SCHEMA,
    ' ' TABLE_NAME,
    ' ' TABLE_GROUP,
    ' ' TABLE_GROUP_TYPE,
    ' ' PARTS,
    ' ' TOTAL_GB,
    ' ' TOTAL_ROWS,
    HOST HOST_1_SIZE_ROWS,
    IFNULL(LEAD(HOST,  1) OVER (ORDER BY HOST), ' ') HOST_2_SIZE_ROWS,
    IFNULL(LEAD(HOST,  2) OVER (ORDER BY HOST), ' ') HOST_3_SIZE_ROWS,
    IFNULL(LEAD(HOST,  3) OVER (ORDER BY HOST), ' ') HOST_4_SIZE_ROWS,
    IFNULL(LEAD(HOST,  4) OVER (ORDER BY HOST), ' ') HOST_5_SIZE_ROWS,
    IFNULL(LEAD(HOST,  5) OVER (ORDER BY HOST), ' ') HOST_6_SIZE_ROWS,
    IFNULL(LEAD(HOST,  6) OVER (ORDER BY HOST), ' ') HOST_7_SIZE_ROWS,
    IFNULL(LEAD(HOST,  7) OVER (ORDER BY HOST), ' ') HOST_8_SIZE_ROWS,
    IFNULL(LEAD(HOST,  8) OVER (ORDER BY HOST), ' ') HOST_9_SIZE_ROWS,
    IFNULL(LEAD(HOST,  9) OVER (ORDER BY HOST), ' ') HOST_10_SIZE_ROWS,
    IFNULL(LEAD(HOST, 10) OVER (ORDER BY HOST), ' ') HOST_11_SIZE_ROWS,
    IFNULL(LEAD(HOST, 11) OVER (ORDER BY HOST), ' ') HOST_12_SIZE_ROWS,
    IFNULL(LEAD(HOST, 12) OVER (ORDER BY HOST), ' ') HOST_13_SIZE_ROWS,
    IFNULL(LEAD(HOST, 13) OVER (ORDER BY HOST), ' ') HOST_14_SIZE_ROWS,
    IFNULL(LEAD(HOST, 14) OVER (ORDER BY HOST), ' ') HOST_15_SIZE_ROWS,
    IFNULL(LEAD(HOST, 15) OVER (ORDER BY HOST), ' ') HOST_16_SIZE_ROWS
  FROM
    M_LANDSCAPE_HOST_CONFIGURATION
  ORDER BY
    HOST
)
UNION ALL
SELECT
  *
FROM
( SELECT TOP 1
    'ROLE' SCHEMA_NAME,
    ' ' TABLE_NAME,
    ' ' TABLE_GROUP,
    ' ' TABLE_GROUP_TYPE,
    ' ' PARTS,
    ' ' TOTAL_GB,
    ' ' TOTAL_ROWS,
    INDEXSERVER_ACTUAL_ROLE,
    IFNULL(LEAD(INDEXSERVER_ACTUAL_ROLE,  1) OVER (ORDER BY HOST), ' '),
    IFNULL(LEAD(INDEXSERVER_ACTUAL_ROLE,  2) OVER (ORDER BY HOST), ' '),
    IFNULL(LEAD(INDEXSERVER_ACTUAL_ROLE,  3) OVER (ORDER BY HOST), ' '),
    IFNULL(LEAD(INDEXSERVER_ACTUAL_ROLE,  4) OVER (ORDER BY HOST), ' '),
    IFNULL(LEAD(INDEXSERVER_ACTUAL_ROLE,  5) OVER (ORDER BY HOST), ' '),
    IFNULL(LEAD(INDEXSERVER_ACTUAL_ROLE,  6) OVER (ORDER BY HOST), ' '),
    IFNULL(LEAD(INDEXSERVER_ACTUAL_ROLE,  7) OVER (ORDER BY HOST), ' '),
    IFNULL(LEAD(INDEXSERVER_ACTUAL_ROLE,  8) OVER (ORDER BY HOST), ' '),
    IFNULL(LEAD(INDEXSERVER_ACTUAL_ROLE,  9) OVER (ORDER BY HOST), ' '),
    IFNULL(LEAD(INDEXSERVER_ACTUAL_ROLE, 10) OVER (ORDER BY HOST), ' '),
    IFNULL(LEAD(INDEXSERVER_ACTUAL_ROLE, 11) OVER (ORDER BY HOST), ' '),
    IFNULL(LEAD(INDEXSERVER_ACTUAL_ROLE, 12) OVER (ORDER BY HOST), ' '),
    IFNULL(LEAD(INDEXSERVER_ACTUAL_ROLE, 13) OVER (ORDER BY HOST), ' '),
    IFNULL(LEAD(INDEXSERVER_ACTUAL_ROLE, 14) OVER (ORDER BY HOST), ' '),
    IFNULL(LEAD(INDEXSERVER_ACTUAL_ROLE, 15) OVER (ORDER BY HOST), ' ')
  FROM
  ( SELECT
      HOST,
      MAP(INDEXSERVER_ACTUAL_ROLE, 'MASTER', 'COORDINATOR', 'SLAVE', 'WORKER', INDEXSERVER_ACTUAL_ROLE) INDEXSERVER_ACTUAL_ROLE
    FROM
      M_LANDSCAPE_HOST_CONFIGURATION
  )
  ORDER BY
    HOST
)
UNION ALL
SELECT
  ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
FROM
  DUMMY
UNION ALL
SELECT
  *
FROM
( SELECT TOP 1
    'TOTAL' SCHEMA_NAME,
    ' ' TABLE_NAME,
    ' ' TABLE_GROUP,
    ' ' TABLE_GROUP_TYPE,
    ' ' PART,
    LPAD(TO_DECIMAL(SUM(SIZE_GB) OVER (), 10, 2), 8) TOTAL_GB,
    LPAD(TO_DECIMAL(ROUND(SUM(RECORDS) OVER ()  / 1000000), 10, 0), 9) || 'M' TOTAL_ROWS,
    LPAD(TO_DECIMAL(ROUND(IFNULL(SIZE_GB                               , 0)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(IFNULL(RECORDS                               , 0) / 1000000), 10, 0), 7) || 'M',
    LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(SIZE_GB,  1) OVER (ORDER BY HOST), 0)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(RECORDS,  1) OVER (ORDER BY HOST), 0) / 1000000), 10, 0), 7) || 'M',
    LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(SIZE_GB,  2) OVER (ORDER BY HOST), 0)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(RECORDS,  2) OVER (ORDER BY HOST), 0) / 1000000), 10, 0), 7) || 'M',
    LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(SIZE_GB,  3) OVER (ORDER BY HOST), 0)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(RECORDS,  3) OVER (ORDER BY HOST), 0) / 1000000), 10, 0), 7) || 'M',
    LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(SIZE_GB,  4) OVER (ORDER BY HOST), 0)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(RECORDS,  4) OVER (ORDER BY HOST), 0) / 1000000), 10, 0), 7) || 'M',
    LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(SIZE_GB,  5) OVER (ORDER BY HOST), 0)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(RECORDS,  5) OVER (ORDER BY HOST), 0) / 1000000), 10, 0), 7) || 'M',
    LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(SIZE_GB,  6) OVER (ORDER BY HOST), 0)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(RECORDS,  6) OVER (ORDER BY HOST), 0) / 1000000), 10, 0), 7) || 'M',
    LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(SIZE_GB,  7) OVER (ORDER BY HOST), 0)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(RECORDS,  7) OVER (ORDER BY HOST), 0) / 1000000), 10, 0), 7) || 'M',
    LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(SIZE_GB,  8) OVER (ORDER BY HOST), 0)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(RECORDS,  8) OVER (ORDER BY HOST), 0) / 1000000), 10, 0), 7) || 'M',
    LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(SIZE_GB,  9) OVER (ORDER BY HOST), 0)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(RECORDS,  9) OVER (ORDER BY HOST), 0) / 1000000), 10, 0), 7) || 'M',
    LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(SIZE_GB, 10) OVER (ORDER BY HOST), 0)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(RECORDS, 10) OVER (ORDER BY HOST), 0) / 1000000), 10, 0), 7) || 'M',
    LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(SIZE_GB, 11) OVER (ORDER BY HOST), 0)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(RECORDS, 11) OVER (ORDER BY HOST), 0) / 1000000), 10, 0), 7) || 'M',
    LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(SIZE_GB, 12) OVER (ORDER BY HOST), 0)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(RECORDS, 12) OVER (ORDER BY HOST), 0) / 1000000), 10, 0), 7) || 'M',
    LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(SIZE_GB, 13) OVER (ORDER BY HOST), 0)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(RECORDS, 13) OVER (ORDER BY HOST), 0) / 1000000), 10, 0), 7) || 'M',
    LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(SIZE_GB, 14) OVER (ORDER BY HOST), 0)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(RECORDS, 14) OVER (ORDER BY HOST), 0) / 1000000), 10, 0), 7) || 'M',
    LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(SIZE_GB, 15) OVER (ORDER BY HOST), 0)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(IFNULL(LEAD(RECORDS, 15) OVER (ORDER BY HOST), 0) / 1000000), 10, 0), 7) || 'M'
  FROM
  ( SELECT
      H.HOST,
      IFNULL(SUM(T.ESTIMATED_MAX_MEMORY_SIZE_IN_TOTAL) / 1024 / 1024 / 1024, 0) SIZE_GB,
      SUM(RECORD_COUNT) RECORDS
    FROM
      M_LANDSCAPE_HOST_CONFIGURATION H LEFT OUTER JOIN
      M_CS_TABLES T ON
        H.HOST = T.HOST
    GROUP BY
      H.HOST
  )
  ORDER BY
    HOST
)
UNION ALL
SELECT
  ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
FROM
  DUMMY
UNION ALL
( SELECT
    SCHEMA_NAME,
    TABLE_NAME,
    TABLE_GROUP,
    TABLE_GROUP_TYPE,
    PART,
    TOTAL_GB,
    RECORDS TOTAL_ROWS,
    HOST_1_SIZE_ROWS,
    HOST_2_SIZE_ROWS,
    HOST_3_SIZE_ROWS,
    HOST_4_SIZE_ROWS,
    HOST_5_SIZE_ROWS,
    HOST_6_SIZE_ROWS,
    HOST_7_SIZE_ROWS,
    HOST_8_SIZE_ROWS,
    HOST_9_SIZE_ROWS,
    HOST_10_SIZE_ROWS,
    HOST_11_SIZE_ROWS,
    HOST_12_SIZE_ROWS,
    HOST_13_SIZE_ROWS,
    HOST_14_SIZE_ROWS,
    HOST_15_SIZE_ROWS,
    HOST_16_SIZE_ROWS
  FROM
  ( SELECT
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SCHEMA')     != 0 THEN SCHEMA_NAME      ELSE MAP(BI_SCHEMA_NAME,      '%', 'any', BI_SCHEMA_NAME)      END SCHEMA_NAME,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TABLE')      != 0 THEN TABLE_NAME       ELSE MAP(BI_TABLE_NAME,       '%', 'any', BI_TABLE_NAME)       END TABLE_NAME,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'GROUP_NAME') != 0 THEN TABLE_GROUP      ELSE MAP(BI_TABLE_GROUP,      '%', 'any', BI_TABLE_GROUP)      END TABLE_GROUP,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'GROUP_TYPE') != 0 THEN TABLE_GROUP_TYPE ELSE MAP(BI_TABLE_GROUP_TYPE, '%', 'any', BI_TABLE_GROUP_TYPE) END TABLE_GROUP_TYPE,
      LPAD(COUNT(*), 6) PART,
      LPAD(TO_DECIMAL(SUM(TOTAL_SIZE_GB), 10, 2), 8) TOTAL_GB,
      LPAD(TO_DECIMAL(ROUND(SUM(TOTAL_RECORDS) / 1000000), 10, 0), 9) || 'M' RECORDS,
      LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_1  THEN SIZE_GB ELSE 0 END)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_1  THEN RECORDS ELSE 0 END) / 1000000), 10, 0), 7) || 'M' HOST_1_SIZE_ROWS,
      LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_2  THEN SIZE_GB ELSE 0 END)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_2  THEN RECORDS ELSE 0 END) / 1000000), 10, 0), 7) || 'M' HOST_2_SIZE_ROWS,
      LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_3  THEN SIZE_GB ELSE 0 END)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_3  THEN RECORDS ELSE 0 END) / 1000000), 10, 0), 7) || 'M' HOST_3_SIZE_ROWS,
      LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_4  THEN SIZE_GB ELSE 0 END)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_4  THEN RECORDS ELSE 0 END) / 1000000), 10, 0), 7) || 'M' HOST_4_SIZE_ROWS,
      LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_5  THEN SIZE_GB ELSE 0 END)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_5  THEN RECORDS ELSE 0 END) / 1000000), 10, 0), 7) || 'M' HOST_5_SIZE_ROWS,
      LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_6  THEN SIZE_GB ELSE 0 END)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_6  THEN RECORDS ELSE 0 END) / 1000000), 10, 0), 7) || 'M' HOST_6_SIZE_ROWS,
      LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_7  THEN SIZE_GB ELSE 0 END)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_7  THEN RECORDS ELSE 0 END) / 1000000), 10, 0), 7) || 'M' HOST_7_SIZE_ROWS,
      LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_8  THEN SIZE_GB ELSE 0 END)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_8  THEN RECORDS ELSE 0 END) / 1000000), 10, 0), 7) || 'M' HOST_8_SIZE_ROWS,
      LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_9  THEN SIZE_GB ELSE 0 END)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_9  THEN RECORDS ELSE 0 END) / 1000000), 10, 0), 7) || 'M' HOST_9_SIZE_ROWS,
      LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_10 THEN SIZE_GB ELSE 0 END)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_10 THEN RECORDS ELSE 0 END) / 1000000), 10, 0), 7) || 'M' HOST_10_SIZE_ROWS,
      LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_11 THEN SIZE_GB ELSE 0 END)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_11 THEN RECORDS ELSE 0 END) / 1000000), 10, 0), 7) || 'M' HOST_11_SIZE_ROWS,
      LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_12 THEN SIZE_GB ELSE 0 END)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_12 THEN RECORDS ELSE 0 END) / 1000000), 10, 0), 7) || 'M' HOST_12_SIZE_ROWS,
      LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_13 THEN SIZE_GB ELSE 0 END)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_13 THEN RECORDS ELSE 0 END) / 1000000), 10, 0), 7) || 'M' HOST_13_SIZE_ROWS,
      LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_14 THEN SIZE_GB ELSE 0 END)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_14 THEN RECORDS ELSE 0 END) / 1000000), 10, 0), 7) || 'M' HOST_14_SIZE_ROWS,
      LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_15 THEN SIZE_GB ELSE 0 END)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_15 THEN RECORDS ELSE 0 END) / 1000000), 10, 0), 7) || 'M' HOST_15_SIZE_ROWS,
      LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_16 THEN SIZE_GB ELSE 0 END)), 10, 0), 5) || 'GB' || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(SUM(CASE WHEN HOST = HOST_16 THEN RECORDS ELSE 0 END) / 1000000), 10, 0), 7) || 'M' HOST_16_SIZE_ROWS,
      ROW_NUMBER () OVER (ORDER BY SUM(TOTAL_SIZE_GB) DESC) ROW_NUM,
      RESULT_ROWS
    FROM
    ( SELECT
        T.HOST,
        T.SCHEMA_NAME,
        T.TABLE_NAME,
        IFNULL(G.GROUP_NAME, '') TABLE_GROUP,
        IFNULL(G.GROUP_TYPE, '') TABLE_GROUP_TYPE,
        T.ESTIMATED_MAX_MEMORY_SIZE_IN_TOTAL / 1024 / 1024 / 1024 SIZE_GB,
        T.RECORD_COUNT RECORDS,
        T.ESTIMATED_MAX_MEMORY_SIZE_IN_TOTAL / 1024 / 1024 / 1024 TOTAL_SIZE_GB,
        T.RECORD_COUNT TOTAL_RECORDS,
        BI.SCHEMA_NAME BI_SCHEMA_NAME,
        BI.TABLE_NAME BI_TABLE_NAME,
        BI.TABLE_GROUP BI_TABLE_GROUP,
        BI.TABLE_GROUP_TYPE BI_TABLE_GROUP_TYPE,
        BI.AGGREGATE_BY,
        BI.MIN_SIZE_MB,
        BI.RESULT_ROWS,
        H.HOST_1,
        H.HOST_2,
        H.HOST_3,
        H.HOST_4,
        H.HOST_5,
        H.HOST_6,
        H.HOST_7,
        H.HOST_8,
        H.HOST_9,
        H.HOST_10,
        H.HOST_11,
        H.HOST_12,
        H.HOST_13,
        H.HOST_14,
        H.HOST_15,
        H.HOST_16
      FROM
      ( SELECT                 /* Modification section */
          'SAP%' SCHEMA_NAME,
          '%' TABLE_NAME,
          '%' TABLE_GROUP,
          '%' TABLE_GROUP_TYPE,
          -1 MIN_SIZE_MB,
          'NONE' AGGREGATE_BY,            /* SCHEMA, TABLE, GROUP_NAME, GROUP_TYPE of comma separated combinations, NONE for no aggregation */
          50  RESULT_ROWS
        FROM
          DUMMY
      ) BI,
      ( SELECT TOP 1
          HOST HOST_1,
          LEAD(HOST,  1) OVER (ORDER BY HOST) HOST_2,
          LEAD(HOST,  2) OVER (ORDER BY HOST) HOST_3,
          LEAD(HOST,  3) OVER (ORDER BY HOST) HOST_4,
          LEAD(HOST,  4) OVER (ORDER BY HOST) HOST_5,
          LEAD(HOST,  5) OVER (ORDER BY HOST) HOST_6,
          LEAD(HOST,  6) OVER (ORDER BY HOST) HOST_7,
          LEAD(HOST,  7) OVER (ORDER BY HOST) HOST_8,
          LEAD(HOST,  8) OVER (ORDER BY HOST) HOST_9,
          LEAD(HOST,  9) OVER (ORDER BY HOST) HOST_10,
          LEAD(HOST, 10) OVER (ORDER BY HOST) HOST_11,
          LEAD(HOST, 11) OVER (ORDER BY HOST) HOST_12,
          LEAD(HOST, 12) OVER (ORDER BY HOST) HOST_13,
          LEAD(HOST, 13) OVER (ORDER BY HOST) HOST_14,
          LEAD(HOST, 14) OVER (ORDER BY HOST) HOST_15,
          LEAD(HOST, 15) OVER (ORDER BY HOST) HOST_16
        FROM
          M_LANDSCAPE_HOST_CONFIGURATION
      ) H,
        M_CS_TABLES T LEFT OUTER JOIN
        TABLE_GROUPS G ON
          G.SCHEMA_NAME = T.SCHEMA_NAME AND
          G.TABLE_NAME = T.TABLE_NAME
      WHERE
        T.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
        T.TABLE_NAME LIKE BI.TABLE_NAME AND
        IFNULL(G.GROUP_NAME, '') LIKE BI.TABLE_GROUP AND
        IFNULL(G.GROUP_TYPE, '') LIKE BI.TABLE_GROUP_TYPE
    )
    WHERE
      TOTAL_SIZE_GB >= MIN_SIZE_MB / 1024
    GROUP BY
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SCHEMA')     != 0 THEN SCHEMA_NAME      ELSE MAP(BI_SCHEMA_NAME,      '%', 'any', BI_SCHEMA_NAME)      END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TABLE')      != 0 THEN TABLE_NAME       ELSE MAP(BI_TABLE_NAME,       '%', 'any', BI_TABLE_NAME)       END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'GROUP_NAME') != 0 THEN TABLE_GROUP      ELSE MAP(BI_TABLE_GROUP,      '%', 'any', BI_TABLE_GROUP)      END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'GROUP_TYPE') != 0 THEN TABLE_GROUP_TYPE ELSE MAP(BI_TABLE_GROUP_TYPE, '%', 'any', BI_TABLE_GROUP_TYPE) END,
      RESULT_ROWS 
  )
  WHERE
    ( RESULT_ROWS = -1 OR ROW_NUM <= RESULT_ROWS )
  ORDER BY
    ROW_NUM
)
