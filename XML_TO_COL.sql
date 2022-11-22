/* 

[DESCRIPTION]

- xml to data

*/


drop table clob_str;
create  table clob_str
(id int,
str clob);

select * from clob_str;


   
insert into clob_str

select 1,
'?<?xml version="1.0" encoding="utf-16"?><asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0"><asx:values>
<SOURCE><item><DATA><DATE_FROM>2022-01-01</DATE_FROM>
            <DATE_TO>2022-12-31</DATE_TO>
            <TITLE>Mr</TITLE>
            <NAME1>Mahantesh</NAME1>
            <POST_CODE1>587301</POST_CODE1>
            <STREET>Near Hanuman</STREET>
            <COUNTRY>INDIA</COUNTRY>
            <LANGU>E</LANGU>
            <REGION>Bagalkot</REGION>
         </DATA>
      </item>
</SOURCE>
</asx:values></asx:abap>' xml from dummy;

insert into clob_str
select 2,
'?<?xml version="1.0" encoding="utf-16"?><asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0"><asx:values>
<SOURCE><item><DATA><DATE_FROM>2022-01-01</DATE_FROM>
            <DATE_TO>2022-12-31</DATE_TO>
            <TITLE>Mrs</TITLE>
            <NAME1>Danu</NAME1>
            <POST_CODE1>587301</POST_CODE1>
            <STREET>Near Hanuman</STREET>
            <COUNTRY>INDIA</COUNTRY>
            <LANGU>E</LANGU>
            <REGION>Bagalkot</REGION>
         </DATA>
      </item>
</SOURCE>
</asx:values></asx:abap>' xml from dummy;


WITH XML_DATA AS
    (
       SELECT id,
     str,LOCATE(str,'<DATA>') DATA_START,  LOCATE(str,'</DATA>') DATA_END, LENGTH(str) LEN,
   SUBSTRING(str,LOCATE(str,'<DATA>'),(LOCATE(str,'</DATA>')-LOCATE(str,'<DATA>'))+7) XML_DATA
    FROM  clob_str)
 select  id,   TO_DATE(XMLEXTRACTVALUE(XML_DATA,'/DATA/DATE_FROM')) DATE_FROM, 
   TO_DATE(XMLEXTRACTVALUE(XML_DATA,'/DATA/DATE_TO'))  DATE_TO,
XMLEXTRACTVALUE(XML_DATA,'/DATA/TITLE') TITLE,
  XMLEXTRACTVALUE(XML_DATA,'/DATA/NAME1')  "NAME",
 XMLEXTRACTVALUE(XML_DATA,'/DATA/POST_CODE1') "POST_CODE",
         XMLEXTRACTVALUE(XML_DATA,'/DATA/STREET')  "STREET",
XMLEXTRACTVALUE(XML_DATA,'/DATA/COUNTRY') "COUNTRY",
XMLEXTRACTVALUE(XML_DATA,'/DATA/LANGU')  "LANGU",
XMLEXTRACTVALUE(XML_DATA,'/DATA/REGION')  "REGION"
 from   XML_DATA;
 