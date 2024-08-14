SELECT
/* 

[NAME]

- HANA_Memory_PlanningEngine_2.00.036+

[DESCRIPTION]

- Show current planning engine memory consumption

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Memory is allocated in Pool/PlanningEngine/* allocators like Pool/PlanningEngine/LookupDict
- Accessing M_PLE_RUNTIME_OBJECTS can result in a crash with SAP HANA <= 2.00.047 when certain FOX functionality is active in parallel (SAP Note 2937241)

[VALID FOR]

- Revisions:              >= 2.00.036

[SQL COMMAND VERSION]

- 2015/05/01:  1.0 (initial version)
- 2016/12/31:  1.1 (TIME_AGGREGATE_BY = 'TS<seconds>' included)
- 2017/10/27:  1.2 (TIMEZONE included)
- 2018/11/27:  1.3 (ORDER_BY included)
- 2019/11/27:  1.4 (dedicated public version)

[INVOLVED TABLES]

- M_PLE_RUNTIME_OBJECTS

[INPUT PARAMETERS]

- TIMEZONE

  Used timezone (both for input and output parameters)

  'SERVER'       --> Display times in SAP HANA server time
  'UTC'          --> Display times in UTC time

- HOST

  Host name

  'saphana01'     --> Specic host saphana01
  'saphana%'      --> All hosts starting with saphana
  '%'             --> All hosts

- PORT

  Port number

  '30007'         --> Port 30007
  '%03'           --> All ports ending with '03'
  '%'             --> No restriction to ports

- SERVICE_NAME

  Service name

  'indexserver'   --> Specific service indexserver
  '%server'       --> All services ending with 'server'
  '%'             --> All services  

- OBJECT_TYPE

  Planning object type

  'LOOKUP DICTIONARY' --> Objects of type LOOKUP_DICTIONARY
  '%'                 --> No restriction related to object type

- AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'TIME'          --> Aggregation by time
  'HOST, PORT'    --> Aggregation by host and port
  'NONE'          --> No aggregation

- TIME_AGGREGATE_BY

  Aggregation criteria (possible values can be found in comment)

  'HOUR'          --> Aggregation by hour
  'YYYY/WW'       --> Aggregation by calendar week
  'TS<seconds>'   --> Time slice aggregation based on <seconds> seconds
  'NONE'          --> No aggregation

[OUTPUT PARAMETERS]

- CREATE_TIME:    Creation time
- HOST:           Host name
- PORT:           Port name
- SERVICE:        Service name
- MEM_SIZE_MB:    Used memory (MB)
- ENTRY_COUNT:    Entry count
- OBJECT_TYPE:    Object type
- OBJECT_SCOPE:   Object scope
- OBJECT_NAME:    Planning object name
- SOURCE_COLUMNS: Source columns

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------------
|CREATE_TIME  |HOST|PORT |MEM_SIZE_MB|ENTRY_COUNT|OBJECT_TYPE      |OBJECT_SCOPE|OBJECT_NAME|SOURCE_COLUMNS|
------------------------------------------------------------------------------------------------------------
|2015/03/30 08|any |  any|       3.22|      30329|LOOKUP DICTIONARY|any         |any        |any           |
|2015/03/30 09|any |  any|       0.86|    3212290|LOOKUP DICTIONARY|any         |any        |any           |
|2015/03/30 10|any |  any|       6.45|      62925|LOOKUP DICTIONARY|any         |any        |any           |
|2015/03/30 11|any |  any|       1.91|    1308295|LOOKUP DICTIONARY|any         |any        |any           |
|2015/03/30 12|any |  any|       0.84|     913893|LOOKUP DICTIONARY|any         |any        |any           |
|2015/03/30 13|any |  any|       0.34|    1385000|LOOKUP DICTIONARY|any         |any        |any           |
|2015/03/30 14|any |  any|       0.36|     512313|LOOKUP DICTIONARY|any         |any        |any           |
|2015/03/30 15|any |  any|       3.02|     869088|LOOKUP DICTIONARY|any         |any        |any           |
|2015/03/30 16|any |  any|       9.48|      88465|LOOKUP DICTIONARY|any         |any        |any           |
|2015/03/31 03|any |  any|      38.79|    3335858|LOOKUP DICTIONARY|any         |any        |any           |
------------------------------------------------------------------------------------------------------------

*/

  CREATE_TIME,
  HOST,
  LPAD(PORT, 5) PORT,
  SERVICE_NAME SERVICE,
  LPAD(NUM_OBJECTS, 11) NUM_OBJECTS,
  LPAD(TO_DECIMAL(MEM_SIZE_MB, 10, 2), 11) MEM_SIZE_MB,
  LPAD(ENTRY_COUNT, 11) ENTRY_COUNT,
  OBJECT_TYPE,
  OBJECT_SCOPE,
  OBJECT_NAME,
  SOURCE_COLUMNS
