SELECT
/* 

[NAME]

- HANA_Tables_TableGroups

[DESCRIPTION]

- Table group information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Table groups are a basis for table redistribution because they make sure that tables belonging to the
  same group are located on the same SAP HANA node

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2016/01/14:  1.0 (initial version)

[INVOLVED TABLES]

- TABLE_GROUPS

[INPUT PARAMETERS]

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- TABLE_NAME         

  Table name or pattern

  'T000'          --> Specific table T000
  'T%'            --> All tables starting with 'T'
  '%'             --> All tables

- GROUP_NAME         

  Group name or pattern

  '0ATR_DS01'     --> Specific table group 0ATR_DS01
  'T%'            --> All table groups starting with 'T'
  '%'             --> All table groups

[OUTPUT PARAMETERS]

- SCHEMA_NAME:    Schema name
- TABLE_NAME:     Table name
- GROUP_NAME:     Table group name
- GROUP_TYPE:     Table group type
- SUBTYPE:        Table group subtype

[EXAMPLE OUTPUT]

------------------------------------------------------------
|SCHEMA_NAME|TABLE_NAME      |GROUP_NAME|GROUP_TYPE|SUBTYPE|
------------------------------------------------------------
|SAPSR3     |/BIC/AZCHKPHS00 |ZCHKPHS   |sap.bw.dso|ACTIVE |
|SAPSR3     |/BIC/AZCHKPHS40 |ZCHKPHS   |sap.bw.dso|QUEUE  |
|SAPSR3     |/BIC/AZCNREP0100|ZCNREP01  |sap.bw.dso|ACTIVE |
|SAPSR3     |/BIC/AZCNREP0140|ZCNREP01  |sap.bw.dso|QUEUE  |
|SAPSR3     |/BIC/AZCPOAO0100|ZCPOAO01  |sap.bw.dso|ACTIVE |
|SAPSR3     |/BIC/AZCPOAO0140|ZCPOAO01  |sap.bw.dso|QUEUE  |
|SAPSR3     |/BIC/AZCPOAO0200|ZCPOAO02  |sap.bw.dso|ACTIVE |
|SAPSR3     |/BIC/AZCPOAO0240|ZCPOAO02  |sap.bw.dso|QUEUE  |
------------------------------------------------------------

*/

  TG.SCHEMA_NAME,
  TG.TABLE_NAME,
  TG.GROUP_NAME,
  TG.GROUP_TYPE,
  TG.SUBTYPE
FROM
( SELECT            /* Modification section */
    '%' SCHEMA_NAME,
    '%' TABLE_NAME,
    '%' GROUP_NAME
  FROM
    DUMMY
) BI,
  TABLE_GROUPS TG
WHERE
  TG.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  TG.TABLE_NAME LIKE BI.TABLE_NAME AND
  TG.GROUP_NAME LIKE BI.GROUP_NAME
ORDER BY
  TG.SCHEMA_NAME,
  TG.TABLE_NAME,
  TG.GROUP_NAME,
  TG.GROUP_TYPE,
  TG.SUBTYPE