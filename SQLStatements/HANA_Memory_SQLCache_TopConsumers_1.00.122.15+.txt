SELECT
/* 

[NAME]

- HANA_Memory_SQLCache_TopConsumers_1.00.122.15+

[DESCRIPTION]

- List of table constellations responsible for highest amount of SQL plan cache allocation

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- ACCESSED_OBJECT_NAMES only available as of SAP HANA 1.00.90
- APPLICATION_SOURCE and APPLICATION_NAME in M_SQL_PLAN_CACHE available starting with Rev. 1.00.122.15 (and 2.00.012.04 / 2.00.024.00)

[VALID FOR]

- Revisions:              >= 1.00.122.15

[SQL COMMAND VERSION]

- 2015/01/27:  1.0 (initial version)
- 2015/02/25:  1.1 (INLIST evaluation included)
- 2015/02/26:  1.2 (AVG_PREP_MS included)
- 2015/05/18:  1.2 (AGGREGATE_BY = 'PREFIX' added)
- 2015/09/16:  1.3 (MIN_ENTRIES added, AGGREGATE_BY vs. COMP_AGGREGATE_BY)
- 2015/12/03:  1.4 (SHARING_TYPE added)
- 2015/12/15:  1.5 (REFERENCE_COUNT added)
- 2017/09/18:  1.6 (dedicated IN list length 100 added to properly address rsdb/max_in_blocking_factor = 100)
- 2017/12/13:  1.7 (proper percentage calculation in case of restrictions)
- 2020/04/18:  1.8 (dedicated 1.00.122.15+ version including APPLICATION_SOURCE)
- 2020/06/28:  1.9 (OR_CONCAT added)
- 2020/11/10:  2.0 (INVALIDATION and IS_VALID added)

[INVOLVED TABLES]

- M_SQL_PLAN_CACHE

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

- SQL_PATTERN

  Pattern for SQL text (case insensitive)

  'INSERT%'         --> SQL statements starting with INSERT
  '%DBTABLOG%'      --> SQL statements containing DBTABLOG
  '%'               --> All SQL statements

- ACCESSED_OBJECT_NAMES

  Pattern for accessed tables

  '%MARA%'          --> Only list statements with ACCESSED_OBJECT_NAMES including MARA
  '%'               --> No restriction to accessed tables

- IS_VALID

  Validity flag

  'FALSE'           --> Display only invalid SQL cache entries
  '%'               --> No restriction related to validity

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOST'          --> Aggregation by host
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation
  'ALL'           --> Complete aggregation

- COMP_AGGREGATE_BY

  SQL cache component aggregation approach

  'APP_SOURCE'      --> Aggregation by application source
  'DB_USER'         --> Aggregation by database user
  'HASH'            --> Aggregation by statement hash
  'INLIST'          --> Aggregation by IN LIST length (related to rsdb/max_in_blocking_factor format)
  'INVALIDATION'    --> Aggregation by last invalidation reason
  'OBJECT'          --> Aggregation by table name / object ID
  'OR_CONCAT'       --> Aggregation by OR concatenation length
  'PREFIX'          --> Aggregate by SQL text prefix (25 characters)
  'SHARING_TYPE'    --> Aggregation by plan sharing type
  'REFERENCE_COUNT' --> Aggregation by reference count

- MIN_SIZE_PCT

  Threshold for minimum size (%)

  5               --> Only display areas allocating at least 5 % of the overall memory consumption
  -1              --> No minimum size restriction

-[OUTPUT PARAMETERS]

- HOST:                 Host name
- PORT:                 Port
- SERVICE:              Service name
- SIZE_GB:              Size of statements (GB)
- SIZE_PCT:             Size compared to overall size (%)
- CUM_GB:               Cumulated size of statements (GB)
- CUM_PCT:              Cumulated size compared to overall size (%)
- PIN_GB:               Amount of memory pinned, i.e. REFERENCE_COUNT > 0 (GB)
- NUM_SQL:              Number of statements
- AVG_PREP_MS:          Average preparation time (ms)
- KB_PER_SQL:           Average size of statement (KB)
- STATEMENT_HASH_1:     Example statement hash 1
- STATEMENT_HASH_2:     Example statement hash 2
- AGGREGATION_CATEGORY: Depends on AGGREGATE_BY value:
                        'APP_SOURCE'      -> Application source
                        'DB_USER'         -> Database user
                        'HASH'            -> Statement hash
                        'INLIST'          -> Length categories of IN lists
                        'OBJECT'          -> List of accessed table names
                        'PREFIX'          -> List of SQL statement prefixes (25 characters)
                        'REFERENCE_COUNT' -> Number of references (0 if statement is not pinned)
                        'SHARING_TYPE'    -> List of plan sharing types

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST|PORT |SIZE_GB|SIZE_PCT|CUM_GB |CUM_PCT|PIN_GB|NUM_SQL|KB_PER_SQL|STATEMENT_HASH_1                |STATEMENT_HASH_2                |ACCESSED_OBJECT_NAMES                                                                                                                                                                          |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|any |  any|   1.33|   32.65|   1.33|  32.65|  0.00|   4879|    286.24|0001ac1d7a347e2e8cbcb0c3a1280682|fff7d27a08d5337cda79c98f425aeabb|SYS.RS_TABLES_(7), SYS.RS_COLUMNS_(4), SYS.VIRTUAL_TABLES_(5), SYS.VIRTUAL_COLUMNS_(4), SYS.CS_CONCAT_ATTRIBUTES_(1), SYS.CS_COLUMNS_(3), SYS.CS_TABLES_(6), SYS.DUMMY(1), SYS.P_DATATYPES_(3)|
|any |  any|   1.02|   25.14|   2.35|  57.79|  0.00|   4876|    220.57|0005dd95f25d70cee29a9542e9291ab9|fff766667bd025c90aafc90dd0787fb7|SYS.RS_TABLES_(7), SYS.P_INDEXES_(5), SYS.VIRTUAL_TABLES_(5), SYS.CS_TABLES_(6), SYS.DUMMY(1), SYS.P_INDEXCOLUMNS_(2)                                                                         |
|any |  any|   0.71|   17.43|   3.06|  75.23|  0.00|   4949|    150.69|000353158616d39789b7328a854bc119|fff01da159ed0f34f4ca9750e431c526|SYS.RS_TABLES_(7), SYS.P_INDEXES_(5), SYS.VIRTUAL_TABLES_(5), SYS.CS_TABLES_(6), SYS.DUMMY(1), SYS.SERIES_DATA_(4)                                                                            |
|any |  any|   0.31|    7.78|   3.38|  83.02|  0.00|    261|   1276.54|00c44c9f4e10db0c9d057f6745e87b39|fe5436fa465b19917bd4e42e259c6b9e|SAPBH1.RSR_CACHE_FFB(5)                                                                                                                                                                       |
|any |  any|   0.23|    5.81|   3.62|  88.83|  0.00|   4642|     53.60|000ed9cfaf3393cd015ff73b567eea23|fffe2ff5a887475ccf940e865c9394aa|(16)                                                                                                                                                                                          |
|any |  any|   0.12|    3.18|   3.75|  92.02|  0.00|   1288|    105.76|001ef2fa84410473a913d9ae30769a1b|fff6bebd1c38bb2d90b8e20c8b9a60bf|_SYS_BI.BIMC_PROPERTIES(124)                                                                                                                                                                  |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  SERVICE_NAME SERVICE,
  LPAD(TO_DECIMAL(S.SIZE_GB, 10, 2), 7) SIZE_GB,
  LPAD(TO_DECIMAL(MAP(TOTAL_SIZE_GB, 0, 0, S.SIZE_GB / TOTAL_SIZE_GB * 100), 10, 2), 8) SIZE_PCT,
  LPAD(TO_DECIMAL(SUM(S.SIZE_GB) OVER (ORDER BY S.SIZE_GB DESC), 10, 2), 7) CUM_GB,
  LPAD(TO_DECIMAL(SUM(MAP(TOTAL_SIZE_GB, 0, 0, S.SIZE_GB / TOTAL_SIZE_GB * 100)) OVER (ORDER BY S.SIZE_GB DESC), 10, 2), 7) CUM_PCT,
  LPAD(TO_DECIMAL(PINNED_GB, 10, 2), 6) PIN_GB,
  LPAD(NUM_STATEMENTS, 7) NUM_SQL,
  LPAD(TO_DECIMAL(AVG_PREP_MS, 10, 2), 11) AVG_PREP_MS,
  LPAD(TO_DECIMAL(KB_PER_STATEMENT, 10, 2), 10) KB_PER_SQL,
  STATEMENT_HASH_1,
  STATEMENT_HASH_2,
  AGGREGATION_CATEGORY
FROM
( SELECT
    HOST,
    PORT,
    SERVICE_NAME,
    AGGREGATION_CATEGORY,
    SIZE_GB,
    SUM(SIZE_GB) OVER () TOTAL_SIZE_GB,
    PINNED_GB,
    NUM_STATEMENTS,
    AVG_PREP_MS,
    MAP(NUM_STATEMENTS, 0, 0, SIZE_GB / NUM_STATEMENTS * 1024 * 1024) KB_PER_STATEMENT,
    STATEMENT_HASH_1,
    STATEMENT_HASH_2,
    MIN_SIZE_PCT,
    MIN_ENTRIES
  FROM
  ( SELECT
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')    != 0 THEN C.HOST             ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                 END HOST,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(C.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                 END PORT,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE') != 0 THEN S.SERVICE_NAME     ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME) END SERVICE_NAME,
      CASE COMP_AGGREGATE_BY 
        WHEN 'OBJECT'          THEN TO_VARCHAR(SUBSTR(C.ACCESSED_OBJECT_NAMES, 1, 5000))
        WHEN 'HASH'            THEN C.STATEMENT_HASH
        WHEN 'PREFIX'          THEN SUBSTR(C.STATEMENT_STRING, 1, 25)
        WHEN 'SHARING_TYPE'    THEN C.PLAN_SHARING_TYPE    
        WHEN 'REFERENCE_COUNT' THEN TO_VARCHAR(C.REFERENCE_COUNT) 
        WHEN 'DB_USER'         THEN C.USER_NAME
        WHEN 'APP_SOURCE'      THEN C.APPLICATION_SOURCE
        WHEN 'INVALIDATION'    THEN CASE 
                                      WHEN C.LAST_INVALIDATION_REASON LIKE 'OBJECT VERSION MISMATCH%' THEN 'OBJECT VERSION MISMATCH'
                                      WHEN C.LAST_INVALIDATION_REASON LIKE 'NON-USER-OID NOT FOUND%'  THEN 'NON-USER-OID NOT FOUND'
                                      ELSE C.LAST_INVALIDATION_REASON
                                    END
        WHEN 'INLIST' THEN 
          CASE
            WHEN LOCATE(STATEMENT_STRING, '(' || CHAR(63) || ',' || CHAR(32) || CHAR(63), 1, 100) != 0 THEN 'MULTI VALUE IN LIST (100 and above)'
            WHEN LOCATE(STATEMENT_STRING, '(' || CHAR(63) || ',' || CHAR(32) || CHAR(63), 1,  50) != 0 THEN 'MULTI VALUE IN LIST (50 - 99)'
            WHEN LOCATE(STATEMENT_STRING, '(' || CHAR(63) || ',' || CHAR(32) || CHAR(63), 1,  20) != 0 THEN 'MULTI VALUE IN LIST (20 - 49)'
            WHEN LOCATE(STATEMENT_STRING, '(' || CHAR(63) || ',' || CHAR(32) || CHAR(63), 1,  10) != 0 THEN 'MULTI VALUE IN LIST (10 - 19)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%' || RPAD('', 400, CHAR(63) || CHAR(32) || ',' || CHAR(32)) || '%' THEN 'SINGLE VALUE IN LIST (101 and above)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%' || RPAD('', 396, CHAR(63) || CHAR(32) || ',' || CHAR(32)) || '%' THEN 'SINGLE VALUE IN LIST (100)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%' || RPAD('', 196, CHAR(63) || CHAR(32) || ',' || CHAR(32)) || '%' THEN 'SINGLE VALUE IN LIST (50 - 99)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%' || RPAD('',  76, CHAR(63) || CHAR(32) || ',' || CHAR(32)) || '%' THEN 'SINGLE VALUE IN LIST (20 - 49)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%' || RPAD('',  36, CHAR(63) || CHAR(32) || ',' || CHAR(32)) || '%' THEN 'SINGLE VALUE IN LIST (10 - 19)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%(' || CHAR(32) || CHAR(63) || '%' THEN 'IN LIST (1 - 9)'
            ELSE 'NO IN LIST'
          END
        WHEN 'OR_CONCAT' THEN
          CASE
            WHEN LOCATE(STATEMENT_STRING, CHAR(32) || ') OR (' || CHAR(32), 1, 49) != 0 THEN 'MULTI VALUE OR CONCAT (50 and above)'
            WHEN LOCATE(STATEMENT_STRING, CHAR(32) || ') OR (' || CHAR(32), 1, 19) != 0 THEN 'MULTI VALUE OR CONCAT (20 - 49)'
            WHEN LOCATE(STATEMENT_STRING, CHAR(32) || ') OR (' || CHAR(32), 1,  9) != 0 THEN 'MULTI VALUE OR CONCAT (10 - 19)'
            WHEN LOCATE(STATEMENT_STRING, CHAR(32) || ') OR (' || CHAR(32), 1,  1) != 0 THEN 'MULTI VALUE OR CONCAT (2 - 9)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%' || RPAD('', 245, CHAR(32) || 'OR' || CHAR(32) || '%') THEN 'SINGLE VALUE OR CONCAT (50 and above)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%' || RPAD('', 95, CHAR(32) || 'OR' || CHAR(32) || '%') THEN 'SINGLE VALUE OR CONCAT (20 - 49)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%' || RPAD('', 45, CHAR(32) || 'OR' || CHAR(32) || '%') THEN 'SINGLE VALUE OR CONCAT (10 - 19)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%' || CHAR(32) || 'OR' || CHAR(32) || '%' THEN 'SINGLE VALUE OR CONCAT (2 - 9)'
            ELSE 'NO OR CONCAT'
          END
      END AGGREGATION_CATEGORY,
      SUM(C.PLAN_MEMORY_SIZE) / 1024 / 1024 / 1024 SIZE_GB,
      SUM(MAP(C.REFERENCE_COUNT, 0, 0, C.PLAN_MEMORY_SIZE)) / 1024 / 1024 / 1024 PINNED_GB,
      MAP(SUM(C.PREPARATION_COUNT), 0, 0, SUM(C.TOTAL_PREPARATION_TIME) / SUM(C.PREPARATION_COUNT) / 1000) AVG_PREP_MS,
      COUNT(*) NUM_STATEMENTS,
      MIN(C.STATEMENT_HASH) STATEMENT_HASH_1,
      MAX(C.STATEMENT_HASH) STATEMENT_HASH_2,
      BI.MIN_SIZE_PCT,
      BI.MIN_ENTRIES
    FROM
    ( SELECT                    /* Modification section */
        '%' HOST,
        '%' PORT,
        '%' SERVICE_NAME,
        '%' SQL_PATTERN,
        '%' ACCESSED_OBJECT_NAMES,
        '%' IS_VALID,
        'ALL' AGGREGATE_BY,                  /* HOST, PORT, SERVICE or comma separated combinations, NONE for no aggregation, ALL for complete aggregation */
        'OBJECT' COMP_AGGREGATE_BY,             /* DB_USER, OBJECT, INLIST, OR_CONCAT, PREFIX, HASH, SHARING_TYPE, REFERENCE_COUNT, APP_SOURCE, INVALIDATION */
        5 MIN_SIZE_PCT,
        -1 MIN_ENTRIES
      FROM
        DUMMY
    ) BI,
      M_SERVICES S,
      M_SQL_PLAN_CACHE C
    WHERE
      S.HOST LIKE BI.HOST AND
      TO_VARCHAR(S.PORT) LIKE BI.PORT AND
      S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
      C.HOST = S.HOST AND
      C.PORT = S.PORT AND
      C.IS_VALID LIKE BI.IS_VALID AND
      TO_VARCHAR(C.STATEMENT_STRING) LIKE BI.SQL_PATTERN AND
      TO_VARCHAR(SUBSTR(C.ACCESSED_OBJECT_NAMES, 1, 5000)) LIKE BI.ACCESSED_OBJECT_NAMES
    GROUP BY
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')    != 0 THEN C.HOST             ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                 END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(C.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                 END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE') != 0 THEN S.SERVICE_NAME     ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME) END,
      CASE COMP_AGGREGATE_BY 
        WHEN 'OBJECT'          THEN TO_VARCHAR(SUBSTR(C.ACCESSED_OBJECT_NAMES, 1, 5000))
        WHEN 'HASH'            THEN C.STATEMENT_HASH
        WHEN 'PREFIX'          THEN SUBSTR(C.STATEMENT_STRING, 1, 25)
        WHEN 'SHARING_TYPE'    THEN C.PLAN_SHARING_TYPE    
        WHEN 'REFERENCE_COUNT' THEN TO_VARCHAR(C.REFERENCE_COUNT) 
        WHEN 'DB_USER'         THEN C.USER_NAME
        WHEN 'APP_SOURCE'      THEN C.APPLICATION_SOURCE
        WHEN 'INVALIDATION'    THEN CASE 
                                      WHEN C.LAST_INVALIDATION_REASON LIKE 'OBJECT VERSION MISMATCH%' THEN 'OBJECT VERSION MISMATCH'
                                      WHEN C.LAST_INVALIDATION_REASON LIKE 'NON-USER-OID NOT FOUND%'  THEN 'NON-USER-OID NOT FOUND'
                                      ELSE C.LAST_INVALIDATION_REASON
                                    END
        WHEN 'INLIST' THEN 
          CASE
            WHEN LOCATE(STATEMENT_STRING, '(' || CHAR(63) || ',' || CHAR(32) || CHAR(63), 1, 100) != 0 THEN 'MULTI VALUE IN LIST (100 and above)'
            WHEN LOCATE(STATEMENT_STRING, '(' || CHAR(63) || ',' || CHAR(32) || CHAR(63), 1,  50) != 0 THEN 'MULTI VALUE IN LIST (50 - 99)'
            WHEN LOCATE(STATEMENT_STRING, '(' || CHAR(63) || ',' || CHAR(32) || CHAR(63), 1,  20) != 0 THEN 'MULTI VALUE IN LIST (20 - 49)'
            WHEN LOCATE(STATEMENT_STRING, '(' || CHAR(63) || ',' || CHAR(32) || CHAR(63), 1,  10) != 0 THEN 'MULTI VALUE IN LIST (10 - 19)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%' || RPAD('', 400, CHAR(63) || CHAR(32) || ',' || CHAR(32)) || '%' THEN 'SINGLE VALUE IN LIST (101 and above)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%' || RPAD('', 396, CHAR(63) || CHAR(32) || ',' || CHAR(32)) || '%' THEN 'SINGLE VALUE IN LIST (100)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%' || RPAD('', 196, CHAR(63) || CHAR(32) || ',' || CHAR(32)) || '%' THEN 'SINGLE VALUE IN LIST (50 - 99)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%' || RPAD('',  76, CHAR(63) || CHAR(32) || ',' || CHAR(32)) || '%' THEN 'SINGLE VALUE IN LIST (20 - 49)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%' || RPAD('',  36, CHAR(63) || CHAR(32) || ',' || CHAR(32)) || '%' THEN 'SINGLE VALUE IN LIST (10 - 19)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%(' || CHAR(32) || CHAR(63) || '%' THEN 'IN LIST (1 - 9)'
            ELSE 'NO IN LIST'
          END
        WHEN 'OR_CONCAT' THEN
          CASE
            WHEN LOCATE(STATEMENT_STRING, CHAR(32) || ') OR (' || CHAR(32), 1, 49) != 0 THEN 'MULTI VALUE OR CONCAT (50 and above)'
            WHEN LOCATE(STATEMENT_STRING, CHAR(32) || ') OR (' || CHAR(32), 1, 19) != 0 THEN 'MULTI VALUE OR CONCAT (20 - 49)'
            WHEN LOCATE(STATEMENT_STRING, CHAR(32) || ') OR (' || CHAR(32), 1,  9) != 0 THEN 'MULTI VALUE OR CONCAT (10 - 19)'
            WHEN LOCATE(STATEMENT_STRING, CHAR(32) || ') OR (' || CHAR(32), 1,  1) != 0 THEN 'MULTI VALUE OR CONCAT (2 - 9)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%' || RPAD('', 245, CHAR(32) || 'OR' || CHAR(32) || '%') THEN 'SINGLE VALUE OR CONCAT (50 and above)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%' || RPAD('', 95, CHAR(32) || 'OR' || CHAR(32) || '%') THEN 'SINGLE VALUE OR CONCAT (20 - 49)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%' || RPAD('', 45, CHAR(32) || 'OR' || CHAR(32) || '%') THEN 'SINGLE VALUE OR CONCAT (10 - 19)'
            WHEN TO_VARCHAR(STATEMENT_STRING) LIKE '%' || CHAR(32) || 'OR' || CHAR(32) || '%' THEN 'SINGLE VALUE OR CONCAT (2 - 9)'
            ELSE 'NO OR CONCAT'
          END
      END,
      BI.MIN_SIZE_PCT,
      BI.MIN_ENTRIES
  )
) S
WHERE
  ( MIN_SIZE_PCT = -1 OR MAP(TOTAL_SIZE_GB, 0, 0, SIZE_GB / TOTAL_SIZE_GB * 100) >= MIN_SIZE_PCT ) AND
  ( MIN_ENTRIES = -1 OR NUM_STATEMENTS >= MIN_ENTRIES )
ORDER BY
  S.SIZE_GB DESC
