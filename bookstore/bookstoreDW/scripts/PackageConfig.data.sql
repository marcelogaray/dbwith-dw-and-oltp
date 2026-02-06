-- PackageConfig.data.sql para bookstoreDW
-- Datos iniciales para control de cargas incrementales ETL

-- Inicializar configuración para tablas dimensionales
INSERT INTO dbo.PackageConfig (TableName, LastRowVersion, LastLoadDate, IsActive)
VALUES 
    ('DimCustomer', 0, NULL, 1),
    ('DimProduct', 0, NULL, 1),
    ('DimStaff', 0, NULL, 1),
    ('DimStore', 0, NULL, 1),
    ('FactOrders', 0, NULL, 1);
GO
