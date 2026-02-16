import httpx
from fastapi import HTTPException, status
from sqlalchemy.orm import Session, joinedload
import models
from sqlalchemy.dialects.postgresql import UUID
import json

def transName(consumerName,prosumerName):
    pass

async def publishEnergy(db: Session):
    # get all enerygData records where is_captured == False
    # push the entries to the chain 
    # for all records, set is_captured == True
    #chain expects: PublishEnergy(assetID,kwh,price)
    #assetID is coming from UserSystem.id, so we need to pull that from the query

    pending_records = (
        db.query(
            models.EnergyData,
            models.FabricIdentity
        )
        .join(models.UserSystem, models.UserSystem.id == models.EnergyData.user_system_id)
        .join(models.User, models.User.id == models.UserSystem.user_id)
        .join(
            models.FabricIdentity,
            models.FabricIdentity.user_id == models.User.id
        )
        .filter(
            models.EnergyData.is_captured == False,
            models.FabricIdentity.status == models.FabricIdentityStatus.ACTIVE
        )
        .all()
    )

    async with httpx.AsyncClient() as client:

        for energy_data, fabric_identity in pending_records:

            try:
                response = await client.post(
                    "http://localhost:4000/fabric/submit",
                    json={
                        "channel": "mychannel",
                        "chaincode": "energy",
                        "function": "PublishEnergy",
                        "args": [
                            str(energy_data.user_system_id),  # UUID → string
                            energy_data.surplus_kwh,
                            0.12
                        ],
                        "identity": fabric_identity.fabric_identity
                    },
                )

                if response.status_code != 200:
                    raise HTTPException(
                        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                        detail=f"Power Publication failed: {response.text}"
                    )

                energy_data.is_captured = True

            except Exception as e:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail=f"Chain Energy Publish failed: {str(e)}"
                )

        db.commit()

async def getEnergy(user_fab:str):
    try:
        async with httpx.AsyncClient() as client:
            allAvailPower = await client.post(
                "http://localhost:4000/fabric/query",
                json={
                    "channel": "mychannel",
                    "chaincode": "energy",
                    "function": "GetAllAvailableEnergy",
                    "identity": user_fab
                },
            )
            if allAvailPower.status_code != 200:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail=f"Get Available Power from Chain failed: {allAvailPower.text}"
                )
            payload = allAvailPower.json()
            return payload

    except httpx.HTTPException as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Connection to Chain failed here: {str(e)}"
        )
    except HTTPException:
        # Re-raise HTTPException as-is
        raise
    except Exception as e:
        # Catch any other errors
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Unexpected error: {str(e)}"
        )
            
#chain needs: txID string, consumerID string, assetID string, kwhRequested float64
#consumerID = user_id, assetID = user_system_id
async def initiate_transaction(user_fab:str, transID:str, consumerID:str,assetID:str,kwhRequested:float):
    payload = ''
    try:
        async with httpx.AsyncClient() as client:
            transaction = await client.post(
                "http://localhost:4000/fabric/initiateTransaction",
                json={
                    "channel": "mychannel",
                    "chaincode": "energy",
                    "function": "InitiateTransaction",
                    "args":[transID,consumerID,assetID,kwhRequested],
                    "identity": user_fab
                },
            )
            if transaction.status_code != 200:
                payload = transaction.text
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail=f"Start Transaction failed: {payload}"
                )
            else:
                payload = transaction.json()
            return payload

    except httpx.HTTPException as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Connection to Chain failed here: {str(e)}"
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Unexpected error: {str(e)}"
        )