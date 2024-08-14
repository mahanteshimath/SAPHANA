SELECT
/* 

[NAME]

- HANA_Indexes_MultiColumnIndexesWithClient_1.00.100+

[DESCRIPTION]

- Determines indexes on two or more columns including ABAP client column

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- ORDER BY clause for STRING_AGG only available as of Rev. 100
- If a column store index is defined on two columns including the client column, it is usually much
  better from a memory perspective to omit the client column
- From performance perspective it can be also helpful to omit the client in indexes on more than two columns

[VALID FOR]

- Revisions:              >= 1.00.100

[SQL COMMAND VERSION]

- 2016/09/25:  1.0 (initial version)

[INVOLVED TABLES]

- INDEX_COLUMNS
- M_TABLES

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

- INDEX_NAME

  Index name or pattern

  'EDIDC~1'       --> Specific index EDIDC~1
  '%~2'           --> All indexes ending with '~2'
  '%'             --> All indexes

- EXCLUDE_PK_AND_UNIQUE

  Possibility to exclude columns related to primary keys and unique indexes

  'X'             --> Exclude columns related to primary keys and unique indexes
  ' '             --> No restriction related to primary keys and unique indexes

- MAX_INDEX_COLUMNS

  Maximum number of index columns

  2               --> Only consider indexes with a maximum number of 2 columns
  -1              --> No restriction related to maximum number of index columns

- MIN_TABLE_RECORDS

  Minimum number of table records

  1000000         --> Only consider indexes of tables with at least 1000000 records
  -1              --> No restriction related to table records

[OUTPUT PARAMETERS]

- SCHEMA_NAME:   Schema name
- TABLE_NAME:    Table name
- STORE:         Store (ROW, COLUMN)
- RECORDS:       Number of table records
- INDEX_NAME:    Index name
- INDEX_COLUMNS: Index columns

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------
|SCHEMA_NAME|TABLE_NAME      |STORE |RECORDS     |INDEX_NAME        |INDEX_COLUMNS          |
---------------------------------------------------------------------------------------------
|SAPSR3     |/FLDQ/AD_MTCCODE|COLUMN|     6082573|/FLDQ/AD_MTCCODE01|CLIENT, MATCH_CODE1    |
|SAPSR3     |/FLDQ/AD_MTCCODE|COLUMN|     6082573|/FLDQ/AD_MTCCODE02|CLIENT, MTC_CODE_NM1   |
|SAPSR3     |/FLDQ/AD_MTCCODE|COLUMN|     6082573|/FLDQ/AD_MTCCODE03|CLIENT, MTC_CODE_NM2   |
|SAPSR3     |/FLDQ/AD_MTCCODE|COLUMN|     6082573|/FLDQ/AD_MTCCODE04|CLIENT, MTC_CODE_NM3   |
|SAPSR3     |/FLDQ/AD_MTCCODE|COLUMN|     6082573|/FLDQ/AD_MTCCODE05|CLIENT, MTC_CODE_NM4   |
|SAPSR3     |/FLDQ/AD_MTCCODE|COLUMN|     6082573|/FLDQ/AD_MTCCODE06|CLIENT, MTC_CODE_NM5   |
|SAPSR3     |/FLDQ/AD_MTCCODE|COLUMN|     6082573|/FLDQ/AD_MTCCODE07|CLIENT, PO_MATCH_CODE  |
|SAPSR3     |ADRC            |COLUMN|     5581764|ADRC~IU1          |CLIENT, ADDR_GROUP     |
|SAPSR3     |ADRC            |COLUMN|     5581764|ADRC~IU2          |CLIENT, MC_STREET      |
|SAPSR3     |ADRC            |COLUMN|     5581764|ADRC~IU3          |CLIENT, MC_CITY1       |
|SAPSR3     |Y0AUD_ANSWER    |COLUMN|    13147228|Y0AUD_ANSWER~Y01  |MANDT, AUDIT_GROUP_GUID|
|SAPSR3     |Y0AUD_AUDIT_GRP |COLUMN|     1965809|Y0AUD_AUDIT_GRP~Y0|MANDT, ACTIVITY_GUID   |
|SAPSR3     |Y0AUD_CALC_RES  |COLUMN|     2442017|Y0AUD_CALC_RES~Y01|MANDT, ACTIVITY_GUID   |
|SAPSR3     |Y0DPI_TDLINX_OUT|COLUMN|     3838166|Y0DPI_TDLINX_OUTY0|CLIENT, ACCT_CODE_OWNER|
|SAPSR3     |Y0DPL_INVOICES_H|COLUMN|    22635462|Y0DPL_INVOICES_HY2|MANDT, INV_DATE        |
|SAPSR3     |Y0DPL_INVOICES_P|COLUMN|    40597344|Y0DPL_INVOICES_PY0|MANDT, INV_DATE        |
|SAPSR3     |Y0MDM_DP_LAYER  |COLUMN|     4029154|Y0MDM_DP_LAYER~Y02|CLIENT, MASTER_STORE_ID|
|SAPSR3     |Y0MDM_DP_LAYER  |COLUMN|     4029154|Y0MDM_DP_LAYER~Y03|CLIENT, EXTERNAL_KEY   |
|SAPSR3     |Y0TPM_ACCR_EF   |COLUMN|   327070822|Y0TPM_ACCR_EF~Y1  |MANDT, GUID            |
---------------------------------------------------------------------------------------------

*/

  SCHEMA_NAME,
  TABLE_NAME,
  STORE,
  LPAD(RECORD_COUNT, 12) RECORDS,
  INDEX_NAME,
  INDEX_COLUMNS
