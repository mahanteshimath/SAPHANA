WITH 

/* 

[NAME]

- HANA_Data_Schemas

[DESCRIPTION]

- Matrix of largest tables in largest schemas

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Takes advantage of WITH clause, so may not work with older DBACOCKPIT versions
- WITH clause requires at least Rev. 1.00.70
- WITH clause does not work with older DBACOCKPIT transactions before SAP BASIS 7.02 SP16 / 7.30 SP12 / 7.31 SP12 / SAP_BASIS 7.40 SP07 (empty result returned) 

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2019/03/02:  1.0 (initial version)

[INVOLVED TABLES]

- M_CS_TABLES
- M_RS_INDEXES
- M_RS_TABLES
- M_TABLE_PERSISTENCE_STATISTICS

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

- MIN_SIZE_MB

  Minimum table size (MB)

  1024            --> Only consider tables with a size of at least 1024 MB
  -1              --> No restriction related to table size

- SCHEMA_ORDER

  Sorting of schema columns

  'NAME'          --> Sort by schema name
  'SIZE'          --> Sort by schema size

- SIZE_CATEGORY

  Size used for sorting

  'DISK'          --> Disk size
  'CURRENT_MEM'   --> Current memory size
  'MAX_MEM'       --> Maximum memory size

- RESULT_ROWS

  Number of records to be returned by the query

  100             --> Return a maximum number of 100 records
  -1              --> Return all records

[OUTPUT PARAMETERS]

- TABLE_NAME:    Table name
- TOTAL_SIZE_GB: Total table size on disk (GB)
- SIZE_GB_<n>:   Size of schema <n> (GB)

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------------------
|TABLE_NAME                         |TOTAL_SIZE_GB|SIZE_GB_1       |SIZE_GB_2       |SIZE_GB_3       |SIZE_GB_4       |SIZE_GB_5       |
----------------------------------------------------------------------------------------------------------------------------------------
|SCHEMAS                            |             |HANA_STOCKPM7622|HANA_STOCKPM8057|HANA_STOCKPM8092|HANA_STOCKPM8058|HANA_STOCKPM7659|
|                                   |             |                |                |                |                |                |
|TOTAL                              |     20471.42|   1365.24      |    921.39      |    853.66      |    835.41      |    684.10      |
|                                   |             |                |                |                |                |                |
|ATTACH_CONTENT                     |      6419.49|    741.57      |    357.98      |    340.74      |    324.64      |    271.90      |
|ATTACHMENT_IMAGE                   |      3405.39|    322.80      |    270.57      |    257.98      |    250.65      |    212.90      |
|FORM_CONTENT                       |      1727.04|     17.84      |      2.41      |      2.04      |      1.96      |      1.61      |
|RCM_AUDIT_TRAIL                    |      1384.24|    107.62      |    118.34      |    102.96      |     93.75      |     67.94      |
|JOB_REQUEST                        |      1242.42|      5.41      |     13.07      |     10.84      |     10.63      |      9.48      |
|OBJ_AUDITTRAIL                     |      1110.23|      1.51      |      0.96      |      0.97      |      1.27      |      0.77      |
|PHOTO                              |       536.70|     24.69      |     27.12      |     24.28      |     22.67      |     15.30      |
|FM2_FORM_ROUTE_AUD                 |       465.32|     46.67      |      1.23      |      0.96      |      0.93      |      0.87      |
|COMP_PLAN                          |       454.12|                |      0.04      |      0.04      |      0.04      |      0.02      |
|RCM_APPLICATION_CAND_INFO          |       376.07|     10.42      |     19.27      |     17.91      |     17.00      |     14.40      |
----------------------------------------------------------------------------------------------------------------------------------------

*/

