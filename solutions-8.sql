/* ### 8

USAs röstningssystem bygger på att varje delstat har ett visst antal elektorer, 
och kandidaten som har flest röster i delstaten får alla rösterna från elektorerna. 
Den med flest röster från elektorer vinner sedan valet. Kolla upp detta på internet om du är lite osäker inför uppgiften.
The US voting system is based on each state having a certain number of electorals,
and the candidate with the most votes in the state receives all the votes of the electors.
The person with the most votes from electorals then wins the election.
Look this up on the internet if you are a little unsure about the task.

1. Skapa en tabell
state_votes(_state_code_, biden_votes, trump_votes, electors)
och sätt in lite fiktiv data.
1. Create a table
state_votes(_state_code_, biden_votes, trump_votes, electors)
and insert some fictitious data.
 */

CREATE TABLE state_votes (
    state_code VARCHAR(2),
    biden_votes INT,
    trump_votes INT,
    electorals INT
);

INSERT INTO state_votes (state_code, biden_votes, trump_votes, electorals)
VALUES
('AL', 1000000, 2000000, 9),  -- Alabama
('AK', 400000, 500000, 3),    -- Alaska
('AZ', 1800000, 1700000, 11), -- Arizona
('AR', 1200000, 2000000, 6),  -- Arkansas
('CA', 8000000, 4000000, 55), -- California
('CO', 2000000, 1700000, 9),  -- Colorado
('CT', 1700000, 1300000, 7),  -- Connecticut
('DE', 1000000, 500000, 3),   -- Delaware
('FL', 5000000, 5000000, 29), -- Florida
('GA', 3500000, 3000000, 16), -- Georgia
('HI', 1000000, 400000, 4),   -- Hawaii
('ID', 500000, 700000, 4),    -- Idaho
('IL', 6000000, 2500000, 20), -- Illinois
('IN', 2800000, 3200000, 11), -- Indiana
('IA', 1500000, 1400000, 6),  -- Iowa
('KS', 1100000, 1500000, 6),  -- Kansas
('KY', 1400000, 2500000, 8),  -- Kentucky
('LA', 1600000, 2200000, 8),  -- Louisiana
('ME', 700000, 800000, 4),    -- Maine
('MD', 2500000, 1800000, 10), -- Maryland
('MA', 3000000, 1300000, 11), -- Massachusetts
('MI', 4500000, 3500000, 16), -- Michigan
('MN', 2800000, 2200000, 10), -- Minnesota
('MS', 1200000, 1500000, 6),  -- Mississippi
('MO', 1800000, 2200000, 10), -- Missouri
('MT', 400000, 500000, 3),    -- Montana
('NE', 900000, 1200000, 5),   -- Nebraska
('NV', 1800000, 1300000, 6),  -- Nevada
('NH', 1000000, 800000, 4),   -- New Hampshire
('NJ', 3000000, 2500000, 14), -- New Jersey
('NM', 1500000, 1300000, 5),  -- New Mexico
('NY', 7000000, 3000000, 29), -- New York
('NC', 3500000, 4000000, 15), -- North Carolina
('ND', 400000, 500000, 3),    -- North Dakota
('OH', 3000000, 4000000, 18), -- Ohio
('OK', 1000000, 2200000, 7),  -- Oklahoma
('OR', 2500000, 2000000, 7),  -- Oregon
('PA', 4000000, 3500000, 20), -- Pennsylvania
('RI', 700000, 500000, 4),    -- Rhode Island
('SC', 1500000, 2000000, 9),  -- South Carolina
('SD', 400000, 500000, 3),    -- South Dakota
('TN', 1800000, 2300000, 11), -- Tennessee
('TX', 4500000, 5500000, 38), -- Texas
('UT', 1100000, 1300000, 6),  -- Utah
('VT', 700000, 300000, 3),    -- Vermont
('VA', 3200000, 2700000, 13), -- Virginia
('WA', 3000000, 2000000, 12), -- Washington
('WV', 800000, 1300000, 5),   -- West Virginia
('WI', 3500000, 3000000, 10), -- Wisconsin
('WY', 300000, 500000, 3);    -- Wyoming

