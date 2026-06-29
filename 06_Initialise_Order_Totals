/*==========================================================
INITIALISE ORDER TOTALS
Required only once after creating the trigger.
==========================================================*/

UPDATE Orders
SET TotalAmount = dbo.udf_CalculateOrderTotal(OrderID);

GO
