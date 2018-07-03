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

//175. Combine Two Tables
SELECT p.FirstName, p.LastName, a.City, a.State
FROM Person as p
LEFT JOIN Address as a
ON a.PersonId = p.PersonId

//181. Employees Earning More Than Their Managers
SELECT t1.Name AS Employee
FROM Employee AS t1, Employee AS t2
WHERE t1.ManagerId = t2.Id AND t1.Salary > t2.Salary;

//183. Customers Who Never Order
// Method 1
SELECT A.Name from Customers A
WHERE NOT EXISTS (SELECT 1 FROM Orders B WHERE A.Id = B.CustomerId)
// Method 2
SELECT A.Name from Customers A
LEFT JOIN Orders B on  a.Id = B.CustomerId
WHERE b.CustomerId is NULL
// Method 3
SELECT A.Name from Customers A
WHERE A.Id NOT IN (SELECT B.CustomerId from Orders B)

//596. Classes More Than 5 Students
SELECT class
FROM courses
GROUP BY class
HAVING COUNT(DISTINCT student) >= 5
// be careful with the distint part
// there are entry with same data in the Table, they are not counted as differnt student