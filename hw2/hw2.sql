-- SQL Views
-- 1. Create a view, named NumberCust which is showing how many customers there are 
-- on each territory (use table [Sales].[Customer]). 

CREATE VIEW NumberCust AS
SELECT t.Name
     , COUNT(c.CustomerID) AS CustomerCount
FROM Sales.Customer as c
    JOIN Sales.SalesTerritory as t
        ON c.TerritoryID = t.TerritoryID
GROUP BY t.Name
GO

SELECT * FROM NumberCust

-- SQL Tiggers 
-- 1. Construct a trigger, named trgDelete, that is affected DELETE Transact-SQL 
-- statements in the [HumanResources].[Department] table. This trigger should write 
-- the data which was deleted to separate table (you need to create this table).

SELECT * INTO HumanResources.DepartmentDeleted
FROM HumanResources.Department
WHERE 0 = 1; -- Copy structure w/o data
GO

CREATE TRIGGER trgDelete
ON HumanResources.Department
AFTER DELETE
AS
    DECLARE @DepartmentID SMALLINT
          , @Name         NVARCHAR
          , @GroupName    NVARCHAR
          , @ModifiedDate DATETIME
    SELECT @DepartmentID = DepartmentID FROM DELETED
    SELECT @Name         = [Name]       FROM DELETED
    SELECT @GroupName    = GroupName    FROM DELETED
    SELECT ModifiedDate  = GETDATE()

    INSERT INTO HumanResources.DepartmentDeleted
        ( DepartmentID
        , [Name]
        , GroupName
        , ModifiedDate
        )
    VALUES ( @DepartmentID
           , @Name
           , @GroupName
           , @ModifiedDate
           )
GO

DELETE TOP (1)
FROM HumanResources.Department;
GO
-- 2. Construct a trigger, named trgUpdate, that is affected by UPDATE Transact-SQL 
-- statements in the [HumanResources].[ vEmployee] view. This trigger should simply 
-- raise an error instead of update that indicates that data cannot be updated at this view.

CREATE TRIGGER trgUpdate
ON HumanResources.vEmployee
INSTEAD OF UPDATE
AS RAISERROR( N'UPDATE is not allowed for HumanResources.vEmployee'
            , 14
            , 1
            );
GO

UPDATE HumanResources.vEmployee
SET FirstName = 'FirstName';
GO

-- SQL Stored Procedures 
-- 1. Create a stored procedure sp_ChangeCity which changes all Cities in the table 
-- [Person].[Address] into Upper Case.

CREATE PROC sp_ChangeCity
AS
    UPDATE Person.Address
    SET City = UPPER(City);
GO

EXEC sp_ChangeCity;
GO

-- 2. Construct a stored proc, named sp_GetLastName, that accepts an input parameter 
-- named EmployeeID and returns the last name of that employee (you can join 
-- Employee table and Person). 

CREATE PROC sp_GetLastName @EmployeeId INT
AS
    SELECT P.LastName
    FROM HumanResources.Employee AS e
        JOIN Person.Person AS p
            ON p.BusinessEntityID = e.BusinessEntityID
    WHERE e.BusinessEntityID = @EmployeeId;
GO

EXEC sp_GetLastName @EmployeeId = 30;

-- SQL XML grouping and ranking functions 
-- 1. Use GROUPING SETS, ROLLUP, CUBE with grouping set containing 5 columns.

SELECT CountryRegionName
     , StateProvinceName
     , City
     , JobTitle
     , Title
FROM HumanResources.vEmployee
GROUP BY GROUPING SETS
    ( (CountryRegionName, StateProvinceName, City, JobTitle, Title)
    , (CountryRegionName, StateProvinceName, City, JobTitle)
    , (CountryRegionName, StateProvinceName, City)
    , (CountryRegionName, StateProvinceName)
    , (CountryRegionName)
    );

-- same as previous but shorter
SELECT CountryRegionName
     , StateProvinceName
     , City
     , JobTitle
     , Title
FROM HumanResources.vEmployee
GROUP BY ROLLUP
    ( CountryRegionName
    , StateProvinceName
    , City
    , JobTitle
    , Title
    );

SELECT CountryRegionName
     , StateProvinceName
     , City
     , JobTitle
     , Title
FROM HumanResources.vEmployee
GROUP BY CUBE
    ( CountryRegionName
    , StateProvinceName
    , City
    , JobTitle
    , Title
    );

