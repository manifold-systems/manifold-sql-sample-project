
-- Sakila Sample Database Schema
-- Version 0.8

-- Copyright (c) 2006, MySQL AB
-- All rights reserved.

--
-- Table structure for table `actor`
--

CREATE TABLE actor (
  actor_id IDENTITY NOT NULL PRIMARY KEY,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

--
-- Table structure for table `country`
--

CREATE TABLE country (
  country_id IDENTITY NOT NULL PRIMARY KEY,
  country VARCHAR(50) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

--
-- Table structure for table `city`
--

CREATE TABLE city (
  city_id IDENTITY NOT NULL PRIMARY KEY,
  city VARCHAR(50) NOT NULL,
  country_id BIGINT NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_city_country FOREIGN KEY (country_id) REFERENCES country (country_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

--
-- Table structure for table `address`
--

CREATE TABLE address (
  address_id IDENTITY NOT NULL PRIMARY KEY,
  address VARCHAR(50) NOT NULL,
  address2 VARCHAR(50) DEFAULT NULL,
  district VARCHAR(20) NOT NULL,
  city_id BIGINT NOT NULL,
  postal_code VARCHAR(10) DEFAULT NULL,
  phone VARCHAR(20) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES city (city_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

--
-- Table structure for table `language`
--

CREATE TABLE language (
  language_id IDENTITY NOT NULL PRIMARY KEY,
  name CHAR(20) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

--
-- Table structure for table `staff`
--

CREATE TABLE staff (
  staff_id IDENTITY NOT NULL PRIMARY KEY,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  address_id BIGINT NOT NULL,
  picture MEDIUMBLOB DEFAULT NULL,
  email VARCHAR(50) DEFAULT NULL,
  store_id BIGINT NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  username VARCHAR(16) NOT NULL,
  password VARCHAR(40) DEFAULT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_staff_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

--
-- Table structure for table `store`
--

CREATE TABLE store (
  store_id IDENTITY NOT NULL PRIMARY KEY,
  manager_staff_id BIGINT NOT NULL,
  address_id BIGINT NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (store_id),
  CONSTRAINT idx_unique_manager UNIQUE (manager_staff_id),
  CONSTRAINT fk_store_staff FOREIGN KEY (manager_staff_id) REFERENCES staff (staff_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_store_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

ALTER TABLE staff ADD CONSTRAINT fk_staff_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Table structure for table `customer`
--

CREATE TABLE customer (
  customer_id IDENTITY NOT NULL PRIMARY KEY,
  store_id BIGINT NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(50) DEFAULT NULL,
  address_id BIGINT NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  create_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_customer_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_customer_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

--
-- Table structure for table `film`
--

CREATE TABLE film (
  film_id IDENTITY NOT NULL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT DEFAULT NULL,
  release_year SMALLINT DEFAULT NULL,
  language_id BIGINT NOT NULL,
  original_language_id LONG DEFAULT NULL,
  rental_duration TINYINT NOT NULL DEFAULT 3,
  rental_rate DECIMAL(4,2) NOT NULL DEFAULT 4.99,
  length SMALLINT DEFAULT NULL,
  replacement_cost DECIMAL(5,2) NOT NULL DEFAULT 19.99,
  rating ENUM('G','PG','PG-13','R','NC-17') DEFAULT 'G',
--   special_features SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes') DEFAULT NULL,
  special_features VARCHAR(255) DEFAULT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_film_language FOREIGN KEY (language_id) REFERENCES language (language_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_language_original FOREIGN KEY (original_language_id) REFERENCES language (language_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

--
-- Table structure for table `film_actor`
--

CREATE TABLE film_actor (
  actor_id BIGINT NOT NULL,
  film_id BIGINT NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (actor_id,film_id),
  CONSTRAINT fk_film_actor_actor FOREIGN KEY (actor_id) REFERENCES actor (actor_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_actor_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

--
-- Table structure for table `category`
--

CREATE TABLE category (
  category_id IDENTITY NOT NULL PRIMARY KEY,
  name VARCHAR(25) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

--
-- Table structure for table `film_category`
--

CREATE TABLE film_category (
  film_id BIGINT NOT NULL,
  category_id BIGINT NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (film_id, category_id),
  CONSTRAINT fk_film_category_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_category_category FOREIGN KEY (category_id) REFERENCES category (category_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

--
-- Table structure for table `inventory`
--

CREATE TABLE inventory (
  inventory_id IDENTITY NOT NULL PRIMARY KEY,
  film_id BIGINT NOT NULL,
  store_id BIGINT NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (inventory_id),
  CONSTRAINT fk_inventory_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_inventory_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

--
-- Table structure for table `rental`
--

CREATE TABLE rental (
  rental_id IDENTITY NOT NULL PRIMARY KEY,
  rental_date DATETIME NOT NULL,
  inventory_id BIGINT NOT NULL,
  customer_id BIGINT NOT NULL,
  return_date DATETIME DEFAULT NULL,
  staff_id BIGINT NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (rental_id),
  CONSTRAINT secondary_key UNIQUE (rental_date,inventory_id,customer_id),
  CONSTRAINT fk_rental_staff FOREIGN KEY (staff_id) REFERENCES staff (staff_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_rental_inventory FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_rental_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

--
-- Table structure for table `payment`
--

CREATE TABLE payment (
  payment_id IDENTITY NOT NULL PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  staff_id BIGINT NOT NULL,
  rental_id INT DEFAULT NULL,
  amount DECIMAL(5,2) NOT NULL,
  payment_date DATETIME NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (payment_id),
  CONSTRAINT fk_payment_rental FOREIGN KEY (rental_id) REFERENCES rental (rental_id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_payment_staff FOREIGN KEY (staff_id) REFERENCES staff (staff_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

--
-- View structure for view `customer_list`
--

CREATE VIEW customer_list
AS
SELECT cu.customer_id AS ID, CONCAT(cu.first_name, ' ', cu.last_name) AS name, a.address AS address, a.postal_code AS `zip code`,
	a.phone AS phone, city.city AS city, country.country AS country, CASE WHEN cu.active THEN 'active' ELSE '' END AS notes, cu.store_id AS SID
FROM customer AS cu JOIN address AS a ON cu.address_id = a.address_id JOIN city ON a.city_id = city.city_id
	JOIN country ON city.country_id = country.country_id;

--
-- View structure for view `film_list`
--

CREATE VIEW film_list
AS
SELECT film.film_id AS FID, film.title AS title, film.description AS description, category.name AS category, film.rental_rate AS price,
	film.length AS length, film.rating AS rating, GROUP_CONCAT(CONCAT(actor.first_name, ' ', actor.last_name) SEPARATOR ', ') AS actors
FROM category LEFT JOIN film_category ON category.category_id = film_category.category_id LEFT JOIN film ON film_category.film_id = film.film_id
        JOIN film_actor ON film.film_id = film_actor.film_id
	JOIN actor ON film_actor.actor_id = actor.actor_id
GROUP BY film.film_id, film.title, film.description, film.rental_rate, film.length, film.rating, category.name;


--
-- View structure for view `staff_list`
--

CREATE VIEW staff_list
AS
SELECT s.staff_id AS ID, CONCAT(s.first_name, ' ', s.last_name) AS name, a.address AS address, a.postal_code AS `zip code`, a.phone AS phone,
	city.city AS city, country.country AS country, s.store_id AS SID
FROM staff AS s JOIN address AS a ON s.address_id = a.address_id JOIN city ON a.city_id = city.city_id
	JOIN country ON city.country_id = country.country_id;

--
-- View structure for view `sales_by_store`
--

CREATE VIEW sales_by_store
AS
SELECT
CONCAT(c.city, ',', cy.country) AS store
, CONCAT(m.first_name, ' ', m.last_name) AS manager
, SUM(p.amount) AS total_sales
FROM payment AS p
INNER JOIN rental AS r ON p.rental_id = r.rental_id
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN store AS s ON i.store_id = s.store_id
INNER JOIN address AS a ON s.address_id = a.address_id
INNER JOIN city AS c ON a.city_id = c.city_id
INNER JOIN country AS cy ON c.country_id = cy.country_id
INNER JOIN staff AS m ON s.manager_staff_id = m.staff_id
GROUP BY s.store_id
ORDER BY cy.country, c.city;

--
-- View structure for view `sales_by_film_category`
--
-- Note that total sales will add up to >100% because
-- some titles belong to more than 1 category
--

CREATE VIEW sales_by_film_category
AS
SELECT
c.name AS category, SUM(p.amount) AS total_sales
FROM payment AS p
INNER JOIN rental AS r ON p.rental_id = r.rental_id
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film AS f ON i.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY total_sales DESC;

--
-- View structure for view `actor_info`
--

CREATE VIEW actor_info
AS
SELECT
a.actor_id,
a.first_name,
a.last_name,
GROUP_CONCAT(DISTINCT CONCAT(c.name, ': ',
		(SELECT GROUP_CONCAT(f.title ORDER BY f.title SEPARATOR ', ')
                    FROM film f
                    INNER JOIN film_category fc
                      ON f.film_id = fc.film_id
                    INNER JOIN film_actor fa
                      ON f.film_id = fa.film_id
                    WHERE fc.category_id = c.category_id
                    AND fa.actor_id = a.actor_id
                 )
             )
             ORDER BY c.name SEPARATOR '; ')
AS film_info
FROM actor a
LEFT JOIN film_actor fa
  ON a.actor_id = fa.actor_id
LEFT JOIN film_category fc
  ON fa.film_id = fc.film_id
LEFT JOIN category c
  ON fc.category_id = c.category_id
GROUP BY a.actor_id, a.first_name, a.last_name;


