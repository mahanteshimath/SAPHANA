WITH 

/* 
[NAME]

- HANA_Online_Partitioning_Monitor_2.00.054+


[DESCRIPTION]

- Displays start time, estimated time of completion and current memory consumption during online table partitioning 

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]
- unified table container considered too big, check base value before start
- monitor log space on your own using e.g. df -k to avoid disk full during partitioning of bigger tables
- estimated end time of partitioning is only based on record count and not including final merge time 
  this final phase may take up to an hour for bigger objects (1 TB e.g.)  

[VALID FOR]

- Revisions:              >= 2.00.040

[SQL COMMAND VERSION]

- 2019/11/26:  1.0 (initial version)
- 2020/03/09:  2.0 restructured 
                    -devision by 0 resolved
                    -modification section provided					
- 2020/03/19:  2.1 estimate for last merge phase added to estimated completion time 
                   devision by 0 resolved, again 
                   dev views removed
- 2021/04/02:  2.2 include PMEM for tempfs/FRO
                   fix wrong number of records for source table and herewith estimated runtime
                   
- 2021/04/19:  2.3 fix new div/0 
                   fix table occurrence in multiple schema 
                   Indicate not running repartition 
                   Make schema selectable
                   Reduce estimated size by estimated start value of unified table container
 
- 2021/04/19:  2.4 List unified table container only for the server on which the table is reorganized statistics_id = '42302' 
                   (Before and current, do not add to statement partitioning memory, since it cannot clearly be linked to the table)
 
- 2021/04/30:  2.5 List unified table container only for the server on which the table is reorganized 
                   (Before and current, do not add to statement partitioning memory, since it cannot clearly be linked to the table)

[INVOLVED TABLES]

- M_CS_TABLES
- M_HEAP_MEMORY
- M_TABLE_LOB_STATISTICS
- M_ACTIVE_STATEMENTS
- M_SERVICE_REPLICATION
- _SYS_STATISTICS.HOST_DELTA_MERGE_STATISTICS

INPUT PARAMETERS]

- TABLE_NAME           

  Table name 

  'T000'          --> Specific table T000

- SCHEMA_NAME           

  Schema name 

  'SAPERP'        --> Specific Schema SAPERP
  '%'             --> All Schemas
  
- HOST

  Host name or pattern
  
  'host234'       --> Specific host host234  
  'h%'            --> All hosts starting with 'h'
  '%'             --> All hosts
  
- PORT   
 
  Port 

  '30003'         --> Specific Port   
  
[OUTPUT PARAMETERS]

- REPLICA_START:                Start of partitioning
- CUR_TIME_STAMP:               Time of execution of monitoring script
- EST_COMPL_TIME:               Estimated time of completion of partitioning based on number of records and last merge phase
- PROGRESS_IN_PERC:             Progress based on number or table records only
- CUR_MEM_FOR_PART_GB:          Memory needed for partitioning consisting of statement_memory, replica memory (main+delta), unified table container
                                Statement memory is typically low ~ < 60GB also for bigger tables
                                High memory consumption results from replica in main and delta
                                Without adjustment to the merge function it might be required to merge the replica manually to avoid high memory consumption
                                For tables with fulltext indexes the statement memory consumption has been noted to be much higher
- REPLAY_BACKLOG_SIZE_GB:       Replay backlog size 
- REP_LAST_MERGE_TIME:          Last merge time of any partition of the replica
- MERGE_COMMAND:                Merge command if needed
- SOURCE_TABLE_NAME:            Table name of table that is being partition from user selection 
- REPLICA_DELTA_GB:             Delta size of replica
- UNIF_TAB_CONT_GB:             Size of unified table container
- STMT_MEM_GB:                  Current value of statement memory for ongoing partitioning
- SOURCE_TABLE_MEM_SIZE_GB:     Current size of table that is being partition from user selection  
- REPLICA_MEM_SIZE_GB:          Current size of replica 
- REPLICA_NAME:                 Name of replica
- REPLICA_RECORD_COUNT:         Number of records in replica  
- SOURCE_RECORD_COUNT:          Number of records in source table

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|REPLICA_START      |CUR_TIME_STAMP     |EST_COMPL_TIME     |PROGRESS_IN_PERC|CUR_MEM_FOR_PART_GB|UTable_Cont_Cur_GB|UTable_Cont_Bef_GB|REPLAY_BACKLOG_SIZE_GB|REP_LAST_MERGE_TIME|MERGE_COMMAND                                                   |SOURCE_SCHEMA_NAME|SOURCE_TABLE_NAME|REPLICA_DELTA_GB|STMT_MEM_GB|SOURCE_TABLE_MEM_SIZE_GB|REPLICA_MEM_SIZE_GB|REPLICA_NAME                          |REPLICA_RECORD_COUNT|SOURCE_RECORD_COUNT|
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|2021-04-20 18:04:45|2021-04-20 18:45:06|2021-04-20 19:25:36|51              |61                 |18                |13                |1                     |2021-04-20 18:44:28|MERGE DELTA OF "SAPERP"."_SYS_OMR_ZARIXSD12#4620693217708682730"|SAPERP            |ZARIXSD12        |14              |1          |34                      |46                 |_SYS_OMR_ZARIXSD12#4620693217708682730|795590439           |1560003552         |
|no replica detected|2021-04-20 18:45:06|null               |null            |null               |null              |null              |1                     |null               |null                                                            |BASIS_OS          |ZARIXSD12        |null            |1          |1                       |null               |null                                  |null                |0                  |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

selection as                   /* Modification section */
( select '%' table_name ,
         '%'          schema_name ,
         '%'          host ,
         '30003'      port   
  from   dummy                                          ) ,   

