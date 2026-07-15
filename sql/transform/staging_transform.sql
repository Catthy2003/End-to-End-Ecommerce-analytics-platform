-- =====================================================
-- STAGING TRANSFORM
-- Source : raw
-- Target : staging schema
-- =====================================================

-- =====================================================
-- CUSTOMERS
-- =====================================================

INSERT INTO staging.customers
SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    INITCAP(TRIM(customer_city)) AS customer_city,
    customer_state,
    CURRENT_TIMESTAMP AS etl_loaded_at
FROM raw.customers;

-- =====================================================
-- ORDERS
-- =====================================================

INSERT INTO staging.orders
SELECT
    order_id,
    customer_id,
    LOWER(TRIM(order_status)) AS order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    CURRENT_TIMESTAMP AS etl_loaded_at
FROM raw.orders
WHERE order_purchase_timestamp IS NOT NULL;

-- =====================================================
-- ORDER ITEMS
-- =====================================================

INSERT INTO staging.order_items
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value,
    CURRENT_TIMESTAMP AS etl_loaded_at
FROM raw.order_items
WHERE price >= 0
  AND freight_value >= 0;

-- =====================================================
-- PRODUCTS
-- =====================================================

INSERT INTO staging.products
SELECT
    product_id,
    COALESCE(
        LOWER(TRIM(product_category_name)),
        'Unknown'
    ) AS product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    CURRENT_TIMESTAMP AS etl_loaded_at
FROM raw.products;

-- =====================================================
-- SELLERS
-- =====================================================

INSERT INTO staging.sellers
SELECT
    seller_id,
    seller_zip_code_prefix,
    INITCAP(TRIM(seller_city)) AS seller_city,
    UPPER(TRIM(seller_state)) AS seller_state,
    CURRENT_TIMESTAMP AS etl_loaded_at
FROM raw.sellers;

-- =====================================================
-- ORDER PAYMENTS
-- =====================================================

INSERT INTO staging.order_payments
SELECT
    order_id,
    payment_sequential,
    LOWER(TRIM(payment_type)) AS payment_type,
    payment_installments,
    payment_value,
    CURRENT_TIMESTAMP AS etl_loaded_at
FROM raw.order_payments
WHERE payment_value >= 0;

-- =====================================================
-- ORDER REVIEWS
-- =====================================================

INSERT INTO staging.order_reviews
SELECT
    review_id,
    order_id,
    review_score,
    TRIM(review_comment_title) AS review_comment_title,
    TRIM(review_comment_message) AS review_comment_message,
    review_creation_date,
    review_answer_timestamp,
    CURRENT_TIMESTAMP AS etl_loaded_at
FROM raw.order_reviews
WHERE review_score BETWEEN 1 AND 5;

-- =====================================================
-- GEOLOCATION
-- =====================================================

INSERT INTO staging.geolocation
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    INITCAP(TRIM(geolocation_city)) AS geolocation_city,
    UPPER(TRIM(geolocation_state)) AS geolocation_state,
    CURRENT_TIMESTAMP AS etl_loaded_at
FROM raw.geolocation
WHERE geolocation_lat BETWEEN -90 AND 90
  AND geolocation_lng BETWEEN -180 AND 180;

-- =====================================================
-- PRODUCT CATEGORY TRANSLATION
-- =====================================================

INSERT INTO staging.product_category_name_translation
SELECT
    TRIM(product_category_name) AS product_category_name,
    TRIM(product_category_name_english) AS product_category_name_english,
    CURRENT_TIMESTAMP AS etl_loaded_at
FROM raw.product_category_name_translation;