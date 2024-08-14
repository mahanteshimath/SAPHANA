SELECT

/* 

[NAME]

- HANA_NUMA_Nodes_2.00.010+

[DESCRIPTION]

- NUMA node information

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_NUMA_NODES available starting with SAP HANA 2.00.010

[VALID FOR]

- Revisions:              >= 2.00.010

[SQL COMMAND VERSION]

- 2017/05/09:  1.0 (initial version)
- 2020/11/16:  1.1 (separation of NUMA_NODE_ID and NUMA_NODE_INDEX

[INVOLVED TABLES]

- M_NUMA_NODES

[INPUT PARAMETERS]

- HOST

  Host name

  'saphana01'     --> Specific host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- PORT

  Port number

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- NUMA_NODE_ID

  NUMA node ID

  4               --> Display information for NUMA node ID 4
  -1              --> No restriction related to NUMA node ID

- NUMA_NODE_INDEX

  NUMA node index

  4               --> Display information for NUMA node index 4
  -1              --> No restriction related to NUMA node index

[OUTPUT PARAMETERS]

- HOST:                 Host name
- PORT:                 Port
- ID:                   NUMA node ID
- INDEX:                NUMA node index
- LOGICAL_CORES:        Number of assigned logical CPU cores
- LOGICAL_CORE_IDS:     IDs of assigned logical CPU cores
- MEMORY_GB:            Memory assigned to NUMA node (GB)
- NEIGHBOUR_NUMA_NODES: Neighbour NUMA nodes

[EXAMPLE OUTPUT]

--------------------------------------------------------------------------------------
|HOST  |PORT |NUMA_NODE|LOGICAL_CORES|LOGICAL_CORE_IDS|MEMORY_GB|NEIGHBOUR_NUMA_NODES|
--------------------------------------------------------------------------------------
|hana01|30346|        0|           36|0-17,144-161    |   126.06|1,3,4               |
|hana01|30346|        1|           36|18-35,162-179   |   126.24|0,2,5               |
|hana01|30346|        2|           36|36-53,180-197   |   126.24|1,3,6               |
|hana01|30346|        3|           36|54-71,198-215   |   126.24|0,2,7               |
|hana01|30346|        4|           36|72-89,216-233   |   126.24|0,5,6               |
|hana01|30346|        5|           36|90-107,234-251  |   126.24|1,4,7               |
|hana01|30346|        6|           36|108-125,252-269 |   126.24|2,4,7               |
|hana01|30346|        7|           36|126-143,270-287 |   126.24|3,5,6               |
--------------------------------------------------------------------------------------

*/

  N.HOST,
  LPAD(TO_VARCHAR(N.PORT), 5) PORT,
  LPAD(TO_VARCHAR(N.NUMA_NODE_ID), 3) ID,
  LPAD(TO_VARCHAR(N.NUMA_NODE_INDEX), 5) INDEX,
  LPAD(N.ACTIVE_LOGICAL_CORE_COUNT, 13) LOGICAL_CORES,
  N.LOGICAL_CORE_IDS,
  LPAD(TO_DECIMAL(N.MEMORY_SIZE / 1024 / 1024 / 1024, 10, 2), 9) MEMORY_GB,
  N.NEIGHBOUR_NUMA_NODE_IDS NEIGHBOUR_NUMA_NODES
FROM
( SELECT               /* Modification section */
    '%' HOST,
    '%' PORT,
    -1 NUMA_NODE_ID,
    -1 NUMA_NODE_INDEX
  FROM
    DUMMY
) BI,
  M_NUMA_NODES N
WHERE
  N.HOST LIKE BI.HOST AND
  TO_VARCHAR(N.PORT) LIKE BI.PORT AND
  ( BI.NUMA_NODE_ID = -1 OR N.NUMA_NODE_ID = BI.NUMA_NODE_ID ) AND
  ( BI.NUMA_NODE_INDEX = -1 OR N.NUMA_NODE_INDEX = BI.NUMA_NODE_INDEX )
ORDER BY
  N.HOST,
  N.PORT,
  N.NUMA_NODE_ID