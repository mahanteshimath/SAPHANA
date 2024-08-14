SELECT
/* 

[NAME]

- HANA_Backups_BackupProgress_1.00.100+

[DESCRIPTION]

- Information about current backup progress

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              >= 1.00.100

[SQL COMMAND VERSION]

- 2020/11/12:  1.0 (initial version)

[INVOLVED TABLES]

- M_BACKUP_PROGRESS

[INPUT PARAMETERS]

- HOST

  Host name

  'saphana01'     --> Specific host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- PORT

  Port number

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- BACKUP_TYPE

  Type of backup

  'log backup'           --> Log backup   
  'complete data backup' --> Normal data backup
  'DATA_BACKUP'          --> All types of data backup ( 'complete data backup', 'data snapshot' )
  '%'                    --> No backup type restriction

- BACKUP_STATE

  Backup state

  'cancel pending' --> Display backups in state 'cancel pending'
  '%'              --> No restriction to backup state

[OUTPUT PARAMETERS]

- HOST:         Host name
- PORT:         Port
- BACKUP_TYPE:  Backup type
- BACKUP_STATE: Backup state
- START_TIME:   Backup start time (empty if currently running)
- END_TIME:     Backup end time (empty if currently running)
- TOTAL_GB:     Total backup size (GB)
- PROGRESS_GB:  Backup progress (GB)
- PROGRESS_PCT: Backup progress (%)

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------
|HOST     |PORT |BACKUP_TYPE             |BACKUP_STATE|START_TIME         |END_TIME           |TOTAL_GB|PROGRESS_GB|PROGRESS_PCT|
---------------------------------------------------------------------------------------------------------------------------------
|saphana01|36440|differential data backup|successful  |2020/11/12 03:03:22|2020/11/12 03:15:43|  299.35|     299.35|      100.00|
|saphana01|36446|differential data backup|successful  |2020/11/12 03:03:22|2020/11/12 03:03:54|    0.03|       0.03|      100.00|
---------------------------------------------------------------------------------------------------------------------------------

*/

  B.HOST,
  LPAD(B.PORT, 5) PORT,
  B.ENTRY_TYPE_NAME BACKUP_TYPE,
  B.STATE_NAME BACKUP_STATE,
  IFNULL(TO_VARCHAR(B.SYS_START_TIME, 'YYYY/MM/DD HH24:MI:SS'), '') START_TIME,
  IFNULL(TO_VARCHAR(B.SYS_END_TIME, 'YYYY/MM/DD HH24:MI:SS'), '') END_TIME,
  LPAD(TO_DECIMAL(B.BACKUP_SIZE / 1024 / 1024 / 1024, 10, 2), 8) TOTAL_GB,
  LPAD(TO_DECIMAL(B.TRANSFERRED_SIZE / 1024 / 1024 / 1024, 10, 2), 11) PROGRESS_GB,
  LPAD(TO_DECIMAL(MAP(B.BACKUP_SIZE, 0, 0, B.TRANSFERRED_SIZE / B.BACKUP_SIZE * 100), 10, 2), 12) PROGRESS_PCT
FROM
( SELECT                                                                  /* Modification section */
    '%' HOST,
    '%' PORT,
    '%' BACKUP_TYPE,
    '%' BACKUP_STATE
  FROM
    DUMMY
) BI,
  M_BACKUP_PROGRESS B
WHERE
  B.HOST LIKE BI.HOST AND
  TO_VARCHAR(B.PORT) LIKE BI.PORT AND
  B.ENTRY_TYPE_NAME LIKE BI.BACKUP_TYPE AND
  B.STATE_NAME LIKE BI.BACKUP_STATE
ORDER BY
  B.HOST,
  B.PORT 
