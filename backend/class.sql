Use `Videogamestore`; 
CREATE TABLE `Addresses`(
	`AddressID` INT(10) NOT NULL AUTO_INCREMENT,
    `AddressLine1` VARCHAR(50) NOT NULL,
    `AddressLine2` VARCHAR(50),
    `City` VARCHAR(50) NOT NULL,
    `State` VARCHAR(2),
    `ZipCode` INT(15) NOT NULL,
    `Country` VARCHAR(50) NOT NULL,
    PRIMARY KEY (AddressID)
);
CREATE TABLE `Buyers` (
  `BuyerID` INT(10) NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `phone` varchar(11) NOT NULL,
  `AddressID` INT(10) NOT NULL,
  `fname` varchar(50) NOT NULL,
  `lname` varchar(50) NOT NULL,
  
  `Sex` varchar(1),
  `RewardPoints` INT(7),
  `JoinedOn` date,
  PRIMARY KEY (`BuyerID`),
  FOREIGN KEY (AddressID) References Addresses(AddressID)
);
CREATE TABLE `Orders` (
  `OrderID` INT(10) NOT NULL AUTO_INCREMENT,
  `BuyerID` INT(10) DEFAULT NULL,
  `IsPaymentValid` BOOL NOT NULL,
  `Payment` DOUBLE(8,2),
  `PaymentMethod` VARCHAR(15),
  `PaidOn` Date,
  `AddressID` INT(10) NOT NULL,

  PRIMARY KEY (`OrderID`),
  FOREIGN KEY (BuyerID) References Buyers(BuyerID),
  FOREIGN KEY (AddressID) References Buyers(AddressID)
);
Create Table `Employees`(
	`EmployeeID` INT(10) NOT NULL AUTO_INCREMENT,
    `Fname` VARCHAR(50) NOT NULL,
    `MiddleName` VARCHAR(50) NULL,
    `Lname` VARCHAR(50) NOT NULL,
	`Username` VARCHAR(30) NOT NULL,
    `UserPass` VARCHAR(30) NOT NULL,
    `Email` VARCHAR(30) NOT NULL,
    `Phone` varchar(11) NOT NULL,
    `AddressID` INT(10) NOT NULL,
    `Sex` VARCHAR(1),
    Primary Key (EmployeeID),
    FOREIGN KEY (AddressID) References Addresses(AddressID)
    
);
CREATE TABLE `Suppliers`(
	`SupplierID` INT(10) NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(50) NOT NULL,
    `Email` VARCHAR(30) NOT NULL,
    `phone` varchar(11) NOT NULL,
    `AddressID` INT(10) NOT NULL,
    `Description` Text,
    PRIMARY KEY (SupplierID),
    FOREIGN KEY (AddressID) References Addresses(AddressID)
    
);
CREATE TABLE `Items`(
	`ItemID` INT(10) NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(100) NOT NULL,
    `Category` VARCHAR(20) NOT NULL,
    `IsNew` BOOL NOT NULL,
    `MonetaryUnit` varchar(5),
    `Price` Double(4,2),
    `SupplyCost` Double(4,2),
    `Description` text,
    
    `SupplierID` INT(10) NOT NULL,
    `OrderID` INT(10) NULL,
    
    `AddedOn` Date,
    `AddedBy` INT(10) NOT NULL,
    `LastUpdated` Date,
    `LastUpdatedBy` INT(10) NOT NULL,
    PRIMARY KEY (`ItemID`),
    foreign key (OrderID) References Orders(OrderID),
	foreign key (SupplierID) References Suppliers(SupplierID),
    foreign key (AddedBy) References Employees(EmployeeID),
	foreign key (LastUpdatedBy) References Employees(EmployeeID)
);
Create Table `Game`(
	`GameID` INT(10) NOT NULL,
    `ItemID` INT(10) NOT NULL,
    `SystemFor` VarChar(25) NOT NULL,
    `ESRBRating` Varchar(1),
	primary key (GameID),
    Foreign key (ItemID) references Items(ItemID)
);
Create Table `GameSystem`(
	`GameSystemID` INT(10) NOT NULL,
    `ItemID` INT(10) NOT NULL,
    `Color` VarChar(25) NOT NULL,
    `StorageSpace` Varchar(1),
	primary key (GameSystemID),
    Foreign key (ItemID) references Items(ItemID)
);
Create Table `Accesory`(
	`AccesoryID` INT(10),
    `ItemID` INT(10),
    `Color` varchar(25),
    Primary Key (AccesoryID),
    Foreign key (ItemID) references Items(ItemID)
);