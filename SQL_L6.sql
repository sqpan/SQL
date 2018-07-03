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

