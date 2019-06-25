IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Tables without a primary key]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Tables without a primary key]
GO

CREATE PROCEDURE [SQLCop].[test Tables without a primary key]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- Updates contributed by Claude Harvey
	
	SET NOCOUNT ON
	
	DECLARE @Output VarChar(max)
	SET @Output = ''

	SELECT	@Output = @Output + su.name + '.' + AllTables.Name + Char(13) + Char(10)
	FROM	(
			SELECT	Name, id, uid
			From	sysobjects
			WHERE	xtype = 'U'
			) AS AllTables
			INNER JOIN sysusers su
				On AllTables.uid = su.uid
			LEFT JOIN (
				SELECT parent_obj
				From sysobjects
				WHERE  xtype = 'PK'
				) AS PrimaryKeys
				ON AllTables.id = PrimaryKeys.parent_obj
	WHERE	PrimaryKeys.parent_obj Is Null
			AND su.name <> 'tSQLt'
		    AND ISNULL(su.issqlrole, 0) = 0 -- CH: Fix to avoid false positives with roles 
	ORDER BY su.name,AllTables.Name

	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'https://github.com/red-gate/SQLCop/wiki/Tables-without-a-primary-key' 
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End	
END;