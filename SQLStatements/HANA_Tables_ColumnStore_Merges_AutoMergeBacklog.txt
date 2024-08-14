WITH 

/* 

[NAME]

- HANA_Tables_ColumnStore_Merges_AutoMergeBacklog

[DESCRIPTION]

- Evaluation if tables fulfill auto merge decision function so that auto merge should run

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Auto merge decision function is defined via parameter indexserver.ini -> [mergedog] -> auto_merge_decision_func (SAP Note 2057046)
- The following auto merge decision function is evaluated which completely covers SAP HANA 2.0 SPS 05:

  ((DRC*TMD > 3600*(MRC+0.0001)) or ((DMS>PAL/2000 or DMS > 1000 or DRCC>100) and DRRC > MRC/100) or (DMR>0.2*MRC and DMR > 0.001)

- For SAP HANA >= 2.0 SPS 06 the decision function is enhanced with some specific scenarios, but the above size based 
  conditions are still of major importance

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2022/12/10:  1.0 (initial version)

[INVOLVED TABLES]

- M_CS_TABLES
- M_SERVICE_MEMORY
- TABLE_COLUMNS
- TABLES

[INPUT PARAMETERS]

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

- MIN_DELTA_SIZE_MB

  Minimum delta size threshold (MB)

  100             --> Only consider tables with a delta size of at least 100 MB
  -1              --> No restriction related to delta size

- MIN_THRESHOLD_FACTOR

  1.2             --> Only display a table as backlog when one condition is at least factor 1.2 above decision function threshold
  1               --> Consider all tables as backlog that fulfill the auto merge decision function

- ONLY_BACKLOG

  Restrict output to tables fulfilling the auto merge decision function at the moment

  'X'             --> Only display tables fulfilling the auto merge decision function (i.e. backlog)
  ' '             --> No restriction to auto merge decision function fulfillment

- ONLY_AUTO_MERGE_TABLES

  Restrict output to tables with activated auto merge

  'X'             --> Only consider tables with activated auto merge
  ' '             --> No restriction to auto merge property of tables

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'MAIN_SIZE'     --> Sorting by main storage size
  'DELTA_ROWS'    --> Sorting by delta record count
  
[OUTPUT PARAMETERS]

- ANALYSIS_TIME:     Analysis timestamp
- HOST:              Host name
- PORT:              Port
- SCHEMA_NAME:       Schema name
- TABLE_NAME:        Table name
- LAST_MERGE_TIME:   Last delta merge time
- MAIN_RECORDS:      Raw record count in main storage
- DELTA_RECORDS:     Raw record count in delta storage
- MAIN_GB:           Main storage size (GB) 
- DELTA_GB:          Delta storage size (GB)
- AUTO_MERGE_REASON: Parts of auto merge decision function qualifying table for auto merge
                     (numbers in square brackets indicate the calculated values for the different variables)

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST      |PORT |SCHEMA_NAME|TABLE_NAME|LAST_MERGE_TIME    |MAIN_RECORDS|DELTA_RECORDS|MAIN_GB   |DELTA_GB  |AUTO_MERGE_REASON                                         |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|hananode01|30240|SAPABAP1   |CKMLKALNR |2022/12/06 18:59:07|   441006999|      4804030|      9.83|      0.82|DRC[4.804030]*TMD[331397]>MRC[441.006999]+0.0001          |
|hananode01|30240|SAPABAP1   |BALDAT (4)|2022/12/10 01:40:27|    44536561|       637733|     17.84|      0.32|DMR[11.387267]>0.2*MRC[44.536561] AND DMR[11.387267]>0.001|
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

BASIS_INFO AS
( SELECT                     /* Modification section */
    '%' HOST,
    '%' PORT,
    '%' SCHEMA_NAME,
    '%' TABLE_NAME,
    5   MIN_DELTA_SIZE_MB,
    1.2 MIN_THRESHOLD_FACTOR,
    'X' ONLY_BACKLOG,
    'X' ONLY_AUTO_MERGE_TABLES,
    'DELTA_SIZE' ORDER_BY                      /* MAIN_SIZE, MAIN_ROWS, DELTA_SIZE, DELTA_ROWS */
  FROM
    DUMMY
),
TABLE_LIST AS
( SELECT
    CT.HOST,
    CT.PORT,
    CT.SCHEMA_NAME,
    CT.TABLE_NAME || MAP(CT.PART_ID, -1, '', 0, '', CHAR(32) || '(' || CT.PART_ID || ')') TABLE_NAME,
    CT.RAW_RECORD_COUNT_IN_MAIN,
    CT.RAW_RECORD_COUNT_IN_DELTA,
    CT.MEMORY_SIZE_IN_MAIN,
    CT.MEMORY_SIZE_IN_DELTA,
    CT.LAST_MERGE_TIME,
    TC.NUM_COLUMNS * CT.RAW_RECORD_COUNT_IN_DELTA / 1000000 DCC,
    TC.NUM_COLUMNS * CT.RAW_RECORD_COUNT_IN_DELTA / 1000000 DRCC,
    GREATEST(0, CT.MAX_UDIV - CT.RECORD_COUNT) / 1000000 DMR,
    CT.MEMORY_SIZE_IN_DELTA / 1024 / 1024 DMS,
    CT.RAW_RECORD_COUNT_IN_DELTA / 1000000 DRC,
    CT.RAW_RECORD_COUNT_IN_DELTA / 1000000 DRRC,
    CT.MEMORY_SIZE_IN_MAIN / 1024 / 1024 MMS,
    CT.RAW_RECORD_COUNT_IN_MAIN / 1000000 MRC,
    M.ALLOCATION_LIMIT / 1024 / 1024 PAL,
    SECONDS_BETWEEN(CT.LAST_MERGE_TIME, CURRENT_TIMESTAMP) TMD
  FROM
    BASIS_INFO BI,
  ( SELECT
      CT.*
    FROM
      BASIS_INFO BI,
      M_CS_TABLES CT
    WHERE
      CT.RAW_RECORD_COUNT_IN_DELTA > 0 AND
    ( BI.MIN_DELTA_SIZE_MB = -1 OR CT.MEMORY_SIZE_IN_DELTA / 1024 / 1024 >= BI.MIN_DELTA_SIZE_MB )
  ) CT,
    TABLES T,
    M_SERVICE_MEMORY M,
  ( SELECT
      SCHEMA_NAME,
      TABLE_NAME,
      COUNT(*) NUM_COLUMNS
    FROM
      TABLE_COLUMNS
    GROUP BY
      SCHEMA_NAME,
      TABLE_NAME
  ) TC
  WHERE
    CT.HOST LIKE BI.HOST AND
    TO_VARCHAR(CT.PORT) LIKE BI.PORT AND
    CT.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    CT.TABLE_NAME LIKE BI.TABLE_NAME AND
    CT.HOST = M.HOST AND
    CT.PORT = M.PORT AND
    CT.SCHEMA_NAME = T.SCHEMA_NAME AND
    CT.TABLE_NAME = T.TABLE_NAME AND
    CT.SCHEMA_NAME = TC.SCHEMA_NAME AND
    CT.TABLE_NAME = TC.TABLE_NAME AND
  ( BI.ONLY_AUTO_MERGE_TABLES = ' ' OR T.AUTO_MERGE_ON = 'TRUE' )
)
SELECT
  TO_VARCHAR(CURRENT_TIMESTAMP, 'YYYY/MM/DD HH24:MI:SS') ANALYSIS_TIME,
  T.HOST,
  LPAD(T.PORT, 5) PORT,
  T.SCHEMA_NAME,
  T.TABLE_NAME,
  TO_VARCHAR(T.LAST_MERGE_TIME, 'YYYY/MM/DD HH24:MI:SS') LAST_MERGE_TIME,
  LPAD(T.RAW_RECORD_COUNT_IN_MAIN, 12) MAIN_RECORDS,
  LPAD(T.RAW_RECORD_COUNT_IN_DELTA, 13) DELTA_RECORDS,
  LPAD(TO_DECIMAL(T.MEMORY_SIZE_IN_MAIN / 1024 / 1024 / 1024, 10, 2), 10) MAIN_GB,
  LPAD(TO_DECIMAL(T.MEMORY_SIZE_IN_DELTA / 1024 / 1024 / 1024, 10, 2), 10) DELTA_GB,
  LTRIM(RTRIM(REPLACE(CASE 
    WHEN DRC * TMD > 3600 * ( MRC + 0.0001 ) 
    THEN 'DRC[' || DRC || ']*TMD[' || TMD || ']>3600*MRC[' || MRC || ']+0.0001' ELSE '' 
  END || ',' || CHAR(32) ||
    CASE 
      WHEN ( DMS > PAL / 2000 OR DMS > 1000 OR DRCC > 100 ) AND DRRC > MRC / 100
      THEN '(DMS[' || DMS || ']>PAL[' || PAL || ']/2000 OR DMS[' || DMS || ']>1000 OR DRCC[' || DRCC || ']>100) AND DRCC[' || DRCC || ']>MRC[' || MRC ||']/100)' ELSE ''
    END || ',' || CHAR(32) ||
    CASE
      WHEN DMR > 0.2 * MRC AND DMR > 0.001
      THEN 'DMR[' || DMR || ']>0.2*MRC[' || MRC || '] AND DMR[' || DMR || ']>0.001' ELSE ''
    END, ', , ', ', '), ', '), ', ') AUTO_MERGE_REASON
FROM
  BASIS_INFO BI,
  TABLE_LIST T
WHERE
( BI.ONLY_BACKLOG = ' ' OR
  BI.ONLY_BACKLOG = 'X' AND 
  ( DRC * TMD > BI.MIN_THRESHOLD_FACTOR * 3600 * ( MRC + 0.0001 ) OR
    ( ( DMS > BI.MIN_THRESHOLD_FACTOR * PAL / 2000 OR DMS > 1000 OR DRCC > 100 ) AND DRRC > BI.MIN_THRESHOLD_FACTOR * MRC / 100 ) OR
    ( DMR > BI.MIN_THRESHOLD_FACTOR * 0.2 * MRC AND DMR > 0.001 )
  )
)
ORDER BY
  MAP(BI.ORDER_BY, 'MAIN_ROWS', T.RAW_RECORD_COUNT_IN_MAIN, 'DELTA_ROWS', T.RAW_RECORD_COUNT_IN_DELTA,
    'MAIN_SIZE', T.MEMORY_SIZE_IN_MAIN, 'DELTA_SIZE', T.MEMORY_SIZE_IN_DELTA ) DESC
