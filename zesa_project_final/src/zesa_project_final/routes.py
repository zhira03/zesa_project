from decimal import Decimal, getcontext
from fastapi import APIRouter, Depends, HTTPException, status, Query, Request, File, UploadFile
from psycopg2 import IntegrityError
import httpx
from shapely import Point
from sqlalchemy.orm import Session,joinedload, aliased
from dependencies import get_db
from pydanticModels import *
from auth import *
import models
from utils import _get_or_create_balance
from weatherInfo import assign_new_user_to_cluster

getcontext().prec = 12

router = APIRouter()
#register on db then on chain
@router.post(
    "/api/v1/auth/register/",
    status_code=status.HTTP_201_CREATED,
    response_model=RegisterUserResponse
)
async def register_user(
    user: RegisterUser,
    db: Session = Depends(get_db),
     
):
    # #Admin-only
    # if current_user.role != UserRole.ADMIN:
    #     raise HTTPException(
    #         status_code=status.HTTP_403_FORBIDDEN,
    #         detail="Only admins can register users"
    #     )

    # Check uniqueness
    existing_user = db.query(User).filter(
        (User.username == user.username) |
        (User.email == user.email)
    ).first()
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Username or Email already exists"
        )
    
    role = "Consumer"
    if user.role in [UserRole.PRODUCER, UserRole.PROSUMER]:
        role = "Prosumer"

    try:
        # ---------- 1️⃣ Register user on Fabric FIRST ----------
        fabric_user_id = f"user_{user.username}"

        async with httpx.AsyncClient() as client:
            # --- STEP A: Create the Identity in the Node Wallet ---
            enroll_res = await client.post(
                "http://localhost:4000/fabric/register-identity",
                json={"userId": fabric_user_id}
            )
            if enroll_res.status_code != 200:
                raise HTTPException(
                    status_code=500,
                    detail=f"Fabric CA enrollment failed: {enroll_res.text}"
                )

            # --- STEP B: Submit Transaction using that NEW identity ---
            r = await client.post(
                "http://localhost:4000/fabric/submit",
                json={
                    "channel": "mychannel",
                    "chaincode": "energy",
                    "function": "RegisterUser",
                    "args": [fabric_user_id, role],
                    "identity": fabric_user_id
                },
                timeout=10
            )

        payload_text = r.text

        if r.status_code != 200:
            if "already registered" in payload_text.lower():
                payload = r.json()
                print("FABRIC RESPONSE:", payload)
            else:
                raise HTTPException(
                    status_code=502,
                    detail=f"Fabric registration failed: {payload_text}"
                )
        else:
            payload = r.json()
            print("FABRIC RESPONSE:", payload)

        # ----------Create DB records ----------
        hashed_password = get_password_hash(user.password)
        user_location = Point(user.location.lon, user.location.lat)

        new_user = User(
            name=user.name,
            surname=user.surname,
            username=user.username,
            email=user.email,
            role=user.role,
            password_hash=hashed_password,
            location=user_location
        )
        db.add(new_user)
        db.flush()

        # Cluster assignment
        cluster_id = assign_new_user_to_cluster(db, new_user)

        # Optional energy system
        systemResponse = None
        if user.role in [UserRole.PRODUCER, UserRole.PROSUMER] and user.system:
            new_system = models.UserSystem(
                user_id=new_user.id,
                panel_wattage=user.system.panel_wattage,
                panel_count=user.system.panel_count,
                battery_capacity_kwh=user.system.battery_capacity_kwh,
                inverter_capacity_kw=user.system.inverter_capacity_kw,
                system_type=user.system.system_type,
                installed_date=user.system.installation_date or datetime.utcnow(),
                household_size=user.system.household_size
            )
            db.add(new_system)

            systemResponse = UserSystemResponse(
                panel_count=new_system.panel_count,
                panel_wattage=new_system.panel_wattage,
                battery_capacity_kwh=new_system.battery_capacity_kwh,
                inverter_capacity_kw=new_system.inverter_capacity_kw,
                system_type=new_system.system_type,
                household_size=new_system.household_size
            )

        # Default balance
        db.add(models.Balance(
            user_id=new_user.id,
            balance_currency=Currency.CREDITS,
            balance_value=0.0
        ))

        # Fabric identity mapping
        fabric_identity = FabricIdentity(
            user_id=new_user.id,
            fabric_identity=fabric_user_id,
            msp_id="Org1MSP",
            is_admin=False,
            status=FabricIdentityStatus.ACTIVE,
        )
        db.add(fabric_identity)

        db.commit()

        return RegisterUserResponse(
            user_id=new_user.id,
            name=new_user.name,
            role=new_user.role,
            created_at=new_user.created_at,
            system=systemResponse,
            cluster_id=cluster_id
        )

    except HTTPException as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Register User failed here: {str(e)}"
        )
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Register User failed: {str(e)}"
        )
    
