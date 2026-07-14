# Business Understanding

## 1. Business Background
This dataset was generously provided by Olist, the largest department store in Brazilian marketplaces. Olist connects small businesses from all over Brazil to channels without hassle and with a single contract. Those merchants are able to sell their products through the Olist Store and ship them directly to the customers using Olist logistics partners. 

## 2. Dataset Overview
9 tables :
- orders: Tracks the lifecycle of each order from purchase to delivery.
- order_items: mangaging each items in an order, connecting orders and products tables.
- order_payments: payment methods, payment type, payment behaviors.
- products: Enables product performance analysis by category, price, and sales volume.
- customers: Stores customer information and enables customer behavior analysis, such as new vs. returning customers, customer distribution, and customer lifetime value. 
- sellers: Managing seller infomation.
- geolocation: Can be used for heatmap visualization.
- product_category_name_translation: product category translation between Portuguese and English.

## 3. Business Process
After a customer purchases the product from Olist Store a seller gets notified to fulfill that order. Once the customer receives the product, or the estimated delivery date is due, the customer gets a satisfaction survey by email where he can give a note for the purchase experience and write down some comments.
