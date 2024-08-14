SELECT

/* 

[NAME]

- HANA_ABAP_BWBookmarks

[DESCRIPTION]

- Overview of BW bookmarks per user

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Table RSWR_BOOKMARK only available in SAP ABAP environments
- You have to be connected to the SAP<sid> schema otherwise the following error is issued:

  [259]: invalid table name: Could not find table/view RSWR_BOOKMARK in schema

- If access to ABAP objects is possible but you cannot log on as ABAP user, you can switch the default schema before executing the command:

  SET SCHEMA SAP<sid>

[VALID FOR]

- Revisions:              all
- Client application:     ABAP, BW

[SQL COMMAND VERSION]

- 2020/09/14:  1.0 (initial version)

[INVOLVED TABLES]

- RSWR_BOOKMARK
- USR02

[INPUT PARAMETERS]

- USER_NAME

  ABAP user name owning bookmark

  'MEYER'         --> ABAP user MEYER
  '%'             --> No restriction related to ABAP user

- ONLY_OUTDATED_USERS

  Possibility to restrict the output to users that are out of validity date

  'X'             --> Only consider users being out of validity date (e.g. because they left the company)
  ' '             --> No restriction related to user
  
[OUTPUT PARAMETERS]

- USER_NAME: User owning the bookmarks
- OUTDATED:  'X' if user is out of validity date, otherwise ' '
- SIZE_MB:   Total bookmark size (MB)
- CNT:       Number of RSWR_BOOKMARK entries

[EXAMPLE OUTPUT]

--------------------------------------
|USER_NAME   |OUTDATED|SIZE_MB |CNT  |
--------------------------------------
|ATAKAHASHI4 |        | 3348.88| 1379|
|BLEE41      |        | 2921.80| 1548|
|CCHONG6     |       X| 2906.04| 1275|
|DLOPANDIA1  |        | 2848.53| 1160|
|EENOKI      |        | 2793.61| 1385|
--------------------------------------

*/

  R.OWNER USER_NAME,
  LPAD(MAP(U.BNAME, NULL, 'X', ' '), 8) OUTDATED,
  LPAD(TO_DECIMAL(SUM(LENGTH(R.XDATA)) / 1024 / 1024, 10, 2), 8) SIZE_MB,
  LPAD(COUNT(*), 5) CNT
FROM
( SELECT                      /* Modification section */
    '%' USER_NAME,
    'X' ONLY_OUTDATED_USERS
  FROM
    DUMMY
) BI,
  RSWR_DATA R LEFT OUTER JOIN
  ( SELECT DISTINCT BNAME FROM USR02 U WHERE U.GLTGB = '00000000' OR U.GLTGB >= TO_VARCHAR(CURRENT_TIMESTAMP, 'YYYYMMDD') ) U ON
    R.OWNER = U.BNAME
WHERE
  R.OWNER LIKE BI.USER_NAME AND
  ( BI.ONLY_OUTDATED_USERS = ' ' OR U.BNAME IS NULL )
GROUP BY
  R.OWNER,
  U.BNAME
ORDER BY
  SUM(LENGTH(R.XDATA)) DESC