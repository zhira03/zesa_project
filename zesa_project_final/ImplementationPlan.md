# 🔋 Energy Trading Platform Implementation Plan
- **Simulation → Backend → Trading Engine (Detailed)**

---

## 📋 Step 0 — Assumptions / High-level Decisions

### 🛠️ Tech Stack (Recommended)
- **Backend & Simulation**: Python + FastAPI
- **Database**: PostgreSQL 
- **ORM/Migrations**: SQLAlchemy + Alembic
- **Development**: Docker / docker-compose
- **Communication**: REST-based ingestion (backend ↔ simulation via GET/POST)
  - *Future upgrade*: MQTT or message queues
- **Authentication**: JWT (RS256)

### ⏱️ Time Resolution
Choose a consistent **tick** for simulation & matching:
- Options: 5-minute or 15-minute ticks
- ⚠️ **Critical**: All components must use the same tick

---

## 🎯 Step 1 — Simulation Microservice

> **Goal**: Produce per-user time-series data: `generation_kWh`, `consumption_kWh`, `surplus_kWh` at each timestamp

### 🚀 Deliverables

#### API Endpoints
- `GET /simulate-data?user_id=<id>&tick=<timestamp>` → Single reading
- `GET /simulate-batch?start=<>&end=<>&users=[..]` → Array for replay/testing  
- `POST /simulate-stream` → Continuous stream *(optional, for later)*

#### 📄 Output JSON Schema
```json
{
  "user_id": 123,
  "timestamp": "2025-09-09T14:30:00Z",
  "generation_kwh": 4.5,
  "consumption_kwh": 3.2,
  "surplus_kwh": 1.3,
  "meta": {
    "panel_w": 350,
    "panel_count": 12,
    "battery_kwh": 10.0,
    "inverter_kw": 3.0
  }
}
```

### ✅ Acceptance Criteria
- [ ] Deterministic batch files for reproducible tests
- [ ] Per-tick output for N users (scalable from 1 to test size)

---

## 🏗️ Step 2 — Backend: User Management + Energy Ingestion API

> **Goal**: Build API for user registration, system metadata storage, and simulation data ingestion

### 🗄️ Key Database Tables

#### Core Tables
| Table | Fields |
|-------|--------|
| **users** | `id, name, email, role (prosumer/consumer/admin), public_key?` |
| **user_systems** | `user_id, panel_w, panel_count, battery_kwh, inverter_kw, system_type, installed_date` |
| **energy_data** | `id, user_id, timestamp, generation_kwh, consumption_kwh, surplus_kwh, source (sim/live)` |
| **balances** | `user_id, balance_currency, balance_value` |
| **transactions** | `id, from_user, to_user, timestamp, kwh, price_per_kwh, total_amount, trade_tick_id` |
| **trade_tick** | `id, tick_timestamp, status` *(optional, groups transactions per tick)* |

### 🔌 Core APIs

#### Authentication
- `POST /auth/login` → JWT RS256
- `POST /auth/register`

#### User Management
- `GET /users/{id}`
- `POST /users/` → Store system metadata
- `PATCH /users/{id}`

#### Energy Data Ingestion
- `POST /energy-data` → Single reading
- `POST /energy-data/batch` → Bulk ingestion

#### Admin & Analytics
- `GET /trade-tick/{tick}`
- `GET /transactions?user_id=...`
- `GET /balances/{user_id}`

### 🔧 Design Notes
- **Idempotency**: Unique constraint on `(user_id, timestamp)`
- **Atomicity**: Use DB transactions for writes
- **Audit Trail**: Store data source (simulator) for replay

### ✅ Acceptance Criteria
- [ ] User registration + system metadata capture
- [ ] Reliable simulator payload persistence

---

## ⚡ Step 3 — Trading Engine (Core)

> **Goal**: Per tick → read energy data → match sellers/buyers → create transactions → update balances

### 🎯 Core Responsibilities

1. **Aggregate** per-user state (respect inverter caps, battery policies)
2. **Classify** users:
   - **Sellers**: `surplus_kWh > threshold`
   - **Buyers**: `surplus_kWh < -threshold` or `consumption > generation`
