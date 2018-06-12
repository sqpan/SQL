/* COUNT and other math functions don't consider NULL values*/

SELECT SUM(poster_qty)
FROM orders
// 723646

SELECT SUM(standard_qty)
FROM orders
// 1938346

SELECT SUM(total_amt_usd)
FROM orders
// 23141511.83

SELECT standard_amt_usd + gloss_amt_usd AS partial_total
FROM orders
// 6912 results

SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;


// L3-11

SELECT MIN(occurred_at)
FROM orders
//2013-12-04T04:22:44.000Z

SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1
//2013-12-04T04:22:44.000Z

SELECT MAX(occurred_at)
FROM web_events
//2017-01-01T23:51:09.000Z

SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1
//2017-01-01T23:51:09.000Z

SELECT 
	AVG(standard_qty) as average_standard_quantity_per_order,
    AVG(poster_qty) as average_poster_quantity_per_order,
    AVG(gloss_qty) as average_gloss_quantity_per_order,
    AVG(standard_amt_usd) as average_standard_total_per_order,   
    AVG(poster_amt_usd) as average_poster_total_per_order,
    AVG(gloss_amt_usd) as average_gloss_total_per_order
FROM orders
/*
average_standard_quantity_per_order	average_poster_quantity_per_order	average_gloss_quantity_per_order	average_standard_total_per_order	average_poster_total_per_order	average_gloss_total_per_order
280.4320023148148148	104.6941550925925926	146.6685474537037037	1399.3556915509259259	850.1165393518518519	1098.5474204282407407
*/


/*
GROUP BY can be used to aggregate data within subsets of the data. For example, grouping for different accounts, different regions, or different sales representatives.
Any column in the SELECT statement that is not within an aggregator must be in the GROUP BY clause.
The GROUP BY always goes between WHERE and ORDER BY.
ORDER BY works like SORT in spreadsheet software.
*/
SELECT o.occurred_at, a.name
FROM accounts AS a, orders AS o
WHERE o.account_id = a.id 
ORDER BY o.occurred_at 
LIMIT 1
//2013-12-04T04:22:44.000Z	DISH Network

SELECT SUM(total_amt_usd) AS total_amt, a.name
FROM accounts AS a, orders AS o
WHERE o.account_id = a.id 
GROUP BY a.name
// 350 results

SELECT w.occurred_at, w.channel, a.name
FROM web_events AS w, accounts AS a
WHERE w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1
// 2017-01-01T23:51:09.000Z	organic	Molina Healthcare

SELECT COUNT(channel) AS num_used, channel
FROM web_events
GROUP BY channel
/*
906	adwords
5298	direct
476	banner
967	facebook
952	organic
474	twitter
*/

SELECT a.primary_poc
FROM accounts AS a
JOIN web_events AS w
ON w.account_id = a.id 
ORDER BY w.occurred_at 
LIMIT 1 
// Leana Hawker

// **********************************************************
/*
SELECT MIN(total_amt_usd) AS min_total, a.name
FROM orders AS o, accounts AS a
GROUP BY a.name
// This generate all zero results, because when there is no where clause,
it will generate all the combination
*/
// **********************************************************

SELECT MIN(total_amt_usd) AS min_total, a.name
FROM orders AS o, accounts AS a
WHERE o.account_id = a.id 
GROUP BY a.name
// This generate the same results as follow code 
SELECT MIN(total_amt_usd) AS min_total, a.name
FROM orders as o
JOIN accounts AS a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY min_total
// This generate the results we want: min total of each company

SELECT COUNT(s.name) AS num_agent, r.name
FROM sales_reps AS s, region AS r
WHERE s.region_id = r.id
GROUP BY r.name;


// L3-17
// The order of columns listed in the ORDER BY clause does make a difference. 
// You are ordering the columns from left to right.
// As with ORDER BY, you can substitute numbers for column names in the GROUP BY clause. 
// It’s generally recommended to do this only when you’re grouping many columns, 
// or if something else is causing the text in the GROUP BY clause to be excessively long.

SELECT a.name, AVG(standard_qty) avg_standard, AVG(poster_qty) avg_poster, AVG(gloss_qty) avg_gloss
FROM accounts AS a, orders AS o
WHERE a.id = o.account_id
GROUP BY a.name;
// 350 results

SELECT a.name, AVG(standard_amt_usd) avg_standard, AVG(poster_amt_usd) avg_poster, AVG(gloss_amt_usd) avg_gloss
FROM accounts AS a, orders AS o
WHERE a.id = o.account_id
GROUP BY a.name;
// 350 results

SELECT s.name, w.channel, COUNT(channel) count
FROM sales_reps AS s, accounts AS a, web_events AS w
WHERE s.id = a.sales_rep_id AND a.id = w.account_id
GROUP BY s.name, w.channel
ORDER BY count DESC;

SELECT r.name, w.channel, COUNT(channel) count
FROM region AS r, sales_reps AS s, accounts AS a, web_events AS w
WHERE r.id = s.region_id AND s.id = a.sales_rep_id AND a.id = w.account_id
GROUP BY r.name, w.channel
ORDER BY count DESC;


// L3-20
// It’s worth noting that using DISTINCT, 
// particularly in aggregations, can slow your queries down quite a bit.

SELECT DISTINCT a.name account_name, r.name region_name
FROM accounts AS a, region AS r, sales_reps AS s
WHERE r.id = s.region_id AND s.id = a.sales_rep_id
ORDER BY account_name
// 351 results

SELECT DISTINCT a.name account_name, s.name agent_name
FROM accounts AS a,sales_reps AS s
WHERE s.id = a.sales_rep_id
ORDER BY agent_name


// L3-27
SELECT DATE_TRUNC('year', occurred_at) AS year, SUM(total_amt_usd)
FROM orders 
GROUP BY DATE_TRUNC('year', occurred_at)
ORDER BY SUM(total_amt_usd) DESC
// 2016-01-01T00:00:00.000Z	12864917.92

SELECT DATE_PART('month', occurred_at) AS year, SUM(total_amt_usd)
FROM orders 
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY DATE_PART('month', occurred_at)
ORDER BY SUM(total_amt_usd) DESC
// 12 month
// WHERE has to be before group BY

SELECT DATE_PART('year', occurred_at) AS year, COUNT(id)
FROM orders 
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY DATE_PART('year', occurred_at)
ORDER BY 2 DESC
/*
2016	12864917.92
2015	5752004.94
2014	4069106.54
*/

SELECT DATE_PART('month', occurred_at) AS year, COUNT(id)
FROM orders 
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY DATE_PART('month', occurred_at)
ORDER BY 2 DESC

SELECT DATE_TRUNC('month', o.occurred_at) AS year, SUM(o.gloss_amt_usd), a.name
FROM orders AS o, accounts AS a
WHERE o.account_id = a.id AND a.name = 'Walmart'
GROUP BY 1, 3
ORDER BY 2 DESC
LIMIT 1
// 2016-05-01T00:00:00.000Z	9257.64	Walmart
// Lack of o.account_id = a.id caused more unrelated data get into the results

















































