/*==========================================================
TRIGGER : Update Order Total
==========================================================*/

CREATE TRIGGER trg_UpdateOrderTotal
ON OrderItems
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH ChangedOrders AS
    (
        SELECT OrderID FROM inserted
        UNION
        SELECT OrderID FROM deleted
    )
    UPDATE O
    SET TotalAmount = dbo.udf_CalculateOrderTotal(O.OrderID)
    FROM Orders O
    INNER JOIN
    (
        SELECT DISTINCT OrderID
        FROM ChangedOrders
        WHERE OrderID IS NOT NULL
    ) C
        ON O.OrderID = C.OrderID;
END;
GO

/*==========================================================
TRIGGER : Check Product Availability
==========================================================*/

CREATE TRIGGER trg_CheckProductAvailability
ON OrderItems
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM inserted i
        WHERE dbo.udf_IsProductAvailable(i.ProductID, i.Quantity) = 0
    )
    BEGIN
        RAISERROR(
        'Product is inactive or insufficient stock is available.',
        16,
        1
        );

        RETURN;
    END

    INSERT INTO OrderItems
    (
        OrderID,
        ProductID,
        Quantity,
        UnitCashPrice,
        UnitPointsPrice
    )
    SELECT
        OrderID,
        ProductID,
        Quantity,
        UnitCashPrice,
        UnitPointsPrice
    FROM inserted;
END;
GO