3. **Match** sellers → buyers using algorithms
4. **Settle** transactions and update balances atomically

### 🧮 Matching Algorithms

#### 1. **Simple Greedy** *(Start Here - Easiest)*
- Sort sellers by surplus (descending)
- Sort buyers by deficit (descending) 
- Allocate seller surplus to top buyers until exhausted
- **Price**: Fixed platform rate or seller-set

#### 2. **Proportional Sharing**
- Distribute seller surplus proportionally to buyer deficits

#### 3. **Price-Priority Matching**
- Sellers post minimum price, buyers maximum price
- Sort by price-time priority

#### 4. **Auction/Market Clearing** *(Advanced)*
- Compute market-clearing price where supply meets demand

### 💡 Implementation Details
- Support **partial fills**
- Enforce **minimum transaction unit** (e.g., 0.01 kWh)
- Respect **inverter export limit**: `inverter_kw × tick_length_hours`

### 🔄 Pseudocode (Greedy Algorithm)
```python
def run_matching(tick_timestamp):
    rows = db.query_energy_data(tick_timestamp)
    sellers = [(u.id, u.surplus) for u in rows if u.surplus > threshold]
    buyers = [(u.id, -u.surplus) for u in rows if u.surplus < -threshold]
    
    sellers.sort(key=lambda s: s[1], reverse=True)
    buyers.sort(key=lambda b: b[1], reverse=True)
    
    transactions = []
    for s_id, s_amt in sellers:
        remaining = s_amt
        for i, (b_id, b_need) in enumerate(buyers):
            if b_need <= 0: continue
            traded = min(remaining, b_need)
            price = P_BASE
            transactions.append({
                'from': s_id, 
                'to': b_id, 
                'kwh': traded, 
                'price': price
            })
            remaining -= traded
            buyers[i] = (b_id, b_need - traded)
            if remaining <= 0: break
    
    # Persist transactions and update balances in DB transaction
```

### 💰 Settlement & Balances
For each transaction:
- `seller.balance += traded_kwh * price`
- `buyer.balance -= traded_kwh * price`

Use **DB transactions** for atomic writes with rollback on failure.

### ✅ Acceptance Criteria
- [ ] Correct transaction generation preserving energy balance
- [ ] Atomic balance updates

---

## 📐 Step 4 — Business Rules & Power Constraints

### 🔒 Physical Constraints
- **Inverter/Export Limit**: Seller max = `inverter_capacity × tick_hours`
- **Battery Behavior** *(optional)*: Model charge/discharge strategy
- **Minimum Trade Quantum**: Rounding rules
- **Network Constraints** *(optional)*: Local microgrid restrictions

### 💸 Economic Constraints  
- **Transaction Fees**: Platform or grid operator fees
- **Price Bounds**: Min/max price limits

---

## 🕐 Step 5 — Scheduler & Orchestration

### 🔄 Implementation Approaches

#### **Pull Approach** *(Simple)*
Backend scheduler calls `GET /simulate-data/batch?tick=...`

#### **Push Approach** *(Robust)*
Simulator posts to `POST /energy-data`, backend triggers on tick completion

### 🛠️ Tools
- **Initial**: APScheduler or FastAPI background tasks
- **Scale**: Celery + Redis/RabbitMQ

### ✅ Acceptance Criteria
- [ ] Deterministic per-tick matching jobs
- [ ] Results logged in `trade_tick` table

---

## 📊 Step 6 — API for Results & Debugging

### 🔍 Analytics Endpoints
- `GET /trade-tick/{tick}` → Matching summary
- `GET /user/{id}/transactions?from=&to=` → Historical trades
- `GET /balances/{id}` → Current balance
- `GET /energy-data?user_id=&start=&end=` → Replay/analysis data

*These endpoints feed dashboards and experiment analysis*

---

## 🧪 Step 7 — Data Model for Simulation Experiments

### 📈 Experiment Tracking
- **Table**: `simulation_run(id, name, seed, created_at)`
- **Tagging**: All `energy_data`/`transactions` tagged with `simulation_run_id`
- **Export**: `export_csv(run_id, table)` and summary statistics

