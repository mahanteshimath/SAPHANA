WITH 

/* 

[NAME]

- HANA_Global_CriticalTimeFrames_1.00.120+

[DESCRIPTION]

- Check for potentially critical historic time frames

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Different filter conditions are combined with OR, not with AND
- I/O related load history columns available with SAP HANA >= 1.00.120

[VALID FOR]

- Revisions:              >= 1.00.120

[SQL COMMAND VERSION]

- 2015/09/25:  1.0 (initial version)
- 2015/11/11:  1.1 (BLK_TRANS included)
- 2016/04/19:  1.2 (dedicated Rev. 110+ version including HOST_VOLUME_IO_TOTAL_STATISTICS)
- 2017/10/24:  1.3 (TIMEZONE included)
- 2018/12/04:  1.4 (shortcuts for BEGIN_TIME and END_TIME like 'C', 'E-S900' or 'MAX')
- 2019/04/21:  1.5 (dedicated 1.00.120+ version)

[INVOLVED TABLES]

- M_LOAD_HISTORY_SERVICE
- HOST_LOAD_HISTORY_SERVICE

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

- MIN_TOTAL_CPU_PCT

  Minimum threshold for the total CPU consumption (%)

  80              --> Display time frames with a CPU consumption of 80 % or more
  -1              --> No check for total CPU consumption

- MIN_SYSTEM_CPU_PCT

  Minimum threshold for the system CPU consumption (%)

  50              --> Display time frames with a system CPU consumption of 50 % or more
  -1              --> No check for system CPU consumption

- MIN_MEM_USED_PCT

  Minimum threshold for used memory compared to global allocation limit (%)

  80              --> Display time frames with a used memory of at least 80 % of the global allocation limit
  -1              --> No check for used memory 

- MIN_SWAP_IN_MB

  Minimum threshold for swap in (MB)

  1               --> Display time frames with a swap in of at least 1 MB
  -1              --> No check for swap in

- MIN_PING_MS

  Minimum threshold for the indexserver ping time (ms)

  100             --> Display time frames with an indexserver ping time of 100 ms or more
  -1              --> No check for indexserver ping time

- MIN_PENDING_SESSIONS

  Minimum threshold for pending sessions

  5               --> Display time frames with at least 5 pending sessions
  -1              --> No check for pending sessions

- MIN_VERSIONS

  Minimum threshold for MVCC versions

  5000000         --> Display time frames with at least 5 million MVCC versions
  -1              --> No check for MVCC versions

- MIN_LOAD_GAP_S

  Minimum gap in load histories (s)

  120             --> Display time frames with a load history gap of 120 s or more
  -1              --> No check for gaps in the load history

- MIN_WAITING_THREADS

  Minimum number of waiting threads (including idle waits like "Job Exec Waiting")
   
  100              --> Display time frames with 100 or more waiting threads
  -1              --> No check for blocked threads

- MIN_BLOCKED_THREADS

  Minimum number of blocked threads (transactional and internal locks)

  50              --> Display time frames with 50 or more blocked threads
  -1              --> No check for blocked threads

- MIN_BLOCKED_TRANS

  Minimum number of blocked transactions (transactional lock waits)

  20              --> Display time frames with 20 or more blocked transactions
  -1              --> No check for blocked threads

- MIN_DATA_READ_PCT

  Minimum data I/O read time share (%)

  50              --> Display time frames with data I/O read time busy share of at least 50 %
  -1              --> No check for data read time share

- MIN_DATA_WRITE_PCT

  Minimum data I/O write time share (%)

  50              --> Display time frames with data I/O write time busy share of at least 50 %
  -1              --> No check for data write time share

- MIN_LOG_WRITE_PCT

  Minimum log I/O write time share (%)

  50              --> Display time frames with log I/O write time busy share of at least 50 %
  -1              --> No check for log write time share

- MARK_CRITICAL

  Possibility to mark critical key figures with '*'

  'X'             --> Critical key figures are marked with '*'
  ' '             --> Critical key figures are not marked

- TIME_SLICE_S

  Time intervals for aggregation

  10              --> Aggregation on a 10 seconds basis
  900             --> Aggregation on a 15 minutes basis

- AGGREGATION_TYPE

  Type of aggregation (e.g. average, maximum)

  'AVG'           --> Average value
  'PEAK'          --> Peak value (e.g. maximum time or minimum throughput)

[OUTPUT PARAMETERS]

- SNAPSHOT_TIME: Timestamp
- HOST:          Host name
- AGG:           Type of aggregation (AVG -> average values, MAX -> peak values)
- TOT_CPU_PCT:   Total CPU consumption (%)
- SYS_CPU_PCT:   System CPU consumption (%)
- MEM_USED_PCT:  Fraction of global allocation limit currently used by SAP HANA (%)
- UNLOADS:       Number of column store unloads
- SWAP_IN_MB:    Amount of data swapped in (MB)
- PING_MS:       Indexserver ping time (ms)
- VERS_M:        Number of row store versions (in million)
- LOAD_GAP_S:    Nameserver history load gap (s)
- PEND_SESS:     Number of pending sessions
- WAIT_THR:      Number of waiting threads (including idle waits like "Job Exec Waiting")
- BLK_TRANS:     Number of transactional lock waits
- D_RD_PCT:      Data read I/O busy time (%)
- D_WR_PCT:      Data write I/O busy time (%)
- L_WR_PCT:      Log write I/O busy time (%)

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|BEGIN_TIME         |HOST  |AGG|TOT_CPU_PCT|SYS_CPU_PCT|MEM_USED_PCT|UNLOADS|SWAP_IN_MB|PING_MS|VERS_M|LOAD_GAP_S|PEND_SESS|WAIT_THR|BLK_THR|BLK_TRANS|D_RD_MBPS|D_WR_MBPS|L_WR_MBPS|
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2016/04/19 10:30:00|ls5783|AVG|          9|          9|          89|      0|      0.00|     59|     0|        12|        0|      12|   * 89|        0|      386|     1868|       60|
|2016/04/19 09:50:00|ls5783|AVG|          8|          8|          89|      0|      0.00|  * 118|     0|        11|        0|      10|     18|        0|      279|     1601|       82|
|2016/04/19 08:30:00|ls5783|AVG|          6|          6|          89|      0|      0.00|  * 107|     0|        10|        0|      13|      5|        0|      315|     1390|      143|
|2016/04/19 08:00:00|ls5783|AVG|          5|          5|          89|      0|      0.00|  * 164|     0|        10|        0|       6|     15|        0|      285|     1314|       87|
|2016/04/19 05:30:00|ls5783|AVG|          4|          4|          89|      0|      0.00|  * 118|     0|        11|        0|       5|      2|        0|      275|     1557|       71|
|2016/04/19 04:50:00|ls5783|AVG|         10|         10|          89|      0|      0.00|  * 115|     0|        10|        0|       7|      1|        0|      378|     2290|       73|
|2016/04/19 04:00:00|ls5783|AVG|         11|         11|          89|      0|      0.00|  * 161|     0|        10|        0|      11|      6|        0|      343|     1451|       88|
|2016/04/19 03:30:00|ls5783|AVG|         14|         14|          89|      0|      0.00|  * 118|     0|        10|        0|   * 159|      4|        0|     2493|     1006|     * 10|
|2016/04/19 03:20:00|ls5783|AVG|         13|         13|          89|      0|      0.00|     92|     0|        12|        0|   * 124|     14|        0|     2545|     1047|      * 8|
|2016/04/19 00:10:00|ls5783|AVG|         13|         13|          89|      0|      0.00|  * 127|     0|        13|        0|      11|      3|        0|      288|     1223|       82|
|2016/04/18 20:40:00|ls5783|AVG|          5|          5|          87|      0|      0.00|  * 103|     0|        11|        0|       7|      2|        0|      495|     2125|      207|
|2016/04/18 19:00:00|ls5783|AVG|          5|          5|          87|      0|      0.00|  * 213|     0|        11|        0|      13|      1|        0|      307|     1392|       98|
|2016/04/18 18:40:00|ls5783|AVG|          5|          5|          87|      0|      0.00|  * 101|     0|        10|        0|      11|      0|        0|      293|     1492|      104|
|2016/04/18 14:20:00|ls5783|AVG|          6|          6|          86|      0|      0.00|  * 177|     0|        10|        0|      12|      0|        0|      297|     1159|       87|
|2016/04/18 13:40:00|ls5783|AVG|          6|          6|          85|      0|      0.00|  * 159|     0|        10|        0|       4|      0|        0|      329|     1696|      106|
|2016/04/18 13:30:00|ls5783|AVG|          7|          7|          85|      0|      0.00|  * 125|     0|        10|        0|      13|      1|        1|      293|     1585|       82|
|2016/04/18 11:50:00|ls5783|AVG|          6|          6|          85|      0|      0.00|  * 145|     0|        12|        0|      28|      8|        0|      666|     5493|       91|
|2016/04/18 11:40:00|ls5783|AVG|          8|          8|          85|      0|      0.00|  * 419|     0|        12|        1|      31|     14|        1|      214|     2571|       56|
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
    HOST,
    MIN_TOTAL_CPU_PCT,
    MIN_SYSTEM_CPU_PCT,
    MIN_MEM_USED_PCT,
    MIN_UNLOADS,
    MIN_SWAP_IN_MB,
    MIN_PING_MS,
    MIN_PENDING_SESSIONS,
    MIN_VERSIONS,
    MIN_LOAD_GAP_S,
    MIN_WAITING_THREADS,
    MIN_BLOCKED_TRANSACTIONS,
    MIN_DATA_READ_PCT,
    MIN_DATA_WRITE_PCT,
    MIN_LOG_WRITE_PCT,
    MARK_CRITICAL,
    TIME_SLICE_S,
    AGGREGATION_TYPE
  FROM
  ( SELECT             /* Modification section */
      '1000/10/18 07:58:00' BEGIN_TIME,                  /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, E-S<seconds>, E-M<minutes>, E-H<hours>, E-D<days>, E-W<weeks>, MIN */
      '9999/10/18 08:05:00' END_TIME,                    /* YYYY/MM/DD HH24:MI:SS timestamp, C, C-S<seconds>, C-M<minutes>, C-H<hours>, C-D<days>, C-W<weeks>, B+S<seconds>, B+M<minutes>, B+H<hours>, B+D<days>, B+W<weeks>, MAX */
      'SERVER' TIMEZONE,                              /* SERVER, UTC */
      '%' HOST,
      -1 MIN_TOTAL_CPU_PCT,
      -1 MIN_SYSTEM_CPU_PCT,
      -1 MIN_MEM_USED_PCT,
      -1 MIN_UNLOADS,
      -1 MIN_SWAP_IN_MB,
      -1 MIN_PING_MS,
      -1 MIN_PENDING_SESSIONS,
      -1 MIN_VERSIONS,
      60 MIN_LOAD_GAP_S,
      -1 MIN_WAITING_THREADS,
      -1 MIN_BLOCKED_TRANSACTIONS,
      -1 MIN_DATA_READ_PCT,
      -1 MIN_DATA_WRITE_PCT,
      -1 MIN_LOG_WRITE_PCT,
      'X' MARK_CRITICAL,
      -1 TIME_SLICE_S,
      'AVG' AGGREGATION_TYPE                /* PEAK, AVG */
    FROM
      DUMMY
  )
)
SELECT
  BEGIN_TIME,
  HOST,
  AGG,
  MAX(TOT_CPU_PCT) TOT_CPU_PCT,
  MAX(SYS_CPU_PCT) SYS_CPU_PCT,
  MAX(MEM_USED_PCT) MEM_USED_PCT,
  MAX(UNLOADS) UNLOADS,
  MAX(SWAP_IN_MB) SWAP_IN_MB,
  MAX(PING_MS) PING_MS,
  MAX(VERS_M) VERS_M,
  MAX(LOAD_GAP_S) LOAD_GAP_S,
  MAX(MAP(PEND_SESS, LPAD('-1', 9), LPAD('0', 9), PEND_SESS)) PEND_SESS,
  MAX(WAIT_THR) WAIT_THR,
  MAX(BLK_TRANS) BLK_TRANS,
  MAX(D_RD_PCT) D_RD_PCT,
  MAX(D_WR_PCT) D_WR_PCT,
  MAX(L_WR_PCT) L_WR_PCT
