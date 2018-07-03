#L2-4

SELECT orders.standard_qty, 
	   orders.poster_qty,
       orders.gloss_qty,
       accounts.primary_poc,
       accounts.website
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;


#L2-11

SELECT a.primary_poc, a.name, w.occurred_at, w.channel 
FROM accounts AS a
JOIN web_events AS w
ON a.id = w.account_id
WHERE a.name = 'Walmart';
#9073 result

SELECT s.name agent_name, r.name region_name, a.name account_name
FROM sales_reps AS s
JOIN region AS r
ON r.id = s.region_id
JOIN accounts AS a
ON a.sales_rep_id = s.id;
#351 results

SELECT r.name region_name, a.name account_name,  o.total_amt_usd / (o.total + 0.01) unit_price
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON a.id = o.account_id;
#6912 results


#L2-19

SELECT r.name region_name, s.name sales_name, a.name account_name
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest'
ORDER BY a.name;
#48 result
# ************* WHERE clause have to be after all the JOIN ************************

SELECT r.name region_name, s.name sales_name, a.name account_name
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name; 
#5 result

SELECT r.name region_name, s.name sales_name, a.name account_name
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name; 
#13 result

SELECT r.name region_name, a.name account_name，,  o.total_amt_usd / (o.total + 0.01) unit_price
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON a.id = o.account_id
WHERE o.standard_qty > 100
#4509 result

SELECT r.name region_name, a.name account_name，,  o.total_amt_usd / (o.total + 0.01) unit_price
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON a.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
#835 result


SELECT r.name region_name, a.name account_name，,  o.total_amt_usd / (o.total + 0.01) unit_price
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON a.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC
#835 result

SELECT DISTINCT a.name, w.channel
FROM accounts AS a
JOIN web_events AS w
ON a.id = w.account_id
WHERE a.id = 1001
# 6 result

SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM orders AS o
JOIN accounts AS a
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01'
#1725 result

/* *************************************************
Union show only distinct data point
but union all show all the data point
****************************************************
*/

/*
CROSS JOIN
1，2，3
4，5，6
->
14，15，16，24，25，26，34，35，36
SELF JOIN
1,2,3
->
11,12,13,21,22,23,31,32,33
*/
