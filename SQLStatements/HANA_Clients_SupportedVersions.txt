SELECT

/* 

[NAME]

- HANA_Clients_SupportedVersions

[DESCRIPTION]

- Overview of supported SAP HANA client versions

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2016/12/03:  1.0 (initial version)

[INVOLVED TABLES]

- M_CLIENT_VERSIONS

[INPUT PARAMETERS]

- CLIENT_TYPE

  SAP HANA client product type

  'ABAP_FDA'    --> ABP_FDA client
  '%'           --> No restriction related to client type

[OUTPUT PARAMETERS]

- CLIENT_TYPE:         Client type
- RELEASE_DESCRIPTION: Release description
- MIN_VERSION:         Minimum supported version
- MAX_VERSION:         Maximum supported version

[EXAMPLE OUTPUT]

----------------------------------------------------------------
|CLIENT_TYPE       |RELEASE_DESCRIPTION|MIN_VERSION|MAX_VERSION|
----------------------------------------------------------------
|ABAP_FDA          |8.0                |          0|          0|
|InformationModeler|1.0                |          3|        170|
|bics              |1.0                |          1|          1|
----------------------------------------------------------------

*/

  C.CLIENT_TYPE,
  C.CLIENT_RELEASE_DESC RELEASE_DESCRIPTION,
  LPAD(C.MIN_VERSION, 11) MIN_VERSION,
  LPAD(C.MAX_VERSION, 11) MAX_VERSION
FROM
( SELECT                        /* Modification section */
    '%' CLIENT_TYPE
  FROM
    DUMMY
) BI,
  M_CLIENT_VERSIONS C
WHERE
  C.CLIENT_TYPE LIKE BI.CLIENT_TYPE
ORDER BY
  C.CLIENT_TYPE