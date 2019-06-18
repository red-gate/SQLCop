IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Procedures With SET ROWCOUNT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Procedures With SET ROWCOUNT]
GO

CREATE PROCEDURE [SQLCop].[test Procedures With SET ROWCOUNT]
AS
BEGIN
    -- Written by George Mastros
    -- February 25, 2012
    -- http://sqlcop.lessthandot.com
    -- http://sqltips.wordpress.com/2007/08/19/set-rowcount-will-not-be-supported-in-future-version-of-sql-server/
    
    SET NOCOUNT ON

    Declare @Output VarChar(max)
    Set @Output = ''
  
    SELECT	@Output = @Output + Schema_Name(schema_id) + '.' + name + Char(13) + Char(10)
    From	sys.all_objects
    Where	type = 'P'
            AND name Not In('sp_helpdiagrams','sp_upgraddiagrams','sp_creatediagram','testProcedures With SET ROWCOUNT')
            And Replace(Object_Definition(Object_id), ' ', '') COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI Like '%SETROWCOUNT%'
            And is_ms_shipped = 0
            and schema_id <> Schema_id('tSQLt')
            and schema_id <> Schema_id('SQLCop')			
    ORDER BY Schema_Name(schema_id) + '.' + name

    If @Output > '' 
        Begin
            Set @Output = Char(13) + Char(10) 
                          + 'For more information:  '
                          + 'http://sqltips.wordpress.com/2007/08/19/set-rowcount-will-not-be-supported-in-future-version-of-sql-server/'
                          + Char(13) + Char(10) 
                          + Char(13) + Char(10) 
                          + @Output
            EXEC tSQLt.Fail @Output
        End
END;