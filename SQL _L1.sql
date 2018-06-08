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


//L1-35
SELECT id, name, website
FROM accounts
WHERE name LIKE 'C%';

SELECT id, name, website
FROM accounts
WHERE name LIKE '%one%';

SELECT id, name, website
FROM accounts
WHERE name LIKE '%s';


//L1-38
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

SELECT * 
FROM web_events
WHERE channel IN ('organic', 'adwords');


//L1-41

SELECT  name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN('Walmart', 'Target', 'Nordstrom');

SELECT * 
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');


//L1-44

SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

SELECT *
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC


//L1-47

SELECT id
FROM orders
WHERE gloss_qty = 0 OR poster_qty > 4000;

SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);

SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') 
	AND (primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') 
	AND primary_poc NOT LIKE ('%eana%');






















