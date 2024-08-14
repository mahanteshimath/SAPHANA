SELECT

/* 

[NAME]

- HANA_BW_DSOTypes

[DESCRIPTION]

- BW DSO tables

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- SET SCHEMA may be required if user different from table owner is used, otherwise you may get an error like:

  [259] invalid table name: Could not find table/view RSODSO in schema <non_sap_schema>

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2016/03/16:  1.0 (initial version)

[INVOLVED TABLES]

- RSDODSO

[INPUT PARAMETERS]

- ODSOBJECT: ODS object name
- OBJVERS:   Object version

[OUTPUT PARAMETERS]

- STANDARD_DSO:       Number of standard DSOs
- HANA_OPTIMIZED_DSO: Number of HANA optimized DSOs

[EXAMPLE OUTPUT]

---------------------------------
|STANDARD_DSO|HANA_OPTIMIZED_DSO|
---------------------------------
|         144|               130|
---------------------------------

*/

  LPAD(SUM(CASE WHEN ODSOTYPE = '' THEN 1 ELSE 0 END), 12) STANDARD_DSO,
  LPAD(SUM(CASE WHEN ODSOTYPE = '' AND IMOFL = 'X' THEN 1 ELSE 0 END), 18) HANA_OPTIMIZED_DSO
FROM
( SELECT          /* Modification section */
    '%' ODSOBJECT,
    'A' OBJVERS
  FROM
    DUMMY
) BI,
  RSDODSO O
WHERE
  O.OBJVERS = BI.OBJVERS AND
  ( SUPERTLOGO = '' OR SUPERTLOGO = 'ODSO' )


