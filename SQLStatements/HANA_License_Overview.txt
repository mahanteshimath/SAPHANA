SELECT
/* 

[NAME]

- HANA_License_Overview

[DESCRIPTION]

- License information overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Fails in SAP HANA Cloud (SHC) environments because license checks, limits and usage details are irrelevant:

  invalid column name: PRODUCT_USAGE

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/07/02:  1.0 (initial version)
- 2018/01/25:  1.1 (switch from M_LICENSE to M_LICENSES)

[INVOLVED TABLES]

- M_LICENSE

[INPUT PARAMETERS]


[OUTPUT PARAMETERS]

- HARDWARE_KEY:     Hardware key
- SID:              System ID
- INSTALL_NO:       Installation number
- PRODUCT_LIMIT_GB: License limit (GB)
- PRODUCT_USAGE_GB: Used memory peak (GB)
- EXPIRATION_DATE:  License expiration date
- EXP_DAYS:         Number of days until license expiration
- PERMANENT:        TRUE for permanent license, otherwise FALSE

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------
|HARDWARE_KEY|SID|INSTALL_NO|PRODUCT_LIMIT_GB|PRODUCT_USAGE_GB|EXPIRATION_DATE|EXP_DAYS|PERMANENT|
--------------------------------------------------------------------------------------------------
|R1009528279 |PRD|0020319547|            4000|            3000|               |        |TRUE     |
--------------------------------------------------------------------------------------------------

*/

  HARDWARE_KEY,
  SYSTEM_ID SID,
  INSTALL_NO,
  IFNULL(GLAS_APPLICATION_ID, '') GLAS_APPLICATION_ID,
  PRODUCT_NAME,
  PRODUCT_DESCRIPTION,
  LPAD(PRODUCT_LIMIT, 16) PRODUCT_LIMIT_GB,
  LPAD(PRODUCT_USAGE, 16) PRODUCT_USAGE_GB,
  IFNULL(TO_VARCHAR(EXPIRATION_DATE, 'YYYY/MM/DD HH24:MI:SS'), '') EXPIRATION_DATE,
  IFNULL(LPAD(DAYS_BETWEEN(CURRENT_DATE, EXPIRATION_DATE), 8), '') EXP_DAYS,
  PERMANENT,
  VALID
FROM
  M_LICENSES