// 595 Big Country
SELECT name, population, area
FROM world
WHERE area > 3000000 OR population > 25000000

// 627 Swap Salary
UPDATE salary
SET sex = CASE sex
    WHEN 'm' THEN 'f'
    ELSE 'm'
    END;

// 620 Not Boring Movies
SELECT * 
FROM cinema
WHERE id % 2 = 1 AND description not like '%boring%'
ORDER BY rating DESC
// not like '%boring%' is not equals

// 182 Duplicate Emails
SELECT Email
FROM Person
GROUP BY Email 
HAVING count(Email) > 1;