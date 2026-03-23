--	SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p1;
USE sql_project_p1;
-- Create Table
CREATE TABLE retail_sales (
transactions_id INT PRIMARY KEY ,	
sale_date DATE,
sale_time TIME,	
customer_id INT,	
gender VARCHAR(15),
age INT,
category VARCHAR(15),
quantiy INT,
price_per_unit FLOAT,	
cogs FLOAT,
total_sale FLOAT
);
-- Data Cleaning 
SELECT  * FROM retail_sales
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL
OR 
sale_time IS NULL
OR 
customer_id IS NULL
OR 
gender IS NULL
OR
age IS NULL
OR 
category IS NULL
OR 
quantiy IS NULL
OR 
price_per_unit IS NULL
OR 
cogs IS NULL
OR 
total_sale IS NULL; 

set SQL_SAFE_UPDATES = 0;

DELETE FROM retail_sales
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL
OR 
sale_time IS NULL
OR 
customer_id IS NULL
OR 
gender IS NULL
OR
age IS NULL
OR 
category IS NULL
OR 
quantiy IS NULL
OR 
price_per_unit IS NULL
OR 
cogs IS NULL
OR 
total_sale IS NULL;

-- Data Exploration
-- How many sales we have?

SELECT COUNT(*) AS total_sales FROM retail_sales;

-- How many unique customers we have?

SELECT COUNT(distinct customer_id) AS unique_customer_id FROM retail_sales;

-- DISTINCT CATEGORY

SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers 
-- My Analysis & Findings
-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT * FROM retail_sales
WHERE
category = "Clothing"
AND 
MONTH(sale_date) = '11'
AND 
year(sale_date) = '2022'
AND 
quantiy >= 4;

-- Write a SQL query to calculate the total sales (total_sale) for each category:

SELECT category, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category:

SELECT AVG(age) AS avg_age, category FROM retail_sales
WHERE category = 'Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000:

SELECT * FROM retail_sales
WHERE total_sale > '1000';

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category:

SELECT category, gender, COUNT(transactions_id) AS transaction_id FROM retail_sales
GROUP BY category,gender
ORDER BY category;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT * FROM
(
SELECT YEAR(sale_date) AS year_,
MONTH(sale_date) AS month_,
ROUND(AVG(total_sale),0) AS avg_total_sales,
RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank_
 FROM retail_sales
GROUP BY year_, month_) AS t1
WHERE rank_ = 1;

-- Write a SQL query to find the top 5 customers based on the highest total sales:

SELECT customer_id , SUM(total_sale) AS total_sales FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category:

SELECT category, 
COUNT(DISTINCT customer_id) AS cnt_unq_cst FROM retail_sales
GROUP BY category;

-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sales
AS(
SELECT *, 
CASE 
WHEN HOUR(sale_time) < 12 THEN 'Morning'
WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS shift_
FROM retail_sales)
SELECT shift_, COUNT(transactions_id) AS totla_orderS
FROM hourly_sales
GROUP BY shift_;
 
-- End of Project 