# L5-3
# LEFT(column_name, position)  POSITION IS INCLUDED
# RIGHT(column_name, position)	POSITION IS INCLUDED
# LENGTH(column_name)

# Q1 @@@@@@@@@@@@@@@@@@@@@@@
WITH web AS (
  	SELECT a.name, RIGHT(a.website, 3) AS last_three
	FROM accounts AS a)
    
SELECT last_three, COUNT(last_three)
FROM web
GROUP BY last_three
/* 
net	1
com	349
org	1
*/

# Q2 @@@@@@@@@@@@@@@@@@@@@@@
WITH init AS (
  	SELECT a.name, LEFT(a.name, 1) AS first_letter
	FROM accounts AS a)
    
SELECT first_letter, COUNT(first_letter)
FROM init
GROUP BY first_letter
ORDER BY 2 DESC

# Q3 @@@@@@@@@@@@@@@@@@@@@@@
WITH init AS (
  	SELECT a.name, LEFT(a.name, 1) AS first_letter,
  		CASE WHEN LEFT(a.name, 1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 'Number'
  			 ELSE 'Letter' END AS type
	FROM accounts AS a)
/* CASE WHEN THEN
		WHEN THEN
		ELSE END
*/
    
SELECT type, COUNT(type) AS type_count
FROM init
GROUP BY 1
ORDER BY 2 DESC
/*
Letter	350
Number	1
*/

# Q4 @@@@@@@@@@@@@@@@@@@@@@@
WITH init AS (
  	SELECT a.name, LEFT(a.name, 1) AS first_letter,
  		CASE WHEN LEFT(a.name, 1) IN ('a','e','i','o','u','A','E','I','O','U') THEN 'Vowel'
  			 ELSE 'Other' END AS type
	FROM accounts AS a)

SELECT type, COUNT(type) AS type_count
FROM init
GROUP BY 1
ORDER BY 2 DESC
/*
Other	271
Vowel	80
*/

# L5-6
# POSITION(',' IN city_state).
#  STRPOS(city_state, ',')

# Q1 @@@@@@@@@@@@@@@@@@@@@@@
SELECT primary_poc, 
	LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) AS fname, 
	/* be careful, need to - 1, or space will be included */
	RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) AS lname                    
FROM accounts


# Q2 @@@@@@@@@@@@@@@@@@@@@@@
SELECT name, 
	LEFT(name, STRPOS(name, ' ') - 1 ) AS fname, 
	/* be careful, need to - 1, or space will be included */
	RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) AS lname                    
FROM sales_reps

# L5-9
# CONCAT(first_name, ' ', last_name) 
# or with piping as first_name || ' ' || last_name
# Q1 @@@@@@@@@@@@@@@@@@@@@@@
WITH name AS(
	SELECT LEFT(primary_poc, STRPOS(primary_poc,' ') - 1) AS fname,
		RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc,' ')) AS lname,
		a.name AS aname
	FROM sales_reps AS s, accounts AS a 
	WHERE s.id = a.sales_rep_id
)

SELECT fname || '.' || lname || '@' || aname || '.com'
FROM name

# Q2 @@@@@@@@@@@@@@@@@@@@@@@
# REPLACE(target_data, orign, change_to)
WITH name AS(
	SELECT LEFT(primary_poc, STRPOS(primary_poc,' ') - 1) AS fname,
		RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc,' ')) AS lname,
		a.name AS aname
	FROM sales_reps AS s, accounts AS a 
	WHERE s.id = a.sales_rep_id
)

SELECT fname || '.' || lname || '@' || REPLACE(aname, ' ', '') || '.com'
FROM name

# Q3 @@@@@@@@@@@@@@@@@@@@@@@
WITH name AS(
	SELECT LEFT(primary_poc, STRPOS(primary_poc,' ') - 1) AS fname,
		RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc,' ')) AS lname,
		a.name AS aname
	FROM sales_reps AS s, accounts AS a 
	WHERE s.id = a.sales_rep_id
)

SELECT name.fname, name.lname, name.aname, LOWER(LEFT(fname,1)) || LOWER(RIGHT(fname,1)) || LOWER(LEFT(lname,1)) || LOWER(RIGHT(lname,1)) 
		|| LENGTH(fname) || LENGTH(lname) || UPPER(REPLACE(aname,' ','')) AS password
FROM name
ORDER BY 4                                                    
/*
aabt36LANDO'LAKES
aabt84BIOGEN
aacr77XCELENERGY
aadr59EOGRESOURCES
aaia59PHILIPMORRISINTERNATIONAL
*/

# L5-12
# TO_DATE(month, 'month')  	this function change a string type month data into data
# CAST(data_column AS DATE)  	this function cast the variable type
# DATE_PART(month, '2013/01/01') 	will return 01
# DATE_TRUNC('year', occurred_at) 	will return '20xx/01/01'
# SUBSTR (str, position, [length])
SELECT date, SUBSTR(date, 7,4) || '/' || SUBSTR(date, 1, 5) AS monthAndDay,
		CAST(SUBSTR(date, 7,4) || '/' || SUBSTR(date, 1, 5) AS DATE) AS newDate
FROM sf_crime_data

# L5-15
# COALESCE(expr1, expr2, ...., expr_n)	return the first not NULL value
# SELECT COALESCE(NULL, 1, 2, 'W3Schools.com');	return 1

# STEP 1
SELECT *
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;
# 	Goldman Sachs Group	www.gs.com	40.75744399	-73.96730918	Loris Manfredi	321690										

# STEP 2
SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, o.*
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;
# 1731	Goldman Sachs Group	www.gs.com	40.75744399	-73.96730918	Loris Manfredi	321690											

#STEP 3
SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, o.standard_qty, o.gloss_qty, o.poster_qty, o.total, o.standard_amt_usd, o.gloss_amt_usd, o.poster_amt_usd, o.total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;
# 1731	Goldman Sachs Group	www.gs.com	40.75744399	-73.96730918	Loris Manfredi	321690	1731									


#STEP 4
SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;
# 1731	Goldman Sachs Group	www.gs.com	40.75744399	-73.96730918	Loris Manfredi	321690	1731		0	0	0	0	0	0	0	0

# STEP 5
SELECT COUNT(a.id)
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
# 6913

# STEP 6
SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;

