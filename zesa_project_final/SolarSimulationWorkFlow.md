# Solar Simulation Workflow

## Architecture Overview

```
Backend (FastAPI/Django) ←→ Google Colab (Mesa Simulation)
     ↕                              ↕
  Database                    File I/O (CSV)
```

## Workflow Cycle (Every 15 Minutes)

### 1. Backend: Data Preparation & Export

#### 1.1 Query Database
```sql
SELECT 
    u.id as user_id,
    us.panel_wattage,
    us.panel_count,
    us.battery_capacity_kwh,
    us.inverter_capacity_kw,
    us.household_size
FROM users u
JOIN user_systems us ON u.id = us.user_id
WHERE us.panel_count > 0;  -- Only users with solar systems
```

#### 1.2 Create Input CSV
**File: `users_input_{timestamp}.csv`**
```csv
user_id,panel_wattage,panel_count,battery_capacity_kwh,inverter_capacity_kw,household_size
a1b2c3d4-e5f6-7890-1234-567890abcdef,400.0,12,13.5,5.0,4
b2c3d4e5-f6g7-8901-2345-678901bcdefg,350.0,8,10.0,3.5,2
c3d4e5f6-g7h8-9012-3456-789012cdefgh,450.0,16,20.0,7.0,5
```

**Data Types:**
- `user_id`: UUID4 string (36 characters with dashes)
- `panel_wattage`: Float (watts per panel)
- `panel_count`: Integer (number of panels)
- `battery_capacity_kwh`: Float (kWh capacity, 0 for no battery)
- `inverter_capacity_kw`: Float (kW capacity)
- `household_size`: Integer (number of people)

#### 1.3 Backend Code Example
```python
from datetime import datetime
import pandas as pd
import uuid

def export_users_for_simulation(db_session):
    """Export user data for simulation input."""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"users_input_{timestamp}.csv"
    
    # Query database
    query = """
    SELECT 
        u.id as user_id,
        COALESCE(us.panel_wattage, 350.0) as panel_wattage,
        COALESCE(us.panel_count, 0) as panel_count,
        COALESCE(us.battery_capacity_kwh, 0.0) as battery_capacity_kwh,
        COALESCE(us.inverter_capacity_kw, 5.0) as inverter_capacity_kw,
        COALESCE(us.household_size, 3) as household_size
    FROM users u
    LEFT JOIN user_systems us ON u.id = us.user_id
    WHERE us.panel_count > 0
    """
    
    df = pd.read_sql(query, db_session.bind)
    df.to_csv(filename, index=False)
    
    return filename, len(df)
```

---

### 2. Backend → Google Colab: File Transfer

#### 2.1 Upload Methods

**Option A: Google Drive API**
```python
from googleapiclient.discovery import build
from google.oauth2.service_account import Credentials

def upload_to_drive(file_path, folder_id):
    """Upload CSV to Google Drive folder accessible by Colab."""
    service = build('drive', 'v3', credentials=creds)
    
    file_metadata = {
        'name': os.path.basename(file_path),
        'parents': [folder_id]
    }
    
    media = MediaFileUpload(file_path, mimetype='text/csv')
    file = service.files().create(
        body=file_metadata,
        media_body=media,
        fields='id'
    ).execute()
    
    return file.get('id')
```

**Option B: HTTP API Endpoint**
```python
import requests

def send_to_colab(csv_file_path, colab_webhook_url):
    """Send CSV via HTTP to Colab webhook."""
    with open(csv_file_path, 'rb') as f:
        files = {'file': f}
        data = {
            'timestamp': datetime.now().isoformat(),
            'weather_factor': get_current_weather_factor(),
            'seed': generate_seed()
        }
        response = requests.post(colab_webhook_url, files=files, data=data)
    
    return response.json()
```

