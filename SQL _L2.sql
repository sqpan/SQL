//L2-4

SELECT orders.standard_qty, 
	   orders.poster_qty,
       orders.gloss_qty,
       accounts.primary_poc,
       accounts.website
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;


//L2-11

SELECT a.primary_poc, a.name, w.occurred_at, w.channel 
FROM accounts AS a
JOIN web_events AS w
ON a.id = w.account_id
WHERE a.name = 'Walmart';
//9073 result

SELECT s.name agent_name, r.name region_name, a.name account_name
FROM sales_reps AS s
JOIN region AS r
ON r.id = s.region_id
JOIN accounts AS a
ON a.sales_rep_id = s.id;
//351 results

SELECT r.name region_name, a.name account_name,  o.total_amt_usd / (o.total + 0.01) unit_price
FROM region AS r
JOIN sales_reps AS s
ON r.id = s.region_id
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN orders AS o
ON a.id = o.account_id;
//6912 results
