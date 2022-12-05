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

DELETE FROM [dbo].[tblGender] WHERE id=3;





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





-- Different ways to replace NULL in sql server
SELECT ISNULL({EXPRESSION}, {REPLACEMENT_VALUE}) AS {ALIAS};

SELECT CASE WHEN {EXPRESSION} IS NULL THEN {REPLACEMENT_VALUE} ELSE {EXPRESSION} END AS {ALIAS};

SELECT COALESCE({EXPRESSION}, {REPLACEMENT_VALUE}) AS {ALIAS};
-- COALESCE() can have multiple arguments and returns the first non-null value.





-- UNION
SELECT ...
UNION
SELECT ...
...
/*
Differences between UNION and UNION ALL (Common Interview Question)
From the output, it is very clear that, UNION removes duplicate rows, where as UNION ALL does not. When use UNION, to remove the duplicate rows, sql server has to to do a distinct sort, which is time consuming. For this reason, UNION ALL is much faster than UNION. 
If you want to see the cost of DISTINCT SORT, you can turn on the estimated query execution plan using CTRL + L.
For UNION and UNION ALL to work, the Number, Data types, and the order of the columns in the select statements should be same.
If you want to sort, the results of UNION or UNION ALL, the ORDER BY caluse should be used on the last SELECT statement.
*/





-- Stored procedures

-- Createing
CREATE PROCEDURE spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int OUTPUT
AS
BEGIN
	SELECT @EmployeeCount = COUNT(id) 
	FROM tblEmployee 
	WHERE Gender = @Gender
END;

-- Executing
DECLARE @EmployeeTotal int
EXECUTE spGetEmployeeCountByGender 'Female', @EmployeeTotal OUTPUT
PRINT @EmployeeTotal

-- Changing
ALTER PROCEDURE {PROC_NAME}
...

-- Encrypting the text of the SP
ALTER PROCEDURE {PROC_NAME}
...
WITH ENCRYPTION
AS
...

-- Deleting
DROP PROCEDURE {PROC_NAME};

-- Passing parameters in any order
DECLARE @EmployeeTotal int
EXECUTE spGetEmployeeCountByGender @EmployeeCount = @EmployeeTotal OUT, @Gender = 'Male'
PRINT @EmployeeTotal

/* The following system stored procedures, are extremely useful when working procedures.
sp_help SP_Name: View the information about the stored procedure, like parameter names, their datatypes etc. sp_help can be used with any database object, like tables, views, SP's, triggers etc. Alternatively, you can also press ALT+F1, when the name of the object is highlighted.
sp_helptext SP_Name : View the Text of the stored procedure if it is not encrypted.
sp_depends SP_Name : View the dependencies of the stored procedure. This system SP is very useful, especially if you want to check, if there are any stored procedures that are referencing a table that you are abput to drop. sp_depends can also be used with other database objects like table etc.
*/

-- Returning values from SP
CREATE PROCEDURE spGetTotalCountOfEmployees2
AS
BEGIN
	RETURN (SELECT COUNT(id) FROM Employees)
END

-- Executing
DECLARE @TotalEmployees int
EXECUTE @TotalEmployees = spGetTotalCountOfEmployees2
SELECT @TotalEmployees

/*
Difference between return values and output parameters

Return value                     |Output Parameters
---------------------------------|------------------------------------------
Only integer data type           |Any data type
---------------------------------|------------------------------------------
Only one value                   |More than one value
---------------------------------|------------------------------------------
Use to convey success or failure |Use to return values like name, count, ...
---------------------------------|------------------------------------------


Advantages of using Stored Procedures
1. Execution plan retention and reusability 
2. Reduces network traffic
3. Code reusability and better maintainability
4. Better Security
5. Avoids SQL Injection attack
*/





-- Some useful string functions

-- ASCII(Character_Expression) - Returns the ASCII code of the given character expression.
-- CHAR(Integer_Expression) - Converts an int ASCII code to a character. The Integer_Expression, should be between 0 and 255.
-- Printing uppercase alphabets using CHAR() function:
DECLARE @Number int
SET @Number = 65
WHILE(@Number <= 90)
BEGIN
	PRINT CHAR(@Number)
	SET @Number = @Number + 1
END;

-- LTRIM(Character_Expression) - Removes blanks on the left handside of the given character expression.
-- RTRIM(Character_Expression) - Removes blanks on the right hand side of the given character expression.
-- LOWER(Character_Expression) - Converts all the characters in the given Character_Expression, to lowercase letters.
-- UPPER(Character_Expression) - Converts all the characters in the given Character_Expression, to uppercase letters.

