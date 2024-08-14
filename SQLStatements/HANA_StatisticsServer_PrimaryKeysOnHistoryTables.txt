SELECT
/* 

[NAME]

- HANA_StatisticsServer_PrimaryKeysOnHistoryTables

[DESCRIPTION]

- Lists statistics server history tables with primary keys

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- See SAP Note 2143679 and drop the primary keys only in exceptional cases, because
  a dropped index can result in terminations during a SAP HANA upgrade

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2015/03/17:  1.0 (initial version)
- 2015/05/04:  1.1 (STATISTICS_ALERTS_BASE added)

[INVOLVED TABLES]

- TABLES
- CONSTRAINTS

[INPUT PARAMETERS]


[OUTPUT PARAMETERS]

- TABLE_NAME:    History table name
- PK_CONSTRAINT: Name of primary key constraint
- DROP_COMMAND:  Command that can be used to drop the primary key constraint

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|TABLE_NAME                            |PK_CONSTRAINT               |DROP_COMMAND                                                                                                        |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|GLOBAL_COLUMN_TABLES_SIZE             |_SYS_TREE_CS_#138544_#0_#P0 |ALTER TABLE "_SYS_STATISTICS"."GLOBAL_COLUMN_TABLES_SIZE" DROP CONSTRAINT "_SYS_TREE_CS_#138544_#0_#P0"             |
|GLOBAL_CPU_STATISTICS                 |_SYS_TREE_CS_#138569_#0_#P0 |ALTER TABLE "_SYS_STATISTICS"."GLOBAL_CPU_STATISTICS" DROP CONSTRAINT "_SYS_TREE_CS_#138569_#0_#P0"                 |
|GLOBAL_DEC_EXTRACTOR_STATUS           |_SYS_TREE_CS_#138588_#0_#P0 |ALTER TABLE "_SYS_STATISTICS"."GLOBAL_DEC_EXTRACTOR_STATUS" DROP CONSTRAINT "_SYS_TREE_CS_#138588_#0_#P0"           |
|GLOBAL_DISKS                          |_SYS_TREE_CS_#146199_#0_#P0 |ALTER TABLE "_SYS_STATISTICS"."GLOBAL_DISKS" DROP CONSTRAINT "_SYS_TREE_CS_#146199_#0_#P0"                          |
|GLOBAL_INTERNAL_DISKFULL_EVENTS       |_SYS_TREE_CS_#138605_#0_#P0 |ALTER TABLE "_SYS_STATISTICS"."GLOBAL_INTERNAL_DISKFULL_EVENTS" DROP CONSTRAINT "_SYS_TREE_CS_#138605_#0_#P0"       |
|GLOBAL_INTERNAL_EVENTS                |_SYS_TREE_CS_#138624_#0_#P0 |ALTER TABLE "_SYS_STATISTICS"."GLOBAL_INTERNAL_EVENTS" DROP CONSTRAINT "_SYS_TREE_CS_#138624_#0_#P0"                |
|GLOBAL_MEMORY_STATISTICS              |_SYS_TREE_CS_#138643_#0_#P0 |ALTER TABLE "_SYS_STATISTICS"."GLOBAL_MEMORY_STATISTICS" DROP CONSTRAINT "_SYS_TREE_CS_#138643_#0_#P0"              |
|GLOBAL_PERSISTENCE_STATISTICS         |_SYS_TREE_CS_#138657_#0_#P0 |ALTER TABLE "_SYS_STATISTICS"."GLOBAL_PERSISTENCE_STATISTICS" DROP CONSTRAINT "_SYS_TREE_CS_#138657_#0_#P0"         |
|GLOBAL_ROWSTORE_TABLES_SIZE           |_SYS_TREE_CS_#138670_#0_#P0 |ALTER TABLE "_SYS_STATISTICS"."GLOBAL_ROWSTORE_TABLES_SIZE" DROP CONSTRAINT "_SYS_TREE_CS_#138670_#0_#P0"           |
|GLOBAL_TABLES_SIZE                    |_SYS_TREE_CS_#138694_#0_#P0 |ALTER TABLE "_SYS_STATISTICS"."GLOBAL_TABLES_SIZE" DROP CONSTRAINT "_SYS_TREE_CS_#138694_#0_#P0"                    |
|GLOBAL_TABLE_PERSISTENCE_STATISTICS   |_SYS_TREE_CS_#138709_#0_#P0 |ALTER TABLE "_SYS_STATISTICS"."GLOBAL_TABLE_PERSISTENCE_STATISTICS" DROP CONSTRAINT "_SYS_TREE_CS_#138709_#0_#P0"   |
|HOST_BLOCKED_TRANSACTIONS             |_SYS_TREE_CS_#138732_#0_#P0 |ALTER TABLE "_SYS_STATISTICS"."HOST_BLOCKED_TRANSACTIONS" DROP CONSTRAINT "_SYS_TREE_CS_#138732_#0_#P0"             |
|HOST_COLUMN_TABLES_PART_SIZE          |_SYS_TREE_CS_#138753_#0_#P0 |ALTER TABLE "_SYS_STATISTICS"."HOST_COLUMN_TABLES_PART_SIZE" DROP CONSTRAINT "_SYS_TREE_CS_#138753_#0_#P0"          |
|HOST_CONNECTIONS                      |_SYS_TREE_CS_#138790_#0_#P0 |ALTER TABLE "_SYS_STATISTICS"."HOST_CONNECTIONS" DROP CONSTRAINT "_SYS_TREE_CS_#138790_#0_#P0"                      |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  C.TABLE_NAME,
  C.CONSTRAINT_NAME PK_CONSTRAINT,
  'ALTER TABLE "_SYS_STATISTICS"."' || C.TABLE_NAME || '" DROP CONSTRAINT "' || C.CONSTRAINT_NAME || '";' DROP_COMMAND
FROM
  TABLES T,
  CONSTRAINTS C
WHERE
  T.SCHEMA_NAME = '_SYS_STATISTICS' AND
  ( T.TABLE_NAME LIKE 'HOST%' OR T.TABLE_NAME LIKE 'GLOBAL%' OR T.TABLE_NAME = 'STATISTICS_ALERTS_BASE' ) AND
  T.SCHEMA_NAME = C.SCHEMA_NAME AND
  T.TABLE_NAME = C.TABLE_NAME AND
  C.IS_PRIMARY_KEY = 'TRUE'
GROUP BY
  C.TABLE_NAME,
  C.CONSTRAINT_NAME
ORDER BY
  C.TABLE_NAME