SELECT
/* 

[NAME]

- HANA_Features_Usage

[DESCRIPTION]

- SAP HANA feature usage information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- See SAP Note 2425002 for deprecations starting with SAP HANA 2.00 SPS 01
- Hint OPTIMIZATION_LEVEL(RULE_BASED) to bypass high compilation times and memory requirements (bug 253741)

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2017/04/29:  1.0 (initial version)
- 2017/10/24:  1.1 (TIMEZONE included)
- 2019/05/18:  1.2 (MAX_HOURS_SINCE_LAST_USED included)
- 2020/02/03:  1.3 (SKIP_ERRONEOUS_DEPRECATION_MESSAGES added)
- 2020/05/13:  1.4 (APP_SOURCE and APP_NAME included)
- 2020/08/03:  1.5 (hint OPTIMIZATION_LEVEL(RULE_BASED) added)

[INVOLVED TABLES]

- M_FEATURE_USAGE

[INPUT PARAMETERS]

- TIMEZONE

  Used timezone (both for input and output parameters)

  'SERVER'       --> Display times in SAP HANA server time
  'UTC'          --> Display times in UTC time

- COMPONENT_NAME

  Component name

  'CALCENGINE'        --> Only show features related to CALCENGINE
  '%'                 --> No restriction by component

- FEATURE_NAME

  Feature name

  'HINT'              --> Only show information related to feature HINT
  '%'                 --> No restriction by feature

- IS_DEPRECATED

  Deprecation status

  'TRUE'              --> Only display deprecated features
  'FALSE'             --> Only display non-deprecated features
  '%'                 --> No restriction related to deprecation status

- SKIP_ERRONEOUS_DEPRECATION_MESSAGES

  Possibility to skip unjustified deprecation messages

  'X'                 --> Skip features with unjustified deprecation messages
  ' '                 --> Show all features independent on unjustified deprecation message

- MAX_HOURS_SINCE_LAST_USED

  Maximum time threshold since feature was used last time

  10                  --> Only show features that were used within the last 10 hours
  -1                  --> No limitation related to last usage time
  
[OUTPUT PARAMETERS]

- COMPONENT_NAME:  Component name
- FEATURE_NAME:    Feature name
- DEPRECATED:      Deprecation status (TRUE or FALSE)
- OBJECT_COUNT:    Number of objects related to the feature
- CALL_COUNT:      Number of usage of feature (since last indexserver restart)
- LAST_USAGE_TIME: Time of last feature usage
- USER_NAME:       Database user responsible for last feature usage
- STATEMENT_HASH:  SQL statement hash responsible for last feature usage
- APP_USER:        Application user responsible for last feature usage
- APP_NAME:        Application name responsible for last feature usage
- APP_SOURCE:      Application source responsible for last feature usage

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|COMPONENT_NAME     |FEATURE_NAME                         |DEPRECATED|OBJECT_COUNT|CALL_COUNT|LAST_USAGE_TIME    |USER_NAME   |APP_USER_NAME  |STATEMENT_HASH                  |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|DSO                |IMO                                  |TRUE      |           0|         0|                   |            |               |                                |
|DSO                |IMO CONVERSION                       |TRUE      |           0|         0|                   |            |               |                                |
|ESH                |XSC_ODATA                            |TRUE      |           0|         0|                   |            |               |                                |
|SQL HINT           |OLAP_PARALLEL_AGGREGATION            |TRUE      |           0|         0|                   |            |               |                                |
|SQL HINT           |USE_TRANSFORMATION                   |TRUE      |           0|         0|                   |            |               |                                |
|SQL UPDATE         |UPDATE FROM                          |TRUE      |           0|         8|2017/04/24 21:43:04|            |_SYS_STATISTICS|d4b499431f2cc38dbe154152d85815fe|
|SQLSCRIPT          |ALTER PROCEDURE RECOMPILE            |TRUE      |           0|         0|                   |            |               |                                |
|SQLSCRIPT          |DCL in dynamic SQL                   |TRUE      |           0|      3429|2017/04/29 16:29:00|            |_SYS_STATISTICS|12e4370033bd3d72f87b13621cc59ec9|
|SQLSCRIPT          |DEFAULT SCHEMA                       |TRUE      |           0|         3|2017/04/27 22:35:53|SYSTEM      |SYSTEM         |208d10aefd9ba7fbf7f86d9b69ffcdaa|
|SQLSCRIPT          |IN DEBUG MODE                        |TRUE      |           0|         0|                   |            |               |                                |
|SQLSCRIPT          |TRACE OPERATOR                       |TRUE      |           0|         0|                   |            |               |                                |
|SQLSCRIPT          |WITH OVERVIEW                        |TRUE      |           0|         0|                   |            |               |                                |
|SQLSCRIPT          |WITH PARAMETERS                      |TRUE      |           0|         0|                   |            |               |                                |
|SQLSCRIPT          |WITH RESULT VIEW                     |TRUE      |          36|         0|                   |            |               |                                |
|STATIC RESULT CACHE|RETENTION 0                          |TRUE      |           0|         0|                   |            |               |                                |
|SYSTEMFUNCTION     |CONVERT_CURRENCY/DEPRECATED_COLUMNS  |TRUE      |           0|         0|                   |            |               |                                |
|SYSTEMFUNCTION     |CONVERT_CURRENCY/POSITIONAL_PARAMETER|TRUE      |           0|         0|                   |            |               |                                |
|SYSTEMVIEW         |M_SHARED_MEMORY                      |TRUE      |           0|     32716|2017/04/29 16:29:49|            |_SYS_STATISTICS|07fd3f919cf7be00234c52cb7a3dd4b3|
|SYSTEMVIEW         |M_TENANTS                            |TRUE      |           0|         0|                   |            |               |                                |
|SYSTEMVIEW         |QUERY_PLANS                          |TRUE      |           0|         0|                   |            |               |                                |
|TABLE TYPE         |HISTORY                              |TRUE      |           0|         0|                   |            |               |                                |
|TEXT               |CS_TEXT                              |TRUE      |           0|         0|                   |            |               |                                |
|TEXT               |QPF                                  |TRUE      |           0|         0|                   |            |               |                                |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  FU.COMPONENT_NAME,
  FU.FEATURE_NAME,
  FU.IS_DEPRECATED DEPRECATED,
  LPAD(IFNULL(FU.OBJECT_COUNT, 0), 12) OBJECT_COUNT,
  LPAD(IFNULL(FU.CALL_COUNT, 0), 10) CALL_COUNT,
  MAP(FU.LAST_TIMESTAMP, NULL, '', TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(FU.LAST_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE FU.LAST_TIMESTAMP END, 'YYYY/MM/DD HH24:MI:SS')) LAST_USAGE_TIME,
  IFNULL(FU.LAST_USER_NAME, '') USER_NAME,
  IFNULL(FU.LAST_STATEMENT_HASH, '') STATEMENT_HASH,
  IFNULL(FU.LAST_APPLICATION_USER_NAME, '') APP_USER,
  IFNULL(FU.LAST_APPLICATION_NAME, '') APP_NAME,
  IFNULL(FU.LAST_APPLICATION_SOURCE, '') APP_SOURCE
FROM
( SELECT         /* Modification section */
    'SERVER' TIMEZONE,                              /* SERVER, UTC */
    '%' COMPONENT_NAME,
    '%' FEATURE_NAME,
    'TRUE' IS_DEPRECATED,
    'X' SKIP_ERRONEOUS_DEPRECATION_MESSAGES,
    24 * 30 MAX_HOURS_SINCE_LAST_USED
  FROM
    DUMMY
) BI,
  M_FEATURE_USAGE FU
