--The following example finds the products that were sold with more than two units in a sales order:
SELECT product_name , list_price  FROM  production.products P
WHERE product_id = ANY(
	SELECT product_id 
	FROM  sales.order_items OI
	WHERE quantity >= 2 
)

--the following query finds the products whose list prices are bigger than the average list price of products of all brands:
SELECT product_name, list_price 
FROM production.products P
WHERE list_price > ALL(
		SELECT AVG(list_price)list_price
		FROM production.products
		group by brand_id
)
order by list_price

--Exercise 10: Find Customers with Gmail Addresses
--Objective: Practice using the LIKE operator for pattern matching.
--Task: Write a SQL query to retrieve the first_name, last_name, and email of all customers whose email ends with @gmail.com.
--You'll need the sales.customers table and the LIKE operator with a wildcard (%).

SELECT first_name , last_name , email  
FROM  sales.customers 
WHERE email like '%@gmail.com'
 

-- Exercise 11: Get the Top 5 Newest Orders
--Task: Write a SQL query to return the top 5 most recent orders.
--Show:
--order_id order_date customer_id

SELECT  TOP 5*  
FROM  sales.orders
ORDER BY order_date desc

--Exercise 12: Find Customers in Specific States
--Objective: Practice filtering using the IN operator with multiple values.
--Task: Write a SQL query to return first_name, last_name, and state
--for all customers located in California (CA), Texas (TX), or New York (NY).

SELECT first_name , last_name , state  
FROM  sales.customers
WHERE  state IN ('CA','TX','NY')


--Exercise 13: Count Customers Per State
--Objective: Practice using GROUP BY with aggregation.
--Task: Write a SQL query to return:
--state
--total_customers (i.e., the number of customers in each state)

SELECT state , count(customer_id) total_customers
FROM  sales.customers
GROUP BY state 
order by count(customer_id) 

--Exercise 14: Get Products Priced Between $500 and $1000
--Objective: Practice numeric filtering with BETWEEN.
--Task: Write a SQL query to return product_name and list_price
--from production.products where the price is between $500 and $1000, inclusive.

SELECT product_name , list_price
FROM production.products  
WHERE list_price BETWEEN 500 AND 1000

--Exercise 15: List the 10 Most Expensive Products
--Objective: Practice sorting with ORDER BY and limiting with TOP.
--Task: Write a SQL query to return the product_name and list_price
--for the top 10 most expensive products in production.products.

SELECT top 10  product_name ,list_price
FROM production.products
ORDER BY  list_price DESC

--Exercise 16: Find Orders with No Shipped Date
--Objective: Practice working with NULL values.
--Task: Write a SQL query to return order_id, order_date, and ship_date
--for all orders in sales.orders where the ship_date is null (i.e., not yet shipped).

SELECT order_id , order_date,shipped_date
FROM  sales.orders  
WHERE shipped_date IS NULL

--Exercise 17: Get Total Sales by Store
--Objective: Use JOIN, SUM(), and GROUP BY.
--Task: Write a SQL query to return:
--store_id total_sales (the sum of list_price * quantity for each store)

SELECT O.store_id ,ROUND((SUM((OI.quantity * OI.list_price) * (1- OI.discount))),0)  as total_sales
FROM  sales.order_items OI
INNER JOIN sales.orders O ON  O.order_id = OI.order_id
Inner JOIN sales.staffs S ON  O.store_id = S.store_id 
group  by O.store_id

--Exercise 18: List Employees and Their Managers
--Objective: Practice a self-join.
--Task: Write a SQL query to list:
--employee's first_name and last_name
--their manager's first_name and last_name

SELECT S.first_name , s.last_name  , M.first_name , M.last_name
FROM sales.staffs S
INNER JOIN sales.staffs  M  ON M.staff_id = S.manager_id


--Exercise 19: Get Total Revenue Per Product
--Objective: Aggregate total revenue per product.
--Task: Write a SQL query to return:
--product_id total_revenue (calculated as quantity * list_price * (1 - discount))
--Use the sales.order_items table and group by product_id.

SELECT OI.product_id ,p.product_name, SUM ((OI.quantity * OI.list_price) * (1-OI.discount)) as TotalSales
FROM sales.order_items OI  
INNER JOIN  production.products P ON P.product_id = OI.product_id
GROUP BY OI.product_id ,P.product_name


