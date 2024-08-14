SELECT
/* 

[NAME]

- HANA_Backups_CatalogSize

[DESCRIPTION]

- Backup catalog size

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Backup catalog size may be displayed with 0 on certain SAP HANA Revisions (SAP Note 2795010)
- Backup catalog size may be 8 byte (Bug 217912 - Catalog backup size in M_BACKUP_CATALOG_FILES is always 8, though in fact larger)

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/07/18:  1.0 (initial version)
- 2017/10/24:  1.1 (TIMEZONE included)

[INVOLVED TABLES]

- M_BACKUP_CATALOG
- M_BACKUP_CATALOG_FILES

[INPUT PARAMETERS]

- TIMEZONE

  Used timezone (both for input and output parameters)

  'SERVER'       --> Display times in SAP HANA server time
  'UTC'          --> Display times in UTC time

[OUTPUT PARAMETERS]

- EVALUATION_TIME:    Evaluation time
- CATALOG_SIZE_MB:    Backup catalog size (MB)  
- OLDEST_BACKUP_DATE: Creation date of oldest backup still contained in catalog
- OLDEST_BACKUP_DAYS: Age of oldest backup still contained in catalog (days)

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------
|EVALUATION_TIME    |CATALOG_SIZE_MB|OLDEST_BACKUP_DATE |OLDEST_BACKUP_DAYS|
----------------------------------------------------------------------------
|2014/07/18 15:47:25|          45.68|2013/12/16 19:13:35|               214|
----------------------------------------------------------------------------

*/

  TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN CURRENT_UTCTIMESTAMP ELSE CURRENT_TIMESTAMP END, 'YYYY/MM/DD HH24:MI:SS') EVALUATION_TIME,
  LPAD(TO_DECIMAL(C.CATALOG_SIZE_MB, 10, 2), 15) CATALOG_SIZE_MB,
  TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(B.OLDEST_BACKUP_DATE, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE B.OLDEST_BACKUP_DATE END, 'YYYY/MM/DD HH24:MI:SS') OLDEST_BACKUP_DATE,
  LPAD(B.OLDEST_BACKUP_DAYS, 18) OLDEST_BACKUP_DAYS
FROM
( SELECT                /* Modification section */
    'SERVER' TIMEZONE                              /* SERVER, UTC */
  FROM
    DUMMY
) BI,
( SELECT TOP 1
    BF.BACKUP_SIZE / 1024 / 1024 CATALOG_SIZE_MB
  FROM
    M_BACKUP_CATALOG B,
    M_BACKUP_CATALOG_FILES BF
  WHERE
    B.BACKUP_ID = BF.BACKUP_ID AND
    BF.SOURCE_TYPE_NAME = 'catalog' AND
    B.STATE_NAME = 'successful'
  ORDER BY
    B.SYS_START_TIME DESC
) C,
( SELECT
    MIN(SYS_START_TIME) OLDEST_BACKUP_DATE,
    DAYS_BETWEEN(MIN(SYS_START_TIME), CURRENT_TIMESTAMP) OLDEST_BACKUP_DAYS
  FROM
    M_BACKUP_CATALOG
) B
