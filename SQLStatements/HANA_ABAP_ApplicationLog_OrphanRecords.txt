SELECT

/* 

[NAME]

- HANA_ABAP_ApplicationLog_OrphanRecords

[DESCRIPTION]

- Overview of orphan rows in application log table BALDAT without a reference in header table BALHDR

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Tables BALDAT and BALHDR only available in SAP ABAP environments
- You have to be connected to the SAP<sid> schema otherwise the following error is issued:

  [259]: invalid table name: Could not find table/view BALDAT in schema

- If access to ABAP objects is possible but you cannot log on as ABAP user, you can switch the default schema before executing the command:

  SET SCHEMA SAP<sid>

[VALID FOR]

- Revisions:              all
- Client application:     ABAP

[SQL COMMAND VERSION]

- 2019/03/20:  1.0 (initial version)

[INVOLVED TABLES]

- BALDAT
- BALHDR

[INPUT PARAMETERS]

- MANDT

  ABAP client

  '100'           --> ABAP client 100
  '%'             --> No restriction to ABAP client

- RELID

  Application log RELID

  'AL'            --> Display orphan records for RELID AL
  '%'             --> No restriction related to RELID
  
[OUTPUT PARAMETERS]

- MANDT:          ABAP client
- RELID:          RELID
- ORPHAN_RECORDS: Number of orphan records

[EXAMPLE OUTPUT]

----------------------------
|MANDT|RELID|ORPHAN_RECORDS|
----------------------------
|500  |AL   |        260443|
----------------------------

*/

  D.MANDANT MANDT,
  D.RELID,
  LPAD(COUNT(*), 14) ORPHAN_RECORDS
FROM
( SELECT                    /* Modification section */
    '%' MANDT,
    '%' RELID
  FROM
    DUMMY
) BI,
  BALDAT D
WHERE
  D.MANDANT LIKE BI.MANDT AND
  D.RELID LIKE BI.RELID AND
  D.LOG_HANDLE NOT IN ( SELECT LOG_HANDLE FROM BALHDR )
GROUP BY
  D.MANDANT,
  D.RELID
ORDER BY
  COUNT(*) DESC
