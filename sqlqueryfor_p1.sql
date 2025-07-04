-- SQL Retail Sales Analysis
CREATE DATABASE sql_project_p1;
-- create tables
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales 
			(
				transactions_id	INT,
				sale_date	DATE,
				sale_time	TIME,
				customer_id	INT,
				gender	VARCHAR(15),
				age	INT,
				category VARCHAR(15) ,	
				quantity INT,
				price_per_unit	FLOAT,
				cogs	FLOAT,
				total_sale FLOAT
			);

-- DATA CLEANING
SELECT * FROM retail_sales
WHERE
transactions_id	IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL	
OR
customer_id	IS NULL
OR
gender IS NULL
OR
age	IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL	
OR
cogs IS NULL	
OR
total_sale IS NULL;

DELETE FROM retail_sales
WHERE
transactions_id	IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL	
OR
customer_id	IS NULL
OR
gender IS NULL
OR
age	IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL	
OR
cogs IS NULL	
OR
total_sale IS NULL;

-- DATA EXPLORATION
--How many sales we have
SELECT COUNT(*) as total_sales FROM retail_sales;

--How many unique customers we have
SELECT COUNT (DISTINCT customer_id) as total_customers FROM retail_sales;

-- How many unique categories we have?
SELECT DISTINCT category as total_categories FROM retail_sales;

--DATA Analysis and BUSINESS key Problems

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';
-- query to view all the transactions where category is clothing and quantity sold is more than or equal to 4 in the month of November
SELECT * FROM retail_sales
WHERE category = 'Clothing'
AND quantity >= 4
AND sale_date between '2022-11-01' AND '2022-11-30';

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity >= 4
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';

-- Query to calculate total sales for each category
SELECT category, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;

-- Average age of customers who purchased items from Beauty category

SELECT ROUND(AVG(age),2) 
FROM retail_sales 
WHERE category = 'Beauty';

--query to find all the transactions where total sales is more than 1000

SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- total number of tansactions made by each gender in each category

SELECT COUNT(transactions_id),
gender,
category
FROM retail_sales
GROUP BY 2,3;

--query to calculate avg sale for each month and best month in each year

SELECT
  DATE_TRUNC('month', sale_date) AS month,
  ROUND(CAST(AVG(total_sale) AS numeric), 2) AS avg_sale
FROM retail_sales
GROUP BY month
ORDER BY month;

SELECT
year,
month,
avg_sale
FROM
(SELECT
  EXTRACT(YEAR FROM sale_date) AS year,
  EXTRACT(MONTH FROM sale_date) AS month,
  ROUND(CAST(AVG(total_sale) AS numeric), 2) AS avg_sale,
  RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank  
FROM retail_sales
GROUP BY year, month
ORDER BY year, avg_sale DESC) as t1
WHERE rank = 1;

-- query to find top 5 customers based on the total sales 

SELECT 
SUM(total_sale) as total_by_customer,
customer_id
FROM retail_sales
GROUP BY customer_id
ORDER BY 1 DESC;


-- query to find the number of unique customers who purchased the items from each category

SELECT COUNT(*) 
FROM (
  SELECT customer_id
  FROM retail_sales
  WHERE category IN ('Clothing', 'Beauty', 'Electronics')
  GROUP BY customer_id
  HAVING COUNT(DISTINCT category) = 3
) AS sub;

-- Unique Customer from any of the categories,
SELECT COUNT(DISTINCT customer_id),
category
FROM retail_sales as Unique_customers
GROUP BY category;

-- query to create each shift and number of orders, eg shift till 12 , 12 to 5, and after 5 

SELECT 
  CASE 
    WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning (Till 12)'
    WHEN EXTRACT(HOUR FROM sale_time) >= 12 AND EXTRACT(HOUR FROM sale_time) < 17 THEN 'Afternoon (12 to 5)'
    ELSE 'Evening (After 5)'
  END AS shift,
  COUNT(*) AS number_of_orders
FROM 
  retail_sales
GROUP BY 
  shift
ORDER BY 
  number_of_orders DESC;

  WITH shift_data AS (
  SELECT 
    CASE 
      WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
      WHEN EXTRACT(HOUR FROM sale_time) < 17 THEN 'Afternoon'
      ELSE 'Evening'
    END AS shift
  FROM retail_sales
)
SELECT shift, COUNT(*) AS number_of_orders
FROM shift_data
GROUP BY shift;