--Exercise 20: Find Customers Without Orders
--Objective: Use LEFT JOIN and IS NULL to find unmatched records.
--Task: Write a SQL query to return the first_name and last_name
--of customers who haven’t placed any orders.

SELECT  C.first_name , C.last_name 
FROM  sales.customers C 
LEFT JOIN  sales.orders O  on  O.customer_id = C.customer_id
WHERE O.customer_id IS NULL

--Exercise 21: Get Monthly Sales Revenue
--Objective: Use GROUP BY with date functions.
--Task: Write a SQL query to return:
--year month  total_sales (sum of quantity * list_price * (1 - discount))
--Use sales.orders and sales.order_items. Extract YEAR() and MONTH() from order_date.

SELECT YEAR(O.order_date) Year ,MONTH(O.order_date) Month ,SUM((OI.quantity * OI.list_price) * (1-OI.discount)) AS Total_Sales 
FROM  sales.orders O
INNER JOIN  sales.order_items OI ON OI.order_id =O.order_id  
GROUP BY YEAR(O.order_date) ,MONTH(O.order_date) 

--Exercise 22: List the Number of Products in Each Category
--Objective: Practice grouping with joins.
--Task: Write a SQL query to return:
--category_name
--product_count (the number of products in that category)

SELECT C.category_id ,COUNT(p.product_name)  as productCount  
FROM production.products P
LEFT JOIN production.categories C ON C.category_id = P.category_id
GROUP BY C.category_id

--Exercise 23: Get the Average Discount Per Product
--Objective: Use AVG() with grouping.
--Task: Write a SQL query to return:
--product_id  average_discount
--Use sales.order_items and group by product_id.

SELECT  OI.product_id , P.product_name, AVG(OI.discount) as AvgDescount   
FROM production.products  P
INNER JOIN sales.order_items OI ON OI.product_id = P.product_id 
GROUP BY OI.product_id , P.product_name

--Exercise 24: Show Total Sales by Brand
--Objective: Aggregate sales data across brands.
--Task: Write a SQL query to return:
--brand_name total_sales (sum of quantity * list_price * (1 - discount))
--Use the sales.order_items, production.products, and production.brands tables.

SELECT B.brand_id ,B.brand_name ,SUM(OI.quantity * OI.list_price * (1-OI.discount)) AS  TotalSales
 FROM sales.order_items OI 
INNER JOIN production.products P ON P.product_id = OI.product_id 
LEFT JOIN production.brands B ON B.brand_id = P.brand_id
GROUP BY B.brand_id ,B.brand_name


--Exercise 25: List Customers Who Placed Orders in 2017
--Objective: Combine filtering with joins and date functions.
--Task: Write a SQL query to return:
--first_name, last_name order_date
--Only include orders placed in the year 2017.

SELECT C.first_name , C.last_name , O.order_date
FROM sales.customers C
Inner JOIN sales.orders O ON  O.customer_id = C.customer_id 
WHERE YEAR(O.order_date) = 2017

--Exercise 26: Find the Top-Selling Store by Revenue
--Objective: Identify the store with the highest total sales.
--Task: Write a SQL query to return:
--store_id total_revenue (from order_items)
--Return only the store with the highest revenue. Use TOP 1 or a window function.

SELECT TOP 1 O.store_id , S.store_name , SUM(OI.quantity * OI.list_price * (1 - OI.discount)) AS TotalSales
FROM  sales.orders O
INNER JOIN sales.order_items OI ON OI.order_id= O.order_id 
INNER JOIN sales.stores S ON  S.store_id = O.store_id 
GROUP BY  O.store_id , S.store_name
ORDER BY  SUM(OI.quantity * OI.list_price * (1 - OI.discount)) DESC

--Exercise 27: List Products That Were Never Sold
--Objective: Use a LEFT JOIN with NULL filtering.
--Task: Write a SQL query to return: product_id product_name 
--Only include products that never appeared in any order. Use production.products and sales.order_items.

SELECT P.product_id, P.product_name ,o.product_id
FROM production.products P
LEFT JOIN sales.order_items O ON O.product_id = P.product_id
WHERE O.product_id IS NULL;

--Exercise 28: Rank Customers by Total Spend
--Objective: Use aggregate and ranking functions.
--Task: Write a query to return:
--customer_id first_name, last_name total_spent rank (1 = highest spender)
--Use a window function to rank customers based on total amount spent.

