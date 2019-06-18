IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Orphaned Users]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Orphaned Users]
GO

CREATE PROCEDURE [SQLCop].[test Orphaned Users]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	
	SET NOCOUNT ON
	
	Declare @Output VarChar(max)
    Set @Output = ''

    Set NOCOUNT ON
	If is_rolemember('db_owner') = 1
		Begin
			Declare @Temp Table(UserName sysname, UserSid VarBinary(85))

			Insert Into @Temp Exec sp_change_users_login 'report'

			Select @Output = @Output + UserName + Char(13) + Char(10)
			From   @Temp
			Order By UserName
		End
	Else
		Set @Output = 'Only members of db_owner can perform this check.'
                   
	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'Most common when performing restores or re-attaching databases, database users become orphaned.'
						  + Char(13) + Char(10) 
						  + 'This simply means the database user is not associated with a sql server login.'
						  + Char(13) + Char(10) 
						  + 'For a script to fix this problem, see:  '
						  + 'https://dba.stackexchange.com/questions/12817/is-there-a-shorthand-way-to-auto-fix-all-orphaned-users-in-an-sql-server-2008'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End  
		  
END;