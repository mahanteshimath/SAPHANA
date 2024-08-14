WITH 

/* 

[NAME]

- HANA_Data_JoinCardinalities_CommandGenerator

[DESCRIPTION]

- Generates a SQL command calculate join cardinalities
[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Result of command execution is a SQL statement that has to be executed in order to display join cardinalities
- See the following blog for more information on join cardinalities:

  https://blogs.sap.com/2017/10/27/join-cardinality-setting-in-calculation-views-how-proposals-for-join-cardinality-can-be-obtained/

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2019/12/09:  1.0 (initial version)

[INVOLVED TABLES]


[INPUT PARAMETERS]

- SCHEMA_NAME_1

  Schema name or pattern for left join object

  'SAPSR3'        --> Specific schema SAPSR3
  ''              --> No explicit schema generation

- OBJECT_NAME_1          

  Left object name (e.g. table, view)

  'T000'          --> Specific table T000

- JOIN_COLUMNS_1

  Comma separated list of join columns of the left table

  'MATNR'                            --> Single join column MATNR
  'MANDT, BELNR'                     --> Join columns MANDT and BELNR

- SCHEMA_NAME_2

  Schema name or pattern for right join object

  'SAPSR3'        --> Specific schema SAPSR3
  ''              --> No explicit schema generation

- OBJECT_NAME_2

  Right object name (e.g. table, view)

  'T000'          --> Specific table T000

- JOIN_COLUMNS_2

  Comma separated list of join columns of the right table

  ''                                 --> Take value of JOIN_COLUMNS_1
  'MATNR'                            --> Single join column MATNR
  'MANDT, BELNR'                     --> Join columns MANDT and BELNR

- ATTRIBUTE_COLUMNS_2

  Additional attribute columns of the right table (considered when grouping)

  ''                                 --> Group only by join columns
  'WERKS, GJAHR'                     --> Additionally group by columns WERK and GJAHR

[OUTPUT PARAMETERS]

- COMMAND: SQL command to be executed in second step

[EXAMPLE OUTPUT]

------------------------------------------------------
|COMMAND                                             |
------------------------------------------------------
|WITH LEFT_DISTINCT_VALUES AS                        |
|( SELECT DISTINCT                                   |
|    LT.ALERT_ID                                     |
|  FROM                                              |
|    "_SYS_STATISTICS"."STATISTICS_CURRENT_ALERTS" LT|
|)                                                   |
|SELECT                                              |
|  '' J1, LT.ALERT_ID,                               |
|  '' J2, RT.ALERT_ID,                               |
|  '' AT, RT.ALERT_RATING,                           |
|  LPAD(COUNT(*), 7) COUNT                           |
|FROM                                                |
|  LEFT_DISTINCT_VALUES LT LEFT OUTER JOIN           |
|  "_SYS_STATISTICS"."STATISTICS_ALERTS_BASE" RT ON  |
|    (LT.ALERT_ID) = (RT.ALERT_ID)                   |
|GROUP BY                                            |
|  LT.ALERT_ID,RT.ALERT_ID,RT.ALERT_RATING           |
|ORDER BY                                            |
|  COUNT(*) DESC                                     |
------------------------------------------------------

--> Needs to be executed and returns e.g.:

-------------------------------------------------
|J1|ALERT_ID|J2|ALERT_ID|AT|ALERT_RATING|COUNT  |
-------------------------------------------------
|  |79      |  |79      |  |2           |1047758|
|  |119     |  |119     |  |2           |    424|
|  |135     |  |135     |  |3           |    424|
-------------------------------------------------

--> Columns J1, J2 and AT are separators for join columns of table 1, join columns of table 2 and attribute columns considered when grouping

*/

