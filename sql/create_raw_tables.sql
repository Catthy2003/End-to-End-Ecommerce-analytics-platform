-- Create raw schema
CREATE SCHEMA IF NOT EXISTS raw;

-- =========================
-- Customers
-- =========================
CREATE TABLE IF NOT EXISTS raw.customers (
    customer_id TEXT PRIMARY KEY,
    customer_unique_id TEXT NOT NULL,
    customer_zip_code_prefix TEXT NOT NULL,
    customer_city TEXT,
    customer_state CHAR(2)
);

-- =========================
-- Orders
-- =========================
CREATE TABLE IF NOT EXISTS raw.orders (
    order_id TEXT PRIMARY KEY,
    customer_id TEXT NOT NULL,
    order_status TEXT NOT NULL,
    order_purchase_timestamp TIMESTAMP NOT NULL,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP NOT NULL
);

-- =========================
-- Order Items
-- =========================
CREATE TABLE IF NOT EXISTS raw.order_items (
    order_id TEXT NOT NULL,
    order_item_id INTEGER NOT NULL,
    product_id TEXT NOT NULL,
    seller_id TEXT NOT NULL,
    shipping_limit_date TIMESTAMP NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    freight_value NUMERIC(10,2) NOT NULL,

    PRIMARY KEY (order_id, order_item_id)
);

-- =========================
-- Products
-- =========================
CREATE TABLE IF NOT EXISTS raw.products (
    product_id TEXT PRIMARY KEY,         
    product_category_name TEXT NOT NULL,      
    product_name_lenght INTEGER NOT NULL,
    product_description_lenght INTEGER NOT NULL,
    product_photos_qty INTEGER NOT NULL,
    product_weight_g NUMERIC(10,2) NOT NULL,
    product_length_cm NUMERIC(10,2) NOT NULL,
    product_height_cm NUMERIC(10,2) NOT NULL
);

-- =========================
-- Order Payments
-- =========================
CREATE TABLE IF NOT EXISTS raw.order_payments (
    order_id TEXT PRIMARY KEY,
    payment_sequential INTEGER NOT NULL,
    payment_type TEXT NOT NULL,
    payment_installments INTEGER NOT NULL,
    payment_value NUMERIC(10,2) NOT NULL
);

-- =========================
-- Order Reviews
-- =========================
CREATE TABLE IF NOT EXISTS raw.order_reviews (
    review_id TEXT PRIMARY KEY,
    order_id TEXT NOT NULL,
    review_score INTEGER NOT NULL,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP NOT NULL,
    review_answer_timestamp TIMESTAMP
);

-- =========================
-- Sellers
-- =========================
CREATE TABLE IF NOT EXISTS raw.sellers (
    seller_id TEXT PRIMARY KEY,
    seller_zip_code_prefix TEXT NOT NULL,
    seller_city TEXT NOT NULL,
    seller_state CHAR(2) NOT NULL
);

-- =========================
-- Geolocation
-- =========================
CREATE TABLE IF NOT EXISTS raw.geolocation (
    geolocation_zip_code_prefix TEXT PRIMARY KEY,
    geolocation_lat NUMERIC(10,6) NOT NULL,
    geolocation_lng NUMERIC(10,6) NOT NULL,
    geolocation_city TEXT NOT NULL,
    geolocation_state CHAR(2) NOT NULL
);

-- =========================
-- Product Category Name Translation
-- =========================
CREATE TABLE IF NOT EXISTS raw.product_category_name_translation (
    product_category_name TEXT PRIMARY KEY,
    product_category_name_english TEXT NOT NULL
);