**Option C: Cloud Storage (GCS/S3)**
```python
def upload_to_gcs(file_path, bucket_name, blob_name):
    """Upload to Google Cloud Storage."""
    from google.cloud import storage
    
    client = storage.Client()
    bucket = client.bucket(bucket_name)
    blob = bucket.blob(blob_name)
    
    blob.upload_from_filename(file_path)
    return f"gs://{bucket_name}/{blob_name}"
```

---

### 3. Google Colab: Simulation Execution

#### 3.1 Colab Setup Cell
```python
# Install dependencies
!pip install mesa pandas numpy

# Mount Google Drive (if using Drive method)
from google.colab import drive
drive.mount('/content/drive')

# Import simulation model
from solar_simulation_model import run_simulation
import pandas as pd
from datetime import datetime
```

#### 3.2 Simulation Runner Cell
```python
def run_15min_simulation():
    """Run single 15-minute simulation tick."""
    
    # Get current time rounded to 15-min intervals
    now = datetime.now()
    minutes = (now.minute // 15) * 15
    current_time = now.replace(minute=minutes, second=0, microsecond=0)
    
    # Input/output file paths
    input_file = "/content/drive/MyDrive/solar_sim/users_input_latest.csv"
    output_file = f"/content/drive/MyDrive/solar_sim/results_{current_time.strftime('%Y%m%d_%H%M')}.csv"
    
    # Get weather factor (you could integrate weather API here)
    weather_factor = 0.9  # Default sunny conditions
    
    # Run simulation
    success = run_simulation(
        input_file=input_file,
        output_file=output_file,
        steps=1,  # Single 15-minute tick
        start_time=current_time.isoformat(),
        weather=weather_factor,
        seed=None  # Or use timestamp-based seed for consistency
    )
    
    if success:
        print(f"✅ Simulation completed: {output_file}")
        return output_file
    else:
        print("❌ Simulation failed")
        return None

# Auto-run simulation
result_file = run_15min_simulation()
```

#### 3.3 Automated Scheduling (Optional)
```python
import time
from datetime import datetime, timedelta

def schedule_simulations():
    """Run simulation every 15 minutes."""
    while True:
        try:
            # Calculate next 15-minute mark
            now = datetime.now()
            next_run = now.replace(second=0, microsecond=0)
            next_run += timedelta(minutes=15 - (now.minute % 15))
            
            # Wait until next 15-minute mark
            wait_seconds = (next_run - now).total_seconds()
            print(f"⏰ Waiting {wait_seconds:.0f}s until {next_run.strftime('%H:%M')}")
            time.sleep(wait_seconds)
            
            # Run simulation
            run_15min_simulation()
            
        except KeyboardInterrupt:
            print("🛑 Simulation scheduler stopped")
            break
        except Exception as e:
            print(f"❌ Error: {e}")
            time.sleep(60)  # Wait 1 minute before retry

# Uncomment to start auto-scheduler
# schedule_simulations()
```

---

### 4. Google Colab → Backend: Results Transfer

#### 4.1 Output CSV Format
**File: `results_{YYYYMMDD_HHMM}.csv`**
```csv
user_id,timestamp,generation_kwh,consumption_kwh,battery_soc_kwh,battery_charge_kwh,battery_discharge_kwh,grid_import_kwh,grid_export_kwh,surplus_kwh
a1b2c3d4-e5f6-7890-1234-567890abcdef,2024-09-11T14:15:00,1.234567,0.456789,12.500000,0.000000,0.000000,0.000000,0.777778,0.777778
b2c3d4e5-f6g7-8901-2345-678901bcdefg,2024-09-11T14:15:00,0.892345,0.634521,8.750000,0.000000,0.000000,0.000000,0.257824,0.257824
c3d4e5f6-g7h8-9012-3456-789012cdefgh,2024-09-11T14:15:00,2.156789,1.023456,19.125000,0.500000,0.000000,0.000000,0.633333,1.133333
```

