SELECT
/* 

[NAME]

- HANA_Services_Overview_2.00.040+

[DESCRIPTION]

- Service overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_SERVICES.IS_DATABASE_LOCAL available with SAP HANA >= 2.00.040

[VALID FOR]

- Revisions:              >= 2.00.040

[SQL COMMAND VERSION]

- 2014/05/05:  1.0 (initial version)
- 2019/07/27:  1.1 (dedicated 2.00.040+ version including IS_DATABASE_LOCAL)

[INVOLVED TABLES]

- M_SERVICES

[INPUT PARAMETERS]

- HOST

  Host name

  'saphana01'     --> Specic host saphana01
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

- LOCAL

  Flag if service is local in one database

  'TRUE'          --> Only list services that are local to one tenant
  'FALSE'         --> Only list services that are shared by all databases
  '%'             --> No restriction related to local / shared services

- EXCLUDE_STARTED_SERVICES

  Possibility to exclude started services

  'X'             --> Only show services that are not started properly
  ' '             --> Show all services

[OUTPUT PARAMETERS]

- HOST:         Host name
- PORT:         Port
- SERVICE:      Service name
- TYPE:         Service type (e.g. MASTER)
- STARTED:      Information if service is started properly
- LOCAL:        TRUE if service is local to a tenant, FALSE if service is shared
- SQL_PORT:     SQL port
- PROCESS_ID:   Process ID

[EXAMPLE OUTPUT]

----------------------------------------------------------------------
|HOST      |PORT |SERVICE_NAME    |TYPE  |STARTED|SQL_PORT|PROCESS_ID|
----------------------------------------------------------------------
|saphana001|30200|daemon          |NONE  |YES    |       0|      7697|
|saphana001|30201|nameserver      |MASTER|YES    |       0|      7748|
|saphana001|30202|preprocessor    |NONE  |YES    |       0|      7841|
|saphana001|30203|indexserver     |MASTER|YES    |   30215|     30460|
|saphana001|30204|scriptserver    |NONE  |YES    |       0|      7886|
|saphana001|30205|statisticsserver|MASTER|YES    |   30217|      7889|
|saphana001|30207|xsengine        |NONE  |YES    |       0|      7892|
|saphana001|30210|compileserver   |NONE  |YES    |       0|      7844|
----------------------------------------------------------------------

*/

  S.HOST,
  LPAD(S.PORT, 5) PORT, 
  S.SERVICE_NAME SERVICE,
  S.COORDINATOR_TYPE TYPE,
  S.ACTIVE_STATUS STARTED,
  S.IS_DATABASE_LOCAL LOCAL,
  LPAD(S.SQL_PORT, 8) SQL_PORT,
  LPAD(S.PROCESS_ID, 10) PROCESS_ID
FROM
( SELECT                        /* Modification section */
    '%' HOST,
    '%' PORT,
    '%' SERVICE_NAME,
    '%' LOCAL,
    ' ' EXCLUDE_STARTED_SERVICES
  FROM
    DUMMY
) BI,
  M_SERVICES S
WHERE
  S.HOST LIKE BI.HOST AND
  TO_VARCHAR(S.PORT) LIKE BI.PORT AND
  S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
  S.IS_DATABASE_LOCAL LIKE BI.LOCAL AND
  ( BI.EXCLUDE_STARTED_SERVICES = ' ' OR
    BI.EXCLUDE_STARTED_SERVICES = 'X' AND S.ACTIVE_STATUS != 'YES' )
ORDER BY
  S.HOST,
  S.PORT
