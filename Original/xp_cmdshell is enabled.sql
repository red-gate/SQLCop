IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test xp_cmdshell is enabled]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test xp_cmdshell is enabled]
GO

CREATE PROCEDURE [SQLCop].[test xp_cmdshell is enabled]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	
	SET NOCOUNT ON
	
	Declare @Output VarChar(max)
	Set @Output = ''

    select @Output = @Output + 'Warning: xp_cmdshell is enabled' + Char(13) + Char(10)
    from   sys.configurations
    where  name = 'xp_cmdshell'
           and value_in_use = 1
    
	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'If you have xp_cmdshell enabled basically what you have done is giving your user a command prompt'
						  + Char(13) + Char(10) 
						  + ' accessible from within T-SQL.'
						  + Char(13) + Char(10) 
						  + ' The CLR is better for some of these tasks because it is sandboxed by the .NET framework.'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End 
END;