@router.post('/api/v1/auth/login/', status_code=status.HTTP_200_OK, response_model=LoginUserResponse)
def login_user(login_data: LoginUser, db: Session = Depends(get_db)):
    try:
        # Check for rate limiting
        identifier = login_data.email or login_data.username
        if login_tracker.is_locked_out(identifier):
            raise HTTPException(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                detail="Too many failed login attempts. Please try again later."
            )

        # Authenticate user
        user = None
        if login_data.email:
            user = authenticate_user(db, login_data.email, login_data.password)
        elif login_data.username:
            user = authenticate_user_by_username(db, login_data.username, login_data.password)

        if not user:
            login_tracker.record_failed_attempt(identifier)
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid email/username or password",
                headers={"WWW-Authenticate": "Bearer"},
            )

        # Record successful login
        login_tracker.record_successful_login(identifier)

        # Create tokens
        tokens = create_tokens_for_user(user)

        return LoginUserResponse(
            user_id=user.id,
            name=user.name,
            email=user.email,
            role=user.role,
            access_token=tokens["access_token"],
            refresh_token=tokens["refresh_token"],
            token_type=tokens["token_type"],
            expires_in=tokens["expires_in"]
        )
    
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Get User Info failed: {str(e)}"
        )
    

@router.get('/api/v1/users/{user_id}/', status_code=status.HTTP_200_OK, response_model=UserInfo)
def get_user(user_id:uuid.UUID, db: Session = Depends(get_db)):
    exists = db.query(User).filter(User.id == user_id).first()
    if not exists:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    
    try:
        # #lets lazy load all related tables for query optimization
        user = db.query(User).options(
            joinedload(User.system),
            joinedload(User.balances),
            joinedload(User.energy_data)
        ). filter(User.id == user_id).first()

        return UserInfo(
            user_id=user.id,
            name=user.name,
            surname=user.surname,
            username=user.username,
            email=user.email,
            role=user.role,
            created_at=user.created_at,
            system=user.system,
            balances=user.balances,
            energy_data=user.energy_data
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Get User Info failed: {str(e)}"
        )
    
@router.patch("/api/v1/users/{id}/", response_model=UserInfo)
def update_user(id: uuid.UUID, payload: UserUpdate, db: Session = Depends(get_db)):
    user = db.query(User).options(joinedload(User.system)).filter(User.id == id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    try:
        # Update user fields
        update_data = payload.dict(exclude_unset=True)
        system_data = update_data.pop("system", None)

        for field, value in update_data.items():
            setattr(user, field, value)

        # Update or create system info
        if system_data:
            if user.system:
                for field, value in system_data.items():
                    setattr(user.system, field, value)
            else:
                new_system = UserSystem(user_id=user.id, **system_data)
                db.add(new_system)

        db.commit()
        db.refresh(user)

        return UserInfo(
            user_id=user.id,
            name=user.name,
            surname=user.surname,
            username=user.username,
            email=user.email,
            role=user.role,
            created_at=user.created_at,
            system=user.system,
            balances=user.balances,
            energy_data=user.energy_data
        )
    
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Get User Info failed: {str(e)}"
        )
    
#fetch weather info from API
@router.get('/api/v1/simulation/weather/', status_code = status.HTTP_200_OK)
def fetch_weather_info():
    pass

