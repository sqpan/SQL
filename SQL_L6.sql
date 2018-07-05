/*
Window function:
a window function performs a calculation across 
a set of table rows that are somehow related to the current row

OVER and PARTITION BY. These are key to window functions. Not every window function uses PARTITION BY;
we can also use ORDER BY or no statement at all depending on the query we want to run

*/
# L6-3
SELECT o.standard_amt_usd,
		SUM(standard_amt_usd) OVER (ORDER BY occurred_at)
FROM orders AS o
# running total of standard_amt_usd without group

// L6-5
SELECT o.occurred_at, o.standard_amt_usd,
		SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year',occurred_at) ORDER BY DATE_TRUNC('year',occurred_at))
FROM orders AS o

// L6-8
SELECT o.id, o.account_id, o.total,
	RANK() OVER (PARTITION BY account_id ORDER BY total DESC)
FROM orders AS o

/*
LAG() OVER () show the value of previous row value
LEAD() OVER() show the value of the next row value
*/

// L6-17
SELECT occurred_at,
       total_usd,
       LEAD(total_usd) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_usd) OVER (ORDER BY occurred_at) - total_usd AS lead_difference
FROM (
SELECT occurred_at,
       SUM(total_amt_usd) AS total_usd
  FROM orders 
 GROUP BY 1
 ) sub
/*
2013-12-04T04:22:44.000Z	627.48	2646.77	2019.29
2013-12-04T04:45:54.000Z	2646.77	2709.62	62.85
2013-12-04T04:53:25.000Z	2709.62	277.13	-2432.49
2013-12-05T20:29:16.000Z	277.13	3001.85	2724.72
2013-12-05T20:33:56.000Z	3001.85	2802.90	-198.95
*/



/*
You can use window functions to identify what percentile 
(or quartile, or any other subdivision)
a given row falls into. The syntax is NTILE(*# of buckets*)

In other words, when you use a NTILE function but the number of rows in the partition is 
less than the NTILE(number of groups), 
then NTILE will divide the rows into as many groups as there are members (rows) 
in the set but then stop short of the requested number of groups. 
If you’re working with very small windows,
 keep this in mind and consider using quartiles or similarly small bands.
*/
// L6-21
// Q1 @@@@@@@@@@@@@@@@@@@@@@@
SELECT account_id, occurred_at, standard_qty, NTILE(4) OVER(PARTITION BY account_id ORDER BY standard_qty) as quartile
FROM orders
ORDER BY account_id
/*
1001	2015-11-05T03:25:21.000Z	506	4
1001	2016-10-26T20:31:30.000Z	97	2
1001	2016-02-01T19:27:27.000Z	108	2
1001	2016-09-26T23:22:47.000Z	507	4
1001	2016-11-25T23:21:32.000Z	127	2
*/

// Q2 @@@@@@@@@@@@@@@@@@@@@@@
SELECT account_id, occurred_at, gloss_qty, NTILE(2) OVER(PARTITION BY account_id ORDER BY gloss_qty) as gloss_half
FROM orders
ORDER BY account_id
/*
1001	2015-10-06T17:31:14.000Z	22	1
1001	2016-02-01T19:27:27.000Z	29	1
1001	2015-12-04T04:21:55.000Z	47	2
1001	2016-03-02T15:29:32.000Z	24	1
1001	2016-12-24T05:53:13.000Z	127	2
*/

// Q3 @@@@@@@@@@@@@@@@@@@@@@@
SELECT account_id, occurred_at, total_amt_usd, NTILE(100) OVER(PARTITION BY account_id ORDER BY total_amt_usd) as total_percentile
FROM orders
ORDER BY account_id
/*
1001	2016-11-25T23:21:32.000Z	1283.12	24
1001	2016-02-01T19:07:32.000Z	8538.26	96
1001	2016-01-02T01:18:24.000Z	958.24	18
1001	2016-08-28T06:50:58.000Z	9134.31	98
1001	2015-12-04T04:01:09.000Z	9426.71	98
*/