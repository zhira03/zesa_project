import mesa
import numpy as np
import math
from mesa.datacollection import DataCollector
from datetime import datetime, timedelta
import random

class SolarProducerAgent2(mesa.Agent):
    def __init__(self, model, user_id, panel_wattage, panel_count, household_size, cluster_id, 
                 battery_capacity=0, battery_count=0, inverter_capacity=0, location="harare"):
        super().__init__(model)
        self.user_id = user_id
        self.panel_wattage = panel_wattage
        self.panel_count = panel_count
        self.household_size = household_size
        self.cluster_id = cluster_id
        self.location = location

        # Battery specs from backend
        self.battery_capacity_kwh = battery_capacity  # Single battery capacity in kWh
        self.battery_count = battery_count
        self.total_battery_capacity = self.battery_capacity_kwh * self.battery_count
        self.battery_soc = 0.5  # Start at 50% state of charge
        self.battery_min_soc = 0.2  # Don't discharge below 20%
        self.battery_max_soc = 0.95  # Don't charge above 95%
        self.battery_charge_efficiency = 0.95  # Charging efficiency
        self.battery_discharge_efficiency = 0.95  # Discharging efficiency
        self.battery_max_charge_rate = self.total_battery_capacity * 0.5  # 0.5C charge rate (kW)
        self.battery_max_discharge_rate = self.total_battery_capacity * 0.5  # 0.5C discharge rate (kW)

        # Inverter specs from backend
        self.inverter_capacity_kw = inverter_capacity  # Maximum inverter capacity in kW
        self.inverter_efficiency = 0.96  # Modern inverter efficiency

        # Panel specs
        self.panel_area_m2 = 2.0
        self.panel_efficiency = 0.20
        self.temperature_coefficient = -0.004
        self.wiring_losses = 0.97
        self.soiling_factor = 0.95

        # State variables
        self.generation_kwh = 0  # Raw solar generation
        self.usable_generation_kwh = 0  # After inverter limiting
        self.consumption_kwh = 0
        self.surplus_kwh = 0  # Net after consumption
        self.battery_charged_kwh = 0  # Energy stored in battery this step
        self.battery_discharged_kwh = 0  # Energy drawn from battery this step
        self.grid_export_kwh = 0  # Excess energy exported to grid
        self.grid_import_kwh = 0  # Energy imported from grid
        self.inverter_clipped_kwh = 0  # Energy lost due to inverter capacity limit

        # Weather (to be updated externally from DB/API)
        self.weather_temp = 25  # Default temperature
        self.weather_humidity = 60  # Default humidity
        self.weather_clouds = 20  # Default cloud cover

        # Daily household load shape (24 hours, relative multipliers)
        self.consumption_pattern = [
            0.3, 0.2, 0.2, 0.2, 0.3, 0.5,  # 00:00-05:00 (night, low usage)
            0.8, 1.2, 1.0, 0.8, 0.6, 0.6,  # 06:00-11:00 (morning peak)
            0.7, 0.7, 0.6, 0.8, 1.0, 1.5,  # 12:00-17:00 (afternoon)
            2.0, 1.8, 1.5, 1.2, 0.8, 0.5   # 18:00-23:00 (evening peak)
        ]

    def update_weather(self, weather):
        """Inject real weather data from backend (dict with temp, humidity, clouds)"""
        if weather:
            self.weather_temp = weather.get("temperature", self.weather_temp)
            self.weather_humidity = weather.get("humidity", self.weather_humidity)
            self.weather_clouds = weather.get("clouds", self.weather_clouds)

    def step(self):
        """Main simulation step - calculates generation, consumption, and energy flows"""
        hour = self.model.current_hour
        day_of_year = self.model.day_of_year

        # Reset step variables
        self.battery_charged_kwh = 0
        self.battery_discharged_kwh = 0
        self.grid_export_kwh = 0
        self.grid_import_kwh = 0
        self.inverter_clipped_kwh = 0

        # Calculate raw solar generation
        self.generation_kwh = self.calculate_generation(hour, day_of_year)
        
        # Apply inverter capacity limit
        self.usable_generation_kwh = self.apply_inverter_limit(self.generation_kwh)
        
        # Calculate household consumption
        self.consumption_kwh = self.calculate_consumption(hour)
        
        # Handle energy flows (battery charging/discharging, grid import/export)
        self.manage_energy_flows()

    def calculate_generation(self, hour, day_of_year):
        """Calculate solar generation based on time, season, and weather"""
        # No generation at night
        if hour < 6 or hour > 18:
            return 0

        # Base irradiance (Zimbabwe average daily kWh/m²)
        seasonal_factor = 1 + 0.2 * math.cos(2 * math.pi * (day_of_year - 355) / 365)
        base_irradiance = 7.2 * seasonal_factor

        # Daily curve (sine wave from 6 AM to 6 PM)
        daily_factor = math.sin(math.pi * (hour - 6) / 12)

        # Adjust irradiance with cloud cover
        cloud_factor = (1 - (self.weather_clouds / 100) * 0.75)  # Clouds reduce by up to 75%
        irradiance = base_irradiance * daily_factor * cloud_factor / 24  # Convert to hourly

        # Panel area
        total_panel_area = self.panel_count * self.panel_area_m2
        theoretical_power = irradiance * total_panel_area * self.panel_efficiency

        # Temperature effect (panels lose efficiency when hot)
        current_temp = self.weather_temp
        temp_loss = max(0, current_temp - 25) * self.temperature_coefficient
        temp_factor = 1 + temp_loss

        # Apply all losses
        actual_power = (theoretical_power *
                        temp_factor *
                        self.wiring_losses *
                        self.soiling_factor)

        return max(0, actual_power)

    def apply_inverter_limit(self, generation_kwh):
        """Limit generation based on inverter capacity"""
        if self.inverter_capacity_kw == 0:
            # No inverter limit specified, use generation as-is with default efficiency
            return generation_kwh * self.inverter_efficiency
        
        # Check if generation exceeds inverter capacity
        if generation_kwh > self.inverter_capacity_kw:
            self.inverter_clipped_kwh = generation_kwh - self.inverter_capacity_kw
            usable = self.inverter_capacity_kw
        else:
            usable = generation_kwh
        
        # Apply inverter efficiency
        return usable * self.inverter_efficiency

    def calculate_consumption(self, hour):
        """Calculate household consumption based on hour and household size"""
        base_consumption_per_person_per_hour = 0.4 / 24  # 400 Wh per person per day
        hourly_multiplier = self.consumption_pattern[hour]
        variation = random.uniform(0.8, 1.2)  # Add some randomness
        return self.household_size * base_consumption_per_person_per_hour * hourly_multiplier * variation

    def manage_energy_flows(self):
        """Manage battery charging/discharging and grid import/export"""
        # Net energy after consumption
        net_energy = self.usable_generation_kwh - self.consumption_kwh
        
        if net_energy > 0:
            # Surplus energy - try to charge battery first
            if self.total_battery_capacity > 0:
                self.charge_battery(net_energy)
                remaining_surplus = net_energy - self.battery_charged_kwh
                self.grid_export_kwh = max(0, remaining_surplus)
            else:
                # No battery, export all surplus
                self.grid_export_kwh = net_energy
        else:
            # Energy deficit - try to discharge battery first
            deficit = abs(net_energy)
            if self.total_battery_capacity > 0:
                self.discharge_battery(deficit)
                remaining_deficit = deficit - self.battery_discharged_kwh
                self.grid_import_kwh = max(0, remaining_deficit)
            else:
                # No battery, import all deficit
                self.grid_import_kwh = deficit
        
        # Calculate final surplus (can be negative if importing from grid)
        self.surplus_kwh = (self.usable_generation_kwh + self.battery_discharged_kwh - 
                           self.consumption_kwh - self.battery_charged_kwh)

    def charge_battery(self, available_energy):
        """Charge battery with available surplus energy"""
        if self.total_battery_capacity == 0:
            return
        
        # Calculate available battery capacity
        current_energy = self.battery_soc * self.total_battery_capacity
        max_energy = self.battery_max_soc * self.total_battery_capacity
        available_capacity = max_energy - current_energy
        
        # Limit by charge rate, available energy, and available capacity
        charge_amount = min(
            available_energy,
            self.battery_max_charge_rate,
            available_capacity / self.battery_charge_efficiency  # Account for efficiency
        )
        
        # Apply charging
        energy_stored = charge_amount * self.battery_charge_efficiency
        self.battery_soc += energy_stored / self.total_battery_capacity
        self.battery_charged_kwh = charge_amount
        
        # Ensure SOC doesn't exceed max
        self.battery_soc = min(self.battery_soc, self.battery_max_soc)

    def discharge_battery(self, required_energy):
        """Discharge battery to meet energy deficit"""
        if self.total_battery_capacity == 0:
            return
        
        # Calculate available battery energy
        current_energy = self.battery_soc * self.total_battery_capacity
        min_energy = self.battery_min_soc * self.total_battery_capacity
        available_energy = current_energy - min_energy
        
        # Limit by discharge rate, required energy, and available energy
        discharge_amount = min(
            required_energy / self.battery_discharge_efficiency,  # Account for efficiency
            self.battery_max_discharge_rate,
            available_energy
        )
        
        # Apply discharging
        self.battery_soc -= discharge_amount / self.total_battery_capacity
        self.battery_discharged_kwh = discharge_amount * self.battery_discharge_efficiency
        
        # Ensure SOC doesn't go below min
        self.battery_soc = max(self.battery_soc, self.battery_min_soc)


