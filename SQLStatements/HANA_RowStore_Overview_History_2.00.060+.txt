SELECT

/* 

[NAME]

- HANA_RowStore_Overview_History_2.00.060+

[DESCRIPTION]

- Historic row store overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- See SAP Note 1813245 for row store fragmentation
- SITE_ID in history tables available with SAP HANA >= 2.0 SPS 06

[VALID FOR]

- Revisions:              >= 2.00.060

[SQL COMMAND VERSION]

- 2016/01/29:  1.0 (initial version)
- 2016/12/31:  1.1 (TIME_AGGREGATE_BY = 'TS<seconds>' included)
- 2017/10/26:  1.2 (TIMEZONE included)
- 2018/12/04:  1.3 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2022/05/26:  1.4 (dedicated 2.00.060+ version including SITE_ID for data source HISTORY)

[INVOLVED TABLES]

- M_RS_MEMORY
- HOST_RS_MEMORY

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

  'saphana01'     --> Specic host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- PORT

  Port number

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'RESET'         --> Data from reset information (*_RESET tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)

- KEY_FIGURE

  Memory key figure (allocated memory, used memory, main memory, delta memory, ...)

  'USED'          --> Used memory
  'ALLOC'         --> Allocated memory
  'FREE'          --> Free memory

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOST'          --> Aggregation by host
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation

[OUTPUT PARAMETERS]

- SNAPSHOT_TIME: Timestamp
- ST:            System replication site ID
- HOST:          Host name
- PORT:          Port
- KEY_FIGURE:    Key figure related to memory sizes
- TOTAL_GB:      Total (allocated) size (GB)
- TABLE_GB:      Table size (GB)
- CATALOG_GB:    Catalog size (GB)
- INDEX_GB:      Index size (GB)
- VERSION_GB:    Version size (GB)
- PAGELIST_GB:   Pagelist size (GB)
- LOCK_GB:       Lock table size (GB)

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------
|SNAPSHOT_TIME|HOST|PORT |SERVICE|KEY_FIGURE|TOTAL_GB|TABLE_GB|CATALOG_GB|INDEX_GB|VERSION_GB|PAGELIST_GB|LOCK_GB |
-------------------------------------------------------------------------------------------------------------------
|2016/01/26 06|any |  any|any    |FREE      |   62.83|   62.74|      0.07|    0.00|      0.01|       0.00|    0.00|
|2016/01/26 05|any |  any|any    |FREE      |   62.84|   62.75|      0.07|    0.00|      0.01|       0.00|    0.00|
|2016/01/26 04|any |  any|any    |FREE      |   62.83|   62.75|      0.07|    0.00|      0.01|       0.00|    0.00|
|2016/01/26 03|any |  any|any    |FREE      |   62.80|   62.71|      0.07|    0.00|      0.01|       0.00|    0.00|
|2016/01/26 02|any |  any|any    |FREE      |   62.84|   62.75|      0.07|    0.00|      0.01|       0.00|    0.00|
|2016/01/26 01|any |  any|any    |FREE      |   62.73|   62.65|      0.06|    0.00|      0.00|       0.00|    0.00|
|2016/01/26 00|any |  any|any    |FREE      |   63.05|   62.96|      0.06|    0.00|      0.01|       0.00|    0.00|
|2016/01/25 23|any |  any|any    |FREE      |   62.98|   62.89|      0.06|    0.00|      0.01|       0.00|    0.00|
|2016/01/25 22|any |  any|any    |FREE      |   63.08|   62.99|      0.06|    0.00|      0.01|       0.00|    0.00|
|2016/01/25 21|any |  any|any    |FREE      |   63.10|   63.01|      0.06|    0.00|      0.01|       0.00|    0.00|
|2016/01/25 20|any |  any|any    |FREE      |   63.10|   63.01|      0.06|    0.00|      0.01|       0.00|    0.00|
|2016/01/25 19|any |  any|any    |FREE      |   63.09|   63.01|      0.06|    0.00|      0.01|       0.00|    0.00|
|2016/01/25 18|any |  any|any    |FREE      |   62.98|   62.89|      0.06|    0.00|      0.01|       0.00|    0.00|
|2016/01/25 17|any |  any|any    |FREE      |    3.11|    2.99|      0.11|    0.00|      0.00|       0.00|    0.00|
|2016/01/25 16|any |  any|any    |FREE      |    3.11|    2.99|      0.11|    0.00|      0.00|       0.00|    0.00|
|2016/01/25 15|any |  any|any    |FREE      |    3.11|    2.99|      0.11|    0.00|      0.00|       0.00|    0.00|
|2016/01/25 14|any |  any|any    |FREE      |    3.11|    2.99|      0.11|    0.00|      0.00|       0.00|    0.00|
-------------------------------------------------------------------------------------------------------------------

*/

  SNAPSHOT_TIME,
  IFNULL(LPAD(SITE_ID, 2), '') ST,
  HOST,
  LPAD(PORT, 5) PORT,
  KEY_FIGURE,
  LPAD(TO_DECIMAL(TOTAL_GB, 10, 2), 8) TOTAL_GB,
  LPAD(TO_DECIMAL(TABLE_GB, 10, 2), 8) TABLE_GB,
  LPAD(TO_DECIMAL(CATALOG_GB, 10, 2), 10) CATALOG_GB,
  LPAD(TO_DECIMAL(INDEX_GB, 10, 2), 8) INDEX_GB,
  LPAD(TO_DECIMAL(VERSION_GB, 10, 2), 10) VERSION_GB,
  LPAD(TO_DECIMAL(PAGELIST_GB, 10, 2), 11) PAGELIST_GB,
  LPAD(TO_DECIMAL(LOCKTABLE_GB, 10, 2), 8) LOCK_GB
