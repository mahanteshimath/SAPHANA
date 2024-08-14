SELECT
/* 

[NAME]

- HANA_Consistency_ColumnStore_DuplicateKeys_CommandGenerator

[DESCRIPTION]

- Generates SQL commands to check for duplicate keys in tables

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Output of the SQL statement are SQL commands that have to be executed in the second step
- Only works for tables in column store
- Single column primary index: Comparison based on single column
- Multi column primary index:  Comparison based on $trexexternalkey$

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/03/20:  1.0 (initial version)

[INVOLVED TABLES]

- M_CS_ALL_COLUMNS
- M_CS_TABLES
- INDEXES
- INDEX_COLUMNS

[INPUT PARAMETERS]

      '%' SCHEMA_NAME,
      '%' TABLE_NAME,
      ' ' GENERATE_SEMICOLON

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

- GENERATE_SEMICOLON

  Controls the generation of semicolons at the end of the generated SQL statements

  'X'             --> Semicolon is generated
  ' '             --> No semicolon is generated
 
[OUTPUT PARAMETERS]

- COMMAND:          SELECT command to check for duplicate keys (one command per table)

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------
|COMMAND                                                                                  |
-------------------------------------------------------------------------------------------
|SELECT 'SAPBES' OWNER, '/ASU/ATTRIB_CUST' TABLE_NAME, 'SINGLE' IND_TYPE,                 |
|    T1."XML_TAG" UNIQUE_KEY, T1."$rowid$" ROWID_1, T2."$rowid$" ROWID_2                  |
|  FROM "SAPBES"."/ASU/ATTRIB_CUST" T1, "SAPBES"."/ASU/ATTRIB_CUST" T2                    |
|  WHERE T1."XML_TAG" = T2."XML_TAG" AND T1."$rowid$" <> T2."$rowid$"                     |
|SELECT 'SAPBES' OWNER, '/ASU/CONTENT' TABLE_NAME, 'CONCAT' IND_TYPE,                     |
|    T1."$trexexternalkey$" UNIQUE_KEY, T1."$rowid$" ROWID_1, T2."$rowid$" ROWID_2        |
|  FROM "SAPBES"."/ASU/CONTENT" T1, "SAPBES"."/ASU/CONTENT" T2                            |
|  WHERE T1."$trexexternalkey$" = T2."$trexexternalkey$" AND T1."$rowid$" <> T2."$rowid$" |
|SELECT 'SAPBES' OWNER, '/ASU/CONTENTATTR' TABLE_NAME, 'CONCAT' IND_TYPE,                 |
|    T1."$trexexternalkey$" UNIQUE_KEY, T1."$rowid$" ROWID_1, T2."$rowid$" ROWID_2        |
|  FROM "SAPBES"."/ASU/CONTENTATTR" T1, "SAPBES"."/ASU/CONTENTATTR" T2                    |
|  WHERE T1."$trexexternalkey$" = T2."$trexexternalkey$" AND T1."$rowid$" <> T2."$rowid$" |
-------------------------------------------------------------------------------------------

*/
  CASE
    WHEN BI.GENERATE_SEMICOLON = 'X' AND T.LINE_NO = 4 THEN T.COMMAND || ';' ELSE T.COMMAND END COMMAND
