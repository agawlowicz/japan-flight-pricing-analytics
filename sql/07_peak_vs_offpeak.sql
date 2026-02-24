/*************************************************************
Query 07: Peak vs Off-Peak Season Price Comparison

Business Question:
    "How much of a premium do travelers pay during peak seasons,
    and is the cost difference significant enough to justify
    flexible travel timing?"

Why It Matters:
    Quantifying the peak premium converts seasonal intuition
    into actionable product decisions and traveler nudges.
    A large and consistent peak premium signals that flexible
    date products have real value — a traveler who can shift
    their timing by a few weeks could save hundreds of dollars.
    This insight also informs how protection products like
    Price Freeze should be priced differently across seasons,
    and where marketing nudges toward off-peak travel would
    be most compelling and credible.

Key Concepts:
    - CASE statements to bucket months into named seasons
    - Aggregating across derived categorical groupings
    - Calculating premium as both dollar amount and percentage
    - ORDER BY on a CASE expression for logical sort order

Expected Insight:
    Cherry blossom season (March/April) and Golden Week (May)
    should show the largest premium over off-peak months.
    The dollar gap should be significant enough to make a
    compelling case for flexible date products. Fall foliage
    (October/November) should show a clear secondary premium
    above shoulder and off-peak seasons.
*************************************************************/

SELECT
    CASE
        WHEN month IN (3, 4)        THEN '1. Cherry Blossom (Mar-Apr)'
        WHEN month = 5              THEN '2. Golden Week (May)'
        WHEN month IN (10, 11)      THEN '3. Fall Foliage (Oct-Nov)'
        WHEN month IN (7, 8)        THEN '4. Summer (Jul-Aug)'
        WHEN month IN (12, 1, 2)    THEN '5. Winter (Dec-Feb)'
        ELSE                             '6. Shoulder (Jun, Sep)'
    END                                             AS season,
    ROUND(AVG(final_price), 2)                      AS avg_price,
    ROUND(MIN(final_price), 2)                      AS min_price,
    ROUND(MAX(final_price), 2)                      AS max_price,
    COUNT(*)                                        AS num_flights,
    ROUND(AVG(final_price) - MIN(AVG(final_price))
        OVER (), 2)                                 AS premium_vs_cheapest,
    ROUND((AVG(final_price) - MIN(AVG(final_price))
        OVER ()) / MIN(AVG(final_price))
        OVER () * 100, 2)                           AS premium_pct
FROM 'data/japan_flight_prices.csv'
GROUP BY season
ORDER BY season;