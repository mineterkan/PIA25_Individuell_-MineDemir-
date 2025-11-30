

from sqlalchemy import func
from tabulate import tabulate
# NOTE: Assuming get_session function is defined in database.py
from database import get_session 

# Import all 11 query functions from queries.py
from queries import (
    get_all_products, get_products_over_price, get_orders_from_year, 
    get_pending_orders, get_products_with_brands, get_orders_with_customer_names, 
    get_customer_purchases, get_product_count_per_brand, get_top_spending_customers,
    get_products_with_average_rating

)

def display_report(title: str, results: list):
    print("=" * 70)
    print(f"| REPORT TITLE: {title:<50} |")
    print("=" * 70)

    if not results:
        print("--- No results found for this query. ---")
        return

    processed_results = []
    for row in results:
        if hasattr(row, "__dict__"):
            row_dict = row.__dict__.copy()
            row_dict.pop('_sa_instance_state', None)
            processed_results.append(row_dict)
        #  (Row object)
        elif hasattr(row, "_mapping"):
             processed_results.append(dict(row._mapping))
        else:
             # (fallback)
             processed_results.append(row)

    if not processed_results:
        print("--- No displayable data found. ---")
        return
        
    headers = "keys"
    table_format = "github"
    
    print(tabulate(processed_results, headers=headers, tablefmt=table_format, numalign="left"))
    print(f"\n({len(results)} rows listed)\n")
    print("-" * 70)

def run_analysis():
    """Main analysis engine: Executes all queries and generates the report."""
    print("\n\n################ ANALYSIS REPORT START ################")
    
    # Get the single Session object from the database configuration
    session = get_session() 

    # Centralized dictionary of all G/VG level queries to run
    analysis_queries = {
        "1. ALPHABETICAL PRODUCT LIST": get_all_products,
        "2. PREMIUM PRODUCTS (OVER 5000)": get_products_over_price,
        "3. ALL ORDERS FROM 2024": get_orders_from_year,
        "4. ALL PENDING ORDERS": get_pending_orders,
        "5. PRODUCTS WITH BRAND NAMES": get_products_with_brands,
        "6. ORDERS WITH CUSTOMER NAMES": get_orders_with_customer_names,
        "7. CUSTOMER PURCHASE HISTORY": get_customer_purchases,
        "8. PRODUCT COUNT PER BRAND": get_product_count_per_brand,
        "9. TOP SPENDING CUSTOMERS": get_top_spending_customers,
        "10. PRODUCTS WITH AVERAGE RATINGS": get_products_with_average_rating,
    }

    # Execute and report on queries sequentially
    for title, func_name in analysis_queries.items():
        try:
            # Execute the function, passing the session object
            # NOTE: Your queries.py must ensure the result is a list of dicts/tuples for display_report
            results = func_name(session)
            
            display_report(title, results)
        
        except Exception as e:
            print(f"❌ ERROR: An error occurred while running the query '{title}': {e}")

    session.close() # Always close the session when done
    print("\n################ ANALYSIS REPORT CONCLUDED ################")


if __name__ == "__main__":
    # Ensure 'tabulate' is installed: pip install tabulate
    run_analysis()