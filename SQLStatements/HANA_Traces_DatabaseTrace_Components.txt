SELECT

/* 

[NAME]

- HANA_Traces_DatabaseTrace_Components

[DESCRIPTION]

- Overview of available components / trace topics for database trace

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Exceeding 2047 configured components can result in crash (issue number 262519)

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2021/01/24:  1.0 (initial version)

[INVOLVED TABLES]

- M_SERVICE_TRACES

[INPUT PARAMETERS]

- SERVICE_NAME

  Service name

  'indexserver'   --> Specific service indexserver
  '%server'       --> All services ending with 'server'
  '%'             --> All services  

- COMPONENT_NAME

  Name of trace component (trace topic)

  'Basis'         --> Display information for component Basis
  'TRex%'         --> Display information for all components starting with 'TRex'
  '%'             --> No restriction related to component

- MIN_COMPONENTS

  Minimum number of components to be displayed

  1500            --> Only display result lines with at least 1500 components
  -1              --> No restriction related to number of components

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'SERVICE'            --> Aggregation by service
  'SERVICE, COMPONENT' --> Aggregation by service and component
  'NONE'               --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'COMPONENT'     --> Sorting by component / trace topic
  'COUNT'         --> Sorting by number of components

[OUTPUT PARAMETERS]

- MODIFICATION_TIME: Last modification time of file
- HOST:              Host name
- FILE_NAME:         File name
- NUM_FILES:         Number of trace files
- FILE_SIZE_KB:      Size of files (in KB)
- FILE_SIZE_PCT:     Percentage of file size compared to overall size
- CLEANUP_COMMAND:   SAP HANA SQL command to clean up file

[EXAMPLE OUTPUT]

---------------------------------------------
|SERVICE_NAME|COMPONENT_NAME          |COUNT|
---------------------------------------------
|indexserver |abapstream              |    1|
|indexserver |ae_accessor_callback    |    1|
|indexserver |ae_btree                |    1|
|indexserver |ae_btree_statistic      |    1|
|indexserver |ae_case_insensitive_sort|    1|
|indexserver |ae_deltacontainer       |    1|
|indexserver |ae_getvalues            |    1|
|indexserver |ae_pin                  |    1|
|indexserver |ae_querystats           |    1|
|indexserver |aetext                  |    1|
---------------------------------------------

*/

  SERVICE_NAME,
  COMPONENT_NAME,
  LPAD(CNT, 5) COUNT
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE')   != 0 THEN C.SERVICE_NAME   ELSE MAP(BI.SERVICE_NAME,   '%', 'any', BI.SERVICE_NAME)   END SERVICE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COMPONENT') != 0 THEN C.COMPONENT_NAME ELSE MAP(BI.COMPONENT_NAME, '%', 'any', BI.COMPONENT_NAME) END COMPONENT_NAME,
    COUNT(*) CNT,
    BI.MIN_COMPONENTS,
    BI.ORDER_BY
  FROM
  ( SELECT                 /* Modification section */
      '%' SERVICE_NAME,
      '%' COMPONENT_NAME,
      1500 MIN_COMPONENTS,
      'SERVICE' AGGREGATE_BY,              /* SERVICE, COMPONENT or comma separated combinations, NONE for no aggregation */
      'COUNT' ORDER_BY                     /* SERVICE, COMPONENT, COUNT */
    FROM
      DUMMY
  ) BI,
    M_SERVICE_TRACES C
  WHERE
    C.SERVICE_NAME LIKE BI.SERVICE_NAME AND
    C.COMPONENT_NAME LIKE BI.COMPONENT_NAME
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE')   != 0 THEN C.SERVICE_NAME   ELSE MAP(BI.SERVICE_NAME,   '%', 'any', BI.SERVICE_NAME)   END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COMPONENT') != 0 THEN C.COMPONENT_NAME ELSE MAP(BI.COMPONENT_NAME, '%', 'any', BI.COMPONENT_NAME) END,
    BI.MIN_COMPONENTS,
    BI.ORDER_BY
)
WHERE
  MIN_COMPONENTS = -1 OR CNT >= MIN_COMPONENTS
ORDER BY
  MAP(ORDER_BY, 'SERVICE', SERVICE_NAME || COMPONENT_NAME, 'COMPONENT', COMPONENT_NAME || SERVICE_NAME),
  COUNT DESC
