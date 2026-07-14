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




/* -----------------------------------------------------------------------------------------------------------------*/
PRINT '========== UDF : Calculate Order Total ==========';

SELECT
OrderID,
dbo.udf_CalculateOrderTotal(OrderID) AS CalculatedTotal
FROM Orders
WHERE OrderID<=10;

/*
Each order should return the correct calculated total
based on the associated OrderItems.
*/


/* -----------------------------------------------------------------------------------------------------------------*/
PRINT '========== UDF : Wallet Balance ==========';

SELECT
WalletID,
dbo.udf_GetWalletBalance(WalletID) AS WalletBalance
FROM Wallets
WHERE WalletID <= 10;

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
-- Check stock before

SELECT
P.ProductID,
P.StockQuantity
FROM Products P
JOIN OrderItems OI
ON P.ProductID = OI.ProductID
WHERE OI.OrderItemID = 1;

-- Increase quantity by 1

UPDATE OrderItems
SET Quantity = Quantity + 1
WHERE OrderItemID = 1;

-- Stock should decrease by 1

SELECT
P.ProductID,
P.StockQuantity
FROM Products P
JOIN OrderItems OI
ON P.ProductID = OI.ProductID
WHERE OI.OrderItemID = 1;

-- Restore original quantity

UPDATE OrderItems
SET Quantity = Quantity - 1
WHERE OrderItemID = 1;

-- Stock should return to original value

SELECT
P.ProductID,
P.StockQuantity
FROM Products P
JOIN OrderItems OI
ON P.ProductID = OI.ProductID
WHERE OI.OrderItemID = 1;

/* -----------------------------------------------------------------------------------------------------------------*/
PRINT '========== Trigger 2 ==========';
-- deactivate a product
UPDATE Products
SET IsActive=0
WHERE ProductID=1;

-- try adding it to the orderitem
INSERT INTO OrderItems
  (
  OrderID,
  ProductID,
  Quantity,
  UnitCashPrice,
  UnitPointsPrice
  )
SELECT
  1,
  ProductID,
  1,
  CashPrice,
  PointsPrice
FROM Products
WHERE ProductID = 1;

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
    ReturnStatus = 'Approved',
    ApprovedBy = 1,
    ApprovalDate = GETDATE()
WHERE ReturnID =
(
    SELECT TOP 1 ReturnID
    FROM Returns
    WHERE ReturnStatus = 'Pending'
    ORDER BY ReturnID
);

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
''EMP026'',
'Test User',
'james.smith@pointpay.com',
'ABC'
);

-- Violation of UNIQUE KEY constraint.


/* -----------------------------------------------------------------------------------------------------------------*/
PRINT '========== CHECK Constraint ==========';

INSERT INTO Returns
(OrderID,EmployeeID,ReturnReason,ReturnStatus,RequestDate)
VALUES
(1,1,'Testing','InvalidStatus',GETDATE());

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



/* -----------------------------------------------------------------------------------------------------------------*/
PRINT '========== STORED PROCEDURES ==========';

/*---------------------------------------
Place Order using XML
---------------------------------------*/

DECLARE @OrderItems XML =
'
<OrderItems>

    <Item>
        <ProductID>2</ProductID>
        <Quantity>1</Quantity>
    </Item>

    <Item>
        <ProductID>5</ProductID>
        <Quantity>2</Quantity>
    </Item>

</OrderItems>';

EXEC sp_PlaceOrder
    @EmployeeID = 1,
    @PaymentMethod = 'Mixed',
    @CashPaid = 100,
    @PointsUsed = 500,
    @OrderStatus = 'Pending',
    @OrderItems = @OrderItems;

GO

/*---------------------------------------
Approve Return
---------------------------------------*/


DECLARE @ReturnID INT;

SELECT TOP 1
    @ReturnID = ReturnID
FROM Returns
WHERE ReturnStatus = 'Pending'
ORDER BY ReturnID;

EXEC sp_ApproveReturn
    @ReturnID = @ReturnID,
    @ApprovedBy = 1;

GO

/*---------------------------------------
Redeem Points
---------------------------------------*/

EXEC sp_RedeemPoints
    @WalletID = 1,
    @Points = 500;

GO


/* -----------------------------------------------------------------------------------------------------------------*/
PRINT '========== VIEWS ==========';

SELECT TOP 5 *
FROM vw_EmployeeWalletSummary;

SELECT TOP 5 *
FROM vw_OrderSummary;

SELECT TOP 5 *
FROM vw_ProductInventory;

SELECT TOP 5 *
FROM vw_ReturnSummary;

GO


/* -----------------------------------------------------------------------------------------------------------------*/
PRINT '========== XML ==========';

/* Orders as XML */

SELECT
    O.OrderID,
    O.OrderNumber,
    E.FullName,
    dbo.udf_CalculateOrderTotal(O.OrderID) AS OrderTotal
FROM Orders O
JOIN Employees E
ON O.EmployeeID = E.EmployeeID
FOR XML PATH('Order'), ROOT('Orders');

GO

/* Products as XML */

SELECT
    ProductID,
    ProductName,
    CashPrice,
    PointsPrice
FROM Products
FOR XML PATH('Product'), ROOT('Products');

GO


/* -----------------------------------------------------------------------------------------------------------------*/
PRINT '========== INNOVATION ==========';

/* Wallet Before */

SELECT
    WalletID,
    dbo.udf_GetWalletBalance(WalletID) AS WalletBalance
FROM Wallets
WHERE WalletID = 1;

/* Redeem */

EXEC sp_RedeemPoints
    @WalletID = 1,
    @Points = 250;

/* Wallet After */

SELECT
    WalletID,
    dbo.udf_GetWalletBalance(WalletID) AS WalletBalance
FROM Wallets
WHERE WalletID = 1;

GO


PRINT CHAR(10) + '========== DATABASE TEST COMPLETED ==========';

PRINT 'All database objects executed successfully.';
