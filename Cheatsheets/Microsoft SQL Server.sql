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

-- DatePart(DatePart, Date) - Returns an integer representing the specified DatePart.
SELECT DATEPART(WEEKDAY, '2012-08-30 19:45:31.793') -- returns 5

-- DATEADD(datepart, NumberToAdd, date) - Returns the DateTime, after adding specified NumberToAdd, to the datepart specified of the given date.
SELECT DATEADD(DAY, 20, '2012-08-30 19:45:31.793') -- Returns 2012-09-19 19:45:31.793
SELECT DATEADD(DAY, -20, '2012-08-30 19:45:31.793') -- Returns 2012-08-10 19:45:31.793

-- DATEDIFF(datepart, startdate, enddate) - Returns the count of the specified datepart boundaries crossed between the specified startdate and enddate.
SELECT DATEDIFF(MONTH, '11/30/2005','01/31/2006') -- returns 2
SELECT DATEDIFF(DAY, '11/30/2005','01/31/2006') -- returns 62

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

/* Real Example
Write a query to compute the age of a person, when the date of birth is given.

CREATE FUNCTION fnComputeAge(@DOB DATETIME)
RETURNS NVARCHAR(50)
AS
BEGIN
DECLARE @tempdate DATETIME, @years INT, @months INT, @days INT
SELECT @tempdate = @DOB

SELECT @years = DATEDIFF(YEAR, @tempdate, GETDATE()) -
						CASE
							WHEN (MONTH(@DOB) > MONTH(GETDATE())) OR
							(MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE()))
							THEN 1 ELSE 0
						END

SELECT @tempdate = DATEADD(YEAR, @years, @tempdate)

SELECT @months = DATEDIFF(MONTH, @tempdate, GETDATE()) -
						CASE
							WHEN DAY(@DOB) > DAY(GETDATE())
							THEN 1 ELSE 0
						END
SELECT @tempdate = DATEADD(MONTH, @months, @tempdate)

SELECT @days = DATEDIFF(DAY, @tempdate, GETDATE())

DECLARE @Age NVARCHAR(50)
SET @Age = CAST(@years AS  NVARCHAR(4)) + ' Years ' + CAST(@months AS  NVARCHAR(2))+ ' Months ' +  CAST(@days AS  NVARCHAR(2))+ ' Days Old'
RETURN @Age
END;

-- Executing
SELECT id, name, DateOfBirth, dbo.fnComputeAge(DateOfBirth) AS Age FROM tblEmployees;

*/





-- To convert one data type to another, CAST and CONVERT functions can be used. 
-- Syntax of CAST and CONVERT functions from MSDN:
CAST ( expression AS data_type [ ( length ) ] )
CONVERT ( data_type [ ( length ) ] , expression [ , style ] )

SELECT id, name, DateOfBirth, CAST(DateofBirth AS nvarchar) AS ConvertedDOB
FROM tblEmployees;
SELECT id, name, DateOfBirth, CONVERT(nvarchar, DateOfBirth) AS ConvertedDOB
FROM tblEmployees;

-- with style
SELECT id, name, DateOfBirth, CONVERT(nvarchar, DateOfBirth, 103) AS ConvertedDOB
FROM tblEmployees;

-- Complete list of all the Date and Time Styles:
-- https://learn.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?redirectedfrom=MSDN&view=sql-server-ver16

-- In SQL Server 2008, Date datatype is introduced, so you can also use
SELECT CAST(GETDATE() as DATE)
SELECT CONVERT(DATE, GETDATE())

/*
To control the formatting of the Date part, DateTime has to be converted to NVARCHAR using the styles provided. When converting to DATE data type, the CONVERT() function will ignore the style parameter.
1. Cast is based on ANSI standard and Convert is specific to SQL Server. So, if portability is a concern and if you want to use the script with other database applications, use Cast(). 
2. Convert provides more flexibility than Cast. For example, it's possible to control how you want DateTime datatypes to be converted using styles with convert function.
The general guideline is to use CAST(), unless you want to take advantage of the style functionality in CONVERT().
*/





