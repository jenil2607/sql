-- sql tutorials

-- 1. Stored Procedures

-- key concepts and keywords 

-- 1) CREATE PROCEDURE : defines a new procedure.departmentsdept_iddept_id
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

DELIMITER //
CREATE PROCEDURE GetAvgSalaryByDeptOUT(
    OUT overall_avg_salary FLOAT
)
BEGIN
    SELECT AVG(salary) INTO overall_avg_salary
    FROM salaries;
END //
DELIMITER ;

CALL GetAvgSalaryByDeptOUT(@avg_salary);
SELECT @avg_salary; -- Retrieve the output parameter value.

DELIMITER //
CREATE PROCEDURE GetAvgSalaryByDeptINOUT(
    IN input_dept_id INT,
    OUT avg_salary FLOAT
)
BEGIN
    SELECT AVG(salary) INTO avg_salary
    FROM salaries s
    JOIN employees e ON s.emp_id = e.emp_id
    WHERE e.dept_id = input_dept_id;
END //
DELIMITER ;

CALL GetAvgSalaryByDeptINOUT(2, @avg_salary); -- Replace 1 with the desired department ID.
SELECT @avg_salary; -- Retrieve the output parameter value.

DELIMITER //

CREATE PROCEDURE GetDeptDetailsINOUT(
    INOUT input_dept_id INT,
    OUT avg_salary FLOAT
)
BEGIN
    -- Calculate average salary for the given department
    SELECT AVG(s.salary) INTO avg_salary
    FROM salaries s
    JOIN employees e ON s.emp_id = e.emp_id
    WHERE e.dept_id = input_dept_id;

    -- Update input_dept_id to reflect the number of employees in the department
    SELECT COUNT(*) INTO input_dept_id
    FROM employees
    WHERE dept_id = input_dept_id;
END //

DELIMITER ;

SET @dept_id = 1; -- Replace 2 with the desired department ID
CALL GetDeptDetailsINOUT(@dept_id, @avg_salary);
SELECT @dept_id AS employee_count, @avg_salary AS avg_salary; -- Retrieve updated values

-- 2. Functions

--  Key Concepts and Keywords

-- 1) CREATE FUNCTION: Defines a new function.
-- 2) RETURNS: Specifies the data type of the value returned by the function.
-- 3) RETURN: Specifies the value to return when the function is called.
-- 4) DECLARE: Used to define variables inside the function.


DELIMITER //

CREATE FUNCTION GetTotalSalary(emp_id_in INT)
RETURNS DECIMAL(10, 2)
    NOT DETERMINISTIC
    READS SQL DATA
BEGIN
    DECLARE total_salary DECIMAL(10, 2);
    SELECT SUM(salary) INTO total_salary
    FROM Salaries
    WHERE emp_id = emp_id_in;
    RETURN total_salary;
END //

DELIMITER ;
drop function GetTotalSalary;-- 
SELECT GetTotalSalary(2); -- Replace '1' with the Employee ID

select sum(salary) from salaries where emp_id = 1;

-- 3. Triggers
-- A trigger is a database object that is automatically executed (or "triggered") in response to certain events on a table, such as INSERT, UPDATE, or DELETE.

create TABLE AuditLog (
    log_id int auto_increment primary key,
    emp_id INT not null,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    change_date timestamp default current_timestamp,
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id) on delete cascade -- i delete casecade :- if we are deleting emp_id then when ever reference of emp_id available thire also delete emp_id
);
select * from AuditLog;

DELIMITER //
CREATE TRIGGER AuditSalaryUpdate
AFTER UPDATE ON Salaries
FOR EACH ROW
BEGIN
    -- Retrieve the emp_id using the foreign key relationship
    INSERT INTO AuditLog (emp_id, old_salary, new_salary, change_date)
    VALUES (
        (SELECT emp_id FROM Employees WHERE emp_id = OLD.emp_id), 
        OLD.salary, 
        NEW.salary, 
        NOW()
    );
END //
DELIMITER ;

UPDATE Salaries
SET salary = 100000.00
WHERE emp_id = 1;