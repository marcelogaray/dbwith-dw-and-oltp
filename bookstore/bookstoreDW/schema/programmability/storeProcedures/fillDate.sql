-- PopulateDimDate: Stored procedure para poblar DimDate
CREATE PROCEDURE [dbo].[PopulateDimDate]
(
    @startdate DATE = '2020-01-01',
    @enddate DATE = '2030-12-31'
)
AS
BEGIN
    -- Solo llenar si está vacía
    IF NOT EXISTS(SELECT TOP(1) 1 FROM [dbo].[DimDate])
    BEGIN
        DECLARE @datelist TABLE(FullDate DATE);

        -- Generar lista de fechas
        WHILE (@startdate <= @enddate)
        BEGIN
            INSERT INTO @datelist(FullDate)
            SELECT @startdate;
            SET @startdate = DATEADD(dd, 1, @startdate);
        END

        -- Insertar en DimDate
        INSERT INTO dbo.DimDate(DateKey, Date, Day, Month, Year, Quarter, DayOfWeek, MonthName, DayName, WeekOfYear, IsWeekend)
        SELECT 
            DateKey    = CONVERT(INT, CONVERT(VARCHAR, dl.FullDate, 112)),
            Date       = dl.FullDate,
            Day        = DATEPART(d, dl.FullDate),
            Month      = MONTH(dl.FullDate),
            Year       = YEAR(dl.FullDate),
            Quarter    = DATEPART(qq, dl.FullDate),
            DayOfWeek  = DATEPART(dw, dl.FullDate),
            MonthName  = DATENAME(MONTH, dl.FullDate),
            DayName    = DATENAME(WEEKDAY, dl.FullDate),
            WeekOfYear = DATEPART(wk, dl.FullDate),
            IsWeekend  = CASE WHEN DATEPART(dw, dl.FullDate) IN (1, 7) THEN 1 ELSE 0 END
        FROM @datelist dl;
        
        PRINT 'DimDate populated with ' + CAST(@@ROWCOUNT AS VARCHAR) + ' records.';
    END
    ELSE
    BEGIN
        PRINT 'DimDate already contains data. Skipping population.';
    END
END
GO