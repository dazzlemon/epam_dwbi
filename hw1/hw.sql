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
                  , InstructorId2 INT -- maybe null if subject doesn't have labs or only one instructor
                  
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
                    , (    0, '11:00',      NULL,         0,       3,     911)
                    , (    1,  '9:30',      NULL,         0,       1,     940);

INSERT INTO Student (FirstName,  LastName, IsInFirstSubgroup, GroupId)
             VALUES ( 'Daniel', 'Safonov',                 0,     911)
                  , (   'John',    'Wick',                 1,     911);

