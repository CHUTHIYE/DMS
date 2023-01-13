CREATE DATABASE EmployeeDB
go
USE EmployeeDB

CREATE TABLE Department(
DepartId int primary key,
DepartName varchar(50) not null,
[Description] varchar(100) not null
);

CREATE TABLE Employee(
EmpCode char(6) primary key,
FirstName varchar(30) not null,
LastName varchar(30) not null,
Birthday smalldatetime not null,
Gerder bit Default '1',
[Address] varchar(100),
DepartID int foreign key references Department(DepartID),
Salary Money
);
--1
INSERT INTO Department
VALUES
('01', 'Nhan Su', 'Tuyen nhan vien'),
('02', 'Kinh Doanh', 'Huong dan, chi dao cac hoat dong'),
('03', 'Hanh Chinh', 'Xu ly cong viec noi bo')

INSERT INTO Employee
VALUES
('001', 'Chu', 'Yen', '2004-09-05', '0', 'Nghe An', '01', '5000'),
('002', 'Tran', 'A', '2002-06-26', '1', 'Thanh Hoa', '02', '3000'),
('003', 'Nguyen', 'B', '1999-01-01', '', 'Ha Noi', '03', '7000')

--2
UPDATE Employee
SET Salary = Salary*0.1+Salary

--3
ALTER TABLE Employee
ADD CONSTRAINT CHK_Salary CHECK (Salary>0);

--4

CREATE TRIGGER tg_chkBirthday
ON Employee
AFTER INSERT, UPDATE
AS
BEGIN
	IF EXISTS (SELECT 1 FROM inserted WHERE Birthday <=23)
	begin
		raiserror ('Value of birthday column must be greater than 23', 16, 1);
		rollback transaction;
	END
END
--5
CREATE INDEX IX_DepartmentName
ON Department(DepartName);
--6
CREATE VIEW View_Employee
as
	SELECT Employee.EmpCode, Employee.FirstName, Employee.LastName, Department.DepartName
	FROM dbo.Department 
	INNER JOIN dbo.Employee 
	ON Department.DepartId = Employee.DepartID

--7
CREATE proc sp_getAllEmp @DepartId int
as
BEGIN
SELECT *FROM Employee e
WHERE e.DepartID = @DepartId
END

--8
create proc sp_delDept @EmpCode char(6)
as
BEGIN
DELETE FROM Employee 
WHERE EmpCode=@EmpCode
end

exec sp_getAllEmp 03

--select * from Department
--select * from Employee