-- SQL XML data-types 
-- 1. Create your own XML script (root must containt your name, e.g. 
-- <bookstore_NameSurname>) and convert it into table.

CREATE TABLE dbo.xmlBook (book XML);

INSERT INTO dbo.xmlBook VALUES
('
<Book_DanielSafonov>
<Book>
    <Id>1</Id>
    <Author>Stephen Hawking</Author>
    <Name>A Brief History of Time</Name>
    <Year>1988</Year>
</Book>
<Book>
    <Id>2</Id>
    <Author>Susanna S. Epp</Author>
    <Name>Discrete Mathematics with Applications. 4th ed.</Name>
    <Year>2011</Year>
</Book>
<Book>
    <Id>3</Id>
    <Author>Miran Lipovaca</Author>
    <Name>Learn You a Haskell for Great Good!</Name>
    <Year>2011</Year>
</Book>
</Book_DanielSafonov>
')

DECLARE @hBooks INT
DECLARE @xmlBooks XML

SET @xmlBooks = (SELECT * FROM dbo.xmlBook);

EXEC sp_xml_preparedocument @hBooks OUTPUT, @xmlBooks;
SELECT *
FROM OPENXML( @hBooks
            , 'Book_DanielSafonov/Book'
            , 2)
WITH (Id INT, Author TEXT, [Name] TEXT, [Year] INT);
EXEC sp_xml_removedocument @hBooks;
-- SQL partitions 
-- 1. Create your own partitions in database (NameSurname_ParititionDB), partition 
-- function, scheme and table.

CREATE DATABASE DanielSafonov_PartitionDB;

ALTER DATABASE DanielSafonov_PartitionDB ADD FILEGROUP fg1;
ALTER DATABASE DanielSafonov_PartitionDB ADD FILEGROUP fg2;
ALTER DATABASE DanielSafonov_PartitionDB ADD FILEGROUP fg3;
ALTER DATABASE DanielSafonov_PartitionDB ADD FILEGROUP fg4;

ALTER DATABASE DanielSafonov_PartitionDB
ADD FILE ( NAME = f1
         , FILENAME = '/var/opt/mssql/data/DanielSafonov_PartitionDB_f1.ndf'
         )
TO FILEGROUP fg1;

ALTER DATABASE DanielSafonov_PartitionDB
ADD FILE ( NAME = f2
         , FILENAME = '/var/opt/mssql/data/DanielSafonov_PartitionDB_f2.ndf'
         )
TO FILEGROUP fg2;

ALTER DATABASE DanielSafonov_PartitionDB
ADD FILE ( NAME = f3
         , FILENAME = '/var/opt/mssql/data/DanielSafonov_PartitionDB_f3.ndf'
         )
TO FILEGROUP fg3;

ALTER DATABASE DanielSafonov_PartitionDB
ADD FILE ( NAME = f4
         , FILENAME = '/var/opt/mssql/data/DanielSafonov_PartitionDB_f4.ndf'
         )
TO FILEGROUP fg4;

CREATE PARTITION FUNCTION pf1 (INT)
AS RANGE LEFT FOR VALUES (1000, 2000, 3000);

CREATE PARTITION SCHEME ps1
AS PARTITION pf1
TO (fg1, fg2, fg3, fg4);

CREATE TABLE dbo.t1 ( Id INT PRIMARY KEY
                    , [Name] TEXT
                    )
ON ps1 (Id);

INSERT INTO t1
VALUES (1001, 'Daniel')
     , (2001, 'Peter')
     , (3003, 'Michael')
     ;

SELECT $PARTITION.pf1(Id) AS 'PartNum', * FROM t1;

-- SQL Geography and geometry types 
-- 1. GEOMETRY = ART: draw anything using different Geometry datatypes (let your 
-- imagination run wild and enjoy this subtask!)

-- Can't test it (Azure data studio doesn't visualise geometry, or i didn't find how),
-- but it should be a smiley face

SELECT geometry::STGeomFromText('CIRCULARSTRING(0 4, 4 0, 0 -4, -4 0, 0 4)', 0) AS [circle]
     , geometry::STGeomFromText('CIRCULARSTRING(-2 -2, 0 -3, 2 -2)', 0)         AS mouth
     , geometry::STGeomFromText('POINT(-2 2)', 0)                               AS leftEye
     , geometry::STGeomFromText('POINT( 2 2)', 0)                               AS rigthEye