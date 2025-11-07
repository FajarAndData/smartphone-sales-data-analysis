/* =======================================================
INSERTING DATA INTO SILVER LAYER TABLES 
==========================================================*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE 
		@start_time			DATETIME,
		@end_time			DATETIME, 
		@batch_start_time	DATETIME,
		@batch_end_time		DATETIME
		;
	BEGIN TRY
		SET @batch_start_time =GETDATE();
		PRINT '=========================================================';
		PRINT 'LOADING SILVER LAYER...';
		PRINT '=========================================================';

		
		PRINT '=========================================================';
		PRINT 'Loading Tables...';
		PRINT '=========================================================';
--------		
		SET @start_time =GETDATE();
		PRINT '>>> Truncating table: silver.product_category';
		TRUNCATE TABLE silver.product_category;
		PRINT '>>> Inserting data into: silver.product_category';
		INSERT INTO silver.product_category (
			cat_id,
			cat_name
		)

		SELECT
			TRIM(cat_id) AS cat_id,
			TRIM(cat_name) AS cat_name
		FROM bronze.product_category 

		SET @end_time =GETDATE();
		PRINT 'Loading Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '- - - - - - - - - -';
--------
		SET @start_time =GETDATE();
		PRINT '>>> Truncating table: silver.product_info';
		TRUNCATE TABLE silver.product_info;
		PRINT '>>> Inserting data into: silver.product_info';
		INSERT INTO silver.product_info (
			product_id,
			product_name,
			cat_id,
			launch_date,
			price)
		SELECT 
			product_id,
			product_name,
			cat_id,
			launch_date,
			price
		FROM bronze.product_info
		SET @end_time =GETDATE();
		PRINT 'Loading Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '- - - - - - - - - -';
--------
		SET @start_time =GETDATE();
		PRINT '>>> Truncating table: silver.sales_details';
		TRUNCATE TABLE silver.sales_details;
		PRINT '>>> Inserting data into: silver.sales_details';
		INSERT INTO silver.sales_details (
			order_id,
			order_date, 
			store_id,
			product_id,
			quantity
			)
		SELECT
			sale_id,
			CONVERT(date, sale_date, 105) AS sale_date,
			store_id,
			product_id,
			quantity
		FROM bronze.sales_details
		SET @end_time =GETDATE();
		PRINT 'Loading Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '- - - - - - - - - -';
		
--------
		SET @start_time =GETDATE();
		PRINT '>>> Truncating table: silver.store_info';
		TRUNCATE TABLE silver.store_info;
		PRINT '>>> Inserting data into: silver.store_info';
		INSERT INTO silver.store_info (
			store_id,
			store_name,
			city,
			country
			)
		SELECT 
			store_id,
			CASE WHEN flag = 2 THEN CONCAT(store_name, ' (2)')
				 ELSE store_name
				 END AS store_name,
			TRIM(city) AS city,
			TRIM(country) AS country
		FROM (
			SELECT 
				*,
				ROW_NUMBER() OVER(PARTITION BY store_name ORDER BY store_id) AS flag
			FROM bronze.store_info
			) t
		SET @end_time =GETDATE();
		PRINT 'Loading Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '- - - - - - - - - -';
--------
		SET @start_time =GETDATE();
		PRINT '>>> Truncating table: silver.warranty_details';
		TRUNCATE TABLE silver.warranty_details;
		PRINT '>>> Inserting data into: silver.warranty_details';
		INSERT INTO silver.warranty_details (
			claim_id,
			claim_date,
			order_id,
			repair_status
			)
		SELECT 
			claim_id,
			claim_date,
			sale_id,
			repair_status
		FROM bronze.warranty_details 
				SET @end_time =GETDATE();
		PRINT 'Loading Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '- - - - - - - - - -';

		SET @batch_end_time =GETDATE();
		PRINT '=========================================================';
		PRINT 'LOADING BRONZE LAYER IS COMPLETED';
		PRINT ' - Total Loading Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================================';
	END TRY
	BEGIN CATCH
		PRINT '====================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error message' + ERROR_MESSAGE();
		PRINT 'Error message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '====================================================';
	END CATCH
END;

EXEC silver.load_silver
