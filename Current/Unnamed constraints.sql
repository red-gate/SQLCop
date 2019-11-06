IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Unnamed Constraints]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Unnamed Constraints]
GO

CREATE PROCEDURE [SQLCop].[test Unnamed Constraints]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012

	SET NOCOUNT ON

	DECLARE @Output VarChar(max)
	SET @Output = ''

	SELECT	@Output = @Output + CONSTRAINT_SCHEMA + '.' + CONSTRAINT_NAME + Char(13) + Char(10)
	From	INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
	Where	CONSTRAINT_NAME collate sql_latin1_general_CP1_CI_AI Like '%[_][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]'
			And TABLE_NAME <> 'sysdiagrams'
			And CONSTRAINT_SCHEMA <> 'tSQLt'
	Order By CONSTRAINT_SCHEMA,CONSTRAINT_NAME

	If @Output > ''
		Begin
			Set @Output = Char(13) + Char(10)
						  + 'For more information:  '
						  + 'https://github.com/red-gate/SQLCop/wiki/Unnamed-constraints'
						  + Char(13) + Char(10)
						  + Char(13) + Char(10)
						  + @Output
			EXEC tSQLt.Fail @Output
		End

END;