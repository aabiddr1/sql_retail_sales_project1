# Retail Sales Analysis – SQL Project

## 📘 Project Overview

**Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database Name**: `sql_project_p1`

This project helps beginners develop essential SQL skills by analyzing retail sales data. You will learn how to create and manage a database, clean and explore data, and answer business questions using SQL. It is a hands-on exercise designed for aspiring data analysts to build a solid foundation.

---

## 🎯 Project Objectives

### 1. Database Setup
- Create a PostgreSQL database and load the provided retail sales dataset.

### 2. Data Cleaning
- Identify and remove records with missing or null values to ensure clean and consistent data.

### 3. Exploratory Data Analysis (EDA)
- Understand data distribution, trends, and patterns using SQL queries.

### 4. Business Analysis
- Use SQL to answer specific business questions and uncover actionable insights.

---

## 📂 Project Structure

### 1. Database Setup

```sql
CREATE DATABASE sql_project_p1;

DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
    transactions_id INT,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

---

### 2. Data Cleaning

```sql
-- Find null values
SELECT * FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- Delete null records
DELETE FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
```

---

### 3. Exploratory Data Analysis (EDA)

```sql
-- Total sales
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- Unique customers
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;

-- Unique categories
SELECT DISTINCT category AS total_categories FROM retail_sales;

-- Transactions on a specific date
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';

-- Clothing sales with quantity >= 4 in November
SELECT * FROM retail_sales
WHERE category = 'Clothing'
  AND quantity >= 4
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

-- Total sales by category
SELECT category, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;

-- Average age for Beauty category
SELECT ROUND(AVG(age), 2)
FROM retail_sales
WHERE category = 'Beauty';

-- Transactions with total sales > 1000
SELECT * FROM retail_sales WHERE total_sale > 1000;

-- Transactions by gender and category
SELECT COUNT(transactions_id), gender, category
FROM retail_sales
GROUP BY gender, category;
```

---

### 4. Business Analysis

```sql
-- Average sale per month
SELECT DATE_TRUNC('month', sale_date) AS month,
       ROUND(CAST(AVG(total_sale) AS NUMERIC), 2) AS avg_sale
FROM retail_sales
GROUP BY month
ORDER BY month;

-- Best month in each year
SELECT year, month, avg_sale
FROM (
    SELECT EXTRACT(YEAR FROM sale_date) AS year,
           EXTRACT(MONTH FROM sale_date) AS month,
           ROUND(CAST(AVG(total_sale) AS NUMERIC), 2) AS avg_sale,
           RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY year, month
) AS t
WHERE rank = 1;

-- Top 5 customers by sales
SELECT customer_id, SUM(total_sale) AS total_by_customer
FROM retail_sales
GROUP BY customer_id
ORDER BY total_by_customer DESC
LIMIT 5;

-- Customers who bought from all 3 categories
SELECT COUNT(*)
FROM (
    SELECT customer_id
    FROM retail_sales
    WHERE category IN ('Clothing', 'Beauty', 'Electronics')
    GROUP BY customer_id
    HAVING COUNT(DISTINCT category) = 3
) AS sub;

-- Unique customers per category
SELECT COUNT(DISTINCT customer_id), category
FROM retail_sales
GROUP BY category;

-- Orders by shift (Morning, Afternoon, Evening)
SELECT
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning (Till 12)'
        WHEN EXTRACT(HOUR FROM sale_time) < 17 THEN 'Afternoon (12 to 5)'
        ELSE 'Evening (After 5)'
    END AS shift,
    COUNT(*) AS number_of_orders
FROM retail_sales
GROUP BY shift
ORDER BY number_of_orders DESC;
```

---

## 🎉 Summary

This beginner-friendly SQL project provides hands-on practice for:
- Database creation
- Data cleaning
- EDA with SQL
- Answering real-world business questions

Perfect for learners building a portfolio or preparing for SQL interviews. Feel free to fork, clone, and adapt it for your learning!

---

> ✨ Happy Querying!

