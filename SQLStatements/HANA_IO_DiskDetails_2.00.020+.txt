SELECT

/* 

[NAME]

- HANA_IO_DiskDetails_2.00.020+

[DESCRIPTION]

- Disk detail information (performance, load, throughput)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_HOST_AGENT_METRICS available with SAP HANA >= 2.00.020
- M_HOST_AGENT_METRICS data may not be available for slave nodes with SAP HANA <= 2.00.035

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

- DISK

  Disk name

  'sdf'           --> Information for disk sdf
  '%'             --> No restriction to disk

- MIN_LATENCY_MS

  Minimum disk latency (ms)

  10              --> Only display disks with more than 10 ms latency
  -1              --> No restriction related to disk latency

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'LATENCY'       --> Order by I/O latency
  'THROUGHPUT'    --> Order by I/O throughput

[OUTPUT PARAMETERS]

- TIMESTAMP:  Check timestamp
- HOST:       Host
- DISK:       Disk name
- QUEUE:      I/O queue length (number of queued requests)
- LATENCY_MS: Total I/O latency (ms), i.e. sum of service and wait time
- SRV_MS:     I/O service time (ms)
- WAIT_MS:    I/O wait time (ms)
- IO_PER_S:   I/O requests per second
- TP_MBPS:    I/O throughput (MB/s)

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------
|TIMESTAMP          |HOST   |DISK|QUEUE   |LATENCY_MS|SRV_MS|WAIT_MS|IO_PER_S|TP_MBPS|
--------------------------------------------------------------------------------------
|2019/03/17 18:22:10|saphana|sddq|    0.00|      2.58|  1.29|   1.29|    0.47|   0.06|
|2019/03/17 18:22:10|saphana|sddk|    0.00|      2.48|  1.24|   1.24|    0.48|   0.06|
|2019/03/17 18:22:10|saphana|sddi|    0.00|      2.20|  1.10|   1.10|    0.48|   0.06|
|2019/03/17 18:22:10|saphana|sde |    0.00|      2.20|  1.10|   1.10|    0.48|   0.06|
|2019/03/17 18:22:10|saphana|sdfd|    0.00|      2.14|  1.07|   1.07|    0.50|   0.04|
|2019/03/17 18:22:10|saphana|sdbr|    0.00|      1.86|  0.93|   0.93|    0.50|   0.05|
|2019/03/17 18:22:10|saphana|sdf |    0.00|      1.86|  0.93|   0.93|    0.50|   0.07|
|2019/03/17 18:22:10|saphana|sdcr|    0.00|      1.80|  0.90|   0.90|    0.52|   0.04|
|2019/03/17 18:22:10|saphana|sdcu|    0.00|      1.72|  0.86|   0.86|    0.47|   0.06|
|2019/03/17 18:22:10|saphana|sdbx|    0.00|      1.72|  0.86|   0.86|    0.47|   0.04|
--------------------------------------------------------------------------------------

*/

  TO_VARCHAR(I.TIMESTAMP, 'YYYY/MM/DD HH24:MI:SS') TIMESTAMP,
  I.HOST,
  I.DISK,
  LPAD(TO_DECIMAL(I.QUEUE, 10, 2), 8) QUEUE,
  LPAD(TO_DECIMAL(I.LATENCY_MS, 10, 2), 10) LATENCY_MS,
  LPAD(TO_DECIMAL(I.SRV_MS, 10, 2), 7) SRV_MS,
  LPAD(TO_DECIMAL(I.WAIT_MS, 10, 2), 7) WAIT_MS,
  LPAD(TO_DECIMAL(I.IO_PER_S, 10, 2), 8) IO_PER_S,
  LPAD(TO_DECIMAL(I.TP_KBPS / 1024, 10, 2), 7) TP_MBPS
FROM
( SELECT                                /* Modification section */
    '%' HOST,
    '%' DISK,
    -1 MIN_LATENCY_MS,
    'LATENCY' ORDER_BY                  /* HOST, DISK, LATENCY, SERVICE_TIME, WAIT_TIME, IOPS, THROUGHPUT */
  FROM
    DUMMY
) BI,
( SELECT
    TIMESTAMP,
    HOST,
    DISK,
    QUEUE,
    SRV_MS + WAIT_MS LATENCY_MS,
    SRV_MS,
    WAIT_MS,
    IO_PER_S,
    TP_KBPS
  FROM
  ( SELECT
      TIMESTAMP,
      HOST,
      MEASURED_ELEMENT_NAME DISK,
      MAX(MAP(CAPTION, 'Queue Length', TO_NUMBER(VALUE), 0)) QUEUE,
      MAX(MAP(CAPTION, 'Service Time', TO_NUMBER(VALUE), 0)) SRV_MS,
      MAX(MAP(CAPTION, 'Wait Time', TO_NUMBER(VALUE), 0)) WAIT_MS,
      MAX(MAP(CAPTION, 'I/O Rate', TO_NUMBER(VALUE), 0)) IO_PER_S,
      MAX(MAP(CAPTION, 'Total Throughput', TO_NUMBER(VALUE), 0)) TP_KBPS
    FROM
      M_HOST_AGENT_METRICS
    WHERE
      MEASURED_ELEMENT_TYPE = 'Disk'
    GROUP BY
      TIMESTAMP,
      HOST,
      MEASURED_ELEMENT_NAME
  )
) I
WHERE
  I.HOST LIKE BI.HOST AND
  I.DISK LIKE BI.DISK AND
  ( BI.MIN_LATENCY_MS = -1 OR I.LATENCY_MS >= BI.MIN_LATENCY_MS )
ORDER BY
  MAP(BI.ORDER_BY, 'HOST', I.HOST, 'DISK', I.DISK),
  MAP(BI.ORDER_BY, 'LATENCY', I.LATENCY_MS, 'SERVICE_TIME', I.SRV_MS, 'WAIT_TIME', I.WAIT_MS, 'IOPS', I.IO_PER_S, 'THROUGHPUT', I.TP_KBPS) DESC