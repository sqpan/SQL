# 595 Big Country
SELECT name, population, area
FROM world
WHERE area > 3000000 OR population > 25000000

# 627 Swap Salary
UPDATE salary
SET sex = CASE sex
    WHEN 'm' THEN 'f'
    ELSE 'm'
    END;

# 620 Not Boring Movies
SELECT * 
FROM cinema
WHERE id % 2 = 1 AND description not like '%boring%'
ORDER BY rating DESC
# not like '%boring%' is not equals

# 182 Duplicate Emails
SELECT Email
FROM Person
GROUP BY Email 
HAVING count(Email) > 1;

#175. Combine Two Tables
SELECT p.FirstName, p.LastName, a.City, a.State
FROM Person as p
LEFT JOIN Address as a
ON a.PersonId = p.PersonId

#181. Employees Earning More Than Their Managers
SELECT t1.Name AS Employee
FROM Employee AS t1, Employee AS t2
WHERE t1.ManagerId = t2.Id AND t1.Salary > t2.Salary;

#183. Customers Who Never Order
# Method 1
SELECT A.Name from Customers A
WHERE NOT EXISTS (SELECT 1 FROM Orders B WHERE A.Id = B.CustomerId)
# Method 2
SELECT A.Name from Customers A
LEFT JOIN Orders B on  a.Id = B.CustomerId
WHERE b.CustomerId is NULL
# Method 3
SELECT A.Name from Customers A
WHERE A.Id NOT IN (SELECT B.CustomerId from Orders B)

#596. Classes More Than 5 Students
SELECT class
FROM courses
GROUP BY class
HAVING COUNT(DISTINCT student) >= 5
# be careful with the distint part
# there are entry with same data in the Table, they are not counted as differnt student

# 197. Rising Temperature
SELECT w1.Id
FROM Weather AS w1, Weather AS w2
WHERE TO_DAYS(w1.RecordDate) - TO_DAYS(w2.RecordDate) = 1 
	AND w1.Temperature > w2.Temperature;

# 196. Delete Duplicate Emails
DELETE p1
FROM Person as p1, Person AS p2
WHERE p1.Email = p2.Email AND p1.Id > p2.Id;

# 176. Second Highest Salary
SELECT MAX(Salary) AS SecondHighestSalary
FROM Employee 
WHERE Salary NOT IN (SELECT MAX(Salary) FROM Employee);

# 626. Exchange Seats
SELECT s1.Id + 1 AS Id, s1.student
FROM seat AS s1
WHERE MOD(s1.Id, 2) = 1 AND s1.Id != (SELECT MAX(seat.Id) FROM seat)
# if use s1.Id != (SELECT MAX(s1.Id) FROM seat), will generate extra row
UNION
# Origin even row become odd row
SELECT s2.Id - 1 AS Id, s2.student
FROM seat AS s2
WHERE MOD(s2.Id, 2) = 0
UNION 
# if there is a final odd row, put it at last
SELECT s3.Id, s3.student
FROM seat AS s3
WHERE MOD(s3.Id, 2) = 1 AND s3.Id = (SELECT MAX(s3.Id) FROM seat)
# similar with line 76, use seat instead of s3
ORDER BY Id

# 180. Consecutive Numbers
SELECT DISTINCT l1.Num AS ConsecutiveNums
FROM Logs l1, Logs l2, Logs l3
WHERE l1.Num = l2.Num AND l2.Num = l3.Num AND l1.Id + 1 = l2.Id AND l2.Id + 1 = l3.Id
 
# 184. Department Highest Salary
SELECT d.Name AS Department, e.Name AS Employee, m.Max AS Salary
FROM Department d, 
    (SELECT max(e.Salary) AS Max, e.DepartmentId FROM Employee e GROUP BY e.DepartmentId) AS m,
    Employee e
WHERE m.DepartmentId = d.Id AND m.Max = e.Salary AND d.ID = e.DepartmentID
/* Bugs
 	1. SELECT e.name, max(e.Salary) AS Max, e.DepartmentId FROM Employee e GROUP BY e.DepartmentId
	will generate a table with each department's highest salary with first name of department.
	The name is not match to the highest salary
	2. WHERE condition need to add d.ID = e.DepartmentID, or it generates cross join of highest 
	salary with every department name
*/
	 