-- REVERSE('Any_String_Expression') - Reverses all the characters in the given string expression.
SELECT REVERSE('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
-- Output: ZYXWVUTSRQPONMLKJIHGFEDCBA

-- LEN(String_Expression) - Returns the count of total characters, in the given string expression, excluding the blanks at the end of the expression.
SELECT LEN('SQL Functions   ')
-- Output: 13

-- LEFT(Character_Expression, Integer_Expression) - Returns the specified number of characters from the left hand side of the given character expression.
-- RIGHT(Character_Expression, Integer_Expression) - Returns the specified number of characters from the right hand side of the given character expression.

-- CHARINDEX('Expression_To_Find', 'Expression_To_Search', 'Start_Location') - Returns the starting position of the specified expression in a character string. Start_Location parameter is optional.
SELECT CHARINDEX('@','sara@aaa.com',1)
-- Output: 5

-- SUBSTRING('Expression', 'Start', 'Length') - As the name, suggests, this function returns substring (part of the string), from the given expression. You specify the starting location using the 'start' parameter and the number of characters in the substring using 'Length' parameter. All the 3 parameters are mandatory.
SELECT SUBSTRING('John@bbb.com',6, 7)
-- Output: bbb.com

-- REPLICATE(String_To_Be_Replicated, Number_Of_Times_To_Replicate) - Repeats the given string, for the specified number of times.
SELECT REPLICATE('Pragim', 3)
-- Output: Pragim Pragim Pragim 

-- SPACE(Number_Of_Spaces) - Returns number of spaces, specified by the Number_Of_Spaces argument.
-- PATINDEX('%Pattern%', Expression) - Returns the starting position of the first occurrence of a pattern in a specified expression. If the specified pattern is not found, PATINDEX() returns ZERO.

-- REPLACE(String_Expression, Pattern , Replacement_Value) - Replaces all occurrences of a specified string value with another string value.
SELECT REPLACE(Email, '.com', '.net') as ConvertedEmail
FROM tblEmployee;

-- STUFF(Original_Expression, Start, Length, Replacement_expression) - Inserts Replacement_expression, at the start position specified, along with removing the charactes specified using Length parameter.
SELECT STUFF(Email, 2, 3, '*****') as StuffedEmail
FROM tblEmployee;





-- DateTime functions
-- GETDATE() - Get the current system date and time, where you have sql server installed.

-- ISDATE() - Checks if the given value, is a valid date, time, or datetime. Returns 1 for success, 0 for failure.
SELECT ISDATE('PRAGIM') -- returns 0
SELECT ISDATE(Getdate()) -- returns 1
SELECT ISDATE('2012-08-31 21:02:04.167') -- returns 1

-- DAY() - Returns the 'Day number of the Month' of the given date
SELECT DAY(GETDATE()) -- Returns the day number of the month, based on current system datetime.
SELECT DAY('01/31/2012') -- Returns 31

-- MONTH() - Returns the 'Month number of the year' of the given date
SELECT Month(GETDATE()) -- Returns the Month number of the year, based on the current system date and time
SELECT Month('01/31/2012') -- Returns 1

-- YEAR() - Returns the 'Year number' of the given date
SELECT Year(GETDATE()) -- Returns the year number, based on the current system date
SELECT Year('01/31/2012') -- Returns 2012

-- DateName(DatePart, Date) - Returns a string, that represents a part of the given date
SELECT DATENAME(DAY, '2012-09-30 12:43:46.837') -- Returns 30
SELECT DATENAME(WEEKDAY, '2012-09-30 12:43:46.837') -- Returns Sunday
SELECT DATENAME(MONTH, '2012-09-30 12:43:46.837') -- Returns September

/* Valid DatePart parameter values and their abbreviations

DatePart    |Abbreviation
------------|------------
year        |yy, yyyy
quater      |qq, q
month       |mm, m
dayofyear   |dy, y
day         |dd, d
week        |wk, ww
weekday     |dw
hour        |hh
minute      |mi, n
second      |ss, s
millisecond |ms
microsecond |mcs
nanosecond  |ns
TZoffset    |tz
*/










SELECT * FROM [dbo].[tblGender]
SELECT * FROM [dbo].[tblPerson]
-- https://www.pragimtech.com/courses/sql-server-tutorial-for-beginners/
-- https://csharp-video-tutorials.blogspot.com/2014/05/sql-server-interview-questions-and.html