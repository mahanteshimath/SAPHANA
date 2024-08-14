WITH 

/* 

[NAME]

- HANA_Tests_ArithmeticOperations

[DESCRIPTION]

- Runtime test for arithmetic CPU operations

[SOURCE]

- SAP Note 1969700

[DETAILS AND RESTRICTIONS]

- Can be executed to measure CPU performance of arithmetic operations
- When statement is executed (once or several times), results can be retrieved from the SQL cache via
  SQL: "HANA_Tests_Results" available in SAP Note 1969700

[VALID FOR]

- Revisions:              all

[SQL COMMAND VERSION]

- 2021/01/03:  1.0 (initial version)

[INVOLVED TABLES]


[INPUT PARAMETERS]

- SQL_CACHE_TAG

  Tag for identifying SQL cache entry related to statement execution

  'ZMF_TEST_CPU_ARITHMETIC' -> Use SQL cache tag ZMF_TEST_CPU_ARITHMETIC

[OUTPUT PARAMETERS]


[EXAMPLE OUTPUT]


*/

BASIS_INFO AS
( SELECT
    'ZMF_TEST_CPU_ARITHMETIC' SQL_CACHE_TAG
  FROM
    DUMMY
),
DIGITS AS
( SELECT 1 DIGIT FROM DUMMY UNION ALL
  SELECT 2 DIGIT FROM DUMMY UNION ALL
  SELECT 3 DIGIT FROM DUMMY UNION ALL
  SELECT 4 DIGIT FROM DUMMY UNION ALL
  SELECT 5 DIGIT FROM DUMMY UNION ALL
  SELECT 6 DIGIT FROM DUMMY UNION ALL
  SELECT 7 DIGIT FROM DUMMY UNION ALL
  SELECT 8 DIGIT FROM DUMMY UNION ALL
  SELECT 9 DIGIT FROM DUMMY
)
SELECT
  *
FROM DIGITS A, DIGITS B, DIGITS C, DIGITS D, DIGITS E, DIGITS F
WHERE
  ( A.DIGIT * 100 + B.DIGIT * 10 + C.DIGIT ) * ( B.DIGIT * 100 + C.DIGIT * 10 + D.DIGIT * 1) =
  ( F.DIGIT * 10000000 + E.DIGIT * 1000000 + A.DIGIT * 100000 + C.DIGIT * 10000 + B.DIGIT * 1000 + D.DIGIT * 100 + C.DIGIT * 10 + D.DIGIT * 1 )

