SELECT

/* 

[NAME]

- HANA_SQL_PlanStability_StatementHints_2.00.040+

[DESCRIPTION]

- Display SAP HANA statement hints (SAP Note 2400006)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Statement hints available starting with Rev. 1.00.122.03
- STATEMENT_HINTS.STATEMENT_HASH available starting with 2.00.040

[VALID FOR]

- Revisions:              >= 2.00.040

[SQL COMMAND VERSION]

- 2017/04/03:  1.0 (initial version)
- 2017/10/26:  1.1 (TIMEZONE included)
- 2019/07/26:  1.2 (dedicated 2.00.040+ version including STATEMENT_HASH)
- 2020/11/20:  1.3 (EXCLUDE_DELIVERED_ENTRIES and ONLY_ENTRIES_OLDER_THAN_LAST_UPGRADE included)

[INVOLVED TABLES]

- STATEMENT_HINTS

[INPUT PARAMETERS]

- TIMEZONE

  Used timezone (both for input and output parameters)

  'SERVER'       --> Display times in SAP HANA server time
  'UTC'          --> Display times in UTC time

- STATEMENT_HASH      
 
  Hash of SQL statement to be analyzed

  '2e960d7535bf4134e2bd26b9d80bd4fa' --> SQL statement with hash '2e960d7535bf4134e2bd26b9d80bd4fa'
  '%'                                --> No statement hash restriction

- STATEMENT_STRING

  SQL statement string

  'SELECT%'       --> SQL statements starting with 'SELECT'
  '%'             --> All statement strings

- HINT_STRING

  Hint string

  'NO_CS_JOIN'    --> Only show entries with hint NO_CS_JOIN
  '%'             --> No restriction related to hints

- IS_ENABLED

  Flag if hint is currently enabled or not

  'TRUE'          --> Statement hint is enabled
  'FALSE'         --> Statement hint is disabled
  '%'             --> No restriction

- USER_NAME

  Name of user who has enabled the statement hint

  'SAPSR3'        --> Filter for hints being enabled by user SAPSR3
  '%'             --> No restriction related to enabling user

- EXCLUDE_PREDEFINED_ENTRIES

  Possibility to exclude statement hints that are pre-delivered (user is SYS)

  'X'             --> Only show customer-specific statement hints
  ' '             --> Consider all statement hints

- EXCLUDE_DELIVERED_ENTRIES

  Possibility to exclude statement hints delivered via SAP Note 2700051, no 100 % perfect heuristics,
  so result may not always be completely accurate

  'X'             --> Suppress display of statements hints delivered via SAP Note 2700051
  ' '             --> Consider all statement hints

- ONLY_ENTRIES_OLDER_THAN_LAST_UPGRADE

  Possibility to display only statement hints that were created before the last SAP HANA upgrade

  'X'             --> Only display statement hints older than the last SAP HANA upgrade
  ' '             --> No restriction related to age of statement hints

- LINE_LENGTH

  Maximum displayed line size

  50              --> Lines are wrapped after 50 characters
  -1              --> No line wrapping

- STATEMENT_STRING_LENGTH

  Maximum length of statement string to be displayed

  100             --> Only display the first 100 characters of the statement string
  -1              --> No restriction related to statement string length

[OUTPUT PARAMETERS]

- STATEMENT_STRING:   Statement string
- HINT_STRING:        Hint string (i.e. hints manually added by user)
- SYSTEM_HINT_STRING: System hint string (i.e. hints predelivered during upgrade)
- ENABLED:            Status of statement hint (TRUE -> enabled, FALSE -> disabled)
- ENABLE_TIME:        Last enable time
- USER_NAME:          Name of user who enabled statement hint last time

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|STATEMENT_STRING                                                                |STATEMENT_HASH                  |HINT_STRING                |SYSTEM_HINT_STRING|ENABLED|ENABLE_TIME        |USER_NAME|
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|                                                                                |db5b7ec374243c8f0da12a3fd619c4ef|NO_USE_HEX_PLAN            |                  |TRUE   |2020/08/27 14:22:43|MUELLER  |
|                                                                                |1d56271fb844c65884d6eb9fb0a78c9d|NO_USE_HEX_PLAN            |                  |TRUE   |2020/08/27 14:45:14|MUELLER  |
|                                                                                |51b8f52b240f68035de1cfcac0742e5a|ROUTE_TO(3)                |                  |TRUE   |2020/11/05 11:10:04|SAPSR3   |
|                                                                                |33541995767b819929d873d0fbd07bf8|ROUTE_TO(3)                |                  |TRUE   |2020/11/05 11:10:17|SAPSR3   |
|                                                                                |6083e48d0d5ea9ababf4be60b994a6cf|ROUTE_TO(3)                |                  |TRUE   |2020/11/05 11:10:27|SAPSR3   |
|                                                                                |379402e6ac1d798f2490657fecef7024|ROUTE_TO(3)                |                  |TRUE   |2020/11/05 11:12:17|SAPSR3   |
|                                                                                |dfef7773bb2313b9666d2126479b161a|ROUTE_TO(3)                |                  |TRUE   |2020/11/05 11:12:27|SAPSR3   |
|                                                                                |f6131eda091f3439b163df45359c6304|ROUTE_TO(3)                |                  |TRUE   |2020/11/05 11:12:37|SAPSR3   |
|                                                                                |2cafcd6301acc5cf9e5c80de57553052|USE_HEX_PLAN, HEX_HASH_JOIN|                  |TRUE   |2020/08/18 09:28:03|SAPSR3   |
|                                                                                |69ead0a8160b14553ff4fdde1f75dd55|NO_USE_HEX_PLAN            |                  |TRUE   |2020/08/18 14:42:21|MAIER    |
|                                                                                |583c18d91c56bea6a9748c74be970d32|NO_USE_HEX_PLAN            |                  |TRUE   |2020/08/19 15:33:56|MAIER    |
|SELECT * FROM "EKPO" WHERE "MANDT" = X AND "EBELN" = X AND "UEBPO" = X  WITH RAN|cb016426b7cf25e4de1ed869aa52637f|USE_HEX_PLAN               |                  |TRUE   |2020/02/06 07:59:19|SAPSR3   |
|GE_RESTRICTION('CURRENT')                                                       |                                |                           |                  |       |                   |         |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  SUBSTR(SH.STATEMENT_STRING, 1 + ( O.LINE_NO - 1 ) * SH.LINE_LENGTH, SH.LINE_LENGTH) STATEMENT_STRING,
  MAP(SH.STATEMENT_STRING, '', SH.STATEMENT_HASH, MAP(ROW_NUMBER () OVER (PARTITION BY SH.STATEMENT_STRING ORDER BY O.LINE_NO), 1, SH.STATEMENT_HASH, '')) STATEMENT_HASH,
  MAP(SH.STATEMENT_STRING, '', SH.HINT_STRING, MAP(ROW_NUMBER () OVER (PARTITION BY SH.STATEMENT_STRING ORDER BY O.LINE_NO), 1, SH.HINT_STRING, ''))  HINT_STRING,
  MAP(SH.STATEMENT_STRING, '', SH.SYSTEM_HINT_STRING, MAP(ROW_NUMBER () OVER (PARTITION BY SH.STATEMENT_STRING ORDER BY O.LINE_NO), 1, SH.SYSTEM_HINT_STRING, ''))  SYSTEM_HINT_STRING,
  MAP(SH.STATEMENT_STRING, '', SH.IS_ENABLED, MAP(ROW_NUMBER () OVER (PARTITION BY SH.STATEMENT_STRING ORDER BY O.LINE_NO), 1, SH.IS_ENABLED, ''))  ENABLED,
  MAP(SH.STATEMENT_STRING, '', TO_VARCHAR(SH.LAST_ENABLE_TIME, 'YYYY/MM/DD HH24:MI:SS'), MAP(ROW_NUMBER () OVER (PARTITION BY SH.STATEMENT_STRING ORDER BY O.LINE_NO), 1, TO_VARCHAR(SH.LAST_ENABLE_TIME, 'YYYY/MM/DD HH24:MI:SS'), '')) ENABLE_TIME,
  MAP(SH.STATEMENT_STRING, '', SH.USER_NAME, MAP(ROW_NUMBER () OVER (PARTITION BY SH.STATEMENT_STRING ORDER BY O.LINE_NO), 1, SH.USER_NAME, '')) USER_NAME
FROM
( SELECT
    TO_VARCHAR(SUBSTR(SH.STATEMENT_STRING, 1, MAP(BI.STATEMENT_STRING_LENGTH, -1, 5000, BI.STATEMENT_STRING_LENGTH))) STATEMENT_STRING,
    IFNULL(SH.HINT_STRING, '') HINT_STRING,
    IFNULL(SH.SYSTEM_HINT_STRING, '') SYSTEM_HINT_STRING,
    IFNULL(SH.STATEMENT_HASH, '') STATEMENT_HASH,
    SH.IS_ENABLED,
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(SH.LAST_ENABLE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE SH.LAST_ENABLE_TIME END LAST_ENABLE_TIME,
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(DH.INSTALL_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE DH.INSTALL_TIME END INSTALL_TIME,
    SH.LAST_ENABLE_USER USER_NAME,
    BI.LINE_LENGTH
  FROM
  ( SELECT                 /* Modification section */
      'SERVER' TIMEZONE,                              /* SERVER, UTC */
      '%' STATEMENT_HASH,
      '%' STATEMENT_STRING,
      '%' HINT_STRING,
      '%' IS_ENABLED,
      '%' USER_NAME,
      ' ' EXCLUDE_PREDEFINED_ENTRIES,
      ' ' EXCLUDE_DELIVERED_ENTRIES,
      ' ' ONLY_ENTRIES_OLDER_THAN_LAST_UPGRADE,
      80 LINE_LENGTH,
      -1 STATEMENT_STRING_LENGTH
    FROM
      DUMMY
  ) BI,
  ( SELECT MAX(INSTALL_TIME) INSTALL_TIME FROM M_DATABASE_HISTORY ) DH,
  ( SELECT DISTINCT
      TO_VARCHAR(CASE WHEN SH.STATEMENT_STRING LIKE '' THEN C.STATEMENT_STRING ELSE SH.STATEMENT_STRING END) STATEMENT_STRING,
      SH.STATEMENT_HASH,
      SH.HINT_STRING,
      SH.SYSTEM_HINT_STRING,
      SH.IS_ENABLED,
      SH.LAST_ENABLE_TIME,
      SH.LAST_ENABLE_USER,
      SH.LAST_DISABLE_TIME,
      SH.LAST_DISABLE_USER
    FROM
      STATEMENT_HINTS SH LEFT OUTER JOIN
      M_SQL_PLAN_CACHE C ON
        C.STATEMENT_HASH = SH.STATEMENT_HASH
  ) SH
  WHERE
    IFNULL(SH.STATEMENT_HASH, '') LIKE BI.STATEMENT_HASH AND
    SH.STATEMENT_STRING LIKE BI.STATEMENT_STRING AND
    ( IFNULL(SH.HINT_STRING, '') LIKE BI.HINT_STRING OR IFNULL(SH.SYSTEM_HINT_STRING, '') LIKE BI.HINT_STRING ) AND
    SH.IS_ENABLED LIKE BI.IS_ENABLED AND
    SH.LAST_ENABLE_USER LIKE BI.USER_NAME AND
    ( BI.EXCLUDE_PREDEFINED_ENTRIES = ' ' OR SH.LAST_ENABLE_USER != 'SYS' ) AND
    ( BI.EXCLUDE_DELIVERED_ENTRIES = ' ' OR
      ( SH.STATEMENT_STRING NOT LIKE '%"EDIDS"%' AND
        SH.STATEMENT_STRING NOT LIKE '%"ODQDATA"%' AND
        SH.STATEMENT_STRING NOT LIKE '%"STXH"%' AND
        SH.STATEMENT_STRING NOT LIKE '%"STXL"%' AND
        SH.STATEMENT_STRING NOT LIKE '%"TBTCO"%' AND
        SH.STATEMENT_STRING NOT LIKE '%"TRFCQIN"%' AND
        SH.STATEMENT_STRING NOT LIKE '%"TRFCQOUT"%'
      ) OR
      ( REPLACE(REPLACE(SH.HINT_STRING, CHAR(32), ''), '"', '') NOT IN 
        ( 'IGNORE_PLAN_CACHE,OPTIMIZATION_LEVEL(RULE_BASED)', 
          'INDEX(ODQDATA(ODQDATA~0))', 
          'INDEX(ODQDATA(ODQDATA~0)),OPTIMIZATION_LEVEL(RULE_BASED)', 
          'INDEX(TRFCQOUT(TRFCQOUT~0))', 
          'INDEX(TBTCO(TBTCO~3))', 
          'INDEX(TRFCQIN(TRFCQIN~1))', 
          'INDEX(TRFCQIN(TRFCQIN~1)),OPTIMIZATION_LEVEL(RULE_BASED)', 
          'INDEX(TRFCQOUT(TRFCQOUT~0))', 
          'INDEX(TRFCQOUT(TRFCQOUT~3))', 
          'INDEX(TRFCQOUT(TRFCQOUT~4))', 
          'INDEX(TRFCQOUT(TRFCQOUT~6))', 
          'NO_CS_PRIMARY_KEY', 
          'OPTIMIZATION_LEVEL(RULE_BASED)', 
          'USE_HEX_PLAN',
          'USE_HEX_PLAN,HEX_HASH_JOIN'
        )
      )
    ) AND
    ( BI.ONLY_ENTRIES_OLDER_THAN_LAST_UPGRADE = ' ' OR SH.LAST_ENABLE_TIME < DH.INSTALL_TIME )
) SH,
( SELECT
    ROW_NUMBER () OVER () LINE_NO
  FROM
    OBJECTS
) O
WHERE
  O.LINE_NO <= GREATEST(1, CEILING(LENGTH(SH.STATEMENT_STRING) / LINE_LENGTH))
ORDER BY
  SH.STATEMENT_STRING,
  O.LINE_NO
