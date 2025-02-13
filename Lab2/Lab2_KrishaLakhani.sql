/*
Name - Krisha Lakhani
NUID - 002334794
Subject - Data Management and Database Design(DAMG6210)
Lab 2
*/

USE AdventureWorks2008R2;
--Question 1
SELECT 
    SalesPersonID,
    CAST(MAX(OrderDate) AS DATE) AS MostRecentOrderDate,
    COUNT(*) AS TotalOrders
FROM  Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL
GROUP BY SalesPersonID
ORDER BY TotalOrders DESC;

--Question 2
SELECT 
    P.ProductID,
    P.Name AS ProductName,
    COUNT(*) AS TimesSold,
    SUM(SOD.OrderQty) AS TotalSoldQuantity
FROM Sales.SalesOrderDetail SOD
INNER JOIN Production.Product P ON SOD.ProductID = P.ProductID
GROUP BY P.ProductID, P.Name
HAVING COUNT(*) > 353
ORDER BY TimesSold DESC, P.ProductID ASC;

--Question 3
SELECT 
    ST.TerritoryID,
    ST.Name AS TerritoryName,
    COUNT(DISTINCT SO.CustomerID) AS UniqueCustomers,
    COUNT(SO.SalesOrderID) AS TotalOrders,
    COUNT(SO.SalesOrderID) / COUNT(DISTINCT SO.CustomerID) AS OrdersToCustomerRatio
FROM  Sales.SalesTerritory ST
INNER JOIN Sales.SalesOrderHeader SO ON ST.TerritoryID = SO.TerritoryID
GROUP BY ST.TerritoryID, ST.Name
HAVING COUNT(SO.SalesOrderID) / COUNT(DISTINCT SO.CustomerID) >= 5
ORDER BY ST.TerritoryID;

--Question 4
SELECT CAST(soh.OrderDate AS DATE) AS OrderDate, 
       SUM(od.OrderQty) AS TotalProductQuantitySold
FROM Sales.SalesOrderHeader AS soh
JOIN Sales.SalesOrderDetail AS od ON soh.SalesOrderID = od.SalesOrderID
WHERE soh.TotalDue <= 500
GROUP BY CAST(soh.OrderDate AS DATE)
HAVING COUNT(soh.SalesOrderID) > 0
ORDER BY TotalProductQuantitySold DESC;

--Question 5
SELECT 
    c.CustomerID, 
    p.LastName, 
    p.FirstName, 
    CAST(SUM(soh.TotalDue) AS INT) AS TotalPurchaseAmount
FROM Sales.Customer c
INNER JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
INNER JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
WHERE soh.TotalDue > 100000
GROUP BY c.CustomerID, p.LastName, p.FirstName
HAVING COUNT(soh.SalesOrderID) > 3
ORDER BY c.CustomerID;
   
--Question 6
SELECT 
    YEAR(SOH.OrderDate) AS Year,
    DATEPART(QUARTER, SOH.OrderDate) AS Quarter,
    CAST(SUM(SOH.TotalDue) AS INT) AS TotalQuarterlySales,
    CAST(SUM(CASE WHEN P.Color = 'Black' OR P.Color IS NULL THEN SOD.UnitPrice * SOD.OrderQty ELSE 0 END) AS INT) AS BlackAndNoColorSales
FROM Sales.SalesOrderHeader SOH
INNER JOIN Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN Production.Product P ON SOD.ProductID = P.ProductID   
GROUP BY YEAR(SOH.OrderDate), DATEPART(QUARTER, SOH.OrderDate)
HAVING SUM(CASE WHEN P.Color = 'Black' OR P.Color IS NULL THEN SOD.UnitPrice * SOD.OrderQty ELSE 0 END) > 4000000
ORDER BY YEAR(SOH.OrderDate), DATEPART(QUARTER, SOH.OrderDate);
