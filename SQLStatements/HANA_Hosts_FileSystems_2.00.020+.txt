SELECT

/* 

[NAME]

- HANA_Hosts_FileSystems_2.00.020+

[DESCRIPTION]

- Filesystem information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_HOST_AGENT_METRICS available with SAP HANA >= 2.00.020
- M_HOST_AGENT_METRICS data may not be available for slave nodes with SAP HANA <= 2.00.035
- There can be auto-extend mechanisms for filesystems, so a high filesystem utilization doesn't
  necessarily indicate a problem

[VALID FOR]

- Revisions:              >= 2.00.020

[SQL COMMAND VERSION]

- 2019/03/17:  1.0 (initial version)

[INVOLVED TABLES]

- M_HOST_AGENT_METRICS

[INPUT PARAMETERS]

- HOST

  Host name

  'saphana01'     --> Specific host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- FILESYSTEM

  Filesystem

  '/home'         --> Information for filesystem /home
  '%'             --> No restriction to filesystem

- MIN_USED_PCT

  Minimum threshold for used disk space (%)

  90              --> Only display filesystems with at least 90 % of used space
  -1              --> No restriction related to filesystem filling level

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'FILESYSTEM'    --> Sorting by filesystem name
  'USED_PCT'      --> Sorting by used space (%)

[OUTPUT PARAMETERS]

- Timestamp:  Check timestamp
- HOST:       Host
- FILESYSTEM: Filesystem name
- SIZE_GB:    Filesystem size (GB)
- USED_GB:    Used space in filesystem (GB)
- FREE_GB:    Free space in filesystem (GB)
- USED_PCT:   Used space in filesystem (%)
- FREE_PCT:   Free space in filesystem (%)

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------
|HOST   |FILESYSTEM             |SIZE_GB   |USED_GB   |FREE_GB   |USED_PCT|FREE_PCT|
------------------------------------------------------------------------------------
|saphana|/                      |    500.00|    226.52|    273.47|   45.30|   54.69|
|saphana|/hana/data/C11         |  36861.86|  13169.92|  23691.94|   35.72|   64.27|
|saphana|/hana/shared/C11       |   1023.48|    193.54|    829.93|   18.91|   81.08|
|saphana|/hana/log/C11          |   1023.48|    148.34|    875.13|   14.49|   85.50|
|saphana|/usr/sap               |    127.95|      3.84|    124.10|    3.00|   96.99|
|saphana|/boot/efi              |      0.15|      0.00|      0.14|    2.95|   97.04|
|saphana|/run                   |   8794.53|      2.45|   8792.07|    0.02|   99.97|
|saphana|/dev/shm               |  13193.29|      0.00|  13193.29|    0.00|   99.99|
|saphana|/dev                   |   8794.52|      0.00|   8794.52|    0.00|   99.99|
------------------------------------------------------------------------------------

*/

  TO_VARCHAR(FS.TIMESTAMP, 'YYYY/MM/DD HH24:MI:SS') TIMESTAMP,
  FS.HOST,
  FS.FILESYSTEM,
  LPAD(TO_DECIMAL(FS.SIZE_GB, 10, 2), 10) SIZE_GB,
  LPAD(TO_DECIMAL(FS.USED_GB, 10, 2), 10) USED_GB,
  LPAD(TO_DECIMAL(FS.FREE_GB, 10, 2), 10) FREE_GB,
  LPAD(TO_DECIMAL(FS.USED_PCT, 10, 2), 8) USED_PCT,
  LPAD(TO_DECIMAL(FS.FREE_PCT, 10, 2), 8) FREE_PCT
FROM
( SELECT                 /* Modification section */
    '%' HOST,
    '%' FILESYSTEM,
    -1 MIN_USED_PCT,
    'USED_PCT' ORDER_BY          /* HOST, FILESYSTEM, FREE_SIZE, USED_PCT */
  FROM
    DUMMY
) BI,
( SELECT
    TIMESTAMP,
    HOST,
    FILESYSTEM,
    SIZE_GB,
    FREE_GB,
    SIZE_GB - FREE_GB USED_GB,
    MAP(SIZE_GB, 0, 0, FREE_GB / SIZE_GB * 100) FREE_PCT,
    MAP(SIZE_GB, 0, 0, 100 - FREE_GB / SIZE_GB * 100) USED_PCT
  FROM
  ( SELECT
      MAX(TIMESTAMP) TIMESTAMP,
      HOST,
      MEASURED_ELEMENT_NAME FILESYSTEM,
      MAX(MAP(CAPTION, 'File System Size', TO_NUMBER(VALUE) / 1024 / 1024 / 1024, 0)) SIZE_GB,
      MAX(MAP(CAPTION, 'File System Free', TO_NUMBER(VALUE) / 1024 / 1024 / 1024, 0)) FREE_GB
    FROM
      M_HOST_AGENT_METRICS
    WHERE
      MEASURED_ELEMENT_TYPE = 'FileSystem'
    GROUP BY
      HOST,
      MEASURED_ELEMENT_NAME
  )
) FS
WHERE
  FS.HOST LIKE BI.HOST AND
  FS.FILESYSTEM LIKE BI.FILESYSTEM AND
  ( BI.MIN_USED_PCT = -1 OR FS.USED_PCT >= BI.MIN_USED_PCT )
ORDER BY
  MAP(BI.ORDER_BY, 'FILESYSTEM', FS.FILESYSTEM),
  MAP(BI.ORDER_BY, 'FREE_SIZE', FS.FREE_GB, 'USED_PCT', FS.USED_PCT) DESC,
  HOST