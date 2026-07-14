TABLE_CONFIG = {

    "orders": {
        "primary_keys": ["order_id"],

        "required_columns": [
            "order_id",
            "customer_id",
            "order_status",
            "order_purchase_timestamp",
            "order_approved_at",
            "order_delivered_carrier_date",
            "order_delivered_customer_date",
            "order_estimated_delivery_date"
        ],
        "path": "data/raw/orders.csv"
    },

    "customers": {
        "primary_keys": ["customer_id"],

        "required_columns": [
            "customer_id",
            "customer_unique_id",
            "customer_zip_code_prefix",
            "customer_city",
            "customer_state"
        ],
        "path": "data/raw/customers.csv"
    },
    
    "order_items": {
        "primary_keys": ["order_id", "order_item_id"],

        "required_columns": [
            "order_id",
            "order_item_id",
            "product_id",
            "seller_id",
            "shipping_limit_date",
            "price",
            "freight_value"
        ],
        "path": "data/raw/order_items.csv"
    },
    
    "products": {
        "primary_keys": ["product_id"],
        
        "required_columns": [
            "product_id",
            "product_category_name",
            "product_name_lenght",
            "product_description_lenght",
            "product_photos_qty",
            "product_weight_g",
            "product_length_cm",
            "product_height_cm",
            "product_width_cm"
        ],
        "path": "data/raw/products.csv"
    },
    
    "sellers": {
        "primary_keys": ["seller_id"],
        
        "required_columns": [
            "seller_id",
            "seller_zip_code_prefix",
            "seller_city",
            "seller_state"
        ],
        "path": "data/raw/sellers.csv"
    },
    
    "order_payments": {
        "primary_keys": ["order_id", "payment_type"],
        
        "required_columns": [
            "order_id",
            "payment_type",
            "payment_installments",
            "payment_value"
        ],
        "path": "data/raw/order_payments.csv"
    },
    
    "order_reviews": {
        "primary_keys": ["review_id"],
        
        "required_columns": [
            "review_id",
            "order_id",
            "review_score",
            "review_comment_title",
            "review_comment_message",
            "review_creation_date",
            "review_answer_timestamp"
        ],
        "path": "data/raw/order_reviews.csv"
    },
    
    "geolocation": {
        "primary_keys": ["geolocation_zip_code_prefix", "geolocation_lat", "geolocation_lng"],
        
        "required_columns": [
            "geolocation_zip_code_prefix",
            "geolocation_lat",
            "geolocation_lng"
        ],
        "path": "data/raw/geolocation.csv"
    },
    
    "product_category_name_translation": {
        "primary_keys": ["product_category_name", "product_category_name_english"],
        
        "required_columns": [
            "product_category_name",
            "product_category_name_english"
        ],
        "path": "data/raw/product_category_name_translation.csv"
    }

}