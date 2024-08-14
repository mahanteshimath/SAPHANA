SELECT
/* 

[NAME]

- HANA_License_Licenses

[DESCRIPTION]

- License usage information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_LICENSES available starting with SAP HANA 1.00.90

[VALID FOR]

- Revisions:              >= 1.00.90

[SQL COMMAND VERSION]

- 2018/03/20:  1.1 (initial version)

[INVOLVED TABLES]

- M_LICENSES

[INPUT PARAMETERS]

- GLAS_APPLICATION_ID

  GLAS application ID

  '000673'       --> GLAS application ID 000673 (SAP HANA database without BW)
  '%'            --> No restriction related to GLAS application ID

- APPLICATION_NAME

  Application name

  'Smart Data Integration' --> Smart data integration (SDA)
  '%'                      -- No restriction related to application name
    
[OUTPUT PARAMETERS]

- HARDWARE_KEY:        Hardware key
- SYSTEM_ID:           System ID
- INSTALL_NO:          Installation number
- SYSTEM_NO:           System number
- P:                   Permanent license ('X' -> permanent, '' -> temporary)
- V:                   License validity ('X' -> valid, '' -> not valid)
- GLAS_APPLICATION_ID: GLAS application ID
- APP_SHORT:           Application short name
- APPLICATION_NAME:    Application name
- LIMIT_DESCRIPTION:   Limit description
- LICENSE_LIMIT_GB:    License limit (GB)
- LICENSE_USAGE_GB:    License usage (GB)
- USAGE_PCT:           Percentage of license limit used
- START_DATE:          License start date
- EXPIRATION_DATE:     License expiration date

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|HARDWARE_KEY|SYSTEM_ID|INSTALL_NO|SYSTEM_NO         |P|V|GLAS_APPLICATION_ID|APP_SHORT   |APP_NAME                               |LIMIT_DESCRIPTION|LICENSE_LIMIT_GB|LICENSE_USAGE_GB|USAGE_PCT|START_DATE         |EXPIRATION_DATE    |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|D0366905xxx |C11      |0020540xxx|000000000312235xxx|X|X|000673             |SAP-HANA    |SAP HANA database                      |used memory in GB|             512|             220|    42.96|2014/12/14 00:00:00|                   |
|D0366905xxx |C11      |0020540xxx|000000000312235xxx| | |                   |SAP-HANA-EPM|Enterprise Performance Management (EPM)|                 |      2147483647|               0|     0.00|2015/01/23 00:00:00|2015/04/23 23:59:59|
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/
  L.HARDWARE_KEY,
  L.SYSTEM_ID,
  L.INSTALL_NO,
  L.SYSTEM_NO,
  MAP(L.PERMANENT, 'TRUE', 'X', '') P,
  MAP(L.VALID, 'TRUE', 'X', '') V,
  IFNULL(L.GLAS_APPLICATION_ID, '') GLAS_APPLICATION_ID,
  L.PRODUCT_NAME APP_SHORT,
  IFNULL(L.PRODUCT_DESCRIPTION, '') APPLICATION_NAME,
  L.PRODUCT_LIMIT_DESCRIPTION LIMIT_DESCRIPTION,
  LPAD(L.PRODUCT_LIMIT, 16) LICENSE_LIMIT_GB,
  LPAD(L.PRODUCT_USAGE, 16) LICENSE_USAGE_GB,
  LPAD(TO_DECIMAL(CASE WHEN L.PRODUCT_LIMIT = 0 THEN 0 ELSE L.PRODUCT_USAGE / L.PRODUCT_LIMIT * 100 END, 10, 2), 9) USAGE_PCT,
  TO_VARCHAR(L.START_DATE, 'YYYY/MM/DD HH24:MI:SS') START_DATE,
  IFNULL(TO_VARCHAR(L.EXPIRATION_DATE, 'YYYY/MM/DD HH24:MI:SS'), '') EXPIRATION_DATE
FROM
( SELECT                         /* Modification section */
    '%' GLAS_APPLICATION_ID,
    '%' APPLICATION_NAME
  FROM
    DUMMY
) BI,
  M_LICENSES L
WHERE
  IFNULL(L.GLAS_APPLICATION_ID, '') LIKE BI.GLAS_APPLICATION_ID AND
  L.PRODUCT_DESCRIPTION LIKE BI.APPLICATION_NAME
ORDER BY
  L.HARDWARE_KEY,
  L.SYSTEM_ID,
  L.INSTALL_NO,
  L.SYSTEM_NO