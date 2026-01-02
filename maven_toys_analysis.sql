/*
===========================================================================
MAVEN TOYS: GLOBAL RETAIL DATA ANALYSIS
Author: [Your Name]
Tool: MySQL
Description: This script contains 30 queries ranging from basic data 
             exploration to advanced business intelligence (YoY Growth, 
             Inventory Turnover, and Market Basket Analysis).
===========================================================================
*/

-- -------------------------------------------------------------------------
-- MODULE 1: DATA CLEANING & SCHEMA OPTIMIZATION
-- -------------------------------------------------------------------------

-- Disable Safe Updates to allow bulk calculation of the Total_Price column
SET SQL_SAFE_UPDATES = 0;

-- Adding a calculated column for Total Price to optimize future queries
ALTER TABLE Sales ADD COLUMN Total_Price DECIMAL(15, 2);

UPDATE Sales SET Total_Price = Units * Unit_Sale_Price;

-- Re-enable Safe Updates (Best Practice)
SET SQL_SAFE_UPDATES = 1;


-- -------------------------------------------------------------------------
-- MODULE 2: BASIC EXPLORATION (Beginner Level)
-- -------------------------------------------------------------------------

-- Q6: List all products with a price greater than $50.00
SELECT Product_Name, Product_Price 
FROM Products 
WHERE Product_Price > 50.00 
ORDER BY Product_Price DESC;

-- Q8: Total units sold by Store_ID 3
SELECT SUM(Units) AS Total_Units_Sold_Store_3 
FROM Sales 
WHERE Store_ID = 3;

-- Q9: Current stock on hand for Store_ID 5
SELECT Product_ID, Stock_On_Hand 
FROM Inventory 
WHERE Store_ID = 5;

-- Q10: Unique Product Categories
SELECT DISTINCT Product_Category FROM Products;


-- -------------------------------------------------------------------------
-- MODULE 3: SALES & PROFITABILITY ANALYSIS (Intermediate Level)
-- -------------------------------------------------------------------------

-- Q11: Top 5 Best-Selling Products by Unit Volume
SELECT p.Product_Name, SUM(s.Units) AS Total_Units_Sold
FROM Sales s
JOIN Products p ON s.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Total_Units_Sold DESC
LIMIT 5;

-- Q12 & Q18: Most Profitable Stores (Including Revenue & Margin)
SELECT 
    st.Store_Name,
    SUM(s.Units * p.Product_Price) AS Total_Revenue,
    SUM(s.Units * (p.Product_Price - p.Product_Cost)) AS Total_Profit,
    ROUND((SUM(s.Units * (p.Product_Price - p.Product_Cost)) / SUM(s.Units * p.Product_Price)) * 100, 2) AS Margin_Percentage
FROM Sales s
JOIN Products p ON s.Product_ID = p.Product_ID
JOIN Stores st ON s.Store_ID = st.Store_ID
GROUP BY st.Store_Name
ORDER BY Total_Profit DESC;

-- Q14: Identify the single highest revenue day in history
SELECT s.Date, SUM(s.Units * p.Product_Price) AS Total_Daily_Revenue
FROM Sales s
JOIN Products p ON s.Product_ID = p.Product_ID
GROUP BY s.Date
ORDER BY Total_Daily_Revenue DESC
LIMIT 1;

-- Q19: Monthly Sales Trends (Seasonality)
SELECT 
    MONTHNAME(Date) AS Month_Name,
    SUM(Units * Unit_Sale_Price) AS Monthly_Revenue
FROM Sales
GROUP BY MONTH(Date), MONTHNAME(Date)
ORDER BY MONTH(Date);

-- Q20: Average Transaction Value (ATV) by Store
SELECT 
    st.Store_Name,
    ROUND(SUM(s.Units * p.Product_Price) / COUNT(s.Sale_ID), 2) AS Avg_Transaction_Value
FROM Sales s
JOIN Products p ON s.Product_ID = p.Product_ID
JOIN Stores st ON s.Store_ID = st.Store_ID
GROUP BY st.Store_Name
ORDER BY Avg_Transaction_Value DESC;


