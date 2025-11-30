
-- testdata.sql

-- Clear existing data (for clean testing)
TRUNCATE TABLE 
    Reviews, 
    Order_Items, 
    Orders, 
    Products, 
    Customers, 
    Brands 
RESTART IDENTITY CASCADE;

-- 1. Brands
INSERT INTO Brands (name, country, founded_year, description) VALUES
('Vestel', 'TR', 1984, 'A leading Turkish technology and electronics producer. Home appliances, TV, and mobile devices.'),         
('Beko', 'TR', 1955, 'A global white goods and electronics brand operating under the Arçelik umbrella.'),                 
('Casper', 'TR', 2007, 'A local brand providing solutions in the computer, tablet, and smartphone market.');                     

-- 2. Products
INSERT INTO Products (name, brand_id, sku, release_year, price, warranty_months, category, stock_quantity) VALUES
('Vestel Venus Z40', 1, 'VST-VZ-40', 2024, 12999.50, 24, 'Smartphones', 50),     
('Beko V300 Laptop', 2, 'BEK-V3-005', 2023, 19500.00, 36, 'Laptops', 20),       
('Casper Nirvana Tablet A', 3, 'CSP-NT-010', 2024, 3500.99, 12, 'Tablets', 150), 
('Vestel Smart Watch V5', 1, 'VST-AS-003', 2024, 4500.00, 18, 'Wearables', 80),   
('Beko Bluetooth Headset P2', 2, 'BEK-KP-002', 2023, 999.99, 12, 'Accessories', 300), 
('Vestel Regal 15 Laptop', 1, 'VST-RG-007', 2022, 9800.00, 24, 'Laptops', 15),   
('Casper VIA M20', 3, 'CSP-VM-011', 2023, 1999.00, 12, 'Smartphones', 250),      
('Casper Power Bank 20k', 3, 'CSP-TŞ-012', 2024, 450.00, 6, 'Accessories', 500), 
('Beko Smart Tablet X', 2, 'BEK-ST-008', 2023, 7500.50, 18, 'Tablets', 30),     
('Vestel Soundbar P1', 1, 'VST-SP-009', 2022, 2500.00, 24, 'Audio', 10);        

-- 3.Customers
INSERT INTO Customers (first_name, last_name, email, phone, city, registration_date) VALUES
('Ayşe', 'Yılmaz', 'ayse.yilmaz@mail.com', '05321234567', 'İstanbul', '2023-01-15'),
('Mehmet', 'Kaya', 'mehmet.kaya@mail.com', '05439876543', 'Ankara', '2023-05-20'),
('Zeynep', 'Demir', 'zeynep.demir@mail.com', '05553456789', 'İzmir', '2024-02-10'),
('Can', 'Öztürk', 'can.ozturk@mail.com', '05058765432', 'Bursa', '2024-03-01'),
('Selin', 'Eren', 'selin.eren@mail.com', '05061122334', 'İstanbul', '2024-04-05');

-- 4. Orders 
INSERT INTO Orders (customer_id, order_date, total_amount, status, shipping_city) VALUES
(1, '2023-08-10', 13999.50, 'completed', 'İstanbul'), 
(2, '2023-11-25', 20499.99, 'completed', 'Ankara'), 
(3, '2024-03-05', 4500.00, 'pending', 'İzmir'),    
(1, '2024-03-15', 3500.99, 'completed', 'İstanbul'), 
(4, '2024-04-01', 1999.00, 'completed', 'Bursa'),  
(5, '2024-04-10', 450.00, 'pending', 'İstanbul'),   
(2, '2024-05-01', 7500.50, 'completed', 'Ankara'), 
(3, '2024-05-10', 1299.99, 'pending', 'İzmir'),    
(1, '2024-05-20', 9800.00, 'completed', 'İstanbul'), 
(4, '2024-05-25', 15000.00, 'pending', 'Bursa');  

-- 5. Order_Items
INSERT INTO Order_Items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 12999.50), (1, 5, 1, 999.99), (2, 2, 1, 19500.00), (2, 5, 1, 999.99),
(3, 4, 1, 4500.00), (4, 3, 1, 3500.99), (5, 7, 1, 1999.00), (6, 8, 1, 450.00),
(7, 9, 1, 7500.50), (8, 5, 1, 999.99), (8, 8, 1, 450.00), (9, 6, 1, 9800.00), 
(10, 2, 1, 19500.00); 

-- 6. Reviews
INSERT INTO Reviews (product_id, customer_id, rating, comment, review_date) VALUES
(1, 1, 5, 'Camera quality is great, exceeded my expectations!', '2023-09-01'),
(1, 2, 4, 'A very good phone, just a bit pricey.', '2023-12-01'),
(2, 2, 5, 'The best laptop I have ever owned. Super fast.', '2023-12-01'),
(5, 1, 3, 'Headset is okay, comfortable but sound quality could be better.', '2023-09-15'),
(3, 4, 5, 'Amazing value for the money, perfect tablet for casual use.', '2024-04-05'),
(7, 3, 4, 'Decent budget phone, reliable.', '2024-03-15'),
(4, 5, 5, 'Love the smartwatch, long battery life.', '2024-04-12'),
(8, 1, 5, 'Fast shipping and works great! Necessary accessory.', '2024-03-16'),
(9, 2, 4, 'Solid tablet for work.', '2024-05-15'),
(6, 1, 5, 'Great performance for gaming and work.', '2024-05-25');