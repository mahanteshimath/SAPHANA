WITH 

/* 

[NAME]

- HANA_SQL_StatementHash_SQLText

[DESCRIPTION]

- Display SQL text for specific statement hash
- Line wrapping at blanks
- If SQL statement has only limited number of blanks, you can add further blanks after
  commas by setting ADD_BLANK_AFTER_COMMA = 'X'

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/05/29:  1.0 (initial version)
- 2015/03/18:  1.1 (ADD_BLANK_AFTER_COMMA added)
- 2018/01/08:  1.2 (consideration of M_EXPENSIVE_STATEMENTS)
- 2018/02/09:  1.3 (REPLACE_BINDS and BIND_VALUES included)
- 2018/04/28:  1.4 (consideration of M_EXECUTED_STATEMENTS)
- 2020/11/24:  1.5 (DISPLAY_STATEMENT_HASH included)

[INVOLVED TABLES]

- M_SQL_PLAN_CACHE
- HOST_SQL_PLAN_CACHE

[INPUT PARAMETERS]

- STATEMENT_HASH      
 
  Hash of SQL statement to be analyzed (mandatory)

- LINE_LENGTH_TARGET

  Target for output line lengths

  80              --> Approximate line length of 80 characters

- ADD_BLANK_AFTER_COMMA

  Controls if blanks are generated after commas

  'X'             --> Blank is added after each comma (useful if statement itself has not many blanks and so line breaks at blanks are impacted)
  ' '             --> No blanks are added after each comma (okay in 99 % of all cases)

- REPLACE_BINDS

  Allows to replace bind variables with real values

  'X'             --> Replace bind variables with literals (provided via BIND_VALUES)
  ' '             --> Keep bind variables unchanged

- BIND_VALUES

  Defines from where a set of bind variables is taken

  'SQL_CACHE'            --> Take a set of bind values from M_SQL_PLAN_CACHE_PARAMETERS
  'EXPENSIVE_STATEMENTS' --> Take a set of bind values from M_EXPENSIVE_STATEMENTS
  '100,X'                --> Manually defined, comma-separated list of bind values 

[OUTPUT PARAMETERS]

- SQL_TEXT: SQL text

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------
|SQL_TEXT                                                                        |
----------------------------------------------------------------------------------
|UPDATE "ZINDX01" SET "CLUSTR" = X , "CLUSTD" = X WHERE "MANDT" = X AND "RELID" =|
|X AND "TCODE" = X AND "UNAME" = X AND "DATUM" = X AND "UZEIT" = X AND "COUNTER" |
|= X AND "SRTFD" = X AND "SRTF2" = X                                             |
----------------------------------------------------------------------------------

*/

