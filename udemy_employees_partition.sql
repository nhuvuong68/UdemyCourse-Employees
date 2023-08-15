SELECT
	e.emp_no,
	ROW_NUMBER() OVER (ORDER BY e.emp_no ASC) AS row_num
FROM
	employees AS e
	JOIN dept_manager AS dm ON e.emp_no = dm.emp_no
WHERE
	dm.emp_no IS NOT NULL

SELECT
	e.emp_no,
	e.first_name,
	e.last_name,
	ROW_NUMBER() OVER(PARTITION BY e.first_name ORDER BY e.last_name ASC) AS row_num
FROM
	employees AS e

SELECT
	dm.emp_no,
	ROW_NUMBER() OVER(ORDER BY s.salary ASC) AS row_1,
	ROW_NUMBER() OVER(ORDER BY s.salary DESC) AS row_2
--	SELECT MIN(s.salary) AS min_salary
FROM
	dept_manager AS dm 
	JOIN salaries AS s ON dm.emp_no = s.emp_no
--WHERE
--	dm.emp_no IS NOT NULL AND e.hire_date = s.from_date
--GROUP BY
--	e.emp_no,
--	e.hire_date

SELECT
	e.emp_no,
	e.hire_date,
	s.from_date,
	s.to_date,
	s.salary
FROM
	employees AS e
	JOIN salaries AS s ON e.emp_no = s.emp_no
WHERE
	e.emp_no = '110022'


SELECT 
	e.emp_no,
	e.first_name,
	ROW_NUMBER() OVER (PARTITION BY e.first_name ORDER BY e.emp_no ASC) AS row_num
FROM
	employees AS e
WHERE
	e.first_name = 'Abdelghani'

--Find out the lowest salary value each employee has ever signed a contract for
SELECT a.emp_no, a.salary, a.row_num
FROM(
	SELECT
		s.emp_no,
		s.salary,
		ROW_NUMBER() OVER (PARTITION BY s.emp_no ORDER BY s.salary ASC) AS row_num
	FROM
		salaries AS s) AS a
WHERE
	a.row_num = 1
ORDER BY
	a.emp_no
SELECT
	s.emp_no,
	MIN(s.salary)
FROM
	salaries AS s
GROUP BY 
	s.emp_no

-- Obtain all salary values that employee number 10560 has ever signed a contract for.
-- Order and display the obtained salary values from highest to lowest.

SELECT 
	emp_no,
	salary,
	ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS salary_ranking
FROM
	salaries
WHERE
	emp_no = '10560'

SELECT 
	emp_no,
	salary,
	RANK() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS salary_ranking
FROM
	salaries
WHERE
	emp_no = '10560'

SELECT 
	emp_no,
	salary,
	DENSE_RANK() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS salary_dense_ranking
FROM
	salaries
WHERE
	emp_no = '10560'

--displays the number of salary contracts that each manager has ever signed while working in the company.
SELECT a.emp_no, MAX(a.row_num) AS number_salary_contracts
FROM(
	SELECT
		dm.emp_no,
		s.salary,
		ROW_NUMBER() OVER (PARTITION BY s.emp_no ORDER BY salary) AS row_num
	FROM
		dept_manager AS dm
		JOIN salaries AS s ON dm.emp_no = s.emp_no) AS a
GROUP BY a.emp_no
ORDER BY a.emp_no

SELECT
    dm.emp_no, (COUNT(salary)) AS no_of_salary_contracts
FROM
    dept_manager dm
	JOIN salaries s ON dm.emp_no = s.emp_no
GROUP BY dm.emp_no
ORDER BY dm.emp_no

SELECT
	d.dept_no,
	d.dept_name,
	dm.emp_no,
	RANK() OVER (PARTITION BY d.dept_no ORDER BY s.salary DESC) AS salary_ranking,
	s.salary,
	s.from_date AS salary_from_date,
	s.to_date AS salary_to_date,
	dm.from_date AS department_manager_from_date,
	dm.to_date AS department_manager_to_date
FROM
	dept_manager AS dm
		JOIN 
	departments AS d ON dm.dept_no = d.dept_no
		JOIN 
	salaries AS s ON dm.emp_no = s.emp_no
		AND s.from_date BETWEEN dm.from_date AND dm.to_date
		AND s.to_date BETWEEN dm.from_date AND dm.to_date


-- EXERCISE: ranks the salary values in descending order of all contracts signed by employees numbered between 10500 and 10600 inclusive.
SELECT 
	emp_no,
	salary,
	RANK() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS salary_rank
FROM
	salaries
WHERE emp_no BETWEEN 10500 AND 10600
ORDER BY emp_no ASC, salary DESC

SELECT
	e.emp_no,
	s.salary,
	RANK() OVER (PARTITION BY e.emp_no ORDER BY salary DESC) AS salary_rank,
	e.hire_date,
	s.from_date,
	DATEDIFF(YEAR, e.hire_date, s.from_date) AS date_dif
FROM
	employees AS e
		JOIN
	salaries AS s
		ON e.emp_no = s.emp_no
