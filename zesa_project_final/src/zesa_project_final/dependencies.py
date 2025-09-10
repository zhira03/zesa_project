from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv

load_dotenv()
localTestDb1 = "postgresql://postgres:newpassword@localhost:5432/localDB1"
localTestDb2 = "postgresql://postgres:newpassword@localhost:5432/localDB2"
localTestDb3= "postgresql://postgres:newpassword@localhost:5432/localDB3"

engine = create_engine(localTestDb1)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()