class SolarGenerationModel2(mesa.Model):
    def __init__(self, user_data_list, weather_lookup, start_day=1, simulation_hours=24):
        """
        user_data_list: list of dicts with user_id, panel_wattage, panel_count, household_size, 
                        cluster_id, battery_capacity, battery_count, inverter_capacity
        weather_lookup: dict mapping cluster_id -> {"temperature":..,"humidity":..,"clouds":..}
        """
        super().__init__()
        self.num_agents = len(user_data_list)
        self.current_hour = 6  # start sim at 6 AM
        self.day_of_year = start_day
        self.simulation_hours = simulation_hours
        self.step_count = 0
        self.weather_lookup = weather_lookup

        # Create agents
        for i, user_data in enumerate(user_data_list):
            agent = SolarProducerAgent2(
                model=self,
                user_id=user_data['user_id'],
                panel_wattage=user_data['panel_wattage'],
                panel_count=user_data['panel_count'],
                household_size=user_data['household_size'],
                cluster_id=user_data['cluster_id'],
                battery_capacity=user_data.get('battery_capacity', 0),
                battery_count=user_data.get('battery_count', 0),
                inverter_capacity=user_data.get('inverter_capacity', 0),
                location=user_data.get('location', 'harare')
            )

        # Data collector
        self.datacollector = DataCollector(
            model_reporters={
                "Total_Generation": lambda m: sum([a.generation_kwh for a in m.agents]),
                "Total_Usable_Generation": lambda m: sum([a.usable_generation_kwh for a in m.agents]),
                "Total_Consumption": lambda m: sum([a.consumption_kwh for a in m.agents]),
                "Total_Battery_Charged": lambda m: sum([a.battery_charged_kwh for a in m.agents]),
                "Total_Battery_Discharged": lambda m: sum([a.battery_discharged_kwh for a in m.agents]),
                "Total_Grid_Export": lambda m: sum([a.grid_export_kwh for a in m.agents]),
                "Total_Grid_Import": lambda m: sum([a.grid_import_kwh for a in m.agents]),
                "Total_Inverter_Clipped": lambda m: sum([a.inverter_clipped_kwh for a in m.agents]),
                "Avg_Battery_SOC": lambda m: np.mean([a.battery_soc for a in m.agents if a.total_battery_capacity > 0]) if any(a.total_battery_capacity > 0 for a in m.agents) else 0,
                "Hour": "current_hour",
                "Day": "day_of_year"
            },
            agent_reporters={
                "UserID": "user_id",
                "Generation_kWh": "generation_kwh",
                "Usable_Generation_kWh": "usable_generation_kwh",
                "Consumption_kWh": "consumption_kwh",
                "Battery_Charged_kWh": "battery_charged_kwh",
                "Battery_Discharged_kWh": "battery_discharged_kwh",
                "Battery_SOC": "battery_soc",
                "Grid_Export_kWh": "grid_export_kwh",
                "Grid_Import_kWh": "grid_import_kwh",
                "Inverter_Clipped_kWh": "inverter_clipped_kwh",
                "ClusterID": "cluster_id",
                "Location": "location"
            }
        )

    def step(self):
        """Run one step of the model"""
        # Update each agent with latest weather data before stepping
        for agent in self.agents:
            weather = self.weather_lookup.get(agent.cluster_id)
            agent.update_weather(weather)

        # Collect before stepping
        self.datacollector.collect(self)

        # Advance all agents
        self.agents.shuffle_do("step")

        # Advance time
        self.current_hour += 1
        if self.current_hour >= 24:
            self.current_hour = 0
            self.day_of_year += 1

        self.step_count += 1