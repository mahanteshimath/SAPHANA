SELECT

/* 

[NAME]

- HANA_ABAP_CorrespondenceLanguages

[DESCRIPTION]

- Overview of defined ABAP correspondence languages

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Table T002C only available in SAP ABAP environments
- You have to be connected to the SAP<sid> schema otherwise the following error is issued:

  [259]: invalid table name: Could not find table/view T002C in schema

- If access to ABAP objects is possible but you cannot log on as ABAP user, you can switch the default schema before executing the command:

  SET SCHEMA SAP<sid>

- See SAP Note 302063 for more details about correspondence languages

[VALID FOR]

- Revisions:              all
- Client application:     ABAP

[SQL COMMAND VERSION]

- 2019/07/15:  1.0 (initial version)

[INVOLVED TABLES]

- T002C

[INPUT PARAMETERS]

- LANGUAGE_KEY

  Language key

  '&'             --> Language key &
  '%'             --> No restriction to language key

[OUTPUT PARAMETERS]

- LANGUAGE_KEY:      Language key of correspondence language
- FALLBACK_LANGUAGE: Fallback language
- CHANGED_BY:        Changing user
- CHANGE_TIME:       Change timestamp

[EXAMPLE OUTPUT]

---------------------------------------------------------------
|LANGUAGE_KEY|FALLBACK_LANGUAGE|CHANGED_BY|CHANGE_TIME        |
---------------------------------------------------------------
|&           |P                |MEYER     |2019/11/13 15:51:27|
---------------------------------------------------------------

*/

  C.SPRAS LANGUAGE_KEY,
  ( SELECT MAX(SPTXT) FROM T002T T WHERE T.SPRSL = C.SPRAS ) CR_LANG_NAME,
  C.LAKETT FALLBACK_LANGUAGE,
  ( SELECT MAX(SPTXT) FROM T002T T WHERE T.SPRAS = '2' AND T.SPRSL = C.LAKETT ) FB_LANG_NAME,
  C.LAUSER CHANGED_BY,
  TO_VARCHAR(TO_TIMESTAMP(C.LADATUM || C.LAUZEIT, 'YYYYMMDDHH24MISS'), 'YYYY/MM/DD HH24:MI:SS') CHANGE_TIME
FROM
( SELECT                     /* Modification section */
    '%' LANGUAGE_KEY
  FROM
    DUMMY
) BI,
  T002C C
WHERE
  C.SPRAS IN ( '(', ')', ',', '.', CHAR(32), '/', ':', CHAR(59), '&' ) AND
  C.SPRAS LIKE BI.LANGUAGE_KEY
ORDER BY
  C.SPRAS