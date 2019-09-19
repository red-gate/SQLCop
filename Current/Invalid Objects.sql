IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[SQLCop].[test Invalid Objects]')
          AND type IN ( N'P', N'PC' )
)
    DROP PROCEDURE [SQLCop].[test Invalid Objects];
GO

CREATE PROCEDURE [SQLCop].[test Invalid Objects]
AS
BEGIN
    --  Test to identify Invalid Stored Procedures and Views
    --  If any invalid objects are found then fail the test with list of affected objects
    --  If you require a comprehensive list of Invalid Objects you can use the SQL Prompt find invalid objects functionality:
    --  https://documentation.red-gate.com/sp/sql-refactoring/refactoring-an-object-or-batch/finding-invalid-objects

    --  Written by Chris Unwin 17/09/2019

    SET NOCOUNT ON;

    --Assemble
    -- Declare and set output

    DECLARE @Output VARCHAR(MAX);
    SET @Output = '';

    -- Act
    -- Fetch all invalid objects from sys.sql_expression_dpenedencies and write to output

    SELECT @Output
        = @Output + 'Invalid ' + (CASE
                                      WHEN ob.type = 'P' THEN
                                          'stored procedure '
                                      WHEN ob.type = 'V' THEN
                                          'view '
                                      ELSE
                                          'object type ' + ob.type + ' '
                                  END
                                 ) + '[' + SCHEMA_NAME(ob.schema_id) + '].[' + OBJECT_NAME(dep.referencing_id)
          + '] relies on missing object [' + dep.referenced_schema_name + '].[' + dep.referenced_entity_name + ']'
          + CHAR(13) + CHAR(10)
    FROM sys.sql_expression_dependencies dep
        INNER JOIN sys.objects ob
            ON ob.object_id = dep.referencing_id
    WHERE dep.is_ambiguous = 0
          AND OBJECT_ID(dep.referenced_entity_name) IS NULL
          AND dep.referenced_schema_name <> 'tSQLt'
          AND SCHEMA_NAME(ob.schema_id) <> 'tSQLt';

    -- Assert
    -- Check if output is blank and pass, else fail with list of invalid objects

    IF @Output > ''
    BEGIN
        SET @Output = CHAR(13) + CHAR(10) + @Output;
        EXEC tSQLt.Fail @Output;
    END;
END;