SELECT

/* 

[NAME]

- HANA_Disks_Data_Partitions_2.00.040+

[DESCRIPTION]

- Data volume partition overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_DATA_VOLUME_PARTITION_STATISTICS available starting with SAP HANA 2.00.040

[VALID FOR]

- Revisions:              >= 2.00.040

[SQL COMMAND VERSION]

- 2020/07/17:  1.0 (initial version)

[INVOLVED TABLES]

- M_DATA_VOLUME_PARTITION_STATISTICS

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

- PARTITION_ID

  Data volume partition ID

  2               --> Data volume partition ID 2
  -1              --> No restriction related to data volume partition ID

- FILE_NAME

  Data file name

  '%sapdata2%'    --> Files with names containing 'sapdata2'
  '%'             --> No file name restriction

- STATE

  Data volume partition state

  'INACTIVE'      --> Display partitions with state INACTIVE
  '%'             --> No restriction related to partition state    
  
[OUTPUT PARAMETERS]

- HOST:        Host name
- PORT:        Port
- PART_ID:     Partition ID
- FILE_NAME:   File name
- STATE:       Data volume partition state
- USED_GB:     Used space in file (GB)
- ALLOC_GB:    Allocated space in file (GB)
- FILE_GB:     Current file size (GB)
- MAX_FILE_GB: File size limit (GB)

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------------------
|HOST     |PORT |PART_ID|FILE_NAME                                                     |STATE |USED_GB |ALLOC_GB|FILE_GB |MAX_FILE_GB|
--------------------------------------------------------------------------------------------------------------------------------------
|saphana01|30103|      0|/hdb/C11/sapdata1/mnt00001/hdb00002.00003/datavolume_0000*.dat|ACTIVE| 1675.71| 2195.31| 2196.85|    3000.00|
|saphana01|30103|      1|/hdb/C11/sapdata2/mnt00001/hdb00002.00003/datavolume_0001*.dat|ACTIVE| 1675.68| 2192.75| 2194.39|    3000.00|
|saphana01|30103|      2|/hdb/C11/sapdata3/mnt00001/hdb00002.00003/datavolume_0002*.dat|ACTIVE| 1675.02| 2195.37| 2195.45|    3000.00|
|saphana01|30103|      3|/hdb/C11/sapdata4/mnt00001/hdb00002.00003/datavolume_0003*.dat|ACTIVE| 1674.68| 2193.75| 2195.25|    3000.00|
|saphana01|30103|      4|/hdb/C11/sapdata5/mnt00001/hdb00002.00003/datavolume_0004*.dat|ACTIVE| 1675.63| 2193.12| 2193.14|    3000.00|
|saphana01|30107|      0|/hdb/C11/sapdata1/mnt00001/hdb00003.00003/datavolume_0000*.dat|ACTIVE|    0.08|    0.25|    0.25|    3000.00|
--------------------------------------------------------------------------------------------------------------------------------------

*/

  P.HOST,
  LPAD(P.PORT, 5) PORT,
  LPAD(P.PARTITION_ID, 7) PART_ID,
  P.FILE_NAME_PATTERN FILE_NAME,
  P.STATE,
  LPAD(TO_DECIMAL(P.USED_SIZE / 1024 / 1024 / 1024, 10, 2), 8) USED_GB,
  LPAD(TO_DECIMAL(P.TOTAL_SIZE / 1024 / 1024 / 1024, 10, 2), 8) ALLOC_GB,
  LPAD(TO_DECIMAL(P.FILE_SIZE / 1024 / 1024 / 1024, 10, 2), 8) FILE_GB,
  LPAD(TO_DECIMAL(P.MAX_FILE_SIZE / 1024 / 1024 / 1024, 10, 2), 11) MAX_FILE_GB
FROM
( SELECT                     /* Modification section */
    '%' HOST,
    '%' PORT,
    -1 PARTITION_ID,
    '%' FILE_NAME,
    '%' STATE
  FROM
    DUMMY
) BI,
  M_DATA_VOLUME_PARTITION_STATISTICS P
WHERE
  P.HOST LIKE BI.HOST AND
  TO_VARCHAR(P.PORT) LIKE BI.PORT AND
  ( BI.PARTITION_ID = -1 OR P.PARTITION_ID = BI.PARTITION_ID ) AND
  P.FILE_NAME_PATTERN LIKE BI.FILE_NAME AND
  P.STATE LIKE BI.STATE
ORDER BY
  P.HOST,
  P.PORT,
  P.PARTITION_ID