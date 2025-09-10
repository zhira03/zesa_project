"""
Authentication module for Energy Trading Platform
Handles JWT tokens, password hashing, and user authentication
"""

from datetime import datetime, timedelta, timezone
from typing import Optional, Union
import uuid
import jwt
from passlib.context import CryptContext
from sqlalchemy.orm import Session
from fastapi import HTTPException, status, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import os
from functools import wraps

from dependencies import get_db
from models import User, UserRole  

# Configuration
SECRET_KEY = os.getenv("SECRET_KEY", "your-super-secret-key-change-this-in-production")
ALGORITHM = "RS256"
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "30"))
REFRESH_TOKEN_EXPIRE_DAYS = int(os.getenv("REFRESH_TOKEN_EXPIRE_DAYS", "7"))

PRIVATE_KEY_PATH = os.getenv("PRIVATE_KEY_PATH", "keys/private-key.pem")
PUBLIC_KEY_PATH = os.getenv("PUBLIC_KEY_PATH", "keys/public-key.pem")

# Password hashing context
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# HTTP Bearer token scheme
security = HTTPBearer()

class AuthenticationError(Exception):
    """Custom exception for authentication errors"""
    pass

class TokenData:
    """Token payload data structure"""
    def __init__(self, user_id: uuid, email: str, role: str, exp: datetime):
        self.user_id = user_id
        self.email = email
        self.role = role
        self.exp = exp

# =====================================
# PASSWORD UTILITIES
# =====================================

def verify_password(plain_password: str, hashed_password: str) -> bool:
    """
    Verify a plain password against its hash
    
    Args:
        plain_password: The plain text password
        hashed_password: The hashed password from database
        
    Returns:
        bool: True if password matches, False otherwise
    """
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password: str) -> str:
    """
    Hash a password
    
    Args:
        password: Plain text password
        
    Returns:
        str: Hashed password
    """
    return pwd_context.hash(password)

# =====================================
# USER DATABASE OPERATIONS
# =====================================

def get_user_by_email(db: Session, email: str) -> Optional[User]:
    """
    Get user by email address
    
    Args:
        db: Database session
        email: User's email address
        
    Returns:
        User object or None if not found
    """
    return db.query(User).filter(User.email == email).first()

def get_user_by_username(db: Session, username: str) -> Optional[User]:
    """
    Get user by username
    
    Args:
        db: Database session
        username: User's username
        
    Returns:
        User object or None if not found
    """
    return db.query(User).filter(User.username == username).first()

def get_user_by_id(db: Session, user_id: str) -> Optional[User]:
    """
    Get user by ID
    
    Args:
        db: Database session
        user_id: User's UUID
        
    Returns:
        User object or None if not found
    """
    return db.query(User).filter(User.id == user_id).first()

def authenticate_user(db: Session, email: str, password: str) -> Union[User, bool]:
    """
    Authenticate a user with email and password
    
    Args:
        db: Database session
        email: User's email
        password: Plain text password
        
    Returns:
        User object if authenticated, False otherwise
    """
    user = get_user_by_email(db, email)
    if not user:
        return False
    
    if not verify_password(password, user.password_hash):
        return False
    
    return user

def authenticate_user_by_username(db: Session, username: str, password: str) -> Union[User, bool]:
    """
    Authenticate a user with username and password
    
    Args:
        db: Database session
        username: User's username
        password: Plain text password
        
    Returns:
        User object if authenticated, False otherwise
    """
    user = get_user_by_username(db, username)
    if not user:
        return False
    
    if not verify_password(password, user.password_hash):
        return False
    
    return user

# =====================================
# RSA KEY MANAGEMENT (for RS256)
# =====================================

def load_private_key() -> str:
    """Load RSA private key for token signing"""
    if PRIVATE_KEY_PATH and os.path.exists(PRIVATE_KEY_PATH):
        with open(PRIVATE_KEY_PATH, 'r') as f:
            return f.read()
    # Fallback to HS256 with SECRET_KEY if no RSA keys
    return SECRET_KEY

def load_public_key() -> str:
    """Load RSA public key for token verification"""
    if PUBLIC_KEY_PATH and os.path.exists(PUBLIC_KEY_PATH):
        with open(PUBLIC_KEY_PATH, 'r') as f:
            return f.read()
    # Fallback to HS256 with SECRET_KEY if no RSA keys
    return SECRET_KEY

