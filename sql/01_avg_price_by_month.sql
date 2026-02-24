/*************************************************************
Query 01: Average Flight Price by Month

Business Question:
    "How do Japan flight prices change throughout the year,
    and which months offer the best and worst value?"

Why It Matters:
    Seasonal pricing is the foundation of travel fintech
    products like Price Freeze and Cancel for Any Reason.
    Understanding when prices peak and drop directly informs
    how travel fintech platforms price their products and
    advise travelers on optimal booking windows.

Key Concepts:
    - Seasonal demand multipliers (JNTO-derived)
    - Window function: MIN() OVER () for baseline comparison
    - price_vs_baseline: dollar premium above cheapest month

Expected Insight:
    April (cherry blossom peak) should show highest average
    prices. January/February should show lowest. Fall foliage
    (October/November) should show a clear secondary peak.
*************************************************************/
SELECT
    month,
    month_name,
    seasonal_mult,
    ROUND(AVG(final_price), 2)        AS avg_price,
    ROUND(MIN(final_price), 2)        AS min_price,
    ROUND(MAX(final_price), 2)        AS max_price,
    ROUND(AVG(final_price) - MIN(AVG(final_price)) 
        OVER (), 2)                   AS price_vs_baseline,
    COUNT(*)                          AS num_flights
FROM 'data/japan_flight_prices.csv'
GROUP BY month, month_name, seasonal_mult
ORDER BY month;