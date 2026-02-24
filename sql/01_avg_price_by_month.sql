/*************************************************************
Query 1: Average Flight Price by Month
Purpose: Reveals seasonal pricing patterns across the year
Grounded in JNTO 2024 visitor arrival data
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