Retail Sales Analysis – SQL Project

📘 Project Overview

Title: Retail Sales Analysis

Level: Beginner

Database Name: sql\_project\_p1

This project aims to help beginners develop essential SQL skills by analyzing real-world retail sales data. You'll learn how to create and manage a database, clean and explore data, and answer key business questions through SQL queries. It's a hands-on exercise designed for aspiring data analysts looking to build a strong foundation in SQL.

🎯 Project Objectives

Database Setup

Create a PostgreSQL database and load the provided retail sales dataset.

Data Cleaning

Identify and remove records with missing or null values to ensure data quality.

Exploratory Data Analysis (EDA)

Perform basic analysis to understand data distribution, trends, and patterns.

Business Analysis

Use SQL to answer specific business questions, uncover insights, and support decision-making.

📂 Project Structure

1\. Database Setup

Create Database: Start by creating a new database named sql\_project\_p1.

Create Table: Define and create a table called retail\_sales to store the dataset.

The table includes the following columns:

transaction\_id: Unique ID for each transaction

sale\_date: Date of the transaction

sale\_time: Time of the transaction

customer\_id: Unique ID of the customer

gender: Gender of the customer

age: Age of the customer

category: Product category

quantity: Quantity of products sold

price\_per\_unit: Price of a single unit

cogs: Cost of Goods Sold

total\_sale: Total sale amount

SQL QUERIES YOU CAN RUN:-

\-- SQL Retail Sales Analysis

CREATE DATABASE sql\_project\_p1;

\-- create tables

DROP TABLE IF EXISTS retail\_sales;

CREATE TABLE retail\_sales

(

transactions\_idINT,

sale\_dateDATE,

sale\_timeTIME,

customer\_idINT,

genderVARCHAR(15),

ageINT,

category VARCHAR(15) ,

quantity INT,

price\_per\_unitFLOAT,

cogsFLOAT,

total\_sale FLOAT

);

\-- DATA CLEANING

SELECT \* FROM retail\_sales

WHERE

transactions\_idIS NULL

OR

sale\_date IS NULL

OR

sale\_time IS NULL

OR

customer\_idIS NULL

OR

gender IS NULL

OR

ageIS NULL

OR

category IS NULL

OR

quantity IS NULL

OR

price\_per\_unit IS NULL

OR

cogs IS NULL

OR

total\_sale IS NULL;

DELETE FROM retail\_sales

WHERE

transactions\_idIS NULL

OR

sale\_date IS NULL

OR

sale\_time IS NULL

OR

customer\_idIS NULL

OR

gender IS NULL

OR

ageIS NULL

OR

category IS NULL

OR

quantity IS NULL

OR

price\_per\_unit IS NULL

OR

cogs IS NULL

OR

total\_sale IS NULL;

\-- DATA EXPLORATION

\--How many sales we have

SELECT COUNT(\*) as total\_sales FROM retail\_sales;

\--How many unique customers we have

SELECT COUNT (DISTINCT customer\_id) as total\_customers FROM retail\_sales;

\-- How many unique categories we have?

SELECT DISTINCT category as total\_categories FROM retail\_sales;

\--DATA Analysis and BUSINESS key Problems

SELECT \* FROM retail\_sales

WHERE sale\_date = '2022-11-05';

\-- query to view all the transactions where category is clothing and quantity sold is more than or equal to 4 in the month of November

SELECT \* FROM retail\_sales

WHERE category = 'Clothing'

AND quantity >= 4

AND sale\_date between '2022-11-01' AND '2022-11-30';

SELECT \*

FROM retail\_sales

WHERE category = 'Clothing'

AND quantity >= 4

AND sale\_date >= '2022-11-01'

AND sale\_date < '2022-12-01';

\-- Query to calculate total sales for each category

SELECT category, SUM(total\_sale) AS total\_sales

FROM retail\_sales

GROUP BY category

ORDER BY total\_sales DESC;

\-- Average age of customers who purchased items from Beauty category

SELECT ROUND(AVG(age),2)

FROM retail\_sales

WHERE category = 'Beauty';

\--query to find all the transactions where total sales is more than 1000

SELECT \* FROM retail\_sales

WHERE total\_sale > 1000;

\-- total number of tansactions made by each gender in each category

SELECT COUNT(transactions\_id),

gender,

category

FROM retail\_sales

GROUP BY 2,3;

\--query to calculate avg sale for each month and best month in each year

SELECT

DATE\_TRUNC('month', sale\_date) AS month,

ROUND(CAST(AVG(total\_sale) AS numeric), 2) AS avg\_sale

FROM retail\_sales

GROUP BY month

ORDER BY month;

SELECT

year,

month,

avg\_sale

FROM

(SELECT

EXTRACT(YEAR FROM sale\_date) AS year,

EXTRACT(MONTH FROM sale\_date) AS month,

ROUND(CAST(AVG(total\_sale) AS numeric), 2) AS avg\_sale,

RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale\_date) ORDER BY AVG(total\_sale) DESC) AS rank

FROM retail\_sales

GROUP BY year, month

ORDER BY year, avg\_sale DESC) as t1

WHERE rank = 1;

\-- query to find top 5 customers based on the total sales

SELECT

SUM(total\_sale) as total\_by\_customer,

customer\_id

FROM retail\_sales

GROUP BY customer\_id

ORDER BY 1 DESC;

\-- query to find the number of unique customers who purchased the items from each category

SELECT COUNT(\*)

FROM (

SELECT customer\_id

FROM retail\_sales

WHERE category IN ('Clothing', 'Beauty', 'Electronics')

GROUP BY customer\_id

HAVING COUNT(DISTINCT category) = 3

) AS sub;

\-- Unique Customer from any of the categories,

SELECT COUNT(DISTINCT customer\_id),

category

FROM retail\_sales as Unique\_customers

GROUP BY category;

\-- query to create each shift and number of orders, eg shift till 12 , 12 to 5, and after 5

SELECT

CASE

WHEN EXTRACT(HOUR FROM sale\_time) < 12 THEN 'Morning (Till 12)'

WHEN EXTRACT(HOUR FROM sale\_time) >= 12 AND EXTRACT(HOUR FROM sale\_time) < 17 THEN 'Afternoon (12 to 5)'

ELSE 'Evening (After 5)'

END AS shift,

COUNT(\*) AS number\_of\_orders

FROM

retail\_sales

GROUP BY

shift

ORDER BY

number\_of\_orders DESC;

WITH shift\_data AS (

SELECT

CASE

WHEN EXTRACT(HOUR FROM sale\_time) < 12 THEN 'Morning'

WHEN EXTRACT(HOUR FROM sale\_time) < 17 THEN 'Afternoon'

ELSE 'Evening'

END AS shift

FROM retail\_sales

)

SELECT shift, COUNT(\*) AS number\_of\_orders

FROM shift\_data

GROUP BY shift;

