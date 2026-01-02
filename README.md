# Maven-Toys-Global-Retail-Data-Analysis-SQL-
This project involves a comprehensive end-to-end SQL analysis of Maven Toys, a fictional retail chain. Using a dataset of over 800,000 transactions, I performed data cleaning, architectural optimization, and deep-dive business intelligence to provide actionable insights for stakeholders. 
The analysis covers Financial Performance, Inventory Management, Store Operations, and Advanced Customer Behavior.

🏗️ Database Architecture
The database consists of four interconnected tables:

Sales: Transactional data (Date, Store_ID, Product_ID, Units).
Products: Catalog data (Price, Cost, Category).
Stores: Location data (City, Type, Opening Date).
Inventory: Real-time stock levels.

🚀 Key Business Modules
I organised the 30-query analysis into four strategic business modules:

1. Financial Growth & Profitability
Revenue Analysis: Calculated total revenue and profit margins per product.
YoY Growth: Implemented LAG() window functions to compare Year-over-Year performance.
Profit Analysis: Identified high-margin vs. low-margin categories to optimise the product mix.

2. Operational Efficiency & Store Performance
Store Tiering: Categorised stores based on sales volume using HAVING and RANK().
City Performance: Analysed geographic trends to identify the best locations for expansion.
Transaction Metrics: Calculated Average Transaction Value (ATV) per store location.

3. Supply Chain & Inventory Optimisation
Stockout Prevention: Built a low-stock alert system for items with < 10 units.
Inventory Turnover: Calculated the ratio of units sold vs. average stock on hand to identify slow-moving capital.
Dead Stock: Identified products with zero sales in the last 30 days using LEFT JOIN exclusion logic.

4. Advanced Market Basket Analysis
Product Affinity: Utilised a Self-Join to identify which products are most frequently purchased together. This helps in designing promotional bundles and store layouts.

🛠️ Technical Skills Demonstrated
Complex Joins: Inner, Left, and Self-Joins across 4 tables.
Aggregations: Multi-level GROUP BY, SUM, AVG, and COUNT DISTINCT.
Window Functions: DENSE_RANK(), LAG(), and SUM() OVER() for cumulative totals.
Common Table Expressions (CTEs): Used for modular, readable, and high-performance queries.
Data Cleaning: Managing Safe Update Mode and altering table schemas for optimised data types.

📈 Key Insights Found
Seasonality: Revenue spikes significantly in Q4 (October–December), suggesting a need for temporary staffing during these months.
The 80/20 Rule: 20% of products (primarily in the 'Electronics' and 'Toys' categories) drive nearly 75% of total profit.
Inventory Lag: 15% of the inventory in specific city locations has not moved in over 60 days, indicating a need for a clearance strategy.

📂 How to Use This Repo
Setup: Run the schema_setup.sql to create the tables.

Data Loading: Use the import_data.sql script to load the CSV files into your MySQL environment.

Analysis: The maven_toys_analysis.sql file contains all 30 queries, commented by business question.

## 📊 Dataset
The raw data used for this project can be found in the [data/](./data) folder of this repository. 
* **Source:** Maven Analytics (Maven Toys Challenge)
* **Format:** 4 CSV files (Sales, Products, Stores, Inventory)
