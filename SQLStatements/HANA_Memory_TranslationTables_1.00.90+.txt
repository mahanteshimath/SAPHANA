SELECT
/* 

[NAME]

- HANA_Memory_TranslationTables_1.00.90+

[DESCRIPTION]

- Show current content of Pool/JoinEvaluator/TranslationTables heap area

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Available for public as of Revision 90 via M_JOIN_TRANSLATION_TABLES
- The displayed PART_IDs (in brackets after the table name in case of partitioned tables and OBJECT_LEVEL = 'PARTITION') are 
  internal physical partition IDs that can be different from the logical partition IDs being reported in other monitoring views
  like M_CS_TABLES. 

[VALID FOR]

- Revisions:              >= 1.00.90

[SQL COMMAND VERSION]

- 2014/12/18:  1.0 (initial version)
- 2017/10/24:  1.1 (TIMEZONE included)
- 2018/02/27:  1.2 (OBJECT_LEVEL included)
- 2018/11/07:  1.3 (ORDER_BY included)

[INVOLVED TABLES]

- M_JOIN_TRANSLATION_TABLES

[INPUT PARAMETERS]

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

- TABLE_NAME           

  Table name or pattern

  'T000'          --> Specific table T000
  'T%'            --> All tables starting with 'T'
  '%'             --> All tables

- OBJECT_LEVEL

  Controls display of partitions

  'PARTITION'     --> Result is shown on partition level
  'TABLE'         --> Result is shown on table level

- RESULT_ROWS

  Number of records to be returned by the query

  100             --> Return a maximum number of 100 records
  -1              --> Return all records

- ORDER_BY

  Sort criteria

  'SIZE'          --> Sorting by size 
  'TABLE'         --> Sorting by table name

[OUTPUT PARAMETERS]

- HOST:          Host name
- PORT:          Port name
- SERVICE:       Service name
- SCHEMA_NAME_1: Schema name of first table to be joined
- TABLE_NAME_1:  First table name
- COLUMN_NAME_1: Join column name of first table
- SCHEMA_NAME_2: Schema name of second table to be joined
- TABLE_NAME_2:  Second table name
- COLUMN_NAME_2: Join column name of second table
- NUM_TTS:       Number of translation tables
- TT_SIZE_MB:    Size of translation table (in MB)
- SIZE_PCT:      Size of translation table compared to overall translation tables size (in %)
- CHANGE_TIME:   Change time

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST  |PORT |SCHEMA_NAME_1  |TABLE_NAME_1       |COLUMN_NAME_1        |SCHEMA_NAME_2  |TABLE_NAME_2                           |COLUMN_NAME_2        |NUM_TTS|TT_SIZE_MB|SIZE_PCT|CHANGE_TIME        |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|hana01|31005|_SYS_STATISTICS|STATISTICS_ALERTS  |$trexexternalkey$    |_SYS_STATISTICS|STATISTICS_ALERT_LAST_CHECK_INFORMATION|$trexexternalkey$    |     30|      7.15|   53.85|2014/12/18 11:51:57|
|hana01|31003|SAPSR3         |TFDIR              |FUNCNAME             |SAPSR3         |TFTIT                                  |FUNCNAME             |      1|      0.92|    6.96|2014/12/15 18:57:24|
|hana01|31003|SAPSR3         |RSDDSTATHEADER     |STEPUID              |SAPSR3         |RSDDSTATINFO                           |STEPUID              |      1|      0.70|    5.33|2014/12/16 20:24:08|
|hana01|31003|SAPSR3         |RSDDSTATEVDATA     |STEPUID              |SAPSR3         |RSDDSTATHEADER                         |STEPUID              |      1|      0.70|    5.33|2014/12/16 20:24:08|
|hana01|31003|SAPSR3         |RSDDSTATEVDATA     |STEPUID              |SAPSR3         |RSDDSTATINFO                           |STEPUID              |      1|      0.68|    5.17|2014/12/11 14:21:13|
|hana01|31003|SAPSR3         |RSDDSTATDM         |STEPUID              |SAPSR3         |RSDDSTATINFO                           |STEPUID              |      1|      0.35|    2.70|2014/12/10 14:41:04|
|hana01|31003|SAPSR3         |RSDIOBJ            |IOBJNM               |SAPSR3         |RSDIOBJT                               |IOBJNM               |      1|      0.33|    2.49|2014/12/15 13:54:19|
|hana01|31003|SAPSR3         |RSDIOBCIOBJ        |IOBJNM               |SAPSR3         |RSDIOBJ                                |IOBJNM               |      1|      0.32|    2.45|2014/12/15 13:54:19|
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  SERVICE_NAME SERVICE,
  SCHEMA_NAME_1,
  TABLE_NAME_1,
  COLUMN_NAME_1,
  SCHEMA_NAME_2,
  TABLE_NAME_2,
  COLUMN_NAME_2,
  LPAD(NUM_TTS, 7) NUM_TTS,
  TT_SIZE_MB,
  SIZE_PCT,
  IFNULL(CHANGE_TIME, '') CHANGE_TIME
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'HOST')    != 0 THEN TT.HOST          ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                 END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(TT.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT)              END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'SERVICE') != 0 THEN S.SERVICE_NAME   ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME) END SERVICE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'SCHEMA')  != 0 THEN TT.SCHEMA_NAME1  ELSE 'any'                                             END SCHEMA_NAME_1,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'TABLE')   != 0 THEN TT.TABLE_NAME1 || MAP(BI.OBJECT_LEVEL, 'TABLE', '', MAP(TT.PART_ID1, 0, 
                                                                                    '', CHAR(32) || '(' || TT.PART_ID1 || ')')) ELSE 'any'                     END TABLE_NAME_1,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'COLUMN')  != 0 THEN TT.COLUMN_NAME1  ELSE 'any'                                             END COLUMN_NAME_1,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'SCHEMA')  != 0 THEN TT.SCHEMA_NAME2  ELSE 'any'                                             END SCHEMA_NAME_2,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'TABLE')   != 0 THEN TT.TABLE_NAME2 || MAP(BI.OBJECT_LEVEL, 'TABLE', '', MAP(TT.PART_ID2, 0, 
                                                                                    '', CHAR(32) || '(' || TT.PART_ID2 || ')')) ELSE 'any'                     END TABLE_NAME_2,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'COLUMN')  != 0 THEN TT.COLUMN_NAME2  ELSE 'any'                                             END COLUMN_NAME_2,
    COUNT(*) NUM_TTS,
    LPAD(TO_DECIMAL(SUM(TT.TRANSLATION_TABLE_MEMORY_SIZE) / 1024 / 1024, 10, 2), 10) TT_SIZE_MB,
    LPAD(TO_DECIMAL(SUM(TT.TRANSLATION_TABLE_MEMORY_SIZE) / SUM(SUM(TT.TRANSLATION_TABLE_MEMORY_SIZE)) OVER () * 100, 5, 2), 8) SIZE_PCT,
    TO_VARCHAR(MAX(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(TT.IMPLEMENTATION_TYPE_CHANGE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE TT.IMPLEMENTATION_TYPE_CHANGE_TIME END), 'YYYY/MM/DD HH24:MI:SS') CHANGE_TIME,
    BI.ORDER_BY
  FROM
  ( SELECT                     /* Modification section */
      'SERVER' TIMEZONE,                              /* SERVER, UTC */
      '%' HOST,
      '%' PORT,
      '%' SERVICE_NAME,
      '%' SCHEMA_NAME,
      '%' TABLE_NAME,
      'TABLE' OBJECT_LEVEL,
      'NONE' AGGREGATE_BY,              /* HOST, PORT, SERVICE, SCHEMA, TABLE, COLUMN or comma-separated combination, NONE for no aggregation */
      'COUNT' ORDER_BY                  /* HOST, TABLE, COUNT, SIZE, TIME */
    FROM
      DUMMY
  ) BI,
    M_SERVICES S,
    M_JOIN_TRANSLATION_TABLES TT
  WHERE
    S.HOST LIKE BI.HOST AND
    TO_VARCHAR(S.PORT) LIKE BI.PORT AND
    S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
    TT.HOST = S.HOST AND
    TT.PORT = S.PORT AND
    ( TT.SCHEMA_NAME1 LIKE BI.SCHEMA_NAME OR TT.SCHEMA_NAME2 LIKE BI.SCHEMA_NAME ) AND
    ( TT.TABLE_NAME1 LIKE BI.TABLE_NAME OR TT.TABLE_NAME2 LIKE BI.TABLE_NAME )
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'HOST')    != 0 THEN TT.HOST          ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                 END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(TT.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT)              END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'SERVICE') != 0 THEN S.SERVICE_NAME   ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'SCHEMA')  != 0 THEN TT.SCHEMA_NAME1  ELSE 'any'                                             END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'TABLE')   != 0 THEN TT.TABLE_NAME1 || MAP(BI.OBJECT_LEVEL, 'TABLE', '', MAP(TT.PART_ID1, 0, 
                                                                                    '', CHAR(32) || '(' || TT.PART_ID1 || ')')) ELSE 'any'                     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'COLUMN')  != 0 THEN TT.COLUMN_NAME1  ELSE 'any'                                             END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'SCHEMA')  != 0 THEN TT.SCHEMA_NAME2  ELSE 'any'                                             END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'TABLE')   != 0 THEN TT.TABLE_NAME2 || MAP(BI.OBJECT_LEVEL, 'TABLE', '', MAP(TT.PART_ID2, 0, 
                                                                                    '', CHAR(32) || '(' || TT.PART_ID2 || ')')) ELSE 'any'                     END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR LOCATE(BI.AGGREGATE_BY, 'COLUMN')  != 0 THEN TT.COLUMN_NAME2  ELSE 'any'                                             END,
    ORDER_BY
  ORDER BY
    SUM(TT.TRANSLATION_TABLE_MEMORY_SIZE) DESC
)
ORDER BY
  MAP(ORDER_BY, 'HOST', HOST || PORT || SERVICE_NAME, 'TABLE', SCHEMA_NAME_1 || TABLE_NAME_1 || COLUMN_NAME_1 || SCHEMA_NAME_2 || TABLE_NAME_2 || COLUMN_NAME_2),
  MAP(ORDER_BY, 'COUNT', NUM_TTS, 'SIZE', TT_SIZE_MB) DESC,
  MAP(ORDER_BY, 'COUNT', TT_SIZE_MB) DESC,
  MAP(ORDER_BY, 'TIME', CHANGE_TIME) DESC
