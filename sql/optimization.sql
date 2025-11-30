-- optimization.sql

-- ** Optimization for Query 9: Find customers who have spent the most in total **

-- Create Index 1: Partial index on Orders.status for fast filtering of 'completed' orders.
CREATE INDEX idx_orders_status ON Orders (status) WHERE status = 'completed';

-- Create Index 2: Composite index on Orders.customer_id and total_amount to speed up JOIN and SUM operations.
CREATE INDEX idx_orders_customer_id_total_amount ON Orders (customer_id, total_amount);

-- Usage Example (Run in your DB client for performance check):
-- EXPLAIN ANALYZE 
-- SELECT 
--     c.first_name || ' ' || c.last_name AS customer_full_name, 
--     SUM(o.total_amount) AS total_spent
-- FROM Customers c
-- JOIN Orders o ON c.id = o.customer_id
-- WHERE o.status = 'completed'
-- GROUP BY customer_full_name
-- ORDER BY total_spent DESC
-- LIMIT 5;


-- ** Optimization for Query 10: Show products with the average rating from reviews **

-- Create Index 3: Composite index on Reviews.product_id and rating to speed up JOIN and AVG aggregation.
CREATE INDEX idx_reviews_product_rating ON Reviews (product_id, rating);

-- Usage Example (Run in your DB client for performance check):
-- EXPLAIN ANALYZE 
-- SELECT 
--     p.name AS product_name,
--     COUNT(r.id) AS total_reviews,
--     ROUND(AVG(r.rating)::numeric, 2) AS average_rating
-- FROM Products p
-- JOIN Reviews r ON p.id = r.product_id
-- GROUP BY p.name
-- HAVING COUNT(r.id) >= 2 
-- ORDER BY average_rating DESC, total_reviews DESC;