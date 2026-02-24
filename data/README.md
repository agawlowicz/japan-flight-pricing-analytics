# Data Sources & Methodology

## Overview
This dataset was synthetically generated using Python based on real-world 
pricing data, official tourism statistics, and domain knowledge of US-to-Japan 
travel patterns. It contains 5,000 flight records spanning 2023-2024.

---

## Seasonal Demand Multipliers
Seasonal pricing multipliers are grounded in official visitor arrival 
statistics published by the Japan National Tourism Organization (JNTO).

**Source:** Japan National Tourism Organization (JNTO)  
**URL:** https://statistics.jnto.go.jp/en/graph/  
**Data Used:** Monthly foreign visitor arrivals to Japan, 2024

### Key Data Points Referenced
| Month | 2024 Visitor Pattern | Multiplier Applied |
|-------|---------------------|-------------------|
| January | Lowest demand period | 0.82x |
| February | Quiet, pre-cherry blossom | 0.85x |
| March | 3M+ visitors, cherry blossom begins | 1.45x |
| April | Record 3.04M visitors, peak cherry blossom | 1.55x |
| May | Golden Week, sustained peak demand | 1.40x |
| June | Rainy season, sharp demand drop | 0.88x |
| July | Hot/humid, lower Western demand | 0.92x |
| August | Domestic travel bump, still hot | 0.95x |
| September | Shoulder season, pleasant weather | 1.05x |
| October | Fall foliage begins, demand rising | 1.30x |
| November | Peak fall foliage season | 1.25x |
| December | Holiday travel, baseline | 1.00x |

---

## Base Flight Prices
**Sources:** Google Flights, Expedia, Kayak — February 2026  
**Routes covered:**
- Origins: New York (JFK), Los Angeles (LAX), San Francisco (SFO), 
  Chicago (ORD), Seattle (SEA)
- Destinations: Tokyo (HND), Tokyo (NRT), Osaka (KIX)
- Airlines: Japan Airlines, ANA, United Airlines, Delta Airlines, 
  American Airlines

### Normalization Methodology
February 2026 observed fares were normalized to a 1.0 seasonal baseline 
using seasonal deflation:
```
True Baseline = Observed February Price ÷ 0.85
```

This removes the February low-season discount so that seasonal multipliers 
apply cleanly across all twelve months. Validation check: applying the 0.85 
February multiplier back to any normalized baseline returns the original 
observed February fare, confirming internal consistency.

### Pricing Notes
- Tokyo routes are generally cheaper than Osaka due to higher route 
  competition and more direct flight options
- Osaka premiums are larger from East Coast cities (JFK, ORD) where 
  direct routing is limited and connections through Tokyo add cost
- West Coast cities (LAX, SFO, SEA) show smaller Tokyo/Osaka price gaps 
  due to direct JAL and ANA service to KIX
- United, Delta, and American Osaka fares are estimated where direct 
  routes don't exist, based on typical connecting fare premiums

---

## Price Variance & Booking Window
Each record includes two additional price adjustments applied on top of 
the seasonal multiplier:

**Random variance (±12%):** Simulates real-world price fluctuation due to 
seat inventory, day of week, and competitor pricing.

**Booking window discount:** Based on real booking behavior data:
- 90+ days in advance → 3-12% discount (early bird pricing)
- 45-89 days in advance → roughly market price (±2%)
- Under 45 days → 2-15% premium (last minute pricing)

---

## Why Synthetic Data?
Real-time flight pricing data is proprietary — it's the core competitive 
asset of travel fintech companies like Hopper. Generating a realistic 
synthetic dataset based on domain knowledge and official tourism statistics 
mirrors how data teams prototype and test pricing models before production 
data pipelines are available.

Pricing assumptions are grounded in a combination of real observed data 
and transparent estimation methodology:

- **Seasonal multipliers** are derived from official JNTO 2024 monthly 
  visitor arrival statistics (cited above)
- **Base flight prices** for key routes are sourced from observed February 
  2026 economy fares on Google Flights, Expedia, Kayak, and Momondo
- **Tokyo HND vs NRT price differentials** are estimated based on observed 
  competition levels and direct route availability by carrier
- **Osaka fares for carriers without direct routes** (United, Delta, 
  American from East Coast cities) are estimated based on typical connecting 
  fare premiums over direct route pricing
- **Price variance (±12%)** and **booking window adjustments** are modeled 
  on general industry pricing patterns rather than carrier-specific data

---

## Dataset Schema
| Column | Type | Description |
|--------|------|-------------|
| travel_date | string | Travel date in ISO 8601 format (YYYY-MM-DD) |
| month | integer | Month number (1-12) |
| month_name | string | Full month name (e.g. "April") |
| year | integer | Travel year (2023 or 2024) |
| origin | string | US departure city and airport code |
| destination | string | Japan arrival city and airport code |
| airline | string | Operating airline |
| booking_window | integer | Days booked in advance (7-180) |
| seasonal_mult | float | JNTO-derived seasonal demand multiplier |
| base_price | float | Normalized 1.0 baseline price (USD) |
| final_price | float | Final price after all adjustments (USD) |

---

## Known Limitations

**Uniform price volatility across months**
The synthetic data applies consistent random variance (±12%) across all
records regardless of season, resulting in a nearly identical coefficient
of variation (~0.21) for every month. Real pricing data would show
meaningfully higher volatility during peak demand periods (cherry blossom,
Golden Week) due to inventory scarcity, dynamic pricing responses, and
competitor reactions. This limitation is worth noting when interpreting
Query 05 seasonal volatility results.

**Carrier pricing assumptions**
JAL and ANA are seeded slightly higher than US carriers in the base price
dictionary. Real observed data shows carrier pricing is mixed — Japanese
carriers are sometimes cheaper on direct routes due to higher frequency
and inventory. This affects the airline ranking patterns visible in
Query 03.

**Estimated prices for indirect routes**
Where direct pricing data was unavailable for specific carrier and route
combinations (particularly US carriers to Osaka), prices were estimated
based on typical connecting fare premiums rather than observed fares. A
production model would source all prices from live fare data.

**Western traveler demand adjustment**
Seasonal multipliers were adjusted beyond raw JNTO visitor data to account
for Western traveler demand patterns. That adjustment was based on domain
knowledge and judgment rather than a separate data source. A production
model would validate this against actual booking data segmented by
traveler origin country.

**Booking window distribution**
Booking windows are randomly distributed between 7 and 180 days, producing
a thin last-minute bucket (191 flights vs 2,592 early bird bookings). Real
booking behavior skews differently by route, season, and traveler type and
would require behavioral data to model accurately.