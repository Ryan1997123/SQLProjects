CREATE TABLE friends(
id INTEGER,
name TEXT,
birthday DATE
);

INSERT INTO friends(id,name,birthday)VALUES(1, 'Ororo Munroe', '1940-05-30');

SELECT * 
FROM friends;


INSERT INTO friends(id,name,birthday)VALUES(2, 'Redmond Ang','1999-01-01');

INSERT INTO friends(id,name,birthday)VALUES(3,'Samantha Dargie','1999-09-19');

UPDATE friends
SET name = 'Storm Munroe'
WHERE id = 1;

ALTER TABLE friends
ADD COLUMN email TEXT;


UPDATE friends
SET email = 'storm@codeacademy.com'
WHERE id = 1;

UPDATE friends
SET email = 'rang@fordham.edu'
WHERE id = 2;

UPDATE friends
SET email = 'sdargie@fordham.edu'
WHERE id = 3;


DELETE FROM friends WHERE id = 1;

SELECT * 
FROM friends;