BASIS_INFO AS
( SELECT                                       /* Modification section */
    '%' SCHEMA_NAME,
    '%' TABLE_NAME,
    1 MIN_SIZE_MB,
    'SIZE' SCHEMA_ORDER,                 /* NAME, SIZE */
    'DISK' SIZE_CATEGORY,                  /* DISK, CURRENT_MEM, MAX_MEM */
    50 RESULT_ROWS
  FROM
    DUMMY
),
TABLE_SIZES AS
( SELECT
    SCHEMA_NAME,
    TABLE_NAME,
    SIZE_MB
  FROM
  ( SELECT
      TP.SCHEMA_NAME,
      TP.TABLE_NAME,
      SUM(TP.DISK_SIZE) / 1024 / 1024 SIZE_MB
    FROM
      BASIS_INFO BI,
      M_TABLE_PERSISTENCE_STATISTICS TP
    WHERE
      BI.SIZE_CATEGORY = 'DISK' AND
      TP.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
      TP.TABLE_NAME LIKE BI.TABLE_NAME
    GROUP BY
      TP.SCHEMA_NAME,
      TP.TABLE_NAME,
      BI.SIZE_CATEGORY,
      BI.MIN_SIZE_MB
    HAVING
      SUM(TP.DISK_SIZE) / 1024 / 1024 >= BI.MIN_SIZE_MB
    UNION ALL
    SELECT
      T.SCHEMA_NAME,
      T.TABLE_NAME,
      MAP(BI.SIZE_CATEGORY, 'CURRENT_MEM', SUM(T.MEMORY_SIZE_IN_TOTAL) / 1024 / 1024, SUM(T.ESTIMATED_MAX_MEMORY_SIZE_IN_TOTAL) / 1024 / 1024) SIZE_MB
    FROM
      BASIS_INFO BI,
      M_CS_TABLES T
    WHERE
      BI.SIZE_CATEGORY IN ('CURRENT_MEM', 'MAX_MEM') AND
      T.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
      T.TABLE_NAME LIKE BI.TABLE_NAME
    GROUP BY
      T.SCHEMA_NAME,
      T.TABLE_NAME,
      BI.SIZE_CATEGORY,
      BI.MIN_SIZE_MB
    HAVING
      BI.SIZE_CATEGORY = 'CURRENT_MEM' AND SUM(T.MEMORY_SIZE_IN_TOTAL) / 1024 / 1024 >= BI.MIN_SIZE_MB OR
      BI.SIZE_CATEGORY = 'MAX_MEM' AND SUM(T.ESTIMATED_MAX_MEMORY_SIZE_IN_TOTAL) / 1024 / 1024 >= BI.MIN_SIZE_MB
    UNION ALL
    SELECT
      T.SCHEMA_NAME,
      T.TABLE_NAME,
      SUM(SIZE_MB) SIZE_MB
    FROM
      BASIS_INFO BI,
    ( SELECT
        SCHEMA_NAME,
        TABLE_NAME,
        SUM(USED_FIXED_PART_SIZE + USED_VARIABLE_PART_SIZE) / 1024 / 1024 SIZE_MB
      FROM
        M_RS_TABLES
      GROUP BY
        SCHEMA_NAME,
        TABLE_NAME
      UNION ALL
      SELECT
        SCHEMA_NAME,
        TABLE_NAME,
        SUM(INDEX_SIZE) / 1024 / 1024 SIZE_MB
      FROM
        M_RS_INDEXES
      GROUP BY
        SCHEMA_NAME,
        TABLE_NAME
    ) T
    WHERE
      BI.SIZE_CATEGORY IN ('CURRENT_MEM', 'MAX_MEM') AND
      T.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
      T.TABLE_NAME LIKE BI.TABLE_NAME
    GROUP BY
      T.SCHEMA_NAME,
      T.TABLE_NAME,
      BI.SIZE_CATEGORY,
      BI.MIN_SIZE_MB
    HAVING
      SUM(SIZE_MB) / 1024 / 1024 >= BI.MIN_SIZE_MB
  )
),
LARGEST_TABLES AS
( SELECT
    T.TP,
    T.TABLE_NAME,
    T.SIZE_MB
  FROM
  ( SELECT
      ROW_NUMBER() OVER (ORDER BY SIZE_MB DESC) TP,
      TABLE_NAME,
      SIZE_MB
    FROM
    ( SELECT
        TABLE_NAME,
        SUM(SIZE_MB) SIZE_MB
      FROM
        TABLE_SIZES
      GROUP BY
        TABLE_NAME
    )
  ) T,
    BASIS_INFO BI
  WHERE
    BI.RESULT_ROWS = -1 OR T.TP <= BI.RESULT_ROWS
),
LARGEST_SCHEMAS AS
( SELECT
    SP,
    SCHEMA_NAME,
    SIZE_MB
  FROM
  ( SELECT
      ROW_NUMBER() OVER (ORDER BY MAP(BI.SCHEMA_ORDER, 'SIZE', S.SIZE_MB) DESC, MAP(BI.SCHEMA_ORDER, 'NAME', S.SCHEMA_NAME)) SP,
      S.SCHEMA_NAME,
      S.SIZE_MB
    FROM
      BASIS_INFO BI,
    ( SELECT
        SCHEMA_NAME,
        SUM(SIZE_MB) SIZE_MB
      FROM
        TABLE_SIZES
      GROUP BY
        SCHEMA_NAME
    ) S
  )
)
SELECT
  TABLE_NAME,
  TOTAL_SIZE_GB,
  SIZE_GB_1,
  SIZE_GB_2,
  SIZE_GB_3,
  SIZE_GB_4,
  SIZE_GB_5,
  SIZE_GB_6,
  SIZE_GB_7,
  SIZE_GB_8,
  SIZE_GB_9,
  SIZE_GB_10,
  SIZE_GB_11,
  SIZE_GB_12,
  SIZE_GB_13,
  SIZE_GB_14,
  SIZE_GB_15,
  SIZE_GB_16,
  SIZE_GB_17,
  SIZE_GB_18,
  SIZE_GB_19,
  SIZE_GB_20,
  SIZE_GB_21,
  SIZE_GB_22,
  SIZE_GB_23,
  SIZE_GB_24,
  SIZE_GB_25,
  SIZE_GB_26,
  SIZE_GB_27,
  SIZE_GB_28,
  SIZE_GB_29,
  SIZE_GB_30,
  SIZE_GB_31,
  SIZE_GB_32
