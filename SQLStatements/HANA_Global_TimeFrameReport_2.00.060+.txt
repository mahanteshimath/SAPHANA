WITH 

/*

[NAME]

- HANA_Global_TimeFrameReport_2.00.060+

[DESCRIPTION]

- Collection of historic performance information for a specified time frame

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- WITH clause requires at least Rev. 1.00.70
- WITH clause does not work with older DBACOCKPIT transactions before SAP BASIS 7.02 SP16 / 7.30 SP12 / 7.31 SP12 / SAP_BASIS 7.40 SP07 (empty result returned) 
- HOST_LOAD_HISTORY_SERVICE and HOST_LOAD_HISTORY_HOST not available before Rev. 1.00.120
- HOST_JOB_HISTORY not available before Rev. 1.00.120
- Delta values in HOST_VOLUME_IO_TOTAL_STATISTICS and HOST_SERVICE_STATISTICS not available before Rev. 1.00.120
- M_SYSTEM_REPLICATION_TAKEOVER_HISTORY available with SAP HANA >= 2.00.030
- GLOBAL_DISK_USAGE available with SAP HANA >= 2.00.040
- HOST_COLUMN_TABLES_PART_SIZE.PERSISTENT_MEMORY_SIZE_IN_TOTAL available with SAP HANA >= 2.00.043
- SITE_ID in history tables available with SAP HANA >= 2.0 SPS 06
- Various histories (e.g. HOST_SQL_PLAN_CACHE, HOST_SQL_PLAN_CACHE_OVERVIEW, M_CS_UNLOADS, M_CS_LOADS, HOST_JOB_HISTORY) do not contain different site IDs and so always the
  information of the primary site is shown

[VALID FOR]

- Revisions:              >= 2.00.060

[SQL COMMAND VERSION]

- 2016/08/21:  1.0 (initial version)
- 2016/12/22:  1.1 (table optimization and backup top list included)
- 2017/06/28:  1.2 (THREAD_METHOD overview included)
- 2017/08/08:  1.3 (MEMORY section refined)
- 2017/09/21:  1.4 (EXPENSIVE STATEMENTS, EXECUTED STATEMENTS and TRACE FILE ENTRIES sections added)
- 2017/10/24:  1.5 (TIMEZONE included)
- 2017/11/14:  1.6 (LINE_LENGTH included)
- 2017/12/27:  1.7 ("Database name" and "Revision level" included)
- 2018/01/07:  1.8 ('SERVICE STATISTICS' included)
- 2018/12/04:  1.9 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2019/05/16:  2.0 (dedicated 2.00.030+ version including M_SYSTEM_REPLICATION_TAKEOVER_HISTORY)
- 2019/07/28:  2.1 (dedicated 2.00.040+ version including GLOBAL_DISK_USAGE)
- 2020/08/15:  2.2 (dedicated 2.00.043+ version including HOST_COLUMN_TABLES_PART_SIZE.PERSISTENT_MEMORY_SIZE_IN_TOTAL)
- 2021/09/11:  2.3 (PASSPORT_COMPONENT and PASSPORT_ACTION included)
- 2022/05/24:  1.6 (dedicated 2.00.060+ version including SITE_ID)

[INVOLVED TABLES]

- GLOBAL_DISK_USAGE
- GLOBAL_ROWSTORE_TABLES_SIZE
- GLOBAL_TABLE_PERSISTENCE_STATISTICS
- HOST_BLOCKED_TRANSACTIONS
- HOST_COLUMN_TABLES_PART_SIZE
- HOST_DELTA_MERGE_STATISTICS
- HOST_HEAP_ALLOCATORS
- HOST_JOB_HISTORY
- HOST_LOAD_HISTORY_HOST
- HOST_LOAD_HISTORY_SERVICE
- HOST_LONG_IDLE_CURSOR
- HOST_LONG_RUNNING_STATEMENTS
- HOST_RESOURCE_UTILIZATION_STATISTICS
- HOST_RS_INDEXES
- HOST_SAVEPOINTS 
- HOST_SERVICE_REPLICATION
- HOST_SERVICE_STATISTICS
- HOST_SERVICE_THREAD_SAMPLES
- HOST_SQL_PLAN_CACHE
- HOST_VOLUME_IO_TOTAL_STATISTICS
- HOST_WORKLOAD
- M_BACKUP_CATALOG
- M_BACKUP_CATALOG_FILES
- M_CS_LOADS
- M_CS_UNLOADS
- M_SYSTEM_REPLICATION_TAKEOVER_HISTORY

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

- SITE_ID

  System replication site ID

  -1             --> No restriction related to site ID
  1              --> Site id 1

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

- THREAD_HISTORY_INTERVAL_S

  Filtering interval of HOST_SERVICE_THREAD_SAMPLES 

  50              --> Filtering of every 50th timestamp (default)
  10              --> Filtering of every 1th timestamp (only adjust in case of deviation from the SAP standard)

- TOP_N_CS_SIZE

  Number of top tables in terms of column store size

  10              --> Display top 10 tables in terms of column store size

- TOP_N_RS_SIZE

  Number of top tables in terms of row store size to be displayed

  10              --> Display top 10 tables in row store

- TOP_N_DISK

  Number of top tables on disk to be displayed

  20              --> Display top 20 tables on disk

- TOP_N_BLOCKED_TRANSACTIONS

  Number of blocked transactions to be displayed

  5              --> Display top 5 blocked transactions

- TOP_N_MEMORY

  Number of top memory areas

  10              --> Display top 10 heap allocators

- TOP_N_IDLE_CURSORS

  Number of longest idle cursors

  5               --> Show the 5 longest idle cursors

- TOP_N_LONGRUNNERS

  Number of long, old active statements

  5               --> Show the 5 longest running active statements

- TOP_N_SQL_TIME

  Number of top statement hashes in SQL cache to be displayed in terms of time

  20              --> Display top 20 statement hashes in SQL cache in terms of time

- TOP_N_SQL_EXECUTIONS

  Number of top statement hashes in SQL cache to be displayed in terms of executions

  10              --> Display top 10 statement hashes in SQL cache in terms of executions

- TOP_N_SQL_RECORDS

  Number of top statement hashes in SQL cache to be displayed in terms of records

  10              --> Display top 10 statement hashes in SQL cache in terms of records

- TOP_N_EXPENSIVE_SQL_TIME

  Number of top statement hashes in expensive statements trace to be displayed in terms of time

  10              --> Display top 10 statement hashes in expensive statements trace in terms of time

- TOP_N_EXECUTED_SQL_TIME

  Number of top statement hashes in executed statements trace to be displayed in terms of time

  10              --> Display top 10 statement hashes in executed statements trace in terms of time

- TOP_N_THREAD_SQL

  Number of top thread statement hashes to be displayed

  5               --> Display top 5 thread statement hashes

- TOP_N_THREAD_TYPES

  Number of top thread types to be displayed

  5               --> Display top 5 thread types

- TOP_N_THREAD_STATES_AND_LOCKS

  Number of top thread states and locks to be displayed

  10              --> Display top 10 thread states / locks

- TOP_N_THREAD_METHODS

  Number of top thread methods

  10              --> Display top 10 thread methods

- TOP_N_THREAD_DB_USERS

  Number of top thread database users to be displayed

  5              --> Display top 10 thread database users

- TOP_N_THREAD_APP_USERS

  Number of top thread application users to be displayed

  5              --> Display top 10 thread application users

- TOP_N_THREAD_APP_NAMES

  Number of top thread applications to be displayed

  5              --> Display top 10 thread applications

- TOP_N_THREAD_APP_SOURCES

  Number of top thread application sources to be displayed

  5              --> Display top 10 thread application sources

- TOP_N_THREAD_PASSPORT_COMPONENTS

  Number of top thread passport components to be displayed, top N is considered for both time intervals

  5              --> Display top 10 thread passport components for both time intervals

- TOP_N_THREAD_PASSPORT_ACTIONS

  Number of top thread passport actions to be displayed, top N is considered for both time intervals

  5              --> Display top 10 thread passport actions for both time intervals

- TOP_N_THREAD_HOST_PORTS

  Number of thread host / port combinations to be displayed

  5              --> Display top 5 thread host / port combination

- TOP_N_TABLE_OPTIMIZATION_TIME

  Number of thread host / port combinations to be displayed

  10             --> Display top 10 table optimization activities (e.g. merge, compression optimization) in terms of runtime

- TOP_N_TRACE_ENTRIES

  Number of (non-info) database trace entries

  30             --> Display 30 latest database trace entries with level different from 'Info'

- LINE_LENGTH

  Maximum displayed line size

  50              --> Lines are truncated at 50 characters
  -1              --> No line truncation

[OUTPUT PARAMETERS]

- LINE: Timeframe report (use monospaced output for optimal display)

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|LINE                                                                                                                                                                                                   |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|*****************************                                                                                                                                                                          |
|* SAP HANA TIMEFRAME REPORT *                                                                                                                                                                          |
|*****************************                                                                                                                                                                          |
|                                                                                                                                                                                                       |
|Start time:         2016/07/09 12:51:25                                                                                                                                                                |
|End time:           2016/08/21 12:51:25                                                                                                                                                                |
|Duration:           3715200 s                                                                                                                                                                          |
|Host:               all                                                                                                                                                                                |
|Port:               all                                                                                                                                                                                |
|                                                                                                                                                                                                       |
|*********************                                                                                                                                                                                  |
|* WORKLOAD OVERVIEW *                                                                                                                                                                                  |
|*********************                                                                                                                                                                                  |
|                                                                                                                                                                                                       |
|ACTIVITY                           TOTAL     RATE_PER_SECOND                                                                                                                                           |
|==================== =================== ===================                                                                                                                                           |
|Executions                     777261197              209.21                                                                                                                                           |
|Compilations                   566840742              152.57                                                                                                                                           |
|Update transactions             30323723                8.16                                                                                                                                           |
|Commits                        586450070              157.85                                                                                                                                           |
|Rollbacks                          39453                0.01                                                                                                                                           |
|                                                                                                                                                                                                       |
|********************                                                                                                                                                                                   |
|* SYSTEM RESOURCES *                                                                                                                                                                                   |
|********************                                                                                                                                                                                   |
|                                                                                                                                                                                                       |
|HOST                  AVG_CPU_IDLE  MIN_CPU_IDLE  AVG_CPU_USER  MAX_CPU_USER  AVG_CPU_SYS  MAX_CPU_SYS  AVG_CPU_IO  MAX_CPU_IO                                                                         |
|==================== ============= ============= ============= ============= ============ ============ =========== ===========                                                                         |
|saphana                      78.53          5.89          1.28         74.76         0.24         4.33        0.05        7.13                                                                         |
|                                                                                                                                                                                                       |
|HOST                 PHYS_GB PHYS_USED_GB ALLOC_LIM_GB INST_ALLOC_GB INST_USED_GB SHARED_GB                                                                                                            |
|==================== ======= ============ ============ ============= ============ =========                                                                                                            |
|saphana               371.23       371.23       361.32        361.20       320.38      4.91                                                                                                            |
|                                                                                                                                                                                                       |
...
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/  

BASIS_INFO AS
( SELECT
    GREATEST(ADD_DAYS(CURRENT_TIMESTAMP, -HISTORY_RETENTION_DAYS - 1), CASE TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(BEGIN_TIME, SECONDS_BETWEEN(CURRENT_UTCTIMESTAMP, CURRENT_TIMESTAMP)) ELSE BEGIN_TIME END) BEGIN_TIME,
    LEAST(CURRENT_TIMESTAMP, CASE TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(END_TIME, SECONDS_BETWEEN(CURRENT_UTCTIMESTAMP, CURRENT_TIMESTAMP)) ELSE END_TIME END) END_TIME,
    GREATEST(ADD_DAYS(CURRENT_TIMESTAMP, -HISTORY_RETENTION_DAYS - 1), BEGIN_TIME) BEGIN_TIME_ORIG,
    LEAST(CURRENT_TIMESTAMP, END_TIME) END_TIME_ORIG,
    SECONDS_BETWEEN(GREATEST(ADD_DAYS(CURRENT_TIMESTAMP, -HISTORY_RETENTION_DAYS - 1), BEGIN_TIME), LEAST(CURRENT_TIMESTAMP, END_TIME)) SECONDS,
    SITE_ID,
    HOST,
    PORT,
    THREAD_HISTORY_INTERVAL_S,
    TOP_N_CS_SIZE,
    TOP_N_RS_SIZE,
    TOP_N_DISK,
    TOP_N_BLOCKED_TRANSACTIONS,
    TOP_N_MEMORY,
    TOP_N_IDLE_CURSORS,
    TOP_N_LONGRUNNERS,
    TOP_N_SQL_TIME,
    TOP_N_SQL_EXECUTIONS,
    TOP_N_SQL_RECORDS,
    TOP_N_EXPENSIVE_SQL_TIME,
    TOP_N_EXECUTED_SQL_TIME,
    TOP_N_THREAD_SQL,
    TOP_N_THREAD_TYPES,
    TOP_N_THREAD_STATES_AND_LOCKS,
    TOP_N_THREAD_METHODS,
    TOP_N_THREAD_DB_USERS,
    TOP_N_THREAD_APP_USERS,
    TOP_N_THREAD_APP_NAMES,
    TOP_N_THREAD_APP_SOURCES,
    TOP_N_THREAD_PASSPORT_COMPONENTS,
    TOP_N_THREAD_PASSPORT_ACTIONS,
    TOP_N_THREAD_HOST_PORTS,
    TOP_N_TABLE_OPTIMIZATIONS,
    TOP_N_TRACE_ENTRIES,
    LINE_LENGTH
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
      SITE_ID,
      HOST,
      PORT,
      THREAD_HISTORY_INTERVAL_S,
      TOP_N_CS_SIZE,
      TOP_N_RS_SIZE,
      TOP_N_DISK,
      TOP_N_BLOCKED_TRANSACTIONS,
      TOP_N_MEMORY,
      TOP_N_IDLE_CURSORS,
      TOP_N_LONGRUNNERS,
      TOP_N_SQL_TIME,
      TOP_N_SQL_EXECUTIONS,
      TOP_N_SQL_RECORDS,
      TOP_N_EXPENSIVE_SQL_TIME,
      TOP_N_EXECUTED_SQL_TIME,
      TOP_N_THREAD_SQL,
      TOP_N_THREAD_TYPES,
      TOP_N_THREAD_STATES_AND_LOCKS,
      TOP_N_THREAD_METHODS,
      TOP_N_THREAD_DB_USERS,
      TOP_N_THREAD_APP_USERS,
      TOP_N_THREAD_APP_NAMES,
      TOP_N_THREAD_APP_SOURCES,
      TOP_N_THREAD_PASSPORT_COMPONENTS,
      TOP_N_THREAD_PASSPORT_ACTIONS,
      TOP_N_THREAD_HOST_PORTS,
      TOP_N_TABLE_OPTIMIZATIONS,
      TOP_N_TRACE_ENTRIES,
      LINE_LENGTH
    FROM
    ( SELECT                      /* Modification section */
        'C-D1' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        'C' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        'SERVER' TIMEZONE,                              /* SERVER, UTC */
        -1 SITE_ID,
        '%' HOST,
        '%' PORT,
        50 THREAD_HISTORY_INTERVAL_S,
        10 TOP_N_CS_SIZE,
         5 TOP_N_RS_SIZE,
        10 TOP_N_DISK,
         5 TOP_N_BLOCKED_TRANSACTIONS,
        20 TOP_N_MEMORY,
         5 TOP_N_IDLE_CURSORS,
         5 TOP_N_LONGRUNNERS,
        20 TOP_N_SQL_TIME,
        10 TOP_N_SQL_EXECUTIONS,
        10 TOP_N_SQL_RECORDS,
        10 TOP_N_EXPENSIVE_SQL_TIME,
        10 TOP_N_EXECUTED_SQL_TIME,
        20 TOP_N_THREAD_SQL,
        10 TOP_N_THREAD_TYPES,
        10 TOP_N_THREAD_STATES_AND_LOCKS,
        10 TOP_N_THREAD_METHODS,
         3 TOP_N_THREAD_DB_USERS,
         3 TOP_N_THREAD_APP_USERS,
         5 TOP_N_THREAD_APP_NAMES,
         5 TOP_N_THREAD_APP_SOURCES,
         5 TOP_N_THREAD_PASSPORT_COMPONENTS,
         5 TOP_N_THREAD_PASSPORT_ACTIONS,
         5 TOP_N_THREAD_HOST_PORTS,
        10 TOP_N_TABLE_OPTIMIZATIONS,
        30 TOP_N_TRACE_ENTRIES,
       200 LINE_LENGTH
      FROM
        DUMMY
    )
  ),
  ( SELECT MAX(IFNULL(RETENTION_DAYS_CURRENT, RETENTION_DAYS_DEFAULT)) HISTORY_RETENTION_DAYS FROM _SYS_STATISTICS.STATISTICS_SCHEDULE )
),
SQLHIST AS
( SELECT
    STATEMENT_HASH,
    SQL_TYPE,
    DURATION_S ELAPSED_S,
    ACCESSED_OBJECTS,
    EXECUTIONS,
    RECORDS,
    CASE WHEN DR <= TOP_N_SQL_TIME THEN 'X' ELSE ' ' END TOP_TIME,
    CASE WHEN ER <= TOP_N_SQL_EXECUTIONS THEN 'X' ELSE ' ' END TOP_EXECUTIONS,
    CASE WHEN RR <= TOP_N_SQL_RECORDS THEN 'X' ELSE ' ' END TOP_RECORDS
  FROM
  ( SELECT
      ROW_NUMBER () OVER (ORDER BY DURATION_S DESC) DR,
      ROW_NUMBER () OVER (ORDER BY EXECUTIONS DESC) ER,
      ROW_NUMBER () OVER (ORDER BY RECORDS DESC) RR,
      STATEMENT_HASH,
      CASE
        WHEN STATEMENT_STRING_CLEANED LIKE 'ALTER INDEX%'       THEN 'AI'
        WHEN STATEMENT_STRING_CLEANED LIKE 'ALTER SYSTEM%'      THEN 'AS'
        WHEN STATEMENT_STRING_CLEANED LIKE 'ALTER TABLE%'       THEN 'AT'
        WHEN STATEMENT_STRING_CLEANED LIKE 'ALTER%'             THEN 'AL'
        WHEN STATEMENT_STRING_CLEANED LIKE 'CALL%'              THEN 'CA'
        WHEN STATEMENT_STRING_CLEANED LIKE 'COMMIT%'            THEN 'CO'
        WHEN STATEMENT_STRING_CLEANED LIKE 'CREATE INDEX%'      THEN 'CI'
        WHEN STATEMENT_STRING_CLEANED LIKE 'CREATE TABLE%'      THEN 'CT'
        WHEN STATEMENT_STRING_CLEANED LIKE 'CREATE%'            THEN 'CR'
        WHEN STATEMENT_STRING_CLEANED LIKE 'DELETE%'            THEN 'DE'
        WHEN STATEMENT_STRING_CLEANED LIKE 'DROP INDEX%'        THEN 'DI'
        WHEN STATEMENT_STRING_CLEANED LIKE 'DROP TABLE%'        THEN 'DT'
        WHEN STATEMENT_STRING_CLEANED LIKE 'DROP%'              THEN 'DR'
        WHEN STATEMENT_STRING_CLEANED LIKE 'EXECUTE%'           THEN 'EX'
        WHEN STATEMENT_STRING_CLEANED LIKE 'INSERT%'            THEN 'IN'
        WHEN STATEMENT_STRING_CLEANED LIKE 'REPLACE%'           THEN 'RE'
        WHEN STATEMENT_STRING_CLEANED LIKE 'ROLLBACK%'          THEN 'RO'
        WHEN STATEMENT_STRING_CLEANED LIKE 'SELECT%FOR UPDATE%' THEN 'SU'
        WHEN STATEMENT_STRING_CLEANED LIKE 'SELECT%'            THEN 'SE'
        WHEN STATEMENT_STRING_CLEANED LIKE 'TRUNCATE%'          THEN 'TR'
        WHEN STATEMENT_STRING_CLEANED LIKE 'UPDATE%'            THEN 'UP'
        WHEN STATEMENT_STRING_CLEANED LIKE 'UPSERT%'            THEN 'US'
        WHEN STATEMENT_STRING_CLEANED LIKE 'WITH%'              THEN 'WI'
        ELSE 'unknown'
      END SQL_TYPE,
      ACCESSED_OBJECTS,
      DURATION_S,
      EXECUTIONS,
      RECORDS,
      TOP_N_SQL_TIME,
      TOP_N_SQL_EXECUTIONS,
      TOP_N_SQL_RECORDS
    FROM
    ( SELECT
        S.STATEMENT_HASH,
        REPLACE(UPPER(LTRIM(MAP(SUBSTR(TO_VARCHAR(STATEMENT_STRING), 1, 2), '/*', SUBSTR(TO_VARCHAR(STATEMENT_STRING), LOCATE(TO_VARCHAR(STATEMENT_STRING), '*/') + 2), TO_VARCHAR(STATEMENT_STRING)), ' ({')), CHAR(10), '') STATEMENT_STRING_CLEANED,
        MAX(TO_VARCHAR(S.ACCESSED_OBJECT_NAMES)) ACCESSED_OBJECTS,
        SUM(TO_DOUBLE(TO_BIGINT(S.TOTAL_EXECUTION_TIME + S.TOTAL_PREPARATION_TIME))) / 1000000 DURATION_S,
        SUM(S.EXECUTION_COUNT) EXECUTIONS,
        SUM(S.TOTAL_RESULT_RECORD_COUNT) RECORDS,
        BI.TOP_N_SQL_TIME,
        BI.TOP_N_SQL_EXECUTIONS,
        BI.TOP_N_SQL_RECORDS
      FROM
        BASIS_INFO BI,
       _SYS_STATISTICS.HOST_SQL_PLAN_CACHE S
      WHERE
        S.SERVER_TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
        S.HOST LIKE BI.HOST AND
        TO_VARCHAR(S.PORT) LIKE BI.PORT
      GROUP BY
        S.STATEMENT_HASH,
        TO_VARCHAR(S.STATEMENT_STRING),
        BI.TOP_N_SQL_TIME,
        BI.TOP_N_SQL_EXECUTIONS,
        BI.TOP_N_SQL_RECORDS
    )
  )
  WHERE
    DR <= TOP_N_SQL_TIME OR
    ER <= TOP_N_SQL_EXECUTIONS OR
    RR <= TOP_N_SQL_RECORDS
),
THREADS AS
( SELECT
    T.HOST,
    T.PORT,
    CASE
      WHEN T.STATEMENT_HASH = CHAR(63) THEN 'no SQL (' || MAP(T.THREAD_METHOD, CHAR(63), T.THREAD_TYPE, T.THREAD_METHOD) || ')'
      ELSE T.STATEMENT_HASH
    END STATEMENT_HASH,
    CASE
      WHEN T.THREAD_TYPE LIKE 'JobWrk%' THEN 'JobWorker'
      ELSE T.THREAD_TYPE
    END THREAD_TYPE,
    T.THREAD_METHOD,
    T.THREAD_STATE,
    SUBSTR(T.LOCK_WAIT_NAME, MAP(INSTR(T.LOCK_WAIT_NAME, ':' || CHAR(32)), 0, 1, INSTR(T.LOCK_WAIT_NAME, ':' || CHAR(32)) + 2)) LOCK_NAME,
    T.USER_NAME DB_USER,
    T.APPLICATION_USER_NAME APP_USER,
    T.APPLICATION_NAME APP_NAME,
    T.APPLICATION_SOURCE APP_SOURCE,
    T.PASSPORT_COMPONENT_NAME PASSPORT_COMPONENT,
    T.PASSPORT_ACTION,
    COUNT(*) NUM_SAMPLES,
    COUNT(*) / BI.SECONDS * BI.THREAD_HISTORY_INTERVAL_S ACT_THR,
    COUNT(*) / (SUM(COUNT(*)) OVER () + 0.01) * 100 THR_PCT,
    MAX(LENGTH(T.HOST)) OVER () HOST_LEN
  FROM
    BASIS_INFO BI,
    _SYS_STATISTICS.HOST_SERVICE_THREAD_SAMPLES T
  WHERE
    T.TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND T.SITE_ID IN (-1, 0) ) OR T.SITE_ID = BI.SITE_ID ) AND
    T.HOST LIKE BI.HOST AND
    TO_VARCHAR(T.PORT) LIKE BI.PORT
  GROUP BY
    T.HOST,
    T.PORT,
    CASE
      WHEN T.STATEMENT_HASH = CHAR(63) THEN 'no SQL (' || MAP(T.THREAD_METHOD, CHAR(63), T.THREAD_TYPE, T.THREAD_METHOD) || ')'
      ELSE T.STATEMENT_HASH
    END,
    T.THREAD_TYPE,
    T.THREAD_STATE,
    T.THREAD_METHOD,
    T.LOCK_WAIT_NAME,
    T.USER_NAME,
    T.APPLICATION_USER_NAME,
    T.APPLICATION_NAME,
    T.APPLICATION_SOURCE,
    T.PASSPORT_COMPONENT_NAME,
    T.PASSPORT_ACTION,
    BI.SECONDS,
    BI.THREAD_HISTORY_INTERVAL_S
),
IO_TOTAL_STATISTICS AS
( SELECT
    SERVER_TIMESTAMP,
    SITE_ID,
    HOST,
    PORT,
    TYPE,
    CASE WHEN TOTAL_READ_TIME_DELTA < 0 THEN TOTAL_READ_TIME ELSE TOTAL_READ_TIME_DELTA END TOTAL_READ_TIME,
    CASE WHEN TOTAL_WRITE_TIME_DELTA < 0 THEN TOTAL_WRITE_TIME ELSE TOTAL_WRITE_TIME_DELTA END TOTAL_WRITE_TIME,
    CASE WHEN TOTAL_READ_SIZE_DELTA < 0 THEN TOTAL_READ_SIZE ELSE TOTAL_READ_SIZE_DELTA END TOTAL_READ_SIZE,
    CASE WHEN TOTAL_WRITE_SIZE_DELTA < 0 THEN TOTAL_WRITE_SIZE ELSE TOTAL_WRITE_SIZE_DELTA END TOTAL_WRITE_SIZE,
    CASE WHEN TOTAL_READS_DELTA < 0 THEN TOTAL_READS + TOTAL_TRIGGER_ASYNC_READS ELSE TOTAL_READS_DELTA + TOTAL_TRIGGER_ASYNC_READS - LAG(TOTAL_TRIGGER_ASYNC_READS, 1) OVER (PARTITION BY HOST, PORT, TYPE ORDER BY SERVER_TIMESTAMP) END TOTAL_READS,
    CASE WHEN TOTAL_WRITES_DELTA < 0 THEN TOTAL_WRITES + TOTAL_TRIGGER_ASYNC_WRITES ELSE TOTAL_WRITES_DELTA + TOTAL_TRIGGER_ASYNC_WRITES - LAG(TOTAL_TRIGGER_ASYNC_WRITES, 1) OVER (PARTITION BY HOST, PORT, TYPE ORDER BY SERVER_TIMESTAMP) END TOTAL_WRITES,
    MAX(LENGTH(HOST)) OVER () HOST_LEN
  FROM
    _SYS_STATISTICS.HOST_VOLUME_IO_TOTAL_STATISTICS
),
IO_TOTAL_STATISTICS_HOUR AS
( SELECT
    TO_VARCHAR(SERVER_TIMESTAMP, 'YYYY/MM/DD HH24') TIMESTAMP_HOUR,
    SITE_ID,
    HOST,
    PORT,
    TYPE,
    SUM(TOTAL_READ_TIME) TOTAL_READ_TIME,
    SUM(TOTAL_WRITE_TIME) TOTAL_WRITE_TIME,
    SUM(TOTAL_READ_SIZE) TOTAL_READ_SIZE,
    SUM(TOTAL_WRITE_SIZE) TOTAL_WRITE_SIZE,
    SUM(TOTAL_READS) TOTAL_READS,
    SUM(TOTAL_WRITES) TOTAL_WRITES,
    MAX(LENGTH(HOST)) OVER () HOST_LEN
  FROM
    IO_TOTAL_STATISTICS
  GROUP BY
    TO_VARCHAR(SERVER_TIMESTAMP, 'YYYY/MM/DD HH24'),
    SITE_ID,
    HOST,
    PORT,
    TYPE
),
SR_TAKEOVERS AS
( SELECT
    T.*
  FROM
    BASIS_INFO BI,
    M_SYSTEM_REPLICATION_TAKEOVER_HISTORY T
  WHERE
    T.TAKEOVER_START_TIME BETWEEN BI.BEGIN_TIME AND BI.END_TIME
),
DISK_USAGE AS
( SELECT
    DU.HOST,
    TO_DECIMAL(MAX(MAP(DU.USAGE_TYPE, 'DATA',           DU.USED_SIZE, 0)) / 1024 / 1024 / 1024, 10, 2) DATA_GB,
    TO_DECIMAL(MAX(MAP(DU.USAGE_TYPE, 'LOG',            DU.USED_SIZE, 0)) / 1024 / 1024 / 1024, 10, 2) LOG_GB,
    TO_DECIMAL(MAX(MAP(DU.USAGE_TYPE, 'DATA_BACKUP',    DU.USED_SIZE, 0)) / 1024 / 1024 / 1024, 10, 2) DATA_BACKUP_GB,
    TO_DECIMAL(MAX(MAP(DU.USAGE_TYPE, 'LOG_BACKUP',     DU.USED_SIZE, 0)) / 1024 / 1024 / 1024, 10, 2) LOG_BACKUP_GB,
    TO_DECIMAL(MAX(MAP(DU.USAGE_TYPE, 'TRACE',          DU.USED_SIZE, 0)) / 1024 / 1024 / 1024, 10, 2) TRACE_GB,
    TO_DECIMAL(MAX(MAP(DU.USAGE_TYPE, 'CATALOG_BACKUP', DU.USED_SIZE, 0)) / 1024 / 1024 / 1024, 10, 2) CATALOG_BACKUP_GB,
    TO_DECIMAL(MAX(MAP(DU.USAGE_TYPE, 'ROOTKEY_BACKUP', DU.USED_SIZE, 0)) / 1024 / 1024 / 1024, 10, 2) ROOTKEY_BACKUP_GB,
    MAX(LENGTH(DU.HOST)) HOST_LEN
  FROM
    BASIS_INFO BI,
    _SYS_STATISTICS.GLOBAL_DISK_USAGE DU
  WHERE
    DU.SERVER_TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND DU.SITE_ID IN (-1, 0) ) OR DU.SITE_ID = BI.SITE_ID ) AND
    DU.HOST LIKE BI.HOST
  GROUP BY
    DU.SITE_ID,
    DU.HOST
),
SERVICE_STATISTICS AS
( SELECT
    HOST,
    PORT,
    SERVICE_NAME,
    MAP(SECONDS, 0, 0, TO_DECIMAL(REQUESTS / SECONDS, 10, 2)) REQ_PER_S,                   /* request columns aren't meaningful, so they aren't propagated to the output */
    MAP(SECONDS, 0, 0, TO_DECIMAL(INT_REQUESTS / SECONDS, 10, 2)) INT_REQ_PER_S,
    MAP(SECONDS, 0, 0, TO_DECIMAL(CPU_MS / 1000 / SECONDS, 10, 2)) ACT_CPUS,
    TO_DECIMAL(ACTIVE_REQUESTS, 10, 2) ACT_REQUESTS,
    TO_DECIMAL(ACTIVE_THREADS, 10, 2) ACT_THREADS,
    TO_DECIMAL(ROUND(THREADS), 10, 0) THREADS,
    TO_DECIMAL(MEM_GB, 10, 2) MEM_GB,
    TO_DECIMAL(AVG_RESP_MS, 10, 2) AVG_RESP_MS,
    TO_DECIMAL(ROUND(OPEN_FILES), 10, 0) OPEN_FILES,
    MAX(LENGTH(HOST)) OVER () HOST_LEN
  FROM
  ( SELECT
      SS.HOST,
      SS.PORT,
      SS.SERVICE_NAME,
      SUM(SS.SNAPSHOT_DELTA) SECONDS,
      SUM(GREATEST(SS.ALL_FINISHED_REQUEST_COUNT_DELTA, 0)) REQUESTS,
      SUM(GREATEST(SS.ALL_FINISHED_REQUEST_COUNT_DELTA - SS.FINISHED_NON_INTERNAL_REQUEST_COUNT_DELTA, 0)) INT_REQUESTS,
      SUM(GREATEST(SS.PROCESS_CPU_TIME_DELTA, 0)) CPU_MS,
      AVG(GREATEST(SS.ACTIVE_REQUEST_COUNT, 0)) ACTIVE_REQUESTS,
      AVG(GREATEST(SS.ACTIVE_THREAD_COUNT, 0)) ACTIVE_THREADS,
      AVG(GREATEST(SS.THREAD_COUNT, 0)) THREADS,
      AVG(GREATEST(SS.PROCESS_PHYSICAL_MEMORY, 0)) / 1024 / 1024 / 1024 MEM_GB,
      AVG(GREATEST(SS.RESPONSE_TIME, 0)) AVG_RESP_MS,
      AVG(GREATEST(SS.OPEN_FILE_COUNT, 0)) OPEN_FILES
    FROM
      BASIS_INFO BI,
      _SYS_STATISTICS.HOST_SERVICE_STATISTICS SS
    WHERE
      SS.SERVER_TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
      (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND SS.SITE_ID IN (-1, 0) ) OR SS.SITE_ID = BI.SITE_ID ) AND
      SS.HOST LIKE BI.HOST AND
      TO_VARCHAR(SS.PORT) LIKE BI.PORT
    GROUP BY
      SS.HOST,
      SS.PORT,
      SS.SERVICE_NAME
  )
),
INTERNAL_ACTIVITIES AS
( SELECT
    ACTIVITY,
    HOST,
    TOTAL,
    PER_HOUR,
    AVG_ACTIVE,
    RECORDS_PER_HOUR,
    MAX(LENGTH(HOST)) OVER () HOST_LEN
  FROM
  ( SELECT
      'LOAD' ACTIVITY,
      HOST,
      NUM_LOADS TOTAL,
      TO_DECIMAL(NUM_LOADS / SECONDS * 3600, 10, 2) PER_HOUR,
      TO_VARCHAR(TO_DECIMAL(TIME_S / SECONDS, 10, 2)) AVG_ACTIVE,
      '' RECORDS_PER_HOUR
    FROM
    ( SELECT
        U.HOST,
        COUNT(*) NUM_LOADS,
        SUM(U.LOAD_DURATION) / 1000 TIME_S,
        BI.SECONDS
      FROM
        BASIS_INFO BI,
        M_CS_LOADS U
      WHERE
        U.LOAD_TIME BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
        U.HOST LIKE BI.HOST AND
        TO_VARCHAR(U.PORT) LIKE BI.PORT
      GROUP BY
        U.HOST,
        BI.SECONDS
    )
    UNION ALL
    ( SELECT
        ACTIVITY,
        HOST,
        NUM_MERGES TOTAL,
        TO_DECIMAL(NUM_MERGES * 3600 / SECONDS, 10, 2) PER_HOUR,
        TO_VARCHAR(TO_DECIMAL(TIME_S / SECONDS, 10, 2)) AVG_ACTIVE,
        TO_VARCHAR(TO_DECIMAL(RECORDS / SECONDS * 3600, 10, 2)) RECORDS_PER_HOUR
      FROM
      ( SELECT
          M.HOST,
          MAP(M.TYPE, 'MERGE', 'DELTA MERGE', 'HINT', 'DELTA MERGE', 'FACT', 'FACT TABLE COMPRESSION', 'RECLAIM', 'DELTA STORAGE RECLAIM', 'SPARSE', 'OPTIMIZE COMPRESSION', 'MERGE (UNDEFINED)') ACTIVITY,
          COUNT(*) NUM_MERGES,
          SUM(M.EXECUTION_TIME) / 1000 TIME_S,
          SUM(TO_BIGINT(GREATEST(0, M.MERGED_DELTA_RECORDS))) RECORDS,
          BI.SECONDS
        FROM
          BASIS_INFO BI,
          _SYS_STATISTICS.HOST_DELTA_MERGE_STATISTICS M
        WHERE
          M.SERVER_TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
          (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND M.SITE_ID IN (-1, 0) ) OR M.SITE_ID = BI.SITE_ID ) AND
          M.HOST LIKE BI.HOST AND
          TO_VARCHAR(M.PORT) LIKE BI.PORT
        GROUP BY
          M.HOST,
          MAP(M.TYPE, 'MERGE', 'DELTA MERGE', 'HINT', 'DELTA MERGE', 'FACT', 'FACT TABLE COMPRESSION', 'RECLAIM', 'DELTA STORAGE RECLAIM', 'SPARSE', 'OPTIMIZE COMPRESSION', 'MERGE (UNDEFINED)'),
          BI.SECONDS
      )
    )
    UNION ALL
    ( SELECT
        'SAVEPOINT' ACTIVITY,
        HOST,
        NUM_SAVEPOINTS TOTAL,
        TO_DECIMAL(NUM_SAVEPOINTS / SECONDS * 3600, 10, 2) PER_HOUR,
        TO_VARCHAR(TO_DECIMAL(TIME_S / SECONDS, 10, 2)) AVG_ACTIVE,
        '' RECORDS_PER_HOUR
      FROM
      ( SELECT
          S.HOST,
          COUNT(*) NUM_SAVEPOINTS,
          SUM(S.DURATION) / 1000000 TIME_S,
          BI.SECONDS
        FROM
          BASIS_INFO BI,
          _SYS_STATISTICS.HOST_SAVEPOINTS S
        WHERE
          S.START_TIME BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
          (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND S.SITE_ID IN (-1, 0) ) OR S.SITE_ID = BI.SITE_ID ) AND
          S.HOST LIKE BI.HOST AND
          TO_VARCHAR(S.PORT) LIKE BI.PORT
        GROUP BY
          S.HOST,
          BI.SECONDS
      )
    )
    UNION ALL
    ( SELECT
        'UNLOAD' || CHAR(32) || '(' || REASON || ')' ACTIVITY,
        HOST,
        NUM_UNLOADS TOTAL,
        TO_DECIMAL(NUM_UNLOADS / SECONDS * 3600, 10, 2) PER_HOUR,
        '' AVG_ACTIVE,
        '' RECORDS_PER_HOUR
      FROM
      ( SELECT
          U.HOST,
          COUNT(*) NUM_UNLOADS,
          U.REASON,
          BI.SECONDS
        FROM
          BASIS_INFO BI,
          M_CS_UNLOADS U
        WHERE
          U.UNLOAD_TIME BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
          U.HOST LIKE BI.HOST AND
          TO_VARCHAR(U.PORT) LIKE BI.PORT
        GROUP BY
          U.HOST,
          U.REASON,
          BI.SECONDS
      )
    )
    UNION ALL
    ( SELECT
        ACTIVITY,
        HOST,
        NUM_JOBS TOTAL,
        TO_DECIMAL(NUM_JOBS / SECONDS * 3600, 10, 2) PER_HOUR,
        TO_VARCHAR(TO_DECIMAL(ACT_SECONDS / SECONDS, 10, 2)) AVG_ACTIVE,
        '' RECORDS_PER_HOUR
      FROM
      ( SELECT
          J.HOST,
          'JOB:' || CHAR(32) || UPPER(J.JOB_NAME) ACTIVITY,
          SUM(SECONDS_BETWEEN(J.START_TIME, J.END_TIME)) ACT_SECONDS,
          COUNT(*) NUM_JOBS,
          BI.SECONDS
        FROM
          BASIS_INFO BI,
          _SYS_STATISTICS.HOST_JOB_HISTORY J
        WHERE
        ( J.START_TIME BETWEEN BI.BEGIN_TIME AND BI.END_TIME OR
          J.END_TIME BETWEEN BI.BEGIN_TIME AND BI.END_TIME OR
          J.START_TIME < BI.BEGIN_TIME AND J.END_TIME > BI.END_TIME
        ) AND
          J.JOB_HOST LIKE BI.HOST AND
          TO_VARCHAR(J.PORT) LIKE BI.PORT
        GROUP BY
          J.HOST,
          UPPER(J.JOB_NAME),
          BI.SECONDS
      )
    )
  )
),
RESOURCE_UTILIZATION AS
( SELECT
    R.HOST,
    SUM(R.SNAPSHOT_DELTA) DURATION,
    SUM(CASE WHEN R.TOTAL_CPU_IDLE_TIME_DELTA < 0 THEN 0 ELSE R.TOTAL_CPU_IDLE_TIME_DELTA END) SUM_IDLE,
    MIN(CASE WHEN R.TOTAL_CPU_IDLE_TIME_DELTA < 0 THEN 999999 ELSE R.TOTAL_CPU_IDLE_TIME_DELTA / R.SNAPSHOT_DELTA END) MIN_IDLE,
    SUM(CASE WHEN R.TOTAL_CPU_SYSTEM_TIME_DELTA < 0 THEN 0 ELSE R.TOTAL_CPU_SYSTEM_TIME_DELTA END) SUM_SYS,
    MAX(CASE WHEN R.TOTAL_CPU_SYSTEM_TIME_DELTA < 0 THEN 0 ELSE R.TOTAL_CPU_SYSTEM_TIME_DELTA / R.SNAPSHOT_DELTA END) MAX_SYS,
    SUM(CASE WHEN R.TOTAL_CPU_USER_TIME_DELTA < 0 THEN 0 ELSE R.TOTAL_CPU_USER_TIME_DELTA END) SUM_USER,
    MAX(CASE WHEN R.TOTAL_CPU_USER_TIME_DELTA < 0 THEN 0 ELSE R.TOTAL_CPU_USER_TIME_DELTA / R.SNAPSHOT_DELTA END) MAX_USER,
    SUM(CASE WHEN R.TOTAL_CPU_WIO_TIME_DELTA < 0 THEN 0 ELSE R.TOTAL_CPU_WIO_TIME_DELTA END) SUM_IO,
    MAX(CASE WHEN R.TOTAL_CPU_WIO_TIME_DELTA < 0 THEN 0 ELSE R.TOTAL_CPU_WIO_TIME_DELTA / R.SNAPSHOT_DELTA END) MAX_IO,
    TO_DECIMAL(AVG(R.USED_PHYSICAL_MEMORY + R.FREE_PHYSICAL_MEMORY) / 1024 / 1024 / 1024, 10, 2) PHYS_GB,
    TO_DECIMAL(AVG(R.USED_PHYSICAL_MEMORY) / 1024 / 1024 / 1024, 10, 2) PHYS_USED_GB,
    TO_DECIMAL(AVG(R.ALLOCATION_LIMIT) / 1024 / 1024 / 1024, 10, 2) ALLOC_LIM_GB,
    TO_DECIMAL(MAX(R.INSTANCE_TOTAL_MEMORY_ALLOCATED_SIZE) / 1024 / 1024 / 1024, 10, 2) INST_ALLOC_GB,
    TO_DECIMAL(MAX(R.INSTANCE_TOTAL_MEMORY_USED_SIZE) / 1024 / 1024 / 1024, 10, 2) INST_USED_GB,
    TO_DECIMAL(AVG(R.INSTANCE_SHARED_MEMORY_ALLOCATED_SIZE) / 1024 / 1024 / 1024, 10, 2) SHARED_GB,
    MAX(LENGTH(R.HOST)) OVER () HOST_LEN
  FROM
    BASIS_INFO BI,
    _SYS_STATISTICS.HOST_RESOURCE_UTILIZATION_STATISTICS R
  WHERE
    R.SERVER_TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND R.SITE_ID IN (-1, 0) ) OR R.SITE_ID = BI.SITE_ID ) AND
    R.HOST LIKE BI.HOST AND
    R.SNAPSHOT_DELTA > 0
  GROUP BY
    R.HOST
),
MEMORY AS
( SELECT
    HOST,
    CATEGORY DETAIL,
    COMPONENT,
    MAX_SIZE_GB,
    AVG_SIZE_GB
  FROM
  ( SELECT
      M.HOST,
      M.CATEGORY,
      M.COMPONENT,
      TO_DECIMAL(MAX(SIZE_GB), 10, 2) MAX_SIZE_GB,
      TO_DECIMAL(AVG(SIZE_GB), 10, 2) AVG_SIZE_GB
    FROM
    ( SELECT
        M.SERVER_TIMESTAMP,
        M.HOST,
        M.CATEGORY,
        M.COMPONENT,
        SUM(M.EXCLUSIVE_SIZE_IN_USE) / 1024 / 1024 / 1024 SIZE_GB
      FROM
        BASIS_INFO BI,
        _SYS_STATISTICS.HOST_HEAP_ALLOCATORS M
      WHERE
        M.SERVER_TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
        (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND M.SITE_ID IN (-1, 0) ) OR M.SITE_ID = BI.SITE_ID ) AND
        M.HOST LIKE BI.HOST AND
        TO_VARCHAR(M.PORT) LIKE BI.PORT
      GROUP BY
        M.SERVER_TIMESTAMP,
        M.HOST,
        M.CATEGORY,
        M.COMPONENT
      UNION ALL
      SELECT       /* not 100 % precise to map shared memory to row store tables, but usually a good approximation */
        M.SERVER_TIMESTAMP,
        M.HOST,
        'Shared Memory',
        'Row Store Tables',
        SUM(SHARED_MEMORY_ALLOCATED_SIZE) / 1024 / 1024 / 1024 SIZE_GB
      FROM
        BASIS_INFO BI,
        _SYS_STATISTICS.HOST_SERVICE_MEMORY M
      WHERE
        M.SERVER_TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
        (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND M.SITE_ID IN (-1, 0) ) OR M.SITE_ID = BI.SITE_ID ) AND
        M.HOST LIKE BI.HOST AND
        TO_VARCHAR(M.PORT) LIKE BI.PORT      
      GROUP BY
        M.SERVER_TIMESTAMP,
        M.HOST
    ) M
    GROUP BY
      M.HOST,
      M.CATEGORY,
      M.COMPONENT
  ) 
),
MEMORY_1 AS
( SELECT
    HOST,
    MAX(LENGTH(HOST)) OVER () HOST_LEN,
    COMPONENT,
    MAX(LENGTH(COMPONENT)) OVER () COMPONENT_LEN,
    DETAIL,
    MAX(LENGTH(DETAIL)) OVER () DETAIL_LEN,
    MAX_SIZE_GB
  FROM
  ( SELECT
      M.HOST,
      M.COMPONENT,
      M.DETAIL,
      SUM(M.MAX_SIZE_GB) MAX_SIZE_GB,
      ROW_NUMBER() OVER (ORDER BY SUM(MAX_SIZE_GB) DESC) LN,
      BI.TOP_N_MEMORY
    FROM
      BASIS_INFO BI,
      MEMORY M
    GROUP BY
      M.HOST,
      M.COMPONENT,
      M.DETAIL,
      BI.TOP_N_MEMORY
  )
  WHERE
    ( TOP_N_MEMORY = -1 OR LN <= TOP_N_MEMORY )
),
MEMORY_2 AS
( SELECT
    HOST,
    MAX(LENGTH(HOST)) OVER () HOST_LEN,
    COMPONENT,
    MAX(LENGTH(COMPONENT)) OVER () COMPONENT_LEN,
    MAX_SIZE_GB
  FROM
  ( SELECT
      M.HOST,
      M.COMPONENT,
      SUM(M.MAX_SIZE_GB) MAX_SIZE_GB,
      ROW_NUMBER() OVER (ORDER BY SUM(MAX_SIZE_GB) DESC) LN,
      BI.TOP_N_MEMORY
    FROM
      BASIS_INFO BI,
      MEMORY M
    GROUP BY
      M.HOST,
      M.COMPONENT,
      BI.TOP_N_MEMORY
  )
  WHERE
    ( TOP_N_MEMORY = -1 OR LN <= TOP_N_MEMORY )
),
TRACE_ENTRIES AS
( SELECT
    TIMESTAMP,
    HOST,
    PORT,
    T,
    COMPONENT,
    TRACE_TEXT,
    MAX(LENGTH(HOST)) OVER () HOST_LEN
  FROM
  ( SELECT
      ROW_NUMBER () OVER (ORDER BY TIMESTAMP DESC) LN,   
      TO_VARCHAR(T.TIMESTAMP, 'YYYY/MM/DD HH24:MI:SS') TIMESTAMP,
      T.HOST,
      T.PORT,
      SUBSTR(T.TRACE_LEVEL, 1, 1) T,
      T.COMPONENT,
      TO_VARCHAR(REPLACE(REPLACE(REPLACE(SUBSTR(T.TRACE_TEXT, 1, 4000), CHAR(10), CHAR(32)), CHAR(13), CHAR(32)), CHAR(9), CHAR(32))) TRACE_TEXT,
      BI.TOP_N_TRACE_ENTRIES
    FROM
      BASIS_INFO BI,
      M_MERGED_TRACES T
    WHERE
      T.TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
      T.TRACE_LEVEL NOT IN ( 'Debug', 'DebugFull', 'Info', 'Interface', 'InterfaceFull' )
  )
  WHERE
    LN <= TOP_N_TRACE_ENTRIES
),
COLUMN_STORE AS
( SELECT
    SCHEMA_NAME,
    TABLE_NAME,
    MEM_TOTAL_GB,
    MEM_MAIN_GB,
    MEM_DELTA_GB,
    RECORDS,
    RECORDS_DELTA,
    READS_PER_H,
    WRITES_PER_H,
    MAX(LENGTH(SCHEMA_NAME)) OVER () SCHEMA_LEN,
    MAX(LENGTH(TABLE_NAME)) OVER () TABLE_LEN
  FROM
  ( SELECT
      ROW_NUMBER() OVER (ORDER BY AVG(MEMORY_SIZE_IN_TOTAL) DESC) LN1,
      ROW_NUMBER() OVER (ORDER BY AVG(MEMORY_SIZE_IN_MAIN) DESC) LN2,
      ROW_NUMBER() OVER (ORDER BY AVG(MEMORY_SIZE_IN_DELTA) DESC) LN3,
      ROW_NUMBER() OVER (ORDER BY AVG(RECORD_COUNT) DESC) LN4,
      ROW_NUMBER() OVER (ORDER BY SUM(READ_COUNT) DESC) LN5,
      ROW_NUMBER() OVER (ORDER BY SUM(WRITE_COUNT) DESC) LN6,
      SCHEMA_NAME,
      TABLE_NAME,
      TO_DECIMAL(AVG(MEMORY_SIZE_IN_TOTAL) / 1024 / 1024 / 1024, 10, 2) MEM_TOTAL_GB,
      TO_DECIMAL(AVG(MEMORY_SIZE_IN_MAIN) / 1024 / 1024 / 1024, 10, 2) MEM_MAIN_GB,
      TO_DECIMAL(AVG(MEMORY_SIZE_IN_DELTA) / 1024 / 1024 / 1024, 10, 2) MEM_DELTA_GB,
      TO_DECIMAL(ROUND(AVG(RECORD_COUNT)), 12, 0) RECORDS,
      TO_DECIMAL(ROUND(AVG(RECORD_COUNT_DELTA)), 12, 0) RECORDS_DELTA,
      TO_DECIMAL(SUM(READ_COUNT) * 3600 / SECONDS, 10, 2) READS_PER_H,	
      TO_DECIMAL(SUM(WRITE_COUNT) * 3600 / SECONDS, 10, 2) WRITES_PER_H,
      TOP_N_CS_SIZE
    FROM
    ( SELECT
        T.SERVER_TIMESTAMP,
        T.SCHEMA_NAME,
        T.TABLE_NAME,
        SUM(T.MEMORY_SIZE_IN_TOTAL) MEMORY_SIZE_IN_TOTAL,
        SUM(T.MEMORY_SIZE_IN_MAIN + T.PERSISTENT_MEMORY_SIZE_IN_TOTAL) MEMORY_SIZE_IN_MAIN,
        SUM(T.MEMORY_SIZE_IN_DELTA) MEMORY_SIZE_IN_DELTA,
        SUM(T.RECORD_COUNT) RECORD_COUNT,
        SUM(T.RAW_RECORD_COUNT_IN_DELTA) RECORD_COUNT_DELTA,
        SUM(CASE WHEN T.READ_COUNT_SDELTA >= 0 THEN T.READ_COUNT_SDELTA ELSE T.READ_COUNT END) READ_COUNT,
        SUM(CASE WHEN T.WRITE_COUNT_SDELTA >= 0 THEN T.WRITE_COUNT_SDELTA ELSE T.WRITE_COUNT END) WRITE_COUNT,
        BI.SECONDS,
        BI.TOP_N_CS_SIZE
      FROM
        BASIS_INFO BI,
        _SYS_STATISTICS.HOST_COLUMN_TABLES_PART_SIZE T
      WHERE
        T.SERVER_TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
        (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND T.SITE_ID IN (-1, 0) ) OR T.SITE_ID = BI.SITE_ID ) AND
        T.HOST LIKE BI.HOST AND
        TO_VARCHAR(T.PORT) LIKE BI.PORT
      GROUP BY
        T.SERVER_TIMESTAMP,
        T.SCHEMA_NAME,
        T.TABLE_NAME,
        BI.SECONDS,
        BI.TOP_N_CS_SIZE
    )
    GROUP BY
      SCHEMA_NAME,
      TABLE_NAME,
      SECONDS,
      TOP_N_CS_SIZE
  )
  WHERE
    LEAST(LN1, LN2, LN3, LN4, LN5, LN6) <= TOP_N_CS_SIZE
),
ROW_STORE AS
( SELECT
    SCHEMA_NAME,
    TABLE_NAME,
    MEM_TOTAL_GB,
    MEM_TAB_GB,
    MEM_IND_GB,
    RECORDS,
    MAX(LENGTH(SCHEMA_NAME)) OVER () SCHEMA_LEN,
    MAX(LENGTH(TABLE_NAME)) OVER () TABLE_LEN
  FROM
  ( SELECT
      ROW_NUMBER() OVER (ORDER BY SUM(T.RS_TAB_SIZE_GB + IFNULL(I.RS_IND_SIZE_GB, 0)) DESC) LN1,
      ROW_NUMBER() OVER (ORDER BY SUM(T.RECORDS) DESC) LN2,
      T.SCHEMA_NAME,
      T.TABLE_NAME,
      TO_DECIMAL(SUM(T.RS_TAB_SIZE_GB + IFNULL(I.RS_IND_SIZE_GB, 0)), 10, 2) MEM_TOTAL_GB,
      TO_DECIMAL(SUM(T.RS_TAB_SIZE_GB), 10, 2) MEM_TAB_GB,
      TO_DECIMAL(SUM(IFNULL(I.RS_IND_SIZE_GB, 0)), 10, 2) MEM_IND_GB,
      SUM(T.RECORDS) RECORDS,
      T.TOP_N_RS_SIZE
    FROM
    ( SELECT
        BI.TOP_N_RS_SIZE,
        T.HOST,
        T.SCHEMA_NAME,
        T.TABLE_NAME,
        MAX(TO_BIGINT(T.ALLOCATED_FIXED_PART_SIZE + T.ALLOCATED_VARIABLE_PART_SIZE)) / 1024 / 1024 / 1024 RS_TAB_SIZE_GB,
        MAX(T.RECORD_COUNT) RECORDS
      FROM
        BASIS_INFO BI,
        _SYS_STATISTICS.GLOBAL_ROWSTORE_TABLES_SIZE T
      WHERE
        T.SERVER_TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
        (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND T.SITE_ID IN (-1, 0) ) OR T.SITE_ID = BI.SITE_ID ) AND
        T.HOST LIKE BI.HOST  AND
        TO_VARCHAR(T.PORT) LIKE BI.PORT
      GROUP BY
        T.HOST,
        T.SCHEMA_NAME,
        T.TABLE_NAME,
        BI.TOP_N_RS_SIZE
    ) T LEFT OUTER JOIN
    ( SELECT
        HOST,
        SCHEMA_NAME,
        TABLE_NAME,
        MAX(RS_IND_SIZE_GB) RS_IND_SIZE_GB
      FROM
      ( SELECT
          I.HOST,
          I.SCHEMA_NAME,
          I.TABLE_NAME,
          SUM(I.INDEX_SIZE / 1024 / 1024 / 1024) RS_IND_SIZE_GB
        FROM
          BASIS_INFO BI,
          _SYS_STATISTICS.HOST_RS_INDEXES I
        WHERE
          I.SERVER_TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
          (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND I.SITE_ID IN (-1, 0) ) OR I.SITE_ID = BI.SITE_ID ) AND
          I.HOST LIKE BI.HOST  AND
          TO_VARCHAR(I.PORT) LIKE BI.PORT
        GROUP BY
          I.HOST,
          I.SCHEMA_NAME,
          I.TABLE_NAME,
          I.SERVER_TIMESTAMP
      )
      GROUP BY
        HOST,
        SCHEMA_NAME,
        TABLE_NAME
    ) I ON
      I.HOST = T.HOST AND
      I.SCHEMA_NAME = T.SCHEMA_NAME AND
      I.TABLE_NAME = T.TABLE_NAME
    GROUP BY
      T.SCHEMA_NAME,
      T.TABLE_NAME,
      T.TOP_N_RS_SIZE
  )
  WHERE
    LEAST(LN1, LN2) <= TOP_N_RS_SIZE
),
PERSISTENCE AS
( SELECT
    SCHEMA_NAME,
    TABLE_NAME,
    DISK_GB,
    READ_GB,
    WRITE_GB,
    APPEND_GB,
    MAX(LENGTH(SCHEMA_NAME)) OVER () SCHEMA_LEN,
    MAX(LENGTH(TABLE_NAME)) OVER () TABLE_LEN
  FROM
  ( SELECT
      ROW_NUMBER() OVER (ORDER BY DISK_GB DESC) LN1,
      ROW_NUMBER() OVER (ORDER BY READ_GB + WRITE_GB + APPEND_GB DESC) LN2,
      SCHEMA_NAME,
      TABLE_NAME,
      TO_DECIMAL(DISK_GB, 10, 2) DISK_GB,
      TO_DECIMAL(READ_GB, 10, 2) READ_GB,
      TO_DECIMAL(WRITE_GB, 10, 2) WRITE_GB,
      TO_DECIMAL(APPEND_GB, 10, 2) APPEND_GB,
      TOP_N_DISK
    FROM
    ( SELECT
        P.SCHEMA_NAME,
        P.TABLE_NAME,
        MAX(P.DISK_SIZE) / 1024 / 1024 / 1024 DISK_GB,
        SUM(CASE WHEN P.BYTES_READ_DELTA < 0 THEN P.BYTES_READ ELSE P.BYTES_READ_DELTA END) / 1024 / 1024 / 1024 READ_GB,
        SUM(CASE WHEN P.BYTES_WRITTEN_DELTA < 0 THEN P.BYTES_WRITTEN ELSE P.BYTES_WRITTEN_DELTA END) / 1024 / 1024 / 1024 WRITE_GB,
        SUM(CASE WHEN P.BYTES_APPENDED_DELTA < 0 THEN P.BYTES_APPENDED ELSE P.BYTES_APPENDED_DELTA END) / 1024 / 1024 / 1024 APPEND_GB,
        BI.TOP_N_DISK
      FROM
        BASIS_INFO BI,
        _SYS_STATISTICS.GLOBAL_TABLE_PERSISTENCE_STATISTICS P
      WHERE
        P.SERVER_TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
        (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND P.SITE_ID IN (-1, 0) ) OR P.SITE_ID = BI.SITE_ID ) AND
        P.HOST LIKE BI.HOST  AND
        TO_VARCHAR(P.PORT) LIKE BI.PORT
      GROUP BY
        P.SCHEMA_NAME,
        P.TABLE_NAME,
        BI.TOP_N_DISK
    )
  )
  WHERE
    LEAST(LN1, LN2) <= TOP_N_DISK
),
BLOCKED_TRANSACTIONS AS
( SELECT
    TIMESTAMP,
    WAITING_S,
    TABLE_NAME,
    BLOCKED_UTID,
    BLOCKING_UTID,
    BLOCKED_STATEMENT_HASH,
    MAX(LENGTH(TABLE_NAME)) OVER () TABLE_LEN
  FROM
  ( SELECT
      ROW_NUMBER() OVER (ORDER BY MAX(WAITING_S) DESC) LN,
      MAX(TIMESTAMP) TIMESTAMP,
      MAX(IFNULL(WAITING_S, 0)) WAITING_S,
      TABLE_NAME,
      BLOCKED_UTID,
      BLOCKING_UTID,
      IFNULL(BLOCKED_STATEMENT_HASH, '') BLOCKED_STATEMENT_HASH,
      TOP_N_BLOCKED_TRANSACTIONS
    FROM
    ( SELECT
        TO_VARCHAR(B.SERVER_TIMESTAMP, 'YYYY/MM/DD HH24:MI:SS') TIMESTAMP,
        SECONDS_BETWEEN(B.BLOCKED_TIME, B.SERVER_TIMESTAMP) WAITING_S,
        B.WAITING_SCHEMA_NAME || '.' || B.WAITING_OBJECT_NAME TABLE_NAME,
        B.BLOCKED_UPDATE_TRANSACTION_ID BLOCKED_UTID,
        B.LOCK_OWNER_UPDATE_TRANSACTION_ID BLOCKING_UTID,
        B.BLOCKED_STATEMENT_HASH BLOCKED_STATEMENT_HASH,
        BI.TOP_N_BLOCKED_TRANSACTIONS
      FROM
        BASIS_INFO BI,
        _SYS_STATISTICS.HOST_BLOCKED_TRANSACTIONS B
      WHERE
        B.SERVER_TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
        (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND B.SITE_ID IN (-1, 0) ) OR B.SITE_ID = BI.SITE_ID ) AND
        B.HOST LIKE BI.HOST  AND
        TO_VARCHAR(B.PORT) LIKE BI.PORT
    )
    GROUP BY
      TABLE_NAME,
      BLOCKED_UTID,
      BLOCKING_UTID,
      BLOCKED_STATEMENT_HASH,
      TOP_N_BLOCKED_TRANSACTIONS
  )
  WHERE
    LN <= TOP_N_BLOCKED_TRANSACTIONS
),
TABLE_OPTIMIZATIONS AS
( SELECT
    SCHEMA_NAME,
    TABLE_NAME,
    TYPE,
    EXECUTIONS,
    TOTAL_TIME_S,
    AVG_TIME_S,
    MAX(LENGTH(SCHEMA_NAME)) OVER () SCHEMA_LEN,
    MAX(LENGTH(TABLE_NAME)) OVER () TABLE_LEN
  FROM
  ( SELECT
      ROW_NUMBER() OVER (ORDER BY SUM(M.EXECUTION_TIME) DESC) LN,
      M.SCHEMA_NAME,
      M.TABLE_NAME,
      M.TYPE,
      COUNT(*) EXECUTIONS,
      TO_DECIMAL(SUM(M.EXECUTION_TIME) / 1000, 10, 2) TOTAL_TIME_S,
      TO_DECIMAL(SUM(M.EXECUTION_TIME) / 1000 / COUNT(*), 10, 2) AVG_TIME_S,
      BI.TOP_N_TABLE_OPTIMIZATIONS
    FROM
      BASIS_INFO BI,
      _SYS_STATISTICS.HOST_DELTA_MERGE_STATISTICS M
    WHERE
      M.START_TIME BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
      (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND M.SITE_ID IN (-1, 0) ) OR M.SITE_ID = BI.SITE_ID ) AND
      M.HOST LIKE BI.HOST AND
      TO_VARCHAR(M.PORT) LIKE BI.PORT
    GROUP BY
      M.SCHEMA_NAME,
      M.TABLE_NAME,
      M.TYPE,
      BI.TOP_N_TABLE_OPTIMIZATIONS
  )
