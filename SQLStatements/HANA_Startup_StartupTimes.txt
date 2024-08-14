SELECT
/* 

[NAME]

- HANA_Startup_StartupTimes

[DESCRIPTION]

- Startup times of SAP HANA hosts and services 

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/10/21:  1.0 (initial version)
- 2017/10/26:  1.1 (TIMEZONE included)

[INVOLVED TABLES]

- M_HOST_INFORMATION
- M_SERVICE_STATISTICS

[INPUT PARAMETERS]

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

- SERVICE_NAME

  Service name

  'indexserver'   --> Specific service indexserver
  '%server'       --> All services ending with 'server'
  '%'             --> All services  

- LEVEL

  Level of information (host, port)

  'HOST'          --> Show startup information on host level
  'PORT'          --> Show startup information on port / service level
  '%'             --> Show startup information on both host and port level

[OUTPUT PARAMETERS]

- HOST:                 Host name
- HOST_STARTUP_TIME:    Timestamp of host startup
- HOST_STARTUP_DELAY_S: Delay compared to first host startup (s)
- PORT:                 Port
- PORT_STARTUP_TIME:    Timestamp of service startup
- PORT_STARTUP_DELAY_S: Delay compared to first service startup on same host (s)

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------------
|HOST    |HOST_STARTUP_TIME  |HOST_STARTUP_DELAY_S|PORT |PORT_STARTUP_TIME  |PORT_STARTUP_DELAY_S|
--------------------------------------------------------------------------------------------------
|saphana7|2014/10/16 13:32:30|              391099|     |                   |                    |
|        |                   |                    |30600|2014/10/16 13:32:23|                   0|
|        |                   |                    |30601|2014/10/16 13:32:30|                   7|
|        |                   |                    |30602|2014/10/16 13:32:37|                  14|
|        |                   |                    |30603|2014/10/16 13:32:40|                  17|
|        |                   |                    |30610|2014/10/16 13:32:36|                  13|
|saphana8|2014/10/12 00:54:10|                   0|     |                   |                    |
|        |                   |                    |30600|2014/10/12 00:53:49|                   0|
|        |                   |                    |30601|2014/10/12 00:54:10|                  21|
|        |                   |                    |30602|2014/10/12 00:54:30|                  41|
|        |                   |                    |30603|2014/10/12 00:54:32|                  43|
|        |                   |                    |30610|2014/10/12 00:54:29|                  40|
|saphana9|2014/10/12 00:54:10|                   0|     |                   |                    |
|        |                   |                    |30600|2014/10/12 00:53:49|                   0|
|        |                   |                    |30601|2014/10/12 00:54:10|                  21|
|        |                   |                    |30602|2014/10/12 00:54:35|                  46|
|        |                   |                    |30603|2014/10/12 00:54:37|                  48|
|        |                   |                    |30607|2014/10/12 00:54:37|                  48|
|        |                   |                    |30610|2014/10/12 00:54:34|                  45|
--------------------------------------------------------------------------------------------------

*/

  CASE WHEN PORT = '' OR BI_LEVEL = 'PORT' THEN HOST ELSE '' END HOST,
  CASE WHEN LEVEL = 'HOST' THEN STARTUP_TIME              ELSE '' END HOST_STARTUP_TIME,
  CASE WHEN LEVEL = 'HOST' THEN LPAD(STARTUP_DELAY_S, 20) ELSE '' END HOST_STARTUP_DELAY_S,
  PORT,
  SERVICE_NAME,
  CASE WHEN LEVEL = 'PORT' THEN STARTUP_TIME              ELSE '' END PORT_STARTUP_TIME,
  CASE WHEN LEVEL = 'PORT' THEN LPAD(STARTUP_DELAY_S, 20) ELSE '' END PORT_STARTUP_DELAY_S
FROM
( SELECT
    D.LEVEL,
    D.HOST,
    D.PORT,
    D.SERVICE_NAME,
    TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(D.STARTUP_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE D.STARTUP_TIME END, 'YYYY/MM/DD HH24:MI:SS') STARTUP_TIME,
    LPAD(D.STARTUP_DELAY_S, 15) STARTUP_DELAY_S,
    BI.LEVEL BI_LEVEL
  FROM
  ( SELECT            /* Modification section */
      'SERVER' TIMEZONE,                              /* SERVER, UTC */
      '%' HOST,
      '%' PORT,
      '%' SERVICE_NAME,
      '%' LEVEL        /* HOST, PORT */
    FROM
      DUMMY
  ) BI,
  ( SELECT
      'HOST' LEVEL,
      HOST,
      '' PORT,
      '' SERVICE_NAME,
      VALUE STARTUP_TIME,
      SECONDS_BETWEEN(MIN(VALUE) OVER (), VALUE) STARTUP_DELAY_S
    FROM
      M_HOST_INFORMATION
    WHERE
      KEY = 'start_time'
    UNION ALL
    ( SELECT
        'PORT' LEVEL,
        HOST,
        TO_VARCHAR(PORT) PORT,
        SERVICE_NAME,
        START_TIME STARTUP_TIME,
        SECONDS_BETWEEN(MIN(START_TIME) OVER (PARTITION BY HOST), START_TIME) STARTUP_DELAY_S
      FROM
        M_SERVICE_STATISTICS
    )
  ) D
  WHERE
    D.HOST LIKE BI.HOST AND
    D.PORT LIKE BI.PORT AND
    D.SERVICE_NAME LIKE BI.SERVICE_NAME AND
    D.LEVEL LIKE BI.LEVEL
) S
ORDER BY
  S.HOST,
  S.PORT