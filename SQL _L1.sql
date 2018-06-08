//L1-22

SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at DESC, total_amt_usd DESC
LIMIT 5;

SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at, total_amt_usd DESC
LIMIT 10;

//L1-25

SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

//L1-28

SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';


//L1-31

SELECT id, 
	   account_id, 
       standard_amt_usd / standard_qty AS unit_price
FROM orders
LIMIT 10;

SELECT id, 
	   account_id, 
       poster_amt_usd / total_amt_usd AS poster_revenue
FROM orders
WHERE total_amt_usd != 0;