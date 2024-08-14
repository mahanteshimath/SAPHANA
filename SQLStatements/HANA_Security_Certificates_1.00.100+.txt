SELECT

/* 

[NAME]

- HANA_Security_Certificates_1.00.100+

[DESCRIPTION]

- Certificate overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- PSE_CERTIFICATES and PSES available with SAP HANA >= 1.00.100

[VALID FOR]

- Revisions:              >= 1.00.100

[SQL COMMAND VERSION]

- 2019/06/02:  1.0 (initial version)

[INVOLVED TABLES]

- PSE_CERTIFICATES
- PSES

[INPUT PARAMETERS]

- PSE_NAME

  Name of personal security environment (PSE)

  'SAPXSUAASAML' --> Display PSEs with name SAPXSUAASAML
  '%'            --> No restriction related to PSE

- CERTIFICATE_ID

  Certificate ID

  282820714      --> Display details for certificate with ID 282820714
  -1             --> No restriction related to certificate ID

- CERTIFICATE_SUBJECT

  Certificate subject

  '%OU=HANA%'    --> Certificate subjects containing 'OU=HANA'
  '%'            --> No restriction related to certificate subject

- CERTIFICATE_ISSUER

  Certificate issuer

  '%JWT%'        --> Certificate issuers containing 'JWT'
  '%'            --> No restriction related to certificate issuer

- PSE_PURPOSE

  PSE purpose

  'SAML'         --> Show PSEs for purpose SAML
  '%'            --> No restriction related to PSE purpose

- OWNER_NAME

  PSE owner name

  'SYSTEM'       --> Show PSEs with owner SYSTEM
  '%'            --> No restriction related to owner name

- ONLY_EXPIRING_CERTIFICATES

  Possibility to restrict output to certificates that have already expired or will expire soon

  'X'            --> Show only certificates that have already expired or will expire soon
  ' '            --> No restriction related to certificate expiry

[OUTPUT PARAMETERS]

- PSE_NAME:       PSE name
- CERTIFICATE_ID: Certificate ID
- SUBJECT_NAME:   Certificate subject
- VALID_FROM:     Certificate validity start date
- VALID_UNTIL:    Certificate validity end date
- USAGE:          Certificate usage
- PURPOSE:        Certificate purpose
- OWNER_NAME:     Owner name
- ISSUER_NAME:    issuer name

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------------------------------------
|PSE_NAME    |CERTIFICATE_ID|SUBJECT_NAME                |VALID_FROM         |VALID_UNTIL        |USAGE|PURPOSE|OWNER_NAME|ISSUER_NAME                 |
--------------------------------------------------------------------------------------------------------------------------------------------------------
|SAPXSUAAJWT |     282820714|OU=JWT, CN=C11              |2018/06/18 12:37:15|2068/06/18 12:47:16|TRUST|JWT    |SYSTEM    |OU=JWT, CN=C11              |
|SAPXSUAASAML|     282811151|CN=SAML-C11, OU=HANA, OU=XSA|2018/06/08 06:27:21|2068/06/08 06:37:21|OWN  |SAML   |SYSTEM    |CN=SAML-C11, OU=HANA, OU=XSA|
|SAPXSUAASAML|     282820713|CN=C11, OU=SAML             |2018/06/18 12:37:16|2068/06/18 12:47:16|TRUST|SAML   |SYSTEM    |CN=C11, OU=SAML             |
--------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  PC.PSE_NAME,
  LPAD(PC.CERTIFICATE_ID, 14) CERTIFICATE_ID,
  IFNULL(PC.SUBJECT_NAME, '') SUBJECT_NAME,
  TO_VARCHAR(PC.VALID_FROM, 'YYYY/MM/DD HH24:MI:SS') VALID_FROM,
  TO_VARCHAR(PC.VALID_UNTIL, 'YYYY/MM/DD HH24:MI:SS') VALID_UNTIL,
  PC.CERTIFICATE_USAGE USAGE,
  IFNULL(P.PURPOSE, '') PURPOSE,
  IFNULL(P.OWNER_NAME, '') OWNER_NAME,
  IFNULL(PC.ISSUER_NAME, '') ISSUER_NAME
FROM
( SELECT                          /* Modification section */
    '%' PSE_NAME,
    -1 CERTIFICATE_ID,
    '%' CERTIFICATE_SUBJECT,
    '%' CERTIFICATE_ISSUER,
    '%' PSE_PURPOSE,
    '%' OWNER_NAME,
    ' ' ONLY_EXPIRING_CERTIFICATES
  FROM
    DUMMY
) BI,
  PSE_CERTIFICATES PC,
  PSES P
WHERE
  PC.PSE_NAME LIKE BI.PSE_NAME AND
  ( BI.CERTIFICATE_ID = -1 OR PC.CERTIFICATE_ID = BI.CERTIFICATE_ID ) AND
  IFNULL(PC.SUBJECT_NAME, '') LIKE BI.CERTIFICATE_SUBJECT AND
  IFNULL(PC.ISSUER_NAME, '') LIKE BI.CERTIFICATE_ISSUER AND
  IFNULL(P.PURPOSE, '') LIKE BI.PSE_PURPOSE AND
  IFNULL(P.OWNER_NAME, '') LIKE BI.OWNER_NAME AND
  ( BI.ONLY_EXPIRING_CERTIFICATES = ' ' OR DAYS_BETWEEN(CURRENT_TIMESTAMP, PC.VALID_UNTIL) <= 50 ) AND
  PC.PSE_NAME = P.NAME
ORDER BY
  PC.PSE_NAME,
  PC.CERTIFICATE_ID
