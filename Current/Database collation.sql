IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Database collation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Database collation]
GO

CREATE PROCEDURE [SQLCop].[test Database collation]
AS
BEGIN
    -- Written by George Mastros
    -- February 25, 2012

    SET NOCOUNT ON

    Declare @Output VarChar(max)
    Set @Output = ''

    Select  @Output = @Output + 'Warning: Collation conflict between user database and TempDB' + Char(13) + Char(10)
    Where   DatabasePropertyEx('TempDB', 'Collation') <> DatabasePropertyEx(db_name(), 'Collation')

    If @Output > ''
        Begin
            Set @Output = Char(13) + Char(10)
                          + 'For more information:  '
                          + 'https://github.com/red-gate/SQLCop/wiki/Database-collation'
                          + Char(13) + Char(10)
                          + Char(13) + Char(10)
                          + @Output
            EXEC tSQLt.Fail @Output
        End
END;
