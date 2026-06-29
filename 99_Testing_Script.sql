-- Use the database
USE PointPay;
GO
/* -----------------------------------------------------------------------------------------------------------------*/
PRINT '========== TABLE ROW COUNTS ==========';

SELECT COUNT(*) AS Employees FROM Employees;
SELECT COUNT(*) AS Wallets FROM Wallets;
SELECT COUNT(*) AS Products FROM Products;
SELECT COUNT(*) AS Orders FROM Orders;
SELECT COUNT(*) AS OrderItems FROM OrderItems;
SELECT COUNT(*) AS WalletTransactions FROM WalletTransactions;
SELECT COUNT(*) AS Returns FROM Returns;

/*
Employees          50
Wallets            50
Products           50
Orders             100
OrderItems         modified count
WalletTransactions modified count
Returns            20 */


/* -----------------------------------------------------------------------------------------------------------------*/
PRINT '========== UDF : Calculate Order Total ==========';

SELECT
OrderID,
TotalAmount,
dbo.udf_CalculateOrderTotal(OrderID) AS CalculatedTotal
FROM Orders
WHERE OrderID<=10;

/* For every row it ust give 
TotalAmount = CalculatedTotal   */


/* -----------------------------------------------------------------------------------------------------------------*/
PRINT '========== UDF : Wallet Balance ==========';

SELECT
EmployeeID,
dbo.udf_GetWalletBalance(EmployeeID) AS WalletBalance
FROM Employees
WHERE EmployeeID<=10;

/* 
actual balances
*/


/* -----------------------------------------------------------------------------------------------------------------*/
PRINT '========== UDF : Product Availability ==========';

SELECT
ProductID,
ProductName,
dbo.udf_IsProductAvailable(ProductID,1) AS Available
FROM Products
WHERE ProductID<=10;

/* mostly 1 */



/* -----------------------------------------------------------------------------------------------------------------*/
PRINT '========== Trigger 1 ==========';
-- TotalAmount increases automatically.
SELECT
OrderID,
TotalAmount
FROM Orders
WHERE OrderID=1;

UPDATE OrderItems
SET Quantity=Quantity+1
WHERE OrderItemID=1;


SELECT
OrderID,
TotalAmount
FROM Orders
WHERE OrderID=1;

-- reset the change 
UPDATE OrderItems
SET Quantity=Quantity-1
WHERE OrderItemID=1;

/* -----------------------------------------------------------------------------------------------------------------*/
PRINT '========== Trigger 2 ==========';
-- deactivate a product
UPDATE Products
SET IsActive=0
WHERE ProductID=1;

-- try adding it to the orderitem
INSERT INTO OrderItems
(OrderID,ProductID,Quantity,UnitCashPrice,UnitPointsPrice)
VALUES
(1,1,1,95,950);

-- expected : Product is inactive or insufficient stock available.

-- reset the change 
UPDATE Products
SET IsActive=1
WHERE ProductID=1;

/* -----------------------------------------------------------------------------------------------------------------*/
PRINT '========== Trigger 3 ==========';

-- managing the returns
SELECT
COUNT(*) AS RefundTransactions
FROM WalletTransactions
WHERE TransactionType='Refund';
-- check the ciunt of refund transactions

--update one of the refunds status to approved
UPDATE Returns
SET
ReturnStatus='Approved',
ApprovedBy=1,
ApprovalDate=GETDATE()
WHERE ReturnID=11;

-- see the count or result 
SELECT
COUNT(*) AS RefundTransactions
FROM WalletTransactions
WHERE TransactionType='Refund';

--Count increases by 1.

-- the exact transaction created 
SELECT TOP 1 *
FROM WalletTransactions
WHERE TransactionType='Refund'
ORDER BY TransactionID DESC;



/* -----------------------------------------------------------------------------------------------------------------*/
PRINT '========== PK Constraint ==========';

INSERT INTO Employees
(
EmployeeID,
EmployeeCode,
FullName,
Email,
PasswordHash
)
VALUES
(
1,
'EMP001',
'Duplicate',
'duplicate@pointpay.com',
'ABC'
);

-- Violation of PRIMARY KEY constraint.


/* -----------------------------------------------------------------------------------------------------------------*/
PRINT '========== UNIQUE Constraint ==========';

INSERT INTO Employees
(
EmployeeCode,
FullName,
Email,
PasswordHash
)
VALUES
(
'EMP051',
'Test User',
'james.smith@pointpay.com',
'ABC'
);

-- Violation of UNIQUE KEY constraint.


/* -----------------------------------------------------------------------------------------------------------------*/
PRINT '========== CHECK Constraint ==========';

INSERT INTO Returns
(
OrderID,
EmployeeID,
ReturnReason,
RefundPoints,
ReturnStatus,
RequestDate
)
VALUES
(
1,
1,
'Testing',
100,
'InvalidStatus',
GETDATE()
);

-- CHECK constraint violation.


/* -----------------------------------------------------------------------------------------------------------------*/

PRINT '========== FK Constraint ==========';

INSERT INTO Wallets
(
EmployeeID
)
VALUES
(
999
);

-- Foreign key violation.

/* -----------------------------------------------------------------------------------------------------------------*/
PRINT '========== FINAL SUMMARY ==========';

SELECT

(SELECT COUNT(*) FROM Employees) AS Employees,

(SELECT COUNT(*) FROM Wallets) AS Wallets,

(SELECT COUNT(*) FROM Products) AS Products,

(SELECT COUNT(*) FROM Orders) AS Orders,

(SELECT COUNT(*) FROM OrderItems) AS OrderItems,

(SELECT COUNT(*) FROM WalletTransactions) AS WalletTransactions,

(SELECT COUNT(*) FROM Returns) AS Returns;
