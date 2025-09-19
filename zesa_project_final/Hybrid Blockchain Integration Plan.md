# Hybrid Blockchain Integration Plan

**Goal:** Build a hybrid (centralized + distributed) ledger for the solar energy sharing platform. The server acts as the primary/full node (authoritative chain + full data). Mobile apps act as light clients (store recent headers, validate transactions via SPV / Merkle proofs, and vote). The trading engine remains the trade matcher; after DB commit the server publishes each trade tick as a block or header.

---

## 1. High-level architecture

* **Primary server (Full Node / Authority)**

  * Stores full blockchain (blocks + transactions) and full SQL DB.
  * Performs heavy work: mining (PoW) *or* signing (PoA).
  * Proposes block headers to mobile clients, collects votes or acks.
  * Acts as the authoritative finalizer for blocks (hybrid trust model).

* **Mobile clients (Light / SPV clients)**

  * Store only the most recent `N` block headers (default `N = 5`).
  * Verify headers and transaction inclusion using Merkle proofs.
  * Validate & vote by signing headers (or sending an ack).
  * Request full block data only when needed (e.g., dispute or proof verification).

* **Optional secondary validators**

  * Additional server-side validators (PoA multisig) for higher auditability.

---

## 2. Data models & primitives

### BlockHeader (minimal fields)

```json
{
  "prev_hash": "...",
  "merkle_root": "...",
  "timestamp": 169...,
  "nonce": 12345,
  "difficulty": 3,
  "miner_id": "primary-server",
}
```

* `header_hash` = sha256(canonical\_json(header\_fields))
* Small and cheap to store on mobile devices.

### Block

* `header` (BlockHeader)
* `transactions` (full list)
* `block_hash` = header\_hash (canonical)

### Transaction record (block-level)

* Keep identical transaction fields to your SQL `Transaction` model for easy mapping:

  * `id`, `from_user_id`, `to_user_id`, `kwh`, `price_per_kwh`, `total_amount`, `timestamp`, `tick_id`
* On the blockchain side we store a canonical serialized form and hash it for Merkle tree leaves.

### Merkle Tree

* `leaf` = sha256(serialized\_transaction)
* `merkle_root` computed by pairing & hashing up the tree. If a layer has an odd number, duplicate the last leaf.
* Provide `make_merkle_proof(tx_index)` and `verify_merkle_proof(leaf_hash, proof, root)` utilities.

---

## 3. Integration points with `run_trading_tick`

At the end of the successful DB `commit()` inside `run_trading_tick`:

1. Build canonical transaction objects (`transactions_out`) exactly as committed.
2. Serialize each transaction deterministically (sorted keys + stable formatting) and compute `tx_hashes`.
3. Compute `merkle_root = merkle_root(tx_hashes)`.
4. Build `header = BlockHeader(prev_hash=server_chain[-1].block_hash, merkle_root=root, timestamp=now, difficulty=DIFFICULTY, miner_id=server_id)`.
5. Option A: `mine_header(header)` for PoW (if you want PoW).
   Option B (recommended for hybrid): `sign_header(header)` using server private key (Proof-of-Authority).
6. Form `block = Block(header, transactions_out)` and append to server chain.
7. Persist block metadata to DB (block reference table) and store full block on full node storage.
8. Broadcast header to mobile clients & validators and collect votes (signed acknowledgements).
9. Mark the block as `finalized` depending on policy (immediate or after threshold signatures).
10. Return API response including `block_hash`, `header_hash`, and `merkle_root` for audit links.

**Important:** If DB `commit()` fails, do NOT create a blockchain block. Database is the source-of-record for operational state and must remain in sync.

---

## 4. FastAPI endpoints to implement

### Server / Full Node endpoints

1. `POST /blocks/propose/` - (internal) propose a header (server-only).
2. `GET  /blocks/latest-headers/?n=5` - returns last `n` block headers (for light-client sync).
3. `GET  /blocks/{block_hash}/merkle-proof/?tx_hash=...` - return Merkle proof for a transaction hash inside the block.
4. `GET  /blocks/{block_hash}` - return full block (header + transactions) — restricted endpoint.
5. `POST /blocks/{header_hash}/vote/` - mobile client posts signed ack/vote for header.
6. `GET  /blocks/{block_hash}/status/` - block finalization & vote counts (for audit).

### Mobile client endpoints (light client requests)

1. `GET /blocks/latest-headers/?n=5` — fetch headers.
2. `GET /blocks/{block_hash}/merkle-proof/?tx_id=...` — request proof for a specific tx.
3. `POST /blocks/{header_hash}/vote/` — send signed ack (client->server).

---

## 5. Client flow (SPV / Light client)