SELECT * FROM state_votes;

/* 2. Skapa en view `state_results` med en kolumn med statens kod, en med den vinnande presidentkandidaten, 
och en sista med antalet elektorer som kandidaten har vunnit. Tips: kolla in `CASE`.
2. Create a view `state_results` with a column with the state code, one with the winning presidential candidate,
and a final one with the number of electorals the candidate has won. Tip: check out `CASE`.
*/

CREATE VIEW state_results AS
SELECT 
    state_code,
    CASE 
        WHEN biden_votes > trump_votes THEN 'Biden'
        WHEN trump_votes > biden_votes THEN 'Trump'
        ELSE 'Too close to call'
    END AS winning_candidate,
    electorals
FROM
    state_votes;

SELECT * FROM state_results;

/* 3. Skriv en query som slutligen visar hur många totala röster varje kandidat har fått.
 3. Write a query that finally shows how many total votes each candidate has received.*/
SELECT 
    'Biden' AS candidate,
    SUM(biden_votes) AS total_biden_votes
FROM 
    state_votes
UNION ALL
SELECT 
    'Trump' AS candidate,
    SUM(trump_votes) AS total_trump_votes
FROM 
    state_votes;


/* find out the Winner by counting the overall electoral of each candidate*/
SELECT 
    winning_candidate, 
    SUM(electorals) AS total_electoral_votes
FROM 
    state_results
GROUP BY 
    winning_candidate
ORDER BY 
    total_electoral_votes DESC;


/* 4. Byt nu tabellen till:
state_votes(_state_code_, _candidate_, votes, electors)
 4. Now change the table to:
state_votes(_state_code_, _candidate_, votes, electorals)*/ 

SELECT * FROM state_votes;

ALTER TABLE state_votes
ADD COLUMN candidate VARCHAR(10),
ADD COLUMN votes INT;

SELECT * FROM state_votes;

UPDATE state_votes
SET candidate = CASE
                    WHEN biden_votes > trump_votes THEN 'Biden'
                    WHEN trump_votes > biden_votes THEN 'Trump'
                    ELSE 'Tie'
                END,
    votes = CASE
                WHEN biden_votes > trump_votes THEN biden_votes
                WHEN trump_votes > biden_votes THEN trump_votes
                ELSE NULL
            END;

SELECT * FROM state_votes;

/* Cannot DROP coloumns since some other objects depend on them.
First we identify which objects.
then we Drop the View.
at last we can Drop the Columns*/

SELECT * 
FROM pg_catalog.pg_depend
WHERE objid = 'state_votes'::regclass;

DROP VIEW state_results;

ALTER TABLE state_votes
DROP COLUMN biden_votes,
DROP COLUMN trump_votes;

SELECT * FROM state_votes;

/*stata_votes (state_code, electorals, candidates, votes)*/

/* Gör om uppgift 2 och 3 med den nya tabellen. Tips: kolla in `RANK()` och andra window-functions.
Vilken struktur är bäst anser du? Finns det några för och nackdelar?
Redo tasks 2 and 3 with the new table. Tip: check out `RANK()` and other window-functions.
Which structure do you think is best? Are there any pros and cons?
*/
CREATE OR REPLACE VIEW state_results AS
SELECT 
    candidate,
    SUM(electorals) AS total_electorals
FROM 
    state_votes
GROUP BY 
    candidate
ORDER BY 
    total_electorals DESC;

SELECT * FROM state_results


SELECT 
    candidate AS winner, 
    total_electorals
FROM 
    state_results
ORDER BY 
    total_electorals DESC
;

/*1: clear, easy to audit. BUT complex calculations . BETTER */
/*2: only the winner's data is stored. additional steps.*/