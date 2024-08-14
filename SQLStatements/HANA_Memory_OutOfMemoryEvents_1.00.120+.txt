SELECT

/* 

[NAME]

- HANA_Memory_OutOfMemoryEvents_1.00.120+

[DESCRIPTION]

- Overview of out of memory (OOM) situations

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_OUT_OF_MEMORY_EVENTS and GLOBAL_OUT_OF_MEMORY_EVENTS available starting with SAP HANA 1.0 SPS 12
- Command can fail on earlier SAP HANA 2.0 SPS 00 and SPS 01 versions due to absence of GLOBAL_OUT_OF_MEMORY_EVENTS
- Number of entries in M_OUT_OF_MEMORY_EVENTS is 20, additional OOMs will overwrite the oldest entries
- Due to SAP HANA bug 196121 several entries can exist for the same OOM termination.

[VALID FOR]

- Revisions:              >= 1.00.120

[SQL COMMAND VERSION]

- 2018/01/24:  1.0 (initial version)
- 2018/10/18:  1.1 (GLOBAL_OUT_OF_MEMORY_EVENTS included)
- 2018/12/05:  1.2 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')

[INVOLVED TABLES]

- M_OUT_OF_MEMORY_EVENTS
- GLOBAL_OUT_OF_MEMORY_EVENTS

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

- PORT

  Port number

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- HOST

  Host name

  'saphana01'     --> Specific host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- CONN_ID

  Connection ID

  330655          --> Connection ID 330655
  -1              --> No connection ID restriction

- STATEMENT_HASH      
 
  Hash of SQL statement to be analyzed

  '2e960d7535bf4134e2bd26b9d80bd4fa' --> SQL statement with hash '2e960d7535bf4134e2bd26b9d80bd4fa'
  '%'                                --> No statement hash restriction

- EVENT_REASON

  OOM event reason

  'GENERIC_COMPOSITE_LIMIT' --> Statement memory limit related dumps
  '%'                       --> No restriction related to OOM event reason

- DATA_SOURCE

  Source of analysis data

  'CURRENT'       --> Data from memory information (M_ tables)
  'HISTORY'       --> Data from persisted history information (HOST_ tables)
  '%'             --> All data sources

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
  
[OUTPUT PARAMETERS]

- OOM_TIME:       Out of memory timestamp
- HOST:           Host
- PORT:           Port
- CONN_ID:        Connection ID
- STATEMENT_HASH: Statement hash
- STATEMENT_ID:   Statement ID
- NUM_OOMS:       Number of OOM situations
- MEM_REQ_GB:     Memory request size (GB)
- MEM_USED_GB:    Memory used size (GB) (statement memory used in case of composite limit dump, global memory used in case of global allocation limit dump)
- MEM_LIMIT_GB:   Memory limit (GB) (depends on event reason, e.g. statement memory limit, global allocation limit, process alocation limit)
- EVENT_REASON:   OOM event reason
- TRACEFILE_NAME: Trace file name (only written if oom_dump_time_delta since last dump is exceeded)

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|OOM_TIME           |HOST   |PORT |CONN_ID     |STATEMENT_HASH                  |STATEMENT_ID        |NUM_OOMS|MEM_REQ_GB|MEM_USED_GB|MEM_LIMIT_GB|EVENT_REASON           |TRACEFILE_NAME                                                                                     |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2018/09/27 18:53:37|saphana|30003|      254300|ff12700f8a4519054d47ba07199dabf4|    1092211975498084|       1|      0.00|     220.64|      239.99|GLOBAL_ALLOCATION_LIMIT|/usr/sap/OQL/HDB00/saphana/trace/indexserver_saphana.30003.rtedump.20180927-182448.008582.oom.trc  |
|2018/09/22 18:53:34|saphana|30003|      200140|7152306c54ed24459ecdfbfc4bf1832c|     859597486763934|       1|      0.00|      39.99|       40.00|GENERIC_COMPOSITE_LIMIT|                                                                                                   |
|2018/09/22 12:53:34|saphana|30003|      200142|20a074abce64ae54fc4721d90ecc7a27|     859604933730077|       1|      0.00|      40.00|       40.00|GENERIC_COMPOSITE_LIMIT|                                                                                                   |
|2018/09/22 10:53:37|saphana|30003|      200144|31bba04a1af16e71e497f2bad2176d2a|     859614570026973|       1|      0.00|      40.00|       40.00|GENERIC_COMPOSITE_LIMIT|                                                                                                   |
|2018/09/21 13:53:34|saphana|30003|      200143|20a074abce64ae54fc4721d90ecc7a27|     859611466077150|       1|      0.00|      40.00|       40.00|GENERIC_COMPOSITE_LIMIT|                                                                                                   |
|2018/09/21 05:53:34|saphana|30003|      200141|20a074abce64ae54fc4721d90ecc7a27|     859599195275182|       1|      0.00|      40.00|       40.00|GENERIC_COMPOSITE_LIMIT|                                                                                                   |
|2018/09/13 15:53:34|saphana|30003|      239025|0032cd424617136077bdc91785c23c5a|    1026605628599935|       1|      0.00|      40.00|       40.00|GENERIC_COMPOSITE_LIMIT|                                                                                                   |
|2018/09/13 04:53:34|saphana|30003|      200140|8fd5d72eb2c877f7190c6210b464d11c|     859597499739787|       1|      0.00|      40.00|       40.00|GENERIC_COMPOSITE_LIMIT|                                                                                                   |
|2018/09/13 04:53:34|saphana|30003|      200144|9e7917fc4a4be150512bc38304fa6e22|     859614509856050|       1|      0.02|      39.97|       40.00|GENERIC_COMPOSITE_LIMIT|                                                                                                   |
|2018/09/13 03:53:34|saphana|30003|      200142|efb0e85b69a24941732fda4c3b97ff80|     859604127702251|       1|      0.01|      39.98|       40.00|GENERIC_COMPOSITE_LIMIT|                                                                                                   |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  OOM_TIME,
  HOST,
  LPAD(PORT, 5) PORT,
  LPAD(CONN_ID, 9) CONN_ID,
  STATEMENT_HASH,
  LPAD(STATEMENT_ID, 20) STATEMENT_ID,
  LPAD(NUM_OOMS, 8) NUM_OOMS,
  LPAD(TO_DECIMAL(MEM_REQ_GB, 10, 2), 10) MEM_REQ_GB,
  LPAD(TO_DECIMAL(MEM_USED_GB, 10, 2), 11) MEM_USED_GB,
  LPAD(TO_DECIMAL(MEM_LIMIT_GB, 10, 2), 12) MEM_LIMIT_GB,
  EVENT_REASON,
  TRACEFILE_NAME
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(OE.TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE OE.TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(OE.TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE OE.TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END OOM_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')         != 0 THEN OE.HOST           ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                            END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')         != 0 THEN OE.PORT           ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                            END PORT,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONN_ID')      != 0 THEN OE.CONNECTION_ID  ELSE MAP(BI.CONN_ID, -1, 'any', TO_VARCHAR(BI.CONN_ID))           END CONN_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HASH')         != 0 THEN OE.STATEMENT_HASH ELSE MAP(BI.STATEMENT_HASH, '%', 'any', BI.STATEMENT_HASH)        END STATEMENT_HASH,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATEMENT_ID') != 0 THEN OE.STATEMENT_ID   ELSE MAP(BI.STATEMENT_ID, -1, 'any', TO_VARCHAR(BI.STATEMENT_ID)) END STATEMENT_ID,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'REASON')       != 0 THEN OE.EVENT_REASON   ELSE MAP(BI.EVENT_REASON, '%', 'any', BI.EVENT_REASON)            END EVENT_REASON,
    COUNT(*) NUM_OOMS,
    AVG(OE.MEMORY_REQUEST_SIZE) / 1024 / 1024 / 1024 MEM_REQ_GB,
    AVG(OE.MEMORY_USED_SIZE) / 1024 / 1024 / 1024 MEM_USED_GB,
    AVG(OE.MEMORY_LIMIT_SIZE) / 1024 / 1024 / 1024 MEM_LIMIT_GB,
    MAP(MIN(OE.TRACEFILE_NAME), MAX(OE.TRACEFILE_NAME), MIN(OE.TRACEFILE_NAME), 'various') TRACEFILE_NAME
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
      CONN_ID,
      STATEMENT_HASH,
      STATEMENT_ID,
      EVENT_REASON,
      DATA_SOURCE,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS',
        'HOUR',        'YYYY/MM/DD HH24',
        'DAY',         'YYYY/MM/DD (DY)',
        'HOUR_OF_DAY', 'HH24',
        TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY
    FROM
    ( SELECT                              /* Modification section */
        '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
        '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
        'SERVER' TIMEZONE,                              /* SERVER, UTC */
        '%' HOST,
        '%' PORT,
        -1 CONN_ID,
        '%' STATEMENT_HASH,
        -1 STATEMENT_ID,
        '%' EVENT_REASON,
        'CURRENT' DATA_SOURCE,
        'NONE' AGGREGATE_BY,         /* TIME, HOST, PORT, CONN_ID, HASH, REASON or comma separated combinations, NONE for no aggregation */
        'NONE' TIME_AGGREGATE_BY     /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
      FROM
        DUMMY
    )
  ) BI,
  ( SELECT
      'CURRENT' DATA_SOURCE,
      HOST,
      TO_VARCHAR(PORT) PORT,
      TIME,
      TO_VARCHAR(CONNECTION_ID) CONNECTION_ID,
      STATEMENT_HASH,
      STATEMENT_ID,
      EVENT_REASON,
      MEMORY_REQUEST_SIZE,
      MEMORY_USED_SIZE,
      MEMORY_LIMIT_SIZE,
      TRACEFILE_NAME
    FROM
      M_OUT_OF_MEMORY_EVENTS
    UNION ALL
    SELECT
      'HISTORY' DATA_SOURCE,
      HOST,
      PORT,
      TIME,
      CONNECTION_ID,
      STATEMENT_HASH,
      STATEMENT_ID,
      EVENT_REASON,
      MEMORY_REQUEST_SIZE,
      MEMORY_USED_SIZE,
      MEMORY_LIMIT_SIZE,
      TRACEFILE_NAME
    FROM
      _SYS_STATISTICS.GLOBAL_OUT_OF_MEMORY_EVENTS
  ) OE
  WHERE
    CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(OE.TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE OE.TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME AND
    OE.HOST LIKE BI.HOST AND
    OE.PORT LIKE BI.PORT AND
    ( BI.CONN_ID = -1 OR OE.CONNECTION_ID = TO_VARCHAR(BI.CONN_ID) ) AND
    OE.STATEMENT_HASH LIKE BI.STATEMENT_HASH AND
    ( BI.STATEMENT_ID = -1 OR OE.STATEMENT_ID = BI.STATEMENT_ID ) AND
    OE.EVENT_REASON LIKE BI.EVENT_REASON AND
    OE.DATA_SOURCE LIKE BI.DATA_SOURCE
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(OE.TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE OE.TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(OE.TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE OE.TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')         != 0 THEN OE.HOST           ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                            END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')         != 0 THEN OE.PORT           ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                            END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'CONN_ID')      != 0 THEN OE.CONNECTION_ID  ELSE MAP(BI.CONN_ID, -1, 'any', TO_VARCHAR(BI.CONN_ID))           END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HASH')         != 0 THEN OE.STATEMENT_HASH ELSE MAP(BI.STATEMENT_HASH, '%', 'any', BI.STATEMENT_HASH)        END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'STATEMENT_ID') != 0 THEN OE.STATEMENT_ID   ELSE MAP(BI.STATEMENT_ID, -1, 'any', TO_VARCHAR(BI.STATEMENT_ID)) END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'REASON')       != 0 THEN OE.EVENT_REASON   ELSE MAP(BI.EVENT_REASON, '%', 'any', BI.EVENT_REASON)            END
)
ORDER BY
  OOM_TIME DESC,
  NUM_OOMS DESC,
  HOST,
  PORT,
  CONN_ID