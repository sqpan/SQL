// L4-7
SELECT 
	DATE_TRUNC('month', occurred_at) AS month, 
	AVG(standard_qty) AS standard,
	AVG(poster_qty) AS poster,
	AVG(gloss_qty) AS gloss
FROM orders
WHERE month = 
	(SELECT DATE_TRUNC('month', occurred_at)
	FROM orders
	ORDER BY occurred_at
	LIMIT 1)
GROUP BY 1

//The easier way
SELECT DATE_TRUNC('month', MIN(occurred_at)) 
FROM orders;

// L4-10
// Q1 @@@@@@@@@@@@@@@@@@@@@@@
SELECT info.agent_name, info.region_name, region_max.max
FROM 
	(SELECT s.name AS agent_name, s.region_id AS region_id, r.name AS region_name, SUM(o.total) AS total
		FROM sales_reps AS s, accounts AS a, orders AS o, region AS r 
		WHERE s.id = a.sales_rep_id AND a.id = o.account_id AND r.id = s.region_id
		GROUP BY 1, 2, 3
		ORDER BY 3 DESC) AS info
JOIN 
	(SELECT sales_total.region_id, MAX(sales_total.total) AS max
	FROM 
		(SELECT s.name AS agent_name, s.region_id, SUM(o.total) AS total
		FROM sales_reps AS s, accounts AS a, orders AS o
		WHERE s.id = a.sales_rep_id AND a.id = o.account_id
		GROUP BY 1, 2
		ORDER BY 3 DESC) AS sales_total
	GROUP BY 1
	ORDER BY 2 DESC) AS region_max
ON region_max.region_id = info.region_id AND region_max.max = info.total
ORDER BY region_max.max DESC 


