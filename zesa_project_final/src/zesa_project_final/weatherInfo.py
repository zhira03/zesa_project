#this pings the OpenWeather API to get weather info
from datetime import datetime
import uuid
import requests
from shapely import Point
from sqlalchemy import and_, func, update
from geoalchemy2.shape import to_shape
from shapely.ops import unary_union
from fastapi import Depends, HTTPException, status
from sqlalchemy.orm import Session,joinedload, aliased
from geoalchemy2.functions import ST_Equals, ST_Y
from dependencies import get_db
from pydanticModels import WeatherResponse
import models
from dotenv import load_dotenv
import os

load_dotenv()


API_key = os.getenv("API_KEY")

def assign_user_clusters(db: Session, radius_meters: float = 20000):
    """
    Creates clusters for users without a cluster_id.
    Ensures that existing clusters and their assigned users remain unchanged.
    """
    # Identify users who are not yet in a cluster
    unclustered_users = db.query(models.User).filter(models.User.cluster_id == None).all()
    
    if not unclustered_users:
        return "All users are already assigned to a cluster."

    locations_to_cluster = [user.location for user in unclustered_users]
    if not locations_to_cluster:
        return []

    # Get the raw cluster geospatial info from PostGIS
    cluster_geoms_query = db.query(
        func.unnest(func.ST_ClusterWithin(
            func.ST_Collect(locations_to_cluster), radius_meters)
        ).label("geom")
    ).all()

    cluster_data = []

    for cluster_row in cluster_geoms_query:
        shapely_geom = to_shape(cluster_row.geom)
        
        # Calculate centroid and user count from the geom
        centroid = shapely_geom.centroid
        
        # Create a new cluster entry
        new_cluster = models.UserCluster(
            radius=radius_meters / 1000,
            location=Point(centroid.x, centroid.y),
            num_users=0 # Will be updated in the next step
        )
        db.add(new_cluster)
        db.flush()

        affected_rows = db.execute(
            update(models.User)
            .where(and_(
                models.User.cluster_id == None,
                func.ST_Within(models.User.location, cluster_row.geom)
            ))
            .values(cluster_id=new_cluster.id)
        ).rowcount
        
        new_cluster.num_users = affected_rows
        db.add(new_cluster)

        cluster_data.append({
            "cluster_id": str(new_cluster.id),
            "centroid": {"lat": centroid.y, "lon": centroid.x},
            "user_count": affected_rows
        })

    existing_clusters = db.query(models.UserCluster).all()
    for cluster in existing_clusters:
        updated_count = db.query(models.User).filter(models.User.cluster_id == cluster.id).count()
        cluster.num_users = updated_count
        db.add(cluster)

    db.commit()
    return cluster_data

def assign_new_user_to_cluster(db: Session, user: models.User, radius_meters: float = 20000):
    """
    Assigns a newly registered user to the nearest cluster if within radius,
    otherwise creates a new cluster.
    """
    # find nearest cluster within 20 km
    nearest_cluster = db.query(models.UserCluster).filter(
        func.ST_DWithin(
            models.UserCluster.location,
            user.location,
            radius_meters
        )
    ).first()

    if nearest_cluster:
        # assign user to existing cluster
        user.cluster_id = nearest_cluster.id
        nearest_cluster.num_users += 1
        db.add(user)
        db.add(nearest_cluster)
    else:
        # create new cluster centered on this user
        centroid = db.query(
            func.ST_Y(user.location).label("lat"),
            func.ST_X(user.location).label("lon")
        ).first()

        new_cluster = models.UserCluster(
            id=uuid.uuid4(),
            radius=radius_meters / 1000,
            location=user.location,
            num_users=1
        )
        db.add(new_cluster)
        db.flush()

        user.cluster_id = new_cluster.id
        db.add(user)

    db.commit()
    return user.cluster_id

def fetch_weather_by_cluster(db: Session, api_key: str):
    clusters = db.query(
        models.UserCluster.id,
        models.UserCluster.num_users,
        func.ST_Y(models.UserCluster.location).label("lat"),
        func.ST_X(models.UserCluster.location).label("lon")
    ).all()

    weather_data = []

    for cluster in clusters:
        weather = getWeatherInfo(
            lat=cluster.lat,
            lon=cluster.lon,
            api_key=api_key
        )

        #save each weather data point per cluster as long as weatherdata.is_expired is false
        #check if cluster already has weather data point
        cluster_weather = db.query(models.WeatherData).filter(models.WeatherData.cluster_id == cluster.id, models.WeatherData.is_expired == False).first()
        if not cluster_weather:
            new_cluster_weather_data = models.WeatherData(
                temp = weather.temp,
                pressure = weather.pressure,
                humidity = weather.humidity,
                dew_point = weather.dew_point,
                uvi = weather.uvi,
                cloud_cover = weather.clouds,
                visibility = weather.visibility,
                cluster_id = cluster.id,
                wind_speed = weather.wind_speed
            )

        db.add(new_cluster_weather_data)
        db.commit()

        weather_data.append({
            "cluster_id": str(cluster.id),
            "weather": weather.dict(),
            "user_count": cluster.num_users
        })

    return weather_data


def getWeatherInfo(lat,lon) -> WeatherResponse:
    timestamp = int(datetime.utcnow().timestamp())  # UNIX time

    api_url = (
        f"https://api.openweathermap.org/data/3.0/onecall/timemachine"
        f"?lat={lat}&lon={lon}&dt={timestamp}&appid={API_key}&units=metric"
    )

    response = requests.get(api_url)
    if response.status_code != 200:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Failed to fetch weather data")

    data = response.json()

    # take current (hourly) weather data
    current = data.get("data", [])[0] if "data" in data else data.get("current")

    if not current:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Weather data unavailable")

    return WeatherResponse(
        temp=current["temp"],
        pressure=current["pressure"],
        humidity=current["humidity"],
        dew_point=current["dew_point"],
        uvi=current.get("uvi", 0),
        clouds=current["clouds"],
        visibility=current["visibility"],
        wind_speed=current["wind_speed"]
    )



