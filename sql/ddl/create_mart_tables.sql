-- Create mart schema
CREATE SCHEMA IF NOT EXISTS mart;

-- =========================
-- Customers
-- =========================
CREATE TABLE IF NOT EXISTS mart.dim_customer (
    customer_key SERIAL PRIMARY KEY,
    customer_id TEXT UNIQUE NOT NULL,
    customer_unique_id TEXT NOT NULL,
    customer_city TEXT,
    customer_state CHAR(2),
    etl_loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================
-- Products
-- =========================
CREATE TABLE IF NOT EXISTS mart.dim_product (
    product_key SERIAL PRIMARY KEY,
    product_id CHAR(32) UNIQUE NOT NULL,
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

-- ========================
-- Sellers
-- =========================
CREATE TABLE IF NOT EXISTS mart.dim_seller (
    seller_key SERIAL PRIMARY KEY,
    seller_id TEXT UNIQUE NOT NULL,
    seller_city TEXT,
    seller_state CHAR(2),
    etl_loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);