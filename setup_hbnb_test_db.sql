-- Creates a database called hbnb_test_db in the current MySQL server
CREATE DATABASE IF NOT EXISTS hbnb_test_db;

-- creates the MySQL server user test
CREATE USER IF NOT EXISTS 'test'@'localhost' IDENTIFIED BY '10353236';

-- Grants Permissions for user test
GRANT ALL ON `hbnb_test_db`.* TO 'test'@'localhost';
GRANT SELECT ON `performance_schema`.* TO 'test'@'localhost';


