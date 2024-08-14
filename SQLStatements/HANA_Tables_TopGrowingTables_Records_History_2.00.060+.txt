WITH

/* 

[NAME]

- HANA_Tables_TopGrowingTables_Records_History_2.00.060+

[DESCRIPTION]

- Displays top growing (or top shrinking) tables in terms of records for historic time frames

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Histories contains information from both sites of active/active (read-enabled) system replication scenarios
- SITE_ID in history tables available with SAP HANA >= 2.0 SPS 06

[VALID FOR]

- Revisions:              >= 2.00.060

[SQL COMMAND VERSION]

- 2014/07/07:  1.0 (initial version)
- 2017/10/27:  1.1 (TIMEZONE included)
- 2018/12/04:  1.2 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2019/02/20:  1.3 (PART_ID included)
- 2022/05/27:  1.4 (dedicated 2.00.060+ version including SITE_ID for data source HISTORY)

[INVOLVED TABLES]

- GLOBAL_ROWSTORE_TABLES_SIZE
- HOST_COLUMN_TABLES_PART_SIZE

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

- SITE_ID

  System replication site ID (may only work for DATA_SOURCE = 'HISTORY')

  -1             --> No restriction related to site ID
  1              --> Site id 1

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

- PART_ID

  Partition number

  2               --> Only show information for partition number 2
  -1              --> No restriction related to partition number

- OBJECT_LEVEL

  Controls display of partitions

  'PARTITION'     --> Result is shown on partition level
  'TABLE'         --> Result is shown on table level

- SORT_ORDER

  Order of sorting (ascending vs. descending)

  'ASC'           --> Ascending sort
  'DESC'          --> Descending sort

- RESULT_ROWS

  Number of records to be returned by the query

  100             --> Return a maximum number of 100 records
  -1              --> Return all records

 
[OUTPUT PARAMETERS]

- BEGIN_TIME:    Begin time (first timestamp for comparison)
- END_TIME:      End time (second timestamp for comparison)
- ST:            System replication site ID
- SCHEMA_NAME:   Schema name
- TABLE_NAME:    Table name
- RECORDS_BEGIN: Number of records in table at begin time
- RECORDS_END:   Number of records in table at end time
- RECORDS_CHG:   Change of table records between begin time and end time
- CHG_PCT:       Change of table records between begin time and end time (in %)

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------
|BEGIN_TIME      |END_TIME        |SCHEMA_NAME    |TABLE_NAME          |RECORDS_BEGIN |RECORDS_END |RECORDS_CHG   |CHG_PCT|
---------------------------------------------------------------------------------------------------------------------------
|2014/07/06 00:18|2014/07/07 17:18|SAPECC         |KONV                |    6455028892|  6649269701|     194240809|   3.00|
|2014/07/06 00:18|2014/07/07 17:18|SAPECC         |EDID4               |     476726473|   582670648|     105944175|  22.22|
|2014/07/06 00:18|2014/07/07 17:18|SAPECC         |CDPOS               |     479654679|   496547779|      16893100|   3.52|
|2014/07/06 00:18|2014/07/07 17:18|SAPECC         |VBFA                |     430817564|   443739169|      12921605|   2.99|
|2014/07/06 00:18|2014/07/07 17:18|SAPECC         |VBFS                |     104527224|   113030609|       8503385|   8.13|
|2014/07/06 00:18|2014/07/07 17:18|SAPECC         |S888                |      73570405|    80847224|       7276819|   9.89|
|2014/07/06 00:18|2014/07/07 17:18|SAPECC         |VBRP                |     192487703|   197322525|       4834822|   2.51|
|2014/07/06 00:18|2014/07/07 17:18|SAPECC         |VRPMA               |     194535425|   199370247|       4834822|   2.48|
|2014/07/06 00:18|2014/07/07 17:18|SAPECC         |BSEG                |     786306637|   790668540|       4361903|   0.55|
|2014/07/06 00:18|2014/07/07 17:18|SAPECC         |CDHDR               |      90237877|    93823903|       3586026|   3.97|
|2014/07/06 00:18|2014/07/07 17:18|SAPECC         |ZBW10               |          3686|     3491130|       3487444|9999.99|
|2014/07/06 00:18|2014/07/07 17:18|SAPECC         |BDCP2               |      22591363|    25956324|       3364961|  14.89|
---------------------------------------------------------------------------------------------------------------------------

*/

