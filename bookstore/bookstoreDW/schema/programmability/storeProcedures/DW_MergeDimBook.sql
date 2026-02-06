-- DW_MergeDimBook: Carga de DimBook desde staging (desnormalizado)
CREATE PROCEDURE [dbo].[DW_MergeDimBook]
AS
BEGIN
    MERGE INTO dbo.DimBook AS target
    USING staging.book AS source
    ON target.BookID = source.BookID
    WHEN MATCHED THEN
        UPDATE SET
            Title = source.Title,
            AuthorNames = source.AuthorNames,
            ISBN13 = source.ISBN13,
            LanguageName = source.LanguageName,
            NumPages = source.NumPages,
            PublicationDate = source.PublicationDate,
            PublisherName = source.PublisherName,
            IsActive = source.IsActive
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (BookID, Title, AuthorNames, ISBN13, LanguageName, NumPages, PublicationDate, PublisherName, IsActive, StartDate)
        VALUES (source.BookID, source.Title, source.AuthorNames, source.ISBN13, source.LanguageName, source.NumPages, source.PublicationDate, source.PublisherName, source.IsActive, GETDATE());
END;