SELECT C.first_name ,C.last_name  ,  SUM(OI.list_price * OI.quantity * (1 - OI.discount)) AS total_spent,
Rank() OVER (ORDER BY SUM(OI.list_price * OI.quantity * (1-OI.discount))) as rank_num  
FROM sales.customers C 
LEFT JOIN sales.orders O ON  C.customer_id =O.customer_id
INNER JOIN sales.order_items OI ON OI.order_id =O.order_id 
GROUP BY C.customer_id, C.first_name, C.last_name;

--Exercise 29: Monthly Revenue by Store
--Objective: Combine grouping and date functions.
--Task: Write a query to return:
--store_id year, month monthly_revenue
--Use orders and order_items to compute total revenue per store per month.

SELECT S.store_id ,YEAR(O.order_date ) AS Year , MOnth(O.order_date) Month , SUM(OI.list_price * OI.quantity * (1-oi.discount)) as Total_sale  
FROM  sales.order_items  OI 
INNER JOIN sales.orders O ON O.order_id = OI.order_id
LEFT JOIN sales.stores S ON S.store_id =O.store_id  
GROUP BY MOnth(O.order_date) , S.store_id ,YEAR(O.order_date )
ORDER BY YEAR(O.order_date ),MOnth(O.order_date) ,S.store_id

--Exercise 30: Find the Most Popular Product (By Quantity Sold)
--Objective: Use aggregation and ordering.
--Task: Write a SQL query to return:
--product_id  product_name total_quantity_sold
--Return only the top-selling product by quantity (not revenue). Use TOP 1 or a window function.

SELECT TOP 1  OI.product_id  , SUM(OI.quantity) as QuantitySold
FROM sales.order_items OI 
INNER JOIn production.products P ON P.product_id = OI.product_id 
GROUP BY  OI.product_id  
ORDER BY  SUM(OI.quantity) DESC


