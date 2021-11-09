-- SQL Basics Homework
-- DEADLINE: 19.11.2021
-- x 1. Download and install any relational DBMS (Preferable - SQL Server).
-- x 2. Choose subject area for your database (for example, online shop, cinema app, employees database, library catalogue etc).
-- x 3. Create a database.
-- x 4. Create at least 2 (preferable - 4-5) tables according to chosen subject area with appropriate data types, constraints and relations between them.
-- - 5. Insert data into created tables (5 - 10 rows per table will do). Note: you do not have to make all the inserts using queries, but at least 1-2 per table should be done with INSERT INTO statements.
-- - 6. Save sql code you used to perform steps 3-5 to .sql file.
-- - 7. Write 5 - 10 SELECT queries. Feel free to add/update values in the tables if you need. Try to use as much statements you learned as possible (listed below), but please, DO NOT overcomplicate your queries. Hint: you may combine a few statements in a single query (for example: 2 types of joins, group by, aggregate functions etc.) Statements to use:
--      - a. DISTINCT
--      - b. WHERE (AND, OR, NOT, IN, BETWEEN, LIKE â€¦)
--      - c. ORDER BY
--      - d. LIMIT
--      - e. JOINS (INNER, LEFT, RIGHT, FULL)
--      - f. UNION, UNION ALL
--      - g. AGGREGATE FUNCTIONS (COUNT, MIN, MAX, SUM, AVG)
--      - h. GROUP BY
--      - i. HAVING
--      - j. + Subqueries.
-- - 8. Save your SELECT queries to .sql file (other than in step 6).
-- - 9. Create Diagram of your database schema. It is an optional task. You can create a diagram using SQL Server Management Studio if you use SQL Server. Or you can draw one.
-- - 10. Upload your homework (2 .sql files and picture of diagram of your DB Schema) to your Homework channel, SQL Basics folder.

-- Create

CREATE DATABASE School;
USE School;

CREATE TABLE Room( Id INT
                  , CONSTRAINT PK_Room PRIMARY KEY (Id));


CREATE TABLE [Group]( Id INT
                    , CONSTRAINT PK_Group PRIMARY KEY (Id));


CREATE TABLE Teacher( Id        INT IDENTITY(1, 1)
                    , FirstName TEXT NOT NULL
                    , LastName  TEXT NOT NULL
                    
                    , CONSTRAINT PK_Teacher PRIMARY KEY (Id));


CREATE TABLE Class( Id            INT IDENTITY(1, 1)
                  , [Name]        TEXT NOT NULL
                  
                  , LecturerId    INT -- maybe null if subject doesn't have lectures
                  , InstructorId1 INT -- maybe null if subject doesn't have labs
                  , InsturctorId2 INT -- maybe null if subject doesn't have labs or only one instructor
                  
                  , LectureRoomId INT -- same goes for these
                  , RoomId1       INT
                  , RoomId2       INT
                  
                  , CONSTRAINT PK_Class PRIMARY KEY (Id)
                  
                  , CONSTRAINT FK_Class_LecturerId    FOREIGN KEY (LecturerId   ) REFERENCES Teacher (Id)
                  , CONSTRAINT FK_Class_InstructorId1 FOREIGN KEY (InstructorId1) REFERENCES Teacher (Id)
                  , CONSTRAINT FK_Class_InstructorId2 FOREIGN KEY (InsturctorId2) REFERENCES Teacher (Id)

                  , CONSTRAINT FK_Class_LectureRoomId FOREIGN KEY (LectureRoomId) REFERENCES Room    (Id)
                  , CONSTRAINT FK_Class_RoomId1       FOREIGN KEY (RoomId1)       REFERENCES Room    (Id)
                  , CONSTRAINT FK_Class_RoomId2       FOREIGN KEY (RoomId2)       REFERENCES Room    (Id));


CREATE TABLE Schedule( [Day]     SMALLINT NOT NULL
                     , [Time]    TIME     NOT NULL
                     , IsOddWeek BIT -- if NULL same for both weeks
                     , IsLecture BIT      NOT NULL
                     , ClassId   INT      NOT NULL
                     , GroupId   INT      NOT NULL
                     
                     , CONSTRAINT FK_Schedule_ClassId FOREIGN KEY (ClassId) REFERENCES Class   (Id)
                     , CONSTRAINT FK_Schedule_GroupId FOREIGN KEY (GroupId) REFERENCES [Group] (Id)
                     , CONSTRAINT CHK_Schedule CHECK ([Day] BETWEEN 0 AND 6)); -- 0 is monday


CREATE TABLE Student( Id                INT  IDENTITY(1, 1)
                    , FirstName         TEXT NOT NULL
                    , LastName          TEXT NOT NULL
                    , IsInFirstSubgroup BIT  NOT NULL -- groups are divided into two for labs
                    , GroupId           INT  NOT NULL
                    
                    , CONSTRAINT PK_Student         PRIMARY KEY (Id)
                    , CONSTRAINT FK_Student_GroupId FOREIGN KEY (GroupId) REFERENCES [Group] (Id));

-- Populate

INSERT INTO Room (Id )
          VALUES (202)
               , (303)
               , (404)
               , (504)
               , (323)
               , (220);

INSERT INTO [Group] (Id )
             VALUES (911)
                  , (912)
                  , (931)
                  , (940);

INSERT INTO Teacher (FirstName, LastName  )
             VALUES ('John',    'Nash'    )
                  , ('Terence', 'Tao'     )
                  , ('fname1',  'fname2'  )
                  , ('another', 'cool guy')
                  , ('and one', 'more'    );

INSERT INTO Class (                Name,          LecturerId, InstructorId1, LectureRoomId, RoomId1)
           VALUES (       'Game Theory',          1,             3,           504,     323) -- not good idea using raw fk but whatever
                , ('Probability Theory',          2,             4,           404,     303)
                , (  'One more subject',          3,             4,           220,     303);

INSERT INTO Schedule ([Day],  [Time], IsOddWeek, IsLecture, ClassId, GroupId)
              VALUES (    0,  '9:30',         0,         1,       1,     911)
                   , (    0,  '9:30',         1,         1,       2,     911)
                   , (    0, '11:00',      NULL,         0,       3,     911);

INSERT INTO Student (FirstName,  LastName, IsInFirstSubgroup, GroupId)
             VALUES ( 'Daniel', 'Safonov',                 0,     911)
                  , (   'John',    'Wick',                 1,     911);

