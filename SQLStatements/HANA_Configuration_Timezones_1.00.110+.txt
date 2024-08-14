SELECT
/* 

[NAME]

- HANA_Configuration_Timezones_1.00.110+

[DESCRIPTION]

- SAP HANA timezone information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_TIMEZONE_ALERTS available starting with SAP HANA 1.0 SPS 11
- Proper configuration of timezones required to avoid expensive timezone conversions or wrong timezone calculations

[VALID FOR]

- Revisions:              >= 1.00.110

[SQL COMMAND VERSION]

- 2018/02/07:  1.0 (initial version)

[INVOLVED TABLES]

- M_HOST_INFORMATION
- M_INIFILE_CONTENTS
- M_TABLES
- M_TIMEZONE_ALERTS

[INPUT PARAMETERS]


[OUTPUT PARAMETERS]

- AREA:  Check area (e.g. TIMEZONE TABLES)
- KEY:   Check key (e.g. table name)
- VALUE: Key value (e.g. table entries)

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------------------------------------------------------------
|AREA               |KEY                                                             |VALUE                                                                |
------------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST TIMEZONES     |saphana                                                         |CET (GMT offset: 3600 s)                                             |
|                   |                                                                |                                                                     |
|TIMEZONE TABLES    |SAPSR3.TTZD                                                     |216 entries                                                          |
|                   |SAPSR3.TTZDF                                                    |290 entries                                                          |
|                   |SAPSR3.TTZDV                                                    |271 entries                                                          |
|                   |SAPSR3.TTZZ                                                     |907 entries                                                          |
|                   |                                                                |                                                                     |
|TIMEZONE PARAMETERS|indexserver.ini -> [global] -> timezone_dataset                 |sap (DEFAULT)                                                        |
|                   |indexserver.ini -> [global] -> timezone_default_data_client_name|001 (DEFAULT)                                                        |
|                   |indexserver.ini -> [global] -> timezone_default_data_schema_name|SYSTEM (DEFAULT)                                                     |
|                   |                                                                |                                                                     |
|TIMEZONE ALERTS    |TABLES NOT FOUND                                                |The following timezone tables could not be found or are not readable:|
|                   |                                                                |SYSTEM.TTZD, SYSTEM.TTZDF, SYSTEM.TTZDV, SYSTEM.TTZZ                 |
------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  MAP(ROW_NUMBER() OVER (PARTITION BY AREA ORDER BY LINE_NO), 1, AREA, '') AREA,
  KEY,
  VALUE
FROM
( SELECT
    100 + ROW_NUMBER () OVER (ORDER BY HOST) LINE_NO,
    'HOST TIMEZONES' AREA,
    HOST KEY,
    MAX(MAP(KEY, 'timezone_name', VALUE, '')) || CHAR(32) || '(GMT offset:' || CHAR(32) || MAX(MAP(KEY, 'timezone_offset', VALUE, '')) || CHAR(32) || 's)' VALUE
  FROM
    M_HOST_INFORMATION
  GROUP BY
    HOST
  UNION ALL
  SELECT 200, '', '', '' FROM DUMMY
  UNION ALL
  SELECT
    200 + ROW_NUMBER () OVER (ORDER BY SCHEMA_NAME, TABLE_NAME) / 100,
    'TIMEZONE TABLES',
    SCHEMA_NAME || '.' || TABLE_NAME,
    RECORD_COUNT || CHAR(32) || 'entries'
  FROM
    M_TABLES
  WHERE
    TABLE_NAME IN ('TTZZ', 'TTZD', 'TTZDF', 'TTZDV') 
  UNION ALL
  SELECT 300, '', '', '' FROM DUMMY
  UNION ALL
  SELECT
    300 + ROW_NUMBER () OVER (ORDER BY FILE_NAME, SECTION, KEY, LAYER_NAME),
    'TIMEZONE PARAMETERS',
    FILE_NAME || CHAR(32) || '->' || CHAR(32) || '[' || SECTION || ']' || CHAR(32) || '->' || CHAR(32) || KEY,
    VALUE || CHAR(32) || '(' || LAYER_NAME || ')'
  FROM
    M_INIFILE_CONTENTS
  WHERE
    SECTION = 'global' AND
    KEY LIKE '%timezone%'
  UNION ALL
  SELECT TOP 1 400, '', '', '' FROM M_TIMEZONE_ALERTS
  UNION ALL
  SELECT
    400 + LINE_NO,
    AREA,
    KEY,
    VALUE
  FROM
  ( SELECT DISTINCT
      L.LINE_NO,
      MAP(L.LINE_NO, 1, 'TIMEZONE ALERTS', '') AREA,
      MAP(L.LINE_NO, 1, STATUS || MAP(TIMEZONE_NAME, NULL, '', '?', '', CHAR(32) || '(timezone:' || CHAR(32) || TIMEZONE_NAME || ')'), '') KEY,
      MAP(L.LINE_NO, 1, SUBSTR(DETAILS, 1, LOCATE(DETAILS, ':', 1) + 1), SUBSTR(DETAILS, LOCATE(DETAILS, ':', 1) + 2)) VALUE
    FROM
    ( SELECT 1 LINE_NO FROM DUMMY UNION ALL
      SELECT 2 LINE_NO FROM DUMMY
    ) L,
      M_TIMEZONE_ALERTS A
  )
)
ORDER BY
  LINE_NO