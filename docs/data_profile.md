## orders

Rows: 99,441

Columns: 8

Primary Key:
- order_id

Contains NULL:
- order_approved_at
- order_delivered_carrier_date
- order_delivered_customer_date

Duplicate:
- 0

## customers

Rows: 99,441

Columns: 5

Primary Key:
- customer_id

Contains NULL:
- 0

Duplicate:
- 0

## order items

Rows: 112,650

Columns: 7

Primary Key:
- order_id, order_item_id (Composite Primary Key)

Contains NULL:
- 0

Duplicate:
- 0