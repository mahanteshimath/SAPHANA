SELECT
/* 

[NAME]

- HANA_BW_InconsistentDSOTables

[DESCRIPTION]

- Check for related DSO tables (new data, active data, change log) with inconsistent configuration

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Tables are reported if partitioning layout differs between DSO new data and DSO active data table
- Tables (and partitions) are reported if partitioning layout is identical, but tables (and partitions)
  reside on different hosts
- Access to SAP tables RSDODSO and RSTSODS required in order to determine change log table, so you
  have to be logged on as the SAP schema owner
- Not valid for BW/4HANA because RSTSODS no longer exists
- Output is a rough guidance, but may not be 100 % correct in all cases, consider also using RSDU_TABLE_CONSISTENCY

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/03/12:  1.0 (initial version)

[INVOLVED TABLES]

- M_CS_TABLES
- TABLES
- RSDODSO
- RSTSODS

[INPUT PARAMETERS]

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'   --> Specific schema SAPSR3
  'SAP%'     --> All schemata starting with SAP
  '%'        --> All schemata

- TABLE_NAME:           

  Table name or pattern

  'T000'     --> Specific table T000
  'T%'       --> All tables starting with T
  '%'        --> All tables

- CHECK_PARTITIONING_CONSISTENCY

  Activation / deactivation of check for partitioning consistency between DSO new data and DSO active data table

  'X'        --> Check is executed
  ' '        --> Check is not done

- CHECK_HOST_CONSISTENCY

  Activation / deactivation of check for host consistency between DSO new data and DSO active data table

  'X'        --> Check is activated
  ' '        --> Check is deactivated

- CHECK_MULTIPLE_PARTITIONS_ON_SAME_HOST

  Activation / deactivation of check to check if multiple partitions of table are located on same host

  'X'        --> Check is executed
  ' '        --> Check is not done

[OUTPUT PARAMETERS]
 
- ISSUE:            Description of the configuration issue
- SCHEMA_NAME:      Schema name
- NEW_TABLE_NAME:   Name of DSO new data table
- NEW_PART_ID:      Partition ID of DSO new data table
- NEW_PART_SPEC     Partition specification of DSO new data table
- NEW_TABLE_HOST:   Host of DSO new data table
- ACT_TABLE_NAME:   Name of DSO active data table 
- ACT_PART_ID:      Partition ID of DSO active data table
- ACT_PART_SPEC:    Partition specification of DSO active data table
- ACT_TABLE_HOST:   Host of DSO active data table
- CHG_TABLE_NAME:   Name of DSO change log table 
- CHG_PART_ID:      Partition ID of DSO change log table
- CHG_PART_SPEC:    Partition specification of DSO change log table
- CHG_TABLE_HOST:   Host of DSO change log table

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|ISSUE                                        |SCHEMA_NAME|NEW_TABLE_NAME  |NEW_PART_ID|NEW_PART_SPEC                                               |NEW_HOST|ACT_TABLE_NAME  |ACT_PART_ID|ACT_PART_SPEC                                               |ACT_HOST|CHG_TABLE_NAME  |CHG_PART_ID|CHG_PART_SPEC                  |CHG_HOST|
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|Host differs (new data vs. active data)      |SAPC11     |/BIC/AZOCEUO5940|          0|HASH 1 DOC_NUMBER,MATERIAL,FISCVARNT,ITEM_CATEG             |erslha35|/BIC/AZOCEUO5900|          0|HASH 1 DOC_NUMBER,MATERIAL,FISCVARNT,ITEM_CATEG             |erslha34|/BIC/B0006279000|          0|HASH 1 REQUEST,DATAPAKID,RECORD|erslha34|
|Multiple partitions on same host (change log)|SAPC11     |/BIC/AZOCEUO9740|          0|HASH 1 /BIC/ZTOION,/BIC/ZCOID,MATERIAL,/BIC/ZSPLIT          |erslha36|/BIC/AZOCEUO9700|          0|HASH 1 /BIC/ZTOION,/BIC/ZCOID,MATERIAL,/BIC/ZSPLIT          |erslha36|/BIC/B0009383000|various    |HASH 1 REQUEST,DATAPAKID,RECORD|erslha35|
|Multiple partitions on same host (change log)|SAPC11     |/BIC/AZOCXXO0140|          0|HASH 1 /BIC/ZDCOMPLVL,/BIC/ZGEOLEV2,/BIC/ZGEOLEV5,SALESORG,D|erslha35|/BIC/AZOCXXO0100|          0|HASH 1 /BIC/ZDCOMPLVL,/BIC/ZGEOLEV2,/BIC/ZGEOLEV5,SALESORG,D|erslha35|/BIC/B0009336000|various    |HASH 1 REQUEST,DATAPAKID,RECORD|erslha35|
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/ 
  DISTINCT
  CASE
    WHEN D.CHECK_DESC = 'PARTITIONING_DIFFERENCE' THEN
      'Partition specification differs (new data vs. active data)'
    WHEN D.CHECK_DESC = 'HOST_DIFFERENCE' THEN
      'Host differs (new data vs. active data)'
    WHEN D.CHECK_DESC = 'MULTIPLE_PARTITIONS_ON_SAME_HOST' THEN
      'Multiple partitions on same host (' ||
      CASE WHEN D.NEW_MAX_PART_ON_HOST > 1 THEN 'new data, ' || CASE WHEN D.ACT_MAX_PART_ON_HOST > 1 OR C.MAX_PART_ON_HOST >1 THEN ', ' ELSE '' END ELSE '' END ||
        CASE WHEN D.ACT_MAX_PART_ON_HOST > 1 THEN 'active data, ' || CASE WHEN C.MAX_PART_ON_HOST > 1 THEN ', ' ELSE '' END ELSE '' END ||
        CASE WHEN C.MAX_PART_ON_HOST     > 1 THEN 'change log' ELSE '' END || ')'
    END ISSUE,
  D.SCHEMA_NAME,
  D.NEW_TABLE_NAME,
  CASE WHEN D.CHECK_DESC IN ( 'PARTITIONING_DIFFERENCE', 'MULTIPLE_PARTITIONS_ON_SAME_HOST' ) AND MIN(D.NEW_PART_ID) OVER (PARTITION BY D.SCHEMA_NAME, D.NEW_TABLE_NAME) != MAX(D.NEW_PART_ID) OVER (PARTITION BY D.SCHEMA_NAME, D.NEW_TABLE_NAME) 
    THEN 'various' ELSE LPAD(D.NEW_PART_ID, 11) END NEW_PART_ID,
  D.NEW_PART_SPEC,
  CASE WHEN D.CHECK_DESC IN ( 'PARTITIONING_DIFFERENCE', 'MULTIPLE_PARTITIONS_ON_SAME_HOST' ) AND MIN(D.NEW_HOST) OVER (PARTITION BY D.SCHEMA_NAME, D.NEW_TABLE_NAME) != MAX(D.NEW_HOST) OVER (PARTITION BY D.SCHEMA_NAME, D.NEW_TABLE_NAME)
    THEN 'various' ELSE D.NEW_HOST END NEW_HOST,
  D.ACT_TABLE_NAME,
  CASE WHEN D.CHECK_DESC IN ( 'PARTITIONING_DIFFERENCE', 'MULTIPLE_PARTITIONS_ON_SAME_HOST' ) AND MIN(D.ACT_PART_ID) OVER (PARTITION BY D.SCHEMA_NAME, D.NEW_TABLE_NAME) != MAX(D.ACT_PART_ID) OVER (PARTITION BY D.SCHEMA_NAME, D.NEW_TABLE_NAME) 
    THEN 'various' ELSE LPAD(D.ACT_PART_ID, 11) END ACT_PART_ID,
  D.ACT_PART_SPEC,
  CASE WHEN D.CHECK_DESC IN ( 'PARTITIONING_DIFFERENCE', 'MULTIPLE_PARTITIONS_ON_SAME_HOST' ) AND MIN(D.ACT_HOST) OVER (PARTITION BY D.SCHEMA_NAME, D.NEW_TABLE_NAME) != MAX(D.ACT_HOST) OVER (PARTITION BY D.SCHEMA_NAME, D.NEW_TABLE_NAME) 
    THEN 'various' ELSE D.ACT_HOST END ACT_HOST,
  C.TABLE_NAME CHG_TABLE_NAME,
  CASE WHEN D.CHECK_DESC IN ( 'PARTITIONING_DIFFERENCE', 'MULTIPLE_PARTITIONS_ON_SAME_HOST' ) AND MIN(C.PART_ID) OVER (PARTITION BY D.SCHEMA_NAME, D.NEW_TABLE_NAME) != MAX(C.PART_ID) OVER (PARTITION BY D.SCHEMA_NAME, D.NEW_TABLE_NAME) 
    THEN 'various' ELSE LPAD(C.PART_ID, 11) END CHG_PART_ID,
  C.PART_SPEC CHG_PART_SPEC,
  CASE WHEN D.CHECK_DESC IN ( 'PARTITIONING_DIFFERENCE', 'MULTIPLE_PARTITIONS_ON_SAME_HOST' ) AND MIN(C.HOST) OVER (PARTITION BY D.SCHEMA_NAME, D.NEW_TABLE_NAME) != MAX(C.HOST) OVER (PARTITION BY D.SCHEMA_NAME, D.NEW_TABLE_NAME) 
    THEN 'various' ELSE C.HOST END CHG_HOST
FROM
  ( SELECT
      N.SCHEMA_NAME,
      N.DSO_NAME,
      N.HOST NEW_HOST,
      N.TABLE_NAME NEW_TABLE_NAME,
      N.PART_ID NEW_PART_ID,
      N.PART_SPEC NEW_PART_SPEC,
      N.MAX_PART_ON_HOST NEW_MAX_PART_ON_HOST,
      A.HOST ACT_HOST,
      A.TABLE_NAME ACT_TABLE_NAME,
      A.PART_ID ACT_PART_ID,
      A.PART_SPEC ACT_PART_SPEC,
      A.MAX_PART_ON_HOST ACT_MAX_PART_ON_HOST,
      C.CHECK_DESC,
      BI.CHECK_PARTITIONING_CONSISTENCY,
      BI.CHECK_HOST_CONSISTENCY,
      BI.CHECK_MULTIPLE_PARTITIONS_ON_SAME_HOST
    FROM
    ( SELECT                             /* Modification section */
          '%' SCHEMA_NAME,
          '%' TABLE_NAME,
          'X' CHECK_PARTITIONING_CONSISTENCY,
          'X' CHECK_HOST_CONSISTENCY,
          'X' CHECK_MULTIPLE_PARTITIONS_ON_SAME_HOST
        FROM
          DUMMY
      ) BI,
      ( SELECT   1 CHECK_NO, 'HOST_DIFFERENCE' CHECK_DESC       FROM DUMMY UNION ALL
        ( SELECT 2,          'PARTITIONING_DIFFERENCE'          FROM DUMMY ) UNION ALL
        ( SELECT 3,          'MULTIPLE_PARTITIONS_ON_SAME_HOST' FROM DUMMY )
      ) C,
      ( SELECT
          CT.HOST,
          CT.SCHEMA_NAME,
          CT.TABLE_NAME,
          CT.PART_ID,
          ( SELECT
              SUBSTR(MAP(LOCATE(T.PARTITION_SPEC, ';'), 0, T.PARTITION_SPEC, RTRIM(SUBSTR(T.PARTITION_SPEC, 1, LOCATE(T.PARTITION_SPEC, ';')), ';')), 1, 60)
            FROM
              TABLES T
            WHERE
              T.SCHEMA_NAME = CT.SCHEMA_NAME AND
              T.TABLE_NAME = CT.TABLE_NAME
          ) PART_SPEC,
          SUBSTR(CT.TABLE_NAME, 7, LENGTH(CT.TABLE_NAME) - 8) DSO_NAME,
          COUNT(*) OVER (PARTITION BY CT.HOST, CT.SCHEMA_NAME, CT.TABLE_NAME) MAX_PART_ON_HOST
        FROM
          M_CS_TABLES CT
        WHERE
          TABLE_NAME LIKE '/B%/A%40'
      ) N,
      ( SELECT
          CT.HOST,
          CT.SCHEMA_NAME,
          CT.TABLE_NAME,
          CT.PART_ID,
          ( SELECT
              SUBSTR(MAP(LOCATE(T.PARTITION_SPEC, ';'), 0, T.PARTITION_SPEC, RTRIM(SUBSTR(T.PARTITION_SPEC, 1, LOCATE(T.PARTITION_SPEC, ';')), ';')), 1, 60)
            FROM
              TABLES T
            WHERE
              T.SCHEMA_NAME = CT.SCHEMA_NAME AND
              T.TABLE_NAME = CT.TABLE_NAME
          ) PART_SPEC,
          SUBSTR(CT.TABLE_NAME, 7, LENGTH(CT.TABLE_NAME) - 8) DSO_NAME,
          COUNT(*) OVER (PARTITION BY CT.HOST, CT.SCHEMA_NAME, CT.TABLE_NAME) MAX_PART_ON_HOST
        FROM
          M_CS_TABLES CT
        WHERE
          TABLE_NAME LIKE '/B%/A%00'
      ) A 
    WHERE
      N.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
      N.TABLE_NAME LIKE BI.TABLE_NAME AND
      A.SCHEMA_NAME = N.SCHEMA_NAME AND
      A.DSO_NAME = N.DSO_NAME  
  ) D LEFT OUTER JOIN
  ( SELECT
      CT.HOST,
      CT.SCHEMA_NAME,
      CT.TABLE_NAME,
      CT.PART_ID,
      ( SELECT
          SUBSTR(MAP(LOCATE(T.PARTITION_SPEC, ';'), 0, T.PARTITION_SPEC, RTRIM(SUBSTR(T.PARTITION_SPEC, 1, LOCATE(T.PARTITION_SPEC, ';')), ';')), 1, 60)
        FROM
          TABLES T
        WHERE
          T.SCHEMA_NAME = CT.SCHEMA_NAME AND
          T.TABLE_NAME = CT.TABLE_NAME
      ) PART_SPEC,
      O.ODSOBJECT DSO_NAME,
      COUNT(*) OVER (PARTITION BY CT.HOST, CT.SCHEMA_NAME, CT.TABLE_NAME) MAX_PART_ON_HOST
    FROM
      M_CS_TABLES CT,
      RSDODSO O,
      RSTSODS TS
    WHERE
      O.OBJVERS = 'A' AND
      TS.ODSNAME LIKE '8' || O.ODSOBJECT || '#__A' ESCAPE '#' AND
      CT.TABLE_NAME = TS.ODSNAME_TECH
  ) C ON
    D.SCHEMA_NAME = C.SCHEMA_NAME AND
    D.DSO_NAME = C.DSO_NAME
WHERE
  ( D.CHECK_PARTITIONING_CONSISTENCY = 'X' AND D.CHECK_DESC = 'PARTITIONING_DIFFERENCE' AND D.NEW_PART_SPEC != D.ACT_PART_SPEC OR
    D.CHECK_HOST_CONSISTENCY = 'X' AND D.CHECK_DESC = 'HOST_DIFFERENCE' AND D.NEW_PART_ID = D.ACT_PART_ID AND D.NEW_PART_SPEC = D.ACT_PART_SPEC AND D.NEW_HOST != D.ACT_HOST OR
    D.CHECK_MULTIPLE_PARTITIONS_ON_SAME_HOST = 'X' AND D.CHECK_DESC = 'MULTIPLE_PARTITIONS_ON_SAME_HOST' AND D.NEW_PART_SPEC = D.ACT_PART_SPEC AND 
      ( D.NEW_MAX_PART_ON_HOST > 1 OR D.ACT_MAX_PART_ON_HOST > 1 OR C.MAX_PART_ON_HOST > 1 )
  )
ORDER BY
  D.SCHEMA_NAME,
  D.NEW_TABLE_NAME
  