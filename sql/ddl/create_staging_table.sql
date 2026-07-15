-- Create staging schema
CREATE SCHEMA IF NOT EXISTS staging;

-- =========================
-- Customers
-- =========================
CREATE TABLE IF NOT EXISTS staging.customers (
    customer_id TEXT PRIMARY KEY,
    customer_unique_id TEXT NOT NULL,
    customer_zip_code_prefix TEXT,
    customer_city TEXT,
    customer_state CHAR(2),
    etl_loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- Orders
-- =========================
CREATE TABLE IF NOT EXISTS staging.orders (
    order_id TEXT PRIMARY KEY,
    customer_id TEXT NOT NULL,
    order_status TEXT NOT NULL,
    order_purchase_timestamp TIMESTAMP NOT NULL,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP NOT NULL,
    etl_loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- Order Items
-- =========================
CREATE TABLE IF NOT EXISTS staging.order_items (
    order_id TEXT NOT NULL,
    order_item_id INTEGER NOT NULL,
    product_id TEXT NOT NULL,
    seller_id TEXT NOT NULL,
    shipping_limit_date TIMESTAMP NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    freight_value NUMERIC(10,2) NOT NULL,
    etl_loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (order_id, order_item_id)
);

-- =========================
-- Products
-- =========================
CREATE TABLE IF NOT EXISTS staging.products (
    product_id TEXT PRIMARY KEY,         
    product_category_name TEXT,      
    product_name_length INTEGER,
    product_description_length INTEGER,
    product_photos_qty INTEGER,
    product_weigth_g NUMERIC(10,2),
    product_length_cm NUMERIC(10,2),
    product_heigth_cm NUMERIC(10,2),
    product_width_cm NUMERIC(10,2),
    etl_loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- Order Payments
-- =========================
CREATE TABLE IF NOT EXISTS staging.order_payments (
    order_id TEXT NOT NULL,
    payment_sequential INTEGER NOT NULL,
    payment_type TEXT NOT NULL,
    payment_installments INTEGER NOT NULL,
    payment_value NUMERIC(10,2) NOT NULL,
    etl_loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (order_id, payment_sequential)
);

-- =========================
-- Order Reviews
-- =========================
CREATE TABLE IF NOT EXISTS staging.order_reviews (
    review_id TEXT NOT NULL,
    order_id TEXT NOT NULL,
    review_score INTEGER NOT NULL,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP NOT NULL,
    review_answer_timestamp TIMESTAMP,
    etl_loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (review_id, order_id)
);

-- =========================
-- Sellers
-- =========================
CREATE TABLE IF NOT EXISTS staging.sellers (
    seller_id TEXT PRIMARY KEY,
    seller_zip_code_prefix TEXT NOT NULL,
    seller_city TEXT NOT NULL,
    seller_state CHAR(2) NOT NULL,
    etl_loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- Geolocation
-- =========================
CREATE TABLE IF NOT EXISTS staging.geolocation (
    geolocation_zip_code_prefix TEXT,
    geolocation_lat NUMERIC(10,6) NOT NULL,
    geolocation_lng NUMERIC(10,6) NOT NULL,
    geolocation_city TEXT NOT NULL,
    geolocation_state CHAR(2) NOT NULL,
    etl_loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- Product Category Name Translation
-- =========================
CREATE TABLE IF NOT EXISTS staging.product_category_name_translation (
    product_category_name TEXT,
    product_category_name_english TEXT NOT NULL,
    etl_loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
