--VIEWS
CREATE OR ALTER VIEW manager_salary AS
SELECT 
	t.title AS title,
	ROUND (AVG (s.salary),2) AS average_salary
FROM
	employees AS e
	JOIN titles AS t ON e.emp_no = t.emp_no
	JOIN salaries AS s ON e.emp_no = s.emp_no
WHERE
	t.title = 'Manager'
GROUP BY
	t.title

-- PROCEDURE
CREATE PROCEDURE all_emp_avg_salary AS
BEGIN
	SELECT AVG(CAST(salary AS bigint))
	FROM salaries;
END;

EXEC all_emp_avg_salary

-- PROCEDURE WITH INPUT & OUTPUT
CREATE OR ALTER PROCEDURE emp_info 
	@p_first_name VARCHAR(14),
	@p_last_name VARCHAR(16),
	@p_emp_no INT OUTPUT
AS
BEGIN
	SET @p_emp_no = 
	(SELECT emp_no
	FROM employees AS e 
	WHERE e.first_name = @p_first_name AND e.last_name = @p_last_name)
END;

-- FUNCTION TO GET LATEST SALARY OF EMPLOYEE WITH INPUT: LAST & FIRST NAME
CREATE OR ALTER FUNCTION f_salary 
	(
	@f_first_name VARCHAR(14),
	@f_last_name VARCHAR(16)
	)
RETURNS INT
AS
BEGIN
	DECLARE @v_max_date DATE;
	SELECT @v_max_date = MAX(from_date)
	FROM salaries AS s 
	JOIN employees AS e ON e.emp_no = s.emp_no
	WHERE e.first_name = @f_first_name AND e.last_name = @f_last_name;

	DECLARE @f_salary INT;
	SELECT @f_salary = s.salary
	FROM salaries AS s 
	JOIN employees AS e ON e.emp_no = s.emp_no
	WHERE e.first_name = @f_first_name AND e.last_name = @f_last_name AND s.from_date >= @v_max_date
	RETURN @f_salary
END;

SELECT e.first_name, e.last_name, dbo.f_salary (e.first_name, e.last_name) AS 'Current Salary'
FROM employees AS e
WHERE e.first_name = 'Mary' AND e.last_name = 'Sluis'