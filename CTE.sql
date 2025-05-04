
--  Window Function — Running Total by Month
--Write a query that returns:
--Year Month  Monthly Sales 
--Running total of monthly sales over time (ordered chronologically)

SELECT YEAR(order_date ) YEAR , MONTH(order_date) MONTH , SUM (OI.quantity * OI.list_price * (1- OI.discount)) AS TOTAL
, SUM( SUM (OI.quantity * OI.list_price * (1- OI.discount)) ) OVER (ORDER BY year(order_date),MONTH(order_date)  )  AS RUNNING_TOTAL
	FROM sales.orders o 
INNER JOIN sales.order_items OI ON OI.order_id =O.order_id
GROUP BY YEAR(order_date ) , MONTH(order_date) 
ORDER BY YEAR(order_date ) , MONTH(order_date) 
  
  
--Category-wise Top-Selling Product
--Write a query to return:
--Category Name Product Name Total Sales
--Rank of each product within its category by total sales
--Use RANK() over partition.

SELECT C.category_name , P.product_name ,SUM(OI.quantity * OI.list_price * (1- OI.discount)) TOTAL_SALE
, RANK() OVER  (PARTITION BY C.category_name  ORDER BY  SUM(OI.quantity * OI.list_price * (1- OI.discount)) DESC ) AS RANK 
FROM  production.categories c
LEFT JOIN  production.products p on P.category_id = c.category_id
LEFT JOIN sales.order_items OI ON OI.product_id = P.product_id
GROUP  BY  C.category_name , P.product_name 


--Write a query to find customers who never placed an order — using either LEFT 
--JOIN with IS NULL or a NOT EXISTS subquery.
--Would you like to try both approaches for practice?

SELECT * 
FROM sales.customers C
LEFT JOIN sales.orders O ON O.customer_id =C.customer_id
WHERE O.customer_id IS NULL


--Next challenge:
--Write a query to get the top 3 customers by total purchase value using RANK() or ROW_NUMBER().

WITH CUSTOMER_WISE_SALES AS(
SELECT O.customer_id, c.first_name , C.last_name , SUM(OI.quantity * OI.list_price * (1- OI.discount)) TOTAL_SALES ,
ROW_NUMBER() OVER ( ORDER BY  SUM(OI.quantity * OI.list_price * (1- OI.discount)) DESC) AS PURCHASE_RANK 
FROM sales.customers C 
INNER JOIN sales.orders O ON O.customer_id = C.customer_id
INNER JOIN sales.order_items OI ON  OI.order_id = O.order_id
GROUP  BY O.customer_id, c.first_name , C.last_name 
) 
SELECT *  FROM CUSTOMER_WISE_SALES
WHERE  3 >=  PURCHASE_RANK


--  SAME FROM USING RANK()

WITH CUSTOMER_WISE_SALES AS(
SELECT O.customer_id, c.first_name , C.last_name , SUM(OI.quantity * OI.list_price * (1- OI.discount)) TOTAL_SALES ,
RANK () OVER ( ORDER BY  SUM(OI.quantity * OI.list_price * (1- OI.discount)) DESC) AS PURCHASE_RANK 
FROM sales.customers C 
INNER JOIN sales.orders O ON O.customer_id = C.customer_id
INNER JOIN sales.order_items OI ON  OI.order_id = O.order_id
GROUP  BY O.customer_id, c.first_name , C.last_name 
) 
SELECT TOP 3 * FROM CUSTOMER_WISE_SALES