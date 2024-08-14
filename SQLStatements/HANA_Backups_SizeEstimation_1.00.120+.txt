SELECT
/* 

[NAME]

- HANA_Backups_SizeEstimation_1.00.120+

[DESCRIPTION]

- Data backup size estimation

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_BACKUP_SIZE_ESTIMATIONS available starting with SAP HANA 1.0 SPS 12

[VALID FOR]

- Revisions:              >= 1.00.120

[SQL COMMAND VERSION]

- 2020/06/02:  1.0 (initial version)

[INVOLVED TABLES]

- M_BACKUP_SIZE_ESTIMATIONS

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

  'indexserver'   --> Show information for indexserver
  '%'             --> No restriction to service names

- BACKUP_TYPE

  Type of backup

  'complete data backup' --> Normal data backup
  '%'                    --> No backup type restriction  
 
[OUTPUT PARAMETERS]

- HOST:         Host name
- PORT:         Port
- SERVICE_NAME: Service name
- BACKUP_TYPE:  Backup type
- SIZE_GB:      Estimated backup size (GB)

[EXAMPLE OUTPUT]

----------------------------------------------------------------
|HOST   |PORT |SERVICE_NAME|BACKUP_TYPE             |SIZE_GB   |
----------------------------------------------------------------
|saphana|30003|indexserver |complete data backup    |    262.80|
|saphana|30003|indexserver |differential data backup|      5.01|
|saphana|30003|indexserver |incremental data backup |      5.01|
|saphana|30004|scriptserver|complete data backup    |      0.06|
|saphana|30004|scriptserver|differential data backup|      0.01|
|saphana|30004|scriptserver|incremental data backup |      0.01|
|saphana|30007|xsengine    |complete data backup    |      0.06|
|saphana|30007|xsengine    |differential data backup|      0.01|
|saphana|30007|xsengine    |incremental data backup |      0.01|
|saphana|30011|dpserver    |complete data backup    |      0.06|
|saphana|30011|dpserver    |differential data backup|      0.01|
|saphana|30011|dpserver    |incremental data backup |      0.01|
----------------------------------------------------------------

*/

  B.HOST,
  LPAD(B.PORT, 5) PORT,
  B.SERVICE_NAME,
  B.ENTRY_TYPE_NAME BACKUP_TYPE,
  LPAD(TO_DECIMAL(B.ESTIMATED_SIZE / 1024 / 1024 / 1024, 10, 2), 10) SIZE_GB
FROM
( SELECT                 /* Modification section */
    '%' HOST,
    '%' PORT,
    '%' SERVICE_NAME,
    '%' BACKUP_TYPE                            /* e.g. 'complete data backup', 'incremental data backup', 'differential data backup', 'data snapshot' */
  FROM
    DUMMY
) BI,
  M_BACKUP_SIZE_ESTIMATIONS B 
WHERE
  B.HOST LIKE BI.HOST AND
  TO_VARCHAR(B.PORT) LIKE BI.PORT AND
  B.SERVICE_NAME LIKE BI.SERVICE_NAME AND
  B.ENTRY_TYPE_NAME LIKE BI.BACKUP_TYPE
ORDER BY
  B.HOST,
  B.PORT,
  B.ENTRY_TYPE_NAME
