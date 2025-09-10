from decimal import Decimal
from sqlalchemy.orm import Session
import models

def _get_or_create_balance(db: Session, user_id):
    bal = db.query(models.Balance).filter(models.Balance.user_id == user_id).first()
    if not bal:
        bal = models.Balance(user_id=user_id, balance_value=Decimal("0.0"), balance_currency="CREDITS")
        db.add(bal)
        db.flush()  # ensure it has an id when we update it
    return bal