-- queries_advanced.sql

-- Subqueries (2 queries)

-- 1. Find all products whose price is higher than the average price
-- Compares each product's price with the global average price (calculated in the subquery).
SELECT 
    name, 
    price, 
    category
FROM Products
WHERE price > (
    SELECT AVG(price) 
    FROM Products
)
ORDER BY price DESC;

-- 2. Find customers who have placed more than the average number of orders
-- Calculates the average number of orders per customer and then selects only customers with more orders than this average.
SELECT 
    c.first_name || ' ' || c.last_name AS customer_full_name,
    COUNT(o.id) AS total_orders
FROM Customers c
JOIN Orders o ON c.id = o.customer_id
GROUP BY customer_full_name
HAVING COUNT(o.id) > (
    SELECT AVG(order_count) 
    FROM (
        SELECT COUNT(id) AS order_count 
        FROM Orders 
        GROUP BY customer_id
    ) AS subquery
)
ORDER BY total_orders DESC;

-- Window functions (2 queries) - PostgreSQL specific

-- 3. Rank products per manufacturer based on price (ROW_NUMBER)
-- Uses ROW_NUMBER() to rank products within each brand ('brand_id') by price, most expensive first.
SELECT
    p.name AS product_name,
    b.name AS brand_name,
    p.price,
    ROW_NUMBER() OVER (PARTITION BY b.name ORDER BY p.price DESC) AS price_rank_in_brand
FROM Products p
JOIN Brands b ON p.brand_id = b.id
ORDER BY brand_name, price_rank_in_brand;

-- 4. Show each customer's total spending and their rank among all customers (RANK)
-- Uses RANK() to rank customers based on their total spent amount.
SELECT
    customer_full_name,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) AS spending_rank
FROM (
    -- Subquery to calculate total amount spent per customer
    SELECT 
        c.first_name || ' ' || c.last_name AS customer_full_name,
        COALESCE(SUM(o.total_amount), 0) AS total_spent
    FROM Customers c
    LEFT JOIN Orders o ON c.id = o.customer_id AND o.status = 'completed'
    GROUP BY customer_full_name
) AS customer_spending
ORDER BY spending_rank, customer_full_name;

-- CASE and conditional logic (2 queries)

-- 5. Categorize products as 'Budget' (<1000), 'Medium' (1000-5000), 'Premium' (>5000)
-- Uses a CASE expression to assign a price tier label to each product.
SELECT
    name,
    price,
    CASE
        WHEN price > 5000.00 THEN 'Premium'
        WHEN price >= 1000.00 AND price <= 5000.00 THEN 'Medium'
        ELSE 'Budget'
    END AS price_segment
FROM Products
ORDER BY price DESC;

-- 6. Show customers as 'VIP' (>3 orders), 'Regular' (2-3), 'New' (1)
-- Uses a CASE expression to categorize customers based on their total number of orders.
SELECT
    c.first_name || ' ' || c.last_name AS customer_full_name,
    COUNT(o.id) AS total_orders,
    CASE
        WHEN COUNT(o.id) > 3 THEN 'VIP'
        WHEN COUNT(o.id) >= 2 THEN 'Regular'
        ELSE 'New' -- 0 or 1 order
    END AS customer_level
FROM Customers c
LEFT JOIN Orders o ON c.id = o.customer_id
GROUP BY customer_full_name
ORDER BY total_orders DESC;