BASIS_INFO AS
( SELECT
    STATEMENT_HASH,
    LINE_LENGTH_TARGET,
    ADD_BLANK_AFTER_COMMA,
    REPLACE_BINDS,
    DISPLAY_STATEMENT_HASH,
    CASE WHEN BIND_VALUES IN ('EXPENSIVE_STATEMENTS', 'SQL_CACHE') THEN BIND_VALUES ELSE ',' || REPLACE(BIND_VALUES, ',' || CHAR(32), ',') || ',' END BIND_VALUES
  FROM
  ( SELECT                         /* Modification section */
      'c9e784e9a4db9ab7166b43a6e6763d9f' STATEMENT_HASH,
      60 LINE_LENGTH_TARGET,
      ' ' ADD_BLANK_AFTER_COMMA,
      ' ' REPLACE_BINDS,
      'X' DISPLAY_STATEMENT_HASH,
      'EXPENSIVE_STATEMENTS' BIND_VALUES
    FROM
      DUMMY
  )
),
SQL_STATEMENT_HELPER AS
( SELECT TOP 1
    SQL_TEXT
  FROM
  ( SELECT
      1 PRIORITY,
      TO_VARCHAR(SP.STATEMENT_STRING) SQL_TEXT
    FROM
      BASIS_INFO BI,
      M_SQL_PLAN_CACHE SP
    WHERE
      SP.STATEMENT_HASH = BI.STATEMENT_HASH
    UNION
    SELECT
      3 PRIORITY,
      TO_VARCHAR(SP.STATEMENT_STRING) SQL_TEXT
    FROM
      BASIS_INFO BI,
      _SYS_STATISTICS.HOST_SQL_PLAN_CACHE SP
    WHERE
      SP.STATEMENT_HASH = BI.STATEMENT_HASH
    UNION
    SELECT
      2 PRIORITY,
      TO_VARCHAR(SP.STATEMENT_STRING) SQL_TEXT
    FROM
      BASIS_INFO BI,
      M_EXPENSIVE_STATEMENTS SP
    WHERE
      SP.STATEMENT_HASH = BI.STATEMENT_HASH
    UNION
    SELECT
      3 PRIORITY,
      TO_VARCHAR(SP.STATEMENT_STRING) SQL_TEXT
    FROM
      BASIS_INFO BI,
      M_EXECUTED_STATEMENTS SP
    WHERE
      SP.STATEMENT_HASH = BI.STATEMENT_HASH
  )
  ORDER BY
    PRIORITY
),
BIND_VALUES AS
( SELECT
    MAX(POSITION) OVER () MAX_POSITION,
    POSITION,
    BIND_VALUE
  FROM
  ( SELECT
      O.ROWNO POSITION,
      SUBSTR(BI.BIND_VALUES, LOCATE(BI.BIND_VALUES, ',', 1, O.ROWNO) + 1, LOCATE(BI.BIND_VALUES, ',', 1, O.ROWNO + 1) - LOCATE(BI.BIND_VALUES, ',', 1, O.ROWNO) - 1) BIND_VALUE
    FROM
    ( SELECT TOP 1000 ROW_NUMBER() OVER () ROWNO FROM OBJECTS ) O,
      BASIS_INFO BI
    WHERE
      BI.REPLACE_BINDS = 'X' AND
      BI.BIND_VALUES NOT IN ( 'SQL_CACHE', 'EXPENSIVE_STATEMENTS' )
    UNION ALL
    SELECT
      O.ROWNO POSITION,
      REPLACE(SUBSTR(ES.BIND_VALUES, LOCATE(ES.BIND_VALUES, ',', 1, O.ROWNO) + 1, LOCATE(ES.BIND_VALUES, ',', 1, O.ROWNO + 1) - LOCATE(ES.BIND_VALUES, ',', 1, O.ROWNO) - 1), CHAR(39), '') BIND_VALUE      
    FROM
    ( SELECT TOP 1000 ROW_NUMBER() OVER () ROWNO FROM OBJECTS ) O,
      BASIS_INFO BI,
    ( SELECT TOP 1 ',' || REPLACE(TO_VARCHAR(SUBSTR(PARAMETERS, 1, 5000)), ',' || CHAR(32), ',') || ',' BIND_VALUES FROM M_EXPENSIVE_STATEMENTS ES, BASIS_INFO BI WHERE ES.STATEMENT_HASH = BI.STATEMENT_HASH AND ES.PARAMETERS != '') ES
    WHERE
      BI.REPLACE_BINDS = 'X' AND
      BI.BIND_VALUES = 'EXPENSIVE_STATEMENTS'
    UNION ALL
    SELECT
      SPP.POSITION,
      SPP.PARAMETER_VALUE BIND_VALUE
    FROM
      BASIS_INFO BI,
    ( SELECT MIN(SP.PLAN_ID) PLAN_ID FROM BASIS_INFO BI, M_SQL_PLAN_CACHE SP, M_SQL_PLAN_CACHE_PARAMETERS SPP WHERE SP.STATEMENT_HASH = BI.STATEMENT_HASH AND SP.PLAN_ID = SPP.PLAN_ID ) MP,
      M_SQL_PLAN_CACHE_PARAMETERS SPP
    WHERE
      BI.REPLACE_BINDS = 'X' AND
      BI.BIND_VALUES = 'SQL_CACHE' AND
      SPP.PLAN_ID = MP.PLAN_ID
  )
  WHERE
    BIND_VALUE != ''
),
SQL_STATEMENT AS
( SELECT
    STRING_AGG(TEXT_FRAGMENT, '' ORDER BY POSITION) SQL_TEXT
  FROM
    BASIS_INFO BI,
  ( SELECT
      B.POSITION,
      CASE B.POSITION
        WHEN 1 THEN SUBSTR(S.SQL_TEXT, 1, LOCATE(S.SQL_TEXT, '?', 1, 1) - 1) || CHAR(39) || B.BIND_VALUE || CHAR(39)
        ELSE        SUBSTR(S.SQL_TEXT, LOCATE(S.SQL_TEXT, '?', 1, B.POSITION - 1) + 1, LOCATE(S.SQL_TEXT, '?', 1, B.POSITION) - LOCATE(S.SQL_TEXT, '?', 1, B.POSITION - 1) - 1) || CHAR(39) || B.BIND_VALUE || CHAR(39)
      END TEXT_FRAGMENT
    FROM
      SQL_STATEMENT_HELPER S,
      BIND_VALUES B
    UNION ALL
    SELECT
      MAX_POSITION + 1 POSITION,
      SUBSTR(S.SQL_TEXT, LOCATE(S.SQL_TEXT, '?', 1, M.MAX_POSITION) + 1) TEXT_FRAGMENT
    FROM
      SQL_STATEMENT_HELPER S,
    ( SELECT MAX(MAX_POSITION) MAX_POSITION FROM BIND_VALUES ) M
  )
  WHERE
    BI.REPLACE_BINDS = 'X'
  UNION ALL
  SELECT
    S.SQL_TEXT
  FROM
    BASIS_INFO BI,
    SQL_STATEMENT_HELPER S
  WHERE
    BI.REPLACE_BINDS = ' '
)
SELECT TOP 1
  'Statement hash:' || CHAR(32) || BI.STATEMENT_HASH SQL_TEXT
