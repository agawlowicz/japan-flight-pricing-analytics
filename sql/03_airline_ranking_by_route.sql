/*************************************************************
Query 03: Airline Price Ranking by Route

Business Question:
    "Which airline is the cheapest and most expensive on each
    route, and how big is the price gap between carriers?"

Why It Matters:
    Carrier-level price differentiation is critical for travel
    fintech platforms building fare comparison tools and booking
    recommendations. Understanding which airlines consistently
    price higher or lower on specific routes helps power smarter
    suggestions and better value predictions for travelers.

Key Concepts:
    - RANK() and DENSE_RANK() window functions
    - PARTITION BY to reset ranking within each route
    - ORDER BY within OVER() clause
    - Difference between RANK and DENSE_RANK tie handling

Expected Insight:
    Carrier pricing is expected to be mixed — Japanese carriers
    (JAL, ANA) may price competitively on direct routes where
    they have more frequency and inventory. US carriers (United,
    Delta, American) may price higher on routes where they rely
    on connections rather than direct service. The largest price
    gaps between carriers are expected on East Coast routes where
    routing options are more limited.
*************************************************************/

SELECT
    origin,
    destination,
    airline,
    ROUND(AVG(final_price), 2)                                          AS avg_price,
    RANK()       OVER (PARTITION BY origin, destination 
                       ORDER BY AVG(final_price) DESC)                  AS price_rank,
    DENSE_RANK() OVER (PARTITION BY origin, destination 
                       ORDER BY AVG(final_price) DESC)                  AS dense_rank
FROM 'data/japan_flight_prices.csv'
GROUP BY origin, destination, airline
ORDER BY origin, destination, price_rank;