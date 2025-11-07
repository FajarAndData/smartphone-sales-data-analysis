-- ====================================
-- WHOLE SALE OVER TIME CUMILATIVE ANALYSIS
-- ====================================

DROP VIEW IF EXISTS gold.report_annual_sales_whole;
GO

CREATE VIEW gold.report_annual_sales_whole AS
SELECT
	year_order,
	total_sales,
	CASE WHEN LAG(total_sales) OVER(ORDER BY year_order) < total_sales THEN 'Increase'
		 WHEN LAG(total_sales) OVER(ORDER BY year_order) > total_sales THEN 'Decreasing'
		 ELSE ''
		 END AS vs_py,
	SUM(CAST(total_sales AS BIGINT)) OVER(ORDER BY year_order) AS running_total_sales,
	AVG(avg_sales) OVER(ORDER BY year_order) AS moving_avg_sales
FROM (
	SELECT 
		DATETRUNC(year, order_date) AS year_order,
		SUM(sales_amount) AS total_sales,
		AVG(sales_amount) AS avg_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(year, order_date)
	) T
;
GO
