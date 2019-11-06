IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Ole Automation Procedures]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Ole Automation Procedures]
GO

CREATE PROCEDURE [SQLCop].[test Ole Automation Procedures]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012

	SET NOCOUNT ON

	Declare @Output VarChar(max)
    Set @Output = ''

    select @Output = @Output + 'Warning: Ole Automation procedures are enabled' + Char(13) + Char(10)
    from   sys.configurations
    where  name = 'Ole Automation Procedures'
           and value_in_use = 1

	If @Output > ''
		Begin
			Set @Output = Char(13) + Char(10)
						  + 'For more information:  '
						  + 'https://github.com/red-gate/SQLCop/wiki/Ole-automation-procedures'
						  + Char(13) + Char(10)
						  + Char(13) + Char(10)
						  + @Output
			EXEC tSQLt.Fail @Output
		End
END;