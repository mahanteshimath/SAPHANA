SELECT
/* 

[NAME]

HANA_Tables_ColumnStore_PersistentMergeDisabled

[DESCRIPTION]

- Displays tables with disabled persistent merge

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/11/05:  1.0 (initial version)

[INVOLVED TABLES]

- M_CS_TABLES

[INPUT PARAMETERS]

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- TABLE_NAME:           

  Table name or pattern

  'T000'          --> Specific table T000
  'T%'            --> All tables starting with 'T'
  '%'             --> All tables

- OBJECT_LEVEL

  Controls display of partitions

  'PARTITION'     --> Result is shown on partition level
  'TABLE'         --> Result is shown on table level

[OUTPUT PARAMETERS]

- SCHEMA_NAME:      Schema name
- TABLE_NAME:       Table name
- PERSISTENT_MERGE: Persistent merge configuration on table level (FALSE: memory merge)

[EXAMPLE OUTPUT]

----------------------------------------------------
|SCHEMA_NAME|TABLE_NAME           |PERSISTENT_MERGE|
----------------------------------------------------
|SAPSR3     |/1ACC/CTX__M8001     |FALSE           |
|SAPSR3     |/1ACC/CTX__M8002     |FALSE           |
|SAPSR3     |/1ACC/EDG__M8001     |FALSE           |
|SAPSR3     |/1ACC/EDG__M8002     |FALSE           |
|SAPSR3     |/1ACC/EDG__M8003     |FALSE           |
|SAPSR3     |/1ACC/EDG__M8004     |FALSE           |
|SAPSR3     |/1ACC/EDG__M8005     |FALSE           |
|SAPSR3     |/1ACC/EDG__M8006     |FALSE           |
|SAPSR3     |/1ACC/EDG__M8007     |FALSE           |
|SAPSR3     |/1ACC/EDG__M8008     |FALSE           |
|SAPSR3     |/1ACC/FOB__M8001     |FALSE           |
----------------------------------------------------

*/
  DISTINCT
  T.SCHEMA_NAME,
  T.TABLE_NAME || CASE WHEN BI.OBJECT_LEVEL = 'PARTITION' AND T.PART_ID != 0 THEN ' (' || T.PART_ID || ')' ELSE '' END TABLE_NAME,
  T.PERSISTENT_MERGE
FROM
( SELECT                  /* Modification section */
    '%' SCHEMA_NAME,
    '%' TABLE_NAME,
    'TABLE' OBJECT_LEVEL
  FROM
    DUMMY
) BI,
  M_CS_TABLES T
WHERE
  T.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  T.TABLE_NAME LIKE BI.TABLE_NAME AND
  T.PERSISTENT_MERGE = 'FALSE' 
ORDER BY
  T.SCHEMA_NAME,
  T.TABLE_NAME || CASE WHEN BI.OBJECT_LEVEL = 'PARTITION' AND T.PART_ID != 0 THEN ' (' || T.PART_ID || ')' ELSE '' END
