IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Database and Log files on the same disk]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Database and Log files on the same disk]
GO

CREATE PROCEDURE [SQLCop].[test Database and Log files on the same disk]
AS
BEGIN
    -- Written by George Mastros
    -- February 25, 2012

    SET NOCOUNT ON

    Declare @Output VarChar(max)
    Set @Output = ''

    Select @Output = @Output + db_name() + Char(13) + Char(10)
    FROM   sys.database_files
    Having Count(*) != Count(Distinct Left(Physical_Name, 3))

    If @Output > ''
        Begin
            Set @Output = Char(13) + Char(10)
                          + 'For more information:  '
                          + 'https://github.com/red-gate/SQLCop/wiki/Database-and-log-on-same-disk'
                          + Char(13) + Char(10)
                          + Char(13) + Char(10)
                          + @Output
            EXEC tSQLt.Fail @Output
        End
END;
