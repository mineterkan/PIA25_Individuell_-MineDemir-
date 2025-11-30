
-- Grundläggande queries (4 st)

-- 1. Hämta alla produkter sorterade efter namn
-- Jag vill bara ha en enkel, alfabetisk lista över alla produkter vi har i lager för en snabb överblick.
SELECT id, name, price, category
FROM Products
ORDER BY name ASC;

-- 2. Hämta alla produkter som kostar mer än 5000 kr
-- Jag filtrerar sortimentet för att snabbt se vilka produkter som faller inom Premium-segmentet (> 5000 kr).
SELECT name, price, category
FROM Products
WHERE price > 5000.00
ORDER BY price DESC;

-- 3. Hämta alla beställningar från 2024
-- Jag behöver en rapport över all försäljning under innevarande år (2024) för att analysera årets trend och försäljningsvolym.
SELECT id, customer_id, order_date, total_amount, status
FROM Orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY order_date DESC;

-- 4. Hämta alla "pending" beställningar
-- Jag måste snabbt se vilka ordrar som fortfarande väntar på hantering (pending) så att vi kan prioritera och skicka ut dem omedelbart.
SELECT id, customer_id, order_date, total_amount, shipping_city, status
FROM Orders
WHERE status = 'pending'
ORDER BY order_date DESC;

-- JOIN-queries (3 st)

-- 5. Visa alla produkter med deras tillverkares namn
-- För att få en helhetsbild av sortimentet, kopplar jag produkten direkt till dess märke för att få läsbara namn istället för bara ID-nummer.
SELECT 
    p.name AS product_name, 
    b.name AS brand_name, 
    p.price
FROM Products p
JOIN Brands b ON p.brand_id = b.id
ORDER BY b.name, p.name;

-- 6. Visa alla beställningar med kundens namn och totalt belopp
-- Jag vill få en snabb överblick över alla ordrar; jag kopplar ihop Orders och Customers för att direkt se vilket kundnamn som hör till vilket belopp och datum.
SELECT 
    o.id AS order_id, 
    c.first_name || ' ' || c.last_name AS customer_full_name, 
    o.order_date, 
    o.total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.id
ORDER BY o.order_date DESC;

-- 7. Visa vilka produkter varje kund har köpt
-- För att förstå kundbeteendet, måste jag spåra varje kunds unika köphistorik. Därför kedjar jag ihop alla fyra relations-tabeller (Kunder > Ordrar > Orderdetaljer > Produkter).
SELECT DISTINCT
    c.first_name || ' ' || c.last_name AS customer_full_name,
    p.name AS product_name
FROM Customers c
JOIN Orders o ON c.id = o.customer_id
JOIN Order_Items oi ON o.id = oi.order_id
JOIN Products p ON oi.product_id = p.id
ORDER BY customer_full_name, product_name;

-- Aggregering och analys (3 st)

-- 8. Räkna antal produkter per tillverkare
-- För att bedöma vårt produktsortiment vill jag gruppera och räkna hur många produkter vi har från varje tillverkare (märke). Detta ger en bild av utbudets bredd per märke.
SELECT 
    b.name AS brand_name, 
    COUNT(p.id) AS number_of_products
FROM Brands b
JOIN Products p ON b.id = p.brand_id
GROUP BY b.name
ORDER BY number_of_products DESC;

-- 9. Hitta kunder som har spenderat mest totalt
-- Jag behöver identifiera våra toppkunder (VIP-listan). Jag summerar därför endast slutförda köp (completed) per kund för att se vem som har spenderat mest pengar totalt sett.
SELECT 
    c.first_name || ' ' || c.last_name AS customer_full_name,
    SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.id = o.customer_id
WHERE o.status = 'completed' 
GROUP BY customer_full_name
ORDER BY total_spent DESC
LIMIT 5;

-- 10. Visa produkter med genomsnittligt betyg från recensioner
-- För att få en rättvis bild av produktkvaliteten, beräknar jag det genomsnittliga betyget. Jag filtrerar bort produkter med för få recensioner (färre än 2) för att undvika vilseledande data.
SELECT 
    p.name AS product_name,
    COUNT(r.id) AS total_reviews,
    ROUND(AVG(r.rating)::numeric, 2) AS average_rating
FROM Products p
JOIN Reviews r ON p.id = r.product_id
GROUP BY p.name
HAVING COUNT(r.id) >= 2 
ORDER BY average_rating DESC, total_reviews DESC;