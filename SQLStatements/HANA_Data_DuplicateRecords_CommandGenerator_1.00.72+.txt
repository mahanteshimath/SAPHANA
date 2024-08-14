SELECT
/* 

[NAME]

- HANA_Data_DuplicateRecords_CommandGenerator_1.00.72+

[DESCRIPTION]

- Checks for duplicate records (not duplicate keys!)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- STRING_AGG available as of revision 72

[VALID FOR]

- Revisions:              >= 1.00.72

[SQL COMMAND VERSION]

- 2014/12/03:  1.0 (initial version)

[INVOLVED TABLES]


[INPUT PARAMETERS]

- SCHEMA_NAME

  Schema name or pattern

  'SAPSR3'        --> Specific schema SAPSR3
  '%'             --> All schemata

- TABLE_NAMES           

  Table names, separated by comma

  'T000'          --> Specific table T000
  'JEST, JSTO'    --> Tables JEST and JSTO
  'CRMD%, BUT000' --> Tables with names starting with "CRMD" and table BUT000

- OUTPUT_TYPE

  Type of final output

  'RECORDS'       --> Column values of duplicate records
  'TABLES'        --> Names of tables with duplicates

- STATEMENT_CONNECTION

  Connection of SQL statements for different tables in generated output

  'UNION'         --> Connection via UNION
  ';'             --> Connection via ';'
  ''              --> No dedicated connection identifier

- COLUMNS_PER_LINE:

  Number of table columns specified in each output line

  6               --> 6 columns per output line (in SELECT list and / or GROUP BY clause)

[OUTPUT PARAMETERS]

- SCHEMA_NAME: Schema name
- TABLE_NAME:  Table name
- COLUMN_NAME: Column name
- COMMAND:          SQL command to be executed in second step
- COLUMNS_PER_LINE: Number of table columns specified in each output line

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------
|LINE                                                                              |
------------------------------------------------------------------------------------
|SELECT DISTINCT                                                                   |
|  '"SAPCH1"."DB02N_ANA"' ||' (' || COUNT(*) OVER () || ' duplicate rows)'         |
|FROM "SAPCH1"."DB02N_ANA"                                                         |
|GROUP BY                                                                          |
|  "ADDITIONALPARAM","NODE_KEY","PARAMETERSTRING","PROGNAME","PROGTYPE","RELATKEY",|
|  "VIASELSCREEN"                                                                  |
|HAVING COUNT(*) > 1 UNION                                                         |
|SELECT DISTINCT                                                                   |
|  '"SAPCH1"."DB02N_ANAT"' ||' (' || COUNT(*) OVER () || ' duplicate rows)'        |
|FROM "SAPCH1"."DB02N_ANAT"                                                        |
|GROUP BY                                                                          |
|  "NODE_KEY","SPRAS","TEXT"                                                       |
|HAVING COUNT(*) > 1 UNION                                                         |
|SELECT DISTINCT                                                                   |
|  '"SAPCH1"."DB02_COLL_LOG"' ||' (' || COUNT(*) OVER () || ' duplicate rows)'     |
|FROM "SAPCH1"."DB02_COLL_LOG"                                                     |
|GROUP BY                                                                          |
|  "COLL_DATE","COLL_TIME","CON_NAME","DURATION","MONIFILL","RCODE",               |
|  "SMON_ID","SMON_NAME","UPLOAD"                                                  |
|HAVING COUNT(*) > 1 UNION                                                         |
|SELECT DISTINCT                                                                   |
|  '"SAPCH1"."DB02_COLL_PLAN"' ||' (' || COUNT(*) OVER () || ' duplicate rows)'    |
|FROM "SAPCH1"."DB02_COLL_PLAN"                                                    |
|GROUP BY                                                                          |
|  "CON_NAME","FUNCNAME","MONIFILL","PARAM","PROCESS_TYPE","RANK",                 |
|  "SCH_DATE","SCH_TIME","SMON_ID","SMON_NAME","SOURCE_SMON","STATUS"              |
|HAVING COUNT(*) > 1 UNION                                                         |
|SELECT NULL FROM DUMMY WHERE 1 = 0                                                |
------------------------------------------------------------------------------------

--> Needs to be executed and returns e.g.:

------------------------------------------------
|SAPCH1DB02N_ANA                               |
------------------------------------------------
|"SAPCH1"."DB02N_ANA" (18 duplicate rows)      |
|"SAPCH1"."DB02N_ANAT" (18 duplicate rows)     |
|"SAPCH1"."DB02_COLL_LOG" (1994 duplicate rows)|
------------------------------------------------

*/
  LINE
