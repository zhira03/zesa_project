from decimal import Decimal
from typing import Any
from fastapi import HTTPException, status
from sqlalchemy.orm import Session
import models

def _get_or_create_balance(db: Session, user_id):
    bal = db.query(models.Balance).filter(models.Balance.user_id == user_id).first()
    if not bal:
        bal = models.Balance(user_id=user_id, balance_value=Decimal("0.0"), balance_currency="CREDITS")
        db.add(bal)
        db.flush()  # ensure it has an id when we update it
    return bal

# def match_orders(buyers, sellers):
#     for buyer in buyers:
#         for seller in sellers:
#             if seller.energy >= buyer.request:
#                 execute_trade(buyer, seller)
#                 break

def verify_user(token_data: Any, db: Any) -> Any:
    user = db.query(models.User).filter(models.User.usename == token_data.username).first()
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    return user
    