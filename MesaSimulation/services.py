from typing import Any, Dict, List
from solarGenSim import SolarGenerationModel2



def run_sim(user_data: List[Dict[str, Any]], weather_data: Dict[str, Dict[str, float]], hours: float):
    model = SolarGenerationModel2(
        user_data_list=user_data,
        weather_lookup=weather_data,
        start_day=1,
        simulation_hours=hours
    )

    for _ in range(hours):
        model.step()
    
    # Extract and return results
    model_data = model.datacollector.get_model_vars_dataframe()
    agent_data = model.datacollector.get_agent_vars_dataframe()
    
    response = {
        'summary': {
            'total_generation_kwh': float(model_data['Total_Generation'].sum()),
            'total_consumption_kwh': float(model_data['Total_Consumption'].sum()),
            'total_grid_import_kwh': float(model_data['Total_Grid_Import'].sum()),
            'total_grid_export_kwh': float(model_data['Total_Grid_Export'].sum()),
            'self_consumption_rate': float(1 - model_data['Total_Grid_Import'].sum() / model_data['Total_Consumption'].sum()),
            'avg_battery_soc': float(model_data['Avg_Battery_SOC'].mean())
        },
        'timeseries': {
            'hours': model_data['Hour'].tolist(),
            'generation': model_data['Total_Generation'].tolist(),
            'consumption': model_data['Total_Consumption'].tolist(),
            'grid_import': model_data['Total_Grid_Import'].tolist(),
            'grid_export': model_data['Total_Grid_Export'].tolist(),
            'battery_soc': model_data['Avg_Battery_SOC'].tolist()
        },
        'per_user': []
    }
    
    # Add per-user data
    # Corrected: Access 'UserID' as a column, not an index level.
    for user_id in agent_data['UserID'].unique():
        user_data = agent_data[agent_data['UserID'] == user_id]
        response['per_user'].append({
            'user_id': int(user_id),
            'generation': float(user_data['Generation_kWh'].sum()),
            'consumption': float(user_data['Consumption_kWh'].sum())
        })
    returnData = response['per_user']
    
    return returnData

"""
users_from_db = [
        {
            'user_id': 1,
            'panel_wattage': 400,        # 400W panels
            'panel_count': 10,            # 10 panels = 4kW system
            'household_size': 4,
            'cluster_id': 'harare_north',
            'battery_capacity': 5.0,      # 5 kWh per battery (e.g., Pylontech US3000C)
            'battery_count': 2,           # 2 batteries = 10 kWh total
            'inverter_capacity': 5.0,     # 5 kW inverter
            'location': 'harare'
        },
        {
            'user_id': 2,
            'panel_wattage': 350,
            'panel_count': 8,             # 2.8kW system
            'household_size': 3,
            'cluster_id': 'harare_north',
            'battery_capacity': 2.5,      # Smaller battery
            'battery_count': 1,
            'inverter_capacity': 3.0,     # 3 kW inverter
            'location': 'harare'
        },
        {
            'user_id': 3,
            'panel_wattage': 400,
            'panel_count': 12,            # 4.8kW system
            'household_size': 5,
            'cluster_id': 'bulawayo_south',
            'battery_capacity': 5.0,
            'battery_count': 3,           # 15 kWh total
            'inverter_capacity': 8.0,     # 8 kW inverter
            'location': 'bulawayo'
        },
        {
            'user_id': 4,
            'panel_wattage': 300,
            'panel_count': 6,             # 1.8kW system (smaller setup)
            'household_size': 2,
            'cluster_id': 'bulawayo_south',
            'battery_capacity': 0,        # No battery
            'battery_count': 0,
            'inverter_capacity': 2.0,     # 2 kW inverter
            'location': 'bulawayo'
        }
    ]

    weather_by_cluster = {
        'harare_north': {
            'temperature': 28,   # Celsius
            'humidity': 65,      # Percent
            'clouds': 30         # Percent cloud cover
        },
        'bulawayo_south': {
            'temperature': 30,
            'humidity': 55,
            'clouds': 15
        }
    }
"""