WHERE
  LN <= TOP_N_TABLE_OPTIMIZATIONS
),
LOAD_HISTORY_HOST AS
( SELECT
    H.HOST,
    LPAD(AVG(H.CPU), 3) || CHAR(32) || '/' || LPAD(MAX(H.CPU), 3)  CPU_PCT,
    LPAD(TO_DECIMAL(ROUND(AVG(H.MEMORY_USED / 1024 / 1024 / 1024)), 10, 0), 5) || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(MAX(H.MEMORY_USED / 1024 / 1024 / 1024)), 10, 0), 5) MEM_USED_GB,
    LPAD(TO_DECIMAL(ROUND(AVG(H.DISK_USED / 1024 / 1024 / 1024)), 10, 0), 4) || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(MAX(H.DISK_USED / 1024 / 1024 / 1024)), 10, 0), 4) DISK_USED_GB,
    TO_DECIMAL(SUM(H.NETWORK_IN / 1024 / 1024 / BI.SECONDS), 10, 2) NETWORK_IN_MBPS,
    TO_DECIMAL(SUM(H.NETWORK_OUT / 1024 / 1024 / BI.SECONDS), 10, 2) NETWORK_OUT_MBPS,
    TO_DECIMAL(SUM(H.SWAP_OUT / 1024 / 1024 / BI.SECONDS), 10, 2) SWAP_OUT_MBPS,
    MAX(LENGTH(H.HOST)) OVER () HOST_LEN
  FROM
    BASIS_INFO BI,
    _SYS_STATISTICS.HOST_LOAD_HISTORY_HOST H
  WHERE
    H.TIME BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND H.SITE_ID IN (-1, 0) ) OR H.SITE_ID = BI.SITE_ID ) AND
    H.HOST LIKE BI.HOST
  GROUP BY
    H.HOST,
    BI.SECONDS
),
LOAD_HISTORY_SERVICES AS
( SELECT
    S.HOST,
    S.PORT,
    LPAD(TO_DECIMAL(ROUND(AVG(S.CPU)), 10, 0), 4) || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(MAX(S.CPU)), 10, 0), 4)  CPU_PCT,
    LPAD(TO_DECIMAL(ROUND(AVG(S.SYSTEM_CPU)), 10, 0), 4) || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(MAX(S.SYSTEM_CPU)), 10, 0), 4)  SYS_CPU_PCT,
    LPAD(TO_DECIMAL(ROUND(AVG(S.PING_TIME)), 10, 0), 4) || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(MAX(S.PING_TIME)), 10, 0), 4) PING_MS,
    MAX(S.COMMIT_ID_RANGE) MAX_CID_RANGE,
    MAX(S.MVCC_VERSION_COUNT) MAX_VERSION_COUNT,
    MAX(S.CONNECTION_COUNT) CONNECTIONS,
    MAX(S.TRANSACTION_COUNT) TRANSACTIONS,
    MAX(S.BLOCKED_TRANSACTION_COUNT) BLOCKED_TRANSACTIONS,
    MAX(S.PENDING_SESSION_COUNT) PENDING_SESSIONS,
    LPAD(TO_DECIMAL(ROUND(AVG(S.ACTIVE_THREAD_COUNT)), 10, 0), 4) || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(MAX(S.ACTIVE_THREAD_COUNT)), 10, 0), 4) ACTIVE_THREADS,
    LPAD(TO_DECIMAL(ROUND(AVG(S.WAITING_THREAD_COUNT)), 10, 0), 4) || CHAR(32) || '/' || LPAD(TO_DECIMAL(ROUND(MAX(S.WAITING_THREAD_COUNT)), 10, 0), 4) WAITING_THREADS,
    TO_DECIMAL(ROUND(SUM(S.STATEMENT_COUNT) / BI.SECONDS), 10, 0) STATEMENTS_PER_S,
    MAX(LENGTH(S.HOST)) OVER () HOST_LEN    
  FROM
    BASIS_INFO BI,
    _SYS_STATISTICS.HOST_LOAD_HISTORY_SERVICE S
  WHERE
    S.TIME BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND S.SITE_ID IN (-1, 0) ) OR S.SITE_ID = BI.SITE_ID ) AND
    S.HOST LIKE BI.HOST AND
    TO_VARCHAR(S.PORT) LIKE BI.PORT
  GROUP BY
    S.HOST,
    S.PORT,
    BI.SECONDS
),
SYSTEM_REPLICATION AS
( SELECT
    HOST,
    PORT,
    MAX(REPLICATION_MODE) REPLICATION_MODE,
    TO_DECIMAL(SUM(SHIPPED_LOG_BUFFERS_SIZE) / SECONDS / 1024 / 1024, 10, 2) LOG_SHIP_KB_PER_S,
    TO_DECIMAL(SUM(SHIPPED_LOG_BUFFERS_SIZE) / ( SUM(SHIPPED_LOG_BUFFERS_DURATION) + 1 ) / 1024 / 1024 * 1000 * 1000, 10, 2) LOG_THROUGHPUT_KB_PER_S,
    TO_DECIMAL(SUM(SHIPPED_LOG_BUFFERS_DURATION) / ( SUM(SHIPPED_LOG_BUFFERS_COUNT) + 1 ) / 1000, 10, 2) AVG_LOG_SHIP_MS,
    SUM(ASYNC_BUFFER_FULL_COUNT) ASYNC_BUFFER_FULL_COUNT,
    TO_DECIMAL(ROUND(MAX(MAX_BACKLOG_TIME) / 1000), 10, 0) MAX_BACKLOG_MS,
    MAX(LENGTH(HOST)) OVER () HOST_LEN
  FROM
  ( SELECT
      ROW_NUMBER () OVER (ORDER BY R.HOST, R.PORT) LN,
      R.HOST,
      R.PORT,
      R.REPLICATION_MODE,
      CASE WHEN R.SHIPPED_LOG_BUFFERS_COUNT_DELTA < 0 THEN R.SHIPPED_LOG_BUFFERS_COUNT ELSE R.SHIPPED_LOG_BUFFERS_COUNT_DELTA END SHIPPED_LOG_BUFFERS_COUNT,
      CASE WHEN R.SHIPPED_LOG_BUFFERS_SIZE_DELTA < 0 THEN R.SHIPPED_LOG_BUFFERS_SIZE ELSE R.SHIPPED_LOG_BUFFERS_SIZE_DELTA END SHIPPED_LOG_BUFFERS_SIZE,
      CASE WHEN R.SHIPPED_LOG_BUFFERS_DURATION_DELTA < 0 THEN R.SHIPPED_LOG_BUFFERS_DURATION ELSE R.SHIPPED_LOG_BUFFERS_DURATION_DELTA END SHIPPED_LOG_BUFFERS_DURATION,
      CASE WHEN R.ASYNC_BUFFER_FULL_COUNT_DELTA < 0 THEN R.ASYNC_BUFFER_FULL_COUNT ELSE R.ASYNC_BUFFER_FULL_COUNT_DELTA END ASYNC_BUFFER_FULL_COUNT,
      R.MAX_BACKLOG_TIME,
      BI.SECONDS
    FROM  
      BASIS_INFO BI,
      _SYS_STATISTICS.HOST_SERVICE_REPLICATION R
    WHERE
      R.SERVER_TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
      (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND R.SITE_ID IN (-1, 0) ) OR R.SITE_ID = BI.SITE_ID ) AND
      R.HOST LIKE BI.HOST AND
      TO_VARCHAR(R.PORT) LIKE BI.PORT
  )
  GROUP BY
    HOST,
    PORT,
    SECONDS
),
BACKUPS AS
( SELECT
    HOST,
    BACKUP_TYPE,
    BACKUPS,
    ERRORS,
    TO_DECIMAL(MAP(SECONDS, 0, 0, RUNTIME_S / SECONDS), 10, 2) AVG_ACT_BACKUPS,
    TO_DECIMAL(MAP(SECONDS, 0, 0, BACKUP_SIZE_BYTE / SECONDS / 1024 / 1024), 10, 2) BACKUP_VOL_MBPS,
    TO_DECIMAL(MAP(RUNTIME_S, 0, 0, BACKUP_SIZE_BYTE / RUNTIME_S / 1024 / 1024), 10, 2) BACKUP_TP_MBPS,
    MAX(LENGTH(HOST)) OVER () HOST_LEN
  FROM
  ( SELECT
      BF.HOST,
      B.ENTRY_TYPE_NAME BACKUP_TYPE,
      COUNT(*) BACKUPS,
      SUM(NANO100_BETWEEN(B.SYS_START_TIME, B.SYS_END_TIME) / 10000000) RUNTIME_S,
      SUM(MAP(B.MESSAGE, '<ok>', 0, 1)) ERRORS,
      SUM(BACKUP_SIZE) BACKUP_SIZE_BYTE,
      BI.SECONDS
    FROM
      BASIS_INFO BI,
      M_BACKUP_CATALOG B,
      ( SELECT
          HOST,
          BACKUP_ID,
          SUM(BACKUP_SIZE) BACKUP_SIZE
        FROM
          M_BACKUP_CATALOG_FILES
        GROUP BY
          HOST,
          BACKUP_ID
      ) BF
    WHERE
      B.SYS_START_TIME BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
      B.BACKUP_ID = BF.BACKUP_ID
    GROUP BY
      BF.HOST,
      B.ENTRY_TYPE_NAME,
      BI.SECONDS
  )
),
LINES AS
( SELECT TOP 500
    ROW_NUMBER () OVER () LN
  FROM
    OBJECTS
)
SELECT MAP(BI.LINE_LENGTH, -1, LINE, SUBSTR(LINE, 1, LINE_LENGTH)) LINE FROM BASIS_INFO BI, ( 
SELECT       5 LINE_NO, '******************************' LINE FROM DUMMY
UNION ALL SELECT    10, '* SAP HANA TIME FRAME REPORT *' FROM DUMMY
UNION ALL SELECT    20, '******************************' FROM DUMMY
UNION ALL SELECT    30, '' FROM DUMMY
UNION ALL SELECT    90, RPAD('Generated with:', 27) || 'SQL: "HANA_Global_TimeFrameReport" (SAP Note 1969700)'              FROM DUMMY
UNION ALL SELECT   100, RPAD('Start time:',     27) || TO_VARCHAR(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS')                      FROM BASIS_INFO
UNION ALL SELECT   110, RPAD('End time:',       27) || TO_VARCHAR(END_TIME, 'YYYY/MM/DD HH24:MI:SS')                        FROM BASIS_INFO
UNION ALL SELECT   120, RPAD('Duration:',       27) || SECONDS || CHAR(32) || 's'                                           FROM BASIS_INFO
UNION ALL SELECT   125, RPAD('System ID / database name:', 27) || SYSTEM_ID || CHAR(32) || '/' || CHAR(32) || DATABASE_NAME FROM M_DATABASE
UNION ALL SELECT   127, RPAD('Revision level:', 27) || VERSION                                                              FROM M_DATABASE
UNION ALL SELECT   129, RPAD('Site ID / host / port:',  27) || MAP(SITE_ID, -1, 'all', TO_VARCHAR(SITE_ID)) || ' / ' || MAP(HOST, '%', 'all', HOST) || ' / ' || MAP(PORT, '%', 'all', PORT) FROM BASIS_INFO
UNION ALL SELECT  1000, '' FROM DUMMY
UNION ALL SELECT  1010, '*********************' FROM DUMMY
UNION ALL SELECT  1030, '* WORKLOAD OVERVIEW *' FROM DUMMY
UNION ALL SELECT  1040, '*********************' FROM DUMMY
UNION ALL SELECT  1050, '' FROM DUMMY
UNION ALL SELECT  1060, RPAD('ACTIVITY', 20, CHAR(32)) || LPAD('TOTAL', 20) || LPAD('RATE_PER_SECOND', 20) FROM DUMMY
UNION ALL SELECT  1070, RPAD('=', 20, '=') || CHAR(32) || LPAD('=', 19, '=') || CHAR(32) || LPAD('=', 19, '=') FROM DUMMY
UNION ALL
SELECT
  1100 + L.LN,
  CASE L.LN
    WHEN 1 THEN RPAD('Executions', 20, CHAR(32))          || LPAD(W.EXECUTIONS, 20)          || LPAD(TO_DECIMAL(W.EXECUTIONS          / BI.SECONDS, 10, 2), 20)
    WHEN 2 THEN RPAD('Compilations', 20, CHAR(32))        || LPAD(W.COMPILATIONS, 20)        || LPAD(TO_DECIMAL(W.COMPILATIONS        / BI.SECONDS, 10, 2), 20)
    WHEN 3 THEN RPAD('Update transactions', 20, CHAR(32)) || LPAD(W.UPDATE_TRANSACTIONS, 20) || LPAD(TO_DECIMAL(W.UPDATE_TRANSACTIONS / BI.SECONDS, 10, 2), 20)
    WHEN 4 THEN RPAD('Commits', 20, CHAR(32))             || LPAD(W.COMMITS, 20)             || LPAD(TO_DECIMAL(W.COMMITS             / BI.SECONDS, 10, 2), 20)
    WHEN 5 THEN RPAD('Rollbacks', 20, CHAR(32))           || LPAD(W.ROLLBACKS, 20)           || LPAD(TO_DECIMAL(W.ROLLBACKS           / BI.SECONDS, 10, 2), 20)
  END
FROM
  LINES L,
  BASIS_INFO BI,
  ( SELECT
      IFNULL(SUM(EXECUTION_COUNT_DELTA), 0) EXECUTIONS,
      IFNULL(SUM(COMPILATION_COUNT_DELTA), 0) COMPILATIONS,
      IFNULL(SUM(UPDATE_TRANSACTION_COUNT_DELTA), 0) UPDATE_TRANSACTIONS,
      IFNULL(SUM(COMMIT_COUNT_DELTA), 0) COMMITS,
      IFNULL(SUM(ROLLBACK_COUNT_DELTA), 0) ROLLBACKS
    FROM
      BASIS_INFO BI,
      _SYS_STATISTICS.HOST_WORKLOAD W
    WHERE
      W.SERVER_TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
      (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND W.SITE_ID IN (-1, 0) ) OR W.SITE_ID = BI.SITE_ID ) AND
      W.HOST LIKE BI.HOST  AND
      TO_VARCHAR(W.PORT) LIKE BI.PORT AND
      W.EXECUTION_COUNT_DELTA >= 0
  ) W
WHERE
  L.LN <= 5
UNION ALL SELECT TOP 1 5000, '' FROM SERVICE_STATISTICS
UNION ALL SELECT TOP 1 5010, '**********************' FROM SERVICE_STATISTICS
UNION ALL SELECT TOP 1 5030, '* SERVICE STATISTICS *' FROM SERVICE_STATISTICS
UNION ALL SELECT TOP 1 5040, '**********************' FROM SERVICE_STATISTICS
UNION ALL SELECT TOP 1 5050, '' FROM SERVICE_STATISTICS
UNION ALL SELECT  5060, RPAD('HOST', HOST_LEN) || CHAR(32) || LPAD('PORT', 5) || CHAR(32) || RPAD('SERVICE_NAME', 14) || CHAR(32) || LPAD('ACT_CPUS', 9) || CHAR(32) || LPAD('ACT_THREADS', 11) || CHAR(32) ||
  LPAD('THREADS', 7) || CHAR(32) || LPAD('MEM_GB', 8) || CHAR(32) || LPAD('OPEN_FILES', 10) FROM DUMMY, (SELECT TOP 1 * FROM SERVICE_STATISTICS)
UNION ALL SELECT  5070, RPAD('=', HOST_LEN, '=') || CHAR(32) || LPAD('=', 5, '=') || CHAR(32) || RPAD('=', 14, '=') || CHAR(32) || LPAD('=', 9, '=') || CHAR(32) || LPAD('=', 11, '=') || CHAR(32) ||
  LPAD('=', 7, '=') || CHAR(32) || LPAD('=', 8, '=') || CHAR(32) || LPAD('=', 10, '=') FROM DUMMY, (SELECT TOP 1 * FROM SERVICE_STATISTICS)
UNION ALL
SELECT
  5100 + ROW_NUMBER () OVER (ORDER BY HOST, PORT), RPAD(HOST, HOST_LEN) || CHAR(32) || LPAD(PORT, 5) || CHAR(32) || RPAD(SERVICE_NAME, 14) || CHAR(32) || LPAD(ACT_CPUS, 9) || CHAR(32) || LPAD(ACT_THREADS, 11) || CHAR(32) ||
  LPAD(THREADS, 7) || CHAR(32) || LPAD(MEM_GB, 8) || CHAR(32) || LPAD(OPEN_FILES, 10)
FROM
  SERVICE_STATISTICS
UNION ALL SELECT 10020, '' FROM DUMMY
UNION ALL SELECT 10025, '********************' FROM DUMMY
UNION ALL SELECT 10030, '* SYSTEM RESOURCES *' FROM DUMMY
UNION ALL SELECT 10040, '********************' FROM DUMMY
UNION ALL SELECT TOP 1 10050, '' FROM RESOURCE_UTILIZATION
UNION ALL SELECT TOP 1 10060, RPAD('HOST', HOST_LEN) || CHAR(32) || LPAD('AVG_CPU_IDLE', 12) || CHAR(32) || LPAD('MIN_CPU_IDLE', 12) || CHAR(32) || 
  LPAD('AVG_CPU_USER', 12) || CHAR(32) || LPAD('MAX_CPU_USER', 12) || CHAR(32) || LPAD('AVG_CPU_SYS', 11) || CHAR(32) || 
  LPAD('MAX_CPU_SYS', 11) || CHAR(32) || LPAD('AVG_CPU_IO', 10) || CHAR(32) || LPAD('MAX_CPU_IO', 10) FROM RESOURCE_UTILIZATION
UNION ALL SELECT TOP 1 10070, RPAD('=', HOST_LEN, '=') || CHAR(32) || LPAD('=', 12, '=') || CHAR(32) || LPAD('=', 12, '=') || CHAR(32) || 
  LPAD('=', 12, '=') || CHAR(32) || LPAD('=', 12, '=') || CHAR(32) || LPAD('=', 11, '=') || CHAR(32) || 
  LPAD('=', 11, '=') || CHAR(32) || LPAD('=', 10, '=') || CHAR(32) || LPAD('=', 10, '=') FROM RESOURCE_UTILIZATION
UNION ALL
SELECT
  10100 + ROW_NUMBER () OVER (ORDER BY HOST), RPAD(HOST, HOST_LEN) || CHAR(32) || LPAD(TO_DECIMAL(SUM_IDLE / DURATION, 10, 2), 12) || CHAR(32) || LPAD(TO_DECIMAL(MIN_IDLE, 10, 2), 12) || CHAR(32) ||
  LPAD(TO_DECIMAL(SUM_USER / DURATION, 10, 2), 12) || CHAR(32) || LPAD(TO_DECIMAL(MAX_USER, 10, 2), 12) || CHAR(32) || LPAD(TO_DECIMAL(SUM_SYS / DURATION, 10, 2), 11) || CHAR(32) ||
  LPAD(TO_DECIMAL(MAX_SYS, 10, 2), 11) || CHAR(32) || LPAD(TO_DECIMAL(SUM_IO / DURATION, 10, 2), 10) || CHAR(32) || LPAD(TO_DECIMAL(MAX_IO, 10, 2), 10) 
FROM
  RESOURCE_UTILIZATION
UNION ALL SELECT TOP 1 11020, '' FROM RESOURCE_UTILIZATION
UNION ALL SELECT TOP 1 11030, RPAD('HOST', HOST_LEN) || CHAR(32) || LPAD('PHYS_GB', 9) || CHAR(32) || LPAD('PHYS_USED_GB', 12) || CHAR(32) || LPAD('ALLOC_LIM_GB', 12) || CHAR(32) ||
  LPAD('INST_ALLOC_GB', 13) || CHAR(32) || LPAD('INST_USED_GB', 12) || CHAR(32) || LPAD('SHARED_GB', 9) FROM RESOURCE_UTILIZATION
UNION ALL SELECT TOP 1 11040, RPAD('=', HOST_LEN, '=') || CHAR(32) || RPAD('=', 9, '=') || CHAR(32) || RPAD('=', 12, '=') || CHAR(32) || RPAD('=', 12, '=') || CHAR(32) || 
  RPAD('=', 13, '=') || CHAR(32) || RPAD('=', 12, '=') || CHAR(32) || RPAD('=', 9, '=') FROM RESOURCE_UTILIZATION
UNION ALL
SELECT
  11100 + ROW_NUMBER () OVER (ORDER BY HOST), RPAD(HOST, HOST_LEN) || CHAR(32) || LPAD(PHYS_GB, 9) || CHAR(32) || LPAD(PHYS_USED_GB, 12) || CHAR(32) || LPAD(ALLOC_LIM_GB, 12) || CHAR(32) ||
  LPAD(INST_ALLOC_GB, 13) || CHAR(32) || LPAD(INST_USED_GB, 12) || CHAR(32) || LPAD(SHARED_GB, 9) 
FROM
  RESOURCE_UTILIZATION
UNION ALL SELECT TOP 1 12020, '' FROM IO_TOTAL_STATISTICS
UNION ALL SELECT TOP 1 12030, RPAD('HOST', HOST_LEN) || CHAR(32) || RPAD('TYPE', 6) || CHAR(32) || LPAD('IO_READ_ACT_PCT', 16) || CHAR(32) || LPAD('IO_READ_TP_MBPS', 16) || CHAR(32) || 
  LPAD('IO_READ_VOL_MBPS', 17) || CHAR(32) || LPAD('IO_READ_AVG_KB', 15) || CHAR(32) || LPAD('IO_READ_AVG_MS', 15) FROM IO_TOTAL_STATISTICS
UNION ALL SELECT TOP 1 12031, RPAD('=', HOST_LEN, '=') || CHAR(32) || RPAD('=', 6, '=') || CHAR(32) || RPAD('=', 16, '=') || CHAR(32) || RPAD('=', 16, '=') || CHAR(32) || 
  RPAD('=', 17, '=') || CHAR(32) || RPAD('=', 15, '=') || CHAR(32) || RPAD('=', 15, '=') FROM IO_TOTAL_STATISTICS
UNION ALL
SELECT
  12100 + LN, RPAD(HOST, HOST_LEN) || CHAR(32) || RPAD(TYPE, 6) || CHAR(32) || LPAD(IO_READ_ACT_PCT, 16) || CHAR(32) || LPAD(IO_READ_TP_MBPS, 16) || CHAR(32) ||
  LPAD(IO_READ_VOL_MBPS, 17) || CHAR(32) || LPAD(IO_READ_AVG_KB, 15) || CHAR(32) || LPAD(IO_READ_AVG_MS, 15)
FROM
( SELECT
    ROW_NUMBER() OVER (ORDER BY I.HOST, I.TYPE) LN,
    I.HOST,
    I.TYPE,
    TO_DECIMAL(SUM(I.TOTAL_READ_TIME) / 10000 / BI.SECONDS, 10, 2) IO_READ_ACT_PCT,
    TO_DECIMAL(SUM(I.TOTAL_WRITE_TIME) / 10000 / BI.SECONDS, 10, 2) IO_WRITE_ACT_PCT,
    MAP(SUM(I.TOTAL_READ_TIME), 0, 0, TO_DECIMAL(SUM(I.TOTAL_READ_SIZE) / 1024 / 1024 * 1000000 / SUM(I.TOTAL_READ_TIME), 10, 2)) IO_READ_TP_MBPS,
    MAP(SUM(I.TOTAL_WRITE_TIME), 0, 0, TO_DECIMAL(SUM(I.TOTAL_WRITE_SIZE) / 1024 / 1024 * 1000000 / SUM(I.TOTAL_WRITE_TIME), 10, 2)) IO_WRITE_TP_MBPS,
    MAP(BI.SECONDS, 0, 0, TO_DECIMAL(SUM(I.TOTAL_READ_SIZE) / 1024 / 1024 / BI.SECONDS, 10, 2)) IO_READ_VOL_MBPS,
    MAP(BI.SECONDS, 0, 0, TO_DECIMAL(SUM(I.TOTAL_WRITE_SIZE) / 1024 / 1024 / BI.SECONDS, 10, 2)) IO_WRITE_VOL_MBPS,
    MAP(SUM(I.TOTAL_READS), 0, 0, TO_DECIMAL(SUM(I.TOTAL_READ_SIZE) / 1024 / SUM(I.TOTAL_READS), 10, 2)) IO_READ_AVG_KB,
    MAP(SUM(I.TOTAL_WRITES), 0, 0, TO_DECIMAL(SUM(I.TOTAL_WRITE_SIZE) / 1024 / SUM(I.TOTAL_WRITES), 10, 2)) IO_WRITE_AVG_KB,
    MAP(SUM(I.TOTAL_READS), 0, 0, TO_DECIMAL(SUM(I.TOTAL_READ_TIME) / 1000 / SUM(I.TOTAL_READS), 10, 2)) IO_READ_AVG_MS,
    MAP(SUM(I.TOTAL_WRITES), 0, 0, TO_DECIMAL(SUM(I.TOTAL_WRITE_TIME) / 1000 / SUM(I.TOTAL_WRITES), 10, 2)) IO_WRITE_AVG_MS,
    I.HOST_LEN
  FROM
    BASIS_INFO BI,
    IO_TOTAL_STATISTICS I
  WHERE
    I.SERVER_TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    I.TYPE IN ('LOG', 'DATA') AND
    (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND I.SITE_ID IN (-1, 0) ) OR I.SITE_ID = BI.SITE_ID ) AND
    I.HOST LIKE BI.HOST AND
    TO_VARCHAR(I.PORT) LIKE BI.PORT
  GROUP BY
    I.HOST,
    I.TYPE,
    BI.SECONDS,
    I.HOST_LEN
)
UNION ALL SELECT TOP 1 13020, '' FROM IO_TOTAL_STATISTICS
UNION ALL SELECT TOP 1 13030, RPAD('HOST', HOST_LEN) || CHAR(32) || RPAD('TYPE', 6) || CHAR(32) || LPAD('IO_WRITE_ACT_PCT', 16) || CHAR(32) || LPAD('IO_WRITE_TP_MBPS', 16) || CHAR(32) || 
  LPAD('IO_WRITE_VOL_MBPS', 17) || CHAR(32) || LPAD('IO_WRITE_AVG_KB', 15) || CHAR(32) || LPAD('IO_WRITE_AVG_MS', 15) FROM IO_TOTAL_STATISTICS
