SELECT

/*

[NAME]

- HANA_SmartDataIntegration_RemoteSubscriptions_1.00.90+

[DESCRIPTION]

- Overview of Smart Data Integration (SDI) remote subscriptions 

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- See SAP Note 2400022 for more information related to SDI.

[VALID FOR]

- Revisions:              >= 1.00.90

[SQL COMMAND VERSION]

- 2021/02/28:  1.0 (initial version)

[INVOLVED TABLES]

- M_REMOTE_SUBSCRIPTIONS

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

- TIMEZONE

  Used timezone (both for input and output parameters)

  'SERVER'       --> Display times in SAP HANA server time
  'UTC'          --> Display times in UTC time

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- SUBSCRIPTION_NAME

  Remote subscription name

  'SUB_BSEG'      --> Remote subscriptions with name SUB_BSEG
  '%MSEG%'        --> Remote subscriptions with names containing 'MSEG'
  '%'             --> No restriction related to subscription name  

- REMOTE_SOURCE_NAME

  Name of SDI remote source 

  'RS_CFIN'        --> Remote source with name RS_CFIN
  '%EXT%'          --> All remote sources with names like '%EXT%'
  '%'              --> No restriction related to remote source name

- STATE

  Remote subscription state

  'APPLY_CHANGE_DATA' --> Remote subscriptions in state APPLY_CHANGE_DATA
  '%'                 --> No restriction related to remote subscription state

- REMOTE_SUBSCRIPTION

  Remote subscription object

  '"SAPC11"."KNB1"'   --> Remote subscription for object "SAPC11"."KNB1"
  '%'                 --> No restriction related to remote subscription object

- STATEMENT_HASH      
 
  Hash related to remote subscription execution

  '2e960d7535bf4134e2bd26b9d80bd4fa' --> Remote subscriptions using statement hash '2e960d7535bf4134e2bd26b9d80bd4fa'
  '%'                                --> No statement hash restriction

[OUTPUT PARAMETERS]

- SCHEMA_NAME:         Schema name
- REMOTE_SOURCE:       Remote source
- REMOTE_SUBSCRIPTION: Remote subscription (<schema>.<table>)
- STATE:               Remote subscription state (SAP Note 2709754)
- LAST_ACTIVE_TIME:    Last active time
- STATEMENT_HASH:      Statement hash
- SUBSCRIPTION_NAME:   Subscription name

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME|REMOTE_SOURCE|REMOTE_SUBSCRIPTION          |STATE            |LAST_ACTIVE_TIME   |STATEMENT_HASH                  |SUBSCRIPTION_NAME                                                                                  |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SDI        |ERP          |"SAPECC"."QALS"              |APPLY_CHANGE_DATA|2021/02/28 07:58:34|adde32f9dedafbf98cb05563807fd206|Abc.Rel.QM.REALTIME::REP_WITHCDC_QALS_ECC_01.SUB_VTSAPECC_QALS                                     |
|SDI        |ERP          |"SAPECC"."QAVE"              |APPLY_CHANGE_DATA|2021/02/28 07:58:34|daf9c3dded8a2ea2cae3887622c274fc|Abc.Rel.QM.REALTIME::REP_WITHCDC_QAVE_ECC_01.SUB_VTSAPECC_QAVE                                     |
|SDI        |ERP          |"SAPECC"."TJ02T"             |APPLY_CHANGE_DATA|2021/02/28 07:58:34|ae933f14f95f1c9baf2af2048bbdca00|Abc.Rel.QM.REALTIME.REP_TASK::REP_WITHCDC_TJ02T_ECC_01.SUB_VTSAPECC_TJ02T                          |
|SDI        |ERP          |"SAPECC"."TJ30T"             |APPLY_CHANGE_DATA|2021/02/28 07:58:34|0167f2e93bb2ece1c1e90da16b5665a7|Abc.Rel.QM.REALTIME.REP_TASK::REP_WITHCDC_TJ30T_ECC_01.SUB_VTSAPECC_TJ30T                          |
|SDI        |EWM          |"SAPABAP1"."/LIME/NQUAN"     |APPLY_CHANGE_DATA|2021/02/28 07:58:56|5450c47693be2f8d603f2f564eb738b8|Abc.Rel.EWM.REALTIME.REP_TASK::REP_WITHCDC_NQUAN_EWM_01.SUB_VT_SAPABAP1_LIME_NQUAN                 |
|SDI        |EWM          |"SAPABAP1"."/LIME/NTREE"     |APPLY_CHANGE_DATA|2021/02/28 07:58:56|eb14f1031ee4dae2d6cf4a57122469f6|Abc.Rel.EWM.REALTIME.REP_TASK::REP_WITHCDC_NTREE_EWM_01.SUB_VT_SAPABAP1_LIME_NTREE                 |
|SDI        |EWM          |"SAPABAP1"."/SAPAPO/MATKEY"  |APPLY_CHANGE_DATA|2021/02/28 07:57:04|c3f258b90faccce08fc7813575c7e484|Abc.Rel.EWM.REALTIME.REP_TASK::REP_WITHCDC_MATKEY_EWM_01.SUB_VT_SAPABAP1_SAPAPO_MATKEY             |
|SDI        |EWM          |"SAPABAP1"."/SCDL/DB_PROCH_I"|APPLY_CHANGE_DATA|2021/02/28 07:57:04|b0439076990b6ad791f36327823d5493|Abc.Rel.EWM.REALTIME.REP_TASK::REP_WITHCDC_DB_PROCH_I_EWM_01.SUB_VT_SAPABAP1_SCDL_DB_PROCH_I       |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  IFNULL(S.SCHEMA_NAME, '') SCHEMA_NAME,
  IFNULL(S.REMOTE_SOURCE_NAME, '') REMOTE_SOURCE,
  IFNULL(S.REMOTE_SUBSCRIPTION, '') REMOTE_SUBSCRIPTION,
  IFNULL(S.STATE, '') STATE,
  TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(S.LAST_PROCESSED_TRANSACTION_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE S.LAST_PROCESSED_TRANSACTION_TIME END, 'YYYY/MM/DD HH24:MI:SS') LAST_ACTIVE_TIME,
  IFNULL(S.OPTIMIZED_QUERY_HASH, '') STATEMENT_HASH,
  IFNULL(S.SUBSCRIPTION_NAME, '') SUBSCRIPTION_NAME
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
    TIMEZONE,
    SCHEMA_NAME,
    SUBSCRIPTION_NAME,
    REMOTE_SOURCE_NAME,
    STATE,
    REMOTE_SUBSCRIPTION,
    STATEMENT_HASH
  FROM
  ( SELECT                /* Modification section */
      '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
      '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
      'SERVER' TIMEZONE,                              /* SERVER, UTC */
      '%' SCHEMA_NAME,
      '%' SUBSCRIPTION_NAME,
      '%' REMOTE_SOURCE_NAME,
      '%' STATE,
      '%' REMOTE_SUBSCRIPTION,
      '%' STATEMENT_HASH
    FROM
      DUMMY
  )
) BI,
  M_REMOTE_SUBSCRIPTIONS S
WHERE
  CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(S.LAST_PROCESSED_TRANSACTION_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE S.LAST_PROCESSED_TRANSACTION_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
  IFNULL(S.SCHEMA_NAME, '') LIKE BI.SCHEMA_NAME AND
  IFNULL(S.SUBSCRIPTION_NAME, '') LIKE BI.SUBSCRIPTION_NAME AND
  IFNULL(S.REMOTE_SOURCE_NAME, '') LIKE BI.REMOTE_SOURCE_NAME AND
  IFNULL(S.STATE, '') LIKE BI.STATE AND
  IFNULL(S.REMOTE_SUBSCRIPTION, '') LIKE BI.REMOTE_SUBSCRIPTION AND
  IFNULL(S.OPTIMIZED_QUERY_HASH, '') LIKE BI.STATEMENT_HASH
ORDER BY
  S.SCHEMA_NAME,
  S.REMOTE_SOURCE_NAME,
  S.REMOTE_SUBSCRIPTION