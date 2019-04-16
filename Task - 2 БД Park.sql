
CREATE DATABASE Park
GO

USE Park
GO

CREATE TABLE Employees
(ID int IDENTITY(1,1), 
FName nvarchar(20) NOT NULL, 
MName nvarchar(20) NOT NULL, 
LName nvarchar(20) NOT NULL, 
Post nvarchar(20) NOT NULL,
Salary money NOT NULL)
GO

CREATE TABLE EmployeesInfo
(ID int NOT NULL,
Phone char(12) NOT NULL,
[Address] nvarchar(50) NOT NULL,
MaritalStatus nvarchar(10) NOT NULL,
BirthDate date NOT NULL)
GO

CREATE TABLE Plants
(ID int IDENTITY(1,1),
PName nvarchar(20) NOT NULL)
GO

CREATE TABLE PlantsDetails
(ID int NOT NULL,
TypePlant nvarchar(15) NOT NULL,
PlantingDate date NOT NULL)
GO

CREATE TABLE Tasks
(ID int IDENTITY(1,1), 
TypeAction nvarchar(35) NOT NULL)
GO

CREATE TABLE ListActions
(ID int IDENTITY(1,1),
EmployeesID int NOT NULL,
TaskID int NOT NULL,
PlantsID int NOT NULL,
OrderDate date NOT NULL DEFAULT GETDATE())
GO

ALTER TABLE Employees
ADD
PRIMARY KEY(ID)
GO

ALTER TABLE EmployeesInfo
ADD
UNIQUE(ID)
GO

ALTER TABLE EmployeesInfo
WITH CHECK  
ADD
FOREIGN KEY(ID) REFERENCES Employees (ID) 
ON DELETE CASCADE               
GO

ALTER TABLE Plants
ADD
PRIMARY KEY(ID)
GO

ALTER TABLE PlantsDetails
ADD
UNIQUE(ID)
GO

ALTER TABLE PlantsDetails
WITH CHECK
ADD
FOREIGN KEY(ID) REFERENCES Plants (ID)
ON DELETE CASCADE
GO

ALTER TABLE Tasks
ADD
PRIMARY KEY(ID)
GO

ALTER TABLE ListActions
ADD
PRIMARY KEY(ID)
GO

ALTER TABLE ListActions
WITH CHECK 
ADD
FOREIGN KEY(EmployeesID) REFERENCES Employees (ID),
FOREIGN KEY(PlantsID) REFERENCES Plants (ID),
FOREIGN KEY(TaskID) REFERENCES Tasks (ID)
GO

