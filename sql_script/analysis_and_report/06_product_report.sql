/*===========================
CREATE PRODUCT REPORT
============================*/

IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
	DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS
WITH base AS (
SELECT 
	s.order_id,
	s.order_date,
	p.product_key,
	p.product_id,
	p.product_name,
	p.category,
	p.class,
	p.launch_date,
	p.price,
	s.quantity,
	s.sales_amount,
	s.store_id
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_id = p.product_id
)

, product_agg AS (
SELECT
	product_id,
	product_name,
	category,
	class,
	launch_date,
	price,
	SUM(quantity) AS total_qty,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT order_id) AS total_order,
	COUNT(DISTINCT store_id) AS store_count,
	MIN(order_date) AS first_order,
	MAX(order_date) AS last_order,
	DATEDIFF(month, launch_date, GETDATE()) AS product_age_mo
FROM base
GROUP BY
	product_id,
	product_name,
	category,
	class,
	launch_date,
	price
) 

SELECT
	product_id,
	product_name,
	category,
	class,
	launch_date,
	price,
	total_qty,
	total_sales,
	total_order,
	store_count,
	first_order,
	last_order,
	product_age_mo,
	CASE WHEN total_order = 0 THEN 0  -- to avoid error, in case total order is 0
		 ELSE total_sales / total_order
		 END AS avg_ordered_sales,
	(total_sales / product_age_mo) AS avg_monthly_sales,
	DATEDIFF(month, last_order, GETDATE()) AS recency_mo
FROM product_agg;
