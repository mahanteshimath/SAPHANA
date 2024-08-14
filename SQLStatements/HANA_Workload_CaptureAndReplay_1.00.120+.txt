SELECT

/* 

[NAME]

- HANA_Workload_CaptureAndReplay_1.00.120+

[DESCRIPTION]

- Overview of capture and replay activities

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_WORKLOAD_CAPTURE and M_WORKLOAD_REPLAY available with SAP HANA >= 1.0 SPS 12
- See SAP Note 2669621 for more information related to capture and replay

[VALID FOR]

- Revisions:              >= 1.00.120

[SQL COMMAND VERSION]

- 2020/08/18:  1.0 (initial version)

[INVOLVED TABLES]

- M_WORKLOAD_CAPTURE
- M_WORKLOAD_REPLAY

[INPUT PARAMETERS]

- CAPTURE_ID

  Workload capture ID

  1234            --> Workload capture ID 1234
  -1              --> No restriction related to workload capture ID

- CAPTURE_NAME

  Workload capture name

  'PEAK_LOAD'     --> Workload capture with name PEAK_LOAD
  '%'             --> No restriction related to workload capture name

- REPLAY_ID

  Workload replay ID

  1234            --> Workload replay ID 1234
  -1              --> No restriction related to workload replay ID

- REPLAY_NAME

  Workload replay name

  'PEAK_LOAD_REP' --> Workload replay with name PEAK_LOAD_REP
  '%'             --> No restriction related to workload replay name

[OUTPUT PARAMETERS]

- CAPTURE_START_TIME:  Workload capture start time
- CAPTURE_END_TIME:    Workload capture end time
- CAPTURE_ID:          Workload capture ID
- CAPTURE_NAME:        Workload capture name
- CAPTURE_DESCRIPTION: Workload capture description
- CAP_STATUS:          Workload capture status
- REPLAY_START_TIME:   Workload replay start time
- REPLAY_END_TIME:     Workload replay end time
- REPLAY_ID:           Workload replay ID
- REPLAY_NAME:         Workload replay name
- REPLAY_DESCRIPTION:  Workload replay description
- REP_STATUS:          Workload replay status

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------
|HOST       |PORT |XS_SESS_ID|DB_USER     |AUTH_METHOD|START_TIME         |LAST_REQUEST_TIME  |
-----------------------------------------------------------------------------------------------
|saphananode|30003|     22880|RFC_BOM     |BASIC      |2020/08/18 10:16:59|2020/08/18 10:16:59|
|saphananode|30003|     22879|RFC_BOM     |BASIC      |2020/08/18 10:16:41|2020/08/18 10:16:41|
|saphananode|30003|     22878|RFC_BOM     |BASIC      |2020/08/18 10:16:23|2020/08/18 10:16:23|
|saphananode|30003|       190|MUELLER     |SAML       |2020/08/14 14:16:12|2020/08/18 10:15:05|
|saphananode|30003|       143|MAIER       |SAML       |2020/08/14 14:12:02|2020/08/18 10:15:30|
|saphananode|30003|       139|LORENZ      |SAML       |2020/08/14 14:11:22|2020/08/18 10:15:49|
-----------------------------------------------------------------------------------------------

*/

  TO_VARCHAR(CR.CAPTURE_START_TIME, 'YYYY/MM/DD HH24:MI:SS') CAPTURE_START_TIME,
  TO_VARCHAR(CR.CAPTURE_END_TIME, 'YYYY/MM/DD HH24:MI:SS') CAPTURE_END_TIME,
  CR.CAPTURE_ID,
  CR.CAPTURE_NAME,
  CR.CAPTURE_DESCRIPTION,
  CR.CAPTURE_STATUS CAP_STATUS,
  IFNULL(TO_VARCHAR(CR.REPLAY_START_TIME, 'YYYY/MM/DD HH24:MI:SS'), '') REPLAY_START_TIME,
  IFNULL(TO_VARCHAR(CR.REPLAY_END_TIME, 'YYYY/MM/DD HH24:MI:SS'), '') REPLAY_END_TIME,
  IFNULL(TO_VARCHAR(CR.REPLAY_ID), '') REPLAY_ID,
  IFNULL(CR.REPLAY_NAME, '') REPLAY_NAME,
  IFNULL(CR.REPLAY_DESCRIPTION, '') REPLAY_DESCRIPTION,
  IFNULL(CR.REPLAY_STATUS, '') REP_STATUS
FROM
( SELECT                      /* Modification section */
    -1 CAPTURE_ID,
    '%' CAPTURE_NAME,
    -1 REPLAY_ID,
    '%' REPLAY_NAME
  FROM
    DUMMY
) BI,
( SELECT
    C.CAPTURE_ID,
    C.CAPTURE_NAME,
    C.CAPTURE_DESCRIPTION,
    C.START_TIME CAPTURE_START_TIME,
    C.END_TIME CAPTURE_END_TIME,
    C.DATABASE_NAME CAPTURE_DATABASE_NAME,
    C.STATUS CAPTURE_STATUS,
    R.REPLAY_ID,
    R.REPLAY_NAME,
    R.REPLAY_DESCRIPTION,
    R.REPLAY_START_TIME,
    R.REPLAY_END_TIME,
    R.REPLAY_DATABASE_NAME,
    R.STATUS REPLAY_STATUS
  FROM
    M_WORKLOAD_CAPTURES C LEFT OUTER JOIN
    M_WORKLOAD_REPLAYS R ON
      R.CAPTURE_ID = C.CAPTURE_ID
) CR
WHERE
  ( BI.CAPTURE_ID = -1 OR CR.CAPTURE_ID = BI.CAPTURE_ID ) AND
  CR.CAPTURE_NAME LIKE BI.CAPTURE_NAME AND
  ( BI.REPLAY_ID = -1 OR CR.REPLAY_ID = BI.REPLAY_ID ) AND
  IFNULL(CR.REPLAY_NAME, '') LIKE BI.REPLAY_NAME
ORDER BY
  CR.CAPTURE_START_TIME DESC