ALTER TABLE EmployeesInfo
ADD
CHECK (Phone LIKE '([0-9][0-9])[0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO

ALTER TABLE EmployeesInfo
ADD
CHECK (BirthDate BETWEEN DATEADD(YEAR, -50, GETDATE()) AND DATEADD(YEAR, -18, GETDATE()))
GO

ALTER TABLE EmployeesInfo
ADD
CHECK (MaritalStatus IN ('�����','�� �����','�������','�� �������'))
GO

ALTER TABLE PlantsDetails
ADD
CHECK (TypePlant IN ('�������', '����������'))
GO

ALTER TABLE Employees
ALTER COLUMN MName nvarchar(20) NULL 
GO

INSERT Plants 
(PName)
VALUES
('������'), ('���'), ('�����'), ('����'), ('�����'), ('�����'), 
('���'), ('����'), ('���'), ('������'), ('������')
GO

INSERT PlantsDetails
(ID, TypePlant,PlantingDate)
VALUES
(1,'����������','19470913'),(2,'�������','19470913'),(3,'�������','19470913'),
(4,'����������','19500320'), (5,'����������','19500320'),(6,'����������','19500320'),
(7,'����������','19500409'),(8,'����������','19500409'), (9,'����������','19500409'),
(10,'����������','19500409'), (11,'����������','19500923')
GO

INSERT Employees
(FName, MName, LName, Post, Salary)
VALUES
('����������', '�������', '�����', '���������', 950),
('�������', '���������', '������', '�����������', 750),
('�����', '�����������', '�������', '������', 620),
('����', '��������', '���������', '������', 730),
('����', '����������', '������', '������', 730),
('������', NULL, '�����������', '��������', 500),
('��������', '������������', '�����', '��������', 580),
('�������', '���������', '�������', '�������', 450)
GO

INSERT EmployeesInfo
(ID,Phone,[Address],MaritalStatus,BirthDate)
VALUES
(1,'(44)5892345','��. ������ 46','�����','19791023'),
(2,'(29)5892346','��. �������� 3, ��. 104','�� �����','19860706'),
(3,'(44)3218998','��. ������ 23, �� 65','�����','19851123'),
(4,'(44)4768903','��. ������ 3, �� 10','�����','19790708'),
(5,'(33)1025490','��. ������� 12, �� 32','�� �����','19890109'),
(6,'(25)2300465','��. �������� 14, �� 98','�����','19800824'),
(7,'(44)9983210','��. �������� 23, �� 29','�����','19830418'),
(8,'(33)1248294','��. ������� 12','�������','19750513')
GO

INSERT Tasks
(TypeAction)
VALUES
('������� ��������'), ('�������������� ���������'), 
('�������'), ('�����������')
GO

INSERT ListActions
(EmployeesID, TaskID, PlantsID, OrderDate)
VAlUES
(3, 2, 4,'20190311'),(2, 1, 5,'20190315'),(3, 4, 11,'20190329'),(3, 3, 6,'20190401'),
(2, 2, 3,'20190402'),(3, 2, 1,'20190402'),(3, 1, 9,'20190408'),(3, 1, 8,'20190409'),
(3, 1, 7,'20190420'),(3, 2, 10,'20190423'),(2, 1, 8,'20190428'),(2, 1, 2,'20190428'),
(2, 1, 2,'20190428')
GO

SELECT * FROM Employees
SELECT * FROM EmployeesInfo
SELECT * FROM Plants
SELECT * FROM PlantsDetails
SELECT * FROM Tasks
SELECT * FROM ListActions
GO

SELECT name FROM sys.databases
SELECT name FROM sys.tables
GO

SELECT Post, LName AS Surname, Salary FROM Employees WHERE Salary > 500
SELECT Post, LName AS Surname, Salary FROM Employees WHERE Salary BETWEEN 500 AND 800
GO

SELECT PName, TypePlant FROM Plants
JOIN PlantsDetails ON Plants.ID = PlantsDetails.ID
ORDER BY PName DESC
GO

SELECT ListActions.ID, Employees.LName AS Surname, TypeAction
FROM ListActions 
JOIN Employees ON ListActions.EmployeesID = Employees.ID
JOIN Tasks ON ListActions.TaskID = Tasks.ID
ORDER BY ListActions.ID
GO

SELECT Employees.LName AS Surname, TypeAction
FROM Employees 
LEFT JOIN ListActions ON ListActions.EmployeesID = Employees.ID 
LEFT JOIN Tasks ON ListActions.TaskID = Tasks.ID
ORDER BY Employees.LName
GO

SELECT a.ID NTask, t.TypeAction, p.PName, OrderDate, pd.TypePlant
FROM ListActions a
JOIN Plants p ON a.PlantsID = p.ID
JOIN PlantsDetails pd ON p.ID = pd.ID
JOIN Tasks t ON a.TaskID = t.ID
ORDER BY a.ID
GO

SELECT em.LName + ' ' + em.FName worker, em.Post, TypeAction, COUNT(PName) Plants
FROM ListActions ac
JOIN Employees em ON ac.EmployeesID = em.ID
JOIN EmployeesInfo emI ON em.ID = emI.ID
JOIN Tasks t ON ac.TaskID = t.ID
JOIN Plants p ON ac.PlantsID = p.ID
WHERE OrderDate > '20190401'
GROUP BY em.LName, em.FName, em.Post, TypeAction
ORDER BY Plants DESC
GO

SELECT em.LName + ' ' + em.FName worker, em.Post, TypeAction, COUNT(PName) Plants, TypePlant
FROM ListActions ac
JOIN Employees em ON ac.EmployeesID = em.ID
JOIN EmployeesInfo emI ON em.ID = emI.ID
JOIN Tasks t ON ac.TaskID = t.ID
JOIN Plants p ON ac.PlantsID = p.ID
JOIN PlantsDetails pd ON p.ID = pd.ID
WHERE OrderDate > '20190301'
GROUP BY em.LName, em.FName, em.Post, TypeAction, TypePlant
HAVING COUNT(PName) > 1
ORDER BY Plants DESC
GO