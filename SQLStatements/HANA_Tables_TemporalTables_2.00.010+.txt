SELECT

/* 

[NAME]

- HANA_Tables_TemporalTables_2.00.010+

[DESCRIPTION]

- Overview of temporal tables (system-versioned and application-time period)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- TEMPORAL_TABLES available with SAP HANA >= 2.0 SPS 01
- Initially used for system-versioned tables, extended by application-time period tables with SAP HANA >= 2.0 SPS 04
- SAP Note 3055510 provides an example how to create and use system-versioned tables

[VALID FOR]

- Revisions:              >= 2.00.010

[SQL COMMAND VERSION]

- 2021/05/11:  1.0 (initial version)

[INVOLVED TABLES]

- TEMPORAL_TABLES

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

- PERIOD_NAME

  Time period name

  'SYSTEM_TIME'      --> System-versioned tables
  'APPLICATION_TIME' --> Application-time period tables
  '%'                --> No restriction related to time period name

- HISTORY_TABLE_NAME           

  History table name (containing historic content of main table)

  'T000_HIST'     --> Specific history table T000_HIST
  'T%'            --> All history tables starting with 'T'
  '%'             --> All history tables

[OUTPUT PARAMETERS]

- SCHEMA_NAME:         Schema name
- TABLE_NAME:          Table name
- PERIOD_NAME:         Period name (SYSTEM_TIME -> system-versioned, APPLICATION_TIME -> application-time period)
- START_COLUMN_NAME:   Period start column name
- END_COLUMN_NAME:     Period end column name
- HISTORY_SCHEMA_NAME: Schema name of history table
- HISTORY_TABLE_NAME:  History table name

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME|TABLE_NAME|PERIOD_NAME|START_COLUMN_NAME|END_COLUMN_NAME|HISTORY_SCHEMA_NAME|HISTORY_TABLE_NAME|
-------------------------------------------------------------------------------------------------------------
|SYSTEM     |ACCOUNT   |SYSTEM_TIME|VALID_FROM       |VALID_TO       |SYSTEM             |ACCOUNT_HISTORY   |
-------------------------------------------------------------------------------------------------------------

*/

  TT.SCHEMA_NAME,
  TT.TABLE_NAME,
  TT.PERIOD_NAME,
  TT.PERIOD_START_COLUMN_NAME START_COLUMN_NAME,
  TT.PERIOD_END_COLUMN_NAME END_COLUMN_NAME,
  TT.HISTORY_SCHEMA_NAME,
  TT.HISTORY_TABLE_NAME
FROM
( SELECT                     /* Modification section */
    '%' SCHEMA_NAME,
    '%' TABLE_NAME,
    '%' PERIOD_NAME,
    '%' HISTORY_TABLE_NAME
  FROM
    DUMMY
) BI,
  TEMPORAL_TABLES TT
WHERE
  TT.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  TT.TABLE_NAME LIKE BI.TABLE_NAME AND
  TT.PERIOD_NAME LIKE BI.PERIOD_NAME AND
  IFNULL(TT.HISTORY_TABLE_NAME, '') LIKE BI.HISTORY_TABLE_NAME
ORDER BY
  TT.SCHEMA_NAME,
  TT.TABLE_NAME