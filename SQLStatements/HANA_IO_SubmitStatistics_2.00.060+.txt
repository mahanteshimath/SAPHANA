SELECT

/* 

[NAME]

- HANA_IO_SubmitStatistics_2.00.060+

[DESCRIPTION]

- I/O submit statistics (direct, submit queue, throttle queue)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- I/O throttling avaialable starting with 2.00.060

[VALID FOR]

- Revisions:              >= 2.00.060

[SQL COMMAND VERSION]

- 2022/12/18:  1.0 (initial version)

[INVOLVED TABLES]

- M_VOLUME_IO_SUBMIT_STATISTICS
- M_VOLUME_IO_SUBMIT_STATISTICS_RESET

[INPUT PARAMETERS]

- HOST

  Host name

  'saphana01'    --> Specific host saphana01
  'saphana%'     --> All hosts starting with saphana
  '%'            --> All hosts

- PORT

  Port number

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- IO_TYPE

  I/O type (e.g. DATA, LOG)

  'DATA'          --> Disk areas related to data files
  'LOG'           --> Disk areas related to log files
  '%'             --> All disk areas

- PATH

  Path on disk

  '/hdb/ERP/backup/log/' --> Path /hdb/HAL/backup/log/
  '%backup%'             --> Paths containing 'backup'
  '%'                    --> No restriction of path

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'RESET'         --> Data from reset information (*_RESET tables)

[OUTPUT PARAMETERS]

- HOST:          Host name
- PORT:          Port
- IO_TYPE:       Type of disk area (e.g. DATA, LOG)
- TP_LIM_MBPS:   Overall throughput limit (MB/s)
- TP_R_LIM_MBPS: Read throughput limit (MB/s)
- TP_W_LIM_MBPS: Write throughput limit (MB/s)
- DIR_R_GB:      Direct submit read size (GB)
- DIR_W_GB:      Direct submit write size (GB)
- DIS_R_GB:      Dispatch queue submit read size (GB)
- DIS_W_GB:      Dispatch queue submit write size (GB)
- THR_R_GB:      Throttle queue submit read size (GB)
- THR_W_GB:      Throttle queue submit write size (GB)
- THR_R_BL_MB:   Throttling read dispatch backlog (MB)
- THR_W_BL_MB:   Throttling write dispatch backlog (MB) 

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST       |   PORT|IO_TYPE       |TP_LIM_MBPS|TP_R_LIM_MBPS|TP_W_LIM_MBPS|DIR_R_GB|DIR_W_GB|DIS_R_GB|DIS_W_GB|THR_R_GB|THR_W_GB|THR_R_BL_MB|THR_W_BL_MB|PATH                                   |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|saphananode|30.040 |*             |          0|            0|            0|    0.00|    0.00|    7.29|    6.12|    0.00|    6.37|       0.00|     380.62|*                                      |
|saphananode|30.040 |CATALOG_BACKUP|          0|            0|            0|    0.00|    0.00|    0.00|    0.00|    0.00|    0.00|       0.00|       0.00|/backup/HA2/fullbackup/catalog/DB_HA1/ |
|saphananode|30.040 |CATALOG_BACKUP|          0|            0|            0|    0.00|    0.00|    0.00|    0.00|    0.00|    0.00|       0.00|       0.00|*                                      |
|saphananode|30.040 |DATA          |          0|            0|          500|    0.00|    0.00|    1.82|    0.00|    0.00|    6.37|       0.00|     380.62|*                                      |
|saphananode|30.040 |DATA          |          0|            0|            0|    0.00|    0.00|    1.82|    0.00|    0.00|    6.37|       0.00|     380.62|/hana/data/HA2/mnt00001/hdb00002.00004/|
|saphananode|30.040 |DATA_BACKUP   |          0|            0|            0|    0.00|    0.00|    0.00|    0.00|    0.00|    0.00|       0.00|       0.00|*                                      |
|saphananode|30.040 |DATA_BACKUP   |          0|            0|            0|    0.00|    0.00|    0.00|    0.00|    0.00|    0.00|       0.00|       0.00|/backup/HA2/data/DB_HA1/               |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


*/

  IO.HOST,
  LPAD(IO.PORT, 5) PORT,
  IO.IO_TYPE,
  LPAD(IO.THROUGHPUT_LIMIT, 11) TP_LIM_MBPS,
  LPAD(IO.THROUGHPUT_READ_LIMIT, 13) TP_R_LIM_MBPS,
  LPAD(IO.THROUGHPUT_WRITE_LIMIT, 13) TP_W_LIM_MBPS,
  LPAD(TO_DECIMAL(IO.DIRECT_SUBMIT_READ_SIZE / 1024 / 1024 / 1024, 10, 2), 8) DIR_R_GB,
  LPAD(TO_DECIMAL(IO.DIRECT_SUBMIT_WRITE_SIZE / 1024 / 1024 / 1024, 10, 2), 8) DIR_W_GB,
  LPAD(TO_DECIMAL(IO.DISPATCH_SUBMIT_QUEUE_READ_SIZE / 1024 / 1024 / 1024, 10, 2), 8) DIS_R_GB,
  LPAD(TO_DECIMAL(IO.DISPATCH_SUBMIT_QUEUE_WRITE_SIZE / 1024 / 1024 / 1024, 10, 2), 8) DIS_W_GB,
  LPAD(TO_DECIMAL(IO.DISPATCH_THROTTLE_QUEUE_READ_SIZE / 1024 / 1024 / 1024, 10, 2), 8) THR_R_GB,
  LPAD(TO_DECIMAL(IO.DISPATCH_THROTTLE_QUEUE_WRITE_SIZE / 1024 / 1024 / 1024, 10, 2), 8) THR_W_GB,
  LPAD(TO_DECIMAL((IO.DISPATCH_THROTTLE_QUEUE_READ_SIZE - IO.THROTTLED_DISPATCH_SUBMIT_QUEUE_READ_SIZE) / 1024 / 1024, 10, 2), 11) THR_R_BL_MB,
  LPAD(TO_DECIMAL((IO.DISPATCH_THROTTLE_QUEUE_WRITE_SIZE - IO.THROTTLED_DISPATCH_SUBMIT_QUEUE_WRITE_SIZE) / 1024 / 1024, 10, 2), 11) THR_W_BL_MB,
  IO.PATH
