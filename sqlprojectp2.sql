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

SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;


SELECT * FROM retail_sales_staging1

SELECT *
FROM retail_sales_staging1
WHERE
	transactions_id IS NULL
    OR
	sale_date IS NULL
	OR
    sale_time IS NULL
    OR
	gender IS NULL
    OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	
DELETE FROM retail_sales_staging1
WHERE
	transactions_id IS NULL
    OR
	sale_date IS NULL
	OR
    sale_time IS NULL
    OR
	gender IS NULL
    OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

SELECT * FROM retail_sales_staging1



--Write a SQL query to retrieve all columns for sales made on '2022-11-06'
SELECT *
FROM retail_sales_staging1
WHERE sale_date = '2022-11-06';

--Write a SQL query to retrieve all transactions where the category is 'Beauty' and the quantity sold is more than 4 in the month of Nov-2022
SELECT 
  *
FROM retail_sales_staging1
WHERE 
    category = 'Beauty'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4

--Write the sql query to calculate the total sales for each category.

SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales_staging1
GROUP BY category;

--Write an sql query to find the average age of customers who purchased items from the 'Electronics' category.
SELECT ROUND(AVG(age),2)
FROM retail_sales_staging1
WHERE category = 'Electronics'

--Write an sql query to find all transactions where the total_sales is greater than 1000.
SELECT transactions_id 
FROM retail_sales_staging1
WHERE total_sale>1000

--Write an sql query to find the total no. of transactions made by each gender in each category.
SELECT 
category, gender,
COUNT(*) as total_trans
FROM retail_sales_staging1
GROUP BY category, gender
ORDER BY 1

---Write  an sql query to calculate the average sale for each m onth, also find the best selling month for each year.
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

--Write an sql query to find the top 3 customers based on the highest total sales.
SELECT 
    customer_id,
    SUM(total_sale) AS sumtotal_sale
FROM retail_sales_staging1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

--Write an sql query to find the number of unique customers who purchased items of each category
SELECT category,
COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales_staging1
GROUP BY category;

--Write an sql query to create each shift and no. of orders (EG. Morning<=12, afternoon between 12 and 16, evening >16)

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

--Write an sql query to find the hourly revenue based on the above findings.

SELECT 
    EXTRACT(HOUR FROM sale_time) AS hour_of_day,
    SUM(total_sale) AS hourly_revenue
FROM retail_sales_staging1
GROUP BY hour_of_day
ORDER BY hour_of_day;