SOURCE as
            (SELECT  smcs.table_name,
                     smcs.schema_name,
                     smcs.host,
                     smcs.port,
                     (sum(smcs.RAW_RECORD_COUNT_IN_MAIN+ smcs.RAW_RECORD_COUNT_IN_DELTA)) as record_count  , 
                     ceil(sum(smcs.memory_size_in_total/1024/1024/1024)) as heap_memory,
                     ceil(sum(smcs.PERSISTENT_MEMORY_SIZE_IN_TOTAL /1024/1024/1024)) as Pers_memory, 
                     (ceil(sum(smcs.memory_size_in_total/1024/1024/1024)) + ceil(sum(smcs.PERSISTENT_MEMORY_SIZE_IN_TOTAL /1024/1024/1024))) as memory,
                     '1' dj
               FROM  M_CS_TABLES smcs,
                     SELECTION sel
                     
               WHERE smcs.TABLE_NAME like sel.table_name and 
                     smcs.SCHEMA_NAME like sel.schema_name and
                     smcs.host like sel.host
                     
            GROUP BY smcs.table_name,
                     smcs.schema_name,
                     smcs.host,
                     smcs.port ) ,          

REPLICA as  
            (SELECT rmcs.TABLE_NAME, 
                    rmcs.schema_name, 
                    min(rmcs.CREATE_TIME ) as start_time,
                    (sum(rmcs.RAW_RECORD_COUNT_IN_MAIN + rmcs.RAW_RECORD_COUNT_IN_DELTA)) as record_count  , 
                    ceil(sum(rmcs.MEMORY_SIZE_IN_TOTAL/1024/1024/1024)) as heap_memory ,
                    ceil(sum(rmcs.PERSISTENT_MEMORY_SIZE_IN_TOTAL /1024/1024/1024)) as Pers_memory, 
                   (ceil(sum(rmcs.memory_size_in_total/1024/1024/1024)) + ceil(sum(rmcs.PERSISTENT_MEMORY_SIZE_IN_TOTAL /1024/1024/1024))) as memory,
                    ceil(map(sum(rmcs.MEMORY_SIZE_IN_DELTA),0,0,
                             sum(rmcs.MEMORY_SIZE_IN_DELTA)/1024/1024/1024)) as Delta_GB ,
                    substr(max(rmcs.LAST_MERGE_TIME),1,19) as last_merge_time ,
                    '1' dj
               FROM M_CS_TABLES rmcs,
                    SELECTION sel
              WHERE rmcs.TABLE_NAME LIKE '_SYS_OMR_'||Sel.table_name||'%' and 
                    rmcs.SCHEMA_NAME LIKE sel.schema_name
            GROUP BY rmcs.TABLE_NAME,
                     rmcs.schema_name ) ,    

DMERGE as  
            (SELECT ceil (avg (lgst_merges_past_2h_ms)/1000) avg_ltop4_merges_s,
                    '1' dj            
               from
                    (SELECT top 4 dms.execution_time as lgst_merges_past_2h_ms  
                       FROM _SYS_STATISTICS.HOST_DELTA_MERGE_STATISTICS dms,
                            SELECTION sel
                      WHERE SECONDS_BETWEEN(dms.SNAPSHOT_ID,CURRENT_TIMESTAMP) < 17200 and
                            dms.TABLE_NAME LIKE '_SYS_OMR_'||Sel.table_name||'%' and 
                            dms.LAST_ERROR = 0 
                    GROUP BY dms.execution_time
                    ORDER BY dms.execution_time desc            ) ),    

REPLAY as           
            (SELECT ceil(sum(rep.REPLAY_BACKLOG_SIZE)/1024/1024/1024) as Delay_GB ,
                    '1' dj      
               FROM M_SERVICE_REPLICATION rep,
                    SELECTION             sel
              where rep.port like sel.port )   ,