FROM
( SELECT
    TO_VARCHAR(D.BEGIN_TIME, 'YYYY/MM/DD HH24:MI:SS') BEGIN_TIME,
    D.HOST,
    BI.AGGREGATION_TYPE AGG,
    LPAD(CASE WHEN BI.MARK_CRITICAL = 'X' AND BI.MIN_TOTAL_CPU_PCT        != -1 AND D.TOT_CPU_PCT     >= BI.MIN_TOTAL_CPU_PCT        THEN '*' || CHAR(32) ELSE '' END || TO_DECIMAL(ROUND(D.TOT_CPU_PCT), 10, 0),  11)      TOT_CPU_PCT,
    LPAD(CASE WHEN BI.MARK_CRITICAL = 'X' AND BI.MIN_SYSTEM_CPU_PCT       != -1 AND D.SYS_CPU_PCT     >= BI.MIN_SYSTEM_CPU_PCT       THEN '*' || CHAR(32) ELSE '' END || TO_DECIMAL(ROUND(D.SYS_CPU_PCT), 10, 0),  11)      SYS_CPU_PCT,
    LPAD(CASE WHEN BI.MARK_CRITICAL = 'X' AND BI.MIN_MEM_USED_PCT         != -1 AND D.MEM_USED_PCT    >= BI.MIN_MEM_USED_PCT         THEN '*' || CHAR(32) ELSE '' END || TO_DECIMAL(ROUND(D.MEM_USED_PCT), 10, 0), 12)      MEM_USED_PCT,
    LPAD(CASE WHEN BI.MARK_CRITICAL = 'X' AND BI.MIN_UNLOADS              != -1 AND D.UNLOADS         >= BI.MIN_UNLOADS              THEN '*' || CHAR(32) ELSE '' END || TO_DECIMAL(ROUND(D.UNLOADS), 10, 0), 7)            UNLOADS,
    LPAD(CASE WHEN BI.MARK_CRITICAL = 'X' AND BI.MIN_SWAP_IN_MB           != -1 AND D.SWAP_IN_MB      >= BI.MIN_SWAP_IN_MB           THEN '*' || CHAR(32) ELSE '' END || TO_DECIMAL(D.SWAP_IN_MB, 10, 2), 10)               SWAP_IN_MB,
    LPAD(CASE WHEN BI.MARK_CRITICAL = 'X' AND BI.MIN_PING_MS              != -1 AND D.PING_MS         >= BI.MIN_PING_MS              THEN '*' || CHAR(32) ELSE '' END || TO_DECIMAL(ROUND(D.PING_MS), 10, 0), 7)            PING_MS,
    LPAD(CASE WHEN BI.MARK_CRITICAL = 'X' AND BI.MIN_VERSIONS             != -1 AND D.VERSIONS        >= BI.MIN_VERSIONS             THEN '*' || CHAR(32) ELSE '' END || TO_DECIMAL(ROUND(D.VERSIONS / 1000000), 10, 0), 6) VERS_M,
    LPAD(CASE WHEN BI.MARK_CRITICAL = 'X' AND BI.MIN_LOAD_GAP_S           != -1 AND D.LOAD_GAP_S      >= BI.MIN_LOAD_GAP_S           THEN '*' || CHAR(32) ELSE '' END || TO_DECIMAL(ROUND(D.LOAD_GAP_S), 10, 0), 10)        LOAD_GAP_S,
    LPAD(CASE WHEN BI.MARK_CRITICAL = 'X' AND BI.MIN_PENDING_SESSIONS     != -1 AND D.PEND_SESS       >= BI.MIN_PENDING_SESSIONS     THEN '*' || CHAR(32) ELSE '' END || TO_DECIMAL(ROUND(D.PEND_SESS), 10, 0), 9)          PEND_SESS,
    LPAD(CASE WHEN BI.MARK_CRITICAL = 'X' AND BI.MIN_WAITING_THREADS      != -1 AND D.WAIT_THR        >= BI.MIN_WAITING_THREADS      THEN '*' || CHAR(32) ELSE '' END || TO_DECIMAL(ROUND(D.WAIT_THR), 10, 0), 8)           WAIT_THR,
    LPAD(CASE WHEN BI.MARK_CRITICAL = 'X' AND BI.MIN_BLOCKED_TRANSACTIONS != -1 AND D.BLK_TRANS       >= BI.MIN_BLOCKED_TRANSACTIONS THEN '*' || CHAR(32) ELSE '' END || TO_DECIMAL(ROUND(D.BLK_TRANS), 10, 0), 9)          BLK_TRANS,
    LPAD(CASE WHEN BI.MARK_CRITICAL = 'X' AND BI.MIN_DATA_READ_PCT        != -1 AND D.DATA_READ_PCT   >= BI.MIN_DATA_READ_PCT        THEN '*' || CHAR(32) ELSE '' END || TO_DECIMAL(ROUND(D.DATA_READ_PCT), 10, 0), 8)      D_RD_PCT,
    LPAD(CASE WHEN BI.MARK_CRITICAL = 'X' AND BI.MIN_DATA_WRITE_PCT       != -1 AND D.DATA_WRITE_PCT  >= BI.MIN_DATA_WRITE_PCT       THEN '*' || CHAR(32) ELSE '' END || TO_DECIMAL(ROUND(D.DATA_WRITE_PCT), 10, 0), 8)     D_WR_PCT,
    LPAD(CASE WHEN BI.MARK_CRITICAL = 'X' AND BI.MIN_LOG_WRITE_PCT        != -1 AND D.LOG_WRITE_PCT   >= BI.MIN_LOG_WRITE_PCT        THEN '*' || CHAR(32) ELSE '' END || TO_DECIMAL(ROUND(D.LOG_WRITE_PCT), 10, 0), 8)      L_WR_PCT
  FROM
    BASIS_INFO BI,
  ( SELECT
      L.BEGIN_TIME,
      L.HOST,
      L.TOT_CPU_PCT,
      L.SYS_CPU_PCT,
      L.MEM_USED_PCT,
      L.UNLOADS,
      L.SWAP_IN_MB,
      L.PING_MS,
      L.LOAD_GAP_S,
      L.PEND_SESS,
      L.VERSIONS,
      L.WAIT_THR,
      L.BLK_TRANS,
      L.DATA_READ_PCT,
      L.DATA_WRITE_PCT,
      L.LOG_READ_PCT,
      L.LOG_WRITE_PCT
    FROM
      BASIS_INFO BI,
    ( SELECT
        ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), 
          FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.TIME END) / BI.TIME_SLICE_S) * BI.TIME_SLICE_S) BEGIN_TIME,
        L.HOST,
        MAP(BI.AGGREGATION_TYPE, 'PEAK', MAX(L.CPU),        AVG(L.CPU)) TOT_CPU_PCT,
        MAP(BI.AGGREGATION_TYPE, 'PEAK', MAX(L.SYSTEM_CPU), AVG(L.SYSTEM_CPU)) SYS_CPU_PCT,
        MAP(BI.AGGREGATION_TYPE, 'PEAK', MAX(L.MEMORY_USED / L.MEMORY_ALLOCATION_LIMIT * 100), AVG(L.MEMORY_USED / L.MEMORY_ALLOCATION_LIMIT * 100)) MEM_USED_PCT,
        MAP(BI.AGGREGATION_TYPE, 'PEAK', MAX(L.CS_UNLOAD_COUNT), AVG(L.CS_UNLOAD_COUNT)) / 1024 / 1024 UNLOADS,
        MAP(BI.AGGREGATION_TYPE, 'PEAK', MAX(L.SWAP_IN),    AVG(L.SWAP_IN)) / 1024 / 1024 SWAP_IN_MB,
        MAP(BI.AGGREGATION_TYPE, 'PEAK', MAX(L.PING_TIME),  AVG(L.PING_TIME)) PING_MS,
        MAP(BI.AGGREGATION_TYPE, 'PEAK', MAX(L.PENDING_SESSION_COUNT), AVG(L.PENDING_SESSION_COUNT)) PEND_SESS,
        MAP(BI.AGGREGATION_TYPE, 'PEAK', MAX(L.WAITING_THREAD_COUNT), AVG(L.WAITING_THREAD_COUNT)) WAIT_THR,
        MAP(BI.AGGREGATION_TYPE, 'PEAK', MAX(L.BLOCKED_TRANSACTION_COUNT), AVG(L.BLOCKED_TRANSACTION_COUNT)) BLK_TRANS,
        MAP(BI.AGGREGATION_TYPE, 'PEAK', MAX(L.VERSION_COUNT), AVG(L.VERSION_COUNT)) VERSIONS,
        MAP(BI.AGGREGATION_TYPE, 'PEAK', MAX(LEAST(L.DATA_READ_S / L.INTERVAL_S * 100, 100)), LEAST(SUM(L.DATA_READ_S) / SUM(L.INTERVAL_S) * 100, 100)) DATA_READ_PCT,
        MAP(BI.AGGREGATION_TYPE, 'PEAK', MAX(LEAST(L.DATA_WRITE_S / L.INTERVAL_S * 100, 100)), LEAST(SUM(L.DATA_WRITE_S) / SUM(L.INTERVAL_S) * 100, 100)) DATA_WRITE_PCT,
        MAP(BI.AGGREGATION_TYPE, 'PEAK', MAX(LEAST(L.LOG_READ_S / L.INTERVAL_S * 100, 100)), LEAST(SUM(L.LOG_READ_S) / SUM(L.INTERVAL_S) * 100, 100)) LOG_READ_PCT,
        MAP(BI.AGGREGATION_TYPE, 'PEAK', MAX(LEAST(L.LOG_WRITE_S / L.INTERVAL_S * 100, 100)), LEAST(SUM(L.LOG_WRITE_S) / SUM(L.INTERVAL_S) * 100, 100)) LOG_WRITE_PCT,
        MAP(BI.AGGREGATION_TYPE, 'PEAK', MAX(L.INTERVAL_S), AVG(L.INTERVAL_S)) LOAD_GAP_S
      FROM
        BASIS_INFO BI,
      ( SELECT
          HOST,
          TIME,
          CPU,
          SYSTEM_CPU,
          MEMORY_USED,
          MEMORY_ALLOCATION_LIMIT,
          CS_UNLOAD_COUNT,
          SWAP_IN,
          PING_TIME,
          PENDING_SESSION_COUNT,
          MVCC_VERSION_COUNT VERSION_COUNT,
          WAITING_THREAD_COUNT,
          BLOCKED_TRANSACTION_COUNT,
          DATA_READ_TIME / 1000000 DATA_READ_S,
          DATA_WRITE_TIME / 1000000 DATA_WRITE_S,
          LOG_READ_TIME / 1000000 LOG_READ_S,
          LOG_WRITE_TIME / 1000000 LOG_WRITE_S,
          NANO100_BETWEEN(LAG(TIME, 1) OVER (PARTITION BY HOST, PORT ORDER BY TIME), TIME) / 10000000 INTERVAL_S
        FROM
          M_LOAD_HISTORY_SERVICE
        WHERE
          MEMORY_ALLOCATION_LIMIT > 0
        UNION
        SELECT
          HOST,
          TIME,
          CPU,
          SYSTEM_CPU,
          MEMORY_USED,
          MEMORY_ALLOCATION_LIMIT,
          CS_UNLOAD_COUNT,
          SWAP_IN,
          PING_TIME,
          PENDING_SESSION_COUNT,
          MVCC_VERSION_COUNT VERSION_COUNT,
          WAITING_THREAD_COUNT,
          BLOCKED_TRANSACTION_COUNT,
          DATA_READ_TIME / 1000000 DATA_READ_S,
          DATA_WRITE_TIME / 1000000 DATA_WRITE_S,
          LOG_READ_TIME / 1000000 LOG_READ_S,
          LOG_WRITE_TIME / 1000000 LOG_WRITE_S,
          NANO100_BETWEEN(LAG(TIME, 1) OVER (PARTITION BY HOST, PORT ORDER BY TIME), TIME) / 10000000 INTERVAL_S
        FROM
          _SYS_STATISTICS.HOST_LOAD_HISTORY_SERVICE
        WHERE
          MEMORY_ALLOCATION_LIMIT > 0
      ) L
      WHERE
        L.HOST LIKE BI.HOST AND
        CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.TIME END BETWEEN BI.BEGIN_TIME AND BI.END_TIME
      GROUP BY
        ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), 
          FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(L.TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE L.TIME END) / BI.TIME_SLICE_S) * BI.TIME_SLICE_S),
        L.HOST,
        BI.AGGREGATION_TYPE
    ) L
    WHERE
    ( MIN_TOTAL_CPU_PCT        != -1 AND TOT_CPU_PCT    >= MIN_TOTAL_CPU_PCT        ) OR
    ( MIN_SYSTEM_CPU_PCT       != -1 AND SYS_CPU_PCT    >= MIN_SYSTEM_CPU_PCT       ) OR
    ( MIN_MEM_USED_PCT         != -1 AND MEM_USED_PCT   >= MIN_MEM_USED_PCT         ) OR
    ( MIN_UNLOADS              != -1 AND UNLOADS        >= MIN_UNLOADS              ) OR
    ( MIN_SWAP_IN_MB           != -1 AND SWAP_IN_MB     >= MIN_SWAP_IN_MB           ) OR
    ( MIN_PING_MS              != -1 AND PING_MS        >= MIN_PING_MS              ) OR
    ( MIN_VERSIONS             != -1 AND VERSIONS       >= MIN_VERSIONS             ) OR
    ( MIN_PENDING_SESSIONS     != -1 AND PEND_SESS      >= MIN_PENDING_SESSIONS     ) OR
    ( MIN_LOAD_GAP_S           != -1 AND LOAD_GAP_S     >= MIN_LOAD_GAP_S           ) OR
    ( MIN_WAITING_THREADS      != -1 AND WAIT_THR       >= MIN_WAITING_THREADS      ) OR
    ( MIN_BLOCKED_TRANSACTIONS != -1 AND BLK_TRANS      >= MIN_BLOCKED_TRANSACTIONS ) OR
    ( MIN_DATA_READ_PCT        != -1 AND DATA_READ_PCT  >= MIN_DATA_READ_PCT        ) OR
    ( MIN_DATA_WRITE_PCT       != -1 AND DATA_WRITE_PCT >= MIN_DATA_WRITE_PCT       ) OR
    ( MIN_LOG_WRITE_PCT        != -1 AND LOG_WRITE_PCT  >= MIN_LOG_WRITE_PCT        )
  ) D
)
GROUP BY
  BEGIN_TIME,
  HOST,
  AGG
ORDER BY
  BEGIN_TIME DESC