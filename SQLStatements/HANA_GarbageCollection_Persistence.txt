SELECT
/* 

[NAME]

- HANA_GarbageCollection_Persistence

[DESCRIPTION]

- Garbage collection overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Can be used for monitoring remote system replication sites, see SAP Note 1999880 
  ("Is it possible to monitor remote system replication sites on the primary system") for details.

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/06/20:  1.0 (initial version)
- 2015/11/30:  1.1 (UNDO_FILES, CLEANUP_FILES and FILE_SIZE_GB included)
- 2017/03/28:  1.2 (replaced three M_UNDO_CLEANUP_FILES subqueries with outer join for performance reasons)

[INVOLVED TABLES]

- M_GARBAGE_COLLECTION_STATISTICS

[INPUT PARAMETERS]

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

- STORE

  Restriction to store 

  'LIVECACHE'     --> Only liveCache information
  'COLUMN'        --> Only column store information
  '%'             --> No store restriction

[OUTPUT PARAMETERS]

- HOST:            Host name
- PORT:            Port
- STORE:           Store (COLUMN STORE or liveCache)
- HISTORY_COUNT:   Number of histories requiring garbage collection
- BITVEC_SIZE_GB:  Size of heap allocator Pool/BitVector which can grow in case of garbage collection problems
- WAITERS:         Number of history waiters
- UNDO_FILES:      Number of undo files (still potentially required for rollbacks and MVCC)
- CLEANUP_FILES:   Number of cleanup files (still ptentially required for MVCC)
- FILE_SIZE_GB:    Total undo and cleanup file size (GB)
- COMMIT_ID_RANGE: Commit ID range

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------
|HOST        |PORT |STORE       |HISTORY_COUNT|BITVEC_SIZE_GB|WAITERS     |UNDO_FILES|CLEANUP_FILES|FILE_SIZE_GB|COMMIT_ID_RANGE|
---------------------------------------------------------------------------------------------------------------------------------
|hana_101-srv|30003|COLUMN STORE|       234346|          0.15|           0|        74|       234386|        0.95|        3708215|
|hana_101-srv|30007|COLUMN STORE|            0|          0.00|           0|         0|            0|        0.00|        3684729|
|hana_102-srv|30003|COLUMN STORE|          966|          4.39|           0|         0|          966|        0.02|        3684877|
|hana_103-srv|30003|COLUMN STORE|         1026|          4.09|           0|         2|         1028|        0.01|        3684875|
|hana_104-srv|30003|COLUMN STORE|         1117|          3.98|           0|         1|         1118|        0.00|        3684863|
|hana_201-srv|30003|COLUMN STORE|         1295|          4.44|           0|         0|         1295|        0.75|        3684863|
|hana_202-srv|30003|COLUMN STORE|         1097|          4.15|           0|         1|         1098|        0.69|        3684863|
|hana_203-srv|30003|COLUMN STORE|         1288|          4.01|           0|         0|         1288|        0.78|        3684871|
|hana_204-srv|30003|COLUMN STORE|        14038|          3.57|           0|         1|        14039|        0.74|        3684863|
|hana_301-srv|30003|COLUMN STORE|         1136|          3.96|           0|         1|         1137|        0.66|        3684871|
|hana_302-srv|30003|COLUMN STORE|         4971|          3.90|           0|         0|         4971|        0.02|        3684871|
|hana_303-srv|30003|COLUMN STORE|         1864|          4.14|           0|         1|         1865|        0.31|        3684859|
|hana_304-srv|30003|COLUMN STORE|         1419|          3.97|           0|         1|         1420|        0.68|        3684871|
|hana_401-srv|30003|COLUMN STORE|         1472|          4.00|           0|         1|         1473|        0.03|        3684865|
|hana_402-srv|30003|COLUMN STORE|         1080|          4.19|           0|         1|         1081|        0.01|        3684879|
|hana_403-srv|30003|COLUMN STORE|          712|          3.99|           0|         0|          712|        0.07|        3684867|
|hana_404-srv|30003|COLUMN STORE|         1161|          4.18|           0|         1|         1162|        0.01|        3684863|
---------------------------------------------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  STORE_TYPE STORE,
  LPAD(HISTORY_COUNT, 13) HISTORY_COUNT,
  MAP(STORE_TYPE, 'COLUMN STORE', LPAD(TO_DECIMAL(IFNULL(BITVEC_SIZE_BYTE, 0) / 1024 / 1024 / 1024, 10, 2), 14), LPAD('n/a', 14)) BITVEC_SIZE_GB,
  LPAD(WAITER_COUNT, 12) WAITERS,
  MAP(STORE_TYPE, 'COLUMN STORE', LPAD(IFNULL(UNDO_FILES, 0), 10), LPAD('n/a', 10)) UNDO_FILES,
  MAP(STORE_TYPE, 'COLUMN STORE', LPAD(IFNULL(CLEANUP_FILES, 0), 13), LPAD('n/a', 13)) CLEANUP_FILES,
  MAP(STORE_TYPE, 'COLUMN STORE', LPAD(TO_DECIMAL(IFNULL(FILE_SIZE_BYTE, 0) / 1024 / 1024 / 1024, 10, 2), 12), LPAD('n/a', 12)) FILE_SIZE_GB,
  LPAD(CUR_COMMIT_ID - MIN_COMMIT_ID, 15) COMMIT_ID_RANGE
FROM
( SELECT
    G.HOST,
    G.PORT,
    G.STORE_TYPE,
    G.HISTORY_COUNT,
    G.WAITER_COUNT,
    G.MIN_READ_TID MIN_COMMIT_ID,
    SUM(MAP(U.TYPE, 'UNDO', 1, 0)) UNDO_FILES,
    SUM(MAP(U.TYPE, 'CLEANUP', 1, 0)) CLEANUP_FILES,
    SUM(MAP(U.TYPE, 'FREE', 0, U.RAW_SIZE)) FILE_SIZE_BYTE,
    ( SELECT VALUE FROM M_MVCC_TABLES M WHERE M.HOST = G.HOST AND M.PORT = G.PORT AND M.NAME = 'GLOBAL_TS' ) CUR_COMMIT_ID,
    ( SELECT SUM(EXCLUSIVE_SIZE_IN_USE) FROM M_HEAP_MEMORY H WHERE H.HOST = G.HOST AND H.PORT = G.PORT AND H.CATEGORY = 'Pool/BitVector' ) BITVEC_SIZE_BYTE  
  FROM
  ( SELECT                       /* Modification section */
      '%' HOST,
      '%' PORT,
      'COLUMN' STORE               /* COLUMN, LIVECACHE, % */
    FROM
      DUMMY
  ) BI,
    M_GARBAGE_COLLECTION_STATISTICS G LEFT OUTER JOIN
    M_UNDO_CLEANUP_FILES U ON
      G.HOST = U.HOST AND
      G.PORT = U.PORT
  WHERE
    G.HOST LIKE BI.HOST AND
    TO_VARCHAR(G.PORT) LIKE BI.PORT AND
    ( G.STORE_TYPE = 'COLUMN STORE' AND BI.STORE = 'COLUMN' OR
      G.STORE_TYPE LIKE BI.STORE )
  GROUP BY
    G.HOST,
    G.PORT,
    G.STORE_TYPE,
    G.HISTORY_COUNT,
    G.WAITER_COUNT,
    G.MIN_READ_TID
)
ORDER BY
  HOST,
  PORT,
  STORE_TYPE