UNION ALL SELECT TOP 1 13031, RPAD('=', HOST_LEN, '=') || CHAR(32) || RPAD('=', 6, '=') || CHAR(32) || RPAD('=', 16, '=') || CHAR(32) || RPAD('=', 16, '=') || CHAR(32) || 
  RPAD('=', 17, '=') || CHAR(32) || RPAD('=', 15, '=') || CHAR(32) || RPAD('=', 15, '=') FROM IO_TOTAL_STATISTICS
UNION ALL
SELECT
  13100 + LN, RPAD(HOST, HOST_LEN) || CHAR(32) || RPAD(TYPE, 6) || CHAR(32) || LPAD(IO_WRITE_ACT_PCT, 16) || CHAR(32) || LPAD(IO_WRITE_TP_MBPS, 16) || CHAR(32) ||
  LPAD(IO_WRITE_VOL_MBPS, 17) || CHAR(32) || LPAD(IO_WRITE_AVG_KB, 15) || CHAR(32) || LPAD(IO_WRITE_AVG_MS, 15)
FROM
( SELECT
    ROW_NUMBER() OVER (ORDER BY I.HOST, I.TYPE) LN,
    I.HOST,
    I.TYPE,
    TO_DECIMAL(SUM(I.TOTAL_READ_TIME) / 10000 / BI.SECONDS, 10, 2) IO_READ_ACT_PCT,
    TO_DECIMAL(SUM(I.TOTAL_WRITE_TIME) / 10000 / BI.SECONDS, 10, 2) IO_WRITE_ACT_PCT,
    MAP(SUM(I.TOTAL_READ_TIME), 0, 0, TO_DECIMAL(SUM(I.TOTAL_READ_SIZE) / 1024 / 1024 * 1000000 / SUM(I.TOTAL_READ_TIME), 10, 2)) IO_READ_TP_MBPS,
    MAP(SUM(I.TOTAL_WRITE_TIME), 0, 0, TO_DECIMAL(SUM(I.TOTAL_WRITE_SIZE) / 1024 / 1024 * 1000000 / SUM(I.TOTAL_WRITE_TIME), 10, 2)) IO_WRITE_TP_MBPS,
    MAP(BI.SECONDS, 0, 0, TO_DECIMAL(SUM(I.TOTAL_READ_SIZE) / 1024 / 1024 / BI.SECONDS, 10, 2)) IO_READ_VOL_MBPS,
    MAP(BI.SECONDS, 0, 0, TO_DECIMAL(SUM(I.TOTAL_WRITE_SIZE) / 1024 / 1024 / BI.SECONDS, 10, 2)) IO_WRITE_VOL_MBPS,
    MAP(SUM(I.TOTAL_READS), 0, 0, TO_DECIMAL(SUM(I.TOTAL_READ_SIZE) / 1024 / SUM(I.TOTAL_READS), 10, 2)) IO_READ_AVG_KB,
    MAP(SUM(I.TOTAL_WRITES), 0, 0, TO_DECIMAL(SUM(I.TOTAL_WRITE_SIZE) / 1024 / SUM(I.TOTAL_WRITES), 10, 2)) IO_WRITE_AVG_KB,
    MAP(SUM(I.TOTAL_READS), 0, 0, TO_DECIMAL(SUM(I.TOTAL_READ_TIME) / 1000 / SUM(I.TOTAL_READS), 10, 2)) IO_READ_AVG_MS,
    MAP(SUM(I.TOTAL_WRITES), 0, 0, TO_DECIMAL(SUM(I.TOTAL_WRITE_TIME) / 1000 / SUM(I.TOTAL_WRITES), 10, 2)) IO_WRITE_AVG_MS,
    I.HOST_LEN
  FROM
    BASIS_INFO BI,
    IO_TOTAL_STATISTICS I
  WHERE
    I.SERVER_TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    I.TYPE IN ('LOG', 'DATA') AND
    (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND I.SITE_ID IN (-1, 0) ) OR I.SITE_ID = BI.SITE_ID ) AND
    I.HOST LIKE BI.HOST AND
    TO_VARCHAR(I.PORT) LIKE BI.PORT
  GROUP BY
    I.HOST,
    I.TYPE,
    BI.SECONDS,
    I.HOST_LEN
)
UNION ALL SELECT TOP 1 14005, '' FROM IO_TOTAL_STATISTICS_HOUR
UNION ALL SELECT TOP 1 14007, '***********************************' FROM IO_TOTAL_STATISTICS_HOUR
UNION ALL SELECT TOP 1 14010, '* SYSTEM RESOURCES - HOURLY PEAKS *' FROM IO_TOTAL_STATISTICS_HOUR
UNION ALL SELECT TOP 1 14015, '***********************************' FROM IO_TOTAL_STATISTICS_HOUR
UNION ALL SELECT TOP 1 14020, '' FROM IO_TOTAL_STATISTICS_HOUR
UNION ALL SELECT TOP 1 14030, RPAD('HOST', HOST_LEN) || CHAR(32) || RPAD('TYPE', 6) || CHAR(32) || LPAD('IO_READS', 10) || CHAR(32) || LPAD('IO_READ_SIZE_GB', 15) || CHAR(32) || 
  LPAD('IO_READ_TIME_S', 14) || CHAR(32) || LPAD('IO_WRITES', 9) || CHAR(32) || LPAD('IO_WRITE_SIZE_GB', 16) || CHAR(32) || LPAD('IO_WRITE_TIME_S', 15) FROM IO_TOTAL_STATISTICS_HOUR
