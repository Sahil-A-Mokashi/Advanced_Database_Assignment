-- =============================================
-- PointPay Database
-- Table Creation Script
-- =============================================

USE PointPay;
GO

/*==========================================================
TABLE : Employees
==========================================================*/

CREATE TABLE Employees
(
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,

    EmployeeCode VARCHAR(20) NOT NULL UNIQUE,

    FullName VARCHAR(100) NOT NULL,

    Email VARCHAR(100) NOT NULL UNIQUE,

    PasswordHash VARCHAR(255) NOT NULL,

    IsActive BIT NOT NULL DEFAULT 1,

    FailedAttempts INT NOT NULL DEFAULT 0,

    LockUntil DATETIME NULL,

    LastLogin DATETIME NULL,

    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),

    UpdatedAt DATETIME NOT NULL DEFAULT GETDATE()
);

GO


/*==========================================================
TABLE : Wallets
One Employee -> One Wallet
==========================================================*/

CREATE TABLE Wallets
(
    WalletID INT IDENTITY(1,1) PRIMARY KEY,

    EmployeeID INT NOT NULL UNIQUE,

    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),

    UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Wallet_Employee
        FOREIGN KEY(EmployeeID)
        REFERENCES Employees(EmployeeID)
);

GO


/*==========================================================
TABLE : Products
==========================================================*/

CREATE TABLE Products
(
    ProductID INT IDENTITY(1,1) PRIMARY KEY,

    ProductName VARCHAR(150) NOT NULL,

    SKU VARCHAR(50) NOT NULL UNIQUE,

    CashPrice DECIMAL(10,2) NOT NULL,

    PointsPrice INT NOT NULL,

    StockQuantity INT NOT NULL,

    IsActive BIT NOT NULL DEFAULT 1,

    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),

    UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT CHK_Product_CashPrice
        CHECK (CashPrice >= 0),

    CONSTRAINT CHK_Product_PointsPrice
        CHECK (PointsPrice >= 0),

    CONSTRAINT CHK_Product_Stock
        CHECK (StockQuantity >= 0)
);

GO


/*==========================================================
TABLE : Orders
==========================================================*/

CREATE TABLE Orders
(
    OrderID INT IDENTITY(1,1) PRIMARY KEY,

    EmployeeID INT NOT NULL,

    OrderNumber VARCHAR(30) NOT NULL UNIQUE,

    CashPaid DECIMAL(10,2) NOT NULL DEFAULT 0,

    PointsUsed INT NOT NULL DEFAULT 0,

    PaymentMethod VARCHAR(20) NOT NULL,

    OrderStatus VARCHAR(20) NOT NULL,

    OrderDate DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Order_Employee
        FOREIGN KEY(EmployeeID)
        REFERENCES Employees(EmployeeID),

    CONSTRAINT CHK_Order_CashPaid
        CHECK (CashPaid >= 0),

    CONSTRAINT CHK_Order_Points
        CHECK (PointsUsed >= 0),

    CONSTRAINT CHK_Order_Status
        CHECK (OrderStatus IN ('Pending','Completed','Cancelled')),

    CONSTRAINT CHK_Order_PaymentMethod
        CHECK (PaymentMethod IN ('Cash','Points','Mixed'))
);

GO


/*==========================================================
TABLE : WalletTransactions
==========================================================*/

CREATE TABLE WalletTransactions
(
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,

    WalletID INT NOT NULL,

    EmployeeID INT NOT NULL,

    TransactionType VARCHAR(20) NOT NULL,

    TransactionSource VARCHAR(50) NOT NULL,

    Points INT NOT NULL,

    OrderID INT NULL,

    TransactionStatus VARCHAR(20) NOT NULL,

    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Transaction_Wallet
        FOREIGN KEY(WalletID)
        REFERENCES Wallets(WalletID),

    CONSTRAINT FK_Transaction_Employee
        FOREIGN KEY(EmployeeID)
        REFERENCES Employees(EmployeeID),

    CONSTRAINT FK_Transaction_Order
        FOREIGN KEY(OrderID)
        REFERENCES Orders(OrderID),

    CONSTRAINT CHK_Transaction_Points
        CHECK (Points > 0),
    
    CONSTRAINT CHK_Transaction_Type
        CHECK (TransactionType IN
        (
            'Credit',
            'Debit',
            'Refund',
            'Bonus',
            'Adjustment',
            'Redeem'
        )),

    CONSTRAINT CHK_Transaction_Status
        CHECK (TransactionStatus IN
        (
            'Pending',
            'Completed',
            'Cancelled'
        ))
);

GO


/*==========================================================
TABLE : OrderItems
==========================================================*/

CREATE TABLE OrderItems
(
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,

    OrderID INT NOT NULL,

    ProductID INT NOT NULL,

    Quantity INT NOT NULL,

    UnitCashPrice DECIMAL(10,2) NOT NULL,

    UnitPointsPrice INT NOT NULL,

    CONSTRAINT FK_OrderItems_Order
        FOREIGN KEY(OrderID)
        REFERENCES Orders(OrderID),

    CONSTRAINT FK_OrderItems_Product
        FOREIGN KEY(ProductID)
        REFERENCES Products(ProductID),

    CONSTRAINT CHK_OrderItems_Qty
        CHECK (Quantity > 0),

    CONSTRAINT CHK_OrderItems_Cash
        CHECK (UnitCashPrice >= 0),

    CONSTRAINT CHK_OrderItems_Points
        CHECK (UnitPointsPrice >= 0)
);

GO


/*==========================================================
TABLE : Returns
==========================================================*/

CREATE TABLE Returns
(
    ReturnID INT IDENTITY(1,1) PRIMARY KEY,

    OrderID INT NOT NULL,

    EmployeeID INT NOT NULL,

    ApprovedBy INT NULL,

    ReturnReason VARCHAR(255) NOT NULL,

    ReturnStatus VARCHAR(20) NOT NULL,

    RequestDate DATETIME NOT NULL DEFAULT GETDATE(),

    ApprovalDate DATETIME NULL,

    CONSTRAINT FK_Return_Order
        FOREIGN KEY(OrderID)
        REFERENCES Orders(OrderID),

    CONSTRAINT FK_Return_Employee
        FOREIGN KEY(EmployeeID)
        REFERENCES Employees(EmployeeID),

    CONSTRAINT FK_Return_Admin
        FOREIGN KEY(ApprovedBy)
        REFERENCES Employees(EmployeeID),

    CONSTRAINT CHK_Return_Status
        CHECK
        (
            ReturnStatus IN
            (
                'Pending',
                'Approved',
                'Rejected'
            )
        )
);

GO
