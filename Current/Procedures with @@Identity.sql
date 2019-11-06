IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Procedures with @@Identity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Procedures with @@Identity]
GO

CREATE PROCEDURE [SQLCop].[test Procedures with @@Identity]
AS
BEGIN
    -- Written by George Mastros
    -- February 25, 2012

    SET NOCOUNT ON

    Declare @Output VarChar(max)
    Set @Output = ''

    Select  @Output = @Output + Schema_Name(schema_id) + '.' + name + Char(13) + Char(10)
    From    sys.all_objects
    Where   type = 'P'
            AND name Not In('sp_helpdiagrams','sp_upgraddiagrams','sp_creatediagram','testProcedures with @@Identity')
            And Object_Definition(object_id) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI Like '%@@identity%'
            And is_ms_shipped = 0
            and schema_id <> Schema_id('tSQLt')
            and schema_id <> Schema_id('SQLCop')
    ORDER BY Schema_Name(schema_id), name

    If @Output > ''
        Begin
            Set @Output = Char(13) + Char(10)
                          + 'For more information:  '
                          + 'https://github.com/red-gate/SQLCop/wiki/Procedures-with-@@Identity'
                          + Char(13) + Char(10)
                          + Char(13) + Char(10)
                          + @Output
            EXEC tSQLt.Fail @Output
        End

END;