FROM
( SELECT
    CASE 
      WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), SNAPSHOT_TIME) / SUBSTR(TIME_AGGREGATE_BY, 3)) * SUBSTR(TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(SNAPSHOT_TIME, TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END SNAPSHOT_TIME,
    SITE_ID,
    HOST,
    PORT,
    KEY_FIGURE,
    AVG(TOTAL_GB) TOTAL_GB,
    AVG(TABLE_GB) TABLE_GB,
    AVG(CATALOG_GB) CATALOG_GB,
    AVG(INDEX_GB) INDEX_GB,
    AVG(VERSION_GB) VERSION_GB,
    AVG(PAGELIST_GB) PAGELIST_GB,
    AVG(LOCKTABLE_GB) LOCKTABLE_GB
  FROM
  ( SELECT
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SITE_ID') != 0 THEN TO_VARCHAR(SITE_ID) ELSE MAP(BI_SITE_ID,  -1, 'any', TO_VARCHAR(BI_SITE_ID)) END SITE_ID,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST')    != 0 THEN HOST                ELSE MAP(BI_HOST,    '%', 'any', BI_HOST)                END HOST,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(PORT)    ELSE MAP(BI_PORT,    '%', 'any', BI_PORT)                END PORT,
      SNAPSHOT_TIME,
      SUM(TOTAL_GB) TOTAL_GB,
      SUM(TABLE_GB) TABLE_GB,
      SUM(CATALOG_GB) CATALOG_GB,
      SUM(INDEX_GB) INDEX_GB,
      SUM(VERSION_GB) VERSION_GB,
      SUM(PAGELIST_GB) PAGELIST_GB,
      SUM(LOCKTABLE_GB) LOCKTABLE_GB,
      KEY_FIGURE,
      AGGREGATE_BY,
      TIME_AGGREGATE_BY
    FROM
    ( SELECT
        SNAPSHOT_TIME,
        SITE_ID,
        HOST,
        PORT,
        SUM(MEM_GB) TOTAL_GB,
        SUM(MAP(CATEGORY, 'TABLE', MEM_GB, 0)) TABLE_GB,
        SUM(MAP(CATEGORY, 'CATALOG', MEM_GB, 0)) CATALOG_GB,
        SUM(MAP(CATEGORY, 'BTREE', MEM_GB, 'CPBTREE', MEM_GB, 0)) INDEX_GB,
        SUM(MAP(CATEGORY, 'VERSION', MEM_GB, 0)) VERSION_GB,
        SUM(MAP(CATEGORY, 'PAGELIST', MEM_GB, 0)) PAGELIST_GB,
        SUM(MAP(CATEGORY, 'LOCKTABLE', MEM_GB, 0)) LOCKTABLE_GB,
        BI_SITE_ID,
        BI_HOST,
        BI_PORT,
        KEY_FIGURE,
        AGGREGATE_BY,
        TIME_AGGREGATE_BY
      FROM
      ( SELECT
          CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(R.SNAPSHOT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE R.SNAPSHOT_TIME END SNAPSHOT_TIME,
          R.CATEGORY,
          R.SITE_ID,
          R.HOST,
          R.PORT,
          BI.KEY_FIGURE,
          MAP(BI.KEY_FIGURE, 'ALLOC', R.ALLOCATED_SIZE, 'USED', R.USED_SIZE, 'FREE', R.FREE_SIZE) / 1024 / 1024 / 1024 MEM_GB,
          BI.SITE_ID BI_SITE_ID,
          BI.HOST BI_HOST,
          BI.PORT BI_PORT,
          BI.AGGREGATE_BY,
          BI.TIME_AGGREGATE_BY
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
            DATA_SOURCE,
            KEY_FIGURE,
            AGGREGATE_BY,
            MAP(TIME_AGGREGATE_BY,
              'NONE',        'YYYY/MM/DD HH24:MI:SS',
              'HOUR',        'YYYY/MM/DD HH24',
              'DAY',         'YYYY/MM/DD (DY)',
              'HOUR_OF_DAY', 'HH24',
              TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY
          FROM      
          ( SELECT                            /* Modification section */
              '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
              '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
              'SERVER' TIMEZONE,                              /* SERVER, UTC */
              -1 SITE_ID, 
              '%' HOST,
              '%' PORT,
              'HISTORY' DATA_SOURCE,         /* CURRENT, HISTORY */
              'ALLOC' KEY_FIGURE,        /* ALLOC, USED, FREE */
              'TIME' AGGREGATE_BY,           /* SITE_ID, HOST, PORT, TIME or comma separated combinations, NONE for no aggregation */
              'DAY' TIME_AGGREGATE_BY     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
            FROM
              DUMMY
          ) 
        ) BI,
        ( SELECT
            CURRENT_TIMESTAMP SNAPSHOT_TIME,
            'CURRENT' DATA_SOURCE,
            CURRENT_SITE_ID() SITE_ID,
            HOST,
            PORT,
            CATEGORY,
            ALLOCATED_SIZE,
            USED_SIZE,
            FREE_SIZE
          FROM
            M_RS_MEMORY
          UNION ALL
          SELECT
            SERVER_TIMESTAMP SNAPSHOT_TIME,
            'HISTORY',
            SITE_ID,
            HOST,
            PORT,
            CATEGORY,
            ALLOCATED_SIZE,
            USED_SIZE,
            FREE_SIZE
          FROM
            _SYS_STATISTICS.HOST_RS_MEMORY
        ) R
        WHERE
          ( BI.SITE_ID = -1 OR ( BI.SITE_ID = 0 AND R.SITE_ID IN (-1, 0) ) OR R.SITE_ID = R.SITE_ID ) AND
          R.HOST LIKE BI.HOST AND
          TO_VARCHAR(R.PORT) LIKE BI.PORT AND
          CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(R.SNAPSHOT_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE R.SNAPSHOT_TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
          R.DATA_SOURCE = BI.DATA_SOURCE
      )
      GROUP BY
        SNAPSHOT_TIME,
        SITE_ID,
        HOST,
        PORT,
        KEY_FIGURE,
        BI_SITE_ID,
        BI_HOST,
        BI_PORT,
        AGGREGATE_BY,
        TIME_AGGREGATE_BY
    )
    GROUP BY
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'SITE_ID') != 0 THEN TO_VARCHAR(SITE_ID) ELSE MAP(BI_SITE_ID,  -1, 'any', TO_VARCHAR(BI_SITE_ID)) END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'HOST')    != 0 THEN HOST                ELSE MAP(BI_HOST,    '%', 'any', BI_HOST)                END,
      CASE WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(PORT)    ELSE MAP(BI_PORT,    '%', 'any', BI_PORT)                END,
      SNAPSHOT_TIME,
      KEY_FIGURE,
      AGGREGATE_BY,
      TIME_AGGREGATE_BY
  )
  GROUP BY
    CASE 
      WHEN AGGREGATE_BY = 'NONE' OR INSTR(AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), SNAPSHOT_TIME) / SUBSTR(TIME_AGGREGATE_BY, 3)) * SUBSTR(TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(SNAPSHOT_TIME, TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    SITE_ID,
    HOST,
    PORT,
    KEY_FIGURE
)
ORDER BY
  SNAPSHOT_TIME DESC,
  SITE_ID,
  HOST,
  PORT