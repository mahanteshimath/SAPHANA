---ACTIVE_OBJECT
SELECT TOP 1000 * FROM "_SYS_REPO"."ACTIVE_OBJECT" 
WHERE OBJECT_SUFFIX = 'calculationview'
and OBJECT_NAME LIKE '%T024%'
AND PACKAGE_ID='SE';



---ACTIVE_OBJECT
SELECT TOP 1000 * FROM "_SYS_REPO"."INACTIVE_OBJECT" 
WHERE OBJECT_SUFFIX = 'calculationview'
and OBJECT_NAME LIKE '%T024%'
AND PACKAGE_ID='SE'

----OBJECT_HISTORY

SELECT * FROM "_SYS_REPO"."OBJECT_HISTORY" 
WHERE OBJECT_SUFFIX = 'calculationview'
and OBJECT_NAME='MARA'
AND PACKAGE_ID='mmmm' 
ORDER BY VERSION_ID ;




SELECT *
FROM 
	"_SYS_BI"."BIMC_PROPERTIES"
WHERE 
   CATALOG_NAME ='SAPERP.SE16'
   AND CUBE_NAME like  '%MBEW%'






-----SQL query to check running statements/procedures in HANA memory and their memory consumption

select
c.host, c.user_name, c.connection_status, c.transaction_id, s.last_executed_time,
round(s.allocated_memory_size/1024/1024/1024,2) as "Alloc Mem (GB)",
round(s.used_memory_size/1024/1024/1024,2) as "Used Mem (GB)", s.statement_string
from
m_connections c, m_prepared_statements s
where
s.connection_id = c.connection_id and c.connection_status != 'IDLE'
AND s.statement_string LIKE '%STABILIZATION%'
order by
s.allocated_memory_size desc
;

