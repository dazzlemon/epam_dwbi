-- - 7. Write 5 - 10 SELECT queries. Feel free to add/update values in the tables if you need. Try to use as much statements you learned as possible (listed below), but please, DO NOT overcomplicate your queries. Hint: you may combine a few statements in a single query (for example: 2 types of joins, group by, aggregate functions etc.) Statements to use:
--      - a. DISTINCT
--      - b. AND, OR, NOT, IN, BETWEEN
--      - c. ORDER BY
--      - d. LIMIT
--      - e. INNER, RIGHT, FULL JOIN
--      - f. UNION, UNION ALL
--      - g. AGGREGATE FUNCTIONS (COUNT, MIN, MAX, SUM, AVG)
--      - h. GROUP BY
--      - i. HAVING
--      - j. + Subqueries.
-- - 8. Save your SELECT queries to .sql file (other than in step 6).
-- - 9. Create Diagram of your database schema. It is an optional task. You can create a diagram using SQL Server Management Studio if you use SQL Server. Or you can draw one.
-- - 10. Upload your homework (2 .sql files and picture of diagram of your DB Schema) to your Homework channel, SQL Basics folder.

USE School;

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

SELECT Day
     , [Time]
     , (CASE
            WHEN IsOddWeek = 1 THEN 'Odd'
            WHEN IsOddWeek = 0 THEN 'Even'
        END) AS WeekParity
FROM dbo.Schedule
ORDER BY GroupId;