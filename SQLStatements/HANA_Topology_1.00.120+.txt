SELECT

/* 

[NAME]

- HANA_Topology_1.00.120+

[DESCRIPTION]

- Topology information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- With SAP HANA 1.0 SPS <= 11 it is not possible to perform flexible queries in M_TOPOLOGY_TREE and
  the following error is returned:

  predicates are required in a where clause: M_TOPOLOGY_TREE_ needs predicates on columns (connected
  by AND if more than one): an equal predicate on PATH, Use '/' as root path

[VALID FOR]

- Revisions:              >= 1.00.120

[SQL COMMAND VERSION]

- 2017/05/23:  1.0 (initial version)

[INVOLVED TABLES]

- M_TOPOLOGY_TREE

[INPUT PARAMETERS]

- PATH

  Path name

  '/host'         --> Path /host
  '/host%'        --> Path starting with '/host'
  '%'             --> No restriction related to path

- NAME

  Name of topology entry

  'servicetype'   --> Name servicetype
  '%'             --> No restriction related to name

- VALUE

  Value of topology entry

  'nameserver'    --> Value nameserver
  '%'             --> No restriction related to value

- LEAF

  Leaf property

  'YES'           --> Only display leaves
  'NO'            --> Display everything but leaves
  '%'             --> No restriction related to leaf property
 
[OUTPUT PARAMETERS]

- PATH:  Topology path
- NAME:  Topology entry name
- VALUE: Topology entry value
- LEAF:  Leaf property (YES -> leaf, NO -> no leaf)

[EXAMPLE OUTPUT]

------------------------------------------
|PATH      |NAME       |VALUE       |LEAF|
------------------------------------------
|/volumes/1|servicetype|nameserver  |TRUE|
|/volumes/2|servicetype|indexserver |TRUE|
|/volumes/4|servicetype|xsengine    |TRUE|
|/volumes/5|servicetype|scriptserver|TRUE|
|/volumes/6|servicetype|dpserver    |TRUE|
------------------------------------------

*/

  T.PATH,
  T.NAME,
  T.VALUE,
  T.LEAF
FROM
( SELECT                /* Modification section */
    '/volumes%' PATH,
    'servicetype' NAME,
    '%' VALUE,
    '%' LEAF
  FROM
    DUMMY
) BI,
  M_TOPOLOGY_TREE T
WHERE
  UPPER(T.PATH) LIKE UPPER(BI.PATH) AND
  UPPER(T.NAME) LIKE UPPER(BI.NAME) AND
  UPPER(T.VALUE) LIKE UPPER(BI.VALUE) AND
  T.LEAF LIKE BI.LEAF
ORDER BY
  T.PATH,
  T.NAME,
  T.VALUE,
  T.LEAF
