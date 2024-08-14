SELECT

/*

[NAME]

- HANA_SmartDataIntegration_RemoteSubscriptionStatistics_1.00.90+

[DESCRIPTION]

- Statistics of Smart Data Integration (SDI) remote subscriptions 

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Smart data integration and REMOTE_SUBSCRIPTION_STATISTICS available as of SAP HANA 1.0 SPS 09
- See SAP Note 2400022 for more information related to SDI.

[VALID FOR]

- Revisions:              >= 1.00.90

[SQL COMMAND VERSION]

- 2018/09/30:  1.0 (initial version)
- 2020/02/05:  1.1 (formula for APPLY_DELAY_S adjusted)

[INVOLVED TABLES]

- REMOTE_SUBSCRIPTION_STATISTICS

[INPUT PARAMETERS]

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- SUBSCRIPTION_NAME

  REMOTE_SUBSCRIPTION_NAME

  'RSUB_OBJK'     --> Specific remote subscription RSUB_OBJK
  '%'             --> No restriction related to remote subscriptions

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'DELAY'         --> Sorting by apply delay
  'RECEIVE_TIME'  --> Sorting by last receive time

[OUTPUT PARAMETERS]

- SCHEMA_NAME:       Schema name
- SUBSCRIPTION_NAME: Subscription name
- RECEIVED:          Received messages
- APPLIED:           Applied messages
- LAST_RECEIVE_TIME: Last message receive time
- LAST_APPLY_TIME:   Last message apply time
- APPLY_DELAY_S:     Message application delay
- REC_LATENCY:       Receiver latency
- APP_LATENCY:       Applier latency

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME|SUBSCRIPTION_NAME|RECEIVED|APPLIED     |REJECTED|LAST_RECEIVE_TIME  |LAST_APPLY_TIME    |APPLY_DELAY_S|REC_LATENCY_MS|APP_LATENCY_MS|
--------------------------------------------------------------------------------------------------------------------------------------------------
|DLSRC_SAP  |RSUB_MARA        |      26|      734126|       0|2018/09/30 09:14:14|2018/09/30 03:26:48|        25935|             0|             0|
|DLSRC_SAP  |RSUB_VBRP        |      63|     2515614|       0|2018/09/30 10:13:51|2018/09/30 05:54:55|        17048|             0|             0|
|DLSRC_SAP  |RSUB_VBRK        |      58|     1234682|       0|2018/09/30 10:13:51|2018/09/30 05:54:55|        17048|             0|             0|
|DLSRC_SAP  |RSUB_PA0105      |      29|     2654504|       0|2018/09/30 09:10:16|2018/09/30 05:54:56|        17047|             0|             0|
|DLSRC_SAP  |RSUB_PROJ        |      31|     2594028|       0|2018/09/30 07:23:07|2018/09/30 05:54:59|        17044|             0|             0|
|DLSRC_SAP  |RSUB_FPLT        |     100|      965856|       0|2018/09/30 10:13:51|2018/09/30 05:55:13|        17030|             0|             0|
|DLSRC_SAP  |RSUB_FPLA        |      53|     1292304|       0|2018/09/30 08:45:33|2018/09/30 05:55:13|        17030|             0|             0|
|DLSRC_SAP  |RSUB_KNVP        |     133|     2524223|       0|2018/09/30 10:27:37|2018/09/30 07:56:30|         9752|             0|             0|
|DLSRC_SAP  |RSUB_ADRC        |     253|     1245954|       0|2018/09/30 10:27:37|2018/09/30 07:56:33|         9750|             0|             0|
--------------------------------------------------------------------------------------------------------------------------------------------------

*/

  S.SCHEMA_NAME,
  S.SUBSCRIPTION_NAME,
  LPAD(S.RECEIVED_MESSAGE_COUNT, 8) RECEIVED,
  LPAD(S.APPLIED_MESSAGE_COUNT, 12) APPLIED,
  LPAD(S.REJECTED_MESSAGE_COUNT, 8) REJECTED,
  IFNULL(TO_VARCHAR(S.LAST_MESSAGE_RECEIVED, 'YYYY/MM/DD HH24:MI:SS'), '') LAST_RECEIVE_TIME,
  IFNULL(TO_VARCHAR(S.LAST_MESSAGE_APPLIED, 'YYYY/MM/DD HH24:MI:SS'), '') LAST_APPLY_TIME,
  LPAD(CASE WHEN S.LAST_MESSAGE_APPLIED IS NULL THEN 0
            WHEN S.LAST_MESSAGE_APPLIED > S.LAST_MESSAGE_RECEIVED THEN 0
            WHEN S.LAST_MESSAGE_RECEIVED IS NULL THEN 0
            ELSE SECONDS_BETWEEN(S.LAST_MESSAGE_APPLIED, S.LAST_MESSAGE_RECEIVED)
        END , 13) APPLY_DELAY_S,
  LPAD(TO_DECIMAL(RECEIVER_LATENCY / 1000, 10, 0), 14) REC_LATENCY_MS,
  LPAD(TO_DECIMAL(APPLIER_LATENCY / 1000, 10, 0), 14) APP_LATENCY_MS
FROM
( SELECT            /* Modification section */
    '%' SCHEMA_NAME,
    '%' SUBSCRIPTION_NAME,
    'DELAY' ORDER_BY     /* RECEIVED, APPLIED, DELAY, RECEIVE_TIME, APPLY_TIME */
  FROM
    DUMMY
) BI,
  M_REMOTE_SUBSCRIPTION_STATISTICS S
WHERE
  S.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  S.SUBSCRIPTION_NAME LIKE BI.SUBSCRIPTION_NAME
ORDER BY
  MAP(BI.ORDER_BY, 
    'COUNT',   S.RECEIVED_MESSAGE_COUNT, 
    'APPLIED', S.APPLIED_MESSAGE_COUNT, 
    'DELAY',   CASE WHEN S.LAST_MESSAGE_APPLIED IS NULL THEN 0
                 WHEN S.LAST_MESSAGE_APPLIED > S.LAST_MESSAGE_RECEIVED THEN 0
                 WHEN S.LAST_MESSAGE_RECEIVED IS NULL THEN 0
                 ELSE SECONDS_BETWEEN(S.LAST_MESSAGE_APPLIED, S.LAST_MESSAGE_RECEIVED)
               END,
    'RECEIVE_TIME', IFNULL(TO_VARCHAR(S.LAST_MESSAGE_RECEIVED, 'YYYY/MM/DD HH24:MI:SS'), ''),
    'APPLY_TIME', IFNULL(TO_VARCHAR(S.LAST_MESSAGE_APPLIED, 'YYYY/MM/DD HH24:MI:SS'), '')
  ) DESC
