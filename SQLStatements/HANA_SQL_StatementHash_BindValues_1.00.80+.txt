SELECT
/* 

[NAME]

- HANA_SQL_StatementHash_BindValues_1.00.80+

[DESCRIPTION]

- Show bind values for prepared statement

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_SQL_PLAN_CACHE_PARAMETERS only available as of revision 80

- Controlled by three parameters:

  indexserver.ini -> [sql] -> plan_cache_parameter_enabled

  -> true:  Enables M_SQL_PLAN_CACHE_PARAMETERS information collection (default)
  -> false: Disables M_SQL_PLAN_CACHE_PARAMETERS information collection

  indexserver.ini -> [sql] -> plan_cache_parameter_sum_threshold

  -> Minimum total execution of SQL statement to capture first set of bind values (in ms, default: 100000)

  indexserver.ini -> [sql] -> plan_cache_parameter_threshold

  -> Additional sets of bind values are captured if execution time is larger than execution time during last capturing and
     execution time is higher than the parameter value (in ms, default: 100)

[VALID FOR]

- Revisions:              >= 1.00.80

[SQL COMMAND VERSION]

- 2014/10/07:  1.0 (initial version)
- 2017/10/26:  1.1 (TIMEZONE included)
- 2018/12/04:  1.2 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- M_SQL_PLAN_CACHE_PARAMETERS
- M_SQL_PLAN_CACHE

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

- STATEMENT_HASH      
 
  Hash of SQL statement to be analyzed

  '51f62795010e922370bf897325148783' --> Consider SQL statement with statement hash 51f62795010e922370bf897325148783
  '%'                                --> No restriction in tersm of statement hash

- PLAN_ID

  SQL plan identifier

  12345678       --> SQL plan identifier 12345678
  -1             --> No restriction based on SQL plan identifier

[OUTPUT PARAMETERS]

- EXECUTION_TIMESTAMP: Timestamp of statement execution
- STATEMENT_HASH:      Statement hash
- PLAN_ID:             Execution plan ID
- POS:                 Bind variable position in SQL statement
- DATA_TYPE:           Data type
- VALUE:               Bind value

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------
|EXECUTION_TIMESTAMP|STATEMENT_HASH                  |PLAN_ID   |POS|DATA_TYPE   |VALUE       |
-----------------------------------------------------------------------------------------------
|2015/03/26 13:02:02|ce0f4988e2366e65f602f89e089a1bab|1299621700|  1|NVARCHAR(3) |'400'       |
|                   |                                |          |  2|NVARCHAR(10)|'SC00000073'|
|                   |                                |          |  3|NVARCHAR(1) |'C'         |
|                   |                                |          |  4|NVARCHAR(4) |'NORM'      |
-----------------------------------------------------------------------------------------------

*/

  CASE WHEN B.POSITION = 1 THEN TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(B.EXECUTION_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE B.EXECUTION_TIMESTAMP END, 'YYYY/MM/DD HH24:MI:SS') ELSE '' END EXECUTION_TIMESTAMP,
  CASE WHEN B.POSITION = 1 THEN S.STATEMENT_HASH    ELSE '' END STATEMENT_HASH,
  CASE WHEN B.POSITION = 1 THEN LPAD(B.PLAN_ID, 10) ELSE '' END PLAN_ID,
  LPAD(B.POSITION, 3) POS,
  B.DATA_TYPE_NAME DATA_TYPE,
  CASE
    WHEN B.DATA_TYPE_NAME LIKE 'DECIMAL%' OR B.DATA_TYPE_NAME LIKE 'INTEGER%' THEN B.PARAMETER_VALUE
    ELSE CHAR(39) ||B.PARAMETER_VALUE || CHAR(39)
  END VALUE
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
    STATEMENT_HASH,
    PLAN_ID
  FROM
  ( SELECT                    /* Modification section */
      '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
      '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
      'SERVER' TIMEZONE,                              /* SERVER, UTC */
      'e00f30a426b29bfed5e808822f82d14c' STATEMENT_HASH,
      -1 PLAN_ID
    FROM
      DUMMY
  )
) BI,
  M_SQL_PLAN_CACHE S,
  M_SQL_PLAN_CACHE_PARAMETERS B
WHERE
  S.STATEMENT_HASH LIKE BI.STATEMENT_HASH AND
  ( BI.PLAN_ID = -1 OR S.PLAN_ID = BI.PLAN_ID ) AND
  B.PLAN_ID = S.PLAN_ID AND
  CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(B.EXECUTION_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE B.EXECUTION_TIMESTAMP END BETWEEN BI.BEGIN_TIME AND BI.END_TIME
ORDER BY
  B.EXECUTION_TIMESTAMP DESC,
  S.STATEMENT_HASH,
  B.PLAN_ID,
  B.POSITION
