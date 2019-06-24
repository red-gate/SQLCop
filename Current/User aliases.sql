IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test User Aliases]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test User Aliases]
GO

CREATE PROCEDURE [SQLCop].[test User Aliases]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	
	SET NOCOUNT ON
	
	Declare @Output VarChar(max)
    Set @Output = ''

    Select @Output = @Output + Name + Char(13) + Char(10)
    From   sysusers 
    Where  IsAliased = 1 
    Order By Name
        
	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'https://github.com/red-gate/SQLCop/wiki/User-aliases'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End 
END;