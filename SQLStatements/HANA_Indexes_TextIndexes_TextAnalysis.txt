SELECT

/* 

[NAME]

- HANA_Indexes_TextIndexes_TextAnalysis

[DESCRIPTION]

- Overview of available text analysis options (languages and mime types)

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- See SAP Note 2800008 for details about fulltext indexes.

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2022/07/08:  1.0 (initial version)

[INVOLVED TABLES]

- M_TEXT_ANALYSIS_LANGUAGES
- M_TEXT_ANALYSIS_MIME_TYPES

[INPUT PARAMETERS]

- TYPE

  Type of text analysis object (i.e. language or mime type)

  'LANGUAGE'      --> Text analysis languages
  'MIME'          --> Text analysis mime type
  '%'             --> No restriction related to type

- NAME

  Name of text analysis object

  'Esperanto'       --> Text analysis object 'Esperanto'
  'application/pdf' --> Text analysis object 'application/pdf'
  '%'               --> No restriction related to name

- DETAIL

  Text analysis object detail (language code or mime type description)

  'Plain text'    --> Detail 'Plan text'
  'nl'            --> Detail 'nl'
  '%'             --> No restriction related to detail

[OUTPUT PARAMETERS]

- TYPE:   Text analysis object type
- NAME:   Text analysis object name
- DETAIL: Text analysis object detail

[EXAMPLE OUTPUT]

-------------------------------------------------------------------------------------------------------------------------------
|TYPE    |NAME                                                                     |DETAIL                                    |
-------------------------------------------------------------------------------------------------------------------------------
|LANGUAGE|Afrikaans                                                                |af                                        |
|LANGUAGE|Albanian                                                                 |sq                                        |
|LANGUAGE|Amharic                                                                  |am                                        |
|LANGUAGE|Arabic                                                                   |ar                                        |
|LANGUAGE|Aragonese                                                                |an                                        |
|LANGUAGE|Armenian                                                                 |hy                                        |
|LANGUAGE|Assamese                                                                 |as                                        |
|MIME    |application/x-abap-rawstring                                             |ABAP rawstring format                     |
|MIME    |application/x-cscompr                                                    |SAP compression format                    |
|MIME    |message/rfc822                                                           |Generic e-mail (".eml") messages          |
|MIME    |text/html                                                                |HyperText Markup Language                 |
|MIME    |text/plain                                                               |Plain Text                                |
|MIME    |text/xml                                                                 |Extensible Markup Language                |
-------------------------------------------------------------------------------------------------------------------------------


*/

  T.TYPE,
  T.NAME,
  T.DETAIL
FROM
( SELECT                  /* Modification section */
    '%' TYPE,
    '%' NAME,
    '%' DETAIL
  FROM
    DUMMY
) BI,
( SELECT
    'LANGUAGE' TYPE,
    LANGUAGE_NAME NAME,
    LANGUAGE_CODE DETAIL
  FROM
    M_TEXT_ANALYSIS_LANGUAGES
  UNION ALL
  SELECT
    'MIME' TYPE,
    MIME_TYPE_NAME NAME,
    MIME_TYPE_DESCRIPTION DETAIL
  FROM
    M_TEXT_ANALYSIS_MIME_TYPES
) T
WHERE
  T.TYPE LIKE BI.TYPE AND
  T.NAME LIKE BI.NAME AND
  T.DETAIL LIKE BI.DETAIL
ORDER BY
  T.TYPE,
  T.NAME,
  T.DETAIL