SELECT
/* 

[NAME]

- HANA_BankAnalyzer_IndexConsistency

[DESCRIPTION]

- Checks if specific BankAnalyzer indexes defined on ABAP side are consistent with the indexes on database side

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- "invalid schema name" error will happen if SQL statement is not started in the Bank Analyzer schema. You can prefix the
  table names in the SQL statement with the schema name or execute "set schema <ba_schema>" before executing this
  SQL statement.

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2014/12/04:  1.0 (initial version)

[INVOLVED TABLES]

- /BA1/THM_TPIX_CH
- /BA1/THM_AREAT
- /BA1/HM_GEN_OBJ

[INPUT PARAMETERS]

- INDEX_NAME

  Index name or pattern

  'EDIDC~1'       --> Specific index EDIDC~1
  '%~2'           --> All indexes ending with '~2'
  '%'             --> All indexes
 
[OUTPUT PARAMETERS]

- AREA:              Area
- DESCRIPTION:       Description
- TYPE:              Table type
- FLOW_TABLE_NAME:   Flow table name
- INDEXID:           Index identifier
- INDEX_NAME_ON_DB:  Index name on database side
- COLUMN:            Column name
- COLUMN_NAME_ON_DB: Column name on database side (empty if not available)
- POSITION:          Column position in index
- POSITION_ON_DB:    Column position in index on database side (empty if not available)
- STATUS:            Status of database index (OK -> consistent with ABAP, NOT OKAY -> not consistent with ABAP)

[EXAMPLE OUTPUT]

AREA   |DESCRIPTION             |TYPE  |FLOW_TABLE_NAME |INDEXID|INDEX_NAME_ON_DB  |COLUMN         |COLUMN_NAME_ON_DB|POSITION|POSITION_ON_DB|STATUS  

CHGB_BA|Ergebnisdatenbereich HGB|CHGB_F|/1BA/HM_1SJF_100|Z1     |/1BA/HM_1SJF_100Z1|/BA1/C55BT_ID  |/BA1/C55BT_ID    |0001    |1             |OK      
       |                        |      |                |Z2     |/1BA/HM_1SJF_100Z2|VERSION_GUID   |VERSION_GUID     |0001    |1             |OK      
       |                        |      |                |Z3     |/1BA/HM_1SJF_100Z3|/BA1/C4AAGO    |/BA1/C4AAGO      |0001    |1             |OK      
       |                        |      |                |Z4     |/1BA/HM_1SJF_100Z4|/BA1/C55AEID   |/BA1/C55AEID     |0001    |1             |OK      
       |                        |      |                |Z5     |/1BA/HM_1SJF_100Z5|/BA1/C40FTRAN  |/BA1/C40FTRAN    |0001    |1             |OK      
       |                        |      |                |Z6     |/1BA/HM_1SJF_100Z6|/BA1/C41FINST  |/BA1/C41FINST    |0001    |1             |OK      
       |                        |      |                |Z7     |/1BA/HM_1SJF_100Z7|/1FB/GL_ACCOUNT|                 |0001    |              |NOT OKAY
       |                        |      |                |Z8     |/1BA/HM_1SJF_100Z8|/BIC/CNET_ID   |/BIC/CNET_ID     |0001    |1             |OK      

*/

  MAP(ROW_NUMBER () OVER (PARTITION BY BA_INDEX_DEF.AREA, BA_AREA_TEXT.DESCRIPTION ORDER BY BA_INDEX_DEF.INDEX_POSITION), 1, BA_INDEX_DEF.AREA,         ' ') AREA,
  MAP(ROW_NUMBER () OVER (PARTITION BY BA_INDEX_DEF.AREA, BA_AREA_TEXT.DESCRIPTION ORDER BY BA_INDEX_DEF.INDEX_POSITION), 1, BA_AREA_TEXT.DESCRIPTION , ' ') DESCRIPTION,
  MAP(ROW_NUMBER () OVER (PARTITION BY BA_INDEX_DEF.AREA, BA_AREA_TEXT.DESCRIPTION, BA_INDEX_DEF.TYPE ORDER BY BA_INDEX_DEF.INDEX_POSITION), 1, BA_INDEX_DEF.TYPE , ' ') TYPE,
  MAP(ROW_NUMBER () OVER (PARTITION BY BA_INDEX_DEF.AREA, BA_AREA_TEXT.DESCRIPTION, BA_INDEX_DEF.TYPE ORDER BY BA_INDEX_DEF.INDEX_POSITION), 1,  BA_TABLE_DEF.DATA_TABLE , ' ') FLOW_TABLE_NAME,
  MAP(ROW_NUMBER () OVER (PARTITION BY BA_INDEX_DEF.AREA, BA_AREA_TEXT.DESCRIPTION, BA_INDEX_DEF.TYPE, BA_INDEX_DEF.INDEXID ORDER BY BA_INDEX_DEF.INDEX_POSITION), 1, BA_INDEX_DEF.INDEXID , ' ')INDEXID, IDX.INDEX_NAME INDEX_NAME_ON_DB,
  BA_INDEX_DEF.CHARACTERISTIC COLUMN,
  IDX_CLMN.COLUMN_NAME COLUMN_NAME_ON_DB,
  BA_INDEX_DEF.INDEX_POSITION POSITION,
  IDX_CLMN.POSITION POSITION_ON_DB,
  CASE WHEN ( TO_INTEGER (BA_INDEX_DEF.INDEX_POSITION) = IDX_CLMN.POSITION ) THEN 'OK' ELSE 'NOT OKAY' END STATUS  
FROM 
  sapsr3."/BA1/THM_TPIX_CH" BA_INDEX_DEF INNER JOIN
( SELECT   /* DESCRIPTION IN GERMAN OR ENGLISH */
    AREA,
    STRING_AGG( DESCRIPTION ) DESCRIPTION
   FROM 
     "/BA1/THM_AREAT" 
   WHERE 
     LANGU IN ( 'D' , 'E' )
   GROUP BY AREA
) BA_AREA_TEXT ON 
    BA_INDEX_DEF.AREA = BA_AREA_TEXT.AREA INNER JOIN 
  sapsr3."/BA1/HM_GEN_OBJ" BA_TABLE_DEF ON 
    BA_INDEX_DEF.AREA = BA_TABLE_DEF.AREA AND
    BA_INDEX_DEF.TYPE = BA_TABLE_DEF.OBJECT_NAME INNER JOIN
( SELECT                             /* Modification section */
    '%' INDEX_NAME
  FROM
    DUMMY
) BI ON
    CONCAT(BA_TABLE_DEF.DATA_TABLE, BA_INDEX_DEF.INDEXID) LIKE BI.INDEX_NAME LEFT OUTER JOIN 
  INDEXES IDX ON 
    IDX.INDEX_NAME = CONCAT( BA_TABLE_DEF.DATA_TABLE, BA_INDEX_DEF.INDEXID ) LEFT OUTER JOIN 
  INDEX_COLUMNS IDX_CLMN ON 
    IDX_CLMN.INDEX_NAME = CONCAT( BA_TABLE_DEF.DATA_TABLE, BA_INDEX_DEF.INDEXID ) AND
    IDX_CLMN.COLUMN_NAME = BA_INDEX_DEF.CHARACTERISTIC
ORDER BY 
  BA_INDEX_DEF.AREA, 
  BA_AREA_TEXT.DESCRIPTION,
  BA_INDEX_DEF.TYPE,
  BA_INDEX_DEF.INDEXID,
  BA_INDEX_DEF.INDEX_POSITION
 