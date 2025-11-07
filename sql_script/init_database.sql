/* ===============================================
CREATE DATABASE AND SCHEMA
==================================================*/

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'AppleRetailSales')
BEGIN 
	ALTER DATABASE AppleRetailSales SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP  DATABASE AppleRetailSales
END;
GO

CREATE DATABASE AppleRetailSales;
GO

USE AppleRetailSales;
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
