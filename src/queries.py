# ============================================
# Defines all queries as reusable functions
# ============================================

from database import get_session
from models import Product, Brand, Customer, Order, OrderItem, Review
from sqlalchemy import func


def get_all_products(session):
    """Return all products sorted by name."""
    return session.query(Product).order_by(Product.name).all()


def get_products_over_price(session, min_price=5000):
    """Return all products with price greater than min_price."""
    return (
        session.query(Product)
        .filter(Product.price > min_price)
        .order_by(Product.price)
        .all()
    )


def get_orders_from_year(session, year=2024):
    """Return all orders made in the given year."""
    start_date = f"{year}-01-01"
    end_date = f"{year}-12-31"
    return (
        session.query(Order)
        .filter(Order.order_date.between(start_date, end_date))
        .order_by(Order.order_date)
        .all()
    )


def get_pending_orders(session):
    """Return all orders with status 'pending'."""
    return (
        session.query(Order)
        .filter(Order.status == 'pending')
        .order_by(Order.order_date)
        .all()
    )


def get_products_with_brands(session):
    """Return all products with their brand names."""
    return (
        session.query(Product.name.label("product_name"), Brand.name.label("brand_name"))
        .join(Brand, Product.brand_id == Brand.id)
        .order_by(Product.name)
        .all()
    )


def get_orders_with_customer_names(session):
    """Return all orders with customer names and total amounts."""
    return (
        session.query(
            Order.id.label("order_id"),
            func.concat(Customer.first_name, " ", Customer.last_name).label("customer_name"),
            Order.total_amount,
            Order.status
        )
        .join(Customer, Order.customer_id == Customer.id)
        .order_by(Order.id)
        .all()
    )


def get_customer_purchases(session):
    """Return which products each customer has purchased."""
    return (
        session.query(
            func.concat(Customer.first_name, " ", Customer.last_name).label("customer_name"),
            Product.name.label("product_name"),
            OrderItem.quantity,
            Order.order_date
        )
        .join(Order, Customer.id == Order.customer_id)
        .join(OrderItem, Order.id == OrderItem.order_id)
        .join(Product, OrderItem.product_id == Product.id)
        .order_by(Customer.last_name, Order.order_date)
        .all()
    )


def get_product_count_per_brand(session):
    """Return the number of products per brand."""
    return (
        session.query(
            Brand.name.label("brand_name"),
            func.count(Product.id).label("product_count")
        )
        .join(Product, Product.brand_id == Brand.id)
        .group_by(Brand.name)
        .order_by(func.count(Product.id).desc())
        .all()
    )


def get_top_spending_customers(session):
    """Return customers ranked by total spending."""
    return (
        session.query(
            func.concat(Customer.first_name, " ", Customer.last_name).label("customer_name"),
            func.sum(Order.total_amount).label("total_spent")
        )
        .join(Order, Customer.id == Order.customer_id)
        .group_by(Customer.id)
        .order_by(func.sum(Order.total_amount).desc())
        .all()
    )


def get_products_with_average_rating(session):
    """Return products and their average ratings."""
    return (
        session.query(
            Product.name.label("product_name"),
            func.round(func.avg(Review.rating), 2).label("avg_rating")
        )
        .join(Review, Review.product_id == Product.id)
        .group_by(Product.name)
        .order_by(func.avg(Review.rating).desc())
        .all()
    )

def get_pending_orders_with_customers(session):
    """Return all pending orders including customer names and shipping info."""
    return (
        session.query(
            Order.id.label("order_id"),
            func.concat(Customer.first_name, " ", Customer.last_name).label("customer_name"),
            Order.order_date,
            Order.total_amount,
            Order.shipping_city
        )
        .join(Customer, Order.customer_id == Customer.id)
        .filter(Order.status == 'pending')
        .order_by(Order.order_date)
        .all()
    )