UNION ALL SELECT TOP 1 14031, RPAD('=', HOST_LEN, '=') || CHAR(32) || RPAD('=', 6, '=') || CHAR(32) || RPAD('=', 10, '=') || CHAR(32) || RPAD('=', 15, '=') || CHAR(32) || 
  RPAD('=', 14, '=') || CHAR(32) || RPAD('=', 9, '=') || CHAR(32) || RPAD('=', 16, '=') || CHAR(32) || RPAD('=', 15, '=') FROM IO_TOTAL_STATISTICS_HOUR
UNION ALL
SELECT
  14100 + LN, RPAD(HOST, HOST_LEN) || CHAR(32) || RPAD(TYPE, 6) || CHAR(32) || LPAD(IO_READS, 10) || CHAR(32) || LPAD(IO_READ_SIZE_GB, 15) || CHAR(32) ||
  LPAD(IO_READ_TIME_S, 14) || CHAR(32) || LPAD(IO_WRITES, 9) || CHAR(32) || LPAD(IO_WRITE_SIZE_GB, 16) || CHAR(32) || LPAD(IO_WRITE_TIME_S, 15)
FROM
( SELECT
    ROW_NUMBER() OVER (ORDER BY I.HOST, I.TYPE) LN,
    I.HOST,
    I.TYPE,
    TO_DECIMAL(MAX(I.TOTAL_READ_SIZE) / 1024 / 1024 / 1024, 10, 2) IO_READ_SIZE_GB,
    TO_DECIMAL(MAX(I.TOTAL_WRITE_SIZE) / 1024 / 1024 / 1024, 10, 2) IO_WRITE_SIZE_GB,
    TO_DECIMAL(MAX(I.TOTAL_READ_TIME) / 1000000, 10, 2) IO_READ_TIME_S,
    TO_DECIMAL(MAX(I.TOTAL_WRITE_TIME) / 1000000, 10, 2) IO_WRITE_TIME_S,
    MAX(I.TOTAL_READS) IO_READS,
    MAX(I.TOTAL_WRITES) IO_WRITES,
    I.HOST_LEN
  FROM
    BASIS_INFO BI,
    IO_TOTAL_STATISTICS_HOUR I
  WHERE
    I.TIMESTAMP_HOUR BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    I.TYPE IN ('LOG', 'DATA') AND
    (BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND I.SITE_ID IN (-1, 0) ) OR I.SITE_ID = BI.SITE_ID ) AND
    I.HOST LIKE BI.HOST AND
    TO_VARCHAR(I.PORT) LIKE BI.PORT
  GROUP BY
    I.HOST,
    I.TYPE,
    I.HOST_LEN
)
UNION ALL SELECT TOP 1 15000, '' FROM COLUMN_STORE
UNION ALL SELECT TOP 1 15010, '****************' FROM COLUMN_STORE
UNION ALL SELECT TOP 1 15030, '* COLUMN STORE *' FROM COLUMN_STORE
UNION ALL SELECT TOP 1 15040, '****************' FROM COLUMN_STORE
UNION ALL SELECT TOP 1 15050, '' FROM COLUMN_STORE
UNION ALL SELECT TOP 1 15060, RPAD('SCHEMA_NAME', SCHEMA_LEN) || CHAR(32) || RPAD('TABLE_NAME', TABLE_LEN) || CHAR(32)  || LPAD('MEM_TOTAL_GB', 12) || CHAR(32) || 
  LPAD('MEM_MAIN_GB', 11) || CHAR(32) || LPAD('MEM_DELTA_GB', 12) || CHAR(32) || LPAD('RECORDS', 12) || CHAR(32) || LPAD('RECORDS_DELTA', 13) || CHAR(32) ||
  LPAD('READS_PER_H', 11) || CHAR(32) || LPAD('WRITES_PER_H', 12) FROM COLUMN_STORE
