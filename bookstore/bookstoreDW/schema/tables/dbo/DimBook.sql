-- DimBook: Dimensión de libros (desnormalizada)
CREATE TABLE dbo.DimBook (
    BookKey INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT,
    Title VARCHAR(400),
    AuthorNames VARCHAR(800),
    ISBN13 VARCHAR(13),
    LanguageName VARCHAR(50),
    NumPages INT,
    PublicationDate DATE,
    PublisherName VARCHAR(400),
    IsActive BIT,
    StartDate DATE,
    EndDate DATE
);
