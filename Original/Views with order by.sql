IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Views with order by]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Views with order by]
GO

CREATE PROCEDURE [SQLCop].[test Views with order by]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	
	SET NOCOUNT ON
	
	DECLARE @Output VarChar(max)
	SET @Output = ''

	SELECT	@Output = @Output + sysusers.name + '.' + sysobjects.name + Char(13) + Char(10)
	FROM	sysobjects
			INNER JOIN syscomments
			  ON sysobjects.id = syscomments.id
			INNER JOIN sysusers
			  ON sysobjects.uid = sysusers.uid
	WHERE	xtype = 'V'
			and syscomments.text COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI like '%order by%'
			and sysusers.name <> 'tSQLt'
	ORDER BY sysusers.name,sysobjects.name

	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'This is only a problem on SQL 2005 and SQL 2008 without a hotfix:  '
						  + Char(13) + Char(10) 
						  + 'https://support.microsoft.com/en-us/help/926292/fix-when-you-query-through-a-view-that-uses-the-order-by-clause-in-sql' 
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End	  
END;