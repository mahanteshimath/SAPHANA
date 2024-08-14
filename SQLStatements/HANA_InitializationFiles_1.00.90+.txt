SELECT
/* 

[NAME]

- HANA_InitializationFiles_1.00.90+

[DESCRIPTION]

- Parameter files overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Column TENANT_LAYER no longer available with SAP HANA 1.00.90, instead DATABASE_LAYER exists

[VALID FOR]

- Revisions:              >= 1.00.90

[SQL COMMAND VERSION]

- 2014/01/15:  1.0 (initial version)
- 2014/09/01:  1.1 (modification section added)
- 2016/12/19:  1.2 (dedicated 1.00.90+ version)

[INVOLVED TABLES]

- M_INIFILES

[INPUT PARAMETERS]

- FILE_NAME

  File name

  'daemon.ini'    --> File with name daemon.ini
  '%server%'      --> File with name containing 'server'
  '%'             --> All files

- ONLY_FILES_WITH_MODIFICATIONS

  Possibility to restrict output to files with modified parameter settings

  'X'             --> Only list files with modified parameter settings
  ' '             --> List all files

[OUTPUT PARAMETERS]

- FILE_NAME:      Parameter file name
- DEFAULT_LAYER:  TRUE if file contains default configuration
- SYSTEM_LAYER:   TRUE if file contains SYSTEM configuration, otherwise FALSE 
- DATABASE_LAYER: TRUE if file contains DATABASE configuration, otherwise FALSE
- HOST_LAYER:     TRUE if file contains HOST configuration, otherwise FALSE

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------
|FILE_NAME           |DEFAULT_LAYER|SYSTEM_LAYER|TENANT_LAYER|HOST_LAYER|
-------------------------------------------------------------------------
|attributes.ini      |TRUE         |FALSE       |FALSE       |FALSE     |
|compileserver.ini   |TRUE         |FALSE       |FALSE       |FALSE     |
|daemon.ini          |TRUE         |FALSE       |FALSE       |TRUE      |
|executor.ini        |TRUE         |FALSE       |FALSE       |FALSE     |
|extensions.ini      |TRUE         |FALSE       |FALSE       |FALSE     |
|filter.ini          |TRUE         |FALSE       |FALSE       |FALSE     |
|global.ini          |TRUE         |TRUE        |FALSE       |FALSE     |
|indexserver.ini     |TRUE         |TRUE        |FALSE       |FALSE     |
|localclient.ini     |TRUE         |FALSE       |FALSE       |FALSE     |
|nameserver.ini      |TRUE         |TRUE        |FALSE       |FALSE     |
|preprocessor.ini    |TRUE         |FALSE       |FALSE       |FALSE     |
|property_esp.ini    |TRUE         |FALSE       |FALSE       |FALSE     |
|property_mss.ini    |TRUE         |FALSE       |FALSE       |FALSE     |
|property_orcl.ini   |TRUE         |FALSE       |FALSE       |FALSE     |
|scriptserver.ini    |TRUE         |FALSE       |FALSE       |FALSE     |
|statisticsserver.ini|TRUE         |FALSE       |FALSE       |FALSE     |
|xsengine.ini        |TRUE         |FALSE       |FALSE       |FALSE     |
-------------------------------------------------------------------------

*/

  F.FILE_NAME,
  F.DEFAULT_LAYER,
  F.SYSTEM_LAYER,
  F.DATABASE_LAYER, 
  F.HOST_LAYER
FROM
( SELECT                         /* Modification section */
    '%' FILE_NAME,
    ' ' ONLY_FILES_WITH_MODIFICATIONS
  FROM
    DUMMY
) BI,
  M_INIFILES F
WHERE
  F.FILE_NAME LIKE BI.FILE_NAME AND
  ( BI.ONLY_FILES_WITH_MODIFICATIONS = ' ' OR F.SYSTEM_LAYER != 'FALSE' OR F.DATABASE_LAYER != 'FALSE' OR F.HOST_LAYER != 'FALSE' )

ORDER BY
  FILE_NAME
