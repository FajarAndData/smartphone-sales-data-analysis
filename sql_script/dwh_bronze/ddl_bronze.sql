/*========================================================
CREATE BRONZE LAYER TABLES 
==========================================================*/

IF	OBJECT_ID ('bronze.product_category', 'U') IS NOT NULL
	DROP TABLE bronze.product_category;
CREATE TABLE bronze.product_category (
cat_id		NVARCHAR(50),
cat_name	NVARCHAR(50)
);

DROP	TABLE IF EXISTS bronze.product_info;
CREATE	TABLE bronze.product_info (
product_id		NVARCHAR(50),
product_name	NVARCHAR(50),
cat_id			NVARCHAR(50),
launch_date		DATE,
price			INT
);

IF	OBJECT_ID ('bronze.sales_details', 'U') IS NOT NULL
	DROP TABLE bronze.sales_details;
CREATE TABLE bronze.sales_details (
sale_id			NVARCHAR(50),
sale_date		NVARCHAR(50),
store_id		NVARCHAR(50),
product_id		NVARCHAR(50),
quantity		INT
);

DROP	TABLE IF EXISTS bronze.store_info
CREATE	TABLE bronze.store_info (
store_id		NVARCHAR(50),
store_name		NVARCHAR(50),
city			NVARCHAR(50),
country			NVARCHAR(50)
);

IF	OBJECT_ID ('bronze.warranty_details', 'U') IS NOT NULL
	DROP TABLE bronze.warranty_details;
CREATE TABLE bronze.warranty_details (
claim_id		NVARCHAR(50),
claim_date		DATE,
sale_id			NVARCHAR(50),
repair_status	NVARCHAR(50)
);
