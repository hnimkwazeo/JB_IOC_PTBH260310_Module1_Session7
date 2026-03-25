create database JB_IOC_260310;

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    skills TEXT[]
);

INSERT INTO employees (name, skills) VALUES
('Alice', ARRAY['Java', 'SQL']),
('Bob', ARRAY['Python', 'JavaScript']);

-- Tạo Gin Index
CREATE INDEX idx_gin_skills ON employees USING GIN (skills);

SELECT name FROM employees WHERE skills @> ARRAY['Java'];

--Tạo index cho cột name
create index IDX_employees_name on employees(name);

-- Tạo GIST INDEX
CREATE TABLE places (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    location POINT
);

INSERT INTO places (name, location) VALUES
('Park', POINT(1, 2)),
('Store', POINT(3, 4));

CREATE INDEX idx_location ON places USING GIST (location);

SELECT name FROM places WHERE location <-> POINT(1, 2) <= 1;

