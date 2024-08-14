SELECT

/* 

[NAME]

- HANA_Configuration_CustomizableFunctionalities_1.00.90+

[DESCRIPTION]

- Overview of enabled / disabled SAP HANA functionalities

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- M_CUSTOMIZABLE_FUNCTIONALITIES available starting SAP HANA 1.00.090

[VALID FOR]

- Revisions:              >= 1.00.090

[SQL COMMAND VERSION]

- 2020/01/01:  1.0 (initial version)

[INVOLVED TABLES]

- M_CUSTOMIZABLE_FUNCTIONALITIES

[INPUT PARAMETERS]

- NAME

  Functionality name

  'AFL'          --> Display details for AFL functionality
  '%'            --> No restriction related to functionality name

- DESCRIPTION

  Functionality description

  'BO Explorer API' --> Only display details for functionality with description 'BO Explorer API'
  '%SAP BW%'        --> Only display details for functionalities with a description containing 'SAP BW'
  '%'               --> No restriction by functionality description

- IS_ENABLED

  Indication if functionality is enabled

  'TRUE'            --> List enabled functionalities
  'FALSE'           --> List disabled functionalities
  '%'               --> No restriction related to enable status
  
[OUTPUT PARAMETERS]

- NAME:        Functionality name
- DESCRIPTION: Functionality description
- IS_ENABLED:  Indication if functionality is enabled (TRUE) or not (FALSE)

[EXAMPLE OUTPUT]

------------------------------------------------------------------------------------------------------------------
|NAME                                               |DESCRIPTION                                      |IS_ENABLED|
------------------------------------------------------------------------------------------------------------------
|BUILTINPROCEDURE.BW_CONVERT_CLASSIC_TO_IMO_CUBE    |Operation of an SAP BW powered by SAP HANA system|TRUE      |
|BUILTINPROCEDURE.BW_F_FACT_TABLE_COMPRESSION       |Operation of an SAP BW powered by SAP HANA system|TRUE      |
|BUILTINPROCEDURE.BW_PRECHECK_ACQUIRE_LOCK          |Operation of an SAP BW powered by SAP HANA system|TRUE      |
|BUILTINPROCEDURE.BW_PRECHECK_ACQUIRE_LOCK_WITH_TYPE|Operation of an SAP BW powered by SAP HANA system|TRUE      |
|BUILTINPROCEDURE.BW_PRECHECK_RELEASE_LOCK          |Operation of an SAP BW powered by SAP HANA system|TRUE      |
------------------------------------------------------------------------------------------------------------------

*/

  F.NAME,
  F.DESCRIPTION,
  F.IS_ENABLED
FROM
( SELECT                    /* Modification section */
    '%' NAME,
    '%' DESCRIPTION,
    '%' IS_ENABLED
  FROM
    DUMMY
) BI,
  M_CUSTOMIZABLE_FUNCTIONALITIES F
WHERE
  F.NAME LIKE BI.NAME AND
  UPPER(F.DESCRIPTION) LIKE UPPER(BI.DESCRIPTION) AND
  F.IS_ENABLED LIKE BI.IS_ENABLED
ORDER BY
  NAME,
  DESCRIPTION