UNION ALL SELECT TOP 1 15070, RPAD('=', SCHEMA_LEN, '=') || CHAR(32) || RPAD('=', TABLE_LEN, '=') || CHAR(32) || LPAD('=', 12, '=') || CHAR(32) || 
  LPAD('=', 11, '=') || CHAR(32) || LPAD('=', 12, '=') || CHAR(32) || LPAD('=', 12, '=') || CHAR(32) || LPAD('=', 13, '=') || CHAR(32) || 
  LPAD('=', 11, '=') || CHAR(32) || LPAD('=', 12, '=') FROM COLUMN_STORE
UNION ALL
SELECT
  15100 + ROW_NUMBER() OVER (ORDER BY MEM_TOTAL_GB DESC) / 1000000, RPAD(SCHEMA_NAME, SCHEMA_LEN) || CHAR(32) || RPAD(TABLE_NAME, TABLE_LEN) || CHAR(32)  || LPAD(MEM_TOTAL_GB, 12) || CHAR(32) || 
  LPAD(MEM_MAIN_GB, 11) || CHAR(32) || LPAD(MEM_DELTA_GB, 12) || CHAR(32) || LPAD(RECORDS, 12) || CHAR(32) || LPAD(RECORDS_DELTA, 13) || CHAR(32) ||
  LPAD(READS_PER_H, 11) || CHAR(32) || LPAD(WRITES_PER_H, 12)
FROM
  COLUMN_STORE
