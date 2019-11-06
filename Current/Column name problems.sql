IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Column Name Problems]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Column Name Problems]
GO

CREATE PROCEDURE [SQLCop].[test Column Name Problems]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012

	SET NOCOUNT ON

	DECLARE @Output VarChar(max)
	SET @Output = ''

	SELECT 	@Output = @Output + TABLE_SCHEMA + '.' + TABLE_NAME + '.' + COLUMN_NAME + Char(13) + Char(10)
	FROM	INFORMATION_SCHEMA.COLUMNS
	WHERE	COLUMN_NAME COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI LIKE '%[^a-z0-9_$]%'
			And TABLE_SCHEMA <> 'tSQLt'
	Order By TABLE_SCHEMA,TABLE_NAME,COLUMN_NAME

	If @Output > ''
		Begin
			Set @Output = Char(13) + Char(10)
						  + 'For more information:  '
						  + 'https://github.com/red-gate/SQLCop/wiki/Column-name-problems'
						  + Char(13) + Char(10)
						  + Char(13) + Char(10)
						  + @Output
			EXEC tSQLt.Fail @Output
		End

END;