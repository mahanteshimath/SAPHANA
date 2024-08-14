SELECT
/* 

[NAME]

- HANA_Locks_Transactional_LockWaits_PerObject

[DESCRIPTION]

- Show summarized transactional locks since startup (object and record locks)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/04/05:  1.0 (initial version)

[INVOLVED TABLES]

- M_OBJECT_LOCK_STATISTICS

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

- LOCK_TYPE

  Lock type

  'RECORD'        --> Row level lock
  'OBJECT'        --> Object level lock
  '%'             --> All lock types

- ONLY_LOCK_FAILURES

  Allows the restriction to lock failures

  'X'             --> Only locks with lock failures are displayed
  ' '             --> No restriction to lock failures

- MIN_LOCK_WAIT_TIME_S

  Minimum lock duration time in seconds

  100             --> Minimum lock duration time of 100 s
  -1              --> No restriction of minimum duration time

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'LOCK_TIME'     --> Sorting by time lock is already held
  'OBJECT'        --> Sorting by object name
  
[OUTPUT PARAMETERS]

- HOST:            Host name
- PORT:            Port
- SERVICE:         Service name
- OBJECT_TYPE:     Object type
- SCHEMA_NAME:     Schema name
- OBJECT_NAME:     Object name
- LOCK_TYPE:       Lock type (RECORD for row level lock, OBJECT for object level lock)
- LOCK_WAITS:      Number of lock waits
- TOTAL_TIME_S:    Total lock wait time (in s)
- AVG_TIME_S:      Average time per lock wait (in s)
- LOCK_FAILURES:   Number of lock failures

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------
|HOST     |SERVICE_NAME    |OBJECT_TYPE|OBJECT_NAME                            |LOCK_TYPE|LOCK_WAITS|TOTAL_TIME_S|AVG_TIME_S|LOCK_FAILURES|
-------------------------------------------------------------------------------------------------------------------------------------------
|saphana20|indexserver     |TABLE      |S009                                   |RECORD   |     96486|      112662|      1.16|            0|
|saphana20|indexserver     |TABLE      |ADMI_STATS                             |RECORD   |   1073604|      100276|      0.09|            0|
|saphana20|indexserver     |TABLE      |EINE                                   |RECORD   |      6016|       91449|     15.20|          107|
|saphana20|indexserver     |TABLE      |ZENTSD                                 |RECORD   |       444|       61841|    139.28|           19|
|saphana20|indexserver     |TABLE      |NRIV_LOKAL                             |RECORD   |    202527|       51789|      0.25|            1|
|saphana20|indexserver     |TABLE      |NRIV                                   |RECORD   |    109600|       38123|      0.34|            0|
|saphana20|indexserver     |TABLE      |REPOSRC                                |RECORD   |        74|       21914|    296.13|            7|
|saphana20|indexserver     |TABLE      |ZINDX01                                |RECORD   |      1336|       11673|      8.73|            0|
|saphana20|indexserver     |TABLE      |MVER                                   |RECORD   |       278|        9343|     33.60|            0|
|saphana20|indexserver     |TABLE      |USR02                                  |RECORD   |      1649|        9173|      5.56|            0|
-------------------------------------------------------------------------------------------------------------------------------------------

*/
  HOST,
  LPAD(PORT, 5) PORT,
  SERVICE_NAME SERVICE,
  OBJECT_TYPE,
  SCHEMA_NAME,
  OBJECT_NAME,
  LOCK_TYPE,
  LPAD(LOCK_WAITS, 10) LOCK_WAITS,
  LPAD(TO_DECIMAL(ROUND(LOCK_WAIT_TIME_S), 12, 0), 12) TOTAL_TIME_S,
  LPAD(TO_DECIMAL(MAP(LOCK_WAITS, 0, 0, LOCK_WAIT_TIME_S / LOCK_WAITS), 10, 2), 10) AVG_TIME_S,
  LPAD(LOCK_FAILURES, 13) LOCK_FAILURES
FROM
( SELECT
    L.HOST,
    L.PORT,
    S.SERVICE_NAME,
    L.OBJECT_TYPE,
    L.SCHEMA_NAME,
    L.OBJECT_NAME || MAP(L.PART_ID, 0, '', -1, '', ' (' || L.PART_ID || ')') OBJECT_NAME,
    L.LOCK_TYPE,
    L.LOCK_WAIT_COUNT LOCK_WAITS,
    L.LOCK_WAIT_TIME / 1000000 LOCK_WAIT_TIME_S,
    L.LOCK_FAILED_COUNT LOCK_FAILURES,
    BI.ORDER_BY
  FROM
  ( SELECT                        /* Modification section */
      '%' HOST,
      '%' PORT,
      '%' SERVICE_NAME,
      '%' SCHEMA_NAME,
      '%' OBJECT_NAME,
      '%' OBJECT_TYPE,
      '%' LOCK_TYPE,                /* OBJECT, RECORD */
      ' ' ONLY_LOCK_FAILURES,
      -1 MIN_LOCK_WAIT_TIME_S,
      'TOTAL_TIME' ORDER_BY          /* TOTAL_TIME, AVG_TIME, TOTAL_WAITS, OBJECT */
    FROM
      DUMMY
  ) BI,
    M_SERVICES S,
    M_OBJECT_LOCK_STATISTICS L
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
    ( BI.ONLY_LOCK_FAILURES = ' ' OR L.LOCK_FAILED_COUNT > 0 ) AND
    ( MIN_LOCK_WAIT_TIME_S = -1 OR L.LOCK_WAIT_TIME / 1000000 >= BI.MIN_LOCK_WAIT_TIME_S )
)
ORDER BY
  MAP(ORDER_BY, 'TOTAL_TIME', LOCK_WAIT_TIME_S, 'AVG_TIME', MAP(LOCK_WAITS, 0, 0, LOCK_WAIT_TIME_S / LOCK_WAITS), 'TOTAL_WAITS', LOCK_WAITS) DESC,
  OBJECT_NAME
    