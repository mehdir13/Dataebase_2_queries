-- 1. Retrieve all products
SELECT * FROM products;

-- 2. Find products that are discontinued
SELECT product_id, product_name, discontinued 
FROM products
WHERE discontinued = 1;

-- 3. Find customers located in London
SELECT customer_id, company_name, city, country 
FROM customers
WHERE city = 'London';

-- 4. List suppliers from the USA or UK
SELECT supplier_id, company_name, country 
FROM suppliers
WHERE country = 'USA' OR country = 'UK';

-- 5. Find products that are discontinued AND priced above $20
SELECT product_id, product_name, unit_price, discontinued
FROM products
WHERE discontinued = 1 AND unit_price > 20;

-- 6. Retrieve customers in London or Paris AND whose company name starts with 'A'
SELECT customer_id, company_name, city, country
FROM customers
WHERE (city = 'London' OR city = 'Paris') AND company_name LIKE 'A%';

-- 7. Retrieve orders placed by a specific employee or orders made after '2023-01-01'
SELECT order_id, customer_id, order_date
FROM orders
WHERE employee_id = 5 OR order_date > '2023-01-01';

-- 8. Find products with unit prices between $10 and $20 OR products that are out of stock
SELECT product_id, product_name, unit_price, units_in_stock
FROM products
WHERE (unit_price BETWEEN 10 AND 20) OR units_in_stock = 0;

-- 9. Retrieve customers whose company name starts with 'B' AND are located in Germany
SELECT customer_id, company_name, city, country
FROM customers
WHERE company_name LIKE 'B%' AND country = 'Germany';

-- 10. Find employees who have a region assigned
SELECT employee_id, first_name, last_name
FROM employees
WHERE region IS NOT NULL;


-- 11. Select distinct order dates from orders.
SELECT DISTINCT order_date FROM orders;