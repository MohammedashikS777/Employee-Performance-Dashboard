CREATE DATABASE employees_perform;
USE employees_perform;

-- 1. Departments
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Locations
CREATE TABLE locations (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    location_name VARCHAR(100) NOT NULL UNIQUE
);

-- 3. Education
CREATE TABLE education (
    education_id INT PRIMARY KEY AUTO_INCREMENT,
    education_name VARCHAR(100) NOT NULL UNIQUE
);

-- 4. Employment Types
CREATE TABLE employment_types (
    employment_type_id INT PRIMARY KEY AUTO_INCREMENT,
    employment_type_name VARCHAR(50) NOT NULL UNIQUE
);

-- 5. Job Titles
CREATE TABLE job_titles (
    job_title_id INT PRIMARY KEY AUTO_INCREMENT,
    job_title_name VARCHAR(100) NOT NULL UNIQUE
);

-- 6. Employees
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE,
    department_id INT,
    job_title_id INT,
    location_id INT,
    employment_type_id INT,
    education_id INT,
    joining_date DATE,
    salary DECIMAL(12,2),
    age INT,
    experience_years DECIMAL(4,1),
    employee_status VARCHAR(30),
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (job_title_id) REFERENCES job_titles(job_title_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    FOREIGN KEY (employment_type_id) REFERENCES employment_types(employment_type_id),
    FOREIGN KEY (education_id) REFERENCES education(education_id)
);

