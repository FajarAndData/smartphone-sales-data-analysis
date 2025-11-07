/*========================================================
CREATE SILVER LAYER TABLES 
==========================================================*/

IF	OBJECT_ID ('silver.product_category', 'U') IS NOT NULL
	DROP TABLE silver.product_category;
CREATE TABLE silver.product_category (
  cat_id		NVARCHAR(50),
  cat_name	NVARCHAR(50),
  rcd_create_date	DATETIME2 DEFAULT GETDATE() -- metadata
);

DROP	TABLE IF EXISTS silver.product_info;
CREATE	TABLE silver.product_info (
  product_id		NVARCHAR(50),
  product_name	NVARCHAR(50),
  cat_id			NVARCHAR(50),
  launch_date		DATE,
  price			INT,
  rcd_create_date	DATETIME2 DEFAULT GETDATE() -- metadata
);

IF	OBJECT_ID ('silver.sales_details', 'U') IS NOT NULL
	DROP TABLE silver.sales_details;
CREATE TABLE silver.sales_details (
  order_id		NVARCHAR(50),
  order_date		DATE,
  store_id		NVARCHAR(50),
  product_id		NVARCHAR(50),
  quantity		INT,
  rcd_create_date		DATETIME2 DEFAULT GETDATE() -- metadata
);

DROP	TABLE IF EXISTS silver.store_info
CREATE	TABLE silver.store_info (
  store_id		NVARCHAR(50),
  store_name		NVARCHAR(50),
  city			NVARCHAR(50),
  country			NVARCHAR(50),
  rcd_create_date		DATETIME2 DEFAULT GETDATE() -- metadata
);

IF	OBJECT_ID ('silver.warranty_details', 'U') IS NOT NULL
	DROP TABLE silver.warranty_details;
CREATE TABLE silver.warranty_details (
  claim_id		NVARCHAR(50),
  claim_date		DATE,
  order_id		NVARCHAR(50),
  repair_status	NVARCHAR(50),
  rcd_create_date		DATETIME2 DEFAULT GETDATE() -- metadata
);
