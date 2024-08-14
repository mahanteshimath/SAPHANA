SELECT
/* 

[NAME]

- HANA_BW_DataTargets

[DESCRIPTION]

- Overview of BW data targets (e.g. infocube, DSO)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Information in table RSMDATASTATE_EXT is evaluated, so user needs to have permission to access this table
- SET SCHEMA may be required if user different from table owner is used, otherwise you may get an error like:

  [259] invalid table name: Could not find table/view RSMDATASTATE_EXT in schema <non_sap_schema>

- RECORDS value can be higher than the current number of records, because it also contains old, already deleted requests

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/04/28:  1.0 (initial version)

[INVOLVED TABLES]

- RSMDATASTATE_EXT

[INPUT PARAMETERS]

- DATA_TARGET

  Name of data target

  'ABC123'        --> Data target ABC123
  '0CRM%'         --> Data targets starting with '0CRM'
  '%'             --> No restriction related to data target

- DATA_TARGET_TYPE

  Type of data target

  'CUBE'          --> Infocube
  'ODSO'          --> DSO
  '%'             --> No restriction related to data target type


- MIN_REQUESTS

  Minimum threshold for number of requests in data target

  10000           --> Only show data targets with at least 10000 requests
  -1              --> No restriction related to request number

[OUTPUT PARAMETERS]
 
- DATA_TARGET:      Data target
- DATA_TARGET_TYPE: Type of data target
- REQUESTS:         Total number of requests
- RECORDS:          Total number of records (including already deleted records)

[EXAMPLE OUTPUT]

------------------------------------------------------
|DATA_TARGET  |DATA_TARGET_TYPE|REQUESTS|RECORDS     |
------------------------------------------------------
|/CPMB/ZTIYVAS|CUBE            |  154237| 12189232466|
|0CRM_MKTELM  |FLEX_M          |   16225|    15725505|
|FRINTO27     |ODSO            |   15439|      127700|
------------------------------------------------------

*/

  R.DTA DATA_TARGET,
  R.DTA_TYPE DATA_TARGET_TYPE,
  LPAD(R.REQUESTS_ALL, 8) REQUESTS,
  LPAD(R.RECORDS_ALL, 12) RECORDS
FROM
( SELECT                /* Modification section */
    '%' DATA_TARGET,
    '%' DATA_TARGET_TYPE,
    10000 MIN_REQUESTS
  FROM
    DUMMY
) BI,
  RSMDATASTATE_EXT R
WHERE
  R.DTA LIKE BI.DATA_TARGET AND
  R.DTA_TYPE LIKE BI.DATA_TARGET_TYPE AND
  ( BI.MIN_REQUESTS = -1 OR R.REQUESTS_ALL >= BI.MIN_REQUESTS )
ORDER BY
  R.REQUESTS_ALL DESC
