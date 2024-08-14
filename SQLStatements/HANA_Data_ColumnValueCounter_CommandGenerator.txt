SELECT

/* 

[NAME]

- HANA_Data_ColumnValueCounter_CommandGenerator

[DESCRIPTION]

- Generates a SQL command to count and aggregate column values

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Result of command execution is a SQL statement that has to be executed in order to count the values

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/06/02:  1.0 (initial version)
- 2016/05/31:  1.1 (AGGREGATION_FUNCTION included)
- 2022/11/15:  1.2 (MIN_OCCURRENCES included)

[INVOLVED TABLES]


[INPUT PARAMETERS]

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  '%'             --> All schemata

- TABLE_NAME           

  Table name 

  'T000'          --> Specific table T000

- COLUMN_LIST

  List of columns used for counting / aggregating

  'MATNR'                            --> Aggregation by MATNR
  'MANDT, BELNR'                     --> Aggregation by MANDT and BELNR
  'SUBSTR(UDATE, 1, 6) UDATE_PREFIX' --> Aggregation by six leading characters of column UDATE, arbitrary alias (in this case UDATE_PREFIX) needs to be specified

- ALIAS_LIST

  List of aliases used in COLUMN_LIST

  ''                --> No aliases used in COLUMN_LIST
  'UDATE_PREFIX'    --> Alias UDATE_PREFIX

- RESTRICTION_CONDITIONS

  Restrictions (WHERE clause)

  ''                --> No restrictions
  'MANDT = ''200''' --> Only records of MANDT 200

- AGGREGATION_FUNCTION

  Aggregation function (if standard COUNT aggregation is not sufficient)

  ''                                      -> No aggregation function
  'SUM(LENGTH(CLUSTD)) SUM_LENGTH_CLUSTD' -> Summarize length of column CLUSTD and use alias SUM_LENGTH_CLUSTD

- MIN_OCCURRENCES

  Minimum threshold for number of occurrences to be reported

  100000         --> Only return lines with at least 100000 occurrences
  -1             --> No limitation in terms of number of occurrences

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'OCCURRENCES'   --> Sorting by number of records
  'COLUMN_VALUES' --> Sorting by column values

- RESULT_ROWS

  Number of records to be returned by the query

  100             --> Return a maximum number of 100 records
  -1              --> Return all records

[OUTPUT PARAMETERS]

- COMMAND: SQL command to be executed in second step

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------
|COMMAND                                                                       |
--------------------------------------------------------------------------------
|SELECT TOP 100                                                                |
|  'MARD' TABLE_NAME,                                                          |
|  S.*                                                                         |
|FROM                                                                          |
|( SELECT                                                                      |
|    MATNR_PREFIX,                                                             |
|    LPAD(COUNT(*), 11) OCCURRENCES,                                           |
|    LPAD(TO_DECIMAL(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 10, 2), 7) PERCENT|
|  FROM                                                                        |
|  ( SELECT                                                                    |
|      SUBSTR(MATNR, 1, 13) MATNR_PREFIX                                       |
|    FROM                                                                      |
|      "MARD"                                                                  |
|  )                                                                           |
|  GROUP BY                                                                    |
|    MATNR_PREFIX                                                              |
|  ORDER BY                                                                    |
|    OCCURRENCES DESC                                                          |
|) S                                                                           |
--------------------------------------------------------------------------------

--> Needs to be executed and returns e.g.:

----------------------------------------------
|TABLE_NAME|MATNR_PREFIX |OCCURRENCES|PERCENT|
----------------------------------------------
|MARD      |0000000000013|    1540408|   7.72|
|MARD      |0000000000011|    1511427|   7.57|
|MARD      |0000000000014|    1508570|   7.56|
|MARD      |0000000000015|    1490971|   7.47|
|MARD      |0000000000016|    1469612|   7.36|
|MARD      |0000000000010|    1462475|   7.33|
|MARD      |0000000000012|    1395594|   6.99|
|MARD      |0000000000017|    1201817|   6.02|
|MARD      |0000000000003|    1002074|   5.02|
|MARD      |0000000000002|     992409|   4.97|
|MARD      |0000000000004|     891410|   4.46|
|MARD      |0000000000001|     842386|   4.22|
----------------------------------------------

*/

  COMMAND
