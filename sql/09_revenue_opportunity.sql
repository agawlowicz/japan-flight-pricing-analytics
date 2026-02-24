/*************************************************************
Query 09: Revenue Opportunity by Route

Business Question:
    "Which routes generate the most revenue potential, and
    where should a travel fintech platform prioritize its
    product investment?"

Why It Matters:
    Not all routes are equal from a business perspective.
    A route with high average prices and high booking volume
    represents the greatest revenue opportunity for fintech
    products like Price Freeze and fare alerts. Prioritizing
    product investment on high revenue potential routes
    maximizes return on engineering and marketing spend.
    A route with low volume but high prices may warrant
    different products than a high volume but lower price
    route.

Key Concepts:
    - Multiplying aggregations to derive a revenue proxy
      (avg_price × num_flights as revenue opportunity score)
    - RANK() window function to surface top opportunities
    - ROUND() for clean numeric output
    - Separating volume and price signals to tell a richer story

Expected Insight:
    East Coast routes (JFK) should show high revenue potential
    due to elevated prices despite similar booking volumes.
    West Coast routes should show competitive volume but lower
    per-flight revenue. Osaka routes may rank highly due to
    price premium despite potentially lower volume.
*************************************************************/

SELECT
    origin,
    destination,
    ROUND(AVG(final_price), 2)                              AS avg_price,
    COUNT(*)                                                AS num_flights,
    ROUND(AVG(final_price) * COUNT(*), 2)                   AS revenue_opportunity,
    RANK() OVER (
        ORDER BY AVG(final_price) * COUNT(*) DESC)          AS opportunity_rank
FROM 'data/japan_flight_prices.csv'
GROUP BY origin, destination
ORDER BY opportunity_rank;