**Data Types:**
- `user_id`: UUID4 string (matches input)
- `timestamp`: ISO 8601 string (2024-09-11T14:15:00)
- `generation_kwh`: Float (6 decimal places)
- `consumption_kwh`: Float (6 decimal places)
- `battery_soc_kwh`: Float (current battery charge)
- `battery_charge_kwh`: Float (energy added to battery)
- `battery_discharge_kwh`: Float (energy taken from battery)
- `grid_import_kwh`: Float (energy imported from grid)
- `grid_export_kwh`: Float (energy exported to grid)
- `surplus_kwh`: Float (generation - consumption, can be negative)

#### 4.2 Colab Results Notification
```python
def notify_backend_of_results(result_file_path, backend_webhook):
    """Notify backend that results are ready."""
    import requests
    
    payload = {
        'status': 'completed',
        'result_file': result_file_path,
        'timestamp': datetime.now().isoformat(),
        'record_count': len(pd.read_csv(result_file_path))
    }
    
    response = requests.post(backend_webhook, json=payload)
    return response.status_code == 200
```

---

### 5. Backend: Results Processing & Storage

#### 5.1 Download Results
```python
def download_simulation_results(file_path_or_url):
    """Download results from Colab."""
    if file_path_or_url.startswith('http'):
        # Download from URL
        response = requests.get(file_path_or_url)
        df = pd.read_csv(StringIO(response.text))
    else:
        # Read from file path
        df = pd.read_csv(file_path_or_url)
    
    return df
```

#### 5.2 Parse & Validate Results
```python
import uuid
from datetime import datetime

def validate_simulation_results(df):
    """Validate simulation results before database insertion."""
    errors = []
    
    # Check required columns
    required_columns = [
        'user_id', 'timestamp', 'generation_kwh', 'consumption_kwh',
        'battery_soc_kwh', 'grid_import_kwh', 'grid_export_kwh', 'surplus_kwh'
    ]
    
    for col in required_columns:
        if col not in df.columns:
            errors.append(f"Missing column: {col}")
    
    # Validate UUIDs
    for user_id in df['user_id']:
        try:
            uuid.UUID(str(user_id))
        except ValueError:
            errors.append(f"Invalid UUID: {user_id}")
    
    # Validate timestamps
    for ts in df['timestamp']:
        try:
            datetime.fromisoformat(str(ts))
        except ValueError:
            errors.append(f"Invalid timestamp: {ts}")
    
    # Validate energy values (non-negative)
    energy_cols = ['generation_kwh', 'consumption_kwh', 'grid_import_kwh', 'grid_export_kwh']
    for col in energy_cols:
        if (df[col] < 0).any():
            errors.append(f"Negative values found in {col}")
    
    # Validate surplus calculation
    calculated_surplus = df['generation_kwh'] - df['consumption_kwh']
    surplus_diff = abs(df['surplus_kwh'] - calculated_surplus)
    if (surplus_diff > 0.001).any():
        errors.append("Surplus calculation mismatch")
    
    return errors
```

#### 5.3 Database Insertion
```python
def insert_simulation_results(db_session, results_df, simulation_run_id):
    """Insert simulation results into database."""
    
    # Validate first
    errors = validate_simulation_results(results_df)
    if errors:
        raise ValueError(f"Validation errors: {errors}")
    
    # Prepare energy data records
    energy_records = []
    for _, row in results_df.iterrows():
        energy_data = EnergyData(
            user_id=uuid.UUID(str(row['user_id'])),
            timestamp=datetime.fromisoformat(str(row['timestamp'])),
            generation_kwh=float(row['generation_kwh']),
            consumption_kwh=float(row['consumption_kwh']),
            surplus_kwh=float(row['surplus_kwh']),
            source=EnergyDataSource.SIMULATION,
            simulation_run_id=simulation_run_id
        )
        energy_records.append(energy_data)
    
    # Bulk insert
    db_session.bulk_save_objects(energy_records)
    db_session.commit()
    
    return len(energy_records)
```

---

### 6. Complete Workflow Orchestration