def get_algorithm() -> str:
    """Get the algorithm to use based on available keys"""
    if PRIVATE_KEY_PATH and PUBLIC_KEY_PATH:
        return "RS256"
    return "HS256"  # Fallback for development

# =====================================
# TOKEN MANAGEMENT
# =====================================

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    """
    Create JWT access token
    
    Args:
        data: Payload data to encode
        expires_delta: Token expiration time
        
    Returns:
        str: Encoded JWT token
    """
    to_encode = data.copy()
    
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    
    to_encode.update({"exp": expire})
    
    algorithm = get_algorithm()
    signing_key = load_private_key()
    
    encoded_jwt = jwt.encode(to_encode, signing_key, algorithm=algorithm)
    return encoded_jwt

def create_refresh_token(data: dict) -> str:
    """
    Create JWT refresh token
    
    Args:
        data: Payload data to encode
        
    Returns:
        str: Encoded JWT refresh token
    """
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + timedelta(days=REFRESH_TOKEN_EXPIRE_DAYS)
    to_encode.update({"exp": expire, "type": "refresh"})
    
    algorithm = get_algorithm()
    signing_key = load_private_key()
    
    encoded_jwt = jwt.encode(to_encode, signing_key, algorithm=algorithm)
    return encoded_jwt

def verify_token(token: str) -> TokenData:
    """
    Verify and decode JWT token
    
    Args:
        token: JWT token string
        
    Returns:
        TokenData: Decoded token data
        
    Raises:
        AuthenticationError: If token is invalid
    """
    try:
        algorithm = get_algorithm()
        verification_key = load_public_key()
        
        payload = jwt.decode(token, verification_key, algorithms=[algorithm])
        
        user_id: str = payload.get("sub")
        email: str = payload.get("email")
        role: str = payload.get("role")
        exp: datetime = datetime.fromtimestamp(payload.get("exp"), tz=timezone.utc)
        
        if user_id is None or email is None:
            raise AuthenticationError("Invalid token payload")
            
        return TokenData(user_id=user_id, email=email, role=role, exp=exp)
        
    except jwt.ExpiredSignatureError:
        raise AuthenticationError("Token has expired")
    except jwt.JWTError:
        raise AuthenticationError("Invalid token")

def create_tokens_for_user(user: User) -> dict:
    """
    Create both access and refresh tokens for a user
    
    Args:
        user: User object
        
    Returns:
        dict: Dictionary containing both tokens
    """
    token_data = {
        "sub": str(user.id),  # Convert UUID to string
        "email": user.email,
        "role": user.role.value,  # Enum value
        "name": user.name
    }
    
    access_token = create_access_token(token_data)
    refresh_token = create_refresh_token(token_data)
    
    return {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "token_type": "bearer",
        "expires_in": ACCESS_TOKEN_EXPIRE_MINUTES * 60  # in seconds
    }

# =====================================
# FASTAPI DEPENDENCIES
# =====================================

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
) -> User:
    """
    FastAPI dependency to get current authenticated user
    
    Args:
        credentials: HTTP Authorization credentials
        db: Database session
        
    Returns:
        User: Current authenticated user
        
    Raises:
        HTTPException: If authentication fails
    """
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    try:
        token_data = verify_token(credentials.credentials)
        user = get_user_by_id(db, token_data.user_id)
        
        if user is None:
            raise credentials_exception
            
        return user
        
    except AuthenticationError:
        raise credentials_exception

async def get_current_active_user(
    current_user: User = Depends(get_current_user)
) -> User:
    """
    FastAPI dependency to get current active user
    Add additional checks here if you have user status fields
    """
    
    return current_user

# =====================================
# ROLE-BASED ACCESS CONTROL
# =====================================

def require_role(allowed_roles: list[UserRole]):
    """
    Decorator/dependency factory for role-based access control
    
    Args:
        allowed_roles: List of allowed user roles
        
    Returns:
        FastAPI dependency function
    """
    def role_checker(current_user: User = Depends(get_current_active_user)):
        if current_user.role not in allowed_roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not enough permissions"
            )
        return current_user
    
    return role_checker

# Predefined role dependencies
require_admin = require_role([UserRole.ADMIN, UserRole.DEV_ADMIN])
require_prosumer = require_role([UserRole.PROSUMER])
require_prosumer_or_admin = require_role([UserRole.PROSUMER, UserRole.ADMIN, UserRole.DEV_ADMIN])
require_dev_admin = require_role([UserRole.DEV_ADMIN])

