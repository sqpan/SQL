# L4-7
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

#The easier way
SELECT DATE_TRUNC('month', MIN(occurred_at)) 
FROM orders;

# L4-10
# Q1 @@@@@@@@@@@@@@@@@@@@@@@
SELECT info.agent_name, info.region_name, region_max.max
FROM 
	(SELECT s.name AS agent_name, s.region_id AS region_id, r.name AS region_name, SUM(o.total_amt_usd) AS total
		FROM sales_reps AS s, accounts AS a, orders AS o, region AS r 
		WHERE s.id = a.sales_rep_id AND a.id = o.account_id AND r.id = s.region_id
		GROUP BY 1, 2, 3
		ORDER BY 3 DESC) AS info
JOIN 
	(SELECT sales_total.region_id, MAX(sales_total.total) AS max
	FROM 
		(SELECT s.name AS agent_name, s.region_id, SUM(o.total_amt_usd) AS total
		FROM sales_reps AS s, accounts AS a, orders AS o
		WHERE s.id = a.sales_rep_id AND a.id = o.account_id
		GROUP BY 1, 2
		ORDER BY 3 DESC) AS sales_total
	GROUP BY 1
	ORDER BY 2 DESC) AS region_max
ON region_max.region_id = info.region_id AND region_max.max = info.total
ORDER BY region_max.max DESC 
/*
Earlie Schleusner	Southeast	1098137.72
Tia Amato			Northeast	1010690.60
Georgianna Chisholm	West		886244.12
Charles Bidwell		Midwest		675637.19
*/

# Q2 @@@@@@@@@@@@@@@@@@@@@@@
SELECT max.region_name, max.top, count.total_order
FROM 
	(SELECT region_name, MAX(total.total_amt) AS top 
	FROM 
		(SELECT r.name AS region_name, SUM(total_amt_usd) AS total_amt
		FROM region AS r, sales_reps AS s, accounts AS a, orders AS o 
		WHERE r.id = s.region_id AND s.id = a.sales_rep_id AND o.account_id = a.id
		GROUP BY r.name
		ORDER BY total_amt DESC) AS total
	GROUP BY region_name
	ORDER BY top DESC
	LIMIT 1 
	) AS max
JOIN
	(SELECT r.name AS region_name, COUNT(o.id) AS total_order
	FROM region AS r, sales_reps AS s, accounts AS a, orders AS o 
	WHERE r.id = s.region_id AND s.id = a.sales_rep_id AND o.account_id = a.id
	GROUP BY region_name
	ORDER BY total_order DESC) AS count
ON max.region_name = count.region_name 
# aggregate function cannot be nested
# 	Northeast	7744405.36	2357


# Q3 @@@@@@@@@@@@@@@@@@@@@@@
SELECT COUNT(*)
FROM 
	(SELECT a.name, SUM(o.total) AS total_qty
	FROM accounts AS a, orders AS o
	WHERE a.id = o.account_id
	GROUP BY 1
	ORDER BY 2 DESC)
	AS total_qty_per_account
WHERE  total_qty_per_account.total_qty > 
	(SELECT total_amt	
	FROM
		(SELECT SUM(standard_qty) AS total_standard, SUM(total) AS total_amt
		FROM accounts AS a, orders AS o
		WHERE o.account_id = a.id 
		GROUP BY a.name
		ORDER BY 1 DESC
		LIMIT 1) AS info)
# 3



# Q4 @@@@@@@@@@@@@@@@@@@@@@@
SELECT max.account_name, max.max_amt, channel_count.channel, channel_count.events_count
FROM 
	(SELECT a.name AS account_name, SUM(total_amt_usd) AS max_amt
	FROM accounts AS a, orders AS o 
	WHERE a.id = o.account_id
	GROUP BY account_name
	ORDER BY max_amt DESC 
	LIMIT 1)
	AS max
JOIN  
	(SELECT a.name AS account_name, w.channel AS channel, COUNT(w.id) as events_count
	FROM accounts AS a, web_events AS w
	WHERE w.account_id = a.id
	GROUP BY account_name, channel
	ORDER BY account_name, events_count DESC)
	AS channel_count
ON max.account_name = channel_count.account_name
ORDER BY channel_count.events_count DESC 
/*
EOG Resources	382873.30	direct		44
EOG Resources	382873.30	organic		13
EOG Resources	382873.30	adwords		12
EOG Resources	382873.30	facebook	11
EOG Resources	382873.30	twitter		5
EOG Resources	382873.30	banner		4
*/

# Q5 @@@@@@@@@@@@@@@@@@@@@@@
SELECT AVG(max.max_amt)
FROM
	(SELECT a.name AS account_name, SUM(total_amt_usd) AS max_amt
	FROM accounts AS a, orders AS o 
	WHERE a.id = o.account_id
	GROUP BY account_name
	ORDER BY max_amt DESC 
	LIMIT 10)
	AS max
# 304846.969000000000

# Q6 @@@@@@@@@@@@@@@@@@@@@@@
SELECT AVG(account_more_than_avg.account_avg) 
FROM 
	(SELECT a.name AS account_name, AVG(o.total_amt_usd) AS account_avg
	FROM accounts AS a, orders AS o 
	WHERE a.id = o.account_id
	GROUP BY 1
	ORDER BY 2) AS account_more_than_avg
WHERE account_more_than_avg.account_avg > 
	(SELECT AVG(o.total_amt_usd)
	FROM orders AS o) AS average
# 4721.1397439971747168

# L4-14
# Q1 @@@@@@@@@@@@@@@@@@@@@@@
WITH info AS (
	SELECT s.name AS agent_name, s.region_id AS region_id, r.name AS region_name, SUM(o.total_amt_usd) AS total
	FROM sales_reps AS s, accounts AS a, orders AS o, region AS r 
	WHERE s.id = a.sales_rep_id AND a.id = o.account_id AND r.id = s.region_id
	GROUP BY 1, 2, 3
	ORDER BY 3 DESC),

	region_max AS (
	SELECT sales_total.region_id, MAX(sales_total.total) AS max
	FROM 
		(SELECT s.name AS agent_name, s.region_id, SUM(o.total_amt_usd) AS total
		FROM sales_reps AS s, accounts AS a, orders AS o
		WHERE s.id = a.sales_rep_id AND a.id = o.account_id
		GROUP BY 1, 2
		ORDER BY 3 DESC) AS sales_total
	GROUP BY 1
	ORDER BY 2 DESC)

SELECT info.agent_name, info.region_name, region_max.max
FROM info
JOIN region_max
ON region_max.region_id = info.region_id AND region_max.max = info.total
ORDER BY region_max.max DESC 






