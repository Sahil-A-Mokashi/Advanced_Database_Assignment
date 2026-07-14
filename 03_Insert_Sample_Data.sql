/*==========================================================
INSERT DATA : Employees

Source:
- U.S. Census Bureau - Frequently Occurring Surnames
- U.S. Social Security Administration - Popular Baby Names

pdf in the link -https://www.census.gov/topics/population/genealogy/data/2020_names.html

Names are used only as fictional sample data for educational purposes.
Initial password for all users: Password@123
Stored using SHA2-256 hashing.
==========================================================*/
-- Use the database
USE PointPay;
GO

INSERT INTO Employees
(
    EmployeeCode,
    FullName,
    Email,
    PasswordHash
)
VALUES

('EMP001','James Smith','james.smith@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP002','Mary Johnson','mary.johnson@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP003','Robert Williams','robert.williams@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP004','Patricia Brown','patricia.brown@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP005','John Jones','john.jones@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP006','Jennifer Garcia','jennifer.garcia@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP007','Michael Miller','michael.miller@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP008','Linda Davis','linda.davis@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP009','William Rodriguez','william.rodriguez@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP010','Elizabeth Martinez','elizabeth.martinez@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),

('EMP011','David Hernandez','david.hernandez@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP012','Barbara Lopez','barbara.lopez@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP013','Richard Gonzalez','richard.gonzalez@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP014','Susan Wilson','susan.wilson@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP015','Joseph Anderson','joseph.anderson@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP016','Jessica Thomas','jessica.thomas@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP017','Thomas Taylor','thomas.taylor@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP018','Sarah Moore','sarah.moore@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP019','Charles Jackson','charles.jackson@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP020','Karen Martin','karen.martin@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),

('EMP021','Christopher Lee','christopher.lee@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP022','Nancy Perez','nancy.perez@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP023','Daniel Thompson','daniel.thompson@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP024','Lisa White','lisa.white@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2)),
('EMP025','Matthew Harris','matthew.harris@pointpay.com',CONVERT(VARCHAR(64),HASHBYTES('SHA2_256','Password@123'),2));

GO

/*==========================================================
UPDATE DATA : Employees
Adds realistic account activity for demonstration purposes
==========================================================*/

-- Different Last Login dates
UPDATE Employees
SET LastLogin = DATEADD(DAY, -2, GETDATE())
WHERE EmployeeID BETWEEN 1 AND 10;

UPDATE Employees
SET LastLogin = DATEADD(DAY, -7, GETDATE())
WHERE EmployeeID BETWEEN 11 AND 20;



-- Employees who recently entered incorrect passwords
UPDATE Employees
SET FailedAttempts = 2
WHERE EmployeeID IN (8, 19);

UPDATE Employees
SET FailedAttempts = 4
WHERE EmployeeID = 20;


-- One employee temporarily locked
UPDATE Employees
SET FailedAttempts = 5,
    LockUntil = DATEADD(MINUTE,15,GETDATE())
WHERE EmployeeID = 14;


-- Three employees have left the company
UPDATE Employees
SET IsActive = 0
WHERE EmployeeID IN (12);


-- Employees with no previous login (new joiners)
UPDATE Employees
SET LastLogin = NULL
WHERE EmployeeID IN (15);

GO

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*==========================================================
INSERT DATA : Wallets

Each employee is assigned exactly one wallet.
Wallet creation dates are spread across April–June 2026
to simulate employees joining over time.
==========================================================*/

INSERT INTO Wallets
(
    EmployeeID,
    CreatedAt,
    UpdatedAt
)
VALUES

(1,'2026-04-01','2026-04-01'),
(2,'2026-04-02','2026-04-02'),
(3,'2026-04-03','2026-04-03'),
(4,'2026-04-04','2026-04-04'),
(5,'2026-04-05','2026-04-05'),
(6,'2026-04-06','2026-04-06'),
(7,'2026-04-07','2026-04-07'),
(8,'2026-04-08','2026-04-08'),
(9,'2026-04-09','2026-04-09'),
(10,'2026-04-10','2026-04-10'),

(11,'2026-04-15','2026-04-15'),
(12,'2026-04-16','2026-04-16'),
(13,'2026-04-17','2026-04-17'),
(14,'2026-04-18','2026-04-18'),
(15,'2026-04-19','2026-04-19'),
(16,'2026-04-20','2026-04-20'),
(17,'2026-04-21','2026-04-21'),
(18,'2026-04-22','2026-04-22'),
(19,'2026-04-23','2026-04-23'),
(20,'2026-04-24','2026-04-24'),

(21,'2026-05-01','2026-05-01'),
(22,'2026-05-02','2026-05-02'),
(23,'2026-05-03','2026-05-03'),
(24,'2026-05-04','2026-05-04'),
(25,'2026-05-05','2026-05-05');

GO

/*--------------------------------------------------------------------------------------------------------*/
/*==========================================================
INSERT DATA : Products

Source:
Product catalogue inspired by publicly available employee
rewards platforms and retail catalogues including.

Prices are approximate retail values and are used only
for educational purposes.

link to the dataset- https://www.kaggle.com/datasets/supratimnag06/shop-product-catalog
==========================================================*/

INSERT INTO Products
(
    ProductName,
    SKU,
    CashPrice,
    PointsPrice,
    StockQuantity,
    IsActive
)
VALUES

('Logitech MX Master 3S Mouse','PP001',95.00,950,35,1),
('Logitech K380 Keyboard','PP002',42.00,420,40,1),
('Sony WH-CH720N Headphones','PP003',109.00,1090,20,1),
('JBL Flip 6 Bluetooth Speaker','PP004',119.00,1190,18,1),
('Apple AirTag','PP005',39.00,390,60,1),
('Stanley Quencher Tumbler','PP006',45.00,450,45,1),
('Anker Power Bank 20000mAh','PP007',49.00,490,32,1),
('Dell EcoLoop Backpack','PP008',59.00,590,24,1),
('Kindle Paperwhite','PP009',169.00,1690,15,1),
('Garmin Vivosmart 5','PP010',189.00,1890,10,1),

('Logitech Brio Webcam','PP011',129.00,1290,22,1),
('BenQ ScreenBar Monitor Lamp','PP012',109.00,1090,18,1),
('Samsung T7 Portable SSD 1TB','PP013',119.00,1190,26,1),
('Logitech G305 Gaming Mouse','PP014',49.00,490,34,1),
('SteelSeries QcK Mouse Pad','PP015',20.00,200,55,1),
('Herman Miller Office Chair Voucher','PP016',250.00,2500,8,1),
('Dell 24-inch Monitor','PP017',179.00,1790,16,1),
('Anker USB-C Hub','PP018',55.00,550,38,1),
('Moleskine Notebook Set','PP019',25.00,250,60,1),
('Hydro Flask Water Bottle','PP020',35.00,350,50,1);

GO
/*-----------------------------------------------------------------------------------------------------------------------*/

/*==========================================================
INSERT DATA : Orders 
==========================================================*/

INSERT INTO Orders
(
    EmployeeID,
    OrderNumber,
    PaymentMethod,
    OrderStatus,
    OrderDate
)
VALUES

(1,'ORD1001','Cash','Completed','2026-04-03'),
(2,'ORD1002','Points','Completed','2026-04-04'),
(3,'ORD1003','Mixed','Completed','2026-04-05'),
(4,'ORD1004','Cash','Completed','2026-04-06'),
(5,'ORD1005','Points','Completed','2026-04-06'),

(6,'ORD1006','Mixed','Completed','2026-04-08'),
(7,'ORD1007','Cash','Completed','2026-04-09'),
(8,'ORD1008','Points','Completed','2026-04-10'),
(9,'ORD1009','Mixed','Completed','2026-04-11'),
(10,'ORD1010','Cash','Completed','2026-04-12'),

(11,'ORD1011','Points','Completed','2026-04-13'),
(12,'ORD1012','Mixed','Completed','2026-04-14'),
(13,'ORD1013','Cash','Completed','2026-04-15'),
(14,'ORD1014','Points','Completed','2026-04-16'),
(15,'ORD1015','Mixed','Completed','2026-04-17'),

(21,'ORD1071','Cash','Cancelled','2026-06-13'),
(22,'ORD1072','Points','Cancelled','2026-06-14'),
(23,'ORD1073','Mixed','Cancelled','2026-06-15'),
(24,'ORD1074','Cash','Cancelled','2026-06-16'),
(25,'ORD1075','Points','Cancelled','2026-06-17'),

(21,'ORD1091','Cash','Pending','2026-06-25'),
(22,'ORD1092','Points','Pending','2026-06-26'),
(23,'ORD1093','Mixed','Pending','2026-06-26'),
(24,'ORD1094','Cash','Pending','2026-06-27'),
(25,'ORD1095','Points','Pending','2026-06-27');



GO


/*-----------------------------------------------------------------------------------*/
/*==========================================================
INSERT DATA : OrderItems 
==========================================================*/


INSERT INTO OrderItems
(
    OrderID,
    ProductID,
    Quantity,
    UnitCashPrice,
    UnitPointsPrice
)
VALUES

-- ORD1001
(1,1,1,95.00,950),
(1,2,1,42.00,420),

-- ORD1002
(2,3,1,109.00,1090),

-- ORD1003
(3,1,1,95.00,950),
(3,7,1,49.00,490),

-- ORD1004
(4,4,1,119.00,1190),

-- ORD1005
(5,9,1,169.00,1690),

-- ORD1006
(6,6,2,45.00,450),
(6,8,1,59.00,590),

-- ORD1007
(7,5,1,39.00,390),

-- ORD1008
(8,11,1,129.00,1290),

-- ORD1009
(9,10,1,189.00,1890),
(9,14,1,49.00,490),

-- ORD1010
(10,17,1,179.00,1790),

-- ORD1011
(11,18,1,55.00,550),

-- ORD1012
(12,9,1,169.00,1690),
(12,19,1,25.00,250),
(12,20,1,35.00,350),

-- ORD1013
(13,13,1,119.00,1190),

-- ORD1014
(14,12,1,109.00,1090),

-- ORD1015
(15,16,1,250.00,2500),

-- ORD1071
(16,5,1,39.00,390),

-- ORD1072
(17,8,1,59.00,590),

-- ORD1073
(18,15,2,20.00,200),

-- ORD1074
(19,6,1,45.00,450),
(19,2,1,42.00,420),

-- ORD1075
(20,4,1,119.00,1190),

-- ORD1091
(21,3,1,109.00,1090),

-- ORD1092
(22,18,1,55.00,550),

-- ORD1093
(23,1,1,95.00,950),
(23,20,1,35.00,350),

-- ORD1094
(24,7,1,49.00,490),

-- ORD1095
(25,10,1,189.00,1890);

GO

/*-----------------------------------------------------------------------------------------*/

