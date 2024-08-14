SELECT

/* 

[NAME]

- HANA_SmartDataAccess_Sources_Statistics_1.00.100+

[DESCRIPTION]

- Overview of Smart Data Access (SDA) source statistics

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Smart Data Access was introduced with SAP HANA Rev. 1.00.60
- M_REMOTE_SOURCE_STATISTICS available with SAP HANA >= 1.0 SPS 10

[VALID FOR]

- Revisions:              >= 1.00.100

[SQL COMMAND VERSION]

- 2019/01/02:  1.0 (initial version)

[INVOLVED TABLES]

- M_REMOTE_SOURCE_STATISTICS

[INPUT PARAMETERS]

- REMOTE_SOURCE_NAME

  Name of SDA remote source

  'ABC123'        --> SDA remote source ABC123
  '0CRM%'         --> SDA remote sources starting with '0CRM'
  '%'             --> No restriction related to SDA remote source

- SUBSCRIPTION_NAME

  Subscription name

  'SUBSCRIPT_01'  --> Subscription with name SUBSCRIPT_01
  '%'             --> No restriction related to adapter names

- STATISTIC_NAME

  Source statistics name

  'Last Updated Time' --> Display information for statistics name 'Last Updated Time'
  '%'                 --> No restriction related to source statistics name

- SERVICE_NAME

  Service name

  'indexserver'   --> Specific service indexserver
  '%server'       --> All services ending with 'server'
  '%'             --> All services

- COMPONENT

  Component

  'APPLIER'       --> Display statistics for APPLIER component
  '%'             --> No restriction related to component

[OUTPUT PARAMETERS]
 
- REMOTE_SOURCE_NAME: Remote source name
- SUBSCRIPTION_NAME:  Subscription name
- STATISTIC_NAME:     Statistics name
- STATISTIC_VALUE:    Statistics value
- SERVICE_NAME:       Service name
- COMPONENT:          Component

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SOURCE_NAME|SUBSCRIPTION_NAME     |STATISTIC_NAME                                                                   |STATISTIC_VALUE                                                   |SERVICE_NAME|COMPONENT|
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|C11_DP     |                      |VM % max memory used                                                             |52.93                                                             |dpagent     |ADAPTER  |
|C11_DP     |                      |VM free memory                                                                   |1890192168                                                        |dpagent     |ADAPTER  |
|C11_DP     |                      |VM maximum memory                                                                |4015521792                                                        |dpagent     |ADAPTER  |
|C11_DP     |                      |VM memory usage                                                                  |2125329624                                                        |dpagent     |ADAPTER  |
|C11_DP     |                      |VM total memory allocated                                                        |4015521792                                                        |dpagent     |ADAPTER  |
|C11_DP     |SUBSCR_ACDOCA         |Count, for the subscription, of data records processed by Applier                |138440                                                            |dpserver    |APPLIER  |
|C11_DP     |SUBSCR_EKET           |Last applied timestamp, for the subscription                                     |2018-12-28 20:38:30.5184750                                       |dpserver    |APPLIER  |
|C11_DP     |SUBSCR_EKKO           |Last applied timestamp, for the subscription                                     |2018-12-28 20:38:50.4965250                                       |dpserver    |APPLIER  |
|C11_DP     |SUBSCR_EKPO           |Last applied timestamp, for the subscription                                     |2018-12-28 20:38:30.5184750                                       |dpserver    |APPLIER  |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  S.REMOTE_SOURCE_NAME,
  S.SUBSCRIPTION_NAME,
  S.STATISTIC_NAME,
  S.STATISTIC_VALUE,
  S.SERVICE_NAME,
  S.COMPONENT
FROM
( SELECT                   /* Modification section */
    '%' REMOTE_SOURCE_NAME,
    '%' SUBSCRIPTION_NAME,
    '%' STATISTIC_NAME,
    '%' SERVICE_NAME,
    '%' COMPONENT
  FROM
    DUMMY
) BI,
  M_REMOTE_SOURCE_STATISTICS S
WHERE
  UPPER(S.REMOTE_SOURCE_NAME) LIKE UPPER(BI.REMOTE_SOURCE_NAME) AND
  UPPER(S.SUBSCRIPTION_NAME) LIKE UPPER(BI.SUBSCRIPTION_NAME) AND
  UPPER(S.SERVICE_NAME) LIKE UPPER(BI.SERVICE_NAME) AND
  UPPER(S.COMPONENT) LIKE UPPER(BI.COMPONENT) AND
  UPPER(S.STATISTIC_NAME) LIKE UPPER(BI.STATISTIC_NAME)
ORDER BY
  S.REMOTE_SOURCE_NAME,
  S.SUBSCRIPTION_NAME,
  S.STATISTIC_NAME