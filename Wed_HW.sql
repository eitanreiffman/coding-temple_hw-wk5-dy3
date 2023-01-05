--Week 5 - Wednesday Exercises

=============================================================================================================================

--1. List all customers who live in Texas (use JOINs)


SELECT c.first_name, c.last_name, a.district
FROM customer c
INNER JOIN address a
	ON c.address_id = a.address_id
WHERE a.district = 'Texas';

-- Answer: Jennifer Davis, Kim Cruz, Richard McCrary, etc...

=============================================================================================================================

--2. List all payments of more than $7.00 with the customer’s first and last name


SELECT c.first_name, c.last_name, p.*
FROM customer c
INNER JOIN payment p
	ON c.customer_id = p.customer_id
WHERE amount > 7.00;

-- Answer: Peter Menard 3x, Douglas Graf, Ryan Salisbury 3x, etc...

=============================================================================================================================

--3. Show all customer names who have made over $175 in payments (use
--subqueries)



SELECT first_name, last_name, customer_id
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING sum(amount) > 175
);

-- Answer: Rhonda Kennedy, Clara Shaw, Eleanor Hunt, etc...

=============================================================================================================================

--4. List all customers that live in Argentina (use the city table)


SELECT first_name, last_name, country
FROM customer c
INNER JOIN address a
	ON c.address_id = a.address_id
INNER JOIN city ci
	ON a.city_id = ci.city_id
INNER JOIN country co
	ON ci.country_id = co.country_id
WHERE country = 'Argentina';

-- Answer: Willie Markham, Jordan Archuleta, Jason Morrissey, etc...

=============================================================================================================================

--5. Show all the film categories with their count in descending order


SELECT name, count(name)
FROM category c
INNER JOIN film_category fc
	ON fc.category_id = c.category_id
GROUP BY name
ORDER BY count(name) desc;

--Answer:
--Sports		74
--Foreign		73
--Family		69
--Documentary	68
-- ETC....

=============================================================================================================================

--6. What film had the most actors in it (show film info)?


SELECT *
FROM film
WHERE film_id = (
	SELECT film_id 
	FROM film_actor
	GROUP BY film_id
	ORDER BY count(*) DESC
	LIMIT 1
);

-- Answer: 508, Lambs Cincinatti, "A Insightful Story of a Man And a Feminist who must Fight a Composer in Australia"

=============================================================================================================================

--7. Which actor has been in the least movies?

SELECT *
FROM actor
WHERE actor_id = (
	SELECT actor_id
	FROM film_actor
	GROUP BY actor_id
	ORDER BY count(*)
	LIMIT 1
);

-- Answer: Emily Dee, 148

=============================================================================================================================

--8. Which country has the most cities?

SELECT *
FROM country
WHERE country_id = (
	SELECT country_id
	FROM city
	GROUP BY country_id
	ORDER BY count(*) DESC
	LIMIT 1
);

-- Answer: India

=============================================================================================================================

--9. List the actors who have been in between 20 and 25 films.

-- Using the Sub Query Method

SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id
	FROM film_actor
	GROUP BY actor_id
	HAVING count(*) BETWEEN 20 AND 25
);


-- Using the Join Method

SELECT first_name, last_name, actor_count
FROM actor a
INNER JOIN
	(SELECT actor_id, count(*) AS actor_count
	FROM film_actor
	GROUP BY actor_id
	HAVING count(*) BETWEEN 20 AND 25) AS selected_actors
ON a.actor_id = selected_actors.actor_id;


-- Method using CTE (Common Table Expression) or 'WITH' Clause:

WITH selected_actors AS (
	SELECT actor_id, count(*) AS actor_count
	FROM film_actor
	GROUP BY actor_id
	HAVING count(*) BETWEEN 20 AND 25
)
SELECT first_name, last_name, actor_count
FROM selected_actors
INNER JOIN actor
ON selected_actors.actor_id = actor.actor_id;

-- Answer: Nick Wahlberg, Ed Chase, Jennifer Davis, etc...

=============================================================================================================================