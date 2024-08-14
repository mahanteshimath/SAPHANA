SELECT

/* 

[NAME]

- HANA_Configuration_Constraints_ForeignKeyConstraints

[DESCRIPTION]

- Foreign key constraint overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2019/02/19:  1.0 (initial version)

[INVOLVED TABLES]

- REFERENTIAL_CONSTRAINTS

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

- COLUMN_NAME

  Column name

  'MATNR'         --> Column MATNR
  'Z%'            --> Columns starting with "Z"
  '%'             --> No restriction related to columns

- CONSTRAINT_NAME

  Foreign key constraint name

  'FK_JOB_ID'     --> Constraint FK_JOB_ID
  '%'             --> No restriction related to constraint name

- REFERENCED_SCHEMA_NAME

  Referenced schema name or pattern

  'SAPSR3'        --> Specific referenced schema SAPSR3
  'SAP%'          --> All referenced schemata starting with 'SAP'
  '%'             --> All referencedschemata

- REFERENCED_TABLE_NAME           

  Referenced table name or pattern

  'T000'          --> Specific referenced table T000
  'T%'            --> All referenced tables starting with 'T'
  '%'             --> All referenced tables

- REFERENCED_COLUMN_NAME

  Referenced column name

  'MATNR'         --> Referenced column MATNR
  'Z%'            --> Referenced columns starting with "Z"
  '%'             --> No restriction related to referenced columns

- REFERENCED_CONSTRAINT_NAME

  Referenced constraint name

  'PK_JOB_ID'     --> Referenced constraint PK_JOB_ID
  '%'             --> No restriction related to referenced constraint name

- UPDATE_RULE

  Update rule

  'RESTRICT'      --> Update rule RESTRICT
  '%'             --> No limitation related to update rule

- DELETE_RULE

  Delete rule

  'RESTRICT'      --> Delete rule RESTRICT
  '%'             --> No limitation related to delete rule

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'          --> Aggregation by time
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'SOURCE'        --> Sorting by source schema / table
  'REFERENCED'    --> Sorting by referenced schema / table
  'COUNT'         --> Sorting by count
  
[OUTPUT PARAMETERS]

- SCHEMA_NAME:         Schema name
- TABLE_NAME:          Table name
- COLUMN_NAME:         Column name
- CONSTRAINT_NAME:     Constraint name
- POS:                 Column position
- COUNT:               Count
- REF_SCHEMA_NAME:     Referenced schema name
- REF_TABLE_NAME:      Referenced table name
- REF_COLUMN_NAME:     Referenced column name
- REF_CONSTRAINT_NAME: Referenced constraint name
- UPDATE_RULE:         Update rule
- DELETE_RULE:         Delete rule

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME|TABLE_NAME         |COLUMN_NAME                  |CONSTRAINT_NAME          |POS|COUNT|REF_SCHEMA_NAME|REF_TABLE_NAME   |REF_COLUMN_NAME|REF_CONSTRAINT_NAME        |UPDATE_RULE|DELETE_RULE|
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SAPHANA    |ACT_GE_BYTEARRAY   |DEPLOYMENT_ID_               |ACT_FK_BYTEARR_DEPL      |  1|    1|SAPHANA        |ACT_RE_DEPLOYMENT|ID_            |_SYS_TREE_CS_#157039_#0_#P0|RESTRICT   |RESTRICT   |
|SAPHANA    |ACT_ID_MEMBERSHIP  |GROUP_ID_                    |ACT_FK_MEMB_GROUP        |  1|    1|SAPHANA        |ACT_ID_GROUP     |ID_            |_SYS_TREE_CS_#157478_#0_#P0|RESTRICT   |RESTRICT   |
|SAPHANA    |ACT_ID_MEMBERSHIP  |USER_ID_                     |ACT_FK_MEMB_USER         |  1|    1|SAPHANA        |ACT_ID_USER      |ID_            |_SYS_TREE_CS_#157495_#0_#P0|RESTRICT   |RESTRICT   |
|SAPHANA    |ACT_PROCDEF_INFO   |INFO_JSON_ID_                |ACT_FK_INFO_JSON_BA      |  1|    1|SAPHANA        |ACT_GE_BYTEARRAY |ID_            |_SYS_TREE_CS_#157028_#0_#P0|RESTRICT   |RESTRICT   |
|SAPHANA    |ACT_PROCDEF_INFO   |PROC_DEF_ID_                 |ACT_FK_INFO_PROCDEF      |  1|    1|SAPHANA        |ACT_RE_PROCDEF   |ID_            |_SYS_TREE_CS_#157111_#0_#P0|RESTRICT   |RESTRICT   |
|SAPHANA    |ACT_RE_MODEL       |DEPLOYMENT_ID_               |ACT_FK_MODEL_DEPLOYMENT  |  1|    1|SAPHANA        |ACT_RE_DEPLOYMENT|ID_            |_SYS_TREE_CS_#157039_#0_#P0|RESTRICT   |RESTRICT   |
|SAPHANA    |ACT_RE_MODEL       |EDITOR_SOURCE_EXTRA_VALUE_ID_|ACT_FK_MODEL_SOURCE_EXTRA|  1|    1|SAPHANA        |ACT_GE_BYTEARRAY |ID_            |_SYS_TREE_CS_#157028_#0_#P0|RESTRICT   |RESTRICT   |
|SAPHANA    |ACT_RE_MODEL       |EDITOR_SOURCE_VALUE_ID_      |ACT_FK_MODEL_SOURCE      |  1|    1|SAPHANA        |ACT_GE_BYTEARRAY |ID_            |_SYS_TREE_CS_#157028_#0_#P0|RESTRICT   |RESTRICT   |
|SAPHANA    |ACT_RU_EVENT_SUBSCR|EXECUTION_ID_                |ACT_FK_EVENT_EXEC        |  1|    1|SAPHANA        |ACT_RU_EXECUTION |ID_            |_SYS_TREE_CS_#157067_#0_#P0|RESTRICT   |RESTRICT   |
|SAPHANA    |ACT_RU_EXECUTION   |PARENT_ID_                   |ACT_FK_EXE_PARENT        |  1|    1|SAPHANA        |ACT_RU_EXECUTION |ID_            |_SYS_TREE_CS_#157067_#0_#P0|RESTRICT   |RESTRICT   |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


*/

  SCHEMA_NAME,
  TABLE_NAME,
  COLUMN_NAME,
  CONSTRAINT_NAME,
  LPAD(POSITION, 3) POS,
  LPAD(COUNT, 5) COUNT,
  REFERENCED_SCHEMA_NAME REF_SCHEMA_NAME,
  REFERENCED_TABLE_NAME REF_TABLE_NAME,
  REFERENCED_COLUMN_NAME REF_COLUMN_NAME,
  REFERENCED_CONSTRAINT_NAME REF_CONSTRAINT_NAME,
  UPDATE_RULE,
  DELETE_RULE
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SOURCE_SCHEMA')         != 0 THEN C.SCHEMA_NAME                ELSE MAP(BI.SCHEMA_NAME,                '%', 'any', BI.SCHEMA_NAME)                END SCHEMA_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SOURCE_TABLE')          != 0 THEN C.TABLE_NAME                 ELSE MAP(BI.TABLE_NAME,                 '%', 'any', BI.TABLE_NAME)                 END TABLE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SOURCE_COLUMN')         != 0 THEN C.COLUMN_NAME                ELSE MAP(BI.COLUMN_NAME,                '%', 'any', BI.COLUMN_NAME)                END COLUMN_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SOURCE_CONSTRAINT')     != 0 THEN C.CONSTRAINT_NAME            ELSE MAP(BI.CONSTRAINT_NAME,            '%', 'any', BI.CONSTRAINT_NAME)            END CONSTRAINT_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'REFERENCED_SCHEMA')     != 0 THEN C.REFERENCED_SCHEMA_NAME     ELSE MAP(BI.REFERENCED_SCHEMA_NAME,     '%', 'any', BI.REFERENCED_SCHEMA_NAME)     END REFERENCED_SCHEMA_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'REFERENCED_TABLE')      != 0 THEN C.REFERENCED_TABLE_NAME      ELSE MAP(BI.REFERENCED_TABLE_NAME,      '%', 'any', BI.REFERENCED_TABLE_NAME)      END REFERENCED_TABLE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'REFERENCED_COLUMN')     != 0 THEN C.REFERENCED_COLUMN_NAME     ELSE MAP(BI.REFERENCED_COLUMN_NAME,     '%', 'any', BI.REFERENCED_COLUMN_NAME)     END REFERENCED_COLUMN_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'REFERENCED_CONSTRAINT') != 0 THEN C.REFERENCED_CONSTRAINT_NAME ELSE MAP(BI.REFERENCED_CONSTRAINT_NAME, '%', 'any', BI.REFERENCED_CONSTRAINT_NAME) END REFERENCED_CONSTRAINT_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'UPDATE_RULE')           != 0 THEN C.UPDATE_RULE                ELSE MAP(BI.UPDATE_RULE,                '%', 'any', BI.UPDATE_RULE)                END UPDATE_RULE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DELETE_RULE')           != 0 THEN C.DELETE_RULE                ELSE MAP(BI.DELETE_RULE,                '%', 'any', BI.DELETE_RULE)                END DELETE_RULE,
    MAP(MIN(C.POSITION), MAX(C.POSITION), TO_VARCHAR(MIN(C.POSITION)), 'any') POSITION,
    COUNT(*) COUNT,
    BI.ORDER_BY
  FROM
  ( SELECT                        /* Modification section */
      '%' SCHEMA_NAME,
      '%' TABLE_NAME,
      '%' COLUMN_NAME,
      '%' CONSTRAINT_NAME,
      '%' REFERENCED_SCHEMA_NAME,
      '%' REFERENCED_TABLE_NAME,
      '%' REFERENCED_COLUMN_NAME,
      '%' REFERENCED_CONSTRAINT_NAME,
      '%' UPDATE_RULE,
      '%' DELETE_RULE,
      'NONE' AGGREGATE_BY,                    /* SOURCE_SCHEMA, SOURCE_TABLE, SOURCE_COLUMN, SOURCE_CONSTRAINT, REFERENCED_SCHEMA, REFERENCED_TABLE, REFERENCED_COLUMN, REFERENCED_CONSTRAINT, UPDATE_RULE, DELETE_RULE */
      'SOURCE' ORDER_BY                       /* SOURCE, REFERENCED, COUNT */
    FROM
      DUMMY
  ) BI,
    REFERENTIAL_CONSTRAINTS C
  WHERE
    C.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    C.TABLE_NAME LIKE BI.TABLE_NAME AND
    C.COLUMN_NAME LIKE BI.COLUMN_NAME AND
    C.CONSTRAINT_NAME LIKE BI.CONSTRAINT_NAME AND
    C.REFERENCED_SCHEMA_NAME LIKE BI.REFERENCED_SCHEMA_NAME AND
    C.REFERENCED_TABLE_NAME LIKE BI.REFERENCED_TABLE_NAME AND
    C.REFERENCED_COLUMN_NAME LIKE BI.REFERENCED_COLUMN_NAME AND
    C.REFERENCED_CONSTRAINT_NAME LIKE BI.REFERENCED_CONSTRAINT_NAME AND
    C.UPDATE_RULE LIKE BI.UPDATE_RULE AND
    C.DELETE_RULE LIKE BI.DELETE_RULE
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SOURCE_SCHEMA')         != 0 THEN C.SCHEMA_NAME                ELSE MAP(BI.SCHEMA_NAME,                '%', 'any', BI.SCHEMA_NAME)                END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SOURCE_TABLE')          != 0 THEN C.TABLE_NAME                 ELSE MAP(BI.TABLE_NAME,                 '%', 'any', BI.TABLE_NAME)                 END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SOURCE_COLUMN')         != 0 THEN C.COLUMN_NAME                ELSE MAP(BI.COLUMN_NAME,                '%', 'any', BI.COLUMN_NAME)                END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SOURCE_CONSTRAINT')     != 0 THEN C.CONSTRAINT_NAME            ELSE MAP(BI.CONSTRAINT_NAME,            '%', 'any', BI.CONSTRAINT_NAME)            END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'REFERENCED_SCHEMA')     != 0 THEN C.REFERENCED_SCHEMA_NAME     ELSE MAP(BI.REFERENCED_SCHEMA_NAME,     '%', 'any', BI.REFERENCED_SCHEMA_NAME)     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'REFERENCED_TABLE')      != 0 THEN C.REFERENCED_TABLE_NAME      ELSE MAP(BI.REFERENCED_TABLE_NAME,      '%', 'any', BI.REFERENCED_TABLE_NAME)      END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'REFERENCED_COLUMN')     != 0 THEN C.REFERENCED_COLUMN_NAME     ELSE MAP(BI.REFERENCED_COLUMN_NAME,     '%', 'any', BI.REFERENCED_COLUMN_NAME)     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'REFERENCED_CONSTRAINT') != 0 THEN C.REFERENCED_CONSTRAINT_NAME ELSE MAP(BI.REFERENCED_CONSTRAINT_NAME, '%', 'any', BI.REFERENCED_CONSTRAINT_NAME) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'UPDATE_RULE')           != 0 THEN C.UPDATE_RULE                ELSE MAP(BI.UPDATE_RULE,                '%', 'any', BI.UPDATE_RULE)                END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'DELETE_RULE')           != 0 THEN C.DELETE_RULE                ELSE MAP(BI.DELETE_RULE,                '%', 'any', BI.DELETE_RULE)              END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'SOURCE', SCHEMA_NAME || TABLE_NAME, 'REFERENCED', REFERENCED_SCHEMA_NAME || REFERENCED_TABLE_NAME),
  MAP(ORDER_BY, 'COUNT', COUNT) DESC,
  POS