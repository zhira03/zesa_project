from fastapi import APIRouter, Depends, HTTPException, status, Query, Request, File, UploadFile
from sqlalchemy.orm import Session,joinedload, aliased
from dependencies import get_db
from pydanticModels import *
from auth import *
import models

router = APIRouter()

@router.post('/api/v1/auth/register/', status_code=status.HTTP_201_CREATED, response_model=RegisterUserResponse)
def register_user(user: RegisterUser, db:Session = Depends(get_db)):
    #check if username or email already exists
    existing_user = db.query(User).filter((User.username == user.username) | (User.email == user.email)).first()
    if existing_user:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Username or Email already exists")
    
    try:
        # Hash the password
        hashed_password = get_password_hash(user.password)
        
        new_user = User(
            name=user.name,
            surname=user.surname,
            username=user.username,
            email=user.email,
            role=user.role,
            password_hash=hashed_password #hashed in the model
        )
        db.add(new_user)
        db.flush()
        db.refresh(new_user)

        if user.role in [UserRole.PRODUCER, UserRole.PROSUMER]:
            if user.system is not None:
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
                new_user.system = new_system

                systemResponse = UserSystemResponse(
                    panel_count=new_system.panel_count,
                    panel_wattage=new_system.panel_wattage,
                    battery_capacity_kwh=new_system.battery_capacity_kwh,
                    inverter_capacity_kw=new_system.inverter_capacity_kw,
                    system_type=new_system.system_type,
                    household_size=new_system.household_size
                )
        
        default_balance = models.Balance(
            user_id=new_user.id,
            balance_currency=Currency.CREDITS,
            balance_value=0.0
        )
        db.add(default_balance)

        db.commit()

        return RegisterUserResponse(
            user_id=new_user.id,
            name=new_user.name,
            role=new_user.role,
            created_at=new_user.created_at,
            system=systemResponse if user.role in [UserRole.PRODUCER, UserRole.PROSUMER] and user.system else None
        )
    
    except HTTPException:
        raise
    except Exception as e:
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
    

@router.post('/api/v1/users/{user_id}/', status_code=status.HTTP_200_OK, response_model=UserInfo)
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
    
@router.patch("/api/v1/users/{id}", response_model=UserInfo)
def update_user(id: uuid.UUID, payload: UserUpdate, db: Session = Depends(get_db)):
    user = db.query(User).options(joinedload(User.system)).filter(User.id == id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

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

    
