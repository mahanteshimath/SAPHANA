WITH 

/* 

[NAME]

- HANA_Tables_TopGrowingTables_Size_History_2.00.060+

[DESCRIPTION]

- Displays top growing (or top shrinking) tables for historic time frames

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- WITH clause available with SAP HANA 1.00.70 and higher
- HOST, PORT and PART_ID columns of GLOBAL_TABLE_PERSISTENCE_STATISTICS available starting with SAP HANA 2.00.000
- Per default historic sizes are collected every 6 hours, so smaller BEGIN_TIME / END_TIME intervals do not make sense.
- M_TABLE_PERSISTENCE_LOCATION_STATISTICS may not consider LOB sizes and show too low values for SAP HANA <= 2.00.037.05 and <= 2.00.046 (bug 242275)
- GLOBAL_TABLE_PERSISTENCE_STATICS is based on M_TABLE_PERSISTENCE_LOCATION_STATISTICS and so it may show too low values for SAP HANA <= 2.00.037.05 and <= 2.00.046 (bug 242275)
- Persistent memory information available with SAP HANA >= 2.00.030
- SITE_ID in history tables available with SAP HANA >= 2.0 SPS 06

[VALID FOR]

- Revisions:              >= 2.00.060

[SQL COMMAND VERSION]

- 2014/03/20:  1.0 (initial version)
- 2017/10/02:  1.1 (SPACE_LAYER respectively memory allocation comparison included)
- 2017/10/27:  1.2 (TIMEZONE included)
- 2018/02/27:  1.3 (dedicated 2.00.000+ version)
- 2018/12/04:  1.4 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2020/12/21:  1.5 (dedicated 2.00.030+ version including persistent memory consideration
- 2021/08/14:  1.6 (HOST, PORT added)
- 2021/08/16:  1.7 (AGGREGATE_BY added)
- 2022/05/27:  1.8 (dedicated 2.00.060+ version including SITE_ID for data source HISTORY)

[INVOLVED TABLES]

- GLOBAL_ROWSTORE_TABLES_SIZE
- GLOBAL_TABLE_PERSISTENCE_STATISTICS
- HOST_COLUMN_TABLES_PART_SIZE
- HOST_RS_INDEXES

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

- SPACE_LAYER

  Layer of space allocation to be used

  'DISK'   --> Disk space allocation
  'CURMEM' --> Current memory allocation
  'MAXMEM' --> Maximum memory allocation

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TABLE'         --> Aggregation by table
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

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
- SPACE_LAYER:   Space layer (CURMEM -> current memory allocation, MAXMEM -> maximum memory allocation, DISK -> disk space utilization)
- ST:            System replication site ID
- HOST:          Host name
- PORT:          Port
- SCHEMA_NAME:   Schema name
- TABLE_NAME:    Table name
- SIZE_BEGIN_MB: Disk size of table at begin time (MB)
- SIZE_END_MB:   Disk size of table at end time (MB)
- SIZE_CHG_MB:   Change of table size between begin time and end time (MB)
- CHG_PCT:       Change of table size between begin time and end time (%)

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------------------
|BEGIN_TIME      |END_TIME        |SCHEMA_NAME|TABLE_NAME      |SIZE_BEGIN_MB|SIZE_END_MB|SIZE_CHG_MB|CHG_PCT|
--------------------------------------------------------------------------------------------------------------
|2014/02/19 01:00|2014/03/20 01:00|SAPSR3     |/BIC/B0000495000|      5726.01|   14907.51|    9181.49| 160.34|
|2014/02/19 01:00|2014/03/20 01:00|SAPSR3     |/BIC/FZOCEUC09B |      6610.86|   11665.28|    5054.42|  76.45|
|2014/02/19 01:00|2014/03/20 01:00|SAPSR3     |/BIC/FZOCEUC13  |      2515.96|    7423.29|    4907.32| 195.04|
|2014/02/19 01:00|2014/03/20 01:00|SAPSR3     |EDI40           |     14154.69|   16907.36|    2752.66|  19.44|
|2014/02/19 01:00|2014/03/20 01:00|SAPSR3     |/BIC/AZOCEUO9000|     18500.73|   21027.94|    2527.21|  13.66|
|2014/02/19 01:00|2014/03/20 01:00|SAPSR3     |/BIC/FZOCEUC21B |      3565.23|    5980.00|    2414.76|  67.73|
|2014/02/19 01:00|2014/03/20 01:00|SAPSR3     |/BIC/FZIACEUC04 |      1712.36|    3278.03|    1565.66|  91.43|
|2014/02/19 01:00|2014/03/20 01:00|SAPSR3     |/BIC/AZSCXXO2240|        16.45|    1187.45|    1171.00|7117.18|
|2014/02/19 01:00|2014/03/20 01:00|SAPSR3     |/BIC/B0007733000|       732.41|    1839.94|    1107.53| 151.21|
|2014/02/19 01:00|2014/03/20 01:00|SAPSR3     |/BIC/B0000396000|      4333.07|    5391.08|    1058.00|  24.41|
--------------------------------------------------------------------------------------------------------------

*/

