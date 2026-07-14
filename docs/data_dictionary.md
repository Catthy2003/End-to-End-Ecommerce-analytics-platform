# Data Dictionary

## customers

| Column                   | Data Type | Description                                                             |
|--------------------------|-----------|-------------------------------------------------------------------------|
| customer_id              | TEXT      | Unique identifier of each customer                                      |
| customer_unique_id       | TEXT      | Unique identifier representing the same customer across multiple orders |
| customer_zip_code_prefix | TEXT      | Customer ZIP code prefix                                                |
| customer_city            | TEXT      | Customer city                                                           |
| customer_state           | CHAR(2)   | Customer state                                                          |

---

## orders

| Column                        | Data Type | Description                     |
|-------------------------------|-----------|---------------------------------|
| order_id                      | TEXT      | Unique identifier of each order |
| customer_id                   | TEXT      | Customer who placed the order   |
| order_status                  | TEXT      | Current order status            |
| order_purchase_timestamp      | TIMESTAMP | Order purchase time             |
| order_approved_at             | TIMESTAMP | Order approved time             |
| order_delivered_carrier_date  | TIMESTAMP | Order delivered carrier time    |
| order_delivered_customer_date | TIMESTAMP | Order delivered customer time   |
| order_estimated_delivery_date | TIMESTAMP | Order estimated delivery time   |

---

## order_items

| Column              | Data Type     | Description                                                                 |
|---------------------|---------------|-----------------------------------------------------------------------------|
| order_id            | TEXT          | Unique identifier of each order                                             |
| order_item_id       | INTEGER       | Sequential number identifying number of items included in the same order    |
| product_id          | TEXT          | Unique identifier of each product                                           |
| seller_id           | TEXT          | Unique identifier of each seller                                            |
| shipping_limit_date | TIMESTAMP     | Shipping limit time                                                         |
| price               | NUMERIC(10,2) | item price                                                                  |
| freight_value       | NUMERIC(10,2) | Item freight value item is splitted between items when it has more than one |

---

## products

| Column                     | Data Type     | Description                                                 |
|----------------------------|---------------|-------------------------------------------------------------|
| product_id                 | TEXT          | Unique identifier of each product                           |
| product_category_name      | TEXT          | root category of product, in Portuguese                     |
| product_name_lenght        | INTEGER       | Number of characters extracted from the product name        |
| product_description_lenght | INTEGER       | Number of characters extracted from the product description |
| product_photos_qty         | INTEGER       | number of product published photos                          |
| product_weight_g           | NUMERIC(10,2) | Product weight measured in grams                            |
| product_length_cm          | NUMERIC(10,2) | Product length measured in centimeters                      |
| product_height_cm          | NUMERIC(10,2) | Product height measured in centimeters                      |

## order_payments

| Column               | Data Type     | Description                                                                                    |
|----------------------|---------------|------------------------------------------------------------------------------------------------|
| payment_sequential   | INTEGER       | A sequence created to accommodate all payments if the customer use more than one payment method|
| payment_type         | TEXT          | Payment type                                                                                   |
| payment_installments | INTEGER       | Number of installments chosen by the customer                                                  |
| payment_value        | NUMERIC(10,2) | Value of payment                                                                               |

---

## order_reviews

| Column                  | Data Type | Description                                     |
|-------------------------|-----------|-------------------------------------------------|
| review_id               | TEXT      | Unique identifier of each review                |
| order_id                | TEXT      | Unique identifier of each order                 |
| review_score            | INTEGER   | Score ranging from 1 to 5 given by the customer |
| review_comment_title    | TEXT      | Title of a review                               |
| review_comment_message  | TEXT      | Full review comment                             |
| review_creation_date    | TIMESTAMP | Review created time                             |
| review_answer_timestamp | TIMESTAMP | Review answer time                              |

---

## sellers

| Column                 | Data Type | Description                       |
|------------------------|-----------|-----------------------------------|
| seller_id              | TEXT      | Unique identifier of each seller  |
| seller_zip_code_prefix | TEXT      | First 5 digits of seller zip code |
| seller_city            | TEXT      | Seller city name                  |
| seller_state           | CHAR(2)   | Seller state                      |

---

## product_category_name_translation

| Column                        | Data Type | Description                   |
|-------------------------------|-----------|-------------------------------|
| product_category_name         | TEXT      | category name in Portuguese   |
| product_category_name_english | TEXT      | product_category_name_english |

---

## geolocation

| Column                      | Data Type     | Description                |
|-----------------------------|---------------|----------------------------|
| geolocation_zip_code_prefix | TEXT          | first 5 digits of zip code |
| geolocation_lat             | NUMERIC(10,2) | Latitude                   |
| geolocation_lng             | NUMERIC(10,2) | Longitude                  |
| geolocation_city            | TEXT          | City name                  |
| geolocation_state           | CHAR(2)       | State                      |
