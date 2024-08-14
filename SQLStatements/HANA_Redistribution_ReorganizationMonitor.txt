SELECT
/* 

[NAME]

- HANA_Redistribution_ReorganizationMonitor

[DESCRIPTION]

- Overview current landscape redistribution activities

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- With SAP HANA >= 1.00.120 the timestamps in REORG* views are erroneously stored as UTC rather than local system time

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2016/12/17:  1.0 (initial version)

[INVOLVED TABLES]

- REORG_OVERVIEW
- REORG_STEPS
- M_SERVICE_THREADS

[INPUT PARAMETERS]


[OUTPUT PARAMETERS]

- DETAILS:    Individual landscape redistribution details

[EXAMPLE OUTPUT]

---------------------------------------------------
|DETAILS                                          |
---------------------------------------------------
|Reorganization Monitor                           |
|**********************                           |
|                                                 |
|Total partitioning steps: 2799                   |
|  Done: 2718  Errors: 0                          |
|  Remaining: 81                                  |
|  Running: 62                                    |
|Total Optimize Compression steps: 2799           |
|  Done: 2698  Errors: 0                          |
|  Remaining: 101                                 |
|  Running: 6                                     |
|Total redistribution steps: 14837                |
|  Done: 10918   Errors: 0                        |
|  Remaining: 3887                                |
|  Running: 32                                    |
|---------------------------------------------    |
|Total partitions with host adjustment: 75924     |
|Total partitions with host adjustment done: 35824|
|Partitions with different host in this run: 5283 |
|Partitions moved in this run: 2537               |
|Partitions pending to move in this run: 2746     |
|---------------------------------------------    |
|Elapsed time: 5h 22min                           |
---------------------------------------------------

*/

  DETAILS
