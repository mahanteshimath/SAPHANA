SELECT
/* 

[NAME]

HANA_Replication_SystemReplication_LogShipping_RetentionTime_1.00.110+

[DESCRIPTION]

- Continuous log shipping retention time calculation

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Operation mode “logreplay” configured and parameter logshipping_max_retention_size available and > 0 as of Rev. 110
- Minimum of RET_SIZE_HOURS and LOG_FULL_HOURS is the time the system can afford a disconnection of the secondary site 
  before losing the capability to resync via delta log shipping

[VALID FOR]

- Revisions:              >= 1.00.110

[SQL COMMAND VERSION]

- 2016/03/17:  1.0 (initial version)
- 2016/04/05:  1.1 (LOG_FULL_HOURS included)
- 2017/02/23:  1.2 (service and host specific retention times)

[INVOLVED TABLES]

- M_BACKUP_CATALOG
- M_BACKUP_CATALOG_FILES
- M_DISKS
- M_INIFILE_CONTENTS

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

- SERVICE_NAME

  Service name

  'indexserver'   --> Specific service indexserver
  '%server'       --> All services ending with 'server'
  '%'             --> All services  

[OUTPUT PARAMETERS]

- HOST:                       Host name
- PORT:                       Port
- SERVICE_NAME:               Service name
- RETENTION_SIZE_GB:          Configured log retention size (GB) (according to parmeter logshipping_max_retention_size)
- LOG_BACKUP_SIZE_PER_DAY_GB: Max. log backup size per day (per host and service), average of last week
- RET_SIZE_HOURS:             Maximum number of hours logs can be retained for continuous log shipping
- LOG_FULL_HOURS:             Maximum number of hours until a log full situation is reached when created redo logs can no longer be reused
- LOG_FULL_DEVICE_ID:         Database internal device ID responsible for first expected log full situation              

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------
|RETENTION_SIZE_GB|LOG_BACKUP_SIZE_PER_DAY_GB|RET_SIZE_HOURS|LOG_FULL_HOURS|LOG_FULL_DEVICE_ID|
-----------------------------------------------------------------------------------------------
|          1024.00|                    320.98|         76.56|         59.87|            551541|
-----------------------------------------------------------------------------------------------
   
*/

  B1.HOST,
  LPAD(P.PORT, 5) PORT,
  B1.SERVICE_NAME,
  LPAD(TO_DECIMAL(RETENTION_SIZE_GB, 10, 2), 17) RETENTION_SIZE_GB,
  LPAD(TO_DECIMAL(LOG_BACKUP_SIZE_PER_DAY_GB, 10, 2), 26) LOG_BACKUP_SIZE_PER_DAY_GB,
  LPAD(TO_DECIMAL(MAP(LOG_BACKUP_SIZE_PER_DAY_GB, 0, 0, RETENTION_SIZE_GB / LOG_BACKUP_SIZE_PER_DAY_GB * 24), 10, 2), 14) RET_SIZE_HOURS,
  LPAD(TO_DECIMAL(DAYS_UNTIL_DISK_FULL * 24, 10, 2), 14) LOG_FULL_HOURS,
  LPAD(DEVICE_ID, 18) LOG_FULL_DEVICE_ID
