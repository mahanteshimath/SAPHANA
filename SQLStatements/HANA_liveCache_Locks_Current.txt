SELECT
/* 

[NAME]

- HANA_liveCache_Locks_Current

[DESCRIPTION]

- Overview of currently acquired liveCache locks

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Only relevant in scenarios with embedded liveCache
- Fails in SAP HANA Cloud (SHC) environments because liveCache is no longer available

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/02/24:  1.0 (initial version)
- 2017/10/25:  1.1 (TIMEZONE included)

[INVOLVED TABLES]

- M_LIVECACHE_LOCKS
- M_TRANSACTIONS
- M_SERVICE_THREADS

[INPUT PARAMETERS]

- TIMEZONE

  Used timezone (both for input and output parameters)

  'SERVER'       --> Display times in SAP HANA server time
  'UTC'          --> Display times in UTC time

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

[OUTPUT PARAMETERS]

- START_TIME:    Transaction start time
- TRANS_ID:      Transaction ID
- HOST:          Host name
- PORT:          Port
- SERVICE:       Service name
- CLASS:         Lock class
- ID:            Lock ID (object ID, schema ID or container ID, depending on lock class)
- GRANTED_MODE:  Granted lock mode ('Free', 'IntendShare', 'IntendExclusive', 'Share', 'ShareIntendExclusive', 'Exclusive')
- MODE:          Requested lock mode ('Free', 'IntendShare', 'IntendExclusive', 'Share', 'ShareIntendExclusive', 'Exclusive')
- TYPE:          Type of lock request (EOT -> can be removed end of transaction, Consistent -> can be removed if no longer required for consistent read purposes)
- STATE:         State of lock request
- TIMEOUT:       Timeout
- THREAD_DETAIL: Thread details, typically executed database procedure
- DURATION_S:    Thread duration

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|START_TIME         |TRANS_ID|HOST       |PORT |ID          |CLASS        |GRANTED_MODE|MODE |TYPE|STATE  |                                                                                                                                THREAD_DETAIL|DURATION_S|
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2015/02/24 21:51:49|      46|saphana2100|30203|0xfe0014cf42|ContainerLock|Share       |Share|EOT |Granted|                                                                                                                                             |          |
|2015/02/24 21:25:25|      73|saphana2100|30203|0xfe00150671|ContainerLock|Share       |Share|EOT |Granted|CALL  "APS_OPT_GET_ACTIVITY_NET"  (  X ,  X ,  X ,  X ,  X ,  X ,  X ,  X ,  X ,  X ,  X ,  X ,  X ,  X ,  X ,  X ,  X ,  X ,  X ,  X ,  X  )|   1546.00|
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(TR.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE TR.START_TIME END, 'YYYY/MM/DD HH24:MI:SS') START_TIME,
  LPAD(TR.TRANSACTION_ID, 8) TRANS_ID,
  L.HOST,
  LPAD(L.PORT, 5) PORT,
  S.SERVICE_NAME SERVICE,
  L.CLASS,
  L.ID,
  L.GRANTED_MODE,
  L.MODE,
  L.TYPE,
  L.STATE,
  LPAD(L.TIMEOUT, 7) TIMEOUT,
  TH.THREAD_DETAIL,
  LPAD(TO_DECIMAL(TH.DURATION / 1024, 10, 2), 10) DURATION_S
FROM
( SELECT                 /* Modification section */
    'SERVER' TIMEZONE,                              /* SERVER, UTC */
    '%' HOST,
    '%' PORT,
    '%' SERVICE_NAME
  FROM
    DUMMY
) BI INNER JOIN
  M_SERVICES S ON
    S.HOST LIKE BI.HOST AND
    TO_VARCHAR(S.PORT) LIKE BI.PORT AND
    S.SERVICE_NAME LIKE BI.SERVICE_NAME INNER JOIN
  M_LIVECACHE_LOCKS L ON
    L.HOST = S.HOST AND
    L.PORT = S.PORT INNER JOIN
  M_TRANSACTIONS TR ON
    L.TID = TR.UPDATE_TRANSACTION_ID LEFT OUTER JOIN
  M_SERVICE_THREADS TH ON
    TH.TRANSACTION_ID = TR.TRANSACTION_ID
WHERE
  L.ID IN ( SELECT ID FROM M_LIVECACHE_LOCKS WHERE TIMEOUT > 0)
ORDER BY
  L.ID,
  L.STATE

