from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import text
import os
from dotenv import load_dotenv

load_dotenv()
localTestDb1 = "postgresql://postgres:newpassword@localhost:5432/localDB1"
localTestDb2 = "postgresql://postgres:newpassword@localhost:5432/localDB2"
localTestDb3= "postgresql://postgres:newpassword@localhost:5432/localDB3"

engine = create_engine(localTestDb3)
with engine.connect() as conn:
    conn.execute(text("CREATE EXTENSION IF NOT EXISTS postgis;"))
    conn.commit()
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()