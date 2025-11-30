# models.py

from sqlalchemy import Column, Integer, String, DECIMAL, Date, ForeignKey, TIMESTAMP, Text, func
from sqlalchemy.orm import declarative_base, relationship
from datetime import datetime


Base = declarative_base()

# ===================================================
# ORM Modeller
# ===================================================

class Brand(Base):
    __tablename__ = 'brands'
    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False, unique=True)
    country = Column(String(100))
    founded_year = Column(Integer)
    description = Column(Text)
    created_at = Column(TIMESTAMP, default=datetime.utcnow)
    

    products = relationship("Product", back_populates="brand")

class Product(Base):
    __tablename__ = 'products'
    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    # Foreign Key: RESTRICT eylemi DB schema'da garanti edilir
    brand_id = Column(Integer, ForeignKey('brands.id', ondelete='RESTRICT'), nullable=False) 
    sku = Column(String(100), unique=True)
    release_year = Column(Integer)
    price = Column(DECIMAL(10, 2), nullable=False)
    warranty_months = Column(Integer)
    category = Column(String(100))
    stock_quantity = Column(Integer, default=0)
    created_at = Column(TIMESTAMP, default=datetime.utcnow)
    
    # Relationships
    brand = relationship("Brand", back_populates="products")
    reviews = relationship("Review", back_populates="product")
    order_items = relationship("OrderItem", back_populates="product")

class Customer(Base):
    __tablename__ = 'customers'
    id = Column(Integer, primary_key=True)
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    email = Column(String(255), unique=True, nullable=False)
    city = Column(String(100))
    registration_date = Column(Date, default=datetime.utcnow)
    
    # Relationships
    orders = relationship("Order", back_populates="customer")

class Order(Base):
    __tablename__ = 'orders'
    id = Column(Integer, primary_key=True)
    customer_id = Column(Integer, ForeignKey('customers.id', ondelete='RESTRICT'), nullable=False)
    order_date = Column(Date, default=datetime.utcnow)
    total_amount = Column(DECIMAL(10, 2))
    status = Column(String(50), default='pending')
    
    # Relationships
    customer = relationship("Customer", back_populates="orders")
    order_items = relationship("OrderItem", back_populates="order")

class OrderItem(Base):
    __tablename__ = 'order_items'
    id = Column(Integer, primary_key=True)
    order_id = Column(Integer, ForeignKey('orders.id', ondelete='CASCADE'), nullable=False)
    product_id = Column(Integer, ForeignKey('products.id', ondelete='RESTRICT'), nullable=False)
    quantity = Column(Integer, nullable=False)
    unit_price = Column(DECIMAL(10, 2), nullable=False)
    
    # Relationships
    order = relationship("Order", back_populates="order_items")
    product = relationship("Product", back_populates="order_items")

class Review(Base):
    __tablename__ = 'reviews'
    id = Column(Integer, primary_key=True)
    product_id = Column(Integer, ForeignKey('products.id', ondelete='CASCADE'), nullable=False)
    customer_id = Column(Integer, ForeignKey('customers.id', ondelete='CASCADE'), nullable=False)
    rating = Column(Integer, nullable=False) 
    comment = Column(Text)
    
    # Relationships
    product = relationship("Product", back_populates="reviews")
    customer = relationship("Customer")