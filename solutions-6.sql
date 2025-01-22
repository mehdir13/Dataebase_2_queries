/* ### 6
https://leetcode.com/problems/find-total-time-spent-by-each-employee/ */

/* Find Total Time Spent by Each Employee
Write a solution to calculate the total time in minutes spent by each employee on each day at the office.
Note that within one day, an employee can enter and leave more than once.
The time spent in the office for a single entry is out_time - in_time.
Return the result table in any order.
in_time and out_time are between 1 and 1440. */

CREATE TABLE employees_time (
    emp_id INT,
    event_day DATE,
    in_time INT,
    out_time INT,
    PRIMARY KEY (emp_id, event_day, in_time)
);

INSERT INTO employees_time (emp_id, event_day, in_time, out_time) VALUES
(1, '2024-11-20', 540, 600),   -- Employee 1, Nov 20, 9:00 AM - 10:00 AM
(1, '2024-11-20', 615, 700),   -- Employee 1, Nov 20, 10:15 AM - 11:40 AM
(2, '2024-11-20', 500, 580),   -- Employee 2, Nov 20, 8:20 AM - 9:40 AM
(2, '2024-11-20', 600, 650),   -- Employee 2, Nov 20, 10:00 AM - 10:50 AM
(3, '2024-11-21', 480, 550),   -- Employee 3, Nov 21, 8:00 AM - 9:10 AM
(3, '2024-11-21', 560, 600);   -- Employee 3, Nov 21, 9:20 AM - 10:00 AM

SELECT * FROM employees_time

SELECT 
    emp_id,
    event_day,
    SUM(out_time - in_time) AS total_time
FROM 
    employees_time
GROUP BY 
    event_day, emp_id
ORDER BY emp_id ;
