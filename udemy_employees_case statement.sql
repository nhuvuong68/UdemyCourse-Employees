-- CASE STATEMENT

-- add 1 column 'Is manager' using CASE
SELECT
	e.emp_no,
	e.first_name,
	e.last_name,
	CASE 
		WHEN dm.emp_no IS NOT NULL THEN 'Manager'
		ELSE 'Employee'
	END AS 'Is manager'
FROM
	employees AS e
	JOIN dept_manager AS dm ON e.emp_no = dm.emp_no
WHERE e.emp_no > 109990

-- 1 column: Difference btw max & min salary + 1 column: salary raise > 30000 or NOT
SELECT
	e.emp_no,
	e.first_name,
	e.last_name,
	MAX(s.salary) - MIN(s.salary) AS salary_raise,
	CASE
		WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary raise is higher than 30000'
		WHEN MAX(s.salary) - MIN(s.salary) <= 30000 THEN 'Salary raise is less than 30000'
	END AS remark
FROM
	employees AS e
	JOIN salaries AS s ON e.emp_no = s.emp_no
GROUP BY
	e.emp_no,
	e.first_name,
	e.last_name

-- Check 'is_still_employee'
SELECT TOP (100)
	e.emp_no,
	e.first_name,
	e.last_name,
	de.to_date,
	CASE 
		WHEN MAX(de.to_date) >= SYSDATETIME() THEN 'Is still employeed'
		WHEN MAX(de.to_date) < SYSDATETIME() THEN 'Not an employee anymore'
	END AS current_employee
FROM
	employees AS e
	JOIN dept_emp AS de ON e.emp_no = de.emp_no
GROUP BY
	e.emp_no,
	e.first_name,
	e.last_name,
	de.to_date
	