UNION ALL SELECT TOP 1 16000, '' FROM ROW_STORE
UNION ALL SELECT TOP 1 16010, '*************' FROM ROW_STORE
UNION ALL SELECT TOP 1 16030, '* ROW STORE *' FROM ROW_STORE
UNION ALL SELECT TOP 1 16040, '*************' FROM ROW_STORE
UNION ALL SELECT TOP 1 16050, '' FROM ROW_STORE
UNION ALL SELECT TOP 1 16060, RPAD('SCHEMA_NAME', SCHEMA_LEN) || CHAR(32) || RPAD('TABLE_NAME', TABLE_LEN) || CHAR(32) || LPAD('MEM_TOTAL_GB', 12) || CHAR(32) ||
  LPAD('MEM_TAB_GB', 10) || CHAR(32) || LPAD('MEM_IND_GB', 10) || CHAR(32) || LPAD('RECORDS', 11) FROM ROW_STORE
UNION ALL SELECT TOP 1 16070, RPAD('=', SCHEMA_LEN, '=') || CHAR(32) || RPAD('=', TABLE_LEN, '=') || CHAR(32) || LPAD('=', 12, '=') || CHAR(32) || 
  LPAD('=', 10, '=') || CHAR(32) || LPAD('=', 10, '=') || CHAR(32) || LPAD('=', 11, '=') FROM ROW_STORE
UNION ALL
SELECT
  16100 + ROW_NUMBER () OVER (ORDER BY MEM_TOTAL_GB DESC) / 1000000, RPAD(SCHEMA_NAME, SCHEMA_LEN) || CHAR(32) || RPAD(TABLE_NAME, TABLE_LEN) || CHAR(32) || LPAD(MEM_TOTAL_GB, 12) || CHAR(32) ||
  LPAD(MEM_TAB_GB, 10) || CHAR(32) || LPAD(MEM_IND_GB, 10) || CHAR(32) || LPAD(RECORDS, 11)
FROM
  ROW_STORE
UNION ALL SELECT TOP 1 17000, '' FROM PERSISTENCE
UNION ALL SELECT TOP 1 17010, '***************' FROM PERSISTENCE
UNION ALL SELECT TOP 1 17030, '* PERSISTENCE *' FROM PERSISTENCE
UNION ALL SELECT TOP 1 17040, '***************' FROM PERSISTENCE
UNION ALL SELECT TOP 1 17050, '' FROM PERSISTENCE
UNION ALL SELECT TOP 1 17060, RPAD('SCHEMA_NAME', SCHEMA_LEN) || CHAR(32) || RPAD('TABLE_NAME', TABLE_LEN) || CHAR(32) || LPAD('DISK_GB', 8) || CHAR(32) ||
  LPAD('READ_GB', 8) || CHAR(32) || LPAD('WRITE_GB', 8) || CHAR(32) || LPAD('APPEND_GB', 9) FROM PERSISTENCE
UNION ALL SELECT TOP 1 17070, RPAD('=', SCHEMA_LEN, '=') || CHAR(32) || RPAD('=', TABLE_LEN, '=') || CHAR(32) || LPAD('=', 8, '=') || CHAR(32) || 
  LPAD('=', 8, '=') || CHAR(32) || LPAD('=', 8, '=') || CHAR(32) || LPAD('=', 9, '=') FROM PERSISTENCE
UNION ALL
SELECT
  17100 + ROW_NUMBER () OVER (ORDER BY DISK_GB DESC) / 1000000, RPAD(SCHEMA_NAME, SCHEMA_LEN) || CHAR(32) || RPAD(TABLE_NAME, TABLE_LEN) || CHAR(32) || LPAD(DISK_GB, 8) || CHAR(32) || 
  LPAD(READ_GB, 8) || CHAR(32) || LPAD(WRITE_GB, 8) || CHAR(32) || LPAD(APPEND_GB, 9)
FROM
  PERSISTENCE
UNION ALL SELECT TOP 1 20000, '' FROM BLOCKED_TRANSACTIONS
UNION ALL SELECT TOP 1 20010, '************************' FROM BLOCKED_TRANSACTIONS
UNION ALL SELECT TOP 1 20030, '* BLOCKED TRANSACTIONS *' FROM BLOCKED_TRANSACTIONS
UNION ALL SELECT TOP 1 20040, '************************' FROM BLOCKED_TRANSACTIONS
UNION ALL SELECT TOP 1 20050, '' FROM BLOCKED_TRANSACTIONS
UNION ALL SELECT TOP 1 20060, RPAD('TIMESTAMP', 19) || CHAR(32) || LPAD('WAITING_S', 9) || CHAR(32) || RPAD('TABLE_NAME', TABLE_LEN) || CHAR(32) ||
  LPAD('BLOCKED_UTID', 12) || CHAR(32) || LPAD('BLOCKING_UTID', 13) || CHAR(32) || RPAD('BLOCKED_STATEMENT_HASH', 32) FROM BLOCKED_TRANSACTIONS
UNION ALL SELECT TOP 1 20070, RPAD('=', 19, '=') || CHAR(32) || RPAD('=', 9, '=') || CHAR(32) || RPAD('=', TABLE_LEN, '=') || CHAR(32) || 
  LPAD('=', 12, '=') || CHAR(32) || LPAD('=', 13, '=') || CHAR(32) || RPAD('=', 32, '=') FROM BLOCKED_TRANSACTIONS
UNION ALL
SELECT
  20100 + ROW_NUMBER () OVER (ORDER BY TIMESTAMP DESC) / 1000000, RPAD(TIMESTAMP, 19) || CHAR(32) || LPAD(WAITING_S, 9) || CHAR(32) || RPAD(TABLE_NAME, TABLE_LEN) || CHAR(32) ||
  LPAD(BLOCKED_UTID, 12) || CHAR(32) || LPAD(BLOCKING_UTID, 13) || CHAR(32) || RPAD(BLOCKED_STATEMENT_HASH, 32)
FROM
  BLOCKED_TRANSACTIONS
UNION ALL SELECT TOP 1 30000, '' FROM INTERNAL_ACTIVITIES
UNION ALL SELECT TOP 1 30010, '***********************' FROM INTERNAL_ACTIVITIES
UNION ALL SELECT TOP 1 30030, '* INTERNAL ACTIVITIES *' FROM INTERNAL_ACTIVITIES
UNION ALL SELECT TOP 1 30040, '***********************' FROM INTERNAL_ACTIVITIES
UNION ALL SELECT TOP 1 30050, '' FROM INTERNAL_ACTIVITIES
UNION ALL SELECT TOP 1 30060, RPAD('ACTIVITY', 39) || CHAR(32) || RPAD('HOST', HOST_LEN) || CHAR(32) || LPAD('TOTAL', 9) || CHAR(32) || LPAD('PER_HOUR', 9) || CHAR(32) ||
  LPAD('AVG_ACTIVE', 10) || CHAR(32) || LPAD('RECORDS_PER_HOUR', 16) FROM INTERNAL_ACTIVITIES
UNION ALL SELECT TOP 1 30070, RPAD('=', 39, '=') || CHAR(32) || RPAD('=', HOST_LEN, '=') || CHAR(32) || RPAD('=', 9, '=') || CHAR(32) || LPAD('=', 9, '=') || CHAR(32) || 
  LPAD('=', 10, '=') || CHAR(32) || LPAD('=', 16, '=') FROM INTERNAL_ACTIVITIES
UNION ALL
SELECT
  30100 + ROW_NUMBER () OVER (ORDER BY ACTIVITY, HOST) / 1000, RPAD(ACTIVITY, 39) || CHAR(32) || RPAD(HOST, HOST_LEN) || CHAR(32) || LPAD(TOTAL, 9) || CHAR(32) || LPAD(PER_HOUR, 9) || CHAR(32) ||
  LPAD(AVG_ACTIVE, 10) || CHAR(32) || LPAD(RECORDS_PER_HOUR, 16)
FROM
  INTERNAL_ACTIVITIES
UNION ALL SELECT TOP 1 31050, '' FROM TABLE_OPTIMIZATIONS
UNION ALL SELECT TOP 1 31060, RPAD('SCHEMA_NAME', SCHEMA_LEN) || CHAR(32) || RPAD('TABLE_NAME', TABLE_LEN) || CHAR(32) || RPAD('TYPE', 14) || CHAR(32) || 
  LPAD('EXECUTIONS', 10) || CHAR(32) || LPAD('TOTAL_TIME_S', 12) || CHAR(32) || LPAD('AVG_TIME_S', 10) FROM TABLE_OPTIMIZATIONS
UNION ALL SELECT TOP 1 31070, RPAD('=', SCHEMA_LEN, '=') || CHAR(32) || RPAD('=', TABLE_LEN, '=') || CHAR(32) || RPAD('=', 14, '=') || CHAR(32) || 
  LPAD('=', 10, '=') || CHAR(32) || LPAD('=', 12, '=') || CHAR(32) || LPAD('=', 10, '=') FROM TABLE_OPTIMIZATIONS
UNION ALL
SELECT
  31100 + ROW_NUMBER () OVER (ORDER BY TOTAL_TIME_S DESC) / 1000000, RPAD(SCHEMA_NAME, SCHEMA_LEN) || CHAR(32) || RPAD(TABLE_NAME, TABLE_LEN) || CHAR(32) || RPAD(TYPE, 14) || CHAR(32) ||
  LPAD(EXECUTIONS, 10) || CHAR(32) || LPAD(TOTAL_TIME_S, 12) || CHAR(32) || LPAD(AVG_TIME_S, 10)  
FROM
  TABLE_OPTIMIZATIONS
UNION ALL SELECT 40000, '' FROM DUMMY
UNION ALL SELECT 40010, '**********' FROM DUMMY
UNION ALL SELECT 40030, '* MEMORY *' FROM DUMMY
UNION ALL SELECT 40040, '**********' FROM DUMMY
UNION ALL SELECT TOP 1 40050, '' FROM MEMORY_2
UNION ALL SELECT TOP 1 40060, RPAD('HOST', HOST_LEN) || CHAR(32) || RPAD('COMPONENT', COMPONENT_LEN) || CHAR(32) || LPAD('MAX_SIZE_GB', 11) FROM MEMORY_2
UNION ALL SELECT TOP 1 40070, RPAD('=', HOST_LEN, '=') || CHAR(32) || RPAD('=', COMPONENT_LEN, '=') || CHAR(32) || LPAD('=', 11, '=') FROM MEMORY_2
UNION ALL
SELECT
  40100 + ROW_NUMBER() OVER (ORDER BY MAX_SIZE_GB DESC) / 1000, RPAD(HOST, HOST_LEN) || CHAR(32) || RPAD(COMPONENT, COMPONENT_LEN) || CHAR(32) || LPAD(MAX_SIZE_GB, 11)
FROM
  MEMORY_2
UNION ALL SELECT TOP 1 40550, '' FROM MEMORY_1
UNION ALL SELECT TOP 1 40560, RPAD('HOST', HOST_LEN) || CHAR(32) || RPAD('DETAIL', DETAIL_LEN) || CHAR(32) || RPAD('COMPONENT', COMPONENT_LEN) || CHAR(32) || LPAD('MAX_SIZE_GB', 11) FROM MEMORY_1
UNION ALL SELECT TOP 1 40570, RPAD('=', HOST_LEN, '=') || CHAR(32) || RPAD('=', DETAIL_LEN, '=') || CHAR(32) || RPAD('=', COMPONENT_LEN, '=') || CHAR(32) || LPAD('=', 11, '=') FROM MEMORY_1
UNION ALL
SELECT
  40600 + ROW_NUMBER () OVER (ORDER BY MAX_SIZE_GB DESC) / 1000, RPAD(HOST, HOST_LEN) || CHAR(32) || RPAD(DETAIL, DETAIL_LEN) || CHAR(32) || RPAD(COMPONENT, COMPONENT_LEN) || CHAR(32) || LPAD(MAX_SIZE_GB, 11)
FROM
  MEMORY_1
UNION ALL SELECT 50000, '' FROM DUMMY
UNION ALL SELECT 50010, '****************' FROM DUMMY
UNION ALL SELECT 50030, '* LOAD HISTORY *' FROM DUMMY
UNION ALL SELECT 50040, '****************' FROM DUMMY
UNION ALL SELECT TOP 1 50050, '' FROM LOAD_HISTORY_HOST
UNION ALL SELECT TOP 1 50060, RPAD('HOST', HOST_LEN) || CHAR(32) || LPAD('MEM_USED_GB', 13) || CHAR(32) || LPAD('DISK_USED_GB', 12) || CHAR(32) ||
  LPAD('NETWORK_IN_MBPS', 15) || CHAR(32) || LPAD('NETWORK_OUT_MBPS', 16) || CHAR(32) || LPAD('SWAP_OUT_MBPS', 13) FROM LOAD_HISTORY_HOST
UNION ALL SELECT TOP 1 50065, RPAD('    ', HOST_LEN) || CHAR(32) || LPAD('   AVG /  MAX', 13) || CHAR(32) || LPAD('   AVG / MAX', 12) || CHAR(32) ||
  LPAD(' ', 15) || CHAR(32) || LPAD(' ', 16) || CHAR(32) || LPAD(' ', 13) FROM LOAD_HISTORY_HOST
UNION ALL SELECT TOP 1 50070, RPAD('=', HOST_LEN, '=') || CHAR(32) || RPAD('=', 13, '=') || CHAR(32) || RPAD('=', 12, '=') || CHAR(32) || 
  LPAD('=', 15, '=') || CHAR(32) || LPAD('=', 16, '=') || CHAR(32) || LPAD('=', 13, '=') FROM LOAD_HISTORY_HOST
UNION ALL
SELECT
  50100 + ROW_NUMBER () OVER (ORDER BY HOST) / 1000, RPAD(HOST, HOST_LEN) || CHAR(32) || LPAD(MEM_USED_GB, 13) || CHAR(32) || LPAD(DISK_USED_GB, 12) || CHAR(32) ||
  LPAD(NETWORK_IN_MBPS, 15) || CHAR(32) || LPAD(NETWORK_OUT_MBPS, 16) || CHAR(32) || LPAD(SWAP_OUT_MBPS, 13)
FROM
  LOAD_HISTORY_HOST
UNION ALL SELECT TOP 1 50150, '' FROM LOAD_HISTORY_SERVICES
UNION ALL SELECT TOP 1 50160, RPAD('HOST', HOST_LEN) || CHAR(32) || LPAD('PORT', 5) || CHAR(32) || LPAD('CPU_%', 10) || CHAR(32) || LPAD('SYS_CPU_%', 10) || CHAR(32) || 
  LPAD('PING_MS', 10) || CHAR(32) || LPAD('CID_RANGE', 9) || CHAR(32) || LPAD('VERSIONS', 9) || CHAR(32) || LPAD('CONNS', 5) || CHAR(32) ||
  LPAD('TRANS', 5) || CHAR(32) || LPAD('BLK_TRNS', 8) || CHAR(32) || LPAD('STMT_PER_S', 10) || CHAR(32) || LPAD('PEND_SESS', 9) || CHAR(32) ||
  LPAD('ACT_THREADS', 11) || CHAR(32) || LPAD('WAIT_THRDS', 10) FROM LOAD_HISTORY_SERVICES
UNION ALL SELECT TOP 1 50165, RPAD(' ', HOST_LEN) || CHAR(32) || LPAD(' ', 5) || CHAR(32) || LPAD('AVG / MAX', 10) || CHAR(32) || LPAD('AVG / MAX', 10) || CHAR(32) || 
  LPAD(' AVG / MAX', 10) || CHAR(32) || RPAD('     MAX', 9) || CHAR(32) || RPAD('     MAX', 9) || CHAR(32) || RPAD('  MAX', 5) || CHAR(32) || 
  RPAD('  MAX', 5) || CHAR(32) || RPAD('    MAX', 8) || CHAR(32) || LPAD('', 10) || CHAR(32) || RPAD('     MAX', 9) || CHAR(32) || 
  RPAD('  AVG / MAX', 11) || CHAR(32) || RPAD(' AVG / MAX', 10) FROM LOAD_HISTORY_SERVICES
UNION ALL SELECT TOP 1 50170, RPAD('=', HOST_LEN, '=') || CHAR(32) || LPAD('=', 5, '=') || CHAR(32) || LPAD('=', 10, '=') || CHAR(32) || LPAD('=', 10, '=') || CHAR(32) || 
  LPAD('=', 10, '=') || CHAR(32) || LPAD('=', 9, '=') || CHAR(32) || LPAD('=', 9, '=') || CHAR(32) || LPAD('=', 5, '=') || CHAR(32) || 
  LPAD('=', 5, '=') || CHAR(32) || LPAD('=', 8, '=') || CHAR(32) || LPAD('=', 10, '=') || CHAR(32) || LPAD('=', 9, '=') ||
  CHAR(32) || LPAD('=', 11, '=') || CHAR(32) || LPAD('=', 10, '=') FROM LOAD_HISTORY_SERVICES
UNION ALL
SELECT
  50200 + ROW_NUMBER () OVER (ORDER BY HOST, PORT) / 1000, RPAD(HOST, HOST_LEN) || CHAR(32) || LPAD(PORT, 5) || CHAR(32) || LPAD(CPU_PCT, 10) || CHAR(32) || LPAD(SYS_CPU_PCT, 10) || CHAR(32) || 
    LPAD(PING_MS, 10) || CHAR(32) || LPAD(MAX_CID_RANGE, 9) || CHAR(32) || LPAD(MAX_VERSION_COUNT, 9) || CHAR(32) || LPAD(CONNECTIONS, 5) || CHAR(32) || 
    LPAD(TRANSACTIONS, 5) || CHAR(32) || LPAD(BLOCKED_TRANSACTIONS, 8) || CHAR(32) || LPAD(STATEMENTS_PER_S, 10) || CHAR(32) || LPAD(PENDING_SESSIONS, 9) || CHAR(32) || 
    LPAD(ACTIVE_THREADS, 11) || LPAD(WAITING_THREADS, 10)
FROM
  LOAD_HISTORY_SERVICES
UNION ALL SELECT 60000, '' FROM DUMMY
UNION ALL SELECT 60010, '***************************************' FROM DUMMY
UNION ALL SELECT 60030, '* TRANSACTIONS AND GARBAGE COLLECTION *' FROM DUMMY
UNION ALL SELECT 60040, '***************************************' FROM DUMMY
UNION ALL SELECT 60050, '' FROM DUMMY
UNION ALL SELECT 60060, RPAD('TIMESTAMP', 21) || LPAD('IDLE_S', 7) || CHAR(32) || RPAD('STATUS', 21) || RPAD('APP_NAME', 21) || RPAD('APP_USER', 16) || 'STATEMENT_STRING' FROM DUMMY
UNION ALL SELECT 60070, RPAD('=', 21, '=') || CHAR(32) || RPAD('=', 6, '=') || CHAR(32) || RPAD('=', 20, '=') || CHAR(32) || LPAD('=', 20, '=') || CHAR(32) || LPAD('=', 15, '=') || CHAR(32) || LPAD('=', 112, '=') FROM DUMMY
UNION ALL
SELECT
  60100 + LN / 1000, TO_VARCHAR(SERVER_TIMESTAMP, 'YYYY/MM/DD HH24:MI:SS') || LPAD(IDLE_TIME, 9) || CHAR(32) || RPAD(STATEMENT_STATUS, 21) || RPAD(APPLICATION, 20) || CHAR(32) || RPAD(APP_USER, 15) || CHAR(32) || STATEMENT_STRING
FROM
( SELECT
    ROW_NUMBER() OVER (ORDER BY MAX(C.IDLE_TIME) DESC) LN,
    TO_VARCHAR(SUBSTR(C.STATEMENT_STRING, 1, 112)) STATEMENT_STRING,
    MAX(C.SERVER_TIMESTAMP) SERVER_TIMESTAMP,
    MAX(C.IDLE_TIME) IDLE_TIME,
    MAX(C.STATEMENT_STATUS) STATEMENT_STATUS,
    MAX(C.APPLICATION) APPLICATION,
    MAX(C.APPLICATIONUSER) APP_USER,
    BI.TOP_N_IDLE_CURSORS
  FROM
    BASIS_INFO BI,
    _SYS_STATISTICS.HOST_LONG_IDLE_CURSOR C
  WHERE
    C.SERVER_TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    C.HOST LIKE BI.HOST AND
    TO_VARCHAR(C.PORT) LIKE BI.PORT
  GROUP BY
    C.START_MVCC_TIMESTAMP,
    TO_VARCHAR(SUBSTR(C.STATEMENT_STRING, 1, 112)),
    BI.TOP_N_IDLE_CURSORS
)
WHERE
  LN <= TOP_N_IDLE_CURSORS