BASIS_INFO AS
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
    SITE_ID,
    SCHEMA_NAME,
    TABLE_NAME,
    PART_ID,
    OBJECT_LEVEL,
    SORT_ORDER,
    RESULT_ROWS
  FROM
  ( SELECT                         /* Modification section */
      '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
      '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
      'SERVER' TIMEZONE,                              /* SERVER, UTC */
      -1 SITE_ID,
      '%' SCHEMA_NAME,
      '%' TABLE_NAME,
       -1 PART_ID,
       'PARTITION' OBJECT_LEVEL,    /* TABLE, PARTITION */
      'DESC' SORT_ORDER,            /* ASC to show top shrinking tables, DESC to show top growing tables */
      50 RESULT_ROWS
    FROM
      DUMMY
  )
)
SELECT
  TO_VARCHAR(BEGIN_TIME, 'YYYY/MM/DD HH24:MI') BEGIN_TIME,
  TO_VARCHAR(END_TIME, 'YYYY/MM/DD HH24:MI') END_TIME,
  IFNULL(LPAD(SITE_ID, 2), '') ST,
  SCHEMA_NAME,
  TABLE_NAME,
  RECORDS_BEGIN,
  RECORDS_END,
  RECORDS_CHG,
  CHG_PCT
FROM
( SELECT
    BEGIN_TIME,
    END_TIME,
    SITE_ID,
    SCHEMA_NAME,
    TABLE_NAME,
    LPAD(RECORDS_BEGIN, 14) RECORDS_BEGIN,
    LPAD(RECORDS_END, 12) RECORDS_END,
    LPAD(RECORDS_END - RECORDS_BEGIN, 14) RECORDS_CHG,
    LPAD(TO_DECIMAL(LEAST(MAP(RECORDS_BEGIN, 0, 9999, (RECORDS_END - RECORDS_BEGIN) / RECORDS_BEGIN * 100), 9999.99), 10, 2), 7) CHG_PCT,
    ROW_NUMBER () OVER (ORDER BY MAP(SORT_ORDER, 'ASC', RECORDS_END - RECORDS_BEGIN, RECORDS_BEGIN - RECORDS_END)) ROW_NUM,
    RESULT_ROWS
  FROM
  ( SELECT
      BI.BEGIN_TIME,
      BI.END_TIME,
      TE.SCHEMA_NAME,
      TE.TABLE_NAME,
      TE.SITE_ID,
      TE.RECORD_COUNT RECORDS_END,
      IFNULL(TB.RECORD_COUNT, 0) RECORDS_BEGIN,
      BI.RESULT_ROWS,
      BI.SORT_ORDER
    FROM
    ( SELECT
        LEAST(BEGIN_TIME_COL, BEGIN_TIME_ROW) BEGIN_TIME,
        GREATEST(END_TIME_COL, END_TIME_ROW) END_TIME,
        BEGIN_TIME_COL,
        END_TIME_COL,
        BEGIN_TIME_ROW,
        END_TIME_ROW,
        SITE_ID,
        SCHEMA_NAME,
        TABLE_NAME,
        PART_ID,
        OBJECT_LEVEL,
        SORT_ORDER,
        RESULT_ROWS
      FROM
      ( SELECT
          ( SELECT MIN(SERVER_TIMESTAMP) FROM _SYS_STATISTICS.HOST_COLUMN_TABLES_PART_SIZE T WHERE CASE TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.SERVER_TIMESTAMP END >= BI.BEGIN_TIME ) BEGIN_TIME_COL,
          ( SELECT MAX(SERVER_TIMESTAMP) FROM _SYS_STATISTICS.HOST_COLUMN_TABLES_PART_SIZE T WHERE CASE TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.SERVER_TIMESTAMP END <= BI.END_TIME ) END_TIME_COL,
          ( SELECT MIN(SERVER_TIMESTAMP) FROM _SYS_STATISTICS.GLOBAL_ROWSTORE_TABLES_SIZE T WHERE CASE TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.SERVER_TIMESTAMP END >= BI.BEGIN_TIME ) BEGIN_TIME_ROW,
          ( SELECT MAX(SERVER_TIMESTAMP) FROM _SYS_STATISTICS.GLOBAL_ROWSTORE_TABLES_SIZE T WHERE CASE TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.SERVER_TIMESTAMP END <= BI.END_TIME ) END_TIME_ROW,
          SITE_ID,
          SCHEMA_NAME,
          TABLE_NAME,
          PART_ID,
          OBJECT_LEVEL,
          SORT_ORDER,
          RESULT_ROWS
        FROM
          BASIS_INFO BI
      )
    ) BI INNER JOIN
    ( SELECT 
        T.SERVER_TIMESTAMP,
        T.SITE_ID,
        T.SCHEMA_NAME, 
        T.TABLE_NAME || MAP(BI.OBJECT_LEVEL, 'TABLE', '', MAP(T.PART_ID, 0, '', CHAR(32) || '(' || T.PART_ID || ')')) TABLE_NAME,
        'COLUMN' STORE,
        SUM(T.RECORD_COUNT) RECORD_COUNT 
      FROM
        BASIS_INFO BI,
        _SYS_STATISTICS.HOST_COLUMN_TABLES_PART_SIZE T
      WHERE
        ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND T.SITE_ID IN (-1, 0) ) OR T.SITE_ID = BI.SITE_ID ) AND
        T.TABLE_NAME LIKE BI.TABLE_NAME AND
        ( BI.PART_ID = -1 OR T.PART_ID = BI.PART_ID )
      GROUP BY
        T.SERVER_TIMESTAMP,
        T.SITE_ID,
        T.SCHEMA_NAME,
        T.TABLE_NAME || MAP(BI.OBJECT_LEVEL, 'TABLE', '', MAP(T.PART_ID, 0, '', CHAR(32) || '(' || T.PART_ID || ')'))
      UNION ALL
      SELECT 
        T.SERVER_TIMESTAMP,
        T.SITE_ID,
        T.SCHEMA_NAME, 
        T.TABLE_NAME,
        'ROW' STORE,
        T.RECORD_COUNT
      FROM
        BASIS_INFO BI,
        _SYS_STATISTICS.GLOBAL_ROWSTORE_TABLES_SIZE T
      WHERE
        ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND T.SITE_ID IN (-1, 0) ) OR T.SITE_ID = BI.SITE_ID ) AND
        T.TABLE_NAME LIKE BI.TABLE_NAME AND
        ( BI.PART_ID = -1 OR 0 = BI.PART_ID )
    ) TE ON
        ( TE.STORE = 'ROW' AND TE.SERVER_TIMESTAMP = BI.END_TIME_ROW OR
          TE.STORE = 'COLUMN' AND TE.SERVER_TIMESTAMP = BI.END_TIME_COL ) AND
        UPPER(TE.SCHEMA_NAME) LIKE UPPER(BI.SCHEMA_NAME) LEFT OUTER JOIN
    ( SELECT 
        T.SERVER_TIMESTAMP,
        T.SITE_ID,
        T.SCHEMA_NAME, 
        T.TABLE_NAME || MAP(BI.OBJECT_LEVEL, 'TABLE', '', MAP(T.PART_ID, 0, '', CHAR(32) || '(' || T.PART_ID || ')')) TABLE_NAME,
        'COLUMN' STORE,
        SUM(T.RECORD_COUNT) RECORD_COUNT 
      FROM
        BASIS_INFO BI,
        _SYS_STATISTICS.HOST_COLUMN_TABLES_PART_SIZE T
      WHERE
        ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND T.SITE_ID IN (-1, 0) ) OR T.SITE_ID = BI.SITE_ID ) AND
        T.TABLE_NAME LIKE BI.TABLE_NAME AND
        ( BI.PART_ID = -1 OR T.PART_ID = BI.PART_ID )
      GROUP BY
        T.SERVER_TIMESTAMP,
        T.SITE_ID,
        T.SCHEMA_NAME,
        T.TABLE_NAME || MAP(BI.OBJECT_LEVEL, 'TABLE', '', MAP(T.PART_ID, 0, '', CHAR(32) || '(' || T.PART_ID || ')'))
      UNION ALL
      SELECT 
        T.SERVER_TIMESTAMP,
        T.SITE_ID,
        T.SCHEMA_NAME, 
        T.TABLE_NAME,
        'ROW' STORE,
        T.RECORD_COUNT
      FROM
        BASIS_INFO BI,
        _SYS_STATISTICS.GLOBAL_ROWSTORE_TABLES_SIZE T
      WHERE
        ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND T.SITE_ID IN (-1, 0) ) OR T.SITE_ID = BI.SITE_ID ) AND
        T.TABLE_NAME LIKE BI.TABLE_NAME AND
        ( BI.PART_ID = -1 OR 0 = BI.PART_ID )
    ) TB ON
        ( TB.STORE = 'ROW' AND TB.SERVER_TIMESTAMP = BI.BEGIN_TIME_ROW OR
          TB.STORE = 'COLUMN' AND TB.SERVER_TIMESTAMP = BI.BEGIN_TIME_COL ) AND
        TB.SITE_ID = TE.SITE_ID AND
        TB.SCHEMA_NAME = TE.SCHEMA_NAME AND
        TB.TABLE_NAME = TE.TABLE_NAME
  )
  ORDER BY MAP(SORT_ORDER, 'ASC', RECORDS_END - RECORDS_BEGIN, RECORDS_BEGIN - RECORDS_END)
)
WHERE
  ( RESULT_ROWS = -1 OR ROW_NUM <= RESULT_ROWS)

