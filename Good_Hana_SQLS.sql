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



----TABLE INFO 


SELECT TBL_INFO.TABLE_NAME,TBL_INFO.DESCRIPTION TABLE_DESCRIPTION,COL_INFO.ALL_COLUMNS_DESCRIPTION

FROM
(
SELECT  TABLE_NAME,STRING_AGG(COLUMN_NAME||':'||DESCRIPTION, '
' )  AS ALL_COLUMNS_DESCRIPTION   FROM 
(
SELECT SCHEMA_NAME||'.'||TABLE_NAME TABLE_NAME ,COLUMN_NAME,IFNULL(COMMENTS,'') DESCRIPTION,position

FROM "SYS"."TABLE_COLUMNS"
where SCHEMA_NAME IN (
''
)

order by TABLE_NAME) MM


GROUP BY TABLE_NAME
) COL_INFO
INNER JOIN 

(

SELECT SCHEMA_NAME||'.'||TABLE_NAME TABLE_NAME ,IFNULL(COMMENTS,'') DESCRIPTION 
FROM "SYS"."TABLES"
where SCHEMA_NAME IN (

)

) TBL_INFO

ON (COL_INFO.TABLE_NAME=TBL_INFO.TABLE_NAME)


WHERE TBL_INFO.TABLE_NAME LIKE '_GRP%'

SELECT *
FROM 
	"_SYS_BI"."BIMC_PROPERTIES"
WHERE 
-- CATALOG_NAME LIKE 'SAP%'
  -- AND 
   CUBE_NAME like  '%APO_STAT_GRP_DESC%'
   
   
   SELECT TOP 1000 * FROM "_SYS_REPO"."ACTIVE_OBJECT" 
WHERE OBJECT_SUFFIX = 'calculationview'
and OBJECT_NAME LIKE '%%'
AND PACKAGE_ID='SE';

