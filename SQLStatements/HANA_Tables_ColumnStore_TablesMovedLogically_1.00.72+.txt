SELECT
/* 

[NAME]

- HANA_Tables_ColumnStore_TablesMovedLogically_1.00.72+

[DESCRIPTION]

- Displays tables or table partitions that are moved logically

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- STRING_AGG available as of SAP HANA 1.00.72
- A logical move happens if ALTER TABLE ... MOVE ... TO ... is called without the PHYSICAL option
- This logical move operation will create a link from the new persistence location to the old
  persistence location which is removed during the next merge operation (going to the new
  persistence location)

[VALID FOR]

- Revisions:              >= 1.00.72

[SQL COMMAND VERSION]

- 2014/10/09:  1.0 (initial version)

[INVOLVED TABLES]

- M_TABLE_PERSISTENCE_LOCATIONS

[INPUT PARAMETERS]

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

- TABLE_NAME:           

  Table name or pattern

  'T000'          --> Specific table T000
  'T%'            --> All tables starting with 'T'
  '%'             --> All tables

- PART_ID:

  Partition identifier

  5               --> Only check partition 5
  -1              --> No restriction in terms of partition number

[OUTPUT PARAMETERS]

- HOST:             Host name
- PORT:             Port
- SERVICE:          Service name
- SCHEMA_NAME:      Schema name
- TABLE_NAME:       Table name
- COLUMN_NAME:      Column name
- NUM_DISTINCT:     Distinct values
- DATA_TYPE:        Column data type
- ATTRIBUTE_TYPE:   Column attribute type
- LOADED:           TRUE if column is loaded into memory, otherwise FALSE
- PAGEABLE:         Indicates if column can be set up as paged attribute or not
- USED_FOR:         Reason of (internal) column
- MEM_SIZE_MB:      Column size in memory (in MB)
- DROP_COMMAND:     Command to drop a potentially droppable concat attribute

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------
|SCHEMA_NAME|TABLE_NAME     |PART_ID|IS_HISTORY|PORT |HOSTS                       |
-----------------------------------------------------------------------------------
|SAPSR3     |/BIC/FAB2EH09  |     18|FALSE     |31103|saphanab3d004, saphanab3d006|
|SAPSR3     |/BIC/FAB2EH09  |     19|FALSE     |31103|saphanab3d004, saphanab3d006|
|SAPSR3     |/BIC/FAB2FIL09 |     14|FALSE     |31103|saphanab3d010, saphanab3d005|
|SAPSR3     |/BIC/FAB2FIL09 |     15|FALSE     |31103|saphanab3d010, saphanab3d005|
|SAPSR3     |/BIC/FAB3FIL09 |      6|FALSE     |31103|saphanab3d006, saphanab3d003|
|SAPSR3     |/BIC/FAB3FIL09 |      7|FALSE     |31103|saphanab3d006, saphanab3d003|
|SAPSR3     |/BIC/FAB3FIL09 |     14|FALSE     |31103|saphanab3d006, saphanab3d005|
|SAPSR3     |/BIC/FAB3FIL09 |     15|FALSE     |31103|saphanab3d006, saphanab3d005|
|SAPSR3     |/BIC/FAB4EH09  |     14|FALSE     |31103|saphanab3d006, saphanab3d005|
-----------------------------------------------------------------------------------

*/

  DISTINCT
  P.SCHEMA_NAME,
  P.TABLE_NAME,
  LPAD(P.PART_ID, 7) PART_ID,
  P.IS_HISTORY,
  LPAD(P.PERSISTENCE_PORT, 5) PORT,
  S.SERVICE_NAME SERVICE,
  STRING_AGG (P.PERSISTENCE_HOST, ', ') HOSTS
FROM
( SELECT                   /* Modification section */
    '%' HOST,
    '%' PORT,
    '%' SERVICE_NAME,
    '%' SCHEMA_NAME,
    '%' TABLE_NAME,
    -1 PART_ID
  FROM
    DUMMY
) BI,
  M_SERVICES S,
  M_TABLE_PERSISTENCE_LOCATIONS P
WHERE
  S.HOST LIKE BI.HOST AND
  TO_VARCHAR(S.PORT) LIKE BI.PORT AND
  S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
  P.PERSISTENCE_HOST =  S.HOST AND
  P.PERSISTENCE_PORT = S.PORT AND
  P.SCHEMA_NAME LIKE BI.TABLE_NAME AND
  P.TABLE_NAME LIKE BI.TABLE_NAME AND
  ( BI.PART_ID = -1 OR P.PART_ID = BI.PART_ID )
GROUP BY
  S.SERVICE_NAME,
  P.SCHEMA_NAME,
  P.TABLE_NAME,
  P.PART_ID,
  P.IS_HISTORY,
  P.PERSISTENCE_PORT
HAVING
  COUNT(*) > 1
ORDER BY
  P.SCHEMA_NAME,
  P.TABLE_NAME,
  P.PART_ID,
  P.IS_HISTORY

