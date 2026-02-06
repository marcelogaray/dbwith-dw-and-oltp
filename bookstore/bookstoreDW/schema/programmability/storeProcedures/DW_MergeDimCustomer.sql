-- DW_MergeDimCustomer: Carga de DimCustomer desde staging
CREATE PROCEDURE [dbo].[DW_MergeDimCustomer]
AS
BEGIN
    MERGE INTO dbo.DimCustomer AS target
    USING staging.customer AS source
    ON target.CustomerID = source.CustomerID
    WHEN MATCHED THEN
        UPDATE SET
            FirstName = source.FirstName,
            LastName = source.LastName,
            Email = source.Email,
            IsActive = source.IsActive
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (CustomerID, FirstName, LastName, Email, IsActive, StartDate)
        VALUES (source.CustomerID, source.FirstName, source.LastName, source.Email, source.IsActive, GETDATE());
END;
