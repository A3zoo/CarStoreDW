/****** Object:  Database CarReportingDW    Script Date: 5/12/2024 1:47:08 PM ******/
/*
Kimball Group, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 4

You can use this Excel workbook as a data modeling tool during the logical design phase of your project.
As discussed in the book, it is in some ways preferable to a real data modeling tool during the inital design.
We expect you to move away from this spreadsheet and into a real modeling tool during the physical design phase.
The authors provide this macro so that the spreadsheet isn't a dead-end. You can 'import' into your
data modeling tool by generating a database using this script, then reverse-engineering that database into
your tool.

Uncomment the next lines if you want to drop and create the database
*/

DROP DATABASE CarReportingDW
GO
CREATE DATABASE CarReportingDW
GO
ALTER DATABASE CarReportingDW
SET RECOVERY SIMPLE
GO

USE CarReportingDW
;
IF EXISTS (SELECT Name from sys.extended_properties where Name = 'Description')
    EXEC sys.sp_dropextendedproperty @name = 'Description'
EXEC sys.sp_addextendedproperty @name = 'Description', @value = 'Default description - you should change this.'
;





-- Create a schema to hold user views (set schema name on home page of workbook).
-- It would be good to do this only if the schema doesn't exist already.
GO
CREATE SCHEMA northwind
GO






/* Drop table dbo.DimSalesPerson */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimSalesPerson') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimSalesPerson 
;

/* Create table dbo.DimSalesPerson */
CREATE TABLE dbo.DimSalesPerson (
   [EmployeeKey]  int IDENTITY  NOT NULL
,  [EmployeeID]  int   NOT NULL
,  [EmployeeName]  nvarchar(40)   NOT NULL
,  [EmployeeTitle]  nvarchar(30)   NOT NULL
,  [RowIsCurrent]  bit   DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_dbo.DimSalesPerson] PRIMARY KEY CLUSTERED 
( [EmployeeKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimSalesPerson
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'SalesPerson', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimSalesPerson
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Employee table', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimSalesPerson
;

SET IDENTITY_INSERT dbo.DimSalesPerson ON
;
INSERT INTO dbo.DimSalesPerson (EmployeeKey, EmployeeID, EmployeeName, EmployeeTitle, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', 'None', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT dbo.DimSalesPerson OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[northwind].[SalesPerson]'))
DROP VIEW [northwind].[SalesPerson]
GO
CREATE VIEW [northwind].[SalesPerson] AS 
SELECT [EmployeeKey] AS [EmployeeKey]
, [EmployeeID] AS [EmployeeID]
, [EmployeeName] AS [EmployeeName]
, [EmployeeTitle] AS [EmployeeTitle]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM dbo.DimSalesPerson
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'EmployeeKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'EmployeeKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'EmployeeID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'EmployeeID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'EmployeeName', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'EmployeeName'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'EmployeeTitle', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'EmployeeTitle'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Is Current', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Start Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row End Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Change Reason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'EmployeeKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Business key from source system (aka natural key)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'EmployeeID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Employee''s Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'EmployeeName'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Employee''s Job Title', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'EmployeeTitle'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is this the current row for this member (Y/N)?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become valid for this member?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become invalid? (12/31/9999 if current row)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Why did the row change last?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3…', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'EmployeeKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'TRUE, FALSE', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/24/2011', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/14/1998, 12/31/9999', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'EmployeeKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'EmployeeID'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'EmployeeName'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'EmployeeTitle'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimSalesPerson', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
;





/* Drop table dbo.DimCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimCustomer 
;

/* Create table dbo.DimCustomer */
CREATE TABLE dbo.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID]  nvarchar(5)   NOT NULL
,  [CompanyName]  nvarchar(40)   NOT NULL
,  [ContactName]  nvarchar(30)   NOT NULL
,  [ContactTitle]  nvarchar(30)   NOT NULL
,  [CustomerCountry]  nvarchar(15)   NOT NULL
,  [CustomerRegion]  nvarchar(15)  DEFAULT 'N/A' NOT NULL
,  [CustomerCity]  nvarchar(15)   NOT NULL
,  [CustomerPostalCode]  nvarchar(10)   NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_dbo.DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimCustomer
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Customer', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimCustomer
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Customers dimension', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimCustomer
;

