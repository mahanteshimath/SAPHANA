SELECT
/* 

[NAME]

- HANA_Tables_ColumnStore_TablesWithoutCompressionOptimization

[DESCRIPTION]

- List column store tables that have never been considered for compression optimization

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/12/28:  1.0 (initial version)
- 2017/11/08:  1.1 (exclusion of temporary tables)

[INVOLVED TABLES]

- M_CS_TABLES

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

- MIN_MAIN_RECORDS

  Minimum number of main storage records

  100000          --> Only display tables with at least 100,000 records in main storage
  -1              --> No restriction related to main storage records

- MIN_MAX_MEM_SIZE_MB

  Minimum threshold for the maximum table memory size (MB)

  
  500             --> Only consider tables with a maximum memory size of 500 MB or higher
  -1              --> No restriction related to maximum memory size

[OUTPUT PARAMETERS]

- SCHEMA:                  Schema name
- TABLE_NAME:              Table name
- PARTS:                   Number of qualifying partitions (not necessarily all table partitions)
- RECORDS_MAIN:            Number of records in main storage in all qualifying partitions
- MAX_MEM_SIZE_GB:         Maximum memory size of all qualifying partitions (GB) 
- COMPRESSION_COMMAND:     SQL command for forcing a new compression optimization

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SCHEMA   |TABLE_NAME        |PARTS     |RECORDS_MAIN|MAX_MEM_SIZE_GB|COMPRESSION_COMMAND                                                                        |
------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SAPSR3   |SWWCNTP0          |         1|    11238520|           2.71|UPDATE "SAPSR3"."SWWCNTP0" WITH PARAMETERS ('OPTIMIZE_COMPRESSION' = 'FORCE')              |
|SAPSR3   |SCR_ABAP_AST      |         1|     7758582|           1.66|UPDATE "SAPSR3"."SCR_ABAP_AST" WITH PARAMETERS ('OPTIMIZE_COMPRESSION' = 'FORCE')          |
------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  CT.SCHEMA_NAME SCHEMA,
  CT.TABLE_NAME TABLE_NAME,
  LPAD(COUNT(*), 10) PARTS,
  LPAD(SUM(CT.RAW_RECORD_COUNT_IN_MAIN), 12) RECORDS_MAIN,
  LPAD(TO_DECIMAL(SUM(CT.ESTIMATED_MAX_MEMORY_SIZE_IN_TOTAL) / 1024 / 1024 / 1024, 10, 2), 15) MAX_MEM_SIZE_GB,
  'UPDATE' || CHAR(32) || '"' || CT.SCHEMA_NAME || '"."' || CT.TABLE_NAME || '" WITH PARAMETERS (' || CHAR (39) || 'OPTIMIZE_COMPRESSION' || CHAR(39) || CHAR(32) || '=' || 
    CHAR(32) || CHAR(39) || 'FORCE' || CHAR(39) || ');' COMPRESSION_COMMAND
FROM
( SELECT                   /* Modification section */
    '%' SCHEMA_NAME,
    '%' TABLE_NAME,
    10000000 MIN_MAIN_RECORDS,
    -1 MIN_MAX_MEM_SIZE_MB
  FROM
    DUMMY
) BI,
  TABLES T,
  M_CS_TABLES CT
WHERE
  CT.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  CT.TABLE_NAME LIKE BI.TABLE_NAME AND
  T.SCHEMA_NAME = CT.SCHEMA_NAME AND
  T.TABLE_NAME = CT.TABLE_NAME AND
  T.IS_TEMPORARY = 'FALSE' AND
  CT.LAST_COMPRESSED_RECORD_COUNT = 0 AND
  ( BI.MIN_MAIN_RECORDS = -1 OR CT.RAW_RECORD_COUNT_IN_MAIN >= BI.MIN_MAIN_RECORDS ) AND
  ( BI.MIN_MAX_MEM_SIZE_MB = -1 OR CT.ESTIMATED_MAX_MEMORY_SIZE_IN_TOTAL / 1024 / 1024 >= BI.MIN_MAX_MEM_SIZE_MB )
GROUP BY
  CT.SCHEMA_NAME,
  CT.TABLE_NAME
ORDER BY
  SUM(CT.ESTIMATED_MAX_MEMORY_SIZE_IN_TOTAL) DESC
