IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Column data types (Numeric vs. Int)]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Column data types (Numeric vs. Int)]
GO

CREATE PROCEDURE [SQLCop].[test Column data types (Numeric vs. Int)]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	
	SET NOCOUNT ON
	
	Declare @Output VarChar(max)
	Set @Output = ''

	Select	@Output = @Output + ProblemItem + Char(13) + Char(10)
	From	(
			SELECT	TABLE_SCHEMA + '.' + TABLE_NAME + '.' + COLUMN_NAME As ProblemItem
            FROM	INFORMATION_SCHEMA.COLUMNS C
            WHERE	C.DATA_TYPE IN ('numeric','decimal') 
					AND NUMERIC_SCALE = 0 
					AND NUMERIC_PRECISION <= 18
					AND TABLE_SCHEMA <> 'tSQLt'
			) As Problems
	Order By ProblemItem

	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'https://github.com/red-gate/SQLCop/wiki/Column-data-types-numeric-vs-int' 
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End
	
END;