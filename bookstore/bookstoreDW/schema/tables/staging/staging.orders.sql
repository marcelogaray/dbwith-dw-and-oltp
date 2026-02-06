-- staging.orders: staging temporal para pedidos (simplificado)
CREATE TABLE [staging].[orders] (
    OrderLineID INT,
    OrderID INT,
    OrderDate DATETIME,
    CustomerID INT,
    BookID INT,
    Price DECIMAL(5,2),
    Quantity INT DEFAULT 1
);
