--      - b. AND, NOT, IN, BETWEEN
--      - e. INNER, RIGHT, FULL JOIN
--      - g. MIN, MAX, SUM, AVG
-- - 9. Create Diagram of your database schema.

USE School;

-- Classes and teachers
SELECT c.Id
     , c.[Name]
     , CONCAT(t.FirstName,  ' ', t.Lastname)  AS Lecturer 
     , CONCAT(t1.FirstName, ' ', t1.Lastname) AS Instructor1 
     , CONCAT(t2.FirstName, ' ', t2.Lastname) AS Instructor2
     , LectureRoomId
     , RoomId1
     , RoomId2
FROM dbo.Class AS c
    LEFT JOIN dbo.Teacher as t
        ON c.LecturerId = t.Id
    LEFT JOIN dbo.Teacher as t1
        ON c.InstructorId1 = t1.id
    LEFT JOIN dbo.Teacher as t2
        ON c.InstructorId2 = t2.id
WHERE c.[Name] LIKE '%Theory';
-- is there a way to make it "DRY"?


-- Schedule for odd week
SELECT GroupId
     , (CASE
            WHEN Day = 0 THEN 'Monday'
            WHEN Day = 1 THEN 'Tuesday'
            WHEN Day = 2 THEN 'Wednesday'
            WHEN Day = 3 THEN 'Thursday'
            WHEN Day = 4 THEN 'Friday'
            WHEN Day = 5 THEN 'Saturday'
            WHEN Day = 6 THEN 'Sunday'
        END) AS 'Day'
     , [Time]
     , (CASE
            WHEN IsOddWeek = 1 THEN 'Odd'
            WHEN IsOddWeek = 0 THEN 'Even'
            ELSE 'Both'
        END) AS WeekParity
FROM dbo.Schedule
WHERE IsOddWeek = 1
   OR IsOddWeek IS NULL
ORDER BY GroupId, 'Day';

-- How many classes per week for each group
( 
    SELECT GroupId
        , COUNT(*) AS 'Count'
        , 'Odd' AS WeekParity   
    FROM dbo.Schedule
    WHERE IsOddWeek = 1
    OR IsOddWeek IS NULL
    GROUP BY GroupId

UNION

    SELECT GroupId
        , COUNT(*) AS 'Count'
        , 'Even' AS WeekParity
    FROM dbo.Schedule
    WHERE IsOddWeek = 0
    OR IsOddWeek IS NULL
    GROUP BY GroupId)
ORDER BY GroupId, WeekParity;


-- How many different classes each group has
SELECT GroupId
     , COUNT(*) AS 'Count'
FROM (SELECT DISTINCT ClassId
                    , GroupId
      FROM dbo.Schedule) AS t -- didn't work without "AS t", idk why
GROUP BY GroupId;


-- Groups with at least 20 students
SELECT GroupId
FROM dbo.Student
GROUP BY GroupId
HAVING COUNT(*) >= 20;


-- How many lectures each teacher has
SELECT CONCAT(FirstName, ' ', LastName)
     , [Count]
FROM (
    SELECT LecturerId
         , COUNT(*) AS 'Count'
    FROM (
        SELECT DISTINCT ClassId
                      , LecturerId
        FROM dbo.Schedule as s
            JOIN dbo.Class as c
                ON c.Id = s.ClassId
            JOIN dbo.Teacher as t
                ON c.LecturerId = t.Id) AS t
    GROUP BY LecturerId) as t1
    JOIN dbo.Teacher as t2
        ON t2.Id = t1.LecturerId;