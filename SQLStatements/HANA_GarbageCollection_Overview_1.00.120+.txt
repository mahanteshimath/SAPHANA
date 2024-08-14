SELECT
/* 

[NAME]

- HANA_GarbageCollection_Overview_1.00.120+

[DESCRIPTION]

- Overview about garbage collection details (row store, persistence)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_TABLE_SNAPSHOTS available as of SAP HANA 1.0 SPS 08
- M_TABLE_LOB_STATISTICS available with SAP HANA >= 1.00.120

[VALID FOR]

- Revisions:              >= 1.00.120

[SQL COMMAND VERSION]

- 2014/12/30:  1.0 (initial version)
- 2015/05/25:  1.1 (M_GARBAGE_COLLECTION_STATISTICS included)
- 2015/11/30:  1.2 (M_UNDO_CLEANUP_FILES included)
- 2015/12/30:  1.3 (Pool/DeletedPageList included)
- 2016/01/22:  1.4 (M_TABLE_SNAPSHOTS and further heap allocators included)
- 2017/02/03:  1.5 ("Transaction blocking garbage collection globally" included)
- 2017/03/22:  1.6 (M_JOB_PROGRESS included)
- 2018/05/07:  1.7 (APP_SOURCE and APP_USER included, dedicated 1.00.120+ version)
- 2019/07/12:  1.8 (update transaction ID details removed because of irrelevance)
- 2019/12/11:  1.9 (metadata versions included)

[INVOLVED TABLES]

- M_GARBAGE_COLLECTION_STATISTICS
- M_JOB_PROGRESS
- M_MVCC_OVERVIEW
- M_MVCC_TABLES
- M_RS_TABLE_VERSION_STATISTICS
- M_TABLE_LOB_STATISTICS
- M_TABLE_SNAPSHOTS
- M_TRANSACTIONS

[INPUT PARAMETERS]


[OUTPUT PARAMETERS]

- SECTION: Section description
- NAME:    Detail description
- VALUE:   Value

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------
|SECTION                                  |NAME                              |VALUE                    |
--------------------------------------------------------------------------------------------------------
|Current values                           |Timestamp                         |2016/01/24 01:54:47      |
|                                         |Commit ID                         |987705607                |
|                                         |Update transaction ID             |264054329                |
|                                         |                                  |                         |
|Ranges and IDs                           |Active commit ID range            |0                        |
|                                         |Active update transaction ID range|25                       |
|                                         |Active table snapshot MVCC range  |112323119                |
|                                         |                                  |                         |
|Row store                                |Start time                        |2016/01/24 01:54:43      |
|                                         |MVCC timestamp                    |987705607                |
|                                         |Number of versions                |465134                   |
|                                         |Max. versions per record          |81464 (P_USERS_)         |
|                                         |Max. versions per table           |122160 (P_USERS_)        |
|                                         |                                  |                         |
|Heap area sizes (MB)                     |Pool/BitVector                    |33560.85 MB              |
|                                         |Pool/RowEngine/Version            |107059.20 MB             |
|                                         |                                  |                         |
|Persistence                              |History count (column store)      |13846790                 |
|                                         |History count (liveCache)         |0                        |
|                                         |Undo file size (MB)               |0.00                     |
|                                         |Cleanup file size (MB)            |291549.03                |
|                                         |                                  |                         |
|Table MVCC snapshots                     |MVCC timestamp                    |875382488                |
|                                         |Tables                            |/BI0/QPERSON (COLUMN)    |
|                                         |                                  |/BI0/TMATERIAL (COLUMN)  |
|                                         |                                  |/BI0/TPERSON (COLUMN)    |
|                                         |                                  |/BIC/AZBILLITM00 (COLUMN)|
|                                         |                                  |/BIC/AZSALEITM00 (COLUMN)|
|                                         |                                  |                         |
|Oldest active SQL statement / idle cursor|Start time                        |2015/11/09 16:35:26      |
|                                         |MVCC timestamp                    |875382488                |
|                                         |Transaction ID                    |357                      |
|                                         |Update transaction ID             |0                        |
|                                         |Connection ID                     |407347                   |
|                                         |Cursor idle (s)                   |0                        |
|                                         |Time since last action (s)        |6513560                  |
|                                         |                                  |                         |
|Oldest update transaction (start time)   |Start time                        |n/a                      |
|                                         |MVCC timestamp                    |n/a                      |
|                                         |Transaction ID                    |n/a                      |
|                                         |Update transaction ID             |n/a                      |
|                                         |Connection ID                     |n/a                      |
|                                         |                                  |                         |
|Oldest update transaction (UTID)         |Start time                        |n/a                      |
|                                         |MVCC timestamp                    |n/a                      |
|                                         |Transaction ID                    |n/a                      |
|                                         |Update transaction ID             |n/a                      |
|                                         |Connection ID                     |n/a                      |
--------------------------------------------------------------------------------------------------------

*/

  SECTION,
  NAME,
  VALUE
