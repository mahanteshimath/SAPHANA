SELECT
/* 

[NAME]

- HANA_Hosts_LandscapeConfiguration

[DESCRIPTION]

- Host information for scale-out landscapes

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2016/05/06:  1.0 (initial version)
- 2020/07/02:  1.1 (HOST_CFG_ROLES and HOST_ACT_ROLES added)

[INVOLVED TABLES]

- M_LANDSCAPE_HOST_CONFIGURATION

[INPUT PARAMETERS]

- HOST

  Host name

  'saphana01'     --> Specific host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

[OUTPUT PARAMETERS]

- HOST:           Host name
- ACTIVE:         Active state
- STATUS:         Host status
- HOST_CFG_ROLES: Configured host roles
- HOST_ACT_ROLES: Active host roles
- NAME_CFG_ROLE:  Configured indexserver role
- NAME_ACT_ROLE:  Active nameserver role
- INDEX_CFG_ROLE: Configured indexserver role
- INDEX_ACT_ROLE: Active indexserver role

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------
|HOST     |ACTIVE|STATUS|NAME_CFG_ROLE|NAME_ACT_ROLE|INDEX_CFG_ROLE|INDEX_ACT_ROLE|
-----------------------------------------------------------------------------------
|saphana01|YES   |OK    |MASTER 1     |MASTER       |WORKER        |SLAVE         |
|saphana02|YES   |OK    |MASTER 2     |SLAVE        |WORKER        |SLAVE         |
|saphana03|YES   |OK    |MASTER 3     |SLAVE        |WORKER        |SLAVE         |
|saphana04|YES   |OK    |SLAVE        |SLAVE        |WORKER        |SLAVE         |
|saphana05|YES   |OK    |SLAVE        |SLAVE        |WORKER        |SLAVE         |
|saphana06|YES   |OK    |SLAVE        |SLAVE        |WORKER        |SLAVE         |
|saphana07|YES   |OK    |SLAVE        |SLAVE        |WORKER        |SLAVE         |
|saphana08|YES   |INFO  |SLAVE        |SLAVE        |STANDBY       |MASTER        |
|saphana09|YES   |IGNORE|SLAVE        |SLAVE        |STANDBY       |STANDBY       |
-----------------------------------------------------------------------------------

*/

  L.HOST,
  L.HOST_ACTIVE ACTIVE,
  L.HOST_STATUS STATUS,
  L.HOST_CONFIG_ROLES HOST_CFG_ROLES,
  L.HOST_ACTUAL_ROLES HOST_ACT_ROLES,
  L.NAMESERVER_CONFIG_ROLE NAME_CFG_ROLE,
  L.NAMESERVER_ACTUAL_ROLE NAME_ACT_ROLE,
  L.INDEXSERVER_CONFIG_ROLE INDEX_CFG_ROLE,
  L.INDEXSERVER_ACTUAL_ROLE INDEX_ACT_ROLE
FROM
( SELECT            /* Modification section */
    '%' HOST
  FROM
    DUMMY
) BI,
  M_LANDSCAPE_HOST_CONFIGURATION L
WHERE
  L.HOST LIKE BI.HOST
ORDER BY
  L.HOST