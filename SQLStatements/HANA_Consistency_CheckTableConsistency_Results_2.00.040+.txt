SELECT
/* 

[NAME]

- HANA_Consistency_CheckTableConsistency_Results_2.00.040+

[DESCRIPTION]

- Evaluation of CHECK_TABLE_CONSISTENCY results

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_CONSISTENCY_CHECK_HISTORY and M_CONSISTENCY_CHECK_HISTORY_ERRORS available with SAP HANA >= 2.00.040
- See SAP Note 1977584 for SAP HANA consistency checks.

[VALID FOR]

- Revisions:              >= 2.00.040

[SQL COMMAND VERSION]

- 2015/11/12:  1.0 (initial version)
- 2015/11/27:  1.1 (AGGREGATE_BY included)
- 2017/09/25:  1.2 (EXCLUDE_INFO_MESSAGES included)
- 2017/10/24:  1.3 (TIMEZONE included)
- 2018/12/04:  1.4 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2019/02/18:  1.5 (dedicated 2.00.040+ version based on M_CONSISTENCY_CHECK_HISTORY_ERRORS)

[INVOLVED TABLES]

- M_CONSISTENCY_CHECK_HISTORY
- M_CONSISTENCY_CHECK_HISTORY_ERRORS

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

- COLUMN_NAME

  Column name

  'MATNR'         --> Column MATNR
  'Z%'            --> Columns starting with "Z"
  '%'             --> No restriction related to columns

- ERROR_CODE

  Error code of CHECK_TABLE_CONSISTENCY

  5099            --> Only display entries with error code 5099
  -1              --> No restriction related to error code

- ERROR_MESSAGE

  Error message of CHECK_TABLE_CONSISTENCY

  'metadata%'     --> Only return error messages starting with 'metadata'
  '%'             --> No restriction related to error message

- EXCLUDE_INFO_MESSAGES

  Possibility to exclude messages not indicating a corruption

  'X'             --> Only show errors that can indicate corruptions
  ' '             --> Display all entries available
  
- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'          --> Aggregation by time
  'SCHEMA, TABLE' --> Aggregation by schema and table
  'NONE'          --> No aggregation

[OUTPUT PARAMETERS]

- TIMESTAMP:     Timestamp of error message
- NUM:           Number of inconsistencies
- SCHEMA_NAME:   Schema name
- OBJECT_NAME:   Table name
- COLUMN_NAME:   Column name
- COUNT:         Number of affected rows
- ERROR:         Error code
- ERROR_MESSAGE: Detailed error message

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|TIMESTAMP          |SCHEMA_NAME|OBJECT_NAME                |COLUMN_NAME|ERROR|ERROR_MESSAGE                                                                                                                                                                                                                                                  |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2015/11/09 20:08:50|SAPSR3     |/BIC/AYRFLZOO100          |           | 5099|metadata version changed while running checks: 221 -> 285                                                                                                                                                                                                      |
|2015/11/09 20:08:50|SAPSR3     |/BIC/AYRFLZOO300          |           | 5099|metadata version changed while running checks: 46 -> 51                                                                                                                                                                                                        |
|2015/11/09 20:08:50|SAPSR3     |/BIC/AYRFLZOP100          |           | 5099|metadata version changed while running checks: 80 -> 296                                                                                                                                                                                                       |
|2015/11/09 20:08:50|SAPSR3     |/BIC/AYRFOSO0240          |           | 5099|metadata version changed while running checks: 146 -> 149                                                                                                                                                                                                      |
|2015/11/09 20:08:50|SAPSR3     |/BIC/AYRFOSO0240 (1)      |           | 5099|metadata version changed while running checks: 146 -> 147                                                                                                                                                                                                      |
|2015/11/09 20:08:50|SAPSR3     |/BIC/AYRFOSO0840          |           | 5099|metadata version changed while running checks: 225 -> 227                                                                                                                                                                                                      |
|2015/11/09 20:08:50|SAPSR3     |/BIC/AYRFOSO0840 (2)      |           | 5099|metadata version changed while running checks: 225 -> 226                                                                                                                                                                                                      |
|2015/11/09 20:08:50|SAPSR3     |/BIC/AYRFOSO0840 (11)     |           | 5099|metadata version changed while running checks: 225 -> 226                                                                                                                                                                                                      |
|2015/11/09 20:08:50|SAPSR3     |/BIC/AYRFOSO0840 (12)     |           | 5099|metadata version changed while running checks: 225 -> 226                                                                                                                                                                                                      |
|2015/11/09 20:08:50|SAPSR3     |/BIC/AYRFOSO0840 (3)      |           | 5099|metadata version changed while running checks: 225 -> 226                                                                                                                                                                                                      |
|2015/11/09 20:08:50|SAPSR3     |/BIC/AYRGAZOH100          |           | 5099|metadata version changed while running checks: 162 -> 345                                                                                                                                                                                                      |
|2015/11/09 20:08:50|SAPSR3     |/BIC/AYRGAZOH200          |           | 5099|metadata version changed while running checks: 143 -> 176                                                                                                                                                                                                      |
|2015/11/09 20:08:50|SAPSR3     |0BW:BIA:S2P:BI0_0800000081|           | 5097|Failed to lock table SAPSR3:0BW:BIA:S2P:BI0_0800000081 (-1) for consistency check: ERROR [CODE-2561] distributed metadata error: cannot find table object
exception  1: no.71002561  (ptime/storage/cc/lock/ObjectLockManagerImpl.cpp:1247)
    cannot find ta |
|2015/11/09 20:08:50|SAPSR3     |0BW:BIA:S2P:BI0_0800000082|           | 5097|Failed to lock table SAPSR3:0BW:BIA:S2P:BI0_0800000082 (-1) for consistency check: ERROR [CODE-2561] distributed metadata error: cannot find table object
exception  1: no.71002561  (ptime/storage/cc/lock/ObjectLockManagerImpl.cpp:1247)
    cannot find ta |
|2015/11/09 20:08:50|SAPSR3     |0BW:BIA:S2P:BI0_0Q00067196|           | 5097|Failed to lock table SAPSR3:0BW:BIA:S2P:BI0_0Q00067196 (-1) for consistency check: ERROR [CODE-2561] distributed metadata error: cannot find table object
exception  1: no.71002561  (ptime/storage/cc/lock/ObjectLockManagerImpl.cpp:1247)
    cannot find ta |
|2015/11/09 20:08:50|SAPSR3     |0BW:BIA:S2P:BI0_0Q00067200|           | 5097|Failed to lock table SAPSR3:0BW:BIA:S2P:BI0_0Q00067200 (-1) for consistency check: ERROR [CODE-2561] distributed metadata error: cannot find table object
exception  1: no.71002561  (ptime/storage/cc/lock/ObjectLockManagerImpl.cpp:1247)
    cannot find ta |
|2015/11/09 20:08:50|SAPSR3     |0BW:BIA:S2P:BI0_0Q00067213|           | 5097|Failed to lock table SAPSR3:0BW:BIA:S2P:BI0_0Q00067213 (-1) for consistency check: ERROR [CODE-2561] distributed metadata error: cannot find table object
exception  1: no.71002561  (ptime/storage/cc/lock/ObjectLockManagerImpl.cpp:1247)
    cannot find ta |
|2015/11/09 20:08:50|SAPSR3     |0BW:BIA:S2P:BI0_0Q00067214|           | 5097|Failed to lock table SAPSR3:0BW:BIA:S2P:BI0_0Q00067214 (-1) for consistency check: ERROR [CODE-2561] distributed metadata error: cannot find table object
exception  1: no.71002561  (ptime/storage/cc/lock/ObjectLockManagerImpl.cpp:1247)
    cannot find ta |
|2015/11/09 20:08:50|SAPSR3     |0BW:BIA:S2P:BI0_0Q00067215|           | 5097|Failed to lock table SAPSR3:0BW:BIA:S2P:BI0_0Q00067215 (-1) for consistency check: ERROR [CODE-2561] distributed metadata error: cannot find table object
exception  1: no.71002561  (ptime/storage/cc/lock/ObjectLockManagerImpl.cpp:1247)
    cannot find ta |
|2015/11/09 20:08:50|SAPSR3     |YRDB_HANA_T_02A           |           | 5099|metadata version changed while running checks: 392 -> 470                                                                                                                                                                                                      |
|2015/11/02 20:21:25|SAPSR3     |/BI0/0600000001           |           | 5099|metadata version changed while running checks: 21 -> 25                                                                                                                                                                                                        |
|2015/11/02 20:21:25|SAPSR3     |YRDB_HANA_TEST            |           | 5099|metadata version changed while running checks: 25 -> 28                                                                                                                                                                                                        |
|2015/11/02 20:21:25|SAPSR3     |YRDB_HANA_T_02A           |           | 5099|metadata version changed while running checks: 152 -> 168                                                                                                                                                                                                      |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  TIMESTAMP,
  NUM,
  SCHEMA_NAME,
  OBJECT_NAME,
  OBJECT_TYPE,
  COLUMN_NAME,
  LPAD(IFNULL(AFFECTED_COUNT, 1), 6) COUNT,
  LPAD(MAP(ERROR, -1, 'any', TO_VARCHAR(ERROR)), 5) ERROR,
  ERROR_MESSAGE
FROM
( SELECT
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TIME')          != 0 THEN TIMESTAMP     ELSE 'any'                                               END TIMESTAMP,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SCHEMA')        != 0 THEN SCHEMA_NAME   ELSE MAP(BI_SCHEMA_NAME, '%', 'any', BI_SCHEMA_NAME)     END SCHEMA_NAME,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'OBJECT')        != 0 THEN OBJECT_NAME   ELSE MAP(BI_OBJECT_NAME, '%', 'any', BI_OBJECT_NAME)     END OBJECT_NAME,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TYPE')          != 0 THEN OBJECT_TYPE   ELSE MAP(BI_OBJECT_TYPE, '%', 'any', BI_OBJECT_TYPE)     END OBJECT_TYPE,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'COLUMN')        != 0 THEN COLUMN_NAME   ELSE MAP(BI_COLUMN_NAME, '%', 'any', BI_COLUMN_NAME)     END COLUMN_NAME,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'ERROR_CODE')    != 0 THEN ERROR_CODE    ELSE BI_ERROR_CODE                                       END ERROR,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'ERROR_MESSAGE') != 0 THEN ERROR_MESSAGE ELSE MAP(BI_ERROR_MESSAGE, '%', 'any', BI_ERROR_MESSAGE) END ERROR_MESSAGE,
    SUM(AFFECTED_COUNT) AFFECTED_COUNT,
    LPAD(COUNT(*), 4) NUM
  FROM
  ( SELECT
      TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(C.LAST_START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE C.LAST_START_TIME END, 'YYYY/MM/DD HH24:MI:SS') TIMESTAMP,
      CE.SCHEMA_NAME,
      CE.OBJECT_NAME || MAP(CE.PART_ID, 0, '', ' (' || CE.PART_ID || ')') OBJECT_NAME,
      CE.OBJECT_TYPE,
      CE.COLUMN_NAME,
      CE.ERROR_CODE,
      CE.AFFECTED_COUNT,
      REPLACE(REPLACE(CE.ERROR_MESSAGE, CHAR(13), ''), CHAR(10), '') ERROR_MESSAGE,
      BI.SCHEMA_NAME BI_SCHEMA_NAME,
      BI.OBJECT_NAME BI_OBJECT_NAME,
      BI.OBJECT_TYPE BI_OBJECT_TYPE,
      BI.COLUMN_NAME BI_COLUMN_NAME,
      BI.ERROR_CODE BI_ERROR_CODE,
      BI.ERROR_MESSAGE BI_ERROR_MESSAGE,
      BI.AGGREGATE_BY
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
        TIMEZONE,                              /* SERVER, UTC */
        SCHEMA_NAME,
        OBJECT_NAME,
        OBJECT_TYPE,
        COLUMN_NAME,
        ERROR_CODE,
        ERROR_MESSAGE,
        EXCLUDE_INFO_MESSAGES,
        AGGREGATE_BY 
      FROM
      ( SELECT                /* Modification section */
          '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
          '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
          'SERVER' TIMEZONE,                              /* SERVER, UTC */
          '%' SCHEMA_NAME,
          '%' OBJECT_NAME,
          '%' OBJECT_TYPE,
          '%' COLUMN_NAME,
          -1 ERROR_CODE,
          '%' ERROR_MESSAGE,
          'X' EXCLUDE_INFO_MESSAGES,
          'NONE' AGGREGATE_BY       /* TIME, SCHEMA, OBJECT, TYPE, COLUMN, ERROR_CODE, ERROR_MESSAGE or comma separated combinations, NONE for no aggregation */
        FROM
          DUMMY
      )
    ) BI,
      M_CONSISTENCY_CHECK_HISTORY C,
      M_CONSISTENCY_CHECK_HISTORY_ERRORS CE
    WHERE
      C.CHECK_EXECUTION_ID = CE.CHECK_EXECUTION_ID AND
      CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(C.LAST_START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE C.LAST_START_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
      IFNULL(CE.SCHEMA_NAME, '') LIKE BI.SCHEMA_NAME AND
      IFNULL(CE.OBJECT_NAME, '') LIKE BI.OBJECT_NAME AND
      IFNULL(CE.OBJECT_TYPE, '') LIKE BI.OBJECT_TYPE AND
      IFNULL(CE.COLUMN_NAME, '') LIKE BI.COLUMN_NAME AND
      ( BI.ERROR_CODE = -1 OR CE.ERROR_CODE LIKE BI.ERROR_CODE ) AND
      CE.ERROR_MESSAGE LIKE BI.ERROR_MESSAGE AND
      ( BI.EXCLUDE_INFO_MESSAGES = ' ' OR
        CE.ERROR_CODE NOT IN (0, 8, 5084, 5089, 5096, 5097, 5098, 5099 )
      )
  )
  GROUP BY
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TIME')          != 0 THEN TIMESTAMP     ELSE 'any'                                               END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SCHEMA')        != 0 THEN SCHEMA_NAME   ELSE MAP(BI_SCHEMA_NAME, '%', 'any', BI_SCHEMA_NAME)     END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'OBJECT')        != 0 THEN OBJECT_NAME   ELSE MAP(BI_OBJECT_NAME, '%', 'any', BI_OBJECT_NAME)     END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TYPE')          != 0 THEN OBJECT_TYPE   ELSE MAP(BI_OBJECT_TYPE, '%', 'any', BI_OBJECT_TYPE)     END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'COLUMN')        != 0 THEN COLUMN_NAME   ELSE MAP(BI_COLUMN_NAME, '%', 'any', BI_COLUMN_NAME)     END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'ERROR_CODE')    != 0 THEN ERROR_CODE    ELSE BI_ERROR_CODE                                       END,
    CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'ERROR_MESSAGE') != 0 THEN ERROR_MESSAGE ELSE MAP(BI_ERROR_MESSAGE, '%', 'any', BI_ERROR_MESSAGE) END
)
ORDER BY
  TIMESTAMP DESC,
  SCHEMA_NAME,
  OBJECT_NAME,
  OBJECT_TYPE,
  COLUMN_NAME