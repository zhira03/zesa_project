from typing import Dict, List, Optional
from sqlalchemy.orm import Session
from pydantic import BaseModel, Field, EmailStr, field_validator
from datetime import date
from models import *
from typing_extensions import Annotated
import uuid

class UserSystem(BaseModel):
    user_id : uuid.UUID
    panel_wattage : float
    panel_count : int
    battery_capacity_kwh: float
    inverter_capacity_kw: float
    system_type : SystemType.HYBRID
    installation_date : DateTime
    household_size : int

class RegisterUser(BaseModel):
    name: str
    surname: str
    username: str
    email: EmailStr
    role: UserRole = UserRole.PROSUMER
    password: str
    system: Optional[UserSystem] = None #user might be a consumer

class RegisterUserResponse(BaseModel):
    user_id: uuid.UUID
    name: str
    role: UserRole
    created_at: DateTime
    system : Optional[UserSystem] = None

class LoginUser(BaseModel):
    email: Optional[EmailStr] = None
    username: Optional[str] = None
    password: str

    @field_validator('username')
    def validate_login_fields(cls, v, values):
        email = values.get('email')
        if not email and not v:
            raise ValueError('Either email or username must be provided')
        if email and v:
            raise ValueError('Provide either email or username, not both')
        return v

class LoginUserResponse(BaseModel):
    user_id: uuid.UUID
    name: str
    email: str
    role: UserRole
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    expires_in: int
    message: str = "Login successful"


