SELECT
/* 

[NAME]

- HANA_Hosts_Overview

[DESCRIPTION]

- Host information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/05/30:  1.0 (initial version)
- 2014/11/29:  1.1 (CPU_CLOCK and NOFILE_LIMIT included)
- 2015/04/09:  1.2 (KERNEL_VERSION included)
- 2018/10/31:  1.3 (SOCKETS included)

[INVOLVED TABLES]

- M_HOST_INFORMATION

[INPUT PARAMETERS]

- HOST

  Host name

  'saphana01'     --> Specific host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- MAX_NOFILE_LIMIT

  Maximum threshold for number of open files limit

  1000000         --> Only show hosts with a limit of 100000 or less open files
  -1              --> No restriction in terms of open files limit

[OUTPUT PARAMETERS]

- HOST:           Host name
- BUILT_BY:       Manufacturer name
- CPU_DETAILS:    CPU details (cores, threads, speed)
- SOCKETS:        CPU sockets
- CPU_MHZ:        Current CPU speed (MHz)
- PHYS_MEM_GB:    Physical memory size (GB)
- SWAP_GB:        Swap size (GB)
- OP_SYS:         Operating system type and version
- KERNEL_VERSION: Linux kernel version
- HARDWARE_MODEL: Hardware model
- CPU_MODEL:      CPU model
- NOFILE_LIMIT:   Number of open files limit

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST  |BUILT_BY|CPU_DETAILS   |CPU_MHZ|PHYS_MEM_GB|SWAP_GB|OP_SYS   |KERNEL_VERSION      |CPU_MODEL                        |HARDWARE_MODEL             |NOFILE_LIMIT|
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
|hana10|IBM     |40(80)*2395MHz|   2395|     504.89|  31.99|SLES 11.3|3.0.101-0.40-default|Intel Xeon CPU E7- 8870 @ 2.40GHz|System x3850 X5 -[7143ZAH]-|     1048576|
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

  HOST,
  IFNULL(BUILT_BY,                'n/a') BUILT_BY,
  IFNULL(CPU_DETAILS,             'n/a') CPU_DETAILS,
  IFNULL(LPAD(CPU_SOCKETS, 7),    'n/a') SOCKETS,
  IFNULL(LPAD(CPU_CLOCK_MHZ, 7),  'n/a') CPU_MHZ,
  IFNULL(LPAD(PHYS_MEM_GB,   11), 'n/a') PHYS_MEM_GB,
  IFNULL(LPAD(SWAP_GB,        7), 'n/a') SWAP_GB,
  IFNULL(OP_SYS,                  'n/a') OP_SYS,
  IFNULL(KERNEL_VERSION,          'n/a') KERNEL_VERSION,
  IFNULL(CPU_MODEL,               'n/a') CPU_MODEL,
  IFNULL(HARDWARE_MODEL,          'n/a') HARDWARE_MODEL,
  IFNULL(LPAD(NOFILE_LIMIT, 12),  'n/a') NOFILE_LIMIT
FROM
( SELECT
    H.HOST,
    MAX(CASE WHEN KEY = 'hw_manufacturer' THEN VALUE                                                    END) BUILT_BY,
    MAX(CASE WHEN KEY = 'cpu_summary'     THEN REPLACE(VALUE, CHAR(32), '')                             END) CPU_DETAILS,
    MAX(CASE WHEN KEY = 'cpu_clock'       THEN VALUE                                                    END) CPU_CLOCK_MHZ,
    MAX(CASE WHEN KEY = 'cpu_sockets'     THEN VALUE                                                    END) CPU_SOCKETS,
    MAX(CASE WHEN KEY = 'mem_phys'        THEN TO_DECIMAL(TO_NUMBER(VALUE) / 1024 / 1024 / 1024, 10, 2) END) PHYS_MEM_GB,
    MAX(CASE WHEN KEY = 'mem_swap'        THEN TO_DECIMAL(TO_NUMBER(VALUE) / 1024 / 1024 / 1024, 10, 2) END) SWAP_GB,
    REPLACE(REPLACE(MAX(CASE WHEN KEY = 'os_name'   THEN VALUE END), 'SUSE Linux Enterprise Server', 'SLES'), 'Red Hat Enterprise Linux Server release', 'RHEL') OP_SYS,
    MAX(CASE WHEN KEY = 'os_kernel_version' THEN VALUE END) KERNEL_VERSION,
    REPLACE(MAX(CASE WHEN KEY = 'cpu_model' THEN VALUE END), '(R)', '') CPU_MODEL,
    MAX(CASE WHEN KEY = 'hw_model' THEN VALUE END) HARDWARE_MODEL,
    MAX(CASE WHEN KEY = 'os_rlimit_nofile'  THEN VALUE END) NOFILE_LIMIT,
    BI.MAX_NOFILE_LIMIT
  FROM
  ( SELECT                  /* Modification section */
      '%' HOST,
      -1 MAX_NOFILE_LIMIT
    FROM
      DUMMY
  ) BI,
    M_HOST_INFORMATION H
  WHERE
    H.HOST LIKE BI.HOST
  GROUP BY
    H.HOST,
    BI.MAX_NOFILE_LIMIT
)
WHERE
  ( MAX_NOFILE_LIMIT = -1 OR NOFILE_LIMIT <= MAX_NOFILE_LIMIT )
ORDER BY
  HOST
