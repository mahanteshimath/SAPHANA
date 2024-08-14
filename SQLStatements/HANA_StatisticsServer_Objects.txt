SELECT
/* 

[NAME]

- HANA_StatisticsServer_Objects

[DESCRIPTION]

- Statistics server objects overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2021/08/17:  1.0 (initial version)

[INVOLVED TABLES]

- STATISTICS_OBJECTS

[INPUT PARAMETERS]

- ID

  Statistics object ID

  59             --> Statistics object ID 59
  -1             --> No restriction to statistics object ID

- OBJECT_NAME

  Statistics object name

  'Startup_Preamble' --> Statistics object name Startup_Preamble
  'Alert%'           --> Statistics object names starting with 'Alert'
  '%'                --> No restriction related to statistics object name

- OBJECT_TYPE

  Statistics object type

  'Collector'     --> Statistics objects with type Collector
  '%'             --> No restriction related to statistics object type

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'NAME'          --> Sorting by object name
  'DATE'          --> Sorting by version date
  
[OUTPUT PARAMETERS]

- ID:           Statistics object ID
- OBJECT_NAME:  Statistics object name
- OBJECT_TYPE:  Statistics object type
- VERSION:      Statistics object version
- VERSION_DATE: Date of version implementation

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------
|ID  |OBJECT_NAME                                  |OBJECT_TYPE|VERSION|VERSION_DATE       |
--------------------------------------------------------------------------------------------
|  59|Alert_Blocked_Transactions_Percentage        |Alert      |     10|2021/02/12 12:01:16|
| 105|Alert_Open_Transactions                      |Alert      |      5|2020/11/18 13:31:12|
| 107|Alert_Inconsistent_Database_Fallback_Snapshot|Alert      |      6|2020/11/18 13:31:12|
| 104|Alert_Replication_Logshipping_Backlog        |Alert      |      3|2020/11/18 13:31:11|
|  94|Alert_Replication_Logreplay_Backlog          |Alert      |      7|2020/11/18 13:31:03|
|  48|Alert_Uncommitted_Write_Transaction          |Alert      |     12|2020/11/18 13:31:02|
|  39|Alert_Long_Running_Statements                |Alert      |     14|2020/11/18 13:31:00|
|5029|Collector_Host_Sql_Plan_Cache                |Collector  |     27|2020/11/18 13:30:59|
--------------------------------------------------------------------------------------------

*/

  LPAD(SO.ID, 4) ID,
  SO.NAME OBJECT_NAME,
  SO.TYPE OBJECT_TYPE,
  LPAD(SO.VERSION, 7) VERSION,
  TO_VARCHAR(SO.REACHED_AT, 'YYYY/MM/DD HH24:MI:SS') VERSION_DATE
FROM
  ( SELECT                      /* Modification section */
      -1 ID,                                  
      '%' OBJECT_NAME,
      '%' OBJECT_TYPE,
      'DATE' ORDER_BY        /* ID, DATE, NAME, TYPE */
    FROM
      DUMMY
  ) BI,
  _SYS_STATISTICS.STATISTICS_OBJECTS SO
WHERE
  ( BI.ID = -1 OR SO.ID = BI.ID ) AND
  SO.NAME LIKE BI.OBJECT_NAME AND
  SO.TYPE LIKE BI.OBJECT_TYPE
ORDER BY
  MAP(BI.ORDER_BY, 'ID', SO.ID),
  MAP(BI.ORDER_BY, 'NAME', SO.NAME, 'TYPE', SO.TYPE),
  MAP(BI.ORDER_BY, 'DATE', TO_VARCHAR(SO.REACHED_AT, 'YYYY/MM/DD HH24:MI:SS')) DESC
