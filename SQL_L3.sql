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


// L3-23 
// HAVING is WHERE for aggregate clause, because WHERE 
// does not work on aggregate 
// HAVING is after GROUP BY but before ORDER BY
// WHERE is after FROM, JOIN ON, but before GROUP BY

// Q1 @@@@@@@@@@@@@@@   
SELECT s.name, COUNT(a.id)
FROM accounts AS a, sales_reps AS s 
WHERE s.id = a.sales_rep_id
HAVING COUNT(a.id) > 5;
ORDER BY s.name
// This false

SELECT s.name, COUNT(a.id)
FROM accounts AS a, sales_reps AS s 
WHERE s.id = a.sales_rep_id
GROUP BY s.name
HAVING COUNT(a.id) > 5
ORDER BY s.name
// 34 results
// This is the correct one. 
// 1. remember to include GROUP BY 
// 2. HAVING is after GROUP BY

// Q2 @@@@@@@@@@@@@@@ 
SELECT a.name, COUNT(o.id)
FROM accounts AS a, orders AS o
WHERE a.id = o.account_id
GROUP BY a.name
HAVING COUNT(o.id) > 20
ORDER BY a.name
// 120 result

// Q3 @@@@@@@@@@@@@@@ 
SELECT a.name, COUNT(o.id) as max_order
FROM accounts AS a, orders AS o
WHERE a.id = o.account_id
GROUP BY a.name
ORDER BY max_order DESC
LIMIT 1
// Leucadia National	71

// Q4 @@@@@@@@@@@@@@@ 
SELECT a.name, SUM(o.total_amt_usd)
FROM accounts AS a, orders AS o
WHERE a.id = o.account_id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY a.name
// aggregate cannot use alias
// 204 results	

// Q5 @@@@@@@@@@@@@@@ 
SELECT a.name, SUM(o.total_amt_usd)
FROM accounts AS a, orders AS o
WHERE a.id = o.account_id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY a.name
// 3 results

// Q6 @@@@@@@@@@@@@@@ 
SELECT a.name, SUM(o.total_amt_usd)
FROM accounts AS a, orders AS o
WHERE a.id = o.account_id
GROUP BY a.name
ORDER BY SUM(o.total_amt_usd) DESC
LIMIT 1
// EOG Resources	382873.30

// Q7 @@@@@@@@@@@@@@@ 
SELECT a.name, SUM(o.total_amt_usd)
FROM accounts AS a, orders AS o
WHERE a.id = o.account_id
GROUP BY a.name
ORDER BY SUM(o.total_amt_usd) 
LIMIT 1
// Nike	390.25

// Q8 @@@@@@@@@@@@@@@ 
SELECT a.name, COUNT(w.channel)
FROM web_events AS w, accounts AS a
WHERE a.id = w.account_id AND w.channel = 'facebook'
GROUP BY a.name
HAVING COUNT(w.channel) > 6
ORDER BY a.name
// 46 results
// w.channel = 'facebook' is the right answer
// w.channel = "facebook" does not work

// Q9 @@@@@@@@@@@@@@@ 
SELECT a.name, COUNT(w.channel)
FROM web_events AS w, accounts AS a
WHERE a.id = w.account_id AND w.channel = 'facebook'
GROUP BY a.name
ORDER BY COUNT(w.channel) DESC
LIMIT 1
// Gilead Sciences	16

// Q10 @@@@@@@@@@@@@@@
SELECT a.name, w.channel, COUNT(w.id)
FROM web_events AS w, accounts AS a
WHERE a.id = w.account_id
GROUP BY a.name, w.channel
ORDER BY COUNT(w.id) DESC, a.name;
// 1509 results
// Shows all company most used channel, order by total time of channel used
// if you want to sort the data with descend order, 
// DESC has to follow the clause right away











































