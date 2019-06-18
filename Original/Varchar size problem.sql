IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Varchar Size Problem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Varchar Size Problem]
GO

CREATE PROCEDURE [SQLCop].[test Varchar Size Problem]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	-- http://blogs.lessthandot.com/index.php/DataMgmt/DBProgramming/MSSQLServer/always-include-size-when-using-varchar-n
	
	SET NOCOUNT ON
	
	Declare @Output VarChar(max)
	Set @Output = ''

	Select	@Output = @Output + ProblemItem + Char(13) + Char(10)
	From	(
			SELECT	DISTINCT su.name + '.' + so.Name As ProblemItem
			From	syscomments sc
					Inner Join sysobjects so
						On  sc.id = so.id
						And so.xtype = 'P'
					INNER JOIN sys.schemas su
						ON so.uid = su.schema_id
			Where	REPLACE(Replace(sc.text, ' ', ''), 'varchar]','varchar') COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI Like '%varchar[^(]%'
					And ObjectProperty(sc.Id, N'IsMSSHIPPED') = 0
					And su.schema_id <> schema_id('tSQLt')
					and su.schema_id <> Schema_id('SQLCop')
			) As Problems
	Order By ProblemItem

	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'http://blogs.lessthandot.com/index.php/DataMgmt/DBProgramming/MSSQLServer/always-include-size-when-using-varchar-n' 
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End
		  
END;