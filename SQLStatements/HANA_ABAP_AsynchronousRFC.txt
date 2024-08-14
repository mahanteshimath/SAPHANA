SELECT

/* 

[NAME]

- HANA_ABAP_AsynchronousRFC

[DESCRIPTION]

- Overview of asynchronous RFC records

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Table ARFCSSTATE only available in SAP ABAP environments
- You have to be connected to the SAP<sid> schema otherwise the following error is issued:

  [259]: invalid table name: Could not find table/view ARFCSSTATE in schema

- If access to ABAP objects is possible but you cannot log on as ABAP user, you can switch the default schema before executing the command:

  SET SCHEMA SAP<sid>

[VALID FOR]

- Revisions:              all
- Client application:     ABAP

[SQL COMMAND VERSION]

- 2023/02/16:  1.0 (initial version)

[INVOLVED TABLES]

- ARFCSDATA
- ARFCSSTATE

[INPUT PARAMETERS]

- BEGIN_TIME

  Begin time

  '2018/12/05 14:05:00' --> Set begin time to 5th of December 2018, 14:05
  'C'                   --> Set begin time to current time
  'C-S900'              --> Set begin time to current time minus 900 seconds
  'C-M15'               --> Set begin time to current time minus 15 minutes
  'C-H5'                --> Set begin time to current time minus 5 hours
  'C-D1'                --> Set begin time to current time minus 1 day
  'C-W4'                --> Set begin time to current time minus 4 weeks
  'E-S900'              --> Set begin time to end time minus 900 seconds
  'E-M15'               --> Set begin time to end time minus 15 minutes
  'E-H5'                --> Set begin time to end time minus 5 hours
  'E-D1'                --> Set begin time to end time minus 1 day
  'E-W4'                --> Set begin time to end time minus 4 weeks
  'MIN'                 --> Set begin time to minimum (1000/01/01 00:00:00)

- END_TIME

  End time

  '2018/12/08 14:05:00' --> Set end time to 8th of December 2018, 14:05
  'C'                   --> Set end time to current time
  'C-S900'              --> Set end time to current time minus 900 seconds
  'C-M15'               --> Set end time to current time minus 15 minutes
  'C-H5'                --> Set end time to current time minus 5 hours
  'C-D1'                --> Set end time to current time minus 1 day
  'C-W4'                --> Set end time to current time minus 4 weeks
  'B+S900'              --> Set end time to begin time plus 900 seconds
  'B+M15'               --> Set end time to begin time plus 15 minutes
  'B+H5'                --> Set end time to begin time plus 5 hours
  'B+D1'                --> Set end time to begin time plus 1 day
  'B+W4'                --> Set end time to begin time plus 4 weeks
  'MAX'                 --> Set end time to maximum (9999/12/31 23:59:59)

- ARFCDEST

  ARFC destination

  'C11CLNT100'    --> ARFC destination C11CLNT100
  '%'             --> No restriction related to ARFC destination

- ARFCSTATE

  ARFC state

  'CPICERR'       --> Records with ARFC state CPICERR (CPIC error)
  '%'             --> No restriction related to ARFC state

- ARFCFNAM

  ARFC function module name

  'SUSR_USER_RESPONSE' --> ARFC function module name SUSR_USER_RESPONSE
  '%'                  --> No restriction related to ARFC function module name

- ARFCUSER

  ARFC user name

  'C11_BATCH'     --> Records related to ARFC user C11_BATCH
  '%'             --> No restriction related to ARFC user name

- ARFCMSG

  ARFC message
 
  'Time limit exceeded.' --> Records with message 'Time limit exceeded.'
  '%'                    --> No restriction related to message
  
- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'                --> Aggregation by time
  'ARFCDEST, ARFCSTATE' --> Aggregation by ARFC destination and state
  'NONE'                --> No aggregation

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'TIME'          --> Sorting by change time
  'COUNT'         --> Sorting by number of work items

[OUTPUT PARAMETERS]

- ARFCTIME:  ARFC time
- CNT:       Number of ARFC records
- ARFCDEST:  ARFC destination
- ARFCSTATE: ARFC state
- ARFCFNAM:  ARFC function module name
- ARFCUSER:  ARFC user name
- ARFCMSG:   ARFC message

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------------------------
|ARFCTIME|CNT    |ARFCDEST          |ARFCSTATE|ARFCFNAM                    |ARFCUSER    |ARFCMSG                                           |
--------------------------------------------------------------------------------------------------------------------------------------------
|any     |   9967|NONE              |SYSFAIL  |ENH_BUILD_TREE_IN_BACKGROUND|DDIC        |Time limit exceeded.                              |
|any     |   4987|NONE              |SYSFAIL  |ENH_BUILD_TREE_IN_BACKGROUND|DDIC        |Enhancement implementation /CWM/APPL_CO_RKEVRK2R d|
|any     |   2922|PS_00_750         |SYSFAIL  |ZZEBPP_POST_IS47            |OBERBOERSCHG|RFC-Destination PS_00_750 existiert nicht.        |
|any     |   1512|SAP_LRP           |SYSFAIL  |/SAPAPO/LRP_RES_CRE_TIMEINT |D044822     |RFC destination SAP_LRP does not exist.           |
|any     |   1049|PS_00_750         |SYSFAIL  |ZZEBPP_POST_IS47            |MMUELLER    |RFC-Destination PS_00_750 existiert nicht.        |
|any     |   1003|NONE              |SYSFAIL  |ENH_BUILD_TREE_IN_BACKGROUND|DDIC        |Error Building the ENH TreeObject Type:XHObject Na|
|any     |    656|NONE              |SYSFAIL  |ENH_BUILD_TREE_IN_BACKGROUND|TOEWEU      |Error Building the ENH TreeObject Type:XHObject Na|
|any     |    624|PS_00_750         |SYSFAIL  |ZZEBPP_POST_IS47            |D025016     |RFC destination PS_00_750 does not exist.         |
|any     |    357|WORKFLOW_LOCAL_800|VBRECORD |SWW_WI_CREATE_VIA_EVENT_IBF |HELBIGF     |                                                  |
--------------------------------------------------------------------------------------------------------------------------------------------

*/

  ARFCTIME,
  LPAD(CNT, 9) CNT,
  ARFCDEST,
  ARFCSTATE,
  ARFCFNAM,
  ARFCUSER,
  ARFCMSG
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), A.ARFC_TIME) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(A.ARFC_TIME, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END ARFCTIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ARFCDEST')  != 0 THEN A.ARFCDEST  ELSE MAP(BI.ARFCDEST,  '%', 'any', BI.ARFCDEST)  END ARFCDEST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ARFCSTATE') != 0 THEN A.ARFCSTATE ELSE MAP(BI.ARFCSTATE, '%', 'any', BI.ARFCSTATE) END ARFCSTATE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ARFCFNAM')  != 0 THEN A.ARFCFNAM  ELSE MAP(BI.ARFCFNAM,  '%', 'any', BI.ARFCFNAM)  END ARFCFNAM,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ARFCUSER')  != 0 THEN A.ARFCUSER  ELSE MAP(BI.ARFCUSER,  '%', 'any', BI.ARFCUSER)  END ARFCUSER,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ARFCMSG')   != 0 THEN A.ARFCMSG   ELSE MAP(BI.ARFCMSG,   '%', 'any', BI.ARFCMSG)   END ARFCMSG,
    SUM(CNT) CNT,
    BI.ORDER_BY
  FROM
  ( SELECT
      CASE
        WHEN BEGIN_TIME =    'C'                             THEN CURRENT_TIMESTAMP
        WHEN BEGIN_TIME LIKE 'C-S%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-S'))
        WHEN BEGIN_TIME LIKE 'C-M%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-M') * 60)
        WHEN BEGIN_TIME LIKE 'C-H%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-H') * 3600)
        WHEN BEGIN_TIME LIKE 'C-D%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-D') * 86400)
        WHEN BEGIN_TIME LIKE 'C-W%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-W') * 86400 * 7)
        WHEN BEGIN_TIME LIKE 'E-S%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-S'))
        WHEN BEGIN_TIME LIKE 'E-M%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-M') * 60)
        WHEN BEGIN_TIME LIKE 'E-H%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-H') * 3600)
        WHEN BEGIN_TIME LIKE 'E-D%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-D') * 86400)
        WHEN BEGIN_TIME LIKE 'E-W%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-W') * 86400 * 7)
        WHEN BEGIN_TIME =    'MIN'                           THEN TO_TIMESTAMP('1000/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS')
        WHEN SUBSTR(BEGIN_TIME, 1, 1) NOT IN ('C', 'E', 'M') THEN TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS')
      END BEGIN_TIME,
      CASE
        WHEN END_TIME =    'C'                             THEN CURRENT_TIMESTAMP
        WHEN END_TIME LIKE 'C-S%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-S'))
        WHEN END_TIME LIKE 'C-M%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-M') * 60)
        WHEN END_TIME LIKE 'C-H%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-H') * 3600)
        WHEN END_TIME LIKE 'C-D%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-D') * 86400)
        WHEN END_TIME LIKE 'C-W%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-W') * 86400 * 7)
        WHEN END_TIME LIKE 'B+S%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+S'))
        WHEN END_TIME LIKE 'B+M%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+M') * 60)
        WHEN END_TIME LIKE 'B+H%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+H') * 3600)
        WHEN END_TIME LIKE 'B+D%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+D') * 86400)
        WHEN END_TIME LIKE 'B+W%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+W') * 86400 * 7)
        WHEN END_TIME =    'MAX'                           THEN TO_TIMESTAMP('9999/12/31 00:00:00', 'YYYY/MM/DD HH24:MI:SS')
        WHEN SUBSTR(END_TIME, 1, 1) NOT IN ('C', 'B', 'M') THEN TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS')
      END END_TIME,
      ARFCDEST,
      ARFCSTATE,
      ARFCFNAM,
      ARFCUSER,
      ARFCMSG,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS',
        'HOUR',        'YYYY/MM/DD HH24',
        'DAY',         'YYYY/MM/DD (DY)',
        'HOUR_OF_DAY', 'HH24',
        TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
      ORDER_BY
    FROM
    ( SELECT                  /* Modification section */
        'MIN' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        'MAX' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        '%' ARFCDEST,
        '%' ARFCSTATE,
        '%' ARFCFNAM,
        '%' ARFCUSER,
        '%' ARFCMSG,
        'TIME' AGGREGATE_BY,           /* TIME, ARFCDEST, ARFCSTATE, ARFCFNAM, ARFCUSER, ARFCMSG or comma separated combinations, NONE for no aggregation */
        'YYYY/MM' TIME_AGGREGATE_BY,      /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'TIME' ORDER_BY                /* TIME, COUNT, ARFCNAM */
      FROM
        DUMMY
    )
  ) BI,
  ( SELECT
      TO_TIMESTAMP(S.ARFCDATUM || S.ARFCUZEIT, 'YYYYMMDDHH24MISS') ARFC_TIME,
      S.ARFCDEST,
      S.ARFCSTATE,
      S.ARFCFNAM,
      S.ARFCUSER,
      S.ARFCMSG,
      COUNT(*) CNT
    FROM
      ARFCSSTATE S,
      ARFCSDATA D
    WHERE
      S.ARFCIPID = D.ARFCIPID AND
      S.ARFCPID = D.ARFCPID AND
      S.ARFCTIME = D.ARFCTIME AND
      S.ARFCTIDCNT = D.ARFCTIDCNT AND
      S.ARFCDEST = D.ARFCDEST AND
      S.ARFCLUWCNT = D.ARFCLUWCNT
    GROUP BY
      S.ARFCDATUM,
      S.ARFCUZEIT,
      S.ARFCDEST,
      S.ARFCSTATE,
      S.ARFCFNAM,
      S.ARFCUSER,
      S.ARFCMSG
  ) A
  WHERE
    TO_VARCHAR(A.ARFC_TIME, 'YYYY/MM/DD HH24:MI:SS') BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    A.ARFCDEST LIKE BI.ARFCDEST AND
    A.ARFCSTATE LIKE BI.ARFCSTATE AND
    A.ARFCFNAM LIKE BI.ARFCFNAM AND
    A.ARFCUSER LIKE BI.ARFCUSER AND
    A.ARFCMSG LIKE BI.ARFCMSG
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), A.ARFC_TIME) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(A.ARFC_TIME, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ARFCDEST')  != 0 THEN A.ARFCDEST  ELSE MAP(BI.ARFCDEST,  '%', 'any', BI.ARFCDEST)  END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ARFCSTATE') != 0 THEN A.ARFCSTATE ELSE MAP(BI.ARFCSTATE, '%', 'any', BI.ARFCSTATE) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ARFCFNAM')  != 0 THEN A.ARFCFNAM  ELSE MAP(BI.ARFCFNAM,  '%', 'any', BI.ARFCFNAM)  END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ARFCUSER')  != 0 THEN A.ARFCUSER  ELSE MAP(BI.ARFCUSER,  '%', 'any', BI.ARFCUSER)  END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ARFCMSG')   != 0 THEN A.ARFCMSG   ELSE MAP(BI.ARFCMSG,   '%', 'any', BI.ARFCMSG)   END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'TIME', ARFCTIME) DESC,
  MAP(ORDER_BY, 'COUNT', CNT) DESC,
  ARFCFNAM
