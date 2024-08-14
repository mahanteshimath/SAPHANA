SELECT

/* 

[NAME]

- HANA_Security_PasswordPolicies_2.00.020+

[DESCRIPTION]

- Configured password policies

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- USERGROUP_PARAMETERS available with SAP HANA >= 2.00.020

[VALID FOR]

- Revisions:              >= 2.00.020

[SQL COMMAND VERSION]

- 2018/04/09:  1.0 (initial version)
- 2020/12/19:  1.1 (dedicated 2.00.020+ version including USERGROUP_PARAMETERS)

[INVOLVED TABLES]

- M_PASSWORD_POLICY

[INPUT PARAMETERS]

- USER_GROUP

  User group name

  'EXTERNAL_USERS'  --> Display password policies for user group EXTERNAL_USERS
  '%'               --> No restriction related to user group name

- PROPERTY

  Password policy property

  'password_layout' --> Property password_layout
  'min%'            --> All properties starting with 'min'
  '%'               --> No restriction related to property

- VALUE

  Property value

  'false'           --> Property value false
  '%'               --> No restriction related to property value

[OUTPUT PARAMETERS]

- USER_GROUP: User group name
- PROPERTY:   Password policy property
- VALUE:      Property value

[EXAMPLE OUTPUT]

------------------------------------------------------------------
|USER_GROUP    |PROPERTY                                   |VALUE|
------------------------------------------------------------------
|              |detailed_error_on_connect                  |false|
|EXTERNAL_USERS|detailed_error_on_connect                  |FALSE|
|              |force_first_password_change                |false|
|EXTERNAL_USERS|force_first_password_change                |FALSE|
|              |last_used_passwords                        |0    |
|EXTERNAL_USERS|last_used_passwords                        |0    |
|              |maximum_invalid_connect_attempts           |6    |
|EXTERNAL_USERS|maximum_invalid_connect_attempts           |6    |
|              |maximum_password_lifetime                  |182  |
|EXTERNAL_USERS|maximum_password_lifetime                  |182  |
------------------------------------------------------------------

*/

  P.USER_GROUP,
  P.PROPERTY,
  P.VALUE
FROM
( SELECT                       /* Modification section */
    '%' USER_GROUP,
    '%' PROPERTY,
    '%' VALUE
  FROM
    DUMMY
) BI,
( SELECT
    '' USER_GROUP,
    PROPERTY,
    VALUE
  FROM
    M_PASSWORD_POLICY
  UNION ALL
  SELECT
    USERGROUP_NAME USER_GROUP,
    PARAMETER_NAME PROPERTY,
    PARAMETER_VALUE VALUE
  FROM
    USERGROUP_PARAMETERS
  WHERE
    PARAMETER_SET_NAME = 'password policy'
) P
WHERE
  P.PROPERTY LIKE BI.PROPERTY AND
  P.VALUE LIKE BI.VALUE AND
  P.USER_GROUP LIKE BI.USER_GROUP
ORDER BY
  P.PROPERTY,
  P.USER_GROUP,
  P.VALUE
