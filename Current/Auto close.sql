IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Auto close]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Auto close]
GO

CREATE PROCEDURE [SQLCop].[test Auto close]
AS
BEGIN
    -- Written by George Mastros
    -- February 25, 2012

    SET NOCOUNT ON

    Declare @Output VarChar(max)
    Set @Output = ''

    Select @Output = @Output + 'Database set to Auto Close' + Char(13) + Char(10)
    Where   DatabaseProperty(db_name(), 'IsAutoClose') = 1

    If @Output > ''
        Begin
            Set @Output = Char(13) + Char(10)
                          + 'For more information:  '
                          + 'https://github.com/red-gate/SQLCop/wiki/Auto-close'
                          + Char(13) + Char(10)
                          + Char(13) + Char(10)
                          + @Output
            EXEC tSQLt.Fail @Output
        End
END;
