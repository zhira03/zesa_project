from datetime import datetime
import hashlib
import os
from typing import List, Dict, Any
import uuid

from pydanticModels import EnergyTransaction

class Block:
    def __init__(self, transList:List[Dict[str, Any]], prevHash:str):
        self.transList = transList
        self.prevHash = prevHash

        self.nonce = 0
        self.blockHash = self.computeHash()

    def computeHash(self) -> str:
        transaction_data = "".join([str(sorted(tx.items())) for tx in self.transList])
        blockData = transaction_data + self.prevHash + str(self.nonce)
        return hashlib.sha256(blockData.encode()).hexdigest()
    
    def mineBlock(self, diff:int):
        target = '0' * diff
        while not self.blockHash.startswith(target):
            self.nonce += 1
            self.blockHash = self.computeHash()

class BlockChain:
    def __init__(self, diff: int = 3):
        genesis_tx = [{
            "transaction_id": "0",
            "tick_id": "genesis",
            "seller_id": "system",
            "buyer_id": "system",
            "kwh_bought": 0,
            "price_per_kwh": 0,
            "total_price": 0,
            "timestamp": datetime.now().isoformat()
        }]
        genesis = Block(genesis_tx, '0')
        genesis.mineBlock(diff)
        self.chain: List[Block] = [genesis]
        self.diff = diff  

    def addBlock(self, transList: List) -> str:
        prevHash = self.chain[-1].blockHash
        newBlock = Block(transList, prevHash)
        newBlock.mineBlock(self.diff)
        self.chain.append(newBlock)
        return newBlock
    
    def is_valid(self) -> bool:
        for block in range(1, len(self.chain)):
            current = self.chain[block]
            previous = self.chain[block - 1]

            if current.blockHash != current.computeHash():
                return False
            
            elif current.prevHash != previous.blockHash:
                return False
            else:
                return True