SELECT
/* 

[NAME]

- HANA_ErrorCodes

[DESCRIPTION]

- Error code details

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/03/06:  1.0 (initial version)

[INVOLVED TABLES]

- M_ERROR_CODES

[INPUT PARAMETERS]

- ERROR_CODE

  Error code

  257            --> Error code 257
  -1             --> No restriction in terms of error code

- ERROR_DESCRIPTION

  Error description

  '%log%'        --> Errors with a description containing 'log'
  '%'            --> No filtering by error description
  
[OUTPUT PARAMETERS]

- ERROR_CODE:  Error code
- DESCRIPTION: Error description
- CODE_STRING: Error code string

[EXAMPLE OUTPUT]

-------------------------------------------
|ERROR_CODE|DESCRIPTION     |CODE_STRING  |
-------------------------------------------
|      257 |sql syntax error|ERR_SQL_PARSE|
-------------------------------------------

*/

  EC.CODE ERROR_CODE,
  EC.DESCRIPTION,
  EC.CODE_STRING
FROM
  ( SELECT                      /* Modification section */
      257 ERROR_CODE,                                      
      '%' ERROR_DESCRIPTION
    FROM
      DUMMY
  ) BI,
  M_ERROR_CODES EC
WHERE
  ( BI.ERROR_CODE = -1 OR BI.ERROR_CODE = EC.CODE ) AND
  UPPER(EC.DESCRIPTION) LIKE UPPER(BI.ERROR_DESCRIPTION)
