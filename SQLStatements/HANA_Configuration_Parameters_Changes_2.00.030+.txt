SELECT

/* 

[NAME]

- HANA_Configuration_Parameters_Changes_2.00.030+

[DESCRIPTION]

- Display SAP HANA parameter changes

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_INIFILE_CONTENT_HISTORY available with SAP HANA >= 2.00.030
- Content is no longer updated when global.ini -> [configuration] -> write_log is set to false

[VALID FOR]

- Revisions:              >= 2.00.030

[SQL COMMAND VERSION]

- 2015/11/16:  1.0 (initial version)
- 2015/12/29:  1.1 (TRACE_FILE included)
- 2017/10/24:  1.2 (TIMEZONE included)
- 2018/11/16:  1.3 (dedicated 2.00.030+ version based on M_INIFILE_CONTENT_HISTORY instead of trace files)
- 2018/12/04:  1.4 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- M_INIFILE_CONTENT_HISTORY

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

  'saphana01'     --> Specific host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- FILE_NAME

  Parameter file name

  'global.ini'    --> Display parameters maintained in global.ini
  '%'             --> No restriction related to parameter file name

- LAYER_NAME

  Parameter layer name

  'SYSTEM'        --> Display parameters maintained on SYSTEM layer
  '%'             --> No restriction related to layer

- SECTION

  Parameter file section

  'joins'         --> Specific parameter file section 'joins'
  'stat%'         --> All parameter file sections starting with 'stat'
  '%'             --> All parameter file sections

- PARAMETER_NAME

  Parameter name

  'enable'        --> Parameters with name 'enable'
  'unload%'       --> Parameters starting with 'unload'
  '%'             --> All parameters

- PARAMETER_VALUE

  Parameter value

  '300'           --> Only display parameters set to 300
  '%'             --> No restriction related to parameter value

- DB_USER

  Database user

  'SYSTEM'        --> Database user 'SYSTEM'
  '%'             --> No database user restriction

- APP_USER

  Application user

  'SAPSYS'        --> Application user 'SAPSYS'
  '%'             --> No application user restriction

- APP_NAME

  Name of application

  'ABAP:C11'      --> Application name 'ABAP:C11'
  '%'             --> No application name restriction

- APP_SOURCE

  Application source

  'SAPL2:437'     --> Application source 'SAPL2:437'
  'SAPMSSY2%'     --> Application sources starting with SAPMSSY2
  '%'             --> No application source restriction

- COMMENTS

  Parameter change comments (specified via COMMENT option of ALTER SYSTEM ALTER CONFIGURATION)

  'offline change detected' --> Only display view entries related to offline parameter change
  '%'                       --> No restriction related to parameter comment

- EXCLUDE_OFFLINE_CHANGES

  Possibility to exclude view entries indicating offline changes (without parameter details)

  'X'                       --> Suppress view entries related to offline changes
  ' '                       --> Display all view entries regardless of offline change or not

- EXCLUDE_EMPTY_PARAMETERS

  Possibility to skip view entries without parameter name

  'X'                       --> Only show view entries with maintained parameter name
  ' '                       --> Show all view entries

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'TIME'          --> Sorting by time
  'NAME'          --> Sorting by parameter name

[OUTPUT PARAMETERS]

- CHANGE_TIME:    Time of parameter change
- PARAMETER_NAME: Parameter name (including file name and section)
- VALUE:          Parameter value
- PREV_VALUE:     Previous parameter value
- LAYER_NAME:     Layer name
- HOST:           Host
- DB_USER:        Database user name
- APP_USER:       Application user name
- APP_NAME:       Application name
- APP_SOURCE:     Application source
- COMMENTS:       Comments (can be maintained via COMMENT option of ALTER SYSTEM ALTER CONFIGURATION)

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|CHANGE_TIME        |PARAMETER_NAME                                                                   |VALUE                                             |PREV_VALUE|LAYER_NAME|HOST       |DB_USER|APP_USER     |APP_NAME   |APP_SOURCE                                                                                                                                                                                                                                                     |COMMENTS|
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2018/11/14 15:09:39|global.ini -> [memorymanager] -> enable_sharing_allocator_for_implicit           |                                                  |false     |SYSTEM    |           |SYSTEM |HANAADM      |HDBStudio  |csns.sql.editor.SQLExecuteFormEditor$2$1.run(SQLExecuteFormEditor.java:920)                                                                                                                                                                                    |        |
|2018/11/14 15:08:48|global.ini -> [memorymanager] -> enable_sharing_allocator_for_implicit           |false                                             |          |SYSTEM    |           |SYSTEM |HANAADM      |HDBStudio  |csns.sql.editor.SQLExecuteFormEditor$2$1.run(SQLExecuteFormEditor.java:920)                                                                                                                                                                                    |        |
|2018/11/14 14:55:14|daemon.ini -> [dpserver.C11] -> instanceIdsInactive                              |                                                  |43        |HOST      |saphananode|SYSTEM |HANAADM      |HDBStudio  |csns.sql.editor.SQLExecuteFormEditor$2$1.run(SQLExecuteFormEditor.java:920)                                                                                                                                                                                    |        |
|2018/11/14 14:55:14|daemon.ini -> [dpserver.C11] -> instanceIds                                      |43                                                |          |HOST      |saphananode|SYSTEM |HANAADM      |HDBStudio  |csns.sql.editor.SQLExecuteFormEditor$2$1.run(SQLExecuteFormEditor.java:920)                                                                                                                                                                                    |        |
|2018/11/14 14:55:14|daemon.ini -> [indexserver.C11] -> instanceIdsInactive                           |                                                  |40        |HOST      |saphananode|SYSTEM |HANAADM      |HDBStudio  |csns.sql.editor.SQLExecuteFormEditor$2$1.run(SQLExecuteFormEditor.java:920)                                                                                                                                                                                    |        |
|2018/11/14 14:55:14|daemon.ini -> [dpserver.C11] -> instanceIdsInactive                              |43                                                |          |HOST      |saphananode|SYSTEM |HANAADM      |HDBStudio  |csns.sql.editor.SQLExecuteFormEditor$2$1.run(SQLExecuteFormEditor.java:920)                                                                                                                                                                                    |        |
|2018/11/14 14:55:14|daemon.ini -> [dpserver.C11] -> arguments                                        |-port 300$(INSTANCE:2)                            |          |HOST      |saphananode|SYSTEM |HANAADM      |HDBStudio  |csns.sql.editor.SQLExecuteFormEditor$2$1.run(SQLExecuteFormEditor.java:920)                                                                                                                                                                                    |        |
|2018/11/14 14:55:14|daemon.ini -> [dpserver.C11] -> stderr                                           |${SAP_RETRIEVAL_PATH}/trace/DB_C11/dpserver.err   |          |HOST      |saphananode|SYSTEM |HANAADM      |HDBStudio  |csns.sql.editor.SQLExecuteFormEditor$2$1.run(SQLExecuteFormEditor.java:920)                                                                                                                                                                                    |        |
|2018/11/14 14:55:14|daemon.ini -> [dpserver.C11] -> stdout                                           |${SAP_RETRIEVAL_PATH}/trace/DB_C11/dpserver.out   |          |HOST      |saphananode|SYSTEM |HANAADM      |HDBStudio  |csns.sql.editor.SQLExecuteFormEditor$2$1.run(SQLExecuteFormEditor.java:920)                                                                                                                                                                                    |        |
|2018/11/14 14:55:14|daemon.ini -> [dpserver.C11] -> startdir                                         |${SAP_RETRIEVAL_PATH}                             |          |HOST      |saphananode|SYSTEM |HANAADM      |HDBStudio  |csns.sql.editor.SQLExecuteFormEditor$2$1.run(SQLExecuteFormEditor.java:920)                                                                                                                                                                                    |        |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.TIME END, 'YYYY/MM/DD HH24:MI:SS') CHANGE_TIME,
  P.FILE_NAME || MAP(P.SECTION, '', '', CHAR(32) || '->' || CHAR(32) || '[' || P.SECTION || ']' || CHAR(32) || '->' || CHAR(32) || P.KEY) PARAMETER_NAME,
  P.VALUE,
  P.PREV_VALUE,
  P.LAYER_NAME,
  P.HOST,
  P.USER_NAME DB_USER,
  P.APPLICATION_USER_NAME APP_USER,
  P.APPLICATION_NAME APP_NAME,
  P.APPLICATION_SOURCE APP_SOURCE,
  P.COMMENTS
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
    HOST,
    FILE_NAME,
    LAYER_NAME,
    SECTION,
    PARAMETER_NAME,
    PARAMETER_VALUE,
    DB_USER,
    APP_USER,
    APP_NAME,
    APP_SOURCE,
    COMMENTS,
    EXCLUDE_OFFLINE_CHANGES,
    EXCLUDE_EMPTY_PARAMETERS,
    ORDER_BY
  FROM
  ( SELECT                 /* Modification section */
      '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
      '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
      'SERVER' TIMEZONE,                              /* SERVER, UTC */
      '%' HOST,
      '%' FILE_NAME,
      '%' LAYER_NAME,
      '%' SECTION,
      '%' PARAMETER_NAME,
      '%' PARAMETER_VALUE,
      '%' DB_USER,
      '%' APP_USER,
      '%' APP_NAME,
      '%' APP_SOURCE,
      '%' COMMENTS,
      'X' EXCLUDE_OFFLINE_CHANGES,
      'X' EXCLUDE_EMPTY_PARAMETERS,
      'TIME' ORDER_BY             /* TIME, PARAMETER */
    FROM
      DUMMY
  )
) BI,
( SELECT
    TIME,
    IFNULL(FILE_NAME, '') FILE_NAME,
    IFNULL(LAYER_NAME, '') LAYER_NAME,
    IFNULL(HOST, '') HOST,
    IFNULL(USER_NAME, '') USER_NAME,
    IFNULL(APPLICATION_NAME, '') APPLICATION_NAME,
    IFNULL(APPLICATION_USER_NAME, '') APPLICATION_USER_NAME,
    IFNULL(APPLICATION_SOURCE, '') APPLICATION_SOURCE,
    IFNULL(SECTION, '') SECTION,
    IFNULL(KEY, '') KEY,
    IFNULL(VALUE, '') VALUE,
    IFNULL(PREV_VALUE, '') PREV_VALUE,
    IFNULL(COMMENTS, '') COMMENTS
  FROM
    M_INIFILE_CONTENT_HISTORY
) P
WHERE
  CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
  P.HOST LIKE BI.HOST AND
  P.FILE_NAME LIKE BI.FILE_NAME AND
  P.LAYER_NAME LIKE BI.LAYER_NAME AND
  P.SECTION LIKE BI.SECTION AND
  P.KEY LIKE BI.PARAMETER_NAME AND
  P.VALUE LIKE BI.PARAMETER_VALUE AND
  P.USER_NAME LIKE BI.DB_USER AND
  P.APPLICATION_USER_NAME LIKE BI.APP_USER AND
  P.APPLICATION_NAME LIKE BI.APP_NAME AND
  P.APPLICATION_SOURCE LIKE BI.APP_SOURCE AND
  P.COMMENTS LIKE BI.COMMENTS AND
  P.COMMENTS != 'initial snapshot' AND
  ( BI.EXCLUDE_OFFLINE_CHANGES = ' ' OR P.COMMENTS != 'offline change detected' ) AND
  ( BI.EXCLUDE_EMPTY_PARAMETERS = ' ' OR P.KEY != '' )
ORDER BY
  MAP(BI.ORDER_BY, 'TIME', P.TIME) DESC,
  P.FILE_NAME,
  P.SECTION,
  P.KEY,
  P.TIME
