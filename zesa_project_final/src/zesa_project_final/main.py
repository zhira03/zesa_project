from fastapi import FastAPI
from dependencies import Base, SessionLocal, engine
from routes import router
from scheduler import init_scheduler

app = FastAPI()

@app.on_event('startup')
def startup_event():
    db = SessionLocal()

    init_scheduler()
    
Base.metadata.create_all(bind=engine)

app.include_router(router)
