SELECT
/* 

[NAME]

- HANA_Disks_Overview

[DESCRIPTION]

- Disk space allocation and fragmentation information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/09/22:  1.0 (initial version)
- 2016/02/14:  1.1 (history included)
- 2016/12/31:  1.2 (TIME_AGGREGATE_BY = 'TS<seconds>' included)
- 2017/02/02:  1.3 (M_PERSISTENCE_ENCRYPTION_STATUS included)
- 2018/12/04:  1.4 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- M_VOLUME_FILES
- HOST_VOLUME_FILES
- M_PERSISTENCE_ENCRYPTION_STATUS

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

- FILE_NAME

  File name

  'alert.trc'     --> File with name alert.trc
  '%dat'          --> File with name ending with 'dat'
  '%'             --> All files

- MIN_UNUSED_SIZE_GB

  Minimum unused size to be displayed

  10              --> Only display files with at least 10 GB of unused size
  -1              --> No restriction related to unused size

- MIN_FRAGMENTATION_PCT

  Minimum fragmentation in percent

  30              --> Minimum fragmentation of 30 %
  -1              --> No restriction based on fragmentation

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TYPE'          --> Aggregation by file type
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation

[OUTPUT PARAMETERS]

- SNAPSHOT_TIME: Snapshot timestamp
- HOST:          Host name
- PORT:          Port
- FILE_NAME:     File name
- FILE_TYPE:     File type
- E:             'X' if file system is encrypted, otherwise ' '
- TOTAL_GB:      Total space (GB)
- USED_GB:       Used space (GB)
- UNUSED_GB:     Unused space (GB)
- FRAG_PCT:      Percentage of unused space compared to total space in file

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------
|HOST      |PORT |FILE_NAME                                           |FILE_TYPE|TOTAL_SIZE_GB|USED_SIZE_GB|UNUSED_SIZE_GB|FRAGMENTATION_PCT|
---------------------------------------------------------------------------------------------------------------------------------------------
|saphana1db|30203|/hana/data/PRD/mnt00001/hdb00002/datavolume_0000.dat|DATA     |        33.95|       24.16|          9.79|            28.84|
|saphana1db|30205|/hana/data/PRD/mnt00001/hdb00003/datavolume_0000.dat|DATA     |         5.43|        2.88|          2.55|            47.01|
|saphana1db|30207|/hana/data/PRD/mnt00001/hdb00004/datavolume_0000.dat|DATA     |         0.25|        0.06|          0.18|            73.93|
---------------------------------------------------------------------------------------------------------------------------------------------

*/

  SNAPSHOT_TIME,
  HOST,
  LPAD(PORT, 5) PORT,
  FILE_NAME,
  FILE_TYPE,
  ENCRYPTION E,
  LPAD(TO_DECIMAL(TOTAL_SIZE_GB, 10, 2), 8) TOTAL_GB,
  LPAD(TO_DECIMAL(USED_SIZE_GB, 10, 2), 8)  USED_GB,
  LPAD(TO_DECIMAL(TOTAL_SIZE_GB - USED_SIZE_GB, 10, 2), 9) UNUSED_GB,
  LPAD(TO_DECIMAL(MAP(TOTAL_SIZE_GB, 0, 0, ( 1 - USED_SIZE_GB / TOTAL_SIZE_GB ) * 100), 10, 2), 8) FRAG_PCT
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
    HOST,
    PORT,
    FILE_NAME,
    FILE_TYPE,
    ENCRYPTION,
    AVG(USED_SIZE_GB) USED_SIZE_GB,
    AVG(TOTAL_SIZE_GB) TOTAL_SIZE_GB,
    MIN_UNUSED_SIZE_GB,
    MIN_FRAGMENTATION_PCT
  FROM
  ( SELECT
      F.SNAPSHOT_TIME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')       != 0 THEN F.HOST                                    ELSE MAP(BI.HOST,      '%', 'any', BI.HOST)      END HOST,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')       != 0 THEN TO_VARCHAR(F.PORT)                        ELSE MAP(BI.PORT,      '%', 'any', BI.PORT)      END PORT,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'FILE')       != 0 THEN F.FILE_NAME                               ELSE MAP(BI.FILE_NAME, '%', 'any', BI.FILE_NAME) END FILE_NAME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TYPE')       != 0 THEN F.FILE_TYPE                               ELSE MAP(BI.FILE_TYPE, '%', 'any', BI.FILE_TYPE) END FILE_TYPE,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ENCRYPTION') != 0 THEN MAP(E.ENCRYPTION_ACTIVE, 'TRUE', 'X', '') ELSE 'any'                                       END ENCRYPTION,
      SUM(F.USED_SIZE) / 1024 / 1024 / 1024 USED_SIZE_GB,
      SUM(F.TOTAL_SIZE) / 1024 / 1024 / 1024 TOTAL_SIZE_GB,
      BI.MIN_UNUSED_SIZE_GB,
      BI.MIN_FRAGMENTATION_PCT,
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
        HOST,
        PORT,
        SERVICE_NAME,
        FILE_NAME,
        FILE_TYPE,
        MIN_UNUSED_SIZE_GB,
        MIN_FRAGMENTATION_PCT,
        DATA_SOURCE,
        AGGREGATE_BY,
        MAP(TIME_AGGREGATE_BY,
          'NONE',        'YYYY/MM/DD HH24:MI:SS',
          'HOUR',        'YYYY/MM/DD HH24',
          'DAY',         'YYYY/MM/DD (DY)',
          'HOUR_OF_DAY', 'HH24',
          TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY
      FROM
      ( SELECT                    /* Modification section */
          '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
          '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
          '%' HOST,
          '%' PORT,
          '%' SERVICE_NAME,
          '%' FILE_NAME,
          'DATA' FILE_TYPE,            /* DATA, LOG */
          -1  MIN_UNUSED_SIZE_GB,
          -1  MIN_FRAGMENTATION_PCT,
          'CURRENT' DATA_SOURCE,
          'NONE' AGGREGATE_BY,         /* TIME, HOST, PORT, FILE, TYPE, ENCRYPTION and comma-separated combinations, NONE for no aggregation */
          'NONE' TIME_AGGREGATE_BY     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        FROM
          DUMMY
      )
    ) BI,
    ( SELECT
        'CURRENT' DATA_SOURCE,
        CURRENT_TIMESTAMP SNAPSHOT_TIME,
        HOST,
        PORT,
        FILE_NAME,
        FILE_TYPE,
        USED_SIZE,
        TOTAL_SIZE
      FROM
        M_VOLUME_FILES
      UNION ALL
      SELECT
        'HISTORY' DATA_SOURCE,
        SERVER_TIMESTAMP SNAPSHOT_TIME,
        HOST,
        PORT,
        FILE_NAME,
        FILE_TYPE,
        USED_SIZE,
        TOTAL_SIZE
      FROM
        _SYS_STATISTICS.HOST_VOLUME_FILES
    ) F,
      M_PERSISTENCE_ENCRYPTION_STATUS E
    WHERE
      F.SNAPSHOT_TIME BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
      F.HOST LIKE BI.HOST AND
      TO_VARCHAR(F.PORT) LIKE BI.PORT AND
      F.FILE_NAME LIKE BI.FILE_NAME AND
      F.FILE_TYPE LIKE BI.FILE_TYPE AND
      F.DATA_SOURCE = BI.DATA_SOURCE AND
      E.HOST = F.HOST AND
      E.PORT = F.PORT
    GROUP BY
      F.SNAPSHOT_TIME,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')       != 0 THEN F.HOST                                    ELSE MAP(BI.HOST,      '%', 'any', BI.HOST)      END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')       != 0 THEN TO_VARCHAR(F.PORT)                        ELSE MAP(BI.PORT,      '%', 'any', BI.PORT)      END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'FILE')       != 0 THEN F.FILE_NAME                               ELSE MAP(BI.FILE_NAME, '%', 'any', BI.FILE_NAME) END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TYPE')       != 0 THEN F.FILE_TYPE                               ELSE MAP(BI.FILE_TYPE, '%', 'any', BI.FILE_TYPE) END,
      CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'ENCRYPTION') != 0 THEN MAP(E.ENCRYPTION_ACTIVE, 'TRUE', 'X', '') ELSE 'any'                                       END,
      BI.MIN_UNUSED_SIZE_GB,
      BI.MIN_FRAGMENTATION_PCT,
      BI.AGGREGATE_BY,
      BI.TIME_AGGREGATE_BY
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
    HOST,
    PORT,
    FILE_NAME,
    FILE_TYPE,
    ENCRYPTION,
    MIN_UNUSED_SIZE_GB,
    MIN_FRAGMENTATION_PCT
)
WHERE
  ( MIN_UNUSED_SIZE_GB = -1 OR TOTAL_SIZE_GB - USED_SIZE_GB >= MIN_UNUSED_SIZE_GB) AND
  ( MIN_FRAGMENTATION_PCT = -1 OR MAP(TOTAL_SIZE_GB, 0, 0, ( 1 - USED_SIZE_GB / TOTAL_SIZE_GB ) * 100) >= MIN_FRAGMENTATION_PCT )
ORDER BY
  SNAPSHOT_TIME DESC,
  HOST,
  PORT,
  FILE_NAME,
  FILE_TYPE