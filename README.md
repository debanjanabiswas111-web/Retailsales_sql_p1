# Retail Sales Analysis Using SQL

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

This project focuses on analyzing a retail sales dataset using PostgreSQL. It covers database creation, data cleaning, exploratory data analysis (EDA), and business-driven SQL queries designed to extract meaningful insights about customers, products, and sales performance.

## Objectives

The goal of this project is to understand retail sales patterns using SQL. The analysis explores customer behavior, product category performance, seasonal trends, and high-value transactions.

The SQL scripts include:

Table creation & staging

Data validation & cleaning

Exploratory analysis queries

Window functions for ranking

Revenue, frequency, and customer-centric insights

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount. A new table named 'retail_sales_staging1' is also created to protect the original data.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

CREATE TABLE retail_sales_staging1 AS
TABLE retail_sales;
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales_staging1;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales_staging1;
SELECT DISTINCT category FROM retail_sales_staging1;

SELECT * FROM retail_sales_staging1
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales_staging1
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write an SQL query to retrieve all columns for sales made on '2022-11-06**:
```sql
SELECT *
FROM retail_sales_staging1
WHERE sale_date = '2022-11-06';
```

2. **Write an SQL query to retrieve all transactions where the category is 'Beauty' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT 
  *
FROM retail_sales_staging1
WHERE 
    category = 'Beauty'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
```

3. **Write an SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales_staging1
GROUP BY category;
```

4. **Write an SQL query to find the average age of customers who purchased items from the 'Electronics' category.**:
```sql
SELECT ROUND(AVG(age),2)
FROM retail_sales_staging1
WHERE category = 'Electronics'
```

5. **Write an SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT transactions_id 
FROM retail_sales_staging1
WHERE total_sale>1000
```

6. **Write an SQL query to find the total number of transactions (transaction_id) made by each gender in each category**:
```sql
SELECT 
category, gender,
COUNT(*) as total_trans
FROM retail_sales_staging1
GROUP BY category, gender
ORDER BY 1
```

7. **Write an SQL query to calculate the average sale for each month and also find out best selling month in each year**:
```sql
SELECT year, month, avg_sales
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sales,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales_staging1
    GROUP BY 1, 2
) AS t1
WHERE rank = 1;
```

8. **Write an SQL query to find the top 3 customers based on the highest total sales**:
```sql
SELECT 
    customer_id,
    SUM(total_sale) AS sumtotal_sale
FROM retail_sales_staging1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;
```

9. **Write an SQL query to find the number of unique customers who purchased items of each category.**:
```sql
SELECT category,
COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales_staging1
GROUP BY category;
```

10. **Write an SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 16, Evening >16)**:
```sql
WITH hourly_sale AS (
    SELECT 
        *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 16 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales_staging1
)

SELECT 
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```
11. **Write an sql query to find the hourly revenue based on the above findings.**:
```sql
SELECT 
    EXTRACT(HOUR FROM sale_time) AS hour_of_day,
    SUM(total_sale) AS hourly_revenue
FROM retail_sales_staging1
GROUP BY hour_of_day
ORDER BY hour_of_day;
```

## Findings

**1. Customer Demographics**

Sales are distributed across customers of various age groups, revealing a diverse customer base. Certain categories—like Electronics, Beauty, and Clothing—show stronger engagement among specific segments.

**2. High-Value Transactions**

Multiple records exceed ₹1000 in total sales, indicating frequent premium purchases. These transactions often occur in high-price categories and help identify valuable customer segments.

**3. Sales Trends**

Month-wise analysis highlights natural fluctuations in demand.
Using window functions, the best-performing month of each year was identified, uncovering:

Peak seasonal periods

Category-specific boosts

Monthly revenue patterns

**4. Customer Insights**

The dataset reveals:

The top customers based on total spending

The unique number of customers per category

How purchases differ by gender and age groups

These insights contribute toward targeted marketing and inventory planning.

## Reports
**1. Sales Summary**

A comprehensive breakdown including: Total sales per category, Total orders, Revenue contribution, Average customer age per segment

**2. Trend Analysis**

Reports derived from: Monthly sales performance, Hourly and shift-wise traffic patterns, Best-performing month each year

**3. Customer Insights**

Includes: Top-spending customers, Customer distribution across categories and High-value transaction patterns.

## Conclusion

This project demonstrates how SQL can be used to transform raw transactional data into valuable business insights. From basic filtering and aggregation to advanced window functions, the analysis highlights: 
Category-level profitability
Sales performance across time
Operational patterns (like shifts and hourly revenue)
Customer purchasing behavior
These insights support data-driven decision-making for marketing, resource allocation, inventory planning, and customer segmentation.


