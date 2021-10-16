SELECT *
FROM employees;

SELECT * 
FROM projects;

/*What are the names of employees who have not chosen a project?*/
SELECT first_name, last_name
FROM employees
WHERE current_project IS NULL;



/*What are the names of projects that were not chosen by any employees?*/
SELECT project_name
FROM projects
WHERE project_id NOT IN (
  SELECT current_project
  FROM employees
  WHERE current_project IS NOT NULL
);

/*What is the name of the project chosen by the most employees?*/
SELECT project_name
FROM projects
INNER JOIN employees
ON projects.project_id = employees.current_project
WHERE current_project IS NOT NULL
GROUP BY current_project
HAVING COUNT(current_project) > 1;

/*
Each project needs at least 2 developers. How many available project positions are there for developers? Do we have enough developers to fill the needed positions?

We will learn how to do this in the last chapters of this course! Take a look at the hint to get a preview.*/
SELECT(COUNT(*) * 2) - (
  SELECT COUNT(*)
  FROM employees
  WHERE current_project IS NOT NULL
  AND position = 'Developer') AS 'Count'
  FROM projects;

/*Which personality is the most common across our employees?*/

SELECT personality
FROM employees
GROUP BY personality
ORDER BY COUNT(personality) DESC
LIMIT 1;


/*What are the names of projects chosen by employees with the most common personality type?*/
SELECT project_name
FROM projects
INNER JOIN employees
ON projects.project_id = employees.current_project
WHERE personality = (
  SELECT personality
  FROM employees
  GROUP BY personality
  ORDER BY COUNT(personality) DESC
  LIMIT 1
);


/*Find the personality type most represented by employees with a selected project.

What are names of those employees, the personality type, and the names of the project they’ve chosen?*/

SELECT last_name, first_name, personality, project_name
FROM employees
INNER JOIN projects 
ON employees.current_project = projects.project_id
WHERE personality = (
  SELECT personality
  FROM employees
  WHERE current_project IS NOT NULL
  GROUP BY personality
  ORDER BY COUNT(personality) DESC
  LIMIT 1
);


/*For each employee, provide their name, personality, the names of any projects they’ve chosen, and the number of incompatible co-workers.*/

SELECT last_name, first_name, personality, 
project_name,
CASE
  WHEN personality = 'INFP'
  THEN(SELECT COUNT(*)
  FROM employees
  WHERE personality IN('ISFP', 'ESFP',
  'ISTP', 'ESTP', 'ISFJ', 'ESFJ', 'ISTJ', 'ESTJ'))
  WHEN personality = 'ISFP'
  THEN(SELECT COUNT(*)
  FROM employees
  WHERE personality IN ('INFP','ENTP',
  'INFJ'))
  --.. etc.
  ELSE 0
END AS 'INCOMPATS'
FROM employees
LEFT JOIN projects ON employees.current_project = projects.project_id;
