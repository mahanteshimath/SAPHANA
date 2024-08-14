SELECT
/* 

[NAME]

- HANA_Views_Definition

[DESCRIPTION]

- Display view definition for specific view
- Line wrapping at blanks

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/05/29:  1.0 (initial version)
- 2021/02/27:  1.1 (SCHEMA_NAME and VIEW_NAME output columns included)

[INVOLVED TABLES]

- VIEWS

[INPUT PARAMETERS]

- VIEW_NAME    
 
  View name

  'MDUB'  --> View MDUB

- LINE_LENGTH_TARGET

  Target for output line length

  80      --> Approximate line length of 80 characters

[OUTPUT PARAMETERS]

- SCHEMA_NAME:     Schema name
- VIEW_NAME:       View name
- VIEW_DEFINITION: View definition text

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------------
|VIEW_DEFINITION                                                                           |
--------------------------------------------------------------------------------------------
|SELECT T1."MANDT", T1."MATNR", T1."RESWK", T1."EBELN", T1."EBELP", T2."BSTYP", T2."LOEKZ",|
|T2."ELIKZ", T2."MEINS", T2."UMREZ", T2."UMREN", T2."PLIFZ", T2."WERKS",                   |
|T2."KNTTP", T2."SOBKZ", T2."KZVBR", T2."CUOBJ", T2."UMSOK", T3."ETENR", T3."EINDT",       |
|T3."MENGE", T3."WAMNG", T3."WEMNG", T3."SERNR", T3."MNG02", T3."DAT01", T3."GLMNG",       |
|T2."AKTNR", T2."EGLKZ", T2."KZBWS", T2."TECHS", T2."ETFZ1", T2."ETFZ2",                   |
|T2."REVLV", T3."DABMG", T3."ESTKZ", T3."FIXKZ", T2."LGORT", T2."RETPO", T3."MBDAT",       |
|T2."STAPO", T2."KZSTU", T2."BERID", T2."RESLO", T3."CHARG", T2."UPTYP", T2."EMLIF",       |
|T2."LBLKZ", T2."FLS_RSTO", T2."BSTAE", T2."FIXMG", T2."SPE_INSMK_SRC"                     |
|FROM "EKUB" T1, "EKPO" T2, "EKET" T3 WHERE T2."MANDT" = T1."MANDT" AND T2."EBELN"         |
|= T1."EBELN" AND T2."EBELP" = T1."EBELP" AND T2."MANDT" = T3."MANDT" AND T2."EBELN"       |
|= T3."EBELN" AND T2."EBELP" = T3."EBELP"                                                  |
--------------------------------------------------------------------------------------------

*/

  CASE O.LINE_NO WHEN 1 THEN V.SCHEMA_NAME ELSE '' END SCHEMA_NAME,
  CASE O.LINE_NO WHEN 1 THEN V.VIEW_NAME ELSE '' END VIEW_NAME,
  CASE O.LINE_NO
    WHEN 1 THEN 
      SUBSTR(V.VIEW_DEFINITION, 
        1, 
        BI.LINE_LENGTH_TARGET + LOCATE(SUBSTR(V.VIEW_DEFINITION, O.LINE_NO * BI.LINE_LENGTH_TARGET), CHAR(32)) - 1)
    WHEN CEIL(V.DEFINITION_LENGTH / BI.LINE_LENGTH_TARGET) THEN
      SUBSTR(V.VIEW_DEFINITION, 
        ( O.LINE_NO - 1) * BI.LINE_LENGTH_TARGET + LOCATE(SUBSTR(V.VIEW_DEFINITION, ( O.LINE_NO - 1) * BI.LINE_LENGTH_TARGET), CHAR(32))) 
    ELSE
      SUBSTR(V.VIEW_DEFINITION, 
        ( O.LINE_NO - 1) * BI.LINE_LENGTH_TARGET + LOCATE(SUBSTR(V.VIEW_DEFINITION, ( O.LINE_NO - 1) * BI.LINE_LENGTH_TARGET), CHAR(32)), 
        BI.LINE_LENGTH_TARGET + LOCATE(SUBSTR(V.VIEW_DEFINITION, O.LINE_NO * BI.LINE_LENGTH_TARGET), CHAR(32)) - LOCATE(SUBSTR(V.VIEW_DEFINITION, ( O.LINE_NO - 1) * BI.LINE_LENGTH_TARGET), CHAR(32))) 
  END VIEW_DEFINITION
FROM
( SELECT                         /* Modification section */
    '%' SCHEMA_NAME,
    'MDUB' VIEW_NAME,
    80 LINE_LENGTH_TARGET
  FROM
    DUMMY
) BI INNER JOIN
( SELECT
    SCHEMA_NAME,
    VIEW_NAME,
    TO_VARCHAR(DEFINITION) VIEW_DEFINITION,
    LENGTH(TO_VARCHAR(DEFINITION)) DEFINITION_LENGTH
  FROM
    VIEWS
) V ON
    V.SCHEMA_NAME LIKE BI.SCHEMA_NAME AND
    V.VIEW_NAME = BI.VIEW_NAME INNER JOIN
( SELECT
    ROW_NUMBER () OVER () LINE_NO
  FROM
    OBJECTS
) O ON
    O.LINE_NO <= CEIL(V.DEFINITION_LENGTH / BI.LINE_LENGTH_TARGET)

