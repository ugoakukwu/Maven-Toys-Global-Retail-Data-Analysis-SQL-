USE MavenToysDB;

-- 1. Import Products Data
LOAD DATA INFILE 'C:/path/to/your/products.csv' 
INTO TABLE Products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Skips the header row

-- 2. Import Stores Data
LOAD DATA INFILE 'C:/path/to/your/stores.csv' 
INTO TABLE Stores
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 3. Import Sales Data
LOAD DATA INFILE 'C:/path/to/your/sales.csv' 
INTO TABLE Sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 4. Import Inventory Data
LOAD DATA INFILE 'C:/path/to/your/inventory.csv' 
INTO TABLE Inventory
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'



-- Important: You must replace 'C:/path/to/your/file/' with the actual folder path on your computer where your CSVs are saved.

  Troubleshooting the "Secure File" Error
-- If you run this and get an error saying --secure-file-priv, it’s because MySQL has a security setting that only allows it to read files from a specific "safe" folder.
-- 2 ways to fix this:
-- Option A: The "Safe Folder" Trick (Easiest) Run this command in MySQL: 
  
  SHOW VARIABLES LIKE "secure_file_priv";

-- It will give you a folder path (usually something like C:/ProgramData/MySQL/MySQL Server 8.0/Uploads). Move your CSV files into that exact folder. Update the script above to point to that folder, and it will run perfectly.

Option B: Use the Import Wizard (User Friendly) If the script is too technical for your local setup, you can use the MySQL Workbench Table Data Import Wizard: Right-click your table (e.g., Sales) in the Navigator on the left. Select Table Data Import Wizard. Browse for your CSV and follow the prompts.

IGNORE 1 ROWS;
