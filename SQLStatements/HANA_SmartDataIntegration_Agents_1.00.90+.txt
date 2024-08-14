SELECT

/*

[NAME]

- HANA_SmartDataIntegration_Agents_1.00.90+

[DESCRIPTION]

- Overview of Smart Data Integration (SDI) agents

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Smart data integration and M_AGENTS available as of SAP HANA 1.0 SPS 09
- See SAP Note 2400022 for more information related to SDI.

[VALID FOR]

- Revisions:              >= 1.00.90

[SQL COMMAND VERSION]

- 2019/12/10:  1.0 (initial version)
- 2022/07/27:  1.1 (AGENT_GROUPS included)

[INVOLVED TABLES]

- AGENTS
- M_AGENTS

[INPUT PARAMETERS]

- AGENT_NAME

  Agent name

  'MYAGENT'       --> Agent with name MYGENT
  '%'             --> No restriction related to agent name

- AGENT_VERSION

  Agent version

  '2.3.4.0'       --> Agent version 1.0
  '%'             --> No restriction related to agent version

- AGENT_STATUS

  Agent status

  'CONNECTED'     --> Agents with status CONNECTED
  'DISCONNECTED'  --> Agents with status DISCONNECTED
  '%'             --> No restriction related to agent status

- AGENT_GROUP

  Agent group
  'ZMF_AGENT_GRP' --> Agent group ZMF_AGENT_GRP
  '%'             --> No restriction related to agent groups

[OUTPUT PARAMETERS]

- AGENT_NAME:        Agent name
- AGENT_STATUS:      Agent status
- AGENT_VERSION:     Agent version
- AGENT_GROUP:       Agent group
- MEM_USED_GB:       Used physical memory (GB)
- MEM_FREE_GB:       Free physical memory (GB)
- LAST_CONNECT_TIME: Last connect time

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------
|AGENT_NAME                      |AGENT_STATUS|AGENT_VERSION|MEM_USED_GB|MEM_FREE_GB|LAST_CONNECT_TIME  |
---------------------------------------------------------------------------------------------------------
|MYSAPHANAAGENTPROC1             |CONNECTED   |2.3.4.0      |      62.92|      65.07|2019/12/11 10:40:29|
|MYSAPHANAAGENTPROC1_ABAP_Adapter|CONNECTED   |2.3.4.0      |       0.10|      31.89|2019/12/11 10:40:19|
|MYSAPHANAAGENTPROC2             |CONNECTED   |2.3.4.0      |       2.17|      29.82|2019/12/11 10:40:28|
---------------------------------------------------------------------------------------------------------

*/

  A.AGENT_NAME,
  A.AGENT_STATUS,
  A.AGENT_VERSION,
  AG.AGENT_GROUP_NAME AGENT_GROUP,
  LPAD(TO_DECIMAL(A.USED_PHYSICAL_MEMORY / 1024 / 1024 / 1024, 10, 2), 11) MEM_USED_GB,
  LPAD(TO_DECIMAL(A.FREE_PHYSICAL_MEMORY / 1024 / 1024 / 1024, 10, 2), 11) MEM_FREE_GB,
  IFNULL(TO_VARCHAR(LAST_CONNECT_TIME, 'YYYY/MM/DD HH24:MI:SS'), 'n/a') LAST_CONNECT_TIME
FROM
( SELECT                             /* Modification section */
    '%' AGENT_NAME,
    '%' AGENT_VERSION,
    '%' AGENT_STATUS,
    '%' AGENT_GROUP
  FROM
    DUMMY
) BI,
  M_AGENTS A LEFT OUTER JOIN
  AGENTS AG ON
    AG.AGENT_NAME = A.AGENT_NAME
WHERE
  A.AGENT_NAME LIKE BI.AGENT_NAME AND
  A.AGENT_VERSION LIKE BI.AGENT_VERSION AND
  A.AGENT_STATUS LIKE BI.AGENT_STATUS AND
  IFNULL(AG.AGENT_GROUP_NAME, '') LIKE BI.AGENT_GROUP
ORDER BY
  A.AGENT_NAME
