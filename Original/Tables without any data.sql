IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Tables without any data]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Tables without any data]
GO

CREATE PROCEDURE [SQLCop].[test Tables without any data]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	
	SET NOCOUNT ON
	
	DECLARE @Output VarChar(max)
	SET @Output = ''

	CREATE TABLE #EmptyTables(Table_Name VarChar(100))  
	EXEC 	sp_MSforeachtable 'IF NOT EXISTS(SELECT 1 FROM ?) INSERT INTO #EmptyTables VALUES(''?'')' 
	SELECT	@Output = @Output + Table_Name + Char(13) + Char(10)
	FROM	#EmptyTables 
	Where	Left(Table_Name, 7) <> '[tSQLt]'
	ORDER BY Table_Name 
	DROP TABLE #EmptyTables

	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'Empty tables in your database:' 
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End	  
END;