WHERE
	s.emp_no BETWEEN 10500 AND 10600
		AND
	DATEDIFF(YEAR, e.hire_date, s.from_date) >= 4

SELECT
	e.emp_no,
	s.salary,
	RANK() OVER (PARTITION BY e.emp_no ORDER BY salary DESC) AS salary_rank,
	e.hire_date,
	s.from_date,
	DATEDIFF(YEAR, e.hire_date, s.from_date) AS date_dif
FROM
	employees AS e
		JOIN
	salaries AS s
		ON e.emp_no = s.emp_no
		AND
		DATEDIFF(YEAR, e.hire_date, s.from_date) >= 4
WHERE
	s.emp_no BETWEEN 10500 AND 10600

-- Exercise Lag & Lead
SELECT
	e.emp_no,
	s.salary,
	LAG(s.salary) OVER (PARTITION BY e.emp_no ORDER BY salary ASC) AS previous_salary,
	LEAD(s.salary) OVER (PARTITION BY e.emp_no ORDER BY salary ASC) AS next_salary,
	s.salary - LAG(s.salary) OVER (PARTITION BY e.emp_no ORDER BY salary ASC) AS dif_with_previous_salary,
	LEAD(s.salary) OVER (PARTITION BY e.emp_no ORDER BY salary ASC) - s.salary AS dif_with_nex_salary
FROM
	employees AS e
		JOIN
	salaries AS s
		ON e.emp_no = s.emp_no
WHERE
	s.emp_no BETWEEN 10500 AND 10600
		AND
	s.salary > 80000

SELECT
	e.emp_no,
	s.salary,
	LAG(s.salary) OVER (PARTITION BY e.emp_no ORDER BY salary ASC) AS previous_salary,
	LAG(s.salary, 2) OVER (PARTITION BY e.emp_no ORDER BY salary ASC) AS preceding_previous_salary,
	LEAD(s.salary) OVER (PARTITION BY e.emp_no ORDER BY salary ASC) AS next_salary,
	LEAD(s.salary, 2) OVER (PARTITION BY e.emp_no ORDER BY salary ASC) AS subsequent_next_salary,
	s.salary - LAG(s.salary) OVER (PARTITION BY e.emp_no ORDER BY salary ASC) AS dif_with_previous_salary,
	LEAD(s.salary) OVER (PARTITION BY e.emp_no ORDER BY salary ASC) - s.salary AS dif_with_nex_salary
FROM
	employees AS e
		JOIN
	salaries AS s
		ON e.emp_no = s.emp_no
WHERE
	s.emp_no BETWEEN 10500 AND 10600
		AND
	s.salary > 80000

-- AGGREGATE WINDOW FUNCTION
SELECT
	s.emp_no,
	s.salary,
	s.from_date,
	s.to_date
FROM
	salaries AS s
		JOIN
	(SELECT
		emp_no,
		MIN (from_date) AS from_date
	FROM
		salaries
	GROUP BY 
		emp_no) AS s1 ON s.emp_no = s1.emp_no
WHERE
	s.from_date = s1.from_date
ORDER BY 
	emp_no

-- Exercise for Aggregate: - TO CHECK SYNTAX AGAIN
--Consider the employees' contracts that have been signed after the 1st of January 2000 and terminated before the 1st of January 2002 (as registered in the "dept_emp" table).
--Create a MySQL query that will extract the following information about these employees:
--- Their employee number
--- The salary values of the latest contracts they have signed during the suggested time period
--- The department they have been working in (as specified in the latest contract they've signed during the suggested time period)
--- Use a window function to create a fourth field containing the average salary paid in the department the employee was last working in during the suggested time period. Name that field "average_salary_per_department".
SELECT s2.emp_no,de2.dept_no,s2.salary,de2.from_date,de2.to_date, AVG(s2.salary) OVER (PARTITION BY de2.dept_no ORDER BY s2.salary) AS dept_avg_salary
FROM
	(SELECT
		s.emp_no,
		s.salary,
		s.from_date,
		s.to_date
	FROM
		salaries AS s
			JOIN
		(SELECT	emp_no, MAX(from_date) AS from_date
		FROM salaries
		GROUP BY emp_no) AS s1 ON s1.emp_no = s.emp_no
	WHERE
		s.from_date = s1.from_date
		AND s.from_date > '2000-01-01' 
		AND s.to_date <  '2002-01-01'
		) AS s2
		JOIN
	(SELECT
		de.emp_no,
		de.dept_no,
		de.from_date,
		de.to_date
	FROM
		dept_emp AS de
			JOIN
		(SELECT emp_no, MAX(from_date) AS from_date
		FROM dept_emp
		GROUP BY emp_no ) AS de1 ON de.emp_no = de1.emp_no
	WHERE
		de.from_date = de1.from_date
		AND de.from_date > '2000-01-01' 
		AND de.to_date < '2002-01-01'
		) AS de2 ON s2.emp_no = de2.emp_no
--WHERE		
--	de2.from_date BETWEEN '2000-01-01' AND '2002-01-01'
--	AND de2.to_date BETWEEN '2000-01-01' AND '2002-01-01'
ORDER BY s2.emp_no
