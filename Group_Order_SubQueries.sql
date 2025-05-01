-- Gropu By and  Order By clause
SELECT 
    state,SUM(customer_id)  as s
FROM sales.customers
GROUP BY state
order by s asc

SELECT customer_id , YEAR(order_date) order_date
FROM sales.orders
WHERE customer_id IN (1,2)
GROUP BY customer_id ,  YEAR(order_date)
ORDER BY customer_id

SELECT city ,COUNT(customer_id)CustCount 
FROM  sales.customers
GROUP BY city

SELECT city,state, COUNT (customer_id) customer_count
FROM
    sales.customers
GROUP BY state,city
ORDER BY city,state;



---The following statement returns the minimum and maximum list prices of all products with the model 2018 by brand:

SELECT MIN(list_price) as minPrice , MAX(list_price) as maxPrice , B.brand_name
FROM production.products P 
INNER JOIN production.brands B ON B.brand_id =  p.brand_id
WHERE model_year= 2018
Group BY B.brand_name

---Using GROUP BY clause with the SUM function example See the following order_items table:

SELECT order_id,SUM(quantity *  discount * (1 - discount)) net_value
FROM sales.order_items
group by order_id


--The following statement uses the HAVING clause to find the customers who placed at least two orders per year:
select C.first_name, COUNT(order_id) as order_count , YEAR(order_date) as order_date
from sales.orders O
INNER JOIN sales.customers C ON  C.customer_id = O.customer_id
group by C.first_name  ,YEAR(order_date) 
having COUNT(order_id) > 2   

--The following statement finds the sales orders whose net values are greater than 20,000:

SELECT product_name , CONCAT(CAST(Round(SUM(OI.quantity * OI.list_price *(1- OI.discount)),1,1) as varchar(25)) , '  INR ' ) as netValue 
FROM sales.order_items OI
INNER JOIN production.products P ON  P.product_id= OI.product_id
GROUP BY product_name

--Sub Query 
SELECT product_name,list_price 
FROM  production.products
WHERE  list_price >= ANY (
        SELECT AVG (list_price)
        FROM production.products
        GROUP BY brand_id
    )


--The following query finds the customers who bought products in 2017:

SELECT     customer_id,
    first_name,
    last_name,
    city FROM  sales.customers C
WHERE EXISTS  (
			SELECT customer_id FROM 
			sales.orders O WHERE O.customer_id = C.customer_id
			and YEAR(order_date) = 2017
) 
ORDER BY  first_name , last_name

--The following query finds the customers who not bought products in 2017:


SELECT     customer_id,
    first_name,
    last_name,
    city FROM  sales.customers C
WHERE NOT EXISTS  (
			SELECT customer_id FROM 
			sales.orders O WHERE O.customer_id = C.customer_id
			and YEAR(order_date) = 2017
) 
ORDER BY  first_name , last_name

--SQL Server Correlated Subquery
--The following example finds the products whose list price is equal to the highest list price of the products within the same category:

SELECT * 
FROM production.products P
where list_price = (SELECT MAX(list_price) 
					FROM production.products PP 
					 WHERE  pp.category_id = P.category_id
					)
					ORDER BY list_price


