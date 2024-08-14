SELECT

/* 

[NAME]

- HANA_XSC_Applications

[DESCRIPTION]

- Overview of deployed XS classic (XSC) applications

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2020/08/18:  1.0 (initial version)

[INVOLVED TABLES]

- M_XS_APPLICATIONS

[INPUT PARAMETERS]

- APPLICATION_NAME

  XSC application name

  'sap.hana.ide'  --> Specific XSC application sap.hana.ide
  'public%'       --> All XSC applications starting with 'public'
  '%'             --> No restriction related to XSC application name

- DELIVERY_UNIT

  Delivery unit

  'HANA_ADMIN'    --> Specific delivery unit HANA_ADMIN
  'HDC%'          --> All delivery units starting with 'HDC'
  '%'             --> No restriction related to delivery unit

- VENDOR

  Vendor name

  'sap.com'       --> Specific vendor sap.com
  'mycompany%'    --> All vendors with names starting with 'mycompany'
  '%'             --> No restriction related to vendor name

[OUTPUT PARAMETERS]

- APPLICATION_NAME: XSC application name
- DELIVERY_UNIT:    Delivery unit name
- VENDOR:           Vendor name
- VERSION:          XSC application version
- VERSION_SP:       XSC application support package
- VERSION_PATCH:    XSC application patch level

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------
|APPLICATION_NAME                          |DELIVERY_UNIT          |VENDOR |VERSION|VERSION_SP|VERSION_PATCH|
-------------------------------------------------------------------------------------------------------------
|sap.hana.xs.selfService.user              |HANA_XS_BASE           |sap.com|2      |5         |0            |
|sap.hana.xs.translationTool               |HANA_XS_BASE           |sap.com|2      |5         |0            |
|sap.hana.xs.ui                            |HANA_XS_BASE           |sap.com|2      |5         |0            |
|sap.hana.xs.wdisp.admin                   |HANA_XS_BASE           |sap.com|2      |5         |0            |
|sap.ui5.1                                 |SAPUI5_1               |sap.com|1      |28        |53           |
|sap.watt                                  |SAP_WATT               |sap.com|1      |11        |0            |
-------------------------------------------------------------------------------------------------------------

*/

  X.APPLICATION_NAME,
  X.DELIVERY_UNIT,
  X.VENDOR,
  X.VERSION,
  X.VERSION_SP,
  X.VERSION_PATCH
FROM
( SELECT                  /* Modification section */
    '%' APPLICATION_NAME,
    '%' DELIVERY_UNIT,
    '%' VENDOR
  FROM
    DUMMY
) BI,
  M_XS_APPLICATIONS X
WHERE
  X.APPLICATION_NAME LIKE BI.APPLICATION_NAME AND
  X.DELIVERY_UNIT LIKE BI.DELIVERY_UNIT AND
  X.VENDOR LIKE BI.VENDOR
ORDER BY
  X.APPLICATION_NAME,
  X.DELIVERY_UNIT,
  X.VENDOR