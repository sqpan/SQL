# WHERE accounts.sales_rep_id IS NULL OR sales_reps.id IS NULL
# The above scentance can isolate the unmatch data in from accounts and sales_reps

# L7-6
SELECT a.name AS account_name, a.primary_poc AS primary, s.name AS sales_name
FROM accounts AS a
LEFT JOIN sales_reps AS s
ON s.id = a.sales_rep_id AND a.primary_poc < s.name

# L7-9
SELECT e1.id AS e1_id,
       e1.account_id AS e1_account_id,
       e1.occurred_at AS e1_occurred_at,
       e1.channel AS e1_channel,
       e2.id AS e2_id,
       e2.account_id AS e2_account_id,
       e2.occurred_at AS e2_occurred_at,
       e2.channel AS e2_channel
FROM web_events AS e1
LEFT JOIN web_events AS e2
   ON e1.account_id = e2.account_id
  AND e1.occurred_at > e2.occurred_at
  AND e1.occurred_at <= e2.occurred_at + INTERVAL '1 days'
ORDER BY e1.account_id, e2.occurred_at
/*
9148 results
1		1001	2015-10-06T17:13:58.000Z	direct	4394	1001	2015-10-06T04:22:11.000Z	facebook
4396	1001	2015-10-22T14:04:20.000Z	adwords	4395	1001	2015-10-22T05:02:47.000Z	organic
4397	1001	2015-11-05T17:18:54.000Z	direct	2		1001	2015-11-05T03:08:26.000Z	direct
4		1001	2016-01-02T00:55:03.000Z	direct	4399	1001	2016-01-01T15:45:54.000Z	adwords
8		1001	2016-05-01T15:26:44.000Z	direct	4406	1001	2016-05-01T14:26:40.000Z	direct
*/


/*
SQL's two strict rules for appending data:

Both tables must have the same number of columns.
Those columns must have the same data types in the same order as the first table.
A common misconception is that column names have to be the same. 
Column names, in fact, don't need to be the same to append two tables but you will find that they typically are.

UNION will only return the distinct data, UNION ALL will return all of data
*/
# L7-12
# Q1 @@@@@@@@@@@@@@@@@@@@@@@
SELECT *
FROM accounts AS a1
UNION ALL 
SELECT *
FROM accounts AS a2
# 702 reults

# Q2 @@@@@@@@@@@@@@@@@@@@@@@
WITH double_accounts AS(
    SELECT *
  	FROM accounts AS a1
  	UNION ALL 
  	SELECT *
  	FROM accounts AS a2)
    
SELECT da.name, COUNT(da.name) AS count
FROM double_accounts AS da
GROUP BY da.name
ORDER BY da.name


/*
One way to make a query run faster is to reduce the number of calculations that need to be performed. 
Some of the high-level things that will affect the number of calculations a given query will make include:

Table size
Joins
Aggregations
Query runtime is also dependent on some things that you can’t really control related to the database itself:

Other users running queries concurrently on the database
Database software and optimization (e.g. Postgres is optimized differently than Redshift)
*/


/*
Aggregations is executed before limit, so it won't help to fast the query
In this case, sub query will help to speed up
*/

# Add EXPLAIN before query can show the run time. 
# Try to change query and run it again to see if there is improve
# DISTINCT take a lot of time. it need to O(n) for every entry

WITH order1 AS (
	SELECT DATE_TRUNC('day', o.occurred_at) AS date,
			COUNT(a.sales_rep_id) AS active_sales_reps,
			COUNT(o.id) AS orders
	FROM accounts AS a 
	JOIN orders AS o
	ON o.account_id = a.id
	GROUP BY 1),
	web_event AS(
	SELECT DATE_TRUNC('day', w.occurred_at) AS date,
			COUNT(w.id) AS web_visits
	FROM web_events AS w
	GROUP BY 1)

SELECT COALESCE(order1.date, web_event.date) AS date,
		order1.active_sales_reps,
		order1.orders,
		web_event.web_visits
FROM order1 
FULL JOIN web_event
ON web_event.date = order1.date 
ORDER BY 1 DESC

# Be careful, since SQL is not case senstive, order cannot be used as alias name 


