/* ### 3
Skriv en query som returnerar...

1. All information från tabellen `employees`
2. Förnamn, efternamn, telefonnummer och adress från `employees`
3. Förnamn, efternamn och på alla employees som blev anställda 1993 eller senare.
4. Förnamn och efternamn på alla anställda med
   employees som har managern Steven Buchanan
5. Förnamn och efternamn på alla anställda som inte lagt in sitt telefonnummer i databasen
6. Förnamn och efternamn på alla anställda vars efternamn börjar på D
7. Förnamn och efternamn på alla managers. */

SELECT * FROM employees;

SELECT last_name, first_name, home_phone, address
FROM employees;

SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date >'1993-01-01';

SELECT first_name, last_name
FROM employees
WHERE notes like '%Buchanan%';

SELECT first_name, last_name
FROM employees
WHERE home_phone IS NULL;

SELECT first_name, last_name
FROM employees
WHERE last_name LIKE 'D%';

SELECT first_name, last_name, notes
FROM employees
WHERE notes LIKE '%manager%';

/*8. Hitta de fem dyraste produkterna i products.*/
SELECT product_name, unit_price FROM products
ORDER BY unit_price DESC
LIMIT 5;

/*9. Välj fem valfria kolumner från employees.
En av kolumnerna ska heta full_name och vara en kombination av first- och lastname
För övning 10 och 11 går det inte att uppdatera eller ta bort tabeller som har foreign keys eller som har andra tabeller med foreign keys som pekar på dem.

Select any five columns from employees.
One of the columns should be called full_name and be a combination of first- and lastname
For exercises 10 and 11, you cannot update or drop tables that have foreign keys or that have other tables with foreign keys pointing to them.*/

SELECT employee_id, first_name || '' || last_name AS full_name
FROM employees;

/*10. Uppdatera valfri data i valfri tabell. Verifiera att det fungerade.*/
ALTER TABLE us_states
ADD colour VARCHAR(5);

UPDATE us_states
SET colour = 'red'

SELECT * FROM us_states;

/*11. Ta bort  valfri data i valfri tabell. Verifiera att det fungerade.*/

ALTER TABLE us_states
DROP COLUMN colour;

SELECT * FROM us_states;

/*12. Researcha funktionen COALESCE(). Testa den och formulera med egna ord hur den fungerar.

COALESCE() return the first not-null value in a chain of values.
COALESCE(val1, val2, ..., valn) returns the first value with a not-null value.*/

/*13. Kategorisa alla orderrader i order_details efter hur dyr den orderraden är. Orderrader med totalvärde under 190 är "Cheap" orderrader över 600 är "Expensive", och allting där emellan är "Moderate".*/

SELECT 
    order_id, 
    (unit_price * quantity) AS total_value,
    CASE
        WHEN (unit_price * quantity) < 190 THEN 'Cheap'
        WHEN (unit_price * quantity) > 600 THEN 'Expensive'
        ELSE 'Moderate'
    END AS order_total_value
FROM order_details;

/* Cannot use alias in the CASE statement: just write the calculation directly*/
SELECT * FROM order_details

/* (1) rewriting the above code using subquery in order to be able to write the alias in the CASE statement:*/
SELECT 
    order_id, 
    total_value,
    CASE
        WHEN total_value < 190 THEN 'Cheap'
        WHEN total_value > 600 THEN 'Expensive'
        ELSE 'Moderate'
    END AS order_total_value
FROM (
    SELECT 
        order_id, 
        (unit_price * quantity) AS total_value
    FROM order_details
) AS subquery;

/* (2) rewrite the code usin a CTE (Common Table Expression):*/
WITH OrderValues AS (
    SELECT 
        order_id, 
        (unit_price * quantity) AS total_value
    FROM order_details
)
SELECT 
    order_id, 
    total_value,
    CASE
        WHEN total_value < 190 THEN 'Cheap'
        WHEN total_value > 600 THEN 'Expensive'
        ELSE 'Moderate'
    END AS order_total_value
