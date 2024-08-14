SELECT

/* 

[NAME]

- HANA_SQL_Statistics_JoinStatistics_1.00.120+

[DESCRIPTION]

- Join statistics overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_JOIN_DATA_STATISTICS available starting with Revision 1.00.120
- Example for VALUE_COUNTS_1 and VALUE_COUNTS_FREQUENCIES

  - Column 1 has following values: 'A', 'B', 'A', 'A', 'B', 'A', 'C', 'A', 'A', 'D'
  - VALUE_COUNTS_1 = 1,2,6  (because there are values that exist once, twice and six times)
  - VALUE_COUNTS_FREQUENCIES_1 = 2,1,1 (because two values 'C' and 'D' exist once, one value 'B' exists twice and one value 'A' exists six times)

[VALID FOR]

- Revisions:              >= 1.00.120

[SQL COMMAND VERSION]

- 2018/03/05:  1.0 (initial version)
- 2018/12/04:  1.1 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- M_JOIN_DATA_STATISTICS

[INPUT PARAMETERS]

- BEGIN_TIME

  Begin time

  '2018/12/05 14:05:00' --> Set begin time to 5th of December 2018, 14:05
  'C'                   --> Set begin time to current time
  'C-S900'              --> Set begin time to current time minus 900 seconds
  'C-M15'               --> Set begin time to current time minus 15 minutes
  'C-H5'                --> Set begin time to current time minus 5 hours
  'C-D1'                --> Set begin time to current time minus 1 day
  'C-W4'                --> Set begin time to current time minus 4 weeks
  'E-S900'              --> Set begin time to end time minus 900 seconds
  'E-M15'               --> Set begin time to end time minus 15 minutes
  'E-H5'                --> Set begin time to end time minus 5 hours
  'E-D1'                --> Set begin time to end time minus 1 day
  'E-W4'                --> Set begin time to end time minus 4 weeks
  'MIN'                 --> Set begin time to minimum (1000/01/01 00:00:00)

- END_TIME

  End time

  '2018/12/08 14:05:00' --> Set end time to 8th of December 2018, 14:05
  'C'                   --> Set end time to current time
  'C-S900'              --> Set end time to current time minus 900 seconds
  'C-M15'               --> Set end time to current time minus 15 minutes
  'C-H5'                --> Set end time to current time minus 5 hours
  'C-D1'                --> Set end time to current time minus 1 day
  'C-W4'                --> Set end time to current time minus 4 weeks
  'B+S900'              --> Set end time to begin time plus 900 seconds
  'B+M15'               --> Set end time to begin time plus 15 minutes
  'B+H5'                --> Set end time to begin time plus 5 hours
  'B+D1'                --> Set end time to begin time plus 1 day
  'B+W4'                --> Set end time to begin time plus 4 weeks
  'MAX'                 --> Set end time to maximum (9999/12/31 23:59:59)

- TIMEZONE

  Used timezone (both for input and output parameters)

  'SERVER'       --> Display times in SAP HANA server time
  'UTC'          --> Display times in UTC time

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

- COLUMN_NAME

  Column name

  'MATNR'         --> Column MATNR
  'Z%'            --> Columns starting with "Z"
  '%'             --> No restriction related to columns

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'SIZE'          --> Sorting by size 
  'TABLE'         --> Sorting by table name
  
[OUTPUT PARAMETERS]

- REFRESH_TIME:               Last statistics refresh time
- HOST:                       Host
- PORT:                       Port
- SCHEMA_NAME_1:              Schema name of table 1
- TABLE_NAME_1:               Table name of table 1
- COLUMN_NAME_1:              Column name of table 1
- SCHEMA_NAME_2:              Schema name of table 2
- TABLE_NAME_2:               Table name of table 2
- COLUMN_NAME_2:              Column name of table 2
- NUM_ROWS_1:                 Number of rows in table 1
- DISTINCT_1:                 Distinct values in column of table 1
- MEMORY_KB:                  Used memory (KB)
- VALUE_COUNTS_1:             Unique value counts (or a single average value)
- VALUE_COUNTS_FREQUENCIES_1: Frequency of different value counts (or a single average value)
- MATCHING_VALUES_COUNTS:     Number of value counts in table 1 with corresponding entries in table 2

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|REFRESH_TIME       |HOST   |PORT |SCHEMA_NAME_1|TABLE_NAME_1|COLUMN_NAME_1|SCHEMA_NAME_2|TABLE_NAME_2|COLUMN_NAME_2|NUM_ROWS_1|DISTINCT_1|MEMORY_KB|VALUE_COUNTS_1|VALUE_COUNTS_FREQUENCIES_1|MATCHING_VALUES_COUNTS|
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2018/02/27 21:02:46|saphana|30003|SAPSR3       |DD02L       |TABNAME      |SAPSR3       |E071        |OBJ_NAME     |    550565|    550564|     0.02|1             |550564                    |550564                |
|2018/02/27 20:22:52|saphana|30003|SAPSR3       |E070C       |TRKORR       |SAPSR3       |E070        |TRKORR       |     50909|     50909|     0.02|1             |50909                     |50909                 |
|2018/02/27 20:22:52|saphana|30003|SAPSR3       |E070        |TRKORR       |SAPSR3       |E070C       |TRKORR       |     51009|     51009|     0.02|1             |51009                     |50909                 |
|2018/02/27 21:02:46|saphana|30003|SAPSR3       |E071        |OBJ_NAME     |SAPSR3       |DD02L       |TABNAME      |  16941299|   5426288|     0.02|3             |5426288                   |550564                |
|2018/02/27 21:02:47|saphana|30003|SAPSR3       |E071        |OBJ_NAME     |SAPSR3       |REPOSRC     |PROGNAME     |  16941299|   5426288|     0.02|3             |5426288                   |4981074               |
|2018/02/27 21:02:47|saphana|30003|SAPSR3       |REPOSRC     |PROGNAME     |SAPSR3       |E071        |OBJ_NAME     |   4981391|   4981074|     0.02|1             |4981074                   |4981074               |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  TO_VARCHAR(S.LAST_REFRESH_TIME, 'YYYY/MM/DD HH24:MI:SS') REFRESH_TIME,
  S.HOST,
  LPAD(S.PORT, 5) PORT,
  S.SCHEMA_NAME1 SCHEMA_NAME_1,
  S.TABLE_NAME1 TABLE_NAME_1,
  S.COLUMN_NAME1 COLUMN_NAME_1,
  S.SCHEMA_NAME2 SCHEMA_NAME_2,
  S.TABLE_NAME2 TABLE_NAME_2,
  S.COLUMN_NAME2 COLUMN_NAME_2,
  LPAD(S.RECORD_COUNT1, 10) NUM_ROWS_1,
  LPAD(S.DISTINCT_COUNT1, 10) DISTINCT_1,
  LPAD(TO_DECIMAL(S.MEMORY_SIZE / 1024, 10, 2), 9) MEMORY_KB,
  S.VALUE_COUNTS1 VALUE_COUNTS_1,
  S.VALUE_COUNTS_FREQUENCIES1 VALUE_COUNTS_FREQUENCIES_1,
  S.MATCHING_VALUES_COUNTS1 MATCHING_VALUES_COUNTS
FROM
( SELECT
    CASE
      WHEN BEGIN_TIME =    'C'                             THEN CURRENT_TIMESTAMP
      WHEN BEGIN_TIME LIKE 'C-S%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-S'))
      WHEN BEGIN_TIME LIKE 'C-M%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-M') * 60)
      WHEN BEGIN_TIME LIKE 'C-H%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-H') * 3600)
      WHEN BEGIN_TIME LIKE 'C-D%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-D') * 86400)
      WHEN BEGIN_TIME LIKE 'C-W%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(BEGIN_TIME, 'C-W') * 86400 * 7)
      WHEN BEGIN_TIME LIKE 'E-S%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-S'))
      WHEN BEGIN_TIME LIKE 'E-M%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-M') * 60)
      WHEN BEGIN_TIME LIKE 'E-H%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-H') * 3600)
      WHEN BEGIN_TIME LIKE 'E-D%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-D') * 86400)
      WHEN BEGIN_TIME LIKE 'E-W%'                          THEN ADD_SECONDS(TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS'), -SUBSTR_AFTER(BEGIN_TIME, 'E-W') * 86400 * 7)
      WHEN BEGIN_TIME =    'MIN'                           THEN TO_TIMESTAMP('1000/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS')
      WHEN SUBSTR(BEGIN_TIME, 1, 1) NOT IN ('C', 'E', 'M') THEN TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS')
    END BEGIN_TIME,
    CASE
      WHEN END_TIME =    'C'                             THEN CURRENT_TIMESTAMP
      WHEN END_TIME LIKE 'C-S%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-S'))
      WHEN END_TIME LIKE 'C-M%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-M') * 60)
      WHEN END_TIME LIKE 'C-H%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-H') * 3600)
      WHEN END_TIME LIKE 'C-D%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-D') * 86400)
      WHEN END_TIME LIKE 'C-W%'                          THEN ADD_SECONDS(CURRENT_TIMESTAMP, -SUBSTR_AFTER(END_TIME, 'C-W') * 86400 * 7)
      WHEN END_TIME LIKE 'B+S%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+S'))
      WHEN END_TIME LIKE 'B+M%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+M') * 60)
      WHEN END_TIME LIKE 'B+H%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+H') * 3600)
      WHEN END_TIME LIKE 'B+D%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+D') * 86400)
      WHEN END_TIME LIKE 'B+W%'                          THEN ADD_SECONDS(TO_TIMESTAMP(BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS'), SUBSTR_AFTER(END_TIME, 'B+W') * 86400 * 7)
      WHEN END_TIME =    'MAX'                           THEN TO_TIMESTAMP('9999/12/31 00:00:00', 'YYYY/MM/DD HH24:MI:SS')
      WHEN SUBSTR(END_TIME, 1, 1) NOT IN ('C', 'B', 'M') THEN TO_TIMESTAMP(END_TIME, 'YYYY/MM/DD HH24:MI:SS')
    END END_TIME,
    TIMEZONE,
    HOST,
    PORT,
    SCHEMA_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    ORDER_BY
  FROM
  ( SELECT                    /* Modification section */
      '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
      '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
      'SERVER' TIMEZONE,                              /* SERVER, UTC */    
      '%' HOST,
      '%' PORT,
      '%' SCHEMA_NAME,
      '%' TABLE_NAME,
      '%' COLUMN_NAME,
      'TABLE' ORDER_BY            /* TABLE, REFRESH_TIME, MEMORY */
    FROM
      DUMMY
  )
) BI,
  M_JOIN_DATA_STATISTICS S
WHERE
  CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(S.LAST_REFRESH_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE S.LAST_REFRESH_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
  S.HOST LIKE BI.HOST AND
  TO_VARCHAR(S.PORT) LIKE BI.PORT AND
  ( S.SCHEMA_NAME1 LIKE BI.SCHEMA_NAME OR S.SCHEMA_NAME2 LIKE BI.SCHEMA_NAME ) AND
  ( S.TABLE_NAME1 LIKE BI.TABLE_NAME OR S.TABLE_NAME2 LIKE BI.TABLE_NAME ) AND
  ( S.COLUMN_NAME1 LIKE BI.COLUMN_NAME OR S.COLUMN_NAME2 LIKE BI.SCHEMA_NAME )
ORDER BY
  MAP(BI.ORDER_BY, 'TABLE', S.SCHEMA_NAME1 || S.TABLE_NAME1 || S.COLUMN_NAME1),
  MAP(BI.ORDER_BY, 'REFRESH_TIME', S.LAST_REFRESH_TIME) DESC,
  MAP(BI.ORDER_BY, 'MEMORY', S.MEMORY_SIZE) DESC