FROM
( SELECT
    10 SEC_NO, 1 LINE_NO,
    'Current values' SECTION,
    'Timestamp' NAME,
    TO_VARCHAR(CURRENT_TIMESTAMP, 'YYYY/MM/DD HH24:MI:SS') VALUE
  FROM
    DUMMY
  UNION ALL
  ( SELECT
      10, L.LINE_NO + 5,
      '',
      L.NAME,
      CASE L.NAME
        WHEN 'Commit ID'                  THEN TO_VARCHAR(M.CUR_COMMIT_ID)
      END
    FROM
    ( SELECT 3 LINE_NO, 'Commit ID' NAME FROM DUMMY
    ) L,         
    ( SELECT
        MIN(MAP(NAME, 'MIN_SNAPSHOT_TS',              TO_NUMBER(VALUE), 999999999999999999999)) MIN_COMMIT_ID,
        MAX(MAP(NAME, 'GLOBAL_TS',                    TO_NUMBER(VALUE), 0)) CUR_COMMIT_ID,
        MIN(MAP(NAME, 'MIN_WRITE_TID',                TO_NUMBER(VALUE), 999999999999999999999)) MIN_UPDATE_TID,
        MAX(MAP(NAME, 'NEXT_WRITE_TID',               TO_NUMBER(VALUE), 0)) CUR_UPDATE_TID
      FROM
        M_MVCC_TABLES
    ) M
  )
  UNION ALL
  ( SELECT 15, 1, '', '', '' FROM DUMMY )
  UNION ALL
  ( SELECT
      20, L.LINE_NO,
      MAP(L.LINE_NO, 1, 'Ranges and IDs', ''),
      L.NAME,
      IFNULL(CASE L.NAME
        WHEN 'Active commit ID range'             THEN TO_VARCHAR(M.CUR_COMMIT_ID  - M.MIN_COMMIT_ID)
        WHEN 'Active table snapshot MVCC range'   THEN TO_VARCHAR(M.CUR_COMMIT_ID  - S.MIN_TS_ID)
      END, 'n/a')
    FROM
    ( SELECT 1 LINE_NO, 'Active commit ID range' NAME FROM DUMMY UNION ALL
      SELECT 3, 'Active table snapshot MVCC range'    FROM DUMMY
    ) L,         
    ( SELECT
        MIN(MAP(NAME, 'MIN_SNAPSHOT_TS',              TO_NUMBER(VALUE), 999999999999999999999)) MIN_COMMIT_ID,
        MAX(MAP(NAME, 'GLOBAL_TS',                    TO_NUMBER(VALUE), 0)) CUR_COMMIT_ID,
        MIN(MAP(NAME, 'MIN_WRITE_TID',                TO_NUMBER(VALUE), 999999999999999999999)) MIN_UPDATE_TID,
        MAX(MAP(NAME, 'NEXT_WRITE_TID',               TO_NUMBER(VALUE), 0)) CUR_UPDATE_TID
      FROM
        M_MVCC_TABLES
    ) M,
    ( SELECT
        MIN(MIN_MVCC_SNAPSHOT_TIMESTAMP) MIN_TS_ID
      FROM
        M_TABLE_SNAPSHOTS
    ) S
  )
  UNION ALL
  ( SELECT 25, 1, '', '', '' FROM DUMMY )
  UNION ALL
  ( SELECT
      30, L.LINE_NO,
      MAP(L.LINE_NO, 1, 'Row store', ''),
      L.NAME,
      IFNULL(CASE L.NAME
        WHEN 'Start time (global lock)'       THEN TO_VARCHAR(T.START_TIME, 'YYYY/MM/DD HH24:MI:SS')
        WHEN 'MVCC timestamp'                 THEN TO_VARCHAR(T.MIN_MVCC_SNAPSHOT_TIMESTAMP)
        WHEN 'Blocking transaction ID'        THEN TO_VARCHAR(T.TRANSACTION_ID)
        WHEN 'Blocking connection ID'         THEN TO_VARCHAR(T.CONNECTION_ID)
        WHEN 'Total versions'                 THEN TO_VARCHAR(T.NUM_VERSIONS)
        WHEN 'Data versions'                  THEN TO_VARCHAR(T.DATA_VERSION_COUNT)
        WHEN 'Metadata versions'              THEN TO_VARCHAR(T.METADATA_VERSION_COUNT)
      END, 'n/a')
    FROM
    ( SELECT 1 LINE_NO, 'Start time (global lock)' NAME FROM DUMMY UNION ALL
      SELECT 2, 'MVCC timestamp' NAME FROM DUMMY UNION ALL
      SELECT 3, 'Blocking transaction ID' NAME FROM DUMMY UNION ALL
      SELECT 5, 'Blocking connection ID' FROM DUMMY UNION ALL
      SELECT 6, 'Total versions' FROM DUMMY UNION ALL
      SELECT 7, 'Data versions' FROM DUMMY UNION ALL
      SELECT 8, 'Metadata versions' FROM DUMMY
    ) L,
    ( SELECT TOP 1
        M.VERSION_COUNT NUM_VERSIONS,
        M.DATA_VERSION_COUNT,
        M.METADATA_VERSION_COUNT,
        T.START_TIME,
        M.MIN_MVCC_SNAPSHOT_TIMESTAMP,
        T.TRANSACTION_ID,
        T.UPDATE_TRANSACTION_ID,
        T.CONNECTION_ID
      FROM
      ( SELECT
          SUM(VERSION_COUNT) VERSION_COUNT,
          SUM(DATA_VERSION_COUNT) DATA_VERSION_COUNT,
          SUM(METADATA_VERSION_COUNT) METADATA_VERSION_COUNT,
          MIN_MVCC_SNAPSHOT_TIMESTAMP
        FROM
          M_MVCC_OVERVIEW
        GROUP BY
          MIN_MVCC_SNAPSHOT_TIMESTAMP
      ) M LEFT OUTER JOIN
        M_TRANSACTIONS T ON
          M.MIN_MVCC_SNAPSHOT_TIMESTAMP = T.MIN_MVCC_SNAPSHOT_TIMESTAMP AND
          T.TRANSACTION_ID > 0
      ORDER BY
        M.MIN_MVCC_SNAPSHOT_TIMESTAMP
    ) T
  )
  UNION ALL
  ( SELECT TOP 1
      30, 10,
      '',
      'Max. versions per table',
      IFNULL(VERSION_COUNT || CHAR(32) || '(' || TABLE_NAME  || ')', '0')
    FROM
      DUMMY LEFT OUTER JOIN
      M_RS_TABLE_VERSION_STATISTICS ON
        1 = 1
    ORDER BY
      VERSION_COUNT DESC
  )
  UNION ALL
  ( SELECT TOP 1
      30, 11,
      '',
      'Max. versions per record',
      TO_VARCHAR(T.VALUE) || MAP(O.OBJECT_NAME, NULL, '', CHAR(32) || '(' || O.OBJECT_NAME || ')')
    FROM
      M_MVCC_TABLES T INNER JOIN
      M_MVCC_TABLES T2 ON
        T.HOST = T2.HOST AND
        T.PORT = T2.PORT AND
        T.NAME = 'MAX_VERSIONS_PER_RECORD' AND
        T2.NAME = 'TABLE_ID_OF_MAX_NUM_VERSIONS' LEFT OUTER JOIN
      OBJECTS O ON
        T2.VALUE = O.OBJECT_OID
    ORDER BY
      T.VALUE DESC
  )
  UNION ALL
  ( SELECT 35, 1, '', '', '' FROM DUMMY )
  UNION ALL
  ( SELECT
      40, ROW_NUMBER() OVER (ORDER BY CATEGORY),
      MAP(ROW_NUMBER() OVER (ORDER BY CATEGORY), 1, 'Heap area sizes', ''),
      CATEGORY  || CHAR(32) || '(MB)',
      IFNULL(TO_VARCHAR(TO_DECIMAL(SIZE_MB, 10, 2)), 'n/a')
    FROM
    ( SELECT
        CATEGORY,
        SUM(INCLUSIVE_SIZE_IN_USE / 1024 / 1024) SIZE_MB
      FROM
        M_HEAP_MEMORY
      WHERE
        CATEGORY IN 
        ( 'Pool/BitVector', 
          'Pool/DeletedPageList', 
          'Pool/FRSWLockAllocator', 
          'Pool/PersistenceManager/UndoDirectory', 
          'Pool/PersistenceManager/UnifiedTable container', 
          'Pool/PersistenceManager/UnifiedTableContainer', 
          'Pool/RowEngine/LockTable',
          'Pool/RowEngine/RowTableManager/MVCCManager/MVCCAllocator',
          'Pool/RowEngine/Version',
          'Pool/RowStoreTables/LockTable', 
          'Pool/RowStoreTables/Version',
          'Pool/UdivListMgr/UdivListContainer'
        )
      GROUP BY
        CATEGORY
    )
  )
  UNION ALL
  ( SELECT 45, 1, '', '', '' FROM DUMMY )
  UNION ALL
  ( SELECT
      50, L.LINE_NO,
      MAP(L.LINE_NO, 1, 'Version memory', ''),
      L.NAME || CHAR(32) || '(MB)',
      MAP(L.NAME,
        'Allocated', TO_VARCHAR(TO_DECIMAL(SUM(M.ALLOCATED_MEMORY_SIZE) / 1024 / 1024, 10, 2)),
        'Used',      TO_VARCHAR(TO_DECIMAL(SUM(M.USED_MEMORY_SIZE) / 1024 / 1024, 10, 2)),
        'Reclaimed', TO_VARCHAR(TO_DECIMAL(SUM(M.RECLAIMED_VERSION_SIZE) / 1024 / 1024, 10, 2)),
        'Free',      TO_VARCHAR(TO_DECIMAL(SUM(M.FREE_MEMORY_SIZE) / 1024 / 1024, 10, 2)))
    FROM
    ( SELECT 1 LINE_NO, 'Allocated' NAME FROM DUMMY UNION ALL
      SELECT 2, 'Used'      FROM DUMMY UNION ALL
      SELECT 3, 'Reclaimed' FROM DUMMY UNION ALL
      SELECT 4, 'Free'      FROM DUMMY
    ) L,
      M_VERSION_MEMORY M 
    GROUP BY
      L.LINE_NO,
      L.NAME 
  )
  UNION ALL
  ( SELECT 55, 1, '', '', '' FROM DUMMY )
  UNION ALL
  ( SELECT 
      57, ROWNO,
      MAP(ROWNO, 1, 'Orphan LOBs', ''),
      TABLE_NAME,
      TO_VARCHAR(ORPHAN_LOBS)
    FROM
    ( SELECT TOP 5
        ROW_NUMBER () OVER (ORDER BY L.LOB_COUNT - ( C.LOB_COLUMNS * T.RECORD_COUNT ) DESC ) ROWNO,
        L.SCHEMA_NAME || '.' || L.TABLE_NAME TABLE_NAME,
        L.LOB_COUNT - ( C.LOB_COLUMNS * T.RECORD_COUNT ) ORPHAN_LOBS
      FROM
      ( SELECT DISTINCT
          HOST
        FROM
          M_HOST_INFORMATION  
      ) H,
      ( SELECT
          HOST,
          SCHEMA_NAME,
          TABLE_NAME,
          SUM(LOB_COUNT) LOB_COUNT
        FROM
          M_TABLE_LOB_STATISTICS
        GROUP BY
          HOST,
          SCHEMA_NAME,
          TABLE_NAME
      ) L,
        M_TABLES T,
      ( SELECT
          SCHEMA_NAME,
          TABLE_NAME,
          COUNT(*) LOB_COLUMNS
        FROM
          TABLE_COLUMNS
        WHERE
          DATA_TYPE_NAME IN ( 'BLOB', 'CLOB', 'NCLOB', 'TEXT', 'BINTEXT' )
        GROUP BY
          SCHEMA_NAME,
          TABLE_NAME
      ) C
      WHERE
        L.HOST = H.HOST AND
        T.SCHEMA_NAME = L.SCHEMA_NAME AND
        T.TABLE_NAME = L.TABLE_NAME AND
        C.SCHEMA_NAME = L.SCHEMA_NAME AND
        C.TABLE_NAME = L.TABLE_NAME AND
        L.LOB_COUNT - ( C.LOB_COLUMNS * T.RECORD_COUNT ) > 0
      ORDER BY
        L.LOB_COUNT - ( C.LOB_COLUMNS * T.RECORD_COUNT ) DESC
    )
  )
  UNION ALL
  ( SELECT 59, 1, '', '', '' FROM DUMMY )
  UNION ALL
  ( SELECT
      60, 1,
      'Persistence',
      'History count (column store)',
      TO_VARCHAR(SUM(HISTORY_COUNT))
    FROM
      M_GARBAGE_COLLECTION_STATISTICS
    WHERE
      STORE_TYPE = 'COLUMN STORE'
  )
  UNION ALL
  ( SELECT
      60, 2, 
      '',
      'History count (liveCache)',
      TO_VARCHAR(SUM(HISTORY_COUNT))
    FROM
      M_GARBAGE_COLLECTION_STATISTICS
    WHERE
      STORE_TYPE = 'LIVECACHE'
  )
  UNION ALL
  ( SELECT
      62, D.LINE_NO,
      '',
      MAP(D.FILE_TYPE, 'UNDO', 'Undo', 'Cleanup') || CHAR(32) || 'file size (MB)',
      TO_VARCHAR(TO_DECIMAL(IFNULL(U.RAW_SIZE / 1024 / 1024, 0), 10, 2))
    FROM
    ( SELECT 1 LINE_NO, 'UNDO' FILE_TYPE FROM DUMMY UNION ALL
      SELECT 2 LINE_NO, 'CLEANUP' FROM DUMMY ) D LEFT OUTER JOIN
    ( SELECT
        TYPE,
        SUM(RAW_SIZE) RAW_SIZE
      FROM
        M_UNDO_CLEANUP_FILES
      WHERE
        TYPE IN ('UNDO', 'CLEANUP')
      GROUP BY
        TYPE
    ) U ON
        D.FILE_TYPE = U.TYPE
  )
  UNION ALL
  ( SELECT 65, 1, '', '', '' FROM DUMMY )
  UNION ALL
  ( SELECT
      70, 1,
      'Table MVCC snapshots',
      'MVCC timestamp',
      IFNULL(TO_VARCHAR(MIN(MIN_MVCC_SNAPSHOT_TIMESTAMP)), 'n/a')
    FROM
      M_TABLE_SNAPSHOTS
  )
  UNION ALL
  ( SELECT
      72, ROW_NUMBER() OVER (ORDER BY TABLE_NAME),
      '',
      MAP(ROW_NUMBER () OVER (ORDER BY TABLE_NAME), 1, 'Tables', ''),
      IFNULL(TABLE_NAME || CHAR(32) || '(' || TABLE_TYPE || ')', 'n/a')
    FROM
      M_TABLE_SNAPSHOTS
    WHERE
      MIN_MVCC_SNAPSHOT_TIMESTAMP = ( SELECT MIN(MIN_MVCC_SNAPSHOT_TIMESTAMP) FROM M_TABLE_SNAPSHOTS )
  )    
  UNION ALL
  ( SELECT 75, 1, '', '', '' FROM DUMMY )
  UNION ALL
  ( SELECT
      80, L.LINE_NO,
      MAP(L.LINE_NO, 1, 'Oldest active SQL statement / idle cursor', ''),
      L.NAME,
      IFNULL(CASE L.NAME
        WHEN 'MVCC timestamp'             THEN TO_VARCHAR(T.START_MVCC_TIMESTAMP)
        WHEN 'Transaction ID'             THEN TO_VARCHAR(T.TRANSACTION_ID)
        WHEN 'Connection ID'              THEN TO_VARCHAR(T.CONNECTION_ID)
        WHEN 'Start time'                 THEN TO_VARCHAR(T.START_TIME, 'YYYY/MM/DD HH24:MI:SS')
        WHEN 'Cursor idle (s)'            THEN TO_VARCHAR(TO_DECIMAL(ROUND(T.IDLE_TIME / 1000), 10, 0))
        WHEN 'Time since last action (s)' THEN TO_VARCHAR(GREATEST(0, SECONDS_BETWEEN(LAST_ACTION_TIME, CURRENT_TIMESTAMP)))
        WHEN 'Application source'         THEN APP_SOURCE
        WHEN 'Application user'           THEN APP_USER
      END, 'n/a')
    FROM
    ( SELECT  1 LINE_NO, 'Start time' NAME    FROM DUMMY UNION ALL
      SELECT  2, 'MVCC timestamp'             FROM DUMMY UNION ALL
      SELECT  3, 'Transaction ID'             FROM DUMMY UNION ALL
      SELECT  5, 'Connection ID'              FROM DUMMY UNION ALL
      SELECT  6, 'Cursor idle (s)'            FROM DUMMY UNION ALL
      SELECT  7, 'Time since last action (s)' FROM DUMMY UNION ALL
      SELECT  8, 'Application source'         FROM DUMMY UNION ALL
      SELECT  9, 'Application user'           FROM DUMMY
    ) L LEFT OUTER JOIN
    ( SELECT TOP 1
        A.START_MVCC_TIMESTAMP,
        C.TRANSACTION_ID,
        T.UPDATE_TRANSACTION_ID,
        A.CONNECTION_ID,
        A.LAST_EXECUTED_TIME START_TIME,
        A.LAST_ACTION_TIME,
        C.IDLE_TIME,
        S1.VALUE APP_SOURCE,
        IFNULL(S2.VALUE, S3.VALUE) APP_USER
      FROM
        M_ACTIVE_STATEMENTS A LEFT OUTER JOIN
        M_SESSION_CONTEXT S1 ON
          S1.HOST = A.HOST AND
          S1.PORT = A.PORT AND
          S1.CONNECTION_ID = A.CONNECTION_ID AND
          S1.KEY = 'APPLICATIONSOURCE' LEFT OUTER JOIN
        M_SESSION_CONTEXT S2 ON
          S2.HOST = A.HOST AND
          S2.PORT = A.PORT AND
          S2.CONNECTION_ID = A.CONNECTION_ID AND
          S2.KEY = 'APPLICATIONUSER' LEFT OUTER JOIN
        M_SESSION_CONTEXT S3 ON
          S3.HOST = A.HOST AND
          S3.PORT = A.PORT AND
          S3.CONNECTION_ID = A.CONNECTION_ID AND
          S3.KEY = 'XS_APPLICATIONUSER' INNER JOIN
        M_CONNECTIONS C ON
          A.HOST = C.HOST AND
          A.PORT = C.PORT AND
          A.CONNECTION_ID = C.CONNECTION_ID INNER JOIN
        M_TRANSACTIONS T ON
          C.CONNECTION_ID = T.CONNECTION_ID AND
          C.TRANSACTION_ID = T.TRANSACTION_ID
      WHERE
        A.START_MVCC_TIMESTAMP > 0
      ORDER BY
        A.START_MVCC_TIMESTAMP
    ) T ON
      1 = 1
  )
  UNION ALL
  ( SELECT 85, 1, '', '', '' FROM DUMMY )
  UNION ALL
  ( SELECT
      90, L.LINE_NO,
      MAP(L.LINE_NO, 1, 'Oldest update transaction (start time)', ''),
      L.NAME,
      IFNULL(CASE L.NAME
        WHEN 'MVCC timestamp'        THEN TO_VARCHAR(T.START_MVCC_TIMESTAMP)
        WHEN 'Transaction ID'        THEN TO_VARCHAR(T.TRANSACTION_ID)
        WHEN 'Update transaction ID' THEN TO_VARCHAR(T.UPDATE_TRANSACTION_ID)
        WHEN 'Connection ID'         THEN TO_VARCHAR(T.CONNECTION_ID)
        WHEN 'Start time'            THEN TO_VARCHAR(T.START_TIME, 'YYYY/MM/DD HH24:MI:SS')
        WHEN 'Application source'    THEN S1.VALUE
        WHEN 'Application user'      THEN IFNULL(S2.VALUE, S3.VALUE)   
      END, 'n/a') 
    FROM
    ( SELECT  1 LINE_NO, 'Start time' NAME       FROM DUMMY UNION ALL
      SELECT  2,         'MVCC timestamp'        FROM DUMMY UNION ALL
      SELECT  3,         'Transaction ID'        FROM DUMMY UNION ALL
      SELECT  4,         'Update transaction ID' FROM DUMMY UNION ALL
      SELECT  5,         'Connection ID'         FROM DUMMY UNION ALL
      SELECT  6,         'Application source'    FROM DUMMY UNION ALL
      SELECT  7,         'Application user'      FROM DUMMY
    ) L LEFT OUTER JOIN
    ( SELECT TOP 1 * FROM M_TRANSACTIONS WHERE UPDATE_TRANSACTION_ID > 0 ORDER BY START_TIME ) T ON
      1 = 1 LEFT OUTER JOIN
      M_SESSION_CONTEXT S1 ON
        S1.HOST = T.HOST AND
        S1.PORT = T.PORT AND
        S1.CONNECTION_ID = T.CONNECTION_ID AND
        S1.KEY = 'APPLICATIONSOURCE' LEFT OUTER JOIN
      M_SESSION_CONTEXT S2 ON
        S2.HOST = T.HOST AND
        S2.PORT = T.PORT AND
        S2.CONNECTION_ID = T.CONNECTION_ID AND
        S2.KEY = 'APPLICATIONUSER' LEFT OUTER JOIN
      M_SESSION_CONTEXT S3 ON
        S3.HOST = T.HOST AND
        S3.PORT = T.PORT AND
        S3.CONNECTION_ID = T.CONNECTION_ID AND
        S3.KEY = 'XS_APPLICATIONUSER'
  )
  UNION ALL
  ( SELECT 95, 1, '', '', '' FROM DUMMY )
  UNION ALL
  ( SELECT
      100, L.LINE_NO,
      MAP(L.LINE_NO, 1, 'Oldest update transaction (UTID)', ''),
      L.NAME,
      IFNULL(CASE L.NAME
        WHEN 'MVCC timestamp'        THEN TO_VARCHAR(T.START_MVCC_TIMESTAMP)
        WHEN 'Transaction ID'        THEN TO_VARCHAR(T.TRANSACTION_ID)
        WHEN 'Update transaction ID' THEN TO_VARCHAR(T.UPDATE_TRANSACTION_ID)
        WHEN 'Connection ID'         THEN TO_VARCHAR(T.CONNECTION_ID)
        WHEN 'Start time'            THEN TO_VARCHAR(T.START_TIME, 'YYYY/MM/DD HH24:MI:SS')
        WHEN 'Application source'    THEN S1.VALUE
        WHEN 'Application user'      THEN IFNULL(S2.VALUE, S3.VALUE)
      END, 'n/a') 
    FROM
    ( SELECT  1 LINE_NO, 'Start time' NAME       FROM DUMMY UNION ALL
      SELECT  2,         'MVCC timestamp'        FROM DUMMY UNION ALL
      SELECT  3,         'Transaction ID'        FROM DUMMY UNION ALL
      SELECT  4,         'Update transaction ID' FROM DUMMY UNION ALL
      SELECT  5,         'Connection ID'         FROM DUMMY UNION ALL
      SELECT  6,         'Application source'    FROM DUMMY UNION ALL
      SELECT  7,         'Application user'      FROM DUMMY
    ) L LEFT OUTER JOIN
    ( SELECT TOP 1 * FROM M_TRANSACTIONS WHERE UPDATE_TRANSACTION_ID > 0 ORDER BY UPDATE_TRANSACTION_ID ) T ON
      1 = 1 LEFT OUTER JOIN
      M_SESSION_CONTEXT S1 ON
        S1.HOST = T.HOST AND
        S1.PORT = T.PORT AND
        S1.CONNECTION_ID = T.CONNECTION_ID AND
        S1.KEY = 'APPLICATIONSOURCE' LEFT OUTER JOIN
      M_SESSION_CONTEXT S2 ON
        S2.HOST = T.HOST AND
        S2.PORT = T.PORT AND
        S2.CONNECTION_ID = T.CONNECTION_ID AND
        S2.KEY = 'APPLICATIONUSER' LEFT OUTER JOIN
      M_SESSION_CONTEXT S3 ON
        S3.HOST = T.HOST AND
        S3.PORT = T.PORT AND
        S3.CONNECTION_ID = T.CONNECTION_ID AND
        S3.KEY = 'XS_APPLICATIONUSER'
  )
  UNION ALL
  ( SELECT 109, 1, '', '', '' FROM DUMMY )
  UNION ALL
  ( SELECT
      110, L.LINE_NO,
      MAP(L.LINE_NO, 1, 'Transaction blocking garbage collection globally', ''),
      L.NAME,
      IFNULL(CASE L.NAME
        WHEN 'MVCC timestamp'        THEN TO_VARCHAR(T.START_MVCC_TIMESTAMP)
        WHEN 'Transaction ID'        THEN TO_VARCHAR(T.TRANSACTION_ID)
        WHEN 'Host'                  THEN T.HOST
        WHEN 'Connection ID'         THEN TO_VARCHAR(T.CONNECTION_ID)
        WHEN 'Start time'            THEN TO_VARCHAR(T.START_TIME, 'YYYY/MM/DD HH24:MI:SS')
        WHEN 'Application source'    THEN APP_SOURCE
        WHEN 'Application user'      THEN APP_USER
      END, 'n/a') 
    FROM
    ( SELECT  1 LINE_NO, 'Start time' NAME       FROM DUMMY UNION ALL
      SELECT  2,         'MVCC timestamp'        FROM DUMMY UNION ALL
      SELECT  3,         'Transaction ID'        FROM DUMMY UNION ALL
      SELECT  4,         'Host'                  FROM DUMMY UNION ALL
      SELECT  6,         'Connection ID'         FROM DUMMY UNION ALL
      SELECT  7,         'Application source'    FROM DUMMY UNION ALL
      SELECT  8,         'Application user'      FROM DUMMY ) L LEFT OUTER JOIN
    ( SELECT TOP 1
        T.START_MVCC_TIMESTAMP,
        T.TRANSACTION_ID,
        T.HOST,
        T.UPDATE_TRANSACTION_ID,
        T.CONNECTION_ID,
        T.START_TIME,
        S1.VALUE APP_SOURCE,
        IFNULL(S2.VALUE, S3.VALUE) APP_USER
      FROM 
        M_TRANSACTIONS T LEFT OUTER JOIN
        M_SESSION_CONTEXT S1 ON
          S1.HOST = T.HOST AND
          S1.PORT = T.PORT AND
          S1.CONNECTION_ID = T.CONNECTION_ID AND
          S1.KEY = 'APPLICATIONSOURCE' LEFT OUTER JOIN
        M_SESSION_CONTEXT S2 ON
          S2.HOST = T.HOST AND
          S2.PORT = T.PORT AND
          S2.CONNECTION_ID = T.CONNECTION_ID AND
          S2.KEY = 'APPLICATIONUSER' LEFT OUTER JOIN
        M_SESSION_CONTEXT S3 ON
          S3.HOST = T.HOST AND
          S3.PORT = T.PORT AND
         S3.CONNECTION_ID = T.CONNECTION_ID AND
           S3.KEY = 'XS_APPLICATIONUSER' INNER JOIN
        M_MVCC_OVERVIEW M ON
          M.MIN_MVCC_SNAPSHOT_TIMESTAMP IN (T.START_MVCC_TIMESTAMP, T.MIN_MVCC_SNAPSHOT_TIMESTAMP)
      ORDER BY
        T.START_MVCC_TIMESTAMP,
        T.MIN_MVCC_SNAPSHOT_TIMESTAMP ) T ON
      1 = 1
  )
  UNION ALL
  ( SELECT 119, 1, '', '', '' FROM DUMMY )
  UNION ALL
  ( SELECT
      120, L.LINE_NO,
      MAP(L.LINE_NO, 1, 'Oldest active job', ''),
      L.NAME,
      IFNULL(CASE L.NAME
        WHEN 'Job name'    THEN J.JOB_NAME
        WHEN 'Object name' THEN J.OBJECT_NAME
        WHEN 'Progress'    THEN J.CURRENT_PROGRESS || CHAR(32) || '/' || CHAR(32) || J.MAX_PROGRESS
        WHEN 'Start time'  THEN TO_VARCHAR(J.START_TIME, 'YYYY/MM/DD HH24:MI:SS')
      END, 'n/a') 
    FROM
    ( SELECT 2 LINE_NO, 'Job name' NAME FROM DUMMY UNION ALL
      SELECT 3, 'Object name' NAME FROM DUMMY UNION ALL
      SELECT 4, 'Progress' FROM DUMMY UNION ALL
      SELECT 1, 'Start time' FROM DUMMY
    ) L LEFT OUTER JOIN
    ( SELECT 
        TOP 1 * 
      FROM 
        M_JOB_PROGRESS
      ORDER BY
        START_TIME
    ) J ON
      1 = 1
  )
)
ORDER BY
  SEC_NO,
  LINE_NO
