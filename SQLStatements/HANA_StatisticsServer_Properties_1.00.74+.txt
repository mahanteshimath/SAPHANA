SELECT
/* 

[NAME]

- HANA_StatisticsServer_Properties_1.00.74+

[DESCRIPTION]

- Embedded statistics server properties like migration status

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

[VALID FOR]

- Revisions:              >= 1.00.74

[SQL COMMAND VERSION]

- 2014/12/29:  1.0 (initial version)

[INVOLVED TABLES]

- STATISTICS_PROPERTIES

[INPUT PARAMETERS]

- STAT_PROP_KEY

  Statistics server property key

  '%install%'     --> Keys containing 'install'
  '%'             --> No restriction of key names

- STAT_PROP_VALUE

  Statistics server property value

  'Done%'         --> Values starting with 'Done'
  '%'             --> No restriction of values
  
[OUTPUT PARAMETERS]

- KEY:   Property key
- VALUE: Property value

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|KEY                                      |VALUE                                                                                                                                                                       |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|internal.installation.state              |Done (error) since 2021-12-17 20:22:58.8550000 local time:2021-12-17 21:22:58.8550000                                                                                       |
|internal.thread.samples                  |50                                                                                                                                                                          |
|internal.table_consistency.check_actions |check_delta_log, check_variable_part_sanity, check_data_container, check_variable_part_double_reference_global, check_partitioning, check_replication, check_table_container|
|internal.table_consistency.max_duration  |0                                                                                                                                                                           |
|internal.sizing.profile                  |M                                                                                                                                                                           |
|internal.blocked_transactions.lower_bound|20                                                                                                                                                                          |
|internal.views.SR                        |                                                                                                                                                                            |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  SP.KEY,
  SP.VALUE
FROM
( SELECT                      /* Modification section */
    '%' STAT_PROP_KEY,
    '%' STAT_PROP_VALUE
  FROM
    DUMMY
) BI,
  _SYS_STATISTICS.STATISTICS_PROPERTIES SP
WHERE
  UPPER(SP.KEY) LIKE UPPER(BI.STAT_PROP_KEY) AND
  UPPER(SP.VALUE) LIKE UPPER(BI.STAT_PROP_VALUE)
