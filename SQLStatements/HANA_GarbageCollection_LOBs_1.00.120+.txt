SELECT

/* 

[NAME]

- HANA_GarbageCollection_LOBs_1.00.120+

[DESCRIPTION]

- Check for orphan disk LOBs (consequence of blocked or slow garbage collection)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_TABLE_LOB_STATISTICS available with SAP HANA >= 1.00.120
- ORPHAN_LOBS is a best case value assuming that all records of the table have a related disk LOB.
- In case of memory LOBs the actual number of orphan LOBs can be higher than the displayed optimistic value.

[VALID FOR]

- Revisions:              >= 1.00.120

[SQL COMMAND VERSION]

- 2017/01/06  1.0 (initial version)
- 2018/07/24  1.1 (orphan LOBs on individual column rather global table basis)

[INVOLVED TABLES]

- M_TABLE_LOB_STATISTICS
- M_TABLES
- TABLE_COLUMNS

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

- MIN_ORPHAN_LOBS

  Minimum number of orphan LOBs

  100             --> Only display tables with at last 100 orphan LOBs
  -1              --> No restriction related to orphan LOBs

[OUTPUT PARAMETERS]

- SCHEMA_NAME: Schema name
- TABLE_NAME:  Table name
- S:           Table store ('R' -> row store, 'C' -> column store)
- RECORDS:     Table records
- LOB_COLUMNS: Number of LOB columns of the table
- DISK_LOBS:   Actual number of existing disk LOBs
- ORPHAN_LOBS: (Optimistic) number of orphan LOBs

[EXAMPLE OUTPUT]

------------------------------------------------------------------------
|SCHEMA_NAME|TABLE_NAME  |RECORDS   |LOB_COLUMNS|DISK_LOBS |ORPHAN_LOBS|
------------------------------------------------------------------------
|SAPERP     |VBDATA      |    596250|          1| 277699029|  277102779|
|SAPERP     |TST03       |  15129479|          1| 133686336|  118556857|
|SAPERP     |QRFC_O_SDATA|   1046177|          1|   1163376|     117199|
|SAPERP     |DDLOG       |      7184|          1|     97379|      90195|
|SAPERP     |DYNPLOAD    |     91262|          1|    136884|      45622|
|SAPERP     |INDX_HIER   |     16026|          1|     60706|      44680|
|SAPERP     |CIF_IMOD    |     76040|          1|    105320|      29280|
|SAPERP     |CIF_IMAX    |       132|          1|      8419|       8287|
|SAPERP     |STXB        |      4706|          1|      4973|        267|
------------------------------------------------------------------------

*/

  SCHEMA_NAME,
  TABLE_NAME,
  MAP(IS_COLUMN_TABLE, 'TRUE', 'C', 'R') S,
  LPAD(RECORD_COUNT, 10) RECORDS,
  LPAD(LOB_COLUMNS, 11) LOB_COLUMNS,
  LPAD(LOB_COUNT, 10) DISK_LOBS,
  LPAD(ORPHAN_LOBS, 11) ORPHAN_LOBS,
  LPAD(TO_DECIMAL(ORPHAN_SIZE_GB, 10, 2), 14) ORPHAN_SIZE_GB
FROM
( SELECT
    SCHEMA_NAME,
    TABLE_NAME,
    IS_COLUMN_TABLE,
    MAX(RECORD_COUNT) RECORD_COUNT,
    COUNT(*) LOB_COLUMNS,
    SUM(LOB_COUNT) LOB_COUNT,
    SUM(ORPHAN_LOBS) ORPHAN_LOBS,
    SUM(ORPHAN_SIZE_GB) ORPHAN_SIZE_GB,
    MIN_ORPHAN_LOBS
  FROM
  ( SELECT
      T.SCHEMA_NAME,
      T.TABLE_NAME,
      L.COLUMN_NAME,
      T.IS_COLUMN_TABLE,
      T.RECORD_COUNT,
      L.LOB_COUNT,
      GREATEST(0, L.LOB_COUNT - T.RECORD_COUNT) ORPHAN_LOBS,
      GREATEST(0, MAP(L.LOB_COUNT, 0, 0, L.DISK_SIZE / L.LOB_COUNT * (L.LOB_COUNT - T.RECORD_COUNT ) / 1024 / 1024 / 1024)) ORPHAN_SIZE_GB,
      BI.MIN_ORPHAN_LOBS
    FROM
    ( SELECT             /* Modification section */
        '%' SCHEMA_NAME,
        '%' TABLE_NAME,
        100 MIN_ORPHAN_LOBS
      FROM
        DUMMY
    ) BI,
      M_TABLE_LOB_STATISTICS L,
      M_TABLES T
    WHERE
      L.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
      L.TABLE_NAME LIKE BI.TABLE_NAME AND
      T.SCHEMA_NAME = L.SCHEMA_NAME AND
      T.TABLE_NAME = L.TABLE_NAME
  )
  GROUP BY
    SCHEMA_NAME,
    TABLE_NAME,
    IS_COLUMN_TABLE,
    MIN_ORPHAN_LOBS
)
WHERE
  ( MIN_ORPHAN_LOBS = -1 OR ORPHAN_LOBS >= MIN_ORPHAN_LOBS )
ORDER BY
  ORPHAN_LOBS DESC
