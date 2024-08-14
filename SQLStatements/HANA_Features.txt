SELECT
/* 

[NAME]

- HANA_Features

[DESCRIPTION]

- SAP HANA feature information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- With SAP HANA <= 2.00.037.07 and <= 2.00.047 a cancellation can result in a hanging thread and lock contention
  for mutex TRexUtils_FeatureInfoManager_Lock (SAP Note 1999998).

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/01/15:  1.0 (initial version)

[INVOLVED TABLES]

- M_FEATURES

[INPUT PARAMETERS]

- COMPONENT_NAME

  Component name

  'CALCENGINE'        --> Only show features related to CALCENGINE
  '%'                 --> No restriction by component

- FEATURE_NAME

  Feature name

  'HINT'              --> Only show information related to feature HINT
  '%'                 --> No restriction by feature
  
[OUTPUT PARAMETERS]

- COMPONENT_NAME:  Component name
- FEATURE_NAME:    Feature name
- FEATURE_VERSION: Feature version

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------
|COMPONENT_NAME            |FEATURE_NAME                    |FEATURE_VERSION|
-----------------------------------------------------------------------------
|SMART DATA ACCESS         |ADMINISTRATION                  |             1 |
|SQL                       |AUDIT POLICY                    |             5 |
|SQL                       |FUZZY SEARCH                    |             4 |
|SQL                       |GRAMMAR                         |             2 |
|SQL                       |HINT                            |             1 |
|SQL                       |PLAN VISUALIZER                 |            10 |
|SQL                       |TRIGGER                         |             1 |
|SQL                       |UNLOAD PRIORITY                 |             1 |
-----------------------------------------------------------------------------

*/

  F.COMPONENT_NAME,
  F.FEATURE_NAME,
  F.FEATURE_VERSION
FROM
  ( SELECT                            /* Modification section */
      '%' COMPONENT_NAME,
      '%' FEATURE_NAME
    FROM
      DUMMY
  ) BI,
  M_FEATURES F
WHERE
  UPPER(F.COMPONENT_NAME) LIKE UPPER(BI.COMPONENT_NAME) AND
  UPPER(F.FEATURE_NAME) LIKE UPPER(BI.FEATURE_NAME)
ORDER BY
  F.COMPONENT_NAME,
  F.FEATURE_NAME

