/*************************************************************
Query 10: Price Freeze Risk Model by Route and Season

Business Question:
    "Which route and season combinations represent the highest
    liability risk for Price Freeze products, and where can
    the platform offer protection most confidently?"

Why It Matters:
    Price Freeze profitability depends on accurately assessing
    the risk of prices rising after a freeze is purchased.
    High volatility and high booking volume create maximum
    liability exposure — the platform's payout on a frozen
    price depends on how much prices move and how many freezes
    are outstanding, not the starting price level. Low volatility
    routes and seasons are where Price Freeze can be offered
    most confidently and profitably. This risk model is
    foundational to sustainable fintech product pricing.

Key Concepts:
    - CTE (Common Table Expression) to calculate base metrics
      once and reference them cleanly in the outer query
    - STDDEV() for price volatility measurement
    - CASE statements to assign season buckets
    - Value at Risk proxy: price_stddev × 1.645 × num_flights
      estimates 95th percentile dollar liability exposure per segment.
      avg_price is excluded from the risk score because the platform's
      payout on a frozen price depends only on how much the price moves,
      not the starting price level.
    - RANK() window function to surface highest risk segments

Expected Insight:
    Spring Peak (March-May) on East Coast and Chicago routes
    should score highest on the risk model due to the combination
    of peak volatility and strong booking volume. Winter segments
    appearing in the top 20 reflect a known synthetic data
    limitation — uniform volatility across seasons understates
    true peak season risk. In production data, Spring Peak would
    dominate the top risk tier by a wider margin.
*************************************************************/

WITH base AS (
    SELECT
        origin,
        destination,
        CASE
            WHEN month IN (3, 4, 5)     THEN '1. Spring Peak (Mar-May)'
            WHEN month IN (10, 11)      THEN '2. Fall Foliage (Oct-Nov)'
            WHEN month IN (7, 8)        THEN '3. Summer (Jul-Aug)'
            WHEN month IN (12, 1, 2)    THEN '4. Winter (Dec-Feb)'
            ELSE                             '5. Shoulder (Jun, Sep)'
        END                             AS season,
        AVG(final_price)                AS avg_price,
        STDDEV(final_price)             AS price_stddev,
        COUNT(*)                        AS num_flights
    FROM 'data/japan_flight_prices.csv'
    GROUP BY origin, destination, season
)
SELECT
    origin,
    destination,
    season,
    ROUND(avg_price, 2)                                     AS avg_price,
    ROUND(price_stddev, 2)                                  AS price_stddev,
    ROUND(price_stddev / avg_price, 4)                      AS volatility,
    num_flights,
    ROUND(price_stddev * 1.645 * num_flights, 2)                AS risk_score,
    RANK() OVER (
        ORDER BY price_stddev * 1.645 * num_flights DESC)        AS risk_rank
FROM base
ORDER BY risk_rank
LIMIT 20;

