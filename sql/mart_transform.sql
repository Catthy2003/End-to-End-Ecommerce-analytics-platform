-- =====================================================
-- MART TRANSFORM
-- Source : staging
-- Target : mart schema
-- =====================================================

-- =====================================================
-- DIM_CUSTOMER
-- =====================================================
INSERT INTO mart.dim_customer (
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
)

SELECT
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
FROM staging.customers

ON CONFLICT (customer_id)
DO NOTHING;

-- =====================================================
-- DIM_PRODUCT
-- =====================================================
INSERT INTO mart.dim_product (

    product_id,
    product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)

SELECT
    product_id,
    product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm

FROM staging.products

ON CONFLICT (product_id)
DO NOTHING;

-- =====================================================
-- DIM_SELLER
-- =====================================================
INSERT INTO mart.dim_seller (
    seller_id,
    seller_city,
    seller_state
)   

SELECT
    seller_id,
    seller_city,
    seller_state

FROM staging.sellers
ON CONFLICT (seller_id)
DO NOTHING;

-- =====================================================
-- DIM_DATE
-- =====================================================
SELECT
    MIN(DATE(order_purchase_timestamp)) AS start_date,
    MAX(DATE(order_purchase_timestamp)) AS end_date
FROM staging.orders;

SELECT generate_series AS full_date
WITH date_series AS (
    SELECT
        generate_series AS full_date

    FROM generate_series(
        (SELECT 
            MIN(DATE(order_purchase_timestamp))
         FROM staging.orders),

        (SELECT 
            MAX(DATE(order_purchase_timestamp))
         FROM staging.orders),

        INTERVAL '1 day'
    )
)

INSERT INTO mart.dim_date (
    date_key,
    full_date,
    day,
    month,
    month_name,
    quarter,
    year,
    week_of_year,
    day_of_week,
    day_name,
    is_weekend,
    is_month_start,
    is_month_end
)

SELECT
    TO_CHAR(full_date, 'YYYYMMDD')::INTEGER AS date_key,
    full_date,
    EXTRACT(DAY FROM full_date) AS day,
    EXTRACT(MONTH FROM full_date) AS month,
    TO_CHAR(full_date, 'FMMonth') AS month_name,
    EXTRACT(QUARTER FROM full_date) AS quarter,
    EXTRACT(YEAR FROM full_date) AS year,
    EXTRACT(WEEK FROM full_date) AS week_of_year,
    EXTRACT(DOW FROM full_date) AS day_of_week,
    TO_CHAR(full_date, 'FMDay') AS day_name,
    
    CASE WHEN 
        EXTRACT(DOW FROM full_date) IN (0, 6) 
        THEN 
            TRUE 
        ELSE 
            FALSE 
        END AS is_weekend,
    
    CASE WHEN 
        full_date = DATE_TRUNC('month', full_date) 
        THEN 
            TRUE 
        ELSE 
            FALSE 
        END AS is_month_start,
    
    CASE WHEN 
        full_date = (DATE_TRUNC('month', full_date) + INTERVAL '1 month' - INTERVAL '1 day') 
        THEN 
            TRUE 
        ELSE 
            FALSE 
        END AS is_month_end

FROM (
    SELECT generate_series AS full_date
    
    FROM generate_series(
        (SELECT 
            MIN(DATE(order_purchase_timestamp))
         FROM staging.orders),
        
        (SELECT 
            MAX(DATE(order_purchase_timestamp))
         FROM staging.orders),
        
        INTERVAL '1 day'
    )

) AS date_series
ON CONFLICT (date_key)
DO NOTHING;