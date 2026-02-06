# Bookstore BI Project (OLTP + DW + ETL)
This repository contains a business intelligence project based on the Bookstore transactional database. It includes the OLTP schema, a dimensional data warehouse, and an SSIS ETL process for incremental loads based on `rowversion`.

Presentation: https://proyecto-bookstore-bi-p324eqw.gamma.site/

**Requirements**
- SQL Server (2019+ recommended) with Database Engine.
- Visual Studio + SSDT (SQL Server Data Tools).
- SSIS Projects Extension (Integration Services).
- `Bookstore` database (for example from `Bookstore.bak`, not included in this repo).

**Structure**
- `bookstore/BookStoreBI.slnx` solution with OLTP, DW, and ETL projects.
- `bookstore/bookstoreOLTP.sqlproj` SSDT project for OLTP.
- `bookstore/db/schema` OLTP tables and procedures.
- `bookstore/bookstoreDW/bookstoreDW.sqlproj` SSDT project for the DW.
- `bookstore/bookstoreDW/schema` DW dimensions, facts, staging, and SPs.
- `bookstore/bookstoreETL/bookstoreETL/bookstoreETL.dtproj` SSIS project with ETL packages.
- `bookstore/**/bin` and `bookstore/**/obj` build artifacts.

**OLTP Model (Bookstore)**
Book catalog:
- `book`, `author`, `book_author`, `publisher`, `book_language`

Customers and addresses:
- `customer`, `address`, `country`, `customer_address`, `address_status`

Orders and shipping:
- `cust_order`, `order_line`, `order_status`, `order_history`, `shipping_method`

Incremental extraction:
- `GetDatabaseRowVersion` and `Get*ChangesByRowVersion` query changes by `rowversion`.

**Data Warehouse (BookstoreDW)**
Dimensions and facts:
- `DimBook`, `DimCustomer`, `DimDate`, `FactOrders`

Staging:
- `staging.book`, `staging.customer`, `staging.orders`

Procedures:
- `DW_MergeDimBook`, `DW_MergeDimCustomer`, `DW_MergeFactOrders`
- `PopulateDimDate`
- `GetLastPackageRowVersion`, `UpdateLastPackageRowVersion`

Incremental control:
- `PackageConfig` stores the last `rowversion` per entity.

**ETL Flow**
1. Extract changes from OLTP using `rowversion` SPs.
2. Load data into DW `staging.*` tables.
3. Run merges into `DimBook` and `DimCustomer`.
4. Load `FactOrders` from staging and dimension keys.
5. Update `PackageConfig` with the last `rowversion`.

**How to Run**
1. Restore the OLTP `Bookstore` database (or load equivalent data).
2. Open the solution `bookstore/BookStoreBI.slnx` in Visual Studio.
3. Publish `bookstoreOLTP.sqlproj` to a database named `Bookstore`.
4. Publish `bookstoreDW.sqlproj` to a database named `BookstoreDW`.
5. Verify `DimDate`. The post-deploy script loads dates from 2020-01-01 to 2025-01-01. For another range, run `EXEC dbo.PopulateDimDate '2020-01-01', '2030-12-31';`.
6. Initialize `PackageConfig` if it is empty by running:
```sql
INSERT INTO dbo.PackageConfig (TableName, LastRowVersion)
VALUES ('DimBook', 0), ('DimCustomer', 0), ('FactOrders', 0);
```
7. Open `bookstoreETL/bookstoreETL/bookstoreETL.dtproj`.
8. Update the connections `CM.Source.Bookstore` and `CM.Destination.BookstoreDW` to your instance.
9. Run packages in order: `ETLDimBook`, `ETLDimCustomer`, `ETLFactOrder`.

**Quick Check**
- `SELECT COUNT(*) FROM dbo.DimBook;`
- `SELECT COUNT(*) FROM dbo.DimCustomer;`
- `SELECT COUNT(*) FROM dbo.FactOrders;`

**Notes**
- `bookstore/bookstoreDW/scripts/PackageConfig.data.sql` does not match the current `PackageConfig` table. Adjust before using.
- The SSIS packages contain local server names (e.g., `DESKTOP-*`); you must update them.

**Team**
- Eynar Pari
- Marcelo Garay
- Sheyla Camila Carrillo
- Agustin Acebo Pedraza
