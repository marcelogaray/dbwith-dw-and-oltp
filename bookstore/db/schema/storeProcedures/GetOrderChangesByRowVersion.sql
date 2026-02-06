CREATE PROCEDURE [dbo].[GetOrderChangesByRowVersion]
(
   @startRow BIGINT,
   @endRow  BIGINT 
)
AS
BEGIN
    SELECT 
        ol.[line_id] AS OrderLineID,
        ol.[order_id] AS OrderID,
        co.[order_date] AS OrderDate,
        co.[customer_id] AS CustomerID,
        ol.[book_id] AS BookID,
        ol.[price] AS Price,
        1 AS Quantity
    FROM [dbo].[order_line] ol
    INNER JOIN [dbo].[cust_order] co ON ol.order_id = co.order_id
    WHERE (ol.[rowversion] > CONVERT(ROWVERSION, @startRow) AND ol.[rowversion] <= CONVERT(ROWVERSION, @endRow))
       OR (co.[rowversion] > CONVERT(ROWVERSION, @startRow) AND co.[rowversion] <= CONVERT(ROWVERSION, @endRow))
END
GO
