IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Auto update statistics]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Auto update statistics]
GO

CREATE PROCEDURE [SQLCop].[test Auto update statistics]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	
	SET NOCOUNT ON
	
	Declare @Output VarChar(max)
	Set @Output = ''
	
    Select @Output = @Output + 'Database not set to Auto Update Statistics' + Char(13) + Char(10)
    Where  DatabaseProperty(db_name(), 'IsAutoUpdateStatistics') = 0
    
	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'https://blogs.msdn.microsoft.com/buckwoody/2009/08/18/sql-server-best-practices-auto-create-and-auto-update-statistics-should-be-on-most-of-the-time/'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End
END;