WITH 

/* 

[NAME]

- HANA_SQL_SQLCache_CrossNodeJoins

[DESCRIPTION]

- Identification of cross node joins

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Identification of expensive cross node joins important in order to distribute tables optimally across nodes
- Not relevant for BW where table partitions are scattered optimally across different scale-out nodes
- Erroneous distributed executions may be reported when table replication is in place. You can configure REPLICA_TYPE = ' ' to ignore these statements.
- Also in a few other scenarios erroneous cross-node joins may be reported because the analysis is based on the SQL cache while the final plan may access only a subset of the involved tables.
- RESET can be performed via:

  ALTER SYSTEM RESET MONITORING VIEW M_SQL_PLAN_CACHE_RESET

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2020/01/09:  1.0 (initial version)
- 2020/01/20:  1.1 (GROUP_TYPE included)

[INVOLVED TABLES]

- HOST_SQL_PLAN_CACHE
- M_CS_TABLES
- M_RS_TABLES
- M_SQL_PLAN_CACHE
- M_SQL_PLAN_CACHE_RESET
- TABLE_GROUPS

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

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- STATEMENT_HASH      
 
  Hash of SQL statement to be analyzed

  '2e960d7535bf4134e2bd26b9d80bd4fa' --> SQL statement with hash '2e960d7535bf4134e2bd26b9d80bd4fa'
  '%'                                --> No statement hash restriction (only possible if hash is not mandatory)

- ACCESSED_TABLE_NAMES

  Accessed table names

  '%KONV%'        --> Only statements with accessed table names containing 'KONV'
  '%'             --> No restriction related to accessed table names

- STATEMENT_STRING

  Pattern for SQL text

  'INSERT%'       --> SQL statements starting with INSERT
  '%DBTABLOG%'    --> SQL statements containing DBTABLOG
  '%'             --> All SQL statements

- IS_DISTRIBUTED_EXECUTION

  Possibility to restrict result to distributed executions

  'TRUE'          --> Only show distributed executions (accessing multiple scale-out nodes)
  'FALSE'         --> Only show local executions (accessing only a single SAP HANA node)
  '%'             --> No restriction related to distributed executions

- REPLICA_TYPE

  Restrict results to table replication type

  ' '             --> Do not show statements with replicated tables
  'S'             --> Show statements involving tables with synchronous replication
  'A'             --> Show statements involving tables with asynchronous replication
  '%'             --> No restriction related to table replication

- ONLY_CROSS_NODE_JOIN

  Possibility to restrict the result to cross-node joins

  'X'             --> Only consider requests accessing more than a single SAP HANA node
  ' '             --> No restriction related to cross-node joins

- ONLY_MULTIPLE_INDEXSERVERS

  Possibility to restrict the result to requests involving multiple indexservers

  'X'             --> Only consider requests accessing more than a single indexserver
  ' '             --> No restriction related to number of indexservers

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_* tables)
  'HISTORY'       --> Data from persisted history information (HOST_* tables)
  'RESET'         --> Data from reset memory information (M_*_RESET tables)

- ORDER_BY

  Sort order (available values are provided in comment)

  'ELAPSED'       --> Sorting by elapsed time
  'EXECUTIONS'    --> Sorting by number of executions

[OUTPUT PARAMETERS]

- HOST:             Host (of SQL cache entry)
- PORT:             Port (of SQL cache entry)
- STATEMENT_HASH:   Statement hash
- ELAPSED_S:        Total elapsed time (s)
- EXECUTIONS:       Number of executions
- PER_EXEC_MS:      Elapsed time per execution (ms)
- ROWS:             Rows returned
- I:                Number of indexserver processes involved
- CNJ:              'X' in case of a cross-node join, otherwise ' '
- R:                'A' for asynchronous table replication, 'S' for synchronous table replication, ' ' for no table replication
- SCHEMA_NAME:      Schema name (of table)
- TABLE_NAME:       Table name
- TABLE_GROUP:      Table group
- TABLE_HOSTS:      Table hosts
- TABLE_PORTS:      Table ports
- STATEMENT_STRING: SQL text

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST    |PORT |STATEMENT_HASH                  |ELAPSED_S |EXECUTIONS  |PER_EXEC_MS|ROWS         |I|CNJ|R|SCHEMA_NAME|TABLE_NAME|TABLE_GROUP|TABLE_HOSTS|TABLE_PORTS|
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
|saphana6|30003|15ec7a6faa9ea270f4c59c881268c79a|       162|       33635|       4.82|          497|2|X  | |SAPERP     |SRGBINREL |           |saphana4   |30003      |
|        |     |                                |          |            |           |             | |   | |SAPERP     |SRRELROLES|           |saphana4   |30003      |
|        |     |                                |          |            |           |             | |   | |SAPERP     |VBAK      |SD_VBAK    |saphana6   |30003      |
|        |     |                                |          |            |           |             | |   | |SAPERP     |VBKA      |           |saphana4   |30003      |
|saphana4|30003|15ec7a6faa9ea270f4c59c881268c79a|       155|       33812|       4.60|          536|2|X  | |SAPERP     |SRGBINREL |           |saphana4   |30003      |
|        |     |                                |          |            |           |             | |   | |SAPERP     |SRRELROLES|           |saphana4   |30003      |
|        |     |                                |          |            |           |             | |   | |SAPERP     |VBAK      |SD_VBAK    |saphana6   |30003      |
|        |     |                                |          |            |           |             | |   | |SAPERP     |VBKA      |           |saphana4   |30003      |
|saphana6|30003|764598c92c82de8da0e62f576f2ec159|        19|        4186|       4.57|            0|2|X  | |SAPERP     |SRGBINREL |           |saphana4   |30003      |
|        |     |                                |          |            |           |             | |   | |SAPERP     |SRRELROLES|           |saphana4   |30003      |
|        |     |                                |          |            |           |             | |   | |SAPERP     |VBKA      |           |saphana4   |30003      |
|        |     |                                |          |            |           |             | |   | |SAPERP     |VBRK      |SD_VBAK    |saphana6   |30003      |
|saphana4|30003|764598c92c82de8da0e62f576f2ec159|        17|        4006|       4.38|            0|2|X  | |SAPERP     |SRGBINREL |           |saphana4   |30003      |
|        |     |                                |          |            |           |             | |   | |SAPERP     |SRRELROLES|           |saphana4   |30003      |
|        |     |                                |          |            |           |             | |   | |SAPERP     |VBKA      |           |saphana4   |30003      |
|        |     |                                |          |            |           |             | |   | |SAPERP     |VBRK      |SD_VBAK    |saphana6   |30003      |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

BASIS_INFO AS
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
    HOST,
    PORT,
    SCHEMA_NAME,
    STATEMENT_HASH,
    ACCESSED_TABLE_NAMES,
    STATEMENT_STRING,
    IS_DISTRIBUTED_EXECUTION,
    REPLICA_TYPE,
    ONLY_CROSS_NODE_JOIN,
    ONLY_MULTIPLE_INDEXSERVERS,
    DATA_SOURCE,
    ORDER_BY
  FROM
  ( SELECT                                                      /* Modification section */
      '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
      '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
      'SERVER' TIMEZONE,                              /* SERVER, UTC */
      '%' HOST,
      '%' PORT,
      'SAP%' SCHEMA_NAME,
      '%' STATEMENT_HASH,
      '%' ACCESSED_TABLE_NAMES,
      '%' STATEMENT_STRING,
      'TRUE' IS_DISTRIBUTED_EXECUTION,                    /* TRUE, FALSE, % */
      ' ' REPLICA_TYPE,
      ' ' ONLY_CROSS_NODE_JOIN,
      'X' ONLY_MULTIPLE_INDEXSERVERS,
      'CURRENT' DATA_SOURCE,     /* CURRENT, HISTORY, RESET */
      'ELAPSED' ORDER_BY        /* EXECUTIONS, ELAPSED, RECORDS */
    FROM
      DUMMY
  ) BI
),
SQL_CACHE AS
( SELECT
    C.*,
    ( SELECT COUNT(*) FROM M_SERVICES S WHERE /* S.SERVICE_NAME = 'indexserver' AND */ C.TABLE_LOCATIONS LIKE '%' || S.HOST || ':' || S.PORT || '%' ) NUM_INDEXSERVERS
  FROM
  ( SELECT
      ROW_NUMBER() OVER (ORDER BY MAP(BI.ORDER_BY, 'EXECUTIONS', C.EXECUTION_COUNT, 'ELAPSED', C.TOTAL_EXECUTION_TIME + C.TOTAL_PREPARATION_TIME, 'RECORDS', C.TOTAL_RESULT_RECORD_COUNT) DESC) ROWNO,
      'CURRENT' DATA_SOURCE,
      C.HOST,
      C.PORT,
      C.SCHEMA_NAME,
      C.STATEMENT_HASH,
      TO_VARCHAR(C.ACCESSED_TABLE_NAMES) ACCESSED_TABLE_NAMES,
      TO_VARCHAR(C.STATEMENT_STRING) STATEMENT_STRING,
      C.IS_DISTRIBUTED_EXECUTION,
      C.TABLE_LOCATIONS,
      C.EXECUTION_COUNT,
      C.TOTAL_RESULT_RECORD_COUNT,
      C.TOTAL_EXECUTION_TIME + C.TOTAL_PREPARATION_TIME TOTAL_ELAPSED_TIME
    FROM
      BASIS_INFO BI,
      M_SQL_PLAN_CACHE C
    WHERE
      BI.DATA_SOURCE = 'CURRENT' AND
      C.HOST LIKE BI.HOST AND
      TO_VARCHAR(C.PORT) LIKE BI.PORT AND
      C.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
      C.ACCESSED_TABLE_NAMES LIKE BI.ACCESSED_TABLE_NAMES AND
      C.STATEMENT_HASH LIKE BI.STATEMENT_HASH AND
      C.STATEMENT_STRING LIKE BI.STATEMENT_STRING AND
      C.IS_DISTRIBUTED_EXECUTION LIKE BI.IS_DISTRIBUTED_EXECUTION AND
      C.EXECUTION_COUNT > 0
    UNION ALL
    SELECT
      ROW_NUMBER() OVER (ORDER BY MAP(BI.ORDER_BY, 'EXECUTIONS', C.EXECUTION_COUNT, 'ELAPSED', C.TOTAL_EXECUTION_TIME + C.TOTAL_PREPARATION_TIME, 'RECORDS', C.TOTAL_RESULT_RECORD_COUNT) DESC) ROWNO,
      'RESET' DATA_SOURCE,
      C.HOST,
      C.PORT,
      C.SCHEMA_NAME,
      C.STATEMENT_HASH,
      TO_VARCHAR(C.ACCESSED_TABLE_NAMES) ACCESSED_TABLE_NAMES,
      TO_VARCHAR(C.STATEMENT_STRING) STATEMENT_STRING,
      C.IS_DISTRIBUTED_EXECUTION,
      C.TABLE_LOCATIONS,
      C.EXECUTION_COUNT,
      C.TOTAL_RESULT_RECORD_COUNT,
      C.TOTAL_EXECUTION_TIME + C.TOTAL_PREPARATION_TIME TOTAL_ELAPSED_TIME
    FROM
      BASIS_INFO BI,
      M_SQL_PLAN_CACHE_RESET C
    WHERE
      BI.DATA_SOURCE = 'RESET' AND
      C.HOST LIKE BI.HOST AND
      TO_VARCHAR(C.PORT) LIKE BI.PORT AND
      C.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
      C.ACCESSED_TABLE_NAMES LIKE BI.ACCESSED_TABLE_NAMES AND
      C.STATEMENT_HASH LIKE BI.STATEMENT_HASH AND
      C.STATEMENT_STRING LIKE BI.STATEMENT_STRING AND
      C.IS_DISTRIBUTED_EXECUTION LIKE BI.IS_DISTRIBUTED_EXECUTION AND
      C.EXECUTION_COUNT > 0
    UNION ALL
    SELECT
      ROW_NUMBER() OVER (ORDER BY MAP(BI.ORDER_BY, 'EXECUTIONS', SUM(C.EXECUTION_COUNT), 'ELAPSED', SUM(C.TOTAL_EXECUTION_TIME + C.TOTAL_PREPARATION_TIME), 'RECORDS', SUM(C.TOTAL_RESULT_RECORD_COUNT)) DESC) ROWNO,
      'HISTORY' DATA_SOURCE,
      C.HOST,
      C.PORT,
      C.SCHEMA_NAME,
      C.STATEMENT_HASH,
      TO_VARCHAR(C.ACCESSED_TABLE_NAMES) ACCESSED_TABLE_NAMES,
      TO_VARCHAR(C.STATEMENT_STRING) STATEMENT_STRING,
      C.IS_DISTRIBUTED_EXECUTION,
      C.TABLE_LOCATIONS,
      SUM(C.EXECUTION_COUNT) EXECUTION_COUNT,
      SUM(C.TOTAL_RESULT_RECORD_COUNT) TOTAL_RESULT_RECORD_COUNT,
      SUM(C.TOTAL_EXECUTION_TIME + C.TOTAL_PREPARATION_TIME) TOTAL_ELAPSED_TIME
    FROM
      BASIS_INFO BI,
      _SYS_STATISTICS.HOST_SQL_PLAN_CACHE C
    WHERE
      BI.DATA_SOURCE = 'HISTORY' AND
      CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(C.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE C.SERVER_TIMESTAMP END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
      C.HOST LIKE BI.HOST AND
      TO_VARCHAR(C.PORT) LIKE BI.PORT AND
      C.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
      C.ACCESSED_TABLE_NAMES LIKE BI.ACCESSED_TABLE_NAMES AND
      C.STATEMENT_HASH LIKE BI.STATEMENT_HASH AND
      C.STATEMENT_STRING LIKE BI.STATEMENT_STRING AND
      C.IS_DISTRIBUTED_EXECUTION LIKE BI.IS_DISTRIBUTED_EXECUTION AND
      C.EXECUTION_COUNT > 0
    GROUP BY
      C.HOST,
      C.PORT,
      C.SCHEMA_NAME,
      C.STATEMENT_HASH,
      TO_VARCHAR(C.ACCESSED_TABLE_NAMES),
      TO_VARCHAR(C.STATEMENT_STRING),
      C.IS_DISTRIBUTED_EXECUTION,
      C.TABLE_LOCATIONS,
      BI.ORDER_BY
  ) C
),
ACCESSED_TABLES AS
( SELECT
    *,
    ROW_NUMBER () OVER (PARTITION BY STATEMENT_HASH ORDER BY SCHEMA_NAME, TABLE_NAME) TABNO,
    ( SELECT MAX(GROUP_NAME) FROM TABLE_GROUPS G WHERE G.SCHEMA_NAME = T.SCHEMA_NAME AND G.TABLE_NAME = T.TABLE_NAME ) TABLE_GROUP,
    ( SELECT MAX(GROUP_TYPE) FROM TABLE_GROUPS G WHERE G.SCHEMA_NAME = T.SCHEMA_NAME AND G.TABLE_NAME = T.TABLE_NAME ) GROUP_TYPE,
    ( SELECT MAX(REPLICA_TYPE) FROM M_TABLE_REPLICAS R WHERE R.SCHEMA_NAME = T.SCHEMA_NAME AND R.TABLE_NAME = T.TABLE_NAME OR R.SOURCE_SCHEMA_NAME = T.SCHEMA_NAME AND R.SOURCE_TABLE_NAME = T.TABLE_NAME ) REPLICA_TYPE,
    ( SELECT STRING_AGG(HOST, ', ' ORDER BY HOST) FROM ( SELECT DISTINCT HOST FROM M_CS_TABLES CT WHERE CT.SCHEMA_NAME = T.SCHEMA_NAME AND CT.TABLE_NAME = T.TABLE_NAME ) ) CS_HOSTS,
    ( SELECT STRING_AGG(HOST, ', ' ORDER BY HOST) FROM ( SELECT DISTINCT HOST FROM M_RS_TABLES RT WHERE RT.SCHEMA_NAME = T.SCHEMA_NAME AND RT.TABLE_NAME = T.TABLE_NAME ) ) RS_HOSTS,
    ( SELECT STRING_AGG(PORT, ', ' ORDER BY PORT) FROM ( SELECT DISTINCT PORT FROM M_CS_TABLES CT WHERE CT.SCHEMA_NAME = T.SCHEMA_NAME AND CT.TABLE_NAME = T.TABLE_NAME ) ) CS_PORTS,
    ( SELECT STRING_AGG(PORT, ', ' ORDER BY PORT) FROM ( SELECT DISTINCT PORT FROM M_RS_TABLES RT WHERE RT.SCHEMA_NAME = T.SCHEMA_NAME AND RT.TABLE_NAME = T.TABLE_NAME ) ) RS_PORTS
  FROM
  ( SELECT
      STATEMENT_HASH,
      CASE
        WHEN TABLE_STRING LIKE '%.%' THEN SUBSTR(TABLE_STRING, 1, LOCATE(TABLE_STRING, '.', 1) - 1)
        ELSE TABLE_STRING
      END SCHEMA_NAME,
      CASE
        WHEN TABLE_STRING LIKE '%.%' THEN SUBSTR(TABLE_STRING, LOCATE(TABLE_STRING, '.', 1) + 1)
        ELSE ''
      END TABLE_NAME
    FROM
    ( SELECT
        STATEMENT_HASH,
        CASE 
          WHEN R.LINE_NO = 1 THEN SUBSTR(T.ACCESSED_TABLES, 1, LOCATE(T.ACCESSED_TABLES, '(', 1, 1) - 1)
          ELSE SUBSTR(T.ACCESSED_TABLES, LOCATE(T.ACCESSED_TABLES, ', ', 1, R.LINE_NO - 1) + 2, LOCATE(T.ACCESSED_TABLES, '(', 1, R.LINE_NO) - LOCATE(T.ACCESSED_TABLES, ', ', 1, R.LINE_NO - 1) - 2)
        END TABLE_STRING
      FROM
      ( SELECT TOP 100 ROW_NUMBER () OVER () LINE_NO FROM OBJECTS ) R,
      ( SELECT
          STATEMENT_HASH,
          ACCESSED_TABLE_NAMES ACCESSED_TABLES,
          LENGTH(ACCESSED_TABLE_NAMES) - LENGTH(REPLACE(ACCESSED_TABLE_NAMES, ',', '')) + 1 NUM_TABLES
        FROM
        ( SELECT DISTINCT
            STATEMENT_HASH,
            CASE /* remove schema if stored as first table */
              WHEN LOCATE(ACCESSED_TABLE_NAMES, '.') < LOCATE(ACCESSED_TABLE_NAMES, '(') THEN ACCESSED_TABLE_NAMES
              ELSE SUBSTR(ACCESSED_TABLE_NAMES, LOCATE(ACCESSED_TABLE_NAMES, CHAR(32), 1) + 1)
            END ACCESSED_TABLE_NAMES
          FROM 
            SQL_CACHE
        )
      ) T
      WHERE
        R.LINE_NO <= T.NUM_TABLES
    )
  ) T
)
SELECT
  MAP(TABNO, 1, HOST, '') HOST,
  MAP(TABNO, 1, LPAD(PORT, 5), '') PORT,
  MAP(TABNO, 1, STATEMENT_HASH, '') STATEMENT_HASH,
  MAP(TABNO, 1, LPAD(TO_DECIMAL(TOTAL_ELAPSED_TIME / 1000000, 10, 0), 10), '') ELAPSED_S,
  MAP(TABNO, 1, LPAD(EXECUTION_COUNT, 12), '') EXECUTIONS,
  MAP(TABNO, 1, LPAD(TO_DECIMAL(PER_EXEC_MS, 10, 2), 11), '') PER_EXEC_MS,
  MAP(TABNO, 1, LPAD(TOTAL_RESULT_RECORD_COUNT, 13), '') ROWS,
  MAP(TABNO, 1, TO_VARCHAR(NUM_INDEXSERVERS), '') I,
  MAP(TABNO, 1, CROSS_NODE_JOIN, '') CNJ,
  IFNULL(SUBSTR(REPLICA_TYPE, 1, 1), '') R,
  SCHEMA_NAME,
  TABLE_NAME,
  TABLE_GROUP,
  GROUP_TYPE,
  TABLE_HOSTS,
  TABLE_PORTS,
  MAP(TABNO, 1, STATEMENT_STRING, '') STATEMENT_STRING
FROM
( SELECT
    C.ROWNO,
    T.TABNO,
    C.HOST,
    C.PORT,
    C.STATEMENT_HASH,
    C.TOTAL_ELAPSED_TIME,
    C.EXECUTION_COUNT,
    MAP(C.EXECUTION_COUNT, 0, 0, C.TOTAL_ELAPSED_TIME / 1000 / C.EXECUTION_COUNT) PER_EXEC_MS,
    C.TOTAL_RESULT_RECORD_COUNT,
    T.SCHEMA_NAME,
    T.TABLE_NAME,
    IFNULL(T.TABLE_GROUP, '') TABLE_GROUP,
    IFNULL(T.GROUP_TYPE, '') GROUP_TYPE,
    T.REPLICA_TYPE,
    IFNULL(IFNULL(T.CS_HOSTS, T.RS_HOSTS), '') TABLE_HOSTS,
    IFNULL(IFNULL(T.CS_PORTS, T.RS_PORTS), '') TABLE_PORTS,
    C.STATEMENT_STRING,
    MAP(MIN(IFNULL(T.CS_HOSTS, T.RS_HOSTS)) OVER (PARTITION BY C.STATEMENT_HASH), MAX(IFNULL(T.CS_HOSTS, T.RS_HOSTS)) OVER (PARTITION BY C.STATEMENT_HASH), ' ', 'X') CROSS_NODE_JOIN,
    MAX(T.REPLICA_TYPE) OVER (PARTITION BY C.HOST, C.PORT, C.STATEMENT_HASH) REPLICA_TYPE_STATEMENT,
    C.NUM_INDEXSERVERS,
    BI.ONLY_CROSS_NODE_JOIN,
    BI.ONLY_MULTIPLE_INDEXSERVERS,
    BI.REPLICA_TYPE BI_REPLICA_TYPE
  FROM
    BASIS_INFO BI,
    SQL_CACHE C,
    ACCESSED_TABLES T
  WHERE
    C.STATEMENT_HASH = T.STATEMENT_HASH 
)
WHERE
  ( ONLY_CROSS_NODE_JOIN = ' ' OR CROSS_NODE_JOIN = 'X' ) AND
  ( ONLY_MULTIPLE_INDEXSERVERS = ' ' OR NUM_INDEXSERVERS >= 2 ) AND
  IFNULL(SUBSTR(REPLICA_TYPE_STATEMENT, 1, 1), ' ') LIKE BI_REPLICA_TYPE
ORDER BY
  ROWNO,
  TABNO