-- Mathematical functions in sql server
-- ABS ( numeric_expression ) - ABS stands for absolute and returns, the absolute (positive) number. 
SELECT ABS(-101.5) -- returns 101.5

-- CEILING( numeric_expression ) returns the smallest integer value greater than or equal to the parameter.
-- FLOOR( numeric_expression ) returns the largest integer less than or equal to the parameter. 
SELECT CEILING(15.2) -- Returns 16
SELECT CEILING(-15.2) -- Returns -15

SELECT FLOOR(15.2) -- Returns 15
SELECT FLOOR(-15.2) -- Returns -16

-- POWER(expression, power) - Returns the power value of the specified expression to the specified power.
SELECT POWER(2,3) -- Returns 8

-- RAND([Seed_Value]) - Returns a random float number between 0 and 1. Rand() function takes an optional seed parameter. When seed value is supplied the RAND() function always returns the same value for the same seed.
SELECT RAND(1) -- Always returns the same value

-- To generate a random number between 1 and 100
SELECT FLOOR(RAND() * 100)

-- SQUARE ( Number ) - Returns the square of the given number.
SELECT SQUARE(9) -- Returns 81

-- SQRT ( Number ) - Returns the square root of the given number.
Select SQRT(81) -- Returns 9

/*
ROUND ( numeric_expression , length [ ,function ] ) - Rounds the given numeric expression based on the given length. This function takes 3 parameters:
1. Numeric_Expression is the number that we want to round.
2. Length parameter, specifies the number of the digits that we want to round to. If the length is a positive number, then the rounding is applied for the decimal part, where as if the length is negative, then the rounding is applied to the number before the decimal.
3. The optional function parameter, is used to indicate rounding or truncation operations. A value of 0, indicates rounding, where as a value of non zero indicates truncation. Default, if not specified is 0.
*/
-- Round to 2 places after (to the right) the decimal point
SELECT ROUND(850.556, 2) -- Returns 850.560

-- Truncate anything after 2 places, after (to the right) the decimal point
SELECT ROUND(850.556, 2, 1) -- Returns 850.550

-- Round to 1 place after (to the right) the decimal point
SELECT ROUND(850.556, 1) -- Returns 850.600

-- Truncate anything after 1 place, after (to the right) the decimal point
SELECT ROUND(850.556, 1, 1) -- Returns 850.500

-- Round the last 2 places before (to the left) the decimal point
SELECT ROUND(850.556, -2) -- 900.000

-- Round the last 1 place before (to the left) the decimal point
SELECT ROUND(850.556, -1) -- 850.000





-- UDF - User defined functions.
-- 1. Scalar valued functions

-- Scalar functions may or may not have parameters, but always return a single (scalar) value. The returned value can be of any data type, except text, ntext, image, cursor, and timestamp.
CREATE FUNCTION Function_Name(@Parameter1 DataType, @Parameter2 DataType,..@Parametern Datatype)
RETURNS Return_Datatype
AS
BEGIN
    -- Function Body
    RETURN Return_Datatype
END;

-- When calling a scalar user-defined function, you must supply a two-part name, OwnerName.FunctionName. dbo stands for database owner.
SELECT dbo.Age('10/08/1982')

-- You can also invoke it using the complete 3 part name, DatabaseName.OwnerName.FunctionName.
SELECT SampleDB.dbo.Age('10/08/1982')

-- Scalar user defined functions can be used in the Select and Where clause, as shown below.
SELECT name, DateOfBirth, dbo.Age(DateOfBirth) AS Age 
FROM tblEmployees
WHERE dbo.Age(DateOfBirth) > 30

-- To alter a function we use ALTER FUNCTION FunctionName statement and to delete it we use DROP FUNCTION FuncationName.
-- To view the text of the function use sp_helptext FunctionName



-- 2. Inline table valued functions
CREATE FUNCTION Function_Name(@Param1 DataType, @Param2 DataType..., @ParamN DataType)
RETURNS TABLE
AS
RETURN (Select_Statement)
/*
It is very similar to SCALAR function with the following differences
1. We specify TABLE as the return type, instead of any scalar data type
2. The function body is not enclosed between BEGIN and END block. Inline table valued function body cannot have BEGIN and END block.
3. The structure of the table that gets returned is determined by the SELECT statement with in the function.
*/

