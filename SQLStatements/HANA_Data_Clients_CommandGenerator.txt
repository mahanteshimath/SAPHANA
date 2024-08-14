WITH 
/* 

[NAME]

- HANA_Data_Clients_CommandGenerator

[DESCRIPTION]

- Client (MANDT) size distribution in largest tables

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Takes advantage of WITH clause, so may not work with older DBACOCKPIT versions
- Command generator, so the result is a SQL statement that has to be executed in the second step
- May consume significant amounts of memory, because actual table data has to be scanned
- Clients outside of the range 000 - 999 (e.g. TSK) may show up in context of table BDLDATCOL (internal incident 2270003542)
- WITH clause requires at least Rev. 70
- WITH clause does not work with older DBACOCKPIT transactions before SAP BASIS 7.02 SP16 / 7.30 SP12 / 7.31 SP12 / SAP_BASIS 7.40 SP07 (empty result returned) 

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/04/20:  1.0 (initial version)
- 2017/07/20:  1.1 (CLIENT input parameter included)
- 2017/10/21:  1.2 (COLUMN_ORDER_BY included)
- 2018/10/01:  1.3 (maximum number of displayed clients increased from 10 to 32)

[INVOLVED TABLES]

- M_TABLE_PERSISTENCE_STATISTICS
- TABLE_COLUMNS

[INPUT PARAMETERS]

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

- CLIENT

  SAP client

  '123'           --> Client 123
  '1%'            --> All clients starting with '1'
  '%'             --> No restriction related to client

- MIN_SIZE_MB

  Minimum table size (MB)

  1024            --> Only consider tables with a size of at least 1024 MB
  -1              --> No restriction related to table size

- COLUMN_ORDER_BY

  Sorting of client columns

  'CLIENT'        --> Sort by client number
  'SIZE'          --> Sort by client size (top - down)

- RESULT_ROWS

  Number of records to be returned by the query

  100             --> Return a maximum number of 100 records
  -1              --> Return all records

[OUTPUT PARAMETERS]

- SCHEMA_NAME:   Schema name
- TABLE_NAME:    Table name
- TOTAL_SIZE_GB: Total table size on disk (GB)
- CLIENT_COLUMN: Name of client column ('n/a' if no client column was identified)
- SIZE_GB_<n>:   Size of client (GB)

[EXAMPLE OUTPUT]

- In the first step a SQL statement like the following is generated:

-----------------------------------------------------------------------------------------------------------------
|WITHCLIENT_TABLE_DISTRIBUTIO                                                                                   |
-----------------------------------------------------------------------------------------------------------------
|WITH CLIENT_TABLE_DISTRIBUTION AS                                                                              |
|( SELECT O SCHEMA_NAME, T TABLE_NAME, C CLIENT, CC CLIENT_COLUMN_NAME, B BYTES, CR CLIENT_ROWS,                |
|  TR TOTAL_ROWS, CR / TR * B CLIENT_BYTES FROM                                                                 |
|  ( SELECT O, T, C, CC, B, CR, SUM(CR) OVER (PARTITION BY O, T) TR FROM (                                      |
|SELECT                                                                                                         |
|'SAPBWH' O, '/BIC/AMCLGDSO300' T, 'n/a' C, 'n/a' CC,                                                           |
|455675904 B, COUNT(*) CR FROM "SAPBWH"."/BIC/AMCLGDSO300" GROUP BY 'n/a' UNION ALL                             |
|SELECT                                                                                                         |
|'SAPBWH' O, '/BIC/AMCLGDSO440' T, 'n/a' C, 'n/a' CC,                                                           |
|247263232 B, COUNT(*) CR FROM "SAPBWH"."/BIC/AMCLGDSO440" GROUP BY 'n/a' UNION ALL                             |
...
|SELECT                                                                                                         |
|'SAPBWH' O, '_SYS_SPLIT_/BIC/ACLGDSOZC~1' T, 'n/a' C, 'n/a' CC,                                                |
|166993920 B, COUNT(*) CR FROM "SAPBWH"."_SYS_SPLIT_/BIC/ACLGDSOZC~1" GROUP BY 'n/a' UNION ALL                  |
|SELECT '', '', '', '', 1, 1 FROM DUMMY WHERE 1 = 0 )                                                           |
|  )                                                                                                            |
|),                                                                                                             |
|CLIENT_DISTRIBUTION AS                                                                                         |
|( SELECT ROW_NUMBER () OVER () CLIENT_POS, CLIENT, BYTES FROM                                                  |
|  ( SELECT CLIENT, SUM(CLIENT_BYTES) BYTES                                                                     |
|    FROM CLIENT_TABLE_DISTRIBUTION                                                                             |
|    GROUP BY CLIENT                                                                                            |
|    ORDER BY 2 DESC                                                                                            |
|  )                                                                                                            |
|)                                                                                                              |
|SELECT                                                                                                         |
|  '' SCHEMA_NAME,                                                                                              |
|  'CLIENTS' TABLE_NAME,                                                                                        |
|  '' TOTAL_SIZE_GB,                                                                                            |
|  '' CLIENT_COLUMN,                                                                                            |
|...
|    CLIENT_TABLE_DISTRIBUTION CTD LEFT OUTER JOIN                                                              |
|    CLIENT_DISTRIBUTION CD ON                                                                                  |
|      CTD.CLIENT = CD.CLIENT                                                                                   |
|  GROUP BY                                                                                                     |
|    CTD.SCHEMA_NAME,                                                                                           |
|    CTD.TABLE_NAME,                                                                                            |
|    CTD.BYTES,                                                                                                 |
|    CTD.CLIENT_COLUMN_NAME                                                                                     |
|  ORDER BY                                                                                                     |
|    CTD.BYTES DESC, CTD.SCHEMA_NAME, CTD.TABLE_NAME                                                            |
|)                                                                                                              |
|)                                                                                                              |
-----------------------------------------------------------------------------------------------------------------

- This SQL statement needs to be executed in order to generate the client sizes:

--------------------------------------------------------------------------------------------------------------------------------------------------------------
|SCHEMA_NAME|TABLE_NAME      |TOTAL_SIZE_GB|CLIENT_COLUMN|SIZE_GB_1|SIZE_GB_2|SIZE_GB_3|SIZE_GB_4|SIZE_GB_5|SIZE_GB_6|SIZE_GB_7|SIZE_GB_8|SIZE_GB_9|SIZE_GB10|
--------------------------------------------------------------------------------------------------------------------------------------------------------------
|           |CLIENTS         |             |             |   701   |   901   |   100   |   n/a   |   601   |   900   |   801   |   000   |   001   |         |
|           |                |             |             |         |         |         |         |         |         |         |         |         |         |
|           |TOTAL           |       794.89|             |   415.38|   160.30|    89.86|    50.86|    36.84|    30.73|    10.47|     0.35|     0.05|         |
|           |                |             |             |         |         |         |         |         |         |         |         |         |         |
|SAPSR3     |EDID4           |        96.00|MANDT        |    50.11|    45.67|         |         |     0.21|         |         |         |         |         |
|SAPSR3     |FSBP_CNS_IMAGE  |        57.90|MANDT        |    25.71|    11.82|     6.10|         |     7.62|     6.62|         |         |         |         |
|SAPSR3     |CKMLPRKEPH      |        49.23|MANDT        |    49.19|         |         |         |     0.03|         |         |         |         |         |
|SAPSR3     |SWWCNTP0        |        49.18|CLIENT       |     0.06|         |    49.11|         |     0.00|         |         |         |         |         |
|SAPSR3     |CDPOS           |        44.29|MANDANT      |    42.15|     0.57|     1.01|         |     0.50|     0.04|         |     0.00|     0.00|         |
|SAPSR3     |BALDAT          |        34.37|MANDANT      |    30.49|     0.10|     1.35|         |     2.05|     0.00|     0.00|     0.32|     0.04|         |
|SAPSR3     |MBEWH           |        26.86|MANDT        |    17.04|     9.63|         |         |     0.00|         |     0.17|         |         |         |
|SAPSR3     |ACDOCA          |        25.03|RCLNT        |     4.98|     4.96|     4.96|         |     4.96|     4.96|     0.18|         |         |         |
|SAPSR3     |SOFFCONT1       |        22.61|MANDT        |     4.06|     3.70|     3.66|         |     3.78|     3.66|     3.71|         |         |         |
...
--------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

BASIS_INFO AS
( SELECT                            /* Modification section */
    'SAP%' SCHEMA_NAME,
    '%' TABLE_NAME,
    '%' CLIENT,
    -1 MIN_SIZE_MB,
    'SIZE' COLUMN_ORDER_BY,                 /* CLIENT, SIZE */
    50 RESULT_ROWS
  FROM
    DUMMY
),
TABLE_SIZES AS
( SELECT
    SCHEMA_NAME,
    TABLE_NAME,
    BYTES
  FROM
  ( SELECT
      S.SCHEMA_NAME,
      S.TABLE_NAME,
      S.DISK_SIZE BYTES,
      BI.RESULT_ROWS,
      ROW_NUMBER () OVER (ORDER BY DISK_SIZE DESC) ROW_NUM
    FROM
      M_TABLE_PERSISTENCE_STATISTICS S,
      BASIS_INFO BI
    WHERE
      S.DISK_SIZE / 1024 / 1024 >= BI.MIN_SIZE_MB AND
      S.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
      S.TABLE_NAME LIKE BI.TABLE_NAME
  )
  WHERE
    ( RESULT_ROWS = -1 OR ROW_NUM <= RESULT_ROWS )
),
TABLE_INFO AS
( SELECT
    TS.SCHEMA_NAME,
    TS.TABLE_NAME,
    TS.BYTES,
    IFNULL(TC.COLUMN_NAME, 'CLIENT INDEPENDENT') COLUMN_NAME
  FROM
    TABLE_SIZES TS LEFT OUTER JOIN
    TABLE_COLUMNS TC ON
      TC.SCHEMA_NAME = TS.SCHEMA_NAME AND
      TC.TABLE_NAME = TS.TABLE_NAME AND
      TC.COLUMN_NAME IN ('CLIENT', 'CLNT', 'DCLIENT', 'MANDANT', 'MANDT', 'RCLNT', 'SAPCLIENT')
)
SELECT
  COMMAND
