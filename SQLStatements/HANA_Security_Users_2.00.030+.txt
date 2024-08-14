SELECT
/*
  
[NAME]
  
- HANA_Security_Users_2.00.030+
  
[DESCRIPTION]
  
- User and schema overview
  
[SOURCE]
  
- SAP Note 1969700
  
[DETAILS AND RESTRICTIONS]
  
- STRING_AGG only available as of Revision 1.00.72
- IS_LDAP_ENABLED available with SAP HANA >= 2.00.030
  
[VALID FOR]
  
- Revisions:              >= 2.00.030
  
[SQL COMMAND VERSION]
  
- 2014/05/07:  1.0 (initial version)
- 2014/12/12:  1.1 (USER_PARAMETERS included)
- 2015/02/12:  1.2 (PWD_EXPIRATION included)
- 2015/12/15:  1.3 (ONLY_USERS_WITH_EXPIRATION_DATE included)
- 2017/07/25:  1.4 (MIN_USER_CONNECTIONS and M_CONNECTIONS included)
- 2017/10/26:  1.5 (TIMEZONE included)
- 2018/11/14:  1.6 (calculation of password expiration time based on parameter maximum_password_lifetime)
- 2019/06/02:  1.7 (dedicated 2.00.030+ version including IS_LDAP_ENABLED)
- 2020/11/22:  1.8 (ONLY_USERS_WITH_WORKLOAD_PARAMETERS added)
- 2020/12/19:  1.8 (USERGROUP_PARAMETERS included)
- 2021/02/05:  1.9 (replacement of deprecated PASSWORD_CHANGE_TIME with LAST_PASSWORD_CHANGE_TIME and IS_PASSWORD_LIFETIME_CHECK_ENABLED)
- 2021/11/28:  2.0 (VALID_FROM added)
  
[INVOLVED TABLES]
  
- M_CONNECTIONS
- SCHEMAS
- USERGROUP_PARAMETERS
- USER_PARAMETERS
- USERS
  
[INPUT PARAMETERS]
  
- TIMEZONE
  
  Used timezone (both for input and output parameters)
  
  'SERVER'       --> Display times in SAP HANA server time
  'UTC'          --> Display times in UTC time
  
- USER_NAME
  
  User name
  
  'SAPECC'        --> Only show user SAPECC
  'SAP%'          --> Show users with names starting with 'SAP'
  '%'             --> No user name restriction
  
- USER_GROUP
  
  User group name
  
  'EXTERNAL_USERS' --> Display password policies for user group EXTERNAL_USERS
  '%'              --> No restriction related to user group name
  
- PARAMETER_NAME
  
  Name of user parameter
  
  'CLIENT'        --> Users with parameter CLIENT being set
  '%'             --> No restriction related to user parameters
  
- MIN_USER_CONNECTIONS
  
  Minimum number of current connections with the user
  
  20              --> Only display users with at least 20 current connections
  -1              --> No restriction related to number of current connections
  
- ONLY_USERS_WITH_EXPIRATION_DATE
  
  Possibility to restrict output to users with end-of-validity date (VALID_UNTIL)
  
  'X'             --> Only display users with expiration date
  ' '             --> No restriction related to expiration date
  
- ONLY_USERS_WITH_PWD_EXPIRATION
  
  Possibility to restrict output to users with password expiration
  
  'X'             --> Only display users with password expiration
  ' '             --> No restriction related to password expiration
  
- ONLY_USERS_WITH_LDAP_AUTHENTICATION
  
  Possibility to restrict output to users with LDAP authentication
  
  'X'             --> Only display users with LDAP authentication
  ' '             --> No restriction related to user authentication mechanism
  
- ONLY_USERS_WITH_WORKLOAD_PARAMETERS
  
  Possibility to restrict output to users with workload parameters (other parameters for the same users are not displayed)
  
  'X'             --> Only display users with workload parameters
  ' '             --> No restriction related to users with workload parameters
  
[OUTPUT PARAMETERS]
  
- USER_NAME:       User name
- USER_GROUP:      User group
- L:               LDAP authentication ('X' -> LDAP, ' ', -> no LDAP)
- CREATION_TIME:   User creation time
- VALID_FROM:      Begin of user validity, empty if no begin validity restriction applies
- VALID_UNTIL:     End of user validity, empty if no end validity restriction applies
- PWD_EXPIRE_TIME: Password expiration time
- DEACTIVATED:     'NO' if user is locked, otherwise 'YES'
- CONNECTIONS:     Number of current connections with this database user
- SCHEMA_NAMES:    Schemas assigned to user
- USER_PARAMETERS: User specific parameter settings
  
[EXAMPLE OUTPUT]
  
---------------------------------------------------------------------------------------------------
|USER_NAME|CREATION_TIME      |VALID_UNTIL|PWD_EXPIRATION|DEACTIVATED|SCHEMA_NAMES|USER_PARAMETERS|
---------------------------------------------------------------------------------------------------
|SAPDBCTRL|2014/12/11 15:48:04|           |YES           |NO         |SAPDBCTRL   |               |
|SAPTBJDB |2015/01/29 10:12:12|           |NO            |NO         |SAPTBJDB    |               |
|SAPSR3   |2015/02/04 16:01:34|           |NO            |NO         |SAPTBW      |               |
---------------------------------------------------------------------------------------------------
  
*/
  
  U.USER_NAME,
  IFNULL(U.USERGROUP_NAME, '') USER_GROUP,
  MAP(U.IS_LDAP_ENABLED, 'TRUE', 'X', ' ') L,
  TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(U.CREATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE U.CREATE_TIME END, 'YYYY/MM/DD HH24:MI:SS') CREATION_TIME,
  IFNULL(TO_VARCHAR(U.VALID_FROM, 'YYYY/MM/DD HH24:MI:SS'), '') VALID_FROM,
  IFNULL(TO_VARCHAR(U.VALID_UNTIL, 'YYYY/MM/DD HH24:MI:SS'), '') VALID_UNTIL,
  CASE
    WHEN U.IS_PASSWORD_LIFETIME_CHECK_ENABLED = 'TRUE' THEN
      TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(ADD_DAYS(U.LAST_PASSWORD_CHANGE_TIME, IFNULL(UGP.UG_PWD_LIFETIME_DAYS, P.PWD_LIFETIME_DAYS)), SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP))
      ELSE ADD_DAYS(U.LAST_PASSWORD_CHANGE_TIME, IFNULL(UGP.UG_PWD_LIFETIME_DAYS, P.PWD_LIFETIME_DAYS))
      END, 'YYYY/MM/DD HH24:MI:SS')
    ELSE ''
  END PWD_EXPIRE_TIME,
  MAP(U.USER_DEACTIVATED, 'TRUE', 'YES', 'NO') DEACTIVATED,
  LPAD(IFNULL(C.NUM_CONNECTIONS, 0), 11) CONNECTIONS,
  S.SCHEMA_NAMES,
  IFNULL(STRING_AGG(UP.PARAMETER || '=' || UP.VALUE, ', '), '') USER_PARAMETERS
