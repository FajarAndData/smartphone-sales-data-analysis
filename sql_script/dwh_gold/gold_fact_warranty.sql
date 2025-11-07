/* ===============================
CREATE gold.fact_warranty
================================*/

/* 
check claim_date consistency over order_date
only use logically correct claim date, need further investigation for logically wrong claim date
*/

IF OBJECT_ID('gold.fact_warranty', 'V') IS NOT NULL
	DROP VIEW gold.fact_warranty;
GO 

CREATE VIEW gold.fact_warranty AS
SELECT
	claim_id,
	claim_date,
	repair_status,
	s.order_id,
	order_date,
	DATEDIFF(day, order_date, claim_date) AS product_usage_age,
	store_id
FROM silver.warranty_details w
LEFT JOIN gold.fact_sales s
ON w.order_id = s.order_id
WHERE DATEDIFF(day, order_date, claim_date) > 0