FROM OrderValues;


/* ### 4
Använd domänen från rollspelsövningen från förra lektionen.
Skriv nu följande queries av olika svårighetsgrad:
- Lista hela inventory för spelaren ”kristian”.*/

/*(1) simply lisitng kristian and item_ids he has*/
SELECT player, item FROM player_inventory
WHERE player LIKE 'kristian';
/*(2) listing kristian items thoroughly: (pi : alias for PLayers Inventory)*/
SELECT
    pi.player, 
    i.itemname, 
    i.value 
FROM 
    player_inventory AS pi
JOIN 
    items AS i ON pi.item = i.id
WHERE 
    pi.player = 'kristian';

/*- Hitta det genomsnittliga värdet för alla föremål i spelet.*/
SELECT AVG(value) FROM items as average_value;

/*- Hitta för varje föremål antalet spelare som bär det i sitt _inventory_. Resultatet bör innehålla två kolumner, en för föremåls-ID och en för antal spelare. Se till att visa 0 för föremål som ingen har i sitt _inventory_.*/
SELECT 
    i.id AS item_id, 
    COALESCE(COUNT(pi.player), 0) AS number_of_players
FROM 
    items i
LEFT JOIN 
    player_inventory pi ON i.id = pi.item
GROUP BY 
    i.id
ORDER BY 
    i.id;

/*- Hitta för varje spelare namnet på nuvarande weapon eller strängen "Inget" om spelaren inte har något weapon. Resultatet bör ha kolumner för spelarnamn och föremålsnamn.*/

SELECT 
    p.name AS player_name,
    COALESCE(i.itemname, 'None') AS weapon_name
FROM 
    players p
LEFT JOIN 
    equipped e ON p.name = e.player AND e.equipslot = 'weapon'
LEFT JOIN 
    items i ON e.item = i.id
ORDER BY 
    p.name;

/*- Hitta namnet på alla föremål med ett värde av minst 500 och som är utrustade av minst en spelare med en level över 75.*/
SELECT 
    i.itemname, 
    p.name AS player_name

FROM 
    items i
JOIN 
    equipped e ON i.id = e.item
JOIN 
    players p ON e.player = p.name
WHERE 
    i.value >= 500 AND p.level > 75;

/*- Hitta för varje spelare det totala kombinerade värdet av alla föremål de har på sig och som de har i sitt _inventory_. Resultatet bör ha två kolumner, en för spelarnamn och en annan för totalt värde. Spelare som inte har några föremål behöver inte finnas med i resultatet.*/

SELECT 
    p.name AS player_name,
    SUM(i.value) AS total_value
FROM 
    players p
LEFT JOIN 
    equipped e ON p.name = e.player
LEFT JOIN 
    items i ON e.item = i.id
LEFT JOIN 
    player_inventory pi ON p.name = pi.player
LEFT JOIN 
    items i2 ON pi.item = i2.id
GROUP BY 
    p.name
HAVING 
    SUM(i.value) > 0 OR SUM(i2.value) > 0;

/*- Hitta alla föremål i Roberts inventory som han kan ta på sig direkt. Det innebär att föremålet måste gå att ta på sig i en av Roberts lediga slots. En hjälm ska alltså inte finnas med i resultatet om Robert redan bär på en hjälm. Resultatet bör ha två kolumner, id och equipslot.*/
SELECT 
    pi.item AS item_id,
    e2.equipslot
FROM 
    player_inventory pi
JOIN 
    items i ON pi.item = i.id
JOIN 
    equippable e2 ON i.id = e2.id
LEFT JOIN 
    equipped e1 ON pi.player = e1.player AND e1.equipslot = e2.equipslot AND e1.player = 'Robert'
WHERE 
    pi.player = 'Robert'
    AND e1.equipslot IS NULL;

/*For each item, find the number of players who carry it in their _inventory_. The result should contain two columns, one for item ID and one for number of players. Be sure to show 0 for items that no one has in their _inventory_.*/
