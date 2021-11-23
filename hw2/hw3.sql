-- 1
USE DoctorWho;

SELECT *
FROM tblCompanion AS c
    LEFT JOIN tblEpisodeCompanion AS ec
        ON c.CompanionId = ec.CompanionId
WHERE ec.CompanionId IS NULL;

-- 2
USE WorldEvents;

SELECT *
FROM tblEvent
WHERE EventDate > ( SELECT MAX(EventDate)
                    FROM tblEvent
                    WHERE CountryId = 21
                  )
ORDER BY EventDate DESC;

-- 3
SELECT e.CountryID
     , CountryName
     , EventCount
FROM ( SELECT CountryID
            , COUNT(CountryID) AS EventCount
       FROM tblEvent
       GROUP BY CountryID
       HAVING COUNT(CountryID) > 8
     ) AS e
JOIN tblCountry AS c
    ON e.CountryID = c.CountryID;

-- 4
WITH ThisAndThat AS 
(
    SELECT IIF(EventDetails LIKE '%this%', 1, 0) AS [If This]
         , IIF(EventDetails LIKE '%that%', 1, 0) AS [If That]
         -- wont work without iif idk why
         , *
    FROM tblEvent
)

-- normal version
-- SELECT [If This]
--      , [If That]
--      , COUNT(EventID) AS EventCount
-- FROM ThisAndThat
-- GROUP BY [If This], [If That];

-- EventName, EventDetails for event with 'this' and 'that'
SELECT EventName
     , EventDetails
FROM ThisAndThat
WHERE [If This] = 1
  AND [If That] = 1; 