-- DimDate: Dimensión de tiempo
CREATE TABLE dbo.DimDate (
    DateKey INT PRIMARY KEY,
    Date DATE,
    Year INT,
    Quarter INT,
    Month INT,
    MonthName VARCHAR(20),
    Day INT,
    DayOfWeek INT,
    DayName VARCHAR(20),
    WeekOfYear INT,
    IsWeekend BIT
);