FROM
  BASIS_INFO BI,
  SQL_STATEMENT
WHERE
  BI.DISPLAY_STATEMENT_HASH = 'X'
UNION ALL
SELECT TOP 1
  ''
FROM
  BASIS_INFO BI,
  SQL_STATEMENT
WHERE
  BI.DISPLAY_STATEMENT_HASH = 'X'
UNION ALL
SELECT
  SUBSTR(SQL_TEXT, START_POS, END_POS - START_POS - 1) SQL_TEXT
FROM
( SELECT
    SQL_TEXT,
    SQL_TEXT_LENGTH,
    LINE_NO,
    LAST_LINE_NO,
    MAP(LINE_NO, 1, 0, ( LINE_LENGTH_TARGET * ( LINE_NO - 1) ) + START_POS) START_POS,
    MAP(END_POS, 0, SQL_TEXT_LENGTH + 2, ( LINE_LENGTH_TARGET * LINE_NO ) + END_POS) END_POS
  FROM
  ( SELECT
      SQL_TEXT,
      SQL_TEXT_LENGTH,
      LINE_NO,
      LINE_LENGTH_TARGET,
      CEIL(SQL_TEXT_LENGTH / LINE_LENGTH_TARGET) LAST_LINE_NO,
      LOCATE(SUBSTR(SQL_TEXT, ( LINE_NO - 1) * LINE_LENGTH_TARGET), CHAR(32)) START_POS,
      LOCATE(SUBSTR(SQL_TEXT, LINE_NO        * LINE_LENGTH_TARGET), CHAR(32)) END_POS
    FROM
    ( SELECT
        O.LINE_NO,
        LENGTH(MAP(BI.ADD_BLANK_AFTER_COMMA, 'X', S.SQL_TEXT_2, S.SQL_TEXT)) SQL_TEXT_LENGTH,
        BI.LINE_LENGTH_TARGET,
        MAP(BI.ADD_BLANK_AFTER_COMMA, 'X', S.SQL_TEXT_2, S.SQL_TEXT) SQL_TEXT
      FROM
        BASIS_INFO BI,
      ( SELECT
          SQL_TEXT,
          REPLACE(SQL_TEXT, ',', ',' || CHAR(32)) SQL_TEXT_2
        FROM
          SQL_STATEMENT
      ) S,
      ( SELECT
          ROW_NUMBER () OVER () LINE_NO
        FROM
          OBJECTS
      ) O
    )
    WHERE
      LINE_NO <= CEIL(SQL_TEXT_LENGTH / LINE_LENGTH_TARGET)
  )
  WHERE
    START_POS != 0
)