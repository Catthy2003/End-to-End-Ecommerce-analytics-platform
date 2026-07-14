/*
===========================================================
Revenue Investigation
Business Problem:
Revenue decreased compared to the previous month.

Objective:
Identify the root cause of the revenue decline.

Author: Catthy Nguyen
===========================================================
*/

-- Monthly Revenue Trend
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    ROUND(SUM(op.payment_value), 2) AS revenue

FROM raw.orders o

JOIN raw.order_payments op
ON o.order_id = op.order_id

GROUP BY month

ORDER BY month;

-- Monthly Orders Trend

SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS month,
    COUNT(DISTINCT order_id) AS total_orders

FROM raw.orders

GROUP BY month

ORDER BY month;

-- Monthly Average Order Value (AOV) Trend
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    ROUND(
        SUM(op.payment_value) 
        / 
        COUNT(DISTINCT o.order_id)
        , 2) 
        AS average_order_value

FROM raw.orders o
JOIN raw.order_payments op
ON o.order_id = op.order_id

GROUP BY month

ORDER BY month;

-- Average Items per Order by Month
WITH order_items_count AS (
    SELECT
        oi.order_id,
        o.order_purchase_timestamp,
        COUNT(*) AS total_items

    FROM raw.order_items oi

    JOIN raw.orders o
    ON oi.order_id = o.order_id

    GROUP BY
        oi.order_id,
        o.order_purchase_timestamp
)

SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS month,
    ROUND(AVG(total_items),2) AS average_items_per_order

FROM order_items_count

GROUP BY month
ORDER BY month;

-- Average Product Price by Month
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    ROUND(
        AVG(oi.price),
        2
    ) AS average_product_price

FROM raw.order_items oi

JOIN raw.orders o
    ON oi.order_id = o.order_id

GROUP BY month
ORDER BY month;

-- New Customers revenue by Month
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

SELECT
    DATE_TRUNC(
        'month',
        co.order_purchase_timestamp
    ) AS month,

    COUNT(*) AS new_customers,
    ROUND(
        SUM(op.payment_value),
        2
    ) AS revenue_from_new_customers

FROM customer_orders co

JOIN raw.order_payments op
ON co.order_id = op.order_id

WHERE rn = 1

GROUP BY month
ORDER BY month;

-- Monthly Revenue by Product Category
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    p.product_category_name,
    ROUND(SUM(op.payment_value), 2) AS revenue

FROM raw.orders o

JOIN raw.order_payments op
ON o.order_id = op.order_id

JOIN raw.order_items oi
ON o.order_id = oi.order_id

JOIN raw.products p
ON oi.product_id = p.product_id

GROUP BY month, p.product_category_name

ORDER BY month, revenue DESC;

-- Monthly Revenue by State
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    c.customer_state,
    ROUND(SUM(op.payment_value), 2) AS revenue

FROM raw.orders o

JOIN raw.customers c
ON o.customer_id = c.customer_id

JOIN raw.order_payments op
ON o.order_id = op.order_id

GROUP BY month, c.customer_state

ORDER BY month, revenue DESC;

-- Monthly Order Status Distribution
SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS month,
    order_status,
    COUNT(*) AS total_orders

FROM raw.orders

GROUP BY month, order_status
ORDER BY month, total_orders DESC;

-- Monthly Delivery Performance
SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS month,
    ROUND(
        AVG(
            EXTRACT(EPOCH FROM (
                order_delivered_customer_date
                - order_purchase_timestamp
            )) / 86400
        )
    , 2)

FROM raw.orders

WHERE order_delivered_customer_date IS NOT NULL

GROUP BY month
ORDER BY month;

-- Monthly Review Score
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    ROUND(AVG(r.review_score), 2) AS average_review_score

FROM raw.orders o

JOIN raw.order_reviews r
ON o.order_id = r.order_id

GROUP BY month
ORDER BY month;