SELECT

/* 

[NAME]

- HANA_Metadata_Cache_1.00.122.14+

[DESCRIPTION]

- Metadata cache information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Metadata cache available with SAP HANA 1.0 SPS 12 and higher
- Can only be executed with SAP_INTERNAL_HANA_SUPPORT role or as SYSTEM
- Not available for public use
- Public view available starting with 1.00.122.14, 2.00.012.03 and 2.00.022 (bug 159661)
- Be aware that this analysis command will not succeed on 2.00.000 - 2.00.012.02 and 2.00.20 - 2.00.21
- EMPTY_HITS are cache hits that indicate that the searched object does NOT exist, e.g.
  if a procedure is searched, the following sequence of lookups is done:

    table -> view -> synonym -> procedure

  The first three objects (table, view, synonym) would be flagged with "not found" and
  next time when the same procedure is queried, empty hits are recorded for these objects

[VALID FOR]

- Revisions:              >= 1.00.122.14

[SQL COMMAND VERSION]

- 2017/11/02:  1.0 (initial version)
- 2018/02/06:  1.1 (official version based on public view M_METADATA_CACHE_STATISTICS)

[INVOLVED TABLES]

- M_METADATA_CACHE_STATISTICS

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

- CACHE_GROUP_NAME

  Object name

  'EDIDC'         --> Specific object name EDIDC
  'A%'            --> All objects starting with 'A'
  '%'             --> All objects

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'OBJECT'        --> Aggregation by object
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'OBJECT'        --> Sorting by object name
  'REMOTE'        --> Sorting by metadata cache remote calls

[OUTPUT PARAMETERS]

- HOST:             Host name
- PORT:             Port
- CACHE_GROUP_NAME: Cache group name
- ACCESSES:         Cache accesses
- HITS:             Cache hits
- EMPTY_HITS:       Cache empty hits 
- REMOTE_CALLS:     Remote calls
- ENTRIES:          Cache entries
- MEM_MB:           Memory size (MB)

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------------------------------------------
|HOST|PORT |CACHE_GROUP_NAME                        |ACCESSES    |HITS        |EMPTY_HITS  |REMOTE_CALLS|ENTRIES     |MEM_MB      |
-----------------------------------------------------------------------------------------------------------------------------------
|any |30003|getTable                                |    19956920|       18579|    19919262|       19079|           0|        0.00|
|any |30003|getView                                 |    15349224|           0|    15349224|           0|           0|        0.00|
|any |30007|getObjectByOid                          |       46910|       45865|         149|         276|         207|        0.67|
|any |30007|getTable                                |       39402|       30350|        6716|        2088|         243|        1.26|
|any |30007|getGrantedPriv                          |       12918|       12647|           0|         226|           2|        0.02|
|any |30007|getPrincipalByOid                       |       12280|       11655|           0|         479|           3|        0.00|
|any |30007|getTopologyInfos                        |       11679|        3899|        4361|        3322|         213|        0.05|
|any |30007|getObjSubTypeByOid                      |       10182|       10129|           0|           6|           2|        0.00|
-----------------------------------------------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  CACHE_GROUP_NAME,
  LPAD(ACCESSES, 12) ACCESSES,
  LPAD(HITS, 12) HITS,
  LPAD(EMPTY_HITS, 12) EMPTY_HITS,
  LPAD(REMOTE_CALLS, 12) REMOTE_CALLS,
  LPAD(ENTRIES, 12) ENTRIES,
  LPAD(TO_DECIMAL(MEM_MB, 10, 2), 12) MEM_MB
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')   != 0 THEN M.HOST             ELSE MAP(BI.HOST,             '%', 'any', BI.HOST)             END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')   != 0 THEN TO_VARCHAR(M.PORT) ELSE MAP(BI.PORT,             '%', 'any', BI.PORT)             END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'OBJECT') != 0 THEN M.CACHE_GROUP_NAME ELSE MAP(BI.CACHE_GROUP_NAME, '%', 'any', BI.CACHE_GROUP_NAME) END CACHE_GROUP_NAME,
    SUM(M.ACCESS_COUNT) ACCESSES,
    SUM(M.HIT_COUNT) HITS,
    SUM(M.EMPTY_HIT_COUNT) EMPTY_HITS,
    SUM(M.MISS_COUNT + M.NOT_FOUND_COUNT + M.LATE_HIT_COUNT) REMOTE_CALLS,
    SUM(M.ENTRY_COUNT) ENTRIES,
    SUM(M.USED_MEMORY_SIZE / 1024 / 1024) MEM_MB,
    BI.ORDER_BY
  FROM
  ( SELECT                /* Modification section */
      '%' HOST,
      '%' PORT,
      '%' CACHE_GROUP_NAME,
      'OBJECT' AGGREGATE_BY,               /* HOST, PORT, OBJECT or comma separated combinations, NONE for no aggregation */
      'REMOTE' ORDER_BY                    /* OBJECT, MEMORY, ACCESS, REMOTE */
    FROM
      DUMMY
  ) BI,
    M_METADATA_CACHE_STATISTICS M
  WHERE
    M.HOST LIKE BI.HOST AND
    TO_VARCHAR(M.PORT) LIKE BI.PORT AND
    M.CACHE_GROUP_NAME LIKE BI.CACHE_GROUP_NAME
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')   != 0 THEN M.HOST             ELSE MAP(BI.HOST,             '%', 'any', BI.HOST)             END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')   != 0 THEN TO_VARCHAR(M.PORT) ELSE MAP(BI.PORT,             '%', 'any', BI.PORT)             END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'OBJECT') != 0 THEN M.CACHE_GROUP_NAME ELSE MAP(BI.CACHE_GROUP_NAME, '%', 'any', BI.CACHE_GROUP_NAME) END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'OBJECT', CACHE_GROUP_NAME),
  MAP(ORDER_BY, 'MEMORY', MEM_MB, 'ACCESS', ACCESSES, 'REMOTE', REMOTE_CALLS) DESC