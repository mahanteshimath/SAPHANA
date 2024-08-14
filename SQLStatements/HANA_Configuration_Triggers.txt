SELECT
/* 

[NAME]

- HANA_Configuration_Triggers

[DESCRIPTION]

- Existing database triggers

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/01/03:  1.0 (initial version)
- 2017/02/02:  1.1 (LINE_LENGTH_TARGET and line wrapping included)
- 2021/11/01:  1.2 (complete redesign including aggregation and scenario)
- 2021/11/15:  1.3 (/1LT/%TM% triggers included)
- 2022/10/01:  1.4 (/SAPCOM/ triggers included)

[INVOLVED TABLES]

- TRIGGERS

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

- TRIGGER_NAME

  Trigger name

  'MYTRIG'        --> Trigger MYTRIG
  '/1LT/%'        --> Triggers starting with '/1LT/'
  '%'             --> No restriction related to trigger name

- VALID

  Trigger validity

  'X'             --> Valid triggers
  ' '             --> Invalid triggers
  '%'             --> No restriction related to trigger validity

- ENABLED

  Trigger enabled state

  'X'             --> Trigger enabled
  ' '             --> Trigger disabled
  '%'             --> No restriction related to trigger enabled state

- SCENARIO

  Trigger business scenario

  'SUM'           --> Display triggers used in context of SUM
  '%SLT%'         --> Display triggers somehow related to SLT
  '%'             --> No restriction related to trigger business scenario 

- ACTION_TIME

  Trigger action time

  'AFTER'         --> Triggers that are executed after the event
  '%'             --> No restriction related to trigger action time

- EVENT

  Triggering event

  'UPDATE'        --> UPDATE trigger
  'INSERT'        --> INSERT trigger
  '%'             --> No restriction related to triggering event

- LEVEL

  Trigger level

  'ROW'           --> Row level
  '%'             --> No restriction related to trigger level

- TRIGGER_DEFINITION

  Trigger definition

  '%SRRELROLES%'  --> Triggers containing 'SRRELROLES' in their definitions
  '%'             --> No restriction related to trigger definition

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'SCENARIO'      --> Aggregation by trigger scenario
  'SCHEMA, TABLE' --> Aggregation by schema and table name
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'COUNT'         --> Sorting by number of triggers
  'TABLE'         --> Sorting by table name

[OUTPUT PARAMETERS]

- SCHEMA_NAME:     Schema name
- TABLE_NAME:      Table name
- TRIGGER_NAME:    Trigger name
- V:               Trigger validity ('X' -> valid, ' ' -> invalid)
- E:               Trigger enabled ('X' -> yes, ' ' -> no)
- SCENARIO:        Trigger business scenario
- ACTION_TIME:     Trigger action time
- EVENT:           Trigering event
- LEVEL:           Trigger level
- CNT:             Number of triggers
- DEFINITION:      Trigger definition

[EXAMPLE OUTPUT]

*/

  SCHEMA_NAME,
  TABLE_NAME,
  TRIGGER_NAME,
  VALID V,
  ENABLED E,
  SCENARIO,
  ACTION_TIME,
  EVENT,
  LEVEL,
  LPAD(CNT, 5) CNT,
  DEFINITION
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')      != 0 THEN T.SCHEMA_NAME  ELSE MAP(BI.SCHEMA_NAME,  '%', 'any', BI.SCHEMA_NAME)  END SCHEMA_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')       != 0 THEN T.TABLE_NAME   ELSE MAP(BI.TABLE_NAME,   '%', 'any', BI.TABLE_NAME)   END TABLE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'NAME')        != 0 THEN T.TRIGGER_NAME ELSE MAP(BI.TRIGGER_NAME, '%', 'any', BI.TRIGGER_NAME) END TRIGGER_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'VALID')       != 0 THEN T.VALID        ELSE MAP(BI.VALID,        '%', 'any', BI.VALID)        END VALID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ENABLED')     != 0 THEN T.ENABLED      ELSE MAP(BI.ENABLED,      '%', 'any', BI.ENABLED)      END ENABLED,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCENARIO')    != 0 THEN T.SCENARIO     ELSE MAP(BI.SCENARIO,     '%', 'any', BI.SCENARIO)     END SCENARIO,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ACTION_TIME') != 0 THEN T.ACTION_TIME  ELSE MAP(BI.ACTION_TIME,  '%', 'any', BI.ACTION_TIME)  END ACTION_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'EVENT')       != 0 THEN T.EVENT        ELSE MAP(BI.EVENT,        '%', 'any', BI.EVENT)        END EVENT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'LEVEL')       != 0 THEN T.LEVEL        ELSE MAP(BI.LEVEL,        '%', 'any', BI.LEVEL)        END LEVEL,
    COUNT(*) CNT,
    MAP(MIN(T.DEFINITION), MAX(T.DEFINITION), MIN(T.DEFINITION), 'any') DEFINITION,
    BI.ORDER_BY
  FROM
  ( SELECT                    /* Modification section */
      '%' SCHEMA_NAME,
      '%' TABLE_NAME,
      '%' TRIGGER_NAME,
      '%' VALID,
      '%' ENABLED,
      '%' SCENARIO,
      '%' ACTION_TIME,
      '%' EVENT,
      '%' LEVEL,
      '%' TRIGGER_DEFINITION,
      'SCENARIO' AGGREGATE_BY,         /* SCHEMA, TABLE, NAME, VALID, ENABLED, SCENARIO, ACTION_TIME, EVENT, LEVEL or comma separated combinations, NONE for no aggregation */
      'COUNT' ORDER_BY             /* COUNT, TABLE, NAME */
    FROM
      DUMMY
  ) BI,
  ( SELECT
      SUBJECT_TABLE_SCHEMA SCHEMA_NAME,
      SUBJECT_TABLE_NAME TABLE_NAME,
      TRIGGER_NAME,
      TRIGGER_ACTION_TIME ACTION_TIME,
      TRIGGER_EVENT EVENT,
      TRIGGERED_ACTION_LEVEL LEVEL,
      MAP(IS_VALID, 'TRUE', 'X', ' ') VALID,
      MAP(IS_ENABLED, 'TRUE', 'X', ' ') ENABLED,
      REPLACE(REPLACE(REPLACE(DEFINITION,CHAR(10),CHAR(32)),CHAR(13),CHAR(32)),CHAR(9),CHAR(32)) DEFINITION,
      CASE
        WHEN SCHEMA_NAME = '_SYS_SECURITY'                       THEN 'SAP HANA Security'
        WHEN SCHEMA_NAME = '_SYS_STATISTICS'                     THEN 'SAP HANA Statistics Server'
        WHEN TRIGGER_NAME LIKE '$FSI%'                           THEN 'Fast Search Infrastructure'
        WHEN TRIGGER_NAME LIKE '%#__#_%#_TRIG' ESCAPE '#'        THEN 'SDI Change Data Capture'
        WHEN TRIGGER_NAME LIKE '/1CRR/TR%#__' ESCAPE '#'         THEN 'SUM'
        WHEN TRIGGER_NAME LIKE '/1DH/%'                          THEN 'SLT'
        WHEN TRIGGER_NAME LIKE '/1DI/%'                          THEN 'SDI'
        WHEN TRIGGER_NAME LIKE '/1LT/%TM%'                       THEN 'SLT (temp.)'
        WHEN TRIGGER_NAME LIKE '/1LT/%'                          THEN 'SLT / NZDT'
        WHEN TRIGGER_NAME LIKE '/SAPCOM/%'                       THEN 'Service Provider Cockpit'
        WHEN TRIGGER_NAME LIKE 'SAP#_IC#_EXTR#_%' ESCAPE '#'     THEN 'Interaction Contacts'
        WHEN TRIGGER_NAME LIKE 'SAP#_SMI#_EXTR#_%' ESCAPE '#'    THEN 'Social Media Integration'
        WHEN TRIGGER_NAME LIKE '_SYS#_TRIGGER#_%' ESCAPE '#'     THEN 'Foreign Key Constraints'
        WHEN TRIGGER_NAME LIKE 'TRG#_NZDX#_%#__' ESCAPE '#'      THEN 'nZDM (Java)'
        ELSE                                                          'OTHER'
      END SCENARIO
    FROM 
      TRIGGERS
  ) T
  WHERE
    T.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    T.TABLE_NAME LIKE BI.TABLE_NAME AND
    T.TRIGGER_NAME LIKE BI.TRIGGER_NAME AND
    T.ACTION_TIME LIKE BI.ACTION_TIME AND
    T.EVENT LIKE BI.EVENT AND
    T.LEVEL LIKE BI.LEVEL AND
    T.VALID LIKE BI.VALID AND
    T.ENABLED LIKE BI.ENABLED AND
    T.DEFINITION LIKE BI.TRIGGER_DEFINITION AND
    T.SCENARIO LIKE BI.SCENARIO
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')      != 0 THEN T.SCHEMA_NAME  ELSE MAP(BI.SCHEMA_NAME,  '%', 'any', BI.SCHEMA_NAME)  END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')       != 0 THEN T.TABLE_NAME   ELSE MAP(BI.TABLE_NAME,   '%', 'any', BI.TABLE_NAME)   END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'NAME')        != 0 THEN T.TRIGGER_NAME ELSE MAP(BI.TRIGGER_NAME, '%', 'any', BI.TRIGGER_NAME) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'VALID')       != 0 THEN T.VALID        ELSE MAP(BI.VALID,        '%', 'any', BI.VALID)        END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ENABLED')     != 0 THEN T.ENABLED      ELSE MAP(BI.ENABLED,      '%', 'any', BI.ENABLED)      END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCENARIO')    != 0 THEN T.SCENARIO     ELSE MAP(BI.SCENARIO,     '%', 'any', BI.SCENARIO)     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ACTION_TIME') != 0 THEN T.ACTION_TIME  ELSE MAP(BI.ACTION_TIME,  '%', 'any', BI.ACTION_TIME)  END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'EVENT')       != 0 THEN T.EVENT        ELSE MAP(BI.EVENT,        '%', 'any', BI.EVENT)        END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'LEVEL')       != 0 THEN T.LEVEL        ELSE MAP(BI.LEVEL,        '%', 'any', BI.LEVEL)        END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'COUNT', CNT) DESC,
  MAP(ORDER_BY, 'TABLE', SCHEMA_NAME || TABLE_NAME, 'NAME', TRIGGER_NAME)
