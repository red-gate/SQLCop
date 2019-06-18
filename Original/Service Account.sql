IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Service Account]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Service Account]
GO

CREATE PROCEDURE [SQLCop].[test Service Account]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	
    SET NOCOUNT ON

	Declare @Output VarChar(max)
	Set @Output = ''

    --Declare a variable to hold the value
    DECLARE @ServiceAccount varchar(100)

    --Retrieve the Service account from registry
    EXECUTE master.dbo.xp_instance_regread
            N'HKEY_LOCAL_MACHINE',
            N'SYSTEM\CurrentControlSet\Services\MSSQLSERVER',
            N'ObjectName',
            @ServiceAccount OUTPUT,
            N'no_output'

    --Display the Service Account
    SELECT @Output = 'Service account set to LocalSystem'
    Where  @ServiceAccount = 'LocalSystem'	
    
	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/configure-windows-service-accounts-and-permissions#Default_Accts'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End  
		
END;