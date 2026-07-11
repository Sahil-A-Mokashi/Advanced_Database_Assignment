-- =============================================
-- PointPay Database
-- XML Demonstration
-- =============================================

USE PointPay;
GO

/*==========================================================
XML Example 1
Create an Order using XML
==========================================================*/

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

    <Item>
        <ProductID>10</ProductID>
        <Quantity>1</Quantity>
    </Item>

</OrderItems>';

EXEC sp_PlaceOrder
    @EmployeeID = 1,
    @PaymentMethod = 'Mixed',
    @CashPaid = 150,
    @PointsUsed = 1000,
    @OrderStatus = 'Pending',
    @OrderItems = @OrderItems;

GO

/*==========================================================
View the Newly Created Order
==========================================================*/

SELECT TOP 1
    OrderID,
    OrderNumber,
    EmployeeID,
    PaymentMethod,
    CashPaid,
    PointsUsed,
    dbo.udf_CalculateOrderTotal(OrderID) AS OrderTotal
FROM Orders
ORDER BY OrderID DESC;

GO

/*==========================================================
View the Newly Created Order Items
==========================================================*/

SELECT TOP 10
    OrderItemID,
    OrderID,
    ProductID,
    Quantity,
    UnitCashPrice,
    UnitPointsPrice
FROM OrderItems
ORDER BY OrderItemID DESC;

GO


/*==========================================================
XML Example 2
Generate Orders as XML
==========================================================*/

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
    ON O.EmployeeID = E.EmployeeID
FOR XML PATH('Order'), ROOT('Orders');

GO


/*==========================================================
XML Example 3
Generate Product Catalogue as XML
==========================================================*/

SELECT
    ProductID,
    ProductName,
    SKU,
    CashPrice,
    PointsPrice,
    StockQuantity,
    IsActive
FROM Products
FOR XML PATH('Product'), ROOT('Products');

GO


/*==========================================================
XML Example 4
Generate Wallet Transactions for an Employee as XML
==========================================================*/

SELECT
    WT.TransactionID,
    WT.TransactionType,
    WT.TransactionSource,
    WT.Points,
    WT.TransactionStatus,
    WT.CreatedAt
FROM WalletTransactions WT
WHERE WT.EmployeeID = 1
FOR XML PATH('Transaction'), ROOT('WalletTransactions');

GO