FROM
( SELECT 10 LINE_NO, 'Reorganization Monitor' DETAILS FROM DUMMY 
  UNION ALL
  ( SELECT 11, '**********************' FROM DUMMY )
  UNION ALL
  ( SELECT 15, '' FROM DUMMY )
  UNION ALL
  ( SELECT 
      20,
      'Total partitioning steps: ' || COUNT(*) 
    FROM 
      REORG_STEPS
    WHERE 
      REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW ) AND
      NEW_PARTITION_SPEC IS NOT NULL AND
      TO_VARCHAR(NEW_PARTITION_SPEC) != 'OPTIMIZE COMPRESSION'
  )
  UNION ALL
  ( SELECT
      30,
      '  Done: ' || IFNULL(COUNT(*), 0) || '  Errors: ' || IFNULL(SUM(MAP(ERROR, NULL, 0, 1)), 0)
    FROM 
      REORG_STEPS
    WHERE
      REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW ) AND
      NEW_PARTITION_SPEC IS NOT NULL AND
      TO_VARCHAR(NEW_PARTITION_SPEC) != 'OPTIMIZE COMPRESSION' AND
      END_DATE IS NOT NULL
  )
  UNION ALL
  ( SELECT
      40,
      '  Remaining: ' || COUNT(*)
    FROM
      REORG_STEPS
    WHERE
      REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW ) AND
      NEW_PARTITION_SPEC IS NOT NULL AND
      TO_VARCHAR(NEW_PARTITION_SPEC) != 'OPTIMIZE COMPRESSION' AND
      START_DATE IS NULL AND
	  END_DATE IS NULL
  )
  UNION ALL
  ( SELECT
      50,
      '  Running: ' || COUNT(*)
    FROM
      REORG_STEPS
    WHERE
      REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW ) AND
      NEW_PARTITION_SPEC IS NOT NULL AND
      TO_VARCHAR(NEW_PARTITION_SPEC) != 'OPTIMIZE COMPRESSION' AND
      START_DATE IS NOT NULL AND
      END_DATE IS NULL
  )
  UNION ALL
  ( SELECT
      60,
      'Total Optimize Compression steps: ' || COUNT(*)
    FROM 
      REORG_STEPS
    WHERE
      REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW ) AND
      TO_VARCHAR(NEW_PARTITION_SPEC) = 'OPTIMIZE COMPRESSION'
  )
  UNION ALL
  ( SELECT
      70,
      '  Done: ' || COUNT(*) || '  Errors: ' || IFNULL(SUM(MAP(ERROR, NULL, 0, 1)), 0)
    FROM
      REORG_STEPS
    WHERE
      REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW ) AND
      TO_VARCHAR(NEW_PARTITION_SPEC) = 'OPTIMIZE COMPRESSION' AND
      START_DATE IS NOT NULL AND
      END_DATE IS NOT NULL
  )
  UNION ALL
  ( SELECT
      80,
      '  Remaining: ' || COUNT(*)
    FROM
      REORG_STEPS
    WHERE
      REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW ) AND
      TO_VARCHAR(NEW_PARTITION_SPEC) = 'OPTIMIZE COMPRESSION' AND
      START_DATE IS NULL AND
	  END_DATE IS NULL   
  )
  UNION ALL
  ( SELECT 
      90,
      '  Running: ' || COUNT(*)
    FROM
      REORG_STEPS
    WHERE
      REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW ) AND
      TO_VARCHAR(NEW_PARTITION_SPEC) = 'OPTIMIZE COMPRESSION' AND
      START_DATE IS NOT NULL AND
      END_DATE IS NULL    
  )
  UNION ALL
  ( SELECT
      100,
      'Total redistribution steps: ' || COUNT(*)
    FROM
      REORG_STEPS
    WHERE
      REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW ) AND
      NEW_PARTITION_SPEC IS NULL
  )
  UNION ALL
  ( SELECT
      110,
      '  Done: ' || COUNT(*) || '   Errors: ' || IFNULL(SUM(MAP(ERROR, NULL, 0, 1)), 0)
    FROM 
      REORG_STEPS
    WHERE 
      REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW ) AND
      NEW_PARTITION_SPEC IS NULL AND
      START_DATE IS NOT NULL AND
      END_DATE IS NOT NULL
  )
  UNION ALL
  ( SELECT 
      120,
      '  Remaining: ' || COUNT(*)
    FROM 
      REORG_STEPS
    WHERE 
      REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW ) AND
      NEW_PARTITION_SPEC IS NULL AND
      START_DATE IS NULL AND
      END_DATE IS NULL
  )
  UNION ALL
  ( SELECT
      130,
      '  Running: ' || COUNT(*)
    FROM
      REORG_STEPS
    WHERE
      REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW ) AND
      NEW_PARTITION_SPEC IS NULL AND
      START_DATE IS NOT NULL AND
      END_DATE IS NULL
  )
  UNION ALL
  ( SELECT
      140,
      '---------------------------------------------'
    FROM 
      DUMMY 
  )
  UNION ALL
  ( SELECT
      150,
      'Total partitions with host adjustment: ' || COUNT(*)    
    FROM
      REORG_STEPS RST RIGHT JOIN
      M_CS_TABLES CT ON
        RST.SCHEMA_NAME = CT.SCHEMA_NAME AND
        RST.TABLE_NAME = CT.TABLE_NAME
    WHERE
      RST.REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW ) AND
      RST.NEW_HOST IS NOT NULL
  )
  UNION ALL
  ( SELECT
      160,
      'Total partitions with host adjustment done: ' || COUNT(*)
    FROM
      REORG_STEPS RST RIGHT JOIN
      M_CS_TABLES CT ON
        RST.SCHEMA_NAME = CT.SCHEMA_NAME AND
        RST.TABLE_NAME = CT.TABLE_NAME
    WHERE
      RST.REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW ) AND
      RST.START_DATE IS NOT NULL AND
      RST.END_DATE IS NOT NULL AND
      RST.NEW_HOST IS NOT NULL
  )
  UNION ALL
  ( SELECT
      170,
      'Partitions with different host in this run: ' || COUNT(*) 
    FROM
      REORG_STEPS RST RIGHT JOIN
      M_CS_TABLES CT ON
        RST.SCHEMA_NAME = CT.SCHEMA_NAME AND
        RST.TABLE_NAME = CT.TABLE_NAME
    WHERE
      RST.REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW ) AND
      RST.START_DATE IS NOT NULL AND
      RST.END_DATE IS NULL AND
      RST.NEW_HOST IS NOT NULL
  )
  UNION ALL
  ( SELECT
      180,
      'Partitions moved in this run: ' || COUNT(*)     
    FROM
      REORG_STEPS RST RIGHT JOIN
      M_CS_TABLES CT ON
        RST.SCHEMA_NAME = CT.SCHEMA_NAME AND
        RST.TABLE_NAME = CT.TABLE_NAME
    WHERE
      RST.REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW ) AND
      RST.START_DATE IS NOT NULL AND
      RST.END_DATE IS NULL AND
      RST.NEW_HOST IS NOT NULL AND
      CT.HOST = RST.NEW_HOST
  )
  UNION ALL
  ( SELECT
      190,
      'Partitions pending to move in this run: ' || COUNT(*) 
    FROM
      REORG_STEPS RST RIGHT JOIN
      M_CS_TABLES CT ON
        RST.SCHEMA_NAME = CT.SCHEMA_NAME AND
        RST.TABLE_NAME = CT.TABLE_NAME
    WHERE
      RST.REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW ) AND
      RST.START_DATE IS NOT NULL AND
      RST.END_DATE IS NULL AND
      RST.NEW_HOST IS NOT NULL AND
      CT.HOST = RST.NEW_HOST
  )
  UNION ALL
  ( SELECT 
      200,
      '---------------------------------------------' 
    FROM 
      DUMMY 
  )
  UNION ALL
  ( SELECT
      210,
      CASE
        WHEN REORG_OVERVIEW.REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW ) AND REORG_OVERVIEW.END_DATE IS NULL THEN
          'Elapsed time: ' || 
             TO_INTEGER(SECONDS_BETWEEN(START_DATE, CURRENT_TIMESTAMP) / 3600) || 'h ' || 
             TO_INTEGER(SECONDS_BETWEEN(START_DATE, CURRENT_TIMESTAMP) / 60) - TO_INTEGER(SECONDS_BETWEEN(START_DATE, CURRENT_TIMESTAMP) / 3600 ) * 60 || 'min' ELSE
          'Elapsed time: ' || 
             TO_INTEGER(SECONDS_BETWEEN(START_DATE, END_DATE) / 3600) || 'h ' || 
             TO_INTEGER(SECONDS_BETWEEN(START_DATE, END_DATE) / 60) - TO_INTEGER(SECONDS_BETWEEN(START_DATE, END_DATE) / 3600 ) * 60 || 'min'
        END
      FROM
        REORG_OVERVIEW
      WHERE
        REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW )
  )
  UNION ALL
  ( SELECT
      220,
      'Errors: ' || ERROR || ' ...Count: ' || COUNT(*) 
    FROM 
      REORG_STEPS
    WHERE
      ERROR IS NOT NULL AND REORG_ID = ( SELECT MAX(REORG_ID) FROM REORG_OVERVIEW )
    GROUP BY
      ERROR
  )
  UNION ALL
  ( SELECT
      230,
      'Reorg still running, please wait: ' || THREAD_TYPE
    FROM
      M_SERVICE_THREADS
    WHERE
      THREAD_TYPE LIKE 'LandscapeReorg Plan%'
  )
  UNION ALL
  ( SELECT
      240,
      HOST || CHAR(32) || PORT || CHAR(32) || SERVICE_NAME || ' remove_status: ' || REMOVE_STATUS
    FROM
      M_VOLUMES
    WHERE
      REMOVE_STATUS != ''
  )
)
ORDER BY
  LINE_NO