-- 7. Performance Ratings
CREATE TABLE performance_ratings (
    rating_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    performance_rating INT,
    performance_level VARCHAR(50),
    rating_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- 8. Goals
CREATE TABLE goals (
    goal_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    goal_completion_percentage DECIMAL(5,2),
    goal_year YEAR,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- 9. Attendance
CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    attendance_percentage DECIMAL(5,2),
    attendance_year YEAR,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- 10. Training
CREATE TABLE training (
    training_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    training_hours INT,
    training_year YEAR,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- 11. Projects
CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(150) NOT NULL,
    department_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- 12. Employee Projects
CREATE TABLE employee_projects (
    employee_project_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    project_id INT NOT NULL,
    role_name VARCHAR(100),
    project_status VARCHAR(50),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- 13. Promotions
CREATE TABLE promotions (
    promotion_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    promotion_date DATE,
    old_job_title_id INT,
    new_job_title_id INT,
    promotion_status VARCHAR(50),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (old_job_title_id) REFERENCES job_titles(job_title_id),
    FOREIGN KEY (new_job_title_id) REFERENCES job_titles(job_title_id)
);

-- 14. Salaries
CREATE TABLE salaries (
    salary_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    salary_amount DECIMAL(12,2),
    effective_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- 15. Overtime
CREATE TABLE overtime (
    overtime_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    overtime_hours INT,
    overtime_year YEAR,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- 16. Leave Records
CREATE TABLE leave_records (
    leave_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    leave_days INT,
    leave_year YEAR,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- 17. Feedback
CREATE TABLE feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    feedback_date DATE,
    feedback_score INT,
    feedback_text VARCHAR(500),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- 18. Managers
CREATE TABLE managers (
    manager_id INT PRIMARY KEY AUTO_INCREMENT,
    manager_name VARCHAR(150) NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- 19. Employee Managers
CREATE TABLE employee_managers (
    employee_manager_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    manager_id INT NOT NULL,
    assigned_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (manager_id) REFERENCES managers(manager_id)
);

-- 20. Performance Reviews
CREATE TABLE performance_reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    review_date DATE,
    reviewer_name VARCHAR(150),
    overall_score DECIMAL(5,2),
    comments VARCHAR(500),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

use employees_perform;

-- Stagging Table (employee_performance_stagging): 

CREATE TABLE employee_performance_staging (
    employee_id INT,
    employee_name VARCHAR(150),
    email VARCHAR(150),
    department VARCHAR(100),
    job_title VARCHAR(100),
    location VARCHAR(100),
    employment_type VARCHAR(50),
    education VARCHAR(100),
    joining_date DATE,
    salary DECIMAL(12,2),
    age INT,
    experience_years DECIMAL(4,1),
    attendance_percentage DECIMAL(5,2),
    training_hours INT,
    projects_completed INT,
    performance_rating INT,
    performance_level VARCHAR(50),
    goal_completion_percentage DECIMAL(5,2),
    overtime_hours INT,
    leave_days INT,
    promotion_status VARCHAR(50),
    employee_status VARCHAR(30)
);

SELECT COUNT(*) AS total_rows
FROM employee_performance_staging;


-- After importing the CSV into employee_performance_staging,
-- lookup table insert:

INSERT IGNORE INTO departments (department_name)
SELECT DISTINCT department FROM employee_performance_staging;

INSERT IGNORE INTO locations (location_name)
SELECT DISTINCT location FROM employee_performance_staging;

INSERT IGNORE INTO education (education_name)
SELECT DISTINCT education FROM employee_performance_staging;

INSERT IGNORE INTO employment_types (employment_type_name)
SELECT DISTINCT employment_type FROM employee_performance_staging;

INSERT IGNORE INTO job_titles (job_title_name)
SELECT DISTINCT job_title FROM employee_performance_staging;

SELECT * FROM departments;

SELECT * FROM locations;

SELECT * FROM job_titles;

USE employees_perform;

-- Insert Employees:

INSERT INTO employees
(employee_id, employee_name, email, department_id, job_title_id, location_id,
 employment_type_id, education_id, joining_date, salary, age, experience_years, employee_status)
SELECT
    s.employee_id,
    s.employee_name,
    s.email,
    d.department_id,
    j.job_title_id,
    l.location_id,
    et.employment_type_id,
    e.education_id,
    s.joining_date,
    s.salary,
    s.age,
    s.experience_years,
    s.employee_status
FROM employee_performance_staging s
JOIN departments d ON d.department_name = s.department
JOIN job_titles j ON j.job_title_name = s.job_title
JOIN locations l ON l.location_name = s.location
JOIN employment_types et ON et.employment_type_name = s.employment_type
JOIN education e ON e.education_name = s.education;

SELECT COUNT(*) AS total_employees
FROM employees;

SELECT *
FROM employees
LIMIT 10;

-- Insert Performance Ratings Table :

USE employees_perform;

INSERT INTO performance_ratings
(
    employee_id,
    performance_rating,
    performance_level,
    rating_date
)
SELECT
    employee_id,
    performance_rating,
    performance_level,
    CURDATE()
FROM employee_performance_staging;

SELECT COUNT(*) AS total_performance_records
FROM performance_ratings;

USE employees_perform;

DELETE FROM performance_ratings;

SELECT *
FROM performance_ratings
LIMIT 10;

-- Goals Table :

INSERT INTO goals (employee_id, goal_completion_percentage, goal_year)
SELECT employee_id, goal_completion_percentage, YEAR(CURDATE())
FROM employee_performance_staging;

SELECT COUNT(*) AS total_goals
FROM goals;

-- Attendance Table :
INSERT INTO attendance (employee_id, attendance_percentage, attendance_year)
SELECT employee_id, attendance_percentage, YEAR(CURDATE())
FROM employee_performance_staging;

SELECT COUNT(*) AS total_attendance
FROM attendance;

-- Training Table:

INSERT INTO training (employee_id, training_hours, training_year)
SELECT employee_id, training_hours, YEAR(CURDATE())
FROM employee_performance_staging;

SELECT COUNT(*) AS total_training
FROM training;

-- Salaries Table :

INSERT INTO salaries (employee_id, salary_amount, effective_date)
SELECT employee_id, salary, joining_date
FROM employee_performance_staging;

SELECT COUNT(*) AS total_salaries
FROM salaries;

-- Overtime Table :

INSERT INTO overtime (employee_id, overtime_hours, overtime_year)
SELECT employee_id, overtime_hours, YEAR(CURDATE())
FROM employee_performance_staging;

SELECT COUNT(*) AS total_overtime
FROM overtime;

-- Leave_Records Table :

INSERT INTO leave_records (employee_id, leave_days, leave_year)
SELECT employee_id, leave_days, YEAR(CURDATE())
FROM employee_performance_staging;

SELECT COUNT(*) AS total_leave_records
FROM leave_records;

-- Promotion Table :

USE employees_perform;

INSERT INTO promotions
(
    employee_id,
    promotion_date,
    old_job_title_id,
    new_job_title_id,
    promotion_status
)
SELECT
    s.employee_id,
    s.joining_date,
    j.job_title_id,
    j.job_title_id,
    s.promotion_status
FROM employee_performance_staging s
JOIN job_titles j
    ON j.job_title_name = s.job_title;
    
SELECT COUNT(*) AS total_promotions
FROM promotions;

-- Project Table :

USE employees_perform;

INSERT INTO projects
(
    project_name,
    department_id,
    start_date,
    end_date
)
SELECT
    CONCAT(d.department_name, ' Performance Project'),
    d.department_id,
    CURDATE(),
    NULL
FROM departments d;

SELECT COUNT(*) AS total_projects
FROM projects;

-- employee_projects table :

USE employees_perform;

INSERT INTO employee_projects
(
    employee_id,
    project_id,
    role_name,
    project_status
)
SELECT
    e.employee_id,
    p.project_id,
    e.job_title_id,
    'Completed'
FROM employees AS e
INNER JOIN projects AS p
ON e.department_id = p.department_id;
    
SELECT COUNT(*) AS total_employee_projects
FROM employee_projects;

-- managers Table :

USE employees_perform;

INSERT INTO managers
(
    manager_name,
    department_id
)
SELECT
    CONCAT(d.department_name, ' Manager'),
    d.department_id
FROM departments AS d;

SELECT COUNT(*) AS total_managers
FROM managers;

-- employee_managers

USE employees_perform;

INSERT INTO employee_managers
(
    employee_id,
    manager_id,
    assigned_date
)
SELECT
    e.employee_id,
    m.manager_id,
    e.joining_date
FROM employees AS e
INNER JOIN managers AS m
    ON e.department_id = m.department_id;
    
 SELECT COUNT(*) AS total_employee_managers
FROM employee_managers; 

-- feedback table :

USE employees_perform;

INSERT INTO feedback
(
    employee_id,
    feedback_date,
    feedback_score,
    feedback_text
)
SELECT
    employee_id,
    CURDATE(),
    performance_rating,
    CONCAT(
        'Performance feedback: ',
        performance_level
    )
FROM employee_performance_staging; 

 SELECT COUNT(*) AS total_feedback
FROM feedback;

-- performance_reviews table :

USE employees_perform;

INSERT INTO performance_reviews
(
    employee_id,
    review_date,
    reviewer_name,
    overall_score,
    comments
)
SELECT
    employee_id,
    CURDATE(),
    'Department Manager',
    performance_rating,
    CONCAT(
        'Overall performance level: ',
        performance_level
    )
FROM employee_performance_staging;

SELECT COUNT(*) AS total_performance_reviews
FROM performance_reviews;

USE employees_perform;

SHOW TABLES;

SELECT COUNT(*) AS total_tables
FROM information_schema.tables
WHERE table_schema = 'employees_perform';

-- 40 SQL QUERIES FOR THIS PROJECT :

USE employees_perform;

-- 1. Display all employees :

SELECT *
FROM employees;

USE employees_perform;

SELECT COUNT(*) AS total_employees
FROM employees;

-- 2. Display employee name and salary :

SELECT employee_name, salary
FROM employees;

-- 3. Employees earning more than 50,000

SELECT employee_name, salary
FROM employees
WHERE salary > 50000;

-- 4. Employees with performance rating 5

SELECT e.employee_name, p.performance_rating
FROM employees e
JOIN performance_ratings p
    ON e.employee_id = p.employee_id
WHERE p.performance_rating = 5;

-- 5. Employees with attendance above 90%

SELECT e.employee_name, a.attendance_percentage
FROM employees e
JOIN attendance a
    ON e.employee_id = a.employee_id
WHERE a.attendance_percentage > 90;

-- 6. Employees with goal completion above 80%

SELECT e.employee_name, g.goal_completion_percentage
FROM employees e
JOIN goals g
    ON e.employee_id = g.employee_id
WHERE g.goal_completion_percentage > 80;

-- 7. Employees ordered by highest salary

SELECT employee_name, salary
FROM employees
ORDER BY salary DESC;

-- 8. Employees ordered by performance rating

SELECT e.employee_name, p.performance_rating
FROM employees e
JOIN performance_ratings p
    ON e.employee_id = p.employee_id
ORDER BY p.performance_rating DESC;

-- 9. Total number of employees

SELECT COUNT(*) AS total_employees
FROM employees;

-- 10. Average employee salary

SELECT AVG(salary) AS average_salary
FROM employees;

-- 11. Highest salary

SELECT MAX(salary) AS highest_salary
FROM employees;

-- 12. Lowest salary

SELECT MIN(salary) AS lowest_salary
FROM employees;

-- 13. Employee count by department

SELECT d.department_name,
       COUNT(e.employee_id) AS employee_count
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_name;

-- 14. Average salary by department

SELECT d.department_name,
       AVG(e.salary) AS average_salary
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_name;

-- 15. Highest salary by department

SELECT d.department_name,
       MAX(e.salary) AS highest_salary
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_name;

-- 16. Lowest salary by department

SELECT d.department_name,
       MIN(e.salary) AS lowest_salary
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_name;

-- 17. Average performance rating

SELECT AVG(performance_rating) AS average_rating
FROM performance_ratings;

-- 18. Number of employees by performance level

SELECT performance_level,
       COUNT(*) AS employee_count
FROM performance_ratings
GROUP BY performance_level;

-- 19. High-performing employees

SELECT e.employee_name,
       p.performance_rating,
       p.performance_level
FROM employees e
JOIN performance_ratings p
    ON e.employee_id = p.employee_id
WHERE p.performance_rating >= 4;

-- 20. Employees needing improvement

SELECT e.employee_name,
       p.performance_rating,
       p.performance_level
FROM employees e
JOIN performance_ratings p
    ON e.employee_id = p.employee_id
WHERE p.performance_rating <= 2;

-- 21. Average attendance by department

SELECT d.department_name,
       AVG(a.attendance_percentage) AS average_attendance
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
JOIN attendance a
    ON e.employee_id = a.employee_id
GROUP BY d.department_name;

-- 22. Average training hours by department

SELECT d.department_name,
       AVG(t.training_hours) AS average_training_hours
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
JOIN training t
    ON e.employee_id = t.employee_id
GROUP BY d.department_name;

-- 23. Employees with more than 50 training hours

SELECT e.employee_name,
       t.training_hours
FROM employees e
JOIN training t
    ON e.employee_id = t.employee_id
WHERE t.training_hours > 50;

-- 24. Employees with more than 20 overtime hours

SELECT e.employee_name,
       o.overtime_hours
FROM employees e
JOIN overtime o
    ON e.employee_id = o.employee_id
WHERE o.overtime_hours > 20;

-- 25. Employees with more than 15 leave days

SELECT e.employee_name,
       l.leave_days
FROM employees e
JOIN leave_records l
    ON e.employee_id = l.employee_id
WHERE l.leave_days > 15;

-- 26. Average goal completion by department

SELECT d.department_name,
       AVG(g.goal_completion_percentage) AS average_goal_completion
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
JOIN goals g
    ON e.employee_id = g.employee_id
GROUP BY d.department_name;

-- 27. Employees earning above the company average

SELECT employee_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

-- 28. Top 10 highest-paid employees

SELECT employee_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 10;

-- 29. Top 10 employees by performance rating

SELECT e.employee_name,
       p.performance_rating
FROM employees e
JOIN performance_ratings p
    ON e.employee_id = p.employee_id
ORDER BY p.performance_rating DESC
LIMIT 10;

-- 30. Employees with goal completion above 90%

SELECT e.employee_name,
       g.goal_completion_percentage
FROM employees e
JOIN goals g
    ON e.employee_id = g.employee_id
WHERE g.goal_completion_percentage > 90;

-- 31. High performance + high attendance

SELECT e.employee_name,
       p.performance_rating,
       a.attendance_percentage
FROM employees e
JOIN performance_ratings p
    ON e.employee_id = p.employee_id
JOIN attendance a
    ON e.employee_id = a.employee_id
WHERE p.performance_rating >= 4
  AND a.attendance_percentage >= 90;
  
-- 32. High performance but low attendance

SELECT e.employee_name,
       p.performance_rating,
       a.attendance_percentage
FROM employees e
JOIN performance_ratings p
    ON e.employee_id = p.employee_id
JOIN attendance a
    ON e.employee_id = a.employee_id
WHERE p.performance_rating >= 4
  AND a.attendance_percentage < 80;
  
-- 33. High training + high performance

SELECT e.employee_name,
       t.training_hours,
       p.performance_rating
FROM employees e
JOIN training t
    ON e.employee_id = t.employee_id
JOIN performance_ratings p
    ON e.employee_id = p.employee_id
WHERE t.training_hours > 50
  AND p.performance_rating >= 4;
  
-- 34. Average salary by job title

SELECT j.job_title_name,
       AVG(e.salary) AS average_salary
FROM job_titles j
JOIN employees e
    ON j.job_title_id = e.job_title_id
GROUP BY j.job_title_name;

-- 35. Employee count by location

SELECT l.location_name,
       COUNT(e.employee_id) AS employee_count
FROM locations l
JOIN employees e
    ON l.location_id = e.location_id
GROUP BY l.location_name;

-- 36. Employee count by employment type

SELECT et.employment_type_name,
       COUNT(e.employee_id) AS employee_count
FROM employment_types et
JOIN employees e
    ON et.employment_type_id = e.employment_type_id
GROUP BY et.employment_type_name;

-- 37. Promotion status analysis

SELECT promotion_status,
       COUNT(*) AS employee_count
FROM promotions
GROUP BY promotion_status;

-- 38. Overall dashboard summary

SELECT
    COUNT(e.employee_id) AS total_employees,
    ROUND(AVG(e.salary), 2) AS average_salary,
    ROUND(AVG(p.performance_rating), 2) AS average_performance_rating,
    ROUND(AVG(a.attendance_percentage), 2) AS average_attendance,
    ROUND(AVG(g.goal_completion_percentage), 2) AS average_goal_completion
FROM employees e
JOIN performance_ratings p
    ON e.employee_id = p.employee_id
JOIN attendance a
    ON e.employee_id = a.employee_id
JOIN goals g
    ON e.employee_id = g.employee_id;
    
-- 39. Find high-performing employees using multiple KPIs

SELECT
    e.employee_name,
    p.performance_rating,
    a.attendance_percentage,
    g.goal_completion_percentage
FROM employees e
JOIN performance_ratings p
    ON e.employee_id = p.employee_id
JOIN attendance a
    ON e.employee_id = a.employee_id
JOIN goals g
    ON e.employee_id = g.employee_id
WHERE p.performance_rating >= 4
  AND a.attendance_percentage >= 90
  AND g.goal_completion_percentage >= 80;
  
-- 40. Department performance dashboard

SELECT
    d.department_name,
    COUNT(e.employee_id) AS total_employees,
    ROUND(AVG(e.salary), 2) AS average_salary,
    ROUND(AVG(p.performance_rating), 2) AS average_rating,
    ROUND(AVG(a.attendance_percentage), 2) AS average_attendance,
    ROUND(AVG(g.goal_completion_percentage), 2) AS average_goal_completion,
    ROUND(AVG(t.training_hours), 2) AS average_training_hours
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
JOIN performance_ratings p
    ON e.employee_id = p.employee_id
JOIN attendance a
    ON e.employee_id = a.employee_id
JOIN goals g
    ON e.employee_id = g.employee_id
JOIN training t
    ON e.employee_id = t.employee_id
GROUP BY d.department_name
ORDER BY average_rating DESC;

use employees_perform;








