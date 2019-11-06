IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Procedures Named SP_]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Procedures Named SP_]
GO

CREATE PROCEDURE [SQLCop].[test Procedures Named SP_]
AS
BEGIN
    -- Written by George Mastros
    -- February 25, 2012

    SET NOCOUNT ON

    Declare @Output VarChar(max)
    Set @Output = ''

    SELECT	@Output = @Output + SPECIFIC_SCHEMA + '.' + SPECIFIC_NAME + Char(13) + Char(10)
    From	INFORMATION_SCHEMA.ROUTINES
    Where	SPECIFIC_NAME COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI LIKE 'sp[_]%'
            And SPECIFIC_NAME COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI NOT LIKE '%diagram%'
            AND ROUTINE_SCHEMA <> 'tSQLt'
    Order By SPECIFIC_SCHEMA,SPECIFIC_NAME

    If @Output > ''
        Begin
            Set @Output = Char(13) + Char(10)
                          + 'For more information:  '
                          + 'https://github.com/red-gate/SQLCop/wiki/Procedures-named-SP_'
                          + Char(13) + Char(10)
                          + Char(13) + Char(10)
                          + @Output
            EXEC tSQLt.Fail @Output
        End
END;