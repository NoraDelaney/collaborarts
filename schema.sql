DROP TABLE IF EXISTS users;


CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  location VARCHAR(255),
  artist_type VARCHAR(255),
  looking_for VARCHAR(255),
  description VARCHAR(2048)
);
