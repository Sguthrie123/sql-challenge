-- Drop the tables to start fresh
DROP TABLE IF EXISTS dept_emp; 
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS titles; 
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS employees;

-- Create all neccessary tables for the transgering of data from the csv files.
CREATE TABLE department(
dept_no VARCHAR,
dept_name VARCHAR,
PRIMARY KEY (dept_no)
);

CREATE TABLE employees(
emp_no INTEGER,
birth_date VARCHAR, 
first_name VARCHAR,
last_name VARCHAR,
gender VARCHAR,
hire_date VARCHAR,
PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp(
emp_no INTEGER,
dept_no VARCHAR,
from_date VARCHAR,
to_date VARCHAR,
FOREIGN KEY (dept_no) REFERENCES department(dept_no),
FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE dept_manager(
dept_no VARCHAR,
emp_no INTEGER,
from_date VARCHAR,
to_date VARCHAR,
PRIMARY KEY (emp_no),
FOREIGN KEY (dept_no) REFERENCES department(dept_no)
);

CREATE TABLE salaries(
emp_no INTEGER, 
salary INTEGER,
from_date VARCHAR,
to_date VARCHAR,
PRIMARY KEY (emp_no),
FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE titles(
emp_no INTEGER,
title VARCHAR,
from_date VARCHAR,
to_date VARCHAR, 
FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

-- One way to transfer all the data from the csv's or you could manually import them from the clicking option
COPY department FROM '/Applications/PostgreSQL 12/temp-data/09-SQL_homework_assignment_data_departments.csv' DELIMITER ',' CSV HEADER;
COPY employees FROM '/Applications/PostgreSQL 12/temp-data/09-SQL_homework_assignment_data_employees.csv' DELIMITER ',' CSV HEADER;
COPY dept_emp FROM '/Applications/PostgreSQL 12/temp-data/09-SQL_homework_assignment_data_dept_emp.csv' DELIMITER ',' CSV HEADER;
COPY dept_manager FROM '/Applications/PostgreSQL 12/temp-data/09-SQL_homework_assignment_data_dept_manager.csv' DELIMITER ',' CSV HEADER;
COPY salaries FROM '/Applications/PostgreSQL 12/temp-data/09-SQL_homework_assignment_data_salaries.csv' DELIMITER ',' CSV HEADER;
COPY titles FROM '/Applications/PostgreSQL 12/temp-data/09-SQL_homework_assignment_data_titles.csv' DELIMITER ',' CSV HEADER;

-- Check to make sure the data is there in the tables.
SELECT * FROM department;
SELECT * FROM employees;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager; 
SELECT * FROM salaries;
SELECT * FROM titles;

-- List the following details of each employee: employee number, last name, first name, gender, and salary.
SELECT employees.emp_no, employees.first_name, employees.last_name, employees.gender, salaries.salary 
FROM employees 
JOIN salaries ON employees.emp_no = salaries.emp_no
ORDER BY employees.emp_no;

-- List employees who were hired in 1986.
SELECT * FROM employees WHERE hire_date LIKE '1986%' ORDER BY emp_no;

-- List the manager of each department with the following information: 
-- department number, department name, the manager's employee number, 
-- last name, first name, and start and end employment dates.
SELECT department.dept_name, dept_manager.dept_no, dept_manager.emp_no, employees.first_name, employees.last_name,
dept_manager.from_date, dept_manager.to_date
FROM department 
JOIN dept_manager ON department.dept_no = dept_manager.dept_no
JOIN employees ON employees.emp_no = dept_manager.emp_no;

-- List the department of each employee with the following information: 
-- employee number, last name, first name, and department name.
SELECT employees.emp_no, employees.first_name, employees.last_name, department.dept_name
FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN department ON department.dept_no = dept_emp.dept_no
ORDER BY emp_no;

-- List all employees whose first name is "Hercules" and last names begin with "B."
SELECT * FROM employees WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

-- List all employees in the Sales department, including their 
-- employee number, last name, first name, and department name.
SELECT employees.emp_no, employees.first_name, employees.last_name, department.dept_name 
FROM employees 
JOIN dept_emp ON dept_emp.emp_no = employees.emp_no 
JOIN department ON department.dept_no = dept_emp.dept_no
WHERE department.dept_name = 'Sales' ; 

-- List all employees in the Sales and Development departments, including their 
-- employee number, last name, first name, and department name.
-- The wording on this is questionable, I dont know if you want someone who works in both Sales and Development
-- Or do you mean all the people who work in sales and all who work is development 
-- If its the second one i just need to change AND TO OR on line 123. 
SELECT employees.emp_no, employees.first_name, employees.last_name, department.dept_name 
FROM employees 
JOIN dept_emp ON dept_emp.emp_no = employees.emp_no 
JOIN department ON department.dept_no = dept_emp.dept_no
WHERE department.dept_name = 'Sales' AND department.dept_name = 'Development' ; 

-- In descending order, list the frequency count of employee last names, 
-- i.e., how many employees share each last name.
SELECT last_name, COUNT(last_name) FROM employees GROUP BY last_name ORDER BY COUNT(last_name) DESC ;

