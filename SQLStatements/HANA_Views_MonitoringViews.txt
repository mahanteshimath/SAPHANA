SELECT

/* 

[NAME]

- HANA_Views_MonitoringViews

[DESCRIPTION]

- Overview of monitoring views

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2020/01/22:  1.0 (initial version)

[INVOLVED TABLES]

- M_MONITORS

[INPUT PARAMETERS]

- VIEW_NAME

  Monitoring view name

  'M_HEAP_MEMORY' --> Monitoring view M_HEAP_MEMORY
  '%ROW%'         --> All monitoring views with names containing 'ROW'
  '%'             --> No restriction related to monitoring view name

- RESETTABLE

  Resettable view information

  'X'             --> Only show views that are resettable with ALTER SYSTEM RESET MONITORING VIEW
  ' '             --> Only show views that are not resettable
  '%'             --> No restriction related to resettable views property

- VIEW_DESCRIPTION

  Monitoring view description

  'Statistics%'   --> All views with a description starting with 'Statistics'
  '%'             --> No restriction related to view description
  
[OUTPUT PARAMETERS]

- VIEW_NAME:        Monitoring view name
- R:                'X' if view is resettable via ALTER SYSTEM RESET MONITORING VIEW, otherwise ' '
- VIEW_DESCRIPTION: Monitoring view description

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------------------
|VIEW_NAME                                  |R|VIEW_DESCRIPTION                                                                                               |
---------------------------------------------------------------------------------------------------------------------------------------------------------------
|M_CATALOG_MEMORY                           | |Memory usage information by catalog manager                                                                    |
|M_CONTEXT_MEMORY                           | |Memory allocator statistics                                                                                    |
|M_CONTEXT_MEMORY_RESET                     |X|Memory allocator statistics                                                                                    |
|M_ES_DELTA_MEMORY                          | |Runtime Delta memory data of dynamic tiering                                                                   |
|M_HEAP_MEMORY                              | |Memory allocator statistics                                                                                    |
|M_HEAP_MEMORY_AREAS                        | |Heap memory areas by Memory Management                                                                         |
|M_HEAP_MEMORY_RESET                        |X|Memory allocator statistics                                                                                    |
|M_MEMORY                                   | |Deprecated: use M_SERVICE_MEMORY instead                                                                       |
|M_MEMORY_OBJECTS                           | |Memory object statistics                                                                                       |
|M_MEMORY_OBJECTS_RESET                     |X|Memory object statistics                                                                                       |
|M_MEMORY_OBJECT_DISPOSITIONS               | |Disposition specific memory object statistics. The statistics are calculated and reading them may take a while.|
|M_MEMORY_PROFILER                          | |Current memory profiler state                                                                                  |
|M_MEMORY_RECLAIM_STATISTICS                | |Statistics for reclaiming memory (e.g. defragmentation, unloading of memory objects, ...)                      |
|M_MEMORY_RECLAIM_STATISTICS_RESET          |X|Statistics for reclaiming memory (e.g. defragmentation, unloading of memory objects, ...)                      |
---------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  M.VIEW_NAME VIEW_NAME,
  MAP(M.RESETTABLE, 'TRUE', 'X', ' ') R,
  M.DESCRIPTION VIEW_DESCRIPTION
FROM
  ( SELECT                      /* Modification section */
      '%' VIEW_NAME,                                      
      '%' VIEW_DESCRIPTION,
      '%' RESETTABLE
    FROM
      DUMMY
  ) BI,
  M_MONITORS M
WHERE
  M.VIEW_NAME LIKE BI.VIEW_NAME AND
  M.DESCRIPTION LIKE BI.VIEW_DESCRIPTION AND
  ( BI.RESETTABLE = '%' OR
    BI.RESETTABLE IN ('X', 'TRUE') AND M.RESETTABLE = 'TRUE' OR
    BI.RESETTABLE IN (' ', 'FALSE') AND M.RESETTABLE = 'FALSE'
  )
ORDER BY
  M.VIEW_NAME
