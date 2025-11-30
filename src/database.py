
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from sqlalchemy.exc import SQLAlchemyError
from dotenv import load_dotenv
import os
from models import Base 

load_dotenv() 

DB_NAME = os.getenv('DB_NAME', 'electronics_db')
DB_USER = os.getenv('DB_USER', 'postgres')
DB_PASSWORD = os.getenv('DB_PASSWORD', 'postgres')
DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_PORT = os.getenv('DB_PORT', '5432')

DATABASE_URL = f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}" # psycopg2 eklendi

try:
    engine = create_engine(DATABASE_URL, echo=False)
    SessionLocal = sessionmaker(bind=engine) 
    # test connection
    with engine.connect() as connection:
        connection.execute(text("SELECT 1"))
    
    print("✅ Database connection and ORM configuration successful.")
    
except SQLAlchemyError as e:
    print(" Database connection failed!")
    print(f"Error: {e}")
    raise


def get_session():  
    """Returnerar en ny ORM Session."""
    return SessionLocal()