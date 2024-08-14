SELECT

/* 

[NAME]

- HANA_ABAP_Users

[DESCRIPTION]

- Overview of ABAP users

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Tables ADCP, ADRC, ADRP, ADR3, ADR6 and USR21 only available in SAP ABAP environments
- You have to be connected to the SAP<sid> schema otherwise the following error is issued:

  [259]: invalid table name: Could not find table/view ADCP / ADRC / ADRP / ADR3 / ADR6 / USR21 in schema

- If access to ABAP objects is possible but you cannot log on as ABAP user, you can switch the default schema before executing the command:

  SET SCHEMA SAP<sid>

[VALID FOR]

- Revisions:              all
- Client application:     ABAP

[SQL COMMAND VERSION]

- 2022/04/08:  1.0 (initial version)
- 2022/05/11:  1.1 (TEL_EXTENS and FAX_EXTENS added)

[INVOLVED TABLES]

- ADCP
- ADRC
- ADRP
- ADR6
- USR21

[INPUT PARAMETERS]

- CLIENT

  ABAP client

  '100'              --> Restrict result to users in ABAP client 100
  '%'                --> No limitation in terms of ABAP client

- APP_USER

  ABAP application user name

  'MUSTERMANN'       --> Restrict result to ABAP application user MUSTERMANN
  '%'                --> No limitation in terms of ABAP application user name

- LAST_NAME

  Last name of ABAP user

  'Mustermann'       --> Restrict result to ABAP application users with last name Mustermann
  '%'                --> No limitation in terms of last name of ABAP application user

- FIRST_NAME

  First name of ABAP user

  'Max'              --> Restrict result to ABAP application users with first name Max
  '%'                --> No limitation in terms of last name of ABAP application user

- E_MAIL

  E-mail address of ABAP user

  'max.mustermann@sap.com' --> Restrict result to ABAP application user with e-mail address max.mustermann@sap.com
  '%@sap.com'              --> Restrict result to ABAP application users with e-mail of domain 'sap.com'
  '%'                      --> No limitation in terms of e-mail address of ABAP application user

- COMPANY_NAME

  Company name of ABAP user

  'SAP SE'           --> Restrict result to ABAP application users with company SAP SE
  '%'                --> No restriction related to company name of ABAP application users

- COMPANY_STREET

  Company street (incl. house number) of ABAP user

  'Musterstr. 1'     --> Restrict result to ABAP application users with company street 'Musterstr. 1'
  '%'                --> No restriction related to company street of ABAP application users

- COMPANY_CITY

  Company city (incl. post code) of ABAP user

  '69190 Walldorf'   --> Restrict result to ABAP application users with company city '69190 Walldorf'
  '%'                --> No restriction related to company city of ABAP application users

- PHONE_NUMBER

  Phone number (<number> - <extension>)

  '+49 12345678'     --> Restrict result to ABAP application users with phone number '+49 12345678'
  '%'                --> No restriction related to phone number of ABAP application users

- FAX_NUMBER

  Fax number (<number> - <extension>)

  '+49 12345678'     --> Restrict result to ABAP application users with fax number '+49 12345678'
  '%'                --> No restriction related to fax number of ABAP application users

[OUTPUT PARAMETERS]

- APP_USER:       ABAP application user name
- CLIENT:         ABAP client
- LAST_NAME:      Last name
- FIRST_NAME:     First name
- E_MAIL:         E-mail address
- COMPANY_NAME:   Company name
- COMPANY_STREET: Company street (+ house number)
- COMPANY_CITY:   Company city (+ post code)
- COUNTRY:        Country code
- PHONE_NUMBER:   Phone number
- FAX_NUMBER:     Fax number

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|CLIENT|APP_USER    |LAST_NAME   |FIRST_NAME|E_MAIL                     |COMPANY_NAME              |COMPANY_STREET         |COMPANY_CITY        |COUNTRY|PHONE_NUMBER|FAX_NUMBER|
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|   000|EXT_MFRAUEND|FRAUENDORFER|Martin    |martin.frauendorfer@sap.com|SAP SE                    |Dietmar-Hopp-Allee 16  |69190 Walldorf      |DE     |            |          |
|   010|EXT_MFRAUEND|FRAUENDORFER|Martin    |martin.frauendorfer@sap.com|SAP SE                    |Dietmar-Hopp-Allee 16  |69190 Walldorf      |DE     |            |          |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  U21.BNAME APP_USER,
  LPAD(U21.MANDT, 6) CLIENT,
  AP.NAME_LAST LAST_NAME,
  AP.NAME_FIRST FIRST_NAME,
  LOWER(A6.SMTP_ADDR) E_MAIL,
  AC.NAME1 COMPANY_NAME,
  AC.STREET || CHAR(32) || AC.HOUSE_NUM1 COMPANY_STREET,
  AC.POST_CODE1 || CHAR(32) || AC.CITY1 COMPANY_CITY,
  AC.COUNTRY,
  AP2.TEL_NUMBER || MAP(AP2.TEL_EXTENS, '', '', CHAR(32) || '-' || CHAR(32) || AP2.TEL_EXTENS) PHONE_NUMBER,
  AP2.FAX_NUMBER || MAP(AP2.FAX_EXTENS, '', '', CHAR(32) || '-' || CHAR(32) || AP2.FAX_EXTENS) FAX_NUMBER
FROM
( SELECT                     /* Modification section */
    '%' CLIENT,
    '%' APP_USER,
    '%' LAST_NAME,
    '%' FIRST_NAME,
    '%' E_MAIL,
    '%' COMPANY_NAME,
    '%' COMPANY_STREET,
    '%' COMPANY_CITY,
    '%' COUNTRY,
    '%' PHONE_NUMBER,
    '%' FAX_NUMBER
  FROM
    DUMMY
) BI INNER JOIN
  USR21 U21 ON
    U21.MANDT LIKE BI.CLIENT AND
    U21.BNAME LIKE BI.APP_USER LEFT OUTER JOIN
  ADRC AC ON
    AC.CLIENT = U21.MANDT AND
    AC.ADDRNUMBER = U21.ADDRNUMBER LEFT OUTER JOIN
  ADRP AP ON
    AP.CLIENT = U21.MANDT AND
    AP.PERSNUMBER = U21.PERSNUMBER LEFT OUTER JOIN
  ADR6 A6 ON
    A6.CLIENT = U21.MANDT AND
    A6.ADDRNUMBER = U21.ADDRNUMBER AND
    A6.PERSNUMBER = U21.PERSNUMBER LEFT OUTER JOIN
  ADCP AP2 ON
    AP2.CLIENT = U21.MANDT AND
    AP2.ADDRNUMBER = U21.ADDRNUMBER AND
    AP2.PERSNUMBER = U21.PERSNUMBER
