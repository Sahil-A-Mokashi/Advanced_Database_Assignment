/*==========================================================
UDF : Calculate Order Total
==========================================================*/

CREATE FUNCTION dbo.udf_CalculateOrderTotal
(
    @OrderID INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN

    DECLARE @Total DECIMAL(10,2);

    SELECT
        @Total = ISNULL(SUM(UnitCashPrice * Quantity),0)
    FROM OrderItems
    WHERE OrderID = @OrderID;

    RETURN @Total;

END;
GO

/*==========================================================
UDF : Calculate Wallet Balance
==========================================================*/

CREATE FUNCTION dbo.udf_GetWalletBalance
(
    @WalletID INT
)
RETURNS INT
AS
BEGIN

    DECLARE @Balance INT;

    SELECT
        @Balance =
        ISNULL(
            SUM(
                CASE
                    WHEN TransactionType IN ('Credit','Refund','Bonus')
                        THEN Points
                    ELSE -Points
                END
            ),0)
    FROM WalletTransactions
    WHERE WalletID = @WalletID;

    RETURN @Balance;

END;
GO

/*==========================================================
UDF : Check Product Availability
==========================================================*/

CREATE FUNCTION dbo.udf_IsProductAvailable
(
    @ProductID INT,
    @RequiredQuantity INT
)
RETURNS BIT
AS
BEGIN

    DECLARE @Available INT;

    SELECT
        @Available = StockQuantity
    FROM Products
    WHERE ProductID = @ProductID
      AND IsActive = 1;

    IF @Available IS NULL
        RETURN 0;

    IF @Available >= @RequiredQuantity
        RETURN 1;

    RETURN 0;

END;
GO
