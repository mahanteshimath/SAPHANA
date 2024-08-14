SELECT
/* 

[NAME]

- HANA_Limits

[DESCRIPTION]

- Technical limitations of the SAP HANA database

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/05/13:  1.0 (initial version)

[INVOLVED TABLES]

- M_SYSTEM_LIMITS

[INPUT PARAMETERS]

- LIMIT_NAME

  Short name of system limit

  'MAXIMUM_NUMBER_OF_COLUMNS_IN_INDEX' --> Only show information for limit MAXIMUM_NUMBER_OF_COLUMNS_IN_INDEX
  '%COLUMNS%'                          --> Show limits containing 'COLUMNS'
  '%'                                  --> No restriction by limit name

- LIMIT_COMMENT

  Limit comment

  'Maximum number of SQL parse tree'   --> Only show limit with comment 'Maximum number of SQL parse tree'
  '%length%'                           --> Show limits with comments containing 'length'
  '%'                                  --> No restriction by limit comment

[OUTPUT PARAMETERS]

- LIMIT_NAME:    Short name of system limit
- VALUE:         Limit value
- UNIT:          Limit unit
- LIMIT_COMMENT: Detailed limit description

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------------------------------------------------------
|LIMIT_NAME                                    |VALUE     |UNIT     |LIMIT_COMMENT                                                                           |
--------------------------------------------------------------------------------------------------------------------------------------------------------------
|MAXIMUM_DEPTH_OF_SQL_PARSE_TREE               |       255|         |Maximum number of SQL parse tree                                                        |
|MAXIMUM_DEPTH_OF_SQL_VIEW_NESTING             |       128|         |Maximum number of SQL view nesting                                                      |
|MAXIMUM_LENGTH_OF_ALIAS_NAME                  |       128|Character|Maximum length of an alias such as table and column aliases                             |
|MAXIMUM_LENGTH_OF_BINARY_LITERAL              |      8192|Byte     |Maximum length of a binary literal                                                      |
|MAXIMUM_LENGTH_OF_IDENTIFIER                  |       127|Character|Maximum length of an identifier such as procedure, schema, table, column and user names |
|MAXIMUM_LENGTH_OF_STRING_LITERAL              |         8|MByte    |Maximum length of a string literal                                                      |
|MAXIMUM_NUMBER_OF_COLUMNS_IN_GROUP_BY         |     65535|         |Maximum number of columns/expressions in a GROUP BY clause                              |
|MAXIMUM_NUMBER_OF_COLUMNS_IN_INDEX            |        16|         |Maximum number of columns in an index                                                   |
|MAXIMUM_NUMBER_OF_COLUMNS_IN_IN_PREDICATE     |     65535|         |Maximum number of columns/expressions in an IN predicate                                |
|MAXIMUM_NUMBER_OF_COLUMNS_IN_ORDER_BY         |     65535|         |Maximum number of columns/expressions in an ORDER BY clause                             |
|MAXIMUM_NUMBER_OF_COLUMNS_IN_PRIMARY_KEY      |        16|         |Maximum number of columns in a primary key                                              |
|MAXIMUM_NUMBER_OF_COLUMNS_IN_TABLE            |      1000|         |Maximum number of columns in a table                                                    |
|MAXIMUM_NUMBER_OF_COLUMNS_IN_UNIQUE_CONSTRAINT|        16|         |Maximum number of columns in a UNIQUE constraint                                        |
|MAXIMUM_NUMBER_OF_COLUMNS_IN_VIEW             |      1000|         |Maximum number of columns in a view                                                     |
|MAXIMUM_NUMBER_OF_INDEXES_IN_TABLE            |      1023|         |Maximum number of indexes in a table                                                    |
|MAXIMUM_NUMBER_OF_JOIN_TABLES_IN_STATEMENT    |       255|         |Maximum number of joined tables in a statement                                          |
|MAXIMUM_NUMBER_OF_OUTPUT_COLUMNS_IN_STATEMENT |     65535|         |Maximum number of output columns/expressions in a SELECT statement                      |
|MAXIMUM_NUMBER_OF_SESSIONS                    |     65536|         |Maximum number of concurrent connections                                                |
|MAXIMUM_NUMBER_OF_TABLES_IN_SCHEMA            |    131072|         |Maximum number of tables that can be created in a schema                                |
|MAXIMUM_NUMBER_OF_TABLES_IN_STATEMENT         |      4095|         |This restriction shows the maximum number of tables including repeated occurrences in a |
|MAXIMUM_NUMBER_OF_TRIGGERS_PER_TABLE_PER_DML  |        32|         |Maximum number of triggers per table and per DML. A single table can have maximum 1024 i|
|MAXIMUM_NUMBER_OR_PARTITIONS_OF_CSTABLE       |      1000|         |Maximum number or partitions of a column table                                          |
|MAXIMUM_SIZE_OF_KEY_IN_INDEX                  |     16384|Byte     |Maximum size of a key in an index such as primary key, a secondary index, and a unique c|
--------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  L.NAME LIMIT_NAME,
  LPAD(L.VALUE, 10) VALUE,
  L.UNIT,
  L.COMMENT LIMIT_COMMENT
FROM
( SELECT                            /* Modification section */
    '%' LIMIT_NAME,
    '%' LIMIT_COMMENT
  FROM
    DUMMY
) BI,
  M_SYSTEM_LIMITS L
WHERE
  UPPER(L.NAME) LIKE UPPER(BI.LIMIT_NAME) AND
  UPPER(L.COMMENT) LIKE UPPER(BI.LIMIT_COMMENT)
ORDER BY
  NAME
