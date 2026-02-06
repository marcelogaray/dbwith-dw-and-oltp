/*
Post-Deployment Script Template for bookstoreDW
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script. 
 Use SQLCMD syntax to include a file in the post-deployment script.
 Example:      :r .\myfile.sql
 Use SQLCMD syntax to reference a variable in the post-deployment script.
 Example:      :setvar TableName MyTable
               SELECT * FROM [$(TableName)]
--------------------------------------------------------------------------------------
*/

:r .\DimDate.data.sql
-- Agrega aquí otros scripts de carga si los necesitas
