# Peer-to-Grid Solar Energy Sharing Platform

## 🎯 Project Objective
To design and implement a prototype system that enables solar energy producers to monitor, record, and share their excess electricity with a peer-to-grid platform. The system will:
- Collect real-time solar generation data using IoT hardware (ESP32 + sensors).
- Transmit and store this data in a secure backend.
- Provide dashboards for producers and administrators to visualize production, contributions, and potential payouts.
- Serve as a foundation for a future peer-to-grid electricity marketplace in Zimbabwe.

---

## 🛠 Tools & Technologies
- **Backend:** FastAPI (Python), PostgreSQL
- **Frontend:** Flutter Web/Mobile (Dart)
- **Deployment:** Docker, Azure (Backend), Firebase Hosting (Frontend)
- **Version Control:** Git & GitHub

---

## 🔌 Equipment
- **ESP32** (microcontroller with WiFi)
- **Current Sensor:** ACS712 (DC current measurement)
- **Voltage Sensor:** ZMPT101B (AC voltage measurement)
- **Optional Energy Meter IC:** ADE7753 (for advanced metering)
- Breadboard, jumper wires, power supply, optional OLED display

---

## 💻 Languages & Frameworks
- **Microcontroller Firmware:** MicroPython (or Arduino C++)
- **Backend:** Python (FastAPI)
- **Frontend:** Dart (Flutter)
- **Database:** SQL (PostgreSQL)

# ZESA Project: Physical Equipment List
## This list outlines the physical equipment required to measure real power in a small, off-grid solar setup.

### Bare-minimum for Real Power Measurement (No Grid Tie)
- Battery-Backed Solar Kit (Small)
- **Solar Panel**: A small panel (50–200W is sufficient for testing).
- **Charge Controller**: A PWM controller is fine, but an MPPT is more efficient.
- **12V Battery**: An AGM or LiFePO₄ battery with a capacity of 7–20Ah is enough for lab tests.

## Measurement Points
- DC-Side Metering (simpler and safer)
- Hall-effect DC current sensor (e.g., ACS758, INA219 for current and voltage).
- Voltage divider for scaling the battery or solar array voltage to the ADC range of your microcontroller.
- AC-Side Metering (if you need AC metrics after an inverter)
- Split-core CT clamp for non-invasive current measurement.
- PZEM-004T (a cheap AC energy meter module with UART communication).
- DIN-rail kWh meter with an S0 pulse output for clean pulse counting.

## Inverter (for AC Tests)
- A small pure sine wave inverter (300–1,000W).

## Safety & Accessories
Inline Fuse/DC Breaker: Place fuses between the solar panel and the charge controller, and between the controller and the battery.

## Connectors & Wire: MC4 connectors, DC wire, and ring or fork terminals.

## Multimeter: 
- An essential tool. An AC clamp meter is a useful extra.

## Enclosure: 
- An ABS enclosure is recommended for housing your electronics, providing strain relief and standoffs.

## Electronics: 
- A breadboard, jumper wires, and a 5V voltage regulator for your ESP32 (or other microcontroller).

## Surge Protection: 
- TVS diodes or other surge protectors are a good safety measure to include.

