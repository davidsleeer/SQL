--102831215 Dawei Li

/*
SSubject(SubjCode, Description)
Tacher(StaffID, Surname, GivenName)
SubjectOffering(Year, Semester, Fee, SubjCode, StaffID)
Primary Key (StaffID, Year, Semester)
Foreign Key (SubjCode) References Subject
Foreign Key (StaffID) References Teacher
Student(StudentID, Surname, GivenName, Gender)
Enrolment(DateEnrolled, Grade, Year, Semester, StudentID, StaffID, Year, Semester)
Primary Key (SubjCode, Year, Semester, StudentID)
Foreign Key (StaffID, Year, Semester) References SubjectOffering
Foreign Key (StudentID) References Student






*/
drop table if exists Enrollment;
drop table if exists SubjectOffering;
drop table if exists subject;
drop table if exists student;
drop table if exists Teacher;

CREATE TABLE Subject (
 SubjCode nvarchar(100) PRIMARY KEY
, Description nvarchar(500)
);

CREATE TABLE Student (
 StudentID nvarchar(10) PRIMARY KEY
, Surname nvarchar(100) 
, GivenName nvarchar(100)
, Gender nvarchar(1)
);

CREATE TABLE Teacher (
 StaffID int PRIMARY KEY
, Surname nvarchar(100)
, GivenName nvarchar(100)
);

CREATE TABLE SubjectOffering (
 SubjCode nvarchar(100)
, Year int
, Semester int
, Fee money
, StaffID int
, PRIMARY KEY (SubjCode,Year, Semester)
, FOREIGN KEY (SubjCode) REFERENCES Subject
, FOREIGN KEY (StaffID) REFERENCES Teacher
);

CREATE TABLE Enrollment (
 StudentID NVARCHAR(10)
, SubjCode nvarchar(100)
, Year int
, Semester int
, DateEnrolled DATETIME
, Grade nvarchar(2)
, PRIMARY KEY (StudentID, SubjCode, Year, Semester)
, FOREIGN KEY (StudentID) REFERENCES Student
, FOREIGN KEY (SubjCode, Year, Semester) REFERENCES SubjectOffering
);


INSERT INTO Student (StudentID, Surname, GIvenName, Gender)
VALUES ('102831215', 'Li', 'Dawei','M');
INSERT INTO Student (StudentID, Surname, GIvenName, Gender)
VALUES ('s12233445', 'Morrison', 'Scott','M');
INSERT INTO Student (StudentID, Surname, GIvenName, Gender)
VALUES ('s23344556', 'Gillard', 'Julia','F');
INSERT INTO Student (StudentID, Surname, GIvenName, Gender)
VALUES ('s34455667', 'Whitlam', 'Gough','M');

INSERT INTO Subject (SubjCode, Description)
VALUES ('ICTWEB425', 'Apply SQL to extract & manipulate data');
INSERT INTO Subject (SubjCode, Description)
VALUES ('ICTDBS403', 'Create Basic Databases');
INSERT INTO Subject (SubjCode, Description)
VALUES ('ICTDBS502', 'Design a Database');

INSERT INTO Teacher (StaffID, Surname, GivenName)
VALUES (98776655, 'Starr', 'Ringo');
INSERT INTO Teacher (StaffID, Surname, GivenName)
VALUES (87665544, 'Lennon', 'John');
INSERT INTO Teacher (StaffID, Surname, GivenName)
VALUES (76554433, 'McCartney', 'Paul');

INSERT INTO SubjectOffering (SubjCode, Year, Semester, Fee, StaffID)
VALUES ('ICTWEB425', 2018, 1, 200, 98776655)
INSERT INTO SubjectOffering (SubjCode, Year, Semester, Fee, StaffID)
VALUES ('ICTWEB425', 2019, 1, 225, 98776655)
INSERT INTO SubjectOffering (SubjCode, Year, Semester, Fee, StaffID)
VALUES ('ICTDBS403', 2019, 1, 200, 87665544)
INSERT INTO SubjectOffering (SubjCode, Year, Semester, Fee, StaffID)
VALUES ('ICTDBS403', 2019, 2, 200, 76554433)
INSERT INTO SubjectOffering (SubjCode, Year, Semester, Fee, StaffID)
VALUES ('ICTDBS502', 2018, 2, 225, 87665544)