SET IDENTITY_INSERT dbo.DimCustomer ON
;
INSERT INTO dbo.DimCustomer (CustomerKey, CustomerID, CompanyName, ContactName, ContactTitle, CustomerCountry, CustomerRegion, CustomerCity, CustomerPostalCode, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, 'NONE', 'No Customer', 'None', 'None', 'None', 'None', 'None', 'None', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT dbo.DimCustomer OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[northwind].[Customer]'))
DROP VIEW [northwind].[Customer]
GO
CREATE VIEW [northwind].[Customer] AS 
SELECT [CustomerKey] AS [CustomerKey]
, [CustomerID] AS [CustomerID]
, [CompanyName] AS [CompanyName]
, [ContactName] AS [ContactName]
, [ContactTitle] AS [ContactTitle]
, [CustomerCountry] AS [CustomerCountry]
, [CustomerRegion] AS [CustomerRegion]
, [CustomerCity] AS [CustomerCity]
, [CustomerPostalCode] AS [CustomerPostalCode]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM dbo.DimCustomer
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CustomerKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CustomerID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CompanyName', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ContactName', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactName'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'ContactTitle', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactTitle'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CustomerCountry', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCountry'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CustomerRegion', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerRegion'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CustomerCity', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCity'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CustomerPostalCode', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerPostalCode'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Is Current', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Start Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row End Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Row Change Reason', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Business key from source system (aka natural key)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerID'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Customer''s company Name', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Name of contact at the company', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactName'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Contact''s job title', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactTitle'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Country of origin ', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCountry'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'State or province', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerRegion'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Customer''s City', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCity'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Customer''s postal code', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerPostalCode'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is this the current row for this member (Y/N)?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become valid for this member?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'When did this row become invalid? (12/31/9999 if current row)', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Why did the row change last?', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3…', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'ALFKI', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerID'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Bon app''', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Pedro Alfanso', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactName'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Owner, Sales Rep.', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactTitle'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'USA', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCountry'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'WA', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerRegion'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Seattle', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCity'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'13244', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerPostalCode'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'TRUE, FALSE', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/24/2011', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1/14/1998, 12/31/9999', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerKey'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerID'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CompanyName'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactName'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'ContactTitle'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCountry'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerRegion'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerCity'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'CustomerPostalCode'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'n/a', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowIsCurrent'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowStartDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowEndDate'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Standard SCD-2', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCustomer', @level2type=N'COLUMN', @level2name=N'RowChangeReason'; 
;





/* Drop table dbo.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimDate 
;

/* Create table dbo.DimDate */
CREATE TABLE dbo.DimDate (
   [DateKey]  int   NOT NULL
,  [Date]  date   NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayName]  nchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  smallint   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  nchar(10)   NOT NULL
,  [MonthOfYear]  tinyint   NOT NULL
,  [Quarter]  tinyint   NOT NULL
,  [QuarterName]  nchar(10)   NOT NULL
,  [Year]  smallint   NOT NULL
,  [IsWeekday]  bit  DEFAULT 0 NOT NULL
, CONSTRAINT [PK_dbo.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimDate
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Date', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimDate
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Date dimension contains one row for every day.', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimDate
;

INSERT INTO dbo.DimDate (DateKey, Date, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsWeekday)
VALUES (-1, '', 0, 'Unk date', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, 0)
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[northwind].[Date]'))
DROP VIEW [northwind].[Date]
GO
CREATE VIEW [northwind].[Date] AS 
SELECT [DateKey] AS [DateKey]
, [Date] AS [Date]
, [DayOfWeek] AS [DayOfWeek]
, [DayName] AS [DayName]
, [DayOfMonth] AS [DayOfMonth]
, [DayOfYear] AS [DayOfYear]
, [WeekOfYear] AS [WeekOfYear]
, [MonthName] AS [MonthName]
, [MonthOfYear] AS [MonthOfYear]
, [Quarter] AS [Quarter]
, [QuarterName] AS [QuarterName]
, [Year] AS [Year]
, [IsWeekday] AS [IsWeekday]
FROM dbo.DimDate
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'DateKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DateKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Date'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'DayOfWeek', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfWeek'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'DayName', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayName'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'DayOfMonth', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfMonth'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'DayOfYear', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfYear'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'WeekOfYear', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'WeekOfYear'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'MonthName', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthName'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'MonthOfYear', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthOfYear'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Quarter', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Quarter'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'QuarterName', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'QuarterName'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Year', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Year'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'IsWeekday', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'IsWeekday'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DateKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Full date as a SQL date', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Date'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Number of the day of week; Sunday = 1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfWeek'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Day name of week, eg Monday', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayName'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Number of the day in the month', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfMonth'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Number of the day in the year', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfYear'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Week of year, 1..53', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'WeekOfYear'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Month name, eg January', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthName'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Month of year, 1..12', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthOfYear'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Calendar quarter, 1..4', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Quarter'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Quarter name eg. First', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'QuarterName'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Calendar year, eg 2010', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Year'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Is today a weekday', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'IsWeekday'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'20041123', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DateKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'38314', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Date'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1..7', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfWeek'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'Sunday', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayName'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1..31', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfMonth'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1..365', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfYear'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1..52 or 53', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'WeekOfYear'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'November', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthName'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, …, 12', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthOfYear'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3, 4', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Quarter'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'November', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'QuarterName'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'2004', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Year'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 0', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'IsWeekday'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfWeek'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayName'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfMonth'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfYear'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'WeekOfYear'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthName'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthOfYear'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Quarter'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'QuarterName'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Year'; 
exec sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'IsWeekday'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Day', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Date'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Day', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfWeek'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Day', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayName'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Day', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfMonth'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Day', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DayOfYear'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Calendar', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'WeekOfYear'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Calendar', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthName'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Calendar', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'MonthOfYear'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Calendar', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Quarter'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Calendar', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'QuarterName'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Calendar', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'Year'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Day', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'IsWeekday'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'In the form: yyyymmdd', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimDate', @level2type=N'COLUMN', @level2name=N'DateKey'; 
;





/* Drop table dbo.DimCar */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimCar') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimCar 
;

/* Create table dbo.DimCar */
CREATE TABLE dbo.DimCar (
   [CarKey]  int   NOT NULL
,  [CarID]  int   NOT NULL
,  [Price]  float   NULL
,  [Condition]  nvarchar(225)   NULL
,  [Vehicle_brand]  nvarchar(225)   NULL
,  [Vehicle_model]  float   NULL
,  [Vehicle_version]  nvarchar(225)   NULL
,  [Vehicle_generation]  nvarchar(225)   NULL
,  [Production_year]  float   NULL
,  [Mileage_km]  float   NULL
,  [Power_HP]  float   NULL
,  [Displacement_cm3]  float   NULL
,  [Fuel_type]  nvarchar(225)   NULL
,  [CO2_emissions]  float   NULL
,  [Drive]  nvarchar(225)   NULL
,  [Transmission]  nvarchar(225)   NULL
,  [Type]  nvarchar(225)   NULL
,  [Doors_number]  float   NULL
,  [Colour]  nvarchar(225)   NULL
,  [Features]  text   NULL
, CONSTRAINT [PK_dbo.DimCar] PRIMARY KEY CLUSTERED 
( [CarKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimCar
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Car', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimCar
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Products on an order (with supplier and category info)', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=DimCar
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[northwind].[Car]'))
DROP VIEW [northwind].[Car]
GO
CREATE VIEW [northwind].[Car] AS 
SELECT [CarKey] AS [CarKey]
, [CarID] AS [CarID]
, [Price] AS [Price]
, [Condition] AS [Condition]
, [Vehicle_brand] AS [Vehicle_brand]
, [Vehicle_model] AS [Vehicle_model]
, [Vehicle_version] AS [Vehicle_version]
, [Vehicle_generation] AS [Vehicle_generation]
, [Production_year] AS [Production_year]
, [Mileage_km] AS [Mileage_km]
, [Power_HP] AS [Power_HP]
, [Displacement_cm3] AS [Displacement_cm4]
, [Fuel_type] AS [Fuel_type]
, [CO2_emissions] AS [CO2_emissions]
, [Drive] AS [Drive]
, [Transmission] AS [Transmission]
, [Type] AS [Type]
, [Doors_number] AS [Doors_number]
, [Colour] AS [Colour]
, [Features] AS [Features]
FROM dbo.DimCar
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CarKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'CarKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CarID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'CarID'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Price', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'Price'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Condition', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'Condition'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Vehicle_brand', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'Vehicle_brand'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Vehicle_model', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'Vehicle_model'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Vehicle_version', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'Vehicle_version'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Vehicle_generation', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'Vehicle_generation'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Production_year', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'Production_year'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Mileage_km', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'Mileage_km'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Power_HP', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'Power_HP'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Displacement_cm4', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'Displacement_cm3'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Fuel_type', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'Fuel_type'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CO2_emissions', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'CO2_emissions'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Drive', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'Drive'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Transmission', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'Transmission'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Type', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'Type'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Doors_number', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'Doors_number'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Colour', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'Colour'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Features', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'Features'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Key to Car', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'CarKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'key', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'DimCar', @level2type=N'COLUMN', @level2name=N'CarKey'; 
;





/* Drop table dbo.FactSales */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.FactSales') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.FactSales 
;

/* Create table dbo.FactSales */
CREATE TABLE dbo.FactSales (
   [CarKey]  int   NOT NULL
,  [CustomerKey]  int   NOT NULL
,  [DateKey]  int   NOT NULL
,  [SalesPersonKey]  int   NOT NULL
,  [Sale Price]  money   NOT NULL
,  [Commission Rate]  float   NOT NULL
,  [Commission Earned]  money   NOT NULL
, CONSTRAINT [PK_dbo.FactSales] PRIMARY KEY NONCLUSTERED 
( [CarKey] )
) ON [PRIMARY]
;

--Table extended properties...
exec sys.sp_addextendedproperty @name=N'Table Type', @value=N'Fact', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=FactSales
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Sales', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=FactSales
exec sys.sp_addextendedproperty @name=N'Table Description', @value=N'Sales order information', @level0type=N'SCHEMA', @level0name=dbo, @level1type=N'TABLE', @level1name=FactSales
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[northwind].[Sales]'))
DROP VIEW [northwind].[Sales]
GO
CREATE VIEW [northwind].[Sales] AS 
SELECT [CarKey] AS [CarKey]
, [CustomerKey] AS [CustomerKey]
, [DateKey] AS [DateKey]
, [SalesPersonKey] AS [SalesPersonKey]
, [Sale Price] AS [Sale Price]
, [Commission Rate] AS [Commission Rate]
, [Commission Earned] AS [Commission Earned]
FROM dbo.FactSales
GO

--Column extended properties
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CarKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'CarKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'CustomerKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'CustomerKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'DateKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'DateKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'SalesPersonKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'SalesPersonKey'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Sale Price', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Sale Price'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Commission Rate', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Commission Rate'; 
exec sys.sp_addextendedproperty @name=N'Display Name', @value=N'Commission Earned', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Commission Earned'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Car', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'CarKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Customer', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'CustomerKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Time', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'DateKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'SalesPersonID', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'SalesPersonKey'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'The sale price of the car ', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Sale Price'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'The commission rate paid to the salesperson on the sale', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Commission Rate'; 
exec sys.sp_addextendedproperty @name=N'Description', @value=N'Sale Price * Commission Rate', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Commission Earned'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'CarKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'CustomerKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'DateKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'12133', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'SalesPersonKey'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'12$', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Sale Price'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'0.001123', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Commission Rate'; 
exec sys.sp_addextendedproperty @name=N'Example Values', @value=N'5', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Commission Earned'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'int', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'CarKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'int', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'CustomerKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'dd/mm/yy', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'DateKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'int', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'SalesPersonKey'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Exclude from cube', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Sale Price'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Amounts', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Commission Rate'; 
exec sys.sp_addextendedproperty @name=N'Display Folder', @value=N'Amounts', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'Commission Earned'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from DimCar.CarKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'CarKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from DimCustomer.CustomerKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'CustomerKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from DimDate.DateKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'DateKey'; 
exec sys.sp_addextendedproperty @name=N'ETL Rules', @value=N'Key lookup from DimSalePerson.SalePersonKey', @level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'FactSales', @level2type=N'COLUMN', @level2name=N'SalesPersonKey'; 
;
ALTER TABLE dbo.FactSales ADD CONSTRAINT
   FK_dbo_FactSales_CarKey FOREIGN KEY
   (
   CarKey
   ) REFERENCES DimCar
   ( CarKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactSales ADD CONSTRAINT
   FK_dbo_FactSales_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactSales ADD CONSTRAINT
   FK_dbo_FactSales_DateKey FOREIGN KEY
   (
   DateKey
   ) REFERENCES DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactSales ADD CONSTRAINT
   FK_dbo_FactSales_SalesPersonKey FOREIGN KEY
   (
   SalesPersonKey
   ) REFERENCES DimSalesPerson
   ( EmployeeKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
