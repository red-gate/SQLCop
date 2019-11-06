IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Max degree of parallelism]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Max degree of parallelism]
GO

CREATE PROCEDURE [SQLCop].[test Max degree of parallelism]
AS
BEGIN
    -- Written by George Mastros
    -- February 25, 2012

    SET NOCOUNT ON

    Declare @Output VarChar(max)
    Set @Output = ''

    select @Output = 'Warning: Max degree of parallelism is setup to use all cores'
    from   sys.configurations
    where  name = 'max degree of parallelism'
           and value_in_use = 0

    If @Output > ''
        Begin
            Set @Output = Char(13) + Char(10)
                          + 'For more information:  '
                          + 'https://github.com/red-gate/SQLCop/wiki/Max-degree-of-parallelism'
                          + Char(13) + Char(10)
                          + Char(13) + Char(10)
                          + @Output
            EXEC tSQLt.Fail @Output
        End
END;
