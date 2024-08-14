SELECT
/* 

[NAME]

- HANA_SQL_ExpensiveStatements_SQLText

[DESCRIPTION]

- Display SQL text for specific statement hash
- Line wrapping at blanks

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Only populated if expensive statements trace is activated (SAP Note 2180165)

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/10/22:  1.0 (initial version)

[INVOLVED TABLES]

- M_EXPENSIVE_STATEMENTS

[INPUT PARAMETERS]

- STATEMENT_HASH      
 
  Hash of SQL statement to be analyzed (mandatory)

- LINE_LENGTH_TARGET

  80      --> Approximate line length of 80 characters

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

  CASE O.LINE_NO
    WHEN 1 THEN 
      CASE WHEN S.SQL_TEXT_LENGTH <= BI.LINE_LENGTH_TARGET THEN S.SQL_TEXT ELSE
      SUBSTR(S.SQL_TEXT, 
        1, 
        BI.LINE_LENGTH_TARGET + LOCATE(SUBSTR(S.SQL_TEXT, O.LINE_NO * BI.LINE_LENGTH_TARGET), CHAR(32)) - 1) END
    WHEN CEIL(S.SQL_TEXT_LENGTH / BI.LINE_LENGTH_TARGET) THEN
      SUBSTR(S.SQL_TEXT, 
        ( O.LINE_NO - 1) * BI.LINE_LENGTH_TARGET + LOCATE(SUBSTR(S.SQL_TEXT, ( O.LINE_NO - 1) * BI.LINE_LENGTH_TARGET), CHAR(32))) 
    ELSE
      SUBSTR(S.SQL_TEXT, 
        ( O.LINE_NO - 1) * BI.LINE_LENGTH_TARGET + LOCATE(SUBSTR(S.SQL_TEXT, ( O.LINE_NO - 1) * BI.LINE_LENGTH_TARGET), CHAR(32)), 
        BI.LINE_LENGTH_TARGET + LOCATE(SUBSTR(S.SQL_TEXT, O.LINE_NO * BI.LINE_LENGTH_TARGET), CHAR(32)) - LOCATE(SUBSTR(S.SQL_TEXT, ( O.LINE_NO - 1) * BI.LINE_LENGTH_TARGET), CHAR(32))) 
  END SQL_TEXT
FROM
( SELECT                         /* Modification section */
    '64bd60c2151ee232c3e4fe9b4d4aa6eb' STATEMENT_HASH,
    80 LINE_LENGTH_TARGET
  FROM
    DUMMY
) BI INNER JOIN
( SELECT DISTINCT
    STATEMENT_HASH,
    TO_VARCHAR(STATEMENT_STRING) SQL_TEXT,
    LENGTH(TO_VARCHAR(STATEMENT_STRING)) SQL_TEXT_LENGTH
  FROM
    M_EXPENSIVE_STATEMENTS
) S ON
    BI.STATEMENT_HASH = S.STATEMENT_HASH INNER JOIN
( SELECT
    ROW_NUMBER () OVER () LINE_NO
  FROM
    OBJECTS
) O ON
    O.LINE_NO <= CEIL(S.SQL_TEXT_LENGTH / BI.LINE_LENGTH_TARGET)

