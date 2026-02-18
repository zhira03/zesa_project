from typing import List
from fastapi import BackgroundTasks, Depends, HTTPException
from psycopg2 import IntegrityError
from chainUtils import publishEnergy
from dependencies import get_db
import models
from pydanticModels import EnergyDataCreate, EnergyDataResponse
from sqlalchemy.orm import Session, joinedload


def add_energy_data_batch(payload: List[EnergyDataCreate], background_tasks: BackgroundTasks,db: Session = Depends(get_db)):
    records = []
    #create a simulation_run entry
    simulationRun = models.SimulationRun(
        name = "First Run",
        seed = 10,
    )

    #create the entry
    db.add(simulationRun)
    db.flush()

    for entry in payload:
        user = db.query(models.UserSystem).filter(models.UserSystem.id == entry.user_system_id).first()
        if not user:
            raise HTTPException(status_code=404, detail=f"User {entry.user_system_id} not found")

        surplus = entry.generation_kwh - entry.consumption_kwh

        record = models.EnergyData(
            user_system_id=entry.user_system_id,
            generation_kwh=entry.generation_kwh,
            consumption_kwh=entry.consumption_kwh,
            surplus_kwh = surplus,
            source = models.EnergyDataSource.SIMULATION,
            simulation_run_id = simulationRun.id
        )
        records.append(record)

    db.add_all(records)
    try:
        db.commit()
        for r in records:
            db.refresh(r)
    except IntegrityError:
        db.rollback()
        raise HTTPException(status_code=400, detail="Duplicate entry in batch ingestion")
    
    background_tasks.add_task(
        publishEnergy,
        db = db
    )

    return [
        EnergyDataResponse(
            id=r.id,
            user_id=r.user_system_id,
            timestamp=r.timestamp,
            generation_kwh=r.generation_kwh,
            consumption_kwh=r.consumption_kwh,
            surplus_kwh=r.surplus_kwh
        ) for r in records
    ]