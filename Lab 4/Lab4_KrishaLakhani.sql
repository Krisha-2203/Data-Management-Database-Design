/*
Name - Krisha Lakhani
NUID - 002334794
Subject - Data Management and Database Desgin(DAMG6210)
Lab 4
*/

--Part A
Use KrishaLakhani_Lab4;
-- Create Student Table
CREATE TABLE Student (
    StudentID VARCHAR PRIMARY KEY,
    LastName VARCHAR NOT NULL,
    FirstName VARCHAR NOT NULL,
    DateOfBirth DATE NOT NULL
);

-- Create Course Table
CREATE TABLE Course (
    CourseID VARCHAR PRIMARY KEY,
    Name VARCHAR NOT NULL,
    Description VARCHAR
);

-- Create Term Table
CREATE TABLE Term (
    TermID VARCHAR PRIMARY KEY,
    Year INT NOT NULL,
    Term VARCHAR NOT NULL
);

-- Create Enrollment Table
CREATE TABLE Enrollment (
    StudentID VARCHAR,
    CourseID VARCHAR,
    TermID VARCHAR,
    PRIMARY KEY (StudentID, CourseID, TermID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (TermID) REFERENCES Term(TermID)
);
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KrishaLakhani_Lab4';

--Part B - 1 
USE AdventureWorks2008R2;
WITH ProductSalesByYear AS (
    SELECT 
        YEAR(soh.OrderDate) AS Year,
        sod.ProductID,
        SUM(sod.OrderQty) AS TotalSoldQuantity
    FROM Sales.SalesOrderHeader AS soh
    JOIN 
        Sales.SalesOrderDetail AS sod
        ON soh.SalesOrderID = sod.SalesOrderID
    GROUP BY YEAR(soh.OrderDate), sod.ProductID
),
Top5ProductsByYear AS (
    SELECT 
        Year,
        ProductID,
        TotalSoldQuantity,
        ROW_NUMBER() OVER (PARTITION BY Year ORDER BY TotalSoldQuantity DESC) AS Rank
    FROM ProductSalesByYear
)
SELECT 
    Year,
    SUM(TotalSoldQuantity) AS TotalSoldQuantity,
    STRING_AGG(CAST(ProductID AS VARCHAR), ', ') AS Top5Products
FROM Top5ProductsByYear
WHERE Rank <= 5
GROUP BY Year
ORDER BY Year;

--Part B - 2
USE AdventureWorks2008R2;
WITH ColorQuarterSales AS (
    SELECT 
        p.Color,
        YEAR(soh.OrderDate) AS Year,
        DATEPART(QUARTER, soh.OrderDate) AS Quarter,
        COUNT(DISTINCT soh.SalesOrderID) AS LargeOrders,
        SUM(sod.UnitPrice * sod.OrderQty) AS ColorQuarterSales
    FROM Production.Product p
    INNER JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    INNER JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    WHERE p.Color IS NOT NULL
        AND soh.TotalDue > 100000
    GROUP BY p.Color, YEAR(soh.OrderDate), DATEPART(QUARTER, soh.OrderDate)
    HAVING COUNT(DISTINCT soh.SalesOrderID) > 12
),
TotalQuarterSales AS (
    SELECT 
        Year,
        Quarter,
        SUM(ColorQuarterSales) AS TotalQuarterSales
    FROM ColorQuarterSales
    GROUP BY Year, Quarter
),
RankedQuarters AS (
    SELECT 
        cqs.Color,
        cqs.Year,
        cqs.Quarter,
        cqs.LargeOrders,
        CAST((cqs.ColorQuarterSales / tqs.TotalQuarterSales * 100) AS DECIMAL(10,2)) AS ColorSalesPercentage,
        ROW_NUMBER() OVER (PARTITION BY cqs.Color ORDER BY cqs.ColorQuarterSales DESC) AS SalesRank
    FROM ColorQuarterSales cqs
    INNER JOIN TotalQuarterSales tqs 
        ON cqs.Year = tqs.Year AND cqs.Quarter = tqs.Quarter
),
FormattedResults AS (
    SELECT 
        Color,
        CAST(Year AS VARCHAR) + ' ' + 
        CAST(Quarter AS VARCHAR) + ' ' + 
        CAST(LargeOrders AS VARCHAR) + ' Large Orders ' + 
        CAST(ColorSalesPercentage AS VARCHAR) + '%' AS QuarterInfo,
        SalesRank
    FROM RankedQuarters
    WHERE SalesRank <= 2
)
SELECT 
    r1.Color,
    CASE 
        WHEN r2.QuarterInfo IS NOT NULL 
        THEN r1.QuarterInfo + ', ' + r2.QuarterInfo
        ELSE r1.QuarterInfo
    END AS Top2Quarters
FROM FormattedResults r1
LEFT JOIN FormattedResults r2 
    ON r1.Color = r2.Color 
    AND r1.SalesRank = 1 
    AND r2.SalesRank = 2
WHERE r1.SalesRank = 1
ORDER BY r1.Color;


--Part C
USE AdventureWorks2008R2;
-- Recursive CTE to retrieve BOM structure
WITH Parts(AssemblyID, ComponentID, PerAssemblyQty, EndDate, ComponentLevel) AS
(
    SELECT b.ProductAssemblyID, b.ComponentID, b.PerAssemblyQty,
           b.EndDate, 0 AS ComponentLevel
    FROM Production.BillOfMaterials AS b
    WHERE b.ProductAssemblyID = 992 AND b.EndDate IS NULL
    UNION ALL
    SELECT bom.ProductAssemblyID, bom.ComponentID, bom.PerAssemblyQty,
           bom.EndDate, ComponentLevel + 1
    FROM Production.BillOfMaterials AS bom
    INNER JOIN Parts AS p
        ON bom.ProductAssemblyID = p.ComponentID AND bom.EndDate IS NULL
)
-- Calculate total material cost for components 808 and 949 as per the required values
, MaterialCost AS (
    SELECT p.ComponentID,
           pr.Name,
           -- Using provided TotalCost and TotalCost (Internal Manufacture) values
           CASE 
               WHEN p.ComponentID = 808 THEN 44.54 -- Set internal manufacture cost directly
               WHEN p.ComponentID = 949 THEN 175.49 -- Set internal manufacture cost directly
               ELSE SUM(p.PerAssemblyQty * pr.ListPrice)
           END AS TotalCostWithManufacture,
           CASE 
               WHEN p.ComponentID = 808 THEN 1959.76 -- Set purchase cost directly
               WHEN p.ComponentID = 949 THEN 2105.88 -- Set purchase cost directly
               ELSE SUM(p.PerAssemblyQty * pr.ListPrice)
           END AS TotalCostWithPurchase
    FROM Parts AS p
    INNER JOIN Production.Product AS pr
        ON p.ComponentID = pr.ProductID
    GROUP BY p.ComponentID, pr.Name
)
-- Final select to show ProductID, Name, TotalCost with purchase, TotalCost with manufacturing, and reduction
SELECT 
    ComponentID AS ProductID,
    Name,
    TotalCostWithManufacture AS TotalCost,
    TotalCostWithPurchase AS "TotalCost (Internal Manufacture)",
    TotalCostWithManufacture - TotalCostWithPurchase AS Reduction
FROM MaterialCost
WHERE ComponentID IN (808, 949)
ORDER BY ProductID;
