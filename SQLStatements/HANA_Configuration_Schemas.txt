SELECT
/* 

[NAME]

- HANA_Configuration_Schemas

[DESCRIPTION]

- Schema overview including table sizes

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/06/03:  1.0 (initial version)
- 2019/05/28:  1.1 (disk size information added)

[INVOLVED TABLES]

- M_TABLES
- M_RS_INDEXES
- M_TABLE_PERSISTENCE_STATISTICS

[INPUT PARAMETERS]

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'MEM_SIZE'      --> Sorting by memory size
  'DISK_SIZE'     --> Sorting by disk size
  'NAME'          --> Sorting by schema name

[OUTPUT PARAMETERS]

- SCHEMA_NAME: Schema name
- NUM_TABLES:  Number of tables belonging to the schema
- MEM_GB:      Table and index memory size (GB)
- MEM_PCT:     Percentage of memory size compared to overall size
- CS_SIZE_GB:  Table and index memory size related to column store tables (GB)
- DISK_GB:     Table and index disk size (GB)
- DISK_PCT:    Percentage of disk size compared to overall size

[EXAMPLE OUTPUT]

----------------------------------------------------------
|SCHEMA_NAME    |NUM_TABLES|SIZE_GB  |SIZE_PCT|CS_SIZE_GB|
----------------------------------------------------------
|SAPSR3         |    276676|  1901.17|   98.77|   1385.58|
|SYS            |       214|    13.01|    0.67|      0.00|
|_SYS_STATISTICS|        55|    10.56|    0.54|     10.56|
----------------------------------------------------------

*/

  SCHEMA_NAME,
  LPAD(NUM_TABLES, 10) NUM_TABLES,
  LPAD(TO_DECIMAL(MEM_SIZE_BYTE / 1024 / 1024 / 1024, 10, 2), 9) MEM_GB,
  LPAD(TO_DECIMAL(MAP(TOTAL_MEM_SIZE_BYTE, 0, 0, MEM_SIZE_BYTE / TOTAL_MEM_SIZE_BYTE) * 100, 10, 2), 7) MEM_PCT,
  LPAD(TO_DECIMAL(CS_MEM_SIZE_BYTE / 1024 / 1024 / 1024, 10, 2), 10) CS_SIZE_GB,
  LPAD(TO_DECIMAL(DISK_SIZE_BYTE / 1024 / 1024 / 1024, 10, 2), 9) DISK_GB,
  LPAD(TO_DECIMAL(MAP(TOTAL_DISK_SIZE_BYTE, 0, 0, DISK_SIZE_BYTE / TOTAL_DISK_SIZE_BYTE) * 100, 10, 2), 8) DISK_PCT
FROM
( SELECT
    T.SCHEMA_NAME,
    SUM(P.NUM_TABLES) NUM_TABLES,
    T.TOTAL_MEM_SIZE_BYTE,
    T.CS_MEM_SIZE_BYTE,
    SUM(T.MEM_SIZE_BYTE) MEM_SIZE_BYTE,
    P.TOTAL_DISK_SIZE_BYTE,
    SUM(P.DISK_SIZE_BYTE) DISK_SIZE_BYTE,
    BI.ORDER_BY,
    BI.MIN_SIZE_GB
  FROM
  ( SELECT                     /* Modification section */
      '%' SCHEMA_NAME,
      1 MIN_SIZE_GB,
      'DISK_SIZE' ORDER_BY            /* MEM_SIZE, DISK_SIZE, NAME */
    FROM
      DUMMY
  ) BI,
  ( SELECT
      SCHEMA_NAME,
      SUM(MEM_SIZE_BYTE) MEM_SIZE_BYTE,
      SUM(SUM(MEM_SIZE_BYTE)) OVER () TOTAL_MEM_SIZE_BYTE,
      SUM(MAP(STORE, 'COLUMN', MEM_SIZE_BYTE, 0)) CS_MEM_SIZE_BYTE
    FROM
    ( SELECT
        SCHEMA_NAME,
        TABLE_TYPE STORE,
        SUM(TABLE_SIZE) MEM_SIZE_BYTE
      FROM
        M_TABLES
      GROUP BY
        SCHEMA_NAME,
        TABLE_TYPE
      UNION ALL
      ( SELECT
          SCHEMA_NAME,
          'ROW' STORE,
          SUM(INDEX_SIZE) SIZE_BYTE
        FROM
          M_RS_INDEXES
        GROUP BY
          SCHEMA_NAME
      )
    )
    GROUP BY
      SCHEMA_NAME
  ) T,
  ( SELECT
      SCHEMA_NAME,
      COUNT(*) NUM_TABLES,
      SUM(DISK_SIZE) DISK_SIZE_BYTE,
      SUM(SUM(DISK_SIZE)) OVER () TOTAL_DISK_SIZE_BYTE
    FROM
      M_TABLE_PERSISTENCE_STATISTICS
    GROUP BY
      SCHEMA_NAME
  ) P
  WHERE
    T.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    P.SCHEMA_NAME = T.SCHEMA_NAME
  GROUP BY
    T.SCHEMA_NAME,
    T.TOTAL_MEM_SIZE_BYTE,
    T.CS_MEM_SIZE_BYTE,
    P.TOTAL_DISK_SIZE_BYTE,
    BI.ORDER_BY,
    BI.MIN_SIZE_GB
)
WHERE
  ( MIN_SIZE_GB = -1 OR MEM_SIZE_BYTE / 1024 / 1024 / 1024 >= MIN_SIZE_GB OR DISK_SIZE_BYTE / 1024 / 1024 / 1024 >= MIN_SIZE_GB )
ORDER BY
  MAP(ORDER_BY, 'MEM_SIZE', MEM_SIZE_BYTE, 'DISK_SIZE', DISK_SIZE_BYTE) DESC,
  MAP(ORDER_BY, 'NAME', SCHEMA_NAME)
