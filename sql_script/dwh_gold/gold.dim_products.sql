/* ===============================
CREATE gold.dim_products view
================================*/

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
	DROP VIEW gold.dim_products;
GO
CREATE VIEW gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY launch_date) AS product_key, -- surrogate key
	product_id,
	product_name,
	cat_name AS category,
	CASE WHEN price < 700 THEN 'Entry'
		 WHEN price BETWEEN 700 AND 1200 THEN 'Mid'
		 ELSE 'Flagship'
		 END AS class,
	price,
	launch_date
FROM silver.product_info AS i
LEFT JOIN silver.product_category AS c
ON i.cat_id = c.cat_id
