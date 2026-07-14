-- New Customers by Month

WITH first_purchase AS (
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_purchase_date

    FROM raw.customers c

    JOIN raw.orders o
    ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id

)

SELECT

    DATE_TRUNC('month', first_purchase_date) AS month,

    COUNT(*) AS new_customers

FROM first_purchase

GROUP BY month

ORDER BY month;

-- Repeat Customers
WITH customer_orders AS (

SELECT
    c.customer_unique_id,
    o.order_id,
    o.order_purchase_timestamp,
    ROW_NUMBER() OVER(
        PARTITION BY c.customer_unique_id
        ORDER BY o.order_purchase_timestamp
    ) AS rn

FROM raw.customers c
JOIN raw.orders o
ON c.customer_id = o.customer_id
)

SELECT *
FROM customer_orders
WHERE rn >= 2;

-- Repeat Customers by Month
WITH ranked_orders AS (

SELECT
    c.customer_unique_id,
    o.order_purchase_timestamp,
    ROW_NUMBER() OVER(
        PARTITION BY c.customer_unique_id
        ORDER BY o.order_purchase_timestamp
    ) AS rn

FROM raw.customers c
JOIN raw.orders o
ON c.customer_id = o.customer_id
)

SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS month,
    COUNT(*) AS returning_customers

FROM ranked_orders
WHERE rn = 2
GROUP BY month
ORDER BY month;

-- State-wise revenue
SELECT
    c.customer_state,
    ROUND(SUM(op.payment_value),2) AS revenue

FROM raw.customers c

JOIN raw.orders o
ON c.customer_id = o.customer_id

JOIN raw.order_payments op
ON o.order_id = op.order_id

GROUP BY c.customer_state

ORDER BY revenue DESC;

-- City-wise revenue
SELECT
    c.customer_city,
    ROUND(SUM(op.payment_value), 2) AS revenue
FROM raw.order_payments op

JOIN raw.orders o
ON op.order_id = o.order_id

JOIN raw.customers c
ON o.customer_id = c.customer_id

GROUP BY c.customer_city
ORDER BY revenue DESC

LIMIT 10;

