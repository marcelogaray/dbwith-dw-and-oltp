-- staging.book: staging temporal para libros (desnormalizado)
CREATE TABLE [staging].[book] (
    BookID INT,
    Title VARCHAR(400),
    AuthorNames VARCHAR(800),
    ISBN13 VARCHAR(13),
    LanguageName VARCHAR(50),
    NumPages INT,
    PublicationDate DATE,
    PublisherName VARCHAR(400),
    IsActive BIT
);
