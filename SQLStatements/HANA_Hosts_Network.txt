SELECT
/* 

[NAME]

- HANA_Hosts_Network

[DESCRIPTION]

- Host network information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/05/30:  1.0 (initial version)

[INVOLVED TABLES]

- M_HOST_INFORMATION

[INPUT PARAMETERS]

- HOST

  Host name

  'saphana01'     --> Specific host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

[OUTPUT PARAMETERS]

- HOST:        Host name
- DOMAIN:      Domain name
- HOST_NAMES:  Host names
- PUBLIC_NAME: Public host name

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------
|HOST     |DOMAIN    |HOST_NAMES                                               |PUBLIC_NAME |
---------------------------------------------------------------------------------------------
|saphana20|retail.org|saphana20,gpfsnode01,hananode01,saphanamon20,saphanarep20|10.169.0.171|
|saphana21|retail.org|saphana21,gpfsnode02,hananode02,saphanamon21,saphanarep21|10.169.0.172|
---------------------------------------------------------------------------------------------

*/

  H.HOST,
  IFNULL(MAX(CASE WHEN KEY = 'net_domain' THEN VALUE END), 'n/a') DOMAIN,
  IFNULL(MAX(CASE WHEN KEY = 'net_hostnames' THEN VALUE END), 'n/a') HOST_NAMES,
  IFNULL(MAX(CASE WHEN KEY = 'net_publicname' THEN VALUE END), 'n/a') PUBLIC_NAME
FROM
( SELECT                  /* Modification section */
    '%' HOST
  FROM
    DUMMY
) BI,
  M_HOST_INFORMATION H
WHERE
  H.HOST LIKE BI.HOST
GROUP BY
  H.HOST
ORDER BY
  H.HOST
