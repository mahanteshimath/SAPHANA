SELECT
/* 

[NAME]

- HANA_Sessions_1.00.120+

[DESCRIPTION]

- Show current session information (i.e. connections + threads + transactions + clients + SQL statements)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- LOCK_WAIT_NAME and LOCK_OWNER_THREAD_ID only available as SAP HANA 1.00.70
- STATEMENT_EXECUTION_ID available starting with SAP HANA 1.00.120

[VALID FOR]

- Revisions:              >= 1.00.120

[SQL COMMAND VERSION]

- 2014/04/08:  1.0 (initial version)
- 2014/04/24:  1.1 (M_ACTIVE_STATEMENTS included)
- 2014/04/30:  1.2 (WAITING_FOR and THREAD_METHOD included)
- 2014/07/09:  1.3 (APP_USER included)
- 2014/07/21:  1.4 (ACT_DAYS included)
- 2016/11/18:  1.5 (STATEMENT_EXECUTION_ID included)
- 2017/10/26:  1.6 (TIMEZONE included)
- 2021/12/19:  1.7 (APP_USER and APP_SOURCE filter included)

[INVOLVED TABLES]

- M_CONNECTIONS
- M_PREPARED_STATEMENTS
- M_SERVICE_THREADS
- M_TRANSACTIONS
- M_MVCC_TABLES
- M_SQL_PLAN_CACHE

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

- CONN_ID

  Connection ID

  330655          --> Connection ID 330655
  -1              --> No connection ID restriction

- THREAD_ID

  Thread identifier

  4567            --> Thread 4567
  -1              --> No thread identifier restriction

- THREAD_STATE

  State of thread (e.g. e.g. 'Running', 'Network Read' or 'Semaphore Wait')

  'Running'       --> Threads with state 'Running'
  '%'             --> No thread state restriction

- TRANSACTION_ID

  Transaction identifier

  123             --> Transaction identifier 123
  -1              --> No restriction to specific transaction identifiers

- UPDATE_TRANSACTION_ID

  Update transaction identifier (used for DML operations)

  123456          --> Update transaction identifier 123456
  -1              --> No restriction to specific update transaction identifier

- CLIENT_PID

  Client process ID

  10264           --> Client process ID 10264
  -1              --> No client process ID restriction

- APP_SOURCE

  Application source

  'SAPL2:437'     --> Application source 'SAPL2:437'
  'SAPMSSY2%'     --> Application sources starting with SAPMSSY2
  '%'             --> No application source restriction

- APP_USER

  Application user

  'SAPSYS'        --> Application user 'SAPSYS'
  '%'             --> No application user restriction

- ONLY_ACTIVE_THREADS

  Possibility to restrict results to active threads

  'X'             --> Display only active threads
  ' '             --> No restriction to active threads

- ONLY_ACTIVE_TRANSACTIONS

  Possibility to restrict results to active transactions

  'X'             --> Restrict results to active transaction
  ' '             --> No restriction of transactions

- ONLY_ACTIVE_UPDATE_TRANSACTIONS

  Possibility to restrict results to active DML transactions

  'X'             --> Restrict results to active DML transaction
  ' '             --> No restriction of DML transactions

- ONLY_ACTIVE_SQL_STATEMENTS

  Possibility to restrict results to active SQL statements

  'X'             --> Restrict results to active SQL statements
  ' '             --> No restriction to active SQL statements

- ONLY_MVCC_BLOCKER

  Possibility to restrict results to the MVCC blocker sessions

  'X'             --> Only show sessions currently blocking MVCC garbage collection
  ' '             --> No restriction to MVCC blocker sessions

- MAX_THREAD_DETAIL_LENGTH

  Maximum output length of THREAD_DETAIL column

  40              --> Maximum length of 40 characters
  -1              --> No length limitation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'CONNECTION'    --> Sorting by connection 
  'THREAD'        --> Sorting by thread

[OUTPUT PARAMETERS]

- HOST:               Host name
- PORT:               Port
- SERVICE:            Service name
- CONN_ID:            Connection ID
- THREAD_ID:          Thread ID
- TRANS_ID:           Transaction identifier
- UPD_TID:            Update transaction identifier
- CLIENT_PID:         Client process identifier (e.g. of SAP workprocess)
- CLIENT_HOST:        Host of client process (e.g. SAP application server)
- TRANSACTION_START:  Start time of transaction
- ACT_DAYS:           Number of days since start of transaction
- THREAD_TYPE:        Thread type
- THREAD_STATE:       Thread state
- WAITING_FOR:        Reason why process is waiting:
                      - "Network Read"             --> called thread
                      - "ConditionalVariable Wait" --> blocking session
                      - Other lock wait            --> lock wait name
- APPLICATION_SOURCE: Application issuing the database request
- STATEMENT_HASH:     Statement hash
- STMT_EXEC_ID:       Statement execution ID (unique identifier for the execution of a particular SQL statement)
- THREAD_DETAIL:      Thread details (e.g. SQL statement text)
- MEMORY_MB:          SQL memory allocation (MB)
- THREAD_METHOD:      Thread method
- TRANS_STATE:        Transaction state
- TRANSACTION_TYPE:   Transaction type
- MVCC_TABLE_NAME:    Table name blocking MVCC
- APP_USER:           Application user name (e.g. SAP end user)

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST     |PORT |CONN_ID   |THREAD_ID |TRANS_ID|UPD_TID  |CLIENT_PID|CLIENT_HOST|TRANSACTION_START  |THREAD_TYPE  |THREAD_STATE    |WAITING_FOR                   |APPLICATION_SOURCE                  |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|saphana21|30103|    302754|     28965|    1102|        0|  20512790|yyyond     |2014/04/30 08:56:44|SqlExecutor  |Running         |                              |                                    |
|saphana21|30103|    300466|      2193|     111|        0|  12714142|yyyin      |2014/04/30 08:57:48|JobWorker    |Semaphore Wait  |CALLING: 21042                |CL_SQL_STATEMENT==============CP:500|
|saphana21|30103|    300466|     21042|     111|        0|  12714142|yyyin      |2014/04/30 08:57:48|RemoteService|Network Read    |CALLING: 29090@saphana21:30103|CL_SQL_STATEMENT==============CP:500|
|saphana21|30103|    300466|     21182|     111|        0|  12714142|yyyin      |2014/04/30 08:57:48|SqlExecutor  |Job Exec Waiting|CALLING: 2193                 |CL_SQL_STATEMENT==============CP:500|
|saphana21|30103|    300466|     29090|     111|        0|  12714142|yyyin      |2014/04/30 08:57:48|Request      |Running         |                              |CL_SQL_STATEMENT==============CP:500|
|saphana21|30103|    300966|      3380|     352|762490855|   7012544|yyyenji    |2014/04/30 08:58:13|JobWorker    |Running         |                              |                                    |
|saphana21|30103|    300966|     29128|     352|762490855|   7012544|yyyenji    |2014/04/30 08:58:13|SqlExecutor  |Semaphore Wait  |CALLING: 3380                 |                                    |
|saphana21|30103|    303630|     29372|    1414|        0|   4391216|yyysta     |2014/04/30 08:58:49|SqlExecutor  |Running         |                              |                                    |
|saphana21|30103|    302409|     29160|    1062|        0|  12386512|yyychua    |2014/04/30 08:58:50|SqlExecutor  |Running         |                              |Z_RB_ED_001:400                     |
|saphana21|30103|    301094|     28953|     415|        0|  21561394|yyyfeel    |2014/04/30 08:58:53|SqlExecutor  |Running         |                              |                                    |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  C.HOST,
  LPAD(C.PORT, 5) PORT,
  S.SERVICE_NAME SERVICE,
  IFNULL(LPAD(C.CONN_ID, 7), '') CONN_ID,
  IFNULL(LPAD(C.THREAD_ID, 9), '') THREAD_ID,
  IFNULL(LPAD(C.TRANSACTION_ID, 8), '') TRANS_ID,
  IFNULL(LPAD(C.UPD_TRANS_ID, 9), '') UPD_TID,
  IFNULL(LPAD(C.CLIENT_PID, 10), '') CLIENT_PID,
  C.CLIENT_HOST,
  TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(C.TRANSACTION_START, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE C.TRANSACTION_START END, 'YYYY/MM/DD HH24:MI:SS') TRANSACTION_START,
  IFNULL(LPAD(TO_DECIMAL(C.TRANSACTION_ACTIVE_DAYS, 10, 2), 8), '') ACT_DAYS,
  C.THREAD_TYPE,
  C.THREAD_STATE,
  C.CALLER,
  C.WAITING_FOR,
  C.APPLICATION_SOURCE,
  C.STATEMENT_HASH,
  TO_VARCHAR(C.STATEMENT_EXECUTION_ID) STMT_EXEC_ID,
  CASE
    WHEN MAX_THREAD_DETAIL_LENGTH = -1 THEN THREAD_DETAIL
    WHEN THREAD_DETAIL_FROM_POS <= 15 THEN
      SUBSTR(THREAD_DETAIL, 1, MAX_THREAD_DETAIL_LENGTH)
    ELSE
      SUBSTR(SUBSTR(THREAD_DETAIL, 1, LOCATE(THREAD_DETAIL, CHAR(32))) || '...' || SUBSTR(THREAD_DETAIL, THREAD_DETAIL_FROM_POS - 1), 1, MAX_THREAD_DETAIL_LENGTH) 
  END THREAD_DETAIL,
  IFNULL(LPAD(TO_DECIMAL(C.ALLOCATED_MEMORY_SIZE / 1024 / 1024, 10, 2), 9), '') MEMORY_MB,
  C.THREAD_METHOD,
  C.TRANSACTION_STATE TRANS_STATE,
  C.TRANSACTION_TYPE,
  C.TABLE_NAME MVCC_TABLE_NAME,
  C.APPLICATION_USER_NAME APP_USER
FROM
( SELECT                     /* Modification section */
    'SERVER' TIMEZONE,                              /* SERVER, UTC */
    '%' HOST,
    '%' PORT,
    '%' SERVICE_NAME,
    -1 CONN_ID,
    -1 THREAD_ID,
    '%' THREAD_STATE,
    -1 TRANSACTION_ID,
    -1 UPDATE_TRANSACTION_ID,
    -1 CLIENT_PID,
    '%' APP_SOURCE,
    '%' APP_USER,
    'X' ONLY_ACTIVE_THREADS,
    'X' ONLY_ACTIVE_TRANSACTIONS,
    ' ' ONLY_ACTIVE_UPDATE_TRANSACTIONS,
    ' ' ONLY_ACTIVE_SQL_STATEMENTS,
    ' ' ONLY_MVCC_BLOCKER,
    80 MAX_THREAD_DETAIL_LENGTH,
    'TRANSACTION_TIME' ORDER_BY           /* CONNECTION, THREAD, TRANSACTION, UPDATE_TRANSACTION, TRANSACTION_TIME */
  FROM
    DUMMY
) BI,
  M_SERVICES S,
