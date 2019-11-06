IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Auto create statistics]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Auto create statistics]
GO

CREATE PROCEDURE [SQLCop].[test Auto create statistics]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012

	SET NOCOUNT ON

	Declare @Output VarChar(max)
	Set @Output = ''

    Select @Output = @Output + 'Database not set to Auto Create Statistics' + Char(13) + Char(10)
    Where  DatabaseProperty(db_name(), 'IsAutoCreateStatistics') = 0

	If @Output > ''
		Begin
			Set @Output = Char(13) + Char(10)
						  + 'For more information:  '
						  + 'https://github.com/red-gate/SQLCop/wiki/Auto-create-statistics'
						  + Char(13) + Char(10)
						  + Char(13) + Char(10)
						  + @Output
			EXEC tSQLt.Fail @Output
		End
END;