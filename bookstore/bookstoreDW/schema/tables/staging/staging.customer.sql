-- staging.customer: staging temporal para clientes
CREATE TABLE [staging].[customer] (
    CustomerID INT,
    FirstName VARCHAR(200),
    LastName VARCHAR(200),
    Email VARCHAR(350),
    IsActive BIT
);
