SELECT

/* 

[NAME]

- HANA_SmartDataAccess_Tables_1.00.120+

[DESCRIPTION]

- Overview of virtual Smart Data Access (SDA) tables

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Smart Data Access was introduced with SAP HANA Rev. 60
- Starting with SAP HANA SPS 12 the STATISTICS view is deprecated and replaced with the DATA_STATISTICS view

[VALID FOR]

- Revisions:              >= 1.00.120

[SQL COMMAND VERSION]

- 2016/06/14:  1.0 (initial version)
- 2017/03/15:  1.1 (dedicated 1.00.120+ version)
- 2019/11/03:  1.2 (STATS_COMMAND added)
- 2020/07/09:  1.3 (EXCLUDE_SYSTEM_REPLICATION included)

[INVOLVED TABLES]

- VIRTUAL_TABLES
- DATA_STATISTICS

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

- REMOTE_SOURCE_NAME

  Name of SDA remote source

  'ABC123'        --> SDA remote source ABC123
  '0CRM%'         --> SDA remote sources starting with '0CRM'
  '%'             --> No restriction related to SDA remote source

- REMOTE_OBJECT_NAME

  Name of SDA remote object

  'MYTABLE'       --> SDA remote object MYTABLE
  '%'             --> No restriction related to SDA remote object name

- EXCLUDE_SYSTEM_REPLICATION

  Possibility to exclude virtual tables used in context of Active/active (read-enabled) system replication setups

  'X'             --> Do not show tables related to system replication
  ' '             --> Show all virtual tables independent of system replication

- ONLY_MISSING_STATISTICS

  Possibility to restrict output to tables with missing query optimizer statistics

  'X'             --> Only display tabls without query optimizer statistics
  ' '             --> No restriction related to missing query optimizer statistics

[OUTPUT PARAMETERS]
 
- REMOTE_SOURCE:      Remote source name
- SCHEMA_NAME:        (Local) owner name
- TABLE_NAME:         (Local) table name
- REMOTE_OWNER_NAME:  Remote owner name
- REMOTE_OBJECT_NAME: Remote object name
- OPT_STATS:          Availability of optimizer statistics
- STATS_COMMAND:      Command for creating (simple) statistics 

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------
|REMOTE_SOURCE|SCHEMA_NAME|TABLE_NAME                    |REMOTE_OWNER_NAME|REMOTE_OBJECT_NAME                             |
----------------------------------------------------------------------------------------------------------------------------
|SR3          |_SYS_BI    |CONTATORI 06                  |_SYS_BIC         |ANSWER.saphana1.ISU/CONTATORI                  |
|SR3          |_SYS_BI    |CONTATORI 07                  |_SYS_BIC         |ANSWER.saphana1.ISU/CONTATORI                  |
|SR3          |_SYS_BI    |CONTATORI 08                  |_SYS_BIC         |ANSWER.saphana1.ISU/CONTATORI                  |
|SR3          |_SYS_BI    |CONTATORI 09                  |_SYS_BIC         |ANSWER.saphana1.ISU/CONTATORI                  |
|SR3          |_SYS_BI    |RIEPILOGO_ELENCO_LETTURE 05   |_SYS_BIC         |ANSWER.saphana1.ISU/RIEPILOGO_ELENCO_LETTURE   |
|SR3          |_SYS_BI    |RIEPILOGO_ELENCO_LETTURE 06   |_SYS_BIC         |ANSWER.saphana1.ISU/RIEPILOGO_ELENCO_LETTURE   |
|SR3          |_SYS_BI    |RIEPILOGO_ELENCO_LETTURE 07   |_SYS_BIC         |ANSWER.saphana1.ISU/RIEPILOGO_ELENCO_LETTURE   |
|SR3          |_SYS_BI    |RIEPILOGO_ELENCO_LETTURE 08   |_SYS_BIC         |ANSWER.saphana1.ISU/RIEPILOGO_ELENCO_LETTURE   |
|SR3          |_SYS_BI    |RIEPILOGO_LETTURE_EFFETTIVE 03|_SYS_BIC         |ANSWER.saphana1.ISU/RIEPILOGO_LETTURE_EFFETTIVE|
|SR3          |_SYS_BI    |RIEPILOGO_OPERANDI 03         |_SYS_BIC         |ANSWER.saphana1.ISU/RIEPILOGO_OPERANDI         |
|SR3          |_SYS_BI    |RIEPILOGO_OPERANDI 04         |_SYS_BIC         |ANSWER.saphana1.ISU/RIEPILOGO_OPERANDI         |
|SR3          |_SYS_BI    |ULTIMA_LETTURA_EFFETTIVA 01   |_SYS_BIC         |ANSWER.saphana1.ISU/ULTIMA_LETTURA_EFFETTIVA   |
|SR3          |_SYS_BI    |ULTIMA_LETTURA_EFFETTIVA 03   |_SYS_BIC         |ANSWER.saphana1.ISU/ULTIMA_LETTURA_EFFETTIVA   |
|SR3          |_SYS_BI    |ULTIMA_LETTURA_EFFETTIVA 04   |_SYS_BIC         |ANSWER.saphana1.ISU/ULTIMA_LETTURA_EFFETTIVA   |
|SR3          |_SYS_BI    |ULTIMA_LETTURA_EFFETTIVA 05   |_SYS_BIC         |ANSWER.saphana1.ISU/ULTIMA_LETTURA_EFFETTIVA   |
|SR3          |_SYS_BI    |UTENZE_CAMBIO_CONTATORE_3     |_SYS_BIC         |ANSWER.saphana1.ISU/UTENZE_CAMBIO_CONTATORE    |
|SR3          |_SYS_BI    |UTENZE_CESSATE 03             |_SYS_BIC         |ANSWER.saphana1.ISU/UTENZE_CESSATE             |
|C11          |_SYS_BI    |CONTATTI_CRM 01               |_SYS_BIC         |ANSWER.saphana1.CRM/CONTATTI_2                 |
|C11          |_SYS_BI    |CONTATTI_CRM 02               |_SYS_BIC         |ANSWER.saphana1.CRM/CONTATTI_2                 |
|C11          |_SYS_BI    |CONTATTI_CRM 04               |_SYS_BIC         |ANSWER.saphana1.CRM/CONTATTI_2                 |
|C11          |_SYS_BI    |CONTATTI_CRM 05               |_SYS_BIC         |ANSWER.saphana1.CRM/CONTATTI_2                 |
----------------------------------------------------------------------------------------------------------------------------

*/

  T.REMOTE_SOURCE_NAME REMOTE_SOURCE,
  T.SCHEMA_NAME,
  T.TABLE_NAME,
  T.REMOTE_OWNER_NAME,
  T.REMOTE_OBJECT_NAME,
  MAP(S.SCHEMA_NAME, NULL, 'NO', 'YES') OPT_STATS,
  MAP(S.SCHEMA_NAME, NULL, 'CREATE STATISTICS ON "' || T.SCHEMA_NAME || '"."' || T.TABLE_NAME || '"' || CHAR(59), '') STATS_COMMAND
