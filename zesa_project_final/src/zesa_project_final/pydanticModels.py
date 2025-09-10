from __future__ import annotations
from typing import Dict, List, Optional
from pydantic import BaseModel, Field, EmailStr, field_validator
from datetime import date
from models import *
import uuid

class UserSystem(BaseModel):
    panel_wattage : float
    panel_count : int
    battery_capacity_kwh: float
    inverter_capacity_kw: float
    system_type : SystemType = SystemType.HYBRID
    installation_date : datetime
    household_size : int

class UserSystemResponse(BaseModel):
    panel_wattage : float
    panel_count : int
    battery_capacity_kwh: float
    inverter_capacity_kw: float
    system_type : SystemType 
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
    created_at: datetime
    system : Optional[UserSystemResponse] = None

class LoginUser(BaseModel):
    email: Optional[EmailStr] = None
    username: Optional[str] = None
    password: str

    # @field_validator('username')
    # def validate_login_fields(cls, v, values):
    #     email = values.get('email')
    #     if not email and not v:
    #         raise ValueError('Either email or username must be provided')
    #     if email and v:
    #         raise ValueError('Provide either email or username, not both')
    #     return v

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

class UserUpdate(BaseModel):
    name: Optional[str] = None
    surname: Optional[str] = None
    username: Optional[str] = None
    email: Optional[EmailStr] = None
    role: Optional[UserRole] = None
    system: Optional[UserSystem] = None

    class Config:
        orm_mode = True

class Balance(BaseModel):
    # id: uuid.UUID
    user_id: uuid.UUID
    balance_currency: Currency
    balance_value: float

    class Config:
        orm_mode = True

class EnergyData(BaseModel):
    id: uuid.UUID
    user_id: uuid.UUID
    timestamp: datetime
    consumption_kwh: float
    generation_kwh: float

    class Config:
        orm_mode = True

class UserInfo(BaseModel):
    user_id: uuid.UUID
    name: str
    surname: str
    username: str
    email: EmailStr
    role: UserRole
    created_at: datetime
    system: Optional[UserSystem] = None
    balances: List[Balance]
    energy_data: List[EnergyData] 

    class Config:
        orm_mode = True

class EnergyDataCreate(BaseModel):
    user_id: uuid.UUID
    timestamp: datetime
    generation_kwh: float
    consumption_kwh: float

    class Config:
        orm_mode = True

class EnergyDataResponse(BaseModel):
    id: uuid.UUID
    user_id: uuid.UUID
    timestamp: datetime
    generation_kwh: float
    consumption_kwh: float
    surplus_kwh: float

    class Config:
        orm_mode = True

class TransactionOut(BaseModel):
    id: Optional[uuid.UUID]
    from_user_id: uuid.UUID
    to_user_id: uuid.UUID
    kwh: float
    price_per_kwh: float
    total_amount: float
    timestamp: datetime

    class Config:
        orm_mode = True

class TradeRunResponse(BaseModel):
    tick_timestamp: datetime
    total_supply_kwh: float
    total_demand_kwh: float
    total_traded_kwh: float
    unmatched_supply_kwh: float
    unmatched_demand_kwh: float
    transactions: List[TransactionOut]
