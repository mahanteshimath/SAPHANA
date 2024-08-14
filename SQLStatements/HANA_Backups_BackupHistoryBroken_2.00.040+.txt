SELECT

/* 

[NAME]

- HANA_Backups_BackupHistoryBroken_2.00.040+

[DESCRIPTION]

- Overview of times of broken backup history

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_BACKUP_HISTORY_BROKEN available with SAP HANA >= 2.00.040

[VALID FOR]

- Revisions:              >= 2.00.040

[SQL COMMAND VERSION]

- 2019/12/30:  1.0 (initial version)

[INVOLVED TABLES]

- M_BACKUP_HISTORY_BROKEN

[INPUT PARAMETERS]

- TIMEZONE

  Used timezone (both for input and output parameters)

  'SERVER'       --> Display times in SAP HANA server time
  'UTC'          --> Display times in UTC time

- HOST

  Host name

  'saphana01'     --> Specific host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- SERVICE_NAME

  Service name

  'indexserver'   --> Show information for indexserver
  '%'             --> No restriction to service names

- BACKUP_ID

  Backup ID

  1577704152810   --> Backup ID 1577704152810
  -1              --> No restriction to backup ID

- REASON

  Reason for broken backup history

  '%overwrite%'   --> Only show reasons containing 'overwrite'
  '%'             --> No restriction related to reason

- MESSAGE

  Message for broken backup history

  '%overwrite%'   --> Only show messages containing 'overwrite'
  '%'             --> No restriction related to message
 
[OUTPUT PARAMETERS]

- BROKEN_TIME:  Time when backup history was broken
- HOST:         Host
- SERVICE_NAME: Service name
- BACKUP_ID:    Backup ID
- REASON:       Reason for broken backup history
- MESSAGE:      Message for broken backup history

[EXAMPLE OUTPUT]


*/

  MAP(BI.TIMEZONE, 'UTC', BB.UTC_TIME, BB.SYS_TIME) BROKEN_TIME,
  BB.HOST,
  BB.SERVICE_TYPE_NAME SERVICE_NAME,
  BB.BACKUP_ID,
  BB.REASON,
  BB.MESSAGE
FROM
( SELECT                    /* Modification section */
    'SERVER' TIMEZONE,                   /* SERVER, UTC */
    '%' HOST,
    '%' SERVICE_NAME,
    -1 BACKUP_ID,
    '%' REASON,
    '%' MESSAGE
  FROM
    DUMMY
) BI,
  M_BACKUP_HISTORY_BROKEN BB
WHERE
  BB.HOST LIKE BI.HOST AND
  BB.SERVICE_TYPE_NAME LIKE BI.SERVICE_NAME AND
  ( BI.BACKUP_ID = -1 OR BB.BACKUP_ID = BI.BACKUP_ID ) AND
  IFNULL(BB.REASON, '') LIKE BI.REASON AND
  IFNULL(BB.MESSAGE, '') LIKE BI.MESSAGE
ORDER BY
  BB.SYS_TIME DESC,
  BB.HOST,
  BB.SERVICE_TYPE_NAME