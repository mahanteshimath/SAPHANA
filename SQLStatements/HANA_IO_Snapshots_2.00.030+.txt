SELECT
/* 

[NAME]

- HANA_IO_Snapshots_2.00.030+

[DESCRIPTION]

- Snapshot information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Can be used for monitoring remote system replication sites, see SAP Note 1999880 
  ("Is it possible to monitor remote system replication sites on the primary system") for details.
- M_SNAPSHOTS.PURPOSE available with SAP HANA >= 2.00.030

[VALID FOR]

- Revisions:              >= 2.00.030

[SQL COMMAND VERSION]

- 2014/07/10:  1.0 (initial version)
- 2017/10/25:  1.1 (TIMEZONE included)
- 2019/03/16:  1.2 (dedicated 2.00.030+ version)

[INVOLVED TABLES]

- M_SNAPSHOTS

[INPUT PARAMETERS]

- TIMEZONE

  Used timezone (both for input and output parameters)

  'SERVER'       --> Display times in SAP HANA server time
  'UTC'          --> Display times in UTC time

- HOST

  Host name

  'saphana01'     --> Specic host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- PORT

  Port number

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- PURPOSE

  Snapshot purpose

  'SNAPSHOT_FOR_REPLICATION' --> Snapshot created in context of system replication
  'SNAPSHOT'                 --> Snapshot created for other purposes
  '%'                        --> No restriction related to snapshot purpose

- FOR_BACKUP

  Indicator for snapshots in backup contexts

  'TRUE'                     --> Display snapshots used in context of backups
  'FALSE'                    --> Display snapshots used in other contexts than backups
  '%'                        --> Display all snapshots regardless of the backup context

- MIN_SNAPSHOT_AGE_H

  Minimum age of snapshot in hours

  5               --> Only display database snapshots older than 5 hours
  -1              --> No restriction related to database snapshot age

[OUTPUT PARAMETERS]

- HOST:           Host name
- PORT:           Port
- VOLUME_ID:      Disk volume identifier
- SNAPSHOT_TIME:  Time of snapshot
- SNAPSHOT_AGE_H: Age of snapshot (h)
- PURPOSE:        Snapshot purpose
- FOR_BACKUP:     TRUE if snapshot is preserved / used for backup, otherwise FALSE

[EXAMPLE OUTPUT]

----------------------------------------------------------
|HOST     |PORT |VOLUME_ID|SNAPSHOT_TIME      |FOR_BACKUP|
----------------------------------------------------------
|hlahana21|30105|        2|2014/07/10 12:11:08|FALSE     |
|hlahana21|30107|        4|2014/07/10 12:10:28|FALSE     |
|hlahana21|30103|        3|2014/07/10 11:44:09|FALSE     |
|hlahana21|30103|        3|2014/07/10 11:02:47|FALSE     |
|hlahana21|30107|        4|2014/07/03 21:06:28|TRUE      |
|hlahana21|30105|        2|2014/07/03 21:06:28|TRUE      |
----------------------------------------------------------

*/

  SN.HOST,
  LPAD(SN.PORT, 5) PORT,
  LPAD(SN.VOLUME_ID, 9) VOLUME_ID,
  TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(SN.TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE SN.TIMESTAMP END, 'YYYY/MM/DD HH24:MI:SS') SNAPSHOT_TIME,
  LPAD(TO_DECIMAL(SECONDS_BETWEEN(SN.TIMESTAMP, CURRENT_TIMESTAMP) / 3600, 10, 2), 14) SNAPSHOT_AGE_H,
  SN.PURPOSE,
  SN.FOR_BACKUP
FROM
( SELECT                        /* Modification section */
    'SERVER' TIMEZONE,                              /* SERVER, UTC */
    '%' HOST,
    '%' PORT,
    '%' PURPOSE,
    '%' FOR_BACKUP,
    5 MIN_SNAPSHOT_AGE_H
  FROM
    DUMMY
) BI,
  M_SNAPSHOTS SN
WHERE
  SN.HOST LIKE BI.HOST AND
  TO_VARCHAR(SN.PORT) LIKE BI.PORT AND
  SN.PURPOSE LIKE BI.PURPOSE AND
  SN.FOR_BACKUP LIKE BI.FOR_BACKUP AND
  ( BI.MIN_SNAPSHOT_AGE_H = -1 OR SECONDS_BETWEEN(SN.TIMESTAMP, CURRENT_TIMESTAMP) / 3600 >= BI.MIN_SNAPSHOT_AGE_H )
ORDER BY
  SN.TIMESTAMP DESC
