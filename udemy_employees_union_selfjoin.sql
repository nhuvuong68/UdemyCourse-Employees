DROP TABLE IF EXISTS emp_manager
CREATE TABLE emp_manager (
	emp_no INT NOT NULL,
	dept_no CHAR(4) NULL,
	manager_no INT NOT NULL
)
	--FOREIGN KEY (emp_no) REFERENCES employees (emp_no) DELETE ON CASCADE,
	--FOREIGN KEY (dept_no) REFERENCES departments (dept_no) DELETE ON CASCADE,
	--FOREIGN KEY (manager_no) REFERENCES dept
	--PRIMARY KEY (emp_no,manager_no)

INSERT INTO emp_manager 
SELECT 
	* 
FROM
	(SELECT
		e.emp_no,
		MIN(de.dept_no) AS dept_no,
		(SELECT
			emp_no
		FROM 
			employees
		WHERE
			emp_no = '110022') AS manager_no
	FROM 
		employees AS e
		JOIN dept_emp AS de ON e.emp_no = de.emp_no
	WHERE
		e.emp_no <= 10020
	GROUP BY 
		e.emp_no
	UNION
	(SELECT
		e.emp_no,
		MIN(de.dept_no) AS dept_no,
		(SELECT
			emp_no
		FROM 
			employees
		WHERE
			emp_no = '110039') AS manager_no
	FROM 
		employees AS e
		JOIN dept_emp AS de ON e.emp_no = de.emp_no
	WHERE
		e.emp_no > 10020 AND e.emp_no <= 10040
	GROUP BY 
		e.emp_no)
	UNION
	(SELECT
		e.emp_no,
		MIN(de.dept_no) AS dept_no,
		(SELECT
			emp_no
		FROM 
			employees
		WHERE
			emp_no = '110039') AS manager_no
	FROM 
		employees AS e
		JOIN dept_emp AS de ON e.emp_no = de.emp_no
	WHERE
		e.emp_no = 110022
	GROUP BY 
		e.emp_no)
	UNION
	(SELECT
		e.emp_no,
		MIN(de.dept_no) AS dept_no,
		(SELECT
			emp_no
		FROM 
			employees
		WHERE
			emp_no = '110022') AS manager_no
	FROM 
		employees AS e
		JOIN dept_emp AS de ON e.emp_no = de.emp_no
	WHERE
		e.emp_no = 110039
	GROUP BY
		e.emp_no)
	) AS U

-- SELF JOIN EXERCISE
SELECT
	e1.*
FROM
	emp_manager AS e1
	JOIN emp_manager AS e2 ON e1.emp_no = e2.manager_no
WHERE
	e2.emp_no IN (SELECT e2.manager_no FROM emp_manager AS e2)
