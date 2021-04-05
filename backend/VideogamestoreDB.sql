CREATE SCHEMA IF NOT EXISTS `Videogamestore`;
USE `Videogamestore`;

-- CREATE TABLE `MEMBER_INFO`(
--     `member_id` int NOT NULL AUTO_INCREMENT,
--     `customer_id` int,
--     `joined_date` date NOT NULL,
--     `member_status` BOOL NOT NULL, -- Default 1 ?
--     `renewal_date` date,
--     `reward_points` int NOT NULL,
--     PRIMARY KEY(`member_id`)
--     CONSTRAINT `MEMBER_INFO_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `CUSTOMER`(`customer_id`)
-- ) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `CUSTOMER` (
    `customer_id` int NOT NULL AUTO_INCREMENT,
    `created_on` date NOT NULL,
    `username` varchar(30) NOT NULL,
    `password` varchar(30) NOT NULL,
    `email` varchar(100) NOT NULL,
    `phone` varchar(15) NOT NULL,
    `fname` varchar(50) NOT NULL,
    `lname` varchar(50) NOT NULL,

    `addressLine1` varchar(50) NOT NULL,
    `addressLine2` varchar(50),
    `city` varchar(50) NOT NULL,
    `state` char(2) NOT NULL,
    `zipcode` int NOT NULL,
    `newsletter_subscription` BOOL NOT NULL, -- Default 0 ?

    `reward_points` int NOT NULL, -- Default 0 ?, will trigger a pop-up to user when it's >= 100 for options
    PRIMARY KEY (`customer_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ORDER_STATUS`(
    `order_status_id` int NOT NULL AUTO_INCREMENT,
    `paid` BOOL NOT NULL, -- Default 0 ?
    `shipped` BOOL NOT NULL, -- Default 0 ?
    `delivered` BOOL NOT NULL, -- Default 0 ?
    `cancelled` BOOL NOT NULL, -- Default 0 ?

    PRIMARY KEY (`order_status_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `GIFT_CARD`(
    `gift_card_code` int NOT NULL AUTO_INCREMENT,
    `balance` decimal(6,2) NOT NULL,
    `start_date` date NOT NULL,
    -- `end_date` date NOT NULL, -- will trigger a `usable` flag to be false for this gift card
    -- `usable` BOOL NOT NULL,

    PRIMARY KEY (`gift_card_code`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `SHIPPERS`(
    `shipper_id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,

    PRIMARY KEY (`shipper_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `CUSTOMER_ORDER`(
    `order_id` int NOT NULL AUTO_INCREMENT,
    `customer_id` int NOT NULL,
    `shipper_id` int  NOT NULL,
    `status_id` int  NOT NULL,
    `created_on` date NOT NULL,
    `delivered_on` date NOT NULL,
    `gift_card_code` int,
    `gift_balance_used` int,
    `bill_name` varchar(50) NOT NULL,
    `bill_address` varchar(50) NOT NULL,
    `bill_city` varchar(50) NOT NULL,
    `bill_state` char(2) NOT NULL,
    `bill_zipcode` int NOT NULL,
    `bill_card_number` int NOT NULL,
    -- `bill_expires_on` date NOT NULL, -- (date several years from created_on date) triggers obsolete flag to be true for this order
    -- `obsolete` BOOL NOT NULL, -- default 0 ?
    `bill_cvc` int NOT NULL,
    `ship_name` varchar(50) NOT NULL,
    `ship_address` varchar(50) NOT NULL,
    `ship_city` varchar(50) NOT NULL,
    `ship_state` char(2) NOT NULL,
    `ship_zipcode` int NOT NULL,

    `total_quantity` int NOT NULL, -- computed
    `total_price` decimal(8,2) NOT NULL, -- computed

    PRIMARY KEY (`order_id`),
    CONSTRAINT `CUSTOMER_ORDER_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `CUSTOMER`(`customer_id`),
    CONSTRAINT `CUSTOMER_ORDER_ibfk_2` FOREIGN KEY (`shipper_id`) REFERENCES `SHIPPERS`(`shipper_id`),
    CONSTRAINT `CUSTOMER_ORDER_ibfk_3` FOREIGN KEY (`status_id`) REFERENCES `ORDER_STATUS`(`order_status_id`),
    CONSTRAINT `CUSTOMER_ORDER_ibfk_4` FOREIGN KEY (`gift_card_code`) REFERENCES `GIFT_CARD`(`gift_card_code`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `EMPLOYEE`(
    `employee_id` int NOT NULL AUTO_INCREMENT,
    `job_title` varchar(50) NOT NULL, -- admin, newsletter, verifier (default; adds to inventory)
    `username` varchar(30) NOT NULL,
    `password` varchar(30) NOT NULL,
    `email` varchar(100) NOT NULL,
    `phone` varchar(15) NOT NULL,
    `fname` varchar(50) NOT NULL,
    `lname` varchar(50) NOT NULL,
    `addressLine1` varchar(50) NOT NULL,
    `addressLine2` varchar(50),
    `city` varchar(50) NOT NULL,
    `state` char(2) NOT NULL,
    `zipcode` int NOT NULL,

    `deleted` BOOL NOT NULL, -- flag for deletion (not actually deleted), default 0 ?

    PRIMARY KEY (`employee_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `SUPPLIER`(
    `supplier_id` int NOT NULL AUTO_INCREMENT,
    `supplier_name` varchar(50) NOT NULL,
    `email` varchar(100) NOT NULL,
    `phone` varchar(15) NOT NULL,

    PRIMARY KEY (`supplier_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `SUPPLIER_ORDER`(
    `supplier_order_id` int NOT NULL AUTO_INCREMENT,
    `supplier_id` int NOT NULL,
    `created_on` date NOT NULL,
    `shipper_id` int NOT NULL,
    `status_id` int NOT NULL,
    
    `total_quantity` int NOT NULL, -- computed
    `total_price` decimal(8,2) NOT NULL, -- computed
    
    PRIMARY KEY (`supplier_order_id`),
    CONSTRAINT `SUPPLIER_ORDER_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `SUPPLIER`(`supplier_id`),
    CONSTRAINT `SUPPLIER_ORDER_ibfk_2` FOREIGN KEY (`shipper_id`) REFERENCES `SHIPPERS`(`shipper_id`),
    CONSTRAINT `SUPPLIER_ORDER_ibfk_3` FOREIGN KEY (`status_id`) REFERENCES `ORDER_STATUS`(`order_status_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `INVENTORY`(
    `product_id` int NOT NULL AUTO_INCREMENT,
    `product_name` varchar(50) NOT NULL,
    `product_type` enum('videogame','console', 'accessory') NOT NULL,
    `product_description` text,
    `quantity_in_stock` int NOT NULL, -- will probably trigger a SUPPLIER_ORDER if its quantity gets low
    `deleted` BOOL NOT NULL, -- flag for deletion (not actually deleted), default 0 ?
    `unit_price` decimal(6,2) NOT NULL, -- should be greater than corresponding supplier_order_item's unit_price
    `image_source` text,

    `number_of_ratings` int NOT NULL, -- Default 0 ?
    `average_rating` int, -- will be computed, may need to be in a trigger (when number_of_ratings changes)

    PRIMARY KEY (`product_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- DEAL: Could be removed if time does not allow
CREATE TABLE `DEAL`(
    `deal_id` int NOT NULL AUTO_INCREMENT,
    `product_id` int NOT NULL,
    `deal_code` varchar(25) NOT NULL,
    `deal_percent_off` decimal(6,4) NOT NULL,
    `deal_price_off` decimal(6,2) NOT NULL,
    `unit_price` decimal(6,2) NOT NULL,
    `active` BOOL NOT NULL, -- default 0?
    `start_date` date NOT NULL, -- triggers active flag to be true, should be on or after date inserted
    `end_date` date, -- triggers active flag to be false

    PRIMARY KEY (`deal_id`),
    KEY `deal_code` (`deal_code`),
    CONSTRAINT `DEAL_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `INVENTORY`(`product_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PRODUCT_RATING: Could be removed if time does not allow
CREATE TABLE `PRODUCT_RATING`(
    `rating_id` int NOT NULL AUTO_INCREMENT,
    `product_id` int NOT NULL,
    `customer_id` int NOT NULL, -- note: rating could be altered/deleted by this customer
    `created_on` date NOT NULL,
    `stars` int NOT NULL, -- alternatively: enum(1, 1.5, 2, 2.5, ..., 5)

    PRIMARY KEY (`rating_id`),
    CONSTRAINT `PRODUCT_RATING_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `INVENTORY`(`product_id`),
    CONSTRAINT `PRODUCT_RATING_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `CUSTOMER`(`customer_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `CUSTOMER_ORDER_ITEM`(
    `order_item_id` int NOT NULL AUTO_INCREMENT,
    `order_id` int  NOT NULL,
    `product_id` int NOT NULL,
    `quantity` int NOT NULL,
    `unit_price` int NOT NULL, -- computed according to the unit_price & deal of the product
    `deal_code` varchar(25), -- will apply a deal's discount to the item if not null
    `profit` decimal(8,2) NOT NULL, -- computed based on SUPPLIER_ORDER_ITEM corresponding product's `unit_price`*`quantity` (-) and this item's `unit_price`*`quantity` (+)

    PRIMARY KEY (`order_item_id`),
    CONSTRAINT `CUSTOMER_ORDER_ITEM_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `CUSTOMER_ORDER`(`order_id`),
    CONSTRAINT `CUSTOMER_ORDER_ITEM_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `INVENTORY`(`product_id`),
    CONSTRAINT `CUSTOMER_ORDER_ITEM_ibfk_3` FOREIGN KEY (`deal_code`) REFERENCES `DEAL`(`deal_code`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `SUPPLIER_ORDER_ITEM`(
    `supplier_order_item_id` int NOT NULL AUTO_INCREMENT,
    `supplier_order_id` int  NOT NULL,
    `product_id` int NOT NULL,
    `quantity` int NOT NULL,
    `unit_price` decimal(6,2) NOT NULL, -- computed, will be according to supplier's cost, should be less than product's unit_price
    -- (since there's no actual supplier, make it about 1 dollar less than unit_price, but > 0)

    PRIMARY KEY (`supplier_order_item_id`),
    CONSTRAINT `SUPPLIER_ORDER_ITEM_ibfk_1` FOREIGN KEY (`supplier_order_id`) REFERENCES `SUPPLIER_ORDER`(`supplier_order_id`),
    CONSTRAINT `SUPPLIER_ORDER_ITEM_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `INVENTORY`(`product_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `LOGGED_ITEM`(
    `log_id` int NOT NULL AUTO_INCREMENT,
    `employee_id` int NOT NULL, -- an employee will submit this data after reviewing it
    `product_id` int NOT NULL,
    `supplier_order_item_id` int NOT NULL,
    `quantity` int NOT NULL, -- based on supplier_order_item's `quantity`, may be unnecessary?
    `logged_on` date NOT NULL,

    PRIMARY KEY (`log_id`),
    CONSTRAINT `LOGGED_ITEM_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `EMPLOYEE`(`employee_id`),
    CONSTRAINT `LOGGED_ITEM_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `INVENTORY`(`product_id`),
    CONSTRAINT `LOGGED_ITEM_ibfk_3` FOREIGN KEY (`supplier_order_item_id`) REFERENCES `SUPPLIER_ORDER_ITEM`(`supplier_order_item_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `NEWSLETTER`(
    `newsletter_id` int NOT NULL AUTO_INCREMENT,
    `employee_id` int NOT NULL, -- an employee will add in this data
    `news` text NOT NULL, -- message to email
    `members_only` BOOL NOT NULL, -- 0 = to all w/ subscription, 1 = to all members w/ subscription
    `send_on` date NOT NULL, -- this date should be on or after the date inserted, will cause email trigger

    PRIMARY KEY (`newsletter_id`),
    CONSTRAINT `NEWSLETTER_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `EMPLOYEE`(`employee_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
