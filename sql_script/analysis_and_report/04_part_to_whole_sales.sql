-- ===========================================
-- part to whole product category sales
-- ===========================================

DROP VIEW IF EXISTS gold.report_alltime_sales_category;
GO

CREATE VIEW gold.report_alltime_sales_category AS
WITH base AS (
SELECT
	p.category,
	SUM(s.sales_amount) AS sales,
	(SELECT SUM(CAST(sales_amount AS BIGINT)) 
		FROM gold.fact_sales) AS total_sales
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_id = p.product_id
GROUP BY p.category
)

, base2 AS (
SELECT
	*,
	ROUND(CAST(sales AS FLOAT) / total_sales * 100, 2) AS percentage,
	ROW_NUMBER() OVER(ORDER BY ROUND(CAST(sales AS FLOAT) / total_sales * 100, 2) DESC) AS rn
FROM base 
)

SELECT 
	category,
	sales,
	total_sales,
	CONCAT(percentage, '%') AS percentage,
	rn
FROM base2
;
GO
