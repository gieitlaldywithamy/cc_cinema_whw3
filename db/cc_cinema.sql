DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS films;

CREATE TABLE customers (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  funds FLOAT NOT NULL
);

CREATE TABLE films (
  id SERIAL4 PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  price FLOAT NOT NULL,
  start_time TIME
);

CREATE TABLE tickets (
  id SERIAL4 PRIMARY KEY,
  customer_id INT4 REFERENCES customers(id) ON DELETE CASCADE,
  film_id INT4 REFERENCES films(id) ON DELETE CASCADE
);

-- CREATE TABLE screenings (
--   id SERIAL4 PRIMARY KEY,
--   film_title VARCHAR(255) NOT NULL,
--   fi
-- )