UNION ALL SELECT 60150, '' FROM DUMMY
UNION ALL SELECT 60160, RPAD('TIMESTAMP', 21) || LPAD('ACTIVE_S', 9) || LPAD('CONN_ID', 10) || LPAD('TRANS_ID', 9) || LPAD('UTID', 20) || CHAR(32) || RPAD('APP_USER', 16) || RPAD('CLIENT_HOST', 20) FROM DUMMY
UNION ALL SELECT 60170, RPAD('=', 21, '=') || CHAR(32) || RPAD('=', 8, '=') || CHAR(32) || RPAD('=', 9, '=') || CHAR(32) || LPAD('=', 8, '=') || CHAR(32) || LPAD('=', 19, '=') ||
  CHAR(32) || LPAD('=', 15, '=') || CHAR(32) || LPAD('=', 19, '=') FROM DUMMY
UNION ALL
SELECT
  60200 + LN / 1000, TO_VARCHAR(SERVER_TIMESTAMP, 'YYYY/MM/DD HH24:MI:SS') || LPAD(ACTIVE_S, 11) || LPAD(CONN_ID, 10) || LPAD(TRANS_ID, 9) || LPAD(UTID, 20) || CHAR(32) || RPAD(APP_USER, 15) || CHAR(32) ||
    RPAD(CLIENT_HOST, 20)
FROM
( SELECT
    ROW_NUMBER() OVER (ORDER BY S.DURATION DESC) LN,
    S.SERVER_TIMESTAMP SERVER_TIMESTAMP,
    S.CONNECTION_ID CONN_ID,
    S.TRANSACTION_ID TRANS_ID,
    S.UPDATE_TRANSACTION_ID UTID,
    TO_DECIMAL(ROUND(S.DURATION / 1000), 10, 0) ACTIVE_S,
    S.APPLICATION_USER_NAME APP_USER,
    S.CLIENT_HOST CLIENT_HOST,
    BI.TOP_N_LONGRUNNERS
  FROM
    BASIS_INFO BI,
    _SYS_STATISTICS.HOST_LONG_RUNNING_STATEMENTS S
  WHERE
    S.SERVER_TIMESTAMP BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    S.HOST LIKE BI.HOST AND
    TO_VARCHAR(S.PORT) LIKE BI.PORT
)
WHERE
  LN <= TOP_N_LONGRUNNERS
UNION ALL SELECT 70000, '' FROM DUMMY
UNION ALL SELECT 70010, '*************' FROM DUMMY
UNION ALL SELECT 70030, '* SQL CACHE *' FROM DUMMY
UNION ALL SELECT 70040, '*************' FROM DUMMY
UNION ALL SELECT 70050, '' FROM DUMMY
UNION ALL SELECT 70060, RPAD('STATEMENT_HASH', 33) || RPAD('TP', 3) || LPAD('ELAPSED_S', 11) || LPAD('PER_EXEC_MS', 12)|| LPAD('ACT_SESS', 9) || LPAD('EXECUTIONS', 12) || LPAD('RECORDS', 13) || LPAD('REC_PER_EXEC', 13) || CHAR(32) || 'ACCESSED_OBJECTS' FROM DUMMY
UNION ALL SELECT 70070, RPAD('=', 32, '=') || CHAR(32) || RPAD('==', 2) || CHAR(32) || LPAD('=', 11, '=') || CHAR(32) || LPAD('=', 11, '=') || CHAR(32) || LPAD('=', 8, '=') || CHAR(32) || LPAD('=', 11, '=') || CHAR(32) || LPAD('=', 12, '=') || CHAR(32) || LPAD('=', 12, '=') ||
  CHAR(32) || LPAD('=', 95, '=') FROM DUMMY
UNION ALL
SELECT
  70100 + LN / 1000, RPAD(STATEMENT_HASH, 33) || RPAD(SQL_TYPE, 3) || LPAD(ELAPSED_S, 11) || LPAD(ELA_PER_EXEC_MS, 12) || LPAD(ACT_SESS, 9) || LPAD(EXECUTIONS, 12) || LPAD(RECORDS, 13) || LPAD(REC_PER_EXEC, 13) || 
    CHAR(32) || RPAD(ACCESSED_OBJECTS, 95)
FROM
( SELECT
    ROW_NUMBER() OVER (ORDER BY S.ELAPSED_S DESC) LN,
    STATEMENT_HASH,
    SQL_TYPE,
    TO_DECIMAL(ROUND(S.ELAPSED_S), 10, 0) ELAPSED_S,
    MAP(S.EXECUTIONS, 0, 0,TO_DECIMAL(S.ELAPSED_S * 1000 / S.EXECUTIONS, 10, 2)) ELA_PER_EXEC_MS,
    TO_DECIMAL(S.ELAPSED_S / BI.SECONDS, 10, 2) ACT_SESS,
    S.EXECUTIONS,
    S.RECORDS,
    TO_DECIMAL(MAP(S.EXECUTIONS, 0, 0, S.RECORDS / S.EXECUTIONS), 10, 2) REC_PER_EXEC,
    S.ACCESSED_OBJECTS
  FROM
    BASIS_INFO BI,
    SQLHIST S
)
UNION ALL SELECT 70300, '' FROM DUMMY
UNION ALL SELECT 70310, '************************' FROM DUMMY
UNION ALL SELECT 70330, '* EXPENSIVE STATEMENTS *' FROM DUMMY
UNION ALL SELECT 70340, '************************' FROM DUMMY
UNION ALL SELECT 70350, '' FROM DUMMY
UNION ALL SELECT 70360, RPAD('START_TIME', 20) || RPAD('STATEMENT_HASH', 33) || RPAD('OPERATION', 21) || LPAD('ELAPSED_S', 11) || LPAD('RECORDS', 13) || CHAR(32) || RPAD('SQL_TEXT', 100) FROM DUMMY
UNION ALL SELECT 70370, RPAD('=', 19, '=') || CHAR(32) || RPAD('=', 32, '=') || CHAR(32) || RPAD('=', 20, '=') || CHAR(32) || LPAD('=', 11, '=') || CHAR(32) || LPAD('=', 12, '=') || CHAR(32) || RPAD('=', 100, '=') FROM DUMMY
UNION ALL SELECT
  70400 + LN / 1000, RPAD(TO_VARCHAR(START_TIME, 'YYYY/MM/DD HH24:MI:SS'), 20) || RPAD(STATEMENT_HASH, 33) || RPAD(OPERATION, 21) || LPAD(ELAPSED_S, 11) || LPAD(RECORDS, 13) || CHAR(32) || SQL_TEXT
FROM
( SELECT
    ROW_NUMBER () OVER (ORDER BY E.DURATION_MICROSEC DESC) LN,
    E.START_TIME,
    E.STATEMENT_HASH,
    E.OPERATION,
    TO_DECIMAL(E.DURATION_MICROSEC / 1000000, 10, 2) ELAPSED_S,
    E.RECORDS,
    TO_VARCHAR(REPLACE(REPLACE(REPLACE(SUBSTR(E.STATEMENT_STRING, 1, 4000), CHAR(10), CHAR(32)), CHAR(13), CHAR(32)), CHAR(9), CHAR(32))) SQL_TEXT,
    BI.TOP_N_EXPENSIVE_SQL_TIME
  FROM
    BASIS_INFO BI,
    M_EXPENSIVE_STATEMENTS E
  WHERE
    E.START_TIME BETWEEN BI.BEGIN_TIME AND BI.END_TIME
)
WHERE
  LN <= TOP_N_EXPENSIVE_SQL_TIME
UNION ALL SELECT 70600, '' FROM DUMMY
UNION ALL SELECT 70610, '***********************' FROM DUMMY
UNION ALL SELECT 70630, '* EXECUTED STATEMENTS *' FROM DUMMY
UNION ALL SELECT 70640, '***********************' FROM DUMMY
UNION ALL SELECT 70650, '' FROM DUMMY
UNION ALL SELECT 70660, RPAD('START_TIME', 20) || RPAD('STATEMENT_HASH', 33) || LPAD('ELAPSED_S', 11) || CHAR(32) || RPAD('SQL_TEXT', 100) FROM DUMMY
UNION ALL SELECT 70670, RPAD('=', 19, '=') || CHAR(32) || RPAD('=', 32, '=') || CHAR(32) || LPAD('=', 11, '=') || CHAR(32) || RPAD('=', 100, '=') FROM DUMMY
UNION ALL SELECT
  70700 + LN / 1000, RPAD(TO_VARCHAR(START_TIME, 'YYYY/MM/DD HH24:MI:SS'), 20) || RPAD(STATEMENT_HASH, 33) || LPAD(ELAPSED_S, 11) || CHAR(32) || SQL_TEXT
FROM
( SELECT
    ROW_NUMBER () OVER (ORDER BY E.DURATION_MICROSEC DESC) LN,
    E.START_TIME,
    E.STATEMENT_HASH,
    TO_DECIMAL(E.DURATION_MICROSEC / 1000000, 10, 2) ELAPSED_S,
    TO_VARCHAR(REPLACE(REPLACE(REPLACE(SUBSTR(E.STATEMENT_STRING, 1, 4000), CHAR(10), CHAR(32)), CHAR(13), CHAR(32)), CHAR(9), CHAR(32))) SQL_TEXT,
    BI.TOP_N_EXECUTED_SQL_TIME
  FROM
    BASIS_INFO BI,
    M_EXECUTED_STATEMENTS E
  WHERE
    E.START_TIME BETWEEN BI.BEGIN_TIME AND BI.END_TIME
)
WHERE
  LN <= TOP_N_EXECUTED_SQL_TIME
UNION ALL SELECT TOP 1 80000, '' FROM THREADS
UNION ALL SELECT TOP 1 80010, '*********************' FROM THREADS
UNION ALL SELECT TOP 1 80030, '* THREAD ACTIVITIES *' FROM THREADS
UNION ALL SELECT TOP 1 80040, '*********************' FROM THREADS
UNION ALL SELECT TOP 1 80050, '' FROM THREADS
UNION ALL SELECT TOP 1 80060, LPAD('SAMPLES', 11) || CHAR(32) || LPAD('AVG_ACTIVE_THREADS', 18)|| CHAR(32) || LPAD('PCT_OF_TOTAL_LOAD', 17) || CHAR(32) || 'STATEMENT_HASH' FROM THREADS
UNION ALL SELECT TOP 1 80070, LPAD('=', 11, '=') || CHAR(32) || LPAD('=', 18, '=') || CHAR(32) || LPAD('=', 17, '=') || CHAR(32) || RPAD('=', 50, '=') FROM THREADS
UNION ALL
SELECT
  80100 + LN / 1000, LPAD(SAMPLES, 11) || CHAR(32) || LPAD(ACT_THR, 18) || CHAR(32) || LPAD(THR_PCT, 17) || CHAR(32) || STATEMENT_HASH
FROM
( SELECT
    ROW_NUMBER () OVER (ORDER BY SUM(T.NUM_SAMPLES) DESC) LN,
    T.STATEMENT_HASH,
    SUM(T.NUM_SAMPLES) SAMPLES,
    TO_DECIMAL(SUM(T.ACT_THR), 10, 2) ACT_THR,
    TO_DECIMAL(SUM(T.THR_PCT), 10, 2) THR_PCT,
    BI.TOP_N_THREAD_SQL,
    T.HOST_LEN
  FROM
    BASIS_INFO BI,
    THREADS T
  GROUP BY
    T.STATEMENT_HASH,
    BI.TOP_N_THREAD_SQL,
    T.HOST_LEN
)
WHERE
  LN <= TOP_N_THREAD_SQL
UNION ALL SELECT TOP 1 80150, '' FROM THREADS
UNION ALL SELECT TOP 1 80160, LPAD('SAMPLES', 11) || CHAR(32) || LPAD('AVG_ACTIVE_THREADS', 18)|| CHAR(32) || LPAD('PCT_OF_TOTAL_LOAD', 17) || CHAR(32) || 'THREAD_TYPE' FROM THREADS
UNION ALL SELECT TOP 1 80170, LPAD('=', 11, '=') || CHAR(32) || LPAD('=', 18, '=') || CHAR(32) || LPAD('=', 17, '=') || CHAR(32) || RPAD('=', 50, '=') FROM THREADS
UNION ALL
SELECT
  80200 + LN / 1000, LPAD(SAMPLES, 11) || CHAR(32) || LPAD(ACT_THR, 18) || CHAR(32) || LPAD(THR_PCT, 17) || CHAR(32) || THREAD_TYPE
FROM
( SELECT
    ROW_NUMBER () OVER (ORDER BY SUM(T.NUM_SAMPLES) DESC) LN,
    T.THREAD_TYPE,
    SUM(T.NUM_SAMPLES) SAMPLES,
    TO_DECIMAL(SUM(T.ACT_THR), 10, 2) ACT_THR,
    TO_DECIMAL(SUM(T.THR_PCT), 10, 2) THR_PCT,
    BI.TOP_N_THREAD_TYPES,
    T.HOST_LEN
  FROM
    BASIS_INFO BI,
    THREADS T
  GROUP BY
    T.THREAD_TYPE,
    BI.TOP_N_THREAD_TYPES,
    T.HOST_LEN
)
WHERE
  LN <= TOP_N_THREAD_TYPES
UNION ALL SELECT TOP 1 80210, '' FROM THREADS
UNION ALL SELECT TOP 1 80211, LPAD('SAMPLES', 11) || CHAR(32) || LPAD('AVG_ACTIVE_THREADS', 18)|| CHAR(32) || LPAD('PCT_OF_TOTAL_LOAD', 17) || CHAR(32) || 'THREAD_METHOD' FROM THREADS
UNION ALL SELECT TOP 1 80212, LPAD('=', 11, '=') || CHAR(32) || LPAD('=', 18, '=') || CHAR(32) || LPAD('=', 17, '=') || CHAR(32) || RPAD('=', 50, '=') FROM THREADS
UNION ALL
SELECT
  80220 + LN / 1000, LPAD(SAMPLES, 11) || CHAR(32) || LPAD(ACT_THR, 18) || CHAR(32) || LPAD(THR_PCT, 17) || CHAR(32) || THREAD_METHOD
FROM
( SELECT
    ROW_NUMBER () OVER (ORDER BY SUM(T.NUM_SAMPLES) DESC) LN,
    T.THREAD_METHOD,
    SUM(T.NUM_SAMPLES) SAMPLES,
    TO_DECIMAL(SUM(T.ACT_THR), 10, 2) ACT_THR,
    TO_DECIMAL(SUM(T.THR_PCT), 10, 2) THR_PCT,
    BI.TOP_N_THREAD_METHODS,
    T.HOST_LEN
  FROM
    BASIS_INFO BI,
    THREADS T
  GROUP BY
    T.THREAD_METHOD,
    BI.TOP_N_THREAD_METHODS,
    T.HOST_LEN
)
WHERE
  LN <= TOP_N_THREAD_METHODS
UNION ALL SELECT TOP 1 80250, '' FROM THREADS
UNION ALL SELECT TOP 1 80260, LPAD('SAMPLES', 11) || LPAD('AVG_ACTIVE_THREADS', 19)|| LPAD('PCT_OF_TOTAL_LOAD', 18) || CHAR(32) || 'THREAD_STATE_AND_LOCK' FROM THREADS
UNION ALL SELECT TOP 1 80270, LPAD('=', 11, '=') || CHAR(32) || LPAD('=', 18, '=') || CHAR(32) || LPAD('=', 17, '=') || CHAR(32) || RPAD('=', 80, '=') FROM THREADS
UNION ALL
SELECT
  80300 + LN / 1000, LPAD(SAMPLES, 11) || CHAR(32) || LPAD(ACT_THR, 18) || CHAR(32) || LPAD(THR_PCT, 17) || CHAR(32) || THREAD_STATE
FROM
( SELECT
    ROW_NUMBER () OVER (ORDER BY SUM(T.NUM_SAMPLES) DESC) LN,
    T.THREAD_STATE || CASE WHEN LOCK_NAME IS NOT NULL and LOCK_NAME != '' AND LOCK_NAME != CHAR(63) THEN CHAR(32) || '(' || LOCK_NAME || ')' ELSE '' END THREAD_STATE,
    SUM(T.NUM_SAMPLES) SAMPLES,
    TO_DECIMAL(SUM(T.ACT_THR), 10, 2) ACT_THR,
    TO_DECIMAL(SUM(T.THR_PCT), 10, 2) THR_PCT,
    BI.TOP_N_THREAD_STATES_AND_LOCKS,
    T.HOST_LEN
  FROM
    BASIS_INFO BI,
    THREADS T
  GROUP BY
    T.THREAD_STATE || CASE WHEN LOCK_NAME IS NOT NULL and LOCK_NAME != '' AND LOCK_NAME != CHAR(63) THEN CHAR(32) || '(' || LOCK_NAME || ')' ELSE '' END,
    BI.TOP_N_THREAD_STATES_AND_LOCKS,
    T.HOST_LEN
)
WHERE
  LN <= TOP_N_THREAD_STATES_AND_LOCKS
UNION ALL SELECT TOP 1 80350, '' FROM THREADS
UNION ALL SELECT TOP 1 80360, LPAD('SAMPLES', 11) || CHAR(32) || LPAD('AVG_ACTIVE_THREADS', 18)|| CHAR(32) || LPAD('PCT_OF_TOTAL_LOAD', 17) || CHAR(32) || 'DB_USER' FROM THREADS
UNION ALL SELECT TOP 1 80370, LPAD('=', 11, '=') || CHAR(32) || LPAD('=', 18, '=') || CHAR(32) || LPAD('=', 17, '=') || CHAR(32) || RPAD('=', 50, '=') FROM THREADS
UNION ALL
SELECT
  80400 + LN / 1000, LPAD(SAMPLES, 11) || CHAR(32) || LPAD(ACT_THR, 18) || CHAR(32) || LPAD(THR_PCT, 17) || CHAR(32) || DB_USER
FROM
( SELECT
    ROW_NUMBER () OVER (ORDER BY SUM(T.NUM_SAMPLES) DESC) LN,
    T.DB_USER,
    SUM(T.NUM_SAMPLES) SAMPLES,
    TO_DECIMAL(SUM(T.ACT_THR), 10, 2) ACT_THR,
    TO_DECIMAL(SUM(T.THR_PCT), 10, 2) THR_PCT,
    BI.TOP_N_THREAD_DB_USERS,
    T.HOST_LEN
  FROM
    BASIS_INFO BI,
    THREADS T
  GROUP BY
    T.DB_USER,
    BI.TOP_N_THREAD_DB_USERS,
    T.HOST_LEN
)
WHERE
  LN <= TOP_N_THREAD_DB_USERS
UNION ALL SELECT TOP 1 80450, '' FROM THREADS
UNION ALL SELECT TOP 1 80460, LPAD('SAMPLES', 11) || CHAR(32) || LPAD('AVG_ACTIVE_THREADS', 18)|| CHAR(32) || LPAD('PCT_OF_TOTAL_LOAD', 17) || CHAR(32) || 'APPLICATION_USER' FROM THREADS
UNION ALL SELECT TOP 1 80470, LPAD('=', 11, '=') || CHAR(32) || LPAD('=', 18, '=') || CHAR(32) || LPAD('=', 17, '=') || CHAR(32) || RPAD('=', 50, '=') FROM THREADS
UNION ALL
SELECT
  80500 + LN / 1000, LPAD(SAMPLES, 11) || CHAR(32) || LPAD(ACT_THR, 18) || CHAR(32) || LPAD(THR_PCT, 17) || CHAR(32) || APP_USER
FROM
( SELECT
    ROW_NUMBER () OVER (ORDER BY SUM(T.NUM_SAMPLES) DESC) LN,
    T.APP_USER,
    SUM(T.NUM_SAMPLES) SAMPLES,
    TO_DECIMAL(SUM(T.ACT_THR), 10, 2) ACT_THR,
    TO_DECIMAL(SUM(T.THR_PCT), 10, 2) THR_PCT,
    BI.TOP_N_THREAD_APP_USERS,
    T.HOST_LEN
  FROM
    BASIS_INFO BI,
    THREADS T
  GROUP BY
    T.APP_USER,
    BI.TOP_N_THREAD_APP_USERS,
    T.HOST_LEN
)
WHERE
  LN <= TOP_N_THREAD_APP_USERS
