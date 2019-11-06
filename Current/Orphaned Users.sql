IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Orphaned Users]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Orphaned Users]
GO

CREATE PROCEDURE [SQLCop].[test Orphaned Users]
AS
BEGIN
    -- Written by George Mastros
    -- February 25, 2012

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
                          + 'For more information:  '
                          + 'https://github.com/red-gate/SQLCop/wiki/Orphaned-Users'
                          + Char(13) + Char(10)
                          + Char(13) + Char(10)
                          + @Output
            EXEC tSQLt.Fail @Output
        End

END;
