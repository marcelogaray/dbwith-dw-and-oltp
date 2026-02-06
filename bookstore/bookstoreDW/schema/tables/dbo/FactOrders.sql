-- FactOrders: Tabla de hechos de ventas/pedidos (simplificada)
CREATE TABLE dbo.FactOrders (
    OrderKey INT IDENTITY(1,1) PRIMARY KEY,
    OrderLineID INT,
    OrderID INT,
    DateKey INT,
    CustomerKey INT,
    BookKey INT,
    Price DECIMAL(5,2),
    Quantity INT DEFAULT 1,
    FOREIGN KEY (DateKey) REFERENCES dbo.DimDate(DateKey),
    FOREIGN KEY (CustomerKey) REFERENCES dbo.DimCustomer(CustomerKey),
    FOREIGN KEY (BookKey) REFERENCES dbo.DimBook(BookKey)
);
