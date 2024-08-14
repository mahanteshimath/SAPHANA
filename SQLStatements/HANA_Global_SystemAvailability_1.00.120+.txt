SELECT

/* 

[NAME]

- HANA_Global_SystemAvailability_1.00.120+

[DESCRIPTION]

- Information about system availability

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_SYSTEM_AVAILABILITY only available as of Rev. 120

[VALID FOR]

- Revisions:              >= 1.00.120

[SQL COMMAND VERSION]

- 2016/08/14:  1.0 (initial version)
- 2017/10/24:  1.1 (TIMEZONE included)

[INVOLVED TABLES]

- M_SYSTEM_AVAILABILITY

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

- HOST_ACTIVE

  Filter for host activity states

  'WARNING'       --> Only display events with host status WARNING
  '%'             --> No restriction related to host status

- EXCLUDE_OK_STATES

  Possibility to exclude events indicating that everything is fine

  'X'             --> Only show events that do not indicate a properly running system
  ' '             --> No restriction related to current state

[OUTPUT PARAMETERS]

- EVENT_TIME:           Event time
- HOST:                 Host name
- PORT:                 Port
- SERVICE_NAME:         Service name
- EVENT_NAME:           Event name
- SYSTEM_ACTIVE:        System activity state
- SYSTEM_STATUS:        System status
- HOST_ACTIVE:          Host activitiy state
- HOST_STATUS:          Host status
- SERVICE_ACTIVE:       Service activity state

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------------------------------------------
|EVENT_TIME         |HOST        |PORT |SERVICE_NAME |EVENT_NAME      |SYSTEM_ACTIVE|SYSTEM_STATUS|HOST_ACTIVE|HOST_STATUS|SERVICE_ACTIVE|
------------------------------------------------------------------------------------------------------------------------------------------
|2016/08/05 11:56:57|mo-18b50883c|31010|compileserver|SERVICE_STARTING|UNKNOWN      |WARNING      |STARTING   |WARNING    |STARTING      |
|2016/08/05 11:56:57|mo-18b50883c|31010|compileserver|SERVICE_STARTING|UNKNOWN      |WARNING      |STARTING   |WARNING    |STARTING      |
|2016/08/05 11:56:48|mo-18b50883c|31001|nameserver   |SERVICE_STARTED |UNKNOWN      |WARNING      |STARTING   |WARNING    |YES           |
|2016/08/05 11:56:48|mo-18b50883c|31001|nameserver   |SERVICE_STARTED |UNKNOWN      |WARNING      |STARTING   |WARNING    |YES           |
|2016/08/05 11:56:47|mo-18b50883c|31001|nameserver   |SERVICE_STARTING|UNKNOWN      |WARNING      |STARTING   |WARNING    |STARTING      |
|2016/08/05 11:56:47|mo-18b50883c|31001|nameserver   |SERVICE_STARTING|UNKNOWN      |WARNING      |STARTING   |WARNING    |STARTING      |
|2016/08/05 11:56:05|mo-4dfbe93a0|31006|webdispatcher|SERVICE_STARTED |UNKNOWN      |ERROR        |YES        |OK         |YES           |
|2016/08/05 11:56:02|mo-4dfbe93a0|31006|webdispatcher|SERVICE_STARTING|UNKNOWN      |ERROR        |STARTING   |WARNING    |STARTING      |
|2016/08/05 11:55:54|mo-4dfbe93a0|31007|xsengine     |SERVICE_STARTED |UNKNOWN      |ERROR        |STARTING   |WARNING    |YES           |
|2016/08/05 11:55:38|mo-4dfbe93a0|31003|indexserver  |SERVICE_STARTED |UNKNOWN      |ERROR        |STARTING   |WARNING    |YES           |
|2016/08/05 11:55:35|mo-4dfbe93a0|31043|indexserver  |SERVICE_STARTED |UNKNOWN      |ERROR        |STARTING   |WARNING    |YES           |
|2016/08/05 11:54:05|mo-4dfbe93a0|31003|indexserver  |SERVICE_STARTING|UNKNOWN      |ERROR        |STARTING   |WARNING    |STARTING      |
|2016/08/03 18:23:13|mo-18b50883c|31006|webdispatcher|SERVICE_STARTING|UNKNOWN      |WARNING      |STARTING   |WARNING    |STARTING      |
|2016/08/03 18:23:13|mo-18b50883c|31006|webdispatcher|SERVICE_STARTING|UNKNOWN      |WARNING      |STARTING   |WARNING    |STARTING      |
|2016/08/03 18:23:03|mo-4dfbe93a0|31006|webdispatcher|SERVICE_STARTED |UNKNOWN      |WARNING      |YES        |OK         |YES           |
|2016/08/03 18:22:59|mo-4dfbe93a0|31006|webdispatcher|SERVICE_STARTING|UNKNOWN      |WARNING      |STARTING   |WARNING    |STARTING      |
|2016/08/03 18:22:51|mo-18b50883c|31003|indexserver  |SERVICE_STARTED |UNKNOWN      |WARNING      |STARTING   |WARNING    |YES           |
|2016/08/03 18:22:51|mo-18b50883c|31003|indexserver  |SERVICE_STARTED |UNKNOWN      |WARNING      |STARTING   |WARNING    |YES           |
|2016/08/03 18:22:44|mo-4dfbe93a0|31007|xsengine     |SERVICE_STARTED |UNKNOWN      |WARNING      |STARTING   |WARNING    |YES           |
|2016/08/03 18:22:41|mo-18b50883c|31040|indexserver  |SERVICE_STARTED |UNKNOWN      |WARNING      |STARTING   |WARNING    |YES           |
|2016/08/03 18:22:41|mo-18b50883c|31040|indexserver  |SERVICE_STARTED |UNKNOWN      |WARNING      |STARTING   |WARNING    |YES           |
|2016/08/03 18:22:41|mo-18b50883c|31043|indexserver  |SERVICE_STARTED |UNKNOWN      |WARNING      |STARTING   |WARNING    |YES           |
------------------------------------------------------------------------------------------------------------------------------------------

*/

  TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(A.EVENT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE A.EVENT_TIME END, 'YYYY/MM/DD HH24:MI:SS') EVENT_TIME,
  A.HOST,
  LPAD(A.PORT, 5) PORT,
  A.SERVICE_NAME,
  A.EVENT_NAME,
  A.SYSTEM_ACTIVE,
  A.SYSTEM_STATUS,
  A.HOST_ACTIVE,
  A.HOST_STATUS,
  A.SERVICE_ACTIVE
FROM
( SELECT             /* Modification section */
    'SERVER' TIMEZONE,                              /* SERVER, UTC */
    '%' HOST,
    '%' PORT,
    '%' SERVICE_NAME,
    '%' HOST_ACTIVE,
    '%' HOST_STATUS,
    'X' EXCLUDE_OK_STATES
  FROM
    DUMMY
) BI,
  M_SYSTEM_AVAILABILITY A
WHERE
  A.HOST LIKE BI.HOST AND
  TO_VARCHAR(A.PORT) LIKE BI.PORT AND
  A.SERVICE_NAME LIKE BI.SERVICE_NAME AND
  A.HOST_ACTIVE LIKE BI.HOST_ACTIVE AND
  A.HOST_STATUS LIKE BI.HOST_STATUS AND
  ( BI.EXCLUDE_OK_STATES = ' ' OR A.SYSTEM_ACTIVE != 'YES' OR A.SYSTEM_STATUS NOT IN ( 'INFO', 'OK' ) OR A.HOST_ACTIVE != 'YES' OR A.HOST_STATUS NOT IN ( 'INFO', 'OK', 'IGNORE') )
ORDER BY
  A.EVENT_TIME DESC