FROM
( SELECT                              /* Modification section */
    '%' HOST,
    '%' PORT,
    '%' SERVICE_NAME
  FROM
    DUMMY
) BI,
( SELECT DISTINCT
    S.PORT,
    S.SERVICE_NAME,
    IFNULL(SP.SYSTEM_VALUE, IFNULL(SP.HOST_VALUE, IFNULL(G.SYSTEM_VALUE, IFNULL(G.HOST_VALUE, G.DEFAULT_VALUE)))) / 1024 RETENTION_SIZE_GB
  FROM
  ( SELECT
      MAX(MAP(LAYER_NAME, 'DEFAULT', VALUE)) DEFAULT_VALUE,
      MAX(MAP(LAYER_NAME, 'HOST',    VALUE)) HOST_VALUE,
      MAX(MAP(LAYER_NAME, 'SYSTEM',  VALUE, 'DATABASE', VALUE)) SYSTEM_VALUE
    FROM
      M_INIFILE_CONTENTS 
    WHERE
      FILE_NAME = 'global.ini' AND
      SECTION = 'system_replication' AND
      KEY = 'logshipping_max_retention_size'
  ) G,
    M_SERVICES S LEFT OUTER JOIN
  ( SELECT
      MAX(SUBSTR(FILE_NAME, 1, LOCATE(FILE_NAME, '.ini') - 1)) SERVICE_NAME,
      MAX(MAP(LAYER_NAME, 'DEFAULT', VALUE)) DEFAULT_VALUE,
      MAX(MAP(LAYER_NAME, 'HOST',    VALUE)) HOST_VALUE,
      MAX(MAP(LAYER_NAME, 'SYSTEM',  VALUE, 'DATABASE', VALUE)) SYSTEM_VALUE
    FROM
      M_INIFILE_CONTENTS 
    WHERE
      FILE_NAME != 'global.ini' AND
      SECTION = 'system_replication' AND
      KEY = 'logshipping_max_retention_size'
  ) SP ON
    SP.SERVICE_NAME = S.SERVICE_NAME
) P,
( SELECT
    HOST,
    SERVICE_NAME,
    LOG_BACKUP_SIZE_PER_DAY_GB
  FROM
  ( SELECT
      BCF.HOST,
      BCF.SERVICE_TYPE_NAME SERVICE_NAME,
      SUM(BCF.BACKUP_SIZE) / 7 / 1024 / 1024 / 1024 LOG_BACKUP_SIZE_PER_DAY_GB
    FROM 
      M_BACKUP_CATALOG_FILES BCF,
      M_BACKUP_CATALOG BC
    WHERE 
      BC.BACKUP_ID = BCF.BACKUP_ID AND
      BC.ENTRY_TYPE_NAME = 'log backup' AND
      BC.STATE_NAME = 'successful' AND
      BC.SYS_START_TIME >= ADD_SECONDS(CURRENT_TIMESTAMP, -604800)
    GROUP BY
      BCF.HOST,
      BCF.SERVICE_TYPE_NAME
  )
) B1,
( SELECT
    HOST,
    SERVICE_NAME,
    DEVICE_ID,
    MAP(LOG_BACKUP_SIZE_PER_DAY_GB, 0, 9999, FREE_GB / LOG_BACKUP_SIZE_PER_DAY_GB) DAYS_UNTIL_DISK_FULL
  FROM
  ( SELECT
      D.HOST,
      BCF.SERVICE_TYPE_NAME SERVICE_NAME,
      D.DEVICE_ID,
      AVG(D.TOTAL_SIZE - D.USED_SIZE) / 1024 / 1024 / 1024 FREE_GB,
      SUM(BCF.BACKUP_SIZE) / 7 / 1024 / 1024 / 1024 LOG_BACKUP_SIZE_PER_DAY_GB
    FROM
      M_DISKS D,
      M_BACKUP_CATALOG_FILES BCF,
      M_BACKUP_CATALOG BC
    WHERE
      D.HOST = BCF.HOST AND
      BC.BACKUP_ID = BCF.BACKUP_ID AND
      BC.ENTRY_TYPE_NAME = 'log backup' AND
      BC.STATE_NAME = 'successful' AND
      BC.SYS_START_TIME >= ADD_SECONDS(CURRENT_TIMESTAMP, -604800) AND
      D.USAGE_TYPE = 'LOG'
    GROUP BY
      D.HOST,
      BCF.SERVICE_TYPE_NAME,
      D.DEVICE_ID
  )
) B2
WHERE
  B1.HOST LIKE BI.HOST AND
  TO_CHAR(P.PORT) LIKE BI.PORT AND
  P.SERVICE_NAME LIKE BI.SERVICE_NAME AND
  P.SERVICE_NAME = B1.SERVICE_NAME AND
  B1.HOST = B2.HOST AND
  B1.SERVICE_NAME = B2.SERVICE_NAME
ORDER BY
  B1.HOST,
  B1.SERVICE_NAME
  
