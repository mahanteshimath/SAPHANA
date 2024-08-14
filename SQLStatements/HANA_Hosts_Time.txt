SELECT
/* 

[NAME]

- HANA_Hosts_Time

[DESCRIPTION]

- Time information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Specifying a non-existing HOST in "Modification section" on SAP HANA <= 121 can result in a crash (SAP Note 2391546)

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/07/17:  1.0 (initial version)
- 2017/10/24:  1.1 (CURRENT_UTCTIMESTAMP added)

[INVOLVED TABLES]

- M_HOST_INFORMATION
- M_HOST_RESOURCE_UTILIZATION

[OUTPUT PARAMETERS]

- NAME:   Type of time information
- HOST:   Host name
- DETAIL: Time information details

[EXAMPLE OUTPUT]

--------------------------------------------------
|NAME             |HOST   |DETAIL                |
--------------------------------------------------
|Current timestamp|       |2015/07/17 14:08:15.72|
|                 |       |                      |
|System time      |saphana|2015/07/17 14:08:15.72|
|                 |       |                      |
|Timezone         |saphana|CEST                  |
--------------------------------------------------

*/

  'Current timestamp' NAME,
  '' HOST,
  TO_VARCHAR(CURRENT_TIMESTAMP, 'YYYY/MM/DD HH24:MI:SS.FF2') DETAIL
FROM
  DUMMY
UNION ALL
( SELECT '', '', '' FROM DUMMY )
UNION ALL
( SELECT
    'Current UTC timestamp',
    '',
    TO_VARCHAR(CURRENT_UTCTIMESTAMP, 'YYYY/MM/DD HH24:MI:SS.FF2') DETAIL
  FROM
    DUMMY
)
UNION ALL
( SELECT '', '', '' FROM DUMMY )
UNION ALL
( SELECT
    MAP(ROW_NUM, 1, 'System time', ''),
    HOST,
    TO_VARCHAR(SYS_TIMESTAMP, 'YYYY/MM/DD HH24:MI:SS.FF2') 
  FROM
  ( SELECT
      HOST,
      ROW_NUMBER() OVER (ORDER BY HOST) ROW_NUM,
      SYS_TIMESTAMP
    FROM
      M_HOST_RESOURCE_UTILIZATION
  )
  ORDER BY
    HOST
)
UNION ALL
( SELECT '', '', '' FROM DUMMY )
UNION ALL
( SELECT
    MAP(ROW_NUM, 1, 'Timezone', ''),
    HOST,
    VALUE
  FROM
  ( SELECT
      HOST,
      ROW_NUMBER() OVER (ORDER BY HOST) ROW_NUM,
      VALUE
    FROM
      M_HOST_INFORMATION
    WHERE
      KEY = 'timezone_name'
  )
  ORDER BY
    HOST
)

