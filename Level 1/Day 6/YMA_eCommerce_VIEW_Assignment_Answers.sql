-- =============================================================
-- Name: Ye Min Aung
-- Enrolled ID - DE-2026-0184
-- University: Myanmar Institute Of Information Technology (MIIT)
-- ==============================================================

-- ==========================
-- E-COMMERCE VIEW ASSIGNMENT
-- ==========================

-- 1. DATABASE SCHEMA SETUP
CREATE DATABASE ecommerce_view_demo;
USE ecommerce_view_demo;

-- Create Tables
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 2. INSERT SAMPLE DATA
INSERT INTO customers (customer_name, email, city) VALUES
('Aung Aung', 'aung@gmail.com', 'Yangon'),
('Su Su', 'susu@gmail.com', 'Mandalay'),
('Kyaw Kyaw', 'kyaw@gmail.com', 'Yangon');

INSERT INTO products (product_name, category, price) VALUES
('Laptop', 'Electronics', 1500000),
('Phone', 'Electronics', 800000),
('Shoes', 'Fashion', 120000);

INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2024-01-10', 'Completed'),
(2, '2024-01-11', 'Pending'),
(1, '2024-01-12', 'Completed');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(3, 2, 1);

-- ================================
-- ASSIGNMENT QUESTIONS AND ANSWERS
-- ================================

-- Q1. Create a VIEW to show customer basic information (hide email)
CREATE OR REPLACE VIEW vw_customers_info AS
SELECT customer_id, customer_name, city
FROM customers;

SELECT * FROM vw_customers_info;

-- Q2. Create a VIEW to show all completed orders
CREATE OR REPLACE VIEW vw_completed_orders AS
SELECT order_id, customer_id, order_date, status
FROM orders
WHERE status = 'Completed';

SELECT * FROM vw_completed_orders;

-- Q3. Create a JOIN VIEW for order details (customer + product)
CREATE OR REPLACE VIEW vw_order_details AS
SELECT 
	c.customer_id,
    c.customer_name,
    o.order_date,
    p.product_name,
    oi.quantity,
    p.price AS 'price_per_product (MMK)',
    (oi.quantity * p.price) AS 'total_price (MMK)'
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id;

SELECT * FROM vw_order_details;

-- Q4. Create a VIEW to calculate total sales per order
CREATE OR REPLACE VIEW vw_total_sales_per_order AS
SELECT 
	o.order_id,
    o.customer_id,
    o.order_date,
    SUM(oi.quantity) AS 'total_quantity',
    SUM(oi.quantity * p.price) AS 'total_sales (MMK)'
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
GROUP BY o.order_id, o.order_date;

SELECT * FROM vw_total_sales_per_order;

-- Q5. Create a VIEW for high-value orders (above 1,000,000)
CREATE OR REPLACE VIEW vw_high_value_orders AS
SELECT 
	o.order_id,
    o.customer_id,
    o.order_date,
    SUM(oi.quantity) AS 'total_quantity',
    SUM(oi.quantity * p.price) AS 'total_sales'
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
GROUP BY o.order_id, o.order_date
HAVING SUM(oi.quantity * p.price) > 1000000;

SELECT * FROM vw_high_value_orders;

-- Q6. Create a VIEW with WITH CHECK OPTION (only completed orders allowed)
CREATE VIEW vw_completed_orders_check AS 
SELECT * FROM orders
WHERE status = 'Completed'
WITH CHECK OPTION;

SELECT * FROM vw_completed_orders_check;

-- Q7. Try to update data using VIEW (Updatable View)
UPDATE vw_completed_orders_check
SET customer_id = 3
WHERE order_id = 3;

SELECT * FROM vw_completed_orders_check;

-- Q8. Try invalid update (should fail)
UPDATE vw_completed_orders_check
SET status = 'Pending'
WHERE order_id = 3; 

-- error message
-- Error Code: 1369. CHECK OPTION failed 'ecommerce_view_demo.vw_completed_orders_check'

-- Q9. Create a VIEW for customer purchase summary
CREATE OR REPLACE VIEW vw_customer_purchase_summary AS
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity) AS 'total_items_bought',
    SUM(oi.quantity * p.price) AS 'total_spent (MMK)'
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name;

SELECT * FROM vw_customer_purchase_summary;

-- Q10. Create a VIEW using ALGORITHM = TEMPTABLE
CREATE OR REPLACE
ALGORITHM = TEMPTABLE
VIEW vw_category_sales_summary AS
SELECT 
    p.category,
    SUM(oi.quantity * p.price) AS 'category_revenue'
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category;

SELECT * FROM vw_category_sales_summary;

-- Q11. Create a VIEW for security (hide price)
CREATE OR REPLACE
ALGORITHM = MERGE
VIEW vw_security_view AS
SELECT product_id, product_name, category
FROM products;

SELECT * FROM vw_security_view;

-- Q12. Show all views in database
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- Q13. Show view definition
SHOW CREATE VIEW vw_high_value_orders;

-- Q14. Drop a view
DROP VIEW vw_security_view;

-- =============================
-- ADDITIONAL PRACTICE QUESTIONS
-- =============================

-- 1. Create a view for pending orders only
CREATE OR REPLACE VIEW vw_pending_orders AS
SELECT *
FROM orders
WHERE status = 'Pending';

SELECT * FROM vw_pending_orders;

-- 2. Create a view showing top 3 expensive products
CREATE OR REPLACE VIEW vw_expensive_products AS
SELECT *
FROM products
ORDER BY price DESC
LIMIT 3;

SELECT * FROM vw_expensive_products;

-- 3. Create a view showing customer orders by city
CREATE OR REPLACE VIEW vw_customer_orders_city AS
SELECT 
	c.customer_id, 
    c.customer_name, 
    c.city,
	o.order_id, 
    o.status
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
ORDER BY c.city;

SELECT * FROM vw_customer_orders_city;

-- 4. Create a view for monthly sales report
CREATE OR REPLACE VIEW vw_monthly_sales_report AS
SELECT
    MONTHNAME(o.order_date) AS 'sales_month',
    YEAR(o.order_date) AS 'sales_year',
    SUM(oi.quantity * p.price) AS 'monthly_total'
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p 
ON oi.product_id = p.product_id
GROUP BY YEAR(o.order_date), MONTHNAME(o.order_date);

SELECT * FROM vw_monthly_sales_report;

-- 5. Create a view showing products not ordered
CREATE OR REPLACE VIEW vw_unsold_products AS
SELECT p.product_id, p.product_name, p.category
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

SELECT * FROM vw_unsold_products;