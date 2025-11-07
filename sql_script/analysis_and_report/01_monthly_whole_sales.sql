/*=====================
MONTHLY WHOLE SALES - change over time 
======================*/

IF OBJECT_ID('gold.report_monthly_sales_whole', 'V') IS NOT NULL
	DROP VIEW gold.report_monthly_sales_whole;
GO

CREATE VIEW gold.report_monthly_sales_whole AS
SELECT
	DATETRUNC(month, order_date) AS month_order,
	COUNT(DISTINCT order_id) AS total_order,
	COUNT(DISTINCT p.product_id) AS total_product,
	SUM(quantity) AS total_qty,
	SUM(sales_amount) AS total_sales,
	ROW_NUMBER() OVER(ORDER BY DATETRUNC(month, order_date)) AS rn
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_id = p.product_id
LEFT JOIN silver.store_info st
ON s.store_id = st.store_id
GROUP BY DATETRUNC(month, order_date)
GO
