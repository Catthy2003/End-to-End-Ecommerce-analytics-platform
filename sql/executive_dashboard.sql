-- Total revenue
SELECT
    ROUND(SUM(payment_value), 2) AS total_revenue

FROM raw.order_payments;

-- Total orders
SELECT
    COUNT(*) AS total_orders

FROM raw.orders;

-- Total customers
SELECT
    COUNT(DISTINCT customer_unique_id) AS total_customers

FROM raw.customers;

-- Average Order Value
SELECT 
    ROUND(
        SUM(payment_value) 
        / 
        COUNT(DISTINCT order_id)
        , 2)

AS average_order_value

FROM raw.order_payments;

-- Monthly Revenue 
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    ROUND(SUM(p.payment_value),2) AS revenue

FROM raw.orders o

JOIN raw.order_payments p

ON o.order_id = p.order_id

GROUP BY month

ORDER BY month;

-- Monthly Revenue Growth
SELECT 
    month, 
    revenue, 
    ROUND( 
        (revenue - LAG(revenue) OVER(ORDER BY month)) 
        / 
        LAG(revenue) OVER(ORDER BY month) 
        * 100
        , 2)

AS growth_percentage FROM(
    SELECT 
        DATE_TRUNC('month', order_purchase_timestamp) AS month, 
        SUM(payment_value) AS revenue
    FROM raw.orders o
    JOIN raw.order_payments p
    ON o.order_id=p.order_id
    GROUP BY month
);