WHERE
  IFNULL(UPPER(AC.STREET || CHAR(32) || AC.HOUSE_NUM1), '') LIKE UPPER(BI.COMPANY_STREET) AND
  IFNULL(UPPER(AC.POST_CODE1 || CHAR(32) || AC.CITY1), '') LIKE UPPER(BI.COMPANY_CITY) AND
  IFNULL(AC.COUNTRY, '') LIKE BI.COUNTRY AND
  IFNULL(UPPER(AC.NAME1), '') LIKE UPPER(BI.COMPANY_NAME) AND
  IFNULL(UPPER(AP.NAME_LAST), '') LIKE UPPER(BI.LAST_NAME) AND
  IFNULL(UPPER(AP.NAME_FIRST), '') LIKE UPPER(BI.FIRST_NAME) AND
  IFNULL(UPPER(A6.SMTP_ADDR), '') LIKE UPPER(BI.E_MAIL) AND
  IFNULL(AP2.TEL_NUMBER || MAP(AP2.TEL_EXTENS, '', '', CHAR(32) || '-' || CHAR(32) || AP2.TEL_EXTENS), '') LIKE BI.PHONE_NUMBER AND
  IFNULL(AP2.FAX_NUMBER || MAP(AP2.FAX_EXTENS, '', '', CHAR(32) || '-' || CHAR(32) || AP2.FAX_EXTENS), '') LIKE BI.FAX_NUMBER
ORDER BY
  U21.BNAME,
  U21.MANDT

