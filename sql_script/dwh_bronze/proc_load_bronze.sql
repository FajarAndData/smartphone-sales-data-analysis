/* =======================================================
INSERTING DATA INTO TABLES 
==========================================================*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
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
		PRINT 'LOADING BRONZE LAYER...';
		PRINT '=========================================================';

		
		PRINT '=========================================================';
		PRINT 'Loading Tables...';
		PRINT '=========================================================';
--------		
		SET @start_time =GETDATE();
		PRINT '>>> Truncating table: bronze.product_category';
		TRUNCATE TABLE bronze.product_category;
		PRINT '>>> Inserting data into: bronze.product_category';
		BULK INSERT	   bronze.product_category
		FROM 'C:\Users\User\Downloads\apple_retail_sales\category.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time =GETDATE();
		PRINT 'Loading Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '- - - - - - - - - -';
--------
		SET @start_time =GETDATE();
		PRINT '>>> Truncating table: bronze.product_info';
		TRUNCATE TABLE bronze.product_info;
		PRINT '>>> Inserting data into: bronze.product_info';
		BULK INSERT	   bronze.product_info
		FROM 'C:\Users\User\Downloads\apple_retail_sales\products.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time =GETDATE();
		PRINT 'Loading Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '- - - - - - - - - -';
--------
		SET @start_time =GETDATE();
		PRINT '>>> Truncating table: bronze.sales_details';
		TRUNCATE TABLE bronze.sales_details;
		PRINT '>>> Inserting data into: bronze.sales_details';
		BULK INSERT    bronze.sales_details
		FROM 'C:\Users\User\Downloads\apple_retail_sales\sales.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time =GETDATE();
		PRINT 'Loading Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '- - - - - - - - - -';
--------
		SET @start_time =GETDATE();
		PRINT '>>> Truncating table: bronze.store_info';
		TRUNCATE TABLE bronze.store_info;
		PRINT '>>> Inserting data into: bronze.store_info';
		BULK INSERT    bronze.store_info
		FROM 'C:\Users\User\Downloads\apple_retail_sales\stores.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time =GETDATE();
		PRINT 'Loading Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '- - - - - - - - - -';
--------
		SET @start_time =GETDATE();
		PRINT '>>> Truncating table: bronze.warranty_details';
		TRUNCATE TABLE bronze.warranty_details;
		PRINT '>>> Inserting data into: bronze.warranty_details';
		BULK INSERT	   bronze.warranty_details
		FROM 'C:\Users\User\Downloads\apple_retail_sales\warranty.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
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

EXEC bronze.load_bronze
