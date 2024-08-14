SELECT
/* 

[NAME]

- HANA_Events

[DESCRIPTION]

- Internal SAP HANA events, usually processed by statistics server

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/12/29:  1.0 (initial version)
- 2017/10/24:  1.1 (TIMEZONE included)

[INVOLVED TABLES]

- M_EVENTS
- M_SERVICES

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

- ONLY_OPEN_EVENTS

  Possibility to display only non-acknowledged events

  'X'             --> Only display events without acknowledgement
  ' '             --> No restriction related to acknowledgement
  
[OUTPUT PARAMETERS]

- HOST:        Host name
- PORT:        Port
- SERVICE:     Service name
- TYPE:        Event type
- CREATE_TIME: Creation time
- UPDATE_TIME: Update time
- HANDLE_TIME: Handle time
- ACK:         TRUE of event was already acknowledged, otherwise FALSE
- STATE:       Event state
- DETAILS:     Event details

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST  |PORT |SERVICE   |TYPE            |CREATE_TIME        |UPDATE_TIME|HANDLE_TIME|ACK  |STATE|DETAILS                                                                                                                                                   |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|hana01|30001|nameserver|ReplicationError|2015/12/17 19:14:33|           |           |FALSE|INFO |parameter mismatch (existence): global.ini/system/[memorymanager]/statement_memory_limit = '975' exists only on site 1                                    |
|hana01|30001|nameserver|ReplicationError|2015/12/17 19:14:33|           |           |FALSE|INFO |parameter mismatch (existence): global.ini/system/[expensive_statement]/threshold_duration = '3000000' exists only on site 1                              |
|hana01|30001|nameserver|ReplicationError|2015/12/17 19:14:33|           |           |FALSE|INFO |parameter mismatch (existence): global.ini/system/[expensive_statement]/use_in_memory_tracing = 'false' exists only on site 1                             |
|hana01|30001|nameserver|ReplicationError|2015/12/17 19:14:33|           |           |FALSE|INFO |parameter mismatch (existence): global.ini/system/[persistence]/log_mode = 'normal' exists only on site 2                                                 |
|hana01|30001|nameserver|ReplicationError|2015/12/17 19:14:33|           |           |FALSE|INFO |parameter mismatch (existence): global.ini/system/[resource_tracking]/service_thread_sampling_monitor_thread_detail_enabled = 'true' exists only on site 1|
|hana01|30001|nameserver|ReplicationError|2015/12/17 19:14:33|           |           |FALSE|INFO |parameter mismatch (existence): global.ini/system/[resource_tracking]/memory_tracking = 'on' exists only on site 1                                        |
|hana01|30001|nameserver|ReplicationError|2015/12/17 19:14:33|           |           |FALSE|INFO |parameter mismatch (existence): indexserver.ini/system/[sql]/plan_cache_size = '5368709120' exists only on site 1                                         |
|hana01|30001|nameserver|ReplicationError|2015/12/17 19:14:33|           |           |FALSE|INFO |parameter mismatch (existence): global.ini/system/[expensive_statement]/enable = 'true' exists only on site 1                                             |
|hana01|30001|nameserver|ReplicationError|2015/12/17 19:14:33|           |           |FALSE|INFO |parameter mismatch (existence): global.ini/system/[resource_tracking]/enable_tracking = 'on' exists only on site 1                                        |
|hana01|30001|nameserver|ReplicationError|2015/12/17 19:14:33|           |           |FALSE|INFO |parameter mismatch (existence): global.ini/system/[resource_tracking]/cpu_time_measurement_mode = 'on' exists only on site 1                              |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  E.HOST,
  LPAD(E.PORT, 5) PORT,
  S.SERVICE_NAME SERVICE,
  E.TYPE,
  TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(E.CREATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE E.CREATE_TIME END, 'YYYY/MM/DD HH24:MI:SS') CREATE_TIME,
  IFNULL(TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(E.UPDATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE E.UPDATE_TIME END, 'YYYY/MM/DD HH24:MI:SS'), '') UPDATE_TIME,
  IFNULL(TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(E.HANDLE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE E.HANDLE_TIME END, 'YYYY/MM/DD HH24:MI:SS'), '') HANDLE_TIME,
  E.ACKNOWLEDGED ACK,
  E.STATE,
  E.INFOTEXT DETAILS
FROM
( SELECT            /* Modification section */
    'SERVER' TIMEZONE,                              /* SERVER, UTC */
    '%' HOST,
    '%' PORT,
    '%' SERVICE_NAME,
    'X' ONLY_OPEN_EVENTS
  FROM
    DUMMY
) BI,
  M_SERVICES S,
  M_EVENTS E
WHERE
  S.HOST LIKE BI.HOST AND
  TO_VARCHAR(S.PORT) LIKE BI.PORT AND
  S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
  E.HOST = S.HOST AND
  E.PORT = S.PORT AND
  ( BI.ONLY_OPEN_EVENTS = ' ' OR E.ACKNOWLEDGED = 'FALSE' )
ORDER BY
  E.CREATE_TIME DESC