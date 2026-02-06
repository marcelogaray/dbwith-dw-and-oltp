# Proyecto Bookstore BI (OLTP + DW + ETL)
Este repositorio contiene un proyecto de inteligencia de negocios basado en la base transaccional Bookstore. Incluye el esquema OLTP, un data warehouse con modelo dimensional y un proceso ETL en SSIS para cargas incrementales basadas en `rowversion`.

Presentacion: https://proyecto-bookstore-bi-p324eqw.gamma.site/

**Requisitos**
- SQL Server (2019+ recomendado) con motor de base de datos.
- Visual Studio + SSDT (SQL Server Data Tools).
- Extension de proyectos SSIS (Integration Services).
- Base de datos `Bookstore` (por ejemplo desde `Bookstore.bak`, no incluida en este repo).

**Estructura**
- `bookstore/BookStoreBI.slnx` solucion con los proyectos OLTP, DW y ETL.
- `bookstore/bookstoreOLTP.sqlproj` proyecto SSDT para OLTP.
- `bookstore/db/schema` tablas y procedimientos del OLTP.
- `bookstore/bookstoreDW/bookstoreDW.sqlproj` proyecto SSDT para el DW.
- `bookstore/bookstoreDW/schema` dimensiones, hechos, staging y SPs del DW.
- `bookstore/bookstoreETL/bookstoreETL/bookstoreETL.dtproj` proyecto SSIS con paquetes ETL.
- `bookstore/**/bin` y `bookstore/**/obj` artefactos de compilacion.

**Modelo OLTP (Bookstore)**
Catalogo de libros:
- `book`, `author`, `book_author`, `publisher`, `book_language`

Clientes y direcciones:
- `customer`, `address`, `country`, `customer_address`, `address_status`

Pedidos y envios:
- `cust_order`, `order_line`, `order_status`, `order_history`, `shipping_method`

Extraccion incremental:
- `GetDatabaseRowVersion` y `Get*ChangesByRowVersion` consultan cambios por `rowversion`.

**Data Warehouse (BookstoreDW)**
Dimensiones y hechos:
- `DimBook`, `DimCustomer`, `DimDate`, `FactOrders`

Staging:
- `staging.book`, `staging.customer`, `staging.orders`

Procedimientos:
- `DW_MergeDimBook`, `DW_MergeDimCustomer`, `DW_MergeFactOrders`
- `PopulateDimDate`
- `GetLastPackageRowVersion`, `UpdateLastPackageRowVersion`

Control de incremental:
- `PackageConfig` guarda el ultimo `rowversion` por entidad.

**Flujo ETL**
1. Extraer cambios desde el OLTP con los SPs de `rowversion`.
2. Cargar datos en tablas `staging.*` del DW.
3. Ejecutar merges hacia `DimBook` y `DimCustomer`.
4. Cargar `FactOrders` a partir de staging y claves de dimensiones.
5. Actualizar `PackageConfig` con el ultimo `rowversion`.

**Como ejecutar**
1. Restaurar la base OLTP `Bookstore` (o cargar datos equivalentes).
2. Abrir la solucion `bookstore/BookStoreBI.slnx` en Visual Studio.
3. Publicar `bookstoreOLTP.sqlproj` en una base llamada `Bookstore`.
4. Publicar `bookstoreDW.sqlproj` en una base llamada `BookstoreDW`.
5. Verificar `DimDate`. El post-deploy carga fechas 2020-01-01 a 2025-01-01. Para otro rango, ejecutar `EXEC dbo.PopulateDimDate '2020-01-01', '2030-12-31';`.
6. Inicializar `PackageConfig` si esta vacio ejecutando:
```sql
INSERT INTO dbo.PackageConfig (TableName, LastRowVersion)
VALUES ('DimBook', 0), ('DimCustomer', 0), ('FactOrders', 0);
```
7. Abrir `bookstoreETL/bookstoreETL/bookstoreETL.dtproj`.
8. Actualizar las conexiones `CM.Source.Bookstore` y `CM.Destination.BookstoreDW` a tu instancia.
9. Ejecutar paquetes en orden: `ETLDimBook`, `ETLDimCustomer`, `ETLFactOrder`.

**Verificacion rapida**
- `SELECT COUNT(*) FROM dbo.DimBook;`
- `SELECT COUNT(*) FROM dbo.DimCustomer;`
- `SELECT COUNT(*) FROM dbo.FactOrders;`

**Notas**
- `bookstore/bookstoreDW/scripts/PackageConfig.data.sql` no coincide con la tabla `PackageConfig` actual. Ajustar antes de usar.
- Los paquetes SSIS contienen nombres de servidor locales (ej. `DESKTOP-*`), se deben actualizar.

**Integrantes**
- Eynar Pari
- Marcelo Garay
- Sheyla Camila Carrillo
- Agustin Acebo Pedraza
