SELECT
/* 

[NAME]

- HANA_Consistency_TableLOBLocation_1.00.72+

[DESCRIPTION]

- Check for tables with hybrid LOB containers located on different nodes

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- This constellation is not an inconsistency, but it can impose a performance overhead
- STRING_AGG available as of Rev. 72

[VALID FOR]

- Revisions:              1.00.72 and higher

[SQL COMMAND VERSION]

- 2016/01/19:  1.0 (initial version)

[INVOLVED TABLES]

- M_CS_TABLES
- M_RS_TABLES
- M_TABLE_LOB_FILES

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

- SCHEMA_NAME:       Schema name
- TABLE_NAME:        Table name
- PORT:              Port
- SERVICE_NAME:      Service name
- LOB_HOST:          Host of LOB containers
- TABLE_HOSTS:       Hosts of table (partitions)
- LOB_CONTAINERS:    Number of LOB containers

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME     |TABLE_NAME                                    |PORT |SERVICE_NAME|LOB_HOST|TABLE_HOSTS|LOB_CONTAINERS|
------------------------------------------------------------------------------------------------------------------------
|SAPSR3          |/AIF/PERS_XML                                 |33303|indexserver |hana01  |hana02     |             1|
|SAPSR3          |COV_GENDATA                                   |33303|indexserver |hana01  |hana02     |             2|
|SAPSR3          |COV_METADATA                                  |33303|indexserver |hana01  |hana02     |           255|
|SAPSR3          |DBTABLOG                                      |33303|indexserver |hana01  |hana02     |             4|
|SAPSR3          |DDSQLSCSRC                                    |33303|indexserver |hana02  |hana01     |            20|
|SAPSR3          |EDOCUMENTFILE                                 |33303|indexserver |hana01  |hana02     |             1|
|SAPSR3          |REPOSRC                                       |33303|indexserver |hana02  |hana01     |        934307|
|SAPSR3          |SCR_ABAP_AST                                  |33303|indexserver |hana01  |hana02     |           141|
|SAPSR3          |SCR_ABAP_SCAN                                 |33303|indexserver |hana01  |hana02     |            99|
|SAPSR3          |SCR_ABAP_SYMB                                 |33303|indexserver |hana01  |hana02     |           102|
|SAPSR3          |STXL                                          |33303|indexserver |hana01  |hana02     |            99|
|SAPSR3          |ZFI_VERTEX_LOG                                |33303|indexserver |hana01  |hana02     |             2|
|SAPSR3          |ZSWFL_APPLIK_LOG                              |33303|indexserver |hana01  |hana02     |            13|
------------------------------------------------------------------------------------------------------------------------

*/

  L.SCHEMA_NAME,
  L.TABLE_NAME,
  LPAD(L.PORT, 5) PORT,
  S.SERVICE_NAME,
  L.HOST LOB_HOST,
  RTRIM(LTRIM(T.HOST_LIST, ','), ',') TABLE_HOSTS,
  LPAD(L.LOB_CONTAINERS, 14) LOB_CONTAINERS
FROM
( SELECT                   /* Modification section */
    '%' SCHEMA_NAME,
    '%' TABLE_NAME
  FROM
    DUMMY
) BI,
( SELECT
    HOST,
    PORT,
    SCHEMA_NAME,
    TABLE_NAME,
    COUNT(*) LOB_CONTAINERS
  FROM
    M_TABLE_LOB_FILES
  GROUP BY
    HOST,
    PORT,
    SCHEMA_NAME,
    TABLE_NAME
) L,
  M_SERVICES S,
( SELECT
    ',' || STRING_AGG(HOST, ',') || ',' HOST_LIST,
    PORT,
    SCHEMA_NAME,
    TABLE_NAME
  FROM
  ( SELECT
      HOST,
      PORT,
      SCHEMA_NAME,
      TABLE_NAME
    FROM
      M_CS_TABLES
    UNION ALL
    SELECT
      HOST,
      PORT,
      SCHEMA_NAME,
      TABLE_NAME
    FROM
      M_RS_TABLES
  )
  GROUP BY
    PORT,
    SCHEMA_NAME,
    TABLE_NAME
) T
WHERE
  L.PORT = S.PORT AND
  L.HOST = S.HOST AND
  L.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  L.TABLE_NAME LIKE BI.TABLE_NAME AND
  L.PORT = T.PORT AND
  L.SCHEMA_NAME = T.SCHEMA_NAME AND
  L.TABLE_NAME = T.TABLE_NAME AND
  LOCATE(T.HOST_LIST, ',' || L.HOST || ',') = 0
ORDER BY
  L.SCHEMA_NAME,
  L.TABLE_NAME,
  L.HOST,
  T.HOST_LIST,
  L.PORT
  