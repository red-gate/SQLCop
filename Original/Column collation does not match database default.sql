IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Column collation does not match database default]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Column collation does not match database default]
GO

CREATE PROCEDURE [SQLCop].[test Column collation does not match database default]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	-- http://blogs.lessthandot.com/index.php/DataMgmt/DBProgramming/sql-server-collation-conflicts
	
	SET NOCOUNT ON
	
	DECLARE @Output VarChar(max)
	SET @Output = ''

	SELECT	@Output = @Output + C.TABLE_SCHEMA + '.' + C.TABLE_NAME + '.' + C.COLUMN_NAME + Char(13) + Char(10)
	FROM	INFORMATION_SCHEMA.COLUMNS C
			INNER JOIN INFORMATION_SCHEMA.TABLES T            
				ON C.Table_Name = T.Table_Name 
	WHERE	T.Table_Type = 'BASE TABLE'          
			AND COLLATION_NAME <> convert(VarChar(100), DATABASEPROPERTYEX(db_name(), 'Collation'))
			AND COLUMNPROPERTY(OBJECT_ID(C.TABLE_NAME), COLUMN_NAME, 'IsComputed') = 0 
			AND C.TABLE_SCHEMA <> 'tSQLt'
	Order By C.TABLE_SCHEMA, C.TABLE_NAME, C.COLUMN_NAME
		
	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'http://blogs.lessthandot.com/index.php/DataMgmt/DBProgramming/sql-server-collation-conflicts' 
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End
  
END;