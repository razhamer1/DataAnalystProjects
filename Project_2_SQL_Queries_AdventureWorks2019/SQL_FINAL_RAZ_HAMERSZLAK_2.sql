-------------------------------------------------------------------------------------------
---------Project_No_2 - Extracting data from the AdventureWorks2019 database---------------
-------------------------------------------------------------------------------------------
------------------------------------Raz Hamerszlak-----------------------------------------
-------------------------------------------------------------------------------------------

-------------------
--Q_No.1 --Answer-- 
-------------------
/*Way 1*/
SELECT pp.ProductID,
	   pp.[Name] AS 'Productname',
	   pp.Color, pp.ListPrice,
	   pp.Size
FROM Sales.SalesOrderDetail sso JOIN Sales.SpecialOfferProduct ss
								ON (sso.ProductID=ss.ProductID)
								RIGHT JOIN Production.Product pp
								ON (ss.ProductID = pp.ProductID)
WHERE sso.ProductID IS NULL;
GO
/*Way 2*/
SELECT pp.ProductID,
	   pp.[Name] AS 'Productname',
	   pp.Color,
	   pp.ListPrice,
	   pp.Size
FROM Production.Product pp LEFT JOIN Sales.SalesOrderDetail od
								  ON (pp.ProductID=od.ProductID)
WHERE od.ProductID IS NULL
ORDER BY pp.ProductID;
GO

-----------------------------------------------------------------
--Q_No.2 --Answer--according to the first assignment for 701 rows
-----------------------------------------------------------------
SELECT sc.CustomerID,
	  CASE WHEN pp.LastName IS NULL OR pp.FirstName IS NULL 
			THEN 'Unknown'
			ELSE pp.LastName
			END AS LastName,
	  CASE WHEN pp.LastName IS NULL OR pp.FirstName IS NULL 
			THEN 'Unknown'
			ELSE pp.FirstName
			END AS FirstName
FROM Sales.Customer sc LEFT JOIN Person.Person pp
					   ON (pp.BusinessEntityID=sc.PersonID)
					   LEFT JOIN Sales.SalesOrderHeader so
					   ON (sc.CustomerID=so.CustomerID)
WHERE sc.personID IS NULL  
GO

-------------------
--Q_No.3 --Answer--
-------------------
WITH TBL#1 
AS
    (SELECT
        sc.CustomerID,
	    pp.FirstName, 
	    pp.LastName, 
        COUNT(so.SalesOrderID) AS 'CountOfOrders'
      FROM
        Person.Person pp JOIN Sales.Customer sc 
						 ON (pp.BusinessEntityID = sc.PersonID)
					     JOIN Sales.SalesOrderHeader so 
						 ON (sc.CustomerID = so.CustomerID)
     GROUP BY sc.CustomerID,  pp.FirstName, pp.LastName)
SELECT TOP (10) *
FROM TBL#1
ORDER BY CountOfOrders DESC;
GO

-------------------
--Q_No.4 --Answer--
-------------------
WITH TBL#1 
AS 
	(SELECT pp.FirstName, 
		   pp.LastName, 
		   he.JobTitle, 
		   he.HireDate,
		   CONCAT_WS (' ',pp.FirstName, pp.LastName) AS 'FULL NAME',
		   COUNT(CONCAT_WS (' ',pp.FirstName, pp.LastName)) OVER (PARTITION BY he.JobTitle) AS 'CountOfTitle'
	 FROM Person.Person pp JOIN HumanResources.Employee he
						   ON (pp.BusinessEntityID=he.BusinessEntityID))
SELECT FirstName, LastName, JobTitle, HireDate, CountOfTitle 
FROM TBL#1;
GO

------------------------------------------------------------------------------------
--Q_No.5 --Answer--according to the first assignment version but Order by CustomerID
------------------------------------------------------------------------------------
WITH TBL#1
AS
	(SELECT so.SalesOrderID,
		   sc.CustomerID,
		   pp.LastName, 
		   pp.FirstName,
		   so.OrderDate,
		   CONVERT(VARCHAR, so.OrderDate, 120) AS 'LastOrder',
		   CONVERT(VARCHAR, LAG (so.OrderDate) OVER(PARTITION BY sc.CustomerID ORDER BY so.SalesOrderNumber),120) AS 'PreviousOrder',
		   RANK()OVER(PARTITION BY sc.CustomerID ORDER BY so.OrderDate DESC) AS rnk
	FROM Sales.SalesOrderHeader so JOIN Sales.Customer sc
								   ON (so.CustomerID=sc.CustomerID)
								   JOIN Person.Person pp
								   ON (sc.PersonID=pp.BusinessEntityID))
SELECT SalesOrderID,
       CustomerID,
	   LastName,
	   FirstName,
	   LastOrder,
	   PreviousOrder
FROM TBL#1
WHERE rnk=1
ORDER BY CustomerID;
GO

-------------------
--Q_No.6 --Answer--
-------------------
WITH TBL#1
AS
		(SELECT YEAR (sh.OrderDate) AS 'Year',
		so.SalesOrderID,
		pp.LastName, 
		pp.FirstName, 
		FORMAT (SUM (so.UnitPrice*(1-so.UnitPriceDiscount)*so.OrderQty), 'N1', 'en-us') AS 'Total',
		RANK()OVER(PARTITION BY YEAR (sh.OrderDate) ORDER BY SUM (so.UnitPrice*(1-so.UnitPriceDiscount)*so.OrderQty) DESC) AS rnk
		FROM Sales.SalesOrderDetail so JOIN Sales.SalesOrderHeader sh
										ON (so.SalesOrderID=sh.SalesOrderID)
										JOIN Sales.Customer sc
										ON (sh.CustomerID=sc.CustomerID)
										JOIN Person.Person pp
										ON (sc.PersonID = pp. BusinessEntityID)
		GROUP BY YEAR (sh.OrderDate),so.SalesOrderID,pp.LastName,pp.FirstName)