WHERE
  FU.COMPONENT_NAME LIKE BI.COMPONENT_NAME AND
  FU.FEATURE_NAME LIKE BI.FEATURE_NAME AND
  FU.IS_DEPRECATED LIKE BI.IS_DEPRECATED AND
  ( BI.SKIP_ERRONEOUS_DEPRECATION_MESSAGES = ' ' OR BI.IS_DEPRECATED != 'TRUE' OR 
    ( ( FU.COMPONENT_NAME, FU.FEATURE_NAME ) NOT IN
      ( ( 'EXPORT', 'SCRAMBLE' ) , ( 'EXPORT', 'STRIP' ), ( 'HIERARCHY', 'HIERARCHY VIEW' ), ( 'HIGH AVAILABILITY', 'HOST AUTO FAILOVER' ), 
        ( 'HIGH AVAILABILITY', 'STORAGE CONNECTOR' ), ( 'IMPORT FROM', 'NO TYPE CHECK' ), ( 'IMPORT FROM', 'SCHEMA FLEXIBILITY' ), ( 'IMPORT FROM', 'TABLE LOCK' ),
        ( 'LOB', 'ST_MEMORY_LOB' ), ( 'SECURITY', 'CONFIGURATION PARAMETER: MAXIMUM_UNUSED_INITAL_PASSWORD_LIFETIME' ), ( 'SECURITY', 'DATA ADMIN' ),
        ( 'SECURITY', 'SAPLOGON AUTHENTICATION' ), ( 'SECURITY', 'X509INTERNAL AUTHENTICATION' ), ( 'SPATIAL', 'GEOCODE INDEXES' ), ( 'SYSTEM', 'ALTER SYSTEM LOGGING OFF' ),
        ( 'TABLE TYPE', 'FLEXIBLE' ), ( 'TABLE TYPE', 'HISTORY' ), ( 'TABLE TYPE', 'NO LOGGING RETENTION' ) 
      ) AND
      FU.COMPONENT_NAME != 'SQL UNQUOTED IDENTIFIER'
    )
  ) AND
  ( BI.MAX_HOURS_SINCE_LAST_USED = -1 OR FU.LAST_TIMESTAMP >= ADD_SECONDS(CURRENT_TIMESTAMP, - 3600 * BI.MAX_HOURS_SINCE_LAST_USED) )
ORDER BY
  FU.COMPONENT_NAME,
  FU.FEATURE_NAME
WITH HINT (OPTIMIZATION_LEVEL(RULE_BASED))