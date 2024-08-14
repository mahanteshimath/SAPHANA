SELECT
/* 

[NAME]

- HANA_Jobs_JobProgress

[DESCRIPTION]

- Progress of SAP HANA job activities (e.g. consistency check, merge or compression optimization)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              >= 1.00.100

[SQL COMMAND VERSION]

- 2015/12/20:  1.0 (initial version)
- 2017/10/25:  1.1 (TIMEZONE included)
- 2018/09/19:  1.2 (MIN_RUNTIME_S included)

[INVOLVED TABLES]

- M_JOB_PROGRESS

[INPUT PARAMETERS]

- TIMEZONE

  Used timezone (both for input and output parameters)

  'SERVER'       --> Display times in SAP HANA server time
  'UTC'          --> Display times in UTC time

- HOST

  Host name

  'saphana01'     --> Specific host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- PORT

  Port number

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- SERVICE_NAME

  Service name

  'indexserver'   --> Specific service indexserver
  '%server'       --> All services ending with 'server'
  '%'             --> All services  

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- OBJECT_NAME           

  Object name or pattern

  'T000'          --> Specific object T000
  'T%'            --> All objects starting with 'T'
  '%'             --> All objects

- JOB_NAME

  Job name, available values (see M_JOB_HISTORY_INFO):

    Backup
    BW F Fact Table Compression 
    Check Table Consistency 
    Column table reloading on startup
    Data Statistics Autocreate
    Delta Log Replay 
    Delta Merge 
    DSO activation 
    DSO conversion 
    DSO rollback 
    Export 
    Import 
    Optimize Compression
    Plan Stability
    Reclaim Delta 
    Re-partitioning 
    Row Store Reorganization
    Runtimedump
    Save PerfTrace 
    Savepoint 
    Savepoint Critical Phase
    Table Consistency Check
    Table conversion (Col to Row) 
    Table conversion (Row to Col) 
    Table Redistribution Execute 
    Table Redistribution Generate 

  'Import'       --> Display information for Import jobs
  'DSO%'         --> Display information for jobs starting with 'DSO'
  '%'            --> No restriction related to job name

- CONN_ID

  Connection ID

  330655          --> Connection ID 330655
  -1              --> No connection ID restriction

- MIN_RUNTIME_S

  Minimum job runtime (s)

  86400          --> Only display jobs with a runtime of at least 86400 seconds
  -1             --> No restriction related to job runtime

[OUTPUT PARAMETERS]

- START_TIME:       Job start time
- JOB_NAME:         Job name
- RUNTIME_S:        Job runtime (s)
- HOST:             Host name
- PORT:             Port
- SERVICE:          Service name
- CONN_ID:          Connection ID
- SCHEMA_NAME:      Schema name
- OBJECT_NAME:      Object name
- PROGRESS:         Job progress
- PROGRESS_DETAILS: Progress details,
- SAP_NOTE:         Related SAP Note

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------
|START_TIME         |JOB_NAME |RUNTIME_S|HOST        |PORT |SERVICE    |CONN_ID|SCHEMA_NAME|OBJECT_NAME|PROGRESS|PROGRESS_DETAIL   |SAP_NOTE|
---------------------------------------------------------------------------------------------------------------------------------------------
|2016/02/01 09:15:51|Savepoint|        2|saphana00001|30203|indexserver|      0|           |           |2 of 9  |PAGEFLUSH         | 2100009|
|2016/01/31 21:56:48|Export   |    40745|saphana00001|30203|indexserver| 329584|SAPDIP     |ZTCSFILE   |31 of 32|Exporting a object|        |
|2016/01/31 21:35:16|Export   |    42037|saphana00001|30203|indexserver| 329584|           |           |0 of 1  |Exporting data    |        |
---------------------------------------------------------------------------------------------------------------------------------------------

*/

  TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(J.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE J.START_TIME END, 'YYYY/MM/DD HH24:MI:SS') START_TIME,
  J.JOB_NAME,
  LPAD(SECONDS_BETWEEN(J.START_TIME, CURRENT_TIMESTAMP), 9) RUNTIME_S,
  J.HOST,
  LPAD(J.PORT, 5) PORT,
  S.SERVICE_NAME SERVICE,
  LPAD(J.CONNECTION_ID, 7) CONN_ID,
  J.SCHEMA_NAME,
  J.OBJECT_NAME,
  J.CURRENT_PROGRESS || CHAR(32) || 'of' || CHAR(32) || J.MAX_PROGRESS PROGRESS,
  J.PROGRESS_DETAIL,
  LPAD(CASE J.JOB_NAME
    WHEN 'Alter Table'                       THEN '2366291'
    WHEN 'Backup'                            THEN '1642148'
    WHEN 'BW F Fact Table Compression'       THEN '2057046'
    WHEN 'Check Table Consistency'           THEN '2116157'
    WHEN 'Column table reloading on startup' THEN '2127458'
    WHEN 'Create Index'                      THEN '2160391'
    WHEN 'Create Table Like'                 THEN '2366291'
    WHEN 'Data Statistics Autocreate'        THEN '2124112'
    WHEN 'Delta Log Replay'                  THEN '1642148'
    WHEN 'Delta Merge'                       THEN '2057046'
    WHEN 'DSO activation'                    THEN '1849497'
    WHEN 'DSO conversion'                    THEN '1849497'
    WHEN 'DSO rollback'                      THEN '1849497'
    WHEN 'Export'                            THEN '2476884'
    WHEN 'Export All'                        THEN '2476884'
    WHEN 'Export Object'                     THEN '2476884'
    WHEN 'Import'                            THEN '2476884'
    WHEN 'Import All'                        THEN '2476884'
    WHEN 'Import Object'                     THEN '2476884'
    WHEN 'Memory Profiler'                   THEN '1999997'
    WHEN 'Move Table'                        THEN '2081591'
    WHEN 'Online repartitioning'             THEN '2044468'
    WHEN 'Optimize Compression'              THEN '2112604'
    WHEN 'Plan Stability'                    THEN '2799998'
    WHEN 'Reclaim Delta'                     THEN '2057046'
    WHEN 'Re-partitioning'                   THEN '2044468'
    WHEN 'Row Store Reorganization'          THEN '1813245'
    WHEN 'Runtimedump'                       THEN '2400007'
    WHEN 'Save PerfTrace'                    THEN '1787489'
    WHEN 'Savepoint'                         THEN '2100009'
    WHEN 'Savepoint Critical Phase'          THEN '2100009'
    WHEN 'System Replication Data Transfer'  THEN '1999880'
    WHEN 'Table Consistency Check'           THEN '2116157'
    WHEN 'Table Consistency Check All'       THEN '2116157'
    WHEN 'Table Consistency Check Object'    THEN '2116157'
    WHEN 'Table conversion (Col to Row)'     THEN '2222277'
    WHEN 'Table conversion (Row to Col)'     THEN '2222277'
    WHEN 'Table Redistribution Execute'      THEN '2081591'
    WHEN 'Table Redistribution Generate'     THEN '2081591'
  END, 8) SAP_NOTE
FROM
( SELECT          /* Modification section */
    'SERVER' TIMEZONE,                              /* SERVER, UTC */
    '%' HOST,
    '%' PORT,
    '%' SERVICE_NAME,
    '%' SCHEMA_NAME,
    '%' OBJECT_NAME,
    '%' JOB_NAME,
    -1 CONN_ID,
    -1 MIN_RUNTIME_S
  FROM
    DUMMY
) BI,
  M_SERVICES S,
  M_JOB_PROGRESS J
WHERE
  S.HOST LIKE BI.HOST AND
  TO_VARCHAR(S.PORT) LIKE BI.PORT AND
  S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
  J.HOST = S.HOST AND
  J.PORT = S.PORT AND
  J.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  J.OBJECT_NAME LIKE BI.OBJECT_NAME AND
  UPPER(J.JOB_NAME) LIKE UPPER(BI.JOB_NAME) AND
  ( BI.CONN_ID = -1 OR J.CONNECTION_ID = BI.CONN_ID ) AND
  ( BI.MIN_RUNTIME_S = -1 OR SECONDS_BETWEEN(J.START_TIME, CURRENT_TIMESTAMP) >= BI.MIN_RUNTIME_S )
ORDER BY
  START_TIME DESC