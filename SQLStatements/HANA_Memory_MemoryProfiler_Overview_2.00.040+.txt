SELECT

/* 

[NAME]

- HANA_Memory_MemoryProfiler_Overview_2.00.040+

[DESCRIPTION]

- Overview of memory profiler runs

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Memory profiler available for SAP HANA >= 2.00.040

[VALID FOR]

- Revisions:              >= 2.00.040

[SQL COMMAND VERSION]

- 2020/01/08:  1.0 (initial version)

[INVOLVED TABLES]

- M_MEMORY_PROFILER

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

- FILE_NAME

  Memory profiler file name

  '%30001%'       --> Show all memory profiler files with names containing '300001'
  '%'             --> No restriction by file name

- PROFILE_NAME

  Memory profile name

  'MYPROFILE'     --> Ony display memory profile MYPROFILE
  '%'             --> No restriction related to memory profile

- STATUS

  Memory profiler status

  'STARTED'       --> Display only started memory profiler runs
  '%'             --> No restriction related to status

- HAS_CALLSTACKS

  Flag for call stack collection

  'TRUE'          --> Only display memory profiler runs with activated call stack collection
  '%'             --> No restriction related to call stack collection
  
[OUTPUT PARAMETERS]

- ALLOCATE_TIME:  Allocation time
- ALLOCATOR_NAME: Heap allocator name
- SIZE_GB:        Allocation size (GB)

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------------------
|HOST      |PORT |PROFILE_NAME|STATUS |CALLSTACKS|START_TIME         |STOP_TIME|DURATION_S|REMAINING_S|FREQ_MS|SIZE_KB |FILE_NAME                             |
---------------------------------------------------------------------------------------------------------------------------------------------------------------
|saphana001|30001|            |STARTED|FALSE     |2020/01/08 09:28:02|         |       429|           |     10|  843.48|nameserver_saphana001.30001.memory.trc|
---------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  MP.HOST,
  LPAD(MP.PORT, 5) PORT,
  MP.PROFILE_NAME,
  MP.STATUS,
  MP.HAS_CALLSTACKS CALLSTACKS,
  TO_VARCHAR(MP.START_TIME, 'YYYY/MM/DD HH24:MI:SS') START_TIME,
  MAP(MP.STOP_TIME, NULL, '', TO_VARCHAR(MP.STOP_TIME, 'YYYY/MM/DD HH24:MI:SS')) STOP_TIME,
  LPAD(SECONDS_BETWEEN(MP.START_TIME, MAP(MP.STOP_TIME, NULL, CURRENT_TIMESTAMP, MP.STOP_TIME)), 10) DURATION_S,
  LPAD(MAP(MP.REMAINING_SECONDS, NULL, '', TO_VARCHAR(MP.REMAINING_SECONDS)), 11) REMAINING_S,
  LPAD(MP.SAMPLING_INTERVAL, 7) FREQ_MS,
  LPAD(TO_DECIMAL(MP.FILE_SIZE / 1024, 10, 2), 8) SIZE_KB,
  MP.FILE_NAME
FROM
( SELECT                   /* Modification section */
    '%' HOST,
    '%' PORT,
    '%' FILE_NAME,
    '%' PROFILE_NAME,
    '%' STATUS,
    '%' HAS_CALLSTACKS
  FROM
    DUMMY
) BI,
  M_MEMORY_PROFILER MP
WHERE
  MP.HOST LIKE BI.HOST AND
  TO_VARCHAR(MP.PORT) LIKE BI.PORT AND
  MP.FILE_NAME LIKE BI.FILE_NAME AND
  MP.PROFILE_NAME LIKE BI.PROFILE_NAME AND
  MP.STATUS LIKE BI.STATUS AND
  MP.HAS_CALLSTACKS LIKE BI.HAS_CALLSTACKS