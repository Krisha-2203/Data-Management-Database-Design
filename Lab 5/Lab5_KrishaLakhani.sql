/*
Name - Krisha Lakhani
NUID - 002334794
Subject - Data Management and Database Design (DAMG 6210)
Lab 5
*/

--Question 5-1
USE AdventureWorks2008R2;
SELECT
    TerritoryID,
    [2] AS 'Month 2',
    [4] AS 'Month 4',
    [6] AS 'Month 6',
    [8] AS 'Month 8',
    [10] AS 'Month 10',
    [12] AS 'Month 12'
FROM
(
    SELECT
        TerritoryID,
        MONTH(OrderDate) AS Month,
        CAST(SUM(TotalDue) AS INT) AS TotalSales
    FROM Sales.SalesOrderHeader
    WHERE MONTH(OrderDate) IN (2, 4, 6, 8, 10, 12)
    AND TerritoryID BETWEEN 1 AND 5
    GROUP BY TerritoryID, MONTH(OrderDate)
    HAVING SUM(TotalDue) > 750000
) AS SourceTable
PIVOT
(
    SUM(TotalSales)
    FOR Month IN ([2], [4], [6], [8], [10], [12])
) AS PivotTable
ORDER BY
    TerritoryID;


--Question 5-2
USE KrishaLakhani_Lab4;
GO
CREATE FUNCTION dbo.CalculateColorSales
(
    @year INT,
    @month INT, 
    @color VARCHAR(15)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @total_sales DECIMAL(18,2);

    SELECT @total_sales = SUM(sod.UnitPrice * sod.OrderQty)
    FROM AdventureWorks2008R2.Sales.SalesOrderDetail sod
    JOIN AdventureWorks2008R2.Sales.SalesOrderHeader soh 
        ON sod.SalesOrderID = soh.SalesOrderID
    JOIN AdventureWorks2008R2.Production.Product p 
        ON sod.ProductID = p.ProductID
    WHERE p.Color = @color
    AND YEAR(soh.OrderDate) = @year 
    AND MONTH(soh.OrderDate) = @month;

    RETURN ISNULL(@total_sales, 0);
END;
GO

-- Test the function
SELECT dbo.CalculateColorSales(2008, 1, 'Black') AS TotalSales;


--Question 5-3
USE KrishaLakhani_Lab4;
/*
CREATE TABLE Customer 
(CustomerID VARCHAR(20) PRIMARY KEY, 
CustomerLName VARCHAR(30), 
CustomerFName VARCHAR(30), 
CustomerStatus VARCHAR(10)); 
CREATE TABLE SaleOrder 
(OrderID INT IDENTITY PRIMARY KEY, 
CustomerID VARCHAR(20) REFERENCES Customer(CustomerID), 
OrderDate DATE, 
OrderAmountBeforeTax INT); 
CREATE TABLE SaleOrderDetail 
(OrderID INT REFERENCES SaleOrder(OrderID), 
ProductID INT, 
Quantity INT, 
UnitPrice INT, 
PRIMARY KEY (OrderID, ProductID));
*/
GO
CREATE TRIGGER CalculateOrderAmount
ON SaleOrderDetail
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE SO
    SET OrderAmountBeforeTax = (
        SELECT COALESCE(SUM(Quantity * UnitPrice), 0)
        FROM SaleOrderDetail
        WHERE OrderID = SO.OrderID
    )
    FROM SaleOrder SO
    WHERE SO.OrderID IN (
        SELECT DISTINCT OrderID FROM inserted
        UNION
        SELECT DISTINCT OrderID FROM deleted
    );
END;
GO

--Question 5-4
CREATE DATABASE KrishaLakhani_Lab5;
USE KrishaLakhani_Lab5;

create table department 
(departmentid int primary key, 
departmentname varchar(50) not null, 
description varchar(1000)); 
create table faculty 
(facultyid int primary key, 
facultylastname varchar(50) not null, 
facultyfirstname varchar(50) not null, 
departmentid int not null references department(departmentid)); 
create table classroom 
(classroomid int primary key, 
building varchar(20) not null, 
capacity smallint not null); 
create table class 
(classid varchar(20) primary key,  
status varchar(10) not null, -- For simplicity, either Active or Inactive 
description varchar(100), 
semester varchar(20) not null, 
departmentid int not null references department(departmentid), 
facultyid int not null references faculty(facultyid), 
credit tinyint not null, 
classroomid int not null references classroom(classroomid));  
create table student 
(studentid int primary key, 
studentlastname varchar(50) not null, 
studentfirstname varchar(50) not null, 
departmentid int not null references department(departmentid), 
gpa decimal(3,2) not null);  
create table enrollment 
(classid varchar(20) references class(classid), 
studentid int not null references student(studentid), 
semester varchar(20) not null, 
status varchar(10) not null -- For simplicity, either active or complete 
primary key (classid, studentid, semester)); 
create table audittrail 
(audittrailid int identity primary key, 
departmentid int not null references department(departmentid), 
classid varchar(20) not null references class (classid), 
timing datetime not null default getdate());


-- Trigger to enforce max 25 active faculty members per department
GO
CREATE TRIGGER trg_CheckMaxActiveFaculty
ON faculty
AFTER INSERT
AS
BEGIN
    DECLARE @departmentid INT;

    SELECT @departmentid = departmentid FROM inserted;

    IF (SELECT COUNT(*) FROM faculty WHERE departmentid = @departmentid) > 25
    BEGIN
        RAISERROR('A department cannot have more than 25 active faculty members.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
-- Trigger to enforce max 3 active classes per faculty member per semester
GO
CREATE TRIGGER trg_CheckMaxActiveClasses
ON class
AFTER INSERT
AS
BEGIN
    DECLARE @facultyid INT;
    DECLARE @semester VARCHAR(20);

    SELECT @facultyid = facultyid, @semester = semester FROM inserted;

    IF (SELECT COUNT(*) FROM class WHERE facultyid = @facultyid AND semester = @semester AND status = 'Active') > 3
    BEGIN
        RAISERROR('A faculty member cannot be assigned more than 3 active classes in a semester.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO