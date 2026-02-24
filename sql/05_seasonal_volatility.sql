/*************************************************************
Query 05: Seasonal Price Volatility

Business Question:
    "Which months have the most unpredictable prices, and
    how does price volatility inform both traveler risk
    and platform liability for protection products?"

Why It Matters:
    Average price alone doesn't tell the full story. A month
    with high volatility means travelers face more risk —
    the same trip could cost dramatically different amounts
    depending on timing and luck. Travel fintech platforms
    use volatility signals to determine when price alerts
    and protection products like Price Freeze are most
    valuable to travelers. Conversely, low volatility months
    reduce platform risk when pricing protection products —
    a predictable price range makes it easier to offer Price
    Freeze confidently without unexpected liability exposure.

Key Concepts:
    - STDDEV() window function for price volatility measurement
    - Coefficient of variation (stddev / avg) for normalized
      volatility comparison across months with different averages
    - Combining multiple aggregations to tell a richer story

Expected Insight:
    Peak months like April and March should show the highest
    absolute price volatility (stddev) due to wide price ranges.
    However ordering by coefficient of variation may surface
    surprising results — shoulder months with moderate average
    prices but inconsistent demand may prove more relatively
    unpredictable than peak months. High coefficient of variation
    months represent the greatest liability risk for Price Freeze
    products, as the range of prices the platform may need to
    honor is hardest to predict.
*************************************************************/

SELECT
    month,
    month_name,
    ROUND(AVG(final_price), 2)                            AS avg_price,
    ROUND(STDDEV(final_price), 2)                         AS price_stddev,
    ROUND(MIN(final_price), 2)                            AS min_price,
    ROUND(MAX(final_price), 2)                            AS max_price,
    ROUND(MAX(final_price) - MIN(final_price), 2)         AS price_range,
    ROUND(STDDEV(final_price) / AVG(final_price), 4)      AS coeff_of_variation
FROM 'data/japan_flight_prices.csv'
GROUP BY month, month_name
ORDER BY coeff_of_variation DESC;