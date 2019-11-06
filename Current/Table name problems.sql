IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Table name problems]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Table name problems]
GO

CREATE PROCEDURE [SQLCop].[test Table name problems]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012

	SET NOCOUNT ON

	DECLARE @Output VarChar(max)
    DECLARE @AcceptableSymbols VARCHAR(100)

    SET @AcceptableSymbols = '_$'
	SET @Output = ''

	SELECT  @Output = @Output + TABLE_SCHEMA + '.' + TABLE_NAME + Char(13) + Char(10)
    FROM    INFORMATION_SCHEMA.TABLES
    WHERE   TABLE_NAME COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI Like '%[^a-z' + @AcceptableSymbols + ']%'
			AND TABLE_SCHEMA <> 'tSQLt'
	ORDER BY TABLE_SCHEMA,TABLE_NAME

	If @Output > ''
		Begin
			Set @Output = Char(13) + Char(10)
						  + 'For more information:  '
						  + 'https://github.com/red-gate/SQLCop/wiki/Table-name-problems'
						  + Char(13) + Char(10)
						  + Char(13) + Char(10)
						  + @Output
			EXEC tSQLt.Fail @Output
		End
END;