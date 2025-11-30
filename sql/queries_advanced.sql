-- queries_advanced.sql

-- Subqueries (2 queries)

-- 1. Hitta alla produkter vars pris är högre än genomsnittspriset
-- Jämför varje produkts pris med det globala genomsnittspriset (beräknat i subquery).
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

-- 2. Hitta kunder som har beställt fler än genomsnittligt antal beställningar
-- Beräknar genomsnittligt antal beställningar per kund ve sedan väljer endast kunder med fler beställningar än detta genomsnitt.
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

-- Window functions (2 queries) - PostgreSQL-specifikt

-- 3. Ranka produkter per tillverkare baserat på pris (ROW_NUMBER)
-- Använder ROW_NUMBER() för att rangordna produkter inom varje märke ('brand_id') efter pris, dyraste först.
SELECT
    p.name AS product_name,
    b.name AS brand_name,
    p.price,
    ROW_NUMBER() OVER (PARTITION BY b.name ORDER BY p.price DESC) AS price_rank_in_brand
FROM Products p
JOIN Brands b ON p.brand_id = b.id
ORDER BY brand_name, price_rank_in_brand;

-- 4. Visa varje kunds totala spending och deras rank bland alla kunder (RANK)
-- Använder RANK() för att rangordna kunder baserat på deras totala spenderade belopp.
SELECT
    customer_full_name,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) AS spending_rank
FROM (
    -- Subquery för att beräkna totalt spenderat belopp per kund
    SELECT 
        c.first_name || ' ' || c.last_name AS customer_full_name,
        COALESCE(SUM(o.total_amount), 0) AS total_spent
    FROM Customers c
    LEFT JOIN Orders o ON c.id = o.customer_id AND o.status = 'completed'
    GROUP BY customer_full_name
) AS customer_spending
ORDER BY spending_rank, customer_full_name;

-- CASE och villkorlig logik (2 queries)

-- 5. Kategorisera produkter som 'Budget' (<1000), 'Medium' (1000-5000), 'Premium' (>5000)
-- Använder CASE-uttryck för att tilldela en prisnivå-etikett till varje produkt.
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

-- 6. Visa kunder som 'VIP' (>3 beställningar), 'Regular' (2-3), 'New' (1)
-- Använder CASE-uttryck för att kategorisera kunder baserat på deras totala antal beställningar.
SELECT
    c.first_name || ' ' || c.last_name AS customer_full_name,
    COUNT(o.id) AS total_orders,
    CASE
        WHEN COUNT(o.id) > 3 THEN 'VIP'
        WHEN COUNT(o.id) >= 2 THEN 'Regular'
        ELSE 'New' -- 0 eller 1 beställning
    END AS customer_level
FROM Customers c
LEFT JOIN Orders o ON c.id = o.customer_id
GROUP BY customer_full_name
ORDER BY total_orders DESC;