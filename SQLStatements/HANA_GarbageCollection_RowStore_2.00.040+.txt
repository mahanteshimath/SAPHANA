SELECT

/* 

[NAME]

- HANA_GarbageCollection_RowStore_2.00.040+

[DESCRIPTION]

- Row store garbage collection details

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- In case of aggregation the extreme values (maximum or minimum) are displayed, so column values may appear to
  be inconsistent (e.g. VERSIONS smaller than sum of DATA_VERSIONS and METADATA_VERSIONS)
- DATA_VERSION_COUNT and METADATA_VERSION_COUNT only available with SAP HANA >= 2.00.040

[VALID FOR]

- Revisions:              >= 2.00.040

[SQL COMMAND VERSION]

- 2020/12/15:  1.0 (initial version)

[INVOLVED TABLES]

- HOST_MVCC_OVERVIEW
- M_MVCC_OVERVIEW

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

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'          --> Aggregation by time
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation
  
- ORDER_BY

  Sort criteria (available values are provided in comment)

  'TIME'          --> Sorting by time
  'VERSIONS'      --> Sorting by versions

[OUTPUT PARAMETERS]

- SNAPSHOT_TIMESTAMP: Snapshot timestamp
- HOST:               Host name
- PORT:               Port
- VERSIONS:           Total versions
- DATA_VERSIONS:      Data versions
- METADATA_VERSIONS:  Metadata versions
- MIN_COMMIT_ID:      Minimum commit ID (MIN_MVCC_SNAPSHOT_TIMESTAMP)
- CUR_COMMIT_ID:      Current commit ID (GLOBAL_MVCC_TIMESTAMP)
- COMMIT_ID_RANGE:    Commit ID range (i.e. difference between current and minimum commit ID, relevant for global garbage collection blockage)
- MIN_UPD_TRANS_ID:   Minimum update transaction ID
- CUR_UPD_TRANS_ID:   Current update transaction ID
- UPD_TRANS_RANGE:    Update transaction ID range (i.e. difference between current and minimum update transaction ID, relevant for table-specific garbage collection blockage)

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|SNAPSHOT_TIMESTAMP |HOST      |PORT |VERSIONS |DATA_VERSIONS|METADATA_VERSIONS|MIN_COMMIT_ID  |CUR_COMMIT_ID  |COMMIT_ID_RANGE|MIN_UPD_TRANS_ID|CUR_UPD_TRANS_ID|UPD_TRANS_RANGE|
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2020/12/15 10:25:03|saphana001|  any|  1314531|      1314086|              445|    20862842247|    20862958490|         116243|     20408351808|     20408523613|         116243|
|2020/12/15 10:20:07|saphana001|  any|   574533|       574216|              317|    20862019708|    20862176791|         157083|     20408216064|     20408346483|         157083|
|2020/12/15 10:15:02|saphana001|  any|  1004193|       958260|            45933|    20861770655|    20861939274|         168619|     20407908736|     20408135730|         168619|
|2020/12/15 10:10:02|saphana001|  any|   545798|       500005|            45793|    20861712279|    20861756485|          44206|     20407660992|     20407952984|          44206|
|2020/12/15 10:05:06|saphana001|  any|  1142423|      1096783|            45640|    20861362866|    20861591952|         229086|     20407571712|     20407788729|         229086|
|2020/12/15 10:00:02|saphana001|  any|   320804|       275295|            45509|    20861303360|    20861373643|          70283|     20407542848|     20407570428|          70283|
|2020/12/15 09:55:02|saphana001|  any|   879222|       833852|            45370|    20861055480|    20861234161|         178681|     20407311744|     20407431162|         178681|
|2020/12/15 09:50:58|saphana001|  any|   949876|       904626|            45250|    20861040291|    20861102592|          62301|     20407249216|     20407299661|          62301|
|2020/12/15 09:45:02|saphana001|  any|   433763|       388712|            45051|    20860893501|    20860921586|          28085|     20407073920|     20407118769|          28085|
|2020/12/15 09:40:02|saphana001|  any|   305051|       260167|            44884|    20860717043|    20860764263|          47220|     20406893056|     20406961530|          47220|
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  SNAPSHOT_TIMESTAMP,
  HOST,
  LPAD(PORT, 5) PORT,
  LPAD(VERSIONS, 9) VERSIONS,
  LPAD(DATA_VERSIONS, 13) DATA_VERSIONS,
  LPAD(METADATA_VERSIONS, 17) METADATA_VERSIONS,
  LPAD(MIN_COMMIT_ID, 15) MIN_COMMIT_ID,
  LPAD(CUR_COMMIT_ID, 15) CUR_COMMIT_ID,
  LPAD(COMMIT_ID_RANGE, 15) COMMIT_ID_RANGE,
  LPAD(MIN_UPD_TRANS_ID, 16) MIN_UPD_TRANS_ID,
  LPAD(CUR_UPD_TRANS_ID, 16) CUR_UPD_TRANS_ID,
  LPAD(UPD_TRANS_RANGE, 15) UPD_TRANS_RANGE
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(M.SNAPSHOT_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE M.SNAPSHOT_TIMESTAMP END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(M.SNAPSHOT_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE M.SNAPSHOT_TIMESTAMP END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END SNAPSHOT_TIMESTAMP,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST') != 0 THEN M.HOST             ELSE MAP(BI.HOST, '%', 'any', BI.HOST) END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT') != 0 THEN TO_VARCHAR(M.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT) END PORT,
    MAX(M.DATA_VERSIONS + M.METADATA_VERSIONS) VERSIONS,
    MAX(M.DATA_VERSIONS) DATA_VERSIONS,
    MAX(M.METADATA_VERSIONS) METADATA_VERSIONS,
    MIN(M.MIN_COMMIT_ID) MIN_COMMIT_ID,
    MAX(M.CUR_COMMIT_ID) CUR_COMMIT_ID,
    MAX(M.COMMIT_ID_RANGE) COMMIT_ID_RANGE,
    MIN(M.MIN_UPD_TRANS_ID) MIN_UPD_TRANS_ID,
    MAX(M.CUR_UPD_TRANS_ID) CUR_UPD_TRANS_ID,
    MAX(M.COMMIT_ID_RANGE) UPD_TRANS_RANGE,
    BI.ORDER_BY
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
      DATA_SOURCE,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS',
        'HOUR',        'YYYY/MM/DD HH24',
        'DAY',         'YYYY/MM/DD (DY)',
        'HOUR_OF_DAY', 'HH24',
        TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
      ORDER_BY
    FROM
    ( SELECT                   /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        'SERVER' TIMEZONE,                              /* SERVER, UTC */
        '%' HOST,
        '%' PORT,
        'HISTORY' DATA_SOURCE,
        'TIME, HOST' AGGREGATE_BY,          /* TIME, HOST, PORT or comma separated list, NONE for no aggregation */
        'NONE' TIME_AGGREGATE_BY,     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'TIME' ORDER_BY           /* TIME, VERSIONS, DATA_VERSIONS, METADATA_VERSIONS, COMMIT_ID_RANGE, UPD_TRANS_RANGE */
      FROM
        DUMMY
    )
  ) BI,
  ( SELECT
      'CURRENT' DATA_SOURCE,
      CURRENT_TIMESTAMP SNAPSHOT_TIMESTAMP,
      HOST,
      PORT,
      DATA_VERSION_COUNT DATA_VERSIONS,
      METADATA_VERSION_COUNT METADATA_VERSIONS,
      MIN_MVCC_SNAPSHOT_TIMESTAMP MIN_COMMIT_ID,
      GLOBAL_MVCC_TIMESTAMP CUR_COMMIT_ID,
      GLOBAL_MVCC_TIMESTAMP - MIN_MVCC_SNAPSHOT_TIMESTAMP COMMIT_ID_RANGE,
      MIN_WRITE_TRANSACTION_ID MIN_UPD_TRANS_ID,
      NEXT_WRITE_TRANSACTION_ID CUR_UPD_TRANS_ID,
      NEXT_WRITE_TRANSACTION_ID - MIN_WRITE_TRANSACTION_ID UPD_TRANS_RANGE
    FROM
      M_MVCC_OVERVIEW
    UNION ALL
    SELECT
      'HISTORY' DATA_SOURCE,
      SERVER_TIMESTAMP SNAPSHOT_TIMESTAMP,
      HOST,
      PORT,
      DATA_VERSION_COUNT DATA_VERSIONS,
      METADATA_VERSION_COUNT METADATA_VERSIONS,
      MIN_MVCC_SNAPSHOT_TIMESTAMP MIN_COMMIT_ID,
      GLOBAL_MVCC_TIMESTAMP CUR_COMMIT_ID,
      GLOBAL_MVCC_TIMESTAMP - MIN_MVCC_SNAPSHOT_TIMESTAMP COMMIT_ID_RANGE,
      MIN_WRITE_TRANSACTION_ID MIN_UPD_TRANS_ID,
      NEXT_WRITE_TRANSACTION_ID CUR_UPD_TRANS_ID,
      NEXT_WRITE_TRANSACTION_ID - MIN_WRITE_TRANSACTION_ID UPD_TRANS_RANGE
    FROM
      _SYS_STATISTICS.HOST_MVCC_OVERVIEW
  ) M
  WHERE
    ( BI.DATA_SOURCE = 'CURRENT' OR
      CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(M.SNAPSHOT_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE M.SNAPSHOT_TIMESTAMP END BETWEEN BI.BEGIN_TIME AND BI.END_TIME
    ) AND
    M.HOST LIKE BI.HOST AND
    TO_VARCHAR(M.PORT) LIKE BI.PORT AND
    M.DATA_SOURCE = BI.DATA_SOURCE
  GROUP BY
    CASE
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(M.SNAPSHOT_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE M.SNAPSHOT_TIMESTAMP END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(M.SNAPSHOT_TIMESTAMP, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE M.SNAPSHOT_TIMESTAMP END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST') != 0 THEN M.HOST             ELSE MAP(BI.HOST, '%', 'any', BI.HOST) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT') != 0 THEN TO_VARCHAR(M.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT) END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'VERSIONS', VERSIONS, 'DATA_VERSIONS', DATA_VERSIONS, 'METADATA_VERSIONS', METADATA_VERSIONS,
    'COMMIT_ID_RANGE', COMMIT_ID_RANGE, 'UPD_TRANS_RANGE', UPD_TRANS_RANGE) DESC,
  SNAPSHOT_TIMESTAMP DESC,
  HOST