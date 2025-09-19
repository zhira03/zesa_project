#this is to then collect the data from the users table,system info per user, combine the weather data 
#then send the combined info the the model as a csv document

import csv
from datetime import datetime
import io
from fastapi import Depends, HTTPException, status
from sqlalchemy.orm import Session,joinedload, aliased
from geoalchemy2.functions import ST_Equals, ST_Y
from dependencies import get_db
import models
from weatherInfo import fetch_weather_by_cluster

def getProsumers(db:Session = Depends(get_db)):
    prosumers= db.query(
        models.User).filter(
            models.User.role == models.UserRole.PROSUMER).options(
                joinedload(models.User.system), 
                joinedload(models.User.cluster)
            ).all()

    return prosumers


def getWeatherInfo(db: Session):
    """
    Fetch the latest non-expired weather data for all clusters.
    reads directly from the WeatherData table instead of hitting the API.
    """
    clusters_with_weather = (
        db.query(
            models.UserCluster.id.label("cluster_id"),
            models.UserCluster.num_users,
            models.WeatherData.temp,
            models.WeatherData.pressure,
            models.WeatherData.humidity,
            models.WeatherData.dew_point,
            models.WeatherData.uvi,
            models.WeatherData.cloud_cover,
            models.WeatherData.visibility,
            models.WeatherData.wind_speed
        )
        .join(models.WeatherData, models.WeatherData.cluster_id == models.UserCluster.id)
        .filter(models.WeatherData.is_expired == False)
        .all()
    )

    result = []
    for row in clusters_with_weather:
        result.append({
            "cluster_id": str(row.cluster_id),
            "user_count": row.num_users,
            "weather": {
                "temp": row.temp,
                "pressure": row.pressure,
                "humidity": row.humidity,
                "dew_point": row.dew_point,
                "uvi": row.uvi,
                "cloud_cover": row.cloud_cover,
                "visibility": row.visibility,
                "wind_speed": row.wind_speed
            }
        })

    return result


def combineIntoSingleCSV(db:Session):
    prosumers = getProsumers(db)
    weather_info_by_cluster = getWeatherInfo(db)

    # Turn weather list into dict for fast lookup
    weather_lookup = {w["cluster_id"]: w["weather"] for w in weather_info_by_cluster}

    # Create CSV in memory
    output = io.StringIO()
    writer = csv.writer(output)

    # CSV headers
    writer.writerow([
        "user_id",
        "name",
        "cluster_id",
        "lat",
        "lon",
        "panel_wattage",
        "panel_count",
        "battery_capacity_kwh",
        "inverter_capacity_kw",
        "system_type",
        "household_size",
        "weather_temp",
        "weather_humidity",
        "weather_clouds",
        "fetched_at"
    ])

    for user in prosumers:
        cluster = user.cluster
        system = user.system
        weather = weather_lookup.get(str(cluster.id)) if cluster else None

        writer.writerow([
            str(user.id),
            f"{user.name} {user.surname}",
            str(cluster.id) if cluster else None,
            cluster.location.coords[0][1] if cluster else None,  # lat
            cluster.location.coords[0][0] if cluster else None,  # lon
            system.panel_wattage if system else None,
            system.panel_count if system else None,
            system.battery_capacity_kwh if system else None,
            system.inverter_capacity_kw if system else None,
            system.system_type.value if system else None,
            system.household_size if system else None,
            weather["temperature"] if weather else None,
            weather["humidity"] if weather else None,
            weather["clouds"] if weather else None,
            datetime.utcnow().isoformat()
        ])

    output.seek(0)
    return output.getvalue()  # return CSV as string