STATEMENT as                    
            (select top 1
                    ceil(mas.ALLOCATED_MEMORY_SIZE/1024/1024/1024) as Alloc_Mem_GB,
                    connection_id as con_id,
                    '1' dj 
             from   m_active_statements mas ,
                    selection sel
             where  upper(mas.statement_string) like '%ALTER%'||sel.table_name||'%PARTITION%' and
                    mas.plan_id = 0  
             order by compiled_time)     
 
select case when ( Replica_Start is null )
              then ('no replica detected')
              else substr( Replica_Start , 1,19)                                            
            end 	                                                            Replica_Start,
       substr( CURRENT_TIMESTAMP , 1,19)                                        Cur_Time_Stamp,
       case when ((Progress_In_Perc = 0) or (Progress_In_Perc is null) or (SECONDS_BETWEEN(Replica_Start, CURRENT_TIMESTAMP)=0)) 
              then null 
              else substr(add_seconds 
                           ( Replica_Start, 
                             ( (100/
                                Progress_In_Perc * 
                                (SECONDS_BETWEEN(Replica_Start, CURRENT_TIMESTAMP))
                                ) + Replica_LTop4_Merges_sec
                              ) 
                            ),1,19
                          )  
            end                                                                 Est_Compl_Time ,
                                                                                Progress_In_Perc,     
                                                                                Cur_Mem_for_Part_GB,
                                                                                UTable_Cont_Cur_GB,
                                                                                UTable_Cont_Bef_GB,
                                                                                Replay_Backlog_Size_GB,
                                                                                Rep_Last_Merge_Time,
       'MERGE DELTA OF '||'"'||Source_Schema_Name||'"."'||Replica_Name||'"' as  Merge_Command,
/*     'ALTER SYSTEM CANCEL SESSION ''' || connection_id || '''' as             Cancel_Command,    */
                                                                                Source_Schema_Name,
                                                                                Source_Table_Name,
                                                                                Replica_Delta_GB,
                                                                                Stmt_Mem_GB,
                                                                                Source_Table_Mem_Size_GB,
                                                                                Replica_Mem_Size_GB,
                                                                                Replica_Name, 
                                                                                Replica_Record_Count ,
                                                                                Source_Record_Count

from 
( 	                             
  select s . schema_name         as Source_Schema_Name,
         s . table_name          as Source_Table_Name,
         s . record_count        as Source_Record_Count,
         s . memory              as Source_Table_Mem_Size_GB,
         r . Start_Time          as Replica_Start,
         r . Last_Merge_Time     as Rep_Last_Merge_Time,
         r . Delta_GB            as Replica_Delta_GB,
         r . memory              as Replica_Mem_Size_GB,
         r . table_name          as Replica_Name, 
         r . record_count        as Replica_Record_Count ,
         d . avg_ltop4_merges_s  as Replica_LTop4_Merges_sec,

         rbl . Delay_GB          as Replay_Backlog_Size_GB,
         stmt . Alloc_Mem_GB     as Stmt_Mem_GB,
         stmt . Con_id           as Connection_id ,
         
         case when (s.record_count = 0 or s.record_count is null)
                then null
                else (ceil(round((r.record_count/s.record_count)*100)))
              end                                                                                                     as Progress_In_Perc, 
        (select to_decimal(EXCLUSIVE_SIZE_IN_USE/1024/1024/1024, 9,0)                                                                       
            FROM   M_HEAP_MEMORY                                                                                                            
            WHERE  HOST = s.host and
                   PORT = s.port and            
                   CATEGORY like 'Pool/PersistenceManager/UnifiedTableContainer' )                                                                           as UTable_Cont_Cur_GB, 
        (select to_decimal(EXCLUSIVE_SIZE_IN_USE / 1024 / 1024 / 1024 ,10,0)
            FROM _SYS_STATISTICS.HOST_HEAP_ALLOCATORS
            WHERE CATEGORY like 'Pool/PersistenceManager/UnifiedTableContainer'  and
                  HOST = s.host and
                  PORT = s.port and
                  SNAPSHOT_ID = (select max( SNAPSHOT_ID)
                                   FROM _SYS_STATISTICS.HOST_HEAP_ALLOCATORS
                                      WHERE CATEGORY like 'Pool/PersistenceManager/UnifiedTableContainer'  and
                                       HOST = s.host and
                                       PORT = s.port and
                                       SNAPSHOT_ID < r.start_time ))                                                                                         as UTable_Cont_Bef_GB,                        
         ceil(r . memory   +                                                    
       	      r . Delta_GB    +                                                 
       	      stmt . Alloc_Mem_GB  
             )                                                                                                        as Cur_Mem_for_Part_GB
 
    from ( ( ( (  
          source as s 
               left outer join replica   as r    on s.dj = r.dj and 
                                                    s.schema_name = r.schema_name )
               left outer join replay    as rbl  on s.dj = rbl.dj )
               left outer join statement as stmt on s.dj = stmt.dj )               
               left outer join dmerge    as d    on s.dj = d.dj )
)
     with hint(IGNORE_PLAN_CACHE) 
	
	
