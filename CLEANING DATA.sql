SHOW VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = 1;

CREATE TABLE layoffs (
    company VARCHAR(255),
    location VARCHAR(255),
    industry VARCHAR(255),
    total_laid_off INT,
    percentage_laid_off DECIMAL(5,2),
    date DATE,
    stage VARCHAR(100),
    country VARCHAR(100),
    funds_raised_millions DECIMAL(10,2)
);
-- comment here
LOAD DATA INFILE '/Users/hildatorres/Documents/SQL PRACTICE/layoffs.csv'
INTO TABLE layoffs
FIELDS TERMINATED BY ','  -- Ensure values are separated by commas
OPTIONALLY ENCLOSED BY '"'  -- Handles text values with quotes
LINES TERMINATED BY '\n'  -- Ensures correct row splitting
IGNORE 1 ROWS;  -- Skips the header row