# =====================================
# TOKEN REFRESH FUNCTIONALITY
# =====================================

def refresh_access_token(refresh_token: str, db: Session) -> dict:
    """
    Generate new access token from refresh token
    
    Args:
        refresh_token: Valid refresh token
        db: Database session
        
    Returns:
        dict: New token data
        
    Raises:
        AuthenticationError: If refresh token is invalid
    """
    try:
        token_data = verify_token(refresh_token)
        user = get_user_by_id(db, token_data.user_id)
        
        if not user:
            raise AuthenticationError("User not found")
        
        # Create new access token
        new_token_data = {
            "sub": str(user.id),
            "email": user.email,
            "role": user.role.value,
            "name": user.name
        }
        
        access_token = create_access_token(new_token_data)
        
        return {
            "access_token": access_token,
            "token_type": "bearer",
            "expires_in": ACCESS_TOKEN_EXPIRE_MINUTES * 60
        }
        
    except AuthenticationError:
        raise AuthenticationError("Invalid refresh token")

# =====================================
# UTILITY FUNCTIONS
# =====================================

def is_token_expired(token: str) -> bool:
    """
    Check if token is expired without raising exception
    
    Args:
        token: JWT token string
        
    Returns:
        bool: True if expired, False if valid
    """
    try:
        verify_token(token)
        return False
    except AuthenticationError as e:
        return "expired" in str(e).lower()

def extract_user_id_from_token(token: str) -> Optional[str]:
    """
    Extract user ID from token without verification (for logging/debugging)
    
    Args:
        token: JWT token string
        
    Returns:
        str or None: User ID if extractable, None otherwise
    """
    try:
        # Decode without verification (for debugging only)
        unverified_payload = jwt.decode(token, options={"verify_signature": False})
        return unverified_payload.get("sub")
    except:
        return None

# =====================================
# PASSWORD POLICY VALIDATION
# =====================================

def validate_password_strength(password: str) -> tuple[bool, str]:
    """
    Validate password strength
    
    Args:
        password: Plain text password
        
    Returns:
        tuple: (is_valid, error_message)
    """
    if len(password) < 8:
        return False, "Password must be at least 8 characters long"
    
    if not any(c.isupper() for c in password):
        return False, "Password must contain at least one uppercase letter"
    
    if not any(c.islower() for c in password):
        return False, "Password must contain at least one lowercase letter"
    
    if not any(c.isdigit() for c in password):
        return False, "Password must contain at least one digit"
    
    if not any(c in "!@#$%^&*()_+-=[]{}|;:,.<>?" for c in password):
        return False, "Password must contain at least one special character"
    
    return True, "Password is strong"

# =====================================
# LOGIN ATTEMPT TRACKING (Optional)
# =====================================

class LoginAttemptTracker:
    """Simple in-memory login attempt tracker"""
    
    def __init__(self, max_attempts: int = 5, lockout_time: int = 300):  # 5 minutes
        self.attempts = {}
        self.max_attempts = max_attempts
        self.lockout_time = lockout_time
    
    def is_locked_out(self, email: str) -> bool:
        if email not in self.attempts:
            return False
        
        attempts, last_attempt = self.attempts[email]
        if attempts >= self.max_attempts:
            if datetime.now() - last_attempt < timedelta(seconds=self.lockout_time):
                return True
            else:
                # Reset after lockout period
                del self.attempts[email]
        
        return False
    
    def record_failed_attempt(self, email: str):
        now = datetime.now()
        if email in self.attempts:
            attempts, _ = self.attempts[email]
            self.attempts[email] = (attempts + 1, now)
        else:
            self.attempts[email] = (1, now)
    
    def record_successful_login(self, email: str):
        if email in self.attempts:
            del self.attempts[email]

# Global instance (in production, use Redis or database)
login_tracker = LoginAttemptTracker()

# Example usage in your login endpoint:
"""
@router.post("/login")
async def login(user_credentials: UserLogin, db: Session = Depends(get_db)):
    if login_tracker.is_locked_out(user_credentials.email):
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail="Too many failed login attempts. Please try again later."
        )
    
    user = authenticate_user(db, user_credentials.email, user_credentials.password)
    if not user:
        login_tracker.record_failed_attempt(user_credentials.email)
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password"
        )
    
    login_tracker.record_successful_login(user_credentials.email)
    return create_tokens_for_user(user)
"""