FROM 
( SELECT
    CASE OUTPUT_TYPE
      WHEN 'RECORDS' THEN
        CASE DESCRIPTION
          WHEN 'SELECT'                  THEN 'SELECT'
          WHEN 'SELECT_COLUMN_LIST_1'    THEN CHAR(32) || CHAR(32) || SUBSTR(COLUMN_LIST, 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL)))
          WHEN 'SELECT_COLUMN_LIST_2'    THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL    ), 0, NULL, SUBSTR(COLUMN_LIST, 
            LOCATE(COLUMN_LIST, ',', 1, CL    ) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 2), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 2)) - LOCATE(COLUMN_LIST, ',', 1, CL    )))
          WHEN 'SELECT_COLUMN_LIST_3'    THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 2), 0, NULL, SUBSTR(COLUMN_LIST, 
            LOCATE(COLUMN_LIST, ',', 1, CL * 2) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 3), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 3)) - LOCATE(COLUMN_LIST, ',', 1, CL * 2)))
          WHEN 'SELECT_COLUMN_LIST_4'    THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 3), 0, NULL, SUBSTR(COLUMN_LIST, 
            LOCATE(COLUMN_LIST, ',', 1, CL * 3) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 4), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 4)) - LOCATE(COLUMN_LIST, ',', 1, CL * 3)))
          WHEN 'SELECT_COLUMN_LIST_5'    THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 4), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 4) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 5), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 5)) - LOCATE(COLUMN_LIST, ',', 1, CL * 4)))
          WHEN 'SELECT_COLUMN_LIST_6'    THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 5), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 5) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 6), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 6)) - LOCATE(COLUMN_LIST, ',', 1, CL * 5)))
          WHEN 'SELECT_COLUMN_LIST_7'    THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 6), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 6) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 7), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 7)) - LOCATE(COLUMN_LIST, ',', 1, CL * 6)))
          WHEN 'SELECT_COLUMN_LIST_8'    THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 7), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 7) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 8), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 8)) - LOCATE(COLUMN_LIST, ',', 1, CL * 7)))
          WHEN 'SELECT_COLUMN_LIST_9'    THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 8), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 8) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 9), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 9)) - LOCATE(COLUMN_LIST, ',', 1, CL * 8)))
          WHEN 'SELECT_COLUMN_LIST_10'   THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 9), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 9) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *10), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *10)) - LOCATE(COLUMN_LIST, ',', 1, CL * 9)))
          WHEN 'SELECT_COLUMN_LIST_11'   THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *10), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *10) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *11), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *11)) - LOCATE(COLUMN_LIST, ',', 1, CL *10)))
          WHEN 'SELECT_COLUMN_LIST_12'   THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *11), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *11) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *12), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *12)) - LOCATE(COLUMN_LIST, ',', 1, CL *11)))
          WHEN 'SELECT_COLUMN_LIST_13'   THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *12), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *12) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *13), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *13)) - LOCATE(COLUMN_LIST, ',', 1, CL *12)))
          WHEN 'SELECT_COLUMN_LIST_14'   THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *13), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *13) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *14), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *14)) - LOCATE(COLUMN_LIST, ',', 1, CL *13)))
          WHEN 'SELECT_COLUMN_LIST_15'   THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *14), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *14) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *15), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *15)) - LOCATE(COLUMN_LIST, ',', 1, CL *14)))
          WHEN 'SELECT_COLUMN_LIST_16'   THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *15), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *15) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *16), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *16)) - LOCATE(COLUMN_LIST, ',', 1, CL *15)))
          WHEN 'SELECT_COLUMN_LIST_17'   THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *16), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *16) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *17), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *17)) - LOCATE(COLUMN_LIST, ',', 1, CL *16)))
          WHEN 'SELECT_COLUMN_LIST_18'   THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *17), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *17) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *18), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *18)) - LOCATE(COLUMN_LIST, ',', 1, CL *17)))
          WHEN 'SELECT_COLUMN_LIST_19'   THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *18), 0, NULL, SUBSTR(COLUMN_LIST, 
            LOCATE(COLUMN_LIST, ',', 1, CL *18) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *19), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *19)) - LOCATE(COLUMN_LIST, ',', 1, CL *18)))
          WHEN 'FROM'                    THEN 'FROM' || ' "' || SCHEMA_NAME || '"."' || TABLE_NAME || '"'
          WHEN 'GROUP_BY'                THEN 'GROUP BY'
          WHEN 'GROUP_BY_COLUMN_LIST_1'  THEN CHAR(32) || CHAR(32) || SUBSTR(COLUMN_LIST, 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL)))
          WHEN 'GROUP_BY_COLUMN_LIST_2'  THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL    ), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL    ) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 2), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 2)) - LOCATE(COLUMN_LIST, ',', 1, CL    )))
          WHEN 'GROUP_BY_COLUMN_LIST_3'  THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 2), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 2) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 3), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 3)) - LOCATE(COLUMN_LIST, ',', 1, CL * 2)))
          WHEN 'GROUP_BY_COLUMN_LIST_4'  THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 3), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 3) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 4), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 4)) - LOCATE(COLUMN_LIST, ',', 1, CL * 3)))
          WHEN 'GROUP_BY_COLUMN_LIST_5'  THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 4), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 4) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 5), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 5)) - LOCATE(COLUMN_LIST, ',', 1, CL * 4)))
          WHEN 'GROUP_BY_COLUMN_LIST_6'  THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 5), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 5) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 6), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 6)) - LOCATE(COLUMN_LIST, ',', 1, CL * 5)))
          WHEN 'GROUP_BY_COLUMN_LIST_7'  THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 6), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 6) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 7), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 7)) - LOCATE(COLUMN_LIST, ',', 1, CL * 6)))
          WHEN 'GROUP_BY_COLUMN_LIST_8'  THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 7), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 7) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 8), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 8)) - LOCATE(COLUMN_LIST, ',', 1, CL * 7)))
          WHEN 'GROUP_BY_COLUMN_LIST_9'  THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 8), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 8) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 9), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 9)) - LOCATE(COLUMN_LIST, ',', 1, CL * 8)))
          WHEN 'GROUP_BY_COLUMN_LIST_10' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 9), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 9) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *10), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *10)) - LOCATE(COLUMN_LIST, ',', 1, CL * 9)))
          WHEN 'GROUP_BY_COLUMN_LIST_11' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *10), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *10) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *11), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *11)) - LOCATE(COLUMN_LIST, ',', 1, CL *10)))
          WHEN 'GROUP_BY_COLUMN_LIST_12' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *11), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *11) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *12), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *12)) - LOCATE(COLUMN_LIST, ',', 1, CL *11)))
          WHEN 'GROUP_BY_COLUMN_LIST_13' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *12), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *12) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *13), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *13)) - LOCATE(COLUMN_LIST, ',', 1, CL *12)))
          WHEN 'GROUP_BY_COLUMN_LIST_14' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *13), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *13) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *14), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *14)) - LOCATE(COLUMN_LIST, ',', 1, CL *13)))
          WHEN 'GROUP_BY_COLUMN_LIST_15' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *14), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *14) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *15), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *15)) - LOCATE(COLUMN_LIST, ',', 1, CL *14)))
          WHEN 'GROUP_BY_COLUMN_LIST_16' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *15), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *15) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *16), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *16)) - LOCATE(COLUMN_LIST, ',', 1, CL *15)))
          WHEN 'GROUP_BY_COLUMN_LIST_17' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *16), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *16) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *17), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *17)) - LOCATE(COLUMN_LIST, ',', 1, CL *16)))
          WHEN 'GROUP_BY_COLUMN_LIST_18' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *17), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *17) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *18), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *18)) - LOCATE(COLUMN_LIST, ',', 1, CL *17)))
          WHEN 'GROUP_BY_COLUMN_LIST_19' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *18), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *18) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *19), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *19)) - LOCATE(COLUMN_LIST, ',', 1, CL *18)))
          WHEN 'HAVING'                  THEN 'HAVING COUNT(*) > 1' || CHAR(32) || STATEMENT_CONNECTION
        END
      WHEN 'TABLES' THEN
        CASE DESCRIPTION
          WHEN 'SELECT'                  THEN 'SELECT DISTINCT'
          WHEN 'SELECT_COLUMN_LIST_1'    THEN CHAR(32) || CHAR(32) || CHAR(39) || '"' || SCHEMA_NAME || '"."' || TABLE_NAME || '"' || CHAR(39) || ' ||' || CHAR(39) || CHAR(32) || '(' ||  
            CHAR(39) || ' || COUNT(*) OVER () ||' || CHAR(32) || CHAR(39) || ' duplicate rows)' || CHAR(39) || ' LINE'
          WHEN 'FROM'                    THEN 'FROM' || ' "' || SCHEMA_NAME || '"."' || TABLE_NAME || '"'
          WHEN 'GROUP_BY'                THEN 'GROUP BY'
          WHEN 'GROUP_BY_COLUMN_LIST_1'  THEN CHAR(32) || CHAR(32) || SUBSTR(COLUMN_LIST, 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL)))
          WHEN 'GROUP_BY_COLUMN_LIST_2'  THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL    ), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL    ) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 2), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 2)) - LOCATE(COLUMN_LIST, ',', 1, CL    )))
          WHEN 'GROUP_BY_COLUMN_LIST_3'  THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 2), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 2) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 3), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 3)) - LOCATE(COLUMN_LIST, ',', 1, CL * 2)))
          WHEN 'GROUP_BY_COLUMN_LIST_4'  THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 3), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 3) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 4), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 4)) - LOCATE(COLUMN_LIST, ',', 1, CL * 3)))
          WHEN 'GROUP_BY_COLUMN_LIST_5'  THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 4), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 4) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 5), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 5)) - LOCATE(COLUMN_LIST, ',', 1, CL * 4)))
          WHEN 'GROUP_BY_COLUMN_LIST_6'  THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 5), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 5) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 6), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 6)) - LOCATE(COLUMN_LIST, ',', 1, CL * 5)))
          WHEN 'GROUP_BY_COLUMN_LIST_7'  THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 6), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 6) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 7), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 7)) - LOCATE(COLUMN_LIST, ',', 1, CL * 6)))
          WHEN 'GROUP_BY_COLUMN_LIST_8'  THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 7), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 7) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 8), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 8)) - LOCATE(COLUMN_LIST, ',', 1, CL * 7)))
          WHEN 'GROUP_BY_COLUMN_LIST_9'  THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 8), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 8) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 9), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL * 9)) - LOCATE(COLUMN_LIST, ',', 1, CL * 8)))
          WHEN 'GROUP_BY_COLUMN_LIST_10' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL * 9), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL * 9) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *10), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *10)) - LOCATE(COLUMN_LIST, ',', 1, CL * 9)))
          WHEN 'GROUP_BY_COLUMN_LIST_11' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *10), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *10) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *11), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *11)) - LOCATE(COLUMN_LIST, ',', 1, CL *10)))
          WHEN 'GROUP_BY_COLUMN_LIST_12' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *11), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *11) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *12), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *12)) - LOCATE(COLUMN_LIST, ',', 1, CL *11)))
          WHEN 'GROUP_BY_COLUMN_LIST_13' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *12), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *12) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *13), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *13)) - LOCATE(COLUMN_LIST, ',', 1, CL *12)))
          WHEN 'GROUP_BY_COLUMN_LIST_14' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *13), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *13) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *14), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *14)) - LOCATE(COLUMN_LIST, ',', 1, CL *13)))
          WHEN 'GROUP_BY_COLUMN_LIST_15' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *14), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *14) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *15), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *15)) - LOCATE(COLUMN_LIST, ',', 1, CL *14)))
          WHEN 'GROUP_BY_COLUMN_LIST_16' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *15), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *15) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *16), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *16)) - LOCATE(COLUMN_LIST, ',', 1, CL *15)))
          WHEN 'GROUP_BY_COLUMN_LIST_17' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *16), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *16) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *17), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *17)) - LOCATE(COLUMN_LIST, ',', 1, CL *16)))
          WHEN 'GROUP_BY_COLUMN_LIST_18' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *17), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *17) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *18), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *18)) - LOCATE(COLUMN_LIST, ',', 1, CL *17)))
          WHEN 'GROUP_BY_COLUMN_LIST_19' THEN CHAR(32) || CHAR(32) || MAP(LOCATE(COLUMN_LIST, ',', 1, CL *18), 0, NULL, SUBSTR(COLUMN_LIST,  
            LOCATE(COLUMN_LIST, ',', 1, CL *18) + 1, MAP(LOCATE(COLUMN_LIST, ',', 1, CL *19), 0, LENGTH(COLUMN_LIST), LOCATE(COLUMN_LIST, ',', 1, CL *19)) - LOCATE(COLUMN_LIST, ',', 1, CL *18)))
          WHEN 'HAVING'                  THEN 'HAVING COUNT(*) > 1' || CHAR(32) || STATEMENT_CONNECTION
        END
    END LINE
  FROM
  ( SELECT
      C.SCHEMA_NAME,
      C.TABLE_NAME,
      '"' || STRING_AGG(C.COLUMN_NAME, '","') || '"' COLUMN_LIST,
      L.LINE_NO,
      L.DESCRIPTION,
      BI.OUTPUT_TYPE,
      BI.STATEMENT_CONNECTION,
      BI.COLUMNS_PER_LINE CL
    FROM
    ( SELECT             /* Modification section */
        '%' SCHEMA_NAME,
        '/BIC/F%' TABLE_NAME,
        'TABLES' OUTPUT_TYPE,       /* TABLES, RECORDS */
        'UNION' STATEMENT_CONNECTION,           /* UNION, ';', '' */
        6 COLUMNS_PER_LINE
      FROM
        DUMMY
    ) BI,
    ( SELECT   1 LINE_NO, 'SELECT' DESCRIPTION FROM DUMMY UNION ALL
      SELECT   2, 'SELECT_COLUMN_LIST_1'       FROM DUMMY UNION ALL
      SELECT   3, 'SELECT_COLUMN_LIST_2'       FROM DUMMY UNION ALL
      SELECT   4, 'SELECT_COLUMN_LIST_3'       FROM DUMMY UNION ALL
      SELECT   5, 'SELECT_COLUMN_LIST_4'       FROM DUMMY UNION ALL
      SELECT   6, 'SELECT_COLUMN_LIST_5'       FROM DUMMY UNION ALL
      SELECT   7, 'SELECT_COLUMN_LIST_6'       FROM DUMMY UNION ALL
      SELECT   8, 'SELECT_COLUMN_LIST_7'       FROM DUMMY UNION ALL
      SELECT   9, 'SELECT_COLUMN_LIST_8'       FROM DUMMY UNION ALL
      SELECT  10, 'SELECT_COLUMN_LIST_9'       FROM DUMMY UNION ALL
      SELECT  11, 'SELECT_COLUMN_LIST_10'      FROM DUMMY UNION ALL
      SELECT  12, 'SELECT_COLUMN_LIST_11'      FROM DUMMY UNION ALL
      SELECT  13, 'SELECT_COLUMN_LIST_12'      FROM DUMMY UNION ALL
      SELECT  14, 'SELECT_COLUMN_LIST_13'      FROM DUMMY UNION ALL
      SELECT  15, 'SELECT_COLUMN_LIST_14'      FROM DUMMY UNION ALL
      SELECT  16, 'SELECT_COLUMN_LIST_15'      FROM DUMMY UNION ALL
      SELECT  17, 'SELECT_COLUMN_LIST_16'      FROM DUMMY UNION ALL
      SELECT  18, 'SELECT_COLUMN_LIST_17'      FROM DUMMY UNION ALL
      SELECT  19, 'SELECT_COLUMN_LIST_18'      FROM DUMMY UNION ALL
      SELECT  10, 'SELECT_COLUMN_LIST_19'      FROM DUMMY UNION ALL
      SELECT  50, 'FROM'                       FROM DUMMY UNION ALL
      SELECT  60, 'GROUP_BY'                   FROM DUMMY UNION ALL
      SELECT  61, 'GROUP_BY_COLUMN_LIST_1'     FROM DUMMY UNION ALL
      SELECT  62, 'GROUP_BY_COLUMN_LIST_2'     FROM DUMMY UNION ALL
      SELECT  63, 'GROUP_BY_COLUMN_LIST_3'     FROM DUMMY UNION ALL
      SELECT  64, 'GROUP_BY_COLUMN_LIST_4'     FROM DUMMY UNION ALL
      SELECT  65, 'GROUP_BY_COLUMN_LIST_5'     FROM DUMMY UNION ALL
      SELECT  66, 'GROUP_BY_COLUMN_LIST_6'     FROM DUMMY UNION ALL
      SELECT  67, 'GROUP_BY_COLUMN_LIST_7'     FROM DUMMY UNION ALL
      SELECT  68, 'GROUP_BY_COLUMN_LIST_8'     FROM DUMMY UNION ALL
      SELECT  69, 'GROUP_BY_COLUMN_LIST_9'     FROM DUMMY UNION ALL
      SELECT  70, 'GROUP_BY_COLUMN_LIST_10'    FROM DUMMY UNION ALL
      SELECT  71, 'GROUP_BY_COLUMN_LIST_11'    FROM DUMMY UNION ALL
      SELECT  72, 'GROUP_BY_COLUMN_LIST_12'    FROM DUMMY UNION ALL
      SELECT  73, 'GROUP_BY_COLUMN_LIST_13'    FROM DUMMY UNION ALL
      SELECT  74, 'GROUP_BY_COLUMN_LIST_14'    FROM DUMMY UNION ALL
      SELECT  75, 'GROUP_BY_COLUMN_LIST_15'    FROM DUMMY UNION ALL
      SELECT  76, 'GROUP_BY_COLUMN_LIST_16'    FROM DUMMY UNION ALL
      SELECT  77, 'GROUP_BY_COLUMN_LIST_17'    FROM DUMMY UNION ALL
      SELECT  78, 'GROUP_BY_COLUMN_LIST_18'    FROM DUMMY UNION ALL
      SELECT  79, 'GROUP_BY_COLUMN_LIST_19'    FROM DUMMY UNION ALL
      SELECT 100, 'HAVING'                     FROM DUMMY
    ) L,
    TABLE_COLUMNS C
    WHERE
      C.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
      C.TABLE_NAME LIKE BI.TABLE_NAME
    GROUP BY
      C.SCHEMA_NAME,
      C.TABLE_NAME,
      L.DESCRIPTION,
      L.LINE_NO,
      BI.OUTPUT_TYPE,
      BI.STATEMENT_CONNECTION,
      BI.COLUMNS_PER_LINE
  )
  ORDER BY
    SCHEMA_NAME,
    TABLE_NAME,
    LINE_NO
)
WHERE
  LINE IS NOT NULL
UNION ALL ( SELECT 'SELECT NULL FROM DUMMY WHERE 1 = 0' FROM DUMMY )
