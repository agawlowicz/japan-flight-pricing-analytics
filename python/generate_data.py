"""
generate_data.py
----------------
Generates a synthetic Japan flight pricing dataset for analytical modeling.

Data Sources:
    - Base prices: Observed economy fares from Google Flights, Expedia,
      Kayak, and Momondo (February 2026)
    - Seasonal multipliers: JNTO 2024 monthly visitor arrival statistics
      https://statistics.jnto.go.jp/en/graph/

Methodology:
    - Base prices normalized to 1.0 seasonal baseline via seasonal deflation
      (True Baseline = Observed February Price ÷ 0.85)
    - Seasonal multipliers applied to baseline prices
    - Random variance (±12%) simulates real-world price fluctuation
    - Booking window adjustments reflect early/late booking premiums

Output:
    - data/japan_flight_prices.csv
    - 5,000 flight records spanning 2023-2024
    - 11 columns covering route, airline, timing, and pricing data

Author note:
    Synthetic data generation mirrors how data teams prototype pricing
    models before production pipelines are available.
"""

import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta

# Set seed so data is reproducible (same results every time we run it)
np.random.seed(42)
random.seed(42)

# ── CONFIGURATION ──────────────────────────────────────────────
# US departure cities
origins = [
    "New York (JFK)",
    "Los Angeles (LAX)", 
    "San Francisco (SFO)",
    "Chicago (ORD)",
    "Seattle (SEA)"
]

# Japan destinations
destinations = [
    "Tokyo (NRT)",
    "Tokyo (HND)",
    "Osaka (KIX)",
]

# Airlines that fly US to Japan
airlines = [
    "Japan Airlines",
    "ANA",
    "United Airlines",
    "Delta Airlines",
    "American Airlines"
]

print("Configuration loaded successfully!")
print(f"Origins: {len(origins)}")
print(f"Destinations: {len(destinations)}")
print(f"Airlines: {len(airlines)}")

# ── SEASONAL PRICING MULTIPLIERS ───────────────────────────────
# Grounded in JNTO 2024 official visitor arrival data
# Source: Japan National Tourism Organization (jnto.go.jp)
# 1.0 = baseline price, higher = more expensive
# raw visitor numbers don't translate directly to western travels
# multipliers adjusted upward for months that in my experience drive Western demand (cherry blossom and fall foliage)

seasonal_multipliers = {
    1:  0.82,   # January - lowest demand, winter niche travel
    2:  0.85,   # February - quiet, pre-cherry blossom
    3:  1.45,   # March - cherry blossom begins, 3M+ visitors
    4:  1.55,   # April - peak cherry blossom, record 3.04M in 2024
    5:  1.40,   # May - Golden Week, sustained peak demand
    6:  0.88,   # June - rainy season, sharp demand drop
    7:  0.92,   # July - hot/humid, lower Western demand
    8:  0.95,   # August - domestic travel bump, still hot
    9:  1.05,   # September - shoulder season, pleasant weather
    10: 1.30,   # October - fall foliage begins, demand rising
    11: 1.25,   # November - peak fall foliage season
    12: 1.00,   # December - holiday travel, baseline
}

# print("Seasonal multipliers loaded!")
# print(f"Peak month multiplier (April): {seasonal_multipliers[4]}")
# print(f"Low month multiplier (January): {seasonal_multipliers[1]}")

# ── BASE PRICES BY ORIGIN, DESTINATION AND AIRLINE (Round Trip USD) ──
# Source: Google Flights, Expedia, Kayak, Momondo - February 2026
# Normalized to 1.0 seasonal baseline: True Baseline = Feb Price ÷ 0.85
# Tokyo prices generally lower due to higher route competition
# Osaka prices slightly higher due to fewer direct routes from East Coast
# HND generally slightly cheaper than NRT due to higher direct route competition
# All prices normalized: True Baseline = Feb Price ÷ 0.85

base_prices = {
    "New York (JFK)": {
        "Tokyo (NRT)": {
            "Japan Airlines":    1294,
            "ANA":               1235,
            "United Airlines":   1153,
            "Delta Airlines":    1200,
            "American Airlines": 1165,
        },
        "Tokyo (HND)": {
            "Japan Airlines":    1247,  # ~$50 cheaper than NRT from JFK
            "ANA":               1200,
            "United Airlines":   1153,  # same hubs serve both airports
            "Delta Airlines":    1176,
            "American Airlines": 1141,
        },
        "Osaka (KIX)": {
            "Japan Airlines":    1376,
            "ANA":               1318,
            "United Airlines":   1235,
            "Delta Airlines":    1282,
            "American Airlines": 1247,
        },
    },
    "Los Angeles (LAX)": {
        "Tokyo (NRT)": {
            "Japan Airlines":    870,   # $739 ÷ 0.85
            "ANA":               795,   # $676 ÷ 0.85
            "United Airlines":   735,   # $625 ÷ 0.85
            "Delta Airlines":    838,   # $712 ÷ 0.85
            "American Airlines": 759,   # $645 ÷ 0.85
        },
        "Tokyo (HND)": {
            "Japan Airlines":    811,   # $689 ÷ 0.85
            "ANA":               779,   # $662 ÷ 0.85
            "United Airlines":   735,   # $625 ÷ 0.85
            "Delta Airlines":    882,   # $750 ÷ 0.85
            "American Airlines": 759,   # $645 ÷ 0.85
        },
        "Osaka (KIX)": {
            "Japan Airlines":    874,
            "ANA":               808,
            "United Airlines":   765,
            "Delta Airlines":    847,
            "American Airlines": 788,
        },
    },
    "San Francisco (SFO)": {
        "Tokyo (NRT)": {
            "Japan Airlines":    894,
            "ANA":               824,
            "United Airlines":   765,
            "Delta Airlines":    859,
            "American Airlines": 788,
        },
        "Tokyo (HND)": {
            "Japan Airlines":    847,
            "ANA":               800,
            "United Airlines":   765,
            "Delta Airlines":    835,
            "American Airlines": 765,
        },
        "Osaka (KIX)": {
            "Japan Airlines":    941,
            "ANA":               871,
            "United Airlines":   812,
            "Delta Airlines":    906,
            "American Airlines": 835,
        },
    },
    "Chicago (ORD)": {
        "Tokyo (NRT)": {
            "Japan Airlines":    1235,
            "ANA":               1153,
            "United Airlines":   1082,
            "Delta Airlines":    1141,
            "American Airlines": 1106,
        },
        "Tokyo (HND)": {
            "Japan Airlines":    1188,
            "ANA":               1118,
            "United Airlines":   1082,
            "Delta Airlines":    1106,
            "American Airlines": 1082,
        },
        "Osaka (KIX)": {
            "Japan Airlines":    1318,
            "ANA":               1235,
            "United Airlines":   1165,
            "Delta Airlines":    1224,
            "American Airlines": 1188,
        },
    },
    "Seattle (SEA)": {
        "Tokyo (NRT)": {
            "Japan Airlines":    918,
            "ANA":               847,
            "United Airlines":   800,
            "Delta Airlines":    871,
            "American Airlines": 824,
        },
        "Tokyo (HND)": {
            "Japan Airlines":    871,
            "ANA":               824,
            "United Airlines":   800,
            "Delta Airlines":    847,
            "American Airlines": 800,
        },
        "Osaka (KIX)": {
            "Japan Airlines":    965,
            "ANA":               894,
            "United Airlines":   847,
            "Delta Airlines":    918,
            "American Airlines": 871,
        },
    },
}

# ── DATA GENERATION LOOP ───────────────────────────────────────
# Generate realistic flight records across all combinations

records = []
num_records = 5000  # Enough for meaningful analysis

for _ in range(num_records):
    # Randomly select flight attributes
    origin = random.choice(origins)
    destination = random.choice(destinations)
    airline = random.choice(airlines)
    
    # Random travel date across 2 full years (2023-2024)
    start_date = datetime(2023, 1, 1)
    random_days = random.randint(0, 730) #731 days including leap year in 2024
    travel_date = start_date + timedelta(days=random_days)
    
    # Get month for seasonal multiplier
    month = travel_date.month
    seasonal_mult = seasonal_multipliers[month]
    
    # Get base price for this origin/destination/airline combination
    base_price = base_prices[origin][destination][airline]
    
    # Apply seasonal multiplier
    adjusted_price = base_price * seasonal_mult
    
    # Add realistic random variance (+/- 12%)
    # This simulates real-world price fluctuation around the seasonal trend
    variance = np.random.uniform(0.88, 1.12)
    final_price = round(adjusted_price * variance, 2)
    
    # Booking window: days booked in advance (7 to 180 days)
    # Most purchases are within 1-6 month window
    booking_window = random.randint(7, 180)

    # Booking window discount: earlier booking = slightly cheaper
    # Based on real pattern: booking 90+ days out saves ~10-15%
    #   Book 90+ days out: 3% to 12% cheaper than seasonal price
	#   Book 45-89 days out: roughly at market price, slight variance either way
	#   Book less than 45 days out: 2% to 15% more expensive, last minute premium
    if booking_window >= 90:
        final_price = round(final_price * np.random.uniform(0.88, 0.97), 2)
    elif booking_window >= 45:
        final_price = round(final_price * np.random.uniform(0.95, 1.02), 2)
    else:
        final_price = round(final_price * np.random.uniform(1.02, 1.15), 2)
    
    # Build the record
    records.append({
        "travel_date":      travel_date.strftime("%Y-%m-%d"),
        "month":            month,
        "month_name":       travel_date.strftime("%B"),
        "year":             travel_date.year,
        "origin":           origin,
        "destination":      destination,
        "airline":          airline,
        "booking_window":   booking_window,
        "seasonal_mult":    seasonal_mult,
        "base_price":       base_price,
        "final_price":      final_price,
    })

# Convert to DataFrame
df = pd.DataFrame(records)

print(f"Generated {len(df)} flight records!")
print(f"\nSample of data:")
print(df.head())
print(f"\nPrice range: ${df['final_price'].min():,.2f} - ${df['final_price'].max():,.2f}")
print(f"Average price: ${df['final_price'].mean():,.2f}")

# ── SAVE TO CSV ────────────────────────────────────────────────
output_path = "data/japan_flight_prices.csv"
df.to_csv(output_path, index=False)
print(f"\nData saved to {output_path}")
print(f"File contains {len(df)} rows and {len(df.columns)} columns")
print(f"\nColumns: {list(df.columns)}")