FROM
( SELECT
    L.LINE_NO,
    CASE L.LINE_NO
      WHEN  2 THEN 'SELECT' || MAP(BI.RESULT_ROWS, -1, '', ' TOP' || CHAR(32) || BI.RESULT_ROWS)
      WHEN  3 THEN CHAR(32) || CHAR(32) || CHAR(39) || BI.TABLE_NAME || CHAR(39) || ' TABLE_NAME,'
      WHEN  4 THEN MAP(BI.RESTRICTION_CONDITIONS, NULL, NULL, CHAR(32) || CHAR(32) || CHAR(39) || REPLACE(BI.RESTRICTION_CONDITIONS, CHAR(39), CHAR(39) || CHAR(39)) || CHAR(39) || ' RESTRICTION_CONDITIONS,')
      WHEN  5 THEN CHAR(32) || CHAR(32) || 'S.*'
      WHEN  6 THEN 'FROM'
      WHEN  7 THEN '( SELECT'
      WHEN  8 THEN MAP(BI.COLUMN_LIST, NULL, NULL, CHAR(32) || CHAR(32) || CHAR(32) || CHAR(32) || BI.ALIAS_LIST || ',')
      WHEN  9 THEN MAP(BI.COLUMN_LIST, NULL, NULL, '    LPAD(COUNT(*), 11) OCCURRENCES,')
      WHEN 10 THEN MAP(BI.COLUMN_LIST, NULL, NULL, MAP(BI.AGGREGATION_FUNCTION, NULL, NULL, CHAR(32) || CHAR(32) || CHAR(32) || CHAR(32) || BI.AGGREGATION_FUNCTION || ','))
      WHEN 11 THEN MAP(BI.COLUMN_LIST, NULL, NULL, '    LPAD(TO_DECIMAL(COUNT(*) / SUM(COUNT(*)) OVER () * 100, 10, 2), 7) PERCENT')
      WHEN 12 THEN MAP(BI.COLUMN_LIST, NULL, '    LPAD(SUM(TOTAL_RECORDS), 13) TOTAL_RECORDS,', NULL)
      WHEN 13 THEN MAP(BI.COLUMN_LIST, NULL, '    LPAD(SUM(MATCHING_RECORDS), 16) MATCHING_RECORDS,', NULL)
      WHEN 14 THEN MAP(BI.COLUMN_LIST, NULL, '    LPAD(TO_DECIMAL(MAP(SUM(TOTAL_RECORDS), 0, 0, SUM(MATCHING_RECORDS) / SUM(TOTAL_RECORDS) * 100), 12, 5), 12) MATCHING_PCT', NULL)
      WHEN 15 THEN '  FROM'
      WHEN 16 THEN '  ( SELECT'
      WHEN 17 THEN MAP(BI.COLUMN_LIST, NULL, NULL, CHAR(32) || CHAR(32) || CHAR(32) || CHAR(32) || CHAR(32) || CHAR(32) || MAP(BI.AGGREGATION_FUNCTION, NULL, BI.COLUMN_LIST, '*'))
      WHEN 18 THEN MAP(BI.COLUMN_LIST, NULL, '      CASE WHEN' || CHAR(32) || BI.RESTRICTION_CONDITIONS || ' THEN 1 ELSE 0 END MATCHING_RECORDS,', NULL)
      WHEN 19 THEN MAP(BI.COLUMN_LIST, NULL, '      1 TOTAL_RECORDS', NULL)
      WHEN 20 THEN '    FROM'
      WHEN 21 THEN CHAR(32) || CHAR(32) || CHAR(32) || CHAR(32) || CHAR(32) || CHAR(32) || MAP(BI.SCHEMA_NAME, '%', '', '"' || BI.SCHEMA_NAME || '".') || '"' || BI.TABLE_NAME || '"'
      WHEN 22 THEN MAP(BI.COLUMN_LIST, NULL, NULL, MAP(BI.RESTRICTION_CONDITIONS, NULL, NULL, '    WHERE'))
      WHEN 23 THEN MAP(BI.COLUMN_LIST, NULL, NULL, MAP(BI.RESTRICTION_CONDITIONS, NULL, NULL, CHAR(32) || CHAR(32) ||CHAR(32) || CHAR(32) || CHAR(32) || CHAR(32) || BI.RESTRICTION_CONDITIONS))
      WHEN 24 THEN '  )'
      WHEN 25 THEN MAP(BI.COLUMN_LIST, NULL, NULL, '  GROUP BY')
      WHEN 26 THEN MAP(BI.COLUMN_LIST, NULL, NULL, CHAR(32) || CHAR(32) || CHAR(32) || CHAR(32) || BI.ALIAS_LIST)
      WHEN 27 THEN MAP(BI.MIN_OCCURRENCES, -1, NULL, ' HAVING')
      WHEN 28 THEN MAP(BI.MIN_OCCURRENCES, -1, NULL, CHAR(32) || CHAR(32) || CHAR(32) || CHAR(32) || 'COUNT(*) >' || CHAR(32) || MIN_OCCURRENCES)
      WHEN 29 THEN MAP(BI.COLUMN_LIST, NULL, NULL, '  ORDER BY')
      WHEN 30 THEN MAP(BI.COLUMN_LIST, NULL, NULL, CHAR(32) || CHAR(32) || CHAR(32) || CHAR(32) || MAP(BI.ORDER_BY, 'COLUMN_VALUES', BI.ALIAS_LIST, 'OCCURRENCES', 'OCCURRENCES DESC'))
      WHEN 31 THEN ') S'
    END COMMAND  
  FROM
  ( SELECT
      SCHEMA_NAME,
      TABLE_NAME,
      MAP(COLUMN_LIST, '', NULL, COLUMN_LIST) COLUMN_LIST,
      'NULL ' || REPLACE(REPLACE(MAP(ALIAS_LIST, '', COLUMN_LIST, ALIAS_LIST), ', ', ','), ',', ', NULL ') DUMMY_COLUMN_LIST,
      MAP(ALIAS_LIST, '', COLUMN_LIST, ALIAS_LIST) ALIAS_LIST,
      MAP(RESTRICTION_CONDITIONS, '', NULL, RESTRICTION_CONDITIONS) RESTRICTION_CONDITIONS,
      MAP(AGGREGATION_FUNCTION, '', NULL, AGGREGATION_FUNCTION) AGGREGATION_FUNCTION,
      MIN_OCCURRENCES,
      ORDER_BY,
      RESULT_ROWS
     FROM
    ( SELECT                               /* Modification section */
        '%' SCHEMA_NAME,
        'RSPMREQUEST' TABLE_NAME,
        'DATATARGET' COLUMN_LIST,                   /* comma separated, '' for record counter */
        '' ALIAS_LIST,                         /* comma separated, only required if functions like SUBSTR and aliases are used in COLUMN_LIST */
        '' RESTRICTION_CONDITIONS,             /* '' for no restriction */
        '' AGGREGATION_FUNCTION, /* optionally including alias, '' for aggregation based on COUNT */
        100000 MIN_OCCURRENCES,
        'OCCURRENCES' ORDER_BY,                /* OCCURRENCES, COLUMN_VALUES */
        100 RESULT_ROWS
      FROM
         DUMMY
    )
  ) BI,
  ( SELECT TOP 40 ROW_NUMBER () OVER () LINE_NO FROM OBJECTS
  ) L
)
WHERE
  COMMAND IS NOT NULL
ORDER BY
  LINE_NO
