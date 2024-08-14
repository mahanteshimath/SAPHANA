SELECT
/* 

[NAME]

- HANA_Repository_Objects_Versions

[DESCRIPTION]

- Object versions in repository

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/03/06:  1.0 (initial version)
- 2018/12/04:  1.1 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- ACTIVE_OBJECT
- OBJECT_HISTORY

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

- ACTIVATION_USER_NAME

  Name of user responsible for activation of object

  'SAPC11'       --> Activation user SAPC11
  '%'            --> No restriction of activation user

- PACKAGE_NAME

  Package name

  'sap.hana.xs.sqlcc' --> Package sap.hana.xs.sqlcc
  'sap.hana.xs.%'     --> Packages starting with 'sap.hana.xs.'
  '%'                 --> No restriction of package

- OBJECT_VERSION

  Object version

  'CURRENT'      --> Current version
  'HISTORY'      --> Historic version
  'ALL'          --> Both current and historic versions

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'NAME'         --> Sorting by package name
  'DATE'         --> Sorting by activation date
  
[OUTPUT PARAMETERS]

- PACKAGE_NAME:   Package name
- OBJECT_NAME:    Object name
- OBJECT_SUFFIX:  Object suffix
- ACTIVATED_AT:   Activation time
- ACTIVATED_BY:   Activation user name
- OBJECT_VERSION: CURRENT for current version, HISTORY for historic version
- VERSION_ID:     Version number
- CVERSION:       Version details

[EXAMPLE OUTPUT]

PACKAGE_NAME                     |OBJECT_NAME                     |OBJECT_SUFFIX           |ACTIVATED_AT           |ACTIVATED_BY|OBJECT_VERSION|VERSION_ID|CVERSION

sap.hana.xs.ide.security         |                                |xsaccess                |2014-03-13 12:10:38.722|SYSTEM      |HISTORY       |1         |        
sap.hana.xs.ide.security         |                                |xsaccess                |2014-03-19 09:16:35.362|SYSTEM      |HISTORY       |2         |        
sap.hana.xs.ide.security         |                                |xsaccess                |2014-03-28 08:51:17.172|SYSTEM      |HISTORY       |3         |        
sap.hana.xs.ide.security         |                                |xsaccess                |2014-04-08 10:16:02.626|SYSTEM      |HISTORY       |4         |        
sap.hana.uiscontent.HANALaunch   |                                |xsprivileges            |2014-03-12 09:33:59.986|SYSTEM      |HISTORY       |1         |        

*/

  O.PACKAGE_ID PACKAGE_NAME,
  O.OBJECT_NAME,
  O.OBJECT_SUFFIX,
  O.ACTIVATED_AT,
  O.ACTIVATED_BY,
  O.OBJECT_VERSION,
  O.VERSION_ID,
  O.CVERSION
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
    ACTIVATION_USER_NAME,
    PACKAGE_NAME,
    OBJECT_VERSION,
    ORDER_BY
  FROM
  ( SELECT                                                                  /* Modification section */
      '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
      '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
      '%' ACTIVATION_USER_NAME,
      '%' PACKAGE_NAME,
      'ALL' OBJECT_VERSION,             /* CURRENT, HISTORY, ALL */
      'NAME' ORDER_BY                   /* NAME, DATE */
    FROM
      DUMMY
  )
) BI,
( SELECT
    'CURRENT' OBJECT_VERSION,
    PACKAGE_ID,
    OBJECT_NAME,
    OBJECT_SUFFIX,
    ACTIVATED_AT,
    ACTIVATED_BY,
    VERSION_ID,
    CDATA CVERSION
  FROM
    _SYS_REPO.ACTIVE_OBJECT 
  UNION ALL
  ( SELECT
      'HISTORY' OBJECT_VERSION,
      PACKAGE_ID,
      OBJECT_NAME,
      OBJECT_SUFFIX,
      ACTIVATED_AT,
      ACTIVATED_BY,
      VERSION_ID,
      CVERSION
    FROM
      _SYS_REPO.OBJECT_HISTORY
  )
) O
WHERE
  O.ACTIVATED_AT BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
  O.ACTIVATED_BY LIKE BI.ACTIVATION_USER_NAME AND
  O.PACKAGE_ID LIKE BI.PACKAGE_NAME AND
  ( BI.OBJECT_VERSION = 'ALL' OR BI.OBJECT_VERSION = O.OBJECT_VERSION )
ORDER BY
  MAP(BI.ORDER_BY, 'NAME', O.OBJECT_NAME, ' '),
  MAP(BI.ORDER_BY, 'DATE', O.ACTIVATED_AT) DESC
  
