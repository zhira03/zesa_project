from collections import defaultdict
import json
from uuid import uuid4
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger
from datetime import datetime, timedelta, time
from sqlalchemy.orm import Session,joinedload
import models
from dependencies import SessionLocal
from simService import add_energy_data_batch
from fastapi import BackgroundTasks, HTTPException, status
import httpx


background_tasks = BackgroundTasks()

weather_by_cluster = {
    'harare_north': {
        'temperature': 28,   # Celsius
        'humidity': 65,      # Percent
        'clouds': 30         # Percent cloud cover
    },
    'bulawayo_south': {
        'temperature': 30,
        'humidity': 55,
        'clouds': 15
    }
}
#fetch weather info from the openWeather API
def fetch_weather_data():
    pass

def expire_old_weather_data():
    db : Session = SessionLocal()

    #expire all outdated weather info
    try:
        db.query(models.WeatherData).update({models.WeatherData.is_expired == True})
        db.commit()

    except Exception as e:
        db.rollback()
    finally:
        db.close()

async def startSim():
    db: Session = SessionLocal()
    try:
        # Pull relevant user system info with joined loads
        users = db.query(models.UserSystem).filter(models.UserSystem.is_available).options(
            joinedload(models.UserSystem.user).joinedload(models.User.cluster)
        ).all()

        if users.count() == 0:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Not enough prosumer to run simulation"
            )
        
        # Build user_data
        user_data = []
        user_system_map = {}  # Map user_id to user_system_id for later
        for idx, user_system in enumerate(users, start=1):
            user = user_system.user
            cluster = user.cluster
            user_data.append({
                'user_id': idx,
                'panel_wattage': user_system.panel_wattage,
                'panel_count': user_system.panel_count,
                'household_size': user_system.household_size,
                'cluster_id': str(cluster.id),
                'battery_capacity': user_system.battery_capacity_per_kwh,
                'battery_count': user_system.battery_count,
                'inverter_capacity': user_system.inverter_capacity_kw,
                'location': str(cluster.location)
            })
            user_system_map[idx] = user_system.id
        
        # Build weather_data
        weather_data = weather_by_cluster
        # clusters = db.query(models.UserCluster).options(joinedload(models.UserCluster.weather_data)).all()
        # for cluster in clusters:
        #     # Get the latest non-expired weather data
        #     weather = next((w for w in cluster.weather_data if not w.is_expired), None)
        #     if weather:
        #         weather_data[cluster.id] = {
        #             'temperature': weather.temp,
        #             'humidity': weather.humidity,
        #             'clouds': weather.cloud_cover
        #         }
        
        # Assume hours for simulation, e.g., 24.0 for a day
        hours = 24.0
        
        # call the simulation endpoint
        try:
            async with httpx.AsyncClient() as client:
                result = await client.post(
                    "http://localhost:4000/sim/runGen/",
                    json=
                    {   "user_data": user_data,
                        "weather_data": weather_data,
                        "hours": hours
                    },
                    timeout=2
                )
                if result.status_code != 200:
                    raise HTTPException(
                    status_code=502,
                    detail=f"Simulation Run failed: {result}"
                )
                else:
                    print(result)
        except HTTPException as e:
            raise HTTPException(
                status_code=502,
                detail=f"Simulation Run failed: {e}"
            )

        
        # Transform run_sim result into EnergyDataCreate format
        energy_data_batch = []
        for user_data_point in result:
            user_sim_id = user_system_map[user_data_point['user_id']]
            energy_data_batch.append({
                'user_system_id': user_sim_id,
                'generation_kwh': user_data_point['total_generation_kwh'],
                'consumption_kwh': user_data_point['total_consumption_kwh']
            })
        
        # Call the add_energy_data_batch service
        add_energy_data_batch(payload=energy_data_batch, background_tasks=background_tasks, db=db)
          
    except Exception as e:
        db.rollback()
        raise
    finally:
        db.close()


def init_scheduler() -> BackgroundScheduler:
    scheduler = BackgroundScheduler(
        timezone = 'UTC',
        # Configure job defaults
        job_defaults={
            'coalesce': True,  
            'max_instances': 1,  # Prevent overlapping executions
            'misfire_grace_time': 300  # 5 minutes grace period for missed jobs
        }
    )

    try:
        #expire old weather info
        scheduler.add_job(
            expire_old_weather_data,
            'interval',
            hours=1,
            id='expire old weather data',
            name='Reset WeatherData Tables',
            replace_existing=True
        )
        # solar generation simulation
        scheduler.add_job(
            startSim,
            'interval',
            minutes = 10,
            id = 'start generation simulation',
            name = 'Generation Simulation',
            replace_existing=True
        )

        scheduler.start()

        return scheduler

    except Exception as scheduler_error:
        raise

def get_scheduler_status(scheduler: BackgroundScheduler) -> dict:
    """Get current status of all scheduled jobs"""
    jobs_status = []
    for job in scheduler.get_jobs():
        jobs_status.append({
            'id': job.id,
            'name': job.name,
            'next_run': job.next_run_time.isoformat() if job.next_run_time else None,
            'trigger': str(job.trigger)
        })
    
    return {
        'scheduler_running': scheduler.running,
        'jobs': jobs_status
    }