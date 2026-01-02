-- 1. Create the Database
CREATE DATABASE IF NOT EXISTS MavenToysDB;
USE MavenToysDB;

-- 2. Create the Products Table
-- This is a 'Dimension' table containing product details.
CREATE TABLE Products (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(100) NOT NULL,
    Product_Category VARCHAR(50),
    Product_Cost DECIMAL(10, 2),
    Product_Price DECIMAL(10, 2)
);

-- 3. Create the Stores Table
-- This table defines the physical locations.
CREATE TABLE Stores (
    Store_ID INT PRIMARY KEY,
    Store_Name VARCHAR(100) NOT NULL,
    Store_City VARCHAR(100),
    Store_Location VARCHAR(100),
    Store_Open_Date DATE
);

-- 4. Create the Sales Table
-- This is the 'Fact' table containing transactions.
CREATE TABLE Sales (
    Sale_ID INT PRIMARY KEY,
    Date DATE NOT NULL,
    Store_ID INT,
    Product_ID INT,
    Units INT,
    -- Establishing relationships
    FOREIGN KEY (Store_ID) REFERENCES Stores(Store_ID),
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
);

-- 5. Create the Inventory Table
-- This links products to stores to show stock levels.
CREATE TABLE Inventory (
    Store_ID INT,
    Product_ID INT,
    Stock_On_Hand INT,
    -- Composite Primary Key (A store/product combo is unique)
    PRIMARY KEY (Store_ID, Product_ID),
    FOREIGN KEY (Store_ID) REFERENCES Stores(Store_ID),
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
);