BASIS_INFO AS
( SELECT
    BEGIN_TIME,
    END_TIME,
    ( SELECT MIN(SERVER_TIMESTAMP) FROM _SYS_STATISTICS.GLOBAL_TABLE_PERSISTENCE_STATISTICS T WHERE CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.SERVER_TIMESTAMP END >= BI.BEGIN_TIME ) DISK_BEGIN_TIME,
    ( SELECT MAX(SERVER_TIMESTAMP) FROM _SYS_STATISTICS.GLOBAL_TABLE_PERSISTENCE_STATISTICS T WHERE CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.SERVER_TIMESTAMP END <= BI.END_TIME ) DISK_END_TIME,
    ( SELECT MIN(SERVER_TIMESTAMP) FROM _SYS_STATISTICS.GLOBAL_ROWSTORE_TABLES_SIZE T WHERE CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.SERVER_TIMESTAMP END >= BI.BEGIN_TIME ) MEM_ROW_TAB_BEGIN_TIME,
    ( SELECT MAX(SERVER_TIMESTAMP) FROM _SYS_STATISTICS.GLOBAL_ROWSTORE_TABLES_SIZE T WHERE CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.SERVER_TIMESTAMP END <= BI.END_TIME ) MEM_ROW_TAB_END_TIME,
    ( SELECT MIN(SERVER_TIMESTAMP) FROM _SYS_STATISTICS.HOST_RS_INDEXES T WHERE CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.SERVER_TIMESTAMP END >= BI.BEGIN_TIME ) MEM_ROW_IND_BEGIN_TIME,
    ( SELECT MAX(SERVER_TIMESTAMP) FROM _SYS_STATISTICS.HOST_RS_INDEXES T WHERE CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.SERVER_TIMESTAMP END <= BI.END_TIME ) MEM_ROW_IND_END_TIME,
    ( SELECT MIN(SERVER_TIMESTAMP) FROM _SYS_STATISTICS.HOST_COLUMN_TABLES_PART_SIZE T WHERE CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.SERVER_TIMESTAMP END >= BI.BEGIN_TIME ) MEM_COL_TAB_BEGIN_TIME,
    ( SELECT MAX(SERVER_TIMESTAMP) FROM _SYS_STATISTICS.HOST_COLUMN_TABLES_PART_SIZE T WHERE CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(T.SERVER_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE T.SERVER_TIMESTAMP END <= BI.END_TIME ) MEM_COL_TAB_END_TIME,
    SITE_ID,
    HOST,
    PORT,
    SCHEMA_NAME,
    TABLE_NAME,
    SPACE_LAYER,
    AGGREGATE_BY,
    SORT_ORDER,
    RESULT_ROWS
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
      SITE_ID,
      HOST,
      PORT,
      SCHEMA_NAME,
      TABLE_NAME,
      SPACE_LAYER,
      AGGREGATE_BY,
      SORT_ORDER,
      RESULT_ROWS
    FROM
    ( SELECT                         /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        'SERVER' TIMEZONE,                              /* SERVER, UTC */
        -1 SITE_ID,
        '%' HOST,
        '%' PORT,
        '%' SCHEMA_NAME,
        '%' TABLE_NAME,
        'DISK' SPACE_LAYER,        /* CURMEM, MAXMEM, DISK */
        'TABLE' AGGREGATE_BY,         /* SITE_ID, SCHEMA, TABLE, HOST, PORT */
        'DESC' SORT_ORDER,            /* ASC to show top shrinking tables, DESC to show top growing tables */
        50 RESULT_ROWS
      FROM
        DUMMY
    )
  ) BI
)
SELECT
  TO_VARCHAR(BEGIN_TIME, 'YYYY/MM/DD HH24:MI') BEGIN_TIME,
  TO_VARCHAR(END_TIME, 'YYYY/MM/DD HH24:MI') END_TIME,
  SPACE_LAYER,
  IFNULL(LPAD(SITE_ID, 2), '') ST,
  HOST,
  LPAD(PORT, 5) PORT,
  SCHEMA_NAME,
  TABLE_NAME,
  SIZE_BEGIN_MB,
  SIZE_END_MB,
  SIZE_CHG_MB,
  CHG_PCT
