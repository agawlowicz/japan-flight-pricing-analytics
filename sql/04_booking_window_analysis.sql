/*************************************************************
Query 04: Price by Booking Window

Business Question:
    "How does how far in advance you book affect what you pay,
    and is there a sweet spot for getting the best price?"

Why It Matters:
    Booking window optimization is at the core of what travel
    fintech platforms do — telling travelers exactly when to
    buy is the foundation of fare prediction products. Understanding
    the relationship between advance purchase and price directly
    informs when to trigger price alerts and recommendations.

Key Concepts:
    - CASE statements to bucket continuous data into categories
    - Grouping by derived column (booking window bucket)
    - AVG aggregation across meaningful behavioral segments
    - ORDER BY on a CASE expression to control logical sort order

Expected Insight:
    Bookings made 90+ days in advance should show the lowest
    average prices due to early bird discounts. Last minute
    bookings under 45 days should show the highest prices.
    The sweet spot should be clearly visible in the data.
*************************************************************/

SELECT
    CASE
        WHEN booking_window >= 90 THEN '90+ days (early bird)'
        WHEN booking_window >= 45 THEN '45-89 days (standard)'
        WHEN booking_window >= 14 THEN '14-44 days (late)'
        ELSE                           'Under 14 days (last minute)'
    END                                     AS booking_bucket,
    ROUND(AVG(final_price), 2)              AS avg_price,
    ROUND(MIN(final_price), 2)              AS min_price,
    ROUND(MAX(final_price), 2)              AS max_price,
    COUNT(*)                                AS num_flights
FROM 'data/japan_flight_prices.csv'
GROUP BY booking_bucket
ORDER BY
    CASE booking_bucket
        WHEN '90+ days (early bird)'      THEN 1
        WHEN '45-89 days (standard)'      THEN 2
        WHEN '14-44 days (late)'          THEN 3
        WHEN 'Under 14 days (last minute)' THEN 4
    END;