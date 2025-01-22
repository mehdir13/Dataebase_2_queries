/* ### 7
https://leetcode.com/problems/number-of-unique-subjects-taught-by-each-teacher/ */

/*Number of Unique Subjects Taught by Each Teacher

Write a solution to calculate the number of unique subjects each teacher teaches in the university.
Return the result table in any order.
*/

CREATE TABLE teachers (
    teacher_id INT,
    subject_id INT,
    dept_id INT,
    PRIMARY KEY (subject_id, dept_id)
);

/* TRUNCATE table teachers */
INSERT INTO teachers (teacher_id, subject_id, dept_id) VALUES
(1, 2, 3),
(1, 2, 4),
(1, 3, 3),
(2, 1, 1),
(2, 2, 1),
(2, 3, 1),
(2, 4, 1),
(2, 5, 1),
(3, 4, 4),
(3, 6, 2);

SELECT * FROM teachers;

SELECT 
    teacher_id,
    COUNT(subject_id)
FROM 
    teachers
GROUP BY 
    teacher_id
ORDER BY 
    teacher_id;
