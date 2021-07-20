CREATE TABLE "person" (
	"id" SERIAL PRIMARY KEY,
	"name" VARCHAR(120) NOT NULL
);

CREATE TABLE "social_security" (
	"id" SERIAL PRIMARY KEY,
	"person_id" int REFERENCES "person",
	"number" int NOT NULL
);

INSERT INTO "person" (name)
	VALUES('Matt'), ('Chris'), ('Edan'), ('Tom'), ('Phillip');
	
INSERT INTO "social_security" (number, person_id)
	VALUES (012345678, 1), (123456789, 2), (234567890, 3);
	
-- JOINing tables.  Tables must be connected by some parameter (e.g. the SERIAL key of one table can be imported as an "foreign" id into another table)
	
-- Get SSN for each person in a response (JOIN them)
SELECT *
FROM person
JOIN "social_security" ON "person".id = "social_security".person_id;

SELECT "person".id, "person".name, "social_security".number
FROM "person"
JOIN "social_security" ON "person".id = "social_security".person_id;

SELECT "person".id, name, number
FROM "person"
JOIN "social_security" ON "person".id = "social_security".person_id;

-----------------------------------------------------

CREATE TABLE "cohort" (
	id SERIAL PRIMARY KEY,
	name VARCHAR(25),
	start_date DATE
);

CREATE TABLE "student" (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	cohort_id INT REFERENCES cohort
);

INSERT INTO cohort (name, start_date)
	VALUES ('Higgs', '5/1/2021'), ('Genocchi', '1/1/2021');
	
INSERT INTO "student" (name, cohort_id)
	VALUES('Matt', 1), ('Chris', 2), ('Edan', 1);

-- Select all students from the cohorts	// Gives bad to handle data though
SELECT * FROM "student"
JOIN "cohort" ON "cohort".id = "student".cohort_id;

--Count the student in a single cohort:
SELECT count(*) FROM "student"
JOIN cohort ON student.cohort_id = cohort.id
WHERE cohort.name = 'Higgs';

-- Count students in each cohort:
SELECT cohort.name, count(*)
FROM student
JOIN cohort ON Cohort.id = student.cohort_id
GROUP BY cohort.name;



-- AS renames the column which can be passed to the front-end under the new AS name
SELECT count(*), student.name AS "student_name"
FROM student
JOIN cohort ON student.cohort_id = cohort.id
WHERE cohort.name = 'Higgs'
GROUP BY student.name
ORDER BY student.name DESC;


SELECT
	count(cohort.name) AS student_count, -- Count of student in each cohort and label it as student_count
	cohort.name -- Add in cohort name for reference
FROM student
JOIN cohort ON student.cohort_id = cohort.id
GROUP BY cohort.name
ORDER BY cohort.name DESC;


-------------------------------------------------
-- USING JUNCTION TABLES.
-- When multiple rows can be connected to multiple rows of another table


CREATE TABLE hobby (
	id SERIAL PRIMARY KEY,
	description VARCHAR(100) NOT NULL
);
INSERT INTO hobby (description)
VALUES
('Music'),
('Knitting'),
('Profligacy'),
('Movies'),
('Sleeping'),
('Reading');



SELECT * FROM person;

SELECT * FROM hobby;

-- This will be the linking table between person and hobby.. a "Junction Table"
CREATE TABLE person_hobby (
	id SERIAL PRIMARY KEY,
	person_id INT REFERENCES person,
	hobby_id INT REFERENCES hobby,
	skill INT
);

INSERT INTO person_hobby (person_id, hobby_id, skill)
	VALUES (1, 2, 3), (7, 3, 4), (8, 4, 1), (2, 1, 5), (3, 5, 0), (1, 6, 8), (2, 2, 4), (3, 1, 2), (7, 4, 9), (8, 5, 4);
	
	
-- When referencing a foreign-key in a table, the column name should follow the convention of:
-- '[table name]_[column_name]`.  For example, person_id references the id column of the person table.

-- Aliases to use shorthand code is common, but must remain consistent throughout the query

--PULL EVERYTHING
SELECT id AS person_id FROM person_hobby;

SELECT * FROM person_hobby AS ph
JOIN person as p ON ph.person_id = p.id
JOIN hobby as h ON ph.hobby_id = h.id;


-- select hobbies for specific USER

SELECT hobby.description, person_hobby.skill, person.name FROM person_hobby
JOIN hobby on hobby.id = person_hobby.hobby_id
JOIN person ON person.id = person_hobby.person_id
WHERE person.id = 3;
-- These two will be the same, despite the WHERE.. because person_hobby is directly linked to person
SELECT hobby.description, person_hobby.skill, person.name FROM person_hobby
JOIN hobby on hobby.id = person_hobby.hobby_id
JOIN person ON person.id = person_hobby.person_id
WHERE person_hobby.person_id = 3;

SELECT count(*) FROM person;

-- Minimum skill value for a hobby
SELECT MIN(skill) FROM person_hobby;

-- Maximimum Value for skill
SELECT MAX(skill) FROM person_hobby;

--Average Value of skill level
SELECT AVG(skill) FROM person_hobby;

-- Average Skill of each individual hobby
SELECT AVG(skill), hobby.description FROM person_hobby
JOIN hobby ON person_hobby.hobby_id = hobby.id
GROUP BY hobby.description
ORDER BY AVG(skill) DESC;

-- GET MIN and MAX for each hobby
SELECT MIN(skill) as minimum, MAX(skill) as maximum, hobby.description as hobby FROM person_hobby
JOIN hobby on person_hobby.hobby_id = hobby.id
GROUP BY hobby.description;

-- Get min and max for each hobby for each person (not really relevant in this example, but useful in others)
SELECT MIN(skill) as minimum, MAX(skill) as maximum, hobby.description as hobby, person.name FROM person_hobby
JOIN hobby on person_hobby.hobby_id = hobby.id
JOIN person ON person.id = person_hobby.person_id
GROUP BY hobby.description, person.name
ORDER BY person.name;

-- ORDER OF OPERATIONS REMINDER:
-- SOME			SELECT
-- FRIENDS		FROM
-- JUST			JOIN
-- WANT			WHERE
-- GOOD			GROUP BY
-- HAPPY		HAVING
-- OPTIONS		ORDER BY


-- EXAMPLE OF HAVING clause -- Having is similar to WHERE but is done on the table after it's been filtered down
SELECT hobby.description, person_hobby.skill, person.id
FROM person_hobby
JOIN person ON person_hobby.person_id = person.id
JOIN hobby ON person_hobby.hobby_id = hobby.id
WHERE person_hobby.skill > 3
GROUP BY hobby.description, person_hobby.skill, person.id
HAVING person.id = 2;
