SELECT
/* 

[NAME]

- HANA_Indexes_ColumnStore_RedundantIndexes

[DESCRIPTION]

- Determine single column indexes on columns which are already part of primary key or unique indexes

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Single column indexes (inverted indexes) are automatically created on every single column of a primary key or unique index
- Single column indexes may be created by optimize compression
- Be aware that this kind of redundant indexes does not indicate a problem and there is no need to eliminate redundancy.

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/12/04:  1.0 (initial version)

[INVOLVED TABLES]

- INDEX_COLUMNS

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
 
[OUTPUT PARAMETERS]

- SCHEMA_NAME:         Schema name
- TABLE_NAME:          Table name
- COLUMN_NAME:         Column name
- SINGLE_COLUMN_INDEX: Name of single column index on this column
- PK_UNIQUE_INDEX:     Name of primary key or unique multi column index containing this column

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME     |TABLE_NAME                                 |COLUMN_NAME    |SINGLE_COLUMN_INDEX                         |PK_UNIQUE_INDEX                 |
------------------------------------------------------------------------------------------------------------------------------------------------------------
|SAPSR3          |/BDL/CONTAB                                |SESSIONNR      |/BDL/CONTAB~1                               |_SYS_TREE_CS_#765026_#0_#P0     |
|SAPSR3          |/BDL/MSGLOG                                |TIMESTAMP      |/BDL/MSGLOG~1                               |_SYS_TREE_CS_#151042_#0_#P0     |
|SAPSR3          |/BDL/SDCCLOG                               |TIMESTAMP      |/BDL/SDCCLOG~1                              |_SYS_TREE_CS_#765054_#0_#P0     |
|SAPSR3          |/BDL/TASK_LOG                              |TIMESTAMP      |/BDL/TASK_LOG~1                             |_SYS_TREE_CS_#151328_#0_#P0     |
|SAPSR3          |/BOBF/OBM_QUERY                            |QUERY_KEY      |/BOBF/OBM_QUERY~CT                          |_SYS_TREE_CS_#191410_#0_#P0     |
|SAPSR3          |/IWFND/SU_GWTEST                           |TESTCASE       |/IWFND/SU_GWTEST~1                          |_SYS_TREE_CS_#153425_#0_#P0     |
|SAPSR3          |/SDF/HDB_MON_HIS                           |TIME_STAMP     |/SDF/HDB_MON_HISTS                          |_SYS_TREE_CS_#834303_#0_#P0     |
|SAPSR3          |/UI2/CHIP_CHDRMT                           |LANGU          |/UI2/CHIP_CHDRMTLA                          |_SYS_TREE_CS_#157002_#0_#P0     |
|SAPSR3          |/UI2/CHIP_CHDRT                            |LANGU          |/UI2/CHIP_CHDRT~LA                          |_SYS_TREE_CS_#157025_#0_#P0     |
|SAPSR3          |AAA                                        |OBJECT_NAME    |AAA~1                                       |AAA~0                           |
|SAPSR3          |ADMI_FILES                                 |ARCHIV_KEY     |ADMI_FILES~KEY                              |_SYS_TREE_CS_#158018_#0_#P0     |
------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  SCI.SCHEMA_NAME,
  SCI.TABLE_NAME,
  SCI.COLUMN_NAME,
  SCI.INDEX_NAME SINGLE_COLUMN_INDEX,
  MCI.INDEX_NAME PK_UNIQUE_INDEX
FROM
( SELECT                /* Modification section */
    '%' SCHEMA_NAME,
    '%' TABLE_NAME
  FROM
    DUMMY
) BI,
( SELECT
    SCHEMA_NAME,
    TABLE_NAME,
    INDEX_NAME,
    MIN(COLUMN_NAME) COLUMN_NAME
  FROM
    INDEX_COLUMNS
  GROUP BY
    SCHEMA_NAME,
    TABLE_NAME,
    INDEX_NAME
  HAVING
    COUNT(*) = 1
) SCI,
( SELECT
    IC.SCHEMA_NAME,
    IC.TABLE_NAME,
    IC.INDEX_NAME,
    IC.COLUMN_NAME,
    IC.CONSTRAINT
  FROM
  ( SELECT
      SCHEMA_NAME,
      TABLE_NAME,
      INDEX_NAME
    FROM
      INDEX_COLUMNS
    GROUP BY
      SCHEMA_NAME,
      TABLE_NAME,
      INDEX_NAME
    HAVING
      COUNT(*) > 1
  ) MCI,
    INDEX_COLUMNS IC
  WHERE
    IC.SCHEMA_NAME = MCI.SCHEMA_NAME AND
    IC.TABLE_NAME = MCI.TABLE_NAME AND
    IC.INDEX_NAME = MCI.INDEX_NAME AND
    IC.CONSTRAINT IN ('PRIMARY KEY', 'UNIQUE', 'NOT NULL UNIQUE')
) MCI
WHERE
  SCI.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  SCI.TABLE_NAME LIKE BI.TABLE_NAME AND
  SCI.SCHEMA_NAME = MCI.SCHEMA_NAME AND
  SCI.TABLE_NAME = MCI.TABLE_NAME AND
  SCI.COLUMN_NAME = MCI.COLUMN_NAME
ORDER BY
  SCI.SCHEMA_NAME,
  SCI.TABLE_NAME
