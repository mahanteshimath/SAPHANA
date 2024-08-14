SELECT
/* 

[NAME]

- HANA_Disks_Data_SuperblockStatistics

[DESCRIPTION]

- Disk superblock information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Can be used to monitor progress of RECLAIM DATAVOLUME

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2017/02/20:  1.0 (initial version)

[INVOLVED TABLES]

- M_DATA_VOLUME_SUPERBLOCK_STATISTICS

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

[OUTPUT PARAMETERS]

- HOST:          Host name
- PORT:          Port
- VOLUME_ID:     Volume ID
- SB_SIZE_MB:    Size of a superblock (MB)
- USED_SB_COUNT: Number of used superblocks
- TOT_SB_COUNT:  Total number of superblocks
- USED_GB:       Space occupied by used superblocks (GB)
- ALLOC_GB:      Space occupied by total superblocks (GB)
- FRAG_PCT:      Fragmentation (%)

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------
|HOST    |PORT |VOLUME_ID|SB_SIZE_MB|USED_SB_COUNT|TOT_SB_COUNT|USED_GB   |ALLOC_GB  |FRAG_PCT|
-----------------------------------------------------------------------------------------------
|saphana1|30003|        4|     64.00|       199040|      212000|     12440|     13250|    6.51|
|saphana1|30007|        3|     64.00|            5|           6|         0|         0|   20.00|
-----------------------------------------------------------------------------------------------

*/

  S.HOST,
  LPAD(S.PORT, 5) PORT,
  LPAD(S.VOLUME_ID, 9) VOLUME_ID,
  LPAD(TO_DECIMAL(S.SUPERBLOCK_SIZE / 1024 / 1024, 10, 2), 10) SB_SIZE_MB,
  LPAD(S.USED_SUPERBLOCK_COUNT, 13) USED_SB_COUNT,
  LPAD(S.SUPERBLOCK_COUNT, 12) TOT_SB_COUNT,
  LPAD(TO_DECIMAL(ROUND(S.SUPERBLOCK_SIZE * S.USED_SUPERBLOCK_COUNT / 1024 / 1024 / 1024), 10, 0), 10) USED_GB,
  LPAD(TO_DECIMAL(ROUND(S.SUPERBLOCK_SIZE * S.SUPERBLOCK_COUNT / 1024 / 1024 / 1024), 10, 0), 10) ALLOC_GB,
  LPAD(TO_DECIMAL(MAP(S.FILL_RATIO, 0, 0, TO_DECIMAL(100 / S.FILL_RATIO - 100, 10, 2)), 10, 2), 8) FRAG_PCT
FROM
( SELECT                   /* Modification section */
    '%' HOST,
    '%' PORT
  FROM
    DUMMY
) BI,
  M_DATA_VOLUME_SUPERBLOCK_STATISTICS S
WHERE
  S.HOST LIKE BI.HOST AND
  TO_CHAR(S.PORT) LIKE BI.PORT
ORDER BY
  S.HOST,
  S.PORT