( SELECT
    IFNULL(C.HOST, IFNULL(TH.HOST, T.HOST)) HOST,
    IFNULL(C.PORT, IFNULL(TH.PORT, T.PORT)) PORT,
    C.CONNECTION_ID CONN_ID,
    TH.THREAD_ID,
    IFNULL(TH.THREAD_STATE, '') THREAD_STATE,
    IFNULL(TH.THREAD_METHOD, '') THREAD_METHOD,
    IFNULL(TH.THREAD_TYPE, '') THREAD_TYPE,
    REPLACE(LTRIM(IFNULL(TH.THREAD_DETAIL, IFNULL(S.STATEMENT_STRING, ''))), CHAR(9), CHAR(32)) THREAD_DETAIL,
    LOCATE(LTRIM(UPPER(IFNULL(TH.THREAD_DETAIL, IFNULL(S.STATEMENT_STRING, '')))), 'FROM ') THREAD_DETAIL_FROM_POS,
    T.TRANSACTION_ID,
    IFNULL(T.TRANSACTION_STATUS, '') TRANSACTION_STATE,
    IFNULL(T.TRANSACTION_TYPE, '') TRANSACTION_TYPE,
    IFNULL(TH.CALLER, '') CALLER,
    T.UPDATE_TRANSACTION_ID UPD_TRANS_ID,
    CASE WHEN BT.LOCK_OWNER_UPDATE_TRANSACTION_ID IS NOT NULL THEN 'UPD_TID: ' || BT.LOCK_OWNER_UPDATE_TRANSACTION_ID || CHAR(32) ELSE '' END ||
      CASE WHEN TH.CALLING IS NOT NULL AND TH.CALLING != '' THEN 'CALLING: ' || TH.CALLING || CHAR(32) ELSE '' END ||
      CASE WHEN TH.LOCK_WAIT_NAME IS NOT NULL AND TH.LOCK_WAIT_NAME != '' THEN 'LOCK: ' || TH.LOCK_WAIT_NAME || CHAR(32) ELSE '' END ||
      CASE WHEN TH.LOCK_OWNER_THREAD_ID IS NOT NULL AND TH.LOCK_OWNER_THREAD_ID != 0 THEN 'BLOCKING THREAD: ' || TH.LOCK_OWNER_THREAD_ID || CHAR(32) ELSE '' END ||
      CASE WHEN BT.LOCK_OWNER_CONNECTION_ID IS NOT NULL THEN 'BLOCKING CONNECTION: ' || BT.LOCK_OWNER_CONNECTION_ID || CHAR(32) ELSE '' END WAITING_FOR,
    IFNULL(TO_VARCHAR(T.START_TIME, 'YYYY/MM/DD HH24:MI:SS'), '') TRANSACTION_START,
    SECONDS_BETWEEN(T.START_TIME, CURRENT_TIMESTAMP) / 86400 TRANSACTION_ACTIVE_DAYS,
    IFNULL(C.CLIENT_HOST, '') CLIENT_HOST,
    C.CLIENT_PID,
    MT.MIN_SNAPSHOT_TS,
    TA.TABLE_NAME,
    S.APPLICATION_SOURCE,
    S.STATEMENT_STRING,
    S.ALLOCATED_MEMORY_SIZE,
    SC.STATEMENT_HASH,
    TH.APPLICATION_USER_NAME,
    TH.STATEMENT_EXECUTION_ID
  FROM  
    M_CONNECTIONS C FULL OUTER JOIN
    M_SERVICE_THREADS TH ON
      TH.CONNECTION_ID = C.CONNECTION_ID AND
      TH.HOST = C.HOST AND
      TH.PORT = C.PORT FULL OUTER JOIN
    M_TRANSACTIONS T ON
      T.TRANSACTION_ID = C.TRANSACTION_ID LEFT OUTER JOIN
    M_PREPARED_STATEMENTS S ON
      C.CURRENT_STATEMENT_ID = S.STATEMENT_ID FULL OUTER JOIN
    M_SQL_PLAN_CACHE SC ON
      S.PLAN_ID = SC.PLAN_ID FULL OUTER JOIN
    M_BLOCKED_TRANSACTIONS BT ON
      TH.CONNECTION_ID = BT.BLOCKED_CONNECTION_ID LEFT OUTER JOIN
    ( SELECT
        HOST,
        PORT,
        NUM_VERSIONS,
        TABLE_ID,
        MIN_SNAPSHOT_TS,
        MIN_READ_TID,
        MIN_WRITE_TID
      FROM
      ( SELECT
          HOST,
          PORT,
          MAX(MAP(NAME, 'NUM_VERSIONS',                 VALUE, 0))            NUM_VERSIONS,
          MAX(MAP(NAME, 'TABLE_ID_OF_MAX_NUM_VERSIONS', VALUE, 0))            TABLE_ID,
          MAX(MAP(NAME, 'MIN_SNAPSHOT_TS',              TO_NUMBER(VALUE), 0)) MIN_SNAPSHOT_TS,
          MAX(MAP(NAME, 'MIN_READ_TID',                 TO_NUMBER(VALUE), 0)) MIN_READ_TID,
          MAX(MAP(NAME, 'MIN_WRITE_TID',                TO_NUMBER(VALUE), 0)) MIN_WRITE_TID
        FROM
          M_MVCC_TABLES
        GROUP BY
          HOST,
          PORT
      ) 
      WHERE
        TABLE_ID != 0
    ) MT ON
        MT.MIN_SNAPSHOT_TS = T.MIN_MVCC_SNAPSHOT_TIMESTAMP LEFT OUTER JOIN
      TABLES TA ON
        TA.TABLE_OID = MT.TABLE_ID 
) C
WHERE
  S.HOST LIKE BI.HOST AND
  TO_VARCHAR(S.PORT) LIKE BI.PORT AND
  S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
  C.HOST = S.HOST AND
  C.PORT = S.PORT AND
  ( BI.CONN_ID = -1 OR BI.CONN_ID = C.CONN_ID ) AND
  ( BI.THREAD_ID = -1 OR BI.THREAD_ID = C.THREAD_ID ) AND
  C.THREAD_STATE LIKE BI.THREAD_STATE AND
  ( BI.ONLY_ACTIVE_THREADS = ' ' OR C.THREAD_STATE NOT IN ( 'Inactive', '') ) AND
  ( BI.TRANSACTION_ID = -1 OR BI.TRANSACTION_ID = C.TRANSACTION_ID ) AND
  ( BI.CLIENT_PID = -1 OR BI.CLIENT_PID = C.CLIENT_PID ) AND
  IFNULL(C.APPLICATION_SOURCE, '') LIKE BI.APP_SOURCE AND
  IFNULL(C.APPLICATION_USER_NAME, '') LIKE BI.APP_USER AND
  ( BI.UPDATE_TRANSACTION_ID = -1 OR BI.UPDATE_TRANSACTION_ID = C.UPD_TRANS_ID ) AND
  ( BI.ONLY_ACTIVE_UPDATE_TRANSACTIONS = ' ' OR C.UPD_TRANS_ID > 0 ) AND
  ( BI.ONLY_ACTIVE_TRANSACTIONS = ' ' OR C.TRANSACTION_STATE = 'ACTIVE' ) AND
  ( BI.ONLY_ACTIVE_SQL_STATEMENTS = ' ' OR C.STATEMENT_STRING IS NOT NULL ) AND
  ( BI.ONLY_MVCC_BLOCKER = ' ' OR C.MIN_SNAPSHOT_TS IS NOT NULL )
ORDER BY
  MAP(BI.ORDER_BY, 
    'CONNECTION',         C.CONN_ID, 
    'THREAD',             C.THREAD_ID, 
    'TRANSACTION',        C.TRANSACTION_ID,
    'UPDATE_TRANSACTION', C.UPD_TRANS_ID),
  MAP(BI.ORDER_BY,
    'TRANSACTION_TIME',   C.TRANSACTION_START),
  C.CONN_ID,
  C.THREAD_ID,
  C.TRANSACTION_ID
