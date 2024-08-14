SELECT
/* 

[NAME]

- HANA_SQL_ExpensiveStatements_BindValues_1.00.60+

[DESCRIPTION]

- Show bind values for SQL statements captured with the expensive statement trace

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Only populated if expensive statements trace is activated (SAP Note 2180165)
- Column STATEMENT_HASH available with SAP HANA >= 1.00.60

[VALID FOR]

- Revisions:              >= 1.00.60

[SQL COMMAND VERSION]

- 2014/10/09:  1.0 (initial version)
- 2017/10/26:  1.1 (TIMEZONE included)
- 2018/12/04:  1.2 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- M_EXPENSIVE_STATEMENTS

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

[OUTPUT PARAMETERS]

- EXECUTION_TIMESTAMP: Timestamp of statement execution
- STATEMENT_HASH:      Statement hash
- POS:                 Bind variable position in SQL statement
- VALUE:               Bind value

[EXAMPLE OUTPUT]

EXECUTION_TIMESTAMP|STATEMENT_HASH                  |POS|VALUE    

2014/10/09 15:56:09|96d5f96162346709b244ba275464a424|  1|'2228',  
                   |                                |  2|'27772'  
                   |                                |  3|'9997772'
                   |                                |  4|'21708'  
                   |                                |  5|'X2228'  
2014/10/09 15:55:46|96d5f96162346709b244ba275464a424|  1|'779',   
                   |                                |  2|'29221'  
                   |                                |  3|'9999221'
                   |                                |  4|'23296'  
                   |                                |  5|'X779'   

*/

  CASE WHEN D.POSITION = 1 THEN TO_VARCHAR(D.START_TIME, 'YYYY/MM/DD HH24:MI:SS') ELSE '' END EXECUTION_TIMESTAMP,
  CASE WHEN D.POSITION = 1 THEN D.STATEMENT_HASH                                  ELSE '' END STATEMENT_HASH,
  LPAD(D.POSITION, 3) POS,
  D.VALUE
FROM
( SELECT
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(S.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE S.START_TIME END START_TIME,
    S.STATEMENT_HASH,
    CASE 
      WHEN P.POSITION = 1 AND INSTR(S.PARAMETERS, D.SEPARATOR)                    = 0 THEN S.PARAMETERS
      WHEN P.POSITION = 1 AND INSTR(S.PARAMETERS, D.SEPARATOR)                    > 0 THEN SUBSTR(S.PARAMETERS, 1, INSTR(S.PARAMETERS, D.SEPARATOR) - 1)
      WHEN P.POSITION > 1 AND INSTR(S.PARAMETERS, D.SEPARATOR, 1, P.POSITION - 1) = 0 THEN NULL
      WHEN P.POSITION > 1 AND INSTR(S.PARAMETERS, D.SEPARATOR, 1, P.POSITION - 1) > 0 AND INSTR(S.PARAMETERS, D.SEPARATOR, 1, P.POSITION) = 0 THEN 
        SUBSTR(S.PARAMETERS, INSTR(S.PARAMETERS, D.SEPARATOR, 1, P.POSITION - 1) + LENGTH(D.SEPARATOR))
      WHEN P.POSITION > 1 AND INSTR(S.PARAMETERS, D.SEPARATOR, 1, P.POSITION - 1) > 0 AND INSTR(S.PARAMETERS, D.SEPARATOR, 1, P.POSITION) > 0 THEN 
        SUBSTR(S.PARAMETERS, INSTR(S.PARAMETERS, D.SEPARATOR, 1, P.POSITION - 1) + LENGTH(D.SEPARATOR), INSTR(S.PARAMETERS, D.SEPARATOR, 1, P.POSITION) - 
          INSTR(S.PARAMETERS, D.SEPARATOR, 1, P.POSITION - 1) - LENGTH(D.SEPARATOR))
    END VALUE,
    P.POSITION
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
      STATEMENT_HASH
    FROM
    ( SELECT                    /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        'SERVER' TIMEZONE,                              /* SERVER, UTC */
        '5001448e53fb2db7f529b1830dfe735f' STATEMENT_HASH
      FROM
        DUMMY
    )
  ) BI,
  ( SELECT ',' || CHAR(32) SEPARATOR FROM DUMMY ) D,
    M_EXPENSIVE_STATEMENTS S,
    ( SELECT TOP 100 ROW_NUMBER () OVER () POSITION FROM OBJECTS ) P
  WHERE
    S.STATEMENT_HASH LIKE BI.STATEMENT_HASH AND
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(S.START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE S.START_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    S.PARAMETERS != ''
) D
WHERE
  VALUE IS NOT NULL
ORDER BY
  D.START_TIME DESC,
  D.STATEMENT_HASH,
  D.POSITION
