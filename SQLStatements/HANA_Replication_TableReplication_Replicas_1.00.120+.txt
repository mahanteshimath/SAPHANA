SELECT
/* 

[NAME]

HANA_Replication_TableReplication_Replicas_1.00.120+

[DESCRIPTION]

- Displays table replicas related to synchronous and asynchronous table replication

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Asynchronous table replication available as of Rev. 1.00.100
- Optimistic synchronous table replication available as of Rev. 1.00.120
- M_ASYNCHRONOUS_TABLE_REPLICAS deprecated as of Rev. 1.00.120, M_TABLE_REPLICAS takes over its role

[VALID FOR]

- Revisions:              >= 1.00.120

[SQL COMMAND VERSION]

- 2016/07/08:  1.0 (initial version)
- 2016/07/11:  1.1 (VOLUME_ID and REP_VOL_ID added)
- 2016/07/11:  1.2 (dedicated 1.00.120+ version)
- 2018/07/10:  1.3 (TAB_HOST and TAB_PORT added)

[INVOLVED TABLES]

- M_CS_TABLES
- M_RS_TABLES
- M_TABLE_REPLICAS

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

- VOLUME_ID

  Disk volume ID

  3               --> Volume 3
  -1              --> No restriction related to volume 

- SCHEMA_NAME

  Base table schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  'SAP%'          --> All schemata starting with 'SAP'
  '%'             --> All schemata

- TABLE_NAME         

  Base table name or pattern

  'T000'          --> Specific table T000
  'T%'            --> All tables starting with 'T'
  '%'             --> All tables

- REP_VOLUME_ID

  Replica disk volume ID

  3               --> Replica volume 3
  -1              --> No restriction related to volume 

- REPLICATION_TYPE

  Table replication type

  'ASYNC'         --> Only list replicas with type ASYNC
  '%'             --> No restriction related to replication type

- REPLICATION_STATUS

  Table replication status

  'DISABLED'      --> Only list replicas with status 'DISABLED'
  '%'             --> No restriction related to replication status

[OUTPUT PARAMETERS]

- TAB_HOST:           Source table host
- TAB_PORT:           Source table port
- VOLUME_ID:          Base table volume ID
- SCHEMA_NAME:        Base schema name
- TABLE_NAME:         Base table name
- REP_HOST:           Replica host name
- REP_PORT:           Replica port
- REP_VOL_ID:         Replica volume ID
- REP_SCHEMA:         Replica schema
- REP_NAME:           Replica name
- REPLICA_TYPE:       Replication type
- REPLICATION_STATUS: Replication status
- LAST_ERROR:         Last error message
- ERROR_TIME:         Time of last error
- INSERTS:            Number of INSERT operations
- UPDATES:            Number of UPDATE operations
- DELETES:            Number of DELETE operations

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------------------------
|HOST     |   PORT|SCHEMA_NAME|TABLE_NAME|REPLICA_SCHEMA|REPLICA_NAME  |REPLICATION_STATUS|LAST_ERROR|ERROR_TIME|INSERTS |UPDATES |DELETES |
--------------------------------------------------------------------------------------------------------------------------------------------
|saphana01|30.003 |SAPSR3     |AAA       |SAPSR3        |_SYS_REP_AAA#0|ENABLED           |0         |          |       0|       0|       1|
--------------------------------------------------------------------------------------------------------------------------------------------

*/

  T.HOST TAB_HOST,
  LPAD(T.PORT, 5) TAB_PORT,
  LPAD(R.SOURCE_TABLE_VOLUME_ID, 9) VOLUME_ID,
  R.SOURCE_SCHEMA_NAME SCHEMA_NAME,
  R.SOURCE_TABLE_NAME || MAP(R.PART_ID, NULL, '', 0, '', CHAR(32) || '(' || R.PART_ID || ')') TABLE_NAME,
  R.HOST REP_HOST,
  LPAD(R.PORT, 5) REP_PORT,
  LPAD(R.VOLUME_ID, 10) REP_VOL_ID,
  R.SCHEMA_NAME REP_SCHEMA,
  R.TABLE_NAME || MAP(R.PART_ID, NULL, '', 0, '', CHAR(32) || '(' || R.PART_ID || ')') REP_TAB_NAME,
  R.REPLICA_TYPE,
  R.REPLICATION_STATUS,
  R.LAST_ERROR_CODE || MAP(R.LAST_ERROR_MESSAGE, NULL, '', '', '', ':' || CHAR(32) || R.LAST_ERROR_MESSAGE) LAST_ERROR,
  IFNULL(TO_VARCHAR(R.LAST_ERROR_TIME, 'YYYY/MM/DD HH24:MI:SS'), '') ERROR_TIME,
  LPAD(R.INSERT_RECORD_COUNT, 8) INSERTS,
  LPAD(R.UPDATE_RECORD_COUNT, 8) UPDATES,
  LPAD(R.DELETE_RECORD_COUNT, 8) DELETES
FROM
( SELECT                      /* Modification section */
    '%' TAB_HOST,
    '%' TAB_PORT,
    '%' REP_HOST,
    '%' REP_PORT,
    -1 VOLUME_ID,
    '%' SCHEMA_NAME,
    '%' TABLE_NAME,
    -1 REP_VOLUME_ID,
    '%' REPLICA_TYPE,
    '%' REPLICATION_STATUS     /* e.g. DISABLED, ENABLED */
  FROM
    DUMMY
) BI,
  M_TABLE_REPLICAS R,
( SELECT
    SCHEMA_NAME,
    TABLE_NAME,
    -1 PART_ID,
    HOST,
    PORT
  FROM
    M_RS_TABLES
  UNION ALL
  SELECT
    SCHEMA_NAME,
    TABLE_NAME,
    PART_ID,
    HOST,
    PORT
  FROM
    M_CS_TABLES
) T
WHERE
  T.SCHEMA_NAME = R.SOURCE_SCHEMA_NAME AND
  T.TABLE_NAME = R.SOURCE_TABLE_NAME AND
  T.PART_ID = R.PART_ID AND
  ( BI.REP_VOLUME_ID = -1 OR R.VOLUME_ID = BI.VOLUME_ID ) AND
  R.HOST LIKE BI.REP_HOST AND
  TO_VARCHAR(R.PORT) LIKE BI.REP_PORT AND
  ( BI.VOLUME_ID = -1 OR BI.VOLUME_ID = R.SOURCE_TABLE_VOLUME_ID ) AND
  R.SOURCE_SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
  R.SOURCE_TABLE_NAME LIKE BI.TABLE_NAME AND
  R.REPLICA_TYPE LIKE BI.REPLICA_TYPE AND
  R.REPLICATION_STATUS LIKE BI.REPLICATION_STATUS
ORDER BY
  R.SOURCE_SCHEMA_NAME,
  R.SOURCE_TABLE_NAME,
  T.HOST,
  T.PORT,
  R.HOST,
  R.PORT