--Example
CREATE FUNCTION fn_EmployeesByGender(@Gender nvarchar(10))
RETURNS TABLE
AS
RETURN (SELECT id, name, DateOfBirth, Gender, DepartmentId
      FROM tblEmployees
      WHERE Gender = @Gender)
-- Calling the user defined function
SELECT * FROM fn_EmployeesByGender('Male')

/*
Where can we use Inline Table Valued functions
1. Inline Table Valued functions can be used to achieve the functionality of parameterized views.
2. The table returned by the table valued function can also be used in joins with other tables.
*/
SELECT name, Gender, DepartmentName 
FROM fn_EmployeesByGender('Male') E
JOIN tblDepartment D ON D.Id = E.DepartmentId



-- 3. Multi-statement Table Valued function (MSTVF)
CREATE FUNCTION fn_MSTVF_GetEmployees()
RETURNS @Table TABLE (Id int, name nvarchar(20), DOB date)
AS
BEGIN
	INSERT INTO @Table
	SELECT id, name, CAST(DateOfBirth AS date)
	FROM tblEmployees
	RETURN
END

-- Calling the Multi-statement Table Valued Function:
SELECT * FROM fn_MSTVF_GetEmployees()

/*
The differences between Inline Table Valued functions and Multi-statement Table Valued functions
1. In an Inline Table Valued function the RETURNS clause cannot contain the structure of the table, the function returns. Where as, with the multi-statement table valued function, we specify the structure of the table that gets returned
2. Inline Table Valued function cannot have BEGIN and END block, where as the multi-statement function can have.
3. Inline Table valued functions are better for performance, than multi-statement table valued functions. If the given task, can be achieved using an inline table valued function, always prefer to use them, over multi-statement table valued functions.
4. It's possible to update the underlying table, using an inline table valued function, but not possible using multi-statement table valued function.

Updating the underlying table using inline table valued function: 
This query will change Sam to Sam1, in the underlying table tblEmployees. When you try do the same thing with the multi-statement table valued function, you will get an error stating 'Object 'fn_MSTVF_GetEmployees' cannot be modified.'
UPDATE fn_ILTVF_GetEmployees() SET name='Sam1' WHERE id = 1

Reason for improved performance of an inline table valued function:
Internally, SQL Server treats an inline table valued function much like it would a view and treats a multi-statement table valued function similar to how it would a stored procedure.
*/

/*
Deterministic functions always return the same result any time they are called with a specific set of input values and given the same state of the database. 
Examples: Sum(), AVG(), Square(), Power() and Count()
Note: All aggregate functions are deterministic functions.

Nondeterministic functions may return different results each time they are called with a specific set of input values even if the database state that they access remains the same.
Examples: GetDate() and CURRENT_TIMESTAMP

Rand() function is a Non-deterministic function, but if you provide the seed value, the function becomes deterministic, as the same value gets returned for the same seed value.
*/


-- Encrypting the text of the UDF
ALTER FUNCTION {FUNC_NAME}
...
WITH ENCRYPTION
AS
...


-- SchemaBinding
ALTER FUNCTION fn_GetEmployeeNameById(@Id int)
RETURNS nvarchar(20)
WITH SCHEMABINDING
AS
BEGIN
	RETURN (SELECT NAME FROM dbo.tblEmployees WHERE Id = @Id)
END

-- Schemabinding specifies that the function is bound to the database objects that it references. When SCHEMABINDING is specified, the base objects cannot be modified in any way that would affect the function definition. The function definition itself must first be modified or dropped to remove dependencies on the object that is to be modified.












SELECT * FROM [dbo].[tblGender]
SELECT * FROM [dbo].[tblPerson]
-- https://www.pragimtech.com/courses/sql-server-tutorial-for-beginners/
-- https://csharp-video-tutorials.blogspot.com/2014/05/sql-server-interview-questions-and.html