from sqlalchemy import ARRAY, UUID, Boolean, Column, Date, DateTime, Integer, String, Float, ForeignKey, TIMESTAMP, Text, TypeDecorator, text, Enum, event, func, UniqueConstraint, CheckConstraint
#from sqlalchemy.types import Decimal
from sqlalchemy.orm import relationship, Session, validates
from sqlalchemy.orm import Session as OrmSession 
from dependencies import Base
import os
from datetime import datetime, timedelta
import random
from enum import Enum as MyEnum
import uuid
from sqlalchemy.dialects.postgresql import UUID
from geoalchemy2 import Geometry

from geoalchemy2.shape import to_shape
from shapely.geometry import Point

#custom class to format the GPS coordinates
class GeometryType(TypeDecorator):
    impl = String
    cache_ok = True

    def process_bind_param(self, value, dialect):
        return f"SRID=4326;POINT({value.lon} {value.lat})"

    def process_result_value(self, value, dialect):
        return value

class SimulationStatus(str, MyEnum):
    RUNNING = "Running"
    PAUSED = "Paused"
    FAILED = "Failed"

class EnergyDataSource(str, MyEnum):
    SIMULATION =  "Simulation"
    IOT = "IoT-Device"
    OTHER = "Other"

class TradeTickStatus(str, MyEnum):
    PENDING = "Pending"
    PARTIAL = "Partial" 
    COMPLETED = "Completed"
    FAILED = "Failed"

class Currency(str, MyEnum):
    ZIG = "ZiG"
    USD = "USD"
    ZAR = "Rand"
    CREDITS = "CreditS"

class PaymentMethod(str, MyEnum):
    CASH = "Cash"
    SWIPE = "Swipe"
    ECOCASH = "Ecocash"
    INNBUCKS = "Innbucks"
    CREDIT = "Credit"

class TransactionStatus(str, MyEnum):
    PENDING = 'Pending'
    COMPLETED = 'Completed'
    REJECTED = 'Rejected'
    PAUSED = 'Paused'
    FAILED = 'Failed'

class UserRole(str, MyEnum):
    ADMIN = "Admin"
    PROSUMER = "Prosumer"  # produces & consumes
    CONSUMER = "Consumer"  # only consumes
    PRODUCER = "Producer"  #only produces(offgrid)
    DEV_ADMIN = "dev_admin" #master dev(me)

class SystemType(str, MyEnum):
    GRID_TIED = "grid_tied"
    OFF_GRID = "off_grid"
    HYBRID = "hybrid"

class WalletType(str, MyEnum):
    FS = "FS"        # FileSystemWallet
    VAULT = "VAULT"
    KMS = "KMS"

class FabricIdentityStatus(str, MyEnum):
    ACTIVE = "ACTIVE"
    REVOKED = "REVOKED"


class User(Base):
    __tablename__ = "users"
    id = Column(UUID(as_uuid=True), default=uuid.uuid4, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    surname = Column(String(50), nullable=False)
    # we can pull the user's location and feed it to the model for better simulation
    location = Column(Geometry("POINT", srid=4326), nullable=False)
    email = Column(String(255), unique=True, index=True, nullable=False)
    username = Column(String(100), nullable=False, unique=True)
    password_hash = Column(String(255), nullable=False)  # store hashed password
    role = Column(Enum(UserRole), default=UserRole.CONSUMER, nullable=False)
    updated_at = Column(DateTime(timezone=True),server_default=func.now(),onupdate=func.now())
    cluster_id = Column(UUID(as_uuid=True), ForeignKey('user_cluster.id'), nullable=True, index=True)

    fabric_identities = relationship("FabricIdentity",back_populates="user",cascade="all, delete-orphan")
    system = relationship("UserSystem", back_populates="user", uselist=False)
    balances = relationship("Balance", back_populates="user")
    #1 user can only have 1 cluster
    cluster = relationship("UserCluster", back_populates="users")


class UserSystem(Base):
    __tablename__ = "user_systems"

    id = Column(UUID(as_uuid=True), default=uuid.uuid4, primary_key=True, index=True) #this is the chain AssetID
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False, unique=True)
    panel_wattage = Column(Float, nullable=True)  # wattage per panel
    panel_count = Column(Integer, nullable=True)
    battery_capacity_kwh = Column(Float, nullable=True)
    inverter_capacity_kw = Column(Float, nullable=True)
    system_type = Column(Enum(SystemType), default=SystemType.HYBRID)
    installed_date = Column(DateTime, nullable=True)
    #number of people in the house using the system
    household_size = Column(Integer, nullable=True)
    energy_data = relationship("EnergyData", back_populates="user_system")

    user = relationship("User", back_populates="system")
    __table_args__ = (
        CheckConstraint("panel_wattage > 0", name="positive_panel_wattage"),
        CheckConstraint("panel_count > 0", name="positive_panel_count"),
        CheckConstraint("battery_capacity_kwh >= 0", name="non_negative_battery"),
        CheckConstraint("inverter_capacity_kw > 0", name="positive_inverter"),
    )

