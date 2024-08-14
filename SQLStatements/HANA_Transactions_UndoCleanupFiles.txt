SELECT
/* 

[NAME]

- HANA_Transactions_UndoCleanupFiles

[DESCRIPTION]

- Overview of undo and cleanup files

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Can be used for monitoring remote system replication sites, see SAP Note 1999880 
  ("Is it possible to monitor remote system replication sites on the primary system") for details.

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/11/27:  1.0 (initial version)

[INVOLVED TABLES]

- M_UNDO_CLEANUP_FILES

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

- TYPE

  File type

  'UNDO'          --> Undo files
  'CLEANUP'       --> Cleanup files
  'FREE'          --> Free files
  '%'             --> No restriction related to 

- UTID

  Update transaction ID

  12345678        --> Only show files related to update transaction 12345678
  -1              --> No restriction related to update transaction

- EXCLUDE_FREE_FILES

  Possibility to exclude free files

  'X'             --> Do not display free files
  ' '             --> Display all files

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TYPE'          --> Aggregation by file type
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

[OUTPUT PARAMETERS]

- HOST:       Host
- PORT:       Port
- SERVICE:    Service name
- UTID:       Update transaction ID
- FILES:      Number of files
- PAGE_COUNT: File page count
- SIZE_MB:    Total file size (MB)

[EXAMPLE OUTPUT]

--------------------------------------------------------
|HOST       |PORT |TYPE   |TID|FILES|PAGE_COUNT|SIZE_MB|
--------------------------------------------------------
|saphana0001|30203|CLEANUP|any|  188|       767|   3.00|
|saphana0002|30203|CLEANUP|any|  140|       538|   2.16|
|saphana0001|30203|UNDO   |any|    1|         1|   0.06|
|saphana0004|30203|CLEANUP|any|   12|        12|   0.04|
|saphana0003|30203|CLEANUP|any|    5|         5|   0.01|
--------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  TYPE,
  LPAD(UTID, 10) UTID,
  LPAD(FILES, 5) FILES,
  LPAD(PAGE_COUNT, 12) PAGE_COUNT,
  LPAD(TO_DECIMAL(RAW_SIZE_BYTE / 1024 / 1024, 10, 2), 10) SIZE_MB
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')    != 0 THEN U.HOST          ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                 END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(U.PORT) ELSE MAP(BI.PORT, '%', 'any', TO_VARCHAR(BI.PORT))        END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TYPE')    != 0 THEN U.TYPE          ELSE MAP(BI.TYPE, '%', 'any', BI.TYPE)                 END TYPE,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'UTID')    != 0 THEN TO_VARCHAR(U.TID)  ELSE MAP(BI.UTID, -1, 'any', TO_VARCHAR(BI.UTID))         END UTID,
    COUNT(*) FILES,
    SUM(PAGE_COUNT) PAGE_COUNT,
    SUM(RAW_SIZE) RAW_SIZE_BYTE
  FROM
  ( SELECT                   /* Modification section */
      '%' HOST,
      '%' PORT,
      '%' TYPE,
      -1 UTID,
      'X' EXCLUDE_FREE_FILES,
      'NONE' AGGREGATE_BY              /* HOST, PORT, TYPE, UTID or comma separated combinations, NONE for no aggregation */
    FROM
      DUMMY
  ) BI,
    M_UNDO_CLEANUP_FILES U
  WHERE
    U.HOST LIKE BI.HOST AND
    TO_VARCHAR(U.PORT) LIKE BI.PORT AND
    U.TYPE LIKE BI.TYPE AND
    ( BI.UTID = -1 OR U.TID = BI.UTID ) AND
    ( BI.EXCLUDE_FREE_FILES = ' ' OR U.TYPE != 'FREE' )
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')    != 0 THEN U.HOST          ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                 END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(U.PORT) ELSE MAP(BI.PORT, '%', 'any', TO_VARCHAR(BI.PORT))        END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TYPE')    != 0 THEN U.TYPE          ELSE MAP(BI.TYPE, '%', 'any', BI.TYPE)                 END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'UTID')    != 0 THEN TO_VARCHAR(U.TID)  ELSE MAP(BI.UTID, -1, 'any', TO_VARCHAR(BI.UTID))         END
)
ORDER BY
  RAW_SIZE_BYTE DESC
