Use `Videogamestore`; 
Create Table `MEMBER`(
	`member_id` INT NOT NULL auto_increment,
    `joined_date` date,
    `member_status` bool NOT NULL,
    `renewal_date` date,
    `reward_points` int NOT NULL,
    PRIMARY KEY(member_id)
);
CREATE TABLE `CUSTOMER` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `member_id` INT,
  `username` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(11) NOT NULL,
  `fname` varchar(50) NOT NULL,
  `lname` varchar(50) NOT NULL,
  
  `AddressLine1` VARCHAR(50) NOT NULL,
  `AddressLine2` VARCHAR(50),
  `City` VARCHAR(50) NOT NULL,
  `State` VARCHAR(2) NOT NULL,
  `ZipCode` INT NOT NULL,
  `Newsletter` BOOL NOT NULL,
  PRIMARY KEY (customer_id),
  FOREIGN KEY (member_id) REFERENCES MEMBER(member_id)
);
Create Table `ORDER_STATUS`(
	`order_status_id` INT NOT NULL auto_increment,
    `paid` BOOL NOT NULL,
    `shipped` BOOL NOT NULL,
    `delivered` BOOL NOT NULL,
    `cancelled` BOOL NOT NULL,
    
    PRIMARY KEY (order_status_id)
);
CREATE TABLE `GIFT_CARD`(
	`gift_card_code` INT NOT NULL auto_increment,
    `balance` double NOT NULL,
    `start_date` date NOT NULL,
    `end_date` date NOT NULL,
    
    primary key (gift_card_code)
);
CREATE TABLE `SHIPPERS`(
	`shipper_id` INT NOT NULL auto_increment,
    `name` varchar(50) NOT NULL,
    
    primary key (shipper_id)
);
CREATE TABLE `CUSTOMER_ORDER`(
	`order_id` INT NOT NULL auto_increment,
    `customer_id` INT NOT NULL,
    `shipper_id` INT  NOT NULL,
    `status_id` INT  NOT NULL,
    `created_on` date NOT NULL,
    `delivered_on` date NOT NULL,
    `gift_card_code` INT,
    `gift_balance_used` INT,
    `bill_name` varchar(50) NOT NULL,
    `bill_address` varchar(50) NOT NULL,
    `bill_city` varchar(50) NOT NULL,
    `bill_state` varchar(2) NOT NULL,
    `bill_zipcode` int NOT NULL,
    `bill_card_number` INT NOT NULL,
    `bill_expires_on` INT NOT NULL,
    `bill_cvc` INT NOT NULL,
    `ship_name` varchar(50) NOT NULL,
    `ship_address` varchar(50) NOT NULL,
    `ship_city` varchar(50) NOT NULL,
    `ship_state` varchar(2) NOT NULL,
    `ship_zipcode` int NOT NULL,
    
    `total_quantity` int NOT NULL,
    `total_price` double NOT NULL,
    
    primary key (order_id),
    foreign key (customer_id) REFERENCES CUSTOMER(customer_id),
    foreign key (shipper_id) REFERENCES SHIPPERS(shipper_id),
    foreign key (status_id) REFERENCES ORDER_STATUS(order_status_id),
    foreign key (gift_card_code) REFERENCES GIFT_CARD(gift_card_code)
);
CREATE TABLE `EMPLOYEE`(
	`employee_id` INT NOT NULL auto_increment,
    `title` varchar(50) NOT NULL,
    `password` varchar(30) NOT NULL,
	`email` varchar(100) NOT NULL,
	`phone` varchar(11) NOT NULL,
	`fname` varchar(50) NOT NULL,
	`lname` varchar(50) NOT NULL,
	`AddressLine1` VARCHAR(50) NOT NULL,
	`AddressLine2` VARCHAR(50),
	`City` VARCHAR(50) NOT NULL,
	`State` VARCHAR(2) NOT NULL,
	`ZipCode` INT NOT NULL,
    
    primary key (employee_id)
);