class UserCluster(Base):
    __tablename__ = 'user_cluster'

    id = Column(UUID(as_uuid=True), default=uuid.uuid4, primary_key=True, index=True)
    radius = Column(Float, nullable=False)
    location = Column(Geometry('POINT', srid=4326), nullable=False)
    num_users = Column(Integer, nullable=False, default=0)
    users = relationship("User", back_populates="cluster")
    #TODO: dont forget to add the cluster name!!, it'll be the district/neighbour hood name
    weather_data = relationship(
        "WeatherData",
        back_populates="cluster",
        cascade="all, delete-orphan"
    )


class WeatherData(Base):
    __tablename__ = "weather_data"

    id = Column(UUID(as_uuid=True), default=uuid.uuid4, primary_key=True, index=True)
    temp = Column(Float, nullable=False, default=0.0)
    pressure = Column(Float, nullable=False, default=0.0)
    humidity = Column(Float, nullable=False, default=0.0)
    dew_point = Column(Float, nullable=False, default=0.0)
    uvi = Column(Float, nullable=False, default=0.0)
    cloud_cover = Column(Float, nullable=False, default=0.0)
    visibility = Column(Float, nullable=False, default=0.0)
    wind_speed = Column(Float, nullable=False, default=0.0)
    is_expired = Column(Boolean, nullable=False, default=False)
    cluster_id = Column(UUID(as_uuid=True), ForeignKey('user_cluster.id'), nullable=False, index=True)
    cluster = relationship("UserCluster", back_populates="weather_data")