# POST /energy-data → Single reading
@router.post("/api/v1/energy-data/", status_code=status.HTTP_201_CREATED, response_model=EnergyDataResponse)
def add_energy_data(payload: EnergyDataCreate, db: Session = Depends(get_db)):
    # Ensure user exists
    user = db.query(User).filter(User.id == payload.user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Calculate surplus
    surplus = payload.generation_kwh - payload.consumption_kwh

    record = models.EnergyData(
        user_id=payload.user_id,
        timestamp=payload.timestamp,
        generation_kwh=payload.generation_kwh,
        consumption_kwh=payload.consumption_kwh,
        surplus_kwh=surplus,
        source=EnergyDataSource.SIMULATION
    )

    db.add(record)
    try:
        db.commit()
        db.refresh(record)
    except IntegrityError:
        db.rollback()
        raise HTTPException(status_code=400, detail="Duplicate energy data for this timestamp")

    return EnergyDataResponse(
        id=record.id,
        user_id=user.id,
        timestamp=record.timestamp,
        generation_kwh=record.generation_kwh,
        consumption_kwh=record.consumption_kwh
    )

# POST /energy-data/batch → Bulk ingestion
# get energy generation and consumption from the Mesa simulation
@router.post("/api/v1/energy-data/batch/", status_code=status.HTTP_201_CREATED, response_model=List[EnergyDataResponse])
def add_energy_data_batch(payload: List[EnergyDataCreate], db: Session = Depends(get_db)):
    records = []
    #create a simulation_run entry
    simulationRun = models.SimulationRun(
        name = payload.simRunName,
        seed = payload.seed,
        created_at = payload.timestamp,
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
            timestamp=entry.timestamp,
            generation_kwh=entry.generation_kwh,
            consumption_kwh=entry.consumption_kwh,
            surplus = surplus,
            source = EnergyDataSource.SIMULATION,
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
    
    #push energy made to chain
    #chain expects: PublishEnergy(assetID,prosumerID,kwh,price)
    #assetID is coming from UserSystem.id, so we need to pull that from the query

    return [
        EnergyDataResponse(
            id=r.id,
            user_id=r.user_id,
            timestamp=r.timestamp,
            generation_kwh=r.generation_kwh,
            consumption_kwh=r.consumption_kwh,
            surplus_kwh=r.surplus_kwh
        ) for r in records
    ]




















#trading engine now handled by hyperledger
# #the trading engine logic
# @router.post("/api/v1/trade/run/", response_model=TradeRunResponse, status_code=status.HTTP_200_OK)
# def run_trading_tick(
#     tick_timestamp: Optional[datetime] = None,
#     price_per_kwh: Optional[float] = None,
#     db: Session = Depends(get_db),
# ):
#     MIN_TRADE_KWH = 0.001         # ignore tiny micro-trades
#     DEFAULT_PRICE_PER_KWH = Decimal("0.10")

#     price = Decimal(str(price_per_kwh)) if price_per_kwh is not None else DEFAULT_PRICE_PER_KWH

#     if tick_timestamp is None:
#         tick_timestamp = db.query(func.max(models.EnergyData.timestamp)).scalar()
#         if tick_timestamp is None:
#             raise HTTPException(status_code=404, detail="No energy data available to run matching")
        
#     # prevent re-processing same tick
#     #TODO: I'll add a bool column on the relevat tables that we handle this check
#     existing_tick = db.query(models.TradeTick).filter(models.TradeTick.tick_timestamp == tick_timestamp).first()
#     if existing_tick:
#         raise HTTPException(status_code=400, detail=f"Tick {tick_timestamp.isoformat()} already processed (trade_tick id={existing_tick.id})")

#     # load all energy rows for this tick
#     energy_rows = db.query(models.EnergyData).filter(models.EnergyData.timestamp == tick_timestamp).all()
#     if not energy_rows:
#         raise HTTPException(status_code=404, detail="No energy readings found for the requested tick")
    
#     sellers = []
#     buyers = []
#     total_supply = Decimal("0.0")
#     total_demand = Decimal("0.0")

#     for energy in energy_rows:
#         surplus = Decimal(str(getattr(energy, "surplus_kwh", energy.generation_kwh - energy.consumption_kwh)))
#         #if power generated is more than whats consumed add each contibuters userID and the amount of energy they made in excess
#         if surplus >= Decimal(str(MIN_TRADE_KWH)):
#             sellers.append({"user_id":energy.user_id, "amount": float(surplus)})
#             total_supply += surplus
#         elif surplus <= -Decimal(str(MIN_TRADE_KWH)):
#             need = -surplus
#             buyers.append({"user_id":energy.user_id, "need":float(need)})
#             total_demand += need

#     # nothing to trade
#     if not sellers or not buyers:
#         return TradeRunResponse(
#             tick_timestamp=tick_timestamp,
#             total_supply_kwh=float(total_supply),
#             total_demand_kwh=float(total_demand),
#             total_traded_kwh=0.0,
#             unmatched_supply_kwh=float(total_supply),
#             unmatched_demand_kwh=float(total_demand),
#             transactions=[]
#         )
    
#     #else if there are sellers/buyers
#     # sort sellers (largest surplus first) and buyers (largest need first)
#     sellers.sort(key=lambda x: x['amount'], reverse=True)
#     buyers.sort(key=lambda x: x['need'], reverse=True)

#     transactions_out = []
#     total_traded = Decimal("0.0")

#     try:
#         #create a trade tick/session group
#         trade_tick = models.TradeTick(tick_timestamp=tick_timestamp, status=TradeTickStatus.PENDING)
#         db.add(trade_tick)
#         db.flush()  # ensure trade_tick.id available

#         buyers_mut = buyers[:]
#         for seller in sellers:
#             seller_id = seller['user_id']
#             remaining = float(seller['amount'])

#             if remaining <= MIN_TRADE_KWH:
#                 continue

#             # iterate thru the buyers in order
#             for i, b in enumerate(buyers_mut):
#                 #if there isnt anymore power left to share
#                 if remaining <= MIN_TRADE_KWH:
#                     break

#                 buyer_id = b['user_id']
#                 need = float(b['need'])
#                 if need <= MIN_TRADE_KWH:
#                     continue

#                 traded_kwh = min(remaining, need)
#                 if traded_kwh < MIN_TRADE_KWH:
#                     continue

#                 #money compute
#                 traded_decimal = Decimal(str(traded_kwh))
#                 total_amount = (traded_decimal * price).quantize(Decimal("0.000001"))

#                 #create transaction db row
#                 transaction = models.Transaction(
#                     from_user_id=seller_id,
#                     to_user_id=buyer_id,
#                     timestamp=datetime.utcnow(),
#                     kwh=traded_kwh,
#                     price_per_kwh=float(price),
#                     total_amount=float(total_amount),
#                     tick_id=trade_tick.id
#                 )
#                 db.add(transaction)
#                 db.flush() # we'll need the transaction.id

#                 #update the balances using the util function
#                 seller_bal = _get_or_create_balance(db, seller_id)
#                 buyer_bal = _get_or_create_balance(db, buyer_id)

#                 # Sellers earn credits; buyers pay (balance decreases)
#                 seller_bal.balance_value = (Decimal(str(seller_bal.balance_value)) + total_amount)
#                 buyer_bal.balance_value = (Decimal(str(buyer_bal.balance_value)) - total_amount)

#                 #prepare the output
#                 transactions_out.append(
#                     TransactionOut(
#                         id = transaction.id,
#                         from_user_id=seller_id,
#                         to_user_id=buyer_id,
#                         kwh=traded_kwh,
#                         price_per_kwh=price,
#                         total_amount=total_amount,
#                         timestamp=transaction.timestamp
#                     )
#                 )

#                 # decrement remaining & buyer need
#                 remaining -= traded_kwh
#                 buyers_mut[i]['need'] = need - traded_kwh
#                 total_traded += traded_decimal

#                 # finished with this seller; continue to next seller

#             # finalize trade tick
#             trade_tick.status = TransactionStatus.COMPLETED
#             db.commit()

#     except Exception as e:
#         db.rollback()
#         # update trade tick to failed (best-effort)
#         try:
#             trade_tick.status = TransactionStatus.FAILED
#             db.add(trade_tick)
#             db.commit()
#         except:
#             pass
#         raise HTTPException(status_code=500, detail=f"Trading engine failed: {str(e)}")
    
#     # compute leftover unmatched supply/demand
#     matched_kwh = total_traded
#     unmatched_supply = Decimal(str(total_supply)) - matched_kwh
#     unmatched_demand = Decimal(str(total_demand)) - matched_kwh
    
#     if unmatched_supply < Decimal("0"):
#         unmatched_supply = Decimal("0")
#     if unmatched_demand < Decimal("0"):
#         unmatched_demand = Decimal("0")

#     return TradeRunResponse(
#         tick_timestamp=tick_timestamp,
#         total_supply_kwh=float(total_supply),
#         total_demand_kwh=float(total_demand),
#         total_traded_kwh=float(matched_kwh),
#         unmatched_supply_kwh=float(unmatched_supply),
#         unmatched_demand_kwh=float(unmatched_demand),
#         transactions=transactions_out
#     )




    
