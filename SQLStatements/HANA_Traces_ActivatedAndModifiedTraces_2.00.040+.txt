SELECT

/* 

[NAME]

- HANA_Traces_ActivatedAndModifiedTraces_2.00.040+

[DESCRIPTION]

- Overview of trace settings that are explicitly activated or modified

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_KERNEL_PROFILER only available as of revision 1.00.70
- M_MEMORY_PROFILER available starting with SAP HANA 2.00.040
- See SAP Note 2119087 for a central overview about available traces

[VALID FOR]

- Revisions:              >= 2.00.040

[SQL COMMAND VERSION]

- 2014/12/29:  1.0 (initial version)
- 2015/08/04:  1.1 (Web Dispatcher HTTP trace added)
- 2016/11/30:  1.2 (function profiler added)
- 2017/04/06:  1.3 (plan viz, plan trace and executed statements trace added)
- 2020/12/04:  1.4 (dedicated 2.00.040+ version including memory profiler)
- 2021/01/24:  1.5 (transition to M_CONFIGURATION_PARAMETER_VALUES)
- 2021/08/30:  1.6 (SQLScript plan profiler included)

[INVOLVED TABLES]

- M_CONFIGURATION_PARAMETER_VALUES
- M_KERNEL_PROFILER
- M_MEMORY_PROFILER
- M_PERFTRACE
- M_SQLSCRIPT_PLAN_PROFILERS

[INPUT PARAMETERS]

- ACTIVATED_TRACES

  Controls the display of trace activation settings

  'X'             --> Show settings responsible for trace activation
  ' '             --> Do not show settings responsible for trace activation

- MODIFIED_TRACES

  Controls the display of trace modification settings

  'X'             --> Show settings responsible for trace modification
  ' '             --> Do not show settings responsible for trace modification

- CLIENT_NETWORK_TRACE

  Controls the display of client network trace settings

  'X'             --> Show settings related to client network trace
  ' '             --> Do not show settings responsible for client network trace

- CPU_TIME_MEASUREMENT

  Controls the display of CPU time measurement settings

  'X'             --> Display CPU time measurement settings
  ' '             --> Do not show settings related to CPU time measurement

- DATABASE_TRACE

  Controls the display of database trace settings

  'X'             --> Show settings related to database trace
  ' '             --> Do not show settings responsible for database trace

- END_TO_END_TRACE

  Controls the display of end-to-end trace settings

  'X'             --> Show settings related to end-to-end trace
  ' '             --> Do not show settings responsible for end-to-end trace

- EXECUTED_STATEMENTS_TRACE

  Controls the display of executed statements trace settings

  'X'             --> Show settings related to executed statements trace
  ' '             --> Do not show settings responsible for executed statements trace

- EXPENSIVE_STATEMENTS_TRACE

  Controls the display of expensive statements trace settings

  'X'             --> Show settings related to expensive statements trace
  ' '             --> Do not show settings responsible for expensive statements trace

- FUNCTION_PROFILER

  Controls the display of function profiler settings

  'X'             --> Show settings related to function profiler
  ' '             --> Do not show settings related to function profiler

- HTTP_TRACE

  Controls the display of HTTP trace settings

  'X'             --> Show settings related to HTTP trace
  ' '             --> Do not show settings related to HTTP trace

- KERNEL_PROFILER_TRACE

  Controls the display of kernel profiler trace settings

  'X'             --> Show settings related to kernel profiler trace
  ' '             --> Do not show settings responsible for kernel profiler trace

- LOAD_HISTORY

  Controls the display of load history settings

  'X'             --> Show settings related to load history
  ' '             --> Do not show settings related to load history

- LOAD_TRACE

  Controls the display of load trace settings

  'X'             --> Show settings related to load trace
  ' '             --> Do not show settings responsible for load trace

- PERFORMANCE_TRACE

  Controls the display of performance trace settings

  'X'             --> Show settings related to performance trace
  ' '             --> Do not show settings responsible for performance trace

- PLAN_VIZ_PLAN_TRACE

  Controls the display of PlanVize / plan trace settings

  'X'             --> Show settings related to PlanViz / plan trace
  ' '             --> Do not show settings related to PlanViz / plan trace

- PYTHON_TRACE

  Controls the display of python trace settings

  'X'             --> Show settings related to python trace
  ' '             --> Do not show settings responsible for python trace

- RESOURCE_TRACKING

  Controls the display of resource tracking settings (memory, CPU, thread samples, load monitor)

  'X'             --> Show settings related to resource tracking
  ' '             --> Do not show settings responsible for resource tracking

- SQLSCRIPT_PLAN_PROFILER

  Controls the display of SQLScript plan profiler details

  'X'             --> Show details related to SQLScript plan profiler
  ' '             --> Do not show details related to SQLScript plan profiler

- SQL_TRACE

  Controls the display of SQL trace settings

  'X'             --> Show settings related to SQL trace
  ' '             --> Do not show settings responsible for SQL trace

- THREAD_LOOP

  Controls the display of thread loop settings

  'X'             --> Show settings related to thread loop (thrloop)
  ' '             --> Do not show settings related to thread loop

- THREAD_SAMPLING

  Controls the display of thread sampling settings

  'X'             --> Show settings related to thread sampling
  ' '             --> Do not show settings related to thread sampling

- UNLOAD_TRACE

  Controls the display of unload trace settings

  'X'             --> Show settings related to unload trace
  ' '             --> Do not show settings responsible for unload trace

- USER_SPECIFIC_TRACE

  Controls the display of user-specific trace settings

  'X'             --> Show settings related to user-specific trace
  ' '             --> Do not show settings responsible for user-specific trace

- MEMORY_PROFILER

  Controls the display of memory profiler related trace settings

  'X'             --> Show settings related to memory profiler
  ' '             --> Do not show settings responsible for memory profiler
  
[OUTPUT PARAMETERS]

- TRACE_TYPE:      Trace type
- ADJUSTMENT_TYPE: 'MODIFIED' if setting modifies the standard settings without changing the activation state of the trace, 'ACTIVATED' if setting is responsible for activating the trace
- DETAILS:         Setting details
- CONTEXT:         Setting context (host, service, user, depending on the trace type)

[EXAMPLE OUTPUT]

----------------------------------------------------------------------------------------------------------------------------------------------------------
|TRACE_TYPE               |ADJUSTMENT_TYPE|DETAILS                                                     |CONTEXT                                          |
----------------------------------------------------------------------------------------------------------------------------------------------------------
|Database trace           |MODIFIED       |optimize_compression = 'info'                               |system-wide in global.ini                        |
|End-to-end trace         |ACTIVATED      |enabled = 'true'                                            |system-wide in global.ini for sap_passport_high  |
|                         |ACTIVATED      |enabled = 'true'                                            |system-wide in global.ini for sap_passport_medium|
|Expensive statement trace|ACTIVATED      |enable = 'true'                                             |system-wide in global.ini                        |
|                         |MODIFIED       |threshold_duration = '1000000'                              |system-wide in global.ini                        |
|                         |MODIFIED       |use_in_memory_tracing = 'false'                             |host hana01 in global.ini                        |
|Resource tracking        |ACTIVATED      |cpu_time_measurement_mode = 'on'                            |system-wide in global.ini                        |
|                         |ACTIVATED      |enable_tracking = 'on'                                      |system-wide in global.ini                        |
|                         |ACTIVATED      |memory_tracking = 'on'                                      |system-wide in global.ini                        |
|                         |MODIFIED       |load_monitor_granularity = '60000'                          |system-wide in global.ini                        |
|SQL trace                |MODIFIED       |tracefile = 'trace/sqltrace_$HOST_${PORT}_${COUNT:3}auto.py'|system-wide in indexserver.ini                   |
|                         |MODIFIED       |user = 'jan'                                                |system-wide in indexserver.ini                   |
|User-specific trace      |MODIFIED       |sql_user = 'TESTPRIVDIFLEV'                                 |system-wide in global.ini for user larstest      |
----------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  CASE WHEN ROW_NUMBER () OVER (PARTITION BY T.TRACE_TYPE ORDER BY T.ADJUSTMENT_TYPE, T.DETAILS) = 1 THEN T.TRACE_TYPE ELSE '' END TRACE_TYPE,
  T.ADJUSTMENT_TYPE,
  T.DETAILS,
  T.CONTEXT
FROM
( SELECT                  /* Modification section */
    'X' ACTIVATED_TRACES,
    'X' MODIFIED_TRACES,
    'X' CLIENT_NETWORK_TRACE,
    'X' CPU_TIME_MEASUREMENT,
    'X' DATABASE_TRACE,
    'X' END_TO_END_TRACE,
    'X' EXECUTED_STATEMENTS_TRACE,
    'X' EXPENSIVE_STATEMENTS_TRACE,
    'X' FUNCTION_PROFILER,
    'X' HTTP_TRACE,
    'X' KERNEL_PROFILER_TRACE,
    'X' LOAD_HISTORY,
    'X' LOAD_TRACE,
    'X' PERFORMANCE_TRACE,
    'X' PLAN_VIZ_PLAN_TRACE,
    'X' PYTHON_TRACE,
    'X' RESOURCE_TRACKING,
    'X' SQLSCRIPT_PLAN_PROFILER,
    'X' SQL_TRACE,
    'X' THREAD_LOOP,
    'X' THREAD_SAMPLING,
    'X' UNLOAD_TRACE,
    'X' USER_SPECIFIC_TRACE,
    'X' MEMORY_PROFILER
  FROM
    DUMMY
) BI,
( SELECT
    'Kernel profiler trace' TRACE_TYPE,
    'ACTIVATED' ADJUSTMENT_TYPE,
    COUNT(*) || ' active trace(s)' DETAILS,
    'host' || CHAR(32) || HOST || ' and port' || CHAR(32) || PORT CONTEXT
  FROM 
    M_KERNEL_PROFILER
  GROUP BY
    HOST,
    PORT
  UNION ALL
  SELECT
    'SQLScript plan profiler',
    'ACTIVATED',
    COUNT(*) || ' active trace(s)',
    'host' || CHAR(32) || HOST || ' and port' || CHAR(32) || PORT CONTEXT
  FROM
    M_SQLSCRIPT_PLAN_PROFILERS
  GROUP BY
    HOST,
    PORT
  UNION ALL
  ( SELECT
      'Performance trace',
      'ACTIVATED',
      'Active since' || CHAR(32) || TO_VARCHAR(START_TIME, 'YYYY/MM/DD HH24:MI:SS') || 
        MAP(STATUS, 'SAVING', ', currently saving', ''),
      ''
    FROM
      M_PERFTRACE
    WHERE
      STATUS IN ('STARTED', 'SAVING')
  )
  UNION ALL
  ( SELECT
      'Function profiler',
      'ACTIVATED',
      'Active since' || CHAR(32) || TO_VARCHAR(START_TIME, 'YYYY/MM/DD HH24:MI:SS'),
      ''
    FROM
      M_PERFTRACE
    WHERE
      STATUS = 'STARTED' AND
      FUNCTION_PROFILER = 'TRUE'
  )
  UNION ALL
  ( SELECT DISTINCT
      'SQL trace',
      CASE WHEN KEY = 'trace' AND LOWER(VALUE) = 'true' THEN 'ACTIVATED' ELSE 'MODIFIED' END,
      KEY || ' =' || CHAR(32) || CHAR(39) || MAP(VALUE, 'TRUE', 'true', 'FALSE', 'false', VALUE) || CHAR(39),
      MAP(LAYER_NAME, 'HOST', 'host' || CHAR(32) || HOST, 'system-wide') || ' in' || CHAR(32) || FILE_NAME
    FROM
      M_CONFIGURATION_PARAMETER_VALUES
    WHERE
      SECTION = 'sqltrace' AND
      LAYER_NAME != 'DEFAULT'
  )
  UNION ALL
  ( SELECT DISTINCT
      'PlanViz / plan trace',
      CASE WHEN KEY = 'plan_trace_enable' AND LOWER(VALUE) = 'true' THEN 'ACTIVATED' ELSE 'MODIFIED' END,
      KEY || ' =' || CHAR(32) || CHAR(39) || MAP(VALUE, 'TRUE', 'true', 'FALSE', 'false', VALUE) || CHAR(39),
      MAP(LAYER_NAME, 'HOST', 'host' || CHAR(32) || HOST, 'system-wide') || ' in' || CHAR(32) || FILE_NAME
    FROM
      M_CONFIGURATION_PARAMETER_VALUES
    WHERE
      SECTION = 'performance_analyzer' AND
      LAYER_NAME != 'DEFAULT'
  )
  UNION ALL
  ( SELECT DISTINCT
      'Python trace',
      CASE WHEN KEY = 'trace' AND LOWER(VALUE) = 'true' THEN 'ACTIVATED' ELSE 'MODIFIED' END,
      KEY || ' =' || CHAR(32) || CHAR(39) || MAP(VALUE, 'TRUE', 'true', 'FALSE', 'false', VALUE) || CHAR(39),
      MAP(LAYER_NAME, 'HOST', 'host' || CHAR(32) || HOST, 'system-wide') || ' in' || CHAR(32) || FILE_NAME
    FROM
      M_CONFIGURATION_PARAMETER_VALUES
    WHERE
      SECTION = 'pythontrace' AND
      LAYER_NAME != 'DEFAULT'
  )
  UNION ALL
  ( SELECT DISTINCT
      'Client network trace',
      CASE WHEN KEY = 'enabled' AND LOWER(VALUE) = 'true' THEN 'ACTIVATED' ELSE 'MODIFIED' END,
      KEY || ' =' || CHAR(32) || CHAR(39) || MAP(VALUE, 'TRUE', 'true', 'FALSE', 'false', VALUE) || CHAR(39),
      MAP(LAYER_NAME, 'HOST', 'host' || CHAR(32) || HOST, 'system-wide') || ' in' || CHAR(32) || FILE_NAME
    FROM
      M_CONFIGURATION_PARAMETER_VALUES
    WHERE
      SECTION = 'sql_client_network_io' AND
      LAYER_NAME != 'DEFAULT'
  )
  UNION ALL
  ( SELECT DISTINCT
      'Expensive statements trace',
      CASE WHEN KEY = 'enable' AND LOWER(VALUE) = 'true' THEN 'ACTIVATED' ELSE 'MODIFIED' END,
      KEY || ' =' || CHAR(32) || CHAR(39) || MAP(VALUE, 'TRUE', 'true', 'FALSE', 'false', VALUE) || CHAR(39),
      MAP(LAYER_NAME, 'HOST', 'host' || CHAR(32) || HOST, 'system-wide') || ' in' || CHAR(32) || FILE_NAME
    FROM
      M_CONFIGURATION_PARAMETER_VALUES
    WHERE
      SECTION = 'expensive_statement' AND
      LAYER_NAME != 'DEFAULT'
  )
  UNION ALL
  ( SELECT DISTINCT
      'Executed statements trace',
      CASE WHEN KEY = 'enable' AND LOWER(VALUE) = 'true' THEN 'ACTIVATED' ELSE 'MODIFIED' END,
      KEY || ' =' || CHAR(32) || CHAR(39) || MAP(VALUE, 'TRUE', 'true', 'FALSE', 'false', VALUE) || CHAR(39),
      MAP(LAYER_NAME, 'HOST', 'host' || CHAR(32) || HOST, 'system-wide') || ' in' || CHAR(32) || FILE_NAME
    FROM
      M_CONFIGURATION_PARAMETER_VALUES
    WHERE
      SECTION = 'executed_statement' AND
      LAYER_NAME != 'DEFAULT'
  )
  UNION ALL
  ( SELECT DISTINCT
      'Database trace',
      CASE WHEN KEY = 'enabled' AND LOWER(VALUE) = 'true' THEN 'ACTIVATED' ELSE 'MODIFIED' END,
      KEY || ' =' || CHAR(32) || CHAR(39) || MAP(VALUE, 'TRUE', 'true', 'FALSE', 'false', VALUE) || CHAR(39),
      MAP(LAYER_NAME, 'HOST', 'host' || CHAR(32) || HOST, 'system-wide') || ' in' || CHAR(32) || FILE_NAME
    FROM
      M_CONFIGURATION_PARAMETER_VALUES
    WHERE
      SECTION = 'trace' AND
      LAYER_NAME != 'DEFAULT'
  )
  UNION ALL
  ( SELECT DISTINCT
      'User-specific trace',
      CASE WHEN KEY = 'enabled' AND LOWER(VALUE) = 'true' THEN 'ACTIVATED' ELSE 'MODIFIED' END,
      KEY || ' =' || CHAR(32) || CHAR(39) || MAP(VALUE, 'TRUE', 'true', 'FALSE', 'false', VALUE) || CHAR(39),
      MAP(LAYER_NAME, 'HOST', 'host' || CHAR(32) || HOST, 'system-wide') || ' in' || CHAR(32) || FILE_NAME ||
        CHAR(32) || 'for context' || CHAR(32) || SUBSTR(SECTION, 14) 
    FROM
      M_CONFIGURATION_PARAMETER_VALUES
    WHERE
      SECTION LIKE 'traceprofile%' AND
      SECTION NOT IN ('traceprofile_sap_passport_high', 'traceprofile_sap_passport_medium') AND
      LAYER_NAME != 'DEFAULT'
  )
  UNION ALL
  ( SELECT DISTINCT
      'End-to-end trace',
      CASE WHEN KEY = 'enabled' AND LOWER(VALUE) = 'true' THEN 'ACTIVATED' ELSE 'MODIFIED' END,
      KEY || ' =' || CHAR(32) || CHAR(39) || MAP(VALUE, 'TRUE', 'true', 'FALSE', 'false', VALUE) || CHAR(39),
      MAP(LAYER_NAME, 'HOST', 'host' || CHAR(32) || HOST, 'system-wide') || ' in' || CHAR(32) || FILE_NAME ||
        CHAR(32) || 'for' || CHAR(32) || SUBSTR(SECTION, 14) 
    FROM
      M_CONFIGURATION_PARAMETER_VALUES
    WHERE
      SECTION IN ('traceprofile_sap_passport_high', 'traceprofile_sap_passport_medium') AND
      LAYER_NAME != 'DEFAULT'
  )
  UNION ALL
  ( SELECT DISTINCT
      'Load trace',
      CASE WHEN KEY = 'enable' AND LOWER(VALUE) = 'true' THEN 'ACTIVATED' ELSE 'MODIFIED' END,
      KEY || ' =' || CHAR(32) || CHAR(39) || MAP(VALUE, 'TRUE', 'true', 'FALSE', 'false', VALUE) || CHAR(39),
      MAP(LAYER_NAME, 'HOST', 'host' || CHAR(32) || HOST, 'system-wide') || ' in' || CHAR(32) || FILE_NAME
    FROM
      M_CONFIGURATION_PARAMETER_VALUES
    WHERE
      SECTION = 'load_trace' AND
      LAYER_NAME != 'DEFAULT'
  )
  UNION ALL
  ( SELECT DISTINCT
      'Unload trace',
      CASE WHEN KEY = 'enable' AND LOWER(VALUE) = 'true' THEN 'ACTIVATED' ELSE 'MODIFIED' END,
      KEY || ' =' || CHAR(32) || CHAR(39) || MAP(VALUE, 'TRUE', 'true', 'FALSE', 'false', VALUE) || CHAR(39),
      MAP(LAYER_NAME, 'HOST', 'host' || CHAR(32) || HOST, 'system-wide') || ' in' || CHAR(32) || FILE_NAME
    FROM
      M_CONFIGURATION_PARAMETER_VALUES
    WHERE
      SECTION = 'unload_trace' AND
      LAYER_NAME != 'DEFAULT'
  )
  UNION ALL
  ( SELECT DISTINCT
      'Resource tracking',
      CASE 
        WHEN KEY = 'enable_tracking'                         AND LOWER(VALUE) = 'true'   THEN 'ACTIVATED'
        WHEN KEY = 'memory_tracking'                         AND LOWER(VALUE) = 'true'   THEN 'ACTIVATED' 
        ELSE 'MODIFIED' 
      END,
      KEY || ' =' || CHAR(32) || CHAR(39) || MAP(VALUE, 'TRUE', 'true', 'FALSE', 'false', VALUE) || CHAR(39),
      MAP(LAYER_NAME, 'HOST', 'host' || CHAR(32) || HOST, 'system-wide') || ' in' || CHAR(32) || FILE_NAME
    FROM
      M_CONFIGURATION_PARAMETER_VALUES
    WHERE
      SECTION = 'resource_tracking' AND
      LAYER_NAME != 'DEFAULT' AND
      KEY IN ('enable_tracking', 'memory_tracking')
  )
  UNION ALL
  ( SELECT DISTINCT
      'Load history',
      'MODIFIED',
      KEY || ' =' || CHAR(32) || CHAR(39) || MAP(VALUE, 'TRUE', 'true', 'FALSE', 'false', VALUE) || CHAR(39),
      MAP(LAYER_NAME, 'HOST', 'host' || CHAR(32) || HOST, 'system-wide') || ' in' || CHAR(32) || FILE_NAME
    FROM
      M_CONFIGURATION_PARAMETER_VALUES
    WHERE
      SECTION = 'resource_tracking' AND
      KEY like 'load_monitor%' AND
      LAYER_NAME != 'DEFAULT'
  )
  UNION ALL
  ( SELECT DISTINCT
      'Web Dispatcher HTTP trace',
      'MODIFIED',
      KEY || ' =' || CHAR(32) || CHAR(39) || MAP(VALUE, 'TRUE', 'true', 'FALSE', 'false', VALUE) || CHAR(39),
      MAP(LAYER_NAME, 'HOST', 'host' || CHAR(32) || HOST, 'system-wide') || ' in' || CHAR(32) || FILE_NAME
    FROM
      M_CONFIGURATION_PARAMETER_VALUES
    WHERE
    ( FILE_NAME = 'xsengine.ini' AND SECTION = 'customer_usage' AND LAYER_NAME != 'DEFAULT' OR
      FILE_NAME = 'webdispatcher.ini' AND SECTION = 'profile' AND KEY = 'icm/HTTP/logging_n' AND LAYER_NAME != 'DEFAULT'
    )
  )
  UNION ALL
  ( SELECT DISTINCT
      'Service thread sampling',
      'MODIFIED',
      KEY || ' =' || CHAR(32) || CHAR(39) || MAP(VALUE, 'TRUE', 'true', 'FALSE', 'false', VALUE) || CHAR(39),
      MAP(LAYER_NAME, 'HOST', 'host' || CHAR(32) || HOST, 'system-wide') || ' in' || CHAR(32) || FILE_NAME
    FROM
      M_CONFIGURATION_PARAMETER_VALUES
    WHERE
      SECTION = 'resource_tracking' AND
      KEY like 'service_thread_sampling%' AND
      LAYER_NAME != 'DEFAULT'
  )
  UNION ALL
  ( SELECT
      *
    FROM
    ( SELECT
        'Thread loop' TRACE_TYPE,
        'ACTIVATED' ADJUSTMENT_TYPE,
        TO_DECIMAL(SUM(FILE_SIZE) / 1024 / 1024, 10, 2) || ' MB traces generated within last day' DETAILS,
        '' CONTEXT
      FROM
        M_TRACEFILES
      WHERE
        FILE_NAME LIKE 'thrloop%' AND
        SECONDS_BETWEEN(FILE_MTIME, CURRENT_TIMESTAMP) <= 86400
    )
    WHERE
      DETAILS IS NOT NULL
  )
  UNION ALL
  ( SELECT
      'Memory profiler trace' TRACE_TYPE,
      'ACTIVATED' ADJUSTMENT_TYPE,
      COUNT(*) || ' active trace(s)' DETAILS,
      'host' || CHAR(32) || HOST || ' and port' || CHAR(32) || PORT CONTEXT
    FROM 
      M_MEMORY_PROFILER
    GROUP BY
      HOST,
      PORT
  )
) T
WHERE
  ( ( BI.ACTIVATED_TRACES           = 'X' AND T.ADJUSTMENT_TYPE = 'ACTIVATED' ) OR
    ( BI.MODIFIED_TRACES            = 'X' AND T.ADJUSTMENT_TYPE = 'MODIFIED' ) 
  ) AND
  ( ( BI.CLIENT_NETWORK_TRACE       = 'X' AND T.TRACE_TYPE = 'Client network trace'       ) OR
    ( BI.CPU_TIME_MEASUREMENT       = 'X' AND T.TRACE_TYPE = 'CPU time measurement'       ) OR
    ( BI.DATABASE_TRACE             = 'X' AND T.TRACE_TYPE = 'Database trace'             ) OR
    ( BI.END_TO_END_TRACE           = 'X' AND T.TRACE_TYPE = 'End-to-end trace'           ) OR
    ( BI.EXECUTED_STATEMENTS_TRACE  = 'X' AND T.TRACE_TYPE = 'Executed statements trace'  ) OR
    ( BI.EXPENSIVE_STATEMENTS_TRACE = 'X' AND T.TRACE_TYPE = 'Expensive statements trace' ) OR
    ( BI.FUNCTION_PROFILER          = 'X' AND T.TRACE_TYPE = 'Function profiler'          ) OR
    ( BI.HTTP_TRACE                 = 'X' AND T.TRACE_TYPE = 'Web Dispatcher HTTP trace'  ) OR
    ( BI.KERNEL_PROFILER_TRACE      = 'X' AND T.TRACE_TYPE = 'Kernel profiler trace'      ) OR
    ( BI.LOAD_HISTORY               = 'X' AND T.TRACE_TYPE = 'Load history'               ) OR
    ( BI.LOAD_TRACE                 = 'X' AND T.TRACE_TYPE = 'Load trace'                 ) OR
    ( BI.PERFORMANCE_TRACE          = 'X' AND T.TRACE_TYPE = 'Performance trace'          ) OR
    ( BI.PLAN_VIZ_PLAN_TRACE        = 'X' AND T.TRACE_TYPE = 'PlanViz / plan trace'       ) OR
    ( BI.PYTHON_TRACE               = 'X' AND T.TRACE_TYPE = 'Python trace'               ) OR
    ( BI.RESOURCE_TRACKING          = 'X' AND T.TRACE_TYPE = 'Resource tracking'          ) OR
    ( BI.SQLSCRIPT_PLAN_PROFILER    = 'X' AND T.TRACE_TYPE = 'SQLScript plan profiler'    ) OR
    ( BI.SQL_TRACE                  = 'X' AND T.TRACE_TYPE = 'SQL trace'                  ) OR
    ( BI.THREAD_LOOP                = 'X' AND T.TRACE_TYPE = 'Thread loop'                ) OR
    ( BI.THREAD_SAMPLING            = 'X' AND T.TRACE_TYPE = 'Service thread sampling'    ) OR
    ( BI.UNLOAD_TRACE               = 'X' AND T.TRACE_TYPE = 'Unload trace'               ) OR
    ( BI.USER_SPECIFIC_TRACE        = 'X' AND T.TRACE_TYPE = 'User-specific trace'        ) OR
    ( BI.MEMORY_PROFILER            = 'X' AND T.TRACE_TYPE = 'Memory profiler trace'      )
  )
ORDER BY
  T.TRACE_TYPE,
  T.ADJUSTMENT_TYPE,
  T.DETAILS
