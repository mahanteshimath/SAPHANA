SELECT
/* 

[NAME]

- HANA_Tables_TablePlacement

[DESCRIPTION]

- Table placement information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Table placement is a basis for landscape redistributions (SAP Note 1908075)

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2016/01/18:  1.0 (initial version)

[INVOLVED TABLES]

- TABLE_PLACEMENT

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

- GROUP_NAME         

  Group type or pattern

  'BW_CUBE'       --> Specific table group type BW_CUBE
  'sap.bw%'       --> All table group types starting with 'sap.bw'
  '%'             --> All table group types

[OUTPUT PARAMETERS]

- SCHEMA_NAME:     Schema name
- TABLE_NAME:      Table name
- GROUP_NAME:      Table group name
- GROUP_TYPE:      Table group type
- SUBTYPE:         Table group subtype
- MIN_PART_ROWS:   Minimum number of table rows for partitioning
- INI_PARTS:       Initial number of partitions
- PART_THRES:      Number of rows for table repartitioning
- LOCATION:        Table location
- DYN_RANGE_THRES: Threshold for dynamic range partitioning

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME|TABLE_NAME|GROUP_NAME|GROUP_TYPE               |SUBTYPE|MIN_PART_ROWS|INI_PARTS|PART_THRES|LOCATION|DYN_RANGE_THRES|
---------------------------------------------------------------------------------------------------------------------------------
|           |          |          |                         |       |   2000000000|        3|2000000000|slave   |               |
|SAPSR3     |          |          |                         |       |   2000000000|        2|2000000000|all#1   |               |
|SAPSR3     |          |          |sap.join                 |       |   2000000000|        2|2000000000|all#1   |               |
|SAPSR3     |          |          |sap.join.pinned_to_master|       |   2000000000|        2|2000000000|master  |               |
---------------------------------------------------------------------------------------------------------------------------------

*/

  TP.SCHEMA_NAME,
  TP.TABLE_NAME,
  TP.GROUP_NAME,
  TP.GROUP_TYPE,
  TP.SUBTYPE,
  LPAD(TP.MIN_ROWS_FOR_PARTITIONING, 13) MIN_PART_ROWS,
  LPAD(TP.INITIAL_PARTITIONS, 9) INI_PARTS,
  LPAD(TP.REPARTITIONING_THRESHOLD, 10) PART_THRES,
  TP.LOCATION,
  LPAD(TP.DYNAMIC_RANGE_THRESHOLD, 15) DYN_RANGE_THRES
FROM
( SELECT            /* Modification section */
    '%' SCHEMA_NAME,
    '%' TABLE_NAME,
    '%' GROUP_NAME,
    '%' GROUP_TYPE
  FROM
    DUMMY
) BI,
  TABLE_PLACEMENT TP
WHERE
  TP.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  TP.TABLE_NAME LIKE BI.TABLE_NAME AND
  TP.GROUP_NAME LIKE BI.GROUP_NAME AND
  TP.GROUP_TYPE LIKE BI.GROUP_TYPE
ORDER BY
  TP.SCHEMA_NAME,
  TP.TABLE_NAME,
  TP.GROUP_NAME,
  TP.GROUP_TYPE,
  TP.SUBTYPE