class SimulationRun(Base):
    __tablename__ = "simulation_runs"
    
    id = Column(UUID(as_uuid=True), default=uuid.uuid4, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    seed = Column(Integer, nullable=True)  # for reproducibility
    created_at = Column(DateTime, default=datetime.utcnow)
    status = Column(Enum(SimulationStatus), default=SimulationStatus.RUNNING)
    description = Column(Text, nullable=True)

class EnergyData(Base):
    __tablename__ = "energy_data"

    id = Column(UUID(as_uuid=True), default=uuid.uuid4, primary_key=True, index=True)
    user_system_id = Column(UUID(as_uuid=True), ForeignKey("user_systems.id"), nullable=False)
    timestamp = Column(DateTime, index=True, nullable=False)
    generation_kwh = Column(Float, nullable=False)
    consumption_kwh = Column(Float, nullable=False)
    surplus_kwh = Column(Float, nullable=False)  # generation - consumption
    source = Column(Enum(EnergyDataSource, name = 'data-sorce-enum'), nullable=False, default=EnergyDataSource.SIMULATION)  # simulator or IoT
    simulation_run_id = Column(UUID(as_uuid=True), ForeignKey("simulation_runs.id"), nullable=True)
    is_captured = Column(Boolean,nullable = False, default = False)

    user_system = relationship("UserSystem", back_populates="energy_data")

    __table_args__ = (
        CheckConstraint("generation_kwh >= 0", name="positive_generation"),
        CheckConstraint("consumption_kwh >= 0", name="positive_consumption"),
        CheckConstraint("surplus_kwh = generation_kwh - consumption_kwh", name="correct_surplus"),
    )

    @validates('surplus_kwh')
    def validate_surplus(self, key, value):
        # Ensure surplus = generation - consumption
        if hasattr(self, 'generation_kwh') and hasattr(self, 'consumption_kwh'):
            expected = self.generation_kwh - self.consumption_kwh
            if abs(value - expected) > 0.001:  # Allow for floating point precision
                raise ValueError(f"Surplus must equal generation - consumption")
        return value


class Balance(Base):
    __tablename__ = "balances"
    __table_args__ = (UniqueConstraint("user_id", "balance_currency", name="unique_user_currency"),)

    id = Column(UUID(as_uuid=True), default=uuid.uuid4, primary_key=True, index=True)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    balance_currency = Column(Enum(Currency, name= 'balance-currency-enum'), nullable=False, default=Currency.CREDITS)
    balance_value = Column(Float, default=0.0) 

    user = relationship("User", back_populates="balances")


class Transaction(Base):
    __tablename__ = "transactions"

    id = Column(UUID(as_uuid=True), default=uuid.uuid4, primary_key=True, index=True)
    seller = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    buyer = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    timestamp = Column(DateTime, default=datetime.utcnow, index=True)
    kwh = Column(Float, nullable=False)
    price_per_kwh = Column(Float, nullable=False)
    total_amount = Column(Float, nullable=False)
    tick_id = Column(UUID(as_uuid=True), ForeignKey("trade_ticks.id"), nullable=True)
    transaction_status = Column(Enum(TransactionStatus, name = "transaction_enum"), nullable =False, default=TransactionStatus.COMPLETED)
    failure_reason = Column(Text, nullable=True)  # If status = FAILED
    simulation_run_id = Column(UUID(as_uuid=True), ForeignKey("simulation_runs.id"), nullable=True)
    
    # prevent self-trading
    __table_args__ = (
        CheckConstraint("seller != buyer", name="no_self_trading"),
    )

    # optional relationships (self joins)
    from_user = relationship("User", foreign_keys=[seller])
    to_user = relationship("User", foreign_keys=[buyer])

    @validates('total_amount')
    def validate_total_amount(self, key, value):
        if hasattr(self, 'kwh') and hasattr(self, 'price_per_kwh'):
            expected = self.kwh * self.price_per_kwh
            if abs(value - expected) > 0.001:
                raise ValueError("Total amount must equal kWh × price per kWh")
        return value


class TradeTick(Base):
    __tablename__ = "trade_ticks"

    id = Column(UUID(as_uuid=True), default=uuid.uuid4, primary_key=True, index=True)
    tick_timestamp = Column(DateTime, default=datetime.utcnow, unique=True, index=True)
    status = Column(Enum(TradeTickStatus, name='trade_tick_enum'), nullable=False, default=TradeTickStatus.COMPLETED)

    transactions = relationship("Transaction", backref="trade_tick")

    @property
    def total_energy_traded(self):
        """Sum of all energy traded in this tick"""
        return sum(t.kwh for t in self.transactions if t.transaction_status == TransactionStatus.COMPLETED)
    
    @property
    def total_value_traded(self):
        """Sum of all money traded in this tick"""
        return sum(t.total_amount for t in self.transactions if t.transaction_status == TransactionStatus.COMPLETED)
    
class FabricIdentity(Base):
    __tablename__ = "fabric_identities"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True),ForeignKey("users.id", ondelete="CASCADE"),nullable=False)
    fabric_identity = Column(String(255), unique=True, nullable=False)
    msp_id = Column(String(64), nullable=False)
    is_admin = Column(Boolean, default=False)
    wallet_type = Column(Enum(WalletType),nullable=False,default=WalletType.FS)
    status = Column(Enum(FabricIdentityStatus),nullable=False,default=FabricIdentityStatus.ACTIVE)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    user = relationship("User", back_populates="fabric_identities")
    __table_args__ = (
    UniqueConstraint("fabric_identity", "msp_id"),
)