*Enables reproducible experiment comparison*

---

## 🔐 Step 8 — Security, Privacy & Governance (MVP)

### 🛡️ Security Measures
| Component | Implementation |
|-----------|----------------|
| **Authentication** | JWT RS256 for protected endpoints |
| **Transport** | HTTPS (TLS) |
| **Data Protection** | Store minimal fields, anonymize publications |
| **Audit Logs** | Append-only transactions + `trade_tick` tables |
| **Access Control** | Role-based admin endpoint guards |
| **Record Integrity** | Optional server private key signing |

---

## 🧪 Step 9 — Testing & Validation

### 🔬 Test Categories

#### **Unit Tests**
- Matching algorithm logic
- Database write/rollback scenarios

#### **Integration Tests** 
- Full pipeline: simulate → ingest → match → settle
- Use deterministic simulation seeds

#### **Reproducibility Tests**
- Replay identical datasets → confirm identical transactions

#### **Load Tests**
- Many users/ticks performance (Locust or custom scripts)

#### **Edge Cases**
- Partial fills, zero supply, duplicate timestamps, duplicate ingestion

---

## 📈 Step 10 — Observability & DevOps

### 📊 Monitoring Stack
- **Logging**: Structured logs (ingestion, matching, errors)
- **Metrics**: Transaction counts, latency *(Prometheus + Grafana later)*
- **Deployment**: Docker + docker-compose (local dev)
- **Migrations**: Alembic for schema changes
- **CI/CD**: Linting, unit tests, integration tests

---

## 🚀 Research Features (Future Priorities)

### 🎯 Advanced Features
1. **Dynamic Pricing/Auction Markets** → Research experiments
2. **Privacy-Preserving Analytics** → Differential privacy, aggregation
3. **Immutable Ledger** → Append-only or lightweight blockchain
4. **Payment Integration** → Mobile money, KYC/regulatory compliance  
5. **Machine Learning** → Demand prediction & optimized matching

*Collaborate with ML lecturer co-supervisor on predictive models*

---

## ✅ Implementation Checklist

### 🎯 Concrete Tasks

- [ ] **Finalize tick resolution** and JSON schema
- [ ] **Build simulator endpoints** (batch/streaming)
- [ ] **Backend skeleton**: auth, users, systems, ingestion
- [ ] **Database models** + Alembic migrations  
- [ ] **Ingestion idempotency** and persistence
- [ ] **Simple greedy trading engine** as background job
- [ ] **Transaction/balance logic** with atomic DB operations
- [ ] **Result APIs**: trades, balances, energy history
- [ ] **Automated testing** (unit + integration with deterministic sim)
- [ ] **Docker services** + end-to-end local testing
- [ ] **Logging/metrics** + load testing
- [ ] **Algorithm refinement**: battery behavior, pricing models

---

## 📋 Quick Reference Examples

### 📤 Sample POST `/energy-data` (Bulk)
```json
[
  {
    "user_id": 1,
    "timestamp": "2025-09-09T14:30:00Z",
    "generation_kwh": 1.2,
    "consumption_kwh": 0.8,
    "surplus_kwh": 0.4
  },
  {
    "user_id": 2,
    "timestamp": "2025-09-09T14:30:00Z", 
    "generation_kwh": 0.0,
    "consumption_kwh": 1.5,
    "surplus_kwh": -1.5
  }
]
```

### 💳 Transaction Row Example
```json
{
  "id": 143,
  "from_user": 1,
  "to_user": 2,
  "timestamp": "2025-09-09T14:30:00Z",
  "kwh": 0.4,
  "price_per_kwh": 0.1,
  "total_amount": 0.04,
  "tick_id": 67
}
```

---

## 🎯 Success Metrics

- **Functional**: All endpoints working with proper error handling
- **Performance**: Sub-second matching for 100+ users per tick
- **Reliability**: Zero data loss, atomic transaction processing  
- **Scalability**: Easy horizontal scaling preparation
- **Research Ready**: Clean data exports for thesis analysis

---

*📄 Document Version: 1.0 | Last Updated: September 2025*