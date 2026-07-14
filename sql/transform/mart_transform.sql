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
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)

SELECT
    product_id,
    product_category_name,
    product_name_lenght,
    product_description_lenght,
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
CREATE TABLE IF NOT EXISTS mart.dim_date (
    date_key INTEGER PRIMARY KEY,
    full_date DATE NOT NULL,
    day SMALLINT NOT NULL,
    month SMALLINT NOT NULL,
    month_name TEXT NOT NULL,
    quarter SMALLINT NOT NULL,
    year INTEGER NOT NULL,
    week_of_year SMALLINT NOT NULL,
    day_of_week SMALLINT NOT NULL,
    day_name TEXT NOT NULL,
    is_weekend BOOLEAN NOT NULL,
    is_month_start BOOLEAN NOT NULL,
    is_month_end BOOLEAN NOT NULL
);

WITH date_series AS (

    SELECT
        generate_series AS full_date

    FROM generate_series(

        (SELECT MIN(DATE(order_purchase_timestamp))
         FROM staging.orders),

        (SELECT MAX(DATE(order_purchase_timestamp))
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

-- ====================================================
-- FACT_ORDER
-- ====================================================
CREATE TABLE IF NOT EXISTS mart.fact_sales (

    fact_key BIGSERIAL PRIMARY KEY,

    date_key INTEGER NOT NULL,
    customer_key INTEGER NOT NULL,
    seller_key INTEGER NOT NULL,
    product_key INTEGER NOT NULL,

    order_id TEXT NOT NULL,
    order_item_id INTEGER NOT NULL,

    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),
    review_score SMALLINT,

    etl_loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (date_key)
        REFERENCES mart.dim_date(date_key),

    FOREIGN KEY (customer_key)
        REFERENCES mart.dim_customer(customer_key),

    FOREIGN KEY (seller_key)
        REFERENCES mart.dim_seller(seller_key),

    FOREIGN KEY (product_key)
        REFERENCES mart.dim_product(product_key)
);

-- ====================================================
-- 
-- ====================================================
WITH sales_source AS (

    SELECT
        o.order_id,
        o.customer_id,
        o.order_purchase_timestamp,

        oi.order_item_id,
        oi.product_id,
        oi.seller_id,

        oi.price,
        oi.freight_value,

        r.review_score

    FROM staging.orders o

    JOIN staging.order_items oi
        ON o.order_id = oi.order_id

    LEFT JOIN staging.order_reviews r
        ON o.order_id = r.order_id
),

sales_lookup AS (
    SELECT
        ss.order_id,
        ss.order_item_id,

        dc.customer_key,
        dp.product_key,
        ds.seller_key,
        dd.date_key,

        ss.price,
        ss.freight_value,
        ss.review_score

    FROM sales_source ss
    
)