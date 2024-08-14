SELECT
/* 

[NAME]

- HANA_Jobs_Executors_2.00.043+

[DESCRIPTION]

- Job Executor overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Can be used for monitoring remote system replication sites, see SAP Note 1999880 
  ("Is it possible to monitor remote system replication sites on the primary system") for details.
- M_JOBEXECUTORS.MAX_CONCURRENCY_CONFIG available with SAP HANA >= 2.00.043

[VALID FOR]

- Revisions:              >= 2.00.043

[SQL COMMAND VERSION]

- 2014/07/09:  1.0 (initial version)
- 2017/01/04:  1.1 (QUEUED included)
- 2019/10/12:  1.2 (dedicated 2.00.043 version including MAX_CONCURRENCY_CONFIG)
- 2021/01/01:  1.3 (CONC_ESTD included)

[INVOLVED TABLES]

- M_JOBEXECUTORS

[INPUT PARAMETERS]

- HOST

  Host name

  'saphana01'     --> Specic host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- PORT

  Port number

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

[OUTPUT PARAMETERS]

- HOST:        Host name
- PORT:        Port
- TOTAL:       Total number of job workers
- CONC_CONFIG: Configured max_concurrency value
- CONC_CURR:   Currently used max_concurrency value (can be smaller than configured one in case of dynamic reductions)
- CONC_ESTD:   Estimation for currently used max_concurrency value based on thread activities (should not be significantly higher than CONC_CURR)
- BUSY:        Active JobWorkers
- PARKED:      JobWorkers parked for future uwe
- FREE:        Idle JobWorkers
- SYSWAIT:     JobWorkers waiting for synchronization
- JOBWAIT:     JobWorkers waiting for other JobWorkers
- YIELDWAIT:   Job workers waiting for some more important activities
- QUEUED:      Queued jobs (because maximum amount of JobWorkers is already in active)

[EXAMPLE OUTPUT]

----------------------------------------------------------------------
|HOST         |PORT |TOTAL|BUSY|PARKED|FREE|SYSWAIT|JOBWAIT|YIELDWAIT|
----------------------------------------------------------------------
|saphanab3d001|31103|  172|   4|    12| 155|      0|      0|        0|
|saphanab3d001|31105|  178|   0|    18| 159|      0|      0|        0|
|saphanab3d001|31107|  161|   0|     1| 159|      0|      0|        0|
|saphanab3d003|31103|  260| 158|    93|   0|      6|      2|        0|
|saphanab3d004|31103|  329| 160|   165|   0|      0|      3|        0|
|saphanab3d005|31103|  371|  16|   211| 111|     31|      1|        0|
|saphanab3d006|31103|  253|   7|    93| 142|     10|      0|        0|
|saphanab3d007|31103|  332| 156|   161|   0|     11|      3|        0|
|saphanab3d008|31103|  338|   1|   178| 158|      0|      0|        0|
|saphanab3d009|31103|  283|   2|   123| 156|      1|      0|        0|
|saphanab3d010|31103|  264|   9|   104| 148|      1|      1|        0|
|saphanab3d011|31103|  258| 135|    92|   0|     29|      1|        0|
----------------------------------------------------------------------

*/

  J.HOST,
  LPAD(J.PORT, 5) PORT,
  LPAD(J.MAX_CONCURRENCY_CONFIG, 11) CONC_CONFIG,
  LPAD(J.MAX_CONCURRENCY, 9) CONC_CURR,
  LPAD(TO_DECIMAL(J.MAX_CONCURRENCY_CONFIG - IFNULL(T.CONC_REDUCTION, 0), 10, 0), 9) CONC_ESTD,
  LPAD(J.TOTAL_WORKER_COUNT, 5) TOTAL,
  LPAD(J.TOTAL_WORKER_COUNT - J.PARKED_WORKER_COUNT - J.FREE_WORKER_COUNT - J.SYS_WAITING_WORKER_COUNT - 
    J.JOB_WAITING_WORKER_COUNT - J.YIELD_WAITING_WORKER_COUNT - 1, 4) BUSY,
  LPAD(J.PARKED_WORKER_COUNT, 6) PARKED,
  LPAD(J.FREE_WORKER_COUNT, 4) FREE,
  LPAD(J.SYS_WAITING_WORKER_COUNT, 7) SYSWAIT,
  LPAD(J.JOB_WAITING_WORKER_COUNT, 7) JOBWAIT,
  LPAD(J.YIELD_WAITING_WORKER_COUNT, 9) YIELDWAIT,
  LPAD(J.QUEUED_WAITING_JOB_COUNT, 6) QUEUED
FROM
( SELECT                        /* Modification section */
    '%' HOST,
    '%' PORT
  FROM
    DUMMY
) BI,
  M_JOBEXECUTORS J LEFT OUTER JOIN
( SELECT
    HOST,
    SUM(MAP(THREAD_STATE, 'Running', 1, 0.4)) CONC_REDUCTION
  FROM
    M_SERVICE_THREADS
  WHERE
    (THREAD_TYPE, THREAD_STATE) NOT IN (('JobWorker', 'Running')) AND
    THREAD_STATE != 'Job Exec Waiting' AND
    IS_ACTIVE = 'TRUE'
  GROUP BY
    HOST
) T ON
  T.HOST = J.HOST
WHERE
  J.HOST LIKE BI.HOST AND
  TO_VARCHAR(J.PORT) LIKE BI.PORT
ORDER BY
  J.HOST,
  J.PORT
