// L5-3
// LEFT(column_name, position)  POSITION IS INCLUDED
// RIGHT(column_name, position)	POSITION IS INCLUDED
// LENGTH(column_name)

// Q1 @@@@@@@@@@@@@@@@@@@@@@@
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

// Q2 @@@@@@@@@@@@@@@@@@@@@@@
WITH init AS (
  	SELECT a.name, LEFT(a.name, 1) AS first_letter
	FROM accounts AS a)
    
SELECT first_letter, COUNT(first_letter)
FROM init
GROUP BY first_letter
ORDER BY 2 DESC

// Q3 @@@@@@@@@@@@@@@@@@@@@@@
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

// Q4 @@@@@@@@@@@@@@@@@@@@@@@
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

// L5-6
// POSITION(',' IN city_state).
//  STRPOS(city_state, ',')

// Q1 @@@@@@@@@@@@@@@@@@@@@@@
SELECT primary_poc, 
	LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) AS fname, 
	/* be careful, need to - 1, or space will be included */
	RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) AS lname                    
FROM accounts


// Q2 @@@@@@@@@@@@@@@@@@@@@@@
SELECT name, 
	LEFT(name, STRPOS(name, ' ') - 1 ) AS fname, 
	/* be careful, need to - 1, or space will be included */
	RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) AS lname                    
FROM sales_reps

// L5-9
// CONCAT(first_name, ' ', last_name) 
// or with piping as first_name || ' ' || last_name
// Q1 @@@@@@@@@@@@@@@@@@@@@@@
WITH name AS(
	SELECT LEFT(primary_poc, STRPOS(primary_poc,' ') - 1) AS fname,
		RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc,' ')) AS lname,
		a.name AS aname
	FROM sales_reps AS s, accounts AS a 
	WHERE s.id = a.sales_rep_id
)

SELECT fname || '.' || lname || '@' || aname || '.com'
FROM name

// Q2 @@@@@@@@@@@@@@@@@@@@@@@
// REPLACE(target_data, orign, change_to)
WITH name AS(
	SELECT LEFT(primary_poc, STRPOS(primary_poc,' ') - 1) AS fname,
		RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc,' ')) AS lname,
		a.name AS aname
	FROM sales_reps AS s, accounts AS a 
	WHERE s.id = a.sales_rep_id
)

SELECT fname || '.' || lname || '@' || REPLACE(aname, ' ', '') || '.com'
FROM name

// Q3 @@@@@@@@@@@@@@@@@@@@@@@
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
