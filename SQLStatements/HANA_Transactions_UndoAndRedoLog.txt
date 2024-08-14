SELECT
/* 

[NAME]

- HANA_Transactions_UndoAndRedoLog

[DESCRIPTION]

- Undo and redo log consumption of current transactions

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/12/17:  1.0 (initial version)

[INVOLVED TABLES]

- M_TRANSACTIONS

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

- CONN_ID

  Connection ID

  330655          --> Connection ID 330655
  -1              --> No connection ID restriction

- TRANSACTION_ID

  Transaction identifier

  123             --> Transaction identifier 123
  -1              --> No restriction to specific transaction identifiers

- MIN_UNDO_LOG_MB

  Minimum undo log size (MB)

  10              --> Only display transactions with at least 10 MB of undo log
  -1              --> No restriction related to undo log size  

- MIN_REDO_LOG_MB

  Minimum redo log size (MB)

  10              --> Only display transactions with at least 10 MB of redo log
  -1              --> No restriction related to redo log size  

[OUTPUT PARAMETERS]

- HOST:    Host
- PORT:    Port
- SERVICE: Service name
- CONN_ID: Connection ID
- TID:     Transaction ID
- UTID:    Update transaction ID
- UNDO_MB: Undo log size (MB)
- REDO_MB: Redo log size (MB)

[EXAMPLE OUTPUT]

---------------------------------------------------------------
|HOST  |PORT |CONN_ID|TID    |UTID      |UNDO_MB   |REDO_MB   |
---------------------------------------------------------------
|hana01|33303| 340962|   5790|1634003806|      0.01|      0.46|
|hana01|33303| 341995|   2782|1634003439|      0.02|      0.31|
|hana01|33303| 362688|   2841|1634003829|      0.01|      0.01|
|hana01|33303| 335310|   6868|1634003749|      0.00|      0.00|
---------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  SERVICE_NAME SERVICE,
  LPAD(CONNECTION_ID, 7) CONN_ID,
  LPAD(TRANSACTION_ID, 7) TID,
  LPAD(UPDATE_TRANSACTION_ID, 10) UTID,
  LPAD(TO_DECIMAL(UNDO_LOG_AMOUNT / 1024 / 1024, 10, 2), 10) UNDO_MB,
  LPAD(TO_DECIMAL(REDO_LOG_AMOUNT / 1024 / 1024, 10, 2), 10) REDO_MB
FROM
( SELECT
    T.HOST,
    T.PORT,
    S.SERVICE_NAME,
    T.CONNECTION_ID,
    T.TRANSACTION_ID,
    T.UPDATE_TRANSACTION_ID,
    T.UNDO_LOG_AMOUNT,
    T.REDO_LOG_AMOUNT
  FROM
  ( SELECT                /* Modification section */
      '%' HOST,
      '%' PORT,
      '%' SERVICE_NAME,
      -1 CONN_ID,
      -1 TRANSACTION_ID,
      0.001 MIN_UNDO_LOG_MB,
      -1 MIN_REDO_LOG_MB
    FROM
      DUMMY
  ) BI,
    M_SERVICES S,
    M_TRANSACTIONS T
  WHERE
    S.HOST LIKE BI.HOST AND
    TO_VARCHAR(S.PORT) LIKE BI.PORT AND
    S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
    T.HOST = S.HOST AND
    T.PORT = S.PORT AND
    ( BI.CONN_ID = -1 OR T.CONNECTION_ID = BI.CONN_ID ) AND
    ( BI.TRANSACTION_ID = -1 OR T.TRANSACTION_ID = BI.TRANSACTION_ID ) AND
    ( BI.MIN_UNDO_LOG_MB = -1 OR T.UNDO_LOG_AMOUNT / 1024 / 1024 >= BI.MIN_UNDO_LOG_MB ) AND
    ( BI.MIN_REDO_LOG_MB = -1 OR T.REDO_LOG_AMOUNT / 1024 / 1024 >= BI.MIN_REDO_LOG_MB )
)
ORDER BY
  UNDO_LOG_AMOUNT + REDO_LOG_AMOUNT DESC