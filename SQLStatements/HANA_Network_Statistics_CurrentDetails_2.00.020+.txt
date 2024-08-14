SELECT
/* 

[NAME]

- HANA_Network_Statistics_CurrentDetails_2.00.020+

[DESCRIPTION]

- Current SAP HANA host network statistics

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_HOST_AGENT_METRICS available with SAP HANA >= 2.00.020
- M_HOST_AGENT_METRICS data may not be available for slave nodes with SAP HANA <= 2.00.035
- Fails in SAP HANA Cloud (SHC) environments because host agent is no longer supported:

  invalid table name:  Could not find table/view M_HOST_AGENT_METRICS 

[VALID FOR]

- Revisions:              >= 2.00.020

[SQL COMMAND VERSION]

- 2019/03/17:  1.0 (initial version)

[INVOLVED TABLES]

- M_HOST_AGENT_METRICS

[INPUT PARAMETERS]

- HOST

  Host name

  'saphana01'     --> Specic host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- MIN_SEND_MB_PER_S

  Minimum threshold for send throughput (MB/s)

  5               --> Only display lines with at least 5 MB network send throughput
  -1              --> No restriction related to network send throughput

- MIN_RECV_MB_PER_S

  Minimum threshold for receive throughput (MB/s)

  5               --> Only display lines with at least 5 MB network receive throughput
  -1              --> No restriction related to network receive throughput

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'COLLISIONS'    --> Order by collision count
  'SEND_SIZE'     --> Order by send size

[OUTPUT PARAMETERS]

- TIMESTAMP:      Timestamp
- HOST:           Host
- INTERFACE:      Interface name
- COLL_PER_S:     Collisions per second
- SEND_ERR_PER_S: Send errors per second
- RCV_ERR_PER_S:  Receive errors per second
- SEND_MB_PER_S:  Sent data volume (MB/s)
- RCV_MB_PER_S:   Received data volume (MB/s)
- SEND_REQ_PER_S: Sent data (requests/s)
- RCV_REQ_PER_S:  Received data (requests/s)
- AVG_SEND_KB:    Average send size (KB)
- AVG_RCV_KB:     Average receive size (KB)

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------------------------------------------
|TIMESTAMP          |HOST    |INTERFACE|COLL_PER_S|SEND_ERR_PER_S|RCV_ERR_PER_S|SEND_MB_PER_S|RCV_MB_PER_S|SEND_REQ_PER_S|RCV_REQ_PER_S|AVG_SEND_KB |AVG_RCV_KB|
----------------------------------------------------------------------------------------------------------------------------------------------------------------
|2019/03/17 15:02:19|saphana6|bond1    |      0.00|          0.00|         0.00|       107.51|       24.25|      30662.45|     24307.46|        3.59|      1.02|
|2019/03/17 15:02:19|saphana6|hana.c11 |      0.00|          0.00|         0.00|       106.85|       23.69|      22034.45|     23998.95|        4.96|      1.01|
|2019/03/17 15:01:55|saphana4|bond1    |      0.00|          0.00|         0.00|        47.08|       15.76|      26421.29|     24387.54|        1.82|      0.66|
|2019/03/17 15:01:55|saphana4|hana.c11 |      0.00|          0.00|         0.00|        46.60|       15.26|      23250.01|     24128.83|        2.05|      0.64|
|2019/03/17 15:02:19|saphana6|p42818p1 |      0.00|          0.00|         0.00|        26.14|        1.81|       9738.10|      2564.39|        2.74|      0.72|
|2019/03/17 15:02:19|saphana6|p42567p2 |      0.00|          0.00|         0.00|        20.72|        2.71|       5658.56|      1835.53|        3.75|      1.51|
|2019/03/17 15:02:19|saphana6|p42565p2 |      0.00|          0.00|         0.00|        16.16|        1.67|       3749.29|      1411.47|        4.41|      1.21|
|2019/03/17 15:02:19|saphana6|p42562p2 |      0.00|          0.00|         0.00|        12.32|        1.24|       2959.76|       859.22|        4.26|      1.47|
|2019/03/17 15:02:19|saphana6|p42566p2 |      0.00|          0.00|         0.00|        12.08|        1.29|       2745.20|       965.25|        4.50|      1.37|
----------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  TO_VARCHAR(N.TIMESTAMP, 'YYYY/MM/DD HH24:MI:SS') TIMESTAMP,
  N.HOST,
  N.INTERFACE,
  LPAD(TO_DECIMAL(N.COLL_PER_S, 10, 2), 10) COLL_PER_S,
  LPAD(TO_DECIMAL(N.TRANS_ERR_PER_S, 10, 2), 14) SEND_ERR_PER_S,
  LPAD(TO_DECIMAL(N.RECV_ERR_PER_S, 10, 2), 13) RCV_ERR_PER_S,
  LPAD(TO_DECIMAL(N.TRANS_KB_PER_S / 1024, 10, 2), 13) SEND_MB_PER_S,
  LPAD(TO_DECIMAL(N.RECV_KB_PER_S / 1024, 10, 2), 12) RCV_MB_PER_S,
  LPAD(TO_DECIMAL(N.TRANS_PACK_PER_S, 10, 2), 14) SEND_REQ_PER_S,
  LPAD(TO_DECIMAL(N.RECV_PACK_PER_S, 10, 2), 13) RCV_REQ_PER_S,
  LPAD(TO_DECIMAL(N.AVG_TRANS_KB, 10, 2), 12) AVG_SEND_KB,
  LPAD(TO_DECIMAL(N.AVG_RECV_KB, 10, 2), 10) AVG_RCV_KB
FROM
( SELECT                     /* Modification section */
    '%' HOST,
    1 MIN_SEND_MB_PER_S,
    -1 MIN_RCV_MB_PER_S,
    'SEND_SIZE' ORDER_BY               /* COLLISIONS, ERRORS, RECEIVE_SIZE, SEND_SIZE, RECEIVE_REQUESTS, SEND_REQUESTS */
  FROM
    DUMMY
) BI,
( SELECT
    TIMESTAMP,
    HOST,
    INTERFACE,
    COLL_PER_S,
    RECV_KB_PER_S,
    TRANS_KB_PER_S,
    RECV_PACK_PER_S,
    TRANS_PACK_PER_S,
    RECV_ERR_PER_S,
    TRANS_ERR_PER_S,
    MAP(TRANS_PACK_PER_S, 0, 0, TRANS_KB_PER_S / TRANS_PACK_PER_S) AVG_TRANS_KB,
    MAP(RECV_PACK_PER_S, 0, 0, RECV_KB_PER_S / RECV_PACK_PER_S) AVG_RECV_KB
  FROM
  ( SELECT
      MAX(TIMESTAMP) TIMESTAMP,
      HOST,
      MEASURED_ELEMENT_NAME INTERFACE,
      MAX(MAP(CAPTION, 'Collision Rate', TO_NUMBER(VALUE), 0)) COLL_PER_S,
      MAX(MAP(CAPTION, 'Receive Rate', TO_NUMBER(VALUE), 0)) RECV_KB_PER_S,
      MAX(MAP(CAPTION, 'Transmit Rate', TO_NUMBER(VALUE), 0)) TRANS_KB_PER_S,
      MAX(MAP(CAPTION, 'Packet Receive Rate', TO_NUMBER(VALUE), 0)) RECV_PACK_PER_S,
      MAX(MAP(CAPTION, 'Packet Transmit Rate', TO_NUMBER(VALUE), 0)) TRANS_PACK_PER_S,
      MAX(MAP(CAPTION, 'Receive Error Rate', TO_NUMBER(VALUE), 0)) RECV_ERR_PER_S,
      MAX(MAP(CAPTION, 'Transmit Error Rate', TO_NUMBER(VALUE), 0)) TRANS_ERR_PER_S
    FROM
      M_HOST_AGENT_METRICS
    WHERE
      MEASURED_ELEMENT_TYPE = 'NetworkPort'
    GROUP BY
      HOST,
      MEASURED_ELEMENT_NAME
  )
) N
WHERE
  N.HOST LIKE BI.HOST AND
  ( BI.MIN_SEND_MB_PER_S = -1 OR N.TRANS_KB_PER_S / 1024 >= BI.MIN_SEND_MB_PER_S ) AND
  ( BI.MIN_RCV_MB_PER_S = -1 OR N.RECV_KB_PER_S / 1024 >= BI.MIN_RCV_MB_PER_S )
ORDER BY
  MAP(BI.ORDER_BY, 'COLLISIONS', N.COLL_PER_S, 'ERRORS', N.RECV_ERR_PER_S + N.TRANS_ERR_PER_S, 'RECEIVE_SIZE', N.RECV_KB_PER_S,
    'SEND_SIZE', N.TRANS_KB_PER_S, 'RECEIVE_REQUESTS', N.RECV_PACK_PER_S, 'SEND_REQUESTS', N.TRANS_PACK_PER_S) DESC,
  N.HOST