-- =================================================
-- Monthly TOP gainer (product and store)
-- =================================================
IF OBJECT_ID('gold.report_monthly_top_gainer', 'V') IS NOT NULL 
	DROP VIEW gold.report_monthly_top_gainer;
GO

CREATE VIEW gold.report_monthly_top_gainer AS
WITH cte1 AS (
SELECT
	FORMAT(DATETRUNC(month, order_date), 'yyyy-MM') AS month,
	p.product_name,
	SUM(s.sales_amount) AS pd_sales,
	ROW_NUMBER() OVER(PARTITION BY FORMAT(DATETRUNC(month, order_date), 'yyyy-MM') ORDER BY SUM(s.sales_amount)) AS prod_rn
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_id = p.product_id
GROUP BY
	FORMAT(DATETRUNC(month, order_date), 'yyyy-MM'),
	p.product_name
)
, cte2 AS (
SELECT
	FORMAT(DATETRUNC(month, order_date), 'yyyy-MM') AS month,
	st.store_name,
	SUM(s.sales_amount) AS st_sales,
	ROW_NUMBER() OVER(PARTITION BY FORMAT(DATETRUNC(month, order_date), 'yyyy-MM') ORDER BY SUM(s.sales_amount)) AS store_rn
FROM gold.fact_sales s
LEFT JOIN silver.store_info st
ON s.store_id = st.store_id 
GROUP BY
	FORMAT(DATETRUNC(month, order_date), 'yyyy-MM'),
	st.store_name
)

, cte3 AS (
SELECT
*
FROM cte1 
WHERE prod_rn = 1
)

, cte4 AS (
SELECT
*
FROM cte2 
WHERE store_rn = 1
)

SELECT
	cte3.month,
	product_name AS top_product,
	pd_sales AS product_sales,
	store_name AS top_store,
	st_sales AS store_sales
FROM cte3
JOIN cte4
ON cte3.month = cte4.month
