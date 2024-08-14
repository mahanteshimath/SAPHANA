SELECT
/* 

[NAME]

- HANA_Security_Encryption_2.00.000+

[DESCRIPTION]

- SAP HANA encryption overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_ENCRYPTION_OVERVIEW available starting with 2.00.000

[VALID FOR]

- Revisions:              >= 2.00.000

[SQL COMMAND VERSION]

- 2018/04/09:  1.0 (initial version)

[INVOLVED TABLES]

- ENCRYPTION_OVERVIEW

[INPUT PARAMETERS]

- ENCRYPTION_SCOPE

  Encryption scope

  'PERSISTENCE' --> Data persistence
  'LOG'         --> Log volume
  'BACKUP'      --> Backup area
  '%'           --> No restriction related to encryption scope

[OUTPUT PARAMETERS]

- SCOPE:            Encryption scope
- ENCRYPTION:       Encryption state
- LAST_CHANGE_TIME: Modification time

[EXAMPLE OUTPUT]

--------------------------------------------
|SCOPE      |ENCRYPTION|LAST_CHANGE_TIME   |
--------------------------------------------
|BACKUP     |FALSE     |2018/01/31 11:20:15|
|LOG        |FALSE     |2018/01/31 11:20:13|
|PERSISTENCE|FALSE     |2018/01/31 11:20:11|
--------------------------------------------

*/

  E.SCOPE,
  E.IS_ENCRYPTION_ACTIVE ENCRYPTION,
  TO_VARCHAR(E.LAST_CHANGE_TIME, 'YYYY/MM/DD HH24:MI:SS') LAST_CHANGE_TIME
FROM
( SELECT                       /* Modification section */
    '%' ENCRYPTION_SCOPE
  FROM
    DUMMY
) BI,
  M_ENCRYPTION_OVERVIEW E
WHERE
  E.SCOPE LIKE BI.ENCRYPTION_SCOPE
ORDER BY
  E.SCOPE
