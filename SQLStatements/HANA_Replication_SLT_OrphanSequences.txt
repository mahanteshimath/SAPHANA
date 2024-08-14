SELECT

/* 

[NAME]

- HANA_Replication_SLT_OrphanSequences

[DESCRIPTION]

- Display orphan SLT sequences that have no corresponding logging table

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- SLT sequence naming convention is SEQ_<logging_table>
- Logging table naming convention is /1CADMC/<id>
- Attention: Drop sequences only if you are sure that sequences are really no longer required

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2018/02/26:  1.0 (initial version)

[INVOLVED TABLES]

- M_SEQUENCES
- TABLES

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

[OUTPUT PARAMETERS]

- SCHEMA_NAME:   Schema name
- SEQUENCE_NAME: Sequence name
- DROP_COMMAND:  Command for dropping the sequence

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------
|SCHEMA_NAME|SEQUENCE_NAME       |DROP_COMMAND                                 |
--------------------------------------------------------------------------------
|SAPERP     |SEQ_/1CADMC/00095304|DROP SEQUENCE "SAPERP"."SEQ_/1CADMC/00095304"|
|SAPERP     |SEQ_/1CADMC/00094547|DROP SEQUENCE "SAPERP"."SEQ_/1CADMC/00094547"|
|SAPERP     |SEQ_/1CADMC/00095331|DROP SEQUENCE "SAPERP"."SEQ_/1CADMC/00095331"|
|SAPERP     |SEQ_/1CADMC/00095709|DROP SEQUENCE "SAPERP"."SEQ_/1CADMC/00095709"|
|SAPERP     |SEQ_/1CADMC/00095710|DROP SEQUENCE "SAPERP"."SEQ_/1CADMC/00095710"|
|SAPERP     |SEQ_/1CADMC/00095716|DROP SEQUENCE "SAPERP"."SEQ_/1CADMC/00095716"|
|SAPERP     |SEQ_/1CADMC/00095717|DROP SEQUENCE "SAPERP"."SEQ_/1CADMC/00095717"|
|SAPERP     |SEQ_/1CADMC/00095721|DROP SEQUENCE "SAPERP"."SEQ_/1CADMC/00095721"|
|SAPERP     |SEQ_/1CADMC/00095750|DROP SEQUENCE "SAPERP"."SEQ_/1CADMC/00095750"|
|SAPERP     |SEQ_/1CADMC/00094941|DROP SEQUENCE "SAPERP"."SEQ_/1CADMC/00094941"|
--------------------------------------------------------------------------------

*/

  S.SCHEMA_NAME,
  S.SEQUENCE_NAME,
  'DROP SEQUENCE "' || S.SCHEMA_NAME || '"."' || S.SEQUENCE_NAME || '"' || MAP(BI.GENERATE_SEMICOLON, 'X', CHAR(59), '') DROP_COMMAND
FROM
( SELECT                  /* Modification section */
    '%' SCHEMA_NAME,
    '%' SEQUENCE_NAME,
    'X' GENERATE_SEMICOLON
  FROM
    DUMMY
) BI,
  M_SEQUENCES S
WHERE
  S.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  S.SEQUENCE_NAME LIKE BI.SEQUENCE_NAME AND
  S.SEQUENCE_NAME LIKE 'SEQ_/1CADMC%' AND
  NOT EXISTS
  ( SELECT
      1
    FROM
      TABLES T
    WHERE
      T.TABLE_NAME = SUBSTR(S.SEQUENCE_NAME, 5)
  )
