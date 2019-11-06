IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Procedures using dynamic SQL without sp_executesql]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Procedures using dynamic SQL without sp_executesql]
GO

CREATE PROCEDURE [SQLCop].[test Procedures using dynamic SQL without sp_executesql]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012

	SET NOCOUNT ON

	Declare @Output VarChar(max)
	Set @Output = ''

	SELECT	@Output = @Output + SCHEMA_NAME(so.uid) + '.' + so.name + Char(13) + Char(10)
	From	sys.sql_modules sm
			Inner Join sys.sysobjects so
				On  sm.object_id = so.id
				And so.type = 'P'
	Where	so.uid <> Schema_Id('tSQLt')
			And so.uid <> Schema_Id('SQLCop')
			And Replace(sm.definition, ' ', '') COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI Like '%Exec(%'
			And Replace(sm.definition, ' ', '') COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI Not Like '%sp_Executesql%'
			And OBJECTPROPERTY(so.id, N'IsMSShipped') = 0
	Order By SCHEMA_NAME(so.uid),so.name

	If @Output > ''
		Begin
			Set @Output = Char(13) + Char(10)
						  + 'For more information:  '
						  + 'https://github.com/red-gate/SQLCop/wiki/Procedures-using-dynamic-SQL-without-sp_executesql'
						  + Char(13) + Char(10)
						  + Char(13) + Char(10)
						  + @Output
			EXEC tSQLt.Fail @Output
		End

END;