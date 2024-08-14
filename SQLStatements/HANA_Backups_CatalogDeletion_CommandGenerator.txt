SELECT
/* 

[NAME]

- HANA_Backups_CatalogDeletion_CommandGenerator

[DESCRIPTION]

- Generation of a command for backup catalog cleanup

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/07/30  1.0 (initial version)

[INVOLVED TABLES]

- M_BACKUP_CATALOG

[INPUT PARAMETERS]

- MIN_RETAINED_BACKUPS

  Minimum number of retained backups (i.e. backup catalog entries are only deleted if they are older than
  the defined number of most recent data backups)

  5               --> Only delete backup catalog entries older than the 5 most recent data backups
  -1              --> No restriction related to existing data backups

- MIN_RETENTION_DAYS

  Minimum threshold of retention days (i.e. backup catalog entries are only deleted if they are older than
  the defined number of retention days)

  42              --> Only delete backup catalog entries if they are older than 42 days
  -1              --> No restriction related to retention days 

- COMMAND_OPTIONS

  Command options for deletion command

  'WITH BACKINT'  --> Removes backups from catalog and from BACKINT backup tool
  'WITH FILE'     --> Removes file-based backups from catalog and original location
  'COMPLETE'      --> Removes backups from catalog and file system / BACKINT
  ''              --> No additional command option

[OUTPUT PARAMETERS]
 
- MIN_RETAINED_BACKUPS: Defined minimum number of retained backups
- MIN_RETENTION_DAYS:   Defined minimum retention days
- BACKUP_ID:            ID of backup used for catalog deletion
- BACKUP_TIME:          Timestamp of backup used for catalog deletion
- COMMAND:              Catalog deletion command

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------------------
|MIN_RETAINED_BACKUPS|MIN_RETENTION_DAYS|BACKUP_ID      |BACKUP_TIME        |COMMAND                                                 |
--------------------------------------------------------------------------------------------------------------------------------------
|                   5|                42|  1434135602464|2015/06/12 21:00:02|BACKUP CATALOG DELETE ALL BEFORE BACKUP_ID 1434135602464|
--------------------------------------------------------------------------------------------------------------------------------------

*/

  MAP(BI.MIN_RETAINED_BACKUPS, -1, 'no restriction', LPAD(TO_VARCHAR(BI.MIN_RETAINED_BACKUPS), 20)) MIN_RETAINED_BACKUPS,
  MAP(BI.MIN_RETENTION_DAYS, -1, 'no restriction', LPAD(TO_VARCHAR(BI.MIN_RETENTION_DAYS), 18)) MIN_RETENTION_DAYS,
  LPAD(MAX(B.BACKUP_ID), 15) BACKUP_ID,
  TO_VARCHAR(MAX(B.SYS_START_TIME), 'YYYY/MM/DD HH24:MI:SS') BACKUP_TIME,
  'BACKUP CATALOG DELETE ALL BEFORE BACKUP_ID' || CHAR(32) || MAX(B.BACKUP_ID) || CHAR(32) || BI.COMMAND_OPTIONS COMMAND
FROM
( SELECT                  /* Modification section */
    5 MIN_RETAINED_BACKUPS,
    42 MIN_RETENTION_DAYS,
    '' COMMAND_OPTIONS             /* empty string, 'WITH FILE', 'WITH BACKINT' OR 'COMPLETE' */
  FROM
    DUMMY
) BI,
( SELECT
    BACKUP_ID,
    SYS_START_TIME,
    ROW_NUMBER() OVER (ORDER BY BACKUP_ID DESC) ROW_NUM
  FROM
    M_BACKUP_CATALOG
  WHERE
    STATE_NAME = 'successful' AND
    ENTRY_TYPE_NAME IN ( 'complete data backup', 'data snapshot')
) B
WHERE
  ( BI.MIN_RETAINED_BACKUPS = -1 OR B.ROW_NUM > BI.MIN_RETAINED_BACKUPS ) AND
  DAYS_BETWEEN(B.SYS_START_TIME, CURRENT_TIMESTAMP) > BI.MIN_RETENTION_DAYS
GROUP BY
  BI.MIN_RETAINED_BACKUPS,
  BI.MIN_RETENTION_DAYS,
  BI.COMMAND_OPTIONS
