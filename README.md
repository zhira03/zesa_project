# Peer-to-Grid Solar Energy Sharing Platform

## 🎯 Project Objective
To design and implement a prototype system that enables solar energy producers to monitor, record, and share their excess electricity with a peer-to-grid platform. The system will:
- **Simulate** solar production, energy consumption, and grid collection using a **Python Mesa Agent-Based Model**.
- Transmit and store this simulated data in a secure backend.
- Provide dashboards for producers and administrators to visualize simulated production, contributions, and potential payouts.
- Serve as a foundation for a future peer-to-grid electricity marketplace in Zimbabwe.

---

## 🛠 Tools & Technologies
- **Simulation:** Mesa (Python Agent-Based Modeling)
- **Backend:** FastAPI (Python), PostgreSQL
- **Frontend:** Flutter Web/Mobile (Dart)
- **Deployment:** Docker, Azure (Backend), Firebase Hosting (Frontend)
- **Version Control:** Git & GitHub

---

## 💻 Languages & Frameworks
- **Simulation:** Python (Mesa)
- **Backend:** Python (FastAPI)
- **Frontend:** Dart (Flutter)
- **Database:** SQL (PostgreSQL)

---

## 💡 Simulation Model
The core of this project is a **Mesa Agent-Based Model** that simulates the dynamics of a peer-to-grid energy network. The model includes the following agents:

- **Producer Agents:** Simulate households with solar panels. They generate energy based on a simulated solar profile, consume energy, and contribute any excess to the grid.
- **Consumer Agents:** Simulate households without solar panels. They consume energy and purchase it from the simulated grid.
- **Grid Agent:** Manages the central pool of energy, handling contributions from producers and sales to consumers. It calculates energy flows, balances supply and demand, and determines pricing or payouts.

This approach allows for rapid prototyping, testing of different market scenarios, and scaling the simulation without the constraints and costs of physical hardware. 

---

## 📝 Key Changes from Original Plan
- **Data Source:** Switched from **physical IoT hardware (ESP32 + sensors)** to a **Python Mesa Agent-Based Model** for data collection.
- **Equipment:** All physical equipment lists (e.g., ESP32, sensors, batteries, wiring) have been removed as they are no longer required for this simulation-based approach.