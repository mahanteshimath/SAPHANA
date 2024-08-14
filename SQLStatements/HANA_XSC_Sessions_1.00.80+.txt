SELECT

/* 

[NAME]

- HANA_XSC_Sessions_1.00.80+

[DESCRIPTION]

- Overview of current XS classic (XSC) sessions

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_XS_SESSIONS available with SAP HANA >= 1.0 SPS 08

[VALID FOR]

- Revisions:              >= 1.00.80

[SQL COMMAND VERSION]

- 2020/08/18:  1.0 (initial version)

[INVOLVED TABLES]

- M_XS_SESSIONS

[INPUT PARAMETERS]

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

- XS_SESS_ID

  XSC session ID

  1234            --> XSC session ID 1234
  -1              --> No restriction related to XSC session ID

- DB_USER

  XSC database user

  'BMRFC'         --> XSC database user BMRFC
  '%'             --> No restriction related to XSC database user

- AUTH_METHOD

  XSC authentication method

  'SAML'          --> Authentication method SAML
  '%'             --> No restriction related to authentication method

- ORDER_BY

  Sort criteria (available values are provided in comment)

  'USER'          --> Sorting by XSC database user
  'SESSION'       --> Sorting by XSC session ID

[OUTPUT PARAMETERS]

- HOST:              Host name
- PORT:              Port
- XS_SESS_ID:        XSC session ID
- DB_USER:           XSC database user
- AUTH_METHOD:       Authentication method
- START_TIME:        XSC session start time
- LAST_REQUEST_TIME: Time of last request

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|CAPTURE_START_TIME |CAPTURE_END_TIME   |CAPTURE_ID       |CAPTURE_NAME               |CAPTURE_DESCRIPTION        |CAP_STATUS|REPLAY_START_TIME  |REPLAY_END_TIME    |REPLAY_ID    |REPLAY_NAME       |REPLAY_DESCRIPTION|REP_STATUS|
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2018/09/27 11:41:59|2018/09/27 11:50:10|47368420429808057|JuliaAAmt                  |                           |CAPTURED  |                   |                   |             |                  |                  |          |
|2018/08/18 16:37:17|2018/08/18 16:37:53|28866009194031706|TEST_1MINI2                |                           |CAPTURED  |2018/07/03 15:18:51|2018/07/03 15:19:49|1530623919931|TEST_1MINI2       |                  |REPLAYED  |
|2018/05/16 15:54:17|2018/05/16 15:55:21|18532413829566692|MAY_version                |DEMO                       |CAPTURED  |2018/05/16 16:06:30|2018/05/16 16:07:34|1526479583865|MAY_version       |DEMO              |REPLAYED  |
|2018/04/26 11:46:30|2018/04/26 11:49:19|14185784249874959|WATCH_Oyster               |                           |CAPTURED  |2018/04/26 12:08:57|2018/04/26 12:11:35|1524737325621|WATCH_Oyster_REPL1|                  |REPLAYED  |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  XS.HOST,
  LPAD(XS.PORT, 5) PORT,
  LPAD(XS_SESSION_ID, 10) XS_SESS_ID,
  XS.USER_NAME DB_USER,
  XS.AUTHENTICATION_METHOD AUTH_METHOD,
  TO_VARCHAR(XS.START_TIME, 'YYYY/MM/DD HH24:MI:SS') START_TIME,
  TO_VARCHAR(XS.LAST_REQUEST_TIME, 'YYYY/MM/DD HH24:MI:SS') LAST_REQUEST_TIME
FROM
( SELECT                    /* Modification section */
    '%' HOST,
    '%' PORT,
    -1  XS_SESS_ID,
    '%' DB_USER,
    '%' AUTH_METHOD,
    'START_TIME' ORDER_BY                 /* START_TIME, LAST_REQUEST_TIME, USER, SESSION */
  FROM
    DUMMY
) BI,
  M_XS_SESSIONS XS
WHERE
  XS.HOST LIKE BI.HOST AND
  TO_VARCHAR(XS.PORT) LIKE BI.PORT AND
  ( BI.XS_SESS_ID = -1 OR XS.XS_SESSION_ID = BI.XS_SESS_ID ) AND
  XS.USER_NAME LIKE BI.DB_USER AND
  XS.AUTHENTICATION_METHOD LIKE BI.AUTH_METHOD
ORDER BY
  MAP(BI.ORDER_BY, 'START_TIME', XS.START_TIME, 'LAST_REQUEST_TIME', XS.LAST_REQUEST_TIME) DESC,
  MAP(BI.ORDER_BY, 'USER', XS.USER_NAME),
  XS.HOST,
  XS.PORT,
  XS.XS_SESSION_ID