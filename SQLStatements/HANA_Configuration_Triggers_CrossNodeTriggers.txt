WITH 

/* 

[NAME]

- HANA_Configuration_Triggers_CrossNodeTriggers

[DESCRIPTION]

- Triggers with dependent tables located on different scale-out nodes

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]


[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2018/02/23:  1.0 (initial version)
- 2018/04/26:  1.1 (correction of wrong filter logic)
- 2023/03/13:  1.2 (EXCLUDE_TABLES_WITH_REPLICAS included)

[INVOLVED TABLES]

- M_CS_TABLES
- OBJECT_DEPENDENCIES
- TABLE_REPLICAS

[INPUT PARAMETERS]

- TRIGGER_NAME

  Trigger name

  'MYTRIG'        --> Trigger MYTRIG
  '/1LT/%'        --> Triggers starting with '/1LT/'
  '%'             --> No restriction related to trigger name

- EXCLUDE_TABLES_WITH_REPLICAS

  Possibility to exclude tables using table replication

  'X'             --> Only consider tables without table replication
  ' '             --> Consider all tables (may report cross node triggers although replica is local)

[OUTPUT PARAMETERS]

- TRIGGER_SCHEMA: Trigger schema
- TRIGGER_NAME:   Trigger name
- TABLE_LIST:     List of related tables (and hosts)

[EXAMPLE OUTPUT]

-----------------------------------------------------------------------------------------------------
|TRIGGER_SCHEMA |TRIGGER_NAME                      |TABLE_LIST                                      |
-----------------------------------------------------------------------------------------------------
|TEST123        |_SYS_TRIGGER_REF_INS_6251598_#0_# |BRAND (hana000), PRODUCT (hana001)              |
|TEST123        |_SYS_TRIGGER_REF_UPD_6251598_#0_# |BRAND (hana000), PRODUCT (hana001)              |
|TEST123        |_SYS_TRIGGER_RUL_UPD_6251598_#0_# |BRAND (hana000), PRODUCT (hana001)              |
|TEST123        |_SYS_TRIGGER_RUL_DEL_6251598_#0_# |BRAND (hana000), PRODUCT (hana001)              |
|TEST123        |_SYS_TRIGGER_REF_INS_6251618_#0_# |COUNTRY_OF_PRODUCT (hana000), PRODUCT (hana001) |
|TEST123        |_SYS_TRIGGER_REF_UPD_6251618_#0_# |COUNTRY_OF_PRODUCT (hana000), PRODUCT (hana001) |
|TEST123        |_SYS_TRIGGER_RUL_UPD_6251618_#0_# |COUNTRY_OF_PRODUCT (hana000), PRODUCT (hana001) |
|TEST123        |_SYS_TRIGGER_RUL_DEL_6251618_#0_# |COUNTRY_OF_PRODUCT (hana000), PRODUCT (hana001) |
-----------------------------------------------------------------------------------------------------

*/

BASIS_INFO AS
( SELECT                    /* Modification section */
    '%' TRIGGER_NAME,
    'X' EXCLUDE_TABLES_WITH_REPLICAS
  FROM
    DUMMY
)
SELECT
  T.TRIGGER_SCHEMA,
  T.TRIGGER_NAME,
  T.TABLE_LIST
FROM
( SELECT
    TR.TRIGGER_SCHEMA,
    TR.TRIGGER_NAME,
    STRING_AGG(T.TABLE_NAME || CHAR(32) || '(' || T.HOST || ')', ',' || CHAR(32) ORDER BY T.TABLE_NAME) TABLE_LIST
  FROM
  ( SELECT          /* List of triggers with base objects on multiple hosts */
      TRIGGER_SCHEMA,
      TRIGGER_NAME
    FROM
    ( SELECT
        MIN(T.HOST) HOST_1,
        MAX(T.HOST) HOST_2,
        OD.DEPENDENT_SCHEMA_NAME TRIGGER_SCHEMA,
        OD.DEPENDENT_OBJECT_NAME TRIGGER_NAME
      FROM
        BASIS_INFO BI,
        OBJECT_DEPENDENCIES OD,
        M_CS_TABLES T
      WHERE
        OD.DEPENDENT_OBJECT_TYPE = 'TRIGGER' AND
        OD.BASE_OBJECT_TYPE = 'TABLE' AND
        T.SCHEMA_NAME = OD.BASE_SCHEMA_NAME AND
        T.TABLE_NAME = OD.BASE_OBJECT_NAME AND
        OD.DEPENDENT_OBJECT_NAME LIKE BI.TRIGGER_NAME AND
        ( BI.EXCLUDE_TABLES_WITH_REPLICAS = ' ' OR
          NOT EXISTS (SELECT 1 FROM TABLE_REPLICAS R WHERE R.SCHEMA_NAME = T.SCHEMA_NAME AND R.SOURCE_TABLE_NAME = T.TABLE_NAME )
        )
      GROUP BY
        DEPENDENT_SCHEMA_NAME,
        DEPENDENT_OBJECT_NAME
    )
    WHERE
      HOST_1 != HOST_2
  ) TR,
    OBJECT_DEPENDENCIES OD,
    M_CS_TABLES T
  WHERE
    OD.DEPENDENT_SCHEMA_NAME = TR.TRIGGER_SCHEMA AND
    OD.DEPENDENT_OBJECT_NAME = TR.TRIGGER_NAME AND
    OD.DEPENDENT_OBJECT_TYPE = 'TRIGGER' AND
    OD.BASE_OBJECT_TYPE = 'TABLE' AND
    T.SCHEMA_NAME = OD.BASE_SCHEMA_NAME AND
    T.TABLE_NAME = OD.BASE_OBJECT_NAME
  GROUP BY
    TR.TRIGGER_SCHEMA,
    TR.TRIGGER_NAME
) T