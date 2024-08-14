SELECT

/* 

[NAME]

- HANA_Memory_DynamicResultCache_1.00.110+

[DESCRIPTION]

- SAP HANA dynamic result cache information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Dynamic result cache available as of SAP HANA 1.00 Rev. 110 (SAP Note 2506811)

[VALID FOR]

- Revisions:              >= 2.00.020

[SQL COMMAND VERSION]

- 2017/07/20:  1.0 (initial version)
- 2017/10/25:  1.1 (TIMEZONE included)

[INVOLVED TABLES]

- M_DYNAMIC_RESULT_CACHE

[INPUT PARAMETERS]

- TIMEZONE

  Used timezone (both for input and output parameters)

  'SERVER'       --> Display times in SAP HANA server time
  'UTC'          --> Display times in UTC time

- HOST

  Host name

  'saphana01'     --> Specic host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- PORT

  Port number

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- CACHE_ID

  Cache ID

  20000002        --> Information for cache with ID 20000002
  -1              --> No restriction related to cache ID

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- OBJECT_NAME

  Object name

  'EDIDC'         --> Specific object name EDIDC
  'A%'            --> All objects starting with 'A'
  '%'             --> All objects

- OBJECT_TYPE

  Type of object

  'VIEW'          --> Specific object type VIEW
  '%'             --> All object types

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'SIZE'          --> Sorting by size 
  'HOST'          --> Sorting by host
  
[OUTPUT PARAMETERS]

- HOST:           Host name
- PORT:           Port
- CACHE_ID:       Cache ID
- SCHEMA_NAME:    Schema name
- OBJECT_NAME:    Object name
- OBJECT_TYPE:    Object type
- SIZE_MB:        Cache entry size (MB)
- RECORDS:        Record count
- CREATE_TIME:    Creation time
- REFRESH_TIME:   Refresh time
- REFRESH_REASON: Refresh reason

[EXAMPLE OUTPUT]

*/

  R.HOST,
  LPAD(R.PORT, 5) PORT,
  R.CACHE_ID,
  R.SCHEMA_NAME,
  R.OBJECT_NAME,
  R.OBJECT_TYPE,
  LPAD(TO_DECIMAL(R.MEMORY_SIZE / 1024 / 1024, 10, 2), 8) SIZE_MB,
  LPAD(R.RECORD_COUNT, 12) RECORDS,
  TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(R.CREATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE R.CREATE_TIME END, 'YYYY/MM/DD HH24:MI:SS') CREATE_TIME,
  TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(R.LAST_REFRESH_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE R.LAST_REFRESH_TIME END, 'YYYY/MM/DD HH24:MI:SS') REFRESH_TIME,
  R.LAST_REFRESH_REASON REFRESH_REASON
FROM
( SELECT                /* Modification section */
    'SERVER' TIMEZONE,                              /* SERVER, UTC */
    '%' HOST,
    '%' PORT,
    -1 CACHE_ID,
    '%' SCHEMA_NAME,
    '%' OBJECT_NAME,
    '%' OBJECT_TYPE,
    'SIZE' ORDER_BY            /* SIZE, HOST, CREATE_TIME, REFRESH_TIME */
  FROM
    DUMMY
) BI,
  M_DYNAMIC_RESULT_CACHE R
WHERE
  R.HOST LIKE BI.HOST AND
  TO_VARCHAR(R.PORT) LIKE BI.PORT AND
  ( BI.CACHE_ID = -1 OR R.CACHE_ID = BI.CACHE_ID ) AND
  R.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  R.OBJECT_NAME LIKE BI.OBJECT_NAME AND
  R.OBJECT_TYPE LIKE BI.OBJECT_TYPE
ORDER BY
  MAP(BI.ORDER_BY, 'SIZE', R.MEMORY_SIZE) DESC,
  MAP(BI.ORDER_BY, 'CREATE_TIME', R.CREATE_TIME, 'REFRESH_TIME', R.LAST_REFRESH_TIME) DESC,
  R.HOST,
  R.PORT,
  R.CACHE_ID