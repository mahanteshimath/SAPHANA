SELECT
/* 

[NAME]

- HANA_SQL_Hints_1.00.90+

[DESCRIPTION]

- SQL hint overview

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              >= 1.00.90

[SQL COMMAND VERSION]

- 2015/03/15:  1.0 (initial version)

[INVOLVED TABLES]

- HINTS

[INPUT PARAMETERS]

- HINT_NAME

  Name of hint

  'HASH_JOIN'    --> Information related to HASH_JOIN hint
  '%HASH_JOIN'   --> Information related to hints with names ending with 'HASH_JOIN'
  '%'            --> No restriction related to hint name

- HINT_DESCRIPTION

  Hint description

  '%pushdown%'   --> Errors with a description containing 'pushdown'
  '%'            --> No filtering by error description
  
[OUTPUT PARAMETERS]

- HINT_NAME:   Hint name
- DESCRIPTION: Hint description

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------
|HINT_NAME          |DESCRIPTION                                         |
--------------------------------------------------------------------------
|CS_AGGR            |Prefer/Avoid column engine aggregation              |
|CS_DISTINCT        |Prefer/Avoid column engine distinct                 |
|CS_FILTER          |Prefer/Avoid column engine filter                   |
|CS_ITAB_IN_SUBQUERY|Prefer/Avoid column engine itab in subquery         |
|CS_JOIN            |Prefer/Avoid column engine join                     |
|CS_LIMIT           |Prefer/Avoid column engine limit                    |
|CS_SCALAR_SUBQUERY |Prefer/Avoid column engine scalar subquery          |
|CS_SORT            |Prefer/Avoid column engine order by                 |
|CS_UNION_ALL       |Prefer/Avoid column engine union all                |
|CS_WINDOW          |Prefer/Avoid column engine window for rownumber only|
--------------------------------------------------------------------------

*/

  H.HINT_NAME,
  H.DESCRIPTION
FROM
( SELECT             /* Modification section */
    '%' HINT_NAME,
    '%' HINT_DESCRIPTION
  FROM
    DUMMY
) BI,
  HINTS H
WHERE
  H.HINT_NAME LIKE BI.HINT_NAME AND
  UPPER(H.DESCRIPTION) LIKE UPPER(BI.HINT_DESCRIPTION)
