IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Agent Service]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Agent Service]
GO

CREATE PROCEDURE [SQLCop].[test Agent Service]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012

	SET NOCOUNT ON

	Declare @Output VarChar(max)
    DECLARE @service NVARCHAR(100)

	Set @Output = ''


    If Convert(VarChar(100), ServerProperty('Edition')) Like 'Express%'
      Select @Output = 'SQL Server Agent not installed for express editions'
    Else If Is_SrvRoleMember('sysadmin') = 0
      Select @Output = 'You need to be a member of the sysadmin server role to run this check'
    Else
      Begin
        SELECT @service = CASE WHEN CHARINDEX('\',@@SERVERNAME)>0
               THEN N'SQLAgent$'+@@SERVICENAME
               ELSE N'SQLSERVERAGENT' END

        Create Table #Temp(Output VarChar(1000))
        Insert Into #Temp
        EXEC master..xp_servicecontrol N'QUERYSTATE', @service

        Select	Top 1 @Output = Output
        From	#Temp
        Where	Output Not Like 'Running%'

        Drop	Table #Temp
      End


	If @Output > ''
		Begin
			Set @Output = Char(13) + Char(10)
						  + 'Could not find running SQL Agent:'
						  + Char(13) + Char(10)
						  + Char(13) + Char(10)
						  + @Output
			EXEC tSQLt.Fail @Output
		End
END;