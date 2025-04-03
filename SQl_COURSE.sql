# Select statement

SELECT * 
FROM employee_demographics;

SELECT first_name, last_name, birth_date, age, age + 10
FROM employee_demographics;

SELECT DISTINCT gender
FROM employee_demographics;

-- WHERE CLAUSE

SELECT *
FROM employee_salary
WHERE first_name = 'Leslie';

SELECT *
FROM employee_salary
WHERE salary > 50000;

SELECT *
FROM employee_demographics
WHERE gender != 'Female';

-- AND OR NOT -- LOGICAL OPERATORS

SELECT *
FROM employee_demographics
WHERE birth_date > '1985-01-01'
AND gender = 'male';

SELECT *
FROM employee_demographics
WHERE (first_name = 'Leslie' AND age = 44) OR age > 55;

-- LIKE STATEMENT
-- % and _
SELECT *
FROM employee_demographics
WHERE first_name LIKE 'Jer%';

-- GROUP BY

SELECT gender
FROM employee_demographics
GROUP BY gender;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;

SELECT occupation, salary
FROM employee_salary
GROUP BY occupation, salary;

-- ORDER BY

SELECT *
FROM employee_demographics
ORDER BY first_name DESC, age;

-- WHERE VS HAVING

SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40;

SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000;

-- LIMIT & ALIASING

SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 2, 1;

SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40;

-- JOINS

 SELECT dem.employee_id, age, occupation
 FROM employee_demographics AS dem
 INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;
-- OUTER JOINS

 SELECT *
 FROM employee_demographics AS dem
 RIGHT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;

-- SELF JOIN

SELECT emp1.employee_id AS emp_santa,
emp1.first_name AS first_name_santa,
emp1.last_name AS last_name_santa,
emp2.first_name AS first_name,
emp2.last_name AS last_name
FROM employee_salary AS emp1
JOIN employee_salary AS emp2
	ON emp1.employee_id + 1 = emp2.employee_id;
    

-- joining multiple tables together

 SELECT *
 FROM employee_demographics AS dem
 INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments pd
	ON sal.dept_id = pd.department_id;
    
SELECT * 
FROM parks_departments;    

-- Unions

SELECT first_name, last_name
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary
;

SELECT first_name, last_name, 'Old Man' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION 
SELECT first_name, last_name, 'Old Lady' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION 
SELECT first_name, last_name, 'Highly paid Employee' AS Label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name
;

-- String Functions

SELECT first_name, length(first_name)
FROM employee_demographics
ORDER BY 2
;

SELECT first_name, upper(first_name)
FROM employee_demographics;

SELECT TRIM('       sky   ');

SELECT first_name, 
LEFT(first_name, 4),
RIGHT(first_name, 4),
substring(first_name,3,2),
substring(birth_date,6,2) as birth_month
FROM employee_demographics;

SELECT first_name, REPLACE(first_name, 'a', 'z')
FROM employee_demographics;

SELECT locate('x', 'Alexander');

SELECT first_name, locate('An',first_name)
FROM employee_demographics;

SELECT first_name, last_name,
CONCAT(first_name,' ', last_name) AS full_name
FROM employee_demographics;

-- Case Statements

SELECT first_name,
last_name,
age,
CASE 
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 and 50 THEN 'Old'
    WHEN age >= 50 THEN "On Death's Door"
END AS Age_Bracket
FROM employee_demographics;

-- Pay increase and bonus
-- < 50000 = 5%
-- > 50000 = 7%
-- Finance = 10% bonus

SELECT first_name, last_name, salary,
CASE
	WHEN salary < 50000 THEN salary + (salary * 0.05)
    WHEN salary > 50000 THEN salary * 1.07
END AS New_Salary,
CASE
	WHEN dept_id = 6 THEN salary * 0.10
END AS Bonus
FROM employee_salary;

-- Subqueries

SELECT * 
FROM employee_demographics
WHERE employee_id IN 
				(SELECT employee_id
					FROM employee_salary
                    WHERE dept_id = 1)
;

SELECT first_name, salary,
(SELECT AVG(salary)
FROM employee_salary)
FROM employee_salary;


SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;

SELECT gender, AVG(`MAX(age)`)
FROM
(SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender) AS agg_table
GROUP BY gender
;

-- Window Functions

SELECT gender, AVG(salary) AS avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
;

SELECT dem.first_name, dem.last_name, gender, AVG(salary) OVER(PARTITION BY gender)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;

SELECT dem.first_name, dem.last_name, gender, salary,
SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_Total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
SELECT dem.first_name, dem.last_name, gender, salary,
ROW_NUMBER() OVER (PARTITION BY gender ORDER BY salary DESC) AS row_num,
RANK () OVER (PARTITION BY gender ORDER BY salary DESC) rank_num,
DENSE_RANK () OVER (PARTITION BY gender ORDER BY salary DESC) dense_rank_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
    
