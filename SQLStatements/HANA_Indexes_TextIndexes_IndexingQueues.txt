SELECT

/* 

[NAME]

- HANA_Indexes_TextIndexes_IndexingQueues

[DESCRIPTION]

- Overview of queues for text index processing

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Fails in SAP HANA Cloud (SHC) environments because fulltext indexes are no longer available:

  invalid table name:  Could not find table/view M_FULLTEXT_QUEUES

- If errors are reported, you can retrieve details the generated via the generated error analysis command or manually via:

  SELECT
    "<column>",
    INDEXING_ERROR_CODE("<column>") ERROR_CODE,
    INDEXING_ERROR_MESSAGE("<column>") ERROR_MESSAGE
  FROM
    "<table>"
  WHERE
    INDEXING_ERROR_CODE("<column>") != 0

- Example errors:

  5120: Preprocessor: abort timeout reached
  5122: Xerces parser error.
  5146: Too many annotations added to annotation manager.
  5181: Language model file not found for
  5335: Error occurred when analyzing a segment.
  5438: Initialization error.
        -> may be caused by SAP Note 2396942
  5443: An error occured while opening 3rd party filter stream created from the memory buffer.
  5547: Lexicon: general failure

- A complete list of errors is availabe in M_ERROR_CODES (CODE_STRING = 'ERR_TEXT_...')

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2018/02/28:  1.0 (initial version)
- 2020/06/02:  1.1 (ERROR_ANALYSIS_COMMAND added)

[INVOLVED TABLES]

- M_FULLTEXT_QUEUES

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

- TABLE_NAME           

  Table name or pattern

  'T000'          --> Specific table T000
  'T%'            --> All tables starting with 'T'
  '%'             --> All tables

- PART_ID

  Partition number

  2               --> Only show information for partition number 2
  -1              --> No restriction related to partition number

- COLUMN_NAME

  Column name

  'MATNR'         --> Column MATNR
  'Z%'            --> Columns starting with "Z"
  '%'             --> No restriction related to columns

- MIN_ERROR_COUNT

  Minimum threshold for errors to be displayed

  1000            --> Only display results in case of more than 1000 errors
  -1              --> No restriction related to error count

- MIN_ERROR_PCT

  Minimum percentage of errors compared to overall number of processed documents

  2               --> Only display results if more than 2 % of all documents ran into error
  -1              --> No restriction related to error percentage

- OBJECT_LEVEL

  Controls display of partitions

  'PARTITION'     --> Result is shown on partition level
  'TABLE'         --> Result is shown on table level

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TABLE'         --> Aggregation by table
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'ERROR_COUNT'   --> Sorting by error count
  'TABLE'         --> Sorting by table name

[OUTPUT PARAMETERS]

- HOST:                   Host
- PORT:                   Port
- SCHEMA_NAME:            Schema name
- TABLE_NAME:             Table name
- COLUMN_NAME:            Column name
- TOTAL_DOCS:             Total number of documents
- INDEXED_DOCS:           Documents being successfully indexed
- QUEUED_DOCS:            Queued documents
- ERROR_DOCS:             Number of documents with errors during indexing
- ERROR_PCT:              Percentage of documents with errors during indexing (compared to TOTAL_DOCS)
- ERROR_ANALYSIS_COMMAND: Command for detailed text indexing error analysis

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------
|HOST  |PORT |SCHEMA_NAME|TABLE_NAME    |COLUMN_NAME|TOTAL_DOCS|INDEXED_DOCS|QUEUED_DOCS|ERROR_DOCS|ERROR_PCT|
--------------------------------------------------------------------------------------------------------------
|hana01|30240|SAP_SEARCH |CS_LOG_01     |SEARCH_TERM|  22219384|    22217692|          0|      1692|     0.00|
|hana01|30240|SAPSR3     |/SVT/SNO_SEA00|ABAP_CODING|   2363175|     2363009|          0|       166|     0.00|
|hana01|30240|SAPSR3     |/SVT/SNO_SEA00|META_INFO  |   2363175|     2363071|          0|       104|     0.00|
--------------------------------------------------------------------------------------------------------------

*/

  HOST,
  LPAD(PORT, 5) PORT,
  SCHEMA_NAME,
  TABLE_NAME,
  COLUMN_NAME,
  LPAD(TOTAL, 10) TOTAL_DOCS,
  LPAD(INDEXED, 12) INDEXED_DOCS,
  LPAD(QUEUED, 11) QUEUED_DOCS,
  LPAD(ERROR, 10) ERROR_DOCS,
  LPAD(TO_DECIMAL(ERROR_PCT, 10, 2), 9) ERROR_PCT,
  CASE WHEN SCHEMA_NAME != 'any' AND TABLE_NAME != 'any' AND COLUMN_NAME != 'any' AND ERROR > 0 THEN
    'SELECT ' || LANGKEY || '"' || COLUMN_NAME || '", INDEXING_ERROR_CODE("' || COLUMN_NAME || '") ERROR_CODE, INDEXING_ERROR_MESSAGE("' || COLUMN_NAME || '") ERROR_MESSAGE FROM "' ||
    SCHEMA_NAME || '"."' || TABLE_NAME || '" WHERE INDEXING_ERROR_CODE("' || COLUMN_NAME || '") != 0' ELSE '' END ERROR_ANALYSIS_COMMAND
