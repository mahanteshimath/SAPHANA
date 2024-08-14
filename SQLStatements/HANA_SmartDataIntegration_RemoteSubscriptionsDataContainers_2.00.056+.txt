SELECT

/*

[NAME]

- HANA_SmartDataIntegration_RemoteSubscriptionContainers_2.00.056+

[DESCRIPTION]

- Overview of Smart Data Integration (SDI) remote subscriptions data containers

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- See SAP Note 2400022 for more information related to SDI.
- REMOTE_SUBSCRIPTION_DATA_CONTAINERS available with SAP HANA >= 2.00.056
- REMOTE_SUBSCRIPTION_DATA_CONTAINERS.SUBSCRIPTION_NAME appears to be empty, so cannot be used at this time
- Maximum persistence size is defined with the following parameter (default: 10000000000 byte, i.e. 10 GB):

  dpserver.ini -> [persistence] -> receiver_data_store_max_store_size

- If limit is reached, error "Persistent data store is full" is raised (SAP Note 3065904)

[VALID FOR]

- Revisions:              >= 2.00.056

[SQL COMMAND VERSION]

- 2022/10/03:  1.0 (initial version)

[INVOLVED TABLES]

- REMOTE_SUBSCRIPTION_DATA_CONTAINERS

[INPUT PARAMETERS]

- REMOTE_SOURCE_NAME

  Name of SDI remote source 

  'RS_CFIN'        --> Remote source with name RS_CFIN
  '%EXT%'          --> All remote sources with names like '%EXT%'
  '%'              --> No restriction related to remote source name

- CONTENT_TYPE

  Data container content type

  'TRANSACTION'    --> Data containers with content type TRANSACTION
  '%'              --> No restriction related to data container content type

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'SOURCE'          --> Aggregation by remote source name
  'SOURCE, CONTENT' --> Aggregation by remote source name and content type
  'NONE'            --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'SIZE'          --> Sorting by size 
  'SOURCE'        --> Sorting by remote source name

[OUTPUT PARAMETERS]

- REMOTE_SOURCE: Remote source name
- CONTENT_TYPE:  Data container content type
- PERS_SIZE_MB:  Current persistence data size (MB)
- CNT:           Number of data containers

[EXAMPLE OUTPUT]

--------------------------------------------------------
|REMOTE_SOURCE|CONTENT_TYPE         |PERS_SIZE_MB|CNT  |
--------------------------------------------------------
|RS_CFIN      |COMMIT SEQUENCE GROUP|        3.52|    1|
|RS_CFIN      |TRANSACTION          |        1.35|  197|
|RS_CFIN_2    |COMMIT SEQUENCE GROUP|        0.86|    1|
|RS_CFIN_1    |COMMIT SEQUENCE GROUP|        0.59|    1|
|RS_CFIN_2    |TRANSACTION          |        0.30|   11|
|RS_CFIN_1    |TRANSACTION          |        0.04|    4|
|RS_CFIN      |SUBSCRIPTION INFO    |        0.00|    1|
|RS_CFIN_1    |SUBSCRIPTION INFO    |        0.00|    1|
|RS_CFIN_2    |SUBSCRIPTION INFO    |        0.00|    1|
|RS_CFIN_3    |COMMIT SEQUENCE GROUP|        0.00|    1|
|RS_CFIN_3    |SUBSCRIPTION INFO    |        0.00|    1|
--------------------------------------------------------

*/

  REMOTE_SOURCE,
  CONTENT_TYPE,
  LPAD(TO_DECIMAL(PERS_SIZE_MB, 10, 2), 12) PERS_SIZE_MB,
  LPAD(CNT, 5) CNT
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SOURCE')  != 0 THEN SC.REMOTE_SOURCE_NAME ELSE MAP(BI.REMOTE_SOURCE_NAME, '%', 'any', BI.REMOTE_SOURCE_NAME) END REMOTE_SOURCE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONTENT') != 0 THEN SC.CONTENT_TYPE       ELSE MAP(BI.CONTENT_TYPE,       '%', 'any', BI.CONTENT_TYPE)       END CONTENT_TYPE,
    SUM(SIZE) / 1024 / 1024 PERS_SIZE_MB,
    COUNT(*) CNT,
    BI.ORDER_BY
  FROM
  ( SELECT                /* Modification section */
      '%' REMOTE_SOURCE_NAME,
      '%' CONTENT_TYPE,
      'NONE' AGGREGATE_BY,         /* SOURCE, CONTENT or comma separated combinations, NONE for no aggregation */
      'SIZE' ORDER_BY              /* SOURCE, CONTENT, SIZE, COUNT */
    FROM
      DUMMY
  ) BI,
    REMOTE_SUBSCRIPTION_DATA_CONTAINERS SC
  WHERE
    IFNULL(SC.REMOTE_SOURCE_NAME, '') LIKE BI.REMOTE_SOURCE_NAME AND
    IFNULL(SC.CONTENT_TYPE, '') LIKE BI.CONTENT_TYPE
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SOURCE')  != 0 THEN SC.REMOTE_SOURCE_NAME ELSE MAP(BI.REMOTE_SOURCE_NAME, '%', 'any', BI.REMOTE_SOURCE_NAME) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONTENT') != 0 THEN SC.CONTENT_TYPE       ELSE MAP(BI.CONTENT_TYPE,       '%', 'any', BI.CONTENT_TYPE)       END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'SIZE', PERS_SIZE_MB, 'COUNT', CNT) DESC,
  MAP(ORDER_BY, 'SOURCE', REMOTE_SOURCE, 'CONTENT', CONTENT_TYPE),
  REMOTE_SOURCE,
  CONTENT_TYPE