FROM
( SELECT              /* Modification section */
    '%' SCHEMA_NAME,
    '%' TABLE_NAME,
    '%' REMOTE_SOURCE_NAME,
    '%' REMOTE_OBJECT_NAME,
    'X' EXCLUDE_SYSTEM_REPLICATION,
    ' ' ONLY_MISSING_STATISTICS
  FROM
    DUMMY
) BI INNER JOIN
  VIRTUAL_TABLES T ON
    T.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    T.TABLE_NAME LIKE BI.TABLE_NAME AND
    T.REMOTE_SOURCE_NAME LIKE BI.REMOTE_SOURCE_NAME AND
    ( BI.EXCLUDE_SYSTEM_REPLICATION = ' ' OR T.SCHEMA_NAME NOT LIKE '_SYS_SR_SITE%' ) AND
    T.REMOTE_OBJECT_NAME LIKE BI.REMOTE_OBJECT_NAME LEFT OUTER JOIN
( SELECT DISTINCT DATA_SOURCE_SCHEMA_NAME SCHEMA_NAME, DATA_SOURCE_OBJECT_NAME TABLE_NAME FROM DATA_STATISTICS ) S ON
    S.SCHEMA_NAME = T.SCHEMA_NAME AND
    S.TABLE_NAME = T.TABLE_NAME
WHERE
  ( BI.ONLY_MISSING_STATISTICS = ' ' OR MAP(S.SCHEMA_NAME, NULL, 'NO', 'YES') = 'NO' )
ORDER BY
  T.REMOTE_SOURCE_NAME,
  T.SCHEMA_NAME,
  T.TABLE_NAME