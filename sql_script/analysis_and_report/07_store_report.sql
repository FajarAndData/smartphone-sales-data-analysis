/*===========================
CREATE STORE REPORT
============================*/

IF OBJECT_ID('gold.report_stores', 'V') IS NOT NULL
	DROP VIEW gold.report_stores;
GO

CREATE VIEW gold.report_stores AS
WITH base AS (
SELECT 
	st.store_id,
	st.store_name,
	st.city, 
	st.country,
	s.order_id,
	s.order_date,
	s.product_id,
	p.product_name,
	p.launch_date,
	c.cat_name,
	p.price,
	s.quantity,
	(p.price * s.quantity) AS sales_amount
FROM silver.sales_details s
LEFT JOIN silver.store_info st
ON s.store_id = st.store_id
LEFT JOIN silver.product_info p
ON s.product_id = p.product_id
LEFT JOIN silver.product_category c
ON p.cat_id = c.cat_id
)

, store_agg AS (
SELECT
	store_id,
	store_name,
	city,
	country,
	COUNT(DISTINCT order_id) AS total_order,
	COUNT(DISTINCT product_id) AS total_product,
	SUM(quantity) AS total_qty,
	SUM(sales_amount) AS total_sales,
	MIN(order_date) AS first_order,
	MAX(order_date) AS last_order,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS store_age_mo
FROM base
GROUP BY 
	store_id,
	store_name,
	city,
	country
)

SELECT 
	store_id,
	store_name,
	city,
	country,
	total_order,
	total_product,
	total_qty,
	total_sales,
	(total_sales / store_age_mo) AS avg_monthly_sales,
	(total_sales / total_order) AS avg_ordered_sales,
	first_order,
	last_order,
	store_age_mo
FROM store_agg
