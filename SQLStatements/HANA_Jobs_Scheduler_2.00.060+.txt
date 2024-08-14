SELECT
/* 

[NAME]

- HANA_Jobs_Scheduler_2.00.060+

[DESCRIPTION]

- Overview of scheduled jobs

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- SCHEDULER_JOBS available with SAP HANA >= 2.00.060

[VALID FOR]

- Revisions:              >= 2.00.060

[SQL COMMAND VERSION]

- 2022/03/09:  1.0 (initial version)

[INVOLVED TABLES]

- SCHEDULER_JOBS

[INPUT PARAMETERS]

- JOB_NAME

  Job name

  'TCC'          --> Job with name TCC
  '%'            --> No restriction related to job name

- PROCEDURE_NAME

  Procedure name

  'TCC_PROC'      --> Procedure with name TCC_PROC
  '%'             --> No restriction related to procedure name

[OUTPUT PARAMETERS]

- JOB_NAME:       Job name
- PROCEDURE_NAME: Procedure name
- CRON:           CRON scheduler string
- E:              'X' if enabled, otherwise ' '
- V:              'X' if valid, otherwise ' '
- START_TIME:     Job start time
- END_TIME:       Job end time
- CREATE_TIME:    Job create time
- COMMENTS:       Comments

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------------
|JOB_NAME                |PROCEDURE_NAME               |CRON              |E|V|START_TIME|END_TIME|CREATE_TIME        |COMMENTS|
--------------------------------------------------------------------------------------------------------------------------------
|RECLAIM_COLUMN_LOB_SPACE|PROC_RECLAIM_COLUMN_LOB_SPACE|* * * SUN 03 00 00|X|X|          |        |2022/03/09 18:25:04|        |
--------------------------------------------------------------------------------------------------------------------------------

*/

  SJ.SCHEDULER_JOB_NAME JOB_NAME,
  SJ.PROCEDURE_NAME,
  SJ.CRON,
  MAP(SJ.IS_ENABLED, 'TRUE', 'X', '') E,
  MAP(SJ.IS_VALID, 'TRUE', 'X', '') V,
  IFNULL(TO_VARCHAR(SJ.START_TIME, 'YYYY/MM/DD HH24:MI:SS'), '') START_TIME,
  IFNULL(TO_VARCHAR(SJ.END_TIME, 'YYYY/MM/DD HH24:MI:SS'), '') END_TIME,
  TO_VARCHAR(SJ.CREATE_TIME, 'YYYY/MM/DD HH24:MI:SS') CREATE_TIME,
  IFNULL(SJ.COMMENTS, '') COMMENTS
FROM
( SELECT          /* Modification section */
    '%' JOB_NAME,
    '%' PROCEDURE_NAME
  FROM
    DUMMY
) BI,
  SCHEDULER_JOBS SJ
WHERE
  SJ.SCHEDULER_JOB_NAME LIKE BI.JOB_NAME AND
  SJ.PROCEDURE_NAME LIKE BI.PROCEDURE_NAME
ORDER BY
  SJ.SCHEDULER_JOB_NAME,
  SJ.START_TIME