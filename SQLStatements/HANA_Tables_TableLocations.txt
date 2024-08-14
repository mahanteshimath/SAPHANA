SELECT
/* 

[NAME]

- HANA_Tables_TableLocations

[DESCRIPTION]

- Table locations (host, port)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/12/16:  1.0 (initial version)
- 2018/07/10:  1.1 (OBJECT_LEVEL included)

[INVOLVED TABLES]

- M_TABLE_LOCATIONS

[INPUT PARAMETERS]

- HOST

  Host name

  'saphana01'     --> Specific host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- PORT

  Port number

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- SERVICE_NAME

  Service name

  'indexserver'   --> Specific service indexserver
  '%server'       --> All services ending with 'server'
  '%'             --> All services  

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- TABLE_NAME           

  Table name or pattern

  'T000'          --> Specific table T000
  'T%'            --> All tables starting with 'T'
  '%'             --> All tables

- LOCATION

  Table location

  'hana01:30003'  --> Only show tables with location hana01:30003
  '%'             --> No restriction related to table location

- OBJECT_LEVEL

  Controls display of partitions

  'PARTITION'     --> Result is shown on partition level
  'TABLE'         --> Result is shown on table level

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TABLE'         --> Aggregation by table name
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

[OUTPUT PARAMETERS]

- HOST:        Host name
- PORT:        Port
- SERVICE:     Service name
- SCHEMA_NAME: Schema name
- TABLE_NAME:  Table name
- LOCATION:    Table location
- NUM:         Number of tables / partitions

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------
|HOST  |PORT |SCHEMA_NAME                     |TABLE_NAME|LOCATION    |NUM   |
------------------------------------------------------------------------------
|hana01|31003|SAPSR3                          |any       |hana01:31003| 42647|
|hana01|31003|SYS                             |any       |hana01:31003|     3|
|hana01|31003|SYSTEM                          |any       |hana01:31003|    22|
|hana01|31003|_SYS_AFL                        |any       |hana01:31003|     4|
|hana01|31003|_SYS_AUDIT                      |any       |hana01:31003|     1|
|hana01|31003|_SYS_BI                         |any       |hana01:31003|    23|
|hana01|31003|_SYS_BIC                        |any       |hana01:31003|     1|
|hana01|31003|_SYS_EPM                        |any       |hana01:31003|     8|
|hana01|31003|_SYS_REPO                       |any       |hana01:31003|    34|
|hana01|31003|_SYS_RT                         |any       |hana01:31003|    46|
|hana01|31003|_SYS_SECURITY                   |any       |hana01:31003|     1|
|hana01|31003|_SYS_STATISTICS                 |any       |hana01:31003|    85|
|hana01|31003|_SYS_TASK                       |any       |hana01:31003|    28|
|hana01|31003|_SYS_XB                         |any       |hana01:31003|     2|
|hana01|31003|_SYS_XS                         |any       |hana01:31003|    22|
------------------------------------------------------------------------------

*/

  HOST,
  PORT,
  SERVICE_NAME SERVICE,
  SCHEMA_NAME,
  TABLE_NAME,
  LOCATION,
  LPAD(NUM, 6) NUM
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')     != 0 THEN TL.HOST             ELSE MAP(BI.HOST,        '%', 'any', BI.HOST)          END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')     != 0 THEN TO_VARCHAR(TL.PORT) ELSE MAP(BI.PORT,        '%', 'any', BI.PORT)          END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE')  != 0 THEN S.SERVICE_NAME      ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME) END SERVICE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')   != 0 THEN TL.SCHEMA_NAME      ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)   END SCHEMA_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')    != 0 THEN TL.TABLE_NAME || MAP(BI.OBJECT_LEVEL, 'PARTITION', MAP(TL.PART_ID, 0, '', CHAR(32) || '(' || TL.PART_ID || ')'), '') 
                                                                                                           ELSE MAP(BI.TABLE_NAME,  '%', 'any', BI.TABLE_NAME)    END TABLE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'LOCATION') != 0 THEN TL.LOCATION         ELSE MAP(BI.LOCATION,    '%', 'any', BI.LOCATION)      END LOCATION,
    COUNT(*) NUM
  FROM
  ( SELECT                /* Modification section */
      '%' HOST,
      '%' PORT,
      '%' SERVICE_NAME,
      '%' SCHEMA_NAME,
      '%' TABLE_NAME,
      '%' LOCATION,
      'TABLE' OBJECT_LEVEL,
      'NONE' AGGREGATE_BY            /* HOST, PORT, SERVICE, SCHEMA, TABLE, LOCATION or comma separated combinations, NONE for no aggregation */
    FROM
      DUMMY
  ) BI,
    M_SERVICES S,
    M_TABLE_LOCATIONS TL
  WHERE
    S.HOST LIKE BI.HOST AND
    TO_VARCHAR(S.PORT) LIKE BI.PORT AND
    S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
    TL.HOST = S.HOST AND
    TL.PORT = S.PORT AND
    TL.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    TL.TABLE_NAME LIKE BI.TABLE_NAME AND
    TL.LOCATION LIKE BI.LOCATION
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')     != 0 THEN TL.HOST             ELSE MAP(BI.HOST,        '%', 'any', BI.HOST)          END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')     != 0 THEN TO_VARCHAR(TL.PORT) ELSE MAP(BI.PORT,        '%', 'any', BI.PORT)          END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE')  != 0 THEN S.SERVICE_NAME      ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')   != 0 THEN TL.SCHEMA_NAME      ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)   END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')    != 0 THEN TL.TABLE_NAME || MAP(BI.OBJECT_LEVEL, 'PARTITION', MAP(TL.PART_ID, 0, '', CHAR(32) || '(' || TL.PART_ID || ')'), '') 
                                                                                                           ELSE MAP(BI.TABLE_NAME,  '%', 'any', BI.TABLE_NAME)    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'LOCATION') != 0 THEN TL.LOCATION         ELSE MAP(BI.LOCATION,    '%', 'any', BI.LOCATION)      END
)
ORDER BY
  HOST,
  PORT,
  SCHEMA_NAME,
  TABLE_NAME,
  LOCATION
