 -- create a table students
CREATE TABLE students
  (
     id    INTEGER PRIMARY KEY,
     NAME  TEXT NOT NULL,
     email TEXT NOT NULL,
     ssn   TEXT NOT NULL
  );

-- create a table courses
CREATE TABLE courses
  (
     id          INTEGER PRIMARY KEY,
     NAME        TEXT NOT NULL,
     description TEXT NOT NULL
  );

-- create a table enrollment
CREATE TABLE enrollment
  (
     id         INTEGER PRIMARY KEY,
     student_id INTEGER NOT NULL,
     course_id  INTEGER NOT NULL,
     semester   TEXT NOT NULL
  );

-- insert some values in table:students
INSERT INTO students
VALUES      (1112,
             'Ryan',
             'Ryan@email.com',
             'ssn_Ryan');

INSERT INTO students
VALUES      (2221,
             'Joanna',
             'Joanna@email.com',
             'ssn_Joanna');

INSERT INTO students
VALUES      (1121,
             'Brain',
             'Brain@email.com',
             'ssn_Brain');

-- create a table: professors
CREATE TABLE professors (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  ssn TEXT NOT NULL
);

-- insert some values in table:courses
INSERT INTO courses
VALUES      (0077,
             'Maths',
             'Subject: Maths');

INSERT INTO courses
VALUES      (0044,
             'Science',
             'Subject: Science');

INSERT INTO courses
VALUES      (0011,
             'English',
             'Subject: English');

-- insert some values in table:enrollment
INSERT INTO enrollment
VALUES      (2489,
             2221,
             0044,
             'Fall 2021' );

INSERT INTO enrollment
VALUES      (2490,
             2221,
             0011,
             'Fall 2022' );

INSERT INTO enrollment
VALUES      (2491,
             2221,
             0077,
             'Fall 2021' );

INSERT INTO enrollment
VALUES      (2492,
             1121,
             0044,
             'Fall 2020' );

INSERT INTO enrollment
VALUES      (2493,
             1121,
             0011,
             'Fall 2021' );

-- insert some values in table:professors

 INSERT INTO professors
VALUES      (4811,
             'Hector',
             'Hector@email.com',
             'ssn_Hector');

INSERT INTO professors
VALUES      (4812,
             'John',
             'John@email.com',
             'ssn_John');

INSERT INTO professors
VALUES      (4813,
             'Emma',
             'Emma@email.com',
             'ssn_Emma');  
             
-- How would I get a list of students (name, email, etc...) 
-- enrolled in a particular class (by name) for a particular semester?
SELECT s.*,
       e.*,
       c.NAME
FROM   students AS s
       INNER JOIN enrollment AS e
               ON s.id = e.student_id
       INNER JOIN courses AS c
               ON e.course_id = c.id
WHERE  e.semester = 'Fall 2021' /* e.g Fall 2021*/
ORDER  BY c.NAME; /* assuming sort by class name or can s.name(sort by student name)*/

-- How about a list of students and the number of classes they are enrolled in? 
CREATE TEMPORARY TABLE group_enrollment AS
  SELECT student_id,
         Count(course_id) AS cs_count
  FROM   enrollment
  GROUP  BY student_id;

SELECT s.name,
       gn.cs_count AS Number_of_Classes
FROM   group_enrollment AS gn
       inner join students AS s
               ON s.id = gn.student_id;  
               
-- how would we get a list of students that have not enrolled in any classes in a particular semester?

SELECT s.email
FROM   students AS s
WHERE  s.id NOT IN (SELECT e.student_id
                    FROM   enrollment AS e
                    WHERE  e.semester = 'Fall 2021'
                   /*we can change as per requirement e.g Fall 2020 etc*/) ;
                   
-- select the name, email, and an is_student flag that would indicate if the person is a student or a professor.
CREATE TEMPORARY TABLE all_stud_prof AS
  SELECT id,
         name,
         email
  FROM   students
  UNION
  SELECT id,
         name,
         email
  FROM   professors;

SELECT DISTINCT a.name,
                a.email,
                CASE
                  WHEN s.id IS NULL THEN 0
                  ELSE 1
                END AS is_student
FROM   all_stud_prof AS a
       left join students s
              ON a.id = s.id; 
              