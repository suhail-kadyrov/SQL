-- To Create the database using a query
CREATE DATABASE {DatabaseName};





/* Whether, you create a database graphically using the designer or, using a query, the following 2 files gets generated.
.MDF - Master Data File (Contains actual data)
.LDF - Transaction Log file (Used to recover the database)
*/





-- Rename Database
ALTER DATABASE {DatabaseName} MODIFY name = {NewName};
-- sp_renameDB '{OldName}', '{NewName}'





-- To Delete or Drop a database
DROP DATABASE {DatabaseNameThatYouWantToDrop};
-- Dropping a database deletes the LDF and MDF files.

-- If other users are connected, you need to put the database in single user mode and then drop the database.
ALTER DATABASE {DatabaseName} SET SINGLE_USER With Rollback Immediate;





/* USE Sample1
GO */





-- Creating table
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
-- To see all information about table and its columns in SSMS, highlight the table name and press ALT + F1





-- FOREIGN KEY CONSTRAINT
ALTER TABLE tblPerson
ADD CONSTRAINT tblPerson_GenderID_FK
FOREIGN KEY (GenderID)
REFERENCES tblGender (ID);

-- The general formula is here
ALTER TABLE {ForeignKeyTable}
ADD CONSTRAINT {ForeignKeyTable}_{ForiegnKeyColumn}_FK 
FOREIGN KEY ({ForiegnKeyColumn})
REFERENCES {PrimaryKeyTable} ({PrimaryKeyColumn});


INSERT INTO tblGender (id, gender)
VALUES (3, 'Unknown'); -- Text values should be present in single quotes.

INSERT INTO tblPerson (id, name, email)
VALUES (6, 'Hagrid', 'h@h.com');





-- DEFAULT CONSTRAINT
ALTER TABLE [dbo].[tblPerson]
ADD CONSTRAINT DF_tblPerson_GenderID
DEFAULT 3 FOR GenderID;

-- The general formula for default constraint
-- Altering an existing column to add a default constraint
ALTER TABLE {TABLE_NAME}
ADD CONSTRAINT {CONSTRAINT_NAME} -- = DF_{TABLE_NAME}_{COLUMN_NAME} - meaningful name for constraint
DEFAULT {DEFAULT_VALUE} FOR {EXISTING_COLUMN_NAME};

-- Adding a new column with default value to an existing table:
ALTER TABLE {TABLE_NAME} 
ADD {COLUMN_NAME} {DATA_TYPE} {NULL | NOT NULL}
CONSTRAINT {CONSTRAINT_NAME} DEFAULT {DEFAULT_VALUE};


INSERT INTO tblPerson (id, name, email)
VALUES (7, 'Luna', 'l@l.com');

-- The following insert statement will insert NULL, instead of using the default.
INSERT INTO tblPerson (id, name, email, GenderID)
VALUES (8, 'Draco', 'd@d.com', NULL);


-- Adding new column with DEFAULT CONSTRAINT
ALTER TABLE [dbo].[tblPerson]
ADD age int
CONSTRAINT DF_tblPerson_age
DEFAULT 16;


INSERT INTO tblPerson (id, name, email)
VALUES (10, 'Luna', 'l@l.com');





-- To drop a constraint
ALTER TABLE {TABLE_NAME}
DROP CONSTRAINT {CONSTRAINT_NAME};

ALTER TABLE [dbo].[tblPerson]
DROP CONSTRAINT DF_tblPerson_age;

INSERT INTO tblPerson (id, name, email)
VALUES (11, 'Crabbe', 'c@c.com');





-- Cascading referential integrity constraint
ALTER TABLE [dbo].[tblPerson]
ADD CONSTRAINT tblPerson_GenderID_FK
FOREIGN KEY ([GenderID])
REFERENCES [dbo].[tblGender]([id])
ON DELETE SET NULL;
-- ON DELETE CASCADE;





-- The general formula for adding CHECK CONSTRAINT in SQL Server
ALTER TABLE {TABLE_NAME}
ADD CONSTRAINT {CONSTRAINT_NAME} -- = CK_{TABLE_NAME}_{COLUMN_NAME} - meaningful name for constraint
CHECK ({BOOLEAN_EXPRESSION});

-- The following check constraint, limits the age between ZERO and 150.
ALTER TABLE tblPerson
ADD CONSTRAINT CK_tblPerson_Age
CHECK (Age > 0 AND Age < 150);
-- In this case, when you pass NULL for the AGE column, the boolean expression evaluates to UNKNOWN and allows the value.





-- Adding a column auto increment
CREATE TABLE {TABLE_NAME} (
	id int Identity({SEED}, {INCREMENT_VALUE}) PRIMARY KEY,
	...
); -- SEED = initial value

CREATE TABLE tblPerson (
	id int Identity(1,1) PRIMARY KEY,
	name nvarchar(20)
);
Insert into tblPerson values ('Sam');
Insert into tblPerson values ('Sara');

-- Inserting custom value into identity columns
SET IDENTITY_INSERT {TABLE_NAME} ON;
INSERT INTO {TABLE_NAME} (id, ...)
VALUES ({CUSTOM_VALUE}, ...);
SET IDENTITY_INSERT {TABLE_NAME} OFF;