--Exercise 31: Customer Lifetime Value (CLV)
--Objective: Calculate each customer's total spend.
--Task: Write a query to return:
--customer_id, first_name, last_name
--customer_lifetime_value (i.e. total amount they've spent)
--Sort by the highest lifetime value.


SELECT C.first_name , C.last_name , SUM(OI.quantity * OI.list_price * (1- OI.discount)) CLV
FROM sales.customers C
INNER JOIN sales.orders O ON  O.customer_id = C.customer_id
LEFT JOIN  sales.order_items OI ON OI.order_id = O.order_id 
GROUP BY C.customer_id ,C.first_name , C.last_name 
ORDER BY CLV DESC


--Write a query that shows:
--order_id, product_id, discount, and a new column discount_category:
--'High' if discount > 0.3
--'Medium' if discount between 0.1 and 0.3
--'Low' if discount <= 0.1
--'None' if discount = 0
--From table: sales.order_items
--Let me know once you're done!

SELECT  
  OI.product_id, 
  OI.discount, 
  CASE 
    WHEN OI.discount > 0.3 THEN 'HIGH'
    WHEN OI.discount BETWEEN 0.1 AND 0.3 THEN 'MEDIUM'
    WHEN OI.discount > 0 AND OI.discount <= 0.1 THEN 'LOW'
    WHEN OI.discount = 0 THEN 'NONE'
    ELSE 'UNKNOWN'
  END AS discount_category
FROM sales.order_items OI;


--Exercise 33: Subquery in SELECT clause
--Objective: Practice using scalar subqueries inside SELECT.
--Task:
--For each product (product_id, product_name), return:
--the product name its list price
--a new column: total_sales_count – number of times it appears in the sales.order_items table.

SELECT 
  P.product_id,
  P.product_name,
  (
    SELECT COUNT(*) 
    FROM sales.order_items OI 
    WHERE OI.product_id = P.product_id
  ) AS total_sales_count
FROM production.products P;


-- Exercise 34: Using EXISTS
--Objective: Practice using the EXISTS operator to filter records based on a related subquery.
--Task:
--Write a query to retrieve the first name, last name, and email of customers who have placed at least one order.

SELECT first_name , last_name ,email
FROM  sales.customers  WHERE  EXISTS (
	SELECT 1 FROM sales.orders O
	where O.customer_id =sales.customers.customer_id   
) 

--Exercise 35: Subquery in FROM Clause (Derived Table)
--Objective: Learn how to use a subquery inside the FROM clause to create a temporary table.
-- Task:
--Write a query that shows the average total order value per customer, ordered by average descending.
--Use a subquery in the FROM clause that:
--Calculates the total value of each order:
--(quantity * list_price * (1 - discount))
--Groups by customer_id and order_id
--Then, in the outer query, calculate the average of those order totals per customer.

SELECT S.customer_id, AVG(S.Total_value) AS Total_val_per_Cust
FROM (
    SELECT O.customer_id, O.order_id, 
           SUM(OI.quantity * OI.list_price * (1 - OI.discount)) AS Total_value
    FROM sales.orders O
    INNER JOIN sales.order_items OI ON OI.order_id = O.order_id
    GROUP BY O.customer_id, O.order_id
) S
GROUP BY S.customer_id;

-- Exercise – Use UNION to Combine Results
--Write a query that returns a combined list of first name, last name, and email of:
--All customers from California (CA), and
--All customers from New York (NY)
--Make sure each customer appears only once, even if they match both conditions.

SELECT first_name, last_name , email   
FROM  sales.customers 
WHERE state = 'CA'
UNION
SELECT first_name, last_name , email   
FROM  sales.customers 
WHERE state = 'NY'


--Exercise – Subquery in SELECT Clause
--Write a query to display the following for each product:
--product_name list_price Total number of times the product was sold 

SELECT product_name ,list_price, (SELECT COUNT(product_id) FROM  sales.order_items where sales.order_items.product_id = p.product_id  ) AS total_no_of_times
FROM production.products P

-- Exercise – Use CTE to Get Monthly Sales
--Write a query using a CTE to get the total sales per month across all orders, showing:
--Year Month Total_Sales
--Use:
--sales.orders
--sales.order_items
GO
WITH selectMonthlySales  AS 
(
SELECT YEAR(O.order_date) AS  YEAR , MONTH(O.order_date) MONTH , SUM(OI.quantity * OI.list_price * (1- OI.discount)) AS TOTAL_SALES
FROM SALES.orders O
INNER JOIN sales.order_items OI ON OI.order_id = O.order_id
GROUP BY  YEAR(O.order_date) , MONTH(O.order_date)  
) 
SELECT * FROM  selectMonthlySales
ORDER BY YEAR, MONTH
GO

--Next Exercise: Use a CTE to Find the Top-Selling Product
--Using a CTE:
--Calculate total sales for each product.
--Select the top 1 product based on total sales.

WITH FindTopSellingProduct AS (
SELECT OI.product_id , SUM(OI.list_price * OI.quantity * (1- OI.discount)) AS TotalSalesPerProduct 
FROM production.products P
INNER JOIN  sales.order_items OI ON OI.product_id = P.product_id
INNER JOIN sales.orders O ON O.order_id = OI.order_id
GROUP BY OI.product_id
)
SELECT TOP 1 * FROM FindTopSellingProduct 
ORDER BY TotalSalesPerProduct DESC


--Next Exercise: Window Function — Top 3 Selling Products by Revenue
--Using a window function (RANK() or ROW_NUMBER()), return the top 3 products by total revenue.

SELECT TOP 3 product_id , SUM(quantity * list_price * (1- discount)) AS total_revenue
, ROW_NUMBER() OVER (ORDER BY (SUM(quantity * list_price * (1- discount)) ) DESC) AS TOP_3_BY_RN
,RANK() OVER (ORDER BY (SUM(quantity * list_price * (1- discount)) ) DESC) AS TOP_3_BY_R
FROM sales.order_items 
GROUP  BY  product_id

--Next Exercise: Subquery — Customers with Above-Average CLV (Customer Lifetime Value)
--Write a query to return:
--customer_id, first_name, last_name, and their TotalSales
--Only include customers whose total sales are above the average customer total sales.
GO

WITH CustomerRevenue AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS TotalRevenue
    FROM
        sales.customers c
    INNER JOIN
        sales.orders o ON o.customer_id = c.customer_id
    LEFT JOIN
        sales.order_items oi ON oi.order_id = o.order_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
),
AverageRevenue AS (
 SELECT  AVG(TotalRevenue) as avgTotalRevenue from  CustomerRevenue 
) SELECT cr.first_name,cr.last_name , cr.TotalRevenue FROM      CustomerRevenue cr,    AverageRevenue ar
WHERE cr.TotalRevenue > ar.avgTotalRevenue
 ORDER BY cr.TotalRevenue DESC


 

--subqueries 







