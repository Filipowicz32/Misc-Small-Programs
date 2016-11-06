-- John Filipowicz
-- ITEC 340 Homework 2

DROP TABLE Room_Assign;
DROP TABLE Dorm;
DROP TABLE Campus;
DROP TABLE Student;

CREATE TABLE Campus
(
	Name VARCHAR2(15)
,	Provost VARCHAR2(25) NOT NULL
,	Phone VARCHAR2(14)
,	Zip NUMBER(5,0)
,	Opened NUMBER(4,0)
,	CONSTRAINT PKC_Name PRIMARY KEY (Name)
,	CONSTRAINT U_Phone UNIQUE (Phone)
);

CREATE TABLE Dorm
(
	Name VARCHAR2(15)
,	Campus VARCHAR2(15) NOT NULL
,	Dining VARCHAR2(1)
,	Num_Floors NUMBER(1,0)
,	Num_Rooms NUMBER(3,0)
,	CONSTRAINT PKD_Name PRIMARY KEY (Name)
,	CONSTRAINT FK_Campus FOREIGN KEY (Campus) REFERENCES Campus
,	CONSTRAINT CK_Dining CHECK (Dining = 'Y' OR Dining = 'N')
);

CREATE TABLE Student
(
	SID NUMBER(3,0)
,	First VARCHAR2(10)
,	Last VARCHAR2(10)
,	RANK VARCHAR2(2)
,	GPA NUMBER(3,2)
,	Gender VARCHAR2(1)
,	CONSTRAINT PKS_SID PRIMARY KEY (SID)
,	CONSTRAINT CK_GPA CHECK (GPA <= 4.0 AND GPA >= 0.0)
,	CONSTRAINT CK_Rank CHECK (Rank = 'FR' OR Rank = 'SO' OR Rank = 'JR' OR Rank = 'SR')
,	CONSTRAINT CK_Gender CHECK (Gender = 'M' OR Gender = 'F')
);

CREATE TABLE Room_Assign
(
	SID NUMBER(3,0)
,	Dorm_Name VARCHAR2(15)
,	Room_no NUMBER(3,0)
,	Deposit INTEGER
,	Assign_Date VARCHAR(8) 
,	CONSTRAINT PKR_SID PRIMARY KEY (SID, Dorm_Name, Room_no) 
,	CONSTRAINT FKR_SID FOREIGN KEY (SID) REFERENCES Student
,	CONSTRAINT FKR_Dorm_Name FOREIGN KEY (Dorm_Name) REFERENCES Dorm
,	CONSTRAINT CK_Deposit CHECK (Deposit >= 0)
);


--DML Statement Section

INSERT INTO Campus Values('Alexandria', 'M. Annette Haggray', '(703) 323-3000', 22311, 1965);
INSERT INTO Campus Values('Annandale', 'Pam Hilbert', '(703) 323-3158', 22003, 1966);
INSERT INTO Campus Values('Loudoun', 'Julie Leidig', '(703) 450-2505', 20164, 1974);
INSERT INTO Campus Values('Manassas', 'Molly Lynch', '(703) 257-6685', 20109, 1967);

INSERT INTO Dorm Values('Branner Hall', 'Loudoun', 'Y', 5, 200);
INSERT INTO Dorm Values('Crothers Hall', 'Annandale', 'N', 3, 125);
INSERT INTO Dorm Values('Robie Hall', 'Manassas', 'N', 4, 140);
INSERT INTO Dorm Values('Stern Hall', 'Manassas', 'Y', 4, 180);
INSERT INTO Dorm Values('Toyon Hall', 'Alexandria', 'Y', 3, 90);
INSERT INTO Dorm Values('Wilbur Hall', 'Annandale', 'Y', 5, 180);

INSERT INTO Student Values(121, 'Mary', 'Jones', 'SO', 3.15, 'F');
INSERT INTO Student Values(238, 'Jim', 'Stewart', 'SR', 2.85, 'M');
INSERT INTO Student Values(249, 'Bob', 'Smith', 'SR', 3.89, 'M');
INSERT INTO Student Values(187, 'Sue', 'Crowe', 'FR', 3.09, 'F');
INSERT INTO Student Values(375, 'Jll', 'Mayer', 'JR', 2.44, 'F');

INSERT INTO Room_Assign Values(121, 'Stern Hall', 415, 1200, '7/28/16');
INSERT INTO Room_Assign Values(238, 'Robie Hall', 222, 795, '6/13/16');
INSERT INTO Room_Assign Values(249, 'Wilbur Hall', 538, 825, '7/12/16');
INSERT INTO Room_Assign Values(187, 'Stern Hall', 249, 1200, '6/30/16');
INSERT INTO Room_Assign Values(375, 'Wilbur Hall', 538, 825, '8/5/16'); 
INSERT INTO Room_Assign Values(238, 'Robie Hall', 316, 900, '8/1/16');

UPDATE Dorm SET Dining = 'Y' WHERE Name = 'Robie Hall';
INSERT INTO Student Values(456, 'Amy', 'Marshall', 'FR', 0.00, 'F');
INSERT INTO Room_Assign Values(456, 'Crothers Hall', 301, 500, '8/12/16');
UPDATE Room_Assign SET Room_no = 218 WHERE SID = 187;
DELETE FROM Room_Assign  WHERE SID = 121;
DELETE FROM Student  WHERE SID = 121;
UPDATE Room_Assign SET Deposit = (Deposit * .1) + Deposit;