FROM
  ( SELECT                       /* Modification section */
      '%' SCHEMA_NAME,
      '%' TABLE_NAME,
      ' ' GENERATE_SEMICOLON
    FROM
      DUMMY
  ) BI,
  ( SELECT
      T.SCHEMA_NAME, T.TABLE_NAME, 1 LINE_NO, 'SELECT ' || CHAR(39) || T.SCHEMA_NAME || CHAR(39) || ' OWNER, ' || CHAR(39) || T.TABLE_NAME || 
        CHAR(39) || ' TABLE_NAME, ' || CHAR(39) || 'CONCAT' || CHAR(39) || ' IND_TYPE,' COMMAND
    FROM 
      M_CS_TABLES T,
      M_CS_ALL_COLUMNS C
    WHERE
      T.SCHEMA_NAME = C.SCHEMA_NAME AND
      T.TABLE_NAME = C.TABLE_NAME AND
      C.COLUMN_NAME = '$trexexternalkey$'
    UNION ALL
    ( SELECT
        T.SCHEMA_NAME, T.TABLE_NAME, 2, '    T1."$trexexternalkey$" UNIQUE_KEY, T1."$rowid$" ROWID_1, T2."$rowid$" ROWID_2' 
      FROM
        M_CS_TABLES T,
        M_CS_ALL_COLUMNS C
      WHERE
        T.SCHEMA_NAME = C.SCHEMA_NAME AND
        T.TABLE_NAME = C.TABLE_NAME AND
        C.COLUMN_NAME = '$trexexternalkey$'
    )
    UNION ALL
    ( SELECT
        T.SCHEMA_NAME, T.TABLE_NAME, 3, '  FROM "' || T.SCHEMA_NAME || '"."' || T.TABLE_NAME || 
        '" T1, "' || T.SCHEMA_NAME || '"."' || T.TABLE_NAME || '" T2'
      FROM
        M_CS_TABLES T,
        M_CS_ALL_COLUMNS C
      WHERE
        T.SCHEMA_NAME = C.SCHEMA_NAME AND
        T.TABLE_NAME = C.TABLE_NAME AND
        C.COLUMN_NAME = '$trexexternalkey$'
    )
    UNION ALL
    ( SELECT
        T.SCHEMA_NAME, T.TABLE_NAME, 4, '  WHERE T1."$trexexternalkey$" = T2."$trexexternalkey$" AND T1."$rowid$" <> T2."$rowid$"'
      FROM
        M_CS_TABLES T,
        M_CS_ALL_COLUMNS C
      WHERE
        T.SCHEMA_NAME = C.SCHEMA_NAME AND
        T.TABLE_NAME = C.TABLE_NAME AND
        C.COLUMN_NAME = '$trexexternalkey$'
    )
    UNION ALL
    ( SELECT
        I.SCHEMA_NAME, I.TABLE_NAME, 1 LINE_NO, 'SELECT ' || CHAR(39) || I.SCHEMA_NAME || CHAR(39) || ' OWNER, ' || CHAR(39) || I.TABLE_NAME || 
          CHAR(39) || ' TABLE_NAME, ' || CHAR(39) || 'SINGLE' || CHAR(39) || ' IND_TYPE,' COMMAND
      FROM 
        INDEXES I,
        INDEX_COLUMNS IC,
        M_CS_TABLES T
      WHERE 
        I.SCHEMA_NAME = IC.SCHEMA_NAME AND
        I.TABLE_NAME = IC.TABLE_NAME AND
        IC.SCHEMA_NAME = T.SCHEMA_NAME AND
        IC.TABLE_NAME = T.TABLE_NAME AND
        I.INDEX_TYPE = 'INVERTED VALUE UNIQUE'
      GROUP BY 
        I.SCHEMA_NAME, I.TABLE_NAME, I.INDEX_NAME
      HAVING 
        COUNT(*) = 1
    )
    UNION ALL
    ( SELECT
        I.SCHEMA_NAME, I.TABLE_NAME, 2, '    T1."' || MIN(IC.COLUMN_NAME) || '" UNIQUE_KEY, T1."$rowid$" ROWID_1, T2."$rowid$" ROWID_2' 
      FROM 
        INDEXES I,
        INDEX_COLUMNS IC,
        M_CS_TABLES T
      WHERE 
        I.SCHEMA_NAME = IC.SCHEMA_NAME AND
        I.TABLE_NAME = IC.TABLE_NAME AND
        IC.SCHEMA_NAME = T.SCHEMA_NAME AND
        IC.TABLE_NAME = T.TABLE_NAME AND
        I.INDEX_TYPE = 'INVERTED VALUE UNIQUE'
      GROUP BY 
        I.SCHEMA_NAME, I.TABLE_NAME, I.INDEX_NAME
      HAVING 
        COUNT(*) = 1
    )
    UNION ALL
    ( SELECT
        I.SCHEMA_NAME, I.TABLE_NAME, 3, '  FROM "' || I.SCHEMA_NAME || '"."' || I.TABLE_NAME || 
        '" T1, "' || I.SCHEMA_NAME || '"."' || I.TABLE_NAME || '" T2'
      FROM 
        INDEXES I,
        INDEX_COLUMNS IC,
        M_CS_TABLES T
      WHERE 
        I.SCHEMA_NAME = IC.SCHEMA_NAME AND
        I.TABLE_NAME = IC.TABLE_NAME AND
        IC.SCHEMA_NAME = T.SCHEMA_NAME AND
        IC.TABLE_NAME = T.TABLE_NAME AND
        I.INDEX_TYPE = 'INVERTED VALUE UNIQUE'
      GROUP BY 
        I.SCHEMA_NAME, I.TABLE_NAME, I.INDEX_NAME
      HAVING 
        COUNT(*) = 1
    )
    UNION ALL
    ( SELECT
        I.SCHEMA_NAME, I.TABLE_NAME, 4, '  WHERE T1."' || MIN(IC.COLUMN_NAME) || '" = T2."' || MIN(IC.COLUMN_NAME) || '" AND T1."$rowid$" <> T2."$rowid$"'
      FROM 
        INDEXES I,
        INDEX_COLUMNS IC,
        M_CS_TABLES T
      WHERE 
        I.SCHEMA_NAME = IC.SCHEMA_NAME AND
        I.TABLE_NAME = IC.TABLE_NAME AND
        IC.SCHEMA_NAME = T.SCHEMA_NAME AND
        IC.TABLE_NAME = T.TABLE_NAME AND
        I.INDEX_TYPE = 'INVERTED VALUE UNIQUE'
      GROUP BY 
        I.SCHEMA_NAME, I.TABLE_NAME, I.INDEX_NAME
      HAVING 
        COUNT(*) = 1
    )
  ) T
WHERE
  UPPER(T.SCHEMA_NAME) LIKE UPPER(BI.SCHEMA_NAME) AND
  UPPER(T.TABLE_NAME) LIKE UPPER(BI.TABLE_NAME)
ORDER BY
  T.SCHEMA_NAME,
  T.TABLE_NAME,
  T.LINE_NO
 