#### 6.1 Main Scheduler Function
```python
import schedule
import time
from datetime import datetime

def run_simulation_cycle():
    """Complete 15-minute simulation cycle."""
    cycle_start = datetime.now()
    print(f"🔄 Starting simulation cycle at {cycle_start.strftime('%H:%M:%S')}")
    
    try:
        # Step 1: Export user data
        input_file, user_count = export_users_for_simulation(db_session)
        print(f"📤 Exported {user_count} users to {input_file}")
        
        # Step 2: Upload to Colab (choose your method)
        upload_to_colab_location(input_file)
        print(f"☁️ Uploaded input file to Colab")
        
        # Step 3: Trigger Colab simulation (webhook/API call)
        result_file = trigger_colab_simulation()
        print(f"⚡ Simulation completed: {result_file}")
        
        # Step 4: Download results
        results_df = download_simulation_results(result_file)
        print(f"📥 Downloaded {len(results_df)} energy records")
        
        # Step 5: Insert into database
        records_inserted = insert_simulation_results(db_session, results_df, current_simulation_run_id)
        print(f"💾 Inserted {records_inserted} records into database")
        
        # Step 6: Cleanup temporary files
        cleanup_temp_files([input_file])
        
        cycle_end = datetime.now()
        duration = (cycle_end - cycle_start).total_seconds()
        print(f"✅ Cycle completed in {duration:.1f}s")
        
    except Exception as e:
        print(f"❌ Cycle failed: {e}")
        # Log error, send alerts, etc.

# Schedule every 15 minutes
schedule.every(15).minutes.do(run_simulation_cycle)

# Run scheduler
while True:
    schedule.run_pending()
    time.sleep(60)  # Check every minute
```

#### 6.2 Health Monitoring
```python
def health_check():
    """Monitor simulation health."""
    
    # Check last successful simulation
    last_simulation = db_session.query(EnergyData).filter(
        EnergyData.source == EnergyDataSource.SIMULATION
    ).order_by(EnergyData.timestamp.desc()).first()
    
    if last_simulation:
        time_since_last = datetime.utcnow() - last_simulation.timestamp
        if time_since_last.total_seconds() > 20 * 60:  # 20 minutes
            print("⚠️  No simulation data in 20+ minutes!")
            # Send alert
    
    # Check Colab connectivity
    # Check file transfer status
    # Check database performance
    
    return {
        'status': 'healthy',
        'last_simulation': last_simulation.timestamp if last_simulation else None,
        'active_users': get_active_user_count(),
        'total_energy_today': get_daily_energy_totals()
    }
```

---

## Error Handling & Monitoring

### Common Issues & Solutions

1. **File Transfer Failures**
   - Implement retry logic with exponential backoff
   - Use multiple transfer methods as fallbacks
   - Monitor file sizes and checksums

2. **Colab Disconnections**
   - Set up multiple Colab instances
   - Implement automatic reconnection
   - Use Colab Pro for better reliability

3. **Data Validation Failures**
   - Log detailed validation errors
   - Implement data repair mechanisms
   - Alert administrators immediately

4. **Database Lock/Performance Issues**
   - Use connection pooling
   - Implement bulk operations
   - Monitor query performance

### Monitoring Metrics

- **Simulation Frequency**: Should be every 15 minutes ±30 seconds
- **Processing Time**: Complete cycle should take <5 minutes
- **Data Quality**: 100% of records should pass validation
- **User Coverage**: All active solar users should have data
- **Energy Balance**: Community totals should be consistent

---

## File Naming Conventions

```
Input Files:  users_input_YYYYMMDD_HHMMSS.csv
Output Files: results_YYYYMMDD_HHMM.csv
Logs:         simulation_log_YYYYMMDD.log
Backups:      backup_energy_data_YYYYMMDD.sql
```

## Security Considerations

1. **API Keys**: Store in environment variables, rotate regularly
2. **File Access**: Use temporary signed URLs, clean up files
3. **Data Privacy**: Ensure user data is anonymized in logs
4. **Network**: Use HTTPS/TLS for all transfers
5. **Monitoring**: Log all data access and transfers