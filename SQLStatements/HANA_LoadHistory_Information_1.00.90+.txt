SELECT
/* 

[NAME]

- HANA_LoadHistory_Information_1.00.90+

[DESCRIPTION]

- Provides a description of load history data

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_LOAD_HISTORY_INFO available as of revision 90

[VALID FOR]

- Revisions:              >= 1.00.90

[SQL COMMAND VERSION]

- 2015/01/29:  1.0 (initial version)

[INVOLVED TABLES]

- M_LOAD_HISTORY_INFO

[INPUT PARAMETERS]

- VIEW_NAME    
 
  Load history view name

  'M_LOAD_HISTORY_HOST' --> View M_LOAD_HISTORY_HOST
  '%'                   --> No view name restriction

- COLUMN_NAME

  Column name of load history view

  'DISK_SIZE'     --> Column DISK_SIZE
  '%CPU%'         --> Columns containing 'CPU'
  '%'             --> No restriction related to columns

[OUTPUT PARAMETERS]

- VIEW_NAME:   Load history view name
- COLUMN_NAME: Column name
- SAMPLE_UNIT: Column unit
- DESCRIPTION: Column description
- SQL_SOURCE:  SQL statement for determining the column values (if available)

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|VIEW_NAME             |COLUMN_NAME               |SAMPLE_UNIT|DESCRIPTION                                                                                                                    |SQL_SOURCE                                                                                                                                                                                                                                       |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|M_LOAD_HISTORY_HOST   |CPU                       |%          |CPU Used by all processes                                                                                                      |TOTAL_CPU from SYS.M_SERVICE_STATISTICS where SERVICE_NAME='nameserver'                                                                                                                                                                          |
|M_LOAD_HISTORY_HOST   |DISK_SIZE                 |Byte       |Disk size                                                                                                                      |sum(TOTAL_SIZE) from SYS.M_DISKS where USAGE_TYPE in ('DATA','LOG') group by HOST                                                                                                                                                                |
|M_LOAD_HISTORY_HOST   |DISK_USED                 |Byte       |Disk used                                                                                                                      |sum(USED_SIZE) from SYS.M_DISKS where USAGE_TYPE in ('DATA','LOG') group by HOST                                                                                                                                                                 |
|M_LOAD_HISTORY_HOST   |MEMORY_ALLOCATION_LIMIT   |Byte       |Memory allocation limit for all processes of HANA instance                                                                     |ALLOCATION_LIMIT from SYS.M_HOST_RESOURCE_UTILIZATION                                                                                                                                                                                            |
|M_LOAD_HISTORY_HOST   |MEMORY_RESIDENT           |Byte       |Physical memory used for all HANA processes                                                                                    |sum(PHYSICAL_MEMORY_SIZE) from SYS.M_SERVICE_MEMORY group by HOST                                                                                                                                                                                |
|M_LOAD_HISTORY_HOST   |MEMORY_SIZE               |Byte       |Physical memory size                                                                                                           |USED_PHYSICAL_MEMORY + FREE_PHYSICAL_MEMORY from SYS.M_HOST_RESOURCE_UTILIZATION                                                                                                                                                                 |
|M_LOAD_HISTORY_HOST   |MEMORY_TOTAL_RESIDENT     |Byte       |Physical memory used for all processes                                                                                         |A.USED_PHYSICAL_MEMORY + B.SUM_SHARED_MEMORY_ALLOCATED_SIZE from SYS.M_HOST_RESOURCE_UTILIZATION A join (select HOST H,sum(SHARED_MEMORY_ALLOCATED_SIZE) SUM_SHARED_MEMORY_ALLOCATED_SIZE from SYS.M_SERVICE_MEMORY group by HOST) as B on HOST=H|
|M_LOAD_HISTORY_HOST   |MEMORY_USED               |Byte       |Memory used for all HANA processes                                                                                             |INSTANCE_TOTAL_MEMORY_USED_SIZE from SYS.M_HOST_RESOURCE_UTILIZATION                                                                                                                                                                             |
|M_LOAD_HISTORY_HOST   |NETWORK_IN                |Byte/sample|Bytes read from network by all processes                                                                                       |-- N/A                                                                                                                                                                                                                                           |
|M_LOAD_HISTORY_HOST   |NETWORK_OUT               |Byte/sample|Bytes written to network by all processes                                                                                      |-- N/A                                                                                                                                                                                                                                           |
|M_LOAD_HISTORY_HOST   |SWAP_IN                   |Byte/sample|Bytes read from swap by all processes                                                                                          |-- N/A                                                                                                                                                                                                                                           |
|M_LOAD_HISTORY_HOST   |SWAP_OUT                  |Byte/sample|Bytes written To swap by all processes                                                                                         |-- N/A                                                                                                                                                                                                                                           |
|M_LOAD_HISTORY_SERVICE|ACTIVE_SQL_EXECUTOR_COUNT |           |Number of active SqlExecutors                                                                                                  |count(*) from SYS.M_SERVICE_THREADS where THREAD_TYPE='SqlExecutor' and THREAD_STATE<>'Inactive' group by HOST,PORT                                                                                                                              |
|M_LOAD_HISTORY_SERVICE|ACTIVE_THREAD_COUNT       |           |Number of active threads                                                                                                       |count(*) from SYS.M_SERVICE_THREADS where THREAD_STATE<>'Inactive' group by HOST,PORT                                                                                                                                                            |
|M_LOAD_HISTORY_SERVICE|BLOCKED_TRANSACTION_COUNT |           |Number of blocked SQL transactions                                                                                             |count(*) from SYS.M_BLOCKED_TRANSACTIONS group by HOST,PORT                                                                                                                                                                                      |
|M_LOAD_HISTORY_SERVICE|COMMIT_ID_RANGE           |           |Range between newest and oldest active Commit ID                                                                               |to_bigint(A.VALUE-B.VALUE) as COMMIT_ID_RANGE      from SYS.M_MVCC_TABLES A inner join (select HOST H, PORT P, VALUE from SYS.M_MVCC_TABLES where NAME='MIN_SNAPSHOT_TS') B on HOST=H and PORT=P where A.NAME='GLOBAL_TS'                        |
|M_LOAD_HISTORY_SERVICE|CONNECTION_COUNT          |           |Number of open SQL connections                                                                                                 |count(*) from SYS.M_CONNECTIONS where CONNECTION_ID>0 and CREATED_BY='Session' group by HOST,PORT                                                                                                                                                |
|M_LOAD_HISTORY_SERVICE|CPU                       |%          |CPU used by Service                                                                                                            |PROCESS_CPU from SYS.M_SERVICE_STATISTICS                                                                                                                                                                                                        |
|M_LOAD_HISTORY_SERVICE|CS_MERGE_COUNT            |req/sample |Number of merge requests                                                                                                       |-- N/A                                                                                                                                                                                                                                           |
|M_LOAD_HISTORY_SERVICE|CS_READ_COUNT             |req/sample |Number of read requests (select)                                                                                               |-- N/A                                                                                                                                                                                                                                           |
|M_LOAD_HISTORY_SERVICE|CS_UNLOAD_COUNT           |req/sample |Number of column unloads                                                                                                       |count(*) from SYS.M_CS_UNLOADS where REASON in ('LOW MEMORY','UNUSED RESOURCE')                                                                                                                                                                  |
|M_LOAD_HISTORY_SERVICE|CS_WRITE_COUNT            |req/sample |Number of write requests (insert,update,delete)                                                                                |-- N/A                                                                                                                                                                                                                                           |
|M_LOAD_HISTORY_SERVICE|HANDLE_COUNT              |           |Number of open handles                                                                                                         |OPEN_FILE_COUNT from SYS.M_SERVICE_STATISTICS                                                                                                                                                                                                    |
|M_LOAD_HISTORY_SERVICE|MEMORY_ALLOCATION_LIMIT   |Byte       |Memory allocation limit for Service                                                                                            |EFFECTIVE_ALLOCATION_LIMIT from SYS.M_SERVICE_MEMORY                                                                                                                                                                                             |
|M_LOAD_HISTORY_SERVICE|MEMORY_USED               |Byte       |Memory used by Service                                                                                                         |TOTAL_MEMORY_USED_SIZE from SYS.M_SERVICE_MEMORY                                                                                                                                                                                                 |
|M_LOAD_HISTORY_SERVICE|MVCC_VERSION_COUNT        |           |Number of active MVCC versions                                                                                                 |to_bigint(VALUE) from SYS.M_MVCC_TABLES where NAME='NUM_VERSIONS'                                                                                                                                                                                |
|M_LOAD_HISTORY_SERVICE|PENDING_SESSION_COUNT     |           |Number of pending requests                                                                                                     |sum(PENDING_REQUEST_COUNT) from SYS.M_DEV_SESSION_PARTITIONS group by HOST,PORT                                                                                                                                                                  |
|M_LOAD_HISTORY_SERVICE|PING_TIME                 |msec       |Duration of Service ping request (THREAD_METHOD='__nsWatchdog'). This request includes the collection of service specific KPIs |-- N/A                                                                                                                                                                                                                                           |
|M_LOAD_HISTORY_SERVICE|RECORD_LOCK_COUNT         |           |Number of acquired record locks                                                                                                |to_bigint(VALUE) from SYS.M_MVCC_TABLES where NAME='NUM_ACQUIRED_LOCKS'                                                                                                                                                                          |
|M_LOAD_HISTORY_SERVICE|STATEMENT_COUNT           |stmt/sample|Number of finished SQL statements                                                                                              |EXECUTION_COUNT from SYS.M_WORKLOAD                                                                                                                                                                                                              |
|M_LOAD_HISTORY_SERVICE|SWAP_IN                   |Byte/sample|Bytes read from swap by Service                                                                                                |-- N/A                                                                                                                                                                                                                                           |
|M_LOAD_HISTORY_SERVICE|SYSTEM_CPU                |%          |OS Kernel/System CPU used by Service                                                                                           |-- N/A                                                                                                                                                                                                                                           |
|M_LOAD_HISTORY_SERVICE|TOTAL_SQL_EXECUTOR_COUNT  |           |Total number of SqlExecutors                                                                                                   |count(*) from SYS.M_SERVICE_THREADS where THREAD_TYPE='SqlExecutor' group by HOST,PORT                                                                                                                                                           |
|M_LOAD_HISTORY_SERVICE|TOTAL_THREAD_COUNT        |           |Total number of threads                                                                                                        |count(*) from SYS.M_SERVICE_THREADS group by HOST,PORT                                                                                                                                                                                           |
|M_LOAD_HISTORY_SERVICE|TRANSACTION_COUNT         |           |Number of open SQL transactions                                                                                                |count(*) from SYS.M_TRANSACTIONS where TRANSACTION_STATUS<>'INACTIVE' group by HOST,PORT                                                                                                                                                         |
|M_LOAD_HISTORY_SERVICE|TRANSACTION_ID_RANGE      |           |Range between newest and oldest active Transaction ID                                                                          |to_bigint(A.VALUE-B.VALUE) as TRANSACTION_ID_RANGE from SYS.M_MVCC_TABLES A inner join (select HOST H, PORT P, VALUE from SYS.M_MVCC_TABLES where NAME='MIN_READ_TID')    B on HOST=H and PORT=P where A.NAME='NEXT_WRITE_TID'                   |
|M_LOAD_HISTORY_SERVICE|WAITING_SQL_EXECUTOR_COUNT|           |Number of waiting SqlExecutors                                                                                                 |count(*) FROM SYS.M_SERVICE_THREADS where THREAD_TYPE='SqlExecutor' and THREAD_STATE not in ('Inactive','Running') group by HOST,PORT                                                                                                            |
|M_LOAD_HISTORY_SERVICE|WAITING_THREAD_COUNT      |           |Number of waiting threads                                                                                                      |count(*) from SYS.M_SERVICE_THREADS where THREAD_STATE not in ('Inactive','Running') group by HOST,PORT                                                                                                                                          |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/
  L.VIEW_NAME,
  L.COLUMN_NAME,
  L.SAMPLE_UNIT,
  L.DESCRIPTION,
  L.SQL_SOURCE
FROM
( SELECT                 /* Modification section */
    '%' VIEW_NAME,
    '%' COLUMN_NAME
  FROM
    DUMMY
) BI,
  M_LOAD_HISTORY_INFO L
WHERE
  L.VIEW_NAME LIKE BI.VIEW_NAME AND
  L.COLUMN_NAME LIKE BI.COLUMN_NAME AND
  L.VIEW_NAME != ''
ORDER BY
  L.VIEW_NAME,
  L.COLUMN_NAME