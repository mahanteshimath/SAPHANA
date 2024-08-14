SELECT
/* 

[NAME]

- HANA_Tables_TableStatistics_1.00.100+

[DESCRIPTION]

- Table modification overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_TABLE_STATISTICS only available as of Rev. 1.00.100
- Following parameter needs to be set to populate the SELECT related information (attention: risk of overhead):

  indexserver.ini -> [sql] -> table_statistics_select_enabled = true

- Counters are reset during restart of SAP HANA
- Counters consider overall operations, not number of processed records. For example, a mass deletion of 1
  million records with one DELETE operation increases the DELETES counter by only 1.
- LOAD and UNLOAD operations may be counted as UPDATE with SAP HANA <= 2.00.048.05 and <= 2.00.056 (SAP Note 3052547)

[VALID FOR]

- Revisions:              >= 1.00.100

[SQL COMMAND VERSION]

- 2015/09/23:  1.0 (initial version)
- 2017/10/27:  1.1 (TIMEZONE included)
- 2022/10/20:  1.2 (SELECT_COUNT included)

[INVOLVED TABLES]

- M_TABLE_STATISTICS

[INPUT PARAMETERS]

- TIMEZONE

  Used timezone (both for input and output parameters)

  'SERVER'       --> Display times in SAP HANA server time
  'UTC'          --> Display times in UTC time

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

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'SIZE'          --> Sorting by size 
  'TABLE'         --> Sorting by table name

- RESULT_ROWS

  Number of records to be returned by the query

  100             --> Return a maximum number of 100 records
  -1              --> Return all records
  
[OUTPUT PARAMETERS]

- SCHEMA_NAME:      Schema name
- TABLE_NAME:       Table name
- TOTAL:            Total number of operations
- TOTAL_MOD:        Total number of modification operations
- INSERTS:          Number of INSERT operations
- UPDATES:          Number of UPDATE operations
- DELETES:          Number of DELETE operations
- REPLACES:         Number of REPLACE / UPSERT operations
- SELECTS:          Number of SELECT operations
- LAST_MODIFY_TIME: Time of last DML operation

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME    |TABLE_NAME                                           |TOTAL       |TOTAL_MOD   |INSERTS     |UPDATES     |DELETES     |REPLACES    |SELECTS     |LAST_MODIFY_TIME   |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|ESEARCH_HANA   |ESH:ISP001~ISP001~USER_AUTHORITY_DATA~AUTH_AUTH_VALUE|   523033681|   523023817|           0|           0|   257979652|   265044165|        9864|2022/10/19 23:01:52|
|SAPISP         |/IWFND/D_MET_AGR                                     |   519122350|   519115292|        6611|   519108681|           0|           0|        7058|2022/10/20 04:47:21|
|ABC_DEF_OPENHUB|/BIC/OHXHACOIS04                                     |   505835014|   505835014|   505835014|           0|           0|           0|           0|2022/10/19 19:56:36|
|ESEARCH_HANA   |ESH:ISP001~ISP001~COST_CENTER_H~%B3EC806C            |   287576724|   287562487|           0|           0|           0|   287562487|       14237|2022/10/20 00:23:46|
|SAPISP         |BALDAT                                               |   236159191|   234629019|           0|           0|     8058658|   226570361|     1530172|2022/10/20 17:20:32|
|SAPISP         |EDID4                                                |   215835844|   214075488|   214061824|           0|       13664|           0|     1760356|2022/10/20 17:20:29|
|SAPISP         |SRTMP_DATA                                           |   199723990|   195760413|    97880154|    97880154|         105|           0|     3963577|2022/10/20 16:34:04|
|SAPISP         |ZLAS_UC_ROLES                                        |   182546544|   182546197|   182545119|           0|        1078|           0|         347|2022/10/20 17:07:43|
|SAPISP         |/1CADMC/00001378                                     |   108725628|   108019963|   106417178|           0|     1602785|           0|      705665|2022/10/20 07:59:52|
|ABC_dEV_OPENHUB|/BIC/OHXHACOIS01                                     |    95672380|    95672380|    95672380|           0|           0|           0|           0|2022/10/20 16:06:20|
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  SCHEMA_NAME,
  TABLE_NAME,
  LPAD(TOTAL, 12) TOTAL,
  LPAD(TOTAL_MOD, 12) TOTAL_MOD,
  LPAD(INSERTS, 12) INSERTS,
  LPAD(UPDATES, 12) UPDATES,
  LPAD(DELETES, 12) DELETES,
  LPAD(REPLACES, 12) REPLACES,
  LPAD(SELECTS, 12) SELECTS,
  TO_VARCHAR(LAST_MODIFY_TIME, 'YYYY/MM/DD HH24:MI:SS') LAST_MODIFY_TIME
FROM
( SELECT
    TS.SCHEMA_NAME,
    TS.TABLE_NAME,
    TS.INSERT_COUNT + TS.DELETE_COUNT + TS.UPDATE_COUNT + TS.REPLACE_COUNT TOTAL_MOD,
    TS.INSERT_COUNT + TS.DELETE_COUNT + TS.UPDATE_COUNT + TS.REPLACE_COUNT + TS.SELECT_COUNT TOTAL,
    TS.INSERT_COUNT INSERTS,
    TS.UPDATE_COUNT UPDATES,
    TS.DELETE_COUNT DELETES,
    TS.REPLACE_COUNT REPLACES,
    TS.SELECT_COUNT SELECTS,
    BI.RESULT_ROWS,
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(TS.LAST_MODIFY_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE TS.LAST_MODIFY_TIME END LAST_MODIFY_TIME,
    ROW_NUMBER () OVER 
    ( ORDER BY
        MAP(BI.ORDER_BY, 'TABLE', TS.SCHEMA_NAME, ''),
        MAP(BI.ORDER_BY, 'TABLE', TS.TABLE_NAME, ''),
        MAP(BI.ORDER_BY, 
          'TOTAL', TS.INSERT_COUNT + TS.DELETE_COUNT + TS.UPDATE_COUNT + TS.REPLACE_COUNT + TS.SELECT_COUNT,
          'TOTAL_MOD', TS.INSERT_COUNT + TS.DELETE_COUNT + TS.UPDATE_COUNT + TS.REPLACE_COUNT,
          'INSERT', TS.INSERT_COUNT,
          'UPDATE', TS.UPDATE_COUNT,
          'DELETE', TS.DELETE_COUNT,
          'REPLACE', TS.REPLACE_COUNT,
          'SELECT', TS.SELECT_COUNT) DESC
    ) ROW_NUM
  FROM
  ( SELECT                /* Modification section */
      'SERVER' TIMEZONE,                              /* SERVER, UTC */
      '%' SCHEMA_NAME,
      '%' TABLE_NAME,
      'TOTAL' ORDER_BY,        /* TABLE, TOTAL, TOTAL_MOD, INSERT, UPDATE, DELETE, REPLACE, SELECT */
      50 RESULT_ROWS
    FROM
      DUMMY
  ) BI,
    M_TABLE_STATISTICS TS
  WHERE
    TS.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    TS.TABLE_NAME LIKE BI.TABLE_NAME
  ORDER BY
    MAP(BI.ORDER_BY, 'TABLE', TS.SCHEMA_NAME, ''),
    MAP(BI.ORDER_BY, 'TABLE', TS.TABLE_NAME, ''),
    MAP(BI.ORDER_BY, 
      'TOTAL', TS.INSERT_COUNT + TS.DELETE_COUNT + TS.UPDATE_COUNT + TS.REPLACE_COUNT,
      'INSERT', TS.INSERT_COUNT,
      'UPDATE', TS.UPDATE_COUNT,
      'DELETE', TS.DELETE_COUNT,
      'REPLACE', TS.REPLACE_COUNT) DESC
)
WHERE
  ( RESULT_ROWS = -1 OR ROW_NUM <= RESULT_ROWS )
    
  
