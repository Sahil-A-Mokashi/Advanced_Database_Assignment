-- =============================================
-- PointPay Database
-- Views
-- =============================================

USE PointPay;
GO

/*==========================================================
VIEW : Employee Wallet Summary
Displays employee details with current wallet balance.
==========================================================*/

CREATE VIEW vw_EmployeeWalletSummary
AS
SELECT
    E.EmployeeID,
    E.EmployeeCode,
    E.FullName,
    W.WalletID,
    dbo.udf_GetWalletBalance(W.WalletID) AS WalletBalance
FROM Employees E
INNER JOIN Wallets W
    ON E.EmployeeID = W.EmployeeID;
GO


/*==========================================================
VIEW : Order Summary
Displays orders with calculated order totals.
==========================================================*/

CREATE VIEW vw_OrderSummary
AS
SELECT
    O.OrderID,
    O.OrderNumber,
    E.FullName,
    O.PaymentMethod,
    O.OrderStatus,
    dbo.udf_CalculateOrderTotal(O.OrderID) AS OrderTotal,
    O.OrderDate
FROM Orders O
INNER JOIN Employees E
    ON O.EmployeeID = E.EmployeeID;
GO


/*==========================================================
VIEW : Product Inventory
Displays product catalogue and stock information.
==========================================================*/

CREATE VIEW vw_ProductInventory
AS
SELECT
    ProductID,
    ProductName,
    SKU,
    CashPrice,
    PointsPrice,
    StockQuantity,
    IsActive
FROM Products;
GO


/*==========================================================
VIEW : Return Summary
Displays return requests with employee and order details.
==========================================================*/

CREATE VIEW vw_ReturnSummary
AS
SELECT
    R.ReturnID,
    E.FullName,
    O.OrderNumber,
    R.ReturnReason,
    R.ReturnStatus,
    R.RequestDate,
    R.ApprovalDate
FROM Returns R
INNER JOIN Employees E
    ON R.EmployeeID = E.EmployeeID
INNER JOIN Orders O
    ON R.OrderID = O.OrderID;
GO