FROM
( SELECT 10 LINE_NO, 'WITH CLIENT_TABLE_DISTRIBUTION AS' COMMAND FROM DUMMY UNION ALL
  ( SELECT 20, '( SELECT O SCHEMA_NAME, T TABLE_NAME, C CLIENT, CC CLIENT_COLUMN_NAME, B BYTES, CR CLIENT_ROWS,' FROM DUMMY ) UNION ALL
  ( SELECT 30, '  TR TOTAL_ROWS, CR / TR * B CLIENT_BYTES FROM' FROM DUMMY ) UNION ALL
  ( SELECT 40, '  ( SELECT O, T, C, CC, B, CR, SUM(CR) OVER (PARTITION BY O, T) TR FROM (' FROM DUMMY ) UNION ALL
  ( SELECT 50 + ROW_NUM, LINE FROM
    ( SELECT ROW_NUMBER () OVER (ORDER BY T.SCHEMA_NAME, T.TABLE_NAME) * 3 + 1 ROW_NUM, T.SCHEMA_NAME, T.TABLE_NAME, 'SELECT ' LINE FROM BASIS_INFO BI, TABLE_INFO T UNION ALL
      ( SELECT ROW_NUMBER () OVER (ORDER BY SCHEMA_NAME, TABLE_NAME) * 3 + 2 ROW_NUM, SCHEMA_NAME, TABLE_NAME, CHAR(39) || SCHEMA_NAME || CHAR(39) || ' O, ' || CHAR(39) || TABLE_NAME || CHAR(39) || 
        ' T, ' || MAP(COLUMN_NAME, 'CLIENT INDEPENDENT', CHAR(39) || 'n/a' || CHAR(39), COLUMN_NAME) || 
        ' C, ' || CHAR(39) || MAP(COLUMN_NAME, 'CLIENT INDEPENDENT', 'n/a', COLUMN_NAME) || CHAR(39) || ' CC, ' FROM TABLE_INFO ) UNION ALL
      ( SELECT ROW_NUMBER () OVER (ORDER BY SCHEMA_NAME, TABLE_NAME) * 3 + 3 ROW_NUM, SCHEMA_NAME, TABLE_NAME, BYTES || ' B, COUNT(*) CR FROM "' || SCHEMA_NAME || '"."' || TABLE_NAME || 
        '" GROUP BY ' || MAP(COLUMN_NAME, 'CLIENT INDEPENDENT', CHAR(39) || 'n/a' || CHAR(39), COLUMN_NAME) || ' UNION ALL' FROM TABLE_INFO )
    ) 
  ) UNION ALL
  ( SELECT 10000, 'SELECT ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', 1, 1 FROM DUMMY 
      WHERE 1 = 0 )' FROM DUMMY ) UNION ALL
  ( SELECT 10010, '  )' FROM DUMMY ) UNION ALL
  ( SELECT 10015, 'WHERE' FROM DUMMY ) UNION ALL
  ( SELECT 10016, '  C LIKE' || CHAR(32) || CHAR(39) || CLIENT || CHAR(39) FROM BASIS_INFO ) UNION ALL
  ( SELECT 10020, '),' FROM DUMMY ) UNION ALL
  ( SELECT 10030, 'CLIENT_DISTRIBUTION AS' FROM DUMMY ) UNION ALL
  ( SELECT 10040, '( SELECT ROW_NUMBER () OVER (ORDER BY' || CHAR(32) ||
      MAP(COLUMN_ORDER_BY, 'CLIENT', 'CLIENT', 'BYTES DESC') || ') CLIENT_POS, CLIENT, BYTES FROM' FROM BASIS_INFO ) UNION ALL
  ( SELECT 10050, '  ( SELECT CLIENT, SUM(CLIENT_BYTES) BYTES' FROM DUMMY ) UNION ALL
  ( SELECT 10060, '    FROM CLIENT_TABLE_DISTRIBUTION' FROM DUMMY ) UNION ALL
  ( SELECT 10070, '    GROUP BY CLIENT' FROM DUMMY ) UNION ALL
  ( SELECT 10090, '  )' FROM DUMMY ) UNION ALL
  ( SELECT 10100, ')' FROM DUMMY ) UNION ALL
  ( SELECT 10101, 'SELECT' FROM DUMMY ) UNION ALL
  ( SELECT 10102, '  SCHEMA_NAME,' FROM DUMMY ) UNION ALL
  ( SELECT 10103, '  TABLE_NAME,' FROM DUMMY ) UNION ALL
  ( SELECT 10104, '  TOTAL_SIZE_GB,' FROM DUMMY ) UNION ALL
  ( SELECT 10105, '  CLIENT_COLUMN,' FROM DUMMY ) UNION ALL
  ( SELECT 10106, '  SIZE_GB_1,' FROM DUMMY ) UNION ALL
  ( SELECT 10107, '  SIZE_GB_2,' FROM DUMMY ) UNION ALL
  ( SELECT 10108, '  SIZE_GB_3,' FROM DUMMY ) UNION ALL
  ( SELECT 10109, '  SIZE_GB_4,' FROM DUMMY ) UNION ALL
  ( SELECT 10110, '  SIZE_GB_5,' FROM DUMMY ) UNION ALL
  ( SELECT 10111, '  SIZE_GB_6,' FROM DUMMY ) UNION ALL
  ( SELECT 10112, '  SIZE_GB_7,' FROM DUMMY ) UNION ALL
  ( SELECT 10113, '  SIZE_GB_8,' FROM DUMMY ) UNION ALL
  ( SELECT 10114, '  SIZE_GB_9,' FROM DUMMY ) UNION ALL
  ( SELECT 10115, '  SIZE_GB10,' FROM DUMMY ) UNION ALL
  ( SELECT 10116, '  SIZE_GB11,' FROM DUMMY ) UNION ALL
  ( SELECT 10117, '  SIZE_GB12,' FROM DUMMY ) UNION ALL
  ( SELECT 10118, '  SIZE_GB13,' FROM DUMMY ) UNION ALL
  ( SELECT 10119, '  SIZE_GB14,' FROM DUMMY ) UNION ALL
  ( SELECT 10120, '  SIZE_GB15,' FROM DUMMY ) UNION ALL
  ( SELECT 10121, '  SIZE_GB16,' FROM DUMMY ) UNION ALL
  ( SELECT 10122, '  SIZE_GB17,' FROM DUMMY ) UNION ALL
  ( SELECT 10123, '  SIZE_GB18,' FROM DUMMY ) UNION ALL
  ( SELECT 10124, '  SIZE_GB19,' FROM DUMMY ) UNION ALL
  ( SELECT 10125, '  SIZE_GB20,' FROM DUMMY ) UNION ALL
  ( SELECT 10126, '  SIZE_GB21,' FROM DUMMY ) UNION ALL
  ( SELECT 10127, '  SIZE_GB22,' FROM DUMMY ) UNION ALL
  ( SELECT 10128, '  SIZE_GB23,' FROM DUMMY ) UNION ALL
  ( SELECT 10129, '  SIZE_GB24,' FROM DUMMY ) UNION ALL
  ( SELECT 10130, '  SIZE_GB25,' FROM DUMMY ) UNION ALL
  ( SELECT 10131, '  SIZE_GB26,' FROM DUMMY ) UNION ALL
  ( SELECT 10132, '  SIZE_GB27,' FROM DUMMY ) UNION ALL
  ( SELECT 10133, '  SIZE_GB28,' FROM DUMMY ) UNION ALL
  ( SELECT 10134, '  SIZE_GB29,' FROM DUMMY ) UNION ALL
  ( SELECT 10135, '  SIZE_GB30,' FROM DUMMY ) UNION ALL
  ( SELECT 10136, '  SIZE_GB31,' FROM DUMMY ) UNION ALL
  ( SELECT 10137, '  SIZE_GB32'  FROM DUMMY ) UNION ALL
  ( SELECT 10153, 'FROM' FROM DUMMY ) UNION ALL
  ( SELECT 10154, '( SELECT' FROM DUMMY ) UNION ALL
  ( SELECT 10155, '    100 LINE_NO,' FROM DUMMY ) UNION ALL
  ( SELECT 10156, '    ' || CHAR(39) || ' ' || CHAR(39) || ' SCHEMA_NAME,' FROM DUMMY ) UNION ALL
  ( SELECT 10157, '    ' || CHAR(39) || 'CLIENT' || CHAR(39) || ' TABLE_NAME,' FROM DUMMY ) UNION ALL
  ( SELECT 10158, '    ' || CHAR(39) || ' ' || CHAR(39) || ' TOTAL_SIZE_GB,' FROM DUMMY ) UNION ALL
  ( SELECT 10159, '    ' || CHAR(39) || ' ' || CHAR(39) || ' CLIENT_COLUMN,' FROM DUMMY ) UNION ALL
  ( SELECT 10160, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 1, CLIENT)), 6), '''') SIZE_GB_1,' FROM DUMMY ) UNION ALL
  ( SELECT 10170, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 2, CLIENT)), 6), '''') SIZE_GB_2,' FROM DUMMY ) UNION ALL
  ( SELECT 10180, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 3, CLIENT)), 6), '''') SIZE_GB_3,' FROM DUMMY ) UNION ALL
  ( SELECT 10190, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 4, CLIENT)), 6), '''') SIZE_GB_4,' FROM DUMMY ) UNION ALL
  ( SELECT 10200, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 5, CLIENT)), 6), '''') SIZE_GB_5,' FROM DUMMY ) UNION ALL
  ( SELECT 10210, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 6, CLIENT)), 6), '''') SIZE_GB_6,' FROM DUMMY ) UNION ALL
  ( SELECT 10220, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 7, CLIENT)), 6), '''') SIZE_GB_7,' FROM DUMMY ) UNION ALL
  ( SELECT 10230, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 8, CLIENT)), 6), '''') SIZE_GB_8,' FROM DUMMY ) UNION ALL
  ( SELECT 10240, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 9, CLIENT)), 6), '''') SIZE_GB_9,' FROM DUMMY ) UNION ALL
  ( SELECT 10250, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 10, CLIENT)), 6), '''') SIZE_GB10,' FROM DUMMY ) UNION ALL
  ( SELECT 10251, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 11, CLIENT)), 6), '''') SIZE_GB11,' FROM DUMMY ) UNION ALL
  ( SELECT 10252, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 12, CLIENT)), 6), '''') SIZE_GB12,' FROM DUMMY ) UNION ALL
  ( SELECT 10253, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 13, CLIENT)), 6), '''') SIZE_GB13,' FROM DUMMY ) UNION ALL
  ( SELECT 10254, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 14, CLIENT)), 6), '''') SIZE_GB14,' FROM DUMMY ) UNION ALL
  ( SELECT 10255, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 15, CLIENT)), 6), '''') SIZE_GB15,' FROM DUMMY ) UNION ALL
  ( SELECT 10256, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 16, CLIENT)), 6), '''') SIZE_GB16,' FROM DUMMY ) UNION ALL
  ( SELECT 10257, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 17, CLIENT)), 6), '''') SIZE_GB17,' FROM DUMMY ) UNION ALL
  ( SELECT 10258, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 18, CLIENT)), 6), '''') SIZE_GB18,' FROM DUMMY ) UNION ALL
  ( SELECT 10259, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 19, CLIENT)), 6), '''') SIZE_GB19,' FROM DUMMY ) UNION ALL
  ( SELECT 10260, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 20, CLIENT)), 6), '''') SIZE_GB20,' FROM DUMMY ) UNION ALL
  ( SELECT 10261, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 21, CLIENT)), 6), '''') SIZE_GB21,' FROM DUMMY ) UNION ALL
  ( SELECT 10262, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 22, CLIENT)), 6), '''') SIZE_GB22,' FROM DUMMY ) UNION ALL
  ( SELECT 10263, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 23, CLIENT)), 6), '''') SIZE_GB23,' FROM DUMMY ) UNION ALL
  ( SELECT 10264, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 24, CLIENT)), 6), '''') SIZE_GB24,' FROM DUMMY ) UNION ALL
  ( SELECT 10265, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 25, CLIENT)), 6), '''') SIZE_GB25,' FROM DUMMY ) UNION ALL
  ( SELECT 10266, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 26, CLIENT)), 6), '''') SIZE_GB26,' FROM DUMMY ) UNION ALL
  ( SELECT 10267, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 27, CLIENT)), 6), '''') SIZE_GB27,' FROM DUMMY ) UNION ALL
  ( SELECT 10268, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 28, CLIENT)), 6), '''') SIZE_GB28,' FROM DUMMY ) UNION ALL
  ( SELECT 10269, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 29, CLIENT)), 6), '''') SIZE_GB29,' FROM DUMMY ) UNION ALL
  ( SELECT 10270, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 30, CLIENT)), 6), '''') SIZE_GB30,' FROM DUMMY ) UNION ALL
  ( SELECT 10271, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 31, CLIENT)), 6), '''') SIZE_GB31,' FROM DUMMY ) UNION ALL
  ( SELECT 10272, '    IFNULL(LPAD(MAX(MAP(CLIENT_POS, 32, CLIENT)), 6), '''') SIZE_GB32' FROM DUMMY ) UNION ALL
  ( SELECT 10287, '  FROM' FROM DUMMY ) UNION ALL
  ( SELECT 10288, '    CLIENT_DISTRIBUTION' FROM DUMMY ) UNION ALL
  ( SELECT 10289, '  UNION ALL' FROM DUMMY ) UNION ALL
  ( SELECT 10290, '  ( SELECT 200 LINE_NO, ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || 
      ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' FROM DUMMY ) UNION ALL
  ( SELECT 10291, CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) ||
      ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' FROM DUMMY ) UNION ALL
  ( SELECT 10292, CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) ||
      ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' FROM DUMMY ) UNION ALL
  ( SELECT 10293, CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) ||
      ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ' FROM DUMMY )' FROM DUMMY ) UNION ALL
  ( SELECT 10300, '  UNION ALL' FROM DUMMY ) UNION ALL
  ( SELECT 10310, '  ( SELECT' FROM DUMMY ) UNION ALL
  ( SELECT 10315, '      300 LINE_NO,' FROM DUMMY ) UNION ALL
  ( SELECT 10320, '      ' || CHAR(39) || ' ' || CHAR(39) || ' SCHEMA_NAME,' FROM DUMMY ) UNION ALL
  ( SELECT 10330, '      ' || CHAR(39) || 'TOTAL' || CHAR(39) || ' TABLE_NAME,' FROM DUMMY ) UNION ALL
  ( SELECT 10340, '      IFNULL(LPAD((TO_DECIMAL(SUM(CTD.CLIENT_BYTES / 1024 / 1024 / 1024), 10, 2)), 13), '''') TOTAL_SIZE_GB,' FROM DUMMY ) UNION ALL
  ( SELECT 10350, '      ' || CHAR(39) || ' ' || CHAR(39) || ' CLIENT_COLUMN,' FROM DUMMY ) UNION ALL
  ( SELECT 10360, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS, 1, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_1,' FROM DUMMY ) UNION ALL
  ( SELECT 10370, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS, 2, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_2,' FROM DUMMY ) UNION ALL
  ( SELECT 10380, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS, 3, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_3,' FROM DUMMY ) UNION ALL
  ( SELECT 10390, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS, 4, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_4,' FROM DUMMY ) UNION ALL
  ( SELECT 10400, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS, 5, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_5,' FROM DUMMY ) UNION ALL
  ( SELECT 10410, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS, 6, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_6,' FROM DUMMY ) UNION ALL
  ( SELECT 10420, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS, 7, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_7,' FROM DUMMY ) UNION ALL
  ( SELECT 10430, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS, 8, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_8,' FROM DUMMY ) UNION ALL
  ( SELECT 10440, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS, 9, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_9,' FROM DUMMY ) UNION ALL
  ( SELECT 10441, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,10, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_10,' FROM DUMMY ) UNION ALL
  ( SELECT 10442, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,11, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_11,' FROM DUMMY ) UNION ALL
  ( SELECT 10443, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,12, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_12,' FROM DUMMY ) UNION ALL
  ( SELECT 10444, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,13, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_13,' FROM DUMMY ) UNION ALL
  ( SELECT 10445, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,14, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_14,' FROM DUMMY ) UNION ALL
  ( SELECT 10446, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,15, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_15,' FROM DUMMY ) UNION ALL
  ( SELECT 10447, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,16, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_16,' FROM DUMMY ) UNION ALL
  ( SELECT 10448, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,17, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_17,' FROM DUMMY ) UNION ALL
  ( SELECT 10449, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,18, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_18,' FROM DUMMY ) UNION ALL
  ( SELECT 10450, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,19, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_19,' FROM DUMMY ) UNION ALL
  ( SELECT 10451, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,20, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_20,' FROM DUMMY ) UNION ALL
  ( SELECT 10452, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,21, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_21,' FROM DUMMY ) UNION ALL
  ( SELECT 10453, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,22, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_22,' FROM DUMMY ) UNION ALL
  ( SELECT 10454, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,23, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_23,' FROM DUMMY ) UNION ALL
  ( SELECT 10455, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,24, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_24,' FROM DUMMY ) UNION ALL
  ( SELECT 10456, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,25, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_25,' FROM DUMMY ) UNION ALL
  ( SELECT 10457, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,26, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_26,' FROM DUMMY ) UNION ALL
  ( SELECT 10458, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,27, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_27,' FROM DUMMY ) UNION ALL
  ( SELECT 10459, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,28, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_28,' FROM DUMMY ) UNION ALL
  ( SELECT 10460, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,29, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_29,' FROM DUMMY ) UNION ALL
  ( SELECT 10461, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,30, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_30,' FROM DUMMY ) UNION ALL
  ( SELECT 10462, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,31, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_31,' FROM DUMMY ) UNION ALL
  ( SELECT 10463, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,32, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_32' FROM DUMMY ) UNION ALL
  ( SELECT 10496, '    FROM' FROM DUMMY ) UNION ALL
  ( SELECT 10497, '      CLIENT_TABLE_DISTRIBUTION CTD LEFT OUTER JOIN' FROM DUMMY ) UNION ALL
  ( SELECT 10498, '      CLIENT_DISTRIBUTION CD ON' FROM DUMMY ) UNION ALL
  ( SELECT 10499, '        CTD.CLIENT = CD.CLIENT' FROM DUMMY ) UNION ALL
  ( SELECT 10500, '  )' FROM DUMMY ) UNION ALL
  ( SELECT 10510, '  UNION ALL' FROM DUMMY ) UNION ALL
  ( SELECT 10520, '  ( SELECT 400 LINE_NO, ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || 
      ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' FROM DUMMY ) UNION ALL
  ( SELECT 10521, CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) ||
      ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' FROM DUMMY ) UNION ALL
  ( SELECT 10522, CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) ||
      ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' FROM DUMMY ) UNION ALL
  ( SELECT 10523, CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) ||
      ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ', ' || CHAR(39) || ' ' || CHAR(39) || ' FROM DUMMY )' FROM DUMMY ) UNION ALL
  ( SELECT 10530, '  UNION ALL' FROM DUMMY ) UNION ALL
  ( SELECT 10540, '  ( SELECT' FROM DUMMY ) UNION ALL
  ( SELECT 10550, '      500 + ROW_NUMBER () OVER (ORDER BY CTD.BYTES DESC) / 1000 LINE_NO,' FROM DUMMY ) UNION ALL
  ( SELECT 10560, '      CTD.SCHEMA_NAME, CTD.TABLE_NAME, IFNULL(LPAD(TO_DECIMAL(CTD.BYTES / 1024 / 1024 / 1024, 10, 2), 13), '''') TOTAL_SIZE_GB,' FROM DUMMY ) UNION ALL
  ( SELECT 10570, '        CTD.CLIENT_COLUMN_NAME CLIENT_COLUMN,' FROM DUMMY ) UNION ALL
  ( SELECT 10580, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS, 1, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_1,' FROM DUMMY ) UNION ALL
  ( SELECT 10590, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS, 2, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_2,' FROM DUMMY ) UNION ALL
  ( SELECT 10600, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS, 3, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_3,' FROM DUMMY ) UNION ALL
  ( SELECT 10610, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS, 4, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_4,' FROM DUMMY ) UNION ALL
  ( SELECT 10620, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS, 5, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_5,' FROM DUMMY ) UNION ALL
  ( SELECT 10630, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS, 6, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_6,' FROM DUMMY ) UNION ALL
  ( SELECT 10640, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS, 7, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_7,' FROM DUMMY ) UNION ALL
  ( SELECT 10650, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS, 8, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_8,' FROM DUMMY ) UNION ALL
  ( SELECT 10651, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS, 9, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_9,' FROM DUMMY ) UNION ALL
  ( SELECT 10652, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,10, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_10,' FROM DUMMY ) UNION ALL
  ( SELECT 10653, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,11, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_11,' FROM DUMMY ) UNION ALL
  ( SELECT 10654, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,12, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_12,' FROM DUMMY ) UNION ALL
  ( SELECT 10655, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,13, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_13,' FROM DUMMY ) UNION ALL
  ( SELECT 10656, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,14, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_14,' FROM DUMMY ) UNION ALL
  ( SELECT 10657, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,15, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_15,' FROM DUMMY ) UNION ALL
  ( SELECT 10658, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,16, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_16,' FROM DUMMY ) UNION ALL
  ( SELECT 10659, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,17, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_17,' FROM DUMMY ) UNION ALL
  ( SELECT 10660, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,18, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_18,' FROM DUMMY ) UNION ALL
  ( SELECT 10661, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,19, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_19,' FROM DUMMY ) UNION ALL
  ( SELECT 10662, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,20, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_20,' FROM DUMMY ) UNION ALL
  ( SELECT 10663, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,21, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_21,' FROM DUMMY ) UNION ALL
  ( SELECT 10664, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,22, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_22,' FROM DUMMY ) UNION ALL
  ( SELECT 10665, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,23, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_23,' FROM DUMMY ) UNION ALL
  ( SELECT 10666, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,24, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_24,' FROM DUMMY ) UNION ALL
  ( SELECT 10667, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,25, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_25,' FROM DUMMY ) UNION ALL
  ( SELECT 10668, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,26, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_26,' FROM DUMMY ) UNION ALL
  ( SELECT 10669, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,27, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_27,' FROM DUMMY ) UNION ALL
  ( SELECT 10670, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,28, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_28,' FROM DUMMY ) UNION ALL
  ( SELECT 10671, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,29, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_29,' FROM DUMMY ) UNION ALL
  ( SELECT 10672, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,30, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_30,' FROM DUMMY ) UNION ALL
  ( SELECT 10673, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,31, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_31,' FROM DUMMY ) UNION ALL
  ( SELECT 10674, '      IFNULL(LPAD(TO_DECIMAL(SUM(MAP(CD.CLIENT_POS,32, CTD.CLIENT_BYTES / 1024 / 1024 / 1024)), 10, 2), 9), '''') SIZE_GB_32' FROM DUMMY ) UNION ALL
  ( SELECT 10698, '    FROM' FROM DUMMY ) UNION ALL
  ( SELECT 10699, '      CLIENT_TABLE_DISTRIBUTION CTD LEFT OUTER JOIN' FROM DUMMY ) UNION ALL
  ( SELECT 10700, '      CLIENT_DISTRIBUTION CD ON' FROM DUMMY ) UNION ALL
  ( SELECT 10710, '        CTD.CLIENT = CD.CLIENT' FROM DUMMY ) UNION ALL
  ( SELECT 10720, '    GROUP BY' FROM DUMMY ) UNION ALL
  ( SELECT 10730, '      CTD.SCHEMA_NAME,' FROM DUMMY ) UNION ALL
  ( SELECT 10740, '      CTD.TABLE_NAME,' FROM DUMMY ) UNION ALL
  ( SELECT 10750, '      CTD.BYTES,' FROM DUMMY ) UNION ALL
  ( SELECT 10760, '      CTD.CLIENT_COLUMN_NAME' FROM DUMMY ) UNION ALL
  ( SELECT 10790, '  )' FROM DUMMY ) UNION ALL
  ( SELECT 18000, ')' FROM DUMMY ) UNION ALL
  ( SELECT 18010, '  ORDER BY' FROM DUMMY ) UNION ALL
  ( SELECT 18020, '    LINE_NO' FROM DUMMY )
)
ORDER BY
  LINE_NO
