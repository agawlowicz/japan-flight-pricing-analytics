/*************************************************************
Query 06: Year Over Year Price Comparison

Business Question:
    "Did flight prices to Japan increase or decrease from
    2023 to 2024, and did that change consistently across
    all routes and seasons?"

Why It Matters:
    Historical price trends validate and improve forward-looking
    pricing models. A static baseline becomes increasingly
    inaccurate if prices are trending up or down year over year.
    Understanding price trajectory over time is essential for
    calibrating fare predictions, assessing whether a current
    price is truly good value relative to recent history, and
    pricing protection products like Price Freeze sustainably
    as underlying costs shift.

Key Concepts:
    - CASE statements for conditional aggregation
    - Pivoting rows into columns using CASE inside AVG()
    - Calculating percent change between two aggregated values
    - ROUND() and NULLIF() to handle division safely

Expected Insight:
    Prices should be relatively stable year over year since
    both years were generated from the same base price
    methodology. Any variance reflects random noise in the
    synthetic data rather than a true trend — in real data
    you would expect to see meaningful year over year movement
    driven by fuel costs, demand shifts, and currency changes.
*************************************************************/

SELECT
    origin,
    destination,
    ROUND(AVG(CASE WHEN year = 2023 THEN final_price END), 2)   AS avg_price_2023,
    ROUND(AVG(CASE WHEN year = 2024 THEN final_price END), 2)   AS avg_price_2024,
    ROUND(
        (AVG(CASE WHEN year = 2024 THEN final_price END) -
         AVG(CASE WHEN year = 2023 THEN final_price END)) /
         NULLIF(AVG(CASE WHEN year = 2023 THEN final_price END), 0) * 100
    , 2)                                                        AS pct_change
FROM 'data/japan_flight_prices.csv'
GROUP BY origin, destination
ORDER BY pct_change DESC;