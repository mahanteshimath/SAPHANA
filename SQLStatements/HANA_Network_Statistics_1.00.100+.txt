SELECT
/* 

[NAME]

- HANA_Network_Statistics_1.00.100+

[DESCRIPTION]

- SAP HANA host network statistics

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- TCP related figures similar to OS tool netstat
- Not available in MDC tenants, only in single node databases and system DB of MDC systems

[VALID FOR]

- Revisions:              >= 1.00.100

[SQL COMMAND VERSION]

- 2015/12/20:  1.0 (initial version)

[INVOLVED TABLES]

- M_HOST_NETWORK_STATISTICS

[INPUT PARAMETERS]

- HOST

  Host name

  'saphana01'     --> Specic host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

[OUTPUT PARAMETERS]

- HOST:         Host name
- SEG_RECEIVED: Number of TCP segments received ('Tcp: InSegs' from /proc/net/snmp)
- BAD_SEG_RCV:  Number of bad TCP segments received ('Tcp: InErrs' from /proc/net/snmp)
- BAD_SEG_PCT:  Percentage of bad segments received compared to overall segments received
- SEG_SENT:     Number of TCP segments sent ('Tcp: OutSegs' from /proc/net/snmp)
- SEG_RETRANS:  Number of TCP segment retransmissions ('Tcp: RetransSegs' from /proc/net/snmp)
- RETRANS_PCT:  Percentage of retransmitted segments compared to overall sent segments

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------
|HOST   |SEG_RECEIVED |BAD_SEG_RCV|BAD_SEG_PCT|SEG_SENT     |SEG_RETRANS|RETRANS_PCT|
-------------------------------------------------------------------------------------
|saphana|    163965201|        282|    0.00017|    340922924|      19520|    0.00572|
-------------------------------------------------------------------------------------

*/

  N.HOST,
  LPAD(N.TCP_SEGMENTS_RECEIVED, 13) SEG_RECEIVED,
  LPAD(N.TCP_BAD_SEGMENTS_RECEIVED, 11) BAD_SEG_RCV,
  LPAD(TO_DECIMAL(MAP(N.TCP_SEGMENTS_RECEIVED, 0, 0, N.TCP_BAD_SEGMENTS_RECEIVED * 100 / N.TCP_SEGMENTS_RECEIVED), 9, 5), 11) BAD_SEG_PCT,
  LPAD(N.TCP_SEGMENTS_SENT_OUT, 13) SEG_SENT,
  LPAD(N.TCP_SEGMENTS_RETRANSMITTED, 11) SEG_RETRANS,
  LPAD(TO_DECIMAL(MAP(N.TCP_SEGMENTS_SENT_OUT, 0, 0, N.TCP_SEGMENTS_RETRANSMITTED * 100 / N.TCP_SEGMENTS_SENT_OUT), 9, 5), 11) RETRANS_PCT
FROM
( SELECT                     /* Modification section */
    '%' HOST
  FROM
    DUMMY
) BI,
  M_HOST_NETWORK_STATISTICS N
WHERE
  N.HOST LIKE BI.HOST
ORDER BY
  N.HOST