-- DW_MergeFactOrders: Carga de FactOrders desde staging (simplificado)
CREATE PROCEDURE [dbo].[DW_MergeFactOrders]
AS
BEGIN
    INSERT INTO dbo.FactOrders (OrderLineID, OrderID, DateKey, CustomerKey, BookKey, Price, Quantity)
    SELECT 
        s.OrderLineID,
        s.OrderID,
        CAST(CONVERT(VARCHAR(8), s.OrderDate, 112) AS INT) AS DateKey,
        c.CustomerKey,
        b.BookKey,
        s.Price,
        ISNULL(s.Quantity, 1)
    FROM staging.orders s
    INNER JOIN dbo.DimCustomer c ON s.CustomerID = c.CustomerID
    INNER JOIN dbo.DimBook b ON s.BookID = b.BookID
    WHERE NOT EXISTS (
        SELECT 1 
        FROM dbo.FactOrders f 
        WHERE f.OrderLineID = s.OrderLineID
    );
END;