UNION ALL SELECT TOP 1 80550, '' FROM THREADS
UNION ALL SELECT TOP 1 80560, LPAD('SAMPLES', 11) || CHAR(32) || LPAD('AVG_ACTIVE_THREADS', 18)|| CHAR(32) || LPAD('PCT_OF_TOTAL_LOAD', 17) || CHAR(32) || 'APPLICATION_NAME' FROM THREADS
UNION ALL SELECT TOP 1 80570, LPAD('=', 11, '=') || CHAR(32) || LPAD('=', 18, '=') || CHAR(32) || LPAD('=', 17, '=') || CHAR(32) || RPAD('=', 50, '=') FROM THREADS
UNION ALL
SELECT
  80600 + LN / 1000, LPAD(SAMPLES, 11) || CHAR(32) || LPAD(ACT_THR, 18) || CHAR(32) || LPAD(THR_PCT, 17) || CHAR(32) || APP_NAME
FROM
( SELECT
    ROW_NUMBER () OVER (ORDER BY SUM(T.NUM_SAMPLES) DESC) LN,
    T.APP_NAME,
    SUM(T.NUM_SAMPLES) SAMPLES,
    TO_DECIMAL(SUM(T.ACT_THR), 10, 2) ACT_THR,
    TO_DECIMAL(SUM(T.THR_PCT), 10, 2) THR_PCT,
    BI.TOP_N_THREAD_APP_NAMES,
    T.HOST_LEN
  FROM
    BASIS_INFO BI,
    THREADS T
  GROUP BY
    T.APP_NAME,
    BI.TOP_N_THREAD_APP_NAMES,
    T.HOST_LEN
)
WHERE
  LN <= TOP_N_THREAD_APP_NAMES
UNION ALL SELECT TOP 1 80650, '' FROM THREADS
UNION ALL SELECT TOP 1 80660, LPAD('SAMPLES', 11) || CHAR(32) || LPAD('AVG_ACTIVE_THREADS', 18)|| CHAR(32) || LPAD('PCT_OF_TOTAL_LOAD', 17) || CHAR(32) || 'APPLICATION_SOURCE' FROM THREADS
UNION ALL SELECT TOP 1 80670, LPAD('=', 11, '=') || CHAR(32) || LPAD('=', 18, '=') || CHAR(32) || LPAD('=', 17, '=') || CHAR(32) || RPAD('=', 80, '=') FROM THREADS
UNION ALL
SELECT
  80700 + LN / 1000, LPAD(SAMPLES, 11) || CHAR(32) || LPAD(ACT_THR, 18) || CHAR(32) || LPAD(THR_PCT, 17) || CHAR(32) || APP_SOURCE
FROM
( SELECT
    ROW_NUMBER () OVER (ORDER BY SUM(T.NUM_SAMPLES) DESC) LN,
    T.APP_SOURCE,
    SUM(T.NUM_SAMPLES) SAMPLES,
    TO_DECIMAL(SUM(T.ACT_THR), 10, 2) ACT_THR,
    TO_DECIMAL(SUM(T.THR_PCT), 10, 2) THR_PCT,
    BI.TOP_N_THREAD_APP_SOURCES,
    T.HOST_LEN
  FROM
    BASIS_INFO BI,
    THREADS T
  GROUP BY
    T.APP_SOURCE,
    BI.TOP_N_THREAD_APP_SOURCES,
    T.HOST_LEN
)
WHERE
  LN <= TOP_N_THREAD_APP_SOURCES
UNION ALL SELECT TOP 1 80750, '' FROM THREADS
UNION ALL SELECT TOP 1 80760, LPAD('SAMPLES', 11) || CHAR(32) || LPAD('AVG_ACTIVE_THREADS', 18)|| CHAR(32) || LPAD('PCT_OF_TOTAL_LOAD', 17) || CHAR(32) || 'PASSPORT_COMPONENT' FROM THREADS
UNION ALL SELECT TOP 1 80770, LPAD('=', 11, '=') || CHAR(32) || LPAD('=', 18, '=') || CHAR(32) || LPAD('=', 17, '=') || CHAR(32) || RPAD('=', 50, '=') FROM THREADS
UNION ALL
SELECT
  80800 + LN / 1000, LPAD(SAMPLES, 11) || CHAR(32) || LPAD(ACT_THR, 18) || CHAR(32) || LPAD(THR_PCT, 17) || CHAR(32) || PASSPORT_COMPONENT
FROM
( SELECT
    ROW_NUMBER () OVER (ORDER BY SUM(T.NUM_SAMPLES) DESC) LN,
    T.PASSPORT_COMPONENT,
    SUM(T.NUM_SAMPLES) SAMPLES,
    TO_DECIMAL(SUM(T.ACT_THR), 10, 2) ACT_THR,
    TO_DECIMAL(SUM(T.THR_PCT), 10, 2) THR_PCT,
    BI.TOP_N_THREAD_PASSPORT_COMPONENTS,
    T.HOST_LEN
  FROM
    BASIS_INFO BI,
    THREADS T
  GROUP BY
    T.PASSPORT_COMPONENT,
    BI.TOP_N_THREAD_PASSPORT_COMPONENTS,
    T.HOST_LEN
)
WHERE
  LN <= TOP_N_THREAD_PASSPORT_COMPONENTS
UNION ALL SELECT TOP 1 80850, '' FROM THREADS
UNION ALL SELECT TOP 1 80860, LPAD('SAMPLES', 11) || CHAR(32) || LPAD('AVG_ACTIVE_THREADS', 18)|| CHAR(32) || LPAD('PCT_OF_TOTAL_LOAD', 17) || CHAR(32) || 'PASSPORT_ACTION' FROM THREADS
UNION ALL SELECT TOP 1 80870, LPAD('=', 11, '=') || CHAR(32) || LPAD('=', 18, '=') || CHAR(32) || LPAD('=', 17, '=') || CHAR(32) || RPAD('=', 50, '=') FROM THREADS
UNION ALL
SELECT
  80900 + LN / 1000, LPAD(SAMPLES, 11) || CHAR(32) || LPAD(ACT_THR, 18) || CHAR(32) || LPAD(THR_PCT, 17) || CHAR(32) || PASSPORT_ACTION
FROM
( SELECT
    ROW_NUMBER () OVER (ORDER BY SUM(T.NUM_SAMPLES) DESC) LN,
    T.PASSPORT_ACTION,
    SUM(T.NUM_SAMPLES) SAMPLES,
    TO_DECIMAL(SUM(T.ACT_THR), 10, 2) ACT_THR,
    TO_DECIMAL(SUM(T.THR_PCT), 10, 2) THR_PCT,
    BI.TOP_N_THREAD_PASSPORT_ACTIONS,
    T.HOST_LEN
  FROM
    BASIS_INFO BI,
    THREADS T
  GROUP BY
    T.PASSPORT_ACTION,
    BI.TOP_N_THREAD_PASSPORT_ACTIONS,
    T.HOST_LEN
)
WHERE
  LN <= TOP_N_THREAD_PASSPORT_ACTIONS
UNION ALL SELECT TOP 1 81750, '' FROM THREADS
UNION ALL SELECT TOP 1 81760, LPAD('SAMPLES', 11) || CHAR(32) || LPAD('AVG_ACTIVE_THREADS', 18)|| CHAR(32) || LPAD('PCT_OF_TOTAL_LOAD', 17) || CHAR(32) || 'HOST_AND_PORTS' FROM THREADS
UNION ALL SELECT TOP 1 81770, LPAD('=', 11, '=') || CHAR(32) || LPAD('=', 18, '=') || CHAR(32) || LPAD('=', 17, '=') || CHAR(32) || RPAD('=', 50, '=') FROM THREADS
UNION ALL
SELECT
  81800 + LN / 1000, LPAD(SAMPLES, 11) || CHAR(32) || LPAD(ACT_THR, 18) || CHAR(32) || LPAD(THR_PCT, 17) || CHAR(32) || HOST_AND_PORT
FROM
( SELECT
    ROW_NUMBER () OVER (ORDER BY SUM(T.NUM_SAMPLES) DESC) LN,
    T.HOST || ':' || T.PORT HOST_AND_PORT,
    SUM(T.NUM_SAMPLES) SAMPLES,
    TO_DECIMAL(SUM(T.ACT_THR), 10, 2) ACT_THR,
    TO_DECIMAL(SUM(T.THR_PCT), 10, 2) THR_PCT,
    BI.TOP_N_THREAD_HOST_PORTS,
    T.HOST_LEN
  FROM
    BASIS_INFO BI,
    THREADS T
  GROUP BY
    T.HOST || ':' || T.PORT,
    BI.TOP_N_THREAD_HOST_PORTS,
    T.HOST_LEN
)
WHERE
  LN <= TOP_N_THREAD_HOST_PORTS
UNION ALL SELECT TOP 1 90000, '' FROM SYSTEM_REPLICATION
UNION ALL SELECT TOP 1 90010, '**********************' FROM SYSTEM_REPLICATION
UNION ALL SELECT TOP 1 90030, '* SYSTEM REPLICATION *' FROM SYSTEM_REPLICATION
UNION ALL SELECT TOP 1 90040, '**********************' FROM SYSTEM_REPLICATION
UNION ALL SELECT TOP 1 90050, '' FROM SYSTEM_REPLICATION
UNION ALL SELECT TOP 1 90060, RPAD('HOST', HOST_LEN) || CHAR(32) || LPAD('PORT', 5) || CHAR(32) || RPAD('REPLICATION_MODE', 16) || CHAR(32) ||
  LPAD('LOG_SHIP_KB_PER_S', 17) || CHAR(32) || LPAD('LOG_THROUGHPUT_KB_PER_S', 23) || CHAR(32) || LPAD('AVG_LOG_SHIP_MS', 15) || CHAR(32) ||
  LPAD('ASYNC_BUFF_FULL', 15) || CHAR(32) || LPAD('MAX_BACKLOG_MS', 14) FROM SYSTEM_REPLICATION
UNION ALL SELECT TOP 1 90070, RPAD('=', HOST_LEN, '=') || CHAR(32) || LPAD('=', 5, '=') || CHAR(32) || LPAD('=', 16, '=') || CHAR(32) || 
  LPAD('=', 17, '=') || CHAR(32) || LPAD('=', 23, '=') || CHAR(32) || LPAD('=', 15, '=') || CHAR(32) || 
  LPAD('=', 15, '=') || CHAR(32) || LPAD('=', 14, '=') FROM SYSTEM_REPLICATION
UNION ALL
SELECT
  90100 + ROW_NUMBER () OVER (ORDER BY HOST, PORT) / 1000, RPAD(HOST, HOST_LEN) || CHAR(32) || LPAD(PORT, 5) || CHAR(32) || RPAD(REPLICATION_MODE, 16) || CHAR(32) ||
  LPAD(LOG_SHIP_KB_PER_S, 17) || CHAR(32) || LPAD(LOG_THROUGHPUT_KB_PER_S, 23) || CHAR(32) || LPAD(AVG_LOG_SHIP_MS, 15) || CHAR(32) ||
  LPAD(ASYNC_BUFFER_FULL_COUNT, 15) || CHAR(32) || LPAD(MAX_BACKLOG_MS, 14)
FROM
  SYSTEM_REPLICATION
UNION ALL SELECT TOP 1 100000, '' FROM BACKUPS
UNION ALL SELECT TOP 1 100010, '***********' FROM BACKUPS
UNION ALL SELECT TOP 1 100030, '* BACKUPS *' FROM BACKUPS
UNION ALL SELECT TOP 1 100040, '***********' FROM BACKUPS
UNION ALL SELECT TOP 1 100050, '' FROM BACKUPS
UNION ALL SELECT TOP 1 100060, RPAD('HOST', HOST_LEN) || CHAR(32) || RPAD('BACKUP_TYPE', 25) || CHAR(32) || LPAD('BACKUPS', 7) || CHAR(32) || 
  LPAD('ERRORS', 6) || CHAR(32) || LPAD('AVG_ACT_BACKUPS', 15) || CHAR(32) || LPAD('BACKUP_VOL_MBPS', 15) || CHAR(32) || LPAD('BACKUP_TP_MBPS', 14) FROM BACKUPS
UNION ALL SELECT TOP 1 100070, RPAD('=', HOST_LEN, '=') || CHAR(32) || RPAD('=', 25, '=') || CHAR(32) || LPAD('=', 7, '=') || CHAR(32) || 
  LPAD('=', 6, '=') || CHAR(32) || LPAD('=', 15, '=') || CHAR(32) || LPAD('=', 15, '=') || CHAR(32) || LPAD('=', 14, '=') FROM BACKUPS
UNION ALL
SELECT
  100100 + ROW_NUMBER () OVER (ORDER BY HOST, BACKUP_TYPE) / 1000, RPAD(HOST, HOST_LEN) || CHAR(32) || RPAD(BACKUP_TYPE, 25) || CHAR(32) || LPAD(BACKUPS, 7) || CHAR(32) || 
  LPAD(ERRORS, 6) || CHAR(32) || LPAD(IFNULL(AVG_ACT_BACKUPS, 0), 15) || CHAR(32) || LPAD(IFNULL(BACKUP_VOL_MBPS, 0), 15) || CHAR(32) || LPAD(IFNULL(BACKUP_TP_MBPS, 0), 14)
FROM
  BACKUPS
UNION ALL SELECT TOP 1 101000, '' FROM SR_TAKEOVERS
UNION ALL SELECT TOP 1 101010, '********************************' FROM SR_TAKEOVERS
UNION ALL SELECT TOP 1 101030, '* SYSTEM REPLICATION TAKEOVERS *' FROM SR_TAKEOVERS
UNION ALL SELECT TOP 1 101040, '********************************' FROM SR_TAKEOVERS
UNION ALL SELECT TOP 1 101050, '' FROM SR_TAKEOVERS
UNION ALL SELECT TOP 1 101060, RPAD('START_TIME', 19) || CHAR(32) || LPAD('DURATION_S', 10) || CHAR(32) || RPAD('SOURCE_HOST', 30) || CHAR(32) || RPAD('TARGET_HOST', 30) || CHAR(32) || RPAD('LOG_POS_TIME', 19) || CHAR(32) || RPAD ('SHP_LOG_POS_TIME', 19) FROM SR_TAKEOVERS
UNION ALL SELECT TOP 1 101070, RPAD('=', 19, '=') || CHAR(32) || LPAD('=', 10, '=') || CHAR(32) || RPAD('=', 30, '=') || CHAR(32) || RPAD('=', 30, '=') || CHAR(32) || RPAD('=', 19, '=') || CHAR(32) || RPAD('=', 19, '=') FROM SR_TAKEOVERS
UNION ALL SELECT
  101100 + LN / 1000, RPAD(TO_VARCHAR(TAKEOVER_START_TIME, 'YYYY/MM/DD HH24:MI:SS'), 19) || CHAR(32) || LPAD(DURATION_S, 10) || CHAR(32) || RPAD(SOURCE_MASTER_NAMESERVER_HOST, 30) || CHAR(32) || RPAD(MASTER_NAMESERVER_HOST, 30) || CHAR(32) || 
    RPAD(TO_VARCHAR(LOG_POSITION_TIME, 'YYYY/MM/DD HH24:MI:SS'), 19) || CHAR(32) || RPAD(TO_VARCHAR(SHIPPED_LOG_POSITION_TIME, 'YYYY/MM/DD HH24:MI:SS'), 19)
FROM
( SELECT
    ROW_NUMBER () OVER (ORDER BY TAKEOVER_START_TIME DESC) LN,   
    T.*,
    IFNULL(TO_VARCHAR(SECONDS_BETWEEN(TAKEOVER_START_TIME, TAKEOVER_END_TIME)), 'n/a') DURATION_S
  FROM
    SR_TAKEOVERS T
)
UNION ALL SELECT TOP 1 201000, '' FROM TRACE_ENTRIES
UNION ALL SELECT TOP 1 201010, '**********************' FROM TRACE_ENTRIES
UNION ALL SELECT TOP 1 201030, '* TRACE FILE ENTRIES *' FROM TRACE_ENTRIES
UNION ALL SELECT TOP 1 201040, '**********************' FROM TRACE_ENTRIES
UNION ALL SELECT TOP 1 201050, '' FROM TRACE_ENTRIES
UNION ALL SELECT TOP 1 201060, RPAD('TRACE_TIME', 19) || CHAR(32) || RPAD('HOST', HOST_LEN) || CHAR(32) || RPAD('PORT', 5) || CHAR(32) || RPAD('T', 1) || CHAR(32) || 
  RPAD('COMPONENT', 16) || CHAR(32) || 'TRACE_TEXT' FROM TRACE_ENTRIES
UNION ALL SELECT TOP 1 201070, RPAD('=', 19, '=') || CHAR(32) || RPAD('=', HOST_LEN, '=') || CHAR(32) || RPAD('=', 5, '=') || CHAR(32) || RPAD('=', 1, '=') || CHAR(32) || 
  RPAD('=', 16, '=') || CHAR(32) || RPAD('=', 100, '=') FROM TRACE_ENTRIES
UNION ALL SELECT
  201100 + ROW_NUMBER () OVER (ORDER BY TIMESTAMP DESC) / 1000, RPAD(TIMESTAMP, 19) || CHAR(32) || RPAD(HOST, HOST_LEN) || CHAR(32) || RPAD(PORT, 5) || CHAR(32) || RPAD(T, 1) || CHAR(32) || 
  RPAD(COMPONENT, 16) || CHAR(32) || TRACE_TEXT
FROM
  TRACE_ENTRIES
UNION ALL SELECT TOP 1 211000, '' FROM DISK_USAGE
UNION ALL SELECT TOP 1 211010, '**************' FROM DISK_USAGE
UNION ALL SELECT TOP 1 211030, '* DISK USAGE *' FROM DISK_USAGE
UNION ALL SELECT TOP 1 211040, '**************' FROM DISK_USAGE
UNION ALL SELECT TOP 1 211050, '' FROM DISK_USAGE
UNION ALL SELECT TOP 1 211060, RPAD('HOST', HOST_LEN) || CHAR(32) || LPAD('DATA_GB', 10) || CHAR(32) || LPAD('LOG_GB', 10) || CHAR(32) || LPAD('DATA_BACKUP_GB', 14) || CHAR(32) || 
  LPAD('LOG_BACKUP_GB', 13) || CHAR(32) || LPAD('TRACE_GB', 10) || CHAR(32) || LPAD('CATALOG_BACKUP_GB', 17) || CHAR(32) || LPAD('ROOTKEY_BACKUP_GB', 17) FROM DISK_USAGE
UNION ALL SELECT TOP 1 211070, RPAD('=', HOST_LEN, '=') || CHAR(32) || LPAD('=', 10, '=') || CHAR(32) || LPAD('=', 10, '=') || CHAR(32) || LPAD('=', 14, '=') || CHAR(32) || 
  LPAD('=', 13, '=') || CHAR(32) || LPAD('=', 10, '=') || CHAR(32) || LPAD('=', 17, '=') || CHAR(32) || LPAD('=', 17, '=') FROM DISK_USAGE
UNION ALL SELECT
  211100 + ROW_NUMBER() OVER (ORDER BY HOST), RPAD(HOST, HOST_LEN) || CHAR(32) || LPAD(DATA_GB, 10) || CHAR(32) || LPAD(LOG_GB, 10) || CHAR(32) || LPAD(DATA_BACKUP_GB, 14) || CHAR(32) || 
  LPAD(LOG_BACKUP_GB, 13) || CHAR(32) || LPAD(TRACE_GB, 10) || CHAR(32) || LPAD(CATALOG_BACKUP_GB, 17) || CHAR(32) || LPAD(ROOTKEY_BACKUP_GB, 17)
FROM
  DISK_USAGE
UNION ALL SELECT 1000000, '' FROM DUMMY
UNION ALL SELECT 1000010, '************************************' FROM DUMMY
UNION ALL SELECT 1000020, '* END OF SAP HANA TIMEFRAME REPORT *' FROM DUMMY
UNION ALL SELECT 1000030, '************************************' FROM DUMMY
)
ORDER BY
  LINE_NO
WITH HINT (IGNORE_PLAN_CACHE)