/* ### 10
https://leetcode.com/problems/last-person-to-fit-in-the-bus/description/

Last Person to Fit in the Bus
There is a queue of people waiting to board a bus.
However, the bus has a weight limit of 1000 kilograms, so there may be some people who cannot board.
Write a solution to find the person_name of the last person that can fit on the bus without exceeding the weight limit.
The test cases are generated such that the first person does not exceed the weight limit.
Note that only one person can board the bus at any given turn.
 */

CREATE TABLE queue (
    person_id INT PRIMARY KEY,
    person_name VARCHAR(150),
    weight INT,
    turn INT
);

INSERT INTO queue (person_id, person_name, weight, turn)
VALUES 
    (5, 'Alice', 250, 1),
    (4, 'Bob', 175, 5),
    (3, 'Alex', 350, 2),
    (6, 'John Cena', 400, 3),
    (1, 'Winston', 500, 6),
    (2, 'Marie', 200, 4);

SELECT * FROM queue;

WITH CumulativeWeight AS (
    SELECT 
        person_name,
        weight,
        turn,
        SUM(weight) OVER (ORDER BY turn) AS cumulative_weight
    FROM 
        queue
)
/* SELECT * FROM CumulativeWeight;*/

SELECT 
    person_name, turn, cumulative_weight
FROM 
    CumulativeWeight
WHERE 
    cumulative_weight <= 1000
ORDER BY 
    cumulative_weight /*DESC
LIMIT 1;
