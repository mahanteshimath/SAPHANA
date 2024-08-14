SELECT
/* 

[NAME]

- HANA_Backups_LogBackupDelays

[DESCRIPTION]

- Information related to log backup delays

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/10/28:  1.0 (initial version)
- 2017/10/24:  1.1 (TIMEZONE included)

[INVOLVED TABLES]

- M_BACKUP_CATALOG
- M_BACKUP_CATALOG_FILES
- M_LOG_SEGMENTS

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

- PORT

  Port number

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- SERVICE_NAME

  Service name

  'indexserver'   --> Specific service indexserver
  '%server'       --> All services ending with 'server'
  '%'             --> All services  

[OUTPUT PARAMETERS]

- HOST:                Host name
- PORT:                Port
- LOG_POS_SEGMENT:     Log position (current)
- LOG_POS_BACKUP:      Log position (already backed up)
- NOT_BACKED_UP:       Number of logs not backed up
- BACKUP_START_TIME:   Start time of last log backup
- TIME_SINCE_BACKUP_H: Time since last log backup (h)

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------
|HOST     |PORT | LOG_POS_SEGMENT|  LOG_POS_BACKUP|NOT_BACKED_UP|BACKUP_START_TIME  |TIME_SINCE_BACKUP_H|
---------------------------------------------------------------------------------------------------------
|saphana01|30003|469.236.674.880 |458.497.800.064 |         1282|2015/10/28 09:59:34|               1.66|
|saphana02|30003|397.215.625.664 |397.081.500.096 |           17|2015/10/28 11:19:59|               0.32|
|saphana03|30003|344.240.726.976 |344.203.047.936 |            6|2015/10/28 11:20:04|               0.32|
|saphana01|30007|    139.647.680 |    139.621.504 |            3|2015/10/28 11:19:59|               0.32|
|saphana04|30003|364.905.867.392 |364.902.617.536 |            2|2015/10/28 11:26:58|               0.20|
---------------------------------------------------------------------------------------------------------

*/

  L.HOST,
  LPAD(L.PORT, 5) PORT,
  S.SERVICE_NAME SERVICE,
  MAX(L.MIN_POSITION) LOG_POS_SEGMENT,
  MAX(B.FIRST_REDO_LOG_POSITION) LOG_POS_BACKUP,
  LPAD(COUNT(*), 13) NOT_BACKED_UP,
  TO_VARCHAR(MAX(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(BACKUP_START_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE BACKUP_START_TIME END), 'YYYY/MM/DD HH24:MI:SS') BACKUP_START_TIME,
  LPAD(TO_DECIMAL(SECONDS_BETWEEN(MAX(BACKUP_START_TIME), CURRENT_TIMESTAMP) / 3600, 10, 2), 19) TIME_SINCE_BACKUP_H
FROM
( SELECT              /* Modification section */
    'SERVER' TIMEZONE,                              /* SERVER, UTC */
    '%' HOST,
    '%' PORT,
    '%' SERVICE_NAME
  FROM
    DUMMY
) BI,
  M_LOG_SEGMENTS L,
  M_SERVICES S,
  ( SELECT
      BF.HOST,
      BF.SERVICE_TYPE_NAME,
      MAX(BF.FIRST_REDO_LOG_POSITION) FIRST_REDO_LOG_POSITION,
      MAX(B.SYS_START_TIME) BACKUP_START_TIME
    FROM
      M_BACKUP_CATALOG B,
      M_BACKUP_CATALOG_FILES BF
    WHERE
      B.BACKUP_ID = BF.BACKUP_ID AND
      B.MESSAGE = '<ok>' AND
      BF.SOURCE_TYPE_NAME = 'volume' AND
      BF.FIRST_REDO_LOG_POSITION > 0
    GROUP BY
      BF.HOST,
      BF.SERVICE_TYPE_NAME
  ) B
WHERE
  L.HOST LIKE BI.HOST AND
  L.PORT LIKE BI.PORT AND
  S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
  L.HOST = S.HOST AND
  L.PORT = S.PORT AND
  S.HOST = B.HOST AND
  S.SERVICE_NAME = B.SERVICE_TYPE_NAME AND
  L.MIN_POSITION >= B.FIRST_REDO_LOG_POSITION
GROUP BY
  L.HOST,
  L.PORT,
  S.SERVICE_NAME
ORDER BY
  NOT_BACKED_UP DESC,
  L.HOST,
  L.PORT