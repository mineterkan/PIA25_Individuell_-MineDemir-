-- Create database and tables for an electronics store

-- Create the database
DROP DATABASE IF EXISTS electronics_db;
CREATE DATABASE electronics_db;

-- Connect to the database
\c electronics_db;


--Create Tables
CREATE TABLE Brands (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    country VARCHAR(100),
    founded_year INTEGER,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    brand_id INTEGER NOT NULL REFERENCES Brands(id) ON DELETE RESTRICT,
    sku VARCHAR(50) UNIQUE,
    release_year INTEGER,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    warranty_months INTEGER,
    category VARCHAR(100),
    stock_quantity INTEGER DEFAULT 0 CHECK (stock_quantity >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(50),
    city VARCHAR(100),
    registration_date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES Customers(id) ON DELETE RESTRICT,
    order_date DATE DEFAULT CURRENT_DATE,
    total_amount DECIMAL(10, 2),
    status VARCHAR(50) DEFAULT 'pending',
    shipping_city VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Order_Items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES Orders(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES Products(id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Reviews (
    id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES Products(id) ON DELETE CASCADE,
    customer_id INTEGER NOT NULL REFERENCES Customers(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    review_date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for Foreign Keys (Optimization)

-- Products
CREATE INDEX idx_products_brand_id ON Products (brand_id);

-- Orders
CREATE INDEX idx_orders_customer_id ON Orders (customer_id);

-- Order_Items
-- Composite index for frequent lookups that join on both product and order
CREATE INDEX idx_order_items_order_product ON Order_Items (order_id, product_id);

-- Reviews
CREATE INDEX idx_reviews_product_id ON Reviews (product_id);
CREATE INDEX idx_reviews_customer_id ON Reviews (customer_id);


-- Indexes for Lookups and Reporting

-- Products (for fast searches)
CREATE INDEX idx_products_name ON Products (name);
CREATE INDEX idx_products_category ON Products (category);

-- Orders (for date-based reporting)
CREATE INDEX idx_orders_order_date ON Orders (order_date);