FROM
( SELECT                        /* Modification section */
    '%' HOST,
    '%' PORT,
    '%' IO_TYPE,                      /* LOG, DATA, ... */
    '%' PATH,
    'CURRENT' DATA_SOURCE             /* CURRENT, RESET */
  FROM
    DUMMY
) BI,
( SELECT
    'CURRENT' DATA_SOURCE,
    HOST,
    PORT,
    TYPE IO_TYPE,
    PATH,
    THROUGHPUT_LIMIT,
    THROUGHPUT_READ_LIMIT,
    THROUGHPUT_WRITE_LIMIT,
    DIRECT_SUBMIT_READ_SIZE,
    DIRECT_SUBMIT_WRITE_SIZE,
    DISPATCH_SUBMIT_QUEUE_READ_SIZE,
    DISPATCH_SUBMIT_QUEUE_WRITE_SIZE,
    DISPATCH_THROTTLE_QUEUE_READ_SIZE,
    DISPATCH_THROTTLE_QUEUE_WRITE_SIZE,
    THROTTLED_DISPATCH_SUBMIT_QUEUE_READ_SIZE,
    THROTTLED_DISPATCH_SUBMIT_QUEUE_WRITE_SIZE
  FROM
    M_VOLUME_IO_SUBMIT_STATISTICS
  UNION ALL
  SELECT
    'RESET' DATA_SOURCE,
    HOST,
    PORT,
    TYPE IO_TYPE,
    PATH,
    THROUGHPUT_LIMIT,
    THROUGHPUT_READ_LIMIT,
    THROUGHPUT_WRITE_LIMIT,
    DIRECT_SUBMIT_READ_SIZE,
    DIRECT_SUBMIT_WRITE_SIZE,
    DISPATCH_SUBMIT_QUEUE_READ_SIZE,
    DISPATCH_SUBMIT_QUEUE_WRITE_SIZE,
    DISPATCH_THROTTLE_QUEUE_READ_SIZE,
    DISPATCH_THROTTLE_QUEUE_WRITE_SIZE,
    THROTTLED_DISPATCH_SUBMIT_QUEUE_READ_SIZE,
    THROTTLED_DISPATCH_SUBMIT_QUEUE_WRITE_SIZE  FROM
    M_VOLUME_IO_SUBMIT_STATISTICS_RESET
) IO
WHERE
  IO.HOST LIKE BI.HOST AND
  TO_VARCHAR(IO.PORT) LIKE BI.PORT AND
  IO.IO_TYPE LIKE BI.IO_TYPE AND
  IO.PATH LIKE BI.PATH AND
  IO.DATA_SOURCE = BI.DATA_SOURCE
ORDER BY
  IO.HOST,
  IO.PORT,
  IO.IO_TYPE