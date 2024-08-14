SELECT

/* 

[NAME]

- HANA_Configuration_Parameters_Properties_2.00.040+

[DESCRIPTION]

- Display SAP HANA parameter properties

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- CONFIGURATION_PARAMETER_PROPERTIES available with SAP HANA >= 2.00.040

[VALID FOR]

- Revisions:              >= 2.00.040

[SQL COMMAND VERSION]

- 2019/05/12:  1.0 (initial version)
- 2019/06/27:  1.1 (DESCRIPTION_LENGTH_TARGET included)
- 2021/07/13:  1.2 (IS_READ_ONLY added)

[INVOLVED TABLES]

- CONFIGURATION_PARAMETER_PROPERTIES

[INPUT PARAMETERS]

- FILE_NAMES

  File name(s)

  'global.ini'    --> File with name global.ini
  '%'             --> All files

- SECTION

  Parameter file section

  'joins'         --> Specific parameter file section 'joins'
  'stat%'         --> All parameter file sections starting with 'stat'
  '%'             --> All parameter file sections

- PARAMETER_NAME

  Parameter name

  'enable'        --> Parameters with name 'enable'
  'unload%'       --> Parameters starting with 'unload'
  '%'             --> All parameters

- DEFAULT_VALUE

  Parameter default value

  '3600'          --> Display parameters with default value 3600
  '%'             --> No restriction related to default value

- UNIT

  Parameter unit

  'Megabyte'      --> Display parameters with value unit Megabyte
  '%'             --> No restriction related to parameter value unit

- DESCRIPTION

  Parameter description

  '%concur%'      --> Display parameters with description containing 'concur'
  '%'             --> No restriction related to parameter description

- DESCRIPTION_LENGTH_TARGET

  Target for description line length

  80              --> Wrap description after around 80 characters
  -1              --> Do not wrap description

- DATA_TYPE

  Data type of parameter value

  'INTEGER'       --> Display parameters with data type INTEGER
  '%'             --> No restriction related to data type

- RESTART_REQUIRED

  Filtering parameters based on required restart

  'TRUE'          --> Display parameters that require a restart so that changes become active
  'FALSE'         --> Display online parameters that do not require a restart in order to activate changes
  '%'             --> No limitation related to restart requirements

- LAYER_RESTRICTIONS

  Parameter layer restrictions

  'SYSTEM'        --> Display parameters that can only be set on SYSTEM layer
  '%'             --> No restriction related to parameter layer

- IS_READ_ONLY

  Restriction to read only / read write parameters

  'TRUE'          --> Only display read only parameters
  'FALSE'         --> Only display modifiable parameters
  '%'             --> No limitation related to modifiability of parameters

[OUTPUT PARAMETERS]

- FILE_NAMES:         Parameter (ini) file name(s)
- SECTION:            Parameter section
- PARAMETER_NAME:     Parameter name
- DESCRIPTION:        Parameter description
- DEFAULT_VALUE:      Parameter default value
- UNIT:               Parameter value unit
- DATA_TYPE:          Parameter value data type
- R:                  'X' if restart is required to activate recent parameter change, otherwise ' '
- VALUE_RANGE:        Range of permitted values
- LAYER_RESTRICTIONS: Restriction to specific parameter layers like SYSTEM or HOST
- IS_READ_ONLY:       Information if parameter can only be read (TRUE) or also be modified

[EXAMPLE OUTPUT]

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|FILE_NAMES              |SECTION                |PARAMETER_NAME                     |DEFAULT_VALUE|UNIT|DATA_TYPE       |VALUE_RANGE|DESCRIPTION                                                                                                                                                                                                                                                    |R|LAYER_RESTRICTIONS|
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|<service>.ini           |livecache              |lockmanager_concurrency_level      |23           |    |INTEGER         |           |Determines the number of lock primitives, that are used to synchronize the operations inside the liveCache-lock-manager: The liveCache uses an own lock-manager which is used to synchronize the access to liveCache containers, liveCache schemas, and persis | |                  |
|<service>.ini           |table_consistency_check|check_max_concurrency_percent      |80           |    |INTEGER         |[1,100]    |Maximum concurrency for table consistency check: This parameter controls the overall CPU and thread resource consumption of CHECK_TABLE_CONSISTENCY, defined as a percentage of                                                                                | |                  |
|<service>.ini,global.ini|execution              |default_statement_concurrency_limit|0            |    |INTEGER UNSIGNED|           |Restrict the actual degree of parallel execution per connection within a request: For every HANA process the job executor will attempt to limit the number of threads assigned to process a statement to this limit. This is not a hard limit because blocking | |                  |
|<service>.ini,global.ini|execution              |max_concurrency                    |0            |    |INTEGER UNSIGNED|           |Maximum number of parallel threads in job executor: Sets the maximum number of parallel threads to execute jobs in the job executor system. This number is a hint for the job executor to keep this number of worker threads busy, so depending on what the wo | |                  |
|<service>.ini,global.ini|execution              |max_concurrency_hint               |0            |    |INTEGER UNSIGNED|           |Define an upper bound for the concurrency hint which is internally used to define the degree of parallelism for code processed by the job executor: The concurrency hint is an internal code-level feature to adopt the degree of parallelism for executing co | |                  |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

  MAP(LINE_NO, 1, FILE_NAMES, '') FILE_NAMES,
  MAP(LINE_NO, 1, SECTION, '') SECTION,
  MAP(LINE_NO, 1, PARAMETER_NAME, '') PARAMETER_NAME,
  DESCRIPTION,
  MAP(LINE_NO, 1, DEFAULT_VALUE, '') DEFAULT_VALUE,
  MAP(LINE_NO, 1, UNIT, '') UNIT,
  MAP(LINE_NO, 1, DATA_TYPE, '') DATA_TYPE,
  MAP(LINE_NO, 1, VALUE_RANGE, '') VALUE_RANGE,
  MAP(LINE_NO, 1, MAP(RESTART_REQUIRED, 'TRUE', 'X', ''), '') R,
  MAP(LINE_NO, 1, LAYER_RESTRICTIONS, '') LAYER_RESTRICTIONS,
  MAP(LINE_NO, 1, IS_READ_ONLY, '') IS_READ_ONLY
FROM
( SELECT
    INIFILE_NAMES FILE_NAMES,
    SECTION,
    KEY PARAMETER_NAME,
    DEFAULT_VALUE,
    UNIT,
    DATA_TYPE_NAME DATA_TYPE,
    VALUE_RESTRICTIONS VALUE_RANGE,
    RESTART_REQUIRED,
    LAYER_RESTRICTIONS,
    IS_READ_ONLY,
    LINE_NO,
    SUBSTR(DESCRIPTION, START_POS, END_POS - START_POS - 1) DESCRIPTION
  FROM
  ( SELECT
      INIFILE_NAMES,
      SECTION,
      KEY,
      DEFAULT_VALUE,
      UNIT,
      DATA_TYPE_NAME,
      VALUE_RESTRICTIONS,
      RESTART_REQUIRED,
      LAYER_RESTRICTIONS,
      DESCRIPTION,
      DESCRIPTION_LENGTH,
      IS_READ_ONLY,
      LINE_NO,
      LAST_LINE_NO,
      MAP(LINE_NO, 1, 0, ( DESCRIPTION_LENGTH_TARGET * ( LINE_NO - 1) ) + START_POS) START_POS,
      MAP(END_POS, 0, DESCRIPTION_LENGTH + 2, ( DESCRIPTION_LENGTH_TARGET * LINE_NO ) + END_POS) END_POS
    FROM
    ( SELECT
        INIFILE_NAMES,
        SECTION,
        KEY,
        DEFAULT_VALUE,
        UNIT,
        DATA_TYPE_NAME,
        VALUE_RESTRICTIONS,
        RESTART_REQUIRED,
        LAYER_RESTRICTIONS,
        DESCRIPTION,
        DESCRIPTION_LENGTH,
        LINE_NO,
        DESCRIPTION_LENGTH_TARGET,
        IS_READ_ONLY,
        CEIL(DESCRIPTION_LENGTH / DESCRIPTION_LENGTH_TARGET) LAST_LINE_NO,
        LOCATE(SUBSTR(DESCRIPTION, ( LINE_NO - 1) * DESCRIPTION_LENGTH_TARGET), CHAR(32)) START_POS,
        LOCATE(SUBSTR(DESCRIPTION, LINE_NO        * DESCRIPTION_LENGTH_TARGET), CHAR(32)) END_POS
      FROM
      ( SELECT
          P.INIFILE_NAMES,
          P.SECTION,
          P.KEY,
          P.DEFAULT_VALUE,
          P.UNIT,
          P.DATA_TYPE_NAME,
          P.VALUE_RESTRICTIONS,
          P.RESTART_REQUIRED,
          P.LAYER_RESTRICTIONS,
          P.DESCRIPTION,
          P.IS_READ_ONLY,
          O.LINE_NO,
          LENGTH(P.DESCRIPTION) DESCRIPTION_LENGTH,
          BI.DESCRIPTION_LENGTH_TARGET
        FROM
        ( SELECT                      /* Modification section */
            '%' FILE_NAMES,
            '%' SECTION,
            '%decision_func' PARAMETER_NAME,
            '%' DEFAULT_VALUE,
            '%' UNIT,
            '%' DESCRIPTION,
            80  DESCRIPTION_LENGTH_TARGET,
            '%' DATA_TYPE,
            '%' RESTART_REQUIRED,
            '%' LAYER_RESTRICTIONS,
            '%' IS_READ_ONLY
          FROM
            DUMMY
        ) BI,
          CONFIGURATION_PARAMETER_PROPERTIES P,
        ( SELECT TOP 100
            ROW_NUMBER () OVER () LINE_NO
          FROM
            OBJECTS
        ) O
        WHERE
          P.SECTION LIKE BI.SECTION AND
          P.KEY LIKE BI.PARAMETER_NAME AND
          P.INIFILE_NAMES LIKE BI.FILE_NAMES AND
          UPPER(P.UNIT) LIKE UPPER(BI.UNIT) AND
          P.DEFAULT_VALUE LIKE BI.DEFAULT_VALUE AND
          UPPER(P.DESCRIPTION) LIKE UPPER(BI.DESCRIPTION) AND
          P.DATA_TYPE_NAME LIKE BI.DATA_TYPE AND
          P.RESTART_REQUIRED LIKE BI.RESTART_REQUIRED AND
          P.LAYER_RESTRICTIONS LIKE BI.LAYER_RESTRICTIONS AND
          P.IS_READ_ONLY LIKE BI.IS_READ_ONLY
      )
      WHERE
        LINE_NO <= CEIL(DESCRIPTION_LENGTH / DESCRIPTION_LENGTH_TARGET)
    )
    WHERE
      START_POS != 0
  )
) P
ORDER BY
  P.FILE_NAMES,
  P.SECTION,
  P.PARAMETER_NAME,
  P.LINE_NO