SELECT Year, SalesOrderID,LastName,FirstName,Total 
FROM TBL#1
WHERE rnk=1;
GO

-------------------
--Q_No.7 --Answer--
-------------------
SELECT *
FROM (SELECT MONTH (ss.OrderDate) AS 'Month',
			 YEAR (ss.OrderDate) AS 'Year',
			 ss.SalesOrderID
	  FROM  Sales.SalesOrderHeader ss) Sa
PIVOT (COUNT(Sa.SalesOrderID) FOR [Year] IN ([2011],[2012],[2013],[2014]))PIV
ORDER BY [Month];
GO

-------------------
--Q_No.8 --Answer--
-------------------
WITH TBL#1 AS
	  (SELECT
			YEAR(sh.OrderDate) AS "Year",
			MONTH(sh.OrderDate) AS "Month",
			ROUND (SUM (sd.LineTotal), 2) AS Sum_Price,
			ROUND (SUM(SUM(sd.LineTotal)) OVER(PARTITION BY YEAR(sh.OrderDate) ORDER BY MONTH(sh.OrderDate)), 2) AS Cum_Sum,
			1 AS 'NULL/NOT_NULL'
		FROM
			Sales.SalesOrderHeader sh JOIN Sales.SalesOrderDetail sd 
									   ON sh.SalesOrderID = sd.SalesOrderID
		GROUP BY
			YEAR(sh.OrderDate),
			MONTH(sh.OrderDate)),
TBL#2 AS 
(SELECT Year,
		CAST("Month" AS VARCHAR) AS "Month",
        ROUND (Sum_Price,2) AS 'Sum_Price',
	    SUBSTRING (CAST (ROUND (Cum_Sum,2) AS varchar), -3, LEN ((CAST (ROUND (Cum_Sum,2) AS varchar)))) AS 'Cum_Sum',
		1 AS 'NULL/NOT_NULL'
  FROM TBL#1)
SELECT *
FROM TBL#2	   
UNION ALL
SELECT Year (sh.OrderDate) AS "Year",
	    'Grand_Total' AS "Month",
		ROUND (NULL,2) AS Sum_Price,
		SUBSTRING(CAST(ROUND (SUM(sd.LineTotal),2) AS varchar), -3, LEN(CAST(ROUND(SUM(sd.LineTotal),2) AS varchar))) AS Cum_Sum,
		NULL
FROM Sales.SalesOrderHeader sh JOIN Sales.SalesOrderDetail sd
								ON (sh.SalesOrderID=sd.SalesOrderID)
GROUP BY Year (sh.OrderDate)
ORDER BY Year, 'NULL/NOT_NULL' DESC
GO

-------------------
--Q_No.9 --Answer--
-------------------
WITH TBL#1
AS (SELECT hd.Name AS 'DepartmentName',
		   he.BusinessEntityID AS 'EmployeeID',
		   CONCAT_WS(' ',pp.FirstName, pp.LastName) AS 'Employees Full Name',
		   he.HireDate,
		   DATEDIFF (MM,he.HireDate,GETDATE()) AS 'Seniority',
		   LAG (CONCAT_WS(' ',pp.FirstName, pp.LastName)) OVER (PARTITION BY hd.Name ORDER BY he.HireDate) AS 'PreviusEmpName',
		   LAG (he.HireDate) OVER (PARTITION BY hd.Name ORDER BY he.HireDate) AS 'PreviusEmpHDate'
     FROM Person.Person pp JOIN HumanResources.Employee he
					  ON (pp.BusinessEntityID=he.BusinessEntityID)
					  JOIN HumanResources.EmployeeDepartmentHistory hh
					  ON (he.BusinessEntityID=hh.BusinessEntityID)
					  JOIN HumanResources.Department hd
					  ON (hh.DepartmentID=hd.DepartmentID))
SELECT DepartmentName,
	   EmployeeID,
	   [Employees Full Name],
	   HireDate,
	   Seniority,
	   PreviusEmpName,
	   PreviusEmpHDate,
	   DATEDIFF (dd, PreviusEmpHDate, HireDate) AS 'DIffDays'
FROM TBL#1
ORDER BY DepartmentName, HireDate DESC;
GO

-------------------
--Q_No.10 --Answer-
-------------------
WITH TBL#1
AS (SELECT hd.DepartmentID,
		   he.BusinessEntityID AS 'EmployeeID',
		   CONCAT_WS(' ', he.BusinessEntityID, pp.LastName, pp.FirstName) AS 'Employees Full Name',
		   he.HireDate,
		   ROW_NUMBER() OVER (PARTITION BY he.BusinessEntityID ORDER BY hh.StartDate DESC) AS rw
     FROM Person.Person pp JOIN HumanResources.Employee he
						   ON (pp.BusinessEntityID=he.BusinessEntityID)
						   JOIN HumanResources.EmployeeDepartmentHistory hh
						   ON (he.BusinessEntityID=hh.BusinessEntityID)
						   JOIN HumanResources.Department hd
						   ON (hh.DepartmentID=hd.DepartmentID))
SELECT T1.HireDate,
	   T1.DepartmentID,
	   STRING_AGG(CONCAT_WS(' ', pp.BusinessEntityID, pp.LastName, pp.FirstName),' ,') AS TeamEmployees
FROM TBL#1 T1 JOIN person.person as pp
		   ON (T1.EmployeeID=pp.BusinessEntityID)
WHERE T1.rw=1
GROUP BY T1.HireDate, T1.DepartmentID
ORDER BY T1.HireDate DESC;
GO
