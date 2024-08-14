SELECT

/* 

[NAME]

- HANA_Configuration_Sequences

[DESCRIPTION]

- Show sequence information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/09/03:  1.0 (initial version)
- 2018/02/26:  1.1 (MAX_CACHE_SIZE included, switch from SEQUENCES to M_SEQUENCES)
- 2019/03/04:  1.2 (EXCLUDE_INTERNAL_SEQUENCES included)
- 2020/11/21:  1.3 (EXCLUDE_SEQUENCES_WITHOUT_CACHING_DEMAND included)

[INVOLVED TABLES]

- M_SEQUENCES

[INPUT PARAMETERS]

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- SEQUENCE_NAME

  Sequence name or pattern

  'DDLOG_SEQ'     --> Specific sequence DDLOG_SEQ
  'DD%'           --> All sequences starting with 'DD'
  '%'             --> All sequences

- MAX_CACHE_SIZE

  Maximum sequence cache size

  5               --> Only display sequences with a cache size of 5 or less
  -1              --> No restriction related to sequence cache size

- EXCLUDE_INTERNAL_SCHEMAS

  Possibility to exclude sequences related to internal schemas ( e.g. SYS, SYSTEM)

  'X'             --> Suppress display of sequences of internal schemas
  ' '             --> No restriction related to schemas

- EXCLUDE_INTERNAL_SEQUENCES

  Possibility to exclude internal sequences (e.g. used for identity columns)

  'X'             --> Suppress display of internal sequences
  ' '             --> Show all sequences

- EXCLUDE_SEQUENCES_WITHOUT_CACHING_DEMAND

  Possibility to exclude sequences that do not require caching

  'X'             --> Suppress display of sequences without caching requirement
  ' '             --> Show all sequences

[OUTPUT PARAMETERS]

- SCHEMA_NAME:   Schema name
- SEQUENCE_NAME: Sequence name
- CACHE_SIZE:    Cache size
- START_VALUE:   Minimum value
- CURRENT_VALUE: Current value
- END_VALUE:     Maximum value

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------
|SCHEMA_NAME  |SEQUENCE_NAME            |CACHE_SIZE|MIN_VALUE|MAX_VALUE          |INCREMENT_BY|
-----------------------------------------------------------------------------------------------
|SYS          |STORED_PLAN_ID_SEQ       |     10000|        1|4611686018427387903|           1|
|_SYS_XS      |JOB_SCHEDULES_SEQ        |         1|        1|4611686018427387903|           1|
|_SYS_RT      |_UIS_APPSITE_ID_SEQUENCE |         1|        1|4611686018427387903|           1|
|_SYS_DATAPROV|GENERATE_JOB_ID          |         1|        1|4611686018427387903|           1|
|SAP_XS_LM    |sap.hana.xs.lm.db::ID_SEQ|         1|     1000|4611686018427387903|           1|
|SAPSR3       |DDLOG_SEQ                |       500|        1|4611686018427387903|           1|
-----------------------------------------------------------------------------------------------

*/

  S.SCHEMA_NAME,
  S.SEQUENCE_NAME,
  LPAD(S.CACHE_SIZE, 10) CACHE_SIZE,
  IFNULL(LPAD(S.START_VALUE, 19), '') START_VALUE,
  IFNULL(LPAD(S.CURRENT_VALUE, 19), '') CURRENT_VALUE,
  IFNULL(LPAD(S.END_VALUE, 19), '') END_VALUE
FROM
( SELECT                   /* Modification section */
    '%' SCHEMA_NAME,
    '%' SEQUENCE_NAME,
    1 MAX_CACHE_SIZE,
    ' ' EXCLUDE_INTERNAL_SCHEMAS,
    ' ' EXCLUDE_INTERNAL_SEQUENCES,
    'X' EXCLUDE_SEQUENCES_WITHOUT_CACHING_DEMAND
  FROM
    DUMMY
) BI,
  M_SEQUENCES S
WHERE
  S.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  S.SEQUENCE_NAME LIKE BI.SEQUENCE_NAME AND
  ( BI.MAX_CACHE_SIZE = -1 OR S.CACHE_SIZE <= BI.MAX_CACHE_SIZE ) AND
  ( BI.EXCLUDE_INTERNAL_SCHEMAS = ' ' OR
    ( S.SCHEMA_NAME NOT IN ('SAP_BI_DISCOVER', 'SAP_BI_LAUNCHPAD', 'SAP_HANA_DBCC', 'SAP_HANA_DEMO', 'SAP_HDM', 'SAP_HDM_DDO', 'SAP_HDM_DLM', 'SAP_REST_API', 'SAP_XS_LM', 'SYS', 'SYSTEM') AND
      SUBSTR(S.SCHEMA_NAME, 1, 4) != '_SYS'
    )
  ) AND
  ( BI.EXCLUDE_INTERNAL_SEQUENCES = ' ' OR SUBSTR(S.SEQUENCE_NAME, 1, 4) != '_SYS' ) AND
  ( BI.EXCLUDE_SEQUENCES_WITHOUT_CACHING_DEMAND = ' ' OR 
    ( S.SCHEMA_NAME NOT IN ('SAP_BI_DISCOVER', 'SAP_BI_LAUNCHPAD', 'SAP_HANA_DBCC', 'SAP_HANA_DEMO', 'SAP_HDM', 'SAP_HDM_DDO', 'SAP_HDM_DLM', 'SAP_REST_API', 'SAP_XS_LM', 'SYS', 'SYSTEM') AND
      S.SEQUENCE_NAME != 'SHDB_PFW_INSTANCE_SEQUENCE' AND
      SUBSTR(S.SCHEMA_NAME, 1, 4) != '_SYS' AND
      SUBSTR(S.SEQUENCE_NAME, 1, 4) != '_SYS'
    )
  )
