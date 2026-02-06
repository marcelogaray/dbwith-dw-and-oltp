-- DimCustomer: Dimensión de clientes
CREATE TABLE dbo.DimCustomer (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NULL,
    FirstName VARCHAR(200) NULL,
    LastName VARCHAR(200) NULL,
    Email VARCHAR(350) NULL,
    IsActive BIT NULL,
    StartDate DATE NULL,
    EndDate DATE NULL
);