-- -------------------------------------------------------------------------
-- MODULE 4: INVENTORY & OPERATIONAL INSIGHTS (Advanced Level)
-- -------------------------------------------------------------------------

-- Q17: Low Stock Warning System (Items < 10 units in stock)
SELECT st.Store_Name, p.Product_Name, i.Stock_On_Hand
FROM Inventory i
JOIN Products p ON i.Product_ID = p.Product_ID
JOIN Stores st ON i.Store_ID = st.Store_ID
WHERE i.Stock_On_Hand < 10;

-- Q24: Dead Stock Identification (Products with ZERO sales)
SELECT p.Product_ID, p.Product_Name 
FROM Products p
LEFT JOIN Sales s ON p.Product_ID = s.Product_ID
WHERE s.Sale_ID IS NULL;

-- Q26: Inventory Turnover Ratio (Supply Chain Efficiency)
WITH SalesVolume AS (
    SELECT Product_ID, SUM(Units) AS Total_Sold FROM Sales GROUP BY Product_ID
),
AverageStock AS (
    SELECT Product_ID, AVG(Stock_On_Hand) AS Avg_Stock FROM Inventory GROUP BY Product_ID
)
SELECT 
    p.Product_Name,
    ROUND(sv.Total_Sold / NULLIF(as_st.Avg_Stock, 0), 2) AS Turnover_Ratio
FROM Products p
JOIN SalesVolume sv ON p.Product_ID = sv.Product_ID
JOIN AverageStock as_st ON p.Product_ID = as_st.Product_ID
ORDER BY Turnover_Ratio DESC;

-- Q29: Recency Analysis (Days since last sale per product)
SELECT 
    p.Product_Name,
    DATEDIFF((SELECT MAX(Date) FROM Sales), MAX(s.Date)) AS Days_Since_Last_Sale
FROM Products p
JOIN Sales s ON p.Product_ID = s.Product_ID
GROUP BY p.Product_Name
ORDER BY Days_Since_Last_Sale DESC;


-- -------------------------------------------------------------------------
-- MODULE 5: BUSINESS INTELLIGENCE & WINDOW FUNCTIONS
-- -------------------------------------------------------------------------

-- Q22: Year-over-Year (YoY) Revenue Growth
WITH YearlyRevenue AS (
    SELECT YEAR(Date) AS SalesYear, SUM(Units * Unit_Sale_Price) AS Revenue
    FROM Sales GROUP BY YEAR(Date)
)
SELECT 
    SalesYear,
    Revenue AS Current_Revenue,
    LAG(Revenue) OVER (ORDER BY SalesYear) AS Prev_Revenue,
    ROUND(((Revenue - LAG(Revenue) OVER (ORDER BY SalesYear)) / LAG(Revenue) OVER (ORDER BY SalesYear)) * 100, 2) AS Growth_Pct
FROM YearlyRevenue;

-- Q25: Top 3 Best-Sellers Per Category (DENSE_RANK)
WITH ProductRanks AS (
    SELECT 
        p.Product_Category, p.Product_Name, SUM(s.Units) AS Total_Units,
        DENSE_RANK() OVER (PARTITION BY p.Product_Category ORDER BY SUM(s.Units) DESC) AS Category_Rank
    FROM Sales s
    JOIN Products p ON s.Product_ID = p.Product_ID
    GROUP BY p.Product_Category, p.Product_Name
)
SELECT * FROM ProductRanks WHERE Category_Rank <= 3;

-- Q30: Market Basket Analysis (Product Affinity)
-- Identifies products frequently bought together on the same day in the same store
SELECT 
    p1.Product_Name AS Product_A,
    p2.Product_Name AS Product_B,
    COUNT(*) AS Times_Bought_Together
FROM Sales s1
JOIN Sales s2 ON s1.Date = s2.Date AND s1.Store_ID = s2.Store_ID AND s1.Product_ID < s2.Product_ID
JOIN Products p1 ON s1.Product_ID = p1.Product_ID
JOIN Products p2 ON s2.Product_ID = p2.Product_ID
GROUP BY p1.Product_Name, p2.Product_Name
ORDER BY Times_Bought_Together DESC
LIMIT 10;
