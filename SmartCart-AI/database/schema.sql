-- SmartCart AI Database Schema
-- This file creates all the tables for the project.

-- 1. USERS TABLE
CREATE TABLE USERS (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('CUSTOMER', 'ADMIN')),
    create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. CUSTOMERS TABLE (Inherits from USERS)
CREATE TABLE CUSTOMERS (
    user_id INT PRIMARY KEY REFERENCES USERS(user_id) ON DELETE CASCADE,
    phone VARCHAR(20),
    address TEXT
);

-- 3. ADMINS TABLE (Inherits from USERS)
CREATE TABLE ADMINS (
    user_id INT PRIMARY KEY REFERENCES USERS(user_id) ON DELETE CASCADE,
    admin_level VARCHAR(30) NOT NULL
);

-- 4. CATEGORIES TABLE
CREATE TABLE CATEGORIES (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

-- 5. PRODUCTS TABLE
CREATE TABLE PRODUCTS (
    product_id SERIAL PRIMARY KEY,
    category_id INT REFERENCES CATEGORIES(category_id),
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    image_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. CARTS TABLE
CREATE TABLE CARTS (
    cart_id SERIAL PRIMARY KEY,
    user_id INT UNIQUE REFERENCES CUSTOMERS(user_id) ON DELETE CASCADE,
    update_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. CART_ITEMS TABLE
CREATE TABLE CART_ITEMS (
    cart_item_id SERIAL PRIMARY KEY,
    cart_id INT REFERENCES CARTS(cart_id) ON DELETE CASCADE,
    product_id INT REFERENCES PRODUCTS(product_id),
    quantity INT NOT NULL CHECK (quantity > 0)
);

-- 8. ORDERS TABLE
CREATE TABLE ORDERS (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES CUSTOMERS(user_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'SHIPPED', 'DELIVERED')),
    shipment_address TEXT NOT NULL
);

-- 9. ORDER_ITEMS TABLE
CREATE TABLE ORDER_ITEMS (
    item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES ORDERS(order_id) ON DELETE CASCADE,
    product_id INT REFERENCES PRODUCTS(product_id),
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL
);

-- 10. PAYMENTS TABLE
CREATE TABLE PAYMENTS (
    payment_id SERIAL PRIMARY KEY,
    order_id INT UNIQUE REFERENCES ORDERS(order_id) ON DELETE CASCADE,
    payment_method VARCHAR(50) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    transaction_id VARCHAR(100) UNIQUE,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 11. SHIPMENTS TABLE
CREATE TABLE SHIPMENTS (
    shipment_id SERIAL PRIMARY KEY,
    order_id INT UNIQUE REFERENCES ORDERS(order_id) ON DELETE CASCADE,
    carrier VARCHAR(50) NOT NULL,
    tracking_number VARCHAR(100) UNIQUE,
    status VARCHAR(20) NOT NULL,
    ship_date TIMESTAMP
);

-- 12. REVIEWS TABLE
CREATE TABLE REVIEWS (
    review_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES CUSTOMERS(user_id) ON DELETE CASCADE,
    product_id INT REFERENCES PRODUCTS(product_id) ON DELETE CASCADE,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);