FROM
( SELECT
    10 LINE_NO,
    'SCHEMAS' TABLE_NAME,
    '' TOTAL_SIZE_GB,
    MAX(MAP(SP,  1, SCHEMA_NAME)) SIZE_GB_1,
    MAX(MAP(SP,  2, SCHEMA_NAME)) SIZE_GB_2,
    MAX(MAP(SP,  3, SCHEMA_NAME)) SIZE_GB_3,
    MAX(MAP(SP,  4, SCHEMA_NAME)) SIZE_GB_4,
    MAX(MAP(SP,  5, SCHEMA_NAME)) SIZE_GB_5,
    MAX(MAP(SP,  6, SCHEMA_NAME)) SIZE_GB_6,
    MAX(MAP(SP,  7, SCHEMA_NAME)) SIZE_GB_7,
    MAX(MAP(SP,  8, SCHEMA_NAME)) SIZE_GB_8,
    MAX(MAP(SP,  9, SCHEMA_NAME)) SIZE_GB_9,
    MAX(MAP(SP, 10, SCHEMA_NAME)) SIZE_GB_10,
    MAX(MAP(SP, 11, SCHEMA_NAME)) SIZE_GB_11,
    MAX(MAP(SP, 12, SCHEMA_NAME)) SIZE_GB_12,
    MAX(MAP(SP, 13, SCHEMA_NAME)) SIZE_GB_13,
    MAX(MAP(SP, 14, SCHEMA_NAME)) SIZE_GB_14,
    MAX(MAP(SP, 15, SCHEMA_NAME)) SIZE_GB_15,
    MAX(MAP(SP, 16, SCHEMA_NAME)) SIZE_GB_16,
    MAX(MAP(SP, 17, SCHEMA_NAME)) SIZE_GB_17,
    MAX(MAP(SP, 18, SCHEMA_NAME)) SIZE_GB_18,
    MAX(MAP(SP, 19, SCHEMA_NAME)) SIZE_GB_19,
    MAX(MAP(SP, 20, SCHEMA_NAME)) SIZE_GB_20,
    MAX(MAP(SP, 21, SCHEMA_NAME)) SIZE_GB_21,
    MAX(MAP(SP, 22, SCHEMA_NAME)) SIZE_GB_22,
    MAX(MAP(SP, 23, SCHEMA_NAME)) SIZE_GB_23,
    MAX(MAP(SP, 24, SCHEMA_NAME)) SIZE_GB_24,
    MAX(MAP(SP, 25, SCHEMA_NAME)) SIZE_GB_25,
    MAX(MAP(SP, 26, SCHEMA_NAME)) SIZE_GB_26,
    MAX(MAP(SP, 27, SCHEMA_NAME)) SIZE_GB_27,
    MAX(MAP(SP, 28, SCHEMA_NAME)) SIZE_GB_28,
    MAX(MAP(SP, 29, SCHEMA_NAME)) SIZE_GB_29,
    MAX(MAP(SP, 30, SCHEMA_NAME)) SIZE_GB_30,
    MAX(MAP(SP, 31, SCHEMA_NAME)) SIZE_GB_31,
    MAX(MAP(SP, 32, SCHEMA_NAME)) SIZE_GB_32
  FROM
    LARGEST_SCHEMAS
  UNION ALL
  SELECT 20, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '' FROM DUMMY
  UNION ALL
  SELECT
    30 LINE_NO,
    'TOTAL' TABLE_NAME,
    LPAD(TO_DECIMAL(SUM(SIZE_MB) / 1024, 10, 2), 13) TOTAL_SIZE_GB,
    LPAD(TO_DECIMAL(MAX(MAP(SP,  1, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_1,
    LPAD(TO_DECIMAL(MAX(MAP(SP,  2, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_2,
    LPAD(TO_DECIMAL(MAX(MAP(SP,  3, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_3,
    LPAD(TO_DECIMAL(MAX(MAP(SP,  4, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_4,
    LPAD(TO_DECIMAL(MAX(MAP(SP,  5, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_5,
    LPAD(TO_DECIMAL(MAX(MAP(SP,  6, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_6,
    LPAD(TO_DECIMAL(MAX(MAP(SP,  7, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_7,
    LPAD(TO_DECIMAL(MAX(MAP(SP,  8, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_8,
    LPAD(TO_DECIMAL(MAX(MAP(SP,  9, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_9,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 10, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_10,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 11, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_11,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 12, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_12,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 13, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_13,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 14, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_14,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 15, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_15,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 16, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_16,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 17, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_17,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 18, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_18,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 19, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_19,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 20, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_20,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 21, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_21,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 22, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_22,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 23, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_23,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 24, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_24,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 25, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_25,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 26, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_26,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 27, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_27,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 28, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_28,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 29, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_29,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 30, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_30,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 31, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_31,
    LPAD(TO_DECIMAL(MAX(MAP(SP, 32, SIZE_MB / 1024)), 10, 2), 10) SIZE_GB_32
  FROM
    LARGEST_SCHEMAS
  UNION ALL
  SELECT 40, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '' FROM DUMMY
  UNION ALL
  SELECT
    LINE_NO,
    TABLE_NAME,
    TOTAL_SIZE_GB,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_1),  10, 2), 10), '') SIZE_GB_1,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_2),  10, 2), 10), '') SIZE_GB_2,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_3),  10, 2), 10), '') SIZE_GB_3,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_4),  10, 2), 10), '') SIZE_GB_4,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_5),  10, 2), 10), '') SIZE_GB_5,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_6),  10, 2), 10), '') SIZE_GB_6,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_7),  10, 2), 10), '') SIZE_GB_7,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_8),  10, 2), 10), '') SIZE_GB_8,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_9),  10, 2), 10), '') SIZE_GB_9,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_10), 10, 2), 10), '') SIZE_GB_10,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_11), 10, 2), 10), '') SIZE_GB_11,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_12), 10, 2), 10), '') SIZE_GB_12,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_13), 10, 2), 10), '') SIZE_GB_13,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_14), 10, 2), 10), '') SIZE_GB_14,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_15), 10, 2), 10), '') SIZE_GB_15,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_16), 10, 2), 10), '') SIZE_GB_16,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_17), 10, 2), 10), '') SIZE_GB_17,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_18), 10, 2), 10), '') SIZE_GB_18,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_19), 10, 2), 10), '') SIZE_GB_19,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_20), 10, 2), 10), '') SIZE_GB_20,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_21), 10, 2), 10), '') SIZE_GB_21,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_22), 10, 2), 10), '') SIZE_GB_22,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_23), 10, 2), 10), '') SIZE_GB_23,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_24), 10, 2), 10), '') SIZE_GB_24,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_25), 10, 2), 10), '') SIZE_GB_25,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_26), 10, 2), 10), '') SIZE_GB_26,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_27), 10, 2), 10), '') SIZE_GB_27,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_28), 10, 2), 10), '') SIZE_GB_28,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_29), 10, 2), 10), '') SIZE_GB_29,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_30), 10, 2), 10), '') SIZE_GB_30,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_31), 10, 2), 10), '') SIZE_GB_31,
    IFNULL(LPAD(TO_DECIMAL(MAX(SIZE_GB_32), 10, 2), 10), '') SIZE_GB_32
  FROM
  ( SELECT
      100 + LT.TP LINE_NO,
      T.TABLE_NAME,
      LPAD(TO_DECIMAL(SUM(T.SIZE_MB) OVER(PARTITION BY T.TABLE_NAME) / 1024, 10, 2), 13) TOTAL_SIZE_GB,
      MAP(LS.SP,  1, T.SIZE_MB) / 1024 SIZE_GB_1,
      MAP(LS.SP,  2, T.SIZE_MB) / 1024 SIZE_GB_2,
      MAP(LS.SP,  3, T.SIZE_MB) / 1024 SIZE_GB_3,
      MAP(LS.SP,  4, T.SIZE_MB) / 1024 SIZE_GB_4,
      MAP(LS.SP,  5, T.SIZE_MB) / 1024 SIZE_GB_5,
      MAP(LS.SP,  6, T.SIZE_MB) / 1024 SIZE_GB_6,
      MAP(LS.SP,  7, T.SIZE_MB) / 1024 SIZE_GB_7,
      MAP(LS.SP,  8, T.SIZE_MB) / 1024 SIZE_GB_8,
      MAP(LS.SP,  9, T.SIZE_MB) / 1024 SIZE_GB_9,
      MAP(LS.SP, 10, T.SIZE_MB) / 1024 SIZE_GB_10,
      MAP(LS.SP, 11, T.SIZE_MB) / 1024 SIZE_GB_11,
      MAP(LS.SP, 12, T.SIZE_MB) / 1024 SIZE_GB_12,
      MAP(LS.SP, 13, T.SIZE_MB) / 1024 SIZE_GB_13,
      MAP(LS.SP, 14, T.SIZE_MB) / 1024 SIZE_GB_14,
      MAP(LS.SP, 15, T.SIZE_MB) / 1024 SIZE_GB_15,
      MAP(LS.SP, 16, T.SIZE_MB) / 1024 SIZE_GB_16,
      MAP(LS.SP, 17, T.SIZE_MB) / 1024 SIZE_GB_17,
      MAP(LS.SP, 18, T.SIZE_MB) / 1024 SIZE_GB_18,
      MAP(LS.SP, 19, T.SIZE_MB) / 1024 SIZE_GB_19,
      MAP(LS.SP, 20, T.SIZE_MB) / 1024 SIZE_GB_20,
      MAP(LS.SP, 21, T.SIZE_MB) / 1024 SIZE_GB_21,
      MAP(LS.SP, 22, T.SIZE_MB) / 1024 SIZE_GB_22,
      MAP(LS.SP, 23, T.SIZE_MB) / 1024 SIZE_GB_23,
      MAP(LS.SP, 24, T.SIZE_MB) / 1024 SIZE_GB_24,
      MAP(LS.SP, 25, T.SIZE_MB) / 1024 SIZE_GB_25,
      MAP(LS.SP, 26, T.SIZE_MB) / 1024 SIZE_GB_26,
      MAP(LS.SP, 27, T.SIZE_MB) / 1024 SIZE_GB_27,
      MAP(LS.SP, 28, T.SIZE_MB) / 1024 SIZE_GB_28,
      MAP(LS.SP, 29, T.SIZE_MB) / 1024 SIZE_GB_29,
      MAP(LS.SP, 30, T.SIZE_MB) / 1024 SIZE_GB_30,
      MAP(LS.SP, 31, T.SIZE_MB) / 1024 SIZE_GB_31,
      MAP(LS.SP, 32, T.SIZE_MB) / 1024 SIZE_GB_32
    FROM
      TABLE_SIZES T,
      LARGEST_TABLES LT,
      LARGEST_SCHEMAS LS
    WHERE
      T.TABLE_NAME = LT.TABLE_NAME AND
      T.SCHEMA_NAME = LS.SCHEMA_NAME
  )
  GROUP BY
    LINE_NO,
    TABLE_NAME,
    TOTAL_SIZE_GB
)
ORDER BY 
  LINE_NO