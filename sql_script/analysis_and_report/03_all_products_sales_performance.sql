-- =======================================
-- ALL PRODUCT SALES PERFORMANCE
-- =======================================

DROP VIEW IF EXISTS gold.report_annual_products_performance;
GO

CREATE VIEW gold.report_annual_products_performance AS
WITH base AS (
SELECT
	year(order_date) AS year,
	s.product_id,
	p.product_name,
	p.category,
	p.class,
	SUM(s.sales_amount) AS sales
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_id = p.product_id 
GROUP BY 
	year(order_date),
	s.product_id,
	p.product_name,
	p.category,
	p.class
)

SELECT
	year,
	product_id,
	product_name,
	category,
	class,
	sales,
	LAG(sales) OVER(PARTITION BY product_id ORDER BY year) AS py_sales,
	sales - LAG(sales) OVER(PARTITION BY product_id ORDER BY year) AS py_sales_diff,
	CASE WHEN sales - LAG(sales) OVER(PARTITION BY product_id ORDER BY year) < 0 THEN 'Decrease'
		 WHEN sales - LAG(sales) OVER(PARTITION BY product_id ORDER BY year) > 0 THEN 'Increase'
		 END AS sales_mark,
	AVG(sales) OVER (PARTITION BY product_id) AS avg_sales,
	sales - AVG(sales) OVER (PARTITION BY product_id) AS avg_diff,
	CASE WHEN sales - AVG(sales) OVER (PARTITION BY product_id) < 0 THEN 'ABOVE Avg'
		 WHEN sales - AVG(sales) OVER (PARTITION BY product_id) > 0 THEN 'Below Avg'
		 ELSE 'Average'
		 END AS avg_mark
FROM base;
GO