FROM
( SELECT                       /* Modification section */
    'SERVER' TIMEZONE,                              /* SERVER, UTC */
    '%' USER_NAME,
    '%' USER_GROUP,
    '%' PARAMETER_NAME,
    -1 MIN_USER_CONNECTIONS,
    ' ' ONLY_USERS_WITH_EXPIRATION_DATE,
    ' ' ONLY_USERS_WITH_PWD_EXPIRATION,
    ' ' ONLY_USERS_WITH_LDAP_AUTHENTICATION,
    ' ' ONLY_USERS_WITH_WORKLOAD_PARAMETERS
  FROM
    DUMMY
) BI,
  USERS U LEFT OUTER JOIN
( SELECT
    IFNULL(MODIFIED_VALUE, DEFAULT_VALUE) PWD_LIFETIME_DAYS
  FROM
  ( SELECT
      MAX(MAP(LAYER_NAME, 'DEFAULT', VALUE, NULL)) DEFAULT_VALUE,
      MAX(MAP(LAYER_NAME, 'DEFAULT', NULL, VALUE)) MODIFIED_VALUE
    FROM
      M_INIFILE_CONTENTS
    WHERE
      KEY = 'maximum_password_lifetime'
  )
) P ON
    1 = 1 LEFT OUTER JOIN
