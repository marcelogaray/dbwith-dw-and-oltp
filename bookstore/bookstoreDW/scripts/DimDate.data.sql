-- Carga masiva de DimDate para bookstoreDW
IF NOT EXISTS(SELECT TOP(1) 1 FROM [dbo].[DimDate])
BEGIN
    BEGIN TRAN
        DECLARE @startdate DATE = '2020-01-01',
                @enddate   DATE = '2025-01-01';
        DECLARE @datelist TABLE(FullDate DATE);

    IF @startdate IS NULL
        BEGIN
            SELECT TOP 1 @startdate = Date FROM dbo.DimDate ORDER By DateKey ASC;
        END

    WHILE (@startdate <= @enddate)
    BEGIN
        INSERT INTO @datelist(FullDate)
        SELECT @startdate
        SET @startdate = DATEADD(dd,1,@startdate);
    END

    INSERT INTO dbo.DimDate(DateKey, Date, Day, Month, Year, Quarter, DayOfWeek, MonthName, DayName)
    SELECT 
        DateKey    = CONVERT(INT,CONVERT(VARCHAR,dl.FullDate,112)),
        Date       = dl.FullDate,
        Day        = DATEPART(d,dl.FullDate),
        Month      = MONTH(dl.FullDate),
        Year       = YEAR(dl.FullDate),
        Quarter    = DATEPART(qq, dl.FullDate),
        DayOfWeek  = DATEPART(dw,dl.FullDate),
        MonthName  = DATENAME(MONTH,dl.FullDate),
        DayName    = DATENAME(WEEKDAY,dl.FullDate)
    FROM @datelist dl
    LEFT OUTER JOIN dbo.DimDate dd ON (dl.FullDate = dd.Date)
    WHERE dd.Date IS NULL;
    COMMIT TRAN
END
GO