INSERT INTO Enrollment (StudentID, SubjCode, Year,
Semester, DateEnrolled, Grade)
VALUES ('s12233445', 'ICTWEB425', 2018, 1, NULL, 'D');
INSERT INTO Enrollment (StudentID, SubjCode, Year,
Semester, DateEnrolled, Grade)
VALUES ('s23344556', 'ICTWEB425', 2018, 1, NULL, 'P');
INSERT INTO Enrollment (StudentID, SubjCode, Year,
Semester, DateEnrolled, Grade)
VALUES ('s12233445', 'ICTWEB425', 2019, 1, NULL, 'C');
INSERT INTO Enrollment (StudentID, SubjCode, Year,
Semester, DateEnrolled, Grade)
VALUES ('s23344556', 'ICTWEB425', 2019, 1, NULL, 'HD');
INSERT INTO Enrollment (StudentID, SubjCode, Year,
Semester, DateEnrolled, Grade)
VALUES ('s34455667', 'ICTWEB425', 2019, 1, NULL, 'P');
INSERT INTO Enrollment (StudentID, SubjCode, Year,
Semester, DateEnrolled, Grade)
VALUES ('s12233445', 'ICTDBS403', 2019, 1, NULL, 'C');
INSERT INTO Enrollment (StudentID, SubjCode, Year,
Semester, DateEnrolled, Grade)
VALUES ('s23344556', 'ICTDBS403', 2019, 2, NULL, NULL);
INSERT INTO Enrollment (StudentID, SubjCode, Year,
Semester, DateEnrolled, Grade)
VALUES ('s34455667', 'ICTDBS403', 2019, 2, NULL, NULL);
INSERT INTO Enrollment (StudentID, SubjCode, Year,
Semester, DateEnrolled, Grade)
VALUES ('s23344556', 'ICTDBS502', 2018, 2, NULL, 'P');
INSERT INTO Enrollment (StudentID, SubjCode, Year,
Semester, DateEnrolled, Grade)
VALUES ('s34455667', 'ICTDBS502', 2018, 2, NULL, 'N');

SELECT S.GivenName, S.Surname, E.SubjCode, 
Su.Description, E.Year, E.Semester, SO.Fee,
T.GivenName, T.Surname
FROM Student S 
INNER JOIN Enrollment E
ON E.StudentID = S.StudentID
INNER JOIN SubjectOffering SO
ON E.SubjCode = SO.SubjCode
AND E.Year = SO.Year
AND E.Semester = SO.semester
INNER JOIN Subject Su
ON SO.SubjCode = Su.SubjCode
Inner JOIN Teacher T
ON SO.StaffID = T.StaffID;

SELECT Year, Semester, count(StudentID) AS Num_Enrollments
FROM Enrollment
GROUP BY Year, Semester;

SELECT *
FROM SubjectOffering SO
INNER JOIN Subject S
ON SO.SubjCode = S.SubjCode
WHERE Fee = (SELECT MAX(Fee)  
FROM SubjectOffering 
WHERE SO.SubjCode = S.SubjCode);


SELECT SubjCode, Max(Fee) AS MAX  
FROM SubjectOffering 
GROUP BY SubjCode;　


SELECT *
FROM SubjectOffering
WHERE Fee = (SELECT MAX(Fee)  
FROM SubjectOffering );

SELECT SO.* 
FROM SubjectOffering SO,
(SELECT SubjCode,Max(Fee) AS MAX  
FROM SubjectOffering GROUP BY SubjCode) S1
WHERE SO.SubjCode = S1.SubjCOde AND SO.Fee = S1.MAX;

SELECT SO.*
FROM SubjectOffering SO
INNER JOIN (SELECT SubjCode, Max(Fee) AS MAX  FROM SubjectOffering 
GROUP BY SubjCode) S1
ON SO.SubjCOde = S1.SubjCode AND SO.Fee = S1.MAX;


CREATE VIEW View1 AS
SELECT S.GivenName, S.Surname, E.SubjCode, 
Su.Description, E.Year, E.Semester, SO.Fee,
T.GivenName AS TGivenName, T.Surname AS TSurname
FROM Student S 
INNER JOIN Enrollment E
ON E.StudentID = S.StudentID
INNER JOIN SubjectOffering SO
ON E.SubjCode = SO.SubjCode
AND E.Year = SO.Year
AND E.Semester = SO.semester
INNER JOIN Subject Su
ON SO.SubjCode = Su.SubjCode
Inner JOIN Teacher T
ON SO.StaffID = T.StaffID;

SELECT * FROM VIEW1;