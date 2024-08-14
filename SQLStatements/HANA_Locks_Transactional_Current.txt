SELECT
/* 

[NAME]

- HANA_Locks_Transactional_Current

[DESCRIPTION]

- Show current transactional locks (record and object locks)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- All locks are shown, not only blocking locks

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/04/05:  1.0 (initial version)
- 2015/07/20:  1.1 (TRANSACTION_ID included)
- 2016/04/30:  1.2 (AGGREGATE_BY included)
- 2017/10/25:  1.3 (TIMEZONE included)

[INVOLVED TABLES]

- M_OBJECT_LOCKS
- M_RECORD_LOCKS

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

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- OBJECT_NAME

  Object name

  'EDIDC'         --> Specific object name EDIDC
  'A%'            --> All objects starting with 'A'
  '%'             --> All objects

- OBJECT_TYPE

  Type of object (e.g. 'TABLE', 'SYNONYM', 'VIEW' or 'INDEX')

  'TABLE'         --> Specific object type TABLE
  '%'             --> All object types

- TRANSACTION_ID

  Transaction identifier

  123             --> Transaction identifier 123
  -1              --> No restriction to specific transaction identifiers

- UPDATE_TRANSACTION_ID

  Update transaction identifier (used for DML operations)

  123456          --> Update transaction identifier 123456
  -1              --> No restriction to specific update transaction identifier

- RECORD_ID

  Internal identifier of locked record

  'SID=0x0000176E, OFFSET=0x1658100' --> Record with identifier SID=0x0000176E, OFFSET=0x1658100
  '%'                                --> No restriction related to record identifier

- LOCK_TYPE

  Lock type

  'RECORD'        --> Row level lock
  'OBJECT'        --> Object level lock
  '%'             --> All lock types

- LOCK_MODE:

  Lock mode

  'EXCLUSIVE'     --> Only show EXCLUSIVE locks
  '%'             --> No restriction related to lock mode

- MIN_LOCK_TIME_S

  Minimum lock duration time in seconds

  100             --> Minimum lock duration time of 100 s
  -1              --> No restriction of minimum duration time

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'OBJECT'        --> Aggregation by object
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'LOCK_TIME'     --> Sorting by time lock is already held
  'OBJECT'        --> Sorting by object name
  
[OUTPUT PARAMETERS]

- HOST:                Host name
- PORT:                Port
- SERVICE:             Service name
- OBJECT_TYPE:         Object type
- OBJECT_NAME:         Object name
- LOCK_TYPE:           Lock type (RECORD for row level lock, OBJECT for object level lock)
- LOCK_MODE:           Lock mode
- LOCKING_TID:         Transaction ID responsible for lock
- LOCKING_UTID:        Update transaction ID responsible for lock
- NUM_LOCKS:           Number of locks
- MAX_LOCK_S:          Max. lock duration
- AVG_LOCK_S:          Avg. lock duration

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST|PORT |SERVICE|SCHEMA_NAME|OBJECT_TYPE|OBJECT_NAME  |LOCK_TYPE|LOCK_MODE|LOCKING_TID|LOCKING_UTID|NUM_LOCKS|MIN_LOCK_START_TIME|AVG_LOCK_DURATION_S|
---------------------------------------------------------------------------------------------------------------------------------------------------------
|any |  any|any    |any        |any        |USH10        |any      |any      |        any|         any|        2|2016/04/30 17:29:24|               0.00|
|any |  any|any    |any        |any        |USR10        |any      |any      |        any|         any|        2|2016/04/30 17:29:24|               0.00|
|any |  any|any    |any        |any        |TBOTI        |any      |any      |        any|         any|        1|2016/04/09 00:20:09|         1876154.00|
|any |  any|any    |any        |any        |UKMBP_CMS_SGM|any      |any      |        any|         any|        1|2016/04/30 17:29:26|               0.00|
|any |  any|any    |any        |any        |UKMCASEATTR00|any      |any      |        any|         any|        1|2016/04/30 17:29:26|               0.00|
---------------------------------------------------------------------------------------------------------------------------------------------------------

*/
  HOST,
  LPAD(PORT, 5) PORT,
  SERVICE_NAME SERVICE,
  SCHEMA_NAME,
  OBJECT_TYPE,
  OBJECT_NAME,
  LOCK_TYPE,
  LOCK_MODE,
  LPAD(LOCKING_TID, 11) LOCKING_TID,
  LPAD(LOCKING_UTID, 12) LOCKING_UTID,
  LPAD(NUM_LOCKS, 9) NUM_LOCKS,
  LPAD(TO_DECIMAL(ROUND(GREATEST(0, MAX_LOCK_DURATION_S)), 10, 0), 10) MAX_LOCK_S,
  LPAD(TO_DECIMAL(ROUND(GREATEST(0, AVG_LOCK_DURATION_S)), 10, 0), 10) AVG_LOCK_S
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')           != 0 THEN L.HOST                                      ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                                           END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')           != 0 THEN TO_VARCHAR(L.PORT)                             ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                                           END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE')        != 0 THEN S.SERVICE_NAME                              ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME)                           END SERVICE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')         != 0 THEN L.SCHEMA_NAME                               ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)                             END SCHEMA_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'OBJECT')         != 0 THEN L.OBJECT_NAME                               ELSE MAP(BI.OBJECT_NAME, '%', 'any', BI.OBJECT_NAME)                             END OBJECT_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TYPE')           != 0 THEN L.OBJECT_TYPE                               ELSE MAP(BI.OBJECT_TYPE, '%', 'any', BI.OBJECT_TYPE)                             END OBJECT_TYPE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'RECORD_ID')      != 0 THEN TO_VARCHAR(L.RECORD_ID)                        ELSE MAP(BI.RECORD_ID, -1, 'any', TO_VARCHAR(BI.RECORD_ID))                         END RECORD_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TRANSACTION_ID') != 0 THEN TO_VARCHAR(L.LOCK_OWNER_TRANSACTION_ID)        ELSE MAP(BI.TRANSACTION_ID, -1, 'any', TO_VARCHAR(BI.TRANSACTION_ID))               END LOCKING_TID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'UPD_TRANS_ID')   != 0 THEN TO_VARCHAR(L.LOCK_OWNER_UPDATE_TRANSACTION_ID) ELSE MAP(BI.UPDATE_TRANSACTION_ID, -1, 'any', TO_VARCHAR(BI.UPDATE_TRANSACTION_ID)) END LOCKING_UTID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'LOCK_MODE')      != 0 THEN L.LOCK_MODE                                 ELSE MAP(BI.LOCK_MODE, '%', 'any', BI.LOCK_MODE)                                 END LOCK_MODE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'LOCK_TYPE')      != 0 THEN L.LOCK_TYPE                                 ELSE MAP(BI.LOCK_TYPE, '%', 'any', BI.LOCK_TYPE)                                 END LOCK_TYPE,
    COUNT(*) NUM_LOCKS,
    MIN(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.ACQUIRED_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.ACQUIRED_TIME END) MIN_LOCK_START_TIME,
    AVG(SECONDS_BETWEEN(L.ACQUIRED_TIME, CURRENT_TIMESTAMP)) AVG_LOCK_DURATION_S,
    MAX(SECONDS_BETWEEN(L.ACQUIRED_TIME, CURRENT_TIMESTAMP)) MAX_LOCK_DURATION_S,
    BI.ORDER_BY
  FROM
  ( SELECT                        /* Modification section */
      'SERVER' TIMEZONE,                              /* SERVER, UTC */
      '%' HOST,
      '%' PORT,
      '%' SERVICE_NAME,
      '%' SCHEMA_NAME,
      '%' OBJECT_NAME,
      '%' OBJECT_TYPE,
      -1 TRANSACTION_ID,
      -1 UPDATE_TRANSACTION_ID,
      -1 RECORD_ID,
      '%' LOCK_TYPE,                /* OBJECT, RECORD */
      '%' LOCK_MODE,                /* EXCLUSIVE, INTENTIONAL EXCLUSIVE */
      86400 MIN_LOCK_TIME_S,
      'NONE' AGGREGATE_BY,      /* HOST, PORT, SCHEMA, OBJECT, TYPE, TRANSACTION_ID, UPD_TRANS_ID, RECORD_ID, LOCK_MODE, LOCK_TYPE or comma separated combinations, NONE for no aggregation */
      'NUM' ORDER_BY          /* NUM, LOCK_TIME, OBJECT */
    FROM
      DUMMY
  ) BI,
    M_SERVICES S,
  ( SELECT
      HOST,
      PORT,
      SCHEMA_NAME,
      OBJECT_NAME,
      OBJECT_TYPE,
      LOCK_OWNER_TRANSACTION_ID,
      LOCK_OWNER_UPDATE_TRANSACTION_ID,
      LOCK_MODE,
      ACQUIRED_TIME,
      '' RECORD_ID,
      'OBJECT' LOCK_TYPE
    FROM
      M_OBJECT_LOCKS
    UNION ALL
    ( SELECT
        HOST,
        PORT,
        SCHEMA_NAME,
        TABLE_NAME OBJECT_NAME,
        'TABLE' OBJECT_TYPE,
        LOCK_OWNER_TRANSACTION_ID,
        LOCK_OWNER_UPDATE_TRANSACTION_ID,
        LOCK_MODE,
        ACQUIRED_TIME,
        RECORD_ID,
        'RECORD' LOCK_TYPE
      FROM
        M_RECORD_LOCKS
    )
  ) L
  WHERE
    S.HOST LIKE BI.HOST AND
    TO_VARCHAR(S.PORT) LIKE BI.PORT AND
    S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
    L.HOST = S.HOST AND
    L.PORT = S.PORT AND
    L.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    L.OBJECT_NAME LIKE BI.OBJECT_NAME AND
    L.OBJECT_TYPE LIKE BI.OBJECT_TYPE AND
    L.LOCK_TYPE LIKE BI.LOCK_TYPE AND
    ( BI.TRANSACTION_ID = -1 OR L.LOCK_OWNER_TRANSACTION_ID = BI.TRANSACTION_ID ) AND
    ( MIN_LOCK_TIME_S = -1 OR SECONDS_BETWEEN(L.ACQUIRED_TIME, CURRENT_TIMESTAMP) >= BI.MIN_LOCK_TIME_S )
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')           != 0 THEN L.HOST                                      ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                                           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')           != 0 THEN TO_VARCHAR(L.PORT)                             ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                                           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE')        != 0 THEN S.SERVICE_NAME                              ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME)                           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')         != 0 THEN L.SCHEMA_NAME                               ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)                             END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'OBJECT')         != 0 THEN L.OBJECT_NAME                               ELSE MAP(BI.OBJECT_NAME, '%', 'any', BI.OBJECT_NAME)                             END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TYPE')           != 0 THEN L.OBJECT_TYPE                               ELSE MAP(BI.OBJECT_TYPE, '%', 'any', BI.OBJECT_TYPE)                             END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'RECORD_ID')      != 0 THEN TO_VARCHAR(L.RECORD_ID)                        ELSE MAP(BI.RECORD_ID, -1, 'any', TO_VARCHAR(BI.RECORD_ID))                         END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TRANSACTION_ID') != 0 THEN TO_VARCHAR(L.LOCK_OWNER_TRANSACTION_ID)        ELSE MAP(BI.TRANSACTION_ID, -1, 'any', TO_VARCHAR(BI.TRANSACTION_ID))               END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'UPD_TRANS_ID')   != 0 THEN TO_VARCHAR(L.LOCK_OWNER_UPDATE_TRANSACTION_ID) ELSE MAP(BI.UPDATE_TRANSACTION_ID, -1, 'any', TO_VARCHAR(BI.UPDATE_TRANSACTION_ID)) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'LOCK_MODE')      != 0 THEN L.LOCK_MODE                                 ELSE MAP(BI.LOCK_MODE, '%', 'any', BI.LOCK_MODE)                                 END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'LOCK_TYPE')      != 0 THEN L.LOCK_TYPE                                 ELSE MAP(BI.LOCK_TYPE, '%', 'any', BI.LOCK_TYPE)                                 END,
    BI.ORDER_BY
) S
ORDER BY
  MAP(ORDER_BY, 'LOCK_TIME', MIN_LOCK_START_TIME),
  MAP(ORDER_BY, 'NUM', S.NUM_LOCKS) DESC,
  OBJECT_NAME
    