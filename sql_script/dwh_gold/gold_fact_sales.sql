/* ===============================
CREATE gold.fact_sales
================================*/

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
	DROP VIEW gold.fact_sales;
GO
CREATE VIEW gold.fact_sales AS
SELECT 
	d.order_id,
	d.order_date,
	s.store_id,
	p.product_id,
	d.quantity,
	p.price,
	(d.quantity * p.price) AS sales_amount
FROM silver.sales_details d
LEFT JOIN silver.store_info s
ON d.store_id = s.store_id
LEFT JOIN gold.dim_products p
ON d.product_id = p.product_id