FROM
( SELECT
    IC.SCHEMA_NAME,
    IC.TABLE_NAME,
    T.TABLE_TYPE STORE,
    T.RECORD_COUNT,
    IC.INDEX_NAME,
    STRING_AGG(IC.COLUMN_NAME, ', ' ORDER BY IC.POSITION) INDEX_COLUMNS,
    SUM(MAP(IC.COLUMN_NAME, 'MANDT', 1, 'MANDANT', 1, 'CLIENT', 1, 'DCLIENT', 1, 0)) NUM_CLIENT_COLUMNS,
    COUNT(*) NUM_COLUMNS,
    BI.MAX_INDEX_COLUMNS
  FROM
  ( SELECT                      /* Modification section */
      'SAP%' SCHEMA_NAME,
      '%' TABLE_NAME,
      '%' INDEX_NAME,
      'COLUMN' STORE,
      'X' EXCLUDE_PK_AND_UNIQUE,
      2 MAX_INDEX_COLUMNS,
      1000000 MIN_TABLE_RECORDS
    FROM
      DUMMY
  ) BI,
    INDEX_COLUMNS IC,
    M_TABLES T
  WHERE
    IC.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    IC.TABLE_NAME LIKE BI.TABLE_NAME AND
    IC.INDEX_NAME LIKE BI.INDEX_NAME AND
    IC.SCHEMA_NAME = T.SCHEMA_NAME AND
    IC.TABLE_NAME = T.TABLE_NAME AND
    T.TABLE_TYPE LIKE BI.STORE AND
    ( BI.MIN_TABLE_RECORDS = -1 OR T.RECORD_COUNT >= BI.MIN_TABLE_RECORDS ) AND
    ( BI.EXCLUDE_PK_AND_UNIQUE = ' ' OR
      ( IFNULL(IC.CONSTRAINT, '') NOT LIKE '%UNIQUE%' AND IFNULL(IC.CONSTRAINT, '') NOT LIKE '%PRIMARY KEY%' )
    )
  GROUP BY
    IC.SCHEMA_NAME,
    IC.TABLE_NAME,
    T.TABLE_TYPE,
    T.RECORD_COUNT,
    IC.INDEX_NAME,
    BI.MAX_INDEX_COLUMNS
  HAVING
    COUNT(*) BETWEEN 2 AND MAP(BI.MAX_INDEX_COLUMNS, -1, 9999, BI.MAX_INDEX_COLUMNS)
)
WHERE
  NUM_CLIENT_COLUMNS >= 1
ORDER BY
  SCHEMA_NAME,
  TABLE_NAME,
  INDEX_NAME