( SELECT
    USERGROUP_NAME,
    PARAMETER_VALUE UG_PWD_LIFETIME_DAYS
  FROM
    USERGROUP_PARAMETERS
  WHERE
    PARAMETER_NAME = 'maximum_password_lifetime'
) UGP ON
    U.USERGROUP_NAME = UGP.USERGROUP_NAME LEFT OUTER JOIN
( SELECT
    SCHEMA_OWNER,
    STRING_AGG(SCHEMA_NAME, ', ') SCHEMA_NAMES
  FROM
    SCHEMAS
  GROUP BY
    SCHEMA_OWNER
) S ON
    S.SCHEMA_OWNER = U.USER_NAME LEFT OUTER JOIN
  USER_PARAMETERS UP ON
    UP.USER_NAME = U.USER_NAME LEFT OUTER JOIN
( SELECT
    USER_NAME,
    COUNT(*) NUM_CONNECTIONS
  FROM
    M_CONNECTIONS
  WHERE
    CONNECTION_ID > 0
  GROUP BY
    USER_NAME
) C ON
    C.USER_NAME = U.USER_NAME
WHERE
  U.USER_NAME LIKE BI.USER_NAME AND
  IFNULL(U.USERGROUP_NAME, '') LIKE BI.USER_GROUP AND
  IFNULL(UP.PARAMETER, '') LIKE BI.PARAMETER_NAME AND
  ( BI.ONLY_USERS_WITH_EXPIRATION_DATE = ' ' AND BI.ONLY_USERS_WITH_PWD_EXPIRATION = ' ' OR
    BI.ONLY_USERS_WITH_EXPIRATION_DATE = 'X' AND BI.ONLY_USERS_WITH_PWD_EXPIRATION = 'X' AND ( U.VALID_UNTIL IS NOT NULL OR U.IS_PASSWORD_LIFETIME_CHECK_ENABLED ='TRUE' ) OR
    BI.ONLY_USERS_WITH_EXPIRATION_DATE = 'X' AND BI.ONLY_USERS_WITH_PWD_EXPIRATION = ' ' AND U.VALID_UNTIL IS NOT NULL OR
    BI.ONLY_USERS_WITH_EXPIRATION_DATE = ' ' AND BI.ONLY_USERS_WITH_PWD_EXPIRATION = 'X' AND U.IS_PASSWORD_LIFETIME_CHECK_ENABLED ='TRUE'
  ) AND
  ( BI.ONLY_USERS_WITH_LDAP_AUTHENTICATION = ' ' OR U.IS_LDAP_ENABLED = 'TRUE' ) AND
  ( BI.ONLY_USERS_WITH_WORKLOAD_PARAMETERS = ' ' OR UP.PARAMETER IN ( 'PRIORITY', 'STATEMENT MEMORY LIMIT', 'STATEMENT THREAD LIMIT' ) ) AND
  ( BI.MIN_USER_CONNECTIONS = -1 OR IFNULL(C.NUM_CONNECTIONS, 0) >= BI.MIN_USER_CONNECTIONS )
GROUP BY
  BI.TIMEZONE,
  U.USER_NAME,
  U.USERGROUP_NAME,
  U.IS_PASSWORD_LIFETIME_CHECK_ENABLED,
  U.CREATE_TIME,
  U.VALID_FROM,
  U.VALID_UNTIL,
  U.LAST_PASSWORD_CHANGE_TIME,
  U.USER_DEACTIVATED,
  U.IS_LDAP_ENABLED,
  UGP.UG_PWD_LIFETIME_DAYS,
  C.NUM_CONNECTIONS,
  S.SCHEMA_NAMES,
  P.PWD_LIFETIME_DAYS
ORDER BY
  U.USER_NAME