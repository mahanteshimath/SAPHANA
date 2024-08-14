SELECT

/* 

[NAME]

- HANA_Transactions_CurrentTransactions

[DESCRIPTION]

- Overview of current transactions

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all
- Statistics server:      all

[SQL COMMAND VERSION]

- 2018/04/25:  1.0 (initial version)
- 2018/12/04:  1.1 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2020/01/14:  1.2 (ONLY_UPDATE_TRANSACTIONS included)
- 2020/04/07:  1.3 (MIN_ACTIVE_S included)
- 2020/09/15:  1.4 (INCLUDE_EMPTY_START_TIMES and CREATED_BY included)
- 2021/07/27:  1.5 (ISOLATION_LEVEL added)
- 2023/03/30:  1.6 (record locks included)

[INVOLVED TABLES]

- M_TRANSACTIONS

[INPUT PARAMETERS]

- BEGIN_TIME

  Begin time

  '2018/12/05 14:05:00' --> Set begin time to 5th of December 2018, 14:05
  'C'                   --> Set begin time to current time
  'C-S900'              --> Set begin time to current time minus 900 seconds
  'C-M15'               --> Set begin time to current time minus 15 minutes
  'C-H5'                --> Set begin time to current time minus 5 hours
  'C-D1'                --> Set begin time to current time minus 1 day
  'C-W4'                --> Set begin time to current time minus 4 weeks
  'E-S900'              --> Set begin time to end time minus 900 seconds
  'E-M15'               --> Set begin time to end time minus 15 minutes
  'E-H5'                --> Set begin time to end time minus 5 hours
  'E-D1'                --> Set begin time to end time minus 1 day
  'E-W4'                --> Set begin time to end time minus 4 weeks
  'MIN'                 --> Set begin time to minimum (1000/01/01 00:00:00)

- END_TIME

  End time

  '2018/12/08 14:05:00' --> Set end time to 8th of December 2018, 14:05
  'C'                   --> Set end time to current time
  'C-S900'              --> Set end time to current time minus 900 seconds
  'C-M15'               --> Set end time to current time minus 15 minutes
  'C-H5'                --> Set end time to current time minus 5 hours
  'C-D1'                --> Set end time to current time minus 1 day
  'C-W4'                --> Set end time to current time minus 4 weeks
  'B+S900'              --> Set end time to begin time plus 900 seconds
  'B+M15'               --> Set end time to begin time plus 15 minutes
  'B+H5'                --> Set end time to begin time plus 5 hours
  'B+D1'                --> Set end time to begin time plus 1 day
  'B+W4'                --> Set end time to begin time plus 4 weeks
  'MAX'                 --> Set end time to maximum (9999/12/31 23:59:59)

- TIMEZONE

  Used timezone (both for input and output parameters)

  'SERVER'       --> Display times in SAP HANA server time
  'UTC'          --> Display times in UTC time

- INCLUDE_EMPTY_START_TIMES

  Possibility to include also transactions with empty start time

  'X'             --> Display also transactions with empty start time
  ' '             --> Only consider transactions with start time begin between BEGIN_TIME and END_TIME

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

- TRANSACTION_ID

  Transaction identifier

  123             --> Transaction identifier 123
  -1              --> No restriction to specific transaction identifiers

- UPDATE_TRANSACTION_ID

  Update transaction identifier (used for DML operations)

  123456          --> Update transaction identifier 123456
  -1              --> No restriction to specific update transaction identifier

- CONN_ID

  Connection ID

  330655          --> Connection ID 330655
  -1              --> No connection ID restriction

- ONLY_UPDATE_TRANSACTIONS

  Possibility to restrict output to update transactions (having executed a modification command)

  'X'             --> Display only update transactions
  ' '             --> No restriction related to update transactions

- CREATED_BY

  Context of creation of related connection (if not -1)

  'DataProvisioning' --> Show transactions with connections created in context of DataProvisioning
  '%'                --> No restriction related to connection creation context

- MIN_ACTIVE_S

  Minimum threshold for transaction active time (s)

  3600            --> Only display transactions being active since at least 3600 seconds
  -1              --> No restriction related to transaction active time

- MIN_RECORD_LOCKS

  Minimum number of record locks

  10000000        --> Report transactions with at least 10 million record locks
  -1              --> No restriction related to number of record locks

- TRANSACTION_STATUS

  Status of transaction

  'ACTIVE'        --> Only active transactions
  'X'             --> All transactions

- TRANSACTION_TYPE

  Transaction type

  'INTERNAL TRANSACTION' --> Only display internal transactions
  '%GARBAGE%'            --> Only display transactions with type containing 'GARBAGE'
  '%'                    --> No restriction related to transaction type

- ISOLATION_LEVEL

  Transaction isolation level

  'SERIALIZABLE' --> Only display transactions with isolation level SERIALIZABLE
  '%'            --> No restriction related to transaction isolation level

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'          --> Aggregation by time
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation
  
- ORDER_BY

  Sort criteria (available values are provided in comment)

  'TIME'          --> Sorting by start time 
  'COUNT'         --> Sorting by number of transactions

[OUTPUT PARAMETERS]

- START_TIME:   Transaction start time
- HOST:         Host name
- PORT:         Port
- CONN_ID:      Connection ID
- CREATED_BY:   Context of connection creation (if available)
- S:            Transaction status (A -> ACTIVE, AB -> ABORTING, AP -> ACTIVE PREPARE_COMMIT, I -> INACTIVE, P -> PRECOMMITTED, PA -> PARTIAL_ABORTING)
- T:            Transaction type (DG -> DDL version garbage collection, E -> external transaction, I -> internal transaction, L -> lock waiting
                S -> subtransaction, U -> user transaction, VG -> version garbage collection)
- I:            Transaction isolation level (C -> READ COMMITTED, R -> REPEATABLE READ, S -> SERIALIZABLE, U -> READ UNCOMMITTED)
- TRANS_ID:     Transaction ID
- UTID:         Update transaction ID
- RECORD_LOCKS: Number of acquired record locks
- COUNT:        Number of transactions

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------
|START_TIME      |HOST|PORT |CONN_ID     |S|T |TRANS_ID|UTID            |COUNT|
-------------------------------------------------------------------------------
|2018/04/25 (WED)|any |  any|         any|A|I |     any|             any|    1|
|2018/04/25 (WED)|any |  any|         any|I|U |     any|             any| 1082|
|2018/04/25 (WED)|any |  any|         any|I|E |     any|             any|23440|
|2018/04/25 (WED)|any |  any|         any|I|I |     any|             any|  142|
|2018/04/25 (WED)|any |  any|         any|A|U |     any|             any| 1065|
|2018/04/25 (WED)|any |  any|         any|A|E |     any|             any| 2049|
|2018/04/25 (WED)|any |  any|         any|I|DG|     any|             any|    5|
|2018/04/24 (TUE)|any |  any|         any|I|DG|     any|             any|    2|
|2018/04/24 (TUE)|any |  any|         any|A|U |     any|             any|  238|
|2018/04/24 (TUE)|any |  any|         any|A|E |     any|             any| 3344|
|2018/04/24 (TUE)|any |  any|         any|I|I |     any|             any|   43|
|2018/04/24 (TUE)|any |  any|         any|I|E |     any|             any|   11|
|2018/04/24 (TUE)|any |  any|         any|I|U |     any|             any|  330|
-------------------------------------------------------------------------------

*/

  START_TIME,
  HOST,
  LPAD(PORT, 5) PORT,
  LPAD(CONN_ID, 12) CONN_ID,
  CREATED_BY,
  MAP(TRANSACTION_STATUS, 'ACTIVE', 'A', 'ABORTING', 'AB', 'ACTIVE PREPARE_COMMIT', 'AP', 'INACTIVE', 'I', 'PRECOMMITTED', 'P', 'PARTIAL_ABORTING', 'PA', TRANSACTION_STATUS) S,
  MAP(TRANSACTION_TYPE, 'DDL VERSION GARBAGE COLLECTION TRANSACTION', 'DG', 'EXTERNAL TRANSACTION', 'E', 'INTERNAL TRANSACTION', 'I', 'LOCK_WAITING', 'L',
    'SUBTRANSACTION', 'S', 'USER TRANSACTION', 'U', 'VERSION GARBAGE COLLECTION TRANSACTION', 'VG', TRANSACTION_TYPE) T,
  MAP(ISOLATION_LEVEL, 'READ COMMITTED', 'C', 'REPEATABLE READ', 'R', 'SERIALIZABLE', 'S', 'READ UNCOMMITTED', 'U') I,
  LPAD(TRANS_ID, 8) TRANS_ID,
  LPAD(UTID, 16) UTID,
  LPAD(RECORD_LOCKS, 12) RECORD_LOCKS,
  LPAD(NUM_TRANSACTIONS, 5) COUNT
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.START_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END START_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')            != 0 THEN T.HOST                              ELSE MAP(BI.HOST,                  '%', 'any', BI.HOST)                              END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')            != 0 THEN TO_VARCHAR(T.PORT)                  ELSE MAP(BI.PORT,                  '%', 'any', BI.PORT)                              END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONN_ID')         != 0 THEN TO_VARCHAR(T.CONNECTION_ID)         ELSE MAP(BI.CONN_ID,                -1, 'any', TO_VARCHAR(BI.CONN_ID))               END CONN_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TRANS_ID')        != 0 THEN TO_VARCHAR(T.TRANSACTION_ID)        ELSE MAP(BI.TRANSACTION_ID,         -1, 'any', TO_VARCHAR(BI.TRANSACTION_ID))        END TRANS_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'UTID')            != 0 THEN TO_VARCHAR(T.UPDATE_TRANSACTION_ID) ELSE MAP(BI.UPDATE_TRANSACTION_ID,  -1, 'any', TO_VARCHAR(BI.UPDATE_TRANSACTION_ID)) END UTID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATUS')          != 0 THEN T.TRANSACTION_STATUS                ELSE MAP(BI.TRANSACTION_STATUS,    '%', 'any', BI.TRANSACTION_STATUS)                END TRANSACTION_STATUS,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TYPE')            != 0 THEN T.TRANSACTION_TYPE                  ELSE MAP(BI.TRANSACTION_TYPE,      '%', 'any', BI.TRANSACTION_TYPE)                  END TRANSACTION_TYPE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ISOLATION_LEVEL') != 0 THEN T.ISOLATION_LEVEL                   ELSE MAP(BI.ISOLATION_LEVEL,       '%', 'any', BI.ISOLATION_LEVEL)                   END ISOLATION_LEVEL,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CREATED_BY')      != 0 THEN IFNULL(T.CREATED_BY, '')            ELSE MAP(BI.CREATED_BY,            '%', 'any', BI.CREATED_BY)                        END CREATED_BY,
    COUNT(*) NUM_TRANSACTIONS,
    SUM(T.ACQUIRED_LOCK_COUNT) RECORD_LOCKS,
    BI.ORDER_BY
  FROM
  ( SELECT
      CASE
        WHEN BEGIN_TIME =    'C'                             THEN CURRENT_TIMESTAMP
        WHEN BEGIN_TIME LIKE 'C-S%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-S'))
        WHEN BEGIN_TIME LIKE 'C-M%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-M') * 60)
        WHEN BEGIN_TIME LIKE 'C-H%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-H') * 3600)
        WHEN BEGIN_TIME LIKE 'C-D%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-D') * 86400)
        WHEN BEGIN_TIME LIKE 'C-W%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-W') * 86400 * 7)
        WHEN BEGIN_TIME LIKE 'E-S%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-S'))
        WHEN BEGIN_TIME LIKE 'E-M%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-M') * 60)
        WHEN BEGIN_TIME LIKE 'E-H%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-H') * 3600)
        WHEN BEGIN_TIME LIKE 'E-D%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-D') * 86400)
        WHEN BEGIN_TIME LIKE 'E-W%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-W') * 86400 * 7)
        WHEN BEGIN_TIME =    'MIN'                           THEN TO_TIMESTAMP('1000/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS')
        WHEN SUBSTR(BEGIN_TIME, 1, 1) NOT IN ('C', 'E', 'M') THEN TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS')
      END BEGIN_TIME,
      CASE
        WHEN END_TIME =    'C'                             THEN CURRENT_TIMESTAMP
        WHEN END_TIME LIKE 'C-S%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-S'))
        WHEN END_TIME LIKE 'C-M%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-M') * 60)
        WHEN END_TIME LIKE 'C-H%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-H') * 3600)
        WHEN END_TIME LIKE 'C-D%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-D') * 86400)
        WHEN END_TIME LIKE 'C-W%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-W') * 86400 * 7)
        WHEN END_TIME LIKE 'B+S%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+S'))
        WHEN END_TIME LIKE 'B+M%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+M') * 60)
        WHEN END_TIME LIKE 'B+H%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+H') * 3600)
        WHEN END_TIME LIKE 'B+D%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+D') * 86400)
        WHEN END_TIME LIKE 'B+W%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+W') * 86400 * 7)
        WHEN END_TIME =    'MAX'                           THEN TO_TIMESTAMP('9999/12/31 00:00:00', 'YYYY/MM/DD HH24:MI:SS')
        WHEN SUBSTR(END_TIME, 1, 1) NOT IN ('C', 'B', 'M') THEN TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS')
      END END_TIME,
      TIMEZONE,
      INCLUDE_EMPTY_START_TIMES,
      HOST,
      PORT,
      TRANSACTION_ID,
      UPDATE_TRANSACTION_ID,
      CONN_ID,
      ONLY_UPDATE_TRANSACTIONS,
      CREATED_BY,
      MIN_ACTIVE_S,
      MIN_RECORD_LOCKS,
      TRANSACTION_STATUS,
      TRANSACTION_TYPE,
      ISOLATION_LEVEL,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS',
        'HOUR',        'YYYY/MM/DD HH24',
        'DAY',         'YYYY/MM/DD (DY)',
        'HOUR_OF_DAY', 'HH24',
        TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
      ORDER_BY
    FROM
    ( SELECT                 /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        'SERVER' TIMEZONE,                              /* SERVER, UTC */
        'X' INCLUDE_EMPTY_START_TIMES,
        '%' HOST,
        '%' PORT,
        -1 TRANSACTION_ID,
        -1 UPDATE_TRANSACTION_ID,
        -1 CONN_ID,
        ' ' ONLY_UPDATE_TRANSACTIONS,
        '%' CREATED_BY,
        -1 MIN_ACTIVE_S,
        1 MIN_RECORD_LOCKS,
        '%' TRANSACTION_STATUS,            /* ACTIVE, INACTIVE */
        '%' TRANSACTION_TYPE,               /* EXTERNAL TRANSACTION, INTERNAL TRANSACTION, USER TRANSACTION, ... */
        '%' ISOLATION_LEVEL,                /* READ COMMITTED, SERIALIZABLE, ... */
        'NONE' AGGREGATE_BY,           /* TIME, HOST, PORT, TRANS_ID, UTID, CONN_ID, STATUS, TYPE, ISOLATION_LEVEL, CREATED_BY or comma separated combinations, NULL for no aggregation */
        'NONE' TIME_AGGREGATE_BY,       /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'LOCKS' ORDER_BY               /* TIME, COUNT, TRANS_ID, LOCKS */
      FROM
        DUMMY
    )
  ) BI,
  ( SELECT
      T.*,
      ( SELECT MAX(C.CREATED_BY) FROM M_CONNECTIONS C WHERE C.HOST = T.HOST AND C.CONNECTION_ID = T.CONNECTION_ID ) CREATED_BY
    FROM
      M_TRANSACTIONS T
  ) T
  WHERE
    ( CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.START_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME OR
      BI.INCLUDE_EMPTY_START_TIMES = 'X' AND T.START_TIME IS NULL
    ) AND
    T.HOST LIKE BI.HOST AND
    TO_VARCHAR(T.PORT) LIKE BI.PORT AND
    ( BI.TRANSACTION_ID = -1 OR T.TRANSACTION_ID = BI.TRANSACTION_ID ) AND
    ( BI.UPDATE_TRANSACTION_ID = -1 OR T.UPDATE_TRANSACTION_ID = BI.UPDATE_TRANSACTION_ID ) AND
    ( BI.MIN_ACTIVE_S = -1 OR SECONDS_BETWEEN(T.START_TIME, CURRENT_TIMESTAMP) >= BI.MIN_ACTIVE_S ) AND
    ( BI.MIN_RECORD_LOCKS = -1 OR T.ACQUIRED_LOCK_COUNT > BI.MIN_RECORD_LOCKS ) AND
    ( BI.ONLY_UPDATE_TRANSACTIONS = ' ' OR T.UPDATE_TRANSACTION_ID != 0 ) AND
    ( BI.CONN_ID = -1 OR T.CONNECTION_ID = BI.CONN_ID ) AND
    IFNULL(T.CREATED_BY, '') LIKE BI.CREATED_BY AND
    T.TRANSACTION_STATUS LIKE BI.TRANSACTION_STATUS AND
    T.TRANSACTION_TYPE LIKE BI.TRANSACTION_TYPE AND
    T.ISOLATION_LEVEL LIKE BI.ISOLATION_LEVEL
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.START_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.START_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')            != 0 THEN T.HOST                              ELSE MAP(BI.HOST,                  '%', 'any', BI.HOST)                              END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')            != 0 THEN TO_VARCHAR(T.PORT)                  ELSE MAP(BI.PORT,                  '%', 'any', BI.PORT)                              END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONN_ID')         != 0 THEN TO_VARCHAR(T.CONNECTION_ID)         ELSE MAP(BI.CONN_ID,                -1, 'any', TO_VARCHAR(BI.CONN_ID))               END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TRANS_ID')        != 0 THEN TO_VARCHAR(T.TRANSACTION_ID)        ELSE MAP(BI.TRANSACTION_ID,         -1, 'any', TO_VARCHAR(BI.TRANSACTION_ID))        END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'UTID')            != 0 THEN TO_VARCHAR(T.UPDATE_TRANSACTION_ID) ELSE MAP(BI.UPDATE_TRANSACTION_ID,  -1, 'any', TO_VARCHAR(BI.UPDATE_TRANSACTION_ID)) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATUS')          != 0 THEN T.TRANSACTION_STATUS                ELSE MAP(BI.TRANSACTION_STATUS,    '%', 'any', BI.TRANSACTION_STATUS)                END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TYPE')            != 0 THEN T.TRANSACTION_TYPE                  ELSE MAP(BI.TRANSACTION_TYPE,      '%', 'any', BI.TRANSACTION_TYPE)                  END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ISOLATION_LEVEL') != 0 THEN T.ISOLATION_LEVEL                   ELSE MAP(BI.ISOLATION_LEVEL,       '%', 'any', BI.ISOLATION_LEVEL)                   END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CREATED_BY')      != 0 THEN IFNULL(T.CREATED_BY, '')            ELSE MAP(BI.CREATED_BY,            '%', 'any', BI.CREATED_BY)                        END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'TIME', START_TIME) DESC,
  MAP(ORDER_BY, 'TRANS_ID', TRANS_ID),
  MAP(ORDER_BY, 'COUNT', NUM_TRANSACTIONS) DESC,
  MAP(ORDER_BY, 'LOCKS', RECORD_LOCKS) DESC