FROM
( SELECT
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')   != 0 THEN T.HOST             ELSE MAP(BI.HOST,        '%', 'any', BI.HOST)        END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')   != 0 THEN TO_VARCHAR(T.PORT) ELSE MAP(BI.PORT,        '%', 'any', BI.PORT)        END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA') != 0 THEN T.SCHEMA_NAME      ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME) END SCHEMA_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')  != 0 THEN T.TABLE_NAME || 
      MAP(BI.OBJECT_LEVEL, 'TABLE', '', MAP(T.PART_ID, 0, '', CHAR(32) || '(' || T.PART_ID || ')'))     ELSE MAP(BI.TABLE_NAME,  '%', 'any', BI.TABLE_NAME)  END TABLE_NAME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COLUMN') != 0 THEN T.COLUMN_NAME      ELSE MAP(BI.COLUMN_NAME, '%', 'any', BI.COLUMN_NAME) END COLUMN_NAME,
    SUM(T.TOTAL_DOCUMENT_COUNT) TOTAL,
    SUM(T.INDEXED_DOCUMENT_COUNT) INDEXED,
    SUM(T.QUEUE_DOCUMENT_COUNT) QUEUED,
    SUM(T.ERROR_DOCUMENT_COUNT) ERROR,
    MAX(T.LANGKEY) LANGKEY,
    MAP(SUM(T.TOTAL_DOCUMENT_COUNT), 0, 0, SUM(T.ERROR_DOCUMENT_COUNT) / SUM(T.TOTAL_DOCUMENT_COUNT) * 100) ERROR_PCT,
    BI.MIN_ERROR_COUNT,
    BI.MIN_ERROR_PCT,
    BI.ORDER_BY
  FROM
  ( SELECT                   /* Modification section */
      '%' HOST,
      '%' PORT,
      '%' SCHEMA_NAME,
      '%' TABLE_NAME,
      -1 PART_ID,
      '%' COLUMN_NAME,
      1 MIN_ERROR_COUNT,
      -1 MIN_ERROR_PCT,
      'TABLE' OBJECT_LEVEL,
      'NONE' AGGREGATE_BY,                    /* HOST, PORT, SCHEMA, TABLE, COLUMN or comma-separated combinations, NONE for no aggregation */
      'QUEUED_COUNT' ORDER_BY                  /* TABLE, TOTAL_COUNT, QUEUED_COUNT, ERROR_COUNT, ERROR_PCT */
    FROM
      DUMMY
  ) BI,
  ( SELECT
      T.*,
      IFNULL(TC.COLUMN_NAME || CHAR(32) || 'LANGKEY,' || CHAR(32), '') LANGKEY
    FROM
      M_FULLTEXT_QUEUES T LEFT OUTER JOIN
      TABLE_COLUMNS TC ON
        TC.SCHEMA_NAME = T.SCHEMA_NAME AND
        TC.TABLE_NAME = T.TABLE_NAME AND
        TC.COLUMN_NAME IN ('SPRAS', 'SPRSL', 'LANGU')
  ) T
  WHERE
    T.HOST LIKE BI.HOST AND
    TO_VARCHAR(T.PORT) LIKE BI.PORT AND
    T.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    T.TABLE_NAME LIKE BI.TABLE_NAME AND
    ( BI.PART_ID = -1 OR T.PART_ID = BI.PART_ID ) AND
    T.COLUMN_NAME LIKE BI.COLUMN_NAME
  GROUP BY
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')   != 0 THEN T.HOST             ELSE MAP(BI.HOST,        '%', 'any', BI.HOST)        END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')   != 0 THEN TO_VARCHAR(T.PORT) ELSE MAP(BI.PORT,        '%', 'any', BI.PORT)        END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA') != 0 THEN T.SCHEMA_NAME      ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')  != 0 THEN T.TABLE_NAME || 
      MAP(BI.OBJECT_LEVEL, 'TABLE', '', MAP(T.PART_ID, 0, '', CHAR(32) || '(' || T.PART_ID || ')'))     ELSE MAP(BI.TABLE_NAME,  '%', 'any', BI.TABLE_NAME)  END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COLUMN') != 0 THEN T.COLUMN_NAME      ELSE MAP(BI.COLUMN_NAME, '%', 'any', BI.COLUMN_NAME) END,
    BI.MIN_ERROR_COUNT,
    BI.MIN_ERROR_PCT,
    BI.ORDER_BY
)
WHERE
( MIN_ERROR_COUNT = -1 OR ERROR >= MIN_ERROR_COUNT ) AND
( MIN_ERROR_PCT = -1 OR ERROR_PCT >= MIN_ERROR_PCT )
ORDER BY
  MAP(ORDER_BY, 'TABLE', HOST || PORT || SCHEMA_NAME || TABLE_NAME),
  MAP(ORDER_BY, 'TOTAL_COUNT', TOTAL, 'QUEUED_COUNT', QUEUED, 'ERROR_COUNT', ERROR, 'ERROR_PCT', ERROR_PCT) DESC
