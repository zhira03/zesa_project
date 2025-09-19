from collections import defaultdict
import json
from uuid import uuid4
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger
from datetime import datetime, timedelta, time
from sqlalchemy.orm import Session,joinedload
import models
from dependencies import SessionLocal

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