IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Compatibility Level]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Compatibility Level]
GO

CREATE PROCEDURE [SQLCop].[test Compatibility Level]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	
	SET NOCOUNT ON
	
	Declare @Output VarChar(max)
	Set @Output = ''

	Select @Output = @Output + Name + Char(13) + Char(10)
	FROM   master.dbo.sysdatabases
	WHERE  cmptlevel != 10 * CONVERT(Int, CONVERT(FLOAT, CONVERT(VARCHAR(3), SERVERPROPERTY('productversion'))))

	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'https://docs.microsoft.com/en-us/sql/t-sql/statements/alter-database-transact-sql-compatibility-level'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End
  
END;