FROM
( SELECT
    BEGIN_TIME,
    END_TIME,
    SPACE_LAYER,
    SITE_ID,
    HOST,
    PORT,
    SCHEMA_NAME,
    TABLE_NAME,
    LPAD(TO_DECIMAL(SIZE_BEGIN_MB, 10, 2), 13) SIZE_BEGIN_MB,
    LPAD(TO_DECIMAL(SIZE_END_MB, 10, 2), 11) SIZE_END_MB,
    LPAD(TO_DECIMAL(SIZE_END_MB - SIZE_BEGIN_MB, 10, 2), 11) SIZE_CHG_MB,
    LPAD(TO_DECIMAL(LEAST(MAP(SIZE_BEGIN_MB, 0, 9999, (SIZE_END_MB - SIZE_BEGIN_MB) / SIZE_BEGIN_MB * 100), 9999.99), 10, 2), 7) CHG_PCT,
    ROW_NUMBER () OVER (ORDER BY MAP(SORT_ORDER, 'ASC', SIZE_END_MB - SIZE_BEGIN_MB, SIZE_BEGIN_MB - SIZE_END_MB)) ROW_NUM,
    RESULT_ROWS
  FROM
  ( SELECT
      MAP(BI.SPACE_LAYER, 'DISK', BI.DISK_BEGIN_TIME, LEAST(BI.MEM_ROW_TAB_BEGIN_TIME, BI.MEM_ROW_IND_BEGIN_TIME, BI.MEM_COL_TAB_BEGIN_TIME)) BEGIN_TIME,
      MAP(BI.SPACE_LAYER, 'DISK', BI.DISK_END_TIME, LEAST(BI.MEM_ROW_TAB_END_TIME, BI.MEM_ROW_IND_END_TIME, BI.MEM_COL_TAB_END_TIME)) END_TIME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SITE_ID') != 0 THEN TO_VARCHAR(TE.SITE_ID) ELSE MAP(BI.SITE_ID,      -1, 'any', TO_VARCHAR(BI.SITE_ID)) END SITE_ID,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')    != 0 THEN TE.HOST                ELSE MAP(BI.HOST,        '%', 'any', BI.HOST)                END HOST,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(TE.PORT)    ELSE MAP(BI.PORT,        '%', 'any', BI.PORT)                END PORT,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')  != 0 THEN TE.SCHEMA_NAME         ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)         END SCHEMA_NAME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')   != 0 THEN TE.TABLE_NAME          ELSE MAP(BI.TABLE_NAME,  '%', 'any', BI.TABLE_NAME)          END TABLE_NAME,
      SUM(TE.SIZE_END) / 1024 / 1024 SIZE_END_MB,
      SUM(IFNULL(TE.SIZE_BEGIN, 0)) / 1024 / 1024 SIZE_BEGIN_MB,
      BI.SPACE_LAYER,
      BI.RESULT_ROWS,
      BI.SORT_ORDER
    FROM
      BASIS_INFO BI,
    ( SELECT
        TE.SITE_ID,
        TE.HOST,
        TE.PORT,
        TE.SCHEMA_NAME,
        TE.TABLE_NAME,
        TE.DISK_SIZE SIZE_END,
        TB.DISK_SIZE SIZE_BEGIN
      FROM
        BASIS_INFO BI INNER JOIN
        _SYS_STATISTICS.GLOBAL_TABLE_PERSISTENCE_STATISTICS TE ON
          TE.SERVER_TIMESTAMP = BI.DISK_END_TIME AND
          ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND TE.SITE_ID IN (-1, 0) ) OR TE.SITE_ID = BI.SITE_ID ) AND
          TE.HOST LIKE BI.HOST AND
          TO_VARCHAR(TE.PORT) LIKE BI.PORT AND
          UPPER(TE.SCHEMA_NAME) LIKE UPPER(BI.SCHEMA_NAME) AND
          UPPER(TE.TABLE_NAME) LIKE UPPER(BI.TABLE_NAME) LEFT OUTER JOIN
        _SYS_STATISTICS.GLOBAL_TABLE_PERSISTENCE_STATISTICS TB ON
          TB.SERVER_TIMESTAMP = BI.DISK_BEGIN_TIME AND
          ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND TB.SITE_ID IN (-1, 0) ) OR TB.SITE_ID = BI.SITE_ID ) AND
          TB.SCHEMA_NAME = TE.SCHEMA_NAME AND
          TB.TABLE_NAME = TE.TABLE_NAME AND
          TB.PART_ID = TE.PART_ID          
      WHERE
        BI.SPACE_LAYER = 'DISK'
      UNION ALL
      SELECT
        TE.SITE_ID,
        TE.HOST,
        TE.PORT,
        TE.SCHEMA_NAME,
        TE.TABLE_NAME,
        TE.ALLOCATED_FIXED_PART_SIZE + TE.ALLOCATED_VARIABLE_PART_SIZE SIZE_END,
        TB.ALLOCATED_FIXED_PART_SIZE + TB.ALLOCATED_VARIABLE_PART_SIZE SIZE_BEGIN
      FROM
        BASIS_INFO BI INNER JOIN
        _SYS_STATISTICS.GLOBAL_ROWSTORE_TABLES_SIZE TE ON
          ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND TE.SITE_ID IN (-1, 0) ) OR TE.SITE_ID = BI.SITE_ID ) AND
          TE.SERVER_TIMESTAMP = BI.MEM_ROW_TAB_END_TIME AND
          TE.HOST LIKE BI.HOST AND
          TO_VARCHAR(TE.PORT) LIKE BI.PORT AND
          UPPER(TE.SCHEMA_NAME) LIKE UPPER(BI.SCHEMA_NAME) AND
          UPPER(TE.TABLE_NAME) LIKE UPPER(BI.TABLE_NAME) LEFT OUTER JOIN
        _SYS_STATISTICS.GLOBAL_ROWSTORE_TABLES_SIZE TB ON
          ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND TB.SITE_ID IN (-1, 0) ) OR TB.SITE_ID = BI.SITE_ID ) AND
          TB.SERVER_TIMESTAMP = BI.MEM_ROW_TAB_BEGIN_TIME AND
          TB.SCHEMA_NAME = TE.SCHEMA_NAME AND
          TB.TABLE_NAME = TE.TABLE_NAME
      WHERE
        BI.SPACE_LAYER IN ('CURMEM', 'MAXMEM')
      UNION ALL
      SELECT
        TE.SITE_ID,
        TE.HOST,
        TE.PORT,
        TE.SCHEMA_NAME,
        TE.TABLE_NAME,
        TE.INDEX_SIZE SIZE_END,
        TB.INDEX_SIZE SIZE_BEGIN
      FROM
        BASIS_INFO BI INNER JOIN
        _SYS_STATISTICS.HOST_RS_INDEXES TE ON
          TE.SERVER_TIMESTAMP = BI.MEM_ROW_IND_END_TIME AND
          ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND TE.SITE_ID IN (-1, 0) ) OR TE.SITE_ID = BI.SITE_ID ) AND
          TE.HOST LIKE BI.HOST AND
          TO_VARCHAR(TE.PORT) LIKE BI.PORT AND
          UPPER(TE.SCHEMA_NAME) LIKE UPPER(BI.SCHEMA_NAME) AND
          UPPER(TE.TABLE_NAME) LIKE UPPER(BI.TABLE_NAME) LEFT OUTER JOIN
        _SYS_STATISTICS.HOST_RS_INDEXES TB ON
          TB.SERVER_TIMESTAMP = BI.MEM_ROW_IND_BEGIN_TIME AND
          ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND TB.SITE_ID IN (-1, 0) ) OR TB.SITE_ID = BI.SITE_ID ) AND
          TB.SCHEMA_NAME = TE.SCHEMA_NAME AND
          TB.TABLE_NAME = TE.TABLE_NAME
      WHERE
        BI.SPACE_LAYER IN ('CURMEM', 'MAXMEM')
      UNION ALL
      SELECT
        TE.SITE_ID,
        TE.HOST,
        TE.PORT,
        TE.SCHEMA_NAME,
        TE.TABLE_NAME,
        MAP(BI.SPACE_LAYER, 'CURMEM', TE.MEMORY_SIZE_IN_TOTAL + TE.PERSISTENT_MEMORY_SIZE_IN_TOTAL, 'MAXMEM', TE.ESTIMATED_MAX_MEMORY_SIZE_IN_TOTAL) SIZE_END,
        MAP(BI.SPACE_LAYER, 'CURMEM', TB.MEMORY_SIZE_IN_TOTAL + TE.PERSISTENT_MEMORY_SIZE_IN_TOTAL, 'MAXMEM', TB.ESTIMATED_MAX_MEMORY_SIZE_IN_TOTAL) SIZE_BEGIN
      FROM
        BASIS_INFO BI INNER JOIN
        _SYS_STATISTICS.HOST_COLUMN_TABLES_PART_SIZE TE ON
          TE.SERVER_TIMESTAMP = BI.MEM_COL_TAB_END_TIME AND
          ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND TE.SITE_ID IN (-1, 0) ) OR TE.SITE_ID = BI.SITE_ID ) AND
          TE.HOST LIKE BI.HOST AND
          TO_VARCHAR(TE.PORT) LIKE BI.PORT AND
          UPPER(TE.SCHEMA_NAME) LIKE UPPER(BI.SCHEMA_NAME) AND
          UPPER(TE.TABLE_NAME) LIKE UPPER(BI.TABLE_NAME) LEFT OUTER JOIN
        _SYS_STATISTICS.HOST_COLUMN_TABLES_PART_SIZE TB ON
          TB.SERVER_TIMESTAMP = BI.MEM_COL_TAB_BEGIN_TIME AND
          ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND TB.SITE_ID IN (-1, 0) ) OR TB.SITE_ID = BI.SITE_ID ) AND
          TB.SCHEMA_NAME = TE.SCHEMA_NAME AND
          TB.TABLE_NAME = TE.TABLE_NAME AND
          TB.PART_ID = TE.PART_ID
      WHERE
        BI.SPACE_LAYER IN ('CURMEM', 'MAXMEM')
    ) TE
    GROUP BY
      MAP(BI.SPACE_LAYER, 'DISK', BI.DISK_BEGIN_TIME, LEAST(BI.MEM_ROW_TAB_BEGIN_TIME, BI.MEM_ROW_IND_BEGIN_TIME, BI.MEM_COL_TAB_BEGIN_TIME)),
      MAP(BI.SPACE_LAYER, 'DISK', BI.DISK_END_TIME, LEAST(BI.MEM_ROW_TAB_END_TIME, BI.MEM_ROW_IND_END_TIME, BI.MEM_COL_TAB_END_TIME)),
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SITE_ID') != 0 THEN TO_VARCHAR(TE.SITE_ID) ELSE MAP(BI.SITE_ID,      -1, 'any', TO_VARCHAR(BI.SITE_ID)) END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')    != 0 THEN TE.HOST                ELSE MAP(BI.HOST,        '%', 'any', BI.HOST)                END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(TE.PORT)    ELSE MAP(BI.PORT,        '%', 'any', BI.PORT)                END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCHEMA')  != 0 THEN TE.SCHEMA_NAME         ELSE MAP(BI.SCHEMA_NAME, '%', 'any', BI.SCHEMA_NAME)         END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TABLE')   != 0 THEN TE.TABLE_NAME          ELSE MAP(BI.TABLE_NAME,  '%', 'any', BI.TABLE_NAME)          END,
      BI.SPACE_LAYER,
      BI.RESULT_ROWS,
      BI.SORT_ORDER
  )
  ORDER BY MAP(SORT_ORDER, 'ASC', SIZE_END_MB - SIZE_BEGIN_MB, SIZE_BEGIN_MB - SIZE_END_MB)
)
WHERE
  ( RESULT_ROWS = -1 OR ROW_NUM <= RESULT_ROWS)
