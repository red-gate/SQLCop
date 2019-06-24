IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Database Mail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Database Mail]
GO

CREATE PROCEDURE [SQLCop].[test Database Mail]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	
	SET NOCOUNT ON
	
	Declare @Output VarChar(max)
	Set @Output = ''

    select @Output = @Output + 'Status: Database Mail procedures are enabled' + Char(13) + Char(10)
    from   sys.configurations
    where  name = 'Database Mail XPs'
           and value_in_use = 1
                   
	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'https://github.com/red-gate/SQLCop/wiki/Database-mail'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End  
  
END;