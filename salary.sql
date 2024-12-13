-- sql tutorials
-- key concepts and keywords 

-- 1) CREATE PROCEDURE : defines a new procedure.
-- 2) IN : indicates an input parameters, which is passed to the procedure when called.
-- 3) OUT : INDICATES an outout parameter, which is retuirend to the caller.
-- 4) INPUT : acts as both input and output for the procedure.
-- 5) DECLIMITER : Changes the default statmenmt delimiter to ude a custom one, allowing us to write compound statmenyts.
-- 6) BEGIN... END : Defines the block of code that makes up the procedure. 
-- Create the database
CREATE DATABASE salary_management;
USE salary_management;

-- Create Departments table
CREATE TABLE Departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

-- Insert sample data into Departments
INSERT INTO Departments (dept_name) VALUES
('HR'),
('Finance'),
('Engineering'),
('Marketing');

-- Create Employees table
CREATE TABLE Employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    dept_id INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Insert sample data into Employees
INSERT INTO Employees (emp_name, dept_id) VALUES
('Alice', 1), -- HR
('Bob', 2),   -- Finance
('Charlie', 3), -- Engineering
('Diana', 3), -- Engineering
('Eve', 4);   -- Marketing

-- Create Salaries table
CREATE TABLE Salaries (
    salary_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    salary_date DATE NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Insert sample data into Salaries
INSERT INTO Salaries (emp_id, salary, salary_date) VALUES
(1, 50000.00, '2024-01-01'), -- Alice
(2, 60000.00, '2024-01-01'), -- Bob
(3, 70000.00, '2024-01-01'), -- Charlie
(4, 80000.00, '2024-01-01'), -- Diana
(5, 55000.00, '2024-01-01'); -- Eve

DELIMITER //
CREATE PROCEDURE GetAvgSalaryByDept()
BEGIN
    SELECT d.dept_name, AVG(s.salary) AS avg_salary
    FROM Departments d
    JOIN Employees e ON d.dept_id = e.dept_id
    JOIN Salaries s ON e.emp_id = s.emp_id
    GROUP BY d.dept_name;
END //
DELIMITER ;
call GetAvgSalaryByDept();
drop PROCEDURE GetAvgSalaryByDept;

DELIMITER //
CREATE PROCEDURE GetAvgSalaryByDeptIN(
    IN input_dept_id INT
)
BEGIN
    SELECT dept_id, AVG(salary) AS avg_salary
    FROM salaries s
    JOIN employees e ON s.emp_id = e.emp_id
    WHERE e.dept_id = input_dept_id
    GROUP BY dept_id;
END //
DELIMITER ;
drop PROCEDURE GetAvgSalaryByDeptIN;
call GetAvgSalaryByDeptIN(1);