FROM
( SELECT
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.CREATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.CREATE_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.CREATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.CREATE_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END CREATE_TIME,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')    != 0 THEN P.HOST             ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                 END HOST,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(P.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                 END PORT,    
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE') != 0 THEN S.SERVICE_NAME     ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME) END SERVICE_NAME,    
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TYPE')    != 0 THEN P.OBJECT_TYPE      ELSE MAP(BI.OBJECT_TYPE, '%', 'any', BI.OBJECT_TYPE)   END OBJECT_TYPE,    
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCOPE')   != 0 THEN P.OBJECT_SCOPE     ELSE 'any'                                             END OBJECT_SCOPE,    
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'NAME')    != 0 THEN P.OBJECT_NAME      ELSE 'any'                                             END OBJECT_NAME,    
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COLUMNS') != 0 THEN P.SOURCE_COLUMNS   ELSE 'any'                                             END SOURCE_COLUMNS,
    SUM(P.MEMORY_SIZE) / 1024 / 1024 MEM_SIZE_MB,
    SUM(P.ENTRY_COUNT) ENTRY_COUNT,
    COUNT(*) NUM_OBJECTS,
    BI.ORDER_BY
  FROM
  ( SELECT
      HOST,
      PORT,
      TIMEZONE,
      SERVICE_NAME,
      OBJECT_TYPE,
      AGGREGATE_BY,
      MAP(TIME_AGGREGATE_BY,
        'NONE',        'YYYY/MM/DD HH24:MI:SS.FF3',
        'HOUR',        'YYYY/MM/DD HH24',
        'DAY',         'YYYY/MM/DD (DY)',
        'HOUR_OF_DAY', 'HH24',
        TIME_AGGREGATE_BY ) TIME_AGGREGATE_BY,
      ORDER_BY
    FROM
    ( SELECT                    /* Modification section */
        'SERVER' TIMEZONE,                              /* SERVER, UTC */
        '%' HOST,
        '%' PORT,
        '%' SERVICE_NAME,
        'LOOKUP DICTIONARY' OBJECT_TYPE,
        'NONE' AGGREGATE_BY,           /* HOST, PORT, SERVICE, TIME, TYPE, SCOPE, NAME, COLUMNS and comma-separated combinations, NONE for no aggregation */
        'NONE' TIME_AGGREGATE_BY,             /* HOUR, DAY, HOUR_OF_DAY or database time pattern, TS<seconds> for time slice, NONE for no aggregation */
        'SIZE' ORDER_BY                      /* TIME, SIZE, NAME, OBJECTS, ENTRIES */
      FROM
        DUMMY
    ) 
  ) BI,
    M_SERVICES S,
    M_PLE_RUNTIME_OBJECTS P
  WHERE
    S.HOST LIKE BI.HOST AND
    TO_VARCHAR(S.PORT) LIKE BI.PORT AND
    S.SERVICE_NAME LIKE BI.SERVICE_NAME AND
    P.HOST = S.HOST AND
    P.PORT = S.PORT AND
    P.OBJECT_TYPE LIKE BI.OBJECT_TYPE
  GROUP BY
    CASE 
      WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TIME') != 0 THEN 
        CASE 
          WHEN BI.TIME_AGGREGATE_BY LIKE 'TS%' THEN
            TO_VARCHAR(ADD_SECONDS(TO_TIMESTAMP('2014/01/01 00:00:00', 'YYYY/MM/DD HH24:MI:SS'), FLOOR(SECONDS_BETWEEN(TO_TIMESTAMP('2014/01/01 00:00:00', 
            'YYYY/MM/DD HH24:MI:SS'), CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.CREATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.CREATE_TIME END) / SUBSTR(BI.TIME_AGGREGATE_BY, 3)) * SUBSTR(BI.TIME_AGGREGATE_BY, 3)), 'YYYY/MM/DD HH24:MI:SS')
          ELSE TO_VARCHAR(CASE BI.TIMEZONE WHEN 'UTC' THEN ADD_SECONDS(P.CREATE_TIME, SECONDS_BETWEEN(CURRENT_TIMESTAMP, CURRENT_UTCTIMESTAMP)) ELSE P.CREATE_TIME END, BI.TIME_AGGREGATE_BY)
        END
      ELSE 'any' 
    END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'HOST')    != 0 THEN P.HOST             ELSE MAP(BI.HOST, '%', 'any', BI.HOST)                 END,
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'PORT')    != 0 THEN TO_VARCHAR(P.PORT) ELSE MAP(BI.PORT, '%', 'any', BI.PORT)                 END,    
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SERVICE') != 0 THEN S.SERVICE_NAME     ELSE MAP(BI.SERVICE_NAME, '%', 'any', BI.SERVICE_NAME) END,    
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'TYPE')    != 0 THEN P.OBJECT_TYPE      ELSE MAP(BI.OBJECT_TYPE, '%', 'any', BI.OBJECT_TYPE)   END,    
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'SCOPE')   != 0 THEN P.OBJECT_SCOPE     ELSE 'any'                                             END,    
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'NAME')    != 0 THEN P.OBJECT_NAME      ELSE 'any'                                             END,    
    CASE WHEN BI.AGGREGATE_BY = 'NONE' OR INSTR(BI.AGGREGATE_BY, 'COLUMNS') != 0 THEN P.SOURCE_COLUMNS   ELSE 'any'                                             END,
    BI.ORDER_BY
)
ORDER BY
  MAP(ORDER_BY, 'TIME', CREATE_TIME) DESC,
  MAP(ORDER_BY, 'SIZE', MEM_SIZE_MB, 'OBJECTS', NUM_OBJECTS, 'ENTRIES', ENTRY_COUNT) DESC,
  MAP(ORDER_BY, 'NAME', OBJECT_NAME),
  CREATE_TIME DESC