* On app start / resume: fetch last `N` headers from server and store them securely.
* When the app creates a transaction (or user wants to check inclusion):

  1. Submit trade request (normal / unchanged flow) — server writes to DB & returns `transaction_id`.
  2. When `run_trading_tick` includes transaction and block is proposed, the mobile client will receive (or poll) the new header.
  3. Client can request a Merkle proof for its tx; verify proof against the header's `merkle_root`.
  4. If verified, sign the header (or send ack) to server to contribute to votes/audit.

**Voting**

* Client signs header bytes with local private key and posts signature.
* Server stores signature as audit evidence.

---

## 6. Consensus & finality strategies (tradeoffs)

1. **Server-authoritative (fastest, simplest)**

   * Server mines/signs and finalizes immediately.
   * Clients only provide optional audit signatures.
   * Trade-offs: centralization risk (server can censor), but high throughput.

2. **Threshold-based finality**

   * Server waits for `k` client signatures before marking block `final`.
   * Trade-offs: more trust distribution, but slower & fragile if many clients offline.

3. **Validator-set PoA**

   * Use a small set of trusted validator servers (multisig PoA). Blocks require `m-of-n` signatures.
   * Good compromise: low resource usage, stronger decentralization than single server.

Recommendation: start with **Server-authoritative + client vote collection for auditing**, then later migrate to PoA validator set if you need stronger distribution of trust.

---

## 7. Security & operational considerations

* **Key management (mobile):** Use platform keystore / secure enclave. Provide key recovery options and device revocation.
* **Merkle proof availability:** Full node must keep transactions long enough to provide proofs. Archive older blocks or keep index for fast proof generation.
* **Replay protection:** Include `tick_id` / server nonce / timestamp in transaction canonicalization to avoid replays.
* **Privacy:** Consider redacting PII or storing only hashes of sensitive fields on-chain. Alternatively, encrypt sensitive payload and store ciphertext in block.
* **DoS & spam:** Keep `MIN_TRADE_KWH` filter and additional rate-limiting. Reject extremely small trades early.
* **Fork & re-org handling:** Have server implement chain replacement logic (longest valid chain or highest autority signatures). Clients should request missing headers if `prev_hash` mismatch.
* **Auditability:** Expose endpoint to fetch all signatures / votes for a block for auditors.

---

## 8. Testing plan

1. **Unit tests** for:

   * Merkle root creation & verification.
   * Header canonicalization & hashing.
   * Mining / signing functions.
   * DB/block sync logic (failures & rollbacks).

2. **Integration tests** (simulated network):

   * Run server + multiple simulated light-clients.
   * Propose blocks, collect votes, verify finalization.
   * Tamper test: modify a committed block in server storage and confirm clients reject on verification.

3. **Load testing**

   * Simulate frequent trade ticks and validate mining/signing throughput.
   * Measure latency for clients to receive header & verify proofs.

4. **Security tests**

   * Key compromise scenarios, replay attack simulation, DoS attempts, archive/merkle proof availability tests.

---

## 9. Deployment & rollout

* Start with server in a single authoritative mode (PoA signed headers).
* Deploy endpoint for `latest-headers` + `merkle-proof` + `vote`.
* Release light-client update that stores `N=5` headers and performs SPV checks for own transactions.
* Collect client votes for the first N blocks to build audit trail.
* Monitor metrics: number of client votes, proof request latency, block finalization times.

---

## 10. Milestones & prioritized TODOs

**MVP (Weeks 1-3)**

1. Add merkle utils + header & block model to codebase.
2. Extend `run_trading_tick` to compute merkle\_root after DB commit and create header (PoA sign).
3. Implement `/blocks/latest-headers/` and `/blocks/{block_hash}/merkle-proof/` endpoints.
4. Simple mobile SPV pseudo-client script that fetches headers, requests proof, verifies proof, and posts vote.

**Phase 2 (Weeks 3-6)**

1. Add vote collection & storage for auditability.
2. Implement personal keypair generation & keystore usage on mobile.
3. Add optional `GET /blocks/{block_hash}` restricted endpoint for full block retrieval.
4. Integration & load testing.

**Phase 3 (Weeks 6-12)**

1. Introduce PoA validator set or threshold-based finality if needed.
2. Harden key management, add revocation & recovery workflows.
3. Production roll-out & monitoring dashboards.

---

## 11. Appendix: canonical transaction serialization (example)

Use a deterministic serialization for each transaction when hashing. Example Python canonical serializer:

```python
import json

def canonical_tx(tx: dict) -> bytes:
    # Ensure keys are sorted to maintain deterministic order
    return json.dumps(tx, sort_keys=True, separators=(",", ":")).encode()
```

When computing `tx_hash` do `sha256(canonical_tx(tx))`.

---

## 12. Next steps (pick one)

* I can implement the FastAPI endpoints (latest-headers, merkle-proof, vote) and the header creation in `run_trading_tick`.
* OR I can implement the mobile SPV client pseudo-code (Flutter-friendly) to store headers and request proofs.
* OR I can write unit & integration test skeletons for the merkle & header logic.

Choose which one you want me to implement next and I will start coding.