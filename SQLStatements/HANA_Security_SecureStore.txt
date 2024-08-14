SELECT
/* 

[NAME]

- HANA_Security_SecureStore

[DESCRIPTION]

- SAP HANA secure store overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2018/11/12:  1.0 (initial version)

[INVOLVED TABLES]

- M_SECURESTORE

[INPUT PARAMETERS]

- KEY_TYPE

  Secure store type

  'PERSISTENCE' --> Display secure store information related to PERSISTENCE

- IS_CONSISTENT

  Consistency of secure store

  'FALSE'       --> Only display inconsistent secure stores
  '%'           --> No restriction related to secure store consistency

- IS_CURRENT

  Information if secure store is current or not

  'TRUE'        --> Only display current secure stores
  '%'           --> Display current and non-current secure stores
  
[OUTPUT PARAMETERS]

- KEY_TYPE:      Secure store key type
- IS_CONSISTENT: Consistency of secure store (TRUE -> consistent, FALSE -> not consistent)
- RESET_COUNT:   Number of secure store resets
- VERSION:       Secure store version
- IS_CURRENT:    Information if secure store is current (TRUE) or not (FALSE)

[EXAMPLE OUTPUT]

----------------------------------------------------------
|KEY_TYPE   |IS_CONSISTENT|RESET_COUNT|VERSION|IS_CURRENT|
----------------------------------------------------------
|DPAPI      |TRUE         |          0|      0|TRUE      |
|PERSISTENCE|TRUE         |          0|      0|TRUE      |
----------------------------------------------------------

*/

  S.KEY_TYPE,
  S.IS_CONSISTENT,
  LPAD(S.RESET_COUNT, 11) RESET_COUNT,
  LPAD(S.VERSION, 7) VERSION,
  S.IS_CURRENT
FROM
( SELECT                       /* Modification section */
    '%' KEY_TYPE,
    '%' IS_CONSISTENT,
    '%' IS_CURRENT
  FROM
    DUMMY
) BI,
  M_SECURESTORE S
WHERE
  S.KEY_TYPE LIKE BI.KEY_TYPE AND
  S.IS_CONSISTENT LIKE BI.IS_CONSISTENT AND
  S.IS_CURRENT LIKE BI.IS_CURRENT
ORDER BY
  KEY_TYPE