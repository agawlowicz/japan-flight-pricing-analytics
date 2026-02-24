/*************************************************************
Query 08: Best Value Route and Timing Combinations

Business Question:
    "Which combinations of origin, airline, and travel month
    offer the best value for price-conscious travelers, and
    where should travelers be flexible to maximize savings?"

Why It Matters:
    Surfacing best value combinations is the foundation of
    fare recommendation products. A platform that can tell
    a traveler "fly United from LAX in January and save $700
    compared to JAL from JFK in April" delivers concrete,
    actionable value that builds trust and drives bookings.
    Understanding which combinations consistently offer the
    best value also informs how to personalize fare alerts
    and recommendations based on traveler origin and
    flexibility.

Key Concepts:
    - Multi-column GROUP BY combining route, airline, and month
    - RANK() window function partitioned by origin to surface
      best value within each departure city
    - Combining aggregations with window functions
    - ORDER BY avg_price ASC to surface globally cheapest
      combinations first regardless of origin city
    - HAVING COUNT(*) >= 5 to filter combinations with insufficient 
      sample size for reliable average price calculation

Expected Insight:
    West Coast origins (LAX, SFO, SEA) should dominate the
    top of the results due to shorter routes and more direct
    service options. United and American should appear most
    frequently as best value carriers. January and February
    should be the most common months in top value combinations
    confirming winter as the optimal booking season for
    price-conscious travelers.
*************************************************************/

SELECT
    origin,
    destination,
    airline,
    month_name,
    ROUND(AVG(final_price), 2)                                      AS avg_price,
    ROUND(MIN(final_price), 2)                                      AS min_price,
    COUNT(*)                                                        AS num_flights,
    RANK() OVER (
        PARTITION BY origin
        ORDER BY AVG(final_price) ASC)                              AS value_rank
FROM 'data/japan_flight_prices.csv'
GROUP BY origin, destination, airline, month_name, month
HAVING COUNT(*) >= 5 -- minimum threshold for statistical reliability
ORDER BY avg_price ASC
LIMIT 50;