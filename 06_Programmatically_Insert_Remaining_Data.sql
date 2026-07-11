-- Use the database
USE PointPay;
GO

/*==========================================================
Wallet Transactions
Welcome Bonus
==========================================================*/

INSERT INTO WalletTransactions
(
    WalletID,
    EmployeeID,
    OrderID,
    TransactionType,
    TransactionSource,
    Points,
    TransactionStatus
)
SELECT
    WalletID,
    EmployeeID,
    NULL,
    'Credit',
    'Welcome Bonus',
    1000,
    'Completed'
FROM Wallets;

GO

/*==========================================================
Wallet Transactions
Points Redemption
==========================================================*/

INSERT INTO WalletTransactions
(
    WalletID,
    EmployeeID,
    OrderID,
    TransactionType,
    TransactionSource,
    Points,
    TransactionStatus
)
SELECT
    W.WalletID,
    O.EmployeeID,
    O.OrderID,
    'Debit',
    'Order Redemption',
    CAST(O.TotalAmount * 10 AS INT),
    'Completed'
FROM Orders O
JOIN Wallets W
ON O.EmployeeID = W.EmployeeID
WHERE
O.PaymentMethod='Points'
AND O.OrderStatus='Completed';

GO

/*==========================================================
Wallet Transactions
Mixed Payment Redemption
==========================================================*/

INSERT INTO WalletTransactions
(
    WalletID,
    EmployeeID,
    OrderID,
    TransactionType,
    TransactionSource,
    Points,
    TransactionStatus
)
SELECT
    W.WalletID,
    O.EmployeeID,
    O.OrderID,
    'Debit',
    'Order Redemption',
    CAST((O.TotalAmount/2.0)*10 AS INT),
    'Completed'
FROM Orders O
JOIN Wallets W
ON O.EmployeeID=W.EmployeeID
WHERE
O.PaymentMethod='Mixed'
AND O.OrderStatus='Completed';

GO

/*==========================================================
Wallet Transactions
Performance Bonus
==========================================================*/

INSERT INTO WalletTransactions
(
    WalletID,
    EmployeeID,
    OrderID,
    TransactionType,
    TransactionSource,
    Points,
    TransactionStatus
)
SELECT TOP 10
    WalletID,
    EmployeeID,
    NULL,
    'Bonus',
    'Performance Reward',
    500,
    'Completed'
FROM Wallets
ORDER BY EmployeeID;

GO

/*==========================================================
Wallet Transactions
Manual Adjustment
==========================================================*/

INSERT INTO WalletTransactions
(
    WalletID,
    EmployeeID,
    OrderID,
    TransactionType,
    TransactionSource,
    Points,
    TransactionStatus
)
SELECT TOP 5
    WalletID,
    EmployeeID,
    NULL,
    'Adjustment',
    'Administrative Adjustment',
    100,
    'Completed'
FROM Wallets
ORDER BY EmployeeID DESC;

GO
/*-------------------------------------------------------------------------------------
    SImulate the returns to add transactions to the wallet transactions table, 
    -insert all sample records into returns table as pending,
    -approve the first 10 and reject last 5 ,
    once we update the returns table a trigger will run, 
    only for the records that were marked as approved the trigger will create a refund transaction in wallet transactions table.
    
    -----------------------------------------------------------------------------------------*/
/*==========================================================
Returns
Insert Pending Returns
==========================================================*/

INSERT INTO Returns
(
    OrderID,
    EmployeeID,
    ApprovedBy,
    ReturnReason,
    RefundPoints,
    ReturnStatus,
    RequestDate,
    ApprovalDate
)
SELECT TOP (20)
    O.OrderID,
    O.EmployeeID,
    NULL,

    CASE (O.OrderID % 5)
        WHEN 0 THEN 'Damaged Product'
        WHEN 1 THEN 'Wrong Item Delivered'
        WHEN 2 THEN 'Changed Mind'
        WHEN 3 THEN 'Defective Product'
        ELSE 'Packaging Damage'
    END,

    CASE
        WHEN O.PaymentMethod = 'Cash'
            THEN 0

        WHEN O.PaymentMethod = 'Points'
            THEN CAST(O.TotalAmount * 10 AS INT)

        WHEN O.PaymentMethod = 'Mixed'
            THEN CAST((O.TotalAmount / 2.0) * 10 AS INT)
    END,

    'Pending',

    DATEADD(DAY,5,O.OrderDate),

    NULL

FROM Orders O

WHERE
O.OrderStatus='Completed'

ORDER BY
O.OrderID;

GO

/*==========================================================
Approve First 10 Returns
==========================================================*/

UPDATE Returns
SET
    ReturnStatus='Approved',
    ApprovedBy=1,
    ApprovalDate=GETDATE()

WHERE ReturnID BETWEEN 1 AND 10;

GO
    
/*==========================================================
Reject Last 5 Returns
==========================================================*/

UPDATE Returns
SET
    ReturnStatus='Rejected',
    ApprovedBy=1,
    ApprovalDate=GETDATE()

WHERE ReturnID BETWEEN 16 AND 20;

GO


/*-------------------------------------------------------------
if only 10 records were approved then the wallet transactions table should only give 10 re ords, 

SELECT
TransactionType,
TransactionSource,
Points,
OrderID
FROM WalletTransactions
WHERE TransactionType='Refund';

------------------------------------------------------------*/
