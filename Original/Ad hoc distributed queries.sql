IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Ad hoc distributed queries]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Ad hoc distributed queries]
GO

CREATE PROCEDURE [SQLCop].[test Ad hoc distributed queries]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	
	SET NOCOUNT ON
	
	Declare @Output VarChar(max)
	Set @Output = ''

    select	@Output = 'Status: Ad Hoc Distributed Queries are enabled'
    from	sys.configurations
    where	name = 'Ad Hoc Distributed Queries'
			and value_in_use = 1
           
	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'If you use OPENROWSET and OPENDATASOURCE to access data you need to enable Ad Hoc Distributed Queries, by default it is disabled. To enable Ad Hoc Distributed Queries run the following'
						  + CHAR(13) + Char(10) 
						  + 'sp_configure ''Ad Hoc Distributed Queries'', 1;'
						  + CHAR(13) + Char(10) 
						  + 'GO'
						  + CHAR(13) + Char(10) 
						  + 'RECONFIGURE'
						  + CHAR(13) + Char(10) 
						  + 'GO'
						  + CHAR(13) + Char(10) 
						  + 'sp_configure ''Ad Hoc Distributed Queries'', 1;'
						  + CHAR(13) + Char(10) 
						  + 'GO'
						  + CHAR(13) + Char(10) 
						  + 'RECONFIGURE'
						  + CHAR(13) + Char(10) 
						  + 'GO'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End
END;