CREATE TABLE `SUPPLIER`(
	`supplier_id` INT NOT NULL AUTO_INCREMENT,
    `supplier_name` VARCHAR(50) NOT NULL,
    `Email` VARCHAR(30) NOT NULL,
    `phone` varchar(11) NOT NULL,

    PRIMARY KEY (supplier_id)    
);
CREATE TABLE `SUPPLIER_ORDER`(
	`supplier_order_id` INT NOT NULL auto_increment,
	`supplier_id` INT NOT NULL,
	`created_on` date NOT NULL,
    `total_quantity` INT NOT NULL,
    `shipper_id` INT NOT NULL,
    `status_id` INT NOT NULL,
    
    primary key (supplier_order_id),
    FOREIGN KEY (supplier_id) REFERENCES SUPPLIER(supplier_id),
    FOREIGN KEY (shipper_id) REFERENCES SHIPPERS(shipper_id),
    foreign key (status_id) References ORDER_STATUS(order_status_id)
);
CREATE TABLE `INVENTORY`(
	`product_id` INT NOT NULL auto_increment,
    `product_name` varchar(50) NOT NULL,
    `product_type` INT NOT NULL,
    `product_description` text,
    `quantity_in_stock` INT NOT NULL,
    `unit_price` double NOT NULL,
    `image_source` text,
    `number_of_ratings` INT NOT NULL,
    `average_rating` INT NOT NULL,
    
    primary key (product_id)
);
CREATE TABLE `DEAL`(
	`deal_id` INT NOT NULL auto_increment,
    `product_id` int NOT NULL,
    `deal_code` varchar(25) NOT NULL,
    `is_deal_percent` BOOL NOT NULL,
    `deal_percent` INT,
    `deal_off` INT,
    `start_date` date NOT NULL,
    `end_date` date,
    
    primary key (deal_id),
    foreign key (product_id) REFERENCES INVENTORY(product_id)
);
CREATE TABLE `PRODUCT_RATING`(
	`rating_id` INT NOT NULL AUTO_INCREMENT,
    `product_id` INT NOT NULL,
    `customer_id` INT NOT NULL,
    `created_on` date NOT NULL,
    `stars` INT NOT NULL,
    
    primary key (rating_id),
    foreign key (product_id) REFERENCES INVENTORY(product_id),
    foreign key (customer_id) REFERENCES CUSTOMER(customer_id)
);
CREATE TABLE `CUSTOMER_ORDER_ITEM`(
	`order_item_id` INT NOT NULL AUTO_INCREMENT,
    `order_id` INT  NOT NULL,
    `product_id` INT NOT NULL,
    `quantity` INT NOT NULL,
    `deal_code` varchar(25),
    `sub_total` double NOT NULL,
    
    primary key (order_item_id),
    foreign key (order_id) REFERENCES CUSTOMER_ORDER(order_id),
    foreign key (product_id) REFERENCES INVENTORY(product_id)
);
CREATE TABLE `SUPPLIER_ORDER_ITEM`(
	`supplier_order_item_id` INT NOT NULL AUTO_INCREMENT,
    `supplier_order_id` INT  NOT NULL,
    `product_id` INT NOT NULL,
    `quantity` INT NOT NULL,
    `unit_price` double NOT NULL,
    `sub_total` double NOT NULL,
    
    primary key (supplier_order_item_id),
    foreign key (supplier_order_id) REFERENCES SUPPLIER_ORDER(supplier_order_id),
    foreign key (product_id) REFERENCES INVENTORY(product_id)
);
CREATE TABLE `LOGGED_ITEM`(
	`employee_log_id` INT NOT NULL auto_increment,
    `employee_id` INT NOT NULL,
    `product_id` INT NOT NULL,
    `supplier_order_item_id` INT NOT NULL,
    `quantity` INT NOT NULL,
    `created_on` date NOT NULL,
    
    primary key (employee_log_id),
    foreign key (employee_id) REFERENCES EMPLOYEE(employee_id),
    foreign key (product_id) REFERENCES INVENTORY(product_id),
    foreign key (supplier_order_item_id) references SUPPLIER_ORDER_ITEM(supplier_order_item_id)
);

