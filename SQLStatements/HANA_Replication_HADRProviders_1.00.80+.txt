SELECT

/* 

[NAME]

- HANA_Replication_HADRProviders_1.00.80+

[DESCRIPTION]

- Display HA/DR providers

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_HA_DR_PROVIDERS available with SAP HANA >= 1.00.80

[VALID FOR]

- Revisions:              >= 1.00.80

[SQL COMMAND VERSION]

- 2021/10/12:  1.0 (initial version)

[INVOLVED TABLES]

- M_HA_DR_PROVIDERS

[INPUT PARAMETERS]

- PROVIDER_NAME

  Provider name

  'SAPHanaSR'     --> Provider name SAPHanaSR
  '%'             --> No provider name restriction

- PROVIDER_COMPANY

  Provider company name

  'SUSE'          --> Providers of company SUSE
  '%'             --> No restriction related to provider company name

- PROVIDER_DESCRIPTION

  Provider description

  '%Cluster%'     --> Providers with description containing 'Cluster'
  '%'             --> No provider description restriction

- PROVIDER_VERSION

  Provider version

  '1.0'           --> Providers with version 1.0
  '%'             --> No provider version restriction

- PROVIDER_TYPE

  Provider type

  'GENERIC'       --> Providers with type GENERIC
  '%'             --> No provider type restriction

- PROVIDER_PATH

  Provider path

  '/usr/share/%'  --> Providers located below /usr/share
  '%'             --> No provider path restriction

[OUTPUT PARAMETERS]

- NAME:        Provider name
- COMPANY:     Provider company
- DESCRIPTION: Provider description
- VERSION:     Provider version
- TYPE:        Provider type
- PATH:        Provider path

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------
|NAME     |COMPANY|DESCRIPTION                  |VERSION|TYPE   |PATH                |
--------------------------------------------------------------------------------------
|SAPHanaSR|SUSE   |Inform Cluster about SR state|1.0    |GENERIC|/usr/share/SAPHanaSR|
--------------------------------------------------------------------------------------

*/

  P.PROVIDER_NAME NAME,
  P.PROVIDER_COMPANY COMPANY,
  P.PROVIDER_DESCRIPTION DESCRIPTION,
  P.PROVIDER_VERSION VERSION,
  P.PROVIDER_TYPE TYPE,
  P.PROVIDER_PATH PATH
FROM
( SELECT                /* Modification section */
    '%' PROVIDER_NAME,
    '%' PROVIDER_COMPANY,
    '%' PROVIDER_DESCRIPTION,
    '%' PROVIDER_VERSION,
    '%' PROVIDER_TYPE,
    '%' PROVIDER_PATH
  FROM
    DUMMY
) BI,
  M_HA_DR_PROVIDERS P
WHERE
  P.PROVIDER_NAME LIKE BI.PROVIDER_NAME AND
  P.PROVIDER_COMPANY LIKE BI.PROVIDER_COMPANY AND
  P.PROVIDER_DESCRIPTION LIKE BI.PROVIDER_DESCRIPTION AND
  P.PROVIDER_VERSION LIKE BI.PROVIDER_VERSION AND
  P.PROVIDER_TYPE LIKE BI.PROVIDER_TYPE AND
  P.PROVIDER_PATH LIKE BI.PROVIDER_PATH