BASIS_INFO AS
( SELECT
    MAP(SCHEMA_NAME_1, '', '', '%', '', '"' || SCHEMA_NAME_1 || '".') || '"' || OBJECT_NAME_1 || '"' OBJECT_NAME_1,
    'LT.' || REPLACE(REPLACE(JOIN_COLUMNS_1, CHAR(32), ''), ',', ',LT.') JOIN_COLUMNS_1,
    MAP(SCHEMA_NAME_2, '', '', '%', '', '"' || SCHEMA_NAME_2 || '".') || '"' || OBJECT_NAME_2 || '"' OBJECT_NAME_2,
    'RT.' || REPLACE(REPLACE(MAP(JOIN_COLUMNS_2, '', JOIN_COLUMNS_1, JOIN_COLUMNS_2), CHAR(32), ''), ',', ',RT.') JOIN_COLUMNS_2,
    MAP(ATTRIBUTE_COLUMNS_2, '', '', 'RT.' || REPLACE(REPLACE(ATTRIBUTE_COLUMNS_2, CHAR(32), ''), ',', ',RT.')) ATTRIBUTE_COLUMNS_2
  FROM
  ( SELECT                          /* Modification section */
      '_SYS_STATISTICS' SCHEMA_NAME_1,
      'STATISTICS_CURRENT_ALERTS' OBJECT_NAME_1,
      'ALERT_ID' JOIN_COLUMNS_1,
      '_SYS_STATISTICS' SCHEMA_NAME_2,
      'STATISTICS_ALERTS_BASE' OBJECT_NAME_2,
      'ALERT_ID' JOIN_COLUMNS_2,
      'ALERT_RATING' ATTRIBUTE_COLUMNS_2
    FROM
      DUMMY
  )
)
SELECT
  COMMAND
FROM
( SELECT   10 LINE_NO, 'WITH LEFT_DISTINCT_VALUES AS' COMMAND                               FROM BASIS_INFO UNION ALL
  SELECT   20, '( SELECT DISTINCT'                                                          FROM BASIS_INFO UNION ALL
  SELECT   30, LPAD('', 4) || JOIN_COLUMNS_1                                                FROM BASIS_INFO UNION ALL
  SELECT   40, LPAD('', 2) || 'FROM'                                                        FROM BASIS_INFO UNION ALL
  SELECT   50, LPAD('', 4) || OBJECT_NAME_1 || ' LT'                                        FROM BASIS_INFO UNION ALL
  SELECT   60, ')'                                                                          FROM BASIS_INFO UNION ALL
  SELECT   70, 'SELECT'                                                                     FROM BASIS_INFO UNION ALL
  SELECT   80, LPAD('', 2) || CHAR(39) || CHAR(39) || ' J1, ' || JOIN_COLUMNS_1 || ','      FROM BASIS_INFO UNION ALL
  SELECT   82, LPAD('', 2) || CHAR(39) || CHAR(39) || ' J2, ' || JOIN_COLUMNS_2 || ','      FROM BASIS_INFO UNION ALL
  SELECT   85, LPAD('', 2) || CHAR(39) || CHAR(39) || ' AT, ' || ATTRIBUTE_COLUMNS_2 || ',' FROM BASIS_INFO WHERE ATTRIBUTE_COLUMNS_2 != '' UNION ALL
  SELECT   90, LPAD('', 2) || 'LPAD(COUNT(*), 7) COUNT'                                     FROM BASIS_INFO UNION ALL
  SELECT  100, 'FROM'                                                                       FROM BASIS_INFO UNION ALL
  SELECT  110, LPAD('', 2) || 'LEFT_DISTINCT_VALUES LT LEFT OUTER JOIN'                     FROM BASIS_INFO UNION ALL
  SELECT  120, LPAD('', 2) || OBJECT_NAME_2 || ' RT ON'                                     FROM BASIS_INFO UNION ALL
  SELECT  130, LPAD('', 4) || '(' || JOIN_COLUMNS_1 || ') = (' || JOIN_COLUMNS_2 || ')'     FROM BASIS_INFO UNION ALL
  SELECT  140, 'GROUP BY'                                                                   FROM BASIS_INFO UNION ALL
  SELECT  150, LPAD('', 2) || JOIN_COLUMNS_1 || ',' || JOIN_COLUMNS_2 || 
               MAP(ATTRIBUTE_COLUMNS_2, '', '', ',' || ATTRIBUTE_COLUMNS_2)                 FROM BASIS_INFO UNION ALL
  SELECT  160, 'ORDER BY'                                                                   FROM BASIS_INFO UNION ALL
  SELECT  170, LPAD('', 2) || 'COUNT(*) DESC'                                               FROM BASIS_INFO
)
ORDER BY
  LINE_NO
