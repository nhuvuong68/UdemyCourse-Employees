USE employees

SELECT SYSDATETIME()

SELECT GETDATE()

SELECT FORMAT(GETDATE(),'yyyy-MM-dd')

--TRIGGER: Add a new row to 'Salary' when an employee is promoted to a manager (a new row to dept_manager)
CREATE TRIGGER update_salary_new_manager
ON dept_manager -- Trigger on 'dept_manager'
AFTER INSERT
AS
BEGIN
	DECLARE @New_emp_no INT
	SELECT @New_emp_no = emp_no FROM INSERTED -- To get the newly added emp_no
	
	DECLARE @New_to_date DATE
	SELECT @New_to_date = to_date FROM INSERTED -- To get newly added 'to_date'

	DECLARE @New_from_date DATE
	SELECT @New_from_date = from_date FROM INSERTED -- To get newly added 'from_date'

	DECLARE @v_curr_salary INT -- To get maximum current salary
	SELECT
		@v_curr_salary = MAX(salary)
	FROM
		salaries
	WHERE
		emp_no = @New_emp_no
	
	IF @v_curr_salary IS NOT NULL  -- Update last salary row 'to_date' to 'today'
		UPDATE salaries
		SET
			to_date = SYSDATETIME() -- Get 'today' time
		WHERE
			emp_no = @New_emp_no AND to_date = @New_to_date

	INSERT INTO salaries -- Insert latest row to 'salaries'
		VALUES (@New_emp_no, @v_curr_salary + 20000, @New_from_date, @New_to_date)

END;

-- Test value
INSERT INTO dept_manager
	VALUES(111534, 'd009', FORMAT(SYSDATETIME(),'yyyy-MM-dd'),'9999-01-01')

SELECT * FROM dept_manager WHERE emp_no = 111534

SELECT * FROM salaries WHERE emp_no = 111534

ROLLBACK;

-- TRIGGER To update hire_date to today if hire_date > today
CREATE TRIGGER update_hire_date
ON employees
AFTER INSERT
AS
BEGIN
	
	DECLARE @New_emp_no INT;
	SELECT @New_emp_no = emp_no FROM INSERTED

	DECLARE @hire_date DATE;
	SELECT @hire_date = MAX(hire_date) FROM employees

	IF @hire_date > SYSDATETIME()
	UPDATE employees
	SET
		hire_date = SYSDATETIME() -- Get 'today' time
	WHERE
		emp_no = @New_emp_no
END;
ROLLBACK;

INSERT INTO employees
	VALUES (00001, '9999-01-01','A','B','F','9999-01-01')

SELECT * FROM employees WHERE emp_no = '00001'

-- CREATE INDEX
CREATE INDEX i_composite_name 
ON employees (first_name, last_name)

-- DROP INDEX
ALTER TABLE employees
DROP INDEX i_composite_name

CREATE INDEX i_hire_date
ON employees (hire_date)

-- SYNTAX TO DROP INDEX IN MEMORY-OPTIMIZED TABLES
ALTER TABLE employees
DROP INDEX i_hire_date
-- SYNTAX TO DROP INDEX IN DISK-BASED TABLES
DROP INDEX i_hire_date
ON employees