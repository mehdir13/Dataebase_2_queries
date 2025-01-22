/* ### 9
https://leetcode.com/problems/bank-account-summary-ii/ */
/* Bank Account Summary II
Write a solution to report the name and balance of users with a balance higher than 10000. 
The balance of an account is equal to the sum of the amounts of all transactions involving that account.
Return the result table in any order.
*/
CREATE TABLE users (
    account INT PRIMARY KEY,
    name VARCHAR(150)
);

CREATE TABLE transactions (
    trans_id INT PRIMARY KEY,
    account INT,
    amount INT,
    transacted_on DATE
);

INSERT INTO users (account, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

SELECT * FROM users;

/* TRUNCATE TABLE transactions; */
INSERT INTO transactions (trans_id, account, amount, transacted_on) VALUES
(1, 1, 15000, '2024-01-01'),
(2, 2, 5000, '2024-01-02'),
(3, 1, -2000, '2024-01-03'),
(4, 3, 2000, '2024-01-04'),
(5, 2, 6000, '2024-01-05');

SELECT * FROM transactions;

/* total balance for each account */
SELECT 
    u.name,
    SUM(t.amount) AS balance
FROM 
    users u
LEFT JOIN 
    transactions t ON u.account = t.account
GROUP BY 
    u.name
HAVING 
    SUM(t.amount) > 10000;
