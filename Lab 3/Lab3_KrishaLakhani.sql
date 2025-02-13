/*
Name - Krisha Lakhani
NUID - 002334794
Subject - Data Management and Database Desgin(DAMG6210)
Lab 3
*/

USE AdventureWorks2008R2;

--Question 1
SELECT SalesPersonID, p.LastName, p.FirstName,
       COUNT (o.SalesOrderid) AS [Total Orders],
       CASE 
           WHEN COUNT (o.SalesOrderid) BETWEEN 1 AND 120 THEN 'Do more!'
           WHEN COUNT (o.SalesOrderid) BETWEEN 121 AND 320 THEN 'Fine!'
           ELSE 'Excellent!'
       END AS [Performance Rating]
FROM Sales.SalesOrderHeader o
JOIN Person.Person p
ON o.SalesPersonID = p.BusinessEntityID
GROUP BY o.SalesPersonID, p.LastName, p.FirstName
ORDER BY p.LastName, p.FirstName;

--Question 2
SELECT c.CustomerID, c.TerritoryID, FirstName, LastName,
       COUNT (o.SalesOrderid) AS [Total Orders],
       DENSE_RANK() OVER (PARTITION BY c.TerritoryID ORDER BY COUNT(o.SalesOrderid) DESC) AS [Rank]
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader o
ON c.CustomerID = o.CustomerID
JOIN Person.Person p
ON p.BusinessEntityID = c.PersonID
WHERE c.CustomerID > 25000
GROUP BY c.TerritoryID, c.CustomerID, FirstName, LastName;

--Question 3
WITH DailySales AS (
    SELECT 
        soh.OrderDate, 
        sod.ProductID, 
        p.Name AS ProductName, 
        SUM(sod.OrderQty) AS TotalQuantitySold
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    GROUP BY soh.OrderDate, sod.ProductID, p.Name
),
WorstSellingProducts AS (
    SELECT 
        OrderDate, 
        MIN(TotalQuantitySold) AS MinQuantitySold
    FROM DailySales
    GROUP BY OrderDate
)
SELECT 
    ds.OrderDate, 
    ds.ProductID, 
    ds.ProductName, 
    ds.TotalQuantitySold
FROM DailySales ds
JOIN 
    WorstSellingProducts wsp ON ds.OrderDate = wsp.OrderDate 
    AND ds.TotalQuantitySold = wsp.MinQuantitySold
ORDER BY ds.OrderDate DESC;

--Question 4
WITH SalespersonPerformance AS (
    SELECT 
        soh.SalesPersonID,
        p.LastName,
        p.FirstName,
        SUM(soh.TotalDue) AS TotalSales,
        COUNT(DISTINCT soh.ShipToAddressID) AS StatesShippedTo
    FROM Sales.SalesOrderHeader soh
    INNER JOIN Person.Person p ON soh.SalesPersonID = p.BusinessEntityID
    WHERE soh.SalesPersonID IS NOT NULL
    GROUP BY soh.SalesPersonID, p.LastName, p.FirstName
    HAVING COUNT(DISTINCT soh.ShipToAddressID) > 10
)
SELECT TOP 3
    sp.SalesPersonID,
    sp.LastName,
    sp.FirstName,
    sp.TotalSales,
    sp.StatesShippedTo
FROM SalespersonPerformance sp
ORDER BY sp.TotalSales DESC;

--Question 5 
 WITH ProductSales AS (
 
	SELECT 
        sod.SalesOrderID,
        sod.ProductID, 
        SUM(sod.OrderQty) AS TotalOrderQuantity,
        soh.TerritoryID
    FROM Sales.SalesOrderDetail sod
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    GROUP BY sod.SalesOrderID, sod.ProductID, soh.TerritoryID),
MostSoldProduct AS (
    SELECT 
        TerritoryID, 
        ProductID, 
        SalesOrderID,
        MAX(TotalOrderQuantity) AS MaxQuantity
    FROM ProductSales
    GROUP BY TerritoryID, ProductID, SalesOrderID
),
CustomerCount AS (
    SELECT 
        TerritoryID, 
        COUNT(CustomerID) AS TotalCustomers
    FROM Sales.Customer
    GROUP BY TerritoryID
)
SELECT 
    msp.TerritoryID,
    msp.ProductID AS MostSoldProductID,
    msp.SalesOrderID AS OrderWithHighestQuantity,
    cc.TotalCustomers
FROM MostSoldProduct msp
JOIN CustomerCount cc ON msp.TerritoryID = cc.TerritoryID
WHERE cc.TotalCustomers > 3500
ORDER BY msp.TerritoryID;