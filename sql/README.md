# SQL Queries

This folder contains 10 analytical SQL queries written in DuckDB syntax,
each answering a distinct business question about Japan flight pricing.
Together they tell a complete pricing intelligence story — from foundational
seasonal patterns to advanced risk modeling for fintech protection products.

All queries read directly from `data/japan_flight_prices.csv` using DuckDB's
native CSV reading capability. Use the query runner utility to execute any
query from the project root:
```bash
python python/run_query.py sql/01_avg_price_by_month.sql
```

---

## Query Roadmap

### 01 — Average Price by Month
**Business Question:** How do Japan flight prices change throughout the year,
and which months offer the best and worst value?

Foundational seasonal analysis using a window function to calculate each
month's dollar premium above the cheapest month. Establishes the baseline
seasonal pricing story that all subsequent queries build on.

**Key techniques:** `MIN() OVER ()` window function, seasonal multipliers

---

### 02 — Flight Price by Route
**Business Question:** Which routes are the most and least expensive, and
how much does your departure city affect what you pay?

Route-level pricing matrix showing average, minimum, and maximum prices
across all 15 origin and destination combinations.

**Key techniques:** Multi-column `GROUP BY`, aggregate functions

---

### 03 — Airline Ranking by Route
**Business Question:** Which airline is the cheapest and most expensive on
each route, and how big is the price gap between carriers?

Ranks all five carriers within each route using both `RANK()` and
`DENSE_RANK()` to demonstrate how ties are handled differently between
the two functions.

**Key techniques:** `RANK()`, `DENSE_RANK()`, `PARTITION BY`

---

### 04 — Price by Booking Window
**Business Question:** How does how far in advance you book affect what you
pay, and is there a sweet spot for getting the best price?

Buckets booking windows into four behavioral segments — early bird,
standard, late, and last minute — and calculates average price per segment.
Directly relevant to fare prediction and booking timing products.

**Key techniques:** `CASE` statements, behavioral segmentation

---

### 05 — Seasonal Price Volatility
**Business Question:** Which months have the most unpredictable prices, and
how does price volatility inform both traveler risk and platform liability
for protection products?

Calculates standard deviation and coefficient of variation (reported as
volatility) for each month. High volatility months represent the greatest
liability risk for Price Freeze products. Low volatility months are where
protection products can be offered most confidently.

**Key techniques:** `STDDEV()`, coefficient of variation as normalized
volatility measure

---

### 06 — Year Over Year Price Comparison
**Business Question:** Did flight prices to Japan increase or decrease from
2023 to 2024, and did that change consistently across all routes?

Pivots year into columns using conditional aggregation and calculates
percent change between years. In production data this query would surface
price trends essential for keeping pricing models accurate over time.

**Key techniques:** `CASE` inside `AVG()` for conditional aggregation,
percent change calculation

---

### 07 — Peak vs Off-Peak Season Comparison
**Business Question:** How much of a premium do travelers pay during peak
seasons, and is the cost difference significant enough to justify flexible
travel timing?

Buckets months into five named seasons and calculates both dollar and
percentage premium above the cheapest season. The 68% spring peak premium
over winter is the headline insight — a traveler who can shift timing saves
nearly $580 on average.

**Key techniques:** `CASE` seasonal bucketing, `MIN() OVER ()` for premium
calculation, logical `ORDER BY` on derived column

---

### 08 — Best Value Route and Timing Combinations
**Business Question:** Which combinations of origin, airline, and travel
month offer the best value for price-conscious travelers?

Ranks all origin, destination, airline, and month combinations by average
price within each departure city. Filtered to combinations with at least
5 flights for statistical reliability. West Coast origins on United and
American in January dominate the top value spots.

**Key techniques:** `RANK()` with `PARTITION BY`, `HAVING` for minimum
sample size filtering

---

### 09 — Revenue Opportunity by Route
**Business Question:** Which routes generate the most revenue potential,
and where should a travel fintech platform prioritize its product investment?

Derives a revenue opportunity score as average price multiplied by booking
volume. Surfaces where fintech product investment — fare alerts, Price
Freeze, flexible date tools — would generate the greatest return.

**Key techniques:** Multiplying aggregations to derive a composite metric,
`RANK()` window function

---

### 10 — Price Freeze Risk Model
**Business Question:** Which route and season combinations represent the
highest liability risk for Price Freeze products, and where can the platform
offer protection most confidently?

The most sophisticated query in the project. Uses a parametric Value at Risk
methodology borrowed from financial risk modeling to estimate 95th percentile
liability exposure per segment. Risk score calculated as
`price_stddev × 1.645 × num_flights` where 1.645 is the z-score for 95%
confidence under a normal distribution.

Spring Peak on East Coast and Chicago routes dominates the top risk tier.
Winter segments appearing in the top 20 reflect a known synthetic data
limitation — see `data/README.md` for details.

**Key techniques:** CTE, `STDDEV()`, parametric Value at Risk proxy,
`CASE` seasonal bucketing, `RANK()` window function

---

## SQL Concepts Demonstrated

Across all 10 queries this folder demonstrates:
- Window functions: `MIN() OVER ()`, `RANK()`, `DENSE_RANK()`
- `PARTITION BY` for within-group ranking
- `STDDEV()` for volatility measurement
- `CASE` statements for bucketing and conditional aggregation
- CTEs for readable multi-step calculations
- `HAVING` for post-aggregation filtering
- Composite metric derivation combining multiple aggregations
- Parametric Value at Risk methodology adapted for pricing analytics