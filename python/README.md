# Python Scripts

This folder contains two Python scripts that support the Japan Flight
Pricing Intelligence project — one for synthetic data generation and one
for executing SQL queries against the dataset.

---

## Scripts

### generate_data.py

Generates the synthetic Japan flight pricing dataset that powers all
downstream SQL analysis and dashboard visualizations.

**What it does:**
Produces 5,000 flight records spanning 2023-2024 across 5 US origin
airports, 3 Japan destinations, and 5 airlines. Prices are grounded in
real February 2026 economy fares collected from Google Flights, Expedia,
Kayak, and Momondo, then normalized to a seasonal baseline and adjusted
using demand multipliers derived from JNTO 2024 monthly visitor arrival
statistics.

**Price generation methodology:**
Each record's final price is calculated as:
```
Base Price × Seasonal Multiplier × Random Variance (±12%) × Booking Window Adjustment
```

- **Base price** — normalized from observed February 2026 fares using
  seasonal deflation: `True Baseline = Observed Price ÷ 0.85`
- **Seasonal multiplier** — derived from JNTO 2024 visitor data, ranging
  from 0.82 (January) to 1.55 (April)
- **Random variance** — uniform distribution ±12% simulating real-world
  price fluctuation
- **Booking window adjustment** — early bird discount for 90+ days advance
  purchase, last minute premium for under 45 days

**Output:** `data/japan_flight_prices.csv` — 5,000 records, 11 columns

**To run:**
```bash
python python/generate_data.py
```

---

### run_query.py

A command line utility for executing any SQL query in the `sql/` folder
against the Japan flight pricing dataset using DuckDB.

**What it does:**
Reads a SQL file, executes it against the CSV dataset via DuckDB, and
prints formatted results to the terminal including row count for quick
validation.

**Why DuckDB:**
DuckDB reads CSV files directly without requiring a database setup or
data import step, making it ideal for analytical prototyping. It supports
the full range of analytical SQL including window functions, CTEs, and
statistical aggregations used throughout this project.

**To run:**
```bash
python python/run_query.py sql/01_avg_price_by_month.sql
```

Replace the filename with any query in the `sql/` folder.

---

## Dependencies

Both scripts require the following packages which can be installed via pip:
```bash
pip install pandas numpy duckdb
```