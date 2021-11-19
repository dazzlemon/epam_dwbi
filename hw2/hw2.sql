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

-- 2. Construct a trigger, named trgUpdate, that is affected by UPDATE Transact-SQL 
-- statements in the [HumanResources].[ vEmployee] view. This trigger should simply 
-- raise an error instead of update that indicates that data cannot be updated at this view. 

-- SQL Stored Procedures 
-- 1. Create a stored procedure sp_ChangeCity which changes all Cities in the table 
-- [Person].[Address] into Upper Case. 
-- 2. Construct a stored proc, named sp_GetLastName, that accepts an input parameter 
-- named EmployeeID and returns the last name of that employee (you can join 
-- Employee table and Person). 

-- SQL XML grouping and ranking functions 
-- 1. Use GROUPING SETS, ROLLUP, CUBE with grouping set containing 5 columns. 

-- SQL XML data-types 
-- 1. Create your own XML script (root must containt your name, e.g. 
-- <bookstore_NameSurname>) and convert it into table. 

-- SQL partitions 
-- 1. Create your own partitions in database (NameSurname_ParititionDB), partition 
-- function, scheme and table. 

-- SQL Geography and geometry types 
-- 1. GEOMETRY = ART: draw anything using different Geometry datatypes (let your 
-- imagination run wild and enjoy this subtusk!)