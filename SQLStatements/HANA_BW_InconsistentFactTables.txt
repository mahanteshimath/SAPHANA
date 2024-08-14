SELECT
/* 

[NAME]

- HANA_BW_InconsistentFactTables

[DESCRIPTION]

- Check for related E and F fact tables with inconsistent configuration

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Tables are reported if partitioning layout differs between E and F fact table
- Tables (and partitions) are reported if partitioning layout is identical, but tables (and partitions)
  reside on different hosts
- Output is a rough guidance, but may not be 100 % correct in all cases, consider also using RSDU_TABLE_CONSISTENCY

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/03/11:  1.0 (initial version)

[INVOLVED TABLES]

- M_CS_TABLES
- TABLES

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

[OUTPUT PARAMETERS]

- SCHEMA_NAME:      Schema name
- F_TABLE_NAME:     Name of F fact table
- F_PART_ID:        Partition ID of F fact table
- F_PART_SPEC:      Partition specification of F fact table
- F_TABLE_HOST:     Host of F fact table
- E_TABLE_NAME:     Name of E fact table 
- E_PART_ID:        Partition ID of E fact table
- E_PART_SPEC:      Partition specification of E fact table
- E_TABLE_HOST:     Host of E fact table
- COMMENT:          Description of the inconsistency

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME|F_TABLE_NAME  |F_PART_ID|F_PART_SPEC |F_HOST  |E_TABLE_NAME  |E_PART_ID|E_PART_SPEC |E_HOST  |COMMENT                        |
-------------------------------------------------------------------------------------------------------------------------------------------
|SAPC11     |/BIC/FZIC_C03 |various  |ROUNDROBIN 1|various |/BIC/EZIC_C03 |various  |ROUNDROBIN 3|various |Partition specification differs|
|SAPC11     |/BIC/FZIC_C03T|        2|ROUNDROBIN 3|erslha49|/BIC/EZIC_C03T|        2|ROUNDROBIN 3|erslha53|Host differs                   |
|SAPC11     |/BIC/FZIC_C03T|        3|ROUNDROBIN 3|erslha48|/BIC/EZIC_C03T|        3|ROUNDROBIN 3|erslha53|Host differs                   |
-------------------------------------------------------------------------------------------------------------------------------------------

*/ 
  DISTINCT
  F.SCHEMA_NAME,
  F.TABLE_NAME F_TABLE_NAME,
  CASE WHEN C.CHECK_DESC = 'PARTITIONING_DIFFERENCE' AND MIN(F.PART_ID) OVER () != MAX(F.PART_ID) OVER () THEN 'various' ELSE LPAD(F.PART_ID, 9) END F_PART_ID,
  F.PART_SPEC F_PART_SPEC,
  CASE WHEN C.CHECK_DESC = 'PARTITIONING_DIFFERENCE' AND MIN(F.HOST) OVER () != MAX(F.HOST) OVER () THEN 'various' ELSE F.HOST END F_HOST,
  E.TABLE_NAME E_TABLE_NAME,
  CASE WHEN C.CHECK_DESC = 'PARTITIONING_DIFFERENCE' AND MIN(E.PART_ID) OVER () != MAX(E.PART_ID) OVER () THEN 'various' ELSE LPAD(E.PART_ID, 9) END E_PART_ID,
  E.PART_SPEC E_PART_SPEC,
  CASE WHEN C.CHECK_DESC = 'PARTITIONING_DIFFERENCE' AND MIN(E.HOST) OVER () != MAX(E.HOST) OVER () THEN 'various' ELSE E.HOST END E_HOST,
  CASE
    WHEN C.CHECK_DESC = 'PARTITIONING_DIFFERENCE' THEN
      'Partition specification differs'
    WHEN C.CHECK_DESC = 'HOST_DIFFERENCE' THEN
      'Host differs'
  END COMMENT
FROM
  ( SELECT                             /* Modification section */
      '%' SCHEMA_NAME,
      '%' TABLE_NAME,
      'X' CHECK_PARTITIONING_CONSISTENCY,
      'X' CHECK_HOST_CONSISTENCY
    FROM
      DUMMY
  ) BI,
  ( SELECT   1 CHECK_NO, 'HOST_DIFFERENCE' CHECK_DESC FROM DUMMY UNION ALL
    ( SELECT 2,          'PARTITIONING_DIFFERENCE'    FROM DUMMY )
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
      SUBSTR(CT.TABLE_NAME, 1, 5) || '_' || SUBSTR(CT.TABLE_NAME, 7) TABLE_PATTERN
    FROM
      M_CS_TABLES CT
    WHERE
      TABLE_NAME LIKE '/B%/F%' AND TABLE_NAME NOT LIKE '/BA1/F%'
  ) F,
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
      SUBSTR(CT.TABLE_NAME, 1, 5) || '_' || SUBSTR(CT.TABLE_NAME, 7) TABLE_PATTERN
    FROM
      M_CS_TABLES CT
    WHERE
      TABLE_NAME LIKE '/B%/E%' AND TABLE_NAME NOT LIKE '/BA1/E%'
  ) E
WHERE
  F.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  F.TABLE_NAME LIKE BI.TABLE_NAME AND
  E.SCHEMA_NAME = F.SCHEMA_NAME AND
  E.TABLE_PATTERN = F.TABLE_PATTERN AND
  ( BI.CHECK_PARTITIONING_CONSISTENCY = 'X' AND C.CHECK_DESC = 'PARTITIONING_DIFFERENCE' AND F.PART_SPEC != E.PART_SPEC OR
    BI.CHECK_HOST_CONSISTENCY = 'X' AND C.CHECK_DESC = 'HOST_DIFFERENCE' AND E.PART_ID = F.PART_ID AND F.PART_SPEC = E.PART_SPEC AND F.HOST != E.HOST
  )
ORDER BY
  F.SCHEMA_NAME,
  F.TABLE_NAME
  