-- Reseeding identity cloumn
DBCC CHECKIDENT({TABLE_NAME}, RESEED, 0);

-- Example queries for getting the last generated identity value
Select SCOPE_IDENTITY();
Select @@IDENTITY;
Select IDENT_CURRENT('{TABLE_NAME}');

/*
SCOPE_IDENTITY() - returns the last identity value that is created in the same session and in the same scope.
@@IDENTITY - returns the last identity value that is created in the same session and across any scope.
IDENT_CURRENT('TableName') - returns the last identity value that is created for a specific table across any session and any scope.
*/





-- To create the unique key using a query:
ALTER TABLE {TABLE_NAME}
ADD CONSTRAINT {CONSTRAINT_NAME} -- = UQ_{TABLE_NAME}_{COLUMN_NAME} - meaningful name for constraint
UNIQUE (COLUMN_NAME);

/*
The difference between Primary key constraint and Unique key constraint.
1. A table can have only one primary key, but more than one unique key
2. Primary key does not allow nulls, where as unique key allows one null
*/





-- Select statement syntax
SELECT {COLUMN_LIST}
FROM {TABLE_NAME};

-- To Select distinct rows use DISTINCT keyword
SELECT DISTINCT {COLUMN_LIST}
FROM {TABLE_NAME};
-- when you use SELECT DISTINCT with multiple columns, SQL ignores rows with same values across columns that specified in {COLUMN_LIST}





-- Filtering rows with WHERE clause
SELECT {COLUMN_LIST}
FROM {TABLE_NAME}
WHERE {FILTER_CONDITION};





-- Sorting rows using ORDER BY
SELECT {COLUMN_LIST}
FROM {TABLE_NAME}
ORDER BY {COLUMN_NAMES_OR_POSITIONS, } {ASC | DESC};





-- Selecting top {n} rows
SELECT TOP {n} {COLUMN_LIST}
FROM {TABLE_NAME};

-- Selecting top {n} percentage of rows
SELECT TOP {n} PERCENT {COLUMN_LIST}
FROM {TABLE_NAME};





-- GROUP BY, HAVING examples
SELECT City, Gender, SUM(Salary) as [Total Salary], COUNT(ID) as [Total Employees]
FROM tblEmployee
WHERE Gender = 'Male'
GROUP BY City, Gender
HAVING City = 'London';

/* Difference between WHERE and HAVING clause:
1. WHERE clause can be used with - Select, Insert, and Update statements, where as HAVING clause can only be used with the Select statement.
2. WHERE filters rows before aggregation (GROUPING), where as, HAVING filters groups, after the aggregations are performed.
3. Aggregate functions cannot be used in the WHERE clause, unless it is in a sub query contained in a HAVING clause, whereas, aggregate functions can be used in Having clause.

As a best practice, use the syntax that clearly describes the desired result. Try to eliminate rows that you wouldn't need, as early as possible.
*/





-- General Formula for Joins
SELECT {COLUMN_LIST}
FROM {LEFT_TABLE_NAME}
{JOIN_TYPE} {RIGHT_TABLE_NAME} -- JOIN_TYPES -> (INNER) JOIN, LEFT (OUTER) JOIN, RIGHT (OUTER) JOIN, FULL (OUTER) JOIN
ON {JOIN_CONDITION};

-- CROSS JOIN (Cartesian Product)
SELECT {COLUMN_LIST}
FROM {LEFT_TABLE_NAME}
CROSS JOIN {RIGHT_TABLE_NAME};





-- How to retrieve only the non matching rows from outer joins
SELECT {COLUMN_LIST}
FROM {LEFT_TABLE_NAME}
LEFT JOIN {RIGHT_TABLE_NAME}
ON {JOIN_CONDITION}
WHERE {RIGHT_TABLE}.id IS NULL;

SELECT {COLUMN_LIST}
FROM {LEFT_TABLE_NAME}
RIGHT JOIN {RIGHT_TABLE_NAME}
ON {JOIN_CONDITION}
WHERE {LEFT_TABLE}.id IS NULL;

SELECT {COLUMN_LIST}
FROM {LEFT_TABLE_NAME}
FULL OUTER JOIN {RIGHT_TABLE_NAME}
ON {JOIN_CONDITION}
WHERE {LEFT_TABLE}.id IS NULL
OR {RIGHT_TABLE}.id IS NULL;





-- Self Join Query
SELECT {COLUMN_LIST} AS {ALIASES}
FROM {TABLE_NAME} {ALIAS_1}
{JOIN_TYPE} {TABLE_NAME} {ALIAS_2} -- JOIN_TYPES -> (INNER) JOIN, LEFT (OUTER) JOIN, RIGHT (OUTER) JOIN, FULL (OUTER) JOIN, CROSS JOIN
ON {JOIN_CONDITION}; -- If JOIN_TYPE <> CROSS JOIN


DELETE FROM [dbo].[tblGender] WHERE id=3;


SELECT * FROM [dbo].[tblGender]
SELECT * FROM [dbo].[tblPerson]