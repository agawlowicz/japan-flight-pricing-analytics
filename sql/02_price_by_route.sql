/*************************************************************
Query 02: Flight Price by Route

Business Question:
    "Which routes are the most and least expensive, and how
    much does your departure city affect what you pay?"

Why It Matters:
    Route-level pricing is foundational to how travel fintech
    platforms build fare alerts, price predictions, and booking
    recommendations. Understanding baseline price differences
    by origin and destination helps explain why the same trip
    can cost dramatically different amounts depending on where
    you live.

Key Concepts:
    - Multi-column GROUP BY (origin + destination)
    - Aggregations: AVG, MIN, MAX, COUNT
    - ORDER BY to surface most expensive routes first

Expected Insight:
    East Coast origins (JFK) should show higher average prices
    than West Coast (LAX, SFO, SEA) due to longer flights and
    fewer direct routing options to Japan. Osaka (KIX) should
    show a premium over Tokyo routes from most origins.
*************************************************************/

SELECT
    origin,
    destination,
    ROUND(AVG(final_price), 2)  AS avg_price,
    ROUND(MIN(final_price), 2)  AS min_price,
    ROUND(MAX(final_price), 2)  AS max_price,
    COUNT(*)                    AS num_flights
FROM 'data/japan_flight_prices.csv'
GROUP BY origin, destination
ORDER BY avg_price DESC;