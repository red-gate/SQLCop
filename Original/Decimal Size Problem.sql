IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Decimal Size Problem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Decimal Size Problem]
GO

CREATE PROCEDURE [SQLCop].[test Decimal Size Problem]
AS
BEGIN
    -- Written by George Mastros
    -- February 25, 2012
    -- http://sqlcop.lessthandot.com
    -- http://blogs.lessthandot.com/index.php/DataMgmt/DBProgramming/always-include-precision-and-scale-with
    
    SET NOCOUNT ON  

    Declare @Output VarChar(max)
    Set @Output = ''
  
    Select @Output = @Output + Schema_Name(schema_id) + '.' + name + Char(13) + Char(10)
    From	sys.objects
    WHERE	schema_id <> Schema_ID('SQLCop')
            And schema_id <> Schema_Id('tSQLt')
            and (
            REPLACE(REPLACE(Object_Definition(object_id), ' ', ''), 'decimal]','decimal') COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI LIKE '%decimal[^(]%'
            Or REPLACE(REPLACE(Object_Definition(object_id), ' ', ''), 'numeric]','numeric') COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI LIKE '%[^i][^s]numeric[^(]%'
            )
    Order By Schema_Name(schema_id), name  

    If @Output > '' 
        Begin
            Set @Output = Char(13) + Char(10) 
                          + 'For more information:  '
                          + 'http://blogs.lessthandot.com/index.php/DataMgmt/DBProgramming/always-include-precision-and-scale-with'
                          + Char(13) + Char(10) 
                          + Char(13) + Char(10) 
                          + @Output
            EXEC tSQLt.Fail @Output
        End  
END;