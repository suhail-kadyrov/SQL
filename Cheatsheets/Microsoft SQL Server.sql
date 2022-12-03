CREATE DATABASE Sample1;

/* .MDF - Master Data File
.LDF - Log Data File */

-- ALTER DATABASE Sample1 MODIFY name = Sample2;

-- sp_renameDB 'Sample2', 'Sample3'

-- DROP DATABASE Sample3;

-- ALTER DATABASE {DB Name} SET SINGLE_USER With Rollback Immediate

/* USE Sample1
GO */


CREATE TABLE tblPerson (
	id int NOT NULL PRIMARY KEY,
	name nvarchar(50) NOT NULL,
	email nvarchar(50) NOT NULL,
	GenderID int
);


CREATE TABLE tblGender (
	id int NOT NULL PRIMARY KEY,
	gender nvarchar(50) NOT NULL
);


ALTER TABLE tblPerson
ADD CONSTRAINT tblPerson_GenderID_FK
FOREIGN KEY (GenderID)
REFERENCES tblGender (ID);


INSERT INTO tblGender (id, gender)
VALUES (3, 'Unknown');


INSERT INTO tblPerson (id, name, email)
VALUES (6, 'Hagrid', 'h@h.com');


ALTER TABLE [dbo].[tblPerson]
ADD CONSTRAINT DF_tblPerson_GenderID
DEFAULT 3 FOR GenderID;


INSERT INTO tblPerson (id, name, email)
VALUES (7, 'Luna', 'l@l.com');


INSERT INTO tblPerson (id, name, email, GenderID)
VALUES (8, 'Draco', 'd@d.com', NULL);


ALTER TABLE [dbo].[tblPerson]
ADD age int
CONSTRAINT DF_tblPerson_age
DEFAULT 16;


INSERT INTO tblPerson (id, name, email)
VALUES (10, 'Luna', 'l@l.com');


ALTER TABLE [dbo].[tblPerson]
DROP CONSTRAINT DF_tblPerson_age;


INSERT INTO tblPerson (id, name, email)
VALUES (11, 'Crabbe', 'c@c.com');


/* ALTER TABLE [dbo].[tblPerson]
ADD CONSTRAINT fk_SalesHistoryProductID
FOREIGN KEY (ProductID)
REFERENCES Products(ProductID)
ON DELETE CASCADE ON UPDATE CASCASE; */


SELECT * FROM [dbo].[tblGender]
SELECT * FROM [dbo].[tblPerson]