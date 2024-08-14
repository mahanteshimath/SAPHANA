SELECT

/* 

[NAME]

- HANA_SQL_PlanStability_AbstractSQLPlans_2.00.040+

[DESCRIPTION]

- Overview of abstract SQL plans captured via plan stability feature

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- ABSTRACT_SQL_PLANS available starting with 1.00.122.17
- ABSTRACT_SQL_PLANS may not exist for early SAP HANA 2.0 Revisions
- ABSTRACT_SQL_PLANS.STATEMENT_HASH available with SAP HANA 2.00.040

[VALID FOR]

- Revisions:              >= 2.00.040

[SQL COMMAND VERSION]

- 2019/07/09:  1.0 (initial version)

[INVOLVED TABLES]

- ABSTRACT_SQL_PLANS

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

- STATEMENT_HASH      
 
  Hash of SQL statement to be analyzed

  '2e960d7535bf4134e2bd26b9d80bd4fa' --> SQL statement with hash '2e960d7535bf4134e2bd26b9d80bd4fa'
  '%'                                --> No statement hash restriction (only possible if hash is not mandatory)

- STATEMENT_STRING

  Statement string

  'INSERT%'       --> SQL statements starting with INSERT
  '%DBTABLOG%'    --> SQL statements containing DBTABLOG
  '%'             --> All SQL statements

[OUTPUT PARAMETERS]

- HOST:             Host
- PORT:             Port
- SCHEMA_NAME:      Schema name
- STATEMENT_HASH:   Statement hash
- ENABLED:          TRUE if plan is enabled, otherwise FALSE
- CAPTURE_TIME:     Plan capture time
- STATEMENT_STRING: Statement string

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------------
|HOST    |PORT |SCHEMA_NAME|STATEMENT_HASH                  |ENABLED|CAPTURE_TIME       |STATEMENT_STRING                           |
-------------------------------------------------------------------------------------------------------------------------------------
|saphana1|30003|SAPC11     |1ba6b401ec2b68eefef7f75a15f98cf3|FALSE  |2019/01/17 12:29:42|SELECT TOP 1 * FROM "EKPO" WHERE "MANDT" = |
|saphana1|30003|SAPC11     |2b1037cc27ce85032163a57232e88bff|FALSE  |2019/01/17 12:16:55|SELECT // FDA READ // * FROM "BSEG_ADD" WHE|
|saphana1|30003|SAPC11     |7f37c1fa4037f29c584e14b8f90d9b58|TRUE   |2019/01/17 12:15:03|SELECT // FDA READ // "BUKRS" , "BELNR" , "|
|saphana1|30003|SAPC11     |86605c5fe981e2fa3b8e1e74334392ec|FALSE  |2019/01/17 12:11:58|SELECT "H" . "MANDT" , "H" . "BUKRS" , "H" |
|saphana1|30003|SAPC11     |4b151c1480380b50456cb05d49c51adb|FALSE  |2019/01/17 12:11:02|SELECT // FDA READ // "EBELN" , "EBELP" , "|
|saphana1|30003|SAPC11     |0fe7fd9517dc7436a6af35cda8fbba92|FALSE  |2019/01/17 12:09:34|SELECT // FDA READ // "EBELN" , "EBELP" , "|
|saphana1|30003|SAPC11     |88cab1738a0b6fecc2f6789502d5ec23|TRUE   |2019/01/17 12:04:19|SELECT // FDA READ // * FROM "BSEGC" WHERE |
|saphana1|30003|SAPC11     |2ad857bea3daf775a95264fe36ba1c80|FALSE  |2019/01/17 12:01:15|SELECT TOP 1 "MANDT" , "EBELN" , "EBELP" , |
|saphana1|30003|SAPC11     |221893e20c5d4d981247ff4720f6432e|FALSE  |2019/01/17 11:56:00|SELECT // FDA READ // "EBELP" , "PSTYP" FRO|
|saphana1|30003|SAPC11     |4ae1c1d954a280f34dec76ae69cf39c2|FALSE  |2019/01/17 11:54:00|SELECT DISTINCT  "A" . "EBELN" , "B" . "EBE|
-------------------------------------------------------------------------------------------------------------------------------------

*/

  AP.HOST,
  LPAD(AP.PORT, 5) PORT,
  JSON_VALUE(AP.PLAN_KEY, '$.schema') SCHEMA_NAME,
  AP.STATEMENT_HASH,
  AP.IS_ENABLED ENABLED,
  TO_VARCHAR(CAPTURE_TIME, 'YYYY/MM/DD HH24:MI:SS') CAPTURE_TIME,
  TO_VARCHAR(AP.STATEMENT_STRING) STATEMENT_STRING
FROM
( SELECT                     /* Modification section */
    '%' HOST,
    '%' PORT,
    '%' SCHEMA_NAME,
    '%' STATEMENT_HASH,
    '%' STATEMENT_STRING
  FROM
    DUMMY
) BI,
  ABSTRACT_SQL_PLANS AP
WHERE
  AP.HOST LIKE BI.HOST AND
  TO_VARCHAR(AP.PORT) LIKE BI.PORT AND
  AP.STATEMENT_HASH LIKE BI.STATEMENT_HASH AND
  TO_VARCHAR(AP.STATEMENT_STRING) LIKE BI.STATEMENT_STRING AND
  JSON_VALUE(AP.PLAN_KEY, '$.schema') LIKE BI.SCHEMA_NAME
